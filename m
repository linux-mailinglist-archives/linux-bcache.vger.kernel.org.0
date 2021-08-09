Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AF23E4077
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 08:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhHIGtB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 02:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhHIGtB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 02:49:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30813C0613CF;
        Sun,  8 Aug 2021 23:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=AZuLPYkl9A2TXa8srNWxLAXsGFr2mUQNc5qPxoXeO+o=; b=p+Kqgs8Q9em5vJFdvVXwzlx4Qu
        Wk301OPqqjb4quMM61zs0a44piuBoqarMJKmJyKrY5e1CUsFMSMMqwfWN0eD0LZ3QNHHwyeo3r461
        3W8UrzS7Evc5AVef/20lL69MRpaodg+KRuq1IJbIoKfQAdr54YOfv10nHtBRX2nBoZFMGvF2jOGv4
        fFS99XeZe2uxrfYucpsf/QVKMCLVY2q6jZSOU1OR+4vyUgEtvjZDprBgbv6z8houTwu9FT8AQXwzR
        WrgXBeR5z2r4Cc00+e5Jyt3trR2wc1NXlw67L/n7Ug/JTjwd1j3rkXuphd422Tui0IqTwBRByVims
        N6pMuQDQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCz4A-00AizF-Lt; Mon, 09 Aug 2021 06:47:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH 7/8] bcache: move the del_gendisk call out of bcache_device_free
Date:   Mon,  9 Aug 2021 08:40:27 +0200
Message-Id: <20210809064028.1198327-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809064028.1198327-1-hch@lst.de>
References: <20210809064028.1198327-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Let the callers call del_gendisk so that we can check if add_disk
has been called properly for the cached device case instead of relying
on the block layer internal GENHD_FL_UP flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d0f08e946453..f2874c77ff79 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -885,11 +885,6 @@ static void bcache_device_free(struct bcache_device *d)
 		bcache_device_detach(d);
 
 	if (disk) {
-		bool disk_added = (disk->flags & GENHD_FL_UP) != 0;
-
-		if (disk_added)
-			del_gendisk(disk);
-
 		blk_cleanup_disk(disk);
 		ida_simple_remove(&bcache_device_idx,
 				  first_minor_to_idx(disk->first_minor));
@@ -1371,8 +1366,10 @@ static void cached_dev_free(struct closure *cl)
 
 	mutex_lock(&bch_register_lock);
 
-	if (atomic_read(&dc->running))
+	if (atomic_read(&dc->running)) {
 		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
+		del_gendisk(dc->disk.disk);
+	}
 	bcache_device_free(&dc->disk);
 	list_del(&dc->list);
 
@@ -1518,6 +1515,7 @@ static void flash_dev_free(struct closure *cl)
 	mutex_lock(&bch_register_lock);
 	atomic_long_sub(bcache_dev_sectors_dirty(d),
 			&d->c->flash_dev_dirty_sectors);
+	del_gendisk(d->disk);
 	bcache_device_free(d);
 	mutex_unlock(&bch_register_lock);
 	kobject_put(&d->kobj);
-- 
2.30.2


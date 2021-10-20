Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F04434E01
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhJTOkr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:40:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55090 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJTOkr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:40:47 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1042E1F770;
        Wed, 20 Oct 2021 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZoULiby4wcCx4YY6X0C1WnY0sz/2FNDxpZm7SI668U=;
        b=RvCvZHPn6uRvS8WUBUM9b4ymqlvcIYMe7DHr0+CccVJLydcbZ7GsM7oIXNEt/cgXqpUytO
        6jvX95DwAdAwfkMDnv6t/+31jJh6wFpeYNR4/T5bT7vIGLcth7HWSk5UrAxC4a9PEnr5OJ
        G4POieZ2GyrHdTSK5XUOzRi1A5NCHBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZoULiby4wcCx4YY6X0C1WnY0sz/2FNDxpZm7SI668U=;
        b=uf6XLmdC8dQDSc0aXk8BeV0OZ2HUKPXlapjvnwCWdI5nINvnHOBPfDa+HVpV8ZpHGQyZya
        6xC7lYTyszSTQzDw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id E17E0A3B83;
        Wed, 20 Oct 2021 14:38:29 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Lin Feng <linf@wangsu.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 4/8] bcache: move calc_cached_dev_sectors to proper place on backing device detach
Date:   Wed, 20 Oct 2021 22:38:08 +0800
Message-Id: <20211020143812.6403-5-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020143812.6403-1-colyli@suse.de>
References: <20211020143812.6403-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Lin Feng <linf@wangsu.com>

Calculation of cache_set's cached sectors is done by travelling
cached_devs list as shown below:

static void calc_cached_dev_sectors(struct cache_set *c)
{
...
        list_for_each_entry(dc, &c->cached_devs, list)
                sectors += bdev_sectors(dc->bdev);

        c->cached_dev_sectors = sectors;
}

But cached_dev won't be unlinked from c->cached_devs list until we call
following list_move(&dc->list, &uncached_devices),
so previous fix in 'commit 46010141da6677b81cc77f9b47f8ac62bd1cbfd3
("bcache: recal cached_dev_sectors on detach")' is wrong, now we move
it to its right place.

Signed-off-by: Lin Feng <linf@wangsu.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 6bc5ee42a059..05877177b768 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1153,9 +1153,9 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	mutex_lock(&bch_register_lock);
 
-	calc_cached_dev_sectors(dc->disk.c);
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
+	calc_cached_dev_sectors(dc->disk.c);
 
 	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
 	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);
-- 
2.31.1


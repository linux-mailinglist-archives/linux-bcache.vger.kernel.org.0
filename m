Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0812642FEBC
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Oct 2021 01:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243569AbhJOXdG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 19:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243538AbhJOXdD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 19:33:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D18C061762;
        Fri, 15 Oct 2021 16:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=U16tRkYxOu2xTupE2mvnO7g0MO56Pwj7My6exHcD7bk=; b=SMPXMOkYs49b2c68ayB39v03zE
        1JbaklyNPDkaFFKPIXJZSSf9JcNnGytHsTLxnHHQA91QOrgnaKH/dLotpGBtyzbNzYxWMbm6l5XQK
        +VrXpCqV6xYKGZthiSp/C2mY62tj1C8bC4VDaVWWAqDgxXXxLsfk3NO3Y3R/Ly8UnemuQck06fwiw
        k+nhdx+1yKj/AmmFUFCI4buRGvoBC+xntL9ylynuTURoS86DXIkYd1Ev5Vq6pSXk2TDGlcg1vt8CR
        wRa1vy5MYVu0t5ZCYrJOvV4bPw2j3MZaKqQJzqy/uCT64e5hx776C5FvqrkL4WyO4f7ES6KOhW78j
        nMYiK8XA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbWej-0095v1-AI; Fri, 15 Oct 2021 23:30:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
        kent.overstreet@gmail.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, roger.pau@citrix.com,
        geert@linux-m68k.org, ulf.hansson@linaro.org, tj@kernel.org,
        hare@suse.de, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes.berg@intel.com,
        krisman@collabora.com, chris.obbard@collabora.com,
        thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5/9] xen-blkfront: add error handling support for add_disk()
Date:   Fri, 15 Oct 2021 16:30:24 -0700
Message-Id: <20211015233028.2167651-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We never checked for errors on device_add_disk() as this function
returned void. Now that this is fixed, use the shiny new error
handling. The function xlvbd_alloc_gendisk() typically does the
unwinding on error on allocating the disk and creating the tag,
but since all that error handling was stuffed inside
xlvbd_alloc_gendisk() we must repeat the tag free'ing as well.

We set the info->rq to NULL to ensure blkif_free() doesn't crash
on blk_mq_stop_hw_queues() on device_add_disk() error as the queue
will be long gone by then.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/xen-blkfront.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index df0deb927760..8e3983e456f3 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2386,7 +2386,13 @@ static void blkfront_connect(struct blkfront_info *info)
 	for_each_rinfo(info, rinfo, i)
 		kick_pending_request_queues(rinfo);
 
-	device_add_disk(&info->xbdev->dev, info->gd, NULL);
+	err = device_add_disk(&info->xbdev->dev, info->gd, NULL);
+	if (err) {
+		blk_cleanup_disk(info->gd);
+		blk_mq_free_tag_set(&info->tag_set);
+		info->rq = NULL;
+		goto fail;
+	}
 
 	info->is_ready = 1;
 	return;
-- 
2.30.2


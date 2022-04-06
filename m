Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBB54F59F0
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Apr 2022 11:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348895AbiDFJa5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Apr 2022 05:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579549AbiDFJUa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Apr 2022 05:20:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8747B493CEC;
        Tue,  5 Apr 2022 23:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=oBOOfc3iQHyh4s/28CPoA+VriGqSgcKurZz21BM76xw=; b=pJCGiZx3jyaVpZeZ0r9wUwDapM
        vnq8sVI2OmDjjjAlFeiXpQpXHd3qLUTQmrO2SbOe0V6Khalibg7qRuv2CX/PmXjL37DUcmx7RyXUD
        uqV0VALE0g88DIoHQ8FOht85xvAYgQtSSQkYwAbHZrJs1DJK9oJoVWzqXmfVBMdHkAXiYPHbSqsOm
        JRH353S+zCB5cxULSv0TJdyD4SZcedhDbR4o7iLNacPeClM4cp0ji0qL5BFynmSG+uTd35rxhyItY
        UxPsxFWrFNYMOUR5XuvZyJCMiOjiUFIHRMbQ3DBI8Pg1KPplQ7VNfvN9RWt3m4kjFOi/RjGHDlxuI
        e40KmP4g==;
Received: from 213-225-3-188.nat.highway.a1.net ([213.225.3.188] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbyuA-003zHx-LZ; Wed, 06 Apr 2022 06:12:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs: simplify ->flush_bio handling
Date:   Wed,  6 Apr 2022 08:12:24 +0200
Message-Id: <20220406061228.410163-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061228.410163-1-hch@lst.de>
References: <20220406061228.410163-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use and embedded bios that is initialized when used instead of
bio_kmalloc plus bio_reset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c |  8 +++++---
 fs/btrfs/volumes.c | 11 -----------
 fs/btrfs/volumes.h |  4 ++--
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b30309f187cf0..51f4cdf6bcaea 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4225,6 +4225,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
  */
 static void btrfs_end_empty_barrier(struct bio *bio)
 {
+	bio_uninit(bio);
 	complete(bio->bi_private);
 }
 
@@ -4234,7 +4235,7 @@ static void btrfs_end_empty_barrier(struct bio *bio)
  */
 static void write_dev_flush(struct btrfs_device *device)
 {
-	struct bio *bio = device->flush_bio;
+	struct bio *bio = &device->flush_bio;
 
 #ifndef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	/*
@@ -4252,7 +4253,8 @@ static void write_dev_flush(struct btrfs_device *device)
 		return;
 #endif
 
-	bio_reset(bio, device->bdev, REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH);
+	bio_init(bio, device->bdev, NULL, 0,
+		 REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH);
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
@@ -4266,7 +4268,7 @@ static void write_dev_flush(struct btrfs_device *device)
  */
 static blk_status_t wait_dev_flush(struct btrfs_device *device)
 {
-	struct bio *bio = device->flush_bio;
+	struct bio *bio = &device->flush_bio;
 
 	if (!test_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state))
 		return BLK_STS_OK;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1be7cb2f955fc..00517239b5c01 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -405,7 +405,6 @@ void btrfs_free_device(struct btrfs_device *device)
 	WARN_ON(!list_empty(&device->post_commit_list));
 	rcu_string_free(device->name);
 	extent_io_tree_release(&device->alloc_state);
-	bio_put(device->flush_bio);
 	btrfs_destroy_dev_zone_info(device);
 	kfree(device);
 }
@@ -6956,16 +6955,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	/*
-	 * Preallocate a bio that's always going to be used for flushing device
-	 * barriers and matches the device lifespan
-	 */
-	dev->flush_bio = bio_kmalloc(GFP_KERNEL, 0);
-	if (!dev->flush_bio) {
-		kfree(dev);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_alloc_list);
 	INIT_LIST_HEAD(&dev->post_commit_list);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index bd297f23d19e7..628c9af894749 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -121,8 +121,8 @@ struct btrfs_device {
 	/* bytes used on the current transaction */
 	u64 commit_bytes_used;
 
-	/* for sending down flush barriers */
-	struct bio *flush_bio;
+	/* Bio used for flushing device barriers */
+	struct bio flush_bio;
 	struct completion flush_wait;
 
 	/* per-device scrub information */
-- 
2.30.2


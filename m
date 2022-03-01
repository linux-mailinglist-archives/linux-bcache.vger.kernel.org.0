Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67974C86DE
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 09:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiCAIqu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Mar 2022 03:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiCAIqt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 03:46:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01FE88B10;
        Tue,  1 Mar 2022 00:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=RdSo7ItxpzbwhubLvjEO19q+rtasrdyXQ30J4z5AuZo=; b=hTajS4P+8SLazL66Mp984x7zSc
        ulYJ41+w3C4E8L9bcduoQ34jKzixRDzB+fAt/3T/V1zA6Sf7m0/jZLi5Y1SSTGcOhO3FwxHFTT9ju
        ihGtunxirtm6jy8gAFZwrlq4u7pBwvfJyKgkFKwzzSBSstThO9jeNMR+rMNiM5CSZopEX03lSaY94
        fE/DRQoWHcmke7oceXQ0xmHcWMj2JTxRpaFkMZ/ST49jrV6kqaXuHEsqCpEjaemlFDtbXjJ96Bi8x
        WYv4Ig0tTHig/xHz0w4NqNEyiYfAUgbE9VPPNJtT7KTfgLuFVU6NwztM8g0UtN7rz3g0dmaVoQmUJ
        qf3uJrXg==;
Received: from [2.53.44.23] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOy8t-00FfP8-60; Tue, 01 Mar 2022 08:45:59 +0000
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
Date:   Tue,  1 Mar 2022 10:45:48 +0200
Message-Id: <20220301084552.880256-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301084552.880256-1-hch@lst.de>
References: <20220301084552.880256-1-hch@lst.de>
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
---
 fs/btrfs/disk-io.c |  8 +++++---
 fs/btrfs/volumes.c | 11 -----------
 fs/btrfs/volumes.h |  2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 505ba21230b1f..7d4229c769ac6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4127,6 +4127,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
  */
 static void btrfs_end_empty_barrier(struct bio *bio)
 {
+	bio_uninit(bio);
 	complete(bio->bi_private);
 }
 
@@ -4136,7 +4137,7 @@ static void btrfs_end_empty_barrier(struct bio *bio)
  */
 static void write_dev_flush(struct btrfs_device *device)
 {
-	struct bio *bio = device->flush_bio;
+	struct bio *bio = &device->flush_bio;
 
 #ifndef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 	/*
@@ -4154,7 +4155,8 @@ static void write_dev_flush(struct btrfs_device *device)
 		return;
 #endif
 
-	bio_reset(bio, device->bdev, REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH);
+	bio_init(bio, device->bdev, NULL, 0,
+		 REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH);
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
@@ -4168,7 +4170,7 @@ static void write_dev_flush(struct btrfs_device *device)
  */
 static blk_status_t wait_dev_flush(struct btrfs_device *device)
 {
-	struct bio *bio = device->flush_bio;
+	struct bio *bio = &device->flush_bio;
 
 	if (!test_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state))
 		return BLK_STS_OK;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b07d382d53a86..7015b3096f724 100644
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
@@ -6962,16 +6961,6 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
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
index 005c9e2a491a1..9af7b6211920c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -117,7 +117,7 @@ struct btrfs_device {
 	u64 commit_bytes_used;
 
 	/* for sending down flush barriers */
-	struct bio *flush_bio;
+	struct bio flush_bio;
 	struct completion flush_wait;
 
 	/* per-device scrub information */
-- 
2.30.2


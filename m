Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A083434E05
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhJTOkw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:40:52 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37070 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJTOkw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:40:52 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2BAC421981;
        Wed, 20 Oct 2021 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2q/wKZpzoc4RX+QfZYCHm1EmJEbxolhOjgTk3VNBc2Y=;
        b=1Tem8CMbDOoN6hkMCGSnS/K5eLtl0mcSLVHNIkbJNcIEbfYjOh3MlwnY2lmlaU6gP4h81J
        HgaGW49mjFHgsbvleHEd9jFFCbf4NnkWqGFJDghvVhtv+NtXXjmoKANqloMk40whRCzv+i
        IGXjOdFdHn1XYPbn/12pC9Klw78j+tI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2q/wKZpzoc4RX+QfZYCHm1EmJEbxolhOjgTk3VNBc2Y=;
        b=ptGNfL4r9rNaoFuoX/xdujLryVWzriPWr/EtNpUmOwWdw2RTws45mYKfdhmoCfTLf+Snmx
        lCvJxmWPx0pTuEDQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id CE975A3B81;
        Wed, 20 Oct 2021 14:38:34 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 6/8] bcache: remove the backing_dev_name field from struct cached_dev
Date:   Wed, 20 Oct 2021 22:38:10 +0800
Message-Id: <20211020143812.6403-7-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020143812.6403-1-colyli@suse.de>
References: <20211020143812.6403-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Just use the %pg format specifier to print the name directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h  |  2 --
 drivers/md/bcache/debug.c   |  4 ++--
 drivers/md/bcache/io.c      |  8 +++----
 drivers/md/bcache/request.c |  4 ++--
 drivers/md/bcache/super.c   | 48 ++++++++++++++++---------------------
 drivers/md/bcache/sysfs.c   |  2 +-
 6 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 47ff9ecea2e2..941685409c68 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -395,8 +395,6 @@ struct cached_dev {
 	atomic_t		io_errors;
 	unsigned int		error_limit;
 	unsigned int		offline_seconds;
-
-	char			backing_dev_name[BDEVNAME_SIZE];
 };
 
 enum alloc_reserve {
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 116edda845c3..e803cad864be 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -137,8 +137,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 					p2 + bv.bv_offset,
 					bv.bv_len),
 				 dc->disk.c,
-				 "verify failed at dev %s sector %llu",
-				 dc->backing_dev_name,
+				 "verify failed at dev %pg sector %llu",
+				 dc->bdev,
 				 (uint64_t) bio->bi_iter.bi_sector);
 
 		kunmap_atomic(p1);
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 564357de7640..9c6f9ec55b72 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -65,15 +65,15 @@ void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio)
 	 * we shouldn't count failed REQ_RAHEAD bio to dc->io_errors.
 	 */
 	if (bio->bi_opf & REQ_RAHEAD) {
-		pr_warn_ratelimited("%s: Read-ahead I/O failed on backing device, ignore\n",
-				    dc->backing_dev_name);
+		pr_warn_ratelimited("%pg: Read-ahead I/O failed on backing device, ignore\n",
+				    dc->bdev);
 		return;
 	}
 
 	errors = atomic_add_return(1, &dc->io_errors);
 	if (errors < dc->error_limit)
-		pr_err("%s: IO error on backing device, unrecoverable\n",
-			dc->backing_dev_name);
+		pr_err("%pg: IO error on backing device, unrecoverable\n",
+			dc->bdev);
 	else
 		bch_cached_dev_error(dc);
 }
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6d1de889baeb..64ce5788f80c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -651,8 +651,8 @@ static void backing_request_endio(struct bio *bio)
 		 */
 		if (unlikely(s->iop.writeback &&
 			     bio->bi_opf & REQ_PREFLUSH)) {
-			pr_err("Can't flush %s: returned bi_status %i\n",
-				dc->backing_dev_name, bio->bi_status);
+			pr_err("Can't flush %pg: returned bi_status %i\n",
+				dc->bdev, bio->bi_status);
 		} else {
 			/* set to orig_bio->bi_status in bio_complete() */
 			s->iop.status = bio->bi_status;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 01e6b0bce9c0..ca557204b6c6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1025,8 +1025,8 @@ static int cached_dev_status_update(void *arg)
 			dc->offline_seconds = 0;
 
 		if (dc->offline_seconds >= BACKING_DEV_OFFLINE_TIMEOUT) {
-			pr_err("%s: device offline for %d seconds\n",
-			       dc->backing_dev_name,
+			pr_err("%pg: device offline for %d seconds\n",
+			       dc->bdev,
 			       BACKING_DEV_OFFLINE_TIMEOUT);
 			pr_err("%s: disable I/O request due to backing device offline\n",
 			       dc->disk.name);
@@ -1057,15 +1057,13 @@ int bch_cached_dev_run(struct cached_dev *dc)
 	};
 
 	if (dc->io_disable) {
-		pr_err("I/O disabled on cached dev %s\n",
-		       dc->backing_dev_name);
+		pr_err("I/O disabled on cached dev %pg\n", dc->bdev);
 		ret = -EIO;
 		goto out;
 	}
 
 	if (atomic_xchg(&dc->running, 1)) {
-		pr_info("cached dev %s is running already\n",
-		       dc->backing_dev_name);
+		pr_info("cached dev %pg is running already\n", dc->bdev);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1162,7 +1160,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	mutex_unlock(&bch_register_lock);
 
-	pr_info("Caching disabled for %s\n", dc->backing_dev_name);
+	pr_info("Caching disabled for %pg\n", dc->bdev);
 
 	/* Drop ref we took in cached_dev_detach() */
 	closure_put(&dc->disk.cl);
@@ -1202,29 +1200,27 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		return -ENOENT;
 
 	if (dc->disk.c) {
-		pr_err("Can't attach %s: already attached\n",
-		       dc->backing_dev_name);
+		pr_err("Can't attach %pg: already attached\n", dc->bdev);
 		return -EINVAL;
 	}
 
 	if (test_bit(CACHE_SET_STOPPING, &c->flags)) {
-		pr_err("Can't attach %s: shutting down\n",
-		       dc->backing_dev_name);
+		pr_err("Can't attach %pg: shutting down\n", dc->bdev);
 		return -EINVAL;
 	}
 
 	if (dc->sb.block_size < c->cache->sb.block_size) {
 		/* Will die */
-		pr_err("Couldn't attach %s: block size less than set's block size\n",
-		       dc->backing_dev_name);
+		pr_err("Couldn't attach %pg: block size less than set's block size\n",
+		       dc->bdev);
 		return -EINVAL;
 	}
 
 	/* Check whether already attached */
 	list_for_each_entry_safe(exist_dc, t, &c->cached_devs, list) {
 		if (!memcmp(dc->sb.uuid, exist_dc->sb.uuid, 16)) {
-			pr_err("Tried to attach %s but duplicate UUID already attached\n",
-				dc->backing_dev_name);
+			pr_err("Tried to attach %pg but duplicate UUID already attached\n",
+				dc->bdev);
 
 			return -EINVAL;
 		}
@@ -1242,15 +1238,13 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 
 	if (!u) {
 		if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-			pr_err("Couldn't find uuid for %s in set\n",
-			       dc->backing_dev_name);
+			pr_err("Couldn't find uuid for %pg in set\n", dc->bdev);
 			return -ENOENT;
 		}
 
 		u = uuid_find_empty(c);
 		if (!u) {
-			pr_err("Not caching %s, no room for UUID\n",
-			       dc->backing_dev_name);
+			pr_err("Not caching %pg, no room for UUID\n", dc->bdev);
 			return -EINVAL;
 		}
 	}
@@ -1318,8 +1312,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		 */
 		kthread_stop(dc->writeback_thread);
 		cancel_writeback_rate_update_dwork(dc);
-		pr_err("Couldn't run cached device %s\n",
-		       dc->backing_dev_name);
+		pr_err("Couldn't run cached device %pg\n", dc->bdev);
 		return ret;
 	}
 
@@ -1335,8 +1328,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	/* Allow the writeback thread to proceed */
 	up_write(&dc->writeback_lock);
 
-	pr_info("Caching %s as %s on set %pU\n",
-		dc->backing_dev_name,
+	pr_info("Caching %pg as %s on set %pU\n",
+		dc->bdev,
 		dc->disk.disk->disk_name,
 		dc->disk.c->set_uuid);
 	return 0;
@@ -1458,7 +1451,6 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	struct cache_set *c;
 	int ret = -ENOMEM;
 
-	bdevname(bdev, dc->backing_dev_name);
 	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
 	dc->bdev = bdev;
 	dc->bdev->bd_holder = dc;
@@ -1473,7 +1465,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	if (bch_cache_accounting_add_kobjs(&dc->accounting, &dc->disk.kobj))
 		goto err;
 
-	pr_info("registered backing device %s\n", dc->backing_dev_name);
+	pr_info("registered backing device %pg\n", dc->bdev);
 
 	list_add(&dc->list, &uncached_devices);
 	/* attach to a matched cache set if it exists */
@@ -1490,7 +1482,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	return 0;
 err:
-	pr_notice("error %s: %s\n", dc->backing_dev_name, err);
+	pr_notice("error %pg: %s\n", dc->bdev, err);
 	bcache_device_stop(&dc->disk);
 	return ret;
 }
@@ -1617,8 +1609,8 @@ bool bch_cached_dev_error(struct cached_dev *dc)
 	/* make others know io_disable is true earlier */
 	smp_mb();
 
-	pr_err("stop %s: too many IO errors on backing device %s\n",
-	       dc->disk.disk->disk_name, dc->backing_dev_name);
+	pr_err("stop %s: too many IO errors on backing device %pg\n",
+	       dc->disk.disk->disk_name, dc->bdev);
 
 	bcache_device_stop(&dc->disk);
 	return true;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 05ac1d6fbbf3..1f0dce30fa75 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -271,7 +271,7 @@ SHOW(__bch_cached_dev)
 	}
 
 	if (attr == &sysfs_backing_dev_name) {
-		snprintf(buf, BDEVNAME_SIZE + 1, "%s", dc->backing_dev_name);
+		snprintf(buf, BDEVNAME_SIZE + 1, "%pg", dc->bdev);
 		strcat(buf, "\n");
 		return strlen(buf);
 	}
-- 
2.31.1


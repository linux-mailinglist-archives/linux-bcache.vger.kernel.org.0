Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672A9431031
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 08:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhJRGL5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 02:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhJRGL4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 02:11:56 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40654C06161C
        for <linux-bcache@vger.kernel.org>; Sun, 17 Oct 2021 23:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bCHplYY17yBEzQdKxn5cmCcKSBVrzAy7DxPU3KG5f64=; b=apQe1H6NzNupTdyd9Z1nUj0ZO2
        79PIn2DHveIzbD2wxz+ReMCst3UV55znKQYFsqzcGtimerzC4rRxBgrIJ6xo7Pem0kRo3r7neSrNI
        7pVFJfi1Sar7eWTHCUd9xzf6FpMs8uQUl6S+srlp4N89PoZAHKnJcqwhvhl4LThSfqP7mtobmBS1f
        fcrVmA2rBrOlSMP5mFhYzJj3DP5JMmYK6ISettvQM5D3abx8hfL9yQcvdA47Ckps6lVu/JlmQOi+H
        utsK7nCPylLoIAbPd+5B3Xx108r7KvrQ2cJhyWtSlCDdukn8yEb2siGZc15gJXTgnMM6/scVLOWU3
        WGJhTd8Q==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcLqD-00EHjT-CV; Mon, 18 Oct 2021 06:09:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: [PATCH 2/4]  bcache: remove the backing_dev_name field from struct cached_dev
Date:   Mon, 18 Oct 2021 08:09:32 +0200
Message-Id: <20211018060934.1816088-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018060934.1816088-1-hch@lst.de>
References: <20211018060934.1816088-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Just use the %pg format specifier to print the name directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/bcache.h  |  2 --
 drivers/md/bcache/debug.c   |  4 ++--
 drivers/md/bcache/io.c      |  8 +++----
 drivers/md/bcache/request.c |  4 ++--
 drivers/md/bcache/super.c   | 48 ++++++++++++++++---------------------
 drivers/md/bcache/sysfs.c   |  2 +-
 6 files changed, 29 insertions(+), 39 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 47ff9ecea2e29..941685409c68f 100644
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
index 116edda845c37..e803cad864be7 100644
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
index 564357de76404..9c6f9ec55b724 100644
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
index 6d1de889baeb1..64ce5788f80cb 100644
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
index d0d0257252adc..bf9dfdde1f033 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1026,8 +1026,8 @@ static int cached_dev_status_update(void *arg)
 			dc->offline_seconds = 0;
 
 		if (dc->offline_seconds >= BACKING_DEV_OFFLINE_TIMEOUT) {
-			pr_err("%s: device offline for %d seconds\n",
-			       dc->backing_dev_name,
+			pr_err("%pg: device offline for %d seconds\n",
+			       dc->bdev,
 			       BACKING_DEV_OFFLINE_TIMEOUT);
 			pr_err("%s: disable I/O request due to backing device offline\n",
 			       dc->disk.name);
@@ -1058,15 +1058,13 @@ int bch_cached_dev_run(struct cached_dev *dc)
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
@@ -1163,7 +1161,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	mutex_unlock(&bch_register_lock);
 
-	pr_info("Caching disabled for %s\n", dc->backing_dev_name);
+	pr_info("Caching disabled for %pg\n", dc->bdev);
 
 	/* Drop ref we took in cached_dev_detach() */
 	closure_put(&dc->disk.cl);
@@ -1203,29 +1201,27 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
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
@@ -1243,15 +1239,13 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 
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
@@ -1319,8 +1313,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 		 */
 		kthread_stop(dc->writeback_thread);
 		cancel_writeback_rate_update_dwork(dc);
-		pr_err("Couldn't run cached device %s\n",
-		       dc->backing_dev_name);
+		pr_err("Couldn't run cached device %pg\n", dc->bdev);
 		return ret;
 	}
 
@@ -1336,8 +1329,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	/* Allow the writeback thread to proceed */
 	up_write(&dc->writeback_lock);
 
-	pr_info("Caching %s as %s on set %pU\n",
-		dc->backing_dev_name,
+	pr_info("Caching %pg as %s on set %pU\n",
+		dc->bdev,
 		dc->disk.disk->disk_name,
 		dc->disk.c->set_uuid);
 	return 0;
@@ -1461,7 +1454,6 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	struct cache_set *c;
 	int ret = -ENOMEM;
 
-	bdevname(bdev, dc->backing_dev_name);
 	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
 	dc->bdev = bdev;
 	dc->bdev->bd_holder = dc;
@@ -1476,7 +1468,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	if (bch_cache_accounting_add_kobjs(&dc->accounting, &dc->disk.kobj))
 		goto err;
 
-	pr_info("registered backing device %s\n", dc->backing_dev_name);
+	pr_info("registered backing device %pg\n", dc->bdev);
 
 	list_add(&dc->list, &uncached_devices);
 	/* attach to a matched cache set if it exists */
@@ -1493,7 +1485,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	return 0;
 err:
-	pr_notice("error %s: %s\n", dc->backing_dev_name, err);
+	pr_notice("error %pg: %s\n", dc->bdev, err);
 	bcache_device_stop(&dc->disk);
 	return ret;
 }
@@ -1621,8 +1613,8 @@ bool bch_cached_dev_error(struct cached_dev *dc)
 	/* make others know io_disable is true earlier */
 	smp_mb();
 
-	pr_err("stop %s: too many IO errors on backing device %s\n",
-	       dc->disk.disk->disk_name, dc->backing_dev_name);
+	pr_err("stop %s: too many IO errors on backing device %pg\n",
+	       dc->disk.disk->disk_name, dc->bdev);
 
 	bcache_device_stop(&dc->disk);
 	return true;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 05ac1d6fbbf35..1f0dce30fa759 100644
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
2.30.2


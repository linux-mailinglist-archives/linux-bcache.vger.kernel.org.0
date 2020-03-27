Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649D01952FE
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 09:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgC0Ieo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 04:34:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:58240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0Ien (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 04:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=j//tFwu18tUU2jBjUze8mSa6QCotrXHguv7qwxWZoU4=; b=QAloNSj2VqF+kPY+xdEosHROAq
        wW8EyeRY/LtRUGd795Ke3rUUAS6SopbyzAJUyU1pHcE2S+3xG8W+iEOxf9XNiGOCScbenf1Vw+tuV
        GuKiir6qwsPXyM9+OKuJ5EG9BcrbsMYeIVE1RRW+CIrE8bKFr+3luDG7x8+ecfUNP2GeTvk3tEzdu
        meb+FBOT48N1O1hK38V8dpx7yi4tx/fvlgomHrAPK69KkoSSqb9hOo5BklCponUw67PU1hRmqbWPZ
        P6UzMOl/q2O3b5C0go+jUJ+SvhXKQS+28K7rC3V27snExs77YLwusKB12OnEAqoT7WSk7IDizyhOq
        6Er10I0g==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHkRv-0007sN-BY; Fri, 27 Mar 2020 08:34:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 3/5] bcache: pass the make_request methods to blk_queue_make_request
Date:   Fri, 27 Mar 2020 09:30:10 +0100
Message-Id: <20200327083012.1618778-4-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200327083012.1618778-1-hch@lst.de>
References: <20200327083012.1618778-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bcache is the only driver not actually passing its make_request
methods to blk_queue_make_request, but instead just sets them up
manually a little later.  Make bcache follow the common way of
setting up make_request based queues.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c |  7 ++-----
 drivers/md/bcache/request.h |  3 +++
 drivers/md/bcache/super.c   | 10 ++++++----
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 820d8402a1dc..71a90fbec314 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1161,8 +1161,7 @@ static void quit_max_writeback_rate(struct cache_set *c,
 
 /* Cached devices - read & write stuff */
 
-static blk_qc_t cached_dev_make_request(struct request_queue *q,
-					struct bio *bio)
+blk_qc_t cached_dev_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct search *s;
 	struct bcache_device *d = bio->bi_disk->private_data;
@@ -1266,7 +1265,6 @@ void bch_cached_dev_request_init(struct cached_dev *dc)
 {
 	struct gendisk *g = dc->disk.disk;
 
-	g->queue->make_request_fn		= cached_dev_make_request;
 	g->queue->backing_dev_info->congested_fn = cached_dev_congested;
 	dc->disk.cache_miss			= cached_dev_cache_miss;
 	dc->disk.ioctl				= cached_dev_ioctl;
@@ -1301,8 +1299,7 @@ static void flash_dev_nodata(struct closure *cl)
 	continue_at(cl, search_free, NULL);
 }
 
-static blk_qc_t flash_dev_make_request(struct request_queue *q,
-					     struct bio *bio)
+blk_qc_t flash_dev_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct search *s;
 	struct closure *cl;
diff --git a/drivers/md/bcache/request.h b/drivers/md/bcache/request.h
index c64dbd7a91aa..bb005c93dd72 100644
--- a/drivers/md/bcache/request.h
+++ b/drivers/md/bcache/request.h
@@ -37,7 +37,10 @@ unsigned int bch_get_congested(const struct cache_set *c);
 void bch_data_insert(struct closure *cl);
 
 void bch_cached_dev_request_init(struct cached_dev *dc);
+blk_qc_t cached_dev_make_request(struct request_queue *q, struct bio *bio);
+
 void bch_flash_dev_request_init(struct bcache_device *d);
+blk_qc_t flash_dev_make_request(struct request_queue *q, struct bio *bio);
 
 extern struct kmem_cache *bch_search_cache;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0c3c5419c52b..5e38a167c85e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -816,7 +816,7 @@ static void bcache_device_free(struct bcache_device *d)
 }
 
 static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
-			      sector_t sectors)
+			      sector_t sectors, make_request_fn make_request_fn)
 {
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
@@ -870,7 +870,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	if (!q)
 		return -ENOMEM;
 
-	blk_queue_make_request(q, NULL);
+	blk_queue_make_request(q, make_request_fn);
 	d->disk->queue			= q;
 	q->queuedata			= d;
 	q->backing_dev_info->congested_data = d;
@@ -1339,7 +1339,8 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 			q->limits.raid_partial_stripes_expensive;
 
 	ret = bcache_device_init(&dc->disk, block_size,
-			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
+			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
+			 cached_dev_make_request);
 	if (ret)
 		return ret;
 
@@ -1451,7 +1452,8 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 
 	kobject_init(&d->kobj, &bch_flash_dev_ktype);
 
-	if (bcache_device_init(d, block_bytes(c), u->sectors))
+	if (bcache_device_init(d, block_bytes(c), u->sectors,
+			flash_dev_make_request))
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
-- 
2.25.1


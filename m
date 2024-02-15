Return-Path: <linux-bcache+bounces-263-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 564A7855B59
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B081BB24AF1
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3CADF60;
	Thu, 15 Feb 2024 07:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wIei4lQI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4355D51D;
	Thu, 15 Feb 2024 07:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981071; cv=none; b=UTBSLTF2Hh655otRH3q7tYzMlHXXPPFVJhOkv8w4gWD7PBS7bsIW1Sa2i8ipwwD+cxwQJpoWPJ1W+YVKVBIr92KOk8T4+12+ik6aJqQb0kLEgS9tnFoRSkvK6mPhWAfedHMM+JT0fqLmiAhA5knf9hxbRFDmbU0FpVHQV6J0eag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981071; c=relaxed/simple;
	bh=kfbTBpPX7/dPhtgwTgmfHFNVEJuG/s+gGAm41gZIRK4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WAn6KPE/QpJdy7B3XQCb/Uz2MQMtdD2hg+BCUEZ30M4jitNrzCdzayHumH7z07lJf7u/gpL9bAmgnG8Rt/PR8ySm0p8muiRJvEvo2wTjUwLZHKMxkddHNBe0DHI1sL33prfgFZ0nFSgo8vDefx5EMV1pzrKQllsfXlmlbGK2OhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wIei4lQI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+8zrMZaF5fx45qwkzXKl3U0CQAfkxZCZdzv3EI99fb4=; b=wIei4lQId5JxR+pTLPnbHvP7FP
	BB166vsbo/awFBWrDGyzjLFbINfinxT5gsge3CHDU4+f7h1i/2/AQ/Fs32ki0xIo9JWnxX31Dje3E
	DxMbxNz3DGyQGzQGuu9N29MqoO2wAj5Rq8UM0Zs9fWWLHjPA8T+lINGZzHUMkyaIj//CSZjwRLFhq
	yHiMw2SG/+mlF0+eflwAqcUkyMeIwAdwCSGO3ESa8RnJxDc/hWh4jbVOL3KrxSxR56xFkqvl4MpOi
	TGuEtfVgzeV2317UvviveT2Tm9Z0FUH/9cJD6qrYIPUPK5Rdk+gspmdxz60M0FI9uTbW/bnruqlPV
	MzOKeRhg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVth-0000000FCXd-0Ahj;
	Thu, 15 Feb 2024 07:11:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH 1/9] block: pass a queue_limits argument to blk_alloc_disk
Date: Thu, 15 Feb 2024 08:10:47 +0100
Message-Id: <20240215071055.2201424-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240215071055.2201424-1-hch@lst.de>
References: <20240215071055.2201424-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass a queue_limits to blk_alloc_disk and apply it if non-NULL.  This
will allow allocating queues with valid queue limits instead of setting
the values one at a time later.

Also change blk_alloc_disk to return an ERR_PTR instead of just NULL
which can't distinguish errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/m68k/emu/nfblock.c             |  6 ++++--
 arch/xtensa/platforms/iss/simdisk.c |  8 +++++---
 block/genhd.c                       | 11 ++++++-----
 drivers/block/brd.c                 |  7 ++++---
 drivers/block/drbd/drbd_main.c      |  6 ++++--
 drivers/block/n64cart.c             |  6 ++++--
 drivers/block/null_blk/main.c       |  7 ++++---
 drivers/block/pktcdvd.c             |  7 ++++---
 drivers/block/ps3vram.c             |  6 +++---
 drivers/block/zram/zram_drv.c       |  6 +++---
 drivers/md/bcache/super.c           |  4 ++--
 drivers/md/dm.c                     |  4 ++--
 drivers/md/md.c                     |  7 ++++---
 drivers/nvdimm/btt.c                |  8 ++++----
 drivers/nvdimm/pmem.c               |  6 +++---
 drivers/nvme/host/multipath.c       |  6 +++---
 drivers/s390/block/dcssblk.c        |  6 +++---
 include/linux/blkdev.h              | 10 +++++++---
 18 files changed, 69 insertions(+), 52 deletions(-)

diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index a708fbd5a844f8..539ff56b6968d0 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -117,9 +117,11 @@ static int __init nfhd_init_one(int id, u32 blocks, u32 bsize)
 	dev->bsize = bsize;
 	dev->bshift = ffs(bsize) - 10;
 
-	dev->disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!dev->disk)
+	dev->disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(dev->disk)) {
+		err = PTR_ERR(dev->disk);
 		goto free_dev;
+	}
 
 	dev->disk->major = major_num;
 	dev->disk->first_minor = dev_id * 16;
diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 178cf96ca10acb..defc67909a9c74 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -264,16 +264,18 @@ static int __init simdisk_setup(struct simdisk *dev, int which,
 		struct proc_dir_entry *procdir)
 {
 	char tmp[2] = { '0' + which, 0 };
-	int err = -ENOMEM;
+	int err;
 
 	dev->fd = -1;
 	dev->filename = NULL;
 	spin_lock_init(&dev->lock);
 	dev->users = 0;
 
-	dev->gd = blk_alloc_disk(NUMA_NO_NODE);
-	if (!dev->gd)
+	dev->gd = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(dev->gd)) {
+		err = PTR_ERR(dev->gd);
 		goto out;
+	}
 	dev->gd->major = simdisk_major;
 	dev->gd->first_minor = which;
 	dev->gd->minors = SIMDISK_MINORS;
diff --git a/block/genhd.c b/block/genhd.c
index 7a8fd57c51f73c..84c822d989daca 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1391,20 +1391,21 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	return NULL;
 }
 
-struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass)
+struct gendisk *__blk_alloc_disk(struct queue_limits *lim, int node,
+		struct lock_class_key *lkclass)
 {
-	struct queue_limits lim = { };
+	struct queue_limits default_lim = { };
 	struct request_queue *q;
 	struct gendisk *disk;
 
-	q = blk_alloc_queue(&lim, node);
+	q = blk_alloc_queue(lim ? lim : &default_lim, node);
 	if (IS_ERR(q))
-		return NULL;
+		return ERR_CAST(q);
 
 	disk = __alloc_disk_node(q, node, lkclass);
 	if (!disk) {
 		blk_put_queue(q);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(GD_OWNS_QUEUE, &disk->state);
 	return disk;
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 970bd6ff38c491..689a3c0c31f8b4 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -335,10 +335,11 @@ static int brd_alloc(int i)
 		debugfs_create_u64(buf, 0444, brd_debugfs_dir,
 				&brd->brd_nr_pages);
 
-	disk = brd->brd_disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!disk)
+	disk = brd->brd_disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(disk)) {
+		err = PTR_ERR(disk);
 		goto out_free_dev;
-
+	}
 	disk->major		= RAMDISK_MAJOR;
 	disk->first_minor	= i * max_part;
 	disk->minors		= max_part;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6bc86106c7b2ab..cea1e537fd56c1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2708,9 +2708,11 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	drbd_init_set_defaults(device);
 
-	disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!disk)
+	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(disk)) {
+		err = PTR_ERR(disk);
 		goto out_no_disk;
+	}
 
 	device->vdisk = disk;
 	device->rq_queue = disk->queue;
diff --git a/drivers/block/n64cart.c b/drivers/block/n64cart.c
index d914156db2d8b2..c64d7ee7a44db5 100644
--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -131,9 +131,11 @@ static int __init n64cart_probe(struct platform_device *pdev)
 	if (IS_ERR(reg_base))
 		return PTR_ERR(reg_base);
 
-	disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!disk)
+	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(disk)) {
+		err = PTR_ERR(disk);
 		goto out;
+	}
 
 	disk->first_minor = 0;
 	disk->flags = GENHD_FL_NO_PART;
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index eeb895ec6f34ae..baf2b228d00801 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2154,10 +2154,11 @@ static int null_add_dev(struct nullb_device *dev)
 		}
 		nullb->q = nullb->disk->queue;
 	} else if (dev->queue_mode == NULL_Q_BIO) {
-		rv = -ENOMEM;
-		nullb->disk = blk_alloc_disk(nullb->dev->home_node);
-		if (!nullb->disk)
+		nullb->disk = blk_alloc_disk(NULL, nullb->dev->home_node);
+		if (IS_ERR(nullb->disk)) {
+			rv = PTR_ERR(nullb->disk);
 			goto out_cleanup_queues;
+		}
 
 		nullb->q = nullb->disk->queue;
 		rv = init_driver_queues(nullb);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d56d972aadb36f..abb82926b1c935 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2673,10 +2673,11 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	pd->write_congestion_on  = write_congestion_on;
 	pd->write_congestion_off = write_congestion_off;
 
-	ret = -ENOMEM;
-	disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!disk)
+	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(disk)) {
+		ret = PTR_ERR(disk);
 		goto out_mem;
+	}
 	pd->disk = disk;
 	disk->major = pktdev_major;
 	disk->first_minor = idx;
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 38d42af01b2535..bdcf083b45e234 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -730,10 +730,10 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 
 	ps3vram_proc_init(dev);
 
-	gendisk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!gendisk) {
+	gendisk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(gendisk)) {
 		dev_err(&dev->core, "blk_alloc_disk failed\n");
-		error = -ENOMEM;
+		error = PTR_ERR(gendisk);
 		goto out_cache_cleanup;
 	}
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 6772e0c654fa7f..84982221fc6620 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2195,11 +2195,11 @@ static int zram_add(void)
 #endif
 
 	/* gendisk structure */
-	zram->disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!zram->disk) {
+	zram->disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(zram->disk)) {
 		pr_err("Error allocating disk structure for device %d\n",
 			device_id);
-		ret = -ENOMEM;
+		ret = PTR_ERR(zram->disk);
 		goto out_free_idr;
 	}
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index dc3f50f6971417..9955ecff383966 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -935,8 +935,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
 		goto out_ida_remove;
 
-	d->disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!d->disk)
+	d->disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(d->disk))
 		goto out_bioset_exit;
 
 	set_capacity(d->disk, sectors);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8dcabf84d866e6..b5e6a10b9cfde3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2098,8 +2098,8 @@ static struct mapped_device *alloc_dev(int minor)
 	 * established. If request-based table is loaded: blk-mq will
 	 * override accordingly.
 	 */
-	md->disk = blk_alloc_disk(md->numa_node_id);
-	if (!md->disk)
+	md->disk = blk_alloc_disk(NULL, md->numa_node_id);
+	if (IS_ERR(md->disk))
 		goto bad;
 	md->queue = md->disk->queue;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2266358d807466..e255f426bf9ced 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5770,10 +5770,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		 */
 		mddev->hold_active = UNTIL_STOP;
 
-	error = -ENOMEM;
-	disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!disk)
+	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(disk)) {
+		error = PTR_ERR(disk);
 		goto out_free_mddev;
+	}
 
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index bb3726b622ad9f..9a0eae01d5986e 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1496,11 +1496,11 @@ static int btt_blk_init(struct btt *btt)
 {
 	struct nd_btt *nd_btt = btt->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
-	int rc = -ENOMEM;
+	int rc;
 
-	btt->btt_disk = blk_alloc_disk(NUMA_NO_NODE);
-	if (!btt->btt_disk)
-		return -ENOMEM;
+	btt->btt_disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(btt->btt_disk))
+		return PTR_ERR(btt->btt_disk);
 
 	nvdimm_namespace_disk_name(ndns, btt->btt_disk->disk_name);
 	btt->btt_disk->first_minor = 0;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4e8fdcb3f1c827..3a5df8d467c507 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -497,9 +497,9 @@ static int pmem_attach_disk(struct device *dev,
 		return -EBUSY;
 	}
 
-	disk = blk_alloc_disk(nid);
-	if (!disk)
-		return -ENOMEM;
+	disk = blk_alloc_disk(NULL, nid);
+	if (IS_ERR(disk))
+		return PTR_ERR(disk);
 	q = disk->queue;
 
 	pmem->disk = disk;
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 74de1e64aeead7..dc5d0d0a82d0e2 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -532,9 +532,9 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 	    !nvme_is_unique_nsid(ctrl, head) || !multipath)
 		return 0;
 
-	head->disk = blk_alloc_disk(ctrl->numa_node);
-	if (!head->disk)
-		return -ENOMEM;
+	head->disk = blk_alloc_disk(NULL, ctrl->numa_node);
+	if (IS_ERR(head->disk))
+		return PTR_ERR(head->disk);
 	head->disk->fops = &nvme_ns_head_ops;
 	head->disk->private_data = head;
 	sprintf(head->disk->disk_name, "nvme%dn%d",
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 4b7ecd4fd4319c..0903b432ea9740 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -629,9 +629,9 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->dev.release = dcssblk_release_segment;
 	dev_info->dev.groups = dcssblk_dev_attr_groups;
 	INIT_LIST_HEAD(&dev_info->lh);
-	dev_info->gd = blk_alloc_disk(NUMA_NO_NODE);
-	if (dev_info->gd == NULL) {
-		rc = -ENOMEM;
+	dev_info->gd = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	if (IS_ERR(dev_info->gd)) {
+		rc = PTR_ERR(dev_info->gd);
 		goto seg_list_del;
 	}
 	dev_info->gd->major = dcssblk_major;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 45746ba73670e8..a14ea934413850 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -766,22 +766,26 @@ static inline u64 sb_bdev_nr_blocks(struct super_block *sb)
 int bdev_disk_changed(struct gendisk *disk, bool invalidate);
 
 void put_disk(struct gendisk *disk);
-struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass);
+struct gendisk *__blk_alloc_disk(struct queue_limits *lim, int node,
+		struct lock_class_key *lkclass);
 
 /**
  * blk_alloc_disk - allocate a gendisk structure
+ * @lim: queue limits to be used for this disk.
  * @node_id: numa node to allocate on
  *
  * Allocate and pre-initialize a gendisk structure for use with BIO based
  * drivers.
  *
+ * Returns an ERR_PTR on error, else the allocated disk.
+ *
  * Context: can sleep
  */
-#define blk_alloc_disk(node_id)						\
+#define blk_alloc_disk(lim, node_id)					\
 ({									\
 	static struct lock_class_key __key;				\
 									\
-	__blk_alloc_disk(node_id, &__key);				\
+	__blk_alloc_disk(lim, node_id, &__key);				\
 })
 
 int __register_blkdev(unsigned int major, const char *name,
-- 
2.39.2



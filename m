Return-Path: <linux-bcache+bounces-873-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 048C1A87589
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:48:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B009E1891484
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2986C1B6CEF;
	Mon, 14 Apr 2025 01:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mKp6sPN0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73A21B042C
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595168; cv=none; b=smKgoHpgkKcFts6wdfWDmqZe2+604/iTYZv0+P42hy44RdmdsAN0kxbmWNtN93MO5ZsdWRuaeIDJdUN62AtX97iiwu6iNzSh1/iafsVQDvF0gC0bmzIDUwjqV5zUHD5HsJDLDF05oqZLpecDLfS8HATjP8kRN8pDfbEDExQQYVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595168; c=relaxed/simple;
	bh=9cBDjKJhSiTvib7W3fj8aRhdB5gLKX8e+OpW7b/UfMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XTtZyhcK/sFrO7NlDeS8OflwsQIvuN65AWLtF5hSVJotPyPPGxiz8Qhm4BSYHWgc3LyV9ymN5ZkANKrv38uOnUEhqFXjgxLNZOc2Clw+JFKKIeOg2y4iuppwyoh2qiKuv9OFavLpbCxzeFdjFMQQCgfKsJbBKAEg2l30EGzNcK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mKp6sPN0; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3iTQTKfivIcZOcu/03Vqjvl30ny00w4N5DElQG4ahKU=;
	b=mKp6sPN0/1sBTM1SlLF4WxzvdwpR2bmeiK+CWM1Gj8tfZjW08win4lfe3xWh5o90+Bshlm
	Sa41MIWOF+l4IjB6C48Xg1A6P+kEGKF1bAmBAScRwZqrQ0qiN4aFK2cxcLwoQq7yPPify1
	sNSGo30O5J0l3sxr3tL/LyHtQ/7hHTI=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: axboe@kernel.dk,
	hch@lst.de,
	dan.j.williams@intel.com,
	gregory.price@memverge.com,
	John@groves.net,
	Jonathan.Cameron@Huawei.com,
	bbhushan2@marvell.com,
	chaitanyak@nvidia.com,
	rdunlap@infradead.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [RFC PATCH 10/11] pcache: add backing device management
Date: Mon, 14 Apr 2025 01:45:04 +0000
Message-Id: <20250414014505.20477-11-dongsheng.yang@linux.dev>
In-Reply-To: <20250414014505.20477-1-dongsheng.yang@linux.dev>
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This patch introduces support for managing backing devices in the pcache
framework. A backing device represents a real block device (e.g., /dev/sdX),
which is wrapped with caching support and exposed via a logical device
(e.g., /dev/pcacheX).

Key highlights:

- `pcache_backing_dev`:
  Encapsulates the state of a backing device, including its metadata, bioset,
  workqueues, cache instance, and associated logic device.

- Metadata persistence:
  Uses `pcache_backing_dev_info` to persist path, cache config (segment count,
  GC percent), and other info. Supports update and recovery.

- Sysfs interface:
  Exposes `path`, `cache_segs`, `mapped_id`, `cache_used_segs`, and GC control
  under `/sys/class/.../backing_devX/`.

- I/O request handling:
  Implements a generic `pcache_backing_dev_req` abstraction, which maps and
  submits bio chains to the underlying device. Completion is handled
  asynchronously via `workqueue` to enable decoupled upper-layer processing.

- Initialization flow:
  `backing_dev_start()` prepares the backing device by opening the file,
  initializing bioset/workqueue, loading or creating metadata, instantiating
  the cache, starting the logic block device, and registering sysfs.

- Clean shutdown via `backing_dev_stop()`.

This forms the middle layer of pcache, bridging cache logic and the
logical block device to actual physical storage.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/backing_dev.c | 593 +++++++++++++++++++++++++++++
 drivers/block/pcache/backing_dev.h | 105 +++++
 2 files changed, 698 insertions(+)
 create mode 100644 drivers/block/pcache/backing_dev.c
 create mode 100644 drivers/block/pcache/backing_dev.h

diff --git a/drivers/block/pcache/backing_dev.c b/drivers/block/pcache/backing_dev.c
new file mode 100644
index 000000000000..89a87e715f60
--- /dev/null
+++ b/drivers/block/pcache/backing_dev.c
@@ -0,0 +1,593 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blkdev.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+#include "logic_dev.h"
+#include "meta_segment.h"
+
+static ssize_t path_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct pcache_backing_dev *backing_dev;
+
+	backing_dev = container_of(dev, struct pcache_backing_dev, device);
+
+	return sprintf(buf, "%s\n", backing_dev->backing_dev_info.path);
+}
+static DEVICE_ATTR_ADMIN_RO(path);
+
+static ssize_t mapped_id_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct pcache_backing_dev *backing_dev;
+
+	backing_dev = container_of(dev, struct pcache_backing_dev, device);
+
+	return sprintf(buf, "%u\n", backing_dev->logic_dev->mapped_id);
+}
+static DEVICE_ATTR_ADMIN_RO(mapped_id);
+
+/* sysfs for cache */
+static ssize_t cache_segs_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct pcache_backing_dev *backing_dev;
+
+	backing_dev = container_of(dev, struct pcache_backing_dev, device);
+
+	return sprintf(buf, "%u\n", backing_dev->cache_segs);
+}
+static DEVICE_ATTR_ADMIN_RO(cache_segs);
+
+static ssize_t cache_used_segs_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct pcache_backing_dev *backing_dev;
+	u32 segs_used;
+
+	backing_dev = container_of(dev, struct pcache_backing_dev, device);
+	segs_used = bitmap_weight(backing_dev->cache->seg_map, backing_dev->cache->n_segs);
+	return sprintf(buf, "%u\n", segs_used);
+}
+static DEVICE_ATTR_ADMIN_RO(cache_used_segs);
+
+static ssize_t cache_gc_percent_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct pcache_backing_dev *backing_dev;
+
+	backing_dev = container_of(dev, struct pcache_backing_dev, device);
+
+	return sprintf(buf, "%u\n", backing_dev->backing_dev_info.cache_info.gc_percent);
+}
+
+static ssize_t cache_gc_percent_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t size)
+{
+	struct pcache_backing_dev *backing_dev;
+	unsigned long val;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	backing_dev = container_of(dev, struct pcache_backing_dev, device);
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val < PCACHE_CACHE_GC_PERCENT_MIN ||
+	    val > PCACHE_CACHE_GC_PERCENT_MAX)
+		return -EINVAL;
+
+	backing_dev->backing_dev_info.cache_info.gc_percent = val;
+	backing_dev_info_write(backing_dev);
+
+	return size;
+}
+static DEVICE_ATTR_ADMIN_RW(cache_gc_percent);
+
+static struct attribute *backing_dev_attrs[] = {
+	&dev_attr_path.attr,
+	&dev_attr_mapped_id.attr,
+	&dev_attr_cache_segs.attr,
+	&dev_attr_cache_used_segs.attr,
+	&dev_attr_cache_gc_percent.attr,
+	NULL
+};
+
+static struct attribute_group backing_dev_attr_group = {
+	.attrs = backing_dev_attrs,
+};
+
+static const struct attribute_group *backing_dev_attr_groups[] = {
+	&backing_dev_attr_group,
+	NULL
+};
+
+static void backing_dev_release(struct device *dev)
+{
+}
+
+const struct device_type backing_dev_type = {
+	.name		= "backing_dev",
+	.groups		= backing_dev_attr_groups,
+	.release	= backing_dev_release,
+};
+
+void backing_dev_info_write(struct pcache_backing_dev *backing_dev)
+{
+	struct pcache_backing_dev_info *info;
+	struct pcache_meta_header *meta;
+
+	mutex_lock(&backing_dev->info_lock);
+
+	meta = &backing_dev->backing_dev_info.header;
+	meta->seq++;
+
+	info = pcache_meta_find_oldest(&backing_dev->backing_dev_info_addr->header, PCACHE_BACKING_DEV_INFO_SIZE);
+	memcpy(info, &backing_dev->backing_dev_info, sizeof(struct pcache_backing_dev_info));
+	info->header.crc = pcache_meta_crc(&info->header, PCACHE_BACKING_DEV_INFO_SIZE);
+
+	cache_dev_flush(backing_dev->cache_dev, info, PCACHE_BACKING_DEV_INFO_SIZE);
+	mutex_unlock(&backing_dev->info_lock);
+}
+
+static int backing_dev_info_load(struct pcache_backing_dev *backing_dev)
+{
+	struct pcache_backing_dev_info *info;
+	int ret = 0;
+
+	mutex_lock(&backing_dev->info_lock);
+
+	info = pcache_meta_find_latest(&backing_dev->backing_dev_info_addr->header, PCACHE_BACKING_DEV_INFO_SIZE);
+	if (!info) {
+		ret = -EIO;
+		goto unlock;
+	}
+
+	memcpy(&backing_dev->backing_dev_info, info, sizeof(struct pcache_backing_dev_info));
+unlock:
+	mutex_unlock(&backing_dev->info_lock);
+	return ret;
+}
+
+static void backing_dev_free(struct pcache_backing_dev *backing_dev)
+{
+	drain_workqueue(backing_dev->task_wq);
+	destroy_workqueue(backing_dev->task_wq);
+	kmem_cache_destroy(backing_dev->backing_req_cache);
+	kfree(backing_dev);
+}
+
+static void req_submit_fn(struct work_struct *work);
+static void req_complete_fn(struct work_struct *work);
+static struct pcache_backing_dev *backing_dev_alloc(struct pcache_cache_dev *cache_dev)
+{
+	struct pcache_backing_dev *backing_dev;
+
+	backing_dev = kzalloc(sizeof(struct pcache_backing_dev), GFP_KERNEL);
+	if (!backing_dev)
+		return NULL;
+
+	backing_dev->backing_req_cache = KMEM_CACHE(pcache_backing_dev_req, 0);
+	if (!backing_dev->backing_req_cache)
+		goto free_backing_dev;
+
+	backing_dev->task_wq = alloc_workqueue("pcache-backing-wq",  WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!backing_dev->task_wq)
+		goto destroy_io_cache;
+
+	backing_dev->cache_dev = cache_dev;
+
+	mutex_init(&backing_dev->info_lock);
+	INIT_LIST_HEAD(&backing_dev->node);
+	INIT_LIST_HEAD(&backing_dev->submit_list);
+	INIT_LIST_HEAD(&backing_dev->complete_list);
+	spin_lock_init(&backing_dev->lock);
+	spin_lock_init(&backing_dev->submit_lock);
+	spin_lock_init(&backing_dev->complete_lock);
+	INIT_WORK(&backing_dev->req_submit_work, req_submit_fn);
+	INIT_WORK(&backing_dev->req_complete_work, req_complete_fn);
+
+	return backing_dev;
+
+destroy_io_cache:
+	kmem_cache_destroy(backing_dev->backing_req_cache);
+free_backing_dev:
+	kfree(backing_dev);
+	return NULL;
+}
+
+static int backing_dev_cache_init(struct pcache_backing_dev *backing_dev,
+				  struct pcache_backing_dev_opts *backing_opts,
+				  bool new_backing_dev)
+{
+	struct pcache_cache_opts cache_opts = { 0 };
+	int ret;
+
+	backing_dev->cache_segs = backing_opts->cache_segs;
+	cache_opts.cache_info = &backing_dev->backing_dev_info.cache_info;
+	cache_opts.n_segs = backing_opts->cache_segs;
+	cache_opts.n_paral = backing_opts->queues;
+	cache_opts.new_cache = new_backing_dev;
+	cache_opts.data_crc = backing_opts->data_crc;
+	cache_opts.bdev_file = backing_dev->bdev_file;
+	cache_opts.dev_size = backing_dev->dev_size;
+
+	backing_dev->cache = pcache_cache_alloc(backing_dev, &cache_opts);
+	if (!backing_dev->cache) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static void backing_dev_cache_destroy(struct pcache_backing_dev *backing_dev)
+{
+	if (backing_dev->cache)
+		pcache_cache_destroy(backing_dev->cache);
+}
+
+static int backing_dev_sysfs_init(struct pcache_backing_dev *backing_dev)
+{
+	struct device *dev;
+	struct pcache_logic_dev *logic_dev = backing_dev->logic_dev;
+	int ret;
+
+	dev = &backing_dev->device;
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->type = &backing_dev_type;
+	dev->parent = &backing_dev->cache_dev->device;
+	dev_set_name(dev, "backing_dev%d", backing_dev->backing_dev_id);
+
+	ret = device_add(dev);
+	if (ret)
+		goto err;
+
+	ret = sysfs_create_link(&disk_to_dev(logic_dev->disk)->kobj,
+				&backing_dev->device.kobj, "pcache");
+	if (ret)
+		goto dev_unregister;
+
+	bd_link_disk_holder(backing_dev->bdev, logic_dev->disk);
+	bd_link_disk_holder(backing_dev->cache_dev->bdev, logic_dev->disk);
+
+	return 0;
+
+dev_unregister:
+	device_unregister(dev);
+err:
+	return ret;
+}
+
+static void backing_dev_sysfs_exit(struct pcache_backing_dev *backing_dev)
+{
+	struct pcache_logic_dev *logic_dev = backing_dev->logic_dev;
+
+	bd_unlink_disk_holder(backing_dev->cache_dev->bdev, logic_dev->disk);
+	bd_unlink_disk_holder(backing_dev->bdev, logic_dev->disk);
+	sysfs_remove_link(&disk_to_dev(logic_dev->disk)->kobj, "pcache");
+	device_unregister(&backing_dev->device);
+}
+
+static int backing_dev_init(struct pcache_backing_dev *backing_dev, struct pcache_backing_dev_opts *backing_opts)
+{
+	struct pcache_cache_dev *cache_dev = backing_dev->cache_dev;
+	bool new_backing;
+	int ret;
+
+	memcpy(backing_dev->backing_dev_info.path, backing_opts->path, PCACHE_PATH_LEN);
+
+	backing_dev->bdev_file = bdev_file_open_by_path(backing_dev->backing_dev_info.path,
+			BLK_OPEN_READ | BLK_OPEN_WRITE, backing_dev, NULL);
+	if (IS_ERR(backing_dev->bdev_file)) {
+		backing_dev_err(backing_dev, "failed to open bdev: %d", (int)PTR_ERR(backing_dev->bdev_file));
+		ret = PTR_ERR(backing_dev->bdev_file);
+		goto err;
+	}
+
+	backing_dev->bdev = file_bdev(backing_dev->bdev_file);
+	backing_dev->dev_size = bdev_nr_sectors(backing_dev->bdev);
+
+	ret = bioset_init(&backing_dev->bioset, 1024, 0, BIOSET_NEED_BVECS);
+	if (ret)
+		goto close_bdev;
+
+	ret = cache_dev_find_backing_info(cache_dev, backing_dev, &new_backing);
+	if (ret)
+		goto bioset_exit;
+
+	if (!new_backing)
+		backing_dev_info_load(backing_dev);
+
+	ret = backing_dev_cache_init(backing_dev, backing_opts, new_backing);
+	if (ret)
+		goto bioset_exit;
+
+	ret = logic_dev_start(backing_dev, backing_opts->queues);
+	if (ret)
+		goto destroy_cache;
+
+	ret = backing_dev_sysfs_init(backing_dev);
+	if (ret)
+		goto logic_dev_stop;
+
+	backing_dev->backing_dev_info.state = PCACHE_BACKING_STATE_RUNNING;
+	backing_dev->backing_dev_info.backing_dev_id = backing_dev->backing_dev_id;
+	backing_dev_info_write(backing_dev);
+
+	cache_dev_add_backing(cache_dev, backing_dev);
+
+	return 0;
+
+logic_dev_stop:
+	logic_dev_stop(backing_dev->logic_dev);
+destroy_cache:
+	backing_dev_cache_destroy(backing_dev);
+bioset_exit:
+	bioset_exit(&backing_dev->bioset);
+close_bdev:
+	fput(backing_dev->bdev_file);
+err:
+	return ret;
+}
+
+static int backing_dev_destroy(struct pcache_backing_dev *backing_dev)
+{
+	backing_dev_sysfs_exit(backing_dev);
+	logic_dev_stop(backing_dev->logic_dev);
+	backing_dev_cache_destroy(backing_dev);
+	bioset_exit(&backing_dev->bioset);
+	fput(backing_dev->bdev_file);
+
+	backing_dev->backing_dev_info.state = PCACHE_BACKING_STATE_NONE;
+	backing_dev_info_write(backing_dev);
+
+	return 0;
+}
+
+int backing_dev_start(struct pcache_cache_dev *cache_dev, struct pcache_backing_dev_opts *backing_opts)
+{
+	struct pcache_backing_dev *backing_dev;
+	int ret;
+
+	/* Check if path starts with "/dev/" */
+	if (strncmp(backing_opts->path, "/dev/", 5) != 0)
+		return -EINVAL;
+
+	backing_dev = backing_dev_alloc(cache_dev);
+	if (!backing_dev)
+		return -ENOMEM;
+
+	ret = backing_dev_init(backing_dev, backing_opts);
+	if (ret)
+		goto destroy_backing_dev;
+
+	return 0;
+
+destroy_backing_dev:
+	backing_dev_free(backing_dev);
+
+	return ret;
+}
+
+int backing_dev_stop(struct pcache_cache_dev *cache_dev, u32 backing_dev_id)
+{
+	struct pcache_backing_dev *backing_dev;
+
+	backing_dev = cache_dev_fetch_backing(cache_dev, backing_dev_id);
+	if (!backing_dev)
+		return -ENOENT;
+
+	backing_dev_destroy(backing_dev);
+	backing_dev_free(backing_dev);
+
+	return 0;
+}
+
+/* pcache_backing_dev_req functions */
+static void end_req(struct kref *ref)
+{
+	struct pcache_backing_dev_req *backing_req = container_of(ref, struct pcache_backing_dev_req, ref);
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	spin_lock(&backing_dev->complete_lock);
+	list_move_tail(&backing_req->node, &backing_dev->complete_list);
+	spin_unlock(&backing_dev->complete_lock);
+
+	queue_work(backing_dev->task_wq, &backing_dev->req_complete_work);
+}
+
+static void backing_dev_bio_end(struct bio *bio)
+{
+	struct pcache_backing_dev_req *backing_req = bio->bi_private;
+	int ret = bio->bi_status;
+
+	if (ret && !backing_req->ret)
+		backing_req->ret = ret;
+
+	kref_put(&backing_req->ref, end_req);
+	bio_put(bio);
+}
+
+static int map_bio_pages(struct bio *bio, struct request *req, u32 req_off, u32 len)
+{
+	struct bio_vec src_bvec;
+	struct bvec_iter src_iter;
+	size_t mapped = 0, offset = 0;
+	struct bio *src_bio;
+
+	src_bio = req->bio;
+
+next_bio:
+	bio_for_each_segment(src_bvec, src_bio, src_iter) {
+		struct page *page = src_bvec.bv_page;
+		size_t page_off = src_bvec.bv_offset;
+		size_t page_len = src_bvec.bv_len;
+
+		if (offset + page_len <= req_off) {
+			offset += page_len;
+			continue;
+		}
+
+		size_t start = (req_off > offset) ? (req_off - offset) : 0;
+		size_t map_len = min(len - mapped, page_len - start);
+
+		if (bio_add_page(bio, page, map_len, page_off + start) != map_len) {
+			pr_err("Failed to map page to bio\n");
+			break;
+		}
+
+		mapped += map_len;
+		if (mapped >= len)
+			goto out;
+
+		offset += page_len;
+	}
+
+	if (src_bio->bi_next) {
+		src_bio = src_bio->bi_next;
+		goto next_bio;
+	}
+out:
+	return 0;
+}
+
+struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev, struct pcache_request *pcache_req,
+			u32 off, u32 len, backing_req_end_fn_t end_req)
+{
+	struct pcache_backing_dev_req *backing_req;
+	u32 mapped_len = 0;
+	struct bio *bio;
+
+	backing_req = kmem_cache_zalloc(backing_dev->backing_req_cache, GFP_ATOMIC);
+	if (!backing_req)
+		return NULL;
+
+	backing_req->backing_dev = backing_dev;
+	INIT_LIST_HEAD(&backing_req->node);
+	kref_init(&backing_req->ref);
+	backing_req->end_req = end_req;
+	backing_req->bio_off = off;
+next_bio:
+	bio = bio_alloc_bioset(backing_dev->bdev,
+					BIO_MAX_VECS,
+					req_op(pcache_req->req),
+					GFP_ATOMIC, &backing_dev->bioset);
+	if (!bio)
+		goto free_backing_req;
+
+	bio->bi_iter.bi_sector = (pcache_req->off + off + mapped_len) >> SECTOR_SHIFT;
+	bio->bi_iter.bi_size = 0;
+	bio->bi_private = backing_req;
+	bio->bi_end_io = backing_dev_bio_end;
+	kref_get(&backing_req->ref);
+
+	if (backing_req->bio)
+		bio->bi_next = backing_req->bio;
+	backing_req->bio = bio;
+
+	map_bio_pages(bio, pcache_req->req, off + mapped_len, len - mapped_len);
+	mapped_len += bio->bi_iter.bi_size;
+	if (mapped_len < len)
+		goto next_bio;
+
+	pcache_req_get(pcache_req);
+	backing_req->upper_req = pcache_req;
+
+	return backing_req;
+
+free_backing_req:
+	while (backing_req->bio) {
+		bio = backing_req->bio;
+		backing_req->bio = bio->bi_next;
+		bio_put(bio);
+	}
+	kmem_cache_free(backing_dev->backing_req_cache, backing_req);
+
+	return NULL;
+}
+
+static void req_submit_fn(struct work_struct *work)
+{
+	struct pcache_backing_dev *backing_dev = container_of(work, struct pcache_backing_dev, req_submit_work);
+	struct pcache_backing_dev_req *backing_req;
+	unsigned long flags;
+	LIST_HEAD(tmp_list);
+
+	spin_lock(&backing_dev->submit_lock);
+	list_splice_init(&backing_dev->submit_list, &tmp_list);
+	spin_unlock(&backing_dev->submit_lock);
+
+	while (!list_empty(&tmp_list)) {
+		backing_req = list_first_entry(&tmp_list,
+					    struct pcache_backing_dev_req, node);
+		list_del_init(&backing_req->node);
+		while (backing_req->bio) {
+			struct bio *bio = backing_req->bio;
+
+			backing_req->bio = bio->bi_next;
+			submit_bio_noacct(bio);
+		}
+
+		local_irq_save(flags);
+		kref_put(&backing_req->ref, end_req);
+		local_irq_restore(flags);
+	}
+}
+
+static void req_complete_fn(struct work_struct *work)
+{
+	struct pcache_backing_dev *backing_dev = container_of(work, struct pcache_backing_dev, req_complete_work);
+	struct pcache_backing_dev_req *backing_req;
+	unsigned long flags;
+	LIST_HEAD(tmp_list);
+
+	spin_lock_irqsave(&backing_dev->complete_lock, flags);
+	list_splice_init(&backing_dev->complete_list, &tmp_list);
+	spin_unlock_irqrestore(&backing_dev->complete_lock, flags);
+
+	while (!list_empty(&tmp_list)) {
+		backing_req = list_first_entry(&tmp_list,
+					    struct pcache_backing_dev_req, node);
+		list_del_init(&backing_req->node);
+		backing_dev_req_end(backing_req);
+	}
+}
+
+void backing_dev_req_submit(struct pcache_backing_dev_req *backing_req)
+{
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	spin_lock(&backing_dev->submit_lock);
+	list_add_tail(&backing_req->node, &backing_dev->submit_list);
+	spin_unlock(&backing_dev->submit_lock);
+
+	queue_work(backing_dev->task_wq, &backing_dev->req_submit_work);
+}
+
+void backing_dev_req_end(struct pcache_backing_dev_req *backing_req)
+{
+	struct pcache_backing_dev *backing_dev = backing_req->backing_dev;
+
+	if (backing_req->end_req)
+		backing_req->end_req(backing_req, backing_req->ret);
+
+	kmem_cache_free(backing_dev->backing_req_cache, backing_req);
+}
diff --git a/drivers/block/pcache/backing_dev.h b/drivers/block/pcache/backing_dev.h
new file mode 100644
index 000000000000..e929dc821d37
--- /dev/null
+++ b/drivers/block/pcache/backing_dev.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _BACKING_DEV_H
+#define _BACKING_DEV_H
+
+#include <linux/hashtable.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+
+#define backing_dev_err(backing_dev, fmt, ...)						\
+	cache_dev_err(backing_dev->cache_dev, "backing_dev%d: " fmt,			\
+		 backing_dev->backing_dev_id, ##__VA_ARGS__)
+#define backing_dev_info(backing_dev, fmt, ...)						\
+	cache_dev_info(backing_dev->cache_dev, "backing_dev%d: " fmt,			\
+		 backing_dev->backing_dev_id, ##__VA_ARGS__)
+#define backing_dev_debug(backing_dev, fmt, ...)					\
+	cache_dev_debug(backing_dev->cache_dev, "backing_dev%d: " fmt,			\
+		 backing_dev->backing_dev_id, ##__VA_ARGS__)
+
+#define PCACHE_BACKING_STATE_NONE		0
+#define PCACHE_BACKING_STATE_RUNNING		1
+
+struct pcache_cache_info;
+struct pcache_backing_dev_info {
+	struct pcache_meta_header	header;
+	u8				state;
+	u8				res;
+
+	u16				res1;
+
+	u32				backing_dev_id;
+	u64				dev_size; /* nr_sectors */
+
+	char				path[PCACHE_PATH_LEN];
+	struct pcache_cache_info	cache_info;
+};
+
+struct pcache_backing_dev_req;
+typedef void (*backing_req_end_fn_t)(struct pcache_backing_dev_req *backing_req, int ret);
+
+struct pcache_request;
+struct pcache_backing_dev_req {
+	struct bio			*bio;
+	struct pcache_backing_dev	*backing_dev;
+
+	void				*priv_data;
+	backing_req_end_fn_t		end_req;
+
+	struct pcache_request		*upper_req;
+	u32				bio_off;
+	struct list_head		node;
+	struct kref			ref;
+	int				ret;
+};
+
+struct pcache_logic_dev;
+struct pcache_backing_dev {
+	u32				backing_dev_id;
+	struct pcache_cache_dev		*cache_dev;
+	spinlock_t			lock;
+	struct list_head		node;
+	struct device			device;
+
+	struct pcache_backing_dev_info	backing_dev_info;
+	struct pcache_backing_dev_info	*backing_dev_info_addr;
+	struct mutex			info_lock;
+
+	struct block_device		*bdev;
+	struct file			*bdev_file;
+
+	struct workqueue_struct		*task_wq;
+
+	struct bio_set			bioset;
+	struct kmem_cache		*backing_req_cache;
+	struct list_head		submit_list;
+	spinlock_t			submit_lock;
+	struct work_struct		req_submit_work;
+
+	struct list_head		complete_list;
+	spinlock_t			complete_lock;
+	struct work_struct		req_complete_work;
+
+	struct pcache_logic_dev		*logic_dev;
+	u64				dev_size;
+
+	u32				cache_segs;
+	struct pcache_cache		*cache;
+};
+
+struct pcache_backing_dev_opts {
+	char *path;
+	u32 queues;
+	u32 cache_segs;
+	bool data_crc;
+};
+
+int backing_dev_start(struct pcache_cache_dev *cache_dev, struct pcache_backing_dev_opts *backing_opts);
+int backing_dev_stop(struct pcache_cache_dev *cache_dev, u32 backing_dev_id);
+void backing_dev_info_write(struct pcache_backing_dev *backing_dev);
+
+void backing_dev_req_submit(struct pcache_backing_dev_req *backing_req);
+void backing_dev_req_end(struct pcache_backing_dev_req *backing_req);
+struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev,
+		struct pcache_request *pcache_req, u32 off, u32 len, backing_req_end_fn_t end_req);
+#endif /* _BACKING_DEV_H */
-- 
2.34.1



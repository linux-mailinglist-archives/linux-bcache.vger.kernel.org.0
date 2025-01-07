Return-Path: <linux-bcache+bounces-833-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38164A03C6A
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D79018871CA
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EB01EC01F;
	Tue,  7 Jan 2025 10:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="esaULRTP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969431EBFE6
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245882; cv=none; b=j7YM7gdfWMWtYujDD/kn4tp4XC+6PE5ms/kdWBe4ObYtmWfOpbjjIgVkF8oBoZQyfA1uwifGsxRSqzlv6OjcGWtRGX2bvA1NWWBaocZg/hZwe4/WG0WhEtD2RMVLWs2CbQw1e/4hTP94u6MrlEd96TLBShsbtJHNT5/IiwYaVwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245882; c=relaxed/simple;
	bh=E56oakjwiQ67S9pbo62qwFkHgJ/xiM5ptlG6WQZQdfE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZcFllGj5zlGeKQvOoixK11L1oLan24ZCilvUDTAGDXf/aHwCMXESKDU5hxrT1MJabb4A0H1eaAD+ceSy8cdtoE6PX/SCn/lU36CJuDOGFce31LNe9wX9K9jJql+fzssOsen+4isANIVDkob7aGlVyMfIsCc1bBH/UCZbOMxUr3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=esaULRTP; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+xvialgS7HaL5bNGQCJJkq5pWo3rNO6yxp5m4orZsJo=;
	b=esaULRTPMu3B79TfbfKEvjD+TaDHfJ+fwY/KszEm5wdues6LzLGutwzdeO/EZd3BXHh8Jf
	SuzEYE2A9Cuni/8yFK8pxLjzNDhqNa8YaOul2H3g3AiswPrTCRg36Oqwn014sFFmpncQzj
	+sdtXCEuYJeTOQkO755Pcq37daNAQ+M=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: axboe@kernel.dk,
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
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v3 5/8] cbd: introduce cbd_blkdev
Date: Tue,  7 Jan 2025 10:30:21 +0000
Message-Id: <20250107103024.326986-6-dongsheng.yang@linux.dev>
In-Reply-To: <20250107103024.326986-1-dongsheng.yang@linux.dev>
References: <20250107103024.326986-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The "cbd_blkdev" represents a virtual block device named "/dev/cbdX". It
corresponds to a backend. The "blkdev" interacts with upper-layer users
and accepts IO requests from them. A "blkdev" includes multiple
"cbd_queues", each of which requires a "cbd_channel" to
interact with the backend's handler. The "cbd_queue" forwards IO
requests from the upper layer to the backend's handler through the
channel.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_blkdev.c | 551 +++++++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_blkdev.h |  92 ++++++
 drivers/block/cbd/cbd_queue.c  | 516 ++++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_queue.h  | 288 +++++++++++++++++
 4 files changed, 1447 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_blkdev.c
 create mode 100644 drivers/block/cbd/cbd_blkdev.h
 create mode 100644 drivers/block/cbd/cbd_queue.c
 create mode 100644 drivers/block/cbd/cbd_queue.h

diff --git a/drivers/block/cbd/cbd_blkdev.c b/drivers/block/cbd/cbd_blkdev.c
new file mode 100644
index 000000000000..664fe7daeb9f
--- /dev/null
+++ b/drivers/block/cbd/cbd_blkdev.c
@@ -0,0 +1,551 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "cbd_internal.h"
+#include "cbd_blkdev.h"
+
+static ssize_t backend_id_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_blkdev_device *blkdev_dev;
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev_dev = container_of(dev, struct cbd_blkdev_device, dev);
+	blkdev_info = cbdt_blkdev_info_read(blkdev_dev->cbdt, blkdev_dev->id);
+	if (!blkdev_info)
+		return 0;
+
+	if (blkdev_info->state == CBD_BLKDEV_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%u\n", blkdev_info->backend_id);
+}
+static DEVICE_ATTR_ADMIN_RO(backend_id);
+
+static ssize_t host_id_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct cbd_blkdev_device *blkdev_dev;
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev_dev = container_of(dev, struct cbd_blkdev_device, dev);
+	blkdev_info = cbdt_blkdev_info_read(blkdev_dev->cbdt, blkdev_dev->id);
+	if (!blkdev_info)
+		return 0;
+
+	if (blkdev_info->state == CBD_BLKDEV_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%u\n", blkdev_info->host_id);
+}
+static DEVICE_ATTR_ADMIN_RO(host_id);
+
+static ssize_t mapped_id_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct cbd_blkdev_device *blkdev_dev;
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev_dev = container_of(dev, struct cbd_blkdev_device, dev);
+	blkdev_info = cbdt_blkdev_info_read(blkdev_dev->cbdt, blkdev_dev->id);
+	if (!blkdev_info)
+		return 0;
+
+	if (blkdev_info->state == CBD_BLKDEV_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%u\n", blkdev_info->mapped_id);
+}
+static DEVICE_ATTR_ADMIN_RO(mapped_id);
+
+static void blkdev_info_write(struct cbd_blkdev *blkdev)
+{
+	mutex_lock(&blkdev->info_lock);
+	blkdev->blkdev_info.alive_ts = ktime_get_real();
+	cbdt_blkdev_info_write(blkdev->cbdt, &blkdev->blkdev_info,
+			       sizeof(struct cbd_blkdev_info),
+			       blkdev->blkdev_id);
+	mutex_unlock(&blkdev->info_lock);
+}
+
+static void cbd_blkdev_hb(struct cbd_blkdev *blkdev)
+{
+	blkdev_info_write(blkdev);
+}
+CBD_OBJ_HEARTBEAT(blkdev);
+
+static struct attribute *cbd_blkdev_attrs[] = {
+	&dev_attr_mapped_id.attr,
+	&dev_attr_host_id.attr,
+	&dev_attr_backend_id.attr,
+	&dev_attr_alive.attr,
+	NULL
+};
+
+static struct attribute_group cbd_blkdev_attr_group = {
+	.attrs = cbd_blkdev_attrs,
+};
+
+static const struct attribute_group *cbd_blkdev_attr_groups[] = {
+	&cbd_blkdev_attr_group,
+	NULL
+};
+
+static void cbd_blkdev_release(struct device *dev)
+{
+}
+
+const struct device_type cbd_blkdev_type = {
+	.name		= "cbd_blkdev",
+	.groups		= cbd_blkdev_attr_groups,
+	.release	= cbd_blkdev_release,
+};
+
+const struct device_type cbd_blkdevs_type = {
+	.name		= "cbd_blkdevs",
+	.release	= cbd_blkdev_release,
+};
+
+
+static int cbd_major;
+static DEFINE_IDA(cbd_mapped_id_ida);
+
+static int minor_to_cbd_mapped_id(int minor)
+{
+	return minor >> CBD_PART_SHIFT;
+}
+
+
+static int cbd_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct cbd_blkdev *cbd_blkdev = disk->private_data;
+
+	mutex_lock(&cbd_blkdev->lock);
+	cbd_blkdev->open_count++;
+	mutex_unlock(&cbd_blkdev->lock);
+
+	return 0;
+}
+
+static void cbd_release(struct gendisk *disk)
+{
+	struct cbd_blkdev *cbd_blkdev = disk->private_data;
+
+	mutex_lock(&cbd_blkdev->lock);
+	cbd_blkdev->open_count--;
+	mutex_unlock(&cbd_blkdev->lock);
+}
+
+static const struct block_device_operations cbd_bd_ops = {
+	.owner			= THIS_MODULE,
+	.open			= cbd_open,
+	.release		= cbd_release,
+};
+
+/**
+ * cbd_blkdev_destroy_queues - Stop and free the queues associated with the block device
+ * @cbd_blkdev: Pointer to the block device structure
+ *
+ * Note: The cbd_queue_stop function checks the state of each queue before attempting
+ *       to stop it. If a queue's state is not running, it will return immediately,
+ *       ensuring that only running queues are affected by this operation.
+ */
+static void cbd_blkdev_destroy_queues(struct cbd_blkdev *cbd_blkdev)
+{
+	int i;
+
+	/* Stop each queue associated with the block device */
+	for (i = 0; i < cbd_blkdev->num_queues; i++)
+		cbd_queue_stop(&cbd_blkdev->queues[i]);
+
+	/* Free the memory allocated for the queues */
+	kfree(cbd_blkdev->queues);
+}
+
+/**
+ * cbd_blkdev_create_queues - Create and initialize queues for the block device
+ * @cbd_blkdev: Pointer to the block device structure
+ * @channels: Array of channel identifiers for each queue
+ *
+ * Note: The cbd_blkdev_destroy_queues function checks the state of each queue.
+ *       Only queues that have been started will be stopped in the error path.
+ *       Therefore, any queues that were not started will not be affected.
+ */
+static int cbd_blkdev_create_queues(struct cbd_blkdev *cbd_blkdev, u32 *channels)
+{
+	int i;
+	int ret;
+	struct cbd_queue *cbdq;
+
+	cbd_blkdev->queues = kcalloc(cbd_blkdev->num_queues, sizeof(struct cbd_queue), GFP_KERNEL);
+	if (!cbd_blkdev->queues)
+		return -ENOMEM;
+
+	for (i = 0; i < cbd_blkdev->num_queues; i++) {
+		cbdq = &cbd_blkdev->queues[i];
+		cbdq->cbd_blkdev = cbd_blkdev;
+		cbdq->index = i;
+
+		ret = cbd_queue_start(cbdq, channels[i]);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	cbd_blkdev_destroy_queues(cbd_blkdev);
+	return ret;
+}
+
+static int disk_start(struct cbd_blkdev *cbd_blkdev)
+{
+	struct gendisk *disk;
+	struct queue_limits lim = {
+		.max_hw_sectors			= BIO_MAX_VECS * PAGE_SECTORS,
+		.io_min				= 4096,
+		.io_opt				= 4096,
+		.max_segments			= USHRT_MAX,
+		.max_segment_size		= UINT_MAX,
+		.discard_granularity		= 0,
+		.max_hw_discard_sectors		= 0,
+		.max_write_zeroes_sectors	= 0
+	};
+	int ret;
+
+	memset(&cbd_blkdev->tag_set, 0, sizeof(cbd_blkdev->tag_set));
+	cbd_blkdev->tag_set.ops = &cbd_mq_ops;
+	cbd_blkdev->tag_set.queue_depth = 128;
+	cbd_blkdev->tag_set.numa_node = NUMA_NO_NODE;
+	cbd_blkdev->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_NO_SCHED;
+	cbd_blkdev->tag_set.nr_hw_queues = cbd_blkdev->num_queues;
+	cbd_blkdev->tag_set.cmd_size = sizeof(struct cbd_request);
+	cbd_blkdev->tag_set.timeout = 0;
+	cbd_blkdev->tag_set.driver_data = cbd_blkdev;
+
+	ret = blk_mq_alloc_tag_set(&cbd_blkdev->tag_set);
+	if (ret) {
+		cbd_blk_err(cbd_blkdev, "failed to alloc tag set %d", ret);
+		goto err;
+	}
+
+	disk = blk_mq_alloc_disk(&cbd_blkdev->tag_set, &lim, cbd_blkdev);
+	if (IS_ERR(disk)) {
+		ret = PTR_ERR(disk);
+		cbd_blk_err(cbd_blkdev, "failed to alloc disk");
+		goto out_tag_set;
+	}
+
+	snprintf(disk->disk_name, sizeof(disk->disk_name), "cbd%d",
+		 cbd_blkdev->mapped_id);
+
+	disk->major = cbd_major;
+	disk->first_minor = cbd_blkdev->mapped_id << CBD_PART_SHIFT;
+	disk->minors = (1 << CBD_PART_SHIFT);
+	disk->fops = &cbd_bd_ops;
+	disk->private_data = cbd_blkdev;
+
+	cbd_blkdev->disk = disk;
+	cbdt_add_blkdev(cbd_blkdev->cbdt, cbd_blkdev);
+	cbd_blkdev->blkdev_info.mapped_id = cbd_blkdev->blkdev_id;
+
+	set_capacity(cbd_blkdev->disk, cbd_blkdev->dev_size);
+	set_disk_ro(cbd_blkdev->disk, false);
+
+	/* Register the disk with the system */
+	ret = add_disk(cbd_blkdev->disk);
+	if (ret)
+		goto put_disk;
+
+	/* Create a symlink to the block device */
+	ret = sysfs_create_link(&disk_to_dev(cbd_blkdev->disk)->kobj,
+				&cbd_blkdev->blkdev_dev->dev.kobj, "cbd_blkdev");
+	if (ret)
+		goto del_disk;
+
+	return 0;
+
+del_disk:
+	del_gendisk(cbd_blkdev->disk);
+put_disk:
+	put_disk(cbd_blkdev->disk);
+out_tag_set:
+	blk_mq_free_tag_set(&cbd_blkdev->tag_set);
+err:
+	return ret;
+}
+
+static void disk_stop(struct cbd_blkdev *cbd_blkdev)
+{
+	sysfs_remove_link(&disk_to_dev(cbd_blkdev->disk)->kobj, "cbd_blkdev");
+	del_gendisk(cbd_blkdev->disk);
+	put_disk(cbd_blkdev->disk);
+	blk_mq_free_tag_set(&cbd_blkdev->tag_set);
+}
+
+/**
+ * If *queues is 0, it defaults to backend_info->n_handlers, matching the backend's
+ * handler capacity.
+ */
+static int blkdev_start_validate(struct cbd_transport *cbdt, struct cbd_backend_info *backend_info,
+			     u32 backend_id, u32 *queues)
+{
+	struct cbd_blkdev_info *blkdev_info;
+	u32 backend_blkdevs = 0;
+	u32 i;
+
+	if (!backend_info || !cbd_backend_info_is_alive(backend_info)) {
+		cbdt_err(cbdt, "backend %u is not alive\n", backend_id);
+		return -EINVAL;
+	}
+
+	cbd_for_each_blkdev_info(cbdt, i, blkdev_info) {
+		if (!blkdev_info || blkdev_info->state != CBD_BLKDEV_STATE_RUNNING)
+			continue;
+
+		if (blkdev_info->backend_id == backend_id)
+			backend_blkdevs++;
+	}
+
+	if (backend_blkdevs >= CBDB_BLKDEV_COUNT_MAX) {
+		cbdt_err(cbdt, "too many(%u) blkdevs connected to backend %u.\n", backend_blkdevs, backend_id);
+		return -EBUSY;
+	}
+
+	if (*queues == 0)
+		*queues = backend_info->n_handlers;
+
+	if (*queues > backend_info->n_handlers) {
+		cbdt_err(cbdt, "invalid queues: %u, larger than backend handlers: %u\n",
+				*queues, backend_info->n_handlers);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct cbd_blkdev *blkdev_alloc(struct cbd_transport *cbdt)
+{
+	struct cbd_blkdev *cbd_blkdev;
+	int ret;
+
+	cbd_blkdev = kzalloc(sizeof(struct cbd_blkdev), GFP_KERNEL);
+	if (!cbd_blkdev)
+		return NULL;
+
+	cbd_blkdev->cbdt = cbdt;
+	mutex_init(&cbd_blkdev->lock);
+	mutex_init(&cbd_blkdev->info_lock);
+	INIT_LIST_HEAD(&cbd_blkdev->node);
+	INIT_DELAYED_WORK(&cbd_blkdev->hb_work, blkdev_hb_workfn);
+
+	ret = cbdt_get_empty_blkdev_id(cbdt, &cbd_blkdev->blkdev_id);
+	if (ret < 0)
+		goto blkdev_free;
+
+	cbd_blkdev->mapped_id = ida_simple_get(&cbd_mapped_id_ida, 0,
+					 minor_to_cbd_mapped_id(1 << MINORBITS),
+					 GFP_KERNEL);
+	if (cbd_blkdev->mapped_id < 0) {
+		ret = -ENOENT;
+		goto blkdev_free;
+	}
+
+	cbd_blkdev->task_wq = alloc_workqueue("cbdt%d-d%u",  WQ_UNBOUND | WQ_MEM_RECLAIM,
+					0, cbdt->id, cbd_blkdev->mapped_id);
+	if (!cbd_blkdev->task_wq) {
+		ret = -ENOMEM;
+		goto ida_remove;
+	}
+
+	return cbd_blkdev;
+
+ida_remove:
+	ida_simple_remove(&cbd_mapped_id_ida, cbd_blkdev->mapped_id);
+blkdev_free:
+	kfree(cbd_blkdev);
+
+	return NULL;
+}
+
+static void blkdev_free(struct cbd_blkdev *cbd_blkdev)
+{
+	drain_workqueue(cbd_blkdev->task_wq);
+	destroy_workqueue(cbd_blkdev->task_wq);
+	ida_simple_remove(&cbd_mapped_id_ida, cbd_blkdev->mapped_id);
+	kfree(cbd_blkdev);
+}
+
+static int blkdev_cache_init(struct cbd_blkdev *cbd_blkdev)
+{
+	struct cbd_transport *cbdt = cbd_blkdev->cbdt;
+	struct cbd_cache_opts cache_opts = { 0 };
+
+	cache_opts.cache_info = &cbd_blkdev->cache_info;
+	cache_opts.cache_id = cbd_blkdev->backend_id;
+	cache_opts.owner = NULL;
+	cache_opts.new_cache = false;
+	cache_opts.start_writeback = false;
+	cache_opts.start_gc = true;
+	cache_opts.init_req_keys = true;
+	cache_opts.dev_size = cbd_blkdev->dev_size;
+	cache_opts.n_paral = cbd_blkdev->num_queues;
+
+	cbd_blkdev->cbd_cache = cbd_cache_alloc(cbdt, &cache_opts);
+	if (!cbd_blkdev->cbd_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void blkdev_cache_destroy(struct cbd_blkdev *cbd_blkdev)
+{
+	if (cbd_blkdev->cbd_cache)
+		cbd_cache_destroy(cbd_blkdev->cbd_cache);
+}
+
+static int blkdev_init(struct cbd_blkdev *cbd_blkdev, struct cbd_backend_info *backend_info,
+			u32 backend_id, u32 queues)
+{
+	struct cbd_transport *cbdt = cbd_blkdev->cbdt;
+	int ret;
+
+	cbd_blkdev->backend_id = backend_id;
+	cbd_blkdev->num_queues = queues;
+	cbd_blkdev->dev_size = backend_info->dev_size;
+	cbd_blkdev->blkdev_dev = &cbdt->cbd_blkdevs_dev->blkdev_devs[cbd_blkdev->blkdev_id];
+
+	/* Get the backend if it is hosted on the same machine */
+	if (backend_info->host_id == cbdt->host->host_id)
+		cbd_blkdev->backend = cbdt_get_backend(cbdt, backend_id);
+
+	cbd_blkdev->blkdev_info.backend_id = backend_id;
+	cbd_blkdev->blkdev_info.host_id = cbdt->host->host_id;
+	cbd_blkdev->blkdev_info.state = CBD_BLKDEV_STATE_RUNNING;
+
+	ret = cbd_blkdev_create_queues(cbd_blkdev, backend_info->handler_channels);
+	if (ret < 0)
+		goto err;
+
+	if (cbd_backend_cache_on(backend_info)) {
+		ret = blkdev_cache_init(cbd_blkdev);
+		if (ret)
+			goto destroy_queues;
+	}
+
+	return 0;
+destroy_queues:
+	cbd_blkdev_destroy_queues(cbd_blkdev);
+err:
+	return ret;
+}
+
+static void blkdev_destroy(struct cbd_blkdev *cbd_blkdev)
+{
+	cancel_delayed_work_sync(&cbd_blkdev->hb_work);
+	blkdev_cache_destroy(cbd_blkdev);
+	cbd_blkdev_destroy_queues(cbd_blkdev);
+}
+
+int cbd_blkdev_start(struct cbd_transport *cbdt, u32 backend_id, u32 queues)
+{
+	struct cbd_blkdev *cbd_blkdev;
+	struct cbd_backend_info *backend_info;
+	int ret;
+
+	backend_info = cbdt_backend_info_read(cbdt, backend_id);
+	if (!backend_info) {
+		cbdt_err(cbdt, "cant read backend info for backend%u.\n", backend_id);
+		return -ENOENT;
+	}
+
+	ret = blkdev_start_validate(cbdt, backend_info, backend_id, &queues);
+	if (ret)
+		return ret;
+
+	cbd_blkdev = blkdev_alloc(cbdt);
+	if (!cbd_blkdev)
+		return -ENOMEM;
+
+	ret = blkdev_init(cbd_blkdev, backend_info, backend_id, queues);
+	if (ret)
+		goto blkdev_free;
+
+	ret = disk_start(cbd_blkdev);
+	if (ret < 0)
+		goto blkdev_destroy;
+
+	blkdev_info_write(cbd_blkdev);
+	queue_delayed_work(cbd_wq, &cbd_blkdev->hb_work, 0);
+
+	return 0;
+
+blkdev_destroy:
+	blkdev_destroy(cbd_blkdev);
+blkdev_free:
+	blkdev_free(cbd_blkdev);
+	return ret;
+}
+
+int cbd_blkdev_stop(struct cbd_transport *cbdt, u32 devid)
+{
+	struct cbd_blkdev *cbd_blkdev;
+
+	cbd_blkdev = cbdt_get_blkdev(cbdt, devid);
+	if (!cbd_blkdev)
+		return -EINVAL;
+
+	mutex_lock(&cbd_blkdev->lock);
+	if (cbd_blkdev->open_count > 0) {
+		mutex_unlock(&cbd_blkdev->lock);
+		return -EBUSY;
+	}
+
+	cbdt_del_blkdev(cbdt, cbd_blkdev);
+	mutex_unlock(&cbd_blkdev->lock);
+
+	disk_stop(cbd_blkdev);
+	blkdev_destroy(cbd_blkdev);
+	blkdev_free(cbd_blkdev);
+	cbdt_blkdev_info_clear(cbdt, devid);
+
+	return 0;
+}
+
+int cbd_blkdev_clear(struct cbd_transport *cbdt, u32 devid)
+{
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev_info = cbdt_blkdev_info_read(cbdt, devid);
+	if (!blkdev_info) {
+		cbdt_err(cbdt, "all blkdev_info in blkdev_id: %u are corrupted.\n", devid);
+		return -EINVAL;
+	}
+
+	if (cbd_blkdev_info_is_alive(blkdev_info)) {
+		cbdt_err(cbdt, "blkdev %u is still alive\n", devid);
+		return -EBUSY;
+	}
+
+	if (blkdev_info->state == CBD_BLKDEV_STATE_NONE)
+		return 0;
+
+	cbdt_blkdev_info_clear(cbdt, devid);
+
+	return 0;
+}
+
+int cbd_blkdev_init(void)
+{
+	cbd_major = register_blkdev(0, "cbd");
+	if (cbd_major < 0)
+		return cbd_major;
+
+	return 0;
+}
+
+void cbd_blkdev_exit(void)
+{
+	unregister_blkdev(cbd_major, "cbd");
+}
diff --git a/drivers/block/cbd/cbd_blkdev.h b/drivers/block/cbd/cbd_blkdev.h
new file mode 100644
index 000000000000..5fd54e555abc
--- /dev/null
+++ b/drivers/block/cbd/cbd_blkdev.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_BLKDEV_H
+#define _CBD_BLKDEV_H
+
+#include <linux/blk-mq.h>
+
+#include "cbd_internal.h"
+#include "cbd_transport.h"
+#include "cbd_channel.h"
+#include "cbd_cache/cbd_cache.h"
+#include "cbd_handler.h"
+#include "cbd_backend.h"
+#include "cbd_queue.h"
+
+#define cbd_blk_err(dev, fmt, ...)						\
+	cbdt_err(dev->cbdt, "cbd%d: " fmt,					\
+		 dev->mapped_id, ##__VA_ARGS__)
+#define cbd_blk_info(dev, fmt, ...)						\
+	cbdt_info(dev->cbdt, "cbd%d: " fmt,					\
+		 dev->mapped_id, ##__VA_ARGS__)
+#define cbd_blk_debug(dev, fmt, ...)						\
+	cbdt_debug(dev->cbdt, "cbd%d: " fmt,					\
+		 dev->mapped_id, ##__VA_ARGS__)
+
+/* cbd_blkdev */
+CBD_DEVICE(blkdev);
+
+#define CBD_BLKDEV_STATE_NONE		0
+#define CBD_BLKDEV_STATE_RUNNING	1
+
+struct cbd_blkdev_info {
+	struct cbd_meta_header meta_header;
+	u8	state;
+	u64	alive_ts;
+	u32	backend_id;
+	u32	host_id;
+	u32	mapped_id;
+};
+
+struct cbd_blkdev {
+	u32			blkdev_id; /* index in transport blkdev area */
+	u32			backend_id;
+	int			mapped_id; /* id in block device such as: /dev/cbd0 */
+
+	struct cbd_backend	*backend; /* reference to backend if blkdev and backend on the same host */
+
+	int			major;		/* blkdev assigned major */
+	int			minor;
+	struct gendisk		*disk;		/* blkdev's gendisk and rq */
+
+	struct mutex		lock;
+	unsigned long		open_count;	/* protected by lock */
+
+	struct list_head	node;
+	struct delayed_work	hb_work; /* heartbeat work */
+
+	/* Block layer tags. */
+	struct blk_mq_tag_set	tag_set;
+
+	uint32_t		num_queues;
+	struct cbd_queue	*queues;
+
+	u64			dev_size;
+
+	struct workqueue_struct	*task_wq;
+
+	struct cbd_blkdev_device *blkdev_dev;
+	struct cbd_blkdev_info	blkdev_info;
+	struct mutex		info_lock;
+
+	struct cbd_transport *cbdt;
+
+	struct cbd_cache_info	cache_info;
+	struct cbd_cache	*cbd_cache;
+};
+
+int cbd_blkdev_init(void);
+void cbd_blkdev_exit(void);
+int cbd_blkdev_start(struct cbd_transport *cbdt, u32 backend_id, u32 queues);
+int cbd_blkdev_stop(struct cbd_transport *cbdt, u32 devid);
+int cbd_blkdev_clear(struct cbd_transport *cbdt, u32 devid);
+bool cbd_blkdev_info_is_alive(struct cbd_blkdev_info *info);
+
+extern struct workqueue_struct	*cbd_wq;
+
+#define cbd_for_each_blkdev_info(cbdt, i, blkdev_info)					\
+	for (i = 0;									\
+	     i < cbdt->transport_info.blkdev_num &&					\
+	     (blkdev_info = cbdt_blkdev_info_read(cbdt, i));				\
+	     i++)
+
+#endif /* _CBD_BLKDEV_H */
diff --git a/drivers/block/cbd/cbd_queue.c b/drivers/block/cbd/cbd_queue.c
new file mode 100644
index 000000000000..c80dccfe3719
--- /dev/null
+++ b/drivers/block/cbd/cbd_queue.c
@@ -0,0 +1,516 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cbd_queue.h"
+
+/**
+ * end_req - Finalize a CBD request and handle its completion.
+ * @ref: Pointer to the kref structure that manages the reference count of the CBD request.
+ *
+ * This function is called when the reference count of the cbd_request reaches zero. It
+ * contains two key operations:
+ *
+ * (1) If the end_req callback is set in the cbd_request, this callback will be invoked.
+ *     This allows different cbd_requests to perform specific operations upon completion.
+ *     For example, in the case of a backend request sent in the cache miss reading, it may require
+ *     cache-related operations, such as storing data retrieved during a miss read.
+ *
+ * (2) If cbd_req->req is not NULL, it indicates that this cbd_request corresponds to a
+ *     block layer request. The function will finalize the block layer request accordingly.
+ */
+static void end_req(struct kref *ref)
+{
+	struct cbd_request *cbd_req = container_of(ref, struct cbd_request, ref);
+	struct request *req = cbd_req->req;
+	int ret = cbd_req->ret;
+
+	/* Call the end_req callback if it is set */
+	if (cbd_req->end_req)
+		cbd_req->end_req(cbd_req, cbd_req->priv_data);
+
+	if (req) {
+		/* Complete the block layer request based on the return status */
+		if (ret == -ENOMEM || ret == -EBUSY)
+			blk_mq_requeue_request(req, true);
+		else
+			blk_mq_end_request(req, errno_to_blk_status(ret));
+	}
+}
+
+void cbd_req_get(struct cbd_request *cbd_req)
+{
+	kref_get(&cbd_req->ref);
+}
+
+/**
+ * This function decreases the reference count of the specified cbd_request. If the
+ * reference count reaches zero, the end_req function is called to finalize the request.
+ * Additionally, if the cbd_request has a parent and if the current request is being
+ * finalized (i.e., the reference count reaches zero), the parent request will also
+ * be put, potentially propagating the return status up the hierarchy.
+ */
+void cbd_req_put(struct cbd_request *cbd_req, int ret)
+{
+	struct cbd_request *parent = cbd_req->parent;
+
+	/* Set the return status if it is not already set */
+	if (ret && !cbd_req->ret)
+		cbd_req->ret = ret;
+
+	/* Decrease the reference count and finalize the request if it reaches zero */
+	if (kref_put(&cbd_req->ref, end_req) && parent)
+		cbd_req_put(parent, ret);
+}
+
+/**
+ * When a submission entry is completed, it is marked with the CBD_SE_FLAGS_DONE flag.
+ * If the entry is the oldest one in the submission queue, the tail of the submission ring
+ * can be advanced. If it is not the oldest, the function will wait until all previous
+ * entries have been completed before advancing the tail.
+ */
+static void advance_subm_ring(struct cbd_queue *cbdq)
+{
+	struct cbd_se *se;
+again:
+	se = get_oldest_se(cbdq);
+	if (!se)
+		goto out;
+
+	if (cbd_se_flags_test(se, CBD_SE_FLAGS_DONE)) {
+		cbdc_submr_tail_advance(&cbdq->channel, sizeof(struct cbd_se));
+		goto again;
+	}
+out:
+	return;
+}
+
+/**
+ * This function checks if the specified data offset corresponds to the current
+ * data tail. If it does, the function releases the corresponding extent by
+ * setting the value in the released_extents array to zero and advances the
+ * data tail by the specified length. The data tail is wrapped around if it
+ * exceeds the channel's data size.
+ */
+static bool __advance_data_tail(struct cbd_queue *cbdq, u32 data_off, u32 data_len)
+{
+	if (data_off == cbdq->channel.data_tail) {
+		cbdq->released_extents[data_off / PAGE_SIZE] = 0;
+		cbdq->channel.data_tail += data_len;
+		cbdq->channel.data_tail %= cbdq->channel.data_size;
+		return true;
+	}
+
+	return false;
+}
+
+/**
+ * This function attempts to advance the data tail in the CBD queue by processing
+ * the released extents. It first normalizes the data offset with respect to the
+ * channel's data size. It then marks the released extent and attempts to advance
+ * the data tail by repeatedly checking if the next extent can be released.
+ */
+static void advance_data_tail(struct cbd_queue *cbdq, u32 data_off, u32 data_len)
+{
+	data_off %= cbdq->channel.data_size;
+	cbdq->released_extents[data_off / PAGE_SIZE] = data_len;
+
+	while (__advance_data_tail(cbdq, data_off, data_len)) {
+		data_off += data_len;
+		data_off %= cbdq->channel.data_size;
+		data_len = cbdq->released_extents[data_off / PAGE_SIZE];
+		/*
+		 * if data_len in released_extents is zero, means this extent is not released,
+		 * break and wait it to be released.
+		 */
+		if (!data_len)
+			break;
+	}
+}
+
+void cbd_queue_advance(struct cbd_queue *cbdq, struct cbd_request *cbd_req)
+{
+	spin_lock(&cbdq->channel.submr_lock);
+	advance_subm_ring(cbdq);
+
+	if (!cbd_req_nodata(cbd_req) && cbd_req->data_len)
+		advance_data_tail(cbdq, cbd_req->data_off, round_up(cbd_req->data_len, PAGE_SIZE));
+	spin_unlock(&cbdq->channel.submr_lock);
+}
+
+static int queue_ce_verify(struct cbd_queue *cbdq, struct cbd_request *cbd_req,
+			   struct cbd_ce *ce)
+{
+#ifdef CONFIG_CBD_CHANNEL_CRC
+	if (ce->ce_crc != cbd_ce_crc(ce)) {
+		cbd_queue_err(cbdq, "ce crc bad 0x%x != 0x%x(expected)",
+				cbd_ce_crc(ce), ce->ce_crc);
+		return -EIO;
+	}
+#endif
+
+#ifdef CONFIG_CBD_CHANNEL_DATA_CRC
+	if (cbd_req->op == CBD_OP_READ &&
+		ce->data_crc != cbd_channel_crc(&cbdq->channel,
+					       cbd_req->data_off,
+					       cbd_req->data_len)) {
+		cbd_queue_err(cbdq, "ce data_crc bad 0x%x != 0x%x(expected)",
+				cbd_channel_crc(&cbdq->channel,
+						cbd_req->data_off,
+						cbd_req->data_len),
+				ce->data_crc);
+		return -EIO;
+	}
+#endif
+	return 0;
+}
+
+static int complete_miss(struct cbd_queue *cbdq)
+{
+	if (cbdwc_need_retry(&cbdq->complete_worker_cfg))
+		return -EAGAIN;
+
+	if (inflight_reqs_empty(cbdq)) {
+		cbdwc_init(&cbdq->complete_worker_cfg);
+		goto out;
+	}
+
+	cbdwc_miss(&cbdq->complete_worker_cfg);
+
+	cpu_relax();
+	queue_delayed_work(cbdq->cbd_blkdev->task_wq, &cbdq->complete_work, 0);
+out:
+	return 0;
+}
+
+static void complete_work_fn(struct work_struct *work)
+{
+	struct cbd_queue *cbdq = container_of(work, struct cbd_queue, complete_work.work);
+	struct cbd_request *cbd_req;
+	struct cbd_ce *ce;
+	int ret;
+again:
+	/* compr_head would be updated by backend handler */
+	spin_lock(&cbdq->channel.compr_lock);
+	ce = get_complete_entry(cbdq);
+	spin_unlock(&cbdq->channel.compr_lock);
+	if (!ce)
+		goto miss;
+
+	cbd_req = find_inflight_req(cbdq, ce->req_tid);
+	if (!cbd_req) {
+		cbd_queue_err(cbdq, "inflight request not found: %llu.", ce->req_tid);
+		goto miss;
+	}
+
+	ret = queue_ce_verify(cbdq, cbd_req, ce);
+	if (ret)
+		goto miss;
+
+	cbdwc_hit(&cbdq->complete_worker_cfg);
+	cbdc_compr_tail_advance(&cbdq->channel, sizeof(struct cbd_ce));
+	complete_inflight_req(cbdq, cbd_req, ce->result);
+	goto again;
+miss:
+	ret = complete_miss(cbdq);
+	/* -EAGAIN means we need retry according to the complete_worker_cfg */
+	if (ret == -EAGAIN)
+		goto again;
+}
+
+static void cbd_req_init(struct cbd_queue *cbdq, u8 op, struct request *rq)
+{
+	struct cbd_request *cbd_req = blk_mq_rq_to_pdu(rq);
+
+	cbd_req->req = rq;
+	cbd_req->cbdq = cbdq;
+	cbd_req->op = op;
+
+	if (!cbd_req_nodata(cbd_req))
+		cbd_req->data_len = blk_rq_bytes(rq);
+	else
+		cbd_req->data_len = 0;
+
+	cbd_req->bio = rq->bio;
+	cbd_req->off = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
+}
+
+static void queue_req_se_init(struct cbd_request *cbd_req)
+{
+	struct cbd_se	*se;
+	u64 offset = cbd_req->off;
+	u32 length = cbd_req->data_len;
+
+	se = get_submit_entry(cbd_req->cbdq);
+	memset(se, 0, sizeof(struct cbd_se));
+
+	se->op = cbd_req->op;
+	se->req_tid = cbd_req->req_tid;
+	se->offset = offset;
+	se->len = length;
+
+	if (!cbd_req_nodata(cbd_req)) {
+		se->data_off = cbd_req->cbdq->channel.data_head;
+		se->data_len = length;
+	}
+	cbd_req->se = se;
+}
+
+static void cbd_req_crc_init(struct cbd_request *cbd_req)
+{
+#ifdef CONFIG_CBD_CHANNEL_DATA_CRC
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+
+	if (cbd_req->op == CBD_OP_WRITE)
+		cbd_req->se->data_crc = cbd_channel_crc(&cbdq->channel,
+					       cbd_req->data_off,
+					       cbd_req->data_len);
+#endif
+
+#ifdef CONFIG_CBD_CHANNEL_CRC
+	cbd_req->se->se_crc = cbd_se_crc(cbd_req->se);
+#endif
+}
+
+static void queue_req_channel_init(struct cbd_request *cbd_req)
+{
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+	struct bio *bio = cbd_req->bio;
+
+	cbd_req->req_tid = cbdq->req_tid++;
+	queue_req_se_init(cbd_req);
+
+	if (cbd_req_nodata(cbd_req))
+		goto crc_init;
+
+	cbd_req->data_off = cbdq->channel.data_head;
+	if (cbd_req->op == CBD_OP_WRITE)
+		cbdc_copy_from_bio(&cbdq->channel, cbd_req->data_off,
+				   cbd_req->data_len, bio, cbd_req->bio_off);
+
+	cbdq->channel.data_head = round_up(cbdq->channel.data_head + cbd_req->data_len, PAGE_SIZE);
+	cbdq->channel.data_head %= cbdq->channel.data_size;
+crc_init:
+	cbd_req_crc_init(cbd_req);
+}
+
+int cbd_queue_req_to_backend(struct cbd_request *cbd_req)
+{
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+	int ret;
+
+	spin_lock(&cbdq->channel.submr_lock);
+	/* Check if the submission ring is full or if there is enough data space */
+	if (submit_ring_full(cbdq) ||
+			!data_space_enough(cbdq, cbd_req)) {
+		spin_unlock(&cbdq->channel.submr_lock);
+		cbd_req->data_len = 0;
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Get a reference before submission, it will be put in cbd_req completion */
+	cbd_req_get(cbd_req);
+
+	inflight_add_req(cbdq, cbd_req);
+	queue_req_channel_init(cbd_req);
+
+	cbdc_submr_head_advance(&cbdq->channel, sizeof(struct cbd_se));
+	spin_unlock(&cbdq->channel.submr_lock);
+
+	if (cbdq->cbd_blkdev->backend)
+		cbd_backend_notify(cbdq->cbd_blkdev->backend, cbdq->channel.seg_id);
+	queue_delayed_work(cbdq->cbd_blkdev->task_wq, &cbdq->complete_work, 0);
+
+	return 0;
+err:
+	return ret;
+}
+
+static void queue_req_end_req(struct cbd_request *cbd_req, void *priv_data)
+{
+	cbd_queue_advance(cbd_req->cbdq, cbd_req);
+}
+
+static void cbd_queue_req(struct cbd_queue *cbdq, struct cbd_request *cbd_req)
+{
+	int ret;
+
+	if (cbdq->cbd_blkdev->cbd_cache) {
+		ret = cbd_cache_handle_req(cbdq->cbd_blkdev->cbd_cache, cbd_req);
+		goto end;
+	}
+	cbd_req->end_req = queue_req_end_req;
+	ret = cbd_queue_req_to_backend(cbd_req);
+end:
+	cbd_req_put(cbd_req, ret);
+}
+
+static blk_status_t cbd_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct request *req = bd->rq;
+	struct cbd_queue *cbdq = hctx->driver_data;
+	struct cbd_request *cbd_req = blk_mq_rq_to_pdu(bd->rq);
+
+	memset(cbd_req, 0, sizeof(struct cbd_request));
+	INIT_LIST_HEAD(&cbd_req->inflight_reqs_node);
+	kref_init(&cbd_req->ref);
+	spin_lock_init(&cbd_req->lock);
+
+	blk_mq_start_request(bd->rq);
+
+	switch (req_op(bd->rq)) {
+	case REQ_OP_FLUSH:
+		cbd_req_init(cbdq, CBD_OP_FLUSH, req);
+		break;
+	case REQ_OP_WRITE:
+		cbd_req_init(cbdq, CBD_OP_WRITE, req);
+		break;
+	case REQ_OP_READ:
+		cbd_req_init(cbdq, CBD_OP_READ, req);
+		break;
+	default:
+		return BLK_STS_IOERR;
+	}
+
+	cbd_queue_req(cbdq, cbd_req);
+
+	return BLK_STS_OK;
+}
+
+static int cbd_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
+			unsigned int hctx_idx)
+{
+	struct cbd_blkdev *cbd_blkdev = driver_data;
+	struct cbd_queue *cbdq;
+
+	cbdq = &cbd_blkdev->queues[hctx_idx];
+	hctx->driver_data = cbdq;
+
+	return 0;
+}
+
+const struct blk_mq_ops cbd_mq_ops = {
+	.queue_rq	= cbd_queue_rq,
+	.init_hctx	= cbd_init_hctx,
+};
+
+#define CBDQ_RESET_CHANNEL_WAIT_INTERVAL	(HZ / 10)
+#define CBDQ_RESET_CHANNEL_WAIT_COUNT		300
+
+/**
+ * queue_reset_channel - Sends a reset command to the management layer for a cbd_queue.
+ * @cbdq: Pointer to the cbd_queue structure to be reset.
+ *
+ * This function initiates a channel reset by sending a management command to the
+ * corresponding channel control structure. It waits for the reset operation to
+ * complete, polling the status and allowing for a timeout to avoid indefinite blocking.
+ *
+ * Returns 0 on success, or a negative error code on failure (e.g., -ETIMEDOUT).
+ */
+static int queue_reset_channel(struct cbd_queue *cbdq)
+{
+	u8 cmd_ret;
+	u16 count = 0;
+	int ret;
+
+	ret = cbdc_mgmt_cmd_op_send(cbdq->channel_ctrl, CBDC_MGMT_CMD_RESET);
+	if (ret) {
+		cbd_queue_err(cbdq, "send reset mgmt cmd error: %d\n", ret);
+		return ret;
+	}
+
+	if (cbdq->cbd_blkdev->backend)
+		cbd_backend_mgmt_notify(cbdq->cbd_blkdev->backend, cbdq->channel.seg_id);
+
+	while (true) {
+		if (cbdc_mgmt_completed(cbdq->channel_ctrl))
+			break;
+
+		if (count++ > CBDQ_RESET_CHANNEL_WAIT_COUNT) {
+			ret = -ETIMEDOUT;
+			goto err;
+		}
+		schedule_timeout_uninterruptible(CBDQ_RESET_CHANNEL_WAIT_INTERVAL);
+	}
+	cmd_ret = cbdc_mgmt_cmd_ret_get(cbdq->channel_ctrl);
+	return cbdc_mgmt_cmd_ret_to_errno(cmd_ret);
+err:
+	return ret;
+}
+
+static int queue_channel_init(struct cbd_queue *cbdq, u32 channel_id)
+{
+	struct cbd_blkdev *cbd_blkdev = cbdq->cbd_blkdev;
+	struct cbd_transport *cbdt = cbd_blkdev->cbdt;
+	struct cbd_channel_init_options init_opts = { 0 };
+	int ret;
+
+	init_opts.cbdt = cbdt;
+	init_opts.backend_id = cbdq->cbd_blkdev->backend_id;
+	init_opts.seg_id = channel_id;
+	init_opts.new_channel = false;
+	ret = cbd_channel_init(&cbdq->channel, &init_opts);
+	if (ret)
+		return ret;
+
+	cbdq->channel_ctrl = cbdq->channel.ctrl;
+	if (!cbd_blkdev->backend)
+		cbd_channel_flags_set_bit(cbdq->channel_ctrl, CBDC_FLAGS_POLLING);
+
+	ret = queue_reset_channel(cbdq);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int queue_init(struct cbd_queue *cbdq, u32 channel_id)
+{
+	int ret;
+
+	INIT_LIST_HEAD(&cbdq->inflight_reqs);
+	spin_lock_init(&cbdq->inflight_reqs_lock);
+	cbdq->req_tid = 0;
+	INIT_DELAYED_WORK(&cbdq->complete_work, complete_work_fn);
+	cbdwc_init(&cbdq->complete_worker_cfg);
+
+	ret = queue_channel_init(cbdq, channel_id);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int cbd_queue_start(struct cbd_queue *cbdq, u32 channel_id)
+{
+	int ret;
+
+	cbdq->released_extents = kzalloc(sizeof(u64) * (CBDC_DATA_SIZE >> PAGE_SHIFT),
+					 GFP_KERNEL);
+	if (!cbdq->released_extents) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = queue_init(cbdq, channel_id);
+	if (ret)
+		goto free_extents;
+
+	atomic_set(&cbdq->state, cbd_queue_state_running);
+
+	return 0;
+
+free_extents:
+	kfree(cbdq->released_extents);
+out:
+	return ret;
+}
+
+void cbd_queue_stop(struct cbd_queue *cbdq)
+{
+	if (atomic_read(&cbdq->state) != cbd_queue_state_running)
+		return;
+
+	cancel_delayed_work_sync(&cbdq->complete_work);
+	kfree(cbdq->released_extents);
+}
diff --git a/drivers/block/cbd/cbd_queue.h b/drivers/block/cbd/cbd_queue.h
new file mode 100644
index 000000000000..6f774ceb57f9
--- /dev/null
+++ b/drivers/block/cbd/cbd_queue.h
@@ -0,0 +1,288 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_QUEUE_H
+#define _CBD_QUEUE_H
+
+#include "cbd_channel.h"
+#include "cbd_blkdev.h"
+
+#define cbd_queue_err(queue, fmt, ...)						\
+	cbd_blk_err(queue->cbd_blkdev, "queue%d: " fmt,				\
+		     queue->channel.seg_id, ##__VA_ARGS__)
+#define cbd_queue_info(queue, fmt, ...)						\
+	cbd_blk_info(queue->cbd_blkdev, "queue%d: " fmt,			\
+		     queue->channel.seg_id, ##__VA_ARGS__)
+#define cbd_queue_debug(queue, fmt, ...)					\
+	cbd_blk_debug(queue->cbd_blkdev, "queue%d: " fmt,			\
+		     queue->channel.seg_id, ##__VA_ARGS__)
+
+struct cbd_request {
+	struct cbd_queue	*cbdq;
+
+	struct cbd_se		*se;
+	struct cbd_ce		*ce;
+	struct request		*req;
+
+	u64			off;
+	struct bio		*bio;
+	u32			bio_off;
+	spinlock_t		lock; /* race between cache and complete_work to access bio */
+
+	u8			op;
+	u64			req_tid;
+	struct list_head	inflight_reqs_node;
+
+	u32			data_off;
+	u32			data_len;
+
+	struct work_struct	work;
+
+	struct kref		ref;
+	int			ret;
+	struct cbd_request	*parent;
+
+	void			*priv_data;
+	void (*end_req)(struct cbd_request *cbd_req, void *priv_data);
+};
+
+struct cbd_cache_req {
+	struct cbd_cache	*cache;
+	u8			op;
+	struct work_struct	work;
+};
+
+#define CBD_SE_FLAGS_DONE	1
+
+static inline bool cbd_se_flags_test(struct cbd_se *se, u32 bit)
+{
+	return (se->flags & bit);
+}
+
+static inline void cbd_se_flags_set(struct cbd_se *se, u32 bit)
+{
+	se->flags |= bit;
+}
+
+enum cbd_queue_state {
+	cbd_queue_state_none    = 0,
+	cbd_queue_state_running
+};
+
+struct cbd_queue {
+	struct cbd_blkdev	*cbd_blkdev;
+	u32			index;
+	struct list_head	inflight_reqs;
+	spinlock_t		inflight_reqs_lock;
+	u64			req_tid;
+
+	u64			*released_extents;
+
+	struct cbd_channel_seg_info	*channel_info;
+	struct cbd_channel	channel;
+	struct cbd_channel_ctrl	*channel_ctrl;
+
+	atomic_t                state;
+
+	struct delayed_work	complete_work;
+	struct cbd_worker_cfg	complete_worker_cfg;
+};
+
+int cbd_queue_start(struct cbd_queue *cbdq, u32 channel_id);
+void cbd_queue_stop(struct cbd_queue *cbdq);
+extern const struct blk_mq_ops cbd_mq_ops;
+int cbd_queue_req_to_backend(struct cbd_request *cbd_req);
+void cbd_req_get(struct cbd_request *cbd_req);
+void cbd_req_put(struct cbd_request *cbd_req, int ret);
+void cbd_queue_advance(struct cbd_queue *cbdq, struct cbd_request *cbd_req);
+
+static inline struct cbd_se *get_submit_entry(struct cbd_queue *cbdq)
+{
+	return (struct cbd_se *)(cbdq->channel.submr + cbdc_submr_head_get(&cbdq->channel));
+}
+
+static inline struct cbd_se *get_oldest_se(struct cbd_queue *cbdq)
+{
+	if (cbdc_submr_tail_get(&cbdq->channel) == cbdc_submr_head_get(&cbdq->channel))
+		return NULL;
+
+	return (struct cbd_se *)(cbdq->channel.submr + cbdc_submr_tail_get(&cbdq->channel));
+}
+
+static inline bool queue_subm_ring_empty(struct cbd_queue *cbdq)
+{
+	return (cbdc_submr_tail_get(&cbdq->channel) == cbdc_submr_head_get(&cbdq->channel));
+}
+
+static inline struct cbd_ce *get_complete_entry(struct cbd_queue *cbdq)
+{
+	u32 ce_head = cbdc_compr_head_get(&cbdq->channel);
+
+	if (unlikely(ce_head > (cbdq->channel.compr_size - sizeof(struct cbd_ce))))
+		return NULL;
+
+	if (cbdc_compr_tail_get(&cbdq->channel) == cbdc_compr_head_get(&cbdq->channel))
+		return NULL;
+
+	return (struct cbd_ce *)(cbdq->channel.compr + cbdc_compr_tail_get(&cbdq->channel));
+}
+
+static inline bool cbd_req_nodata(struct cbd_request *cbd_req)
+{
+	switch (cbd_req->op) {
+	case CBD_OP_WRITE:
+	case CBD_OP_READ:
+		return false;
+	case CBD_OP_FLUSH:
+		return true;
+	default:
+		BUG();
+	}
+}
+
+static inline int copy_data_from_cbdreq(struct cbd_request *cbd_req)
+{
+	struct bio *bio = cbd_req->bio;
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+	int ret;
+
+	spin_lock(&cbd_req->lock);
+	ret = cbdc_copy_to_bio(&cbdq->channel, cbd_req->data_off, cbd_req->data_len, bio, cbd_req->bio_off);
+	spin_unlock(&cbd_req->lock);
+
+	return ret;
+}
+
+static inline bool inflight_reqs_empty(struct cbd_queue *cbdq)
+{
+	bool empty;
+
+	spin_lock(&cbdq->inflight_reqs_lock);
+	empty = list_empty(&cbdq->inflight_reqs);
+	spin_unlock(&cbdq->inflight_reqs_lock);
+
+	return empty;
+}
+
+static inline void inflight_add_req(struct cbd_queue *cbdq, struct cbd_request *cbd_req)
+{
+	spin_lock(&cbdq->inflight_reqs_lock);
+	list_add_tail(&cbd_req->inflight_reqs_node, &cbdq->inflight_reqs);
+	spin_unlock(&cbdq->inflight_reqs_lock);
+}
+
+static inline void complete_inflight_req(struct cbd_queue *cbdq, struct cbd_request *cbd_req, int ret)
+{
+	if (cbd_req->op == CBD_OP_READ) {
+		int copy_ret = 0;
+
+		spin_lock(&cbdq->channel.submr_lock);
+		copy_ret = copy_data_from_cbdreq(cbd_req);
+		spin_unlock(&cbdq->channel.submr_lock);
+
+		if (!ret && copy_ret)
+			ret = copy_ret;
+	}
+
+	spin_lock(&cbdq->inflight_reqs_lock);
+	list_del_init(&cbd_req->inflight_reqs_node);
+	spin_unlock(&cbdq->inflight_reqs_lock);
+
+	cbd_se_flags_set(cbd_req->se, CBD_SE_FLAGS_DONE);
+	cbd_req_put(cbd_req, ret);
+}
+
+static inline struct cbd_request *find_inflight_req(struct cbd_queue *cbdq, u64 req_tid)
+{
+	struct cbd_request *req;
+	bool found = false;
+
+	spin_lock(&cbdq->inflight_reqs_lock);
+	list_for_each_entry(req, &cbdq->inflight_reqs, inflight_reqs_node) {
+		if (req->req_tid == req_tid) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&cbdq->inflight_reqs_lock);
+
+	if (found)
+		return req;
+
+	return NULL;
+}
+
+/**
+ * data_space_enough - Check if there is sufficient data space available in the cbd_queue.
+ * @cbdq: Pointer to the cbd_queue structure to check space in.
+ * @cbd_req: Pointer to the cbd_request structure for which space is needed.
+ *
+ * This function evaluates whether the cbd_queue has enough available data space
+ * to accommodate the data length required by the given cbd_request.
+ *
+ * The available space is calculated based on the current positions of the data_head
+ * and data_tail. If data_head is ahead of data_tail, it indicates that the space
+ * wraps around; otherwise, it calculates the space linearly.
+ *
+ * The space needed is rounded up according to the defined data alignment.
+ *
+ * If the available space minus the reserved space is less than the required space,
+ * the function returns false, indicating insufficient space. Otherwise, it returns true.
+ */
+static inline bool data_space_enough(struct cbd_queue *cbdq, struct cbd_request *cbd_req)
+{
+	struct cbd_channel *channel = &cbdq->channel;
+	u32 space_available = channel->data_size;
+	u32 space_needed;
+
+	if (channel->data_head > channel->data_tail) {
+		space_available = channel->data_size - channel->data_head;
+		space_available += channel->data_tail;
+	} else if (channel->data_head < channel->data_tail) {
+		space_available = channel->data_tail - channel->data_head;
+	}
+
+	space_needed = round_up(cbd_req->data_len, CBDC_DATA_ALIGN);
+
+	if (space_available - CBDC_DATA_RESERVED < space_needed)
+		return false;
+
+	return true;
+}
+
+/**
+ * submit_ring_full - Check if the submission ring is full.
+ * @cbdq: Pointer to the cbd_queue structure representing the submission queue.
+ *
+ * This function determines whether the submission ring buffer for the cbd_queue
+ * has enough available space to accept new entries.
+ *
+ * The available space is calculated based on the current positions of the
+ * submission ring head and tail. If the head is ahead of the tail, it indicates
+ * that the ring wraps around; otherwise, the available space is calculated
+ * linearly.
+ *
+ * A reserved space is maintained at the end of the ring to prevent it from
+ * becoming completely filled, ensuring that there is always some space available
+ * for processing. If the available space minus the reserved space is less than
+ * the size of a submission entry (cbd_se), the function returns true, indicating
+ * the ring is full. Otherwise, it returns false.
+ */
+static inline bool submit_ring_full(struct cbd_queue *cbdq)
+{
+	u32 space_available = cbdq->channel.submr_size;
+	struct cbd_channel *channel = &cbdq->channel;
+
+	if (cbdc_submr_head_get(channel) > cbdc_submr_tail_get(channel)) {
+		space_available = cbdq->channel.submr_size - cbdc_submr_head_get(channel);
+		space_available += cbdc_submr_tail_get(channel);
+	} else if (cbdc_submr_head_get(channel) < cbdc_submr_tail_get(channel)) {
+		space_available = cbdc_submr_tail_get(channel) - cbdc_submr_head_get(channel);
+	}
+
+	/* There is a SUBMR_RESERVED we dont use to prevent the ring to be used up */
+	if (space_available - CBDC_SUBMR_RESERVED < sizeof(struct cbd_se))
+		return true;
+
+	return false;
+}
+
+#endif /* _CBD_QUEUE_H */
-- 
2.34.1



Return-Path: <linux-bcache+bounces-724-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 533D097BABD
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 12:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78A491C21960
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 10:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EBD18990D;
	Wed, 18 Sep 2024 10:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eJNEcFQL"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16587189900
	for <linux-bcache@vger.kernel.org>; Wed, 18 Sep 2024 10:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726654756; cv=none; b=fCj3DQJZroSU+tnyucH8/OPApFSwvFAtkOxbofPa47jmFzwgQeTfSAyBJmE36ykuMOiQz7wOUCGw+qUa+mo+puyY4ahPOx6olpeCc6UxQpgx2lPS15zZ7tXH8ngA0/sc1tB1syqolb1zBHA8GVM2ejLiza921ULfcdU9UP0Ssz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726654756; c=relaxed/simple;
	bh=BaUGCto9vs8oFFeaBFeumiYxEaC+cI0sNS72mCFbL4c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o9+qkKY/c4u7wkhPNFmmgCrfuxooPzSdhkiv4MQImCsnU4E72yyh96D8augRnldPM37P2ghTa89aKEFERBcNlT6iweCYCx9YgoaTKqzEBLOoukgMZZH7ueYxXz1KsIWq9qVFY3oIbKqHJzDQOrcPSelbpNGFYL96oTB+/OzORuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eJNEcFQL; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726654751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W1Gtd6ScgTrJJmOdkTMe2oKtbid4lctcDodxd4qiA3I=;
	b=eJNEcFQLFvjjY7KxtUWbts+lI1tq4qCiD/LxDrmdnbBlSvQRi8WKAgSXEyLFAT1mP+eoIE
	rKYYuWenAMd5dIURS8RuoGmaCN3z7DRU3Q4PVz/aDm2KMSN2MoJaGhU4dT5VJEmg2rBeHo
	WOUuHkHTTebUi5k614JXjMl7PqtKvYA=
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
Subject: [PATCH v2 6/8] cbd: introduce cbd_blkdev
Date: Wed, 18 Sep 2024 10:18:19 +0000
Message-Id: <20240918101821.681118-7-dongsheng.yang@linux.dev>
In-Reply-To: <20240918101821.681118-1-dongsheng.yang@linux.dev>
References: <20240918101821.681118-1-dongsheng.yang@linux.dev>
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

cbd_blkdev allow user to force stop a /dev/cbdX, even if backend is not
responsible.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_blkdev.c | 433 +++++++++++++++++++++++++
 drivers/block/cbd/cbd_queue.c  | 574 +++++++++++++++++++++++++++++++++
 2 files changed, 1007 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_blkdev.c
 create mode 100644 drivers/block/cbd/cbd_queue.c

diff --git a/drivers/block/cbd/cbd_blkdev.c b/drivers/block/cbd/cbd_blkdev.c
new file mode 100644
index 000000000000..f16bc429704b
--- /dev/null
+++ b/drivers/block/cbd/cbd_blkdev.c
@@ -0,0 +1,433 @@
+#include "cbd_internal.h"
+
+static ssize_t blkdev_backend_id_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_blkdev_device *blkdev;
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev = container_of(dev, struct cbd_blkdev_device, dev);
+	blkdev_info = blkdev->blkdev_info;
+
+	if (blkdev_info->state == cbd_blkdev_state_none)
+		return 0;
+
+	return sprintf(buf, "%u\n", blkdev_info->backend_id);
+}
+
+static DEVICE_ATTR(backend_id, 0400, blkdev_backend_id_show, NULL);
+
+static ssize_t blkdev_host_id_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_blkdev_device *blkdev;
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev = container_of(dev, struct cbd_blkdev_device, dev);
+	blkdev_info = blkdev->blkdev_info;
+
+	if (blkdev_info->state == cbd_blkdev_state_none)
+		return 0;
+
+	return sprintf(buf, "%u\n", blkdev_info->host_id);
+}
+
+static DEVICE_ATTR(host_id, 0400, blkdev_host_id_show, NULL);
+
+static ssize_t blkdev_mapped_id_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_blkdev_device *blkdev;
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev = container_of(dev, struct cbd_blkdev_device, dev);
+	blkdev_info = blkdev->blkdev_info;
+
+	if (blkdev_info->state == cbd_blkdev_state_none)
+		return 0;
+
+	return sprintf(buf, "%u\n", blkdev_info->mapped_id);
+}
+
+static DEVICE_ATTR(mapped_id, 0400, blkdev_mapped_id_show, NULL);
+
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
+static void cbd_blkdev_stop_queues(struct cbd_blkdev *cbd_blkdev)
+{
+	int i;
+
+	for (i = 0; i < cbd_blkdev->num_queues; i++)
+		cbd_queue_stop(&cbd_blkdev->queues[i]);
+}
+
+static void cbd_blkdev_destroy_queues(struct cbd_blkdev *cbd_blkdev)
+{
+	cbd_blkdev_stop_queues(cbd_blkdev);
+	kfree(cbd_blkdev->queues);
+}
+
+static int cbd_blkdev_create_queues(struct cbd_blkdev *cbd_blkdev)
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
+		ret = cbd_queue_start(cbdq);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
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
+
+	disk->fops = &cbd_bd_ops;
+	disk->private_data = cbd_blkdev;
+
+	/* Tell the block layer that this is not a rotational device */
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
+
+	cbd_blkdev->disk = disk;
+
+	cbdt_add_blkdev(cbd_blkdev->cbdt, cbd_blkdev);
+	cbd_blkdev->blkdev_info->mapped_id = cbd_blkdev->blkdev_id;
+	cbd_blkdev->blkdev_info->state = cbd_blkdev_state_running;
+
+	set_capacity(cbd_blkdev->disk, cbd_blkdev->dev_size);
+
+	set_disk_ro(cbd_blkdev->disk, false);
+	blk_queue_write_cache(cbd_blkdev->disk->queue, false, false);
+
+	ret = add_disk(cbd_blkdev->disk);
+	if (ret)
+		goto put_disk;
+
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
+int cbd_blkdev_start(struct cbd_transport *cbdt, u32 backend_id, u32 queues)
+{
+	struct cbd_blkdev *cbd_blkdev;
+	struct cbd_backend_info *backend_info;
+	u64 dev_size;
+	int ret;
+
+	backend_info = cbdt_get_backend_info(cbdt, backend_id);
+	if (backend_info->blkdev_count == CBDB_BLKDEV_COUNT_MAX)
+		return -EBUSY;
+
+	if (!cbd_backend_info_is_alive(backend_info)) {
+		cbdt_err(cbdt, "backend %u is not alive\n", backend_id);
+		return -EINVAL;
+	}
+
+	dev_size = backend_info->dev_size;
+
+	cbd_blkdev = kzalloc(sizeof(struct cbd_blkdev), GFP_KERNEL);
+	if (!cbd_blkdev)
+		return -ENOMEM;
+
+	mutex_init(&cbd_blkdev->lock);
+
+	if (backend_info->host_id == cbdt->host->host_id)
+		cbd_blkdev->backend = cbdt_get_backend(cbdt, backend_id);
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
+	INIT_LIST_HEAD(&cbd_blkdev->node);
+	cbd_blkdev->cbdt = cbdt;
+	cbd_blkdev->backend_id = backend_id;
+	cbd_blkdev->num_queues = queues;
+	cbd_blkdev->dev_size = dev_size;
+	cbd_blkdev->blkdev_info = cbdt_get_blkdev_info(cbdt, cbd_blkdev->blkdev_id);
+	cbd_blkdev->blkdev_dev = &cbdt->cbd_blkdevs_dev->blkdev_devs[cbd_blkdev->blkdev_id];
+
+	cbd_blkdev->blkdev_info->backend_id = backend_id;
+	cbd_blkdev->blkdev_info->host_id = cbdt->host->host_id;
+	cbd_blkdev->blkdev_info->state = cbd_blkdev_state_running;
+
+
+	if (cbd_backend_cache_on(backend_info)) {
+		struct cbd_cache_opts cache_opts = { 0 };
+
+		cache_opts.cache_info = &backend_info->cache_info;
+		cache_opts.alloc_segs = false;
+		cache_opts.start_writeback = false;
+		cache_opts.start_gc = true;
+		cache_opts.init_keys = true;
+		cache_opts.dev_size = dev_size;
+		cache_opts.n_paral = cbd_blkdev->num_queues;
+		cbd_blkdev->cbd_cache = cbd_cache_alloc(cbdt, &cache_opts);
+		if (!cbd_blkdev->cbd_cache) {
+			ret = -ENOMEM;
+			goto destroy_wq;
+		}
+	}
+
+	ret = cbd_blkdev_create_queues(cbd_blkdev);
+	if (ret < 0)
+		goto destroy_cache;
+
+	backend_info->blkdev_count++;
+
+	INIT_DELAYED_WORK(&cbd_blkdev->hb_work, blkdev_hb_workfn);
+	queue_delayed_work(cbd_wq, &cbd_blkdev->hb_work, 0);
+
+	ret = disk_start(cbd_blkdev);
+	if (ret < 0)
+		goto destroy_queues;
+	return 0;
+
+destroy_queues:
+	cancel_delayed_work_sync(&cbd_blkdev->hb_work);
+	cbd_blkdev_destroy_queues(cbd_blkdev);
+destroy_cache:
+	if (cbd_blkdev->cbd_cache)
+		cbd_cache_destroy(cbd_blkdev->cbd_cache);
+destroy_wq:
+	cbd_blkdev->blkdev_info->state = cbd_blkdev_state_none;
+	destroy_workqueue(cbd_blkdev->task_wq);
+ida_remove:
+	ida_simple_remove(&cbd_mapped_id_ida, cbd_blkdev->mapped_id);
+blkdev_free:
+	kfree(cbd_blkdev);
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
+int cbd_blkdev_stop(struct cbd_transport *cbdt, u32 devid, bool force)
+{
+	struct cbd_blkdev *cbd_blkdev;
+	struct cbd_backend_info *backend_info;
+
+	cbd_blkdev = cbdt_get_blkdev(cbdt, devid);
+	if (!cbd_blkdev)
+		return -EINVAL;
+
+	mutex_lock(&cbd_blkdev->lock);
+	if (cbd_blkdev->open_count > 0 && !force) {
+		mutex_unlock(&cbd_blkdev->lock);
+		return -EBUSY;
+	}
+
+	cbdt_del_blkdev(cbdt, cbd_blkdev);
+	mutex_unlock(&cbd_blkdev->lock);
+
+	cbd_blkdev_stop_queues(cbd_blkdev);
+	disk_stop(cbd_blkdev);
+	kfree(cbd_blkdev->queues);
+
+	cancel_delayed_work_sync(&cbd_blkdev->hb_work);
+	cbd_blkdev->blkdev_info->state = cbd_blkdev_state_none;
+
+	drain_workqueue(cbd_blkdev->task_wq);
+	destroy_workqueue(cbd_blkdev->task_wq);
+	ida_simple_remove(&cbd_mapped_id_ida, cbd_blkdev->mapped_id);
+	backend_info = cbdt_get_backend_info(cbdt, cbd_blkdev->backend_id);
+
+	if (cbd_blkdev->cbd_cache)
+		cbd_cache_destroy(cbd_blkdev->cbd_cache);
+
+	kfree(cbd_blkdev);
+
+	backend_info->blkdev_count--;
+
+	return 0;
+}
+
+int cbd_blkdev_clear(struct cbd_transport *cbdt, u32 devid)
+{
+	struct cbd_blkdev_info *blkdev_info;
+
+	blkdev_info = cbdt_get_blkdev_info(cbdt, devid);
+	if (cbd_blkdev_info_is_alive(blkdev_info)) {
+		cbdt_err(cbdt, "blkdev %u is still alive\n", devid);
+		return -EBUSY;
+	}
+
+	if (blkdev_info->state == cbd_blkdev_state_none)
+		return 0;
+
+	blkdev_info->state = cbd_blkdev_state_none;
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
diff --git a/drivers/block/cbd/cbd_queue.c b/drivers/block/cbd/cbd_queue.c
new file mode 100644
index 000000000000..cd40574d4a48
--- /dev/null
+++ b/drivers/block/cbd/cbd_queue.c
@@ -0,0 +1,574 @@
+#include "cbd_internal.h"
+
+static inline struct cbd_se *get_submit_entry(struct cbd_queue *cbdq)
+{
+	return (struct cbd_se *)(cbdq->channel.submr + cbdq->channel_info->submr_head);
+}
+
+static inline struct cbd_se *get_oldest_se(struct cbd_queue *cbdq)
+{
+	if (cbdq->channel_info->submr_tail == cbdq->channel_info->submr_head)
+		return NULL;
+
+	return (struct cbd_se *)(cbdq->channel.submr + cbdq->channel_info->submr_tail);
+}
+
+static inline struct cbd_ce *get_complete_entry(struct cbd_queue *cbdq)
+{
+	if (cbdq->channel_info->compr_tail == cbdq->channel_info->compr_head)
+		return NULL;
+
+	return (struct cbd_ce *)(cbdq->channel.compr + cbdq->channel_info->compr_tail);
+}
+
+static void cbd_req_init(struct cbd_queue *cbdq, enum cbd_op op, struct request *rq)
+{
+	struct cbd_request *cbd_req = blk_mq_rq_to_pdu(rq);
+
+	cbd_req->req = rq;
+	cbd_req->cbdq = cbdq;
+	cbd_req->op = op;
+
+	if (req_op(rq) == REQ_OP_READ || req_op(rq) == REQ_OP_WRITE)
+		cbd_req->data_len = blk_rq_bytes(rq);
+	else
+		cbd_req->data_len = 0;
+
+	cbd_req->bio = rq->bio;
+	cbd_req->off = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
+}
+
+static bool cbd_req_nodata(struct cbd_request *cbd_req)
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
+static void queue_req_se_init(struct cbd_request *cbd_req)
+{
+	struct cbd_se	*se;
+	u64 offset = cbd_req->off;
+	u32 length = cbd_req->data_len;
+
+	se = get_submit_entry(cbd_req->cbdq);
+	memset(se, 0, sizeof(struct cbd_se));
+	se->op = cbd_req->op;
+
+	se->req_tid = cbd_req->req_tid;
+	se->offset = offset;
+	se->len = length;
+
+	if (cbd_req->op == CBD_OP_READ || cbd_req->op == CBD_OP_WRITE) {
+		se->data_off = cbd_req->cbdq->channel.data_head;
+		se->data_len = length;
+	}
+
+	cbd_req->se = se;
+}
+
+static bool data_space_enough(struct cbd_queue *cbdq, struct cbd_request *cbd_req)
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
+	space_needed = round_up(cbd_req->data_len, CBDC_DATA_ALIGH);
+
+	if (space_available - CBDC_DATA_RESERVED < space_needed)
+		return false;
+
+	return true;
+}
+
+static bool submit_ring_full(struct cbd_queue *cbdq)
+{
+	u32 space_available = cbdq->channel.submr_size;
+	struct cbd_channel_info *info = cbdq->channel_info;
+
+	if (info->submr_head > info->submr_tail) {
+		space_available = cbdq->channel.submr_size - info->submr_head;
+		space_available += info->submr_tail;
+	} else if (info->submr_head < info->submr_tail) {
+		space_available = info->submr_tail - info->submr_head;
+	}
+
+	/* There is a SUBMR_RESERVED we dont use to prevent the ring to be used up */
+	if (space_available - CBDC_SUBMR_RESERVED < sizeof(struct cbd_se))
+		return true;
+
+	return false;
+}
+
+static void queue_req_data_init(struct cbd_request *cbd_req)
+{
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+	struct bio *bio = cbd_req->bio;
+
+	if (cbd_req->op == CBD_OP_READ)
+		goto advance_data_head;
+
+	cbdc_copy_from_bio(&cbdq->channel, cbd_req->data_off, cbd_req->data_len, bio, cbd_req->bio_off);
+
+advance_data_head:
+	cbdq->channel.data_head = round_up(cbdq->channel.data_head + cbd_req->data_len, PAGE_SIZE);
+	cbdq->channel.data_head %= cbdq->channel.data_size;
+}
+
+#ifdef CONFIG_CBD_CRC
+static void cbd_req_crc_init(struct cbd_request *cbd_req)
+{
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+	struct cbd_se *se = cbd_req->se;
+
+	if (cbd_req->op == CBD_OP_WRITE)
+		se->data_crc = cbd_channel_crc(&cbdq->channel,
+					       cbd_req->data_off,
+					       cbd_req->data_len);
+
+	se->se_crc = cbd_se_crc(se);
+}
+#endif
+
+static void end_req(struct kref *ref)
+{
+	struct cbd_request *cbd_req = container_of(ref, struct cbd_request, ref);
+	struct request *req = cbd_req->req;
+	int ret = cbd_req->ret;
+
+	if (cbd_req->end_req)
+		cbd_req->end_req(cbd_req, cbd_req->priv_data);
+
+	if (req) {
+		if (ret == -ENOMEM || ret == -EBUSY)
+			blk_mq_requeue_request(req, true);
+		else
+			blk_mq_end_request(req, errno_to_blk_status(ret));
+	}
+
+}
+
+void cbd_req_get(struct cbd_request *cbd_req)
+{
+	kref_get(&cbd_req->ref);
+}
+
+void cbd_req_put(struct cbd_request *cbd_req, int ret)
+{
+	struct cbd_request *parent = cbd_req->parent;
+
+	if (ret && !cbd_req->ret)
+		cbd_req->ret = ret;
+
+	if (kref_put(&cbd_req->ref, end_req) && parent)
+		cbd_req_put(parent, ret);
+}
+
+static void complete_inflight_req(struct cbd_queue *cbdq, struct cbd_request *cbd_req, int ret);
+int cbd_queue_req_to_backend(struct cbd_request *cbd_req)
+{
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+	size_t command_size;
+	int ret;
+
+	spin_lock(&cbdq->inflight_reqs_lock);
+	if (atomic_read(&cbdq->state) == cbd_queue_state_removing) {
+		spin_unlock(&cbdq->inflight_reqs_lock);
+		ret = -EIO;
+		goto err;
+	}
+	list_add_tail(&cbd_req->inflight_reqs_node, &cbdq->inflight_reqs);
+	spin_unlock(&cbdq->inflight_reqs_lock);
+
+	command_size = sizeof(struct cbd_se);
+
+	spin_lock(&cbdq->channel.submr_lock);
+	if (cbd_req->op == CBD_OP_WRITE || cbd_req->op == CBD_OP_READ)
+		cbd_req->data_off = cbdq->channel.data_head;
+	else
+		cbd_req->data_off = -1;
+
+	if (submit_ring_full(cbdq) ||
+			!data_space_enough(cbdq, cbd_req)) {
+		spin_unlock(&cbdq->channel.submr_lock);
+
+		/* remove request from inflight_reqs */
+		spin_lock(&cbdq->inflight_reqs_lock);
+		list_del_init(&cbd_req->inflight_reqs_node);
+		spin_unlock(&cbdq->inflight_reqs_lock);
+
+		/* return ocuppied space */
+		cbd_req->data_len = 0;
+
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	cbd_req->req_tid = ++cbdq->req_tid;
+	queue_req_se_init(cbd_req);
+
+	if (!cbd_req_nodata(cbd_req))
+		queue_req_data_init(cbd_req);
+
+	cbd_req_get(cbd_req);
+#ifdef CONFIG_CBD_CRC
+	cbd_req_crc_init(cbd_req);
+#endif
+	CBDC_UPDATE_SUBMR_HEAD(cbdq->channel_info->submr_head,
+			sizeof(struct cbd_se),
+			cbdq->channel.submr_size);
+	spin_unlock(&cbdq->channel.submr_lock);
+
+	if (cbdq->cbd_blkdev->backend)
+		cbd_backend_notify(cbdq->cbd_blkdev->backend, cbdq->channel.seg_id);
+	queue_delayed_work(cbdq->cbd_blkdev->task_wq, &cbdq->complete_work, 0);
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static void queue_req_end_req(struct cbd_request *cbd_req, void *priv_data);
+static void cbd_queue_req(struct cbd_queue *cbdq, struct cbd_request *cbd_req)
+{
+	int ret;
+
+	if (cbdq->cbd_blkdev->cbd_cache) {
+		ret = cbd_cache_handle_req(cbdq->cbd_blkdev->cbd_cache, cbd_req);
+		goto end;
+	}
+
+	cbd_req->end_req = queue_req_end_req;
+
+	ret = cbd_queue_req_to_backend(cbd_req);
+end:
+	cbd_req_put(cbd_req, ret);
+}
+
+static void advance_subm_ring(struct cbd_queue *cbdq)
+{
+	struct cbd_se *se;
+again:
+	se = get_oldest_se(cbdq);
+	if (!se)
+		goto out;
+
+	if (cbd_se_flags_test(se, CBD_SE_FLAGS_DONE)) {
+		CBDC_UPDATE_SUBMR_TAIL(cbdq->channel_info->submr_tail,
+				sizeof(struct cbd_se),
+				cbdq->channel.submr_size);
+		goto again;
+	}
+out:
+	return;
+}
+
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
+static void advance_data_tail(struct cbd_queue *cbdq, u32 data_off, u32 data_len)
+{
+	data_off %= cbdq->channel.data_size;
+	cbdq->released_extents[data_off / PAGE_SIZE] = data_len;
+
+	while (__advance_data_tail(cbdq, data_off, data_len)) {
+		data_off += data_len;
+		data_off %= cbdq->channel.data_size;
+		data_len = cbdq->released_extents[data_off / PAGE_SIZE];
+		if (!data_len)
+			break;
+	}
+}
+
+void cbd_queue_advance(struct cbd_queue *cbdq, struct cbd_request *cbd_req)
+{
+	spin_lock(&cbdq->channel.submr_lock);
+	advance_subm_ring(cbdq);
+	if (!cbd_req_nodata(cbd_req) && cbd_req->data_len)
+		advance_data_tail(cbdq, cbd_req->data_off, round_up(cbd_req->data_len, PAGE_SIZE));
+	spin_unlock(&cbdq->channel.submr_lock);
+}
+
+static void queue_req_end_req(struct cbd_request *cbd_req, void *priv_data)
+{
+	cbd_queue_advance(cbd_req->cbdq, cbd_req);
+}
+
+static inline void complete_inflight_req(struct cbd_queue *cbdq, struct cbd_request *cbd_req, int ret)
+{
+	spin_lock(&cbdq->inflight_reqs_lock);
+	list_del_init(&cbd_req->inflight_reqs_node);
+	spin_unlock(&cbdq->inflight_reqs_lock);
+
+	cbd_se_flags_set(cbd_req->se, CBD_SE_FLAGS_DONE);
+
+	cbd_req_put(cbd_req, ret);
+}
+
+static struct cbd_request *find_inflight_req(struct cbd_queue *cbdq, u64 req_tid)
+{
+	struct cbd_request *req;
+	bool found = false;
+
+	list_for_each_entry(req, &cbdq->inflight_reqs, inflight_reqs_node) {
+		if (req->req_tid == req_tid) {
+			found = true;
+			break;
+		}
+	}
+
+	if (found)
+		return req;
+
+	return NULL;
+}
+
+static void copy_data_from_cbdreq(struct cbd_request *cbd_req)
+{
+	struct bio *bio = cbd_req->bio;
+	struct cbd_queue *cbdq = cbd_req->cbdq;
+
+	spin_lock(&cbd_req->lock);
+	cbdc_copy_to_bio(&cbdq->channel, cbd_req->data_off, cbd_req->data_len, bio, cbd_req->bio_off);
+	spin_unlock(&cbd_req->lock);
+}
+
+static void complete_work_fn(struct work_struct *work)
+{
+	struct cbd_queue *cbdq = container_of(work, struct cbd_queue, complete_work.work);
+	struct cbd_ce *ce;
+	struct cbd_request *cbd_req;
+
+again:
+	/* compr_head would be updated by backend handler */
+	spin_lock(&cbdq->channel.compr_lock);
+	ce = get_complete_entry(cbdq);
+	spin_unlock(&cbdq->channel.compr_lock);
+	if (!ce)
+		goto miss;
+
+	spin_lock(&cbdq->inflight_reqs_lock);
+	cbd_req = find_inflight_req(cbdq, ce->req_tid);
+	spin_unlock(&cbdq->inflight_reqs_lock);
+	if (!cbd_req) {
+		cbd_queue_err(cbdq, "inflight request not found: %llu.", ce->req_tid);
+		goto miss;
+	}
+
+#ifdef CONFIG_CBD_CRC
+	if (ce->ce_crc != cbd_ce_crc(ce)) {
+		cbd_queue_err(cbdq, "ce crc bad 0x%x != 0x%x(expected)",
+				cbd_ce_crc(ce), ce->ce_crc);
+		goto miss;
+	}
+
+	if (cbd_req->op == CBD_OP_READ &&
+		ce->data_crc != cbd_channel_crc(&cbdq->channel,
+					       cbd_req->data_off,
+					       cbd_req->data_len)) {
+		cbd_queue_err(cbdq, "ce data_crc bad 0x%x != 0x%x(expected)",
+				cbd_channel_crc(&cbdq->channel,
+						cbd_req->data_off,
+						cbd_req->data_len),
+				ce->data_crc);
+		goto miss;
+	}
+#endif
+
+	cbdwc_hit(&cbdq->complete_worker_cfg);
+	CBDC_UPDATE_COMPR_TAIL(cbdq->channel_info->compr_tail,
+			       sizeof(struct cbd_ce),
+			       cbdq->channel.compr_size);
+
+	if (cbd_req->op == CBD_OP_READ) {
+		spin_lock(&cbdq->channel.submr_lock);
+		copy_data_from_cbdreq(cbd_req);
+		spin_unlock(&cbdq->channel.submr_lock);
+	}
+
+	complete_inflight_req(cbdq, cbd_req, ce->result);
+
+	goto again;
+
+miss:
+	if (cbdwc_need_retry(&cbdq->complete_worker_cfg))
+		goto again;
+
+	spin_lock(&cbdq->inflight_reqs_lock);
+	if (list_empty(&cbdq->inflight_reqs)) {
+		spin_unlock(&cbdq->inflight_reqs_lock);
+		cbdwc_init(&cbdq->complete_worker_cfg);
+		return;
+	}
+	spin_unlock(&cbdq->inflight_reqs_lock);
+	cbdwc_miss(&cbdq->complete_worker_cfg);
+
+	cpu_relax();
+	queue_delayed_work(cbdq->cbd_blkdev->task_wq, &cbdq->complete_work, 0);
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
+static int cbd_queue_channel_init(struct cbd_queue *cbdq, u32 channel_id)
+{
+	struct cbd_blkdev *cbd_blkdev = cbdq->cbd_blkdev;
+	struct cbd_transport *cbdt = cbd_blkdev->cbdt;
+
+	cbd_channel_init(&cbdq->channel, cbdt, channel_id);
+	cbdq->channel_info = cbdq->channel.channel_info;
+
+	if (!cbd_blkdev->backend)
+		cbdq->channel_info->polling = true;
+
+	cbdq->channel.data_head = cbdq->channel.data_tail = 0;
+	cbdq->channel_info->submr_tail = cbdq->channel_info->submr_head = 0;
+	cbdq->channel_info->compr_tail = cbdq->channel_info->compr_head = 0;
+
+	cbdq->channel_info->backend_id = cbd_blkdev->backend_id;
+	cbdq->channel_info->blkdev_id = cbd_blkdev->blkdev_id;
+	cbdq->channel_info->blkdev_state = cbdc_blkdev_state_running;
+
+	return 0;
+}
+
+int cbd_queue_start(struct cbd_queue *cbdq)
+{
+	struct cbd_transport *cbdt = cbdq->cbd_blkdev->cbdt;
+	u32 channel_id;
+	int ret;
+
+	ret = cbd_get_empty_channel_id(cbdt, &channel_id);
+	if (ret < 0) {
+		cbdt_err(cbdt, "failed find available channel_id.\n");
+		goto err;
+	}
+
+	ret = cbd_queue_channel_init(cbdq, channel_id);
+	if (ret) {
+		cbdt_err(cbdt, "failed to init dev channel_info: %d.", ret);
+		goto err;
+	}
+
+	INIT_LIST_HEAD(&cbdq->inflight_reqs);
+	spin_lock_init(&cbdq->inflight_reqs_lock);
+	cbdq->req_tid = 0;
+	INIT_DELAYED_WORK(&cbdq->complete_work, complete_work_fn);
+	cbdwc_init(&cbdq->complete_worker_cfg);
+
+	cbdq->released_extents = kzalloc(sizeof(u64) * (CBDC_DATA_SIZE >> PAGE_SHIFT), GFP_KERNEL);
+	if (!cbdq->released_extents) {
+		ret = -ENOMEM;
+		goto channel_exit;
+	}
+
+	queue_delayed_work(cbdq->cbd_blkdev->task_wq, &cbdq->complete_work, 0);
+
+	atomic_set(&cbdq->state, cbd_queue_state_running);
+
+	return 0;
+
+channel_exit:
+	cbdq->channel_info->blkdev_state = cbdc_blkdev_state_none;
+	cbd_channel_exit(&cbdq->channel);
+err:
+	return ret;
+}
+
+void cbd_queue_stop(struct cbd_queue *cbdq)
+{
+	LIST_HEAD(tmp_list);
+	struct cbd_request *cbd_req;
+
+	if (atomic_read(&cbdq->state) != cbd_queue_state_running)
+		return;
+
+	atomic_set(&cbdq->state, cbd_queue_state_removing);
+	cancel_delayed_work_sync(&cbdq->complete_work);
+
+	spin_lock(&cbdq->inflight_reqs_lock);
+	list_splice_init(&cbdq->inflight_reqs, &tmp_list);
+	spin_unlock(&cbdq->inflight_reqs_lock);
+
+	while (!list_empty(&tmp_list)) {
+		cbd_req = list_first_entry(&tmp_list,
+				struct cbd_request, inflight_reqs_node);
+		list_del_init(&cbd_req->inflight_reqs_node);
+		cancel_work_sync(&cbd_req->work);
+		cbd_req_put(cbd_req, -EIO);
+	}
+
+	kfree(cbdq->released_extents);
+	cbdq->channel_info->blkdev_state = cbdc_blkdev_state_none;
+	cbd_channel_exit(&cbdq->channel);
+}
-- 
2.34.1



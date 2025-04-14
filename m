Return-Path: <linux-bcache+bounces-872-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 882ADA87583
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42530188AEAA
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA4B1ACEC9;
	Mon, 14 Apr 2025 01:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KwUmYwgt"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881C51AAA2C
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595162; cv=none; b=f4qKRfrqKa6wddYYstdeX3htchCI7iEMuYmeT7Xndbzm8poAFCYSC2+i2hGG44UDFheeRYE2JGpYtO5aiV46CHTXcTlEamZtmfXiP3jO3SGfgX8otJg4KVnrPWLteMyztfaFeGTHN4SR24KRjPRZzqFMzYoK8w692DQ9NnYLMMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595162; c=relaxed/simple;
	bh=sxmCPdxrpKlqtCvPbykqVOQ/y6mE9HQZwVV5lIA/aSo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KYvq4/tu/3TpMo6I/t029pKmiBehuqNtD/L57IntUdzOe9x/s95r1KSwEi1xaVQRB4wPrbelBl1AqwxJiPm5e3t8wQNMnpqfR0uxfPF0OlugMQZvsFRnMAfMclyGtpspmuaaQ1y/EDjSRBhHhekyq/sRfZaQnQxLKbIywwlYFtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KwUmYwgt; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZZFggpY+ZKiLRCW/hYI9LKJVuoQ9jFBC+b9AKHIz1M=;
	b=KwUmYwgtosbaDS2/8TrCmlHqVJ3D7yYuhAQg3OO/6UeE8K7rn2BAvf9eDDcrYdR9gMiLEq
	TNvwyNRTFdHp+3L/kFGKvdugeQ7hzydd0eneMxFKUo5raRCCHPHgYwsn1idWRQMw2Dph8E
	lsI+17sA3tcpUauYu4KDVRkhk63ZMAs=
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
Subject: [RFC PATCH 09/11] pcache: introduce logic block device and request handling
Date: Mon, 14 Apr 2025 01:45:03 +0000
Message-Id: <20250414014505.20477-10-dongsheng.yang@linux.dev>
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

This patch introduces the logic block device layer (`pcache_logic_dev`), which
connects pcache to the kernel block layer through a standard gendisk interface.
It implements the infrastructure to expose the cache as a Linux block device
(e.g., /dev/pcache0), enabling I/O submission via standard block device APIs.

Key components added:

- pcache_logic_dev:
  Represents the logical block device and encapsulates associated state,
  such as queues, gendisk, tag set, and open count tracking.

- Block I/O path:
  Implements `pcache_queue_rq()` to translate block layer requests into
  internal `pcache_request` objects. Handles data reads, writes, and flushes
  by dispatching them to `pcache_cache_handle_req()` and completing them
  via `pcache_req_put()`.

- Queue management:
  Initializes per-hctx queues and associates them with `pcache_queue`.
  Ensures multi-queue support by allocating queues according to the backing
  device's configuration.

- Device lifecycle:
  Provides `logic_dev_start()` and `logic_dev_stop()` to manage device
  creation, queue setup, and gendisk registration/unregistration.
  Tracks open_count to ensure safe teardown.

- blkdev integration:
  Adds `pcache_blkdev_init()` and `pcache_blkdev_exit()` to register/unregister
  the pcache major number.

This forms the upper layer of pcache's I/O path and makes the cache visible
as a standard Linux block device.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/logic_dev.c | 348 +++++++++++++++++++++++++++++++
 drivers/block/pcache/logic_dev.h |  73 +++++++
 2 files changed, 421 insertions(+)
 create mode 100644 drivers/block/pcache/logic_dev.c
 create mode 100644 drivers/block/pcache/logic_dev.h

diff --git a/drivers/block/pcache/logic_dev.c b/drivers/block/pcache/logic_dev.c
new file mode 100644
index 000000000000..02917bac2210
--- /dev/null
+++ b/drivers/block/pcache/logic_dev.c
@@ -0,0 +1,348 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "pcache_internal.h"
+#include "cache.h"
+#include "backing_dev.h"
+#include "logic_dev.h"
+
+static int pcache_major;
+static DEFINE_IDA(pcache_mapped_id_ida);
+
+static int minor_to_pcache_mapped_id(int minor)
+{
+	return minor >> PCACHE_PART_SHIFT;
+}
+
+static int logic_dev_open(struct gendisk *disk, blk_mode_t mode)
+{
+	struct pcache_logic_dev *logic_dev = disk->private_data;
+
+	mutex_lock(&logic_dev->lock);
+	logic_dev->open_count++;
+	mutex_unlock(&logic_dev->lock);
+
+	return 0;
+}
+
+static void logic_dev_release(struct gendisk *disk)
+{
+	struct pcache_logic_dev *logic_dev = disk->private_data;
+
+	mutex_lock(&logic_dev->lock);
+	logic_dev->open_count--;
+	mutex_unlock(&logic_dev->lock);
+}
+
+static const struct block_device_operations logic_dev_bd_ops = {
+	.owner			= THIS_MODULE,
+	.open			= logic_dev_open,
+	.release		= logic_dev_release,
+};
+
+static inline bool pcache_req_nodata(struct pcache_request *pcache_req)
+{
+	switch (pcache_req->op) {
+	case REQ_OP_WRITE:
+	case REQ_OP_READ:
+		return false;
+	case REQ_OP_FLUSH:
+		return true;
+	default:
+		BUG();
+	}
+}
+
+static blk_status_t pcache_queue_rq(struct blk_mq_hw_ctx *hctx,
+		const struct blk_mq_queue_data *bd)
+{
+	struct request *req = bd->rq;
+	struct pcache_queue *queue = hctx->driver_data;
+	struct pcache_logic_dev *logic_dev = queue->logic_dev;
+	struct pcache_request *pcache_req = blk_mq_rq_to_pdu(bd->rq);
+	int ret;
+
+	memset(pcache_req, 0, sizeof(struct pcache_request));
+	kref_init(&pcache_req->ref);
+	blk_mq_start_request(bd->rq);
+
+	pcache_req->queue = queue;
+	pcache_req->req = req;
+	pcache_req->op = req_op(bd->rq);
+	pcache_req->off = (u64)blk_rq_pos(bd->rq) << SECTOR_SHIFT;
+	if (!pcache_req_nodata(pcache_req))
+		pcache_req->data_len = blk_rq_bytes(bd->rq);
+	else
+		pcache_req->data_len = 0;
+
+	ret = pcache_cache_handle_req(logic_dev->backing_dev->cache, pcache_req);
+	pcache_req_put(pcache_req, ret);
+
+	return BLK_STS_OK;
+}
+
+static int pcache_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
+			unsigned int hctx_idx)
+{
+	struct pcache_logic_dev *logic_dev = driver_data;
+
+	hctx->driver_data = &logic_dev->queues[hctx_idx];
+
+	return 0;
+}
+
+const struct blk_mq_ops logic_dev_mq_ops = {
+	.queue_rq	= pcache_queue_rq,
+	.init_hctx	= pcache_init_hctx,
+};
+
+static int disk_start(struct pcache_logic_dev *logic_dev)
+{
+	struct gendisk *disk;
+	struct queue_limits lim = {
+		.max_hw_sectors			= BIO_MAX_VECS * PAGE_SECTORS,
+		.io_min				= 4096,
+		.io_opt				= 4096,
+		.max_segments			= BIO_MAX_VECS,
+		.max_segment_size		= PAGE_SIZE,
+		.discard_granularity		= 0,
+		.max_hw_discard_sectors		= 0,
+		.max_write_zeroes_sectors	= 0
+	};
+	int ret;
+
+	memset(&logic_dev->tag_set, 0, sizeof(logic_dev->tag_set));
+	logic_dev->tag_set.ops = &logic_dev_mq_ops;
+	logic_dev->tag_set.queue_depth = 128;
+	logic_dev->tag_set.numa_node = NUMA_NO_NODE;
+	logic_dev->tag_set.nr_hw_queues = logic_dev->num_queues;
+	logic_dev->tag_set.cmd_size = sizeof(struct pcache_request);
+	logic_dev->tag_set.timeout = 0;
+	logic_dev->tag_set.driver_data = logic_dev;
+
+	ret = blk_mq_alloc_tag_set(&logic_dev->tag_set);
+	if (ret) {
+		logic_dev_err(logic_dev, "failed to alloc tag set %d", ret);
+		goto err;
+	}
+
+	disk = blk_mq_alloc_disk(&logic_dev->tag_set, &lim, logic_dev);
+	if (IS_ERR(disk)) {
+		ret = PTR_ERR(disk);
+		logic_dev_err(logic_dev, "failed to alloc disk");
+		goto out_tag_set;
+	}
+
+	snprintf(disk->disk_name, sizeof(disk->disk_name), "pcache%d",
+		 logic_dev->mapped_id);
+
+	disk->major = pcache_major;
+	disk->first_minor = logic_dev->mapped_id << PCACHE_PART_SHIFT;
+	disk->minors = (1 << PCACHE_PART_SHIFT);
+	disk->fops = &logic_dev_bd_ops;
+	disk->private_data = logic_dev;
+
+	logic_dev->disk = disk;
+
+	set_capacity(logic_dev->disk, logic_dev->dev_size);
+	set_disk_ro(logic_dev->disk, false);
+
+	/* Register the disk with the system */
+	ret = add_disk(logic_dev->disk);
+	if (ret)
+		goto put_disk;
+
+	return 0;
+
+put_disk:
+	put_disk(logic_dev->disk);
+out_tag_set:
+	blk_mq_free_tag_set(&logic_dev->tag_set);
+err:
+	return ret;
+}
+
+static void disk_stop(struct pcache_logic_dev *logic_dev)
+{
+	del_gendisk(logic_dev->disk);
+	put_disk(logic_dev->disk);
+	blk_mq_free_tag_set(&logic_dev->tag_set);
+}
+
+static struct pcache_logic_dev *logic_dev_alloc(struct pcache_backing_dev *backing_dev)
+{
+	struct pcache_logic_dev *logic_dev;
+	int ret;
+
+	logic_dev = kzalloc(sizeof(struct pcache_logic_dev), GFP_KERNEL);
+	if (!logic_dev)
+		return NULL;
+
+	logic_dev->backing_dev = backing_dev;
+	mutex_init(&logic_dev->lock);
+	INIT_LIST_HEAD(&logic_dev->node);
+
+	logic_dev->mapped_id = ida_simple_get(&pcache_mapped_id_ida, 0,
+					 minor_to_pcache_mapped_id(1 << MINORBITS),
+					 GFP_KERNEL);
+	if (logic_dev->mapped_id < 0) {
+		ret = -ENOENT;
+		goto logic_dev_free;
+	}
+
+	return logic_dev;
+
+logic_dev_free:
+	kfree(logic_dev);
+
+	return NULL;
+}
+
+static void logic_dev_free(struct pcache_logic_dev *logic_dev)
+{
+	ida_simple_remove(&pcache_mapped_id_ida, logic_dev->mapped_id);
+	kfree(logic_dev);
+}
+
+static void logic_dev_destroy_queues(struct pcache_logic_dev *logic_dev)
+{
+	struct pcache_queue *queue;
+	int i;
+
+	/* Stop each queue associated with the block device */
+	for (i = 0; i < logic_dev->num_queues; i++) {
+		queue = &logic_dev->queues[i];
+		if (queue->state == PCACHE_QUEUE_STATE_NONE)
+			continue;
+	}
+
+	/* Free the memory allocated for the queues */
+	kfree(logic_dev->queues);
+}
+
+static int logic_dev_create_queues(struct pcache_logic_dev *logic_dev)
+{
+	int i;
+	struct pcache_queue *queue;
+
+	logic_dev->queues = kcalloc(logic_dev->num_queues, sizeof(struct pcache_queue), GFP_KERNEL);
+	if (!logic_dev->queues)
+		return -ENOMEM;
+
+	for (i = 0; i < logic_dev->num_queues; i++) {
+		queue = &logic_dev->queues[i];
+		queue->logic_dev = logic_dev;
+		queue->index = i;
+
+		queue->state = PCACHE_QUEUE_STATE_RUNNING;
+	}
+
+	return 0;
+}
+
+static int logic_dev_init(struct pcache_logic_dev *logic_dev, u32 queues)
+{
+	int ret;
+
+	logic_dev->num_queues = queues;
+	logic_dev->dev_size = logic_dev->dev_size;
+
+	ret = logic_dev_create_queues(logic_dev);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+err:
+	return ret;
+}
+
+static void logic_dev_destroy(struct pcache_logic_dev *logic_dev)
+{
+	logic_dev_destroy_queues(logic_dev);
+}
+
+int logic_dev_start(struct pcache_backing_dev *backing_dev, u32 queues)
+{
+	struct pcache_logic_dev *logic_dev;
+	int ret;
+
+	logic_dev = logic_dev_alloc(backing_dev);
+	if (!logic_dev)
+		return -ENOMEM;
+
+	logic_dev->dev_size = backing_dev->dev_size;
+	ret = logic_dev_init(logic_dev, queues);
+	if (ret)
+		goto logic_dev_free;
+
+	backing_dev->logic_dev = logic_dev;
+
+	ret = disk_start(logic_dev);
+	if (ret < 0)
+		goto logic_dev_destroy;
+
+	return 0;
+
+logic_dev_destroy:
+	logic_dev_destroy(logic_dev);
+logic_dev_free:
+	logic_dev_free(logic_dev);
+	return ret;
+}
+
+int logic_dev_stop(struct pcache_logic_dev *logic_dev)
+{
+	mutex_lock(&logic_dev->lock);
+	if (logic_dev->open_count > 0) {
+		mutex_unlock(&logic_dev->lock);
+		return -EBUSY;
+	}
+	mutex_unlock(&logic_dev->lock);
+
+	disk_stop(logic_dev);
+	logic_dev_destroy(logic_dev);
+	logic_dev_free(logic_dev);
+
+	return 0;
+}
+
+int pcache_blkdev_init(void)
+{
+	pcache_major = register_blkdev(0, "pcache");
+	if (pcache_major < 0)
+		return pcache_major;
+
+	return 0;
+}
+
+void pcache_blkdev_exit(void)
+{
+	unregister_blkdev(pcache_major, "pcache");
+}
+
+static void end_req(struct kref *ref)
+{
+	struct pcache_request *pcache_req = container_of(ref, struct pcache_request, ref);
+	struct request *req = pcache_req->req;
+	int ret = pcache_req->ret;
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
+void pcache_req_get(struct pcache_request *pcache_req)
+{
+	kref_get(&pcache_req->ref);
+}
+
+void pcache_req_put(struct pcache_request *pcache_req, int ret)
+{
+	/* Set the return status if it is not already set */
+	if (ret && !pcache_req->ret)
+		pcache_req->ret = ret;
+
+	kref_put(&pcache_req->ref, end_req);
+}
diff --git a/drivers/block/pcache/logic_dev.h b/drivers/block/pcache/logic_dev.h
new file mode 100644
index 000000000000..2a8de0b02369
--- /dev/null
+++ b/drivers/block/pcache/logic_dev.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_LOGIC_DEV_H
+#define _PCACHE_LOGIC_DEV_H
+
+#include <linux/blk-mq.h>
+
+#include "pcache_internal.h"
+
+#define logic_dev_err(logic_dev, fmt, ...)							\
+	cache_dev_err(logic_dev->backing_dev->cache_dev, "logic_dev%d: " fmt,			\
+		 logic_dev->mapped_id, ##__VA_ARGS__)
+#define logic_dev_info(logic_dev, fmt, ...)							\
+	cache_dev_info(logic_dev->backing_dev->cache_dev, "logic_dev%d: " fmt,			\
+		 logic_dev->mapped_id, ##__VA_ARGS__)
+#define logic_dev_debug(logic_dev, fmt, ...)							\
+	cache_dev_debug(logic_dev->backing_dev->cache_dev, "logic_dev%d: " fmt,			\
+		 logic_dev->mapped_id, ##__VA_ARGS__)
+
+#define PCACHE_QUEUE_STATE_NONE			0
+#define PCACHE_QUEUE_STATE_RUNNING		1
+
+struct pcache_queue {
+	struct pcache_logic_dev	*logic_dev;
+	u32			index;
+
+	u8	                state;
+};
+
+struct pcache_request {
+	struct pcache_queue	*queue;
+	struct request		*req;
+
+	u64			off;
+	u32			data_len;
+
+	u8			op;
+
+	struct kref		ref;
+	int			ret;
+};
+
+struct pcache_logic_dev {
+	int				mapped_id; /* id in block device such as: /dev/pcache0 */
+
+	struct pcache_backing_dev	*backing_dev;
+
+	int				major;		/* blkdev assigned major */
+	int				minor;
+	struct gendisk			*disk;		/* blkdev's gendisk and rq */
+
+	struct mutex			lock;
+	unsigned long			open_count;	/* protected by lock */
+
+	struct list_head		node;
+
+	/* Block layer tags. */
+	struct blk_mq_tag_set		tag_set;
+
+	uint32_t			num_queues;
+	struct pcache_queue		*queues;
+
+	u64				dev_size;
+};
+
+int logic_dev_start(struct pcache_backing_dev *backing_dev, u32 queues);
+int logic_dev_stop(struct pcache_logic_dev *logic_dev);
+
+void pcache_req_get(struct pcache_request *pcache_req);
+void pcache_req_put(struct pcache_request *pcache_req, int ret);
+
+int pcache_blkdev_init(void);
+void pcache_blkdev_exit(void);
+#endif /* _PCACHE_LOGIC_DEV_H */
-- 
2.34.1



Return-Path: <linux-bcache+bounces-725-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458AE97BAC0
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 12:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A64C1C2250C
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 10:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D860A189B86;
	Wed, 18 Sep 2024 10:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SsHV7yO9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9CC189901
	for <linux-bcache@vger.kernel.org>; Wed, 18 Sep 2024 10:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726654760; cv=none; b=dwvVGpb6leNogUdzAfBLwaw/JjwyOT6yXtr2DAtXZcrItNnSLoYrzLg2go2wedLPDppr0RkoA4+YKdQ7RM5XRmWzsRL3iNumT4hBebmlQ5MfwybO6smeo+6IOcPnSbvkU+0r9vSz2U3m4q5ILGbrsdUmwTcufch2Y1miCfGNqUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726654760; c=relaxed/simple;
	bh=nQSOWFnAXLLYKidxd/Kf+SBffy0qObGhTTWo18/oS3E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JgNURLa+O+ny5mqRpz8qqkXmmZsCTqXBcyrn1Q+zpZcAHFLUaok/w8RhukMMQJMU5oxEfx1emojjRFQXWUOmNpPWxO5ouBqm2i2k39TeE9dlbOi11WMgZqzQZw0ngSrNj+/lbJpJGvlqfoe8N9RAIAcY6KIGEoQesHol+phNAJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SsHV7yO9; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726654755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v4dKpUx85fl3YTGHcK89lmOveS0EI6KnldbDyoQf1bs=;
	b=SsHV7yO9iYgdH1YQRgodUzX3Smdscq8o3yFVxXTNH1UVKX1QT5nJvKqo4KU2/1PSKb7j1Y
	MTHOqTZzs5pTqUtjQ+QNm2Xb4UfoTmbObbKBOjtAreJlTUuMnatv2SwyiXxxt+T5Bf0+vc
	+lEYr4itRvcfx9OSlNrvJqN6hta+7Pc=
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
Subject: [PATCH v2 7/8] cbd: introduce cbd_backend
Date: Wed, 18 Sep 2024 10:18:20 +0000
Message-Id: <20240918101821.681118-8-dongsheng.yang@linux.dev>
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

The "cbd_backend" is responsible for exposing a local block device (such
as "/dev/sda") through the "cbd_transport" to other hosts.

Any host that registers this transport can map this backend to a local
"cbd device"(such as "/dev/cbd0"). All reads and writes to "cbd0" are
transmitted through the channel inside the transport to the backend. The handler
inside the backend is responsible for processing these read and write
requests, converting them into read and write requests corresponding to
"sda".

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_backend.c | 395 ++++++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_handler.c | 242 +++++++++++++++++++
 2 files changed, 637 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_backend.c
 create mode 100644 drivers/block/cbd/cbd_handler.c

diff --git a/drivers/block/cbd/cbd_backend.c b/drivers/block/cbd/cbd_backend.c
new file mode 100644
index 000000000000..2f7e61b09779
--- /dev/null
+++ b/drivers/block/cbd/cbd_backend.c
@@ -0,0 +1,395 @@
+#include "cbd_internal.h"
+
+static ssize_t backend_host_id_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend_info *backend_info;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	backend_info = backend->backend_info;
+
+	if (backend_info->state == cbd_backend_state_none)
+		return 0;
+
+	return sprintf(buf, "%u\n", backend_info->host_id);
+}
+
+static DEVICE_ATTR(host_id, 0400, backend_host_id_show, NULL);
+
+static ssize_t backend_path_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend_info *backend_info;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	backend_info = backend->backend_info;
+
+	if (backend_info->state == cbd_backend_state_none)
+		return 0;
+
+	return sprintf(buf, "%s\n", backend_info->path);
+}
+
+static DEVICE_ATTR(path, 0400, backend_path_show, NULL);
+
+CBD_OBJ_HEARTBEAT(backend);
+
+static struct attribute *cbd_backend_attrs[] = {
+	&dev_attr_path.attr,
+	&dev_attr_host_id.attr,
+	&dev_attr_alive.attr,
+	NULL
+};
+
+static struct attribute_group cbd_backend_attr_group = {
+	.attrs = cbd_backend_attrs,
+};
+
+static const struct attribute_group *cbd_backend_attr_groups[] = {
+	&cbd_backend_attr_group,
+	NULL
+};
+
+static void cbd_backend_release(struct device *dev)
+{
+}
+
+const struct device_type cbd_backend_type = {
+	.name		= "cbd_backend",
+	.groups		= cbd_backend_attr_groups,
+	.release	= cbd_backend_release,
+};
+
+const struct device_type cbd_backends_type = {
+	.name		= "cbd_backends",
+	.release	= cbd_backend_release,
+};
+
+int cbdb_add_handler(struct cbd_backend *cbdb, struct cbd_handler *handler)
+{
+	int ret = 0;
+
+	spin_lock(&cbdb->lock);
+	if (cbdb->backend_info->state == cbd_backend_state_removing) {
+		ret = -EFAULT;
+		goto out;
+	}
+	hash_add(cbdb->handlers_hash, &handler->hash_node, handler->channel.seg_id);
+out:
+	spin_unlock(&cbdb->lock);
+	return ret;
+}
+
+void cbdb_del_handler(struct cbd_backend *cbdb, struct cbd_handler *handler)
+{
+	spin_lock(&cbdb->lock);
+	hash_del(&handler->hash_node);
+	spin_unlock(&cbdb->lock);
+}
+
+static struct cbd_handler *cbdb_get_handler(struct cbd_backend *cbdb, u32 seg_id)
+{
+	struct cbd_handler *handler;
+	bool found = false;
+
+	spin_lock(&cbdb->lock);
+	hash_for_each_possible(cbdb->handlers_hash, handler,
+			       hash_node, seg_id) {
+		if (handler->channel.seg_id == seg_id) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock(&cbdb->lock);
+
+	if (found)
+		return handler;
+
+	return NULL;
+}
+
+static void state_work_fn(struct work_struct *work)
+{
+	struct cbd_backend *cbdb = container_of(work, struct cbd_backend, state_work.work);
+	struct cbd_transport *cbdt = cbdb->cbdt;
+	struct cbd_segment_info *segment_info;
+	struct cbd_channel_info *channel_info;
+	u32 blkdev_state, backend_state, backend_id;
+	int ret;
+	int i;
+
+	for (i = 0; i < cbdt->transport_info->segment_num; i++) {
+		segment_info = cbdt_get_segment_info(cbdt, i);
+		if (segment_info->type != cbds_type_channel)
+			continue;
+
+		channel_info = (struct cbd_channel_info *)segment_info;
+
+		blkdev_state = channel_info->blkdev_state;
+		backend_state = channel_info->backend_state;
+		backend_id = channel_info->backend_id;
+
+		if (blkdev_state == cbdc_blkdev_state_running &&
+				backend_state == cbdc_backend_state_none &&
+				backend_id == cbdb->backend_id) {
+
+			ret = cbd_handler_create(cbdb, i);
+			if (ret) {
+				cbdb_err(cbdb, "create handler for %u error", i);
+				continue;
+			}
+		}
+
+		if (blkdev_state == cbdc_blkdev_state_none &&
+				backend_state == cbdc_backend_state_running &&
+				backend_id == cbdb->backend_id) {
+			struct cbd_handler *handler;
+
+			handler = cbdb_get_handler(cbdb, i);
+			if (!handler)
+				continue;
+			cbd_handler_destroy(handler);
+		}
+	}
+
+	queue_delayed_work(cbd_wq, &cbdb->state_work, 1 * HZ);
+}
+
+static int cbd_backend_init(struct cbd_backend *cbdb, bool new_backend)
+{
+	struct cbd_backend_info *b_info;
+	struct cbd_transport *cbdt = cbdb->cbdt;
+	int ret;
+
+	b_info = cbdt_get_backend_info(cbdt, cbdb->backend_id);
+	cbdb->backend_info = b_info;
+
+	b_info->host_id = cbdb->cbdt->host->host_id;
+
+	cbdb->backend_io_cache = KMEM_CACHE(cbd_backend_io, 0);
+	if (!cbdb->backend_io_cache) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	cbdb->task_wq = alloc_workqueue("cbdt%d-b%u",  WQ_UNBOUND | WQ_MEM_RECLAIM,
+					0, cbdt->id, cbdb->backend_id);
+	if (!cbdb->task_wq) {
+		ret = -ENOMEM;
+		goto destroy_io_cache;
+	}
+
+	cbdb->bdev_file = bdev_file_open_by_path(cbdb->path,
+			BLK_OPEN_READ | BLK_OPEN_WRITE, cbdb, NULL);
+	if (IS_ERR(cbdb->bdev_file)) {
+		cbdt_err(cbdt, "failed to open bdev: %d", (int)PTR_ERR(cbdb->bdev_file));
+		ret = PTR_ERR(cbdb->bdev_file);
+		goto destroy_wq;
+	}
+
+	cbdb->bdev = file_bdev(cbdb->bdev_file);
+	if (new_backend) {
+		b_info->dev_size = bdev_nr_sectors(cbdb->bdev);
+	} else {
+		if (b_info->dev_size != bdev_nr_sectors(cbdb->bdev)) {
+			cbdt_err(cbdt, "Unexpected backend size: %llu, expected: %llu\n",
+				 bdev_nr_sectors(cbdb->bdev), b_info->dev_size);
+			ret = -EINVAL;
+			goto close_file;
+		}
+	}
+
+	INIT_DELAYED_WORK(&cbdb->state_work, state_work_fn);
+	INIT_DELAYED_WORK(&cbdb->hb_work, backend_hb_workfn);
+	hash_init(cbdb->handlers_hash);
+	cbdb->backend_device = &cbdt->cbd_backends_dev->backend_devs[cbdb->backend_id];
+
+	spin_lock_init(&cbdb->lock);
+
+	b_info->state = cbd_backend_state_running;
+
+	queue_delayed_work(cbd_wq, &cbdb->state_work, 0);
+	queue_delayed_work(cbd_wq, &cbdb->hb_work, 0);
+
+	return 0;
+
+close_file:
+	fput(cbdb->bdev_file);
+destroy_wq:
+	destroy_workqueue(cbdb->task_wq);
+destroy_io_cache:
+	kmem_cache_destroy(cbdb->backend_io_cache);
+err:
+	return ret;
+}
+
+extern struct device_type cbd_cache_type;
+
+int cbd_backend_start(struct cbd_transport *cbdt, char *path, u32 backend_id, u32 cache_segs)
+{
+	struct cbd_backend *backend;
+	struct cbd_backend_info *backend_info;
+	struct cbd_cache_info *cache_info;
+	bool new_backend = false;
+	int ret;
+
+	if (backend_id == U32_MAX)
+		new_backend = true;
+
+	if (new_backend) {
+		ret = cbdt_get_empty_backend_id(cbdt, &backend_id);
+		if (ret)
+			return ret;
+
+		backend_info = cbdt_get_backend_info(cbdt, backend_id);
+		cache_info = &backend_info->cache_info;
+		cache_info->n_segs = cache_segs;
+	} else {
+		backend_info = cbdt_get_backend_info(cbdt, backend_id);
+		if (cbd_backend_info_is_alive(backend_info))
+			return -EBUSY;
+		cache_info = &backend_info->cache_info;
+	}
+
+	backend = kzalloc(sizeof(*backend), GFP_KERNEL);
+	if (!backend)
+		return -ENOMEM;
+
+	strscpy(backend->path, path, CBD_PATH_LEN);
+	memcpy(backend_info->path, backend->path, CBD_PATH_LEN);
+	INIT_LIST_HEAD(&backend->node);
+	backend->backend_id = backend_id;
+	backend->cbdt = cbdt;
+
+	ret = cbd_backend_init(backend, new_backend);
+	if (ret) {
+		kfree(backend);
+		return ret;
+	}
+
+	cbdt_add_backend(cbdt, backend);
+
+	if (cache_info->n_segs) {
+		struct cbd_cache_opts cache_opts = { 0 };
+
+		cache_opts.cache_info = cache_info;
+		cache_opts.alloc_segs = new_backend;
+		cache_opts.start_writeback = true;
+		cache_opts.start_gc = false;
+		cache_opts.init_keys = false;
+		cache_opts.bdev_file = backend->bdev_file;
+		cache_opts.dev_size = backend_info->dev_size;
+		backend->cbd_cache = cbd_cache_alloc(cbdt, &cache_opts);
+		if (!backend->cbd_cache) {
+			ret = -ENOMEM;
+			goto backend_stop;
+		}
+
+		device_initialize(&backend->cache_dev);
+		device_set_pm_not_required(&backend->cache_dev);
+		dev_set_name(&backend->cache_dev, "cache");
+		backend->cache_dev.parent = &backend->backend_device->dev;
+		backend->cache_dev.type = &cbd_cache_type;
+		ret = device_add(&backend->cache_dev);
+		if (ret)
+			goto backend_stop;
+		backend->cache_dev_registered = true;
+	}
+
+	return 0;
+
+backend_stop:
+	cbd_backend_stop(cbdt, backend_id);
+
+	return ret;
+}
+
+int cbd_backend_stop(struct cbd_transport *cbdt, u32 backend_id)
+{
+	struct cbd_backend *cbdb;
+	struct cbd_backend_info *backend_info;
+
+	cbdb = cbdt_get_backend(cbdt, backend_id);
+	if (!cbdb)
+		return -ENOENT;
+
+	spin_lock(&cbdb->lock);
+	if (!hash_empty(cbdb->handlers_hash)) {
+		spin_unlock(&cbdb->lock);
+		return -EBUSY;
+	}
+
+	if (cbdb->backend_info->state == cbd_backend_state_removing) {
+		spin_unlock(&cbdb->lock);
+		return -EBUSY;
+	}
+
+	cbdb->backend_info->state = cbd_backend_state_removing;
+	spin_unlock(&cbdb->lock);
+
+	cbdt_del_backend(cbdt, cbdb);
+
+	if (cbdb->cbd_cache) {
+		if (cbdb->cache_dev_registered)
+			device_unregister(&cbdb->cache_dev);
+		cbd_cache_destroy(cbdb->cbd_cache);
+	}
+
+	cancel_delayed_work_sync(&cbdb->hb_work);
+	cancel_delayed_work_sync(&cbdb->state_work);
+
+	backend_info = cbdt_get_backend_info(cbdt, cbdb->backend_id);
+	backend_info->state = cbd_backend_state_none;
+	backend_info->alive_ts = 0;
+
+	drain_workqueue(cbdb->task_wq);
+	destroy_workqueue(cbdb->task_wq);
+
+	kmem_cache_destroy(cbdb->backend_io_cache);
+
+	fput(cbdb->bdev_file);
+	kfree(cbdb);
+
+	return 0;
+}
+
+int cbd_backend_clear(struct cbd_transport *cbdt, u32 backend_id)
+{
+	struct cbd_backend_info *backend_info;
+
+	backend_info = cbdt_get_backend_info(cbdt, backend_id);
+	if (cbd_backend_info_is_alive(backend_info)) {
+		cbdt_err(cbdt, "backend %u is still alive\n", backend_id);
+		return -EBUSY;
+	}
+
+	if (backend_info->state == cbd_backend_state_none)
+		return 0;
+
+	backend_info->state = cbd_backend_state_none;
+
+	return 0;
+}
+
+bool cbd_backend_cache_on(struct cbd_backend_info *backend_info)
+{
+	return (backend_info->cache_info.n_segs != 0);
+}
+
+void cbd_backend_notify(struct cbd_backend *cbdb, u32 seg_id)
+{
+	struct cbd_handler *handler;
+
+	handler = cbdb_get_handler(cbdb, seg_id);
+	/*
+	 * If the handler is not ready, return directly and
+	 * wait handler to queue the handle_work in creating
+	 */
+	if (!handler)
+		return;
+	cbd_handler_notify(handler);
+}
diff --git a/drivers/block/cbd/cbd_handler.c b/drivers/block/cbd/cbd_handler.c
new file mode 100644
index 000000000000..6589dbe9acc7
--- /dev/null
+++ b/drivers/block/cbd/cbd_handler.c
@@ -0,0 +1,242 @@
+#include "cbd_internal.h"
+
+static inline struct cbd_se *get_se_head(struct cbd_handler *handler)
+{
+	return (struct cbd_se *)(handler->channel.submr + handler->channel_info->submr_head);
+}
+
+static inline struct cbd_se *get_se_to_handle(struct cbd_handler *handler)
+{
+	return (struct cbd_se *)(handler->channel.submr + handler->se_to_handle);
+}
+
+static inline struct cbd_ce *get_compr_head(struct cbd_handler *handler)
+{
+	return (struct cbd_ce *)(handler->channel.compr + handler->channel_info->compr_head);
+}
+
+static inline void complete_cmd(struct cbd_handler *handler, struct cbd_se *se, int ret)
+{
+	struct cbd_ce *ce;
+	unsigned long flags;
+
+	spin_lock_irqsave(&handler->compr_lock, flags);
+	ce = get_compr_head(handler);
+
+	memset(ce, 0, sizeof(*ce));
+	ce->req_tid = se->req_tid;
+	ce->result = ret;
+#ifdef CONFIG_CBD_CRC
+	if (se->op == CBD_OP_READ)
+		ce->data_crc = cbd_channel_crc(&handler->channel, se->data_off, se->data_len);
+	ce->ce_crc = cbd_ce_crc(ce);
+#endif
+	CBDC_UPDATE_COMPR_HEAD(handler->channel_info->compr_head,
+			       sizeof(struct cbd_ce),
+			       handler->channel.compr_size);
+	spin_unlock_irqrestore(&handler->compr_lock, flags);
+}
+
+static void backend_bio_end(struct bio *bio)
+{
+	struct cbd_backend_io *backend_io = bio->bi_private;
+	struct cbd_se *se = backend_io->se;
+	struct cbd_handler *handler = backend_io->handler;
+	struct cbd_backend *cbdb = handler->cbdb;
+
+	complete_cmd(handler, se, bio->bi_status);
+
+	bio_put(bio);
+	kmem_cache_free(cbdb->backend_io_cache, backend_io);
+}
+
+static struct cbd_backend_io *backend_prepare_io(struct cbd_handler *handler,
+						 struct cbd_se *se, blk_opf_t opf)
+{
+	struct cbd_backend_io *backend_io;
+	struct cbd_backend *cbdb = handler->cbdb;
+
+	backend_io = kmem_cache_zalloc(cbdb->backend_io_cache, GFP_KERNEL);
+	if (!backend_io)
+		return NULL;
+	backend_io->se = se;
+
+	backend_io->handler = handler;
+	backend_io->bio = bio_alloc_bioset(cbdb->bdev,
+				DIV_ROUND_UP(se->len, PAGE_SIZE),
+				opf, GFP_KERNEL, &handler->bioset);
+
+	if (!backend_io->bio) {
+		kmem_cache_free(cbdb->backend_io_cache, backend_io);
+		return NULL;
+	}
+
+	backend_io->bio->bi_iter.bi_sector = se->offset >> SECTOR_SHIFT;
+	backend_io->bio->bi_iter.bi_size = 0;
+	backend_io->bio->bi_private = backend_io;
+	backend_io->bio->bi_end_io = backend_bio_end;
+
+	return backend_io;
+}
+
+static int handle_backend_cmd(struct cbd_handler *handler, struct cbd_se *se)
+{
+	struct cbd_backend *cbdb = handler->cbdb;
+	struct cbd_backend_io *backend_io = NULL;
+	int ret;
+
+	if (cbd_se_flags_test(se, CBD_SE_FLAGS_DONE))
+		return 0;
+
+	switch (se->op) {
+	case CBD_OP_READ:
+		backend_io = backend_prepare_io(handler, se, REQ_OP_READ);
+		break;
+	case CBD_OP_WRITE:
+		backend_io = backend_prepare_io(handler, se, REQ_OP_WRITE);
+		break;
+	case CBD_OP_FLUSH:
+		ret = blkdev_issue_flush(cbdb->bdev);
+		goto complete_cmd;
+	default:
+		cbd_handler_err(handler, "unrecognized op: 0x%x", se->op);
+		ret = -EIO;
+		goto complete_cmd;
+	}
+
+	if (!backend_io)
+		return -ENOMEM;
+
+	ret = cbdc_map_pages(&handler->channel, backend_io);
+	if (ret) {
+		kmem_cache_free(cbdb->backend_io_cache, backend_io);
+		return ret;
+	}
+
+	submit_bio(backend_io->bio);
+
+	return 0;
+
+complete_cmd:
+	complete_cmd(handler, se, ret);
+	return 0;
+}
+
+void cbd_handler_notify(struct cbd_handler *handler)
+{
+	queue_delayed_work(handler->cbdb->task_wq, &handler->handle_work, 0);
+}
+
+static void handle_work_fn(struct work_struct *work)
+{
+	struct cbd_handler *handler = container_of(work, struct cbd_handler,
+						   handle_work.work);
+	struct cbd_se *se;
+	u64 req_tid;
+	int ret;
+
+again:
+	/* channel ctrl would be updated by blkdev queue */
+	se = get_se_to_handle(handler);
+	if (se == get_se_head(handler))
+		goto miss;
+
+	req_tid = se->req_tid;
+	if (handler->req_tid_expected != U64_MAX &&
+			req_tid != handler->req_tid_expected) {
+		cbd_handler_err(handler, "req_tid (%llu) is not expected (%llu)",
+				req_tid, handler->req_tid_expected);
+		goto miss;
+	}
+
+#ifdef CONFIG_CBD_CRC
+	if (se->se_crc != cbd_se_crc(se)) {
+		cbd_handler_err(handler, "se crc(0x%x) is not expected(0x%x)",
+				cbd_se_crc(se), se->se_crc);
+		goto miss;
+	}
+
+	if (se->op == CBD_OP_WRITE &&
+		se->data_crc != cbd_channel_crc(&handler->channel,
+						se->data_off,
+						se->data_len)) {
+		cbd_handler_err(handler, "data crc(0x%x) is not expected(0x%x)",
+				cbd_channel_crc(&handler->channel, se->data_off, se->data_len),
+				se->data_crc);
+		goto miss;
+	}
+#endif
+
+	cbdwc_hit(&handler->handle_worker_cfg);
+	ret = handle_backend_cmd(handler, se);
+	if (!ret) {
+		/* this se is handled */
+		handler->req_tid_expected = req_tid + 1;
+		handler->se_to_handle = (handler->se_to_handle + sizeof(struct cbd_se)) %
+							handler->channel.submr_size;
+	}
+
+	goto again;
+
+miss:
+	if (cbdwc_need_retry(&handler->handle_worker_cfg))
+		goto again;
+
+	cbdwc_miss(&handler->handle_worker_cfg);
+
+	if (handler->polling)
+		queue_delayed_work(handler->cbdb->task_wq, &handler->handle_work, 0);
+}
+
+int cbd_handler_create(struct cbd_backend *cbdb, u32 channel_id)
+{
+	struct cbd_transport *cbdt = cbdb->cbdt;
+	struct cbd_handler *handler;
+	int ret;
+
+	handler = kzalloc(sizeof(struct cbd_handler), GFP_KERNEL);
+	if (!handler)
+		return -ENOMEM;
+
+	ret = bioset_init(&handler->bioset, 256, 0, BIOSET_NEED_BVECS);
+	if (ret)
+		goto err;
+
+	handler->cbdb = cbdb;
+	cbd_channel_init(&handler->channel, cbdt, channel_id);
+	handler->channel_info = handler->channel.channel_info;
+
+	if (handler->channel_info->polling)
+		handler->polling = true;
+
+	handler->se_to_handle = handler->channel_info->submr_tail;
+	handler->req_tid_expected = U64_MAX;
+
+	spin_lock_init(&handler->compr_lock);
+	INIT_DELAYED_WORK(&handler->handle_work, handle_work_fn);
+
+	cbdwc_init(&handler->handle_worker_cfg);
+
+	cbdb_add_handler(cbdb, handler);
+	handler->channel_info->backend_state = cbdc_backend_state_running;
+
+	queue_delayed_work(cbdb->task_wq, &handler->handle_work, 0);
+
+	return 0;
+err:
+	kfree(handler);
+	return ret;
+};
+
+void cbd_handler_destroy(struct cbd_handler *handler)
+{
+	cbdb_del_handler(handler->cbdb, handler);
+
+	cancel_delayed_work_sync(&handler->handle_work);
+
+	handler->channel_info->backend_state = cbdc_backend_state_none;
+	cbd_channel_exit(&handler->channel);
+
+	bioset_exit(&handler->bioset);
+	kfree(handler);
+}
-- 
2.34.1



Return-Path: <linux-bcache+bounces-834-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 949E4A03C6D
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C54D160DAD
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44BE1EE00B;
	Tue,  7 Jan 2025 10:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vZjivCIT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB961EC00B
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245892; cv=none; b=sxgm6YhEaKbeyiF7+s3JxxvRHdV3eL3o9zYSEj1HRAsg/WMFzxBi/hpxdlU0AReOVc+sw1YyL6YXv1S8hiu389maMNnVwrV7jegKptMY1oeenAWOamc1a9gcizooUjvVKL6SHR5M+a12wK8sDR8tpEQxTQyQo3ynPnoJ97WVp1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245892; c=relaxed/simple;
	bh=D548V7hh0U46rF7q+LXm4bbB87LYBjBii1yPiOSqpGc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i4xPZb5KBqfEK88ncsi0gFTlGKulTEZEFAQ+XP2uyhMgdPlR2kxf2yhmlMxJP2TVeTCJyfXY2DQ1lXv1QI2uHDSRpME9sGRvkrq96nC7PvJ9f6nhRZMsSqUG+cCMi7bw0MT8kzz/f0tpLGH7ZZQC7ypGih/i38pucaRpBw2dLJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vZjivCIT; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8q+hOL6iOB+NGsGoQrl03bMceyTd32KNtqiUhx+Q/S0=;
	b=vZjivCITOU2mJyqBgpRiWGkrCFftJ2SQ+j9t0QDocOfafNluZztL/hPHGNKB7cYeuSYPfl
	FJahRSLCcqXJmVCJDYHOKBXR2EYaytnBTvLo41H3FW0qZchGoeoGBd98pj93RgZaO2hN9b
	U3ngGfRTLd/NcliBKR0zDTvkhK+tWuQ=
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
Subject: [PATCH v3 6/8] cbd: introduce cbd_backend
Date: Tue,  7 Jan 2025 10:30:22 +0000
Message-Id: <20250107103024.326986-7-dongsheng.yang@linux.dev>
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
 drivers/block/cbd/cbd_backend.c | 730 ++++++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_backend.h | 137 ++++++
 drivers/block/cbd/cbd_handler.c | 468 ++++++++++++++++++++
 drivers/block/cbd/cbd_handler.h |  66 +++
 4 files changed, 1401 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_backend.c
 create mode 100644 drivers/block/cbd/cbd_backend.h
 create mode 100644 drivers/block/cbd/cbd_handler.c
 create mode 100644 drivers/block/cbd/cbd_handler.h

diff --git a/drivers/block/cbd/cbd_backend.c b/drivers/block/cbd/cbd_backend.c
new file mode 100644
index 000000000000..e576658c237c
--- /dev/null
+++ b/drivers/block/cbd/cbd_backend.c
@@ -0,0 +1,730 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cbd_internal.h"
+#include "cbd_transport.h"
+#include "cbd_host.h"
+#include "cbd_segment.h"
+#include "cbd_channel.h"
+#include "cbd_cache/cbd_cache.h"
+#include "cbd_handler.h"
+#include "cbd_backend.h"
+
+static ssize_t host_id_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend_info *latest_info;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	latest_info = cbdt_backend_info_read(backend->cbdt, backend->id);
+	if (!latest_info || latest_info->state == CBD_BACKEND_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%u\n", latest_info->host_id);
+}
+static DEVICE_ATTR_ADMIN_RO(host_id);
+
+static ssize_t path_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend_info *latest_info;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	latest_info = cbdt_backend_info_read(backend->cbdt, backend->id);
+	if (!latest_info || latest_info->state == CBD_BACKEND_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%s\n", latest_info->path);
+}
+static DEVICE_ATTR_ADMIN_RO(path);
+
+/* sysfs for cache */
+static ssize_t cache_segs_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend_info *latest_info;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	latest_info = cbdt_backend_info_read(backend->cbdt, backend->id);
+	if (!latest_info || latest_info->state == CBD_BACKEND_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%u\n", latest_info->cache_info.n_segs);
+}
+static DEVICE_ATTR_ADMIN_RO(cache_segs);
+
+static ssize_t cache_used_segs_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend_info *latest_info;
+	u32 used_segs = 0;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	latest_info = cbdt_backend_info_read(backend->cbdt, backend->id);
+	if (!latest_info || latest_info->state == CBD_BACKEND_STATE_NONE)
+		return 0;
+
+	if (!latest_info->cache_info.n_segs)
+		goto out;
+
+	used_segs = cache_info_used_segs(backend->cbdt, &latest_info->cache_info);
+out:
+	return sprintf(buf, "%u\n", used_segs);
+}
+static DEVICE_ATTR_ADMIN_RO(cache_used_segs);
+
+static ssize_t cache_gc_percent_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend_info *latest_info;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	latest_info = cbdt_backend_info_read(backend->cbdt, backend->id);
+	if (!latest_info || latest_info->state == CBD_BACKEND_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%u\n", latest_info->cache_info.gc_percent);
+}
+
+static void __backend_info_write(struct cbd_backend *cbdb);
+static ssize_t cache_gc_percent_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t size)
+{
+	struct cbd_backend_device *backend;
+	struct cbd_backend *cbdb;
+	unsigned long val;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	backend = container_of(dev, struct cbd_backend_device, dev);
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val < CBD_CACHE_GC_PERCENT_MIN ||
+	    val > CBD_CACHE_GC_PERCENT_MAX)
+		return -EINVAL;
+
+	cbdb = cbdt_get_backend(backend->cbdt, backend->id);
+	if (!cbdb) {
+		cbdt_err(backend->cbdt, "gc_percent is only allowed to set in backend node.\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&cbdb->info_lock);
+	if (cbdb->backend_info.cache_info.n_segs == 0) {
+		mutex_unlock(&cbdb->info_lock);
+		return -EINVAL;
+	}
+
+	cbdb->backend_info.cache_info.gc_percent = val;
+	__backend_info_write(cbdb);
+	mutex_unlock(&cbdb->info_lock);
+
+	return size;
+}
+static DEVICE_ATTR_ADMIN_RW(cache_gc_percent);
+
+static void cbd_backend_hb(struct cbd_backend *cbdb)
+{
+	cbd_backend_info_write(cbdb);
+}
+CBD_OBJ_HEARTBEAT(backend);
+
+static struct attribute *cbd_backend_attrs[] = {
+	&dev_attr_path.attr,
+	&dev_attr_host_id.attr,
+	&dev_attr_alive.attr,
+	&dev_attr_cache_segs.attr,
+	&dev_attr_cache_gc_percent.attr,
+	&dev_attr_cache_used_segs.attr,
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
+	if (cbdb->backend_info.state == CBD_BACKEND_STATE_STOPPING) {
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
+	if (hlist_unhashed(&handler->hash_node))
+		return;
+
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
+static void destroy_handlers(struct cbd_backend *cbdb)
+{
+	struct cbd_handler *handler;
+	struct hlist_node *tmp;
+	int i;
+
+	hash_for_each_safe(cbdb->handlers_hash, i, tmp, handler, hash_node) {
+		hash_del(&handler->hash_node);
+		cbd_handler_destroy(handler);
+	}
+}
+
+static int create_handlers(struct cbd_backend *cbdb, bool new_backend)
+{
+	struct cbd_backend_info *backend_info;
+	u32 channel_id;
+	int ret;
+	int i;
+
+	backend_info = &cbdb->backend_info;
+
+	for (i = 0; i < backend_info->n_handlers; i++) {
+		if (new_backend) {
+			ret = cbdt_get_empty_segment_id(cbdb->cbdt, &channel_id);
+			if (ret < 0) {
+				cbdb_err(cbdb, "failed find available channel_id.\n");
+				goto destroy_handlers;
+			}
+			/* clear all channel segment before using it */
+			cbd_segment_clear(cbdb->cbdt, channel_id);
+			backend_info->handler_channels[i] = channel_id;
+		} else {
+			channel_id = backend_info->handler_channels[i];
+		}
+
+		ret = cbd_handler_create(cbdb, channel_id, new_backend);
+		if (ret) {
+			cbdb_err(cbdb, "failed to create handler: %d\n", ret);
+			goto destroy_handlers;
+		}
+	}
+
+	return 0;
+
+destroy_handlers:
+	destroy_handlers(cbdb);
+
+	return ret;
+}
+
+static int backend_open_bdev(struct cbd_backend *cbdb, bool new_backend)
+{
+	int ret;
+
+	cbdb->bdev_file = bdev_file_open_by_path(cbdb->backend_info.path,
+			BLK_OPEN_READ | BLK_OPEN_WRITE, cbdb, NULL);
+	if (IS_ERR(cbdb->bdev_file)) {
+		cbdb_err(cbdb, "failed to open bdev: %d", (int)PTR_ERR(cbdb->bdev_file));
+		ret = PTR_ERR(cbdb->bdev_file);
+		goto err;
+	}
+
+	cbdb->bdev = file_bdev(cbdb->bdev_file);
+
+	if (new_backend) {
+		cbdb->backend_info.dev_size = bdev_nr_sectors(cbdb->bdev);
+	} else {
+		if (cbdb->backend_info.dev_size != bdev_nr_sectors(cbdb->bdev)) {
+			cbdb_err(cbdb, "Unexpected backend size: %llu, expected: %llu\n",
+				 bdev_nr_sectors(cbdb->bdev), cbdb->backend_info.dev_size);
+			ret = -EINVAL;
+			goto close_file;
+		}
+	}
+
+	return 0;
+
+close_file:
+	fput(cbdb->bdev_file);
+err:
+	return ret;
+}
+
+static void backend_close_bdev(struct cbd_backend *cbdb)
+{
+	fput(cbdb->bdev_file);
+}
+
+static int backend_cache_init(struct cbd_backend *cbdb, u32 cache_segs, bool new_backend)
+{
+	struct cbd_cache_opts cache_opts = { 0 };
+	int ret;
+
+	cache_opts.cache_info = &cbdb->backend_info.cache_info;
+	cache_opts.cache_id = cbdb->backend_id;
+	cache_opts.owner = cbdb;
+	cache_opts.n_segs = cache_segs;
+	cache_opts.n_paral = cbdb->backend_info.n_handlers;
+	cache_opts.new_cache = new_backend;
+	cache_opts.start_writeback = true;
+	cache_opts.start_gc = false;
+	cache_opts.init_req_keys = false;
+	cache_opts.bdev_file = cbdb->bdev_file;
+	cache_opts.dev_size = cbdb->backend_info.dev_size;
+
+	/* Allocate the cache with specified options. */
+	cbdb->cbd_cache = cbd_cache_alloc(cbdb->cbdt, &cache_opts);
+	if (!cbdb->cbd_cache) {
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
+static void backend_cache_destroy(struct cbd_backend *cbdb)
+{
+	if (cbdb->cbd_cache)
+		cbd_cache_destroy(cbdb->cbd_cache);
+}
+
+static int cbd_backend_info_init(struct cbd_backend *cbdb, char *path,
+				 u32 handlers, u32 cache_segs)
+{
+	struct cbd_transport *cbdt = cbdb->cbdt;
+	u32 backend_id;
+	int ret;
+
+	ret = cbdt_get_empty_backend_id(cbdt, &backend_id);
+	if (ret)
+		goto err;
+
+	cbdb->backend_id = backend_id;
+	cbdb->backend_info.meta_header.version = 0;
+	cbdb->backend_info.host_id = cbdb->host_id;
+	cbdb->backend_info.n_handlers = handlers;
+
+	strscpy(cbdb->backend_info.path, path, CBD_PATH_LEN);
+
+	cbd_cache_info_init(&cbdb->backend_info.cache_info, cache_segs);
+
+	return 0;
+err:
+	return ret;
+}
+
+static int cbd_backend_info_load(struct cbd_backend *cbdb, u32 backend_id);
+static int cbd_backend_init(struct cbd_backend *cbdb, char *path, u32 backend_id,
+			    u32 handlers, u32 cache_segs)
+{
+	struct cbd_transport *cbdt = cbdb->cbdt;
+	bool new_backend = false;
+	int ret;
+
+	if (backend_id == U32_MAX)
+		new_backend = true;
+
+	if (new_backend) {
+		/* new backend */
+		ret = cbd_backend_info_init(cbdb, path, handlers, cache_segs);
+		if (ret)
+			goto err;
+	} else {
+		/* attach backend, this could happen after an unexpected power off */
+		cbdt_info(cbdt, "attach backend to backend_id: %u\n", backend_id);
+		cbdb->backend_id = backend_id;
+		ret = cbd_backend_info_load(cbdb, cbdb->backend_id);
+		if (ret)
+			goto err;
+	}
+
+	cbdb->backend_device = &cbdt->cbd_backends_dev->backend_devs[cbdb->backend_id];
+
+	ret = backend_open_bdev(cbdb, new_backend);
+	if (ret)
+		goto err;
+
+	ret = create_handlers(cbdb, new_backend);
+	if (ret)
+		goto close_bdev;
+
+	if (cbdb->backend_info.cache_info.n_segs) {
+		ret = backend_cache_init(cbdb, cbdb->backend_info.cache_info.n_segs, new_backend);
+		if (ret)
+			goto destroy_handlers;
+	}
+
+	cbdb->backend_info.state = CBD_BACKEND_STATE_RUNNING;
+	cbdt_add_backend(cbdt, cbdb);
+
+	return 0;
+
+destroy_handlers:
+	destroy_handlers(cbdb);
+close_bdev:
+	backend_close_bdev(cbdb);
+err:
+	return ret;
+}
+
+static void cbd_backend_destroy(struct cbd_backend *cbdb)
+{
+	struct cbd_transport *cbdt = cbdb->cbdt;
+
+	cbdt_del_backend(cbdt, cbdb);
+	backend_cache_destroy(cbdb);
+	destroy_handlers(cbdb);
+	backend_close_bdev(cbdb);
+}
+
+static void __backend_info_write(struct cbd_backend *cbdb)
+{
+	cbdb->backend_info.alive_ts = ktime_get_real();
+	cbdt_backend_info_write(cbdb->cbdt, &cbdb->backend_info, sizeof(struct cbd_backend_info),
+				cbdb->backend_id);
+}
+
+void cbd_backend_info_write(struct cbd_backend *cbdb)
+{
+	mutex_lock(&cbdb->info_lock);
+	__backend_info_write(cbdb);
+	mutex_unlock(&cbdb->info_lock);
+}
+
+static int cbd_backend_info_load(struct cbd_backend *cbdb, u32 backend_id)
+{
+	struct cbd_backend_info *backend_info;
+	int ret = 0;
+
+	mutex_lock(&cbdb->info_lock);
+	backend_info = cbdt_backend_info_read(cbdb->cbdt, backend_id);
+	if (!backend_info) {
+		cbdt_err(cbdb->cbdt, "can't read info from backend id %u.\n",
+				cbdb->backend_id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (cbd_backend_info_is_alive(backend_info)) {
+		cbdt_err(cbdb->cbdt, "backend %u is alive\n", backend_id);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (backend_info->host_id != cbdb->host_id) {
+		cbdt_err(cbdb->cbdt, "backend_id: %u is on host %u but not on host %u\n",
+				cbdb->backend_id, backend_info->host_id, cbdb->host_id);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	memcpy(&cbdb->backend_info, backend_info, sizeof(struct cbd_backend_info));
+out:
+	mutex_unlock(&cbdb->info_lock);
+	return ret;
+}
+
+static struct cbd_backend *cbd_backend_alloc(struct cbd_transport *cbdt)
+{
+	struct cbd_backend *cbdb;
+
+	cbdb = kzalloc(sizeof(*cbdb), GFP_KERNEL);
+	if (!cbdb)
+		return NULL;
+
+	cbdb->backend_io_cache = KMEM_CACHE(cbd_backend_io, 0);
+	if (!cbdb->backend_io_cache)
+		goto free_cbdb;
+
+	cbdb->task_wq = alloc_workqueue("cbdt%d-b%u",  WQ_UNBOUND | WQ_MEM_RECLAIM,
+					0, cbdt->id, cbdb->backend_id);
+	if (!cbdb->task_wq)
+		goto destroy_io_cache;
+
+	cbdb->cbdt = cbdt;
+	cbdb->host_id = cbdt->host->host_id;
+
+	mutex_init(&cbdb->info_lock);
+	INIT_LIST_HEAD(&cbdb->node);
+	INIT_DELAYED_WORK(&cbdb->hb_work, backend_hb_workfn);
+	hash_init(cbdb->handlers_hash);
+	spin_lock_init(&cbdb->lock);
+
+	return cbdb;
+
+destroy_io_cache:
+	kmem_cache_destroy(cbdb->backend_io_cache);
+free_cbdb:
+	kfree(cbdb);
+	return NULL;
+}
+
+static void cbd_backend_free(struct cbd_backend *cbdb)
+{
+	drain_workqueue(cbdb->task_wq);
+	destroy_workqueue(cbdb->task_wq);
+	kmem_cache_destroy(cbdb->backend_io_cache);
+	kfree(cbdb);
+}
+
+static int backend_validate(struct cbd_transport *cbdt, char *path,
+			    u32 *backend_id, u32 handlers, u32 cache_segs)
+{
+	u32 host_id = cbdt->host->host_id;
+	int ret;
+
+	/* Check if path starts with "/dev/" */
+	if (strncmp(path, "/dev/", 5) != 0)
+		return -EINVAL;
+
+	/* Validate backend_id */
+	if (*backend_id == U32_MAX) {
+		ret = cbd_backend_find_id_by_path(cbdt, host_id, path, backend_id);
+		if (!ret)
+			cbdt_info(cbdt, "found backend_id: %u for host_id: %u, path: %s\n",
+					*backend_id, host_id, path);
+	} else {
+		u32 backend_id_tmp;
+
+		if (*backend_id != U32_MAX && *backend_id >= cbdt->transport_info.backend_num)
+			return -EINVAL;
+
+		ret = cbd_backend_find_id_by_path(cbdt, host_id, path, &backend_id_tmp);
+		if (!ret && (*backend_id != backend_id_tmp)) {
+			cbdt_err(cbdt, "duplicated backend path: %s with backend_id: %u\n",
+					path, backend_id_tmp);
+			return -EINVAL;
+		}
+	}
+
+	/* Ensure handlers count is within valid range */
+	if (handlers == 0 || handlers >= CBD_HANDLERS_MAX)
+		return -EINVAL;
+
+	/* All checks passed */
+	return 0;
+}
+
+int cbd_backend_start(struct cbd_transport *cbdt, char *path, u32 backend_id,
+		      u32 handlers, u32 cache_segs)
+{
+	struct cbd_backend *cbdb;
+	int ret;
+
+	ret = backend_validate(cbdt, path, &backend_id, handlers, cache_segs);
+	if (ret)
+		return ret;
+
+	cbdb = cbd_backend_alloc(cbdt);
+	if (!cbdb)
+		return -ENOMEM;
+
+	ret = cbd_backend_init(cbdb, path, backend_id, handlers, cache_segs);
+	if (ret)
+		goto destroy_cbdb;
+
+	cbd_backend_info_write(cbdb);
+	queue_delayed_work(cbd_wq, &cbdb->hb_work, CBD_HB_INTERVAL);
+
+	return 0;
+
+destroy_cbdb:
+	cbd_backend_free(cbdb);
+
+	return ret;
+}
+
+static bool backend_blkdevs_stopped(struct cbd_transport *cbdt, u32 backend_id)
+{
+	struct cbd_blkdev_info *blkdev_info;
+	int i;
+
+	cbd_for_each_blkdev_info(cbdt, i, blkdev_info) {
+		if (!blkdev_info)
+			continue;
+
+		if (blkdev_info->state != CBD_BLKDEV_STATE_RUNNING)
+			continue;
+
+		if (blkdev_info->backend_id == backend_id) {
+			cbdt_err(cbdt, "blkdev %u is connected to backend %u\n",
+					i, backend_id);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+int cbd_backend_stop(struct cbd_transport *cbdt, u32 backend_id)
+{
+	struct cbd_backend *cbdb;
+
+	cbdb = cbdt_get_backend(cbdt, backend_id);
+	if (!cbdb)
+		return -ENOENT;
+
+	if (!backend_blkdevs_stopped(cbdt, backend_id))
+		return -EBUSY;
+
+	spin_lock(&cbdb->lock);
+	if (cbdb->backend_info.state == CBD_BACKEND_STATE_STOPPING) {
+		spin_unlock(&cbdb->lock);
+		return -EBUSY;
+	}
+
+	cbdb->backend_info.state = CBD_BACKEND_STATE_STOPPING;
+	spin_unlock(&cbdb->lock);
+
+	cancel_delayed_work_sync(&cbdb->hb_work);
+	cbd_backend_destroy(cbdb);
+	cbd_backend_free(cbdb);
+
+	cbdt_backend_info_clear(cbdt, backend_id);
+
+	return 0;
+}
+
+static void backend_segs_clear(struct cbd_transport *cbdt, u32 backend_id)
+{
+	struct cbd_segment_info *seg_info;
+	u32 i;
+
+	cbd_for_each_segment_info(cbdt, i, seg_info) {
+		if (!seg_info)
+			continue;
+
+		if (seg_info->backend_id == backend_id)
+			cbdt_segment_info_clear(cbdt, i);
+	}
+}
+
+int cbd_backend_clear(struct cbd_transport *cbdt, u32 backend_id)
+{
+	struct cbd_backend_info *backend_info;
+
+	backend_info = cbdt_backend_info_read(cbdt, backend_id);
+	if (!backend_info) {
+		cbdt_err(cbdt, "all backend_info in backend_id: %u are corrupted.\n", backend_id);
+		return -EINVAL;
+	}
+
+	if (cbd_backend_info_is_alive(backend_info)) {
+		cbdt_err(cbdt, "backend %u is still alive\n", backend_id);
+		return -EBUSY;
+	}
+
+	if (backend_info->state == CBD_BACKEND_STATE_NONE)
+		return 0;
+
+	if (!backend_blkdevs_stopped(cbdt, backend_id))
+		return -EBUSY;
+
+	backend_segs_clear(cbdt, backend_id);
+	cbdt_backend_info_clear(cbdt, backend_id);
+
+	return 0;
+}
+
+bool cbd_backend_cache_on(struct cbd_backend_info *backend_info)
+{
+	return (backend_info->cache_info.n_segs != 0);
+}
+
+/**
+ * cbd_backend_notify - Notify the backend to handle an I/O request.
+ * @cbdb: Pointer to the cbd_backend structure.
+ * @seg_id: Segment ID associated with the request.
+ *
+ * This function is called in a single-host scenario after a block device
+ * sends an I/O request. It retrieves the corresponding handler for the
+ * given segment ID and, if the handler is ready, notifies it to proceed
+ * with handling the request. If the handler is not ready, the function
+ * returns immediately, allowing the handler to queue the handle_work
+ * while being created.
+ */
+void cbd_backend_notify(struct cbd_backend *cbdb, u32 seg_id)
+{
+	struct cbd_handler *handler;
+
+	handler = cbdb_get_handler(cbdb, seg_id);
+	/*
+	 * If the handler is not ready, return directly and
+	 * wait for the handler to queue the handle_work during creation.
+	 */
+	if (!handler)
+		return;
+
+	cbd_handler_notify(handler);
+}
+
+void cbd_backend_mgmt_notify(struct cbd_backend *cbdb, u32 seg_id)
+{
+	struct cbd_handler *handler;
+
+	handler = cbdb_get_handler(cbdb, seg_id);
+	if (!handler)
+		return;
+
+	cbd_handler_mgmt_notify(handler);
+}
diff --git a/drivers/block/cbd/cbd_backend.h b/drivers/block/cbd/cbd_backend.h
new file mode 100644
index 000000000000..82de238000bb
--- /dev/null
+++ b/drivers/block/cbd/cbd_backend.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_BACKEND_H
+#define _CBD_BACKEND_H
+
+#include <linux/hashtable.h>
+
+#include "cbd_internal.h"
+#include "cbd_transport.h"
+#include "cbd_host.h"
+#include "cbd_cache/cbd_cache.h"
+#include "cbd_handler.h"
+#include "cbd_blkdev.h"
+
+#define cbdb_err(backend, fmt, ...)						\
+	cbdt_err(backend->cbdt, "backend%d: " fmt,				\
+		 backend->backend_id, ##__VA_ARGS__)
+#define cbdb_info(backend, fmt, ...)						\
+	cbdt_info(backend->cbdt, "backend%d: " fmt,				\
+		 backend->backend_id, ##__VA_ARGS__)
+#define cbdb_debug(backend, fmt, ...)						\
+	cbdt_debug(backend->cbdt, "backend%d: " fmt,				\
+		 backend->backend_id, ##__VA_ARGS__)
+
+/* cbd_backend */
+CBD_DEVICE(backend);
+
+extern const struct device_type cbd_cache_type;
+
+#define CBD_BACKEND_STATE_NONE		0
+#define CBD_BACKEND_STATE_RUNNING	1
+#define CBD_BACKEND_STATE_STOPPING	2
+
+#define CBDB_BLKDEV_COUNT_MAX	1
+
+struct cbd_backend_info {
+	struct cbd_meta_header	meta_header;
+	u8			state;
+	u8			res;
+
+	u16			res1;
+	u32			host_id;
+
+	u64			alive_ts;
+	u64			dev_size; /* nr_sectors */
+
+	char			path[CBD_PATH_LEN];
+
+	u32			n_handlers;
+	u32			handler_channels[CBD_HANDLERS_MAX];
+
+	struct cbd_cache_info	cache_info;
+};
+
+struct cbd_backend_io {
+	struct cbd_se		*se;
+	u64			off;
+	u32			len;
+	struct bio		*bio;
+	struct cbd_handler	*handler;
+};
+
+#define CBD_BACKENDS_HANDLER_BITS	7
+
+struct cbd_backend {
+	u32			backend_id;
+	struct cbd_transport	*cbdt;
+	spinlock_t		lock;
+
+	struct cbd_backend_info	backend_info;
+	struct mutex		info_lock;
+
+	u32			host_id;
+
+	struct block_device	*bdev;
+	struct file		*bdev_file;
+
+	struct workqueue_struct	*task_wq;
+	struct delayed_work	hb_work; /* heartbeat work */
+
+	struct list_head	node; /* cbd_transport->backends */
+	DECLARE_HASHTABLE(handlers_hash, CBD_BACKENDS_HANDLER_BITS);
+
+	struct cbd_backend_device *backend_device;
+	struct kmem_cache	*backend_io_cache;
+
+	struct cbd_cache	*cbd_cache;
+};
+
+int cbd_backend_start(struct cbd_transport *cbdt, char *path, u32 backend_id,
+		      u32 handlers, u32 cache_segs);
+int cbd_backend_stop(struct cbd_transport *cbdt, u32 backend_id);
+int cbd_backend_clear(struct cbd_transport *cbdt, u32 backend_id);
+int cbdb_add_handler(struct cbd_backend *cbdb, struct cbd_handler *handler);
+void cbdb_del_handler(struct cbd_backend *cbdb, struct cbd_handler *handler);
+bool cbd_backend_info_is_alive(struct cbd_backend_info *info);
+bool cbd_backend_cache_on(struct cbd_backend_info *backend_info);
+void cbd_backend_notify(struct cbd_backend *cbdb, u32 seg_id);
+void cbd_backend_mgmt_notify(struct cbd_backend *cbdb, u32 seg_id);
+void cbd_backend_info_write(struct cbd_backend *cbdb);
+
+static inline u32 cbd_backend_info_crc(struct cbd_backend_info *backend_info)
+{
+	return crc32(0, (void *)backend_info + 4, sizeof(*backend_info) - 4);
+}
+
+#define cbd_for_each_backend_info(cbdt, i, backend_info)				\
+	for (i = 0;									\
+	     i < cbdt->transport_info.backend_num &&					\
+	     (backend_info = cbdt_backend_info_read(cbdt, i));				\
+	     i++)
+
+static inline int cbd_backend_find_id_by_path(struct cbd_transport *cbdt,
+					      u32 host_id, char *path,
+					      u32 *backend_id)
+{
+	struct cbd_backend_info *backend_info;
+	u32 i;
+
+	cbd_for_each_backend_info(cbdt, i, backend_info) {
+		if (!backend_info)
+			continue;
+
+		if (backend_info->host_id != host_id)
+			continue;
+
+		if (strcmp(backend_info->path, path) == 0) {
+			*backend_id = i;
+			goto found;
+		}
+	}
+
+	return -ENOENT;
+found:
+	return 0;
+}
+
+#endif /* _CBD_BACKEND_H */
diff --git a/drivers/block/cbd/cbd_handler.c b/drivers/block/cbd/cbd_handler.c
new file mode 100644
index 000000000000..0b32a1628753
--- /dev/null
+++ b/drivers/block/cbd/cbd_handler.c
@@ -0,0 +1,468 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blkdev.h>
+
+#include "cbd_handler.h"
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
+
+#ifdef CONFIG_CBD_CHANNEL_DATA_CRC
+	if (se->op == CBD_OP_READ)
+		ce->data_crc = cbd_channel_crc(&handler->channel, se->data_off, se->data_len);
+#endif
+
+#ifdef CONFIG_CBD_CHANNEL_CRC
+	ce->ce_crc = cbd_ce_crc(ce);
+#endif
+	cbdc_compr_head_advance(&handler->channel, sizeof(struct cbd_ce));
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
+	atomic_dec(&handler->inflight_cmds);
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
+
+	backend_io->bio = bio_alloc_bioset(cbdb->bdev,
+				DIV_ROUND_UP(se->len, PAGE_SIZE),
+				opf, GFP_KERNEL, &handler->bioset);
+	if (!backend_io->bio)
+		goto free_backend_io;
+
+	backend_io->se = se;
+	backend_io->handler = handler;
+	backend_io->bio->bi_iter.bi_sector = se->offset >> SECTOR_SHIFT;
+	backend_io->bio->bi_iter.bi_size = 0;
+	backend_io->bio->bi_private = backend_io;
+	backend_io->bio->bi_end_io = backend_bio_end;
+
+	atomic_inc(&handler->inflight_cmds);
+
+	return backend_io;
+
+free_backend_io:
+	kmem_cache_free(cbdb->backend_io_cache, backend_io);
+
+	return NULL;
+}
+
+static int handle_backend_cmd(struct cbd_handler *handler, struct cbd_se *se)
+{
+	struct cbd_backend *cbdb = handler->cbdb;
+	struct cbd_backend_io *backend_io = NULL;
+	int ret;
+
+	/* Check if command has already been completed */
+	if (cbd_se_flags_test(se, CBD_SE_FLAGS_DONE))
+		return 0;
+
+	/* Process command based on operation type */
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
+	/* Check for memory allocation failure in backend I/O */
+	if (!backend_io)
+		return -ENOMEM;
+
+	/*
+	 * Map channel data pages directly into bio, reusing the channel's data space
+	 * instead of allocating new memory. This enables efficient data transfer by
+	 * using the preallocated buffer associated with the channel.
+	 */
+	ret = cbdc_map_pages(&handler->channel, backend_io->bio, se->data_off, se->data_len);
+	if (ret) {
+		kmem_cache_free(cbdb->backend_io_cache, backend_io);
+		return ret;
+	}
+
+	/* Submit bio to initiate the I/O operation on the backend device */
+	submit_bio(backend_io->bio);
+
+	return 0;
+
+complete_cmd:
+	/* Finalize command by generating a completion entry */
+	complete_cmd(handler, se, ret);
+	return 0;
+}
+
+/**
+ * cbd_handler_notify - Notify the backend to process a new submission element (SE).
+ * @handler: Pointer to the `cbd_handler` structure for handling SEs.
+ *
+ * This function is called in a single-host setup when a new SE is submitted
+ * from the block device (blkdev) side. After submission, the backend must be
+ * notified to start processing the SE. The backend locates the handler through
+ * the channel ID, then calls `cbd_handler_notify` to schedule immediate
+ * execution of `handle_work`, which will process the SE in the backend's
+ * work queue.
+ */
+void cbd_handler_notify(struct cbd_handler *handler)
+{
+	queue_delayed_work(handler->cbdb->task_wq, &handler->handle_work, 0);
+}
+
+void cbd_handler_mgmt_notify(struct cbd_handler *handler)
+{
+	cancel_delayed_work(&handler->handle_mgmt_work);
+	queue_delayed_work(handler->cbdb->task_wq, &handler->handle_mgmt_work, 0);
+}
+
+static bool req_tid_valid(struct cbd_handler *handler, u64 req_tid)
+{
+	/* New handler or reattach scenario */
+	if (handler->req_tid_expected == U64_MAX)
+		return true;
+
+	return (req_tid == handler->req_tid_expected);
+}
+
+/**
+ * handler_reset - Reset the state of a handler's channel and control information.
+ * @handler: Pointer to the `cbd_handler` structure managing the channel.
+ *
+ * This function is called to reset the channel's state in scenarios where a block
+ * device (blkdev) is connecting to the backend. There are two main cases where
+ * this reset is required:
+ * 1. A new backend and new blkdev are both being initialized, necessitating a fresh
+ *    start for the channel.
+ * 2. The backend has been continuously running, but a previously connected blkdev
+ *    disconnected and is now being replaced by a newly connected blkdev. In this
+ *    scenario, the state of the channel is reset to ensure it can handle requests
+ *    from the new blkdev.
+ *
+ * In both cases, the blkdev sends a mgmt_cmd of reset into channel_ctrl->mgmt_cmd to
+ * indicate that it requires a channel reset. This function clears all the channel
+ * counters and control pointers, including `submr` and `compr` heads and tails,
+ * resetting them to zero.
+ *
+ * After the reset is complete, the handler sends a cmd_ret of the reset cmd, signaling
+ * to the blkdev that it can begin using the channel for data requests.
+ *
+ * Return: 0 on success, or a negative error code if the reset fails.
+ *         -EBUSY if there are inflight commands indicating the channel is busy.
+ */
+static int handler_reset(struct cbd_handler *handler)
+{
+	int ret;
+
+	/* Check if there are any inflight commands; if so, the channel is busy */
+	if (atomic_read(&handler->inflight_cmds)) {
+		cbd_handler_err(handler, "channel is busy, can't be reset\n");
+		return -EBUSY;
+	}
+
+	spin_lock(&handler->submr_lock);
+	/* Reset expected request transaction ID and handle count */
+	handler->req_tid_expected = U64_MAX;
+	handler->se_to_handle = 0;
+
+	cbd_channel_reset(&handler->channel);
+	spin_unlock(&handler->submr_lock);
+
+	/* Send a success response for the reset command */
+	ret = cbdc_mgmt_cmd_ret_send(handler->channel_ctrl, CBDC_MGMT_CMD_RET_OK);
+	if (ret)
+		return ret;
+
+	/* Queue the handler work to process any subsequent operations */
+	queue_delayed_work(handler->cbdb->task_wq, &handler->handle_work, 0);
+	queue_delayed_work(handler->cbdb->task_wq, &handler->handle_mgmt_work, 0);
+
+	return 0;
+}
+
+static inline int channel_se_verify(struct cbd_handler *handler, struct cbd_se *se)
+{
+#ifdef CONFIG_CBD_CHANNEL_CRC
+	if (se->se_crc != cbd_se_crc(se)) {
+		cbd_handler_err(handler, "se crc(0x%x) is not expected(0x%x)",
+				cbd_se_crc(se), se->se_crc);
+		return -EIO;
+	}
+#endif
+
+#ifdef CONFIG_CBD_CHANNEL_DATA_CRC
+	if (se->op == CBD_OP_WRITE &&
+		se->data_crc != cbd_channel_crc(&handler->channel,
+						se->data_off,
+						se->data_len)) {
+		cbd_handler_err(handler, "data crc(0x%x) is not expected(0x%x)",
+				cbd_channel_crc(&handler->channel, se->data_off, se->data_len),
+				se->data_crc);
+		return -EIO;
+	}
+#endif
+	return 0;
+}
+
+static int handle_mgmt_cmd(struct cbd_handler *handler)
+{
+	u8 cmd_op;
+	int ret;
+
+	cmd_op = cbdc_mgmt_cmd_op_get(handler->channel_ctrl);
+	switch (cmd_op) {
+	case CBDC_MGMT_CMD_NONE:
+		ret = 0;
+		break;
+	case CBDC_MGMT_CMD_RESET:
+		ret = handler_reset(handler);
+		break;
+	default:
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
+/**
+ * handle_mgmt_work_fn - Handle management work for the CBD channel.
+ * @work: Pointer to the work_struct associated with this management work.
+ *
+ * This function is the main function for handling management work related to the
+ * CBD channel. It continuously checks if there are new management commands (mgmt_cmd)
+ * to be processed in the management plane of the CBD channel.
+ *
+ * If a new mgmt_cmd is detected, it will be processed; if none are available, the function
+ * will end this work iteration. The execution cycle of handle_mgmt_work is set to 1 second.
+ */
+static void handle_mgmt_work_fn(struct work_struct *work)
+{
+	struct cbd_handler *handler = container_of(work, struct cbd_handler,
+						   handle_mgmt_work.work);
+	int ret;
+again:
+	/* Check if the current mgmt_cmd has been completed */
+	if (!cbdc_mgmt_completed(handler->channel_ctrl)) {
+		/* Process the management command */
+		ret = handle_mgmt_cmd(handler);
+		if (ret)
+			goto out;
+		goto again;
+	}
+
+out:
+	/* Re-queue the work to run again after 1 second */
+	queue_delayed_work(handler->cbdb->task_wq, &handler->handle_mgmt_work, HZ);
+}
+
+/**
+ * handle_work_fn - Main handler function to process SEs in the channel.
+ * @work: pointer to the work_struct associated with the handler.
+ *
+ * This function is repeatedly called to handle incoming SEs (Submission Entries)
+ * from the channel's control structure.
+ *
+ * In a multi-host environment, this function operates in a polling mode
+ * to retrieve new SEs. For single-host cases, it mainly waits for
+ * blkdev notifications.
+ */
+static void handle_work_fn(struct work_struct *work)
+{
+	struct cbd_handler *handler = container_of(work, struct cbd_handler,
+						   handle_work.work);
+	struct cbd_se *se_head;
+	struct cbd_se *se;
+	u64 req_tid;
+	int ret;
+
+again:
+	/* Retrieve new SE from channel control */
+	spin_lock(&handler->submr_lock);
+	se_head = get_se_head(handler);
+	if (!se_head) {
+		spin_unlock(&handler->submr_lock);
+		goto miss;
+	}
+
+	se = get_se_to_handle(handler);
+	if (se == se_head) {
+		spin_unlock(&handler->submr_lock);
+		goto miss;
+	}
+	spin_unlock(&handler->submr_lock);
+
+	req_tid = se->req_tid;
+	if (!req_tid_valid(handler, req_tid)) {
+		cbd_handler_err(handler, "req_tid (%llu) is not expected (%llu)",
+				req_tid, handler->req_tid_expected);
+		goto miss;
+	}
+
+	ret = channel_se_verify(handler, se);
+	if (ret)
+		goto miss;
+
+	cbdwc_hit(&handler->handle_worker_cfg);
+
+	ret = handle_backend_cmd(handler, se);
+	if (!ret) {
+		/* Successful SE handling */
+		handler->req_tid_expected = req_tid + 1;
+		handler->se_to_handle = (handler->se_to_handle + sizeof(struct cbd_se)) %
+							handler->channel.submr_size;
+	}
+
+	goto again;
+
+miss:
+	/* No more SEs to handle in this round */
+	if (cbdwc_need_retry(&handler->handle_worker_cfg))
+		goto again;
+
+	cbdwc_miss(&handler->handle_worker_cfg);
+
+	/* Queue next work based on polling status */
+	if (cbd_channel_flags_get(handler->channel_ctrl) & CBDC_FLAGS_POLLING) {
+		cpu_relax();
+		queue_delayed_work(handler->cbdb->task_wq, &handler->handle_work, 0);
+	}
+}
+
+static struct cbd_handler *handler_alloc(struct cbd_backend *cbdb)
+{
+	struct cbd_handler *handler;
+	int ret;
+
+	handler = kzalloc(sizeof(struct cbd_handler), GFP_KERNEL);
+	if (!handler)
+		return NULL;
+
+	ret = bioset_init(&handler->bioset, 256, 0, BIOSET_NEED_BVECS);
+	if (ret)
+		goto free_handler;
+
+	handler->cbdb = cbdb;
+
+	return handler;
+free_handler:
+	kfree(handler);
+	return NULL;
+}
+
+static void handler_free(struct cbd_handler *handler)
+{
+	bioset_exit(&handler->bioset);
+	kfree(handler);
+}
+
+static void handler_channel_init(struct cbd_handler *handler, u32 channel_id, bool new_channel)
+{
+	struct cbd_transport *cbdt = handler->cbdb->cbdt;
+	struct cbd_channel_init_options init_opts = { 0 };
+
+	init_opts.cbdt = cbdt;
+	init_opts.backend_id = handler->cbdb->backend_id;
+	init_opts.seg_id = channel_id;
+	init_opts.new_channel = new_channel;
+	cbd_channel_init(&handler->channel, &init_opts);
+
+	handler->channel_ctrl = handler->channel.ctrl;
+	handler->req_tid_expected = U64_MAX;
+	atomic_set(&handler->inflight_cmds, 0);
+	spin_lock_init(&handler->compr_lock);
+	spin_lock_init(&handler->submr_lock);
+	INIT_DELAYED_WORK(&handler->handle_work, handle_work_fn);
+	INIT_DELAYED_WORK(&handler->handle_mgmt_work, handle_mgmt_work_fn);
+	cbdwc_init(&handler->handle_worker_cfg);
+
+	if (new_channel) {
+		handler->channel.data_head = handler->channel.data_tail = 0;
+		handler->channel_ctrl->submr_tail = handler->channel_ctrl->submr_head = 0;
+		handler->channel_ctrl->compr_tail = handler->channel_ctrl->compr_head = 0;
+
+		cbd_channel_flags_clear_bit(handler->channel_ctrl, ~0ULL);
+	}
+
+	handler->se_to_handle = cbdc_submr_tail_get(&handler->channel);
+
+	/* this should be after channel_init, as we need channel.seg_id in backend->handlers_hash */
+	cbdb_add_handler(handler->cbdb, handler);
+}
+
+static void handler_channel_destroy(struct cbd_handler *handler)
+{
+	cbdb_del_handler(handler->cbdb, handler);
+	cbd_channel_destroy(&handler->channel);
+}
+
+/* handler start and stop */
+static void handler_start(struct cbd_handler *handler)
+{
+	struct cbd_backend *cbdb = handler->cbdb;
+
+	queue_delayed_work(cbdb->task_wq, &handler->handle_work, 0);
+	queue_delayed_work(cbdb->task_wq, &handler->handle_mgmt_work, 0);
+}
+
+static void handler_stop(struct cbd_handler *handler)
+{
+	cancel_delayed_work_sync(&handler->handle_mgmt_work);
+	cancel_delayed_work_sync(&handler->handle_work);
+
+	while (atomic_read(&handler->inflight_cmds))
+		schedule_timeout(HZ);
+}
+
+int cbd_handler_create(struct cbd_backend *cbdb, u32 channel_id, bool new_channel)
+{
+	struct cbd_handler *handler;
+
+	handler = handler_alloc(cbdb);
+	if (!handler)
+		return -ENOMEM;
+
+	handler_channel_init(handler, channel_id, new_channel);
+	handler_start(handler);
+
+	return 0;
+};
+
+void cbd_handler_destroy(struct cbd_handler *handler)
+{
+	handler_stop(handler);
+	handler_channel_destroy(handler);
+	handler_free(handler);
+}
diff --git a/drivers/block/cbd/cbd_handler.h b/drivers/block/cbd/cbd_handler.h
new file mode 100644
index 000000000000..7b24236e7886
--- /dev/null
+++ b/drivers/block/cbd/cbd_handler.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_HANDLER_H
+#define _CBD_HANDLER_H
+
+#include "cbd_channel.h"
+#include "cbd_backend.h"
+
+#define cbd_handler_err(handler, fmt, ...)					\
+	cbdb_err(handler->cbdb, "handler%d: " fmt,				\
+		 handler->channel.seg_id, ##__VA_ARGS__)
+#define cbd_handler_info(handler, fmt, ...)					\
+	cbdb_info(handler->cbdb, "handler%d: " fmt,				\
+		 handler->channel.seg_id, ##__VA_ARGS__)
+#define cbd_handler_debug(handler, fmt, ...)					\
+	cbdb_debug(handler->cbdb, "handler%d: " fmt,				\
+		 handler->channel.seg_id, ##__VA_ARGS__)
+
+/* cbd_handler */
+struct cbd_handler {
+	struct cbd_backend	*cbdb;
+
+	struct cbd_channel	channel;
+	struct cbd_channel_ctrl	*channel_ctrl;
+	spinlock_t		compr_lock;
+	spinlock_t		submr_lock;
+
+	u32			se_to_handle;
+	u64			req_tid_expected;
+
+	struct delayed_work	handle_work;
+	struct cbd_worker_cfg	handle_worker_cfg;
+
+	struct delayed_work	handle_mgmt_work;
+
+	atomic_t		inflight_cmds;
+
+	struct hlist_node	hash_node;
+	struct bio_set		bioset;
+};
+
+void cbd_handler_destroy(struct cbd_handler *handler);
+int cbd_handler_create(struct cbd_backend *cbdb, u32 seg_id, bool init_channel);
+void cbd_handler_notify(struct cbd_handler *handler);
+void cbd_handler_mgmt_notify(struct cbd_handler *handler);
+
+static inline struct cbd_se *get_se_head(struct cbd_handler *handler)
+{
+	u32 se_head = cbdc_submr_head_get(&handler->channel);
+
+	if (unlikely(se_head > (handler->channel.submr_size - sizeof(struct cbd_se))))
+		return NULL;
+
+	return (struct cbd_se *)(handler->channel.submr + se_head);
+}
+
+static inline struct cbd_se *get_se_to_handle(struct cbd_handler *handler)
+{
+	return (struct cbd_se *)(handler->channel.submr + handler->se_to_handle);
+}
+
+static inline struct cbd_ce *get_compr_head(struct cbd_handler *handler)
+{
+	return (struct cbd_ce *)(handler->channel.compr + cbdc_compr_head_get(&handler->channel));
+}
+
+#endif /* _CBD_HANDLER_H */
-- 
2.34.1



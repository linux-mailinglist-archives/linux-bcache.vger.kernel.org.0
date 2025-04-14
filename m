Return-Path: <linux-bcache+bounces-863-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FAAA87560
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FCEB3B158E
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2535318C933;
	Mon, 14 Apr 2025 01:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AVCuOZxD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE02170A26
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595129; cv=none; b=k4xJBWZu1RqepNWo0zyi3aZGgaHQbp8/vjdir6XOavKVnMEC32/3gPfU/6Zy+mwm8jZVXnCTRdC260+lxCfTtXwDZOB2YGPuKAKWfrv1pkPqdUN1EZOIDnDf9XTBeCxdh3uzT3IX8OsrwcEd+BBqr+p9IGCXijwa1emeeGXhQ+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595129; c=relaxed/simple;
	bh=CHJB8ylmvUZAraWLaan6Ist2/cMzTAvqPPAzjhPKKmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gcrp6KjNhbKQ02QDd4Ub4/f9Ft5BdMRqTKh0O+F1KO+nm1ZF75JfuErTkKIH34WfnKsbr0ksqJeSgvPtSloP2UT9NO28jRGWyiQFjuM2wejGtok10M+aeRTVKKBspiH/NOSoar60/qKmcuPzdkQWEsfzYXP87leFbL1HD8azZqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AVCuOZxD; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cEChtasyBbHvB3/rNYeOSia7d4HdTAvwjlQLfl1P+D0=;
	b=AVCuOZxDo2f9CyQErYNBSwvCRudUMlh+xdUjbqZ3RwHK+UbWL/nwqBiZygzjHwwNRg5ONA
	/SIomqE/k8/2fiR/fGEKhfO9mfYm6ChZRGrherAmqA3PttRKHz39S98UlxTVKI5kBh27Zg
	FELjdYWKk/RYeeDb6EtBUfkjcmsDOb8=
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
Subject: [RFC PATCH 01/11] pcache: introduce cache_dev for managing persistent memory-based cache devices
Date: Mon, 14 Apr 2025 01:44:55 +0000
Message-Id: <20250414014505.20477-2-dongsheng.yang@linux.dev>
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

This patch introduces the core abstraction `cache_dev`, which represents
a persistent memory (pmem) device used by pcache to cache block device data.
The `cache_dev` layer is responsible for pmem initialization, metadata layout,
lifetime management, and user-facing administration via sysfs.

Key components:

- cache_dev metadata layout:
   - Superblock (`pcache_sb`) located at offset 4KB, includes magic, version,
     feature flags (endianness, data CRC), and segment count.
   - Persistent metadata regions (e.g., backing_dev info) follow, double-indexed
     with CRC and sequence numbers for crash consistency and safe updates.
   - Segments start after metadata and are used to store cache data.

- DAX-based memory mapping:
   - Uses `fs_dax_get_by_bdev()` and `dax_direct_access()` to map the entire pmem
     space either directly or via `vmap()` if partial mapping occurs.
   - Ensures that the underlying pmem is directly accessible for low-latency,
     zero-copy access to cache segments.

- Sysfs interface:
   - `/sys/.../info`: displays cache superblock information.
   - `/sys/.../path`: shows associated pmem path.
   - `/sys/.../adm`: accepts administrative commands, e.g.,

- Metadata helpers:
   - Implements utility functions for safely locating the latest or oldest
     valid metadata copy using CRC and sequence numbers.
   - Provides `pcache_meta_get_next_seq()` to atomically increment update versioning.

- Registration and formatting:
   - `cache_dev_register()` initializes the cache_dev from a pmem device path,
     optionally formatting it if `format=1` is specified.
   - `cache_dev_format()` initializes the SB and zeroes metadata regions.
   - `cache_dev_unregister()` gracefully tears down a cache_dev once all backing
     devices have been detached.

Design rationale:

The `cache_dev` layer cleanly separates the pmem-specific logic from
higher-level pcache functionalities. It offers a persistent and self-describing
structure that supports safe recovery, scalable segment management, and
runtime extensibility. It also serves as the anchoring point for dynamic
attachment of backing block devices, which are managed through additional
modules layered on top.

This patch lays the foundation for building a robust and high-performance
block cache system based on persistent memory.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/cache_dev.c       | 808 +++++++++++++++++++++++++
 drivers/block/pcache/cache_dev.h       |  81 +++
 drivers/block/pcache/pcache_internal.h | 185 ++++++
 3 files changed, 1074 insertions(+)
 create mode 100644 drivers/block/pcache/cache_dev.c
 create mode 100644 drivers/block/pcache/cache_dev.h
 create mode 100644 drivers/block/pcache/pcache_internal.h

diff --git a/drivers/block/pcache/cache_dev.c b/drivers/block/pcache/cache_dev.c
new file mode 100644
index 000000000000..8b5fea7bfcee
--- /dev/null
+++ b/drivers/block/pcache/cache_dev.c
@@ -0,0 +1,808 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/blkdev.h>
+#include <linux/dax.h>
+#include <linux/vmalloc.h>
+#include <linux/pfn_t.h>
+#include <linux/parser.h>
+
+#include "cache_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+#include "segment.h"
+#include "meta_segment.h"
+
+static struct pcache_cache_dev *cache_devs[PCACHE_CACHE_DEV_MAX];
+static DEFINE_IDA(cache_devs_id_ida);
+static DEFINE_MUTEX(cache_devs_mutex);
+
+static ssize_t info_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct pcache_sb *sb;
+	struct pcache_cache_dev *cache_dev;
+	ssize_t ret;
+
+	cache_dev = container_of(dev, struct pcache_cache_dev, device);
+	sb = cache_dev->sb_addr;
+
+	ret = sprintf(buf, "magic: 0x%llx\n"
+			"version: %u\n"
+			"flags: %x\n\n"
+			"segment_num: %u\n",
+			le64_to_cpu(sb->magic),
+			le16_to_cpu(sb->version),
+			le16_to_cpu(sb->flags),
+			cache_dev->seg_num);
+
+	return ret;
+}
+static DEVICE_ATTR_ADMIN_RO(info);
+
+static ssize_t path_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct pcache_cache_dev *cache_dev;
+
+	cache_dev = container_of(dev, struct pcache_cache_dev, device);
+
+	return sprintf(buf, "%s\n", cache_dev->path);
+}
+static DEVICE_ATTR_ADMIN_RO(path);
+
+enum {
+	PCACHE_ADM_OPT_ERR		= 0,
+	PCACHE_ADM_OPT_OP,
+	PCACHE_ADM_OPT_FORCE,
+	PCACHE_ADM_OPT_DATA_CRC,
+	PCACHE_ADM_OPT_PATH,
+	PCACHE_ADM_OPT_BID,
+	PCACHE_ADM_OPT_QUEUES,
+	PCACHE_ADM_OPT_CACHE_SIZE,
+};
+
+enum {
+	PCACHE_ADM_OP_B_START,
+	PCACHE_ADM_OP_B_STOP,
+};
+
+static const char *const adm_op_names[] = {
+	[PCACHE_ADM_OP_B_START] = "backing-start",
+	[PCACHE_ADM_OP_B_STOP] = "backing-stop",
+};
+
+static const match_table_t adm_opt_tokens = {
+	{ PCACHE_ADM_OPT_OP,		"op=%s"	},
+	{ PCACHE_ADM_OPT_FORCE,		"force=%u" },
+	{ PCACHE_ADM_OPT_DATA_CRC,	"data_crc=%u" },
+	{ PCACHE_ADM_OPT_PATH,		"path=%s" },
+	{ PCACHE_ADM_OPT_BID,		"backing_id=%u" },
+	{ PCACHE_ADM_OPT_QUEUES,	"queues=%u" },
+	{ PCACHE_ADM_OPT_CACHE_SIZE,	"cache_size=%u" },	/* unit is MiB */
+	{ PCACHE_ADM_OPT_ERR,		NULL	}
+};
+
+
+struct pcache_cache_dev_adm_options {
+	u16 op;
+	bool force;
+	bool data_crc;
+	u32 backing_id;
+	u32 queues;
+	char path[PCACHE_PATH_LEN];
+	u64 cache_size_M;
+};
+
+static int parse_adm_options(struct pcache_cache_dev *cache_dev,
+		char *buf,
+		struct pcache_cache_dev_adm_options *opts)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *o, *p;
+	int token, ret = 0;
+
+	o = buf;
+
+	while ((p = strsep(&o, ",\n")) != NULL) {
+		if (!*p)
+			continue;
+
+		token = match_token(p, adm_opt_tokens, args);
+		switch (token) {
+		case PCACHE_ADM_OPT_OP:
+			ret = match_string(adm_op_names, ARRAY_SIZE(adm_op_names), args[0].from);
+			if (ret < 0) {
+				cache_dev_err(cache_dev, "unknown op: '%s'\n", args[0].from);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->op = ret;
+			break;
+		case PCACHE_ADM_OPT_PATH:
+			if (match_strlcpy(opts->path, &args[0],
+				PCACHE_PATH_LEN) == 0) {
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
+		case PCACHE_ADM_OPT_FORCE:
+			if (match_uint(args, &token) || token != 1) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->force = 1;
+			break;
+		case PCACHE_ADM_OPT_DATA_CRC:
+			if (match_uint(args, &token) || token != 1) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->data_crc = 1;
+			break;
+		case PCACHE_ADM_OPT_BID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			opts->backing_id = token;
+			break;
+		case PCACHE_ADM_OPT_QUEUES:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (token > PCACHE_QUEUES_MAX) {
+				cache_dev_err(cache_dev, "invalid queues: %u, larger than max %u\n",
+						token, PCACHE_QUEUES_MAX);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->queues = token;
+			break;
+		case PCACHE_ADM_OPT_CACHE_SIZE:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->cache_size_M = token;
+			break;
+		default:
+			cache_dev_err(cache_dev, "unknown parameter or missing value '%s'\n", p);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static ssize_t adm_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *ubuf,
+			size_t size)
+{
+	int ret;
+	char *buf;
+	struct pcache_cache_dev_adm_options opts = { 0 };
+	struct pcache_cache_dev *cache_dev;
+
+	opts.backing_id = U32_MAX;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	cache_dev = container_of(dev, struct pcache_cache_dev, device);
+
+	buf = kmemdup(ubuf, size + 1, GFP_KERNEL);
+	if (IS_ERR(buf)) {
+		cache_dev_err(cache_dev, "failed to dup buf for adm option: %d", (int)PTR_ERR(buf));
+		return PTR_ERR(buf);
+	}
+	buf[size] = '\0';
+	ret = parse_adm_options(cache_dev, buf, &opts);
+	if (ret < 0) {
+		kfree(buf);
+		return ret;
+	}
+	kfree(buf);
+
+	mutex_lock(&cache_dev->adm_lock);
+	switch (opts.op) {
+	case PCACHE_ADM_OP_B_START:
+		u32 cache_segs = 0;
+		struct pcache_backing_dev_opts backing_opts = { 0 };
+
+		if (opts.cache_size_M > 0)
+			cache_segs = DIV_ROUND_UP(opts.cache_size_M,
+					PCACHE_SEG_SIZE / PCACHE_MB);
+
+		backing_opts.path = opts.path;
+		backing_opts.queues = opts.queues;
+		backing_opts.cache_segs = cache_segs;
+		backing_opts.data_crc = opts.data_crc;
+
+		ret = backing_dev_start(cache_dev, &backing_opts);
+		break;
+	case PCACHE_ADM_OP_B_STOP:
+		ret = backing_dev_stop(cache_dev, opts.backing_id);
+		break;
+	default:
+		mutex_unlock(&cache_dev->adm_lock);
+		cache_dev_err(cache_dev, "invalid op: %d\n", opts.op);
+		return -EINVAL;
+	}
+	mutex_unlock(&cache_dev->adm_lock);
+
+	if (ret < 0)
+		return ret;
+
+	return size;
+}
+static DEVICE_ATTR_WO(adm);
+
+static struct attribute *cache_dev_attrs[] = {
+	&dev_attr_info.attr,
+	&dev_attr_path.attr,
+	&dev_attr_adm.attr,
+	NULL
+};
+
+static struct attribute_group cache_dev_attr_group = {
+	.attrs = cache_dev_attrs,
+};
+
+static const struct attribute_group *cache_dev_attr_groups[] = {
+	&cache_dev_attr_group,
+	NULL
+};
+
+static void cache_dev_release(struct device *dev)
+{
+}
+
+const struct device_type cache_dev_type = {
+	.name		= "cache_dev",
+	.groups		= cache_dev_attr_groups,
+	.release	= cache_dev_release,
+};
+
+static void cache_dev_free(struct pcache_cache_dev *cache_dev)
+{
+	cache_devs[cache_dev->id] = NULL;
+	ida_simple_remove(&cache_devs_id_ida, cache_dev->id);
+	kfree(cache_dev);
+}
+
+static struct pcache_cache_dev *cache_dev_alloc(void)
+{
+	struct pcache_cache_dev *cache_dev;
+	int ret;
+
+	cache_dev = kzalloc(sizeof(struct pcache_cache_dev), GFP_KERNEL);
+	if (!cache_dev)
+		return NULL;
+
+	mutex_init(&cache_dev->lock);
+	mutex_init(&cache_dev->seg_lock);
+	mutex_init(&cache_dev->adm_lock);
+	INIT_LIST_HEAD(&cache_dev->backing_devs);
+
+	ret = ida_simple_get(&cache_devs_id_ida, 0, PCACHE_CACHE_DEV_MAX,
+				GFP_KERNEL);
+	if (ret < 0)
+		goto cache_dev_free;
+
+	cache_dev->id = ret;
+	cache_devs[cache_dev->id] = cache_dev;
+
+	return cache_dev;
+
+cache_dev_free:
+	kfree(cache_dev);
+	return NULL;
+}
+
+static void cache_dev_dax_exit(struct pcache_cache_dev *cache_dev)
+{
+	if (cache_dev->dax_dev)
+		fs_put_dax(cache_dev->dax_dev, cache_dev);
+
+	if (cache_dev->bdev_file)
+		fput(cache_dev->bdev_file);
+}
+
+static int cache_dev_dax_notify_failure(struct dax_device *dax_dev, u64 offset,
+				  u64 len, int mf_flags)
+{
+
+	pr_err("%s: dax_dev %llx offset %llx len %lld mf_flags %x\n",
+	       __func__, (u64)dax_dev, (u64)offset, (u64)len, mf_flags);
+
+	return -EOPNOTSUPP;
+}
+
+const struct dax_holder_operations cache_dev_dax_holder_ops = {
+	.notify_failure		= cache_dev_dax_notify_failure,
+};
+
+static int cache_dev_dax_init(struct pcache_cache_dev *cache_dev, char *path)
+{
+	struct dax_device *dax_dev = NULL;
+	struct file *bdev_file = NULL;
+	struct block_device *bdev;
+	long total_pages, mapped_pages;
+	u64 bdev_size, start_off = 0;
+	struct page **pages = NULL;
+	void *vaddr = NULL;
+	int ret, id;
+	pfn_t pfn;
+	long i = 0;
+
+	/* Copy the device path */
+	memcpy(cache_dev->path, path, PCACHE_PATH_LEN);
+
+	/* Open block device */
+	bdev_file = bdev_file_open_by_path(path, BLK_OPEN_READ | BLK_OPEN_WRITE, cache_dev, NULL);
+	if (IS_ERR(bdev_file)) {
+		ret = PTR_ERR(bdev_file);
+		cache_dev_err(cache_dev, "failed to open bdev %s, err=%d\n", path, ret);
+		goto err;
+	}
+
+	/* Get block device structure */
+	bdev = file_bdev(bdev_file);
+	if (!bdev) {
+		ret = -EINVAL;
+		cache_dev_err(cache_dev, "failed to get bdev from file\n");
+		goto fput;
+	}
+
+	/* Get total device size */
+	bdev_size = bdev_nr_bytes(bdev);
+	if (bdev_size == 0) {
+		ret = -ENODEV;
+		cache_dev_err(cache_dev, "device %s has zero size\n", path);
+		goto fput;
+	}
+
+	/* Convert device size to total pages */
+	total_pages = bdev_size >> PAGE_SHIFT;
+
+	/* Get the DAX device */
+	dax_dev = fs_dax_get_by_bdev(bdev, &start_off, cache_dev, &cache_dev_dax_holder_ops);
+	if (IS_ERR(dax_dev)) {
+		ret = PTR_ERR(dax_dev);
+		cache_dev_err(cache_dev, "failed to get dax_dev from bdev, err=%d\n", ret);
+		goto fput;
+	}
+
+	/* Lock DAX access */
+	id = dax_read_lock();
+
+	/* Try to access the entire device memory */
+	mapped_pages = dax_direct_access(dax_dev, 0, total_pages, DAX_ACCESS, &vaddr, &pfn);
+	if (mapped_pages < 0) {
+		cache_dev_err(cache_dev, "dax_direct_access failed, err=%ld\n", mapped_pages);
+		ret = mapped_pages;
+		goto unlock;
+	}
+
+	if (!pfn_t_has_page(pfn)) {
+		cache_dev_err(cache_dev, "pfn_t does not have a valid page mapping\n");
+		ret = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	/* If all pages are mapped in one go, use direct mapping */
+	if (mapped_pages == total_pages) {
+		cache_dev->sb_addr = (struct pcache_sb *)vaddr;
+	} else {
+		/* Use vmap() to create a contiguous mapping */
+		long chunk_size;
+
+		cache_dev_debug(cache_dev, "partial mapping, using vmap\n");
+
+		pages = vmalloc_array(total_pages, sizeof(struct page *));
+		if (!pages) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+
+		i = 0;
+		do {
+			/* Access each page range in DAX */
+			chunk_size = dax_direct_access(dax_dev, i, total_pages - i, DAX_ACCESS, NULL, &pfn);
+			if (chunk_size <= 0) {
+				ret = chunk_size ? chunk_size : -EINVAL;
+				goto vfree;
+			}
+
+			if (!pfn_t_has_page(pfn)) {
+				ret = -EOPNOTSUPP;
+				goto vfree;
+			}
+
+			/* Store pages in the array for vmap */
+			while (chunk_size-- && i < total_pages) {
+				pages[i++] = pfn_t_to_page(pfn);
+				pfn.val++;
+				if (!(i & 15))
+					cond_resched();
+			}
+		} while (i < total_pages);
+
+		/* Map all pages into a contiguous virtual address */
+		vaddr = vmap(pages, total_pages, VM_MAP, PAGE_KERNEL);
+		if (!vaddr) {
+			cache_dev_err(cache_dev, "vmap failed");
+			ret = -ENOMEM;
+			goto vfree;
+		}
+
+		vfree(pages);
+		cache_dev->sb_addr = (struct pcache_sb *)vaddr;
+	}
+
+	/* Unlock and store references */
+	dax_read_unlock(id);
+
+	cache_dev->bdev_file = bdev_file;
+	cache_dev->dax_dev = dax_dev;
+	cache_dev->bdev = bdev;
+
+	return 0;
+
+vfree:
+	vfree(pages);
+unlock:
+	dax_read_unlock(id);
+	fs_put_dax(dax_dev, cache_dev);
+fput:
+	fput(bdev_file);
+err:
+	return ret;
+}
+
+void cache_dev_flush(struct pcache_cache_dev *cache_dev, void *pos, u32 size)
+{
+	dax_flush(cache_dev->dax_dev, pos, size);
+}
+
+void cache_dev_zero_range(struct pcache_cache_dev *cache_dev, void *pos, u32 size)
+{
+	memset(pos, 0, size);
+	cache_dev_flush(cache_dev, pos, size);
+}
+
+static int cache_dev_format(struct pcache_cache_dev *cache_dev, bool force)
+{
+	struct pcache_sb *sb = cache_dev->sb_addr;
+	u64 nr_segs;
+	u64 cache_dev_size;
+	u64 magic;
+	u16 flags = 0;
+
+	magic = le64_to_cpu(sb->magic);
+	if (magic && !force)
+		return -EEXIST;
+
+	cache_dev_size = bdev_nr_bytes(file_bdev(cache_dev->bdev_file));
+	if (cache_dev_size < PCACHE_CACHE_DEV_SIZE_MIN) {
+		cache_dev_err(cache_dev, "dax device is too small, required at least %u",
+				PCACHE_CACHE_DEV_SIZE_MIN);
+		return -ENOSPC;
+	}
+
+	nr_segs = (cache_dev_size - PCACHE_SEGMENTS_OFF) / ((PCACHE_SEG_SIZE));
+
+	/* Segment 0 to be backing info segment, clear it */
+	cache_dev_zero_range(cache_dev, CACHE_DEV_BACKING_SEG(cache_dev), PCACHE_SEG_SIZE);
+
+	sb->version = cpu_to_le16(PCACHE_VERSION);
+
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	flags |= PCACHE_SB_F_BIGENDIAN;
+#endif
+	sb->flags = cpu_to_le16(flags);
+
+	sb->magic = cpu_to_le64(PCACHE_MAGIC);
+	sb->seg_num = cpu_to_le16(nr_segs);
+
+	sb->crc = cpu_to_le32(crc32(0, (void *)sb + 4, PCACHE_SB_SIZE - 4));
+
+	return 0;
+}
+
+static int sb_validate(struct pcache_cache_dev *cache_dev)
+{
+	struct pcache_sb *sb = cache_dev->sb_addr;
+	u16 flags;
+
+	if (le64_to_cpu(sb->magic) != PCACHE_MAGIC) {
+		cache_dev_err(cache_dev, "unexpected magic: %llx\n",
+				le64_to_cpu(sb->magic));
+		return -EINVAL;
+	}
+
+	flags = le16_to_cpu(sb->flags);
+
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	if (!(flags & PCACHE_SB_F_BIGENDIAN)) {
+		cache_dev_err(cache_dev, "cache_dev is not big endian\n");
+		return -EINVAL;
+	}
+#else
+	if (flags & PCACHE_SB_F_BIGENDIAN) {
+		cache_dev_err(cache_dev, "cache_dev is big endian\n");
+		return -EINVAL;
+	}
+#endif
+	return 0;
+}
+
+static void backing_dev_info_init(struct pcache_cache_dev *cache_dev)
+{
+	struct pcache_segment_info *seg_info;
+	struct pcache_meta_segment *meta_seg;
+	struct pcache_backing_dev_info *backing_info, *backing_info_addr;
+	u32 seg_id;
+	u32 i;
+
+	meta_seg = cache_dev->backing_info_seg;
+again:
+	set_bit(meta_seg->segment.seg_info->seg_id, cache_dev->seg_bitmap);
+	/* Try to find the backing_dev_id with same path */
+	pcache_meta_seg_for_each_meta(meta_seg, i, backing_info_addr) {
+		backing_info = pcache_meta_find_latest(&backing_info_addr->header, PCACHE_BACKING_DEV_INFO_SIZE);
+		if (!backing_info || backing_info->state != PCACHE_BACKING_STATE_RUNNING)
+			continue;
+
+		seg_id = backing_info->cache_info.seg_id;
+next_seg:
+		seg_info = pcache_segment_info_read(cache_dev, seg_id);
+		BUG_ON(!seg_info);
+		set_bit(seg_info->seg_id, cache_dev->seg_bitmap);
+		if (segment_info_has_next(seg_info)) {
+			seg_id = seg_info->next_seg;
+			goto next_seg;
+		}
+	}
+
+	if (meta_seg->next_meta_seg) {
+		meta_seg = meta_seg->next_meta_seg;
+		goto again;
+	}
+}
+
+static int cache_dev_init(struct pcache_cache_dev *cache_dev,
+			  struct pcache_cache_dev_register_options *opts)
+{
+	struct pcache_sb *sb;
+	struct device *dev;
+	int ret;
+
+	ret = sb_validate(cache_dev);
+	if (ret)
+		goto err;
+
+	sb = cache_dev->sb_addr;
+	cache_dev->seg_num = le64_to_cpu(sb->seg_num);
+
+	cache_dev->seg_bitmap = bitmap_zalloc(cache_dev->seg_num, GFP_KERNEL);
+	if (!cache_dev->seg_bitmap)
+		goto err;
+
+	cache_dev->backing_info_seg = pcache_meta_seg_alloc(cache_dev, 0, PCACHE_BACKING_DEV_INFO_SIZE);
+	if (!cache_dev->backing_info_seg)
+		goto free_bitmap;
+
+	backing_dev_info_init(cache_dev);
+
+	dev = &cache_dev->device;
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->bus = &pcache_bus_type;
+	dev->type = &cache_dev_type;
+	dev->parent = &pcache_root_dev;
+	dev_set_name(&cache_dev->device, "cache_dev%d", cache_dev->id);
+	ret = device_add(&cache_dev->device);
+	if (ret)
+		goto free_backing_info_seg;
+
+	return 0;
+
+free_backing_info_seg:
+	pcache_meta_seg_free(cache_dev->backing_info_seg);
+free_bitmap:
+	bitmap_free(cache_dev->seg_bitmap);
+err:
+	return ret;
+}
+
+static void cache_dev_exit(struct pcache_cache_dev *cache_dev)
+{
+	device_unregister(&cache_dev->device);
+	pcache_meta_seg_free(cache_dev->backing_info_seg);
+	bitmap_free(cache_dev->seg_bitmap);
+}
+
+int cache_dev_unregister(u32 cache_dev_id)
+{
+	struct pcache_cache_dev *cache_dev;
+
+	if (cache_dev_id >= PCACHE_CACHE_DEV_MAX) {
+		pr_err("invalid cache_dev_id: %u\n", cache_dev_id);
+		return -EINVAL;
+	}
+
+	cache_dev = cache_devs[cache_dev_id];
+	if (!cache_dev) {
+		pr_err("cache_dev: %u, is not registered\n", cache_dev_id);
+		return -EINVAL;
+	}
+
+	mutex_lock(&cache_dev->lock);
+	if (!list_empty(&cache_dev->backing_devs)) {
+		mutex_unlock(&cache_dev->lock);
+		return -EBUSY;
+	}
+	mutex_unlock(&cache_dev->lock);
+
+	cache_dev_exit(cache_dev);
+	cache_dev_dax_exit(cache_dev);
+	cache_dev_free(cache_dev);
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+int cache_dev_register(struct pcache_cache_dev_register_options *opts)
+{
+	struct pcache_cache_dev *cache_dev;
+	int ret;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENODEV;
+
+	if (!strstr(opts->path, "/dev/pmem")) {
+		pr_err("%s: path (%s) is not pmem\n",
+		       __func__, opts->path);
+		ret = -EINVAL;
+		goto module_put;
+	}
+
+	cache_dev = cache_dev_alloc();
+	if (!cache_dev) {
+		ret = -ENOMEM;
+		goto module_put;
+	}
+
+	ret = cache_dev_dax_init(cache_dev, opts->path);
+	if (ret)
+		goto cache_dev_free;
+
+	if (opts->format) {
+		ret = cache_dev_format(cache_dev, opts->force);
+		if (ret < 0)
+			goto dax_release;
+	}
+
+	ret = cache_dev_init(cache_dev, opts);
+	if (ret)
+		goto dax_release;
+
+	return 0;
+dax_release:
+	cache_dev_dax_exit(cache_dev);
+cache_dev_free:
+	cache_dev_free(cache_dev);
+module_put:
+	module_put(THIS_MODULE);
+
+	return ret;
+}
+
+int cache_dev_find_backing_info(struct pcache_cache_dev *cache_dev, struct pcache_backing_dev *backing_dev, bool *new_backing)
+{
+	struct pcache_meta_segment *meta_seg;
+	struct pcache_backing_dev_info *backing_info, *backing_info_addr;
+	struct pcache_backing_dev_info *empty_backing_info;
+	bool empty_id_found = false;
+	u32 total_id = 0;
+	u32 empty_id;
+	int ret;
+	u32 i;
+
+	meta_seg = cache_dev->backing_info_seg;
+again:
+	/* Try to find the backing_dev_id with same path */
+	pcache_meta_seg_for_each_meta(meta_seg, i, backing_info_addr) {
+		backing_info = pcache_meta_find_latest(&backing_info_addr->header, PCACHE_BACKING_DEV_INFO_SIZE);
+
+		if (!backing_info || backing_info->state == PCACHE_BACKING_STATE_NONE) {
+			if (!empty_id_found) {
+				empty_id_found = true;
+				empty_backing_info = backing_info_addr;
+				empty_id = total_id;
+			}
+			total_id++;
+			continue;
+		}
+
+		if (strcmp(backing_info->path, backing_dev->backing_dev_info.path) == 0) {
+			backing_dev->backing_dev_id = backing_info->backing_dev_id;
+			backing_dev->backing_dev_info_addr = backing_info_addr;
+			*new_backing = false;
+			ret = 0;
+			goto out;
+		}
+		total_id++;
+	}
+
+	if (meta_seg->next_meta_seg) {
+		meta_seg = meta_seg->next_meta_seg;
+		goto again;
+	}
+
+	if (empty_id_found) {
+		backing_dev->backing_dev_info_addr = empty_backing_info;
+		backing_dev->backing_dev_id = empty_id;
+		*new_backing = true;
+		ret = 0;
+		goto out;
+	}
+
+	ret = -ENOSPC;
+	/* TODO allocate a new meta seg for backing_dev_info */
+out:
+	return ret;
+}
+
+int cache_dev_add_backing(struct pcache_cache_dev *cache_dev, struct pcache_backing_dev *backing_dev)
+{
+	mutex_lock(&cache_dev->lock);
+	list_add_tail(&backing_dev->node, &cache_dev->backing_devs);
+	mutex_unlock(&cache_dev->lock);
+
+	return 0;
+}
+
+struct pcache_backing_dev *cache_dev_fetch_backing(struct pcache_cache_dev *cache_dev, u32 backing_dev_id)
+{
+	struct pcache_backing_dev *temp_backing_dev;
+
+	mutex_lock(&cache_dev->lock);
+	list_for_each_entry(temp_backing_dev, &cache_dev->backing_devs, node) {
+		if (temp_backing_dev->backing_dev_id == backing_dev_id) {
+			list_del_init(&temp_backing_dev->node);
+			goto found;
+		}
+	}
+	temp_backing_dev = NULL;
+found:
+	mutex_unlock(&cache_dev->lock);
+	return temp_backing_dev;
+}
+
+int cache_dev_get_empty_segment_id(struct pcache_cache_dev *cache_dev, u32 *seg_id)
+{
+	int ret;
+
+	mutex_lock(&cache_dev->seg_lock);
+	*seg_id = find_next_zero_bit(cache_dev->seg_bitmap, cache_dev->seg_num, 0);
+	if (*seg_id == cache_dev->seg_num) {
+		ret = -ENOSPC;
+		goto unlock;
+	}
+
+	set_bit(*seg_id, cache_dev->seg_bitmap);
+	ret = 0;
+unlock:
+	mutex_unlock(&cache_dev->seg_lock);
+	return ret;
+}
diff --git a/drivers/block/pcache/cache_dev.h b/drivers/block/pcache/cache_dev.h
new file mode 100644
index 000000000000..cad1b97a38ba
--- /dev/null
+++ b/drivers/block/pcache/cache_dev.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_CACHE_DEV_H
+#define _PCACHE_CACHE_DEV_H
+
+#include <linux/device.h>
+
+#include "pcache_internal.h"
+#include "meta_segment.h"
+
+#define cache_dev_err(cache_dev, fmt, ...)						\
+	pcache_err("cache_dev%u: " fmt,							\
+		 cache_dev->id, ##__VA_ARGS__)
+#define cache_dev_info(cache_dev, fmt, ...)						\
+	pcache_info("cache_dev%u: " fmt,						\
+		 cache_dev->id, ##__VA_ARGS__)
+#define cache_dev_debug(cache_dev, fmt, ...)						\
+	pcache_debug("cache_dev%u: " fmt,						\
+		 cache_dev->id, ##__VA_ARGS__)
+
+/*
+ * PCACHE SB flags configured during formatting
+ *
+ * The PCACHE_SB_F_xxx flags define registration requirements based on cache_dev
+ * formatting. For a machine to register a cache_dev:
+ * - PCACHE_SB_F_BIGENDIAN: Requires a big-endian machine.
+ */
+#define PCACHE_SB_F_BIGENDIAN			(1 << 0)
+
+struct pcache_sb {
+	__le32 crc;
+	__le16 version;
+	__le16 flags;
+	__le64 magic;
+
+	__le16 seg_num;
+};
+
+struct pcache_cache_dev {
+	u16				id;
+	u16				seg_num;
+	struct pcache_sb		*sb_addr;
+	struct device			device;
+	struct mutex			lock;
+	struct mutex			adm_lock;
+	struct list_head		backing_devs;
+
+	char				path[PCACHE_PATH_LEN];
+	struct dax_device		*dax_dev;
+	struct file			*bdev_file;
+	struct block_device		*bdev;
+
+	struct mutex			seg_lock;
+	unsigned long			*seg_bitmap;
+
+	struct pcache_meta_segment	*backing_info_seg;
+};
+
+struct pcache_cache_dev_register_options {
+	char path[PCACHE_PATH_LEN];
+	bool format;
+	bool force;
+};
+
+struct pcache_backing_dev;
+int cache_dev_register(struct pcache_cache_dev_register_options *opts);
+int cache_dev_unregister(u32 cache_dev_id);
+
+void cache_dev_flush(struct pcache_cache_dev *cache_dev, void *pos, u32 size);
+void cache_dev_zero_range(struct pcache_cache_dev *cache_dev, void *pos, u32 size);
+
+int cache_dev_find_backing_info(struct pcache_cache_dev *cache_dev,
+				struct pcache_backing_dev *backing_dev, bool *new_backing);
+
+int cache_dev_add_backing(struct pcache_cache_dev *cache_dev, struct pcache_backing_dev *backing_dev);
+struct pcache_backing_dev *cache_dev_fetch_backing(struct pcache_cache_dev *cache_dev, u32 backing_dev_id);
+int cache_dev_get_empty_segment_id(struct pcache_cache_dev *cache_dev, u32 *seg_id);
+
+extern const struct bus_type pcache_bus_type;
+extern struct device pcache_root_dev;
+
+#endif /* _PCACHE_CACHE_DEV_H */
diff --git a/drivers/block/pcache/pcache_internal.h b/drivers/block/pcache/pcache_internal.h
new file mode 100644
index 000000000000..dd51d8339275
--- /dev/null
+++ b/drivers/block/pcache/pcache_internal.h
@@ -0,0 +1,185 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_INTERNAL_H
+#define _PCACHE_INTERNAL_H
+
+#include <linux/delay.h>
+#include <linux/crc32.h>
+
+#define pcache_err(fmt, ...)							\
+	pr_err("pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define pcache_info(fmt, ...)							\
+	pr_info("pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define pcache_debug(fmt, ...)							\
+	pr_debug("pcache: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+
+#define PCACHE_KB			(1024ULL)			/* 1 Kilobyte in bytes */
+#define PCACHE_MB			(1024ULL * PCACHE_KB)		/* 1 Megabyte in bytes */
+
+#define PCACHE_CACHE_DEV_MAX		1024				/* Maximum number of cache_dev instances */
+#define PCACHE_PATH_LEN			256
+
+#define PCACHE_QUEUES_MAX		128				/* Maximum number of I/O queues */
+
+#define PCACHE_PART_SHIFT		4				/* Bit shift for partition identifier */
+
+/* pcache segment */
+#define PCACHE_SEG_SIZE			(16 * 1024 * 1024ULL)		/* Size of each PCACHE segment (16 MB) */
+
+#define PCACHE_MAGIC			0x65B05EFA96C596EFULL		/* Unique identifier for PCACHE cache dev */
+#define PCACHE_VERSION			1
+
+/* Maximum number of metadata indices */
+#define PCACHE_META_INDEX_MAX			2
+
+#define PCACHE_SB_OFF				4096
+#define PCACHE_SB_SIZE				PAGE_SIZE
+
+#define PCACHE_CACHE_DEV_INFO_OFF		(PCACHE_SB_OFF + PCACHE_SB_SIZE)
+#define PCACHE_CACHE_DEV_INFO_SIZE		PAGE_SIZE
+#define PCACHE_CACHE_DEV_INFO_STRIDE		(PCACHE_CACHE_DEV_INFO_SIZE * PCACHE_META_INDEX_MAX)
+
+#define PCACHE_SEGMENTS_OFF			(PCACHE_CACHE_DEV_INFO_OFF + PCACHE_CACHE_DEV_INFO_STRIDE)
+#define PCACHE_SEG_INFO_SIZE			PAGE_SIZE
+
+#define PCACHE_BACKING_DEV_INFO_SIZE		PAGE_SIZE
+
+#define PCACHE_CACHE_DEV_SIZE_MIN		(512 * 1024 * 1024)	 /* 512 MB */
+
+#define CACHE_DEV_SEGMENTS(cache_dev)		((void *)cache_dev->sb_addr + PCACHE_SEGMENTS_OFF)
+#define CACHE_DEV_SEGMENT(cache_dev, id)	((void *)CACHE_DEV_SEGMENTS(cache_dev) + (u64)id * PCACHE_SEG_SIZE)
+
+#define BACKING_DEV_INFO_SEG_ID			0
+#define CACHE_DEV_BACKING_SEG(cache_dev)	(CACHE_DEV_SEGMENT(cache_dev, BACKING_DEV_INFO_SEG_ID))
+
+/*
+ * struct pcache_meta_header - PCACHE metadata header structure
+ * @crc: CRC checksum for validating metadata integrity.
+ * @seq: Sequence number to track metadata updates.
+ * @version: Metadata version.
+ * @res: Reserved space for future use.
+ */
+struct pcache_meta_header {
+	u32 crc;
+	u8  seq;
+	u8  version;
+	u16 res;
+};
+
+/*
+ * pcache_meta_crc - Calculate CRC for the given metadata header.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of the metadata structure.
+ *
+ * Returns the CRC checksum calculated by excluding the CRC field itself.
+ */
+static inline u32 pcache_meta_crc(struct pcache_meta_header *header, u32 meta_size)
+{
+	return crc32(0, (void *)header + 4, meta_size - 4);  /* CRC calculated starting after the crc field */
+}
+
+/*
+ * pcache_meta_seq_after - Check if a sequence number is more recent, accounting for overflow.
+ * @seq1: First sequence number.
+ * @seq2: Second sequence number.
+ *
+ * Determines if @seq1 is more recent than @seq2 by calculating the signed
+ * difference between them. This approach allows handling sequence number
+ * overflow correctly because the difference wraps naturally, and any value
+ * greater than zero indicates that @seq1 is "after" @seq2. This method
+ * assumes 8-bit unsigned sequence numbers, where the difference wraps
+ * around if seq1 overflows past seq2.
+ *
+ * Returns:
+ *   - true if @seq1 is more recent than @seq2, indicating it comes "after"
+ *   - false otherwise.
+ */
+static inline bool pcache_meta_seq_after(u8 seq1, u8 seq2)
+{
+	return (s8)(seq1 - seq2) > 0;
+}
+
+/*
+ * pcache_meta_find_latest - Find the latest valid metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Finds the latest valid metadata by checking sequence numbers. If a
+ * valid entry with the highest sequence number is found, its pointer
+ * is returned. Returns NULL if no valid metadata is found.
+ */
+static inline void *pcache_meta_find_latest(struct pcache_meta_header *header,
+					 u32 meta_size)
+{
+	struct pcache_meta_header *meta, *latest = NULL;
+	u32 i;
+
+	for (i = 0; i < PCACHE_META_INDEX_MAX; i++) {
+		meta = (void *)header + (i * meta_size);
+
+		/* Skip if CRC check fails */
+		if (meta->crc != pcache_meta_crc(meta, meta_size))
+			continue;
+
+		/* Update latest if a more recent sequence is found */
+		if (!latest || pcache_meta_seq_after(meta->seq, latest->seq))
+			latest = meta;
+	}
+
+	return latest;
+}
+
+/*
+ * pcache_meta_find_oldest - Find the oldest valid metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Returns the oldest valid metadata by comparing sequence numbers.
+ * If an entry with the lowest sequence number is found, its pointer
+ * is returned. Returns NULL if no valid metadata is found.
+ */
+static inline void *pcache_meta_find_oldest(struct pcache_meta_header *header,
+					 u32 meta_size)
+{
+	struct pcache_meta_header *meta, *oldest = NULL;
+	u32 i;
+
+	for (i = 0; i < PCACHE_META_INDEX_MAX; i++) {
+		meta = (void *)header + (meta_size * i);
+
+		/* Mark as oldest if CRC check fails */
+		if (meta->crc != pcache_meta_crc(meta, meta_size)) {
+			oldest = meta;
+			break;
+		}
+
+		/* Update oldest if an older sequence is found */
+		if (!oldest || pcache_meta_seq_after(oldest->seq, meta->seq))
+			oldest = meta;
+	}
+
+	BUG_ON(!oldest);
+
+	return oldest;
+}
+
+/*
+ * pcache_meta_get_next_seq - Get the next sequence number for metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Returns the next sequence number based on the latest metadata entry.
+ * If no latest metadata is found, returns 1.
+ */
+static inline u32 pcache_meta_get_next_seq(struct pcache_meta_header *header,
+					u32 meta_size)
+{
+	struct pcache_meta_header *latest;
+
+	latest = pcache_meta_find_latest(header, meta_size);
+	if (!latest)
+		return 1;
+
+	return (latest->seq + 1);
+}
+
+#endif /* _PCACHE_INTERNAL_H */
-- 
2.34.1



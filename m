Return-Path: <linux-bcache+bounces-868-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6966A87572
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA00D3B17DF
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA6F1A23A5;
	Mon, 14 Apr 2025 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m6j3EeA0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8174F19DF4C
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595145; cv=none; b=HchlZPzxrNgKNmj9N1BO9qPwZslxDaaI74M8KOckF7hMcXrH2uANHFJ/+QoaUV6DaFfhGi7UV26Wm14Es3sUjA2TFWpnc/miKWemyxZtYBdTWidOVAlr3ekHuAlxC4iiDj+PVZvXw8jjX6KnMs/3HYQChtTLViFpHDoZ87N6f7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595145; c=relaxed/simple;
	bh=zVxMs05OmDfZgLnqLJ1G8lF3CN9mbZ5S2zzEFcA9Vp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SR8vWj9TVa59iHF3rTN7UmU1wBH7B3Ays11Cyt78i/Ra+Som4UswkUJSAqLk7cPPQczoHzBW0Hs+nKUs4AprVluMIMts5reQOgs8pEHNnU+90WOu1Rwz7M1E2t/a9dshIskSHE4w0Kfyfv2JwX6Ojh6UEoNHRdHAiSgQMLdzliY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m6j3EeA0; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jjg0xfiy8siMDsSsG/q/l/t4ReMnhHpayR4Ys9YZtto=;
	b=m6j3EeA0xLb3IXcEhH2P9aRQjpZOQHgvm2ZzErmCRs65WokqJOKohab6m53j4p4Tkvb+Z+
	Z4muG9Y6TACk4v3IBpUnKVqELLSQqVCc4IGoyhsZm7IBln12EuWocauqbNQTb4GO+OvIMD
	k2UpNazlkLaP58wg2VeuTWuW9wfBIog=
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
Subject: [RFC PATCH 05/11] pcache: introduce lifecycle management of pcache_cache
Date: Mon, 14 Apr 2025 01:44:59 +0000
Message-Id: <20250414014505.20477-6-dongsheng.yang@linux.dev>
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

This patch introduces the core implementation for managing the lifecycle of the
pcache_cache structure, which represents the central cache context in pcache.

Key responsibilities covered by this patch include:

- Allocation and initialization:
  `pcache_cache_alloc()` validates configuration options and allocates the memory
  for the pcache_cache instance, including segment array, ksets, request trees,
  and data heads. It sets up key internal fields such as segment maps, generation
  counters, and in-memory trees.

- Subsystem initialization:
  It initializes all supporting subsystems including segment metadata, key tail/
  dirty tail state, in-memory key trees, and background workers like GC and writeback.

- Clean shutdown and destruction:
  `pcache_cache_destroy()` performs a staged shutdown: flushing remaining keys,
  cancelling work queues, tearing down trees, releasing segments, and freeing memory.
  It ensures all pending metadata and dirty data are safely handled before release.

- Persistent state management:
  Provides helpers to encode and decode the key_tail and dirty_tail positions
  persistently, ensuring the cache can recover its position and metadata after
  a crash or reboot.

By defining a consistent and crash-safe lifecycle model for pcache_cache, this patch
lays the foundation for higher-level cache operations to be implemented safely and
concurrently.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/cache.c | 394 ++++++++++++++++++++++
 drivers/block/pcache/cache.h | 612 +++++++++++++++++++++++++++++++++++
 2 files changed, 1006 insertions(+)
 create mode 100644 drivers/block/pcache/cache.c
 create mode 100644 drivers/block/pcache/cache.h

diff --git a/drivers/block/pcache/cache.c b/drivers/block/pcache/cache.c
new file mode 100644
index 000000000000..0dd61ded4b82
--- /dev/null
+++ b/drivers/block/pcache/cache.c
@@ -0,0 +1,394 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blk_types.h>
+
+#include "logic_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+
+void cache_pos_encode(struct pcache_cache *cache,
+			     struct pcache_cache_pos_onmedia *pos_onmedia,
+			     struct pcache_cache_pos *pos)
+{
+	struct pcache_cache_pos_onmedia *oldest;
+
+	oldest = pcache_meta_find_oldest(&pos_onmedia->header, sizeof(struct pcache_cache_pos_onmedia));
+	BUG_ON(!oldest);
+
+	oldest->cache_seg_id = pos->cache_seg->cache_seg_id;
+	oldest->seg_off = pos->seg_off;
+	oldest->header.seq = pcache_meta_get_next_seq(&pos_onmedia->header, sizeof(struct pcache_cache_pos_onmedia));
+	oldest->header.crc = cache_pos_onmedia_crc(oldest);
+	cache_dev_flush(cache->backing_dev->cache_dev, oldest, sizeof(struct pcache_cache_pos_onmedia));
+}
+
+int cache_pos_decode(struct pcache_cache *cache,
+			    struct pcache_cache_pos_onmedia *pos_onmedia,
+			    struct pcache_cache_pos *pos)
+{
+	struct pcache_cache_pos_onmedia *latest;
+
+	latest = pcache_meta_find_latest(&pos_onmedia->header, sizeof(struct pcache_cache_pos_onmedia));
+	if (!latest)
+		return -EIO;
+
+	pos->cache_seg = &cache->segments[latest->cache_seg_id];
+	pos->seg_off = latest->seg_off;
+
+	return 0;
+}
+
+static void cache_info_set_seg_id(struct pcache_cache *cache, u32 seg_id)
+{
+	cache->cache_info->seg_id = seg_id;
+	backing_dev_info_write(cache->backing_dev);
+}
+
+static struct pcache_cache *cache_alloc(struct pcache_backing_dev *backing_dev)
+{
+	struct pcache_cache *cache;
+
+	cache = kvzalloc(struct_size(cache, segments, backing_dev->cache_segs), GFP_KERNEL);
+	if (!cache)
+		goto err;
+
+	cache->seg_map = bitmap_zalloc(backing_dev->cache_segs, GFP_KERNEL);
+	if (!cache->seg_map)
+		goto free_cache;
+
+	cache->req_cache = KMEM_CACHE(pcache_backing_dev_req, 0);
+	if (!cache->req_cache)
+		goto free_bitmap;
+
+	cache->backing_dev = backing_dev;
+	cache->n_segs = backing_dev->cache_segs;
+	spin_lock_init(&cache->seg_map_lock);
+	spin_lock_init(&cache->key_head_lock);
+
+	mutex_init(&cache->key_tail_lock);
+	mutex_init(&cache->dirty_tail_lock);
+
+	INIT_DELAYED_WORK(&cache->writeback_work, cache_writeback_fn);
+	INIT_DELAYED_WORK(&cache->gc_work, pcache_cache_gc_fn);
+	INIT_WORK(&cache->clean_work, clean_fn);
+
+	return cache;
+
+free_bitmap:
+	bitmap_free(cache->seg_map);
+free_cache:
+	kvfree(cache);
+err:
+	return NULL;
+}
+
+static void cache_free(struct pcache_cache *cache)
+{
+	kmem_cache_destroy(cache->req_cache);
+	bitmap_free(cache->seg_map);
+	kvfree(cache);
+}
+
+static void pcache_cache_info_init(struct pcache_cache_opts *opts)
+{
+	struct pcache_cache_info *cache_info = opts->cache_info;
+
+	cache_info->n_segs = opts->n_segs;
+	cache_info->gc_percent = PCACHE_CACHE_GC_PERCENT_DEFAULT;
+	if (opts->data_crc)
+		cache_info->flags |= PCACHE_CACHE_FLAGS_DATA_CRC;
+}
+
+static int cache_validate(struct pcache_backing_dev *backing_dev,
+			  struct pcache_cache_opts *opts)
+{
+	struct pcache_cache_info *cache_info;
+	int ret = -EINVAL;
+
+	if (opts->n_paral > PCACHE_CACHE_PARAL_MAX) {
+		backing_dev_err(backing_dev, "n_paral too large (max %u).\n",
+			 PCACHE_CACHE_PARAL_MAX);
+		goto err;
+	}
+
+	if (opts->new_cache)
+		pcache_cache_info_init(opts);
+
+	cache_info = opts->cache_info;
+
+	/*
+	 * Check if the number of segments required for the specified n_paral
+	 * exceeds the available segments in the cache. If so, report an error.
+	 */
+	if (opts->n_paral * PCACHE_CACHE_SEGS_EACH_PARAL > cache_info->n_segs) {
+		backing_dev_err(backing_dev, "n_paral %u requires cache size (%llu), more than current (%llu).",
+				opts->n_paral, opts->n_paral * PCACHE_CACHE_SEGS_EACH_PARAL * (u64)PCACHE_SEG_SIZE,
+				cache_info->n_segs * (u64)PCACHE_SEG_SIZE);
+		goto err;
+	}
+
+	if (cache_info->n_segs > backing_dev->cache_dev->seg_num) {
+		backing_dev_err(backing_dev, "too large cache_segs: %u, segment_num: %u\n",
+				cache_info->n_segs, backing_dev->cache_dev->seg_num);
+		goto err;
+	}
+
+	if (cache_info->n_segs > PCACHE_CACHE_SEGS_MAX) {
+		backing_dev_err(backing_dev, "cache_segs: %u larger than PCACHE_CACHE_SEGS_MAX: %u\n",
+				cache_info->n_segs, PCACHE_CACHE_SEGS_MAX);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static int cache_tail_init(struct pcache_cache *cache, bool new_cache)
+{
+	int ret;
+
+	if (new_cache) {
+		set_bit(0, cache->seg_map);
+
+		cache->key_head.cache_seg = &cache->segments[0];
+		cache->key_head.seg_off = 0;
+		cache_pos_copy(&cache->key_tail, &cache->key_head);
+		cache_pos_copy(&cache->dirty_tail, &cache->key_head);
+
+		cache_encode_dirty_tail(cache);
+		cache_encode_key_tail(cache);
+	} else {
+		if (cache_decode_key_tail(cache) || cache_decode_dirty_tail(cache)) {
+			backing_dev_err(cache->backing_dev, "Corrupted key tail or dirty tail.\n");
+			ret = -EIO;
+			goto err;
+		}
+	}
+	return 0;
+err:
+	return ret;
+}
+
+static void cache_segs_destroy(struct pcache_cache *cache)
+{
+	u32 i;
+
+	for (i = 0; i < cache->n_segs; i++)
+		cache_seg_destroy(&cache->segments[i]);
+}
+
+static int get_seg_id(struct pcache_cache *cache,
+		      struct pcache_cache_segment *prev_cache_seg,
+		      bool new_cache, u32 *seg_id)
+{
+	struct pcache_backing_dev *backing_dev = cache->backing_dev;
+	struct pcache_cache_dev *cache_dev = backing_dev->cache_dev;
+	int ret;
+
+	if (new_cache) {
+		ret = cache_dev_get_empty_segment_id(cache_dev, seg_id);
+		if (ret) {
+			backing_dev_err(backing_dev, "no available segment\n");
+			goto err;
+		}
+
+		if (prev_cache_seg)
+			cache_seg_set_next_seg(prev_cache_seg, *seg_id);
+		else
+			cache_info_set_seg_id(cache, *seg_id);
+	} else {
+		if (prev_cache_seg) {
+			struct pcache_segment_info *prev_seg_info;
+
+			prev_seg_info = &prev_cache_seg->cache_seg_info.segment_info;
+			if (!segment_info_has_next(prev_seg_info)) {
+				ret = -EFAULT;
+				goto err;
+			}
+			*seg_id = prev_cache_seg->cache_seg_info.segment_info.next_seg;
+		} else {
+			*seg_id = cache->cache_info->seg_id;
+		}
+	}
+	return 0;
+err:
+	return ret;
+}
+
+static int cache_segs_init(struct pcache_cache *cache, bool new_cache)
+{
+	struct pcache_cache_segment *prev_cache_seg = NULL;
+	struct pcache_cache_info *cache_info = cache->cache_info;
+	u32 seg_id;
+	int ret;
+	u32 i;
+
+	for (i = 0; i < cache_info->n_segs; i++) {
+		ret = get_seg_id(cache, prev_cache_seg, new_cache, &seg_id);
+		if (ret)
+			goto segments_destroy;
+
+		ret = cache_seg_init(cache, seg_id, i, new_cache);
+		if (ret)
+			goto segments_destroy;
+
+		prev_cache_seg = &cache->segments[i];
+	}
+	return 0;
+
+segments_destroy:
+	cache_segs_destroy(cache);
+
+	return ret;
+}
+
+static int cache_init_req_keys(struct pcache_cache *cache, u32 n_paral)
+{
+	u32 n_subtrees;
+	int ret;
+	u32 i;
+
+	/* Calculate number of cache trees based on the device size */
+	n_subtrees = DIV_ROUND_UP(cache->dev_size << SECTOR_SHIFT, PCACHE_CACHE_SUBTREE_SIZE);
+	ret = cache_tree_init(cache, &cache->req_key_tree, n_subtrees);
+	if (ret)
+		goto err;
+
+	/* Set the number of ksets based on n_paral, often corresponding to blkdev multiqueue count */
+	cache->n_ksets = n_paral;
+	cache->ksets = kcalloc(cache->n_ksets, PCACHE_KSET_SIZE, GFP_KERNEL);
+	if (!cache->ksets) {
+		ret = -ENOMEM;
+		goto req_tree_exit;
+	}
+
+	/*
+	 * Initialize each kset with a spinlock and delayed work for flushing.
+	 * Each kset is associated with one queue to ensure independent handling
+	 * of cache keys across multiple queues, maximizing multiqueue concurrency.
+	 */
+	for (i = 0; i < cache->n_ksets; i++) {
+		struct pcache_cache_kset *kset = get_kset(cache, i);
+
+		kset->cache = cache;
+		spin_lock_init(&kset->kset_lock);
+		INIT_DELAYED_WORK(&kset->flush_work, kset_flush_fn);
+	}
+
+	cache->n_heads = n_paral;
+	cache->data_heads = kcalloc(cache->n_heads, sizeof(struct pcache_cache_data_head), GFP_KERNEL);
+	if (!cache->data_heads) {
+		ret = -ENOMEM;
+		goto free_kset;
+	}
+
+	for (i = 0; i < cache->n_heads; i++) {
+		struct pcache_cache_data_head *data_head = &cache->data_heads[i];
+
+		spin_lock_init(&data_head->data_head_lock);
+	}
+
+	/*
+	 * Replay persisted cache keys using cache_replay.
+	 * This function loads and replays cache keys from previously stored
+	 * ksets, allowing the cache to restore its state after a restart.
+	 */
+	ret = cache_replay(cache);
+	if (ret) {
+		backing_dev_err(cache->backing_dev, "failed to replay keys\n");
+		goto free_heads;
+	}
+
+	return 0;
+
+free_heads:
+	kfree(cache->data_heads);
+free_kset:
+	kfree(cache->ksets);
+req_tree_exit:
+	cache_tree_exit(&cache->req_key_tree);
+err:
+	return ret;
+}
+
+static void cache_destroy_req_keys(struct pcache_cache *cache)
+{
+	u32 i;
+
+	for (i = 0; i < cache->n_ksets; i++) {
+		struct pcache_cache_kset *kset = get_kset(cache, i);
+
+		cancel_delayed_work_sync(&kset->flush_work);
+	}
+
+	kfree(cache->data_heads);
+	kfree(cache->ksets);
+	cache_tree_exit(&cache->req_key_tree);
+}
+
+struct pcache_cache *pcache_cache_alloc(struct pcache_backing_dev *backing_dev,
+				  struct pcache_cache_opts *opts)
+{
+	struct pcache_cache *cache;
+	int ret;
+
+	ret = cache_validate(backing_dev, opts);
+	if (ret)
+		return NULL;
+
+	cache = cache_alloc(backing_dev);
+	if (!cache)
+		return NULL;
+
+	cache->bdev_file = opts->bdev_file;
+	cache->dev_size = opts->dev_size;
+	cache->cache_info = opts->cache_info;
+	cache->state = PCACHE_CACHE_STATE_RUNNING;
+
+	ret = cache_segs_init(cache, opts->new_cache);
+	if (ret)
+		goto free_cache;
+
+	ret = cache_tail_init(cache, opts->new_cache);
+	if (ret)
+		goto segs_destroy;
+
+	ret = cache_init_req_keys(cache, opts->n_paral);
+	if (ret)
+		goto segs_destroy;
+
+	ret = cache_writeback_init(cache);
+	if (ret)
+		goto destroy_keys;
+
+	queue_delayed_work(cache->backing_dev->task_wq, &cache->gc_work, 0);
+
+	return cache;
+
+destroy_keys:
+	cache_destroy_req_keys(cache);
+segs_destroy:
+	cache_segs_destroy(cache);
+free_cache:
+	cache_free(cache);
+
+	return NULL;
+}
+
+void pcache_cache_destroy(struct pcache_cache *cache)
+{
+	cache->state = PCACHE_CACHE_STATE_STOPPING;
+	cache_flush(cache);
+
+	cancel_delayed_work_sync(&cache->gc_work);
+	flush_work(&cache->clean_work);
+
+	cache_writeback_exit(cache);
+
+	if (cache->req_key_tree.n_subtrees)
+		cache_destroy_req_keys(cache);
+
+	cache_segs_destroy(cache);
+	cache_free(cache);
+}
diff --git a/drivers/block/pcache/cache.h b/drivers/block/pcache/cache.h
new file mode 100644
index 000000000000..c50e94e0515c
--- /dev/null
+++ b/drivers/block/pcache/cache.h
@@ -0,0 +1,612 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_CACHE_H
+#define _PCACHE_CACHE_H
+
+#include "segment.h"
+
+/* Garbage collection thresholds */
+#define PCACHE_CACHE_GC_PERCENT_MIN       0                   /* Minimum GC percentage */
+#define PCACHE_CACHE_GC_PERCENT_MAX       90                  /* Maximum GC percentage */
+#define PCACHE_CACHE_GC_PERCENT_DEFAULT   70                  /* Default GC percentage */
+
+#define PCACHE_CACHE_PARAL_MAX		128
+#define PCACHE_CACHE_SEGS_EACH_PARAL	10
+
+#define PCACHE_CACHE_SUBTREE_SIZE		(4 * 1024 * 1024)   /* 4MB total tree size */
+#define PCACHE_CACHE_SUBTREE_SIZE_MASK		0x3FFFFF            /* Mask for tree size */
+#define PCACHE_CACHE_SUBTREE_SIZE_SHIFT		22                  /* Bit shift for tree size */
+
+/* Maximum number of keys per key set */
+#define PCACHE_KSET_KEYS_MAX		128
+#define PCACHE_CACHE_SEGS_MAX		(1024 * 1024)	/* maximum cache size for each device is 16T */
+#define PCACHE_KSET_ONMEDIA_SIZE_MAX	struct_size_t(struct pcache_cache_kset_onmedia, data, PCACHE_KSET_KEYS_MAX)
+#define PCACHE_KSET_SIZE		(sizeof(struct pcache_cache_kset) + sizeof(struct pcache_cache_key_onmedia) * PCACHE_KSET_KEYS_MAX)
+
+/* Maximum number of keys to clean in one round of clean_work */
+#define PCACHE_CLEAN_KEYS_MAX             10
+
+/* Writeback and garbage collection intervals in jiffies */
+#define PCACHE_CACHE_WRITEBACK_INTERVAL   (5 * HZ)
+#define PCACHE_CACHE_GC_INTERVAL          (5 * HZ)
+
+/* Macro to get the cache key structure from an rb_node pointer */
+#define CACHE_KEY(node)                (container_of(node, struct pcache_cache_key, rb_node))
+
+struct pcache_cache_pos_onmedia {
+	struct pcache_meta_header header;
+	u32 cache_seg_id;
+	u32 seg_off;
+};
+
+/* Offset and size definitions for cache segment control */
+#define PCACHE_CACHE_SEG_CTRL_OFF     (PCACHE_SEG_INFO_SIZE * PCACHE_META_INDEX_MAX)
+#define PCACHE_CACHE_SEG_CTRL_SIZE    PAGE_SIZE
+
+struct pcache_cache_seg_gen {
+	struct pcache_meta_header header;
+	u64 gen;
+};
+
+/* Control structure for cache segments */
+struct pcache_cache_seg_ctrl {
+	struct pcache_cache_seg_gen gen[PCACHE_META_INDEX_MAX]; /* Updated by blkdev, incremented in invalidating */
+	u64	res[64];
+};
+
+struct pcache_cache_seg_info {
+	struct pcache_segment_info segment_info;   /* must be first member */
+};
+
+#define PCACHE_CACHE_FLAGS_DATA_CRC	(1 << 0)
+
+struct pcache_cache_info {
+	u32 seg_id;
+	u32 n_segs;
+	u16 gc_percent;
+	u16 flags;
+	u32 res2;
+};
+
+struct pcache_cache_pos {
+	struct pcache_cache_segment *cache_seg;
+	u32 seg_off;
+};
+
+enum pcache_cache_seg_state {
+	pcache_cache_seg_state_none	= 0,
+	pcache_cache_seg_state_running
+};
+
+struct pcache_cache_segment {
+	struct pcache_cache	*cache;
+	u32			cache_seg_id;   /* Index in cache->segments */
+	struct pcache_segment	segment;
+	atomic_t		refs;
+
+	atomic_t		state;
+
+	struct pcache_cache_seg_info cache_seg_info;
+	struct mutex           info_lock;
+
+	spinlock_t             gen_lock;
+	u64                    gen;
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl;
+	struct mutex           ctrl_lock;
+};
+
+/* rbtree for cache entries */
+struct pcache_cache_subtree {
+	struct rb_root root;
+	spinlock_t tree_lock;
+};
+
+struct pcache_cache_tree {
+	struct pcache_cache		*cache;
+	u32				n_subtrees;
+	struct kmem_cache		*key_cache;
+	struct pcache_cache_subtree	*subtrees;
+};
+
+#define PCACHE_CACHE_STATE_NONE			0
+#define PCACHE_CACHE_STATE_RUNNING		1
+#define PCACHE_CACHE_STATE_STOPPING		2
+
+/* PCACHE Cache main structure */
+struct pcache_cache {
+	struct pcache_backing_dev	*backing_dev;
+	struct pcache_cache_ctrl	*cache_ctrl;
+
+	u32			n_heads;
+	struct pcache_cache_data_head *data_heads;
+
+	spinlock_t		key_head_lock;
+	struct pcache_cache_pos	key_head;
+	u32			n_ksets;
+	struct pcache_cache_kset	*ksets;
+
+	struct mutex		key_tail_lock;
+	struct pcache_cache_pos	key_tail;
+
+	struct mutex		dirty_tail_lock;
+	struct pcache_cache_pos	dirty_tail;
+
+	struct pcache_cache_tree	req_key_tree;
+	struct work_struct	clean_work;
+
+	struct file		*bdev_file;
+	u64			dev_size;
+	struct delayed_work	writeback_work;
+	struct delayed_work	gc_work;
+
+	struct kmem_cache	*req_cache;
+
+	struct pcache_cache_info	*cache_info;
+
+	u32			state:8;
+
+	u32			n_segs;
+	unsigned long		*seg_map;
+	u32			last_cache_seg;
+	spinlock_t		seg_map_lock;
+	struct pcache_cache_segment segments[]; /* Last member */
+};
+
+/* PCACHE Cache options structure */
+struct pcache_cache_opts {
+	u32 cache_id;
+	void *owner;
+	u32 n_segs;
+	bool new_cache;
+	bool data_crc;
+	u64 dev_size;
+	u32 n_paral;
+	struct file *bdev_file;
+	struct pcache_cache_info *cache_info;
+};
+
+struct pcache_cache *pcache_cache_alloc(struct pcache_backing_dev *backing_dev,
+				  struct pcache_cache_opts *opts);
+void pcache_cache_destroy(struct pcache_cache *cache);
+
+struct pcache_cache_ctrl {
+	struct pcache_cache_seg_ctrl cache_seg_ctrl;
+
+	/* Updated by gc_thread */
+	struct pcache_cache_pos_onmedia key_tail_pos[PCACHE_META_INDEX_MAX];
+
+	/* Updated by writeback_thread */
+	struct pcache_cache_pos_onmedia dirty_tail_pos[PCACHE_META_INDEX_MAX];
+};
+
+struct pcache_cache_data_head {
+	spinlock_t data_head_lock;
+	struct pcache_cache_pos head_pos;
+};
+
+struct pcache_cache_key {
+	struct pcache_cache_tree	*cache_tree;
+	struct pcache_cache_subtree	*cache_subtree;
+	struct kref			ref;
+	struct rb_node			rb_node;
+	struct list_head		list_node;
+	u64				off;
+	u32				len;
+	u64				flags;
+	struct pcache_cache_pos		cache_pos;
+	u64				seg_gen;
+};
+
+#define PCACHE_CACHE_KEY_FLAGS_EMPTY   (1 << 0)
+#define PCACHE_CACHE_KEY_FLAGS_CLEAN   (1 << 1)
+
+struct pcache_cache_key_onmedia {
+	u64 off;
+	u32 len;
+	u32 flags;
+	u32 cache_seg_id;
+	u32 cache_seg_off;
+	u64 seg_gen;
+	u32 data_crc;
+};
+
+struct pcache_cache_kset_onmedia {
+	u32 crc;
+	union {
+		u32 key_num;
+		u32 next_cache_seg_id;
+	};
+	u64 magic;
+	u64 flags;
+	struct pcache_cache_key_onmedia data[];
+};
+
+/* cache key */
+struct pcache_cache_key *cache_key_alloc(struct pcache_cache_tree *cache_tree);
+void cache_key_init(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key);
+void cache_key_get(struct pcache_cache_key *key);
+void cache_key_put(struct pcache_cache_key *key);
+int cache_key_append(struct pcache_cache *cache, struct pcache_cache_key *key);
+int cache_key_insert(struct pcache_cache_tree *cache_tree, struct pcache_cache_key *key, bool fixup);
+int cache_key_decode(struct pcache_cache *cache,
+			struct pcache_cache_key_onmedia *key_onmedia,
+			struct pcache_cache_key *key);
+void cache_pos_advance(struct pcache_cache_pos *pos, u32 len);
+
+#define PCACHE_KSET_FLAGS_LAST		(1 << 0)
+#define PCACHE_KSET_MAGIC		0x676894a64e164f1aULL
+
+struct pcache_cache_kset {
+	struct pcache_cache *cache;
+	spinlock_t        kset_lock;
+	struct delayed_work flush_work;
+	struct pcache_cache_kset_onmedia kset_onmedia;
+};
+
+extern struct pcache_cache_kset_onmedia pcache_empty_kset;
+
+struct pcache_cache_subtree_walk_ctx {
+	struct pcache_cache_tree *cache_tree;
+	struct rb_node *start_node;
+	struct pcache_request *pcache_req;
+	u32	req_done;
+	struct pcache_cache_key *key;
+
+	struct list_head *delete_key_list;
+	struct list_head *submit_req_list;
+
+	/*
+	 *	  |--------|		key_tmp
+	 * |====|			key
+	 */
+	int (*before)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |----------|			key_tmp
+	 *		|=====|		key
+	 */
+	int (*after)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *     |----------------|	key_tmp
+	 * |===========|		key
+	 */
+	int (*overlap_tail)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |--------|			key_tmp
+	 *   |==========|		key
+	 */
+	int (*overlap_head)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *    |----|			key_tmp
+	 * |==========|			key
+	 */
+	int (*overlap_contain)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |-----------|		key_tmp
+	 *   |====|			key
+	 */
+	int (*overlap_contained)(struct pcache_cache_key *key, struct pcache_cache_key *key_tmp,
+			struct pcache_cache_subtree_walk_ctx *ctx);
+
+	int (*walk_finally)(struct pcache_cache_subtree_walk_ctx *ctx);
+	bool (*walk_done)(struct pcache_cache_subtree_walk_ctx *ctx);
+};
+
+int cache_subtree_walk(struct pcache_cache_subtree_walk_ctx *ctx);
+struct rb_node *cache_subtree_search(struct pcache_cache_subtree *cache_subtree, struct pcache_cache_key *key,
+				  struct rb_node **parentp, struct rb_node ***newp,
+				  struct list_head *delete_key_list);
+int cache_kset_close(struct pcache_cache *cache, struct pcache_cache_kset *kset);
+void clean_fn(struct work_struct *work);
+void kset_flush_fn(struct work_struct *work);
+int cache_replay(struct pcache_cache *cache);
+int cache_tree_init(struct pcache_cache *cache, struct pcache_cache_tree *cache_tree, u32 n_subtrees);
+void cache_tree_exit(struct pcache_cache_tree *cache_tree);
+
+/* cache segments */
+struct pcache_cache_segment *get_cache_segment(struct pcache_cache *cache);
+int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache);
+void cache_seg_destroy(struct pcache_cache_segment *cache_seg);
+void cache_seg_get(struct pcache_cache_segment *cache_seg);
+void cache_seg_put(struct pcache_cache_segment *cache_seg);
+void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id);
+
+/* cache info */
+void cache_info_write(struct pcache_cache *cache);
+int cache_info_load(struct pcache_cache *cache);
+
+/* cache request*/
+int cache_flush(struct pcache_cache *cache);
+void miss_read_end_work_fn(struct work_struct *work);
+int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req);
+
+/* gc */
+void pcache_cache_gc_fn(struct work_struct *work);
+
+/* writeback */
+void cache_writeback_exit(struct pcache_cache *cache);
+int cache_writeback_init(struct pcache_cache *cache);
+void cache_writeback_fn(struct work_struct *work);
+
+/* inline functions */
+static inline struct pcache_cache_subtree *get_subtree(struct pcache_cache_tree *cache_tree, u64 off)
+{
+	if (cache_tree->n_subtrees == 1)
+		return &cache_tree->subtrees[0];
+
+	return &cache_tree->subtrees[off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT];
+}
+
+static inline void *cache_pos_addr(struct pcache_cache_pos *pos)
+{
+	return (pos->cache_seg->segment.data + pos->seg_off);
+}
+
+static inline void *get_key_head_addr(struct pcache_cache *cache)
+{
+	return cache_pos_addr(&cache->key_head);
+}
+
+static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
+{
+	return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
+}
+
+static inline struct pcache_cache_kset *get_kset(struct pcache_cache *cache, u32 kset_id)
+{
+	return (void *)cache->ksets + PCACHE_KSET_SIZE * kset_id;
+}
+
+static inline struct pcache_cache_data_head *get_data_head(struct pcache_cache *cache, u32 i)
+{
+	return &cache->data_heads[i % cache->n_heads];
+}
+
+static inline bool cache_key_empty(struct pcache_cache_key *key)
+{
+	return key->flags & PCACHE_CACHE_KEY_FLAGS_EMPTY;
+}
+
+static inline bool cache_key_clean(struct pcache_cache_key *key)
+{
+	return key->flags & PCACHE_CACHE_KEY_FLAGS_CLEAN;
+}
+
+static inline void cache_pos_copy(struct pcache_cache_pos *dst, struct pcache_cache_pos *src)
+{
+	memcpy(dst, src, sizeof(struct pcache_cache_pos));
+}
+
+/**
+ * cache_seg_is_ctrl_seg - Checks if a cache segment is a cache ctrl segment.
+ * @cache_seg_id: ID of the cache segment.
+ *
+ * Returns true if the cache segment ID corresponds to a cache ctrl segment.
+ *
+ * Note: We extend the segment control of the first cache segment
+ * (cache segment ID 0) to serve as the cache control (pcache_cache_ctrl)
+ * for the entire PCACHE cache. This function determines whether the given
+ * cache segment is the one storing the pcache_cache_ctrl information.
+ */
+static inline bool cache_seg_is_ctrl_seg(u32 cache_seg_id)
+{
+	return (cache_seg_id == 0);
+}
+
+/**
+ * cache_key_cutfront - Cuts a specified length from the front of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ * @cut_len: Length to cut from the front.
+ *
+ * Advances the cache key position by cut_len and adjusts offset and length accordingly.
+ */
+static inline void cache_key_cutfront(struct pcache_cache_key *key, u32 cut_len)
+{
+	if (key->cache_pos.cache_seg)
+		cache_pos_advance(&key->cache_pos, cut_len);
+
+	key->off += cut_len;
+	key->len -= cut_len;
+}
+
+/**
+ * cache_key_cutback - Cuts a specified length from the back of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ * @cut_len: Length to cut from the back.
+ *
+ * Reduces the length of the cache key by cut_len.
+ */
+static inline void cache_key_cutback(struct pcache_cache_key *key, u32 cut_len)
+{
+	key->len -= cut_len;
+}
+
+static inline void cache_key_delete(struct pcache_cache_key *key)
+{
+	struct pcache_cache_subtree *cache_subtree;
+
+	cache_subtree = key->cache_subtree;
+	if (!cache_subtree)
+		return;
+
+	rb_erase(&key->rb_node, &cache_subtree->root);
+	key->flags = 0;
+	cache_key_put(key);
+}
+
+static inline bool cache_data_crc_on(struct pcache_cache *cache)
+{
+	return (cache->cache_info->flags & PCACHE_CACHE_FLAGS_DATA_CRC);
+}
+
+/**
+ * cache_key_data_crc - Calculates CRC for data in a cache key.
+ * @key: Pointer to the pcache_cache_key structure.
+ *
+ * Returns the CRC-32 checksum of the data within the cache key's position.
+ */
+static inline u32 cache_key_data_crc(struct pcache_cache_key *key)
+{
+	void *data;
+
+	data = cache_pos_addr(&key->cache_pos);
+
+	return crc32(0, data, key->len);
+}
+
+static inline u32 cache_kset_crc(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	u32 crc_size;
+
+	if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST)
+		crc_size = sizeof(struct pcache_cache_kset_onmedia) - 4;
+	else
+		crc_size = struct_size(kset_onmedia, data, kset_onmedia->key_num) - 4;
+
+	return crc32(0, (void *)kset_onmedia + 4, crc_size);
+}
+
+static inline u32 get_kset_onmedia_size(struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	return struct_size_t(struct pcache_cache_kset_onmedia, data, kset_onmedia->key_num);
+}
+
+/**
+ * cache_seg_remain - Computes remaining space in a cache segment.
+ * @pos: Pointer to pcache_cache_pos structure.
+ *
+ * Returns the amount of remaining space in the segment data starting from
+ * the current position offset.
+ */
+static inline u32 cache_seg_remain(struct pcache_cache_pos *pos)
+{
+	struct pcache_cache_segment *cache_seg;
+	struct pcache_segment *segment;
+	u32 seg_remain;
+
+	cache_seg = pos->cache_seg;
+	segment = &cache_seg->segment;
+	seg_remain = segment->data_size - pos->seg_off;
+
+	return seg_remain;
+}
+
+/**
+ * cache_key_invalid - Checks if a cache key is invalid.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns true if the cache key is invalid due to its generation being
+ * less than the generation of its segment; otherwise returns false.
+ *
+ * When the GC (garbage collection) thread identifies a segment
+ * as reclaimable, it increments the segment's generation (gen). However,
+ * it does not immediately remove all related cache keys. When accessing
+ * such a cache key, this function can be used to determine if the cache
+ * key has already become invalid.
+ */
+static inline bool cache_key_invalid(struct pcache_cache_key *key)
+{
+	if (cache_key_empty(key))
+		return false;
+
+	return (key->seg_gen < key->cache_pos.cache_seg->gen);
+}
+
+/**
+ * cache_key_lstart - Retrieves the logical start offset of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns the logical start offset for the cache key.
+ */
+static inline u64 cache_key_lstart(struct pcache_cache_key *key)
+{
+	return key->off;
+}
+
+/**
+ * cache_key_lend - Retrieves the logical end offset of a cache key.
+ * @key: Pointer to pcache_cache_key structure.
+ *
+ * Returns the logical end offset for the cache key.
+ */
+static inline u64 cache_key_lend(struct pcache_cache_key *key)
+{
+	return key->off + key->len;
+}
+
+static inline void cache_key_copy(struct pcache_cache_key *key_dst, struct pcache_cache_key *key_src)
+{
+	key_dst->off = key_src->off;
+	key_dst->len = key_src->len;
+	key_dst->seg_gen = key_src->seg_gen;
+	key_dst->cache_tree = key_src->cache_tree;
+	key_dst->cache_subtree = key_src->cache_subtree;
+	key_dst->flags = key_src->flags;
+
+	cache_pos_copy(&key_dst->cache_pos, &key_src->cache_pos);
+}
+
+/**
+ * cache_pos_onmedia_crc - Calculates the CRC for an on-media cache position.
+ * @pos_om: Pointer to pcache_cache_pos_onmedia structure.
+ *
+ * Calculates the CRC-32 checksum of the position, excluding the first 4 bytes.
+ * Returns the computed CRC value.
+ */
+static inline u32 cache_pos_onmedia_crc(struct pcache_cache_pos_onmedia *pos_om)
+{
+	return pcache_meta_crc(&pos_om->header, sizeof(struct pcache_cache_pos_onmedia));
+}
+
+void cache_pos_encode(struct pcache_cache *cache,
+			     struct pcache_cache_pos_onmedia *pos_onmedia,
+			     struct pcache_cache_pos *pos);
+int cache_pos_decode(struct pcache_cache *cache,
+			    struct pcache_cache_pos_onmedia *pos_onmedia,
+			    struct pcache_cache_pos *pos);
+
+static inline void cache_encode_key_tail(struct pcache_cache *cache)
+{
+	mutex_lock(&cache->key_tail_lock);
+	cache_pos_encode(cache, cache->cache_ctrl->key_tail_pos, &cache->key_tail);
+	mutex_unlock(&cache->key_tail_lock);
+}
+
+static inline int cache_decode_key_tail(struct pcache_cache *cache)
+{
+	int ret;
+
+	mutex_lock(&cache->key_tail_lock);
+	ret = cache_pos_decode(cache, cache->cache_ctrl->key_tail_pos, &cache->key_tail);
+	mutex_unlock(&cache->key_tail_lock);
+
+	return ret;
+}
+
+static inline void cache_encode_dirty_tail(struct pcache_cache *cache)
+{
+	mutex_lock(&cache->dirty_tail_lock);
+	cache_pos_encode(cache, cache->cache_ctrl->dirty_tail_pos, &cache->dirty_tail);
+	mutex_unlock(&cache->dirty_tail_lock);
+}
+
+static inline int cache_decode_dirty_tail(struct pcache_cache *cache)
+{
+	int ret;
+
+	mutex_lock(&cache->dirty_tail_lock);
+	ret = cache_pos_decode(cache, cache->cache_ctrl->dirty_tail_pos, &cache->dirty_tail);
+	mutex_unlock(&cache->dirty_tail_lock);
+
+	return ret;
+}
+#endif /* _PCACHE_CACHE_H */
-- 
2.34.1



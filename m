Return-Path: <linux-bcache+bounces-835-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8A8FA03C74
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D43C3A55DA
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F7FE1EE7BB;
	Tue,  7 Jan 2025 10:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hO3KCZ2i"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E99D1E9B02
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245907; cv=none; b=rrREk8X0YeIc0v4LCV9iU8fDAYEkZCsc/UMWIqsAOFir704ISfNosppZ3LG4uv5DF+nUFgd/Q98c6Mgxoaj37mPeIX2cSJ2za8ZCG0FpNEBjrzRTzjWL5Cia5DdsuDMNOHK2W14NxlsNVcts+fWICY3WM+5q5+pahgpts0E8Os4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245907; c=relaxed/simple;
	bh=uZnXYM6MbCVWNo/sAr+Eg/Jd25/m8UWI4O1XNBjgsIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=otOMNHiZajx+6F6TchYqkJjPCrHEKmPDmqbKF2b07zrMIutWWuoGb0huF43XxHMzCaZGzIrEsx6dAx0DGBHq4qrO+CzJM+VqrbyoRgvI6VW9oOLnEHw3lsPVZWcJ1F1B1o/U1Y9gkPtXPGzvH2basEuooa2sYGv38mWJ3NPgqhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hO3KCZ2i; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKdwbrmecvKfPhVtAA9W1E6Mh29K7ZH6gitD2xn5BMY=;
	b=hO3KCZ2ivIcus5Kz3CY0hKnAY802KIrvHrikuweMHOY4BIllG0M6ShW4Czkh30suYN+SH6
	CKZ9xA+Z/I3lasTQn+marWz/9HC8aayzZ8sIORbaTn0bhSB3rC1AQNWM5o9+VPhi72/cSc
	e2S6hkxlkqt5fJE2K97ylALvr6U5A8g=
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
Subject: [PATCH v3 7/8] cbd: introduce cbd_cache
Date: Tue,  7 Jan 2025 10:30:23 +0000
Message-Id: <20250107103024.326986-8-dongsheng.yang@linux.dev>
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

cbd cache is a lightweight solution that uses persistent memory as block
device cache. It works similar with bcache, where bcache uses block
devices as cache drives, but cbd cache only supports persistent memory
devices for caching. It s designed specifically for PMEM scenarios, with
a simple design and implementation, aiming to provide a low-latency,
high-concurrency, and performance-stable caching solution.

Note: cbd cache is not intended to replace your bcache. Instead, it
offers an alternative solution specifically suited for scenarios where
you want to use persistent memory devices as block device cache.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_cache/cbd_cache.c       | 489 ++++++++++
 drivers/block/cbd/cbd_cache/cbd_cache.h       | 157 +++
 drivers/block/cbd/cbd_cache/cbd_cache_gc.c    | 167 ++++
 .../block/cbd/cbd_cache/cbd_cache_internal.h  | 536 ++++++++++
 drivers/block/cbd/cbd_cache/cbd_cache_key.c   | 881 +++++++++++++++++
 drivers/block/cbd/cbd_cache/cbd_cache_req.c   | 921 ++++++++++++++++++
 .../block/cbd/cbd_cache/cbd_cache_segment.c   | 268 +++++
 .../block/cbd/cbd_cache/cbd_cache_writeback.c | 197 ++++
 8 files changed, 3616 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache.c
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache.h
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_gc.c
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_internal.h
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_key.c
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_req.c
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_segment.c
 create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_writeback.c

diff --git a/drivers/block/cbd/cbd_cache/cbd_cache.c b/drivers/block/cbd/cbd_cache/cbd_cache.c
new file mode 100644
index 000000000000..3b08f7f4c3bd
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache.c
@@ -0,0 +1,489 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/blk_types.h>
+
+#include "../cbd_backend.h"
+#include "cbd_cache_internal.h"
+
+void cbd_cache_info_init(struct cbd_cache_info *cache_info, u32 cache_segs)
+{
+	cache_info->n_segs = cache_segs;
+	cache_info->gc_percent = CBD_CACHE_GC_PERCENT_DEFAULT;
+}
+
+static void cache_segs_destroy(struct cbd_cache *cache)
+{
+	u32 i;
+
+	if (!cache->owner)
+		return;
+
+	for (i = 0; i < cache->n_segs; i++)
+		cache_seg_destroy(&cache->segments[i]);
+}
+
+static void cache_info_set_seg_id(struct cbd_cache *cache, u32 seg_id)
+{
+	cache->cache_info->seg_id = seg_id;
+	cache_info_write(cache);
+}
+
+/*
+ * get_seg_id - Retrieve the segment ID for cache initialization
+ * @cache: Pointer to the cache structure
+ * @prev_cache_seg: Pointer to the previous cache segment in the sequence
+ * @new_cache: Flag indicating if this is a new cache initialization
+ * @seg_id: Pointer to store the retrieved or allocated segment ID
+ *
+ * For a new cache, this function allocates a new segment ID,
+ * and links it with the previous segment in the chain.
+ *
+ * If reloading an existing cache, it retrieves the segment ID based on the
+ * segment chain, using the previous segment information to maintain continuity.
+ */
+static int get_seg_id(struct cbd_cache *cache,
+		      struct cbd_cache_segment *prev_cache_seg,
+		      bool new_cache, u32 *seg_id)
+{
+	struct cbd_transport *cbdt = cache->cbdt;
+	int ret;
+
+	if (new_cache) {
+		ret = cbdt_get_empty_segment_id(cbdt, seg_id);
+		if (ret) {
+			cbd_cache_err(cache, "no available segment\n");
+			goto err;
+		}
+
+		if (prev_cache_seg)
+			cache_seg_set_next_seg(prev_cache_seg, *seg_id);
+		else
+			cache_info_set_seg_id(cache, *seg_id);
+	} else {
+		if (prev_cache_seg) {
+			struct cbd_segment_info *prev_seg_info;
+
+			prev_seg_info = &prev_cache_seg->cache_seg_info.segment_info;
+			if (!cbd_segment_info_has_next(prev_seg_info)) {
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
+static int cache_segs_init(struct cbd_cache *cache, bool new_cache)
+{
+	struct cbd_cache_segment *prev_cache_seg = NULL;
+	struct cbd_cache_info *cache_info = cache->cache_info;
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
+static void used_segs_update_work_fn(struct work_struct *work)
+{
+	struct cbd_cache *cache = container_of(work, struct cbd_cache, used_segs_update_work);
+	struct cbd_cache_used_segs *used_segs;
+
+	used_segs = cbd_meta_find_oldest(&cache->cache_ctrl->used_segs->header, sizeof(struct cbd_cache_used_segs));
+
+	used_segs->header.seq = cbd_meta_get_next_seq(&used_segs->header, sizeof(struct cbd_cache_used_segs));
+	used_segs->used_segs = bitmap_weight(cache->seg_map, cache->n_segs);
+	used_segs->header.crc = cbd_meta_crc(&used_segs->header, sizeof(struct cbd_cache_used_segs));
+
+	cbdt_flush(cache->cbdt, used_segs, sizeof(struct cbd_cache_used_segs));
+}
+
+static struct cbd_cache *cache_alloc(struct cbd_transport *cbdt, struct cbd_cache_info *cache_info)
+{
+	struct cbd_cache *cache;
+
+	cache = kvzalloc(struct_size(cache, segments, cache_info->n_segs), GFP_KERNEL);
+	if (!cache)
+		goto err;
+
+	cache->seg_map = bitmap_zalloc(cache_info->n_segs, GFP_KERNEL);
+	if (!cache->seg_map)
+		goto free_cache;
+
+	cache->req_cache = KMEM_CACHE(cbd_request, 0);
+	if (!cache->req_cache)
+		goto free_bitmap;
+
+	cache->cache_wq = alloc_workqueue("cbdt%d-c%u",  WQ_UNBOUND | WQ_MEM_RECLAIM,
+					0, cbdt->id, cache->cache_id);
+	if (!cache->cache_wq)
+		goto free_req_cache;
+
+	cache->cbdt = cbdt;
+	cache->cache_info = cache_info;
+	cache->n_segs = cache_info->n_segs;
+	spin_lock_init(&cache->seg_map_lock);
+	spin_lock_init(&cache->key_head_lock);
+	spin_lock_init(&cache->miss_read_reqs_lock);
+	INIT_LIST_HEAD(&cache->miss_read_reqs);
+
+	mutex_init(&cache->key_tail_lock);
+	mutex_init(&cache->dirty_tail_lock);
+
+	INIT_DELAYED_WORK(&cache->writeback_work, cache_writeback_fn);
+	INIT_DELAYED_WORK(&cache->gc_work, cbd_cache_gc_fn);
+	INIT_WORK(&cache->clean_work, clean_fn);
+	INIT_WORK(&cache->miss_read_end_work, miss_read_end_work_fn);
+	INIT_WORK(&cache->used_segs_update_work, used_segs_update_work_fn);
+
+	return cache;
+
+free_req_cache:
+	kmem_cache_destroy(cache->req_cache);
+free_bitmap:
+	bitmap_free(cache->seg_map);
+free_cache:
+	kvfree(cache);
+err:
+	return NULL;
+}
+
+static void cache_free(struct cbd_cache *cache)
+{
+	drain_workqueue(cache->cache_wq);
+	destroy_workqueue(cache->cache_wq);
+	kmem_cache_destroy(cache->req_cache);
+	bitmap_free(cache->seg_map);
+	kvfree(cache);
+}
+
+static int cache_init_req_keys(struct cbd_cache *cache, u32 n_paral)
+{
+	u32 n_subtrees;
+	int ret;
+	u32 i;
+
+	/* Calculate number of cache trees based on the device size */
+	n_subtrees = DIV_ROUND_UP(cache->dev_size << SECTOR_SHIFT, CBD_CACHE_SUBTREE_SIZE);
+	ret = cache_tree_init(cache, &cache->req_key_tree, n_subtrees);
+	if (ret)
+		goto err;
+
+	/* Set the number of ksets based on n_paral, often corresponding to blkdev multiqueue count */
+	cache->n_ksets = n_paral;
+	cache->ksets = kcalloc(cache->n_ksets, CBD_KSET_SIZE, GFP_KERNEL);
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
+		struct cbd_cache_kset *kset = get_kset(cache, i);
+
+		kset->cache = cache;
+		spin_lock_init(&kset->kset_lock);
+		INIT_DELAYED_WORK(&kset->flush_work, kset_flush_fn);
+	}
+
+	cache->n_heads = n_paral;
+	cache->data_heads = kcalloc(cache->n_heads, sizeof(struct cbd_cache_data_head), GFP_KERNEL);
+	if (!cache->data_heads) {
+		ret = -ENOMEM;
+		goto free_kset;
+	}
+
+	for (i = 0; i < cache->n_heads; i++) {
+		struct cbd_cache_data_head *data_head = &cache->data_heads[i];
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
+		cbd_cache_err(cache, "failed to replay keys\n");
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
+static void cache_destroy_req_keys(struct cbd_cache *cache)
+{
+	u32 i;
+
+	for (i = 0; i < cache->n_ksets; i++) {
+		struct cbd_cache_kset *kset = get_kset(cache, i);
+
+		cancel_delayed_work_sync(&kset->flush_work);
+	}
+
+	kfree(cache->data_heads);
+	kfree(cache->ksets);
+	cache_tree_exit(&cache->req_key_tree);
+}
+
+static int __cache_info_load(struct cbd_transport *cbdt,
+			      struct cbd_cache_info *cache_info,
+			      u32 cache_id);
+static int cache_validate(struct cbd_transport *cbdt,
+			  struct cbd_cache_opts *opts)
+{
+	struct cbd_cache_info *cache_info;
+	int ret = -EINVAL;
+
+	if (opts->n_paral > CBD_CACHE_PARAL_MAX) {
+		cbdt_err(cbdt, "n_paral too large (max %u).\n",
+			 CBD_CACHE_PARAL_MAX);
+		goto err;
+	}
+
+	/*
+	 * For a new cache, ensure an owner backend is specified
+	 * and initialize cache information with the specified number of segments.
+	 */
+	if (opts->new_cache) {
+		if (!opts->owner) {
+			cbdt_err(cbdt, "owner is needed for new cache.\n");
+			goto err;
+		}
+
+		cbd_cache_info_init(opts->cache_info, opts->n_segs);
+	} else {
+		/* Load cache information from storage for existing cache */
+		ret = __cache_info_load(cbdt, opts->cache_info, opts->cache_id);
+		if (ret)
+			goto err;
+	}
+
+	cache_info = opts->cache_info;
+
+	/*
+	 * Check if the number of segments required for the specified n_paral
+	 * exceeds the available segments in the cache. If so, report an error.
+	 */
+	if (opts->n_paral * CBD_CACHE_SEGS_EACH_PARAL > cache_info->n_segs) {
+		cbdt_err(cbdt, "n_paral %u requires cache size (%llu), more than current (%llu).",
+				opts->n_paral, opts->n_paral * CBD_CACHE_SEGS_EACH_PARAL * (u64)CBDT_SEG_SIZE,
+				cache_info->n_segs * (u64)CBDT_SEG_SIZE);
+		goto err;
+	}
+
+	if (cache_info->n_segs > cbdt->transport_info.segment_num) {
+		cbdt_err(cbdt, "too large cache_segs: %u, segment_num: %u\n",
+				cache_info->n_segs, cbdt->transport_info.segment_num);
+		goto err;
+	}
+
+	if (cache_info->n_segs > CBD_CACHE_SEGS_MAX) {
+		cbdt_err(cbdt, "cache_segs: %u larger than CBD_CACHE_SEGS_MAX: %u\n",
+				cache_info->n_segs, CBD_CACHE_SEGS_MAX);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static int cache_tail_init(struct cbd_cache *cache, bool new_cache)
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
+			cbd_cache_err(cache, "Corrupted key tail or dirty tail.\n");
+			ret = -EIO;
+			goto err;
+		}
+	}
+	return 0;
+err:
+	return ret;
+}
+
+struct cbd_cache *cbd_cache_alloc(struct cbd_transport *cbdt,
+				  struct cbd_cache_opts *opts)
+{
+	struct cbd_cache *cache;
+	int ret;
+
+	ret = cache_validate(cbdt, opts);
+	if (ret)
+		return NULL;
+
+	cache = cache_alloc(cbdt, opts->cache_info);
+	if (!cache)
+		return NULL;
+
+	cache->bdev_file = opts->bdev_file;
+	cache->dev_size = opts->dev_size;
+	cache->cache_id = opts->cache_id;
+	cache->owner = opts->owner;
+	cache->state = CBD_CACHE_STATE_RUNNING;
+
+	ret = cache_segs_init(cache, opts->new_cache);
+	if (ret)
+		goto free_cache;
+
+	ret = cache_tail_init(cache, opts->new_cache);
+	if (ret)
+		goto segs_destroy;
+
+	if (opts->init_req_keys) {
+		ret = cache_init_req_keys(cache, opts->n_paral);
+		if (ret)
+			goto segs_destroy;
+	}
+
+	if (opts->start_writeback) {
+		cache->start_writeback = 1;
+		ret = cache_writeback_init(cache);
+		if (ret)
+			goto destroy_keys;
+	}
+
+	if (opts->start_gc) {
+		cache->start_gc = 1;
+		queue_delayed_work(cache->cache_wq, &cache->gc_work, 0);
+	}
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
+void cbd_cache_destroy(struct cbd_cache *cache)
+{
+	cache->state = CBD_CACHE_STATE_STOPPING;
+
+	flush_work(&cache->miss_read_end_work);
+	cache_flush(cache);
+
+	if (cache->start_gc) {
+		cancel_delayed_work_sync(&cache->gc_work);
+		flush_work(&cache->clean_work);
+	}
+
+	if (cache->start_writeback)
+		cache_writeback_exit(cache);
+
+	if (cache->req_key_tree.n_subtrees)
+		cache_destroy_req_keys(cache);
+
+	flush_work(&cache->used_segs_update_work);
+
+	cache_segs_destroy(cache);
+	cache_free(cache);
+}
+
+/*
+ * cache_info_write - Write cache information to backend
+ * @cache: Pointer to the cache structure
+ *
+ * This function writes the cache's metadata to the backend. Only the owner
+ * backend of the cache is permitted to perform this operation. It asserts
+ * that the cache has an owner backend.
+ */
+void cache_info_write(struct cbd_cache *cache)
+{
+	struct cbd_backend *backend = cache->owner;
+
+	/* Ensure only owner backend is allowed to write */
+	BUG_ON(!backend);
+
+	cbd_backend_info_write(backend);
+}
+
+static int __cache_info_load(struct cbd_transport *cbdt,
+			      struct cbd_cache_info *cache_info,
+			      u32 cache_id)
+{
+	struct cbd_backend_info *backend_info;
+
+	backend_info = cbdt_backend_info_read(cbdt, cache_id);
+	if (!backend_info)
+		return -ENOENT;
+
+	memcpy(cache_info, &backend_info->cache_info, sizeof(struct cbd_cache_info));
+
+	return 0;
+}
+
+int cache_info_load(struct cbd_cache *cache)
+{
+	return __cache_info_load(cache->cbdt, cache->cache_info, cache->cache_id);
+}
+
+u32 cache_info_used_segs(struct cbd_transport *cbdt, struct cbd_cache_info *cache_info)
+{
+	struct cbd_cache_used_segs *latest_used_segs;
+	struct cbd_cache_ctrl *cache_ctrl;
+	void *seg_info;
+
+	seg_info = cbdt_get_segment_info(cbdt, cache_info->seg_id);
+	cache_ctrl = (seg_info + CBDT_CACHE_SEG_CTRL_OFF);
+
+	latest_used_segs = cbd_meta_find_latest(&cache_ctrl->used_segs->header,
+						sizeof(struct cbd_cache_used_segs));
+	if (!latest_used_segs)
+		return 0;
+
+	return latest_used_segs->used_segs;
+}
diff --git a/drivers/block/cbd/cbd_cache/cbd_cache.h b/drivers/block/cbd/cbd_cache/cbd_cache.h
new file mode 100644
index 000000000000..b267876288fc
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache.h
@@ -0,0 +1,157 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_CACHE_H
+#define _CBD_CACHE_H
+
+#include "../cbd_transport.h"
+#include "../cbd_segment.h"
+
+#define cbd_cache_err(cache, fmt, ...)                \
+	cbdt_err(cache->cbdt, "cache%d: " fmt,             \
+		 cache->cache_id, ##__VA_ARGS__)
+#define cbd_cache_info(cache, fmt, ...)               \
+	cbdt_info(cache->cbdt, "cache%d: " fmt,            \
+		 cache->cache_id, ##__VA_ARGS__)
+#define cbd_cache_debug(cache, fmt, ...)              \
+	cbdt_debug(cache->cbdt, "cache%d: " fmt,           \
+		 cache->cache_id, ##__VA_ARGS__)
+
+/* Garbage collection thresholds */
+#define CBD_CACHE_GC_PERCENT_MIN       0                   /* Minimum GC percentage */
+#define CBD_CACHE_GC_PERCENT_MAX       90                  /* Maximum GC percentage */
+#define CBD_CACHE_GC_PERCENT_DEFAULT   70                  /* Default GC percentage */
+
+struct cbd_cache_seg_info {
+	struct cbd_segment_info segment_info;   /* must be first member */
+};
+
+struct cbd_cache_info {
+	u32 seg_id;
+	u32 n_segs;
+	u16 gc_percent;
+	u16 res;
+	u32 res2;
+};
+
+struct cbd_cache_pos {
+	struct cbd_cache_segment *cache_seg;
+	u32 seg_off;
+};
+
+enum cbd_cache_seg_state {
+	cbd_cache_seg_state_none	= 0,
+	cbd_cache_seg_state_running
+};
+
+struct cbd_cache_segment {
+	struct cbd_cache	*cache;
+	u32			cache_seg_id;   /* Index in cache->segments */
+	u32			used;
+	struct cbd_segment	segment;
+	atomic_t		refs;
+
+	atomic_t		state;
+
+	/* Segment info, updated only by the owner backend */
+	struct cbd_cache_seg_info cache_seg_info;
+	struct mutex           info_lock;
+
+	spinlock_t             gen_lock;
+	u64                    gen;
+	struct cbd_cache_seg_ctrl *cache_seg_ctrl;
+	struct mutex           ctrl_lock;
+};
+
+/* rbtree for cache entries */
+struct cbd_cache_subtree {
+	struct rb_root root;
+	spinlock_t tree_lock;
+};
+
+struct cbd_cache_tree {
+	struct cbd_cache		*cache;
+	u32				n_subtrees;
+	struct kmem_cache		*key_cache;
+	struct cbd_cache_subtree	*subtrees;
+};
+
+#define CBD_CACHE_STATE_NONE		0
+#define CBD_CACHE_STATE_RUNNING		1
+#define CBD_CACHE_STATE_STOPPING	2
+
+/* CBD Cache main structure */
+struct cbd_cache {
+	struct cbd_transport	*cbdt;
+	u32			cache_id;  /* Same as related backend->backend_id */
+	void			*owner;    /* For backend cache side only */
+	struct cbd_cache_info	*cache_info;
+	struct cbd_cache_ctrl	*cache_ctrl;
+
+	u32			n_heads;
+	struct cbd_cache_data_head *data_heads;
+
+	spinlock_t		key_head_lock;
+	struct cbd_cache_pos	key_head;
+	u32			n_ksets;
+	struct cbd_cache_kset	*ksets;
+
+	struct mutex		key_tail_lock;
+	struct cbd_cache_pos	key_tail;
+
+	struct mutex		dirty_tail_lock;
+	struct cbd_cache_pos	dirty_tail;
+
+	struct cbd_cache_tree	req_key_tree;
+	struct work_struct	clean_work;
+	struct work_struct	used_segs_update_work;
+
+	spinlock_t		miss_read_reqs_lock;
+	struct list_head	miss_read_reqs;
+	struct work_struct	miss_read_end_work;
+
+	struct workqueue_struct	*cache_wq;
+
+	struct file		*bdev_file;
+	u64			dev_size;
+	struct delayed_work	writeback_work;
+	struct delayed_work	gc_work;
+	struct bio_set		*bioset;
+
+	struct kmem_cache	*req_cache;
+
+	u32			state:8;
+	u32			init_req_keys:1;
+	u32			start_writeback:1;
+	u32			start_gc:1;
+
+	u32			n_segs;
+	unsigned long		*seg_map;
+	u32			last_cache_seg;
+	spinlock_t		seg_map_lock;
+	struct cbd_cache_segment segments[]; /* Last member */
+};
+
+/* CBD Cache options structure */
+struct cbd_cache_opts {
+	u32 cache_id;
+	struct cbd_cache_info *cache_info;
+	void *owner;
+	u32 n_segs;
+	bool new_cache;
+	bool start_writeback;
+	bool start_gc;
+	bool init_req_keys;
+	u64 dev_size;
+	u32 n_paral;
+	struct file *bdev_file;
+};
+
+/* CBD Cache API function declarations */
+struct cbd_cache *cbd_cache_alloc(struct cbd_transport *cbdt, struct cbd_cache_opts *opts);
+void cbd_cache_destroy(struct cbd_cache *cache);
+void cbd_cache_info_init(struct cbd_cache_info *cache_info, u32 cache_segs);
+
+struct cbd_request;
+int cbd_cache_handle_req(struct cbd_cache *cache, struct cbd_request *cbd_req);
+u32 cache_info_used_segs(struct cbd_transport *cbdt, struct cbd_cache_info *cache_info);
+
+#endif /* _CBD_CACHE_H */
diff --git a/drivers/block/cbd/cbd_cache/cbd_cache_gc.c b/drivers/block/cbd/cbd_cache/cbd_cache_gc.c
new file mode 100644
index 000000000000..f387d52214fb
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache_gc.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cbd_cache_internal.h"
+
+/**
+ * cache_key_gc - Releases the reference of a cache key segment.
+ * @cache: Pointer to the cbd_cache structure.
+ * @key: Pointer to the cache key to be garbage collected.
+ *
+ * This function decrements the reference count of the cache segment
+ * associated with the given key. If the reference count drops to zero,
+ * the segment may be invalidated and reused.
+ */
+static void cache_key_gc(struct cbd_cache *cache, struct cbd_cache_key *key)
+{
+	cache_seg_put(key->cache_pos.cache_seg);
+}
+
+/**
+ * need_gc - Determines if garbage collection is needed for the cache.
+ * @cache: Pointer to the cbd_cache structure.
+ *
+ * This function checks if garbage collection is necessary based on the
+ * current state of the cache, including the position of the dirty tail,
+ * the integrity of the key segment on media, and the percentage of used
+ * segments compared to the configured threshold.
+ *
+ * Return: true if garbage collection is needed, false otherwise.
+ */
+static bool need_gc(struct cbd_cache *cache)
+{
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+	void *dirty_addr, *key_addr;
+	u32 segs_used, segs_gc_threshold;
+	int ret;
+
+	/* Refresh dirty_tail position; it may be updated by writeback */
+	ret = cache_decode_dirty_tail(cache);
+	if (ret) {
+		cbd_cache_debug(cache, "failed to decode dirty_tail\n");
+		return false;
+	}
+
+	dirty_addr = cache_pos_addr(&cache->dirty_tail);
+	key_addr = cache_pos_addr(&cache->key_tail);
+	if (dirty_addr == key_addr) {
+		cbd_cache_debug(cache, "key tail is equal to dirty tail: %u:%u\n",
+				cache->dirty_tail.cache_seg->cache_seg_id,
+				cache->dirty_tail.seg_off);
+		return false;
+	}
+
+	/* Check if kset_onmedia is corrupted */
+	kset_onmedia = (struct cbd_cache_kset_onmedia *)key_addr;
+	if (kset_onmedia->magic != CBD_KSET_MAGIC) {
+		cbd_cache_debug(cache, "gc error: magic is not as expected. key_tail: %u:%u magic: %llx, expected: %llx\n",
+					cache->key_tail.cache_seg->cache_seg_id, cache->key_tail.seg_off,
+					kset_onmedia->magic, CBD_KSET_MAGIC);
+		return false;
+	}
+
+	/* Verify the CRC of the kset_onmedia */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		cbd_cache_debug(cache, "gc error: crc is not as expected. crc: %x, expected: %x\n",
+					cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return false;
+	}
+
+	/*
+	 * Load gc_percent and check GC threshold. gc_percent can be modified
+	 * via sysfs in metadata, so we need to load the latest cache_info here.
+	 */
+	ret = cache_info_load(cache);
+	if (ret)
+		return false;
+
+	segs_used = bitmap_weight(cache->seg_map, cache->n_segs);
+	segs_gc_threshold = cache->n_segs * cache->cache_info->gc_percent / 100;
+	if (segs_used < segs_gc_threshold) {
+		cbd_cache_debug(cache, "segs_used: %u, segs_gc_threshold: %u\n", segs_used, segs_gc_threshold);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * last_kset_gc - Advances the garbage collection for the last kset.
+ * @cache: Pointer to the cbd_cache structure.
+ * @kset_onmedia: Pointer to the kset_onmedia structure for the last kset.
+ */
+static int last_kset_gc(struct cbd_cache *cache, struct cbd_cache_kset_onmedia *kset_onmedia)
+{
+	struct cbd_cache_segment *cur_seg, *next_seg;
+
+	/* Don't move to the next segment if dirty_tail has not moved */
+	if (cache->dirty_tail.cache_seg == cache->key_tail.cache_seg)
+		return -EAGAIN;
+
+	cur_seg = cache->key_tail.cache_seg;
+
+	next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
+	cache->key_tail.cache_seg = next_seg;
+	cache->key_tail.seg_off = 0;
+	cache_encode_key_tail(cache);
+
+	cbd_cache_debug(cache, "gc advance kset seg: %u\n", cur_seg->cache_seg_id);
+
+	spin_lock(&cache->seg_map_lock);
+	clear_bit(cur_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+
+	queue_work(cache->cache_wq, &cache->used_segs_update_work);
+
+	return 0;
+}
+
+void cbd_cache_gc_fn(struct work_struct *work)
+{
+	struct cbd_cache *cache = container_of(work, struct cbd_cache, gc_work.work);
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+	struct cbd_cache_key_onmedia *key_onmedia;
+	struct cbd_cache_key *key;
+	int ret;
+	int i;
+
+	while (true) {
+		if (!need_gc(cache))
+			break;
+
+		kset_onmedia = (struct cbd_cache_kset_onmedia *)cache_pos_addr(&cache->key_tail);
+
+		if (kset_onmedia->flags & CBD_KSET_FLAGS_LAST) {
+			ret = last_kset_gc(cache, kset_onmedia);
+			if (ret)
+				break;
+			continue;
+		}
+
+		for (i = 0; i < kset_onmedia->key_num; i++) {
+			struct cbd_cache_key key_tmp = { 0 };
+
+			key_onmedia = &kset_onmedia->data[i];
+
+			key = &key_tmp;
+			cache_key_init(&cache->req_key_tree, key);
+
+			ret = cache_key_decode(cache, key_onmedia, key);
+			if (ret) {
+				cbd_cache_err(cache, "failed to decode cache key in gc\n");
+				break;
+			}
+
+			cache_key_gc(cache, key);
+		}
+
+		cbd_cache_debug(cache, "gc advance: %u:%u %u\n",
+			cache->key_tail.cache_seg->cache_seg_id,
+			cache->key_tail.seg_off,
+			get_kset_onmedia_size(kset_onmedia));
+
+		cache_pos_advance(&cache->key_tail, get_kset_onmedia_size(kset_onmedia));
+		cache_encode_key_tail(cache);
+	}
+
+	queue_delayed_work(cache->cache_wq, &cache->gc_work, CBD_CACHE_GC_INTERVAL);
+}
diff --git a/drivers/block/cbd/cbd_cache/cbd_cache_internal.h b/drivers/block/cbd/cbd_cache/cbd_cache_internal.h
new file mode 100644
index 000000000000..0aa2e8d72eef
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache_internal.h
@@ -0,0 +1,536 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_CACHE_INTERNAL_H
+#define _CBD_CACHE_INTERNAL_H
+
+#include "cbd_cache.h"
+
+#define CBD_CACHE_PARAL_MAX		128
+#define CBD_CACHE_SEGS_EACH_PARAL	10
+
+#define CBD_CACHE_SUBTREE_SIZE		(4 * 1024 * 1024)   /* 4MB total tree size */
+#define CBD_CACHE_SUBTREE_SIZE_MASK	0x3FFFFF            /* Mask for tree size */
+#define CBD_CACHE_SUBTREE_SIZE_SHIFT	22                  /* Bit shift for tree size */
+
+/* Maximum number of keys per key set */
+#define CBD_KSET_KEYS_MAX		128
+#define CBD_CACHE_SEGS_MAX		(1024 * 1024)	/* maximum cache size for each device is 16T */
+#define CBD_KSET_ONMEDIA_SIZE_MAX	struct_size_t(struct cbd_cache_kset_onmedia, data, CBD_KSET_KEYS_MAX)
+#define CBD_KSET_SIZE			(sizeof(struct cbd_cache_kset) + sizeof(struct cbd_cache_key_onmedia) * CBD_KSET_KEYS_MAX)
+
+/* Maximum number of keys to clean in one round of clean_work */
+#define CBD_CLEAN_KEYS_MAX             10
+
+/* Writeback and garbage collection intervals in jiffies */
+#define CBD_CACHE_WRITEBACK_INTERVAL   (1 * HZ)
+#define CBD_CACHE_GC_INTERVAL          (1 * HZ)
+
+/* Macro to get the cache key structure from an rb_node pointer */
+#define CACHE_KEY(node)                (container_of(node, struct cbd_cache_key, rb_node))
+
+struct cbd_cache_pos_onmedia {
+	struct cbd_meta_header header;
+	u32 cache_seg_id;
+	u32 seg_off;
+};
+
+/* Offset and size definitions for cache segment control */
+#define CBDT_CACHE_SEG_CTRL_OFF     (CBDT_SEG_INFO_SIZE * CBDT_META_INDEX_MAX)
+#define CBDT_CACHE_SEG_CTRL_SIZE    PAGE_SIZE
+
+struct cbd_cache_seg_gen {
+	struct cbd_meta_header header;
+	u64 gen;
+};
+
+/* Control structure for cache segments */
+struct cbd_cache_seg_ctrl {
+	struct cbd_cache_seg_gen gen[CBDT_META_INDEX_MAX]; /* Updated by blkdev, incremented in invalidating */
+	u64	res[64];
+};
+
+/*
+ * cbd_cache_ctrl points to the address of the first cbd_cache_seg_ctrl.
+ * It extends the control structure of the first cache segment, storing
+ * information relevant to the entire cbd_cache.
+ */
+#define CBDT_CACHE_CTRL_OFF CBDT_SEG_INFO_SIZE
+#define CBDT_CACHE_CTRL_SIZE PAGE_SIZE
+
+struct cbd_cache_used_segs {
+	struct cbd_meta_header header;
+	u32	used_segs;
+};
+
+/* cbd_cache_info is a part of cbd_backend_info and can only be updated
+ * by the backend. Its integrity is ensured by a unified meta_header.
+ * In contrast, the information within cbd_cache_ctrl may be updated by blkdev.
+ * Each piece of data in cbd_cache_ctrl has its own meta_header to ensure
+ * integrity, allowing for independent updates.
+ */
+struct cbd_cache_ctrl {
+	struct cbd_cache_seg_ctrl cache_seg_ctrl;
+
+	/* Updated by blkdev gc_thread */
+	struct cbd_cache_pos_onmedia key_tail_pos[CBDT_META_INDEX_MAX];
+
+	/* Updated by backend writeback_thread */
+	struct cbd_cache_pos_onmedia dirty_tail_pos[CBDT_META_INDEX_MAX];
+
+	/* Updated by blkdev */
+	struct cbd_cache_used_segs used_segs[CBDT_META_INDEX_MAX];
+};
+
+struct cbd_cache_data_head {
+	spinlock_t data_head_lock;
+	struct cbd_cache_pos head_pos;
+};
+
+struct cbd_cache_key {
+	struct cbd_cache_tree		*cache_tree;
+	struct cbd_cache_subtree	*cache_subtree;
+	struct kref			ref;
+	struct rb_node			rb_node;
+	struct list_head		list_node;
+	u64				off;
+	u32				len;
+	u64				flags;
+	struct cbd_cache_pos		cache_pos;
+	u64				seg_gen;
+};
+
+#define CBD_CACHE_KEY_FLAGS_EMPTY   (1 << 0)
+#define CBD_CACHE_KEY_FLAGS_CLEAN   (1 << 1)
+
+struct cbd_cache_key_onmedia {
+	u64 off;
+	u32 len;
+	u32 flags;
+	u32 cache_seg_id;
+	u32 cache_seg_off;
+	u64 seg_gen;
+#ifdef CONFIG_CBD_CACHE_DATA_CRC
+	u32 data_crc;
+#endif
+};
+
+struct cbd_cache_kset_onmedia {
+	u32 crc;
+	union {
+		u32 key_num;
+		u32 next_cache_seg_id;
+	};
+	u64 magic;
+	u64 flags;
+	struct cbd_cache_key_onmedia data[];
+};
+
+extern struct cbd_cache_kset_onmedia cbd_empty_kset;
+
+/* cache key */
+struct cbd_cache_key *cache_key_alloc(struct cbd_cache_tree *cache_tree);
+void cache_key_init(struct cbd_cache_tree *cache_tree, struct cbd_cache_key *key);
+void cache_key_get(struct cbd_cache_key *key);
+void cache_key_put(struct cbd_cache_key *key);
+int cache_key_append(struct cbd_cache *cache, struct cbd_cache_key *key);
+int cache_key_insert(struct cbd_cache_tree *cache_tree, struct cbd_cache_key *key, bool fixup);
+int cache_key_decode(struct cbd_cache *cache,
+			struct cbd_cache_key_onmedia *key_onmedia,
+			struct cbd_cache_key *key);
+void cache_pos_advance(struct cbd_cache_pos *pos, u32 len);
+
+#define CBD_KSET_FLAGS_LAST (1 << 0)
+#define CBD_KSET_MAGIC      0x676894a64e164f1aULL
+
+struct cbd_cache_kset {
+	struct cbd_cache *cache;
+	spinlock_t        kset_lock;
+	struct delayed_work flush_work;
+	struct cbd_cache_kset_onmedia kset_onmedia;
+};
+
+struct cbd_cache_subtree_walk_ctx {
+	struct cbd_cache_tree *cache_tree;
+	struct rb_node *start_node;
+	struct cbd_request *cbd_req;
+	u32	req_done;
+	struct cbd_cache_key *key;
+
+	struct list_head *delete_key_list;
+	struct list_head *submit_req_list;
+
+	/*
+	 *	  |--------|		key_tmp
+	 * |====|			key
+	 */
+	int (*before)(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+			struct cbd_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |----------|			key_tmp
+	 *		|=====|		key
+	 */
+	int (*after)(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+			struct cbd_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *     |----------------|	key_tmp
+	 * |===========|		key
+	 */
+	int (*overlap_tail)(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+			struct cbd_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |--------|			key_tmp
+	 *   |==========|		key
+	 */
+	int (*overlap_head)(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+			struct cbd_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 *    |----|			key_tmp
+	 * |==========|			key
+	 */
+	int (*overlap_contain)(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+			struct cbd_cache_subtree_walk_ctx *ctx);
+
+	/*
+	 * |-----------|		key_tmp
+	 *   |====|			key
+	 */
+	int (*overlap_contained)(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+			struct cbd_cache_subtree_walk_ctx *ctx);
+
+	int (*walk_finally)(struct cbd_cache_subtree_walk_ctx *ctx);
+	bool (*walk_done)(struct cbd_cache_subtree_walk_ctx *ctx);
+};
+
+int cache_subtree_walk(struct cbd_cache_subtree_walk_ctx *ctx);
+struct rb_node *cache_subtree_search(struct cbd_cache_subtree *cache_subtree, struct cbd_cache_key *key,
+				  struct rb_node **parentp, struct rb_node ***newp,
+				  struct list_head *delete_key_list);
+int cache_kset_close(struct cbd_cache *cache, struct cbd_cache_kset *kset);
+void clean_fn(struct work_struct *work);
+void kset_flush_fn(struct work_struct *work);
+int cache_replay(struct cbd_cache *cache);
+int cache_tree_init(struct cbd_cache *cache, struct cbd_cache_tree *cache_tree, u32 n_subtrees);
+void cache_tree_exit(struct cbd_cache_tree *cache_tree);
+
+/* cache segments */
+struct cbd_cache_segment *get_cache_segment(struct cbd_cache *cache);
+int cache_seg_init(struct cbd_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache);
+void cache_seg_destroy(struct cbd_cache_segment *cache_seg);
+void cache_seg_get(struct cbd_cache_segment *cache_seg);
+void cache_seg_put(struct cbd_cache_segment *cache_seg);
+void cache_seg_set_next_seg(struct cbd_cache_segment *cache_seg, u32 seg_id);
+
+/* cache info */
+void cache_info_write(struct cbd_cache *cache);
+int cache_info_load(struct cbd_cache *cache);
+
+/* cache request*/
+int cache_flush(struct cbd_cache *cache);
+void miss_read_end_work_fn(struct work_struct *work);
+
+/* gc */
+void cbd_cache_gc_fn(struct work_struct *work);
+
+/* writeback */
+void cache_writeback_exit(struct cbd_cache *cache);
+int cache_writeback_init(struct cbd_cache *cache);
+void cache_writeback_fn(struct work_struct *work);
+
+/* inline functions */
+static inline struct cbd_cache_subtree *get_subtree(struct cbd_cache_tree *cache_tree, u64 off)
+{
+	if (cache_tree->n_subtrees == 1)
+		return &cache_tree->subtrees[0];
+
+	return &cache_tree->subtrees[off >> CBD_CACHE_SUBTREE_SIZE_SHIFT];
+}
+
+static inline void *cache_pos_addr(struct cbd_cache_pos *pos)
+{
+	return (pos->cache_seg->segment.data + pos->seg_off);
+}
+
+static inline void *get_key_head_addr(struct cbd_cache *cache)
+{
+	return cache_pos_addr(&cache->key_head);
+}
+
+static inline u32 get_kset_id(struct cbd_cache *cache, u64 off)
+{
+	return (off >> CBD_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
+}
+
+static inline struct cbd_cache_kset *get_kset(struct cbd_cache *cache, u32 kset_id)
+{
+	return (void *)cache->ksets + CBD_KSET_SIZE * kset_id;
+}
+
+static inline struct cbd_cache_data_head *get_data_head(struct cbd_cache *cache, u32 i)
+{
+	return &cache->data_heads[i % cache->n_heads];
+}
+
+static inline bool cache_key_empty(struct cbd_cache_key *key)
+{
+	return key->flags & CBD_CACHE_KEY_FLAGS_EMPTY;
+}
+
+static inline bool cache_key_clean(struct cbd_cache_key *key)
+{
+	return key->flags & CBD_CACHE_KEY_FLAGS_CLEAN;
+}
+
+static inline void cache_pos_copy(struct cbd_cache_pos *dst, struct cbd_cache_pos *src)
+{
+	memcpy(dst, src, sizeof(struct cbd_cache_pos));
+}
+
+/**
+ * cache_seg_is_ctrl_seg - Checks if a cache segment is a cache ctrl segment.
+ * @cache_seg_id: ID of the cache segment.
+ *
+ * Returns true if the cache segment ID corresponds to a cache ctrl segment.
+ *
+ * Note: We extend the segment control of the first cache segment
+ * (cache segment ID 0) to serve as the cache control (cbd_cache_ctrl)
+ * for the entire CBD cache. This function determines whether the given
+ * cache segment is the one storing the cbd_cache_ctrl information.
+ */
+static inline bool cache_seg_is_ctrl_seg(u32 cache_seg_id)
+{
+	return (cache_seg_id == 0);
+}
+
+/**
+ * cache_key_cutfront - Cuts a specified length from the front of a cache key.
+ * @key: Pointer to cbd_cache_key structure.
+ * @cut_len: Length to cut from the front.
+ *
+ * Advances the cache key position by cut_len and adjusts offset and length accordingly.
+ */
+static inline void cache_key_cutfront(struct cbd_cache_key *key, u32 cut_len)
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
+ * @key: Pointer to cbd_cache_key structure.
+ * @cut_len: Length to cut from the back.
+ *
+ * Reduces the length of the cache key by cut_len.
+ */
+static inline void cache_key_cutback(struct cbd_cache_key *key, u32 cut_len)
+{
+	key->len -= cut_len;
+}
+
+static inline void cache_key_delete(struct cbd_cache_key *key)
+{
+	struct cbd_cache_subtree *cache_subtree;
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
+/**
+ * cache_key_data_crc - Calculates CRC for data in a cache key.
+ * @key: Pointer to the cbd_cache_key structure.
+ *
+ * Returns the CRC-32 checksum of the data within the cache key's position.
+ */
+static inline u32 cache_key_data_crc(struct cbd_cache_key *key)
+{
+	void *data;
+
+	data = cache_pos_addr(&key->cache_pos);
+
+	return crc32(0, data, key->len);
+}
+
+static inline u32 cache_kset_crc(struct cbd_cache_kset_onmedia *kset_onmedia)
+{
+	u32 crc_size;
+
+	if (kset_onmedia->flags & CBD_KSET_FLAGS_LAST)
+		crc_size = sizeof(struct cbd_cache_kset_onmedia) - 4;
+	else
+		crc_size = struct_size(kset_onmedia, data, kset_onmedia->key_num) - 4;
+
+	return crc32(0, (void *)kset_onmedia + 4, crc_size);
+}
+
+static inline u32 get_kset_onmedia_size(struct cbd_cache_kset_onmedia *kset_onmedia)
+{
+	return struct_size_t(struct cbd_cache_kset_onmedia, data, kset_onmedia->key_num);
+}
+
+/**
+ * cache_seg_remain - Computes remaining space in a cache segment.
+ * @pos: Pointer to cbd_cache_pos structure.
+ *
+ * Returns the amount of remaining space in the segment data starting from
+ * the current position offset.
+ */
+static inline u32 cache_seg_remain(struct cbd_cache_pos *pos)
+{
+	struct cbd_cache_segment *cache_seg;
+	struct cbd_segment *segment;
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
+ * @key: Pointer to cbd_cache_key structure.
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
+static inline bool cache_key_invalid(struct cbd_cache_key *key)
+{
+	if (cache_key_empty(key))
+		return false;
+
+	return (key->seg_gen < key->cache_pos.cache_seg->gen);
+}
+
+/**
+ * cache_key_lstart - Retrieves the logical start offset of a cache key.
+ * @key: Pointer to cbd_cache_key structure.
+ *
+ * Returns the logical start offset for the cache key.
+ */
+static inline u64 cache_key_lstart(struct cbd_cache_key *key)
+{
+	return key->off;
+}
+
+/**
+ * cache_key_lend - Retrieves the logical end offset of a cache key.
+ * @key: Pointer to cbd_cache_key structure.
+ *
+ * Returns the logical end offset for the cache key.
+ */
+static inline u64 cache_key_lend(struct cbd_cache_key *key)
+{
+	return key->off + key->len;
+}
+
+static inline void cache_key_copy(struct cbd_cache_key *key_dst, struct cbd_cache_key *key_src)
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
+ * @pos_om: Pointer to cbd_cache_pos_onmedia structure.
+ *
+ * Calculates the CRC-32 checksum of the position, excluding the first 4 bytes.
+ * Returns the computed CRC value.
+ */
+static inline u32 cache_pos_onmedia_crc(struct cbd_cache_pos_onmedia *pos_om)
+{
+	return crc32(0, (void *)pos_om + 4, sizeof(*pos_om) - 4);
+}
+
+static inline void cache_pos_encode(struct cbd_cache *cache,
+			     struct cbd_cache_pos_onmedia *pos_onmedia,
+			     struct cbd_cache_pos *pos)
+{
+	struct cbd_cache_pos_onmedia *oldest;
+
+	oldest = cbd_meta_find_oldest(&pos_onmedia->header, sizeof(struct cbd_cache_pos_onmedia));
+	BUG_ON(!oldest);
+
+	oldest->cache_seg_id = pos->cache_seg->cache_seg_id;
+	oldest->seg_off = pos->seg_off;
+	oldest->header.seq = cbd_meta_get_next_seq(&pos_onmedia->header, sizeof(struct cbd_cache_pos_onmedia));
+	oldest->header.crc = cache_pos_onmedia_crc(oldest);
+	cbdt_flush(cache->cbdt, oldest, sizeof(struct cbd_cache_pos_onmedia));
+}
+
+static inline int cache_pos_decode(struct cbd_cache *cache,
+			    struct cbd_cache_pos_onmedia *pos_onmedia,
+			    struct cbd_cache_pos *pos)
+{
+	struct cbd_cache_pos_onmedia *latest;
+
+	latest = cbd_meta_find_latest(&pos_onmedia->header, sizeof(struct cbd_cache_pos_onmedia));
+	if (!latest)
+		return -EIO;
+
+	pos->cache_seg = &cache->segments[latest->cache_seg_id];
+	pos->seg_off = latest->seg_off;
+
+	return 0;
+}
+
+static inline void cache_encode_key_tail(struct cbd_cache *cache)
+{
+	mutex_lock(&cache->key_tail_lock);
+	cache_pos_encode(cache, cache->cache_ctrl->key_tail_pos, &cache->key_tail);
+	mutex_unlock(&cache->key_tail_lock);
+}
+
+static inline int cache_decode_key_tail(struct cbd_cache *cache)
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
+static inline void cache_encode_dirty_tail(struct cbd_cache *cache)
+{
+	mutex_lock(&cache->dirty_tail_lock);
+	cache_pos_encode(cache, cache->cache_ctrl->dirty_tail_pos, &cache->dirty_tail);
+	mutex_unlock(&cache->dirty_tail_lock);
+}
+
+static inline int cache_decode_dirty_tail(struct cbd_cache *cache)
+{
+	int ret;
+
+	mutex_lock(&cache->dirty_tail_lock);
+	ret = cache_pos_decode(cache, cache->cache_ctrl->dirty_tail_pos, &cache->dirty_tail);
+	mutex_unlock(&cache->dirty_tail_lock);
+
+	return ret;
+}
+
+#endif /* _CBD_CACHE_INTERNAL_H */
diff --git a/drivers/block/cbd/cbd_cache/cbd_cache_key.c b/drivers/block/cbd/cbd_cache/cbd_cache_key.c
new file mode 100644
index 000000000000..8697ab57bdec
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache_key.c
@@ -0,0 +1,881 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "cbd_cache_internal.h"
+
+struct cbd_cache_kset_onmedia cbd_empty_kset = { 0 };
+
+void cache_key_init(struct cbd_cache_tree *cache_tree, struct cbd_cache_key *key)
+{
+	kref_init(&key->ref);
+	key->cache_tree = cache_tree;
+	INIT_LIST_HEAD(&key->list_node);
+	RB_CLEAR_NODE(&key->rb_node);
+}
+
+struct cbd_cache_key *cache_key_alloc(struct cbd_cache_tree *cache_tree)
+{
+	struct cbd_cache_key *key;
+
+	key = kmem_cache_zalloc(cache_tree->key_cache, GFP_NOWAIT);
+	if (!key)
+		return NULL;
+
+	cache_key_init(cache_tree, key);
+
+	return key;
+}
+
+/**
+ * cache_key_get - Increment the reference count of a cache key.
+ * @key: Pointer to the cbd_cache_key structure.
+ *
+ * This function increments the reference count of the specified cache key,
+ * ensuring that it is not freed while still in use.
+ */
+void cache_key_get(struct cbd_cache_key *key)
+{
+	kref_get(&key->ref);
+}
+
+/**
+ * cache_key_destroy - Free a cache key structure when its reference count drops to zero.
+ * @ref: Pointer to the kref structure.
+ *
+ * This function is called when the reference count of the cache key reaches zero.
+ * It frees the allocated cache key back to the slab cache.
+ */
+static void cache_key_destroy(struct kref *ref)
+{
+	struct cbd_cache_key *key = container_of(ref, struct cbd_cache_key, ref);
+	struct cbd_cache_tree *cache_tree = key->cache_tree;
+
+	kmem_cache_free(cache_tree->key_cache, key);
+}
+
+void cache_key_put(struct cbd_cache_key *key)
+{
+	kref_put(&key->ref, cache_key_destroy);
+}
+
+void cache_pos_advance(struct cbd_cache_pos *pos, u32 len)
+{
+	/* Ensure enough space remains in the current segment */
+	BUG_ON(cache_seg_remain(pos) < len);
+
+	pos->seg_off += len;
+}
+
+static void cache_key_encode(struct cbd_cache_key_onmedia *key_onmedia,
+			     struct cbd_cache_key *key)
+{
+	key_onmedia->off = key->off;
+	key_onmedia->len = key->len;
+
+	key_onmedia->cache_seg_id = key->cache_pos.cache_seg->cache_seg_id;
+	key_onmedia->cache_seg_off = key->cache_pos.seg_off;
+
+	key_onmedia->seg_gen = key->seg_gen;
+	key_onmedia->flags = key->flags;
+
+#ifdef CONFIG_CBD_CACHE_DATA_CRC
+	key_onmedia->data_crc = cache_key_data_crc(key);
+#endif
+}
+
+int cache_key_decode(struct cbd_cache *cache,
+			struct cbd_cache_key_onmedia *key_onmedia,
+			struct cbd_cache_key *key)
+{
+	key->off = key_onmedia->off;
+	key->len = key_onmedia->len;
+
+	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
+	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
+
+	key->seg_gen = key_onmedia->seg_gen;
+	key->flags = key_onmedia->flags;
+
+#ifdef CONFIG_CBD_CACHE_DATA_CRC
+	if (key_onmedia->data_crc != cache_key_data_crc(key)) {
+		cbd_cache_err(cache, "key: %llu:%u seg %u:%u data_crc error: %x, expected: %x\n",
+				key->off, key->len, key->cache_pos.cache_seg->cache_seg_id,
+				key->cache_pos.seg_off, cache_key_data_crc(key), key_onmedia->data_crc);
+		return -EIO;
+	}
+#endif
+	return 0;
+}
+
+static void append_last_kset(struct cbd_cache *cache, u32 next_seg)
+{
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+
+	kset_onmedia = get_key_head_addr(cache);
+	kset_onmedia->flags |= CBD_KSET_FLAGS_LAST;
+	kset_onmedia->next_cache_seg_id = next_seg;
+	kset_onmedia->magic = CBD_KSET_MAGIC;
+	kset_onmedia->crc = cache_kset_crc(kset_onmedia);
+	cache_pos_advance(&cache->key_head, sizeof(struct cbd_cache_kset_onmedia));
+}
+
+int cache_kset_close(struct cbd_cache *cache, struct cbd_cache_kset *kset)
+{
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+	u32 kset_onmedia_size;
+	int ret;
+
+	kset_onmedia = &kset->kset_onmedia;
+
+	if (!kset_onmedia->key_num)
+		return 0;
+
+	kset_onmedia_size = struct_size(kset_onmedia, data, kset_onmedia->key_num);
+
+	spin_lock(&cache->key_head_lock);
+again:
+	/* Reserve space for the last kset */
+	if (cache_seg_remain(&cache->key_head) < kset_onmedia_size + sizeof(struct cbd_cache_kset_onmedia)) {
+		struct cbd_cache_segment *next_seg;
+
+		next_seg = get_cache_segment(cache);
+		if (!next_seg) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		/* clear outdated kset in next seg */
+		memcpy_flushcache(next_seg->segment.data, &cbd_empty_kset,
+					sizeof(struct cbd_cache_kset_onmedia));
+		append_last_kset(cache, next_seg->cache_seg_id);
+		cache->key_head.cache_seg = next_seg;
+		cache->key_head.seg_off = 0;
+		goto again;
+	}
+
+	kset_onmedia->magic = CBD_KSET_MAGIC;
+	kset_onmedia->crc = cache_kset_crc(kset_onmedia);
+
+	/* clear outdated kset after current kset */
+	memcpy_flushcache(get_key_head_addr(cache) + kset_onmedia_size, &cbd_empty_kset,
+				sizeof(struct cbd_cache_kset_onmedia));
+
+	/* write current kset into segment */
+	memcpy_flushcache(get_key_head_addr(cache), kset_onmedia, kset_onmedia_size);
+	memset(kset_onmedia, 0, sizeof(struct cbd_cache_kset_onmedia));
+	cache_pos_advance(&cache->key_head, kset_onmedia_size);
+
+	ret = 0;
+out:
+	spin_unlock(&cache->key_head_lock);
+
+	return ret;
+}
+
+/**
+ * cache_key_append - Append a cache key to the related kset.
+ * @cache: Pointer to the cbd_cache structure.
+ * @key: Pointer to the cache key structure to append.
+ *
+ * This function appends a cache key to the appropriate kset. If the kset
+ * is full, it closes the kset. If not, it queues a flush work to write
+ * the kset to media.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int cache_key_append(struct cbd_cache *cache, struct cbd_cache_key *key)
+{
+	struct cbd_cache_kset *kset;
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+	struct cbd_cache_key_onmedia *key_onmedia;
+	u32 kset_id = get_kset_id(cache, key->off);
+	int ret = 0;
+
+	kset = get_kset(cache, kset_id);
+	kset_onmedia = &kset->kset_onmedia;
+
+	spin_lock(&kset->kset_lock);
+	key_onmedia = &kset_onmedia->data[kset_onmedia->key_num];
+	cache_key_encode(key_onmedia, key);
+
+	/* Check if the current kset has reached the maximum number of keys */
+	if (++kset_onmedia->key_num == CBD_KSET_KEYS_MAX) {
+		/* If full, close the kset */
+		ret = cache_kset_close(cache, kset);
+		if (ret) {
+			kset_onmedia->key_num--;
+			goto out;
+		}
+	} else {
+		/* If not full, queue a delayed work to flush the kset */
+		queue_delayed_work(cache->cache_wq, &kset->flush_work, 1 * HZ);
+	}
+out:
+	spin_unlock(&kset->kset_lock);
+
+	return ret;
+}
+
+/**
+ * cache_subtree_walk - Traverse the cache tree.
+ * @cache: Pointer to the cbd_cache structure.
+ * @ctx: Pointer to the context structure for traversal.
+ *
+ * This function traverses the cache tree starting from the specified node.
+ * It calls the appropriate callback functions based on the relationships
+ * between the keys in the cache tree.
+ *
+ * Returns 0 on success, or a negative error code on failure.
+ */
+int cache_subtree_walk(struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_cache_key *key_tmp, *key;
+	struct rb_node *node_tmp;
+	int ret;
+
+	key = ctx->key;
+	node_tmp = ctx->start_node;
+
+	while (node_tmp) {
+		if (ctx->walk_done && ctx->walk_done(ctx))
+			break;
+
+		key_tmp = CACHE_KEY(node_tmp);
+		/*
+		 * If key_tmp ends before the start of key, continue to the next node.
+		 * |----------|
+		 *              |=====|
+		 */
+		if (cache_key_lend(key_tmp) <= cache_key_lstart(key)) {
+			if (ctx->after) {
+				ret = ctx->after(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			goto next;
+		}
+
+		/*
+		 * If key_tmp starts after the end of key, stop traversing.
+		 *	  |--------|
+		 * |====|
+		 */
+		if (cache_key_lstart(key_tmp) >= cache_key_lend(key)) {
+			if (ctx->before) {
+				ret = ctx->before(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			break;
+		}
+
+		/* Handle overlapping keys */
+		if (cache_key_lstart(key_tmp) >= cache_key_lstart(key)) {
+			/*
+			 * If key_tmp encompasses key.
+			 *     |----------------|	key_tmp
+			 * |===========|		key
+			 */
+			if (cache_key_lend(key_tmp) >= cache_key_lend(key)) {
+				if (ctx->overlap_tail) {
+					ret = ctx->overlap_tail(key, key_tmp, ctx);
+					if (ret)
+						goto out;
+				}
+				break;
+			}
+
+			/*
+			 * If key_tmp is contained within key.
+			 *    |----|		key_tmp
+			 * |==========|		key
+			 */
+			if (ctx->overlap_contain) {
+				ret = ctx->overlap_contain(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+
+			goto next;
+		}
+
+		/*
+		 * If key_tmp starts before key ends but ends after key.
+		 * |-----------|	key_tmp
+		 *   |====|		key
+		 */
+		if (cache_key_lend(key_tmp) > cache_key_lend(key)) {
+			if (ctx->overlap_contained) {
+				ret = ctx->overlap_contained(key, key_tmp, ctx);
+				if (ret)
+					goto out;
+			}
+			break;
+		}
+
+		/*
+		 * If key_tmp starts before key and ends within key.
+		 * |--------|		key_tmp
+		 *   |==========|	key
+		 */
+		if (ctx->overlap_head) {
+			ret = ctx->overlap_head(key, key_tmp, ctx);
+			if (ret)
+				goto out;
+		}
+next:
+		node_tmp = rb_next(node_tmp);
+	}
+
+	if (ctx->walk_finally) {
+		ret = ctx->walk_finally(ctx);
+		if (ret)
+			goto out;
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * cache_subtree_search - Search for a key in the cache tree.
+ * @cache_subtree: Pointer to the cache tree structure.
+ * @key: Pointer to the cache key to search for.
+ * @parentp: Pointer to store the parent node of the found node.
+ * @newp: Pointer to store the location where the new node should be inserted.
+ * @delete_key_list: List to collect invalid keys for deletion.
+ *
+ * This function searches the cache tree for a specific key and returns
+ * the node that is the predecessor of the key, or first node if the key is
+ * less than all keys in the tree. If any invalid keys are found during
+ * the search, they are added to the delete_key_list for later cleanup.
+ *
+ * Returns a pointer to the previous node.
+ */
+struct rb_node *cache_subtree_search(struct cbd_cache_subtree *cache_subtree, struct cbd_cache_key *key,
+				  struct rb_node **parentp, struct rb_node ***newp,
+				  struct list_head *delete_key_list)
+{
+	struct rb_node **new, *parent = NULL;
+	struct cbd_cache_key *key_tmp;
+	struct rb_node *prev_node = NULL;
+
+	new = &(cache_subtree->root.rb_node);
+	while (*new) {
+		key_tmp = container_of(*new, struct cbd_cache_key, rb_node);
+		if (cache_key_invalid(key_tmp))
+			list_add(&key_tmp->list_node, delete_key_list);
+
+		parent = *new;
+		if (key_tmp->off >= key->off) {
+			new = &((*new)->rb_left);
+		} else {
+			prev_node = *new;
+			new = &((*new)->rb_right);
+		}
+	}
+
+	if (!prev_node)
+		prev_node = rb_first(&cache_subtree->root);
+
+	if (parentp)
+		*parentp = parent;
+
+	if (newp)
+		*newp = new;
+
+	return prev_node;
+}
+
+/**
+ * fixup_overlap_tail - Adjust the key when it overlaps at the tail.
+ * @key: Pointer to the new cache key being inserted.
+ * @key_tmp: Pointer to the existing key that overlaps.
+ * @ctx: Pointer to the context for walking the cache tree.
+ *
+ * This function modifies the existing key (key_tmp) when there is an
+ * overlap at the tail with the new key. If the modified key becomes
+ * empty, it is deleted. Returns 0 on success, or -EAGAIN if the key
+ * needs to be reinserted.
+ */
+static int fixup_overlap_tail(struct cbd_cache_key *key,
+			       struct cbd_cache_key *key_tmp,
+			       struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	int ret;
+
+	/*
+	 *     |----------------|	key_tmp
+	 * |===========|		key
+	 */
+	cache_key_cutfront(key_tmp, cache_key_lend(key) - cache_key_lstart(key_tmp));
+	if (key_tmp->len == 0) {
+		cache_key_delete(key_tmp);
+		ret = -EAGAIN;
+
+		/*
+		 * Deleting key_tmp may change the structure of the
+		 * entire cache tree, so we need to re-search the tree
+		 * to determine the new insertion point for the key.
+		 */
+		goto out;
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * fixup_overlap_contain - Handle case where new key completely contains an existing key.
+ * @key: Pointer to the new cache key being inserted.
+ * @key_tmp: Pointer to the existing key that is being contained.
+ * @ctx: Pointer to the context for walking the cache tree.
+ *
+ * This function deletes the existing key (key_tmp) when the new key
+ * completely contains it. It returns -EAGAIN to indicate that the
+ * tree structure may have changed, necessitating a re-insertion of
+ * the new key.
+ */
+static int fixup_overlap_contain(struct cbd_cache_key *key,
+				  struct cbd_cache_key *key_tmp,
+				  struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	/*
+	 *    |----|			key_tmp
+	 * |==========|			key
+	 */
+	cache_key_delete(key_tmp);
+
+	return -EAGAIN;
+}
+
+/**
+ * fixup_overlap_contained - Handle overlap when a new key is contained in an existing key.
+ * @key: The new cache key being inserted.
+ * @key_tmp: The existing cache key that overlaps with the new key.
+ * @ctx: Context for the cache tree walk.
+ *
+ * This function adjusts the existing key if the new key is contained
+ * within it. If the existing key is empty, it indicates a placeholder key
+ * that was inserted during a miss read. This placeholder will later be
+ * updated with real data from the backend, making it no longer an empty key.
+ *
+ * If we delete key or insert a key, the structure of the entire cache tree may change,
+ * requiring a full research of the tree to find a new insertion point.
+ */
+static int fixup_overlap_contained(struct cbd_cache_key *key,
+	struct cbd_cache_key *key_tmp, struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_cache_tree *cache_tree = ctx->cache_tree;
+	int ret;
+
+	/*
+	 * |-----------|		key_tmp
+	 *   |====|			key
+	 */
+	if (cache_key_empty(key_tmp)) {
+		/* If key_tmp is empty, don't split it;
+		 * it's a placeholder key for miss reads that will be updated later.
+		 */
+		cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+		if (key_tmp->len == 0) {
+			cache_key_delete(key_tmp);
+			ret = -EAGAIN;
+			goto out;
+		}
+	} else {
+		struct cbd_cache_key *key_fixup;
+		bool need_research = false;
+
+		/* Allocate a new cache key for splitting key_tmp */
+		key_fixup = cache_key_alloc(cache_tree);
+		if (!key_fixup) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		cache_key_copy(key_fixup, key_tmp);
+
+		/* Split key_tmp based on the new key's range */
+		cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+		if (key_tmp->len == 0) {
+			cache_key_delete(key_tmp);
+			need_research = true;
+		}
+
+		/* Create a new portion for key_fixup */
+		cache_key_cutfront(key_fixup, cache_key_lend(key) - cache_key_lstart(key_tmp));
+		if (key_fixup->len == 0) {
+			cache_key_put(key_fixup);
+		} else {
+			/* Insert the new key into the cache */
+			ret = cache_key_insert(cache_tree, key_fixup, false);
+			if (ret)
+				goto out;
+			need_research = true;
+		}
+
+		if (need_research) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * fixup_overlap_head - Handle overlap when a new key overlaps with the head of an existing key.
+ * @key: The new cache key being inserted.
+ * @key_tmp: The existing cache key that overlaps with the new key.
+ * @ctx: Context for the cache tree walk.
+ *
+ * This function adjusts the existing key if the new key overlaps
+ * with the beginning of it. If the resulting key length is zero
+ * after the adjustment, the key is deleted. This indicates that
+ * the key no longer holds valid data and requires the tree to be
+ * re-researched for a new insertion point.
+ */
+static int fixup_overlap_head(struct cbd_cache_key *key,
+	struct cbd_cache_key *key_tmp, struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	/*
+	 * |--------|		key_tmp
+	 *   |==========|	key
+	 */
+	/* Adjust key_tmp by cutting back based on the new key's start */
+	cache_key_cutback(key_tmp, cache_key_lend(key_tmp) - cache_key_lstart(key));
+	if (key_tmp->len == 0) {
+		/* If the adjusted key_tmp length is zero, delete it */
+		cache_key_delete(key_tmp);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+/**
+ * cache_insert_fixup - Fix up overlaps when inserting a new key.
+ * @cache_tree: Pointer to the cache_tree structure.
+ * @key: The new cache key to insert.
+ * @prev_node: The last visited node during the search.
+ *
+ * This function initializes a walking context and calls the
+ * cache_subtree_walk function to handle potential overlaps between
+ * the new key and existing keys in the cache tree. Various
+ * fixup functions are provided to manage different overlap scenarios.
+ */
+static int cache_insert_fixup(struct cbd_cache_tree *cache_tree,
+	struct cbd_cache_key *key, struct rb_node *prev_node)
+{
+	struct cbd_cache_subtree_walk_ctx walk_ctx = { 0 };
+
+	/* Set up the context with the cache, start node, and new key */
+	walk_ctx.cache_tree = cache_tree;
+	walk_ctx.start_node = prev_node;
+	walk_ctx.key = key;
+
+	/* Assign overlap handling functions for different scenarios */
+	walk_ctx.overlap_tail = fixup_overlap_tail;
+	walk_ctx.overlap_head = fixup_overlap_head;
+	walk_ctx.overlap_contain = fixup_overlap_contain;
+	walk_ctx.overlap_contained = fixup_overlap_contained;
+
+	/* Begin walking the cache tree to fix overlaps */
+	return cache_subtree_walk(&walk_ctx);
+}
+
+/**
+ * cache_key_insert - Insert a new cache key into the cache tree.
+ * @cache_tree: Pointer to the cache_tree structure.
+ * @key: The cache key to insert.
+ * @fixup: Indicates if this is a new key being inserted.
+ *
+ * This function searches for the appropriate location to insert
+ * a new cache key into the cache tree. It handles key overlaps
+ * and ensures any invalid keys are removed before insertion.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int cache_key_insert(struct cbd_cache_tree *cache_tree, struct cbd_cache_key *key, bool fixup)
+{
+	struct rb_node **new, *parent = NULL;
+	struct cbd_cache_subtree *cache_subtree;
+	struct cbd_cache_key *key_tmp = NULL, *key_next;
+	struct rb_node *prev_node = NULL;
+	LIST_HEAD(delete_key_list);
+	int ret;
+
+	cache_subtree = get_subtree(cache_tree, key->off);
+	key->cache_subtree = cache_subtree;
+search:
+	prev_node = cache_subtree_search(cache_subtree, key, &parent, &new, &delete_key_list);
+	if (!list_empty(&delete_key_list)) {
+		/* Remove invalid keys from the delete list */
+		list_for_each_entry_safe(key_tmp, key_next, &delete_key_list, list_node) {
+			list_del_init(&key_tmp->list_node);
+			cache_key_delete(key_tmp);
+		}
+		goto search;
+	}
+
+	if (fixup) {
+		ret = cache_insert_fixup(cache_tree, key, prev_node);
+		if (ret == -EAGAIN)
+			goto search;
+		if (ret)
+			goto out;
+	}
+
+	/* Link and insert the new key into the red-black tree */
+	rb_link_node(&key->rb_node, parent, new);
+	rb_insert_color(&key->rb_node, &cache_subtree->root);
+
+	return 0;
+out:
+	return ret;
+}
+
+/**
+ * clean_fn - Cleanup function to remove invalid keys from the cache tree.
+ * @work: Pointer to the work_struct associated with the cleanup.
+ *
+ * This function cleans up invalid keys from the cache tree in the background
+ * after a cache segment has been invalidated during cache garbage collection.
+ * It processes a maximum of CBD_CLEAN_KEYS_MAX keys per iteration and holds
+ * the tree lock to ensure thread safety.
+ */
+void clean_fn(struct work_struct *work)
+{
+	struct cbd_cache *cache = container_of(work, struct cbd_cache, clean_work);
+	struct cbd_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct cbd_cache_key *key;
+	int i, count;
+
+	for (i = 0; i < cache->req_key_tree.n_subtrees; i++) {
+		cache_subtree = &cache->req_key_tree.subtrees[i];
+
+again:
+		if (cache->state == CBD_CACHE_STATE_STOPPING)
+			return;
+
+		/* Delete up to CBD_CLEAN_KEYS_MAX keys in one iteration */
+		count = 0;
+		spin_lock(&cache_subtree->tree_lock);
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+			if (cache_key_invalid(key)) {
+				count++;
+				cache_key_delete(key);
+			}
+
+			if (count >= CBD_CLEAN_KEYS_MAX) {
+				/* Unlock and pause before continuing cleanup */
+				spin_unlock(&cache_subtree->tree_lock);
+				usleep_range(1000, 2000);
+				goto again;
+			}
+		}
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+}
+
+/*
+ * kset_flush_fn - Flush work for a cache kset.
+ *
+ * This function is called when a kset flush work is queued from
+ * cache_key_append(). If the kset is full, it will be closed
+ * immediately. If not, the flush work will be queued for later closure.
+ *
+ * If cache_kset_close detects that a new segment is required to store
+ * the kset and there are no available segments, it will return an error.
+ * In this scenario, a retry will be attempted.
+ */
+void kset_flush_fn(struct work_struct *work)
+{
+	struct cbd_cache_kset *kset = container_of(work, struct cbd_cache_kset, flush_work.work);
+	struct cbd_cache *cache = kset->cache;
+	int ret;
+
+	spin_lock(&kset->kset_lock);
+	ret = cache_kset_close(cache, kset);
+	spin_unlock(&kset->kset_lock);
+
+	if (ret) {
+		/* Failed to flush kset, schedule a retry. */
+		queue_delayed_work(cache->cache_wq, &kset->flush_work, 0);
+	}
+}
+
+static int kset_replay(struct cbd_cache *cache, struct cbd_cache_kset_onmedia *kset_onmedia)
+{
+	struct cbd_cache_key_onmedia *key_onmedia;
+	struct cbd_cache_key *key;
+	int ret;
+	int i;
+
+	for (i = 0; i < kset_onmedia->key_num; i++) {
+		key_onmedia = &kset_onmedia->data[i];
+
+		key = cache_key_alloc(&cache->req_key_tree);
+		if (!key) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		ret = cache_key_decode(cache, key_onmedia, key);
+		if (ret) {
+			cache_key_put(key);
+			goto err;
+		}
+
+		/* Mark the segment as used in the segment map. */
+		set_bit(key->cache_pos.cache_seg->cache_seg_id, cache->seg_map);
+
+		/* Check if the segment generation is valid for insertion. */
+		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
+			cache_key_put(key);
+		} else {
+			ret = cache_key_insert(&cache->req_key_tree, key, true);
+			if (ret) {
+				cache_key_put(key);
+				goto err;
+			}
+		}
+
+		cache_seg_get(key->cache_pos.cache_seg);
+	}
+
+	return 0;
+err:
+	return ret;
+}
+
+int cache_replay(struct cbd_cache *cache)
+{
+	struct cbd_cache_pos pos_tail;
+	struct cbd_cache_pos *pos;
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+	int ret = 0;
+	void *addr;
+
+	cache_pos_copy(&pos_tail, &cache->key_tail);
+	pos = &pos_tail;
+
+	/* Mark the segment as used in the segment map. */
+	set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
+
+	while (true) {
+		addr = cache_pos_addr(pos);
+
+		kset_onmedia = (struct cbd_cache_kset_onmedia *)addr;
+		if (kset_onmedia->magic != CBD_KSET_MAGIC ||
+				kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+			break;
+		}
+
+		if (kset_onmedia->crc != cache_kset_crc(kset_onmedia))
+			break;
+
+		/* Process the last kset and prepare for the next segment. */
+		if (kset_onmedia->flags & CBD_KSET_FLAGS_LAST) {
+			struct cbd_cache_segment *next_seg;
+
+			cbd_cache_debug(cache, "last kset replay, next: %u\n", kset_onmedia->next_cache_seg_id);
+
+			next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
+
+			pos->cache_seg = next_seg;
+			pos->seg_off = 0;
+
+			set_bit(pos->cache_seg->cache_seg_id, cache->seg_map);
+			continue;
+		}
+
+		/* Replay the kset and check for errors. */
+		ret = kset_replay(cache, kset_onmedia);
+		if (ret)
+			goto out;
+
+		/* Advance the position after processing the kset. */
+		cache_pos_advance(pos, get_kset_onmedia_size(kset_onmedia));
+	}
+
+	queue_work(cache->cache_wq, &cache->used_segs_update_work);
+
+	/* Update the key_head position after replaying. */
+	spin_lock(&cache->key_head_lock);
+	cache_pos_copy(&cache->key_head, pos);
+	spin_unlock(&cache->key_head_lock);
+
+out:
+	return ret;
+}
+
+int cache_tree_init(struct cbd_cache *cache, struct cbd_cache_tree *cache_tree, u32 n_subtrees)
+{
+	int ret;
+	u32 i;
+
+	cache_tree->cache = cache;
+	cache_tree->n_subtrees = n_subtrees;
+
+	cache_tree->key_cache = KMEM_CACHE(cbd_cache_key, 0);
+	if (!cache_tree->key_cache) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	/*
+	 * Allocate and initialize the subtrees array.
+	 * Each element is a cache tree structure that contains
+	 * an RB tree root and a spinlock for protecting its contents.
+	 */
+	cache_tree->subtrees = kvcalloc(cache_tree->n_subtrees, sizeof(struct cbd_cache_subtree), GFP_KERNEL);
+	if (!cache_tree->n_subtrees) {
+		ret = -ENOMEM;
+		goto destroy_key_cache;
+	}
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		struct cbd_cache_subtree *cache_subtree = &cache_tree->subtrees[i];
+
+		cache_subtree->root = RB_ROOT;
+		spin_lock_init(&cache_subtree->tree_lock);
+	}
+
+	return 0;
+
+destroy_key_cache:
+	kmem_cache_destroy(cache_tree->key_cache);
+err:
+	return ret;
+}
+
+void cache_tree_exit(struct cbd_cache_tree *cache_tree)
+{
+	struct cbd_cache_subtree *cache_subtree;
+	struct rb_node *node;
+	struct cbd_cache_key *key;
+	u32 i;
+
+	for (i = 0; i < cache_tree->n_subtrees; i++) {
+		cache_subtree = &cache_tree->subtrees[i];
+
+		spin_lock(&cache_subtree->tree_lock);
+		node = rb_first(&cache_subtree->root);
+		while (node) {
+			key = CACHE_KEY(node);
+			node = rb_next(node);
+
+			cache_key_delete(key);
+		}
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+	kvfree(cache_tree->subtrees);
+	kmem_cache_destroy(cache_tree->key_cache);
+}
diff --git a/drivers/block/cbd/cbd_cache/cbd_cache_req.c b/drivers/block/cbd/cbd_cache/cbd_cache_req.c
new file mode 100644
index 000000000000..24ce8679c231
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache_req.c
@@ -0,0 +1,921 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cbd_cache_internal.h"
+#include "../cbd_queue.h"
+
+static int cache_data_head_init(struct cbd_cache *cache, u32 head_index)
+{
+	struct cbd_cache_segment *next_seg;
+	struct cbd_cache_data_head *data_head;
+
+	data_head = get_data_head(cache, head_index);
+	next_seg = get_cache_segment(cache);
+	if (!next_seg)
+		return -EBUSY;
+
+	cache_seg_get(next_seg);
+	data_head->head_pos.cache_seg = next_seg;
+	data_head->head_pos.seg_off = 0;
+
+	return 0;
+}
+
+/*
+ * cache_data_alloc - Allocate data for a cache key.
+ * @cache: Pointer to the cache structure.
+ * @key: Pointer to the cache key to allocate data for.
+ * @head_index: Index of the data head to use for allocation.
+ *
+ * This function tries to allocate space from the cache segment specified by the
+ * data head. If the remaining space in the segment is insufficient to allocate
+ * the requested length for the cache key, it will allocate whatever is available
+ * and adjust the key's length accordingly. This function does not allocate
+ * space that crosses segment boundaries.
+ */
+static int cache_data_alloc(struct cbd_cache *cache, struct cbd_cache_key *key, u32 head_index)
+{
+	struct cbd_cache_data_head *data_head;
+	struct cbd_cache_pos *head_pos;
+	struct cbd_cache_segment *cache_seg;
+	u32 seg_remain;
+	u32 allocated = 0, to_alloc;
+	int ret = 0;
+
+	data_head = get_data_head(cache, head_index);
+
+	spin_lock(&data_head->data_head_lock);
+again:
+	if (!data_head->head_pos.cache_seg) {
+		seg_remain = 0;
+	} else {
+		cache_pos_copy(&key->cache_pos, &data_head->head_pos);
+		key->seg_gen = key->cache_pos.cache_seg->gen;
+
+		head_pos = &data_head->head_pos;
+		cache_seg = head_pos->cache_seg;
+		seg_remain = cache_seg_remain(head_pos);
+		to_alloc = key->len - allocated;
+	}
+
+	if (seg_remain > to_alloc) {
+		/* If remaining space in segment is sufficient for the cache key, allocate it. */
+		cache_pos_advance(head_pos, to_alloc);
+		allocated += to_alloc;
+		cache_seg_get(cache_seg);
+	} else if (seg_remain) {
+		/* If remaining space is not enough, allocate the remaining space and adjust the cache key length. */
+		cache_pos_advance(head_pos, seg_remain);
+		key->len = seg_remain;
+
+		/* Get for key: obtain a reference to the cache segment for the key. */
+		cache_seg_get(cache_seg);
+		/* Put for head_pos->cache_seg: release the reference for the current head's segment. */
+		cache_seg_put(head_pos->cache_seg);
+		head_pos->cache_seg = NULL;
+	} else {
+		/* Initialize a new data head if no segment is available. */
+		ret = cache_data_head_init(cache, head_index);
+		if (ret)
+			goto out;
+
+		goto again;
+	}
+
+out:
+	spin_unlock(&data_head->data_head_lock);
+
+	return ret;
+}
+
+static void cache_copy_from_req_bio(struct cbd_cache *cache, struct cbd_cache_key *key,
+				struct cbd_request *cbd_req, u32 bio_off)
+{
+	struct cbd_cache_pos *pos = &key->cache_pos;
+	struct cbd_segment *segment;
+
+	segment = &pos->cache_seg->segment;
+
+	cbds_copy_from_bio(segment, pos->seg_off, key->len, cbd_req->bio, bio_off);
+}
+
+static int cache_copy_to_req_bio(struct cbd_cache *cache, struct cbd_request *cbd_req,
+			    u32 bio_off, u32 len, struct cbd_cache_pos *pos, u64 key_gen)
+{
+	struct cbd_cache_segment *cache_seg = pos->cache_seg;
+	struct cbd_segment *segment = &cache_seg->segment;
+	int ret;
+
+	spin_lock(&cache_seg->gen_lock);
+	if (key_gen < cache_seg->gen) {
+		spin_unlock(&cache_seg->gen_lock);
+		return -EINVAL;
+	}
+
+	spin_lock(&cbd_req->lock);
+	ret = cbds_copy_to_bio(segment, pos->seg_off, len, cbd_req->bio, bio_off);
+	spin_unlock(&cbd_req->lock);
+	spin_unlock(&cache_seg->gen_lock);
+
+	return ret;
+}
+
+static void cache_copy_from_req_channel(struct cbd_cache *cache, struct cbd_request *cbd_req,
+				struct cbd_cache_pos *pos, u32 off, u32 len)
+{
+	struct cbd_seg_pos dst_pos, src_pos;
+
+	src_pos.segment = &cbd_req->cbdq->channel.segment;
+	src_pos.off = cbd_req->data_off;
+
+	dst_pos.segment = &pos->cache_seg->segment;
+	dst_pos.off = pos->seg_off;
+
+	if (off) {
+		cbds_pos_advance(&dst_pos, off);
+		cbds_pos_advance(&src_pos, off);
+	}
+
+	cbds_copy_data(&dst_pos, &src_pos, len);
+}
+
+/**
+ * miss_read_end_req - Handle the end of a miss read request.
+ * @cache: Pointer to the cache structure.
+ * @cbd_req: Pointer to the request structure.
+ *
+ * This function is called when a backing request to read data from
+ * the backend is completed. If the key associated with the request
+ * is empty (a placeholder), it allocates cache space for the key,
+ * copies the data read from the backend into the cache, and updates
+ * the key's status. If the key has been overwritten by a write
+ * request during this process, it will be deleted from the cache
+ * tree and no further action will be taken.
+ */
+static void miss_read_end_req(struct cbd_cache *cache, struct cbd_request *cbd_req)
+{
+	void *priv_data = cbd_req->priv_data;
+	int ret;
+
+	if (priv_data) {
+		struct cbd_cache_key *key;
+		struct cbd_cache_subtree *cache_subtree;
+
+		key = (struct cbd_cache_key *)priv_data;
+		cache_subtree = key->cache_subtree;
+
+		/* if this key was deleted from cache_subtree by a write, key->flags should be cleared,
+		 * so if cache_key_empty() return true, this key is still in cache_subtree
+		 */
+		spin_lock(&cache_subtree->tree_lock);
+		if (cache_key_empty(key)) {
+			/* Check if the backing request was successful. */
+			if (cbd_req->ret) {
+				cache_key_delete(key);
+				goto unlock;
+			}
+
+			/* Allocate cache space for the key and copy data from the backend. */
+			ret = cache_data_alloc(cache, key, cbd_req->cbdq->index);
+			if (ret) {
+				cache_key_delete(key);
+				goto unlock;
+			}
+			cache_copy_from_req_channel(cache, cbd_req, &key->cache_pos,
+						    key->off - cbd_req->off, key->len);
+			key->flags &= ~CBD_CACHE_KEY_FLAGS_EMPTY;
+			key->flags |= CBD_CACHE_KEY_FLAGS_CLEAN;
+
+			/* Append the key to the cache. */
+			ret = cache_key_append(cache, key);
+			if (ret) {
+				cache_seg_put(key->cache_pos.cache_seg);
+				cache_key_delete(key);
+				goto unlock;
+			}
+		}
+unlock:
+		spin_unlock(&cache_subtree->tree_lock);
+		cache_key_put(key);
+	}
+
+	cbd_queue_advance(cbd_req->cbdq, cbd_req);
+	kmem_cache_free(cache->req_cache, cbd_req);
+}
+
+/**
+ * miss_read_end_work_fn - Work function to handle the completion of cache miss reads
+ * @work: Pointer to the work_struct associated with miss read handling
+ *
+ * This function processes requests that were placed on the miss read list
+ * (`cache->miss_read_reqs`) to wait for data retrieval from the backend storage.
+ * Once the data has been retrieved, the requests are handled to complete the
+ * read operation.
+ *
+ * The function transfers the pending miss read requests to a temporary list to
+ * process them without holding the spinlock, improving concurrency. It then
+ * iterates over each request, removing it from the list and calling
+ * `miss_read_end_req()` to finalize the read operation.
+ */
+void miss_read_end_work_fn(struct work_struct *work)
+{
+	struct cbd_cache *cache = container_of(work, struct cbd_cache, miss_read_end_work);
+	struct cbd_request *cbd_req;
+	LIST_HEAD(tmp_list);
+
+	/* Lock and transfer miss read requests to temporary list */
+	spin_lock(&cache->miss_read_reqs_lock);
+	list_splice_init(&cache->miss_read_reqs, &tmp_list);
+	spin_unlock(&cache->miss_read_reqs_lock);
+
+	/* Process each request in the temporary list */
+	while (!list_empty(&tmp_list)) {
+		cbd_req = list_first_entry(&tmp_list,
+					    struct cbd_request, inflight_reqs_node);
+		list_del_init(&cbd_req->inflight_reqs_node);
+		miss_read_end_req(cache, cbd_req);
+	}
+}
+
+/**
+ * cache_backing_req_end_req - Handle the end of a cache miss read request
+ * @cbd_req: The cache request that has completed
+ * @priv_data: Private data associated with the request (unused in this function)
+ *
+ * This function is called when a cache miss read request completes. The request
+ * is added to the `miss_read_reqs` list, which stores pending miss read requests
+ * to be processed later by `miss_read_end_work_fn`.
+ *
+ * After adding the request to the list, the function triggers the `miss_read_end_work`
+ * workqueue to process the completed requests.
+ */
+static void cache_backing_req_end_req(struct cbd_request *cbd_req, void *priv_data)
+{
+	struct cbd_cache *cache = cbd_req->cbdq->cbd_blkdev->cbd_cache;
+
+	/* Lock the miss read requests list and add the completed request */
+	spin_lock(&cache->miss_read_reqs_lock);
+	list_add_tail(&cbd_req->inflight_reqs_node, &cache->miss_read_reqs);
+	spin_unlock(&cache->miss_read_reqs_lock);
+
+	/* Queue work to process the miss read requests */
+	queue_work(cache->cache_wq, &cache->miss_read_end_work);
+}
+
+/**
+ * submit_backing_req - Submit a backend request when cache data is missing
+ * @cache: The cache context that manages cache operations
+ * @cbd_req: The cache request containing information about the read request
+ *
+ * This function is used to handle cases where a cache read request cannot locate
+ * the required data in the cache. When such a miss occurs during `cache_subtree_walk`,
+ * it triggers a backend read request to fetch data from the storage backend.
+ *
+ * If `cbd_req->priv_data` is set, it points to a `cbd_cache_key`, representing
+ * a new cache key to be inserted into the cache. The function calls `cache_key_insert`
+ * to attempt adding the key. On insertion failure, it releases the key reference and
+ * clears `priv_data` to avoid further processing.
+ *
+ * After handling the potential cache key insertion, the request is queued to the
+ * backend using `cbd_queue_req_to_backend`. Finally, `cbd_req_put` is called to
+ * release the request resources with the result of the backend operation.
+ */
+static void submit_backing_req(struct cbd_cache *cache, struct cbd_request *cbd_req)
+{
+	int ret;
+
+	if (cbd_req->priv_data) {
+		struct cbd_cache_key *key;
+
+		/* Attempt to insert the key into the cache if priv_data is set */
+		key = (struct cbd_cache_key *)cbd_req->priv_data;
+		ret = cache_key_insert(&cache->req_key_tree, key, true);
+		if (ret) {
+			/* Release the key if insertion fails */
+			cache_key_put(key);
+			cbd_req->priv_data = NULL;
+			goto out;
+		}
+	}
+
+	/* Queue the request to the backend for data retrieval */
+	ret = cbd_queue_req_to_backend(cbd_req);
+out:
+	/* Release the cache request resources based on backend result */
+	cbd_req_put(cbd_req, ret);
+}
+
+/**
+ * create_backing_req - Create a backend read request for a cache miss
+ * @cache: The cache structure that manages cache operations
+ * @parent: The parent request structure initiating the miss read
+ * @off: Offset in the parent request to read from
+ * @len: Length of data to read from the backend
+ * @insert_key: Determines whether to insert a placeholder empty key in the cache tree
+ *
+ * This function generates a new backend read request when a cache miss occurs. The
+ * `insert_key` parameter controls whether a placeholder (empty) cache key should be
+ * added to the cache tree to prevent multiple backend requests for the same missing
+ * data. Generally, when the miss read occurs in a cache segment that doesn't contain
+ * the requested data, a placeholder key is created and inserted.
+ *
+ * However, if the cache tree already has an empty key at the location for this
+ * read, there is no need to create another. Instead, this function just send the
+ * new request without adding a duplicate placeholder.
+ *
+ * Returns:
+ * A pointer to the newly created request structure on success, or NULL on failure.
+ * If an empty key is created, it will be released if any errors occur during the
+ * process to ensure proper cleanup.
+ */
+static struct cbd_request *create_backing_req(struct cbd_cache *cache, struct cbd_request *parent,
+					u32 off, u32 len, bool insert_key)
+{
+	struct cbd_request *new_req;
+	struct cbd_cache_key *key = NULL;
+	int ret;
+
+	/* Allocate a new empty key if insert_key is set */
+	if (insert_key) {
+		key = cache_key_alloc(&cache->req_key_tree);
+		if (!key) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		/* Initialize the empty key with offset, length, and empty flag */
+		key->off = parent->off + off;
+		key->len = len;
+		key->flags |= CBD_CACHE_KEY_FLAGS_EMPTY;
+	}
+
+	/* Allocate memory for the new backend request */
+	new_req = kmem_cache_zalloc(cache->req_cache, GFP_NOWAIT);
+	if (!new_req) {
+		ret = -ENOMEM;
+		goto delete_key;
+	}
+
+	/* Initialize the request structure */
+	INIT_LIST_HEAD(&new_req->inflight_reqs_node);
+	kref_init(&new_req->ref);
+	spin_lock_init(&new_req->lock);
+
+	new_req->cbdq = parent->cbdq;
+	new_req->bio = parent->bio;
+	new_req->off = parent->off + off;
+	new_req->op = parent->op;
+	new_req->bio_off = off;
+	new_req->data_len = len;
+	new_req->req = NULL;
+
+	/* Reference the parent request */
+	cbd_req_get(parent);
+	new_req->parent = parent;
+
+	/* Attach the empty key to the request if it was created */
+	if (key) {
+		cache_key_get(key);
+		new_req->priv_data = key;
+	}
+	new_req->end_req = cache_backing_req_end_req;
+
+	return new_req;
+
+delete_key:
+	if (key)
+		cache_key_delete(key);
+out:
+	return NULL;
+}
+
+static int send_backing_req(struct cbd_cache *cache, struct cbd_request *cbd_req,
+			    u32 off, u32 len, bool insert_key)
+{
+	struct cbd_request *new_req;
+
+	new_req = create_backing_req(cache, cbd_req, off, len, insert_key);
+	if (!new_req)
+		return -ENOMEM;
+
+	submit_backing_req(cache, new_req);
+
+	return 0;
+}
+
+/*
+ * In the process of walking the cache tree to locate cached data, this
+ * function handles the situation where the requested data range lies
+ * entirely before an existing cache node (`key_tmp`). This outcome
+ * signifies that the target data is absent from the cache (cache miss).
+ *
+ * To fulfill this portion of the read request, the function creates a
+ * backend request (`backing_req`) for the missing data range represented
+ * by `key`. It then appends this request to the submission list in the
+ * `ctx`, which will later be processed to retrieve the data from backend
+ * storage. After setting up the backend request, `req_done` in `ctx` is
+ * updated to reflect the length of the handled range, and the range
+ * in `key` is adjusted by trimming off the portion that is now handled.
+ *
+ * The scenario handled here:
+ *
+ *	  |--------|			  key_tmp (existing cached range)
+ * |====|					   key (requested range, preceding key_tmp)
+ *
+ * Since `key` is before `key_tmp`, it signifies that the requested data
+ * range is missing in the cache (cache miss) and needs retrieval from
+ * backend storage.
+ */
+static int read_before(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+		struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_request *backing_req;
+	int ret;
+
+	/*
+	 * In this scenario, `key` represents a range that precedes `key_tmp`,
+	 * meaning the requested data range is missing from the cache tree
+	 * and must be retrieved from the backend.
+	 */
+	backing_req = create_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, key->len, true);
+	if (!backing_req) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	list_add(&backing_req->inflight_reqs_node, ctx->submit_req_list);
+	ctx->req_done += key->len;
+	cache_key_cutfront(key, key->len);
+
+	return 0;
+out:
+	return ret;
+}
+
+/*
+ * During cache_subtree_walk, this function manages a scenario where part of the
+ * requested data range overlaps with an existing cache node (`key_tmp`).
+ *
+ *	 |----------------|  key_tmp (existing cached range)
+ * |===========|		   key (requested range, overlapping the tail of key_tmp)
+ */
+static int read_overlap_tail(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+		struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_request *backing_req;
+	u32 io_len;
+	int ret;
+
+	/*
+	 * Calculate the length of the non-overlapping portion of `key`
+	 * before `key_tmp`, representing the data missing in the cache.
+	 */
+	io_len = cache_key_lstart(key_tmp) - cache_key_lstart(key);
+	if (io_len) {
+		backing_req = create_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, io_len, true);
+		if (!backing_req) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		list_add(&backing_req->inflight_reqs_node, ctx->submit_req_list);
+		ctx->req_done += io_len;
+		cache_key_cutfront(key, io_len);
+	}
+
+	/*
+	 * Handle the overlapping portion by calculating the length of
+	 * the remaining data in `key` that coincides with `key_tmp`.
+	 */
+	io_len = cache_key_lend(key) - cache_key_lstart(key_tmp);
+	if (cache_key_empty(key_tmp)) {
+		ret = send_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, io_len, false);
+		if (ret)
+			goto out;
+	} else {
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done,
+					io_len, &key_tmp->cache_pos, key_tmp->seg_gen);
+		if (ret) {
+			list_add(&key_tmp->list_node, ctx->delete_key_list);
+			goto out;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return 0;
+
+out:
+	return ret;
+}
+
+/**
+ * The scenario handled here:
+ *
+ *    |----|          key_tmp (existing cached range)
+ * |==========|       key (requested range)
+ */
+static int read_overlap_contain(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+		struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_request *backing_req;
+	u32 io_len;
+	int ret;
+
+	/*
+	 * Calculate the non-overlapping part of `key` before `key_tmp`
+	 * to identify the missing data length.
+	 */
+	io_len = cache_key_lstart(key_tmp) - cache_key_lstart(key);
+	if (io_len) {
+		backing_req = create_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, io_len, true);
+		if (!backing_req) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		list_add(&backing_req->inflight_reqs_node, ctx->submit_req_list);
+
+		ctx->req_done += io_len;
+		cache_key_cutfront(key, io_len);
+	}
+
+	/*
+	 * Handle the overlapping portion between `key` and `key_tmp`.
+	 */
+	io_len = key_tmp->len;
+	if (cache_key_empty(key_tmp)) {
+		ret = send_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, io_len, false);
+		if (ret)
+			goto out;
+	} else {
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done,
+					io_len, &key_tmp->cache_pos, key_tmp->seg_gen);
+		if (ret) {
+			list_add(&key_tmp->list_node, ctx->delete_key_list);
+			goto out;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return 0;
+out:
+	return ret;
+}
+
+/*
+ *	 |-----------|		key_tmp (existing cached range)
+ *	   |====|			key (requested range, fully within key_tmp)
+ *
+ * If `key_tmp` contains valid cached data, this function copies the relevant
+ * portion to the request's bio. Otherwise, it sends a backend request to
+ * fetch the required data range.
+ */
+static int read_overlap_contained(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+		struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_cache_pos pos;
+	int ret;
+
+	/*
+	 * Check if `key_tmp` is empty, indicating a miss. If so, initiate
+	 * a backend request to fetch the required data for `key`.
+	 */
+	if (cache_key_empty(key_tmp)) {
+		ret = send_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, key->len, false);
+		if (ret)
+			goto out;
+	} else {
+		cache_pos_copy(&pos, &key_tmp->cache_pos);
+		cache_pos_advance(&pos, cache_key_lstart(key) - cache_key_lstart(key_tmp));
+
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done,
+					key->len, &pos, key_tmp->seg_gen);
+		if (ret) {
+			list_add(&key_tmp->list_node, ctx->delete_key_list);
+			goto out;
+		}
+	}
+
+	ctx->req_done += key->len;
+	cache_key_cutfront(key, key->len);
+
+	return 0;
+out:
+	return ret;
+}
+
+/*
+ *	 |--------|		  key_tmp (existing cached range)
+ *	   |==========|	  key (requested range, overlapping the head of key_tmp)
+ */
+static int read_overlap_head(struct cbd_cache_key *key, struct cbd_cache_key *key_tmp,
+		struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_cache_pos pos;
+	u32 io_len;
+	int ret;
+
+	io_len = cache_key_lend(key_tmp) - cache_key_lstart(key);
+
+	if (cache_key_empty(key_tmp)) {
+		ret = send_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, io_len, false);
+		if (ret)
+			goto out;
+	} else {
+		cache_pos_copy(&pos, &key_tmp->cache_pos);
+		cache_pos_advance(&pos, cache_key_lstart(key) - cache_key_lstart(key_tmp));
+
+		ret = cache_copy_to_req_bio(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done,
+					io_len, &pos, key_tmp->seg_gen);
+		if (ret) {
+			list_add(&key_tmp->list_node, ctx->delete_key_list);
+			goto out;
+		}
+	}
+
+	ctx->req_done += io_len;
+	cache_key_cutfront(key, io_len);
+
+	return 0;
+out:
+	return ret;
+}
+
+/*
+ * read_walk_finally - Finalizes the cache read tree walk by submitting any
+ *					 remaining backend requests
+ * @ctx:	   Context structure holding information about the cache,
+ *			 read request, and submission list
+ *
+ * This function is called at the end of the `cache_subtree_walk` during a
+ * cache read operation. It completes the walk by checking if any data
+ * requested by `key` was not found in the cache tree, and if so, it sends
+ * a backend request to retrieve that data. Then, it iterates through the
+ * submission list of backend requests created during the walk, removing
+ * each request from the list and submitting it.
+ *
+ * The scenario managed here includes:
+ * - Sending a backend request for the remaining length of `key` if it was
+ *   not fulfilled by existing cache entries.
+ * - Iterating through `ctx->submit_req_list` to submit each backend request
+ *   enqueued during the walk.
+ *
+ * This ensures all necessary backend requests for cache misses are submitted
+ * to the backend storage to retrieve any data that could not be found in
+ * the cache.
+ */
+static int read_walk_finally(struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	struct cbd_request *backing_req, *next_req;
+	struct cbd_cache_key *key = ctx->key;
+	int ret;
+
+	if (key->len) {
+		ret = send_backing_req(ctx->cache_tree->cache, ctx->cbd_req, ctx->req_done, key->len, true);
+		if (ret)
+			goto out;
+		ctx->req_done += key->len;
+	}
+
+	list_for_each_entry_safe(backing_req, next_req, ctx->submit_req_list, inflight_reqs_node) {
+		list_del_init(&backing_req->inflight_reqs_node);
+		submit_backing_req(ctx->cache_tree->cache, backing_req);
+	}
+
+	return 0;
+
+out:
+	return ret;
+}
+
+/*
+ * This function is used within `cache_subtree_walk` to determine whether the
+ * read operation has covered the requested data length. It compares the
+ * amount of data processed (`ctx->req_done`) with the total data length
+ * specified in the original request (`ctx->cbd_req->data_len`).
+ *
+ * If `req_done` meets or exceeds the required data length, the function
+ * returns `true`, indicating the walk is complete. Otherwise, it returns `false`,
+ * signaling that additional data processing is needed to fulfill the request.
+ */
+static bool read_walk_done(struct cbd_cache_subtree_walk_ctx *ctx)
+{
+	return (ctx->req_done >= ctx->cbd_req->data_len);
+}
+
+/*
+ * cache_read - Process a read request by traversing the cache tree
+ * @cache:	 Cache structure holding cache trees and related configurations
+ * @cbd_req:   Request structure with information about the data to read
+ *
+ * This function attempts to fulfill a read request by traversing the cache tree(s)
+ * to locate cached data for the requested range. If parts of the data are missing
+ * in the cache, backend requests are generated to retrieve the required segments.
+ *
+ * The function operates by initializing a key for the requested data range and
+ * preparing a context (`walk_ctx`) to manage the cache tree traversal. The context
+ * includes pointers to functions (e.g., `read_before`, `read_overlap_tail`) that handle
+ * specific conditions encountered during the traversal. The `walk_finally` and `walk_done`
+ * functions manage the end stages of the traversal, while the `delete_key_list` and
+ * `submit_req_list` lists track any keys to be deleted or requests to be submitted.
+ *
+ * The function first calculates the requested range and checks if it fits within the
+ * current cache tree (based on the tree's size limits). It then locks the cache tree
+ * and performs a search to locate any matching keys. If there are outdated keys,
+ * these are deleted, and the search is restarted to ensure accurate data retrieval.
+ *
+ * If the requested range spans multiple cache trees, the function moves on to the
+ * next tree once the current range has been processed. This continues until the
+ * entire requested data length has been handled.
+ */
+static int cache_read(struct cbd_cache *cache, struct cbd_request *cbd_req)
+{
+	struct cbd_cache_key key_data = { .off = cbd_req->off, .len = cbd_req->data_len };
+	struct cbd_cache_subtree *cache_subtree;
+	struct cbd_cache_key *key_tmp = NULL, *key_next;
+	struct rb_node *prev_node = NULL;
+	struct cbd_cache_key *key = &key_data;
+	struct cbd_cache_subtree_walk_ctx walk_ctx = { 0 };
+	LIST_HEAD(delete_key_list);
+	LIST_HEAD(submit_req_list);
+	int ret;
+
+	walk_ctx.cache_tree = &cache->req_key_tree;
+	walk_ctx.req_done = 0;
+	walk_ctx.cbd_req = cbd_req;
+	walk_ctx.before = read_before;
+	walk_ctx.overlap_tail = read_overlap_tail;
+	walk_ctx.overlap_head = read_overlap_head;
+	walk_ctx.overlap_contain = read_overlap_contain;
+	walk_ctx.overlap_contained = read_overlap_contained;
+	walk_ctx.walk_finally = read_walk_finally;
+	walk_ctx.walk_done = read_walk_done;
+	walk_ctx.delete_key_list = &delete_key_list;
+	walk_ctx.submit_req_list = &submit_req_list;
+
+next_tree:
+	key->off = cbd_req->off + walk_ctx.req_done;
+	key->len = cbd_req->data_len - walk_ctx.req_done;
+	if (key->len > CBD_CACHE_SUBTREE_SIZE - (key->off & CBD_CACHE_SUBTREE_SIZE_MASK))
+		key->len = CBD_CACHE_SUBTREE_SIZE - (key->off & CBD_CACHE_SUBTREE_SIZE_MASK);
+
+	cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+	spin_lock(&cache_subtree->tree_lock);
+
+search:
+	prev_node = cache_subtree_search(cache_subtree, key, NULL, NULL, &delete_key_list);
+
+cleanup_tree:
+	if (!list_empty(&delete_key_list)) {
+		list_for_each_entry_safe(key_tmp, key_next, &delete_key_list, list_node) {
+			list_del_init(&key_tmp->list_node);
+			cache_key_delete(key_tmp);
+		}
+		goto search;
+	}
+
+	walk_ctx.start_node = prev_node;
+	walk_ctx.key = key;
+
+	ret = cache_subtree_walk(&walk_ctx);
+	if (ret == -EINVAL)
+		goto cleanup_tree;
+	else if (ret)
+		goto out;
+
+	spin_unlock(&cache_subtree->tree_lock);
+
+	if (walk_ctx.req_done < cbd_req->data_len)
+		goto next_tree;
+
+	return 0;
+out:
+	spin_unlock(&cache_subtree->tree_lock);
+
+	return ret;
+}
+
+static int cache_write(struct cbd_cache *cache, struct cbd_request *cbd_req)
+{
+	struct cbd_cache_subtree *cache_subtree;
+	struct cbd_cache_key *key;
+	u64 offset = cbd_req->off;
+	u32 length = cbd_req->data_len;
+	u32 io_done = 0;
+	int ret;
+
+	while (true) {
+		if (io_done >= length)
+			break;
+
+		key = cache_key_alloc(&cache->req_key_tree);
+		if (!key) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		key->off = offset + io_done;
+		key->len = length - io_done;
+		if (key->len > CBD_CACHE_SUBTREE_SIZE - (key->off & CBD_CACHE_SUBTREE_SIZE_MASK))
+			key->len = CBD_CACHE_SUBTREE_SIZE - (key->off & CBD_CACHE_SUBTREE_SIZE_MASK);
+
+		ret = cache_data_alloc(cache, key, cbd_req->cbdq->index);
+		if (ret) {
+			cache_key_put(key);
+			goto err;
+		}
+
+		if (!key->len) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_put(key);
+			continue;
+		}
+
+		cache_copy_from_req_bio(cache, key, cbd_req, io_done);
+
+		cache_subtree = get_subtree(&cache->req_key_tree, key->off);
+		spin_lock(&cache_subtree->tree_lock);
+		ret = cache_key_insert(&cache->req_key_tree, key, true);
+		if (ret) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_put(key);
+			goto unlock;
+		}
+
+		ret = cache_key_append(cache, key);
+		if (ret) {
+			cache_seg_put(key->cache_pos.cache_seg);
+			cache_key_delete(key);
+			goto unlock;
+		}
+
+		io_done += key->len;
+		spin_unlock(&cache_subtree->tree_lock);
+	}
+
+	return 0;
+unlock:
+	spin_unlock(&cache_subtree->tree_lock);
+err:
+	return ret;
+}
+
+/**
+ * cache_flush - Flush all ksets to persist any pending cache data
+ * @cache: Pointer to the cache structure
+ *
+ * This function iterates through all ksets associated with the provided `cache`
+ * and ensures that any data marked for persistence is written to media. For each
+ * kset, it acquires the kset lock, then invokes `cache_kset_close`, which handles
+ * the persistence logic for that kset.
+ *
+ * If `cache_kset_close` encounters an error, the function exits immediately with
+ * the respective error code, preventing the flush operation from proceeding to
+ * subsequent ksets.
+ */
+int cache_flush(struct cbd_cache *cache)
+{
+	struct cbd_cache_kset *kset;
+	u32 i, ret;
+
+	for (i = 0; i < cache->n_ksets; i++) {
+		kset = get_kset(cache, i);
+
+		spin_lock(&kset->kset_lock);
+		ret = cache_kset_close(cache, kset);
+		spin_unlock(&kset->kset_lock);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * cbd_cache_handle_req - Entry point for handling cache requests
+ * @cache: Pointer to the cache structure
+ * @cbd_req: Pointer to the request structure containing operation and data details
+ *
+ * This function serves as the main entry for cache operations, directing
+ * requests based on their operation type. Depending on the operation (`op`)
+ * specified in `cbd_req`, the function calls the appropriate helper function
+ * to process the request.
+ */
+int cbd_cache_handle_req(struct cbd_cache *cache, struct cbd_request *cbd_req)
+{
+	switch (cbd_req->op) {
+	case CBD_OP_FLUSH:
+		return cache_flush(cache);
+	case CBD_OP_WRITE:
+		return cache_write(cache, cbd_req);
+	case CBD_OP_READ:
+		return cache_read(cache, cbd_req);
+	default:
+		return -EIO;
+	}
+
+	return 0;
+}
diff --git a/drivers/block/cbd/cbd_cache/cbd_cache_segment.c b/drivers/block/cbd/cbd_cache/cbd_cache_segment.c
new file mode 100644
index 000000000000..48dfeac45518
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache_segment.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cbd_cache_internal.h"
+
+static void cache_seg_info_write(struct cbd_cache_segment *cache_seg)
+{
+	mutex_lock(&cache_seg->info_lock);
+	cbdt_segment_info_write(cache_seg->cache->cbdt, &cache_seg->cache_seg_info,
+				sizeof(struct cbd_cache_seg_info), cache_seg->segment.seg_id);
+	mutex_unlock(&cache_seg->info_lock);
+}
+
+static int cache_seg_info_load(struct cbd_cache_segment *cache_seg)
+{
+	struct cbd_segment_info *cache_seg_info;
+	int ret = 0;
+
+	mutex_lock(&cache_seg->info_lock);
+	cache_seg_info = cbdt_segment_info_read(cache_seg->cache->cbdt,
+						cache_seg->segment.seg_id);
+	if (!cache_seg_info) {
+		cbd_cache_err(cache_seg->cache, "can't read segment info of segment: %u\n",
+			      cache_seg->segment.seg_id);
+		ret = -EIO;
+		goto out;
+	}
+	memcpy(&cache_seg->cache_seg_info, cache_seg_info, sizeof(struct cbd_cache_seg_info));
+out:
+	mutex_unlock(&cache_seg->info_lock);
+	return ret;
+}
+
+static void cache_seg_ctrl_load(struct cbd_cache_segment *cache_seg)
+{
+	struct cbd_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+	struct cbd_cache_seg_gen *cache_seg_gen;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen = cbd_meta_find_latest(&cache_seg_ctrl->gen->header,
+					     sizeof(struct cbd_cache_seg_gen));
+	if (!cache_seg_gen) {
+		cache_seg->gen = 0;
+		goto out;
+	}
+
+	cache_seg->gen = cache_seg_gen->gen;
+out:
+	mutex_unlock(&cache_seg->ctrl_lock);
+}
+
+static void cache_seg_ctrl_write(struct cbd_cache_segment *cache_seg)
+{
+	struct cbd_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+	struct cbd_cache_seg_gen *cache_seg_gen;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen = cbd_meta_find_oldest(&cache_seg_ctrl->gen->header,
+					     sizeof(struct cbd_cache_seg_gen));
+	BUG_ON(!cache_seg_gen);
+	cache_seg_gen->gen = cache_seg->gen;
+	cache_seg_gen->header.seq = cbd_meta_get_next_seq(&cache_seg_ctrl->gen->header,
+							  sizeof(struct cbd_cache_seg_gen));
+	cache_seg_gen->header.crc = cbd_meta_crc(&cache_seg_gen->header,
+						 sizeof(struct cbd_cache_seg_gen));
+	mutex_unlock(&cache_seg->ctrl_lock);
+
+	cbdt_flush(cache_seg->cache->cbdt, cache_seg_gen, sizeof(struct cbd_cache_seg_gen));
+}
+
+static int cache_seg_meta_load(struct cbd_cache_segment *cache_seg)
+{
+	int ret;
+
+	ret = cache_seg_info_load(cache_seg);
+	if (ret)
+		goto err;
+
+	cache_seg_ctrl_load(cache_seg);
+
+	return 0;
+err:
+	return ret;
+}
+
+/**
+ * cache_seg_set_next_seg - Sets the ID of the next segment
+ * @cache_seg: Pointer to the cache segment structure.
+ * @seg_id: The segment ID to set as the next segment.
+ *
+ * A cbd_cache allocates multiple cache segments, which are linked together
+ * through next_seg. When loading a cbd_cache, the first cache segment can
+ * be found using cache->seg_id, which allows access to all the cache segments.
+ */
+void cache_seg_set_next_seg(struct cbd_cache_segment *cache_seg, u32 seg_id)
+{
+	cache_seg->cache_seg_info.segment_info.flags |= CBD_SEG_INFO_FLAGS_HAS_NEXT;
+	cache_seg->cache_seg_info.segment_info.next_seg = seg_id;
+	cache_seg_info_write(cache_seg);
+}
+
+static void cbd_cache_seg_sanitize_pos(struct cbd_seg_pos *pos)
+{
+	BUG_ON(pos->off > pos->segment->data_size);
+}
+
+static struct cbd_seg_ops cbd_cache_seg_ops = {
+	.sanitize_pos = cbd_cache_seg_sanitize_pos
+};
+
+int cache_seg_init(struct cbd_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache)
+{
+	struct cbd_transport *cbdt = cache->cbdt;
+	struct cbd_cache_segment *cache_seg = &cache->segments[cache_seg_id];
+	struct cbds_init_options seg_options = { 0 };
+	struct cbd_segment *segment = &cache_seg->segment;
+	int ret;
+
+	cache_seg->cache = cache;
+	cache_seg->cache_seg_id = cache_seg_id;
+	spin_lock_init(&cache_seg->gen_lock);
+	atomic_set(&cache_seg->refs, 0);
+	mutex_init(&cache_seg->info_lock);
+	mutex_init(&cache_seg->ctrl_lock);
+
+	/* init cbd_segment */
+	seg_options.type = CBDS_TYPE_CACHE;
+	seg_options.data_off = CBDT_CACHE_SEG_CTRL_OFF + CBDT_CACHE_SEG_CTRL_SIZE;
+	seg_options.seg_ops = &cbd_cache_seg_ops;
+	seg_options.seg_id = seg_id;
+	cbd_segment_init(cbdt, segment, &seg_options);
+
+	cache_seg->cache_seg_ctrl = cbd_segment_addr(segment) + CBDT_CACHE_SEG_CTRL_OFF;
+	/* init cache->cache_ctrl */
+	if (cache_seg_is_ctrl_seg(cache_seg_id))
+		cache->cache_ctrl = (struct cbd_cache_ctrl *)cache_seg->cache_seg_ctrl;
+
+	if (new_cache) {
+		cache_seg->cache_seg_info.segment_info.type = CBDS_TYPE_CACHE;
+		cache_seg->cache_seg_info.segment_info.state = CBD_SEGMENT_STATE_RUNNING;
+		cache_seg->cache_seg_info.segment_info.flags = 0;
+		cache_seg->cache_seg_info.segment_info.backend_id = cache->cache_id;
+		cache_seg_info_write(cache_seg);
+
+		/* clear outdated kset in segment */
+		memcpy_flushcache(segment->data, &cbd_empty_kset, sizeof(struct cbd_cache_kset_onmedia));
+	} else {
+		ret = cache_seg_meta_load(cache_seg);
+		if (ret)
+			goto err;
+	}
+
+	atomic_set(&cache_seg->state, cbd_cache_seg_state_running);
+
+	return 0;
+err:
+	return ret;
+}
+
+/**
+ * This function clears the segment information to release resources
+ * and prepares the segment for cleanup. It should be called when
+ * the cache segment is no longer needed. This function should only
+ * be called by owner backend.
+ */
+void cache_seg_destroy(struct cbd_cache_segment *cache_seg)
+{
+	if (atomic_read(&cache_seg->state) != cbd_cache_seg_state_running)
+		return;
+
+	/* clear cache segment ctrl */
+	cbdt_zero_range(cache_seg->cache->cbdt, cache_seg->cache_seg_ctrl,
+			CBDT_CACHE_SEG_CTRL_SIZE);
+
+	/* clear cbd segment infomation */
+	cbd_segment_info_clear(&cache_seg->segment);
+}
+
+#define CBD_WAIT_NEW_CACHE_INTERVAL	100
+#define CBD_WAIT_NEW_CACHE_COUNT	100
+
+/**
+ * get_cache_segment - Retrieves a free cache segment from the cache.
+ * @cache: Pointer to the cache structure.
+ *
+ * This function attempts to find a free cache segment that can be used.
+ * It locks the segment map and checks for the next available segment ID.
+ * If no segment is available, it waits for a predefined interval and retries.
+ * If a free segment is found, it initializes it and returns a pointer to the
+ * cache segment structure. Returns NULL if no segments are available after
+ * waiting for a specified count.
+ */
+struct cbd_cache_segment *get_cache_segment(struct cbd_cache *cache)
+{
+	struct cbd_cache_segment *cache_seg;
+	u32 seg_id;
+	u32 wait_count = 0;
+
+again:
+	spin_lock(&cache->seg_map_lock);
+	seg_id = find_next_zero_bit(cache->seg_map, cache->n_segs, cache->last_cache_seg);
+	if (seg_id == cache->n_segs) {
+		spin_unlock(&cache->seg_map_lock);
+		/* reset the hint of ->last_cache_seg and retry */
+		if (cache->last_cache_seg) {
+			cache->last_cache_seg = 0;
+			goto again;
+		}
+
+		if (++wait_count >= CBD_WAIT_NEW_CACHE_COUNT)
+			return NULL;
+
+		udelay(CBD_WAIT_NEW_CACHE_INTERVAL);
+		goto again;
+	}
+
+	/*
+	 * found an available cache_seg, mark it used in seg_map
+	 * and update the search hint ->last_cache_seg
+	 */
+	set_bit(seg_id, cache->seg_map);
+	cache->last_cache_seg = seg_id;
+	spin_unlock(&cache->seg_map_lock);
+
+	cache_seg = &cache->segments[seg_id];
+	cache_seg->cache_seg_id = seg_id;
+
+	queue_work(cache->cache_wq, &cache->used_segs_update_work);
+
+	return cache_seg;
+}
+
+static void cache_seg_gen_increase(struct cbd_cache_segment *cache_seg)
+{
+	spin_lock(&cache_seg->gen_lock);
+	cache_seg->gen++;
+	spin_unlock(&cache_seg->gen_lock);
+
+	cache_seg_ctrl_write(cache_seg);
+}
+
+void cache_seg_get(struct cbd_cache_segment *cache_seg)
+{
+	atomic_inc(&cache_seg->refs);
+}
+
+static void cache_seg_invalidate(struct cbd_cache_segment *cache_seg)
+{
+	struct cbd_cache *cache;
+
+	cache = cache_seg->cache;
+	cache_seg_gen_increase(cache_seg);
+
+	spin_lock(&cache->seg_map_lock);
+	clear_bit(cache_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+
+	/* clean_work will clean the bad key in key_tree*/
+	queue_work(cache->cache_wq, &cache->clean_work);
+
+	queue_work(cache->cache_wq, &cache->used_segs_update_work);
+}
+
+void cache_seg_put(struct cbd_cache_segment *cache_seg)
+{
+	if (atomic_dec_and_test(&cache_seg->refs))
+		cache_seg_invalidate(cache_seg);
+}
diff --git a/drivers/block/cbd/cbd_cache/cbd_cache_writeback.c b/drivers/block/cbd/cbd_cache/cbd_cache_writeback.c
new file mode 100644
index 000000000000..5bc2ad493ec3
--- /dev/null
+++ b/drivers/block/cbd/cbd_cache/cbd_cache_writeback.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/bio.h>
+
+#include "cbd_cache_internal.h"
+
+static inline bool is_cache_clean(struct cbd_cache *cache)
+{
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+	struct cbd_cache_pos *pos;
+	void *addr;
+
+	pos = &cache->dirty_tail;
+	addr = cache_pos_addr(pos);
+	kset_onmedia = (struct cbd_cache_kset_onmedia *)addr;
+
+	/* Check if the magic number matches the expected value */
+	if (kset_onmedia->magic != CBD_KSET_MAGIC) {
+		cbd_cache_debug(cache, "dirty_tail: %u:%u magic: %llx, not expected: %llx\n",
+				pos->cache_seg->cache_seg_id, pos->seg_off,
+				kset_onmedia->magic, CBD_KSET_MAGIC);
+		return true;
+	}
+
+	/* Verify the CRC checksum for data integrity */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		cbd_cache_debug(cache, "dirty_tail: %u:%u crc: %x, not expected: %x\n",
+				pos->cache_seg->cache_seg_id, pos->seg_off,
+				cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return true;
+	}
+
+	return false;
+}
+
+void cache_writeback_exit(struct cbd_cache *cache)
+{
+	cache_flush(cache);
+
+	while (!is_cache_clean(cache))
+		schedule_timeout(HZ);
+
+	cancel_delayed_work_sync(&cache->writeback_work);
+
+	bioset_exit(cache->bioset);
+	kfree(cache->bioset);
+}
+
+int cache_writeback_init(struct cbd_cache *cache)
+{
+	int ret;
+
+	cache->bioset = kzalloc(sizeof(*cache->bioset), GFP_KERNEL);
+	if (!cache->bioset) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = bioset_init(cache->bioset, 256, 0, BIOSET_NEED_BVECS);
+	if (ret) {
+		kfree(cache->bioset);
+		cache->bioset = NULL;
+		goto err;
+	}
+
+	/* Queue delayed work to start writeback handling */
+	queue_delayed_work(cache->cache_wq, &cache->writeback_work, 0);
+
+	return 0;
+
+err:
+	return ret;
+}
+
+static int cache_key_writeback(struct cbd_cache *cache, struct cbd_cache_key *key)
+{
+	struct cbd_cache_pos *pos;
+	void *addr;
+	ssize_t written;
+	u32 seg_remain;
+	u64 off;
+
+	if (cache_key_clean(key))
+		return 0;
+
+	pos = &key->cache_pos;
+
+	seg_remain = cache_seg_remain(pos);
+	BUG_ON(seg_remain < key->len);
+
+	addr = cache_pos_addr(pos);
+	off = key->off;
+
+	/* Perform synchronous writeback to maintain overwrite sequence.
+	 * Ensures data consistency by writing in order. For instance, if K1 writes
+	 * data to the range 0-4K and then K2 writes to the same range, K1's write
+	 * must complete before K2's.
+	 *
+	 * Note: We defer flushing data immediately after each key's writeback.
+	 * Instead, a `sync` operation is issued once the entire kset (group of keys)
+	 * has completed writeback, ensuring all data from the kset is safely persisted
+	 * to disk while reducing the overhead of frequent flushes.
+	 */
+	written = kernel_write(cache->bdev_file, addr, key->len, &off);
+	if (written != key->len)
+		return -EIO;
+
+	return 0;
+}
+
+static int cache_kset_writeback(struct cbd_cache *cache,
+		struct cbd_cache_kset_onmedia *kset_onmedia)
+{
+	struct cbd_cache_key_onmedia *key_onmedia;
+	struct cbd_cache_key *key;
+	int ret;
+	u32 i;
+
+	/* Iterate through all keys in the kset and write each back to storage */
+	for (i = 0; i < kset_onmedia->key_num; i++) {
+		struct cbd_cache_key key_tmp = { 0 };
+
+		key_onmedia = &kset_onmedia->data[i];
+
+		key = &key_tmp;
+		cache_key_init(NULL, key);
+
+		ret = cache_key_decode(cache, key_onmedia, key);
+		if (ret) {
+			cbd_cache_err(cache, "failed to decode key: %llu:%u in writeback.",
+					key->off, key->len);
+			return ret;
+		}
+
+		ret = cache_key_writeback(cache, key);
+		if (ret) {
+			cbd_cache_err(cache, "writeback error: %d\n", ret);
+			return ret;
+		}
+	}
+
+	/* Sync the entire kset's data to disk to ensure durability */
+	vfs_fsync(cache->bdev_file, 1);
+
+	return 0;
+}
+
+static void last_kset_writeback(struct cbd_cache *cache,
+		struct cbd_cache_kset_onmedia *last_kset_onmedia)
+{
+	struct cbd_cache_segment *next_seg;
+
+	cbd_cache_debug(cache, "last kset, next: %u\n", last_kset_onmedia->next_cache_seg_id);
+
+	next_seg = &cache->segments[last_kset_onmedia->next_cache_seg_id];
+
+	cache->dirty_tail.cache_seg = next_seg;
+	cache->dirty_tail.seg_off = 0;
+	cache_encode_dirty_tail(cache);
+}
+
+void cache_writeback_fn(struct work_struct *work)
+{
+	struct cbd_cache *cache = container_of(work, struct cbd_cache, writeback_work.work);
+	struct cbd_cache_kset_onmedia *kset_onmedia;
+	int ret = 0;
+	void *addr;
+
+	/* Loop until all dirty data is written back and the cache is clean */
+	while (true) {
+		if (is_cache_clean(cache))
+			break;
+
+		addr = cache_pos_addr(&cache->dirty_tail);
+		kset_onmedia = (struct cbd_cache_kset_onmedia *)addr;
+
+		if (kset_onmedia->flags & CBD_KSET_FLAGS_LAST) {
+			last_kset_writeback(cache, kset_onmedia);
+			continue;
+		}
+
+		ret = cache_kset_writeback(cache, kset_onmedia);
+		if (ret)
+			break;
+
+		cbd_cache_debug(cache, "writeback advance: %u:%u %u\n",
+			cache->dirty_tail.cache_seg->cache_seg_id,
+			cache->dirty_tail.seg_off,
+			get_kset_onmedia_size(kset_onmedia));
+
+		cache_pos_advance(&cache->dirty_tail, get_kset_onmedia_size(kset_onmedia));
+
+		cache_encode_dirty_tail(cache);
+	}
+
+	queue_delayed_work(cache->cache_wq, &cache->writeback_work, CBD_CACHE_WRITEBACK_INTERVAL);
+}
-- 
2.34.1



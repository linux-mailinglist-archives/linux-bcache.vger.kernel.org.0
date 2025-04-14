Return-Path: <linux-bcache+bounces-867-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80713A8756F
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E490318864CF
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D8119E998;
	Mon, 14 Apr 2025 01:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZcPFSFq7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659D919DF4A
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595140; cv=none; b=KV95Qkzf9mpAD2jzYTbOwshQKrh8IVEagZEmRjce0DOnroHRJJl7vTkbKrun+EntF6m07U9Bcy1xb8b3aOiVU8Rvt2uRZj3VYnUkdC5nVdR+fsUl7WUuP4PEryQOomO9sAsmyVsY5lQ0kJhEk45ZSOrRZEkL3JuHWkKMqdxQhBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595140; c=relaxed/simple;
	bh=y0UHDy8Dco3DHk7nxSKg7QhT8wFyGmzKQe5ykLA0ai8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UfsYg29S96567YhuhWEf8SlA+zEW9YUtnz77JNu4TnZEFbv0AoZ7P3N6DPNQqWaSfLEng8AB2WXLJoOBCvyeGtV+F0cr6b1DavqPspX76U2sEWaas2t3XRFm/UvkshsutDl3Y7Q3nqHjrf0JoBhV59LpNX8n0kG+oP4nM5cKac4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZcPFSFq7; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7RxdgXiQ/ZgOyOW4Bo2AqGzU9+zrN+iL5e6Sh1i+W/A=;
	b=ZcPFSFq7qYEEjqtQKtwyVLIQivpGOZqSZueoxN1mVI8k+GWdVtQA/Wgfub9KMLio9RlEYh
	Saw+o/OCGxFOehmV2yQbrYdRQhH7TR0g14vp6Dlm8e2CTrJQOGeLhjOHhCwCCL30L5UOWv
	N/POjJszUhm/zYblptde0TFcZoLRSX0=
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
Subject: [RFC PATCH 04/11] pcache: introduce cache_segment abstraction
Date: Mon, 14 Apr 2025 01:44:58 +0000
Message-Id: <20250414014505.20477-5-dongsheng.yang@linux.dev>
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

This patch introduces the `cache_segment` module, responsible for managing
cache data and cache key segments used by the pcache system.

Each `cache_segment` is a wrapper around a physical segment on the
persistent cache device, storing cached data and metadata required to track
its state and generation. The segment metadata is persistently recorded
and loaded to support crash recovery.

At the time of backing device startup, a set of `cache_segments` is allocated
according to the cache size requirement of the device. All cache data and
cache keys will be stored within these segments.

Features:
- Segment metadata (`struct pcache_cache_seg_info`) with CRC and sequence tracking.
- Segment control (`struct pcache_cache_seg_gen`) to record generation number, which tracks invalidation.
- Support for dynamic segment linking via `next_seg`.
- Segment reference counting via `cache_seg_get()` and `cache_seg_put()`, with automatic invalidation when refcount reaches zero.
- Metadata flush and reload via `cache_seg_info_write()` and `cache_seg_info_load()`.

This is a foundational piece enabling pcache to manage space efficiently and reuse segments.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/cache_segment.c | 247 +++++++++++++++++++++++++++
 1 file changed, 247 insertions(+)
 create mode 100644 drivers/block/pcache/cache_segment.c

diff --git a/drivers/block/pcache/cache_segment.c b/drivers/block/pcache/cache_segment.c
new file mode 100644
index 000000000000..f51301d75f70
--- /dev/null
+++ b/drivers/block/pcache/cache_segment.c
@@ -0,0 +1,247 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cache_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+
+static void cache_seg_info_write(struct pcache_cache_segment *cache_seg)
+{
+	mutex_lock(&cache_seg->info_lock);
+	pcache_segment_info_write(cache_seg->cache->backing_dev->cache_dev,
+			&cache_seg->cache_seg_info.segment_info,
+			cache_seg->segment.seg_info->seg_id);
+	mutex_unlock(&cache_seg->info_lock);
+}
+
+static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_segment_info *cache_seg_info;
+	int ret = 0;
+
+	mutex_lock(&cache_seg->info_lock);
+	cache_seg_info = pcache_segment_info_read(cache_seg->cache->backing_dev->cache_dev,
+						cache_seg->segment.seg_info->seg_id);
+	if (!cache_seg_info) {
+		pr_err("can't read segment info of segment: %u\n",
+			      cache_seg->segment.seg_info->seg_id);
+		ret = -EIO;
+		goto out;
+	}
+	memcpy(&cache_seg->cache_seg_info, cache_seg_info, sizeof(struct pcache_cache_seg_info));
+out:
+	mutex_unlock(&cache_seg->info_lock);
+	return ret;
+}
+
+static void cache_seg_ctrl_load(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+	struct pcache_cache_seg_gen *cache_seg_gen;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen = pcache_meta_find_latest(&cache_seg_ctrl->gen->header,
+					     sizeof(struct pcache_cache_seg_gen));
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
+static void cache_seg_ctrl_write(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache_seg_ctrl *cache_seg_ctrl = cache_seg->cache_seg_ctrl;
+	struct pcache_cache_seg_gen *cache_seg_gen;
+
+	mutex_lock(&cache_seg->ctrl_lock);
+	cache_seg_gen = pcache_meta_find_oldest(&cache_seg_ctrl->gen->header,
+					     sizeof(struct pcache_cache_seg_gen));
+	BUG_ON(!cache_seg_gen);
+	cache_seg_gen->gen = cache_seg->gen;
+	cache_seg_gen->header.seq = pcache_meta_get_next_seq(&cache_seg_ctrl->gen->header,
+							  sizeof(struct pcache_cache_seg_gen));
+	cache_seg_gen->header.crc = pcache_meta_crc(&cache_seg_gen->header,
+						 sizeof(struct pcache_cache_seg_gen));
+	mutex_unlock(&cache_seg->ctrl_lock);
+
+	cache_dev_flush(cache_seg->cache->backing_dev->cache_dev, cache_seg_gen, sizeof(struct pcache_cache_seg_gen));
+}
+
+static int cache_seg_meta_load(struct pcache_cache_segment *cache_seg)
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
+ * A pcache_cache allocates multiple cache segments, which are linked together
+ * through next_seg. When loading a pcache_cache, the first cache segment can
+ * be found using cache->seg_id, which allows access to all the cache segments.
+ */
+void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id)
+{
+	cache_seg->cache_seg_info.segment_info.flags |= PCACHE_SEG_INFO_FLAGS_HAS_NEXT;
+	cache_seg->cache_seg_info.segment_info.next_seg = seg_id;
+	cache_seg_info_write(cache_seg);
+}
+
+int cache_seg_init(struct pcache_cache *cache, u32 seg_id, u32 cache_seg_id,
+		   bool new_cache)
+{
+	struct pcache_cache_dev *cache_dev = cache->backing_dev->cache_dev;
+	struct pcache_cache_segment *cache_seg = &cache->segments[cache_seg_id];
+	struct pcache_segment_init_options seg_options = { 0 };
+	struct pcache_segment *segment = &cache_seg->segment;
+	int ret;
+
+	cache_seg->cache = cache;
+	cache_seg->cache_seg_id = cache_seg_id;
+	spin_lock_init(&cache_seg->gen_lock);
+	atomic_set(&cache_seg->refs, 0);
+	mutex_init(&cache_seg->info_lock);
+	mutex_init(&cache_seg->ctrl_lock);
+
+	/* init pcache_segment */
+	seg_options.type = PCACHE_SEGMENT_TYPE_DATA;
+	seg_options.data_off = PCACHE_CACHE_SEG_CTRL_OFF + PCACHE_CACHE_SEG_CTRL_SIZE;
+	seg_options.seg_id = seg_id;
+	seg_options.seg_info = &cache_seg->cache_seg_info.segment_info;
+	pcache_segment_init(cache_dev, segment, &seg_options);
+
+	cache_seg->cache_seg_ctrl = CACHE_DEV_SEGMENT(cache_dev, seg_id) + PCACHE_CACHE_SEG_CTRL_OFF;
+	/* init cache->cache_ctrl */
+	if (cache_seg_is_ctrl_seg(cache_seg_id))
+		cache->cache_ctrl = (struct pcache_cache_ctrl *)cache_seg->cache_seg_ctrl;
+
+	if (new_cache) {
+		cache_seg->cache_seg_info.segment_info.type = PCACHE_SEGMENT_TYPE_DATA;
+		cache_seg->cache_seg_info.segment_info.state = PCACHE_SEGMENT_STATE_RUNNING;
+		cache_seg->cache_seg_info.segment_info.flags = 0;
+		cache_seg_info_write(cache_seg);
+
+		/* clear outdated kset in segment */
+		memcpy_flushcache(segment->data, &pcache_empty_kset, sizeof(struct pcache_cache_kset_onmedia));
+	} else {
+		ret = cache_seg_meta_load(cache_seg);
+		if (ret)
+			goto err;
+	}
+
+	atomic_set(&cache_seg->state, pcache_cache_seg_state_running);
+
+	return 0;
+err:
+	return ret;
+}
+
+void cache_seg_destroy(struct pcache_cache_segment *cache_seg)
+{
+	/* clear cache segment ctrl */
+	cache_dev_zero_range(cache_seg->cache->backing_dev->cache_dev, cache_seg->cache_seg_ctrl,
+			PCACHE_CACHE_SEG_CTRL_SIZE);
+
+	clear_bit(cache_seg->segment.seg_info->seg_id, cache_seg->cache->backing_dev->cache_dev->seg_bitmap);
+}
+
+#define PCACHE_WAIT_NEW_CACHE_INTERVAL	100
+#define PCACHE_WAIT_NEW_CACHE_COUNT	100
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
+struct pcache_cache_segment *get_cache_segment(struct pcache_cache *cache)
+{
+	struct pcache_cache_segment *cache_seg;
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
+		if (++wait_count >= PCACHE_WAIT_NEW_CACHE_COUNT)
+			return NULL;
+
+		udelay(PCACHE_WAIT_NEW_CACHE_INTERVAL);
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
+	return cache_seg;
+}
+
+static void cache_seg_gen_increase(struct pcache_cache_segment *cache_seg)
+{
+	spin_lock(&cache_seg->gen_lock);
+	cache_seg->gen++;
+	spin_unlock(&cache_seg->gen_lock);
+
+	cache_seg_ctrl_write(cache_seg);
+}
+
+void cache_seg_get(struct pcache_cache_segment *cache_seg)
+{
+	atomic_inc(&cache_seg->refs);
+}
+
+static void cache_seg_invalidate(struct pcache_cache_segment *cache_seg)
+{
+	struct pcache_cache *cache;
+
+	cache = cache_seg->cache;
+	cache_seg_gen_increase(cache_seg);
+
+	spin_lock(&cache->seg_map_lock);
+	clear_bit(cache_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+
+	/* clean_work will clean the bad key in key_tree*/
+	queue_work(cache->backing_dev->task_wq, &cache->clean_work);
+}
+
+void cache_seg_put(struct pcache_cache_segment *cache_seg)
+{
+	if (atomic_dec_and_test(&cache_seg->refs))
+		cache_seg_invalidate(cache_seg);
+}
-- 
2.34.1



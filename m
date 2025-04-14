Return-Path: <linux-bcache+bounces-869-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F8AA87578
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2DF116F885
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361AC1A3146;
	Mon, 14 Apr 2025 01:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H7W+W61v"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EBC1A2544
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595149; cv=none; b=Dxdil6mkwGsf/OABFrdkxuVmRvmJ93uWR36gUhQT5W1HgBa5EkCmwYLrR+YZ9sFJPWUGLlDH71Pbmia1ACq3J2pspmlKLxhKKXAm0rJ8IeJCe5qt6iRSTNrtlInLYpSO39T3GbkhIX28hSGa+McA2LP9oh8EtcuD9f1N0YL+8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595149; c=relaxed/simple;
	bh=fJZb+T7ydJBmQg2edPbLgj8WD+nr9Nq9XAEx/4GGILk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GWT1xcr87eZiU/bp2ZA613lc8gJ8DrYQXUdW1aco1s5glZVbsy4YWqXGPzrZ4ffxbfxapGwQFwuqHioTsiS9LfKQr2iBZUpndskgowbpn+Fzv+Q8K+b0rHFSBDFcDK8GvjeZUnUTD4lVAAUC1yPbjVoix++WvcEXU9YGmIQIxiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H7W+W61v; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEGvUEgO4KAwZ8jolAEZFp5P76r6dGDynUlkFVVzuhw=;
	b=H7W+W61vBdQ/L4c9vHM0CtgaeOXdiy+6PvClLmJgjL4I0PsJIz93Ph1BtFWaxCGGfE8ZQE
	nxtSGHa63DPdewVzBtrdl35EX4zyFdsmXH1Op5njLnt6nAai0w5w0GI813jvuCLfup++yK
	TIXbBDWreYP0KCbLc5SFdGAQWC34CwI=
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
Subject: [RFC PATCH 06/11] pcache: gc and writeback
Date: Mon, 14 Apr 2025 01:45:00 +0000
Message-Id: <20250414014505.20477-7-dongsheng.yang@linux.dev>
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

This patch adds support for writeback and garbage collection (GC) to manage
cache segment lifecycle and ensure long-term data integrity in the PCACHE
system.

The writeback logic traverses cached data (in the form of ksets) from
`dirty_tail`, writing back valid keys to the backing device.
This is done in FIFO order and ensures that data is synchronously flushed
to persistent storage before being marked clean. After all dirty keys in
a kset are written back, the segment is considered clean and can be reclaimed.

The garbage collection mechanism monitors cache usage and, once the percentage
of used segments exceeds the configured `gc_percent` threshold, begins reclaiming
cache segments from `key_tail` forward. Only fully clean segments are eligible
for reuse.

Because writeback and GC operate in FIFO order, this model guarantees that,
even if the cache device fails unexpectedly, the data on the backing device
remains crash-consistent.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/cache_gc.c        | 150 ++++++++++++++++++++
 drivers/block/pcache/cache_writeback.c | 183 +++++++++++++++++++++++++
 2 files changed, 333 insertions(+)
 create mode 100644 drivers/block/pcache/cache_gc.c
 create mode 100644 drivers/block/pcache/cache_writeback.c

diff --git a/drivers/block/pcache/cache_gc.c b/drivers/block/pcache/cache_gc.c
new file mode 100644
index 000000000000..b32cc2704dfb
--- /dev/null
+++ b/drivers/block/pcache/cache_gc.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cache.h"
+#include "backing_dev.h"
+
+/**
+ * cache_key_gc - Releases the reference of a cache key segment.
+ * @cache: Pointer to the pcache_cache structure.
+ * @key: Pointer to the cache key to be garbage collected.
+ *
+ * This function decrements the reference count of the cache segment
+ * associated with the given key. If the reference count drops to zero,
+ * the segment may be invalidated and reused.
+ */
+static void cache_key_gc(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	cache_seg_put(key->cache_pos.cache_seg);
+}
+
+/**
+ * need_gc - Determines if garbage collection is needed for the cache.
+ * @cache: Pointer to the pcache_cache structure.
+ *
+ * This function checks if garbage collection is necessary based on the
+ * current state of the cache, including the position of the dirty tail,
+ * the integrity of the key segment on media, and the percentage of used
+ * segments compared to the configured threshold.
+ *
+ * Return: true if garbage collection is needed, false otherwise.
+ */
+static bool need_gc(struct pcache_cache *cache)
+{
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	void *dirty_addr, *key_addr;
+	u32 segs_used, segs_gc_threshold;
+
+	dirty_addr = cache_pos_addr(&cache->dirty_tail);
+	key_addr = cache_pos_addr(&cache->key_tail);
+	if (dirty_addr == key_addr) {
+		backing_dev_debug(cache->backing_dev, "key tail is equal to dirty tail: %u:%u\n",
+				cache->dirty_tail.cache_seg->cache_seg_id,
+				cache->dirty_tail.seg_off);
+		return false;
+	}
+
+	/* Check if kset_onmedia is corrupted */
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)key_addr;
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
+		backing_dev_debug(cache->backing_dev, "gc error: magic is not as expected. key_tail: %u:%u magic: %llx, expected: %llx\n",
+					cache->key_tail.cache_seg->cache_seg_id, cache->key_tail.seg_off,
+					kset_onmedia->magic, PCACHE_KSET_MAGIC);
+		return false;
+	}
+
+	/* Verify the CRC of the kset_onmedia */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		backing_dev_debug(cache->backing_dev, "gc error: crc is not as expected. crc: %x, expected: %x\n",
+					cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return false;
+	}
+
+	segs_used = bitmap_weight(cache->seg_map, cache->n_segs);
+	segs_gc_threshold = cache->n_segs * cache->cache_info->gc_percent / 100;
+	if (segs_used < segs_gc_threshold) {
+		backing_dev_debug(cache->backing_dev, "segs_used: %u, segs_gc_threshold: %u\n", segs_used, segs_gc_threshold);
+		return false;
+	}
+
+	return true;
+}
+
+/**
+ * last_kset_gc - Advances the garbage collection for the last kset.
+ * @cache: Pointer to the pcache_cache structure.
+ * @kset_onmedia: Pointer to the kset_onmedia structure for the last kset.
+ */
+static int last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct pcache_cache_segment *cur_seg, *next_seg;
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
+	backing_dev_debug(cache->backing_dev, "gc advance kset seg: %u\n", cur_seg->cache_seg_id);
+
+	spin_lock(&cache->seg_map_lock);
+	clear_bit(cur_seg->cache_seg_id, cache->seg_map);
+	spin_unlock(&cache->seg_map_lock);
+
+	return 0;
+}
+
+void pcache_cache_gc_fn(struct work_struct *work)
+{
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, gc_work.work);
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_key *key;
+	int ret;
+	int i;
+
+	while (true) {
+		if (!need_gc(cache))
+			break;
+
+		kset_onmedia = (struct pcache_cache_kset_onmedia *)cache_pos_addr(&cache->key_tail);
+
+		if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+			ret = last_kset_gc(cache, kset_onmedia);
+			if (ret)
+				break;
+			continue;
+		}
+
+		for (i = 0; i < kset_onmedia->key_num; i++) {
+			struct pcache_cache_key key_tmp = { 0 };
+
+			key_onmedia = &kset_onmedia->data[i];
+
+			key = &key_tmp;
+			cache_key_init(&cache->req_key_tree, key);
+
+			ret = cache_key_decode(cache, key_onmedia, key);
+			if (ret) {
+				backing_dev_err(cache->backing_dev, "failed to decode cache key in gc\n");
+				break;
+			}
+
+			cache_key_gc(cache, key);
+		}
+
+		backing_dev_debug(cache->backing_dev, "gc advance: %u:%u %u\n",
+			cache->key_tail.cache_seg->cache_seg_id,
+			cache->key_tail.seg_off,
+			get_kset_onmedia_size(kset_onmedia));
+
+		cache_pos_advance(&cache->key_tail, get_kset_onmedia_size(kset_onmedia));
+		cache_encode_key_tail(cache);
+	}
+
+	queue_delayed_work(cache->backing_dev->task_wq, &cache->gc_work, PCACHE_CACHE_GC_INTERVAL);
+}
diff --git a/drivers/block/pcache/cache_writeback.c b/drivers/block/pcache/cache_writeback.c
new file mode 100644
index 000000000000..5738d2abe831
--- /dev/null
+++ b/drivers/block/pcache/cache_writeback.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/bio.h>
+
+#include "cache.h"
+#include "backing_dev.h"
+
+static inline bool is_cache_clean(struct pcache_cache *cache)
+{
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	struct pcache_cache_pos *pos;
+	void *addr;
+
+	pos = &cache->dirty_tail;
+	addr = cache_pos_addr(pos);
+	kset_onmedia = (struct pcache_cache_kset_onmedia *)addr;
+
+	/* Check if the magic number matches the expected value */
+	if (kset_onmedia->magic != PCACHE_KSET_MAGIC) {
+		backing_dev_debug(cache->backing_dev, "dirty_tail: %u:%u magic: %llx, not expected: %llx\n",
+				pos->cache_seg->cache_seg_id, pos->seg_off,
+				kset_onmedia->magic, PCACHE_KSET_MAGIC);
+		return true;
+	}
+
+	/* Verify the CRC checksum for data integrity */
+	if (kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+		backing_dev_debug(cache->backing_dev, "dirty_tail: %u:%u crc: %x, not expected: %x\n",
+				pos->cache_seg->cache_seg_id, pos->seg_off,
+				cache_kset_crc(kset_onmedia), kset_onmedia->crc);
+		return true;
+	}
+
+	return false;
+}
+
+void cache_writeback_exit(struct pcache_cache *cache)
+{
+	cache_flush(cache);
+
+	while (!is_cache_clean(cache))
+		schedule_timeout(HZ);
+
+	cancel_delayed_work_sync(&cache->writeback_work);
+}
+
+int cache_writeback_init(struct pcache_cache *cache)
+{
+	/* Queue delayed work to start writeback handling */
+	queue_delayed_work(cache->backing_dev->task_wq, &cache->writeback_work, 0);
+
+	return 0;
+}
+
+static int cache_key_writeback(struct pcache_cache *cache, struct pcache_cache_key *key)
+{
+	struct pcache_cache_pos *pos;
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
+static int cache_kset_writeback(struct pcache_cache *cache,
+		struct pcache_cache_kset_onmedia *kset_onmedia)
+{
+	struct pcache_cache_key_onmedia *key_onmedia;
+	struct pcache_cache_key *key;
+	u64 start = U64_MAX, end = U64_MAX;
+	int ret;
+	u32 i;
+
+	/* Iterate through all keys in the kset and write each back to storage */
+	for (i = 0; i < kset_onmedia->key_num; i++) {
+		struct pcache_cache_key key_tmp = { 0 };
+
+		key_onmedia = &kset_onmedia->data[i];
+
+		key = &key_tmp;
+		cache_key_init(NULL, key);
+
+		ret = cache_key_decode(cache, key_onmedia, key);
+		if (ret) {
+			backing_dev_err(cache->backing_dev, "failed to decode key: %llu:%u in writeback.",
+					key->off, key->len);
+			return ret;
+		}
+
+		if (start == U64_MAX || start > key->off)
+			start = key->off;
+		if (end == U64_MAX || end < key->off + key->len)
+			end = key->off + key->len;
+
+		ret = cache_key_writeback(cache, key);
+		if (ret) {
+			backing_dev_err(cache->backing_dev, "writeback error: %d\n", ret);
+			return ret;
+		}
+	}
+
+	/* Sync the entire kset's data to disk to ensure durability */
+	vfs_fsync_range(cache->bdev_file, start, end, 1);
+
+	return 0;
+}
+
+static void last_kset_writeback(struct pcache_cache *cache,
+		struct pcache_cache_kset_onmedia *last_kset_onmedia)
+{
+	struct pcache_cache_segment *next_seg;
+
+	backing_dev_debug(cache->backing_dev, "last kset, next: %u\n", last_kset_onmedia->next_cache_seg_id);
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
+	struct pcache_cache *cache = container_of(work, struct pcache_cache, writeback_work.work);
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	int ret = 0;
+	void *addr;
+
+	/* Loop until all dirty data is written back and the cache is clean */
+	while (true) {
+		if (is_cache_clean(cache))
+			break;
+
+		addr = cache_pos_addr(&cache->dirty_tail);
+		kset_onmedia = (struct pcache_cache_kset_onmedia *)addr;
+
+		if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+			last_kset_writeback(cache, kset_onmedia);
+			continue;
+		}
+
+		ret = cache_kset_writeback(cache, kset_onmedia);
+		if (ret)
+			break;
+
+		backing_dev_debug(cache->backing_dev, "writeback advance: %u:%u %u\n",
+			cache->dirty_tail.cache_seg->cache_seg_id,
+			cache->dirty_tail.seg_off,
+			get_kset_onmedia_size(kset_onmedia));
+
+		cache_pos_advance(&cache->dirty_tail, get_kset_onmedia_size(kset_onmedia));
+
+		cache_encode_dirty_tail(cache);
+	}
+
+	queue_delayed_work(cache->backing_dev->task_wq, &cache->writeback_work, PCACHE_CACHE_WRITEBACK_INTERVAL);
+}
-- 
2.34.1



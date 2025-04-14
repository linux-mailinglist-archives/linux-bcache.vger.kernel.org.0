Return-Path: <linux-bcache+bounces-864-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A065A87562
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97EB2188DFE9
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F6019048A;
	Mon, 14 Apr 2025 01:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SVVzovFh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E4B18DB17;
	Mon, 14 Apr 2025 01:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595131; cv=none; b=oKiKNQGRpxgEWPsitr2f+BwVljdPYDC1ML3kostxMffVFDMmmPQ2JQ9vH3UeJiGoaArWfK5Z7DyIm4hIPoxLO09e5akwEhJLHGVQwliw/1WVqLNK8kM3ShA/QtH/DAaDWjcZ8yXwsbEOjCtl6DihOCZD8vReP2ulGDVw/ICf0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595131; c=relaxed/simple;
	bh=0JwQesxzmbdE1v2Isi0vz7bFbHUnKWRof5qvxOw8zjg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WQa2T0t6VeOuqVaA2+IazHF/NwK7WRHVsEdl/Qef3rgVOM1Zo9chp9titS0emTR3QE/6MQHXAFuqvNkKiRnqGGyNMQdslxZGYEy8GG75yMryD7L5q427v8YCRvojO2n0g0E118/DVSo+v7hfwSJDqVaynGFpDQU1tFxCGi+irSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SVVzovFh; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sOsI9HfatRd+cdPnfJ9cixNnzCD8PmfIQMnUMgVK2hU=;
	b=SVVzovFhCD9esIB2o2xvJjiGZpsbw+y+Due/aEY8SXsBaQgupVLvwqd9f5IcFzBqksIySx
	I8zKqwb5XMKP6voxs/oz4nASG7C05GqS3K9G+D+kx0H1iAlje+BIMZJAeqNEGeWoHvuX/L
	fwcZU88Oag7wPVH1U9iuzIFG99r9870=
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
Subject: [RFC PATCH 02/11] pcache: introduce segment abstraction
Date: Mon, 14 Apr 2025 01:44:56 +0000
Message-Id: <20250414014505.20477-3-dongsheng.yang@linux.dev>
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

pcache: introduce segment abstraction and metadata support

This patch introduces the basic infrastructure for managing segments
in the pcache system. A "segment" is the minimum unit of allocation
and persistence on the persistent memory used as cache.

Key features introduced:

- `struct pcache_segment` and associated helpers for managing segment data.
- Metadata handling for segments via `struct pcache_segment_info`, including
  type, state, data offset, and next-segment pointer.
- Support for reading and writing segment metadata with on-media consistency
  using `pcache_meta_find_latest()` and `pcache_meta_find_oldest()` helpers.
- Abstractions for copying data to and from segments and bio vectors, including:
  - `segment_copy_to_bio()`
  - `segment_copy_from_bio()`
- Logical cursor `segment_pos_advance()` for iterating over data inside a segment.

Segment metadata is stored inline in each segment and versioned with CRC to ensure
integrity and crash safety. The segment design also lays the foundation for
segment chaining via `next_seg`, which will be used in cache_segment and other higher
level structures.

This patch is part of the core segment layer and will be utilized by metadata
and data layers such as meta_segment and cache_segment in subsequent patches.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/segment.c | 175 +++++++++++++++++++++++++++++++++
 drivers/block/pcache/segment.h |  78 +++++++++++++++
 2 files changed, 253 insertions(+)
 create mode 100644 drivers/block/pcache/segment.c
 create mode 100644 drivers/block/pcache/segment.h

diff --git a/drivers/block/pcache/segment.c b/drivers/block/pcache/segment.c
new file mode 100644
index 000000000000..01e43c9d9bfa
--- /dev/null
+++ b/drivers/block/pcache/segment.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/dax.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+#include "meta_segment.h"
+#include "segment.h"
+
+int segment_pos_advance(struct pcache_segment_pos *seg_pos, u32 len)
+{
+	u32 to_advance;
+
+	while (len) {
+		to_advance = len;
+
+		if (to_advance > seg_pos->segment->data_size - seg_pos->off)
+			to_advance = seg_pos->segment->data_size - seg_pos->off;
+
+		seg_pos->off += to_advance;
+
+		len -= to_advance;
+	}
+
+	return 0;
+}
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	void *dst;
+	u32 to_copy, page_off = 0;
+	struct pcache_segment_pos pos = { .segment = segment,
+				   .off = data_off };
+next:
+	bio_for_each_segment(bv, bio, iter) {
+		if (bio_off > bv.bv_len) {
+			bio_off -= bv.bv_len;
+			continue;
+		}
+		page_off = bv.bv_offset;
+		page_off += bio_off;
+		bio_off = 0;
+
+		dst = kmap_local_page(bv.bv_page);
+again:
+		segment = pos.segment;
+
+		to_copy = min(bv.bv_offset + bv.bv_len - page_off,
+				segment->data_size - pos.off);
+		if (to_copy > data_len)
+			to_copy = data_len;
+
+		flush_dcache_page(bv.bv_page);
+		memcpy(dst + page_off, segment->data + pos.off, to_copy);
+
+		/* advance */
+		pos.off += to_copy;
+		page_off += to_copy;
+		data_len -= to_copy;
+		if (!data_len) {
+			kunmap_local(dst);
+			return 0;
+		}
+
+		/* more data in this bv page */
+		if (page_off < bv.bv_offset + bv.bv_len)
+			goto again;
+		kunmap_local(dst);
+	}
+
+	if (bio->bi_next) {
+		bio = bio->bi_next;
+		goto next;
+	}
+
+	return 0;
+}
+
+void segment_copy_from_bio(struct pcache_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	void *src;
+	u32 to_copy, page_off = 0;
+	struct pcache_segment_pos pos = { .segment = segment,
+				   .off = data_off };
+next:
+	bio_for_each_segment(bv, bio, iter) {
+		if (bio_off > bv.bv_len) {
+			bio_off -= bv.bv_len;
+			continue;
+		}
+		page_off = bv.bv_offset;
+		page_off += bio_off;
+		bio_off = 0;
+
+		src = kmap_local_page(bv.bv_page);
+again:
+		segment = pos.segment;
+
+		to_copy = min(bv.bv_offset + bv.bv_len - page_off,
+				segment->data_size - pos.off);
+		if (to_copy > data_len)
+			to_copy = data_len;
+
+		memcpy_flushcache(segment->data + pos.off, src + page_off, to_copy);
+		flush_dcache_page(bv.bv_page);
+
+		/* advance */
+		pos.off += to_copy;
+		page_off += to_copy;
+		data_len -= to_copy;
+		if (!data_len) {
+			kunmap_local(src);
+			return;
+		}
+
+		/* more data in this bv page */
+		if (page_off < bv.bv_offset + bv.bv_len)
+			goto again;
+		kunmap_local(src);
+	}
+
+	if (bio->bi_next) {
+		bio = bio->bi_next;
+		goto next;
+	}
+}
+
+int pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options)
+{
+	segment->seg_info = options->seg_info;
+
+	segment->seg_info->type = options->type;
+	segment->seg_info->state = options->state;
+	segment->seg_info->seg_id = options->seg_id;
+	segment->seg_info->data_off = options->data_off;
+
+	segment->cache_dev = cache_dev;
+	segment->data_size = PCACHE_SEG_SIZE - options->data_off;
+	segment->data = CACHE_DEV_SEGMENT(cache_dev, options->seg_id) + options->data_off;
+
+	return 0;
+}
+
+void pcache_segment_info_write(struct pcache_cache_dev *cache_dev, struct pcache_segment_info *seg_info, u32 seg_id)
+{
+	struct pcache_segment_info *seg_info_addr;
+
+	seg_info->header.seq++;
+
+	seg_info_addr = CACHE_DEV_SEGMENT(cache_dev, seg_id);
+	seg_info_addr = pcache_meta_find_oldest(&seg_info_addr->header, PCACHE_SEG_INFO_SIZE);
+
+	memcpy(seg_info_addr, seg_info, sizeof(struct pcache_segment_info));
+
+	seg_info_addr->header.crc = pcache_meta_crc(&seg_info_addr->header, PCACHE_SEG_INFO_SIZE);
+	cache_dev_flush(cache_dev, seg_info_addr, PCACHE_SEG_INFO_SIZE);
+
+}
+
+struct pcache_segment_info *pcache_segment_info_read(struct pcache_cache_dev *cache_dev, u32 seg_id)
+{
+	struct pcache_segment_info *seg_info_addr;
+
+	seg_info_addr = CACHE_DEV_SEGMENT(cache_dev, seg_id);
+
+	return pcache_meta_find_latest(&seg_info_addr->header, PCACHE_SEG_INFO_SIZE);
+}
diff --git a/drivers/block/pcache/segment.h b/drivers/block/pcache/segment.h
new file mode 100644
index 000000000000..c41cb8d5b921
--- /dev/null
+++ b/drivers/block/pcache/segment.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_SEGMENT_H
+#define _PCACHE_SEGMENT_H
+
+#include <linux/bio.h>
+
+#include "pcache_internal.h"
+
+#define segment_err(segment, fmt, ...)					\
+	cache_dev_err(segment->cache_dev, "segment%d: " fmt,				\
+		 segment->seg_id, ##__VA_ARGS__)
+#define segment_info(segment, fmt, ...)					\
+	cache_dev_info(segment->cache_dev, "segment%d: " fmt,				\
+		 segment->seg_id, ##__VA_ARGS__)
+#define segment_debug(segment, fmt, ...)					\
+	cache_dev_debug(segment->cache_dev, "segment%d: " fmt,				\
+		 segment->seg_id, ##__VA_ARGS__)
+
+
+#define PCACHE_SEGMENT_STATE_NONE		0
+#define PCACHE_SEGMENT_STATE_RUNNING	1
+
+#define PCACHES_TYPE_NONE			0
+#define PCACHES_TYPE_META			1
+#define PCACHE_SEGMENT_TYPE_DATA			2
+
+struct pcache_segment_info {
+	struct pcache_meta_header	header;	/* Metadata header for the segment */
+	u8			type;
+	u8			state;
+	u16			flags;
+	u32			next_seg;
+	u32			seg_id;
+	u32			data_off;
+};
+
+#define PCACHE_SEG_INFO_FLAGS_HAS_NEXT	(1 << 0)
+
+static inline bool segment_info_has_next(struct pcache_segment_info *seg_info)
+{
+	return (seg_info->flags & PCACHE_SEG_INFO_FLAGS_HAS_NEXT);
+}
+
+struct pcache_segment_pos {
+	struct pcache_segment	*segment;	/* Segment associated with the position */
+	u32			off;		/* Offset within the segment */
+};
+
+struct pcache_segment_init_options {
+	u8			type;
+	u8			state;
+	u32			seg_id;
+	u32			data_off;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+struct pcache_segment {
+	struct pcache_cache_dev	*cache_dev;
+
+	void			*data;
+	u32			data_size;
+
+	struct pcache_segment_info	*seg_info;
+};
+
+int segment_copy_to_bio(struct pcache_segment *segment,
+		      u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+void segment_copy_from_bio(struct pcache_segment *segment,
+			u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+int segment_pos_advance(struct pcache_segment_pos *seg_pos, u32 len);
+int pcache_segment_init(struct pcache_cache_dev *cache_dev, struct pcache_segment *segment,
+		      struct pcache_segment_init_options *options);
+
+void pcache_segment_info_write(struct pcache_cache_dev *cache_dev, struct pcache_segment_info *seg_info, u32 seg_id);
+struct pcache_segment_info *pcache_segment_info_read(struct pcache_cache_dev *cache_dev, u32 set_id);
+
+#endif /* _PCACHE_SEGMENT_H */
-- 
2.34.1



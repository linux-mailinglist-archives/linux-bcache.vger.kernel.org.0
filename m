Return-Path: <linux-bcache+bounces-866-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90875A8756D
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:46:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B9D716F8CA
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA1419CC27;
	Mon, 14 Apr 2025 01:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cgTU36wO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D398194C86
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595136; cv=none; b=sN50LBmTpO6I+zgVdoNKvMyWNOZD8paEFDOrT0Yy9rVurcs2V7YFW9lT5FGIka3esongtRsZA7tzv69/voUaYFVHV3mrGMMnANFsV3jUA1kYi4UDnP2xoI0IQ3iMtuhH9cZEzkxj2GzbX//nNQBwdxFi5PgUTbDGEZD55yoaeiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595136; c=relaxed/simple;
	bh=Wie/ZryAVDQijPRPJjGFG3UQ8ZTUQ+zyinsBIIkhtz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YrQV1qt2apiP8l+MD2pWhzVlMC8Ud9/LTCcKds9NUN+uEJC9fA2A5RsWyCQmMGkQHSLwUitgXnWN7OKM6lGnnHHIfTlEBQRzTcwJkl7RNMzlouz0VasxkzqNabpC8Ks0rCVuh+Nm0Z4EnG/taM22L1dNP6f5DE6ct7Vu1IXrAb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cgTU36wO; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=swjkE7S92/en+HgPlkxlOjwT141VID2yftXpkwZdDX4=;
	b=cgTU36wO3Ji7RigPNjwYPhDrwAEjxCyiLC9Y8hmlxP+KKeKd273qG52OYLFfw5U7R5PVuc
	MtRfk677uRavMVo86ZS/zukyF0XXHR87MJfehB8ljup5jGeYt6QKhD6RSbI/ZQ8tMy3sUm
	ycrTZnRdNrVxWG5fVemNBARF9zMc7HY=
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
Subject: [RFC PATCH 03/11] pcache: introduce meta_segment abstraction
Date: Mon, 14 Apr 2025 01:44:57 +0000
Message-Id: <20250414014505.20477-4-dongsheng.yang@linux.dev>
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

This patch introduces the `meta_segment` abstraction to persistently store
metadata for pcache, specifically the `pcache_backing_dev_info` structure.

Each `meta_segment` wraps a data segment and organizes metadata space into
multiple entries, each replicated multiple times for reliability. Metadata
integrity is ensured using a sequence counter and CRC per metadata header.

Key highlights:
- `struct pcache_meta_segment`: Manages a segment dedicated to metadata.
- `struct pcache_meta_segment_info`: Describes the layout and size of
  metadata entries.
- `meta_seg_info_write()`: Writes updated metadata info with CRC protection.
- `meta_seg_meta()`: Computes the address of a given metadata entry.
- `pcache_meta_seg_for_each_meta`: A convenient macro to iterate over all
  metadata entries in the segment, simplifying metadata scanning and
  management logic.

Currently, only `pcache_backing_dev_info` is stored via this mechanism.

This design provides a structured, verifiable, and extensible foundation
for storing persistent metadata in the pcache framework.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/pcache/meta_segment.c | 61 +++++++++++++++++++++++++++++
 drivers/block/pcache/meta_segment.h | 46 ++++++++++++++++++++++
 2 files changed, 107 insertions(+)
 create mode 100644 drivers/block/pcache/meta_segment.c
 create mode 100644 drivers/block/pcache/meta_segment.h

diff --git a/drivers/block/pcache/meta_segment.c b/drivers/block/pcache/meta_segment.c
new file mode 100644
index 000000000000..6a6dd9ad9041
--- /dev/null
+++ b/drivers/block/pcache/meta_segment.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "cache_dev.h"
+#include "cache.h"
+#include "backing_dev.h"
+#include "meta_segment.h"
+
+static void meta_seg_info_write(struct pcache_meta_segment *meta_seg)
+{
+	struct pcache_meta_segment_info *info_addr;
+
+	mutex_lock(&meta_seg->info_lock);
+	meta_seg->meta_seg_info.seg_info.header.seq++;
+
+	info_addr = CACHE_DEV_SEGMENT(meta_seg->cache_dev, meta_seg->meta_seg_info.seg_info.seg_id);
+	info_addr = pcache_meta_find_oldest(&info_addr->seg_info.header, PCACHE_SEG_INFO_SIZE);
+
+	memcpy(info_addr, &meta_seg->meta_seg_info, sizeof(struct pcache_meta_segment_info));
+	info_addr->seg_info.header.crc = pcache_meta_crc(&info_addr->seg_info.header, PCACHE_SEG_INFO_SIZE);
+
+	cache_dev_flush(meta_seg->cache_dev, info_addr, PCACHE_SEG_INFO_SIZE);
+	mutex_unlock(&meta_seg->info_lock);
+}
+
+static void meta_seg_init(struct pcache_cache_dev *cache_dev, struct pcache_meta_segment *meta_seg, u32 seg_id, u32 meta_size)
+{
+	struct pcache_segment_init_options seg_opts = { 0 };
+
+	meta_seg->cache_dev = cache_dev;
+	mutex_init(&meta_seg->info_lock);
+
+	seg_opts.type = PCACHES_TYPE_META;
+	seg_opts.state = PCACHE_SEGMENT_STATE_RUNNING;
+	seg_opts.seg_id = seg_id;
+	seg_opts.data_off = PCACHE_SEG_INFO_SIZE * PCACHE_META_INDEX_MAX;
+	seg_opts.seg_info = &meta_seg->meta_seg_info.seg_info;
+
+	pcache_segment_init(cache_dev, &meta_seg->segment, &seg_opts);
+
+	meta_seg->meta_seg_info.meta_size = meta_size;
+	meta_seg->meta_seg_info.meta_num = meta_seg->segment.data_size / (meta_size * PCACHE_META_INDEX_MAX);
+
+	meta_seg_info_write(meta_seg);
+}
+
+struct pcache_meta_segment *pcache_meta_seg_alloc(struct pcache_cache_dev *cache_dev, u32 seg_id, u32 meta_size)
+{
+	struct pcache_meta_segment *meta_seg;
+
+	meta_seg = kzalloc(sizeof(struct pcache_meta_segment), GFP_KERNEL);
+	if (!meta_seg)
+		return NULL;
+
+	meta_seg_init(cache_dev, meta_seg, seg_id, meta_size);
+
+	return meta_seg;
+}
+
+void pcache_meta_seg_free(struct pcache_meta_segment *meta_seg)
+{
+	kfree(meta_seg);
+}
diff --git a/drivers/block/pcache/meta_segment.h b/drivers/block/pcache/meta_segment.h
new file mode 100644
index 000000000000..3e0886d0bd2b
--- /dev/null
+++ b/drivers/block/pcache/meta_segment.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _PCACHE_META_SEGMENT_H
+#define _PCACHE_META_SEGMENT_H
+
+#include <linux/bio.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "segment.h"
+
+struct pcache_cache_dev;
+struct pcache_backing_dev_info;
+
+struct pcache_meta_segment_info {
+	struct pcache_segment_info	seg_info;
+	u32 meta_size;
+	u32 meta_num;
+};
+
+struct pcache_meta_segment {
+	struct pcache_segment	segment;
+
+	struct pcache_cache_dev *cache_dev;
+
+	struct pcache_meta_segment_info meta_seg_info;
+	struct mutex info_lock;
+
+	struct pcache_meta_segment *next_meta_seg;
+};
+
+static inline void *meta_seg_meta(struct pcache_meta_segment *meta_seg, u32 meta_id)
+{
+	void *data = meta_seg->segment.data;
+
+	return (data + meta_id * meta_seg->meta_seg_info.meta_size * PCACHE_META_INDEX_MAX);
+}
+
+#define pcache_meta_seg_for_each_meta(meta_seg, i, meta)	\
+	for (i = 0;						\
+	     i < meta_seg->meta_seg_info.meta_num &&		\
+	     ((meta = meta_seg_meta(meta_seg, i)) || true);	\
+	     i++)
+
+struct pcache_meta_segment *pcache_meta_seg_alloc(struct pcache_cache_dev *cache_dev, u32 seg_id, u32 meta_size);
+void pcache_meta_seg_free(struct pcache_meta_segment *meta_seg);
+#endif /* _PCACHE_META_SEGMENT_H */
-- 
2.34.1



Return-Path: <linux-bcache+bounces-831-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A792A03C65
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504701644D8
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC721E9B33;
	Tue,  7 Jan 2025 10:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W/dQrVVe"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A101E4908
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245869; cv=none; b=Ta5spYusYvSf1bp/1Qg+/zSNxLBbK25dk6fNROjhuxlX/cIezxD2MUFrLg1zriOhCLTG/tT/16ob8Wol1fdevJb6KrnVl+h4IlsfdVslP5A+7DOdQvrUdfrsG/0vTmttp3Lx9ns/cLrxS6YVJ0Wr6rhIJNHFNhjXHcsQJDCBZkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245869; c=relaxed/simple;
	bh=BmsOyAK6sFY5bd1TMgzNx+wJVAuRK2Y62I+8s21jW74=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L6MU2ZE2TOCfFlVLhXDDRYI69s9ui9xjy8x6+1CT398MulA10DOcEyhgyDyM1/2uoVk6ljWoIZIXH8jaZCRyK4JB9yzteEcnf0p3PC+48BfTiSd6dCsQx3vp0jMPidNGykMNaNmwKBEbFwsPGmIw9NAA0bPQJd5ALwqdVFsx5mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W/dQrVVe; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUKtV0V4M4Ct0Xe87xvFiPtfAJ7Jk8lSopNav9KsJCE=;
	b=W/dQrVVeaa5UgNbBhAIGAPW0JuO5SBDHro6LAk3e+EaZOMRrfL3JQ/I4lHpfi7xy/iYCIl
	KdWR2Q/4pbCXY5Fkanbh4vhaf1bN8T2pUFO43tDNevD2iCZ3X8BCv+Pyy64KwB+oghCs7A
	K8DlA1+ZtTqBn1iDPq49KrQH5+8cmNo=
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
Subject: [PATCH v3 3/8] cbd: introduce cbd_segment
Date: Tue,  7 Jan 2025 10:30:19 +0000
Message-Id: <20250107103024.326986-4-dongsheng.yang@linux.dev>
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

The `cbd_segments` is an abstraction of the data area in transport. The
data area in transport is divided into segments.

The specific use of this area is determined by `cbd_seg_type`. For example,
`cbd_blkdev` and `cbd_backend` data transfers need to access a segment of
the type `cbds_type_channel`.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_segment.c | 311 ++++++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_segment.h | 104 +++++++++++
 2 files changed, 415 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_segment.c
 create mode 100644 drivers/block/cbd/cbd_segment.h

diff --git a/drivers/block/cbd/cbd_segment.c b/drivers/block/cbd/cbd_segment.c
new file mode 100644
index 000000000000..fc1c4701d343
--- /dev/null
+++ b/drivers/block/cbd/cbd_segment.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/dax.h>
+
+#include "cbd_internal.h"
+#include "cbd_transport.h"
+#include "cbd_segment.h"
+
+static ssize_t type_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct cbd_segment_device *segment_dev;
+	struct cbd_segment_info *segment_info;
+
+	segment_dev = container_of(dev, struct cbd_segment_device, dev);
+	segment_info = cbdt_segment_info_read(segment_dev->cbdt, segment_dev->id);
+	if (!segment_info)
+		return 0;
+
+	if (segment_info->state == CBD_SEGMENT_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%s\n", cbds_type_str(segment_info->type));
+}
+
+static DEVICE_ATTR_ADMIN_RO(type);
+
+static struct attribute *cbd_segment_attrs[] = {
+	&dev_attr_type.attr,
+	NULL
+};
+
+static struct attribute_group cbd_segment_attr_group = {
+	.attrs = cbd_segment_attrs,
+};
+
+static const struct attribute_group *cbd_segment_attr_groups[] = {
+	&cbd_segment_attr_group,
+	NULL
+};
+
+static void cbd_segment_release(struct device *dev)
+{
+}
+
+const struct device_type cbd_segment_type = {
+	.name       = "cbd_segment",
+	.groups     = cbd_segment_attr_groups,
+	.release    = cbd_segment_release,
+};
+
+const struct device_type cbd_segments_type = {
+	.name       = "cbd_segments",
+	.release    = cbd_segment_release,
+};
+
+void cbd_segment_init(struct cbd_transport *cbdt, struct cbd_segment *segment,
+		      struct cbds_init_options *options)
+{
+	segment->cbdt = cbdt;
+	segment->seg_id = options->seg_id;
+	segment->seg_ops = options->seg_ops;
+	segment->data_size = CBDT_SEG_SIZE - options->data_off;
+
+	segment->data = cbd_segment_addr(segment) + options->data_off;
+}
+
+void cbd_segment_clear(struct cbd_transport *cbdt, u32 seg_id)
+{
+	struct cbd_segment_info *segment_info;
+
+	segment_info = cbdt_get_segment_info(cbdt, seg_id);
+	cbdt_zero_range(cbdt, segment_info, CBDT_SEG_SIZE);
+}
+
+void cbd_segment_info_clear(struct cbd_segment *segment)
+{
+	cbdt_segment_info_clear(segment->cbdt, segment->seg_id);
+}
+
+void cbds_copy_data(struct cbd_seg_pos *dst_pos,
+		struct cbd_seg_pos *src_pos, u32 len)
+{
+	u32 copied = 0;
+	u32 to_copy;
+
+	while (copied < len) {
+		if (dst_pos->off >= dst_pos->segment->data_size)
+			dst_pos->segment->seg_ops->sanitize_pos(dst_pos);
+		if (src_pos->off >= src_pos->segment->data_size)
+			src_pos->segment->seg_ops->sanitize_pos(src_pos);
+
+		to_copy = len - copied;
+
+		if (to_copy > dst_pos->segment->data_size - dst_pos->off)
+			to_copy = dst_pos->segment->data_size - dst_pos->off;
+		if (to_copy > src_pos->segment->data_size - src_pos->off)
+			to_copy = src_pos->segment->data_size - src_pos->off;
+
+		memcpy_flushcache(dst_pos->segment->data + dst_pos->off, src_pos->segment->data + src_pos->off, to_copy);
+
+		copied += to_copy;
+		cbds_pos_advance(dst_pos, to_copy);
+		cbds_pos_advance(src_pos, to_copy);
+	}
+}
+
+int cbds_copy_to_bio(struct cbd_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	void *dst;
+	u32 to_copy, page_off = 0;
+	struct cbd_seg_pos pos = { .segment = segment,
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
+		if (pos.off >= pos.segment->data_size)
+			segment->seg_ops->sanitize_pos(&pos);
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
+void cbds_copy_from_bio(struct cbd_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	void *src;
+	u32 to_copy, page_off = 0;
+	struct cbd_seg_pos pos = { .segment = segment,
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
+		if (pos.off >= pos.segment->data_size)
+			segment->seg_ops->sanitize_pos(&pos);
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
+u32 cbd_seg_crc(struct cbd_segment *segment, u32 data_off, u32 data_len)
+{
+	u32 crc = 0;
+	u32 crc_size;
+	struct cbd_seg_pos pos = { .segment = segment,
+				   .off = data_off };
+
+	while (data_len) {
+		if (pos.off >= pos.segment->data_size)
+			segment->seg_ops->sanitize_pos(&pos);
+		segment = pos.segment;
+
+		crc_size = min(segment->data_size - pos.off, data_len);
+
+		crc = crc32(crc, segment->data + pos.off, crc_size);
+
+		data_len -= crc_size;
+		pos.off += crc_size;
+	}
+
+	return crc;
+}
+
+int cbds_map_pages(struct cbd_segment *segment,
+		   struct bio *bio,
+		   u32 off, u32 size)
+{
+	struct cbd_transport *cbdt = segment->cbdt;
+	u32 done = 0;
+	struct page *page;
+	u32 page_off;
+	int ret = 0;
+	int id;
+
+	id = dax_read_lock();
+	while (size) {
+		unsigned int len = min_t(size_t, PAGE_SIZE, size);
+		struct cbd_seg_pos pos = { .segment = segment,
+					   .off = off + done };
+
+		if (pos.off >= pos.segment->data_size)
+			segment->seg_ops->sanitize_pos(&pos);
+		segment = pos.segment;
+
+		u64 transport_off = segment->data -
+					(void *)cbdt->transport_info_addr + pos.off;
+
+		page = cbdt_page(cbdt, transport_off, &page_off);
+
+		ret = bio_add_page(bio, page, len, 0);
+		if (unlikely(ret != len)) {
+			cbd_segment_err(segment, "failed to add page\n");
+			goto out;
+		}
+
+		done += len;
+		size -= len;
+	}
+
+	ret = 0;
+out:
+	dax_read_unlock(id);
+	return ret;
+}
+
+int cbds_pos_advance(struct cbd_seg_pos *seg_pos, u32 len)
+{
+	u32 to_advance;
+
+	while (len) {
+		to_advance = len;
+
+		if (seg_pos->off >= seg_pos->segment->data_size)
+			seg_pos->segment->seg_ops->sanitize_pos(seg_pos);
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
+void *cbd_segment_addr(struct cbd_segment *segment)
+{
+	struct cbd_segment_info *seg_info;
+
+	seg_info = cbdt_get_segment_info(segment->cbdt, segment->seg_id);
+
+	return (void *)seg_info;
+}
diff --git a/drivers/block/cbd/cbd_segment.h b/drivers/block/cbd/cbd_segment.h
new file mode 100644
index 000000000000..99fccb8c49ba
--- /dev/null
+++ b/drivers/block/cbd/cbd_segment.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_SEGMENT_H
+#define _CBD_SEGMENT_H
+
+#include <linux/bio.h>
+
+#include "cbd_internal.h"
+
+#define cbd_segment_err(segment, fmt, ...)					\
+	cbdt_err(segment->cbdt, "segment%d: " fmt,				\
+		 segment->seg_id, ##__VA_ARGS__)
+#define cbd_segment_info(segment, fmt, ...)					\
+	cbdt_info(segment->cbdt, "segment%d: " fmt,				\
+		 segment->seg_id, ##__VA_ARGS__)
+#define cbd_segment_debug(segment, fmt, ...)					\
+	cbdt_debug(segment->cbdt, "segment%d: " fmt,				\
+		 segment->seg_id, ##__VA_ARGS__)
+
+
+CBD_DEVICE(segment);
+
+#define CBD_SEGMENT_STATE_NONE		0
+#define CBD_SEGMENT_STATE_RUNNING	1
+
+#define CBDS_TYPE_NONE			0
+#define CBDS_TYPE_CHANNEL		1
+#define CBDS_TYPE_CACHE			2
+
+static inline const char *cbds_type_str(u8 type)
+{
+	if (type == CBDS_TYPE_CHANNEL)
+		return "channel";
+	else if (type == CBDS_TYPE_CACHE)
+		return "cache";
+
+	return "Unknown";
+}
+
+struct cbd_segment_info {
+	struct cbd_meta_header	meta_header;	/* Metadata header for the segment */
+	u8			type;
+	u8			state;
+	u16			flags;
+	u32			next_seg;
+	u32			backend_id;
+};
+
+#define CBD_SEG_INFO_FLAGS_HAS_NEXT	(1 << 0)
+
+static inline bool cbd_segment_info_has_next(struct cbd_segment_info *seg_info)
+{
+	return (seg_info->flags & CBD_SEG_INFO_FLAGS_HAS_NEXT);
+}
+
+struct cbd_seg_pos {
+	struct cbd_segment	*segment;	/* Segment associated with the position */
+	u32			off;		/* Offset within the segment */
+};
+
+struct cbd_seg_ops {
+	void (*sanitize_pos)(struct cbd_seg_pos *pos);
+};
+
+struct cbds_init_options {
+	u8			type;
+	u8			state;
+	u32			seg_id;
+	u32			data_off;
+	struct cbd_seg_ops	*seg_ops;
+};
+
+struct cbd_segment {
+	struct cbd_transport	*cbdt;
+	struct cbd_seg_ops	*seg_ops;
+	u32			seg_id;
+
+	void			*data;
+	u32			data_size;
+};
+
+void cbd_segment_info_clear(struct cbd_segment *segment);
+void cbd_segment_clear(struct cbd_transport *cbdt, u32 segment_id);
+void cbd_segment_init(struct cbd_transport *cbdt, struct cbd_segment *segment,
+		      struct cbds_init_options *options);
+int cbds_copy_to_bio(struct cbd_segment *segment,
+		      u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+void cbds_copy_from_bio(struct cbd_segment *segment,
+			u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+u32 cbd_seg_crc(struct cbd_segment *segment, u32 data_off, u32 data_len);
+int cbds_map_pages(struct cbd_segment *segment,
+		   struct bio *bio,
+		   u32 off, u32 size);
+int cbds_pos_advance(struct cbd_seg_pos *seg_pos, u32 len);
+void cbds_copy_data(struct cbd_seg_pos *dst_pos,
+		    struct cbd_seg_pos *src_pos, u32 len);
+void *cbd_segment_addr(struct cbd_segment *segment);
+
+#define cbd_for_each_segment_info(cbdt, i, segment_info)			\
+	for (i = 0;								\
+	     i < cbdt->transport_info.segment_num &&				\
+	     (segment_info = cbdt_segment_info_read(cbdt, i));			\
+	     i++)
+
+#endif /* _CBD_SEGMENT_H */
-- 
2.34.1



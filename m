Return-Path: <linux-bcache+bounces-721-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E8A97BAB4
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 12:19:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 983A31C214FF
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 10:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C94F188CA3;
	Wed, 18 Sep 2024 10:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D4z8/D7i"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537EB188A20;
	Wed, 18 Sep 2024 10:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726654743; cv=none; b=cj4kPIWsNQEaBhtgKoqy3Zx/A2Vx9x3eCBaSN9+xOWadKs4uDnsEyMStruPeWh3ninmSv3qvg1So7Lzlhlewx7pdi9A9COm2WMeU1+S49ynbcnl+Ixn964IBqQJ/KGhUgJk/tyUSTvNFznTQM0+1cP4Y/+CgfVNt4KoXpVuUNGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726654743; c=relaxed/simple;
	bh=nKYBwq3DNPvYPSU91alzoWyvAqMifp7STvMO8nRDivg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f8McSJWqYX3vdwS6WzTrkYYwA8m6IgUBlFs05SCE0JREIQYci+qJbgJ11Gir5BHD+4RnEclnxRocoegT7IGR8tpBX/Nck3K7nHsYsoCg08HDVVgAKE67fv5CPV2xDz0ywZmGAqU6NVvReF/yqBRbDewoF/bETnJdDrqZsST9YlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D4z8/D7i; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726654736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X6k89tmJJFaVmsE+g86sdavkc0csK8GGCHyRyKeFHVs=;
	b=D4z8/D7ioQoY3OaTl9TGLPJY1dyeZC3HtLBPmtSXJJDIDpP/wqlTFlAKtpwurUDAdOTzRo
	hF46d+s437SBrtElxd1Dz/QdU9tvqO3Hm9dDzkgDp0k1wUMYPBRKahG6f05IgJ5RB2asBk
	qMzkSIz0o0t+zbJtwp9va2tJb1i2woM=
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
Subject: [PATCH v2 3/8] cbd: introduce cbd_segment
Date: Wed, 18 Sep 2024 10:18:16 +0000
Message-Id: <20240918101821.681118-4-dongsheng.yang@linux.dev>
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

The `cbd_segments` is an abstraction of the data area in transport. The
data area in transport is divided into segments.

The specific use of this area is determined by `cbd_seg_type`. For example,
`cbd_blkdev` and `cbd_backend` data transfers
need to access a segment of the type `cbds_type_channel`.

The segment also allows for more scenarios and more segment types to be expanded.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_segment.c | 349 ++++++++++++++++++++++++++++++++
 1 file changed, 349 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_segment.c

diff --git a/drivers/block/cbd/cbd_segment.c b/drivers/block/cbd/cbd_segment.c
new file mode 100644
index 000000000000..d7fbfee64059
--- /dev/null
+++ b/drivers/block/cbd/cbd_segment.c
@@ -0,0 +1,349 @@
+#include "cbd_internal.h"
+
+static ssize_t cbd_seg_detail_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct cbd_segment_device *segment;
+	struct cbd_segment_info *segment_info;
+
+	segment = container_of(dev, struct cbd_segment_device, dev);
+	segment_info = segment->segment_info;
+
+	if (segment_info->state == cbd_segment_state_none)
+		return 0;
+
+	if (segment_info->type == cbds_type_channel)
+		return cbd_channel_seg_detail_show((struct cbd_channel_info *)segment_info, buf);
+
+	return 0;
+}
+
+static ssize_t cbd_seg_type_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct cbd_segment_device *segment;
+	struct cbd_segment_info *segment_info;
+
+	segment = container_of(dev, struct cbd_segment_device, dev);
+	segment_info = segment->segment_info;
+
+	if (segment_info->state == cbd_segment_state_none)
+		return 0;
+
+	return sprintf(buf, "%s\n", cbds_type_str(segment_info->type));
+}
+
+static DEVICE_ATTR(detail, 0400, cbd_seg_detail_show, NULL);
+static DEVICE_ATTR(type, 0400, cbd_seg_type_show, NULL);
+
+CBD_OBJ_HEARTBEAT(segment);
+
+static struct attribute *cbd_segment_attrs[] = {
+	&dev_attr_detail.attr,
+	&dev_attr_type.attr,
+	&dev_attr_alive.attr,
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
+	.name		= "cbd_segment",
+	.groups		= cbd_segment_attr_groups,
+	.release	= cbd_segment_release,
+};
+
+const struct device_type cbd_segments_type = {
+	.name		= "cbd_segments",
+	.release	= cbd_segment_release,
+};
+
+void cbd_segment_init(struct cbd_transport *cbdt, struct cbd_segment *segment,
+		      struct cbds_init_options *options)
+{
+	struct cbd_segment_info *segment_info = cbdt_get_segment_info(cbdt, options->seg_id);
+
+	segment->cbdt = cbdt;
+	segment->segment_info = segment_info;
+	segment->seg_id = options->seg_id;
+	segment_info->type = options->type;
+	segment->seg_ops = options->seg_ops;
+	segment->data_size = CBDT_SEG_SIZE - options->data_off;
+	segment->data = (void *)(segment->segment_info) + options->data_off;
+	segment->priv_data = options->priv_data;
+
+	segment_info->ref++;
+	segment_info->state = cbd_segment_state_running;
+
+	INIT_DELAYED_WORK(&segment->hb_work, segment_hb_workfn);
+	queue_delayed_work(cbd_wq, &segment->hb_work, 0);
+}
+
+void cbd_segment_exit(struct cbd_segment *segment)
+{
+	if (!segment->segment_info ||
+			segment->segment_info->state != cbd_segment_state_running)
+		return;
+
+	cancel_delayed_work_sync(&segment->hb_work);
+
+	if (--segment->segment_info->ref > 0)
+		return;
+
+	segment->segment_info->state = cbd_segment_state_none;
+	segment->segment_info->alive_ts = 0;
+}
+
+int cbd_segment_clear(struct cbd_transport *cbdt, u32 seg_id)
+{
+	struct cbd_segment_info *segment_info;
+
+	segment_info = cbdt_get_segment_info(cbdt, seg_id);
+	if (cbd_segment_info_is_alive(segment_info)) {
+		cbdt_err(cbdt, "segment %u is still alive\n", seg_id);
+		return -EBUSY;
+	}
+
+	cbdt_zero_range(cbdt, segment_info, CBDT_SEG_SIZE);
+
+	return 0;
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
+
+		if (src_pos->off >= src_pos->segment->data_size)
+			src_pos->segment->seg_ops->sanitize_pos(src_pos);
+
+		to_copy = len - copied;
+
+		if (to_copy > dst_pos->segment->data_size - dst_pos->off)
+			to_copy = dst_pos->segment->data_size - dst_pos->off;
+
+		if (to_copy > src_pos->segment->data_size - src_pos->off)
+			to_copy = src_pos->segment->data_size - src_pos->off;
+
+		memcpy(dst_pos->segment->data + dst_pos->off, src_pos->segment->data + src_pos->off, to_copy);
+
+		copied += to_copy;
+
+		cbds_pos_advance(dst_pos, to_copy);
+		cbds_pos_advance(src_pos, to_copy);
+	}
+}
+
+void cbds_copy_to_bio(struct cbd_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	void *dst;
+	u32 to_copy, page_off = 0;
+	struct cbd_seg_pos pos = { .segment = segment,
+				   .off = data_off };
+
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
+		flush_dcache_page(bv.bv_page);
+		memcpy(dst + page_off, segment->data + pos.off, to_copy);
+
+		/* advance */
+		pos.off += to_copy;
+		page_off += to_copy;
+		data_len -= to_copy;
+		if (!data_len) {
+			kunmap_local(dst);
+			return;
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
+
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
+		memcpy(segment->data + pos.off, src + page_off, to_copy);
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
+int cbds_map_pages(struct cbd_segment *segment, struct cbd_backend_io *io)
+{
+	struct cbd_transport *cbdt = segment->cbdt;
+	struct cbd_se *se = io->se;
+	u32 off = se->data_off;
+	u32 size = se->data_len;
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
+					(void *)cbdt->transport_info + pos.off;
+
+		page = cbdt_page(cbdt, transport_off, &page_off);
+
+		ret = bio_add_page(io->bio, page, len, 0);
+		if (unlikely(ret != len)) {
+			cbdt_err(cbdt, "failed to add page");
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
-- 
2.34.1



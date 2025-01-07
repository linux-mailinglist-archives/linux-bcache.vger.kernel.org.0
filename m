Return-Path: <linux-bcache+bounces-832-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A0AA03C68
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D11BA160725
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8BF1E3DD1;
	Tue,  7 Jan 2025 10:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IwKp4OEl"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC931EB9F2
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245874; cv=none; b=XKJjpzewqRicQOpLv0aQw3y0CRp+XnOVgPb6kQNgmEji5u10PR3U0aqCJPPbfvZEI/JBAA2KibuzDvugbafbFxiIHsXunq6zgk8oegwDNp2ITr61OiOzNX3Hws25YY2zQ8jZiYLhYqYbTfGS5pxVMeqYGyuHFS7R9hf1JzfEluE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245874; c=relaxed/simple;
	bh=7Y5l9+vhKF+2aiYjqPcuXIdYIJ8Hnf3BKz352TDW7vs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t7gqLa++Cw2+z68246wMLgZOd+9fnLjNiV1k/tDZATLy8nJkSFr/raPbvsbbZ99xmcPD2EKYnkmLqaCLa9HZPuoGLS1FkHWE7mSpOKkuxFjkeVUEWRU+NjsAsxvHyixYBh/h31bE3PekzjVSJb/h6BmyECIM7YopM06aDQpacHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IwKp4OEl; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mM7FuvYInlEIqP3lpzEUKgYOss9fQ8hCrjReXMaSnMk=;
	b=IwKp4OElBUR/EcQsyLoHGXttBa2IX8NaSN2O78rmRVQxXDahHyClk20qWy5gA4kfARp220
	CHU3SJKjXdupJGv+Y7/i8ir6ZWMi3rlgaQrcZvRE6U2JScHxYAF90SmENxI8DjR57dR7+h
	OvmVqojdU9082y8sr4SNAltr8WHhYa4=
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
Subject: [PATCH v3 4/8] cbd: introduce cbd_channel
Date: Tue,  7 Jan 2025 10:30:20 +0000
Message-Id: <20250107103024.326986-5-dongsheng.yang@linux.dev>
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

The "cbd_channel" is the component responsible for the interaction
between the blkdev and the backend. It mainly provides the functions
"cbdc_copy_to_bio", "cbdc_copy_from_bio" and "cbd_channel_crc"

If the blkdev or backend is alive, that means there is active
user for this channel, then channel is alive.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_channel.c | 144 +++++++++++
 drivers/block/cbd/cbd_channel.h | 429 ++++++++++++++++++++++++++++++++
 2 files changed, 573 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_channel.c
 create mode 100644 drivers/block/cbd/cbd_channel.h

diff --git a/drivers/block/cbd/cbd_channel.c b/drivers/block/cbd/cbd_channel.c
new file mode 100644
index 000000000000..9e0221a36e65
--- /dev/null
+++ b/drivers/block/cbd/cbd_channel.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cbd_transport.h"
+#include "cbd_channel.h"
+
+int cbdc_copy_to_bio(struct cbd_channel *channel,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	return cbds_copy_to_bio(&channel->segment, data_off, data_len, bio, bio_off);
+}
+
+void cbdc_copy_from_bio(struct cbd_channel *channel,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off)
+{
+	cbds_copy_from_bio(&channel->segment, data_off, data_len, bio, bio_off);
+}
+
+u32 cbd_channel_crc(struct cbd_channel *channel, u32 data_off, u32 data_len)
+{
+	return cbd_seg_crc(&channel->segment, data_off, data_len);
+}
+
+int cbdc_map_pages(struct cbd_channel *channel, struct bio *bio, u32 off, u32 size)
+{
+	return cbds_map_pages(&channel->segment, bio, off, size);
+}
+
+void cbd_channel_reset(struct cbd_channel *channel)
+{
+	/* Reset channel data head and tail pointers */
+	channel->data_head = channel->data_tail = 0;
+
+	/* Reset submr and compr control pointers */
+	channel->ctrl->submr_tail = channel->ctrl->submr_head = 0;
+	channel->ctrl->compr_tail = channel->ctrl->compr_head = 0;
+
+	cbdt_zero_range(channel->cbdt, channel->submr, CBDC_SUBMR_SIZE);
+	cbdt_zero_range(channel->cbdt, channel->compr, CBDC_COMPR_SIZE);
+}
+
+/*
+ * cbd_channel_seg_sanitize_pos - Sanitize position within a channel segment ring
+ * @pos: Position structure within the segment to sanitize
+ *
+ * This function ensures that the offset in the segment position wraps around
+ * correctly when the channel is using a single segment in a ring structure. If
+ * the offset exceeds the data size of the segment, it wraps back to the start of
+ * the segment by reducing it by the segment's data size. This allows the channel
+ * to reuse the segment space efficiently in a circular manner, preventing overflows.
+ */
+static void cbd_channel_seg_sanitize_pos(struct cbd_seg_pos *pos)
+{
+	struct cbd_segment *segment = pos->segment;
+
+	/* Channel only uses one segment as a ring */
+	while (pos->off >= segment->data_size)
+		pos->off -= segment->data_size;
+}
+
+static struct cbd_seg_ops cbd_channel_seg_ops = {
+	.sanitize_pos = cbd_channel_seg_sanitize_pos
+};
+
+static int channel_info_load(struct cbd_channel *channel)
+{
+	struct cbd_channel_seg_info *channel_info;
+	int ret;
+
+	mutex_lock(&channel->info_lock);
+	channel_info = (struct cbd_channel_seg_info *)cbdt_segment_info_read(channel->cbdt,
+							channel->seg_id);
+	if (!channel_info) {
+		cbd_channel_err(channel, "can't read info from segment id: %u\n",
+				channel->seg_id);
+		ret = -EINVAL;
+		goto out;
+	}
+	memcpy(&channel->channel_info, channel_info, sizeof(struct cbd_channel_seg_info));
+	ret = 0;
+out:
+	mutex_unlock(&channel->info_lock);
+	return ret;
+}
+
+static void channel_info_write(struct cbd_channel *channel)
+{
+	mutex_lock(&channel->info_lock);
+	cbdt_segment_info_write(channel->cbdt, &channel->channel_info, sizeof(struct cbd_channel_seg_info),
+				channel->seg_id);
+	mutex_unlock(&channel->info_lock);
+}
+
+int cbd_channel_init(struct cbd_channel *channel, struct cbd_channel_init_options *init_opts)
+{
+	struct cbds_init_options seg_options = { 0 };
+	void *seg_addr;
+	int ret;
+
+	seg_options.seg_id = init_opts->seg_id;
+	seg_options.data_off = CBDC_DATA_OFF;
+	seg_options.seg_ops = &cbd_channel_seg_ops;
+
+	cbd_segment_init(init_opts->cbdt, &channel->segment, &seg_options);
+
+	channel->cbdt = init_opts->cbdt;
+	channel->seg_id = init_opts->seg_id;
+	channel->submr_size = rounddown(CBDC_SUBMR_SIZE, sizeof(struct cbd_se));
+	channel->compr_size = rounddown(CBDC_COMPR_SIZE, sizeof(struct cbd_ce));
+	channel->data_size = CBDC_DATA_SIZE;
+
+	seg_addr = cbd_segment_addr(&channel->segment);
+	channel->ctrl = seg_addr + CBDC_CTRL_OFF;
+	channel->submr = seg_addr + CBDC_SUBMR_OFF;
+	channel->compr = seg_addr + CBDC_COMPR_OFF;
+
+	spin_lock_init(&channel->submr_lock);
+	spin_lock_init(&channel->compr_lock);
+	mutex_init(&channel->info_lock);
+
+	if (init_opts->new_channel) {
+		/* Initialize new channel state */
+		channel->channel_info.seg_info.type = CBDS_TYPE_CHANNEL;
+		channel->channel_info.seg_info.state = CBD_SEGMENT_STATE_RUNNING;
+		channel->channel_info.seg_info.flags = 0;
+		channel->channel_info.seg_info.backend_id = init_opts->backend_id;
+
+		/* Persist new channel information */
+		channel_info_write(channel);
+	} else {
+		/* Load existing channel information for reattachment or blkdev side */
+		ret = channel_info_load(channel);
+		if (ret)
+			goto out;
+	}
+	ret = 0;
+
+out:
+	return ret;
+}
+
+void cbd_channel_destroy(struct cbd_channel *channel)
+{
+	cbdt_segment_info_clear(channel->cbdt, channel->seg_id);
+}
diff --git a/drivers/block/cbd/cbd_channel.h b/drivers/block/cbd/cbd_channel.h
new file mode 100644
index 000000000000..a206300d8fa5
--- /dev/null
+++ b/drivers/block/cbd/cbd_channel.h
@@ -0,0 +1,429 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_CHANNEL_H
+#define _CBD_CHANNEL_H
+
+#include "cbd_internal.h"
+#include "cbd_segment.h"
+#include "cbd_cache/cbd_cache.h"
+
+#define cbd_channel_err(channel, fmt, ...)					\
+	cbdt_err(channel->cbdt, "channel%d: " fmt,				\
+		 channel->seg_id, ##__VA_ARGS__)
+#define cbd_channel_info(channel, fmt, ...)					\
+	cbdt_info(channel->cbdt, "channel%d: " fmt,				\
+		 channel->seg_id, ##__VA_ARGS__)
+#define cbd_channel_debug(channel, fmt, ...)					\
+	cbdt_debug(channel->cbdt, "channel%d: " fmt,				\
+		 channel->seg_id, ##__VA_ARGS__)
+
+#define CBD_OP_WRITE		0
+#define CBD_OP_READ		1
+#define CBD_OP_FLUSH		2
+
+struct cbd_se {
+#ifdef CONFIG_CBD_CHANNEL_CRC
+	u32			se_crc;		/* should be the first member */
+#endif
+#ifdef CONFIG_CBD_CHANNEL_DATA_CRC
+	u32			data_crc;
+#endif
+	u32			op;
+	u32			flags;
+	u64			req_tid;
+
+	u64			offset;
+	u32			len;
+
+	u32			data_off;
+	u32			data_len;
+};
+
+struct cbd_ce {
+#ifdef CONFIG_CBD_CHANNEL_CRC
+	u32		ce_crc;		/* should be the first member */
+#endif
+#ifdef CONFIG_CBD_CHANNEL_DATA_CRC
+	u32		data_crc;
+#endif
+	u64		req_tid;
+	u32		result;
+	u32		flags;
+};
+
+static inline u32 cbd_se_crc(struct cbd_se *se)
+{
+	return crc32(0, (void *)se + 4, sizeof(*se) - 4);
+}
+
+static inline u32 cbd_ce_crc(struct cbd_ce *ce)
+{
+	return crc32(0, (void *)ce + 4, sizeof(*ce) - 4);
+}
+
+/* cbd channel segment metadata */
+#define CBDC_META_SIZE          (4 * 1024 * 1024)                   /* Metadata size for each CBD channel segment (4 MB) */
+#define CBDC_SUBMR_RESERVED     sizeof(struct cbd_se)               /* Reserved space for SUBMR (submission metadata region) */
+#define CBDC_COMPR_RESERVED     sizeof(struct cbd_ce)               /* Reserved space for COMPR (completion metadata region) */
+
+#define CBDC_DATA_ALIGN         4096                                /* Data alignment boundary (4 KB) */
+#define CBDC_DATA_RESERVED      CBDC_DATA_ALIGN                     /* Reserved space aligned to data boundary */
+
+#define CBDC_CTRL_OFF           (CBDT_SEG_INFO_SIZE * CBDT_META_INDEX_MAX)  /* Offset for control data */
+#define CBDC_CTRL_SIZE          PAGE_SIZE                           /* Control data size (1 page) */
+#define CBDC_COMPR_OFF          (CBDC_CTRL_OFF + CBDC_CTRL_SIZE)    /* Offset for COMPR metadata */
+#define CBDC_COMPR_SIZE         (sizeof(struct cbd_ce) * 1024)      /* Size of COMPR metadata region (1024 entries) */
+#define CBDC_SUBMR_OFF          (CBDC_COMPR_OFF + CBDC_COMPR_SIZE)  /* Offset for SUBMR metadata */
+#define CBDC_SUBMR_SIZE         (CBDC_META_SIZE - CBDC_SUBMR_OFF)   /* Size of SUBMR metadata region */
+
+#define CBDC_DATA_OFF           CBDC_META_SIZE                      /* Offset for data storage following metadata */
+#define CBDC_DATA_SIZE          (CBDT_SEG_SIZE - CBDC_META_SIZE)    /* Size of data storage in a segment */
+
+struct cbd_channel_seg_info {
+	struct cbd_segment_info seg_info;	/* must be the first member */
+};
+
+/**
+ * struct cbdc_mgmt_cmd - Management command structure for CBD channel
+ * @header:        Metadata header for data integrity protection
+ * @cmd_seq:      Command sequence number
+ * @cmd_op:       Command operation type
+ * @res:          Reserved field
+ * @res1:         Additional reserved field
+ *
+ * This structure is used for data transfer of management commands
+ * within a CBD channel. Note that a CBD channel can only handle
+ * one mgmt_cmd at a time. If there is a management plane request
+ * on the blkdev side, it will be written into channel_ctrl->mgmt_cmd.
+ * The mgmt_cmd is protected by the meta_header for data integrity
+ * and is double updated. When the handler's mgmt_worker detects
+ * a new mgmt_cmd, it processes it and writes the result into
+ * channel_ctrl->mgmt_ret, where mgmt_ret->cmd_seq equals the
+ * corresponding mgmt_cmd->cmd_seq.
+ */
+struct cbdc_mgmt_cmd {
+	struct cbd_meta_header header;
+	u8 cmd_seq;
+	u8 cmd_op;
+	u16 res;
+	u32 res1;
+};
+
+#define CBDC_MGMT_CMD_NONE	0
+#define CBDC_MGMT_CMD_RESET	1
+
+/**
+ * struct cbdc_mgmt_ret - Management command result structure for CBD channel
+ * @header:        Metadata header for data integrity protection
+ * @cmd_seq:      Command sequence number corresponding to the mgmt_cmd
+ * @cmd_ret:      Command return value
+ * @res:          Reserved field
+ * @res1:         Additional reserved field
+ *
+ * This structure contains the result after the handler processes
+ * the management command (mgmt_cmd). The result is written into
+ * channel_ctrl->mgmt_ret, where cmd_seq equals the corresponding
+ * mgmt_cmd->cmd_seq.
+ */
+struct cbdc_mgmt_ret {
+	struct cbd_meta_header header;
+	u8 cmd_seq;
+	u8 cmd_ret;
+	u16 res;
+	u32 res1;
+};
+
+#define CBDC_MGMT_CMD_RET_OK		0
+#define CBDC_MGMT_CMD_RET_EIO		1
+
+static inline int cbdc_mgmt_cmd_ret_to_errno(u8 cmd_ret)
+{
+	int ret;
+
+	switch (cmd_ret) {
+	case CBDC_MGMT_CMD_RET_OK:
+		ret = 0;
+		break;
+	case CBDC_MGMT_CMD_RET_EIO:
+		ret = -EIO;
+		break;
+	default:
+		ret = -EFAULT;
+	}
+
+	return ret;
+}
+
+struct cbd_channel_ctrl {
+	u64	flags;
+
+	/* management plane */
+	struct cbdc_mgmt_cmd	mgmt_cmd[CBDT_META_INDEX_MAX];
+	struct cbdc_mgmt_ret	mgmt_ret[CBDT_META_INDEX_MAX];
+
+	/* data plane */
+	u32	submr_head;
+	u32	submr_tail;
+
+	u32	compr_head;
+	u32	compr_tail;
+};
+
+#define CBDC_FLAGS_POLLING		(1 << 0)
+
+static inline struct cbdc_mgmt_cmd *__mgmt_latest_cmd(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbd_meta_header *meta_latest;
+
+	meta_latest = cbd_meta_find_latest(&channel_ctrl->mgmt_cmd->header,
+					   sizeof(struct cbdc_mgmt_cmd));
+	if (!meta_latest)
+		return NULL;
+
+	return (struct cbdc_mgmt_cmd *)meta_latest;
+}
+
+static inline struct cbdc_mgmt_cmd *__mgmt_oldest_cmd(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbd_meta_header *meta_oldest;
+
+	meta_oldest = cbd_meta_find_oldest(&channel_ctrl->mgmt_cmd->header,
+					   sizeof(struct cbdc_mgmt_cmd));
+
+	return (struct cbdc_mgmt_cmd *)meta_oldest;
+}
+
+static inline struct cbdc_mgmt_ret *__mgmt_latest_ret(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbd_meta_header *meta_latest;
+
+	meta_latest = cbd_meta_find_latest(&channel_ctrl->mgmt_ret->header,
+					   sizeof(struct cbdc_mgmt_ret));
+	if (!meta_latest)
+		return NULL;
+
+	return (struct cbdc_mgmt_ret *)meta_latest;
+}
+
+static inline struct cbdc_mgmt_ret *__mgmt_oldest_ret(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbd_meta_header *meta_oldest;
+
+	meta_oldest = cbd_meta_find_oldest(&channel_ctrl->mgmt_ret->header,
+					   sizeof(struct cbdc_mgmt_ret));
+
+	return (struct cbdc_mgmt_ret *)meta_oldest;
+}
+
+static inline u8 cbdc_mgmt_latest_cmd_seq(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbdc_mgmt_cmd *cmd_latest;
+
+	cmd_latest = __mgmt_latest_cmd(channel_ctrl);
+	if (!cmd_latest)
+		return 0;
+
+	return cmd_latest->cmd_seq;
+}
+
+static inline u8 cbdc_mgmt_latest_ret_seq(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbdc_mgmt_ret *ret_latest;
+
+	ret_latest = __mgmt_latest_ret(channel_ctrl);
+	if (!ret_latest)
+		return 0;
+
+	return ret_latest->cmd_seq;
+}
+
+/**
+ * cbdc_mgmt_completed - Check if the management command has been processed
+ * @channel_ctrl: Pointer to the CBD channel control structure
+ *
+ * This function is important for the management plane of the CBD channel.
+ * It indicates whether the current mgmt_cmd has been processed.
+ *
+ * (1) If processing is complete, the latest mgmt_ret can be retrieved as the
+ * result, and a new mgmt_cmd can be sent.
+ * (2) If processing is not complete, it indicates that the management plane
+ * is busy and a new mgmt_cmd cannot be sent. The CBD channel management
+ * plane can only handle one mgmt_cmd at a time.
+ *
+ * Return: true if the mgmt_cmd has been processed, false otherwise.
+ */
+static inline bool cbdc_mgmt_completed(struct cbd_channel_ctrl *channel_ctrl)
+{
+	u8 cmd_seq = cbdc_mgmt_latest_cmd_seq(channel_ctrl);
+	u8 ret_seq = cbdc_mgmt_latest_ret_seq(channel_ctrl);
+
+	return (cmd_seq == ret_seq);
+}
+
+static inline u8 cbdc_mgmt_cmd_op_get(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbdc_mgmt_cmd *cmd_latest;
+
+	cmd_latest = __mgmt_latest_cmd(channel_ctrl);
+	if (!cmd_latest)
+		return CBDC_MGMT_CMD_NONE;
+
+	return cmd_latest->cmd_op;
+}
+
+static inline int cbdc_mgmt_cmd_op_send(struct cbd_channel_ctrl *channel_ctrl, u8 op)
+{
+	struct cbdc_mgmt_cmd *cmd_oldest;
+	u8 latest_seq;
+
+	if (!cbdc_mgmt_completed(channel_ctrl))
+		return -EBUSY;
+
+	latest_seq = cbdc_mgmt_latest_cmd_seq(channel_ctrl);
+
+	cmd_oldest = __mgmt_oldest_cmd(channel_ctrl);
+	cmd_oldest->cmd_seq = (latest_seq + 1);
+	cmd_oldest->cmd_op = op;
+
+	cmd_oldest->header.seq = cbd_meta_get_next_seq(&channel_ctrl->mgmt_cmd->header,
+						       sizeof(struct cbdc_mgmt_cmd));
+	cmd_oldest->header.crc = cbd_meta_crc(&cmd_oldest->header, sizeof(struct cbdc_mgmt_cmd));
+
+	return 0;
+}
+
+static inline u8 cbdc_mgmt_cmd_ret_get(struct cbd_channel_ctrl *channel_ctrl)
+{
+	struct cbdc_mgmt_ret *ret_latest;
+
+	ret_latest = __mgmt_latest_ret(channel_ctrl);
+	if (!ret_latest)
+		return CBDC_MGMT_CMD_RET_OK;
+
+	return ret_latest->cmd_ret;
+}
+
+static inline int cbdc_mgmt_cmd_ret_send(struct cbd_channel_ctrl *channel_ctrl, u8 ret)
+{
+	struct cbdc_mgmt_ret *ret_oldest;
+	u8 latest_seq;
+
+	if (cbdc_mgmt_completed(channel_ctrl))
+		return -EINVAL;
+
+	latest_seq = cbdc_mgmt_latest_cmd_seq(channel_ctrl);
+
+	ret_oldest = __mgmt_oldest_ret(channel_ctrl);
+	ret_oldest->cmd_seq = latest_seq;
+	ret_oldest->cmd_ret = ret;
+
+	ret_oldest->header.seq = cbd_meta_get_next_seq(&channel_ctrl->mgmt_ret->header,
+						       sizeof(struct cbdc_mgmt_ret));
+	ret_oldest->header.crc = cbd_meta_crc(&ret_oldest->header, sizeof(struct cbdc_mgmt_ret));
+
+	return 0;
+}
+
+struct cbd_channel_init_options {
+	struct cbd_transport *cbdt;
+	bool	new_channel;
+
+	u32	seg_id;
+	u32	backend_id;
+};
+
+struct cbd_channel {
+	u32				seg_id;
+	struct cbd_segment		segment;
+
+	struct cbd_channel_seg_info	channel_info;
+	struct mutex			info_lock;
+
+	struct cbd_transport		*cbdt;
+
+	struct cbd_channel_ctrl		*ctrl;
+	void				*submr;
+	void				*compr;
+
+	u32				submr_size;
+	u32				compr_size;
+
+	u32				data_size;
+	u32				data_head;
+	u32				data_tail;
+
+	spinlock_t			submr_lock;
+	spinlock_t			compr_lock;
+};
+
+int cbd_channel_init(struct cbd_channel *channel, struct cbd_channel_init_options *init_opts);
+void cbd_channel_destroy(struct cbd_channel *channel);
+void cbdc_copy_from_bio(struct cbd_channel *channel,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+int cbdc_copy_to_bio(struct cbd_channel *channel,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+u32 cbd_channel_crc(struct cbd_channel *channel, u32 data_off, u32 data_len);
+int cbdc_map_pages(struct cbd_channel *channel, struct bio *bio, u32 off, u32 size);
+void cbd_channel_reset(struct cbd_channel *channel);
+
+static inline u64 cbd_channel_flags_get(struct cbd_channel_ctrl *channel_ctrl)
+{
+	/* get value written by the writter */
+	return smp_load_acquire(&channel_ctrl->flags);
+}
+
+static inline void cbd_channel_flags_set_bit(struct cbd_channel_ctrl *channel_ctrl, u64 set)
+{
+	u64 flags = cbd_channel_flags_get(channel_ctrl);
+
+	flags |= set;
+	/* order the update of flags */
+	smp_store_release(&channel_ctrl->flags, flags);
+}
+
+static inline void cbd_channel_flags_clear_bit(struct cbd_channel_ctrl *channel_ctrl, u64 clear)
+{
+	u64 flags = cbd_channel_flags_get(channel_ctrl);
+
+	flags &= ~clear;
+	/* order the update of flags */
+	smp_store_release(&channel_ctrl->flags, flags);
+}
+
+/**
+ * CBDC_CTRL_ACCESSOR - Create accessor functions for channel control members
+ * @MEMBER: The name of the member in the control structure.
+ * @SIZE: The size of the corresponding ring buffer.
+ *
+ * This macro defines two inline functions for accessing and updating the
+ * specified member of the control structure for a given channel.
+ *
+ * For submr_head, submr_tail, and compr_tail:
+ * (1) They have a unique writer on the blkdev side, while the backend
+ *     acts only as a reader.
+ *
+ * For compr_head:
+ * (2) The unique writer is on the backend side, with the blkdev acting
+ *     only as a reader.
+ */
+#define CBDC_CTRL_ACCESSOR(MEMBER, SIZE)						\
+static inline u32 cbdc_##MEMBER##_get(struct cbd_channel *channel)			\
+{											\
+	/* order the ring update */							\
+	return smp_load_acquire(&channel->ctrl->MEMBER);				\
+}											\
+											\
+static inline void cbdc_## MEMBER ##_advance(struct cbd_channel *channel, u32 len)	\
+{											\
+	u32 val = cbdc_## MEMBER ##_get(channel);					\
+											\
+	val = (val + len) % channel->SIZE;						\
+	/* order the ring update */							\
+	smp_store_release(&channel->ctrl->MEMBER, val);					\
+}
+
+CBDC_CTRL_ACCESSOR(submr_head, submr_size)
+CBDC_CTRL_ACCESSOR(submr_tail, submr_size)
+CBDC_CTRL_ACCESSOR(compr_head, compr_size)
+CBDC_CTRL_ACCESSOR(compr_tail, compr_size)
+
+#endif /* _CBD_CHANNEL_H */
-- 
2.34.1



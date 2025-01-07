Return-Path: <linux-bcache+bounces-828-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E146CA03C5D
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B8227A1C6B
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB40B1E9B12;
	Tue,  7 Jan 2025 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oLZD8Bbb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1041DFDB3
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245864; cv=none; b=nebRMTMni2zC2UprH/EZjadknmMwZM/6+6sC5EjiJO7dwXGkawVSpxpBjB09sMHqhYyLk52ISshvxC7l+lTvS/5t9hZFXcnIT/izKp+pn4t05DGJeOlzuNBDvKZklA+gG8BhjHVkFoo3DworjF2XrlULCom6lmnix6EzojLQ448=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245864; c=relaxed/simple;
	bh=trTZkLCZ2F7ZdpoF54Mu4TDYcDk1cBOg0kD7ouCebiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AE8JU9LHrH4ehYB03aOVv7o1GbqmtixILbO/XUqaJ+EuvExwaIKjE6HFT1Qxl1l7vlXoRFFILSJRh1KW04uCn6hO5+/nQ2Y0iDpAKQXSDHO9xtuNHzzLmxiFZNzfFPKXMeSypd08VpLgorgkbfrpsmKH1EMNrblje6x287pDYzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oLZD8Bbb; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQd5VLudXvBJSCZO1xI51ocFdmZt04D5l3Rao1R3i4g=;
	b=oLZD8BbbHu3VYRKEqEbxwUYstaJQ0kLSPbXhJMgBpKqGUYx98jGy3MwKiif/T/kwgCB1XO
	Yb3QFuhM+msXUgjLNsJNsymAhWj5nXoSkRRHHleSsEC8tN703PQ5+nmpaCA1wgCLaCIy5i
	LVj4LbxP/rG32tMGEI5OLbUi51tlHU8=
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
Subject: [PATCH v3 1/8] cbd: introduce cbd_transport
Date: Tue,  7 Jan 2025 10:30:17 +0000
Message-Id: <20250107103024.326986-2-dongsheng.yang@linux.dev>
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

cbd_transport represents the layout of the entire shared memory, as shown below.

	+-------------------------------------------------------------------------------------------------------------------------------+
	|                           cbd transport                                                                                       |
	+--------------------+-----------------------+-----------------------+----------------------+-----------------------------------+
	|                    |       hosts           |      backends         |       blkdevs        |        segments                   |
	| cbd transport info +----+----+----+--------+----+----+----+--------+----+----+----+-------+-------+-------+-------+-----------+
	|                    |    |    |    |  ...   |    |    |    |  ...   |    |    |    |  ...  |       |       |       |   ...     |
	+--------------------+----+----+----+--------+----+----+----+--------+----+----+----+-------+---+---+---+---+-------+-----------+
													|       |
													|       |
													|       |
													|       |
		  +-------------------------------------------------------------------------------------+       |
		  |                                                                                             |
		  |                                                                                             |
		  v                                                                                             |
	    +-----------------------------------------------------------+                                       |
	    |                 channel segment                           |                                       |
	    +--------------------+--------------------------------------+                                       |
	    |    channel meta    |              channel data            |                                       |
	    +---------+----------+--------------------------------------+                                       |
		      |                                                                                         |
		      |                                                                                         |
		      |                                                                                         |
		      v                                                                                         |
	    +----------------------------------------------------------+                                        |
	    |                 channel meta                             |                                        |
	    +-----------+--------------+-------------------------------+                                        |
	    | meta ctrl |  comp ring   |       cmd ring                |                                        |
	    +-----------+--------------+-------------------------------+                                        |
														|
														|
														|
		   +--------------------------------------------------------------------------------------------+
		   |
		   |
		   |
		   v
	     +----------------------------------------------------------+
	     |                cache segment                             |
	     +-----------+----------------------------------------------+
	     |   info    |               data                           |
	     +-----------+----------------------------------------------+

The shared memory is divided into five regions:

	a) Transport_info:
	    Information about the overall transport, including the layout
	of the transport.

	b) Hosts:
	    Each host wishing to utilize this transport needs to register
	its own information within a host entry in this region.

	c) Backends:
	    Starting a backend on a host requires filling in information
	in a backend entry within this region.

	d) Blkdevs:
	    Once a backend is established, it can be mapped to CBD device
	on any associated host. The information about the blkdevs is then
	filled into the blkdevs region.

	e) Segments:
	    This is the actual data communication area, where communication
	between blkdev and backend occurs. Each queue of a block device uses
	a channel, and each backend has a corresponding handler interacting
	with this queue.

	f) Channel segment:
	    Channel is one type of segment, is further divided into meta and
	data regions.
	    The meta region includes subm rings and comp rings.
	The blkdev converts upper-layer requests into cbd_se and fills
	them into the subm ring. The handler accepts the cbd_se from
	the subm ring and sends them to the local actual block device
	of the backend (e.g., sda). After completion, the results are
	formed into cbd_ce and filled into the comp ring. The blkdev
	then receives the cbd_ce and returns the results to the upper-layer
	IO sender.

	g) Cache segment:
	    Cache segment is another type of segment, when cache enabled
	for a backend, transport will allocate cache segments to this
	backend.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_internal.h  |  482 ++++++++++++
 drivers/block/cbd/cbd_transport.c | 1186 +++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_transport.h |  169 ++++
 3 files changed, 1837 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_internal.h
 create mode 100644 drivers/block/cbd/cbd_transport.c
 create mode 100644 drivers/block/cbd/cbd_transport.h

diff --git a/drivers/block/cbd/cbd_internal.h b/drivers/block/cbd/cbd_internal.h
new file mode 100644
index 000000000000..56554acc058f
--- /dev/null
+++ b/drivers/block/cbd/cbd_internal.h
@@ -0,0 +1,482 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_INTERNAL_H
+#define _CBD_INTERNAL_H
+
+#include <linux/delay.h>
+#include <linux/crc32.h>
+
+/*
+ * CBD (CXL Block Device) provides two usage scenarios: single-host and multi-hosts.
+ *
+ * (1) Single-host scenario, CBD can use a pmem device as a cache for block devices,
+ * providing a caching mechanism specifically designed for persistent memory.
+ *
+ *	+-----------------------------------------------------------------+
+ *	|                         single-host                             |
+ *	+-----------------------------------------------------------------+
+ *	|                                                                 |
+ *	|                                                                 |
+ *	|                                                                 |
+ *	|                                                                 |
+ *	|                                                                 |
+ *	|                        +-----------+     +------------+         |
+ *	|                        | /dev/cbd0 |     | /dev/cbd1  |         |
+ *	|                        |           |     |            |         |
+ *	|  +---------------------|-----------|-----|------------|-------+ |
+ *	|  |                     |           |     |            |       | |
+ *	|  |      /dev/pmem0     | cbd0 cache|     | cbd1 cache |       | |
+ *	|  |                     |           |     |            |       | |
+ *	|  +---------------------|-----------|-----|------------|-------+ |
+ *	|                        |+---------+|     |+----------+|         |
+ *	|                        ||/dev/sda ||     || /dev/sdb ||         |
+ *	|                        |+---------+|     |+----------+|         |
+ *	|                        +-----------+     +------------+         |
+ *	+-----------------------------------------------------------------+
+ *
+ * (2) Multi-hosts scenario, CBD also provides a cache while taking advantage of
+ * shared memory features, allowing users to access block devices on other nodes across
+ * different hosts.
+ *
+ * As shared memory is supported in CXL3.0 spec, we can transfer data via CXL shared memory.
+ * CBD use CXL shared memory to transfer data between node-1 and node-2.
+ *
+ *	+--------------------------------------------------------------------------------------------------------+
+ *	|                                           multi-hosts                                                  |
+ *	+--------------------------------------------------------------------------------------------------------+
+ *	|                                                                                                        |
+ *	|                                                                                                        |
+ *	| +-------------------------------+                               +------------------------------------+ |
+ *	| |          node-1               |                               |              node-2                | |
+ *	| +-------------------------------+                               +------------------------------------+ |
+ *	| |                               |                               |                                    | |
+ *	| |                       +-------+                               +---------+                          | |
+ *	| |                       | cbd0  |                               | backend0+------------------+       | |
+ *	| |                       +-------+                               +---------+                  |       | |
+ *	| |                       | pmem0 |                               | pmem0   |                  v       | |
+ *	| |               +-------+-------+                               +---------+----+     +---------------+ |
+ *	| |               |    cxl driver |                               | cxl driver   |     |  /dev/sda     | |
+ *	| +---------------+--------+------+                               +-----+--------+-----+---------------+ |
+ *	|                          |                                            |                                |
+ *	|                          |                                            |                                |
+ *	|                          |        CXL                         CXL     |                                |
+ *	|                          +----------------+               +-----------+                                |
+ *	|                                           |               |                                            |
+ *	|                                           |               |                                            |
+ *	|                                           |               |                                            |
+ *	|                 +-------------------------+---------------+--------------------------+                 |
+ *	|                 |                         +---------------+                          |                 |
+ *	|                 | shared memory device    |  cbd0 cache   |                          |                 |
+ *	|                 |                         +---------------+                          |                 |
+ *	|                 +--------------------------------------------------------------------+                 |
+ *	|                                                                                                        |
+ *	+--------------------------------------------------------------------------------------------------------+
+ */
+#define cbd_err(fmt, ...)							\
+	pr_err("cbd: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define cbd_info(fmt, ...)							\
+	pr_info("cbd: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define cbd_debug(fmt, ...)							\
+	pr_debug("cbd: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+
+#define CBD_KB                  (1024)                      /* 1 Kilobyte in bytes */
+#define CBD_MB                  (CBD_KB * CBD_KB)           /* 1 Megabyte in bytes */
+
+#define CBD_TRANSPORT_MAX       1024                        /* Maximum number of transport instances */
+#define CBD_PATH_LEN            128
+#define CBD_NAME_LEN            32
+
+#define CBD_QUEUES_MAX          128                         /* Maximum number of I/O queues */
+#define CBD_HANDLERS_MAX        128                         /* Maximum number of handlers */
+
+#define CBD_PART_SHIFT          4                           /* Bit shift for partition identifier */
+#define CBD_DRV_NAME            "cbd"                       /* Default driver name for CBD */
+#define CBD_DEV_NAME_LEN        32                          /* Maximum device name length */
+
+#define CBD_HB_INTERVAL         msecs_to_jiffies(5000)      /* Heartbeat interval in jiffies (5 seconds) */
+#define CBD_HB_TIMEOUT          (30 * 1000)                 /* Heartbeat timeout in milliseconds (30 seconds) */
+
+/*
+ * CBD transport layout:
+ *
+ *	+-------------------------------------------------------------------------------------------------------------------------------+
+ *	|                           cbd transport                                                                                       |
+ *	+--------------------+-----------------------+-----------------------+----------------------+-----------------------------------+
+ *	|                    |       hosts           |      backends         |       blkdevs        |        segments                   |
+ *	| cbd transport info +----+----+----+--------+----+----+----+--------+----+----+----+-------+-------+-------+-------+-----------+
+ *	|                    |    |    |    |  ...   |    |    |    |  ...   |    |    |    |  ...  |       |       |       |   ...     |
+ *	+--------------------+----+----+----+--------+----+----+----+--------+----+----+----+-------+---+---+---+---+-------+-----------+
+ *	                                                                                                |       |
+ *	                                                                                                |       |
+ *	                                                                                                |       |
+ *	                                                                                                |       |
+ *	          +-------------------------------------------------------------------------------------+       |
+ *	          |                                                                                             |
+ *	          |                                                                                             |
+ *	          v                                                                                             |
+ *	    +-----------------------------------------------------------+                                       |
+ *	    |                 channel segment                           |                                       |
+ *	    +--------------------+--------------------------------------+                                       |
+ *	    |    channel meta    |              channel data            |                                       |
+ *	    +---------+----------+--------------------------------------+                                       |
+ *	              |                                                                                         |
+ *	              |                                                                                         |
+ *	              |                                                                                         |
+ *	              v                                                                                         |
+ *	    +----------------------------------------------------------+                                        |
+ *	    |                 channel meta                             |                                        |
+ *	    +-----------+--------------+-------------------------------+                                        |
+ *	    | meta ctrl |  comp ring   |       cmd ring                |                                        |
+ *	    +-----------+--------------+-------------------------------+                                        |
+ *	                                                                                                        |
+ *	                                                                                                        |
+ *	                                                                                                        |
+ *	           +--------------------------------------------------------------------------------------------+
+ *	           |
+ *	           |
+ *	           |
+ *	           v
+ *	     +----------------------------------------------------------+
+ *	     |                cache segment                             |
+ *	     +-----------+----------------------------------------------+
+ *	     |   info    |               data                           |
+ *	     +-----------+----------------------------------------------+
+ */
+
+/* cbd segment */
+#define CBDT_SEG_SIZE			(16 * 1024 * 1024)                  /* Size of each CBD segment (16 MB) */
+
+/* cbd transport */
+#define CBD_TRANSPORT_MAGIC             0x65B05EFA96C596EFULL  /* Unique identifier for CBD transport layer */
+#define CBD_TRANSPORT_VERSION           1                      /* Version number for CBD transport layer */
+
+/* Maximum number of metadata indices */
+#define CBDT_META_INDEX_MAX             2
+
+/*
+ * CBD structure diagram:
+ *
+ *	                                        +--------------+
+ *	                                        | cbd_transport|                                               +----------+
+ *	                                        +--------------+                                               | cbd_host |
+ *	                                        |              |                                               +----------+
+ *	                                        |   host       +---------------------------------------------->|          |
+ *	                   +--------------------+   backends   |                                               | hostname |
+ *	                   |                    |   devices    +------------------------------------------+    |          |
+ *	                   |                    |              |                                          |    +----------+
+ *	                   |                    +--------------+                                          |
+ *	                   |                                                                              |
+ *	                   |                                                                              |
+ *	                   |                                                                              |
+ *	                   |                                                                              |
+ *	                   |                                                                              |
+ *	                   v                                                                              v
+ *	             +------------+     +-----------+     +------+                                  +-----------+      +-----------+     +------+
+ *	             | cbd_backend+---->|cbd_backend+---->| NULL |                                  | cbd_blkdev+----->| cbd_blkdev+---->| NULL |
+ *	             +------------+     +-----------+     +------+                                  +-----------+      +-----------+     +------+
+ *	+------------+  cbd_cache |     |  handlers |                                        +------+  queues   |      |  queues   |
+ *	|            |            |     +-----------+                                        |      |           |      +-----------+
+ *	|     +------+  handlers  |                                                          |      |           |
+ *	|     |      +------------+                                                          |      | cbd_cache +-------------------------------------+
+ *	|     |                                                                              |      +-----------+                                     |
+ *	|     |                                                                              |                                                        |
+ *	|     |      +-------------+       +-------------+           +------+                |      +-----------+      +-----------+     +------+     |
+ *	|     +----->| cbd_handler +------>| cbd_handler +---------->| NULL |                +----->| cbd_queue +----->| cbd_queue +---->| NULL |     |
+ *	|            +-------------+       +-------------+           +------+                       +-----------+      +-----------+     +------+     |
+ *	|     +------+ channel     |       |   channel   |                                   +------+  channel  |      |  channel  |                  |
+ *	|     |      +-------------+       +-------------+                                   |      +-----------+      +-----------+                  |
+ *	|     |                                                                              |                                                        |
+ *	|     |                                                                              |                                                        |
+ *	|     |                                                                              |                                                        |
+ *	|     |                                                                              v                                                        |
+ *	|     |                                                        +-----------------------+                                                      |
+ *	|     +------------------------------------------------------->|      cbd_channel      |                                                      |
+ *	|                                                              +-----------------------+                                                      |
+ *	|                                                              | channel_id            |                                                      |
+ *	|                                                              | cmdr (cmd ring)       |                                                      |
+ *	|                                                              | compr (complete ring) |                                                      |
+ *	|                                                              | data (data area)      |                                                      |
+ *	|                                                              |                       |                                                      |
+ *	|                                                              +-----------------------+                                                      |
+ *	|                                                                                                                                             |
+ *	|                                                 +-----------------------------+                                                             |
+ *	+------------------------------------------------>|         cbd_cache           |<------------------------------------------------------------+
+ *	                                                  +-----------------------------+
+ *	                                                  |     cache_wq                |
+ *	                                                  |     cache_tree              |
+ *	                                                  |     segments[]              |
+ *	                                                  +-----------------------------+
+ */
+
+#define CBD_DEVICE(OBJ)					\
+struct cbd_## OBJ ##_device {				\
+	struct device dev;				\
+	struct cbd_transport *cbdt;			\
+	u32 id;						\
+};							\
+							\
+struct cbd_## OBJ ##s_device {				\
+	struct device OBJ ##s_dev;			\
+	struct cbd_## OBJ ##_device OBJ ##_devs[];	\
+}
+
+/* cbd_worker_cfg - Structure to manage retry configurations for a worker */
+struct cbd_worker_cfg {
+	u32			busy_retry_cur;
+	u32			busy_retry_count;
+	u32			busy_retry_max;
+	u32			busy_retry_min;
+	u64			busy_retry_interval;
+};
+
+static inline void cbdwc_init(struct cbd_worker_cfg *cfg)
+{
+	cfg->busy_retry_cur = 0;
+	cfg->busy_retry_count = 100;
+	cfg->busy_retry_max = cfg->busy_retry_count * 2;
+	cfg->busy_retry_min = 0;
+	cfg->busy_retry_interval = 1; /* 1 microsecond */
+}
+
+/**
+ * cbdwc_hit - Reset retry counter and increase busy_retry_count on success.
+ * @cfg: Pointer to the cbd_worker_cfg structure to update.
+ *
+ * Increases busy_retry_count by 1/16 of its current value,
+ * unless it's already at the maximum.
+ */
+static inline void cbdwc_hit(struct cbd_worker_cfg *cfg)
+{
+	u32 delta;
+
+	cfg->busy_retry_cur = 0;
+
+	if (cfg->busy_retry_count == cfg->busy_retry_max)
+		return;
+
+	delta = cfg->busy_retry_count >> 4;
+	if (!delta)
+		delta = (cfg->busy_retry_max + cfg->busy_retry_min) >> 1;
+
+	cfg->busy_retry_count += delta;
+
+	if (cfg->busy_retry_count > cfg->busy_retry_max)
+		cfg->busy_retry_count = cfg->busy_retry_max;
+}
+
+/**
+ * cbdwc_miss - Reset retry counter and decrease busy_retry_count on failure.
+ * @cfg: Pointer to the cbd_worker_cfg structure to update.
+ *
+ * Decreases busy_retry_count by 1/16 of its current value,
+ * unless it's already at the minimum.
+ */
+static inline void cbdwc_miss(struct cbd_worker_cfg *cfg)
+{
+	u32 delta;
+
+	cfg->busy_retry_cur = 0;
+
+	if (cfg->busy_retry_count == cfg->busy_retry_min)
+		return;
+
+	delta = cfg->busy_retry_count >> 4;
+	if (!delta)
+		delta = cfg->busy_retry_count;
+
+	cfg->busy_retry_count -= delta;
+}
+
+/**
+ * cbdwc_need_retry - Determine if another retry attempt should be made.
+ * @cfg: Pointer to the cbd_worker_cfg structure to check.
+ *
+ * Increments busy_retry_cur and compares it to busy_retry_count.
+ * If retry is needed, yields CPU and waits for busy_retry_interval.
+ *
+ * Return: true if retry is allowed, false if retry limit reached.
+ */
+static inline bool cbdwc_need_retry(struct cbd_worker_cfg *cfg)
+{
+	if (++cfg->busy_retry_cur < cfg->busy_retry_count) {
+		cpu_relax();
+		fsleep(cfg->busy_retry_interval);
+		return true;
+	}
+	return false;
+}
+
+/*
+ * struct cbd_meta_header - CBD metadata header structure
+ * @crc: CRC checksum for validating metadata integrity.
+ * @seq: Sequence number to track metadata updates.
+ * @version: Metadata version.
+ * @res: Reserved space for future use.
+ */
+struct cbd_meta_header {
+	u32 crc;
+	u8  seq;
+	u8  version;
+	u16 res;
+};
+
+/*
+ * cbd_meta_crc - Calculate CRC for the given metadata header.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of the metadata structure.
+ *
+ * Returns the CRC checksum calculated by excluding the CRC field itself.
+ */
+static inline u32 cbd_meta_crc(struct cbd_meta_header *header, u32 meta_size)
+{
+	return crc32(0, (void *)header + 4, meta_size - 4);  /* CRC calculated starting after the crc field */
+}
+
+/*
+ * cbd_meta_seq_after - Check if a sequence number is more recent, accounting for overflow.
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
+static inline bool cbd_meta_seq_after(u8 seq1, u8 seq2)
+{
+	return (s8)(seq1 - seq2) > 0;
+}
+
+/*
+ * cbd_meta_find_latest - Find the latest valid metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Finds the latest valid metadata by checking sequence numbers. If a
+ * valid entry with the highest sequence number is found, its pointer
+ * is returned. Returns NULL if no valid metadata is found.
+ */
+static inline void *cbd_meta_find_latest(struct cbd_meta_header *header,
+					 u32 meta_size)
+{
+	struct cbd_meta_header *meta, *latest = NULL;
+	u32 i;
+
+	for (i = 0; i < CBDT_META_INDEX_MAX; i++) {
+		meta = (void *)header + (i * meta_size);
+
+		/* Skip if CRC check fails */
+		if (meta->crc != cbd_meta_crc(meta, meta_size))
+			continue;
+
+		/* Update latest if a more recent sequence is found */
+		if (!latest || cbd_meta_seq_after(meta->seq, latest->seq))
+			latest = meta;
+	}
+
+	return latest;
+}
+
+/*
+ * cbd_meta_find_oldest - Find the oldest valid metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Returns the oldest valid metadata by comparing sequence numbers.
+ * If an entry with the lowest sequence number is found, its pointer
+ * is returned. Returns NULL if no valid metadata is found.
+ */
+static inline void *cbd_meta_find_oldest(struct cbd_meta_header *header,
+					 u32 meta_size)
+{
+	struct cbd_meta_header *meta, *oldest = NULL;
+	u32 i;
+
+	for (i = 0; i < CBDT_META_INDEX_MAX; i++) {
+		meta = (void *)header + (meta_size * i);
+
+		/* Mark as oldest if CRC check fails */
+		if (meta->crc != cbd_meta_crc(meta, meta_size)) {
+			oldest = meta;
+			break;
+		}
+
+		/* Update oldest if an older sequence is found */
+		if (!oldest || cbd_meta_seq_after(oldest->seq, meta->seq))
+			oldest = meta;
+	}
+
+	BUG_ON(!oldest);
+
+	return oldest;
+}
+
+/*
+ * cbd_meta_get_next_seq - Get the next sequence number for metadata.
+ * @header: Pointer to the metadata header.
+ * @meta_size: Size of each metadata block.
+ *
+ * Returns the next sequence number based on the latest metadata entry.
+ * If no latest metadata is found, returns 0.
+ */
+static inline u32 cbd_meta_get_next_seq(struct cbd_meta_header *header,
+					u32 meta_size)
+{
+	struct cbd_meta_header *latest;
+
+	latest = cbd_meta_find_latest(header, meta_size);
+	if (!latest)
+		return 0;
+
+	return (latest->seq + 1);
+}
+
+#define CBD_OBJ_HEARTBEAT(OBJ)								\
+static void OBJ##_hb_workfn(struct work_struct *work)					\
+{											\
+	struct cbd_##OBJ *obj = container_of(work, struct cbd_##OBJ, hb_work.work);	\
+											\
+	cbd_##OBJ##_hb(obj);								\
+											\
+	queue_delayed_work(cbd_wq, &obj->hb_work, CBD_HB_INTERVAL);			\
+}											\
+											\
+bool cbd_##OBJ##_info_is_alive(struct cbd_##OBJ##_info *info)				\
+{											\
+	ktime_t oldest, ts;								\
+											\
+	ts = info->alive_ts;								\
+	oldest = ktime_sub_ms(ktime_get_real(), CBD_HB_TIMEOUT);			\
+											\
+	if (ktime_after(ts, oldest))							\
+		return true;								\
+											\
+	return false;									\
+}											\
+											\
+static ssize_t alive_show(struct device *dev,						\
+			       struct device_attribute *attr,				\
+			       char *buf)						\
+{											\
+	struct cbd_##OBJ##_device *_dev;						\
+	struct cbd_##OBJ##_info *info;							\
+											\
+	_dev = container_of(dev, struct cbd_##OBJ##_device, dev);			\
+	info = cbdt_##OBJ##_info_read(_dev->cbdt, _dev->id);				\
+	if (!info)									\
+		goto out;								\
+											\
+	if (cbd_##OBJ##_info_is_alive(info))						\
+		return sprintf(buf, "true\n");						\
+											\
+out:											\
+	return sprintf(buf, "false\n");							\
+}											\
+static DEVICE_ATTR_ADMIN_RO(alive)							\
+
+#endif /* _CBD_INTERNAL_H */
diff --git a/drivers/block/cbd/cbd_transport.c b/drivers/block/cbd/cbd_transport.c
new file mode 100644
index 000000000000..64ec3055c903
--- /dev/null
+++ b/drivers/block/cbd/cbd_transport.c
@@ -0,0 +1,1186 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/dax.h>
+#include <linux/pfn_t.h>
+#include <linux/parser.h>
+
+#include "cbd_transport.h"
+#include "cbd_host.h"
+#include "cbd_segment.h"
+#include "cbd_backend.h"
+#include "cbd_blkdev.h"
+
+/*
+ * This macro defines and manages four types of objects within the CBD transport:
+ * host, backend, blkdev, and segment. Each object type is associated with its own
+ * information structure (`cbd_<OBJ>_info`), which includes a meta header. The meta
+ * header incorporates a sequence number and CRC, ensuring data integrity. This
+ * integrity mechanism allows consistent and reliable access to object information
+ * within the CBD transport.
+ */
+#define CBDT_OBJ(OBJ, OBJ_UPPER, OBJ_SIZE, OBJ_STRIDE)					\
+static int cbd_##OBJ##s_init(struct cbd_transport *cbdt)			\
+{										\
+	struct cbd_##OBJ##s_device *devs;					\
+	struct cbd_##OBJ##_device *cbd_dev;					\
+	struct device *dev;							\
+	int i;									\
+	int ret;								\
+										\
+	u32 memsize = struct_size(devs, OBJ##_devs,				\
+			cbdt->transport_info.OBJ##_num);			\
+	devs = kvzalloc(memsize, GFP_KERNEL);					\
+	if (!devs) {								\
+		return -ENOMEM;							\
+	}									\
+										\
+	dev = &devs->OBJ##s_dev;						\
+	device_initialize(dev);							\
+	device_set_pm_not_required(dev);					\
+	dev_set_name(dev, "cbd_" #OBJ "s");					\
+	dev->parent = &cbdt->device;						\
+	dev->type = &cbd_##OBJ##s_type;						\
+	ret = device_add(dev);							\
+	if (ret) {								\
+		goto devs_free;							\
+	}									\
+										\
+	for (i = 0; i < cbdt->transport_info.OBJ##_num; i++) {			\
+		cbd_dev = &devs->OBJ##_devs[i];					\
+		dev = &cbd_dev->dev;						\
+										\
+		cbd_dev->cbdt = cbdt;						\
+		cbd_dev->id = i;						\
+		device_initialize(dev);						\
+		device_set_pm_not_required(dev);				\
+		dev_set_name(dev, #OBJ "%u", i);				\
+		dev->parent = &devs->OBJ##s_dev;				\
+		dev->type = &cbd_##OBJ##_type;					\
+										\
+		ret = device_add(dev);						\
+		if (ret) {							\
+			i--;							\
+			goto del_device;					\
+		}								\
+	}									\
+	cbdt->cbd_##OBJ##s_dev = devs;						\
+										\
+	return 0;								\
+del_device:									\
+	for (; i >= 0; i--) {							\
+		cbd_dev = &devs->OBJ##_devs[i];					\
+		dev = &cbd_dev->dev;						\
+		device_unregister(dev);						\
+	}									\
+devs_free:									\
+	kvfree(devs);								\
+	return ret;								\
+}										\
+										\
+static void cbd_##OBJ##s_exit(struct cbd_transport *cbdt)			\
+{										\
+	struct cbd_##OBJ##s_device *devs = cbdt->cbd_##OBJ##s_dev;		\
+	struct device *dev;							\
+	int i;									\
+										\
+	if (!devs)								\
+		return;								\
+										\
+	for (i = 0; i < cbdt->transport_info.OBJ##_num; i++) {			\
+		struct cbd_##OBJ##_device *cbd_dev = &devs->OBJ##_devs[i];	\
+		dev = &cbd_dev->dev;						\
+										\
+		device_unregister(dev);						\
+	}									\
+										\
+	device_unregister(&devs->OBJ##s_dev);					\
+										\
+	kvfree(devs);								\
+	cbdt->cbd_##OBJ##s_dev = NULL;						\
+										\
+	return;									\
+}										\
+										\
+static inline struct cbd_##OBJ##_info						\
+*__get_##OBJ##_info(struct cbd_transport *cbdt, u32 id)				\
+{										\
+	struct cbd_transport_info *info = &cbdt->transport_info;		\
+	void *start = cbdt->transport_info_addr;				\
+										\
+	if (unlikely(id >= info->OBJ##_num)) {					\
+		cbdt_err(cbdt, "unexpected id: %u, num: %u",			\
+			       id, info->OBJ##_num);				\
+		BUG();								\
+	}									\
+	start += info->OBJ##_area_off;						\
+										\
+	return start + ((u64)OBJ_STRIDE * id);					\
+}										\
+										\
+struct cbd_##OBJ##_info								\
+*cbdt_get_##OBJ##_info(struct cbd_transport *cbdt, u32 id)			\
+{										\
+	struct cbd_##OBJ##_info *info;						\
+										\
+	mutex_lock(&cbdt->lock);						\
+	info = __get_##OBJ##_info(cbdt, id);					\
+	mutex_unlock(&cbdt->lock);						\
+										\
+	return info;								\
+}										\
+										\
+int cbdt_get_empty_##OBJ##_id(struct cbd_transport *cbdt, u32 *id)		\
+{										\
+	struct cbd_transport_info *info = &cbdt->transport_info;		\
+	struct cbd_##OBJ##_info *_info, *latest;				\
+	int ret = 0;								\
+	int i;									\
+										\
+	mutex_lock(&cbdt->lock);						\
+again:										\
+	for (i = cbdt->OBJ##_hint; i < info->OBJ##_num; i++) {			\
+		_info = __get_##OBJ##_info(cbdt, i);				\
+		latest = cbd_meta_find_latest(&_info->meta_header,		\
+					      OBJ_SIZE);			\
+		if (!latest || latest->state == CBD_##OBJ_UPPER##_STATE_NONE) {	\
+			*id = i;						\
+			goto out;						\
+		}								\
+	}									\
+										\
+	if (cbdt->OBJ##_hint != 0) {						\
+		cbdt_debug(cbdt, "reset hint to 0\n");				\
+		cbdt->OBJ##_hint = 0;						\
+		goto again;							\
+	}									\
+										\
+	cbdt_err(cbdt, "No available " #OBJ "_id found.");			\
+	ret = -ENOENT;								\
+out:										\
+	mutex_unlock(&cbdt->lock);						\
+										\
+	return ret;								\
+}										\
+										\
+struct cbd_##OBJ##_info *cbdt_##OBJ##_info_read(struct cbd_transport *cbdt,	\
+						u32 id)				\
+{										\
+	struct cbd_##OBJ##_info *info, *latest = NULL;				\
+										\
+	info = cbdt_get_##OBJ##_info(cbdt, id);					\
+										\
+	latest = cbd_meta_find_latest(&info->meta_header,			\
+				      OBJ_SIZE);				\
+	if (!latest)								\
+		return NULL;							\
+										\
+	return latest;								\
+}										\
+										\
+void cbdt_##OBJ##_info_write(struct cbd_transport *cbdt,			\
+				    void *data,					\
+				    u32 data_size,				\
+				    u32 id)					\
+{										\
+	struct cbd_##OBJ##_info *info;						\
+	struct cbd_meta_header *meta;						\
+										\
+	mutex_lock(&cbdt->lock);						\
+	/* seq is u8 and we compare it with cbd_meta_seq_after() */		\
+	meta = (struct cbd_meta_header *)data;					\
+	meta->seq++;								\
+										\
+	info = __get_##OBJ##_info(cbdt, id);					\
+	info = cbd_meta_find_oldest(&info->meta_header, OBJ_SIZE);		\
+										\
+	memcpy_flushcache(info, data, data_size);				\
+	info->meta_header.crc = cbd_meta_crc(&info->meta_header, OBJ_SIZE);	\
+	mutex_unlock(&cbdt->lock);						\
+}										\
+										\
+void cbdt_##OBJ##_info_clear(struct cbd_transport *cbdt, u32 id)		\
+{										\
+	struct cbd_##OBJ##_info *info;						\
+										\
+	mutex_lock(&cbdt->lock);						\
+	info = __get_##OBJ##_info(cbdt, id);					\
+	cbdt_zero_range(cbdt, info, OBJ_SIZE * CBDT_META_INDEX_MAX);		\
+	mutex_unlock(&cbdt->lock);						\
+}
+
+CBDT_OBJ(host, HOST, CBDT_HOST_INFO_SIZE, CBDT_HOST_INFO_STRIDE);
+CBDT_OBJ(backend, BACKEND, CBDT_BACKEND_INFO_SIZE, CBDT_BACKEND_INFO_STRIDE);
+CBDT_OBJ(blkdev, BLKDEV, CBDT_BLKDEV_INFO_SIZE, CBDT_BLKDEV_INFO_STRIDE);
+CBDT_OBJ(segment, SEGMENT, CBDT_SEG_INFO_SIZE, CBDT_SEG_INFO_STRIDE);
+
+static struct cbd_transport *cbd_transports[CBD_TRANSPORT_MAX];
+static DEFINE_IDA(cbd_transport_id_ida);
+static DEFINE_MUTEX(cbd_transport_mutex);
+
+static ssize_t host_id_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct cbd_transport *cbdt;
+	struct cbd_host *host;
+
+	cbdt = container_of(dev, struct cbd_transport, device);
+
+	host = cbdt->host;
+	if (!host)
+		return 0;
+
+	return sprintf(buf, "%d\n", host->host_id);
+}
+static DEVICE_ATTR_ADMIN_RO(host_id);
+
+enum {
+	CBDT_ADM_OPT_ERR		= 0,
+	CBDT_ADM_OPT_OP,
+	CBDT_ADM_OPT_FORCE,
+	CBDT_ADM_OPT_PATH,
+	CBDT_ADM_OPT_BID,
+	CBDT_ADM_OPT_HANDLERS,
+	CBDT_ADM_OPT_DID,
+	CBDT_ADM_OPT_QUEUES,
+	CBDT_ADM_OPT_HID,
+	CBDT_ADM_OPT_CACHE_SIZE,
+};
+
+enum {
+	CBDT_ADM_OP_B_START,
+	CBDT_ADM_OP_B_STOP,
+	CBDT_ADM_OP_B_CLEAR,
+	CBDT_ADM_OP_DEV_START,
+	CBDT_ADM_OP_DEV_STOP,
+	CBDT_ADM_OP_DEV_CLEAR,
+	CBDT_ADM_OP_H_CLEAR,
+};
+
+static const char *const adm_op_names[] = {
+	[CBDT_ADM_OP_B_START] = "backend-start",
+	[CBDT_ADM_OP_B_STOP] = "backend-stop",
+	[CBDT_ADM_OP_B_CLEAR] = "backend-clear",
+	[CBDT_ADM_OP_DEV_START] = "dev-start",
+	[CBDT_ADM_OP_DEV_STOP] = "dev-stop",
+	[CBDT_ADM_OP_DEV_CLEAR] = "dev-clear",
+	[CBDT_ADM_OP_H_CLEAR] = "host-clear",
+};
+
+static const match_table_t adm_opt_tokens = {
+	{ CBDT_ADM_OPT_OP,		"op=%s"	},
+	{ CBDT_ADM_OPT_FORCE,		"force=%u" },
+	{ CBDT_ADM_OPT_PATH,		"path=%s" },
+	{ CBDT_ADM_OPT_BID,		"backend_id=%u" },
+	{ CBDT_ADM_OPT_HANDLERS,	"handlers=%u" },
+	{ CBDT_ADM_OPT_DID,		"dev_id=%u" },
+	{ CBDT_ADM_OPT_QUEUES,		"queues=%u" },
+	{ CBDT_ADM_OPT_HID,		"host_id=%u" },
+	{ CBDT_ADM_OPT_CACHE_SIZE,	"cache_size=%u" },	/* unit is MiB */
+	{ CBDT_ADM_OPT_ERR,		NULL	}
+};
+
+
+struct cbd_adm_options {
+	u16 op;
+	u16 force:1;
+	u32 backend_id;
+	union {
+		struct host_options {
+			u32 hid;
+		} host;
+		struct backend_options {
+			char path[CBD_PATH_LEN];
+			u32 handlers;
+			u64 cache_size_M;
+		} backend;
+		struct segment_options {
+			u32 sid;
+		} segment;
+		struct blkdev_options {
+			u32 devid;
+			u32 queues;
+		} blkdev;
+	};
+};
+
+static int parse_adm_options(struct cbd_transport *cbdt,
+		char *buf,
+		struct cbd_adm_options *opts)
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
+		case CBDT_ADM_OPT_OP:
+			ret = match_string(adm_op_names, ARRAY_SIZE(adm_op_names), args[0].from);
+			if (ret < 0) {
+				cbdt_err(cbdt, "unknown op: '%s'\n", args[0].from);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->op = ret;
+			break;
+		case CBDT_ADM_OPT_PATH:
+			if (match_strlcpy(opts->backend.path, &args[0],
+				CBD_PATH_LEN) == 0) {
+				ret = -EINVAL;
+				goto out;
+			}
+			break;
+		case CBDT_ADM_OPT_FORCE:
+			if (match_uint(args, &token) || token != 1) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->force = 1;
+			break;
+		case CBDT_ADM_OPT_BID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (token >= cbdt->transport_info.backend_num) {
+				cbdt_err(cbdt, "invalid backend_id: %u, larger than backend_num %u\n",
+						token, cbdt->transport_info.backend_num);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->backend_id = token;
+			break;
+		case CBDT_ADM_OPT_HANDLERS:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (token > CBD_HANDLERS_MAX) {
+				cbdt_err(cbdt, "invalid handlers: %u, larger than max %u\n",
+						token, CBD_HANDLERS_MAX);
+				ret = -EINVAL;
+				goto out;
+			}
+
+			opts->backend.handlers = token;
+			break;
+		case CBDT_ADM_OPT_DID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (token >= cbdt->transport_info.blkdev_num) {
+				cbdt_err(cbdt, "invalid dev_id: %u, larger than blkdev_num %u\n",
+						token, cbdt->transport_info.blkdev_num);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->blkdev.devid = token;
+			break;
+		case CBDT_ADM_OPT_QUEUES:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (token > CBD_QUEUES_MAX) {
+				cbdt_err(cbdt, "invalid queues: %u, larger than max %u\n",
+						token, CBD_QUEUES_MAX);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->blkdev.queues = token;
+			break;
+		case CBDT_ADM_OPT_HID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			if (token >= cbdt->transport_info.host_num) {
+				cbdt_err(cbdt, "invalid host_id: %u, larger than max %u\n",
+						token, cbdt->transport_info.host_num);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->host.hid = token;
+			break;
+		case CBDT_ADM_OPT_CACHE_SIZE:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->backend.cache_size_M = token;
+			break;
+		default:
+			cbdt_err(cbdt, "unknown parameter or missing value '%s'\n", p);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
+/**
+ * cbdt_flush - Flush a specified range of data to persistent storage.
+ * @cbdt: Pointer to the CBD transport structure.
+ * @pos: Pointer to the starting address of the data range to flush.
+ * @size: Size of the data range to flush.
+ *
+ * This function ensures that the data in the specified address range
+ * is persisted to storage. It handles the following scenarios:
+ *
+ * - If using NVDIMM in a single-host scenario with ADR support,
+ *   then after calling dax_flush, the data will be persistent.
+ *   For more information on ADR, refer to:
+ *   https://pmem.io/glossary/#adr
+ *
+ * - If using CXL persistent memory, the function should comply with
+ *   Global Persistent Flush (GPF) as described in section 9.8 of
+ *   the CXL SPEC 3.1. In this case, dax_flush is also sufficient
+ *   to ensure data persistence.
+ */
+void cbdt_flush(struct cbd_transport *cbdt, void *pos, u32 size)
+{
+	dax_flush(cbdt->dax_dev, pos, size);
+}
+
+void cbdt_zero_range(struct cbd_transport *cbdt, void *pos, u32 size)
+{
+	memset(pos, 0, size);
+	cbdt_flush(cbdt, pos, size);
+}
+
+static bool hosts_stopped(struct cbd_transport *cbdt)
+{
+	struct cbd_host_info *host_info;
+	u32 i;
+
+	cbd_for_each_host_info(cbdt, i, host_info) {
+		if (cbd_host_info_is_alive(host_info)) {
+			cbdt_err(cbdt, "host %u is still alive\n", i);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int format_validate(struct cbd_transport *cbdt, bool force)
+{
+	struct cbd_transport_info *info = &cbdt->transport_info;
+	u64 transport_dev_size;
+	u64 magic;
+
+	magic = le64_to_cpu(info->magic);
+	if (magic && !force)
+		return -EEXIST;
+
+	if (magic == CBD_TRANSPORT_MAGIC && !hosts_stopped(cbdt))
+		return -EBUSY;
+
+	transport_dev_size = bdev_nr_bytes(file_bdev(cbdt->bdev_file));
+	if (transport_dev_size < CBD_TRASNPORT_SIZE_MIN) {
+		cbdt_err(cbdt, "dax device is too small, required at least %u",
+				CBD_TRASNPORT_SIZE_MIN);
+		return -ENOSPC;
+	}
+
+	return 0;
+}
+
+/*
+ * format_transport_info - Initialize the transport info structure for CBD transport
+ * @cbdt: Pointer to the CBD transport structure
+ *
+ * This function initializes the cbd_transport_info structure with relevant
+ * metadata for the transport. It sets the magic number and version, and
+ * determines the flags.
+ *
+ * The magic, version, and flags fields are stored in little-endian format to
+ * ensure compatibility across different platforms. This allows for correct
+ * identification of transport information and helps determine if it is suitable
+ * for registration on the local machine.
+ *
+ * The function calculates the size and offsets for various sections within
+ * the transport device based on the available device size, assuming a
+ * 1:1 mapping of hosts, block devices, backends, and segments.
+ */
+static void format_transport_info(struct cbd_transport *cbdt)
+{
+	struct cbd_transport_info *info = &cbdt->transport_info;
+	u64 transport_dev_size;
+	u32 seg_size;
+	u32 nr_segs;
+	u16 flags = 0;
+
+	memset(info, 0, sizeof(struct cbd_transport_info));
+
+	info->magic = cpu_to_le64(CBD_TRANSPORT_MAGIC);
+	info->version = cpu_to_le16(CBD_TRANSPORT_VERSION);
+
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	flags |= CBDT_INFO_F_BIGENDIAN;
+#endif
+
+#ifdef CONFIG_CBD_CHANNEL_CRC
+	flags |= CBDT_INFO_F_CHANNEL_CRC;
+#endif
+
+#ifdef CONFIG_CBD_CHANNEL_DATA_CRC
+	flags |= CBDT_INFO_F_CHANNEL_DATA_CRC;
+#endif
+
+#ifdef CONFIG_CBD_CACHE_DATA_CRC
+	flags |= CBDT_INFO_F_CACHE_DATA_CRC;
+#endif
+
+#ifdef CONFIG_CBD_MULTIHOST
+	flags |= CBDT_INFO_F_MULTIHOST;
+#endif
+
+	info->flags = cpu_to_le16(flags);
+	/*
+	 * Try to fully utilize all available space,
+	 * assuming host:blkdev:backend:segment = 1:1:1:1
+	 */
+	seg_size = (CBDT_HOST_INFO_STRIDE + CBDT_BACKEND_INFO_STRIDE +
+			CBDT_BLKDEV_INFO_STRIDE + CBDT_SEG_SIZE);
+	transport_dev_size = bdev_nr_bytes(file_bdev(cbdt->bdev_file));
+	nr_segs = (transport_dev_size - CBDT_INFO_STRIDE) / seg_size;
+
+	info->host_area_off = CBDT_INFO_OFF + CBDT_INFO_STRIDE;
+	info->host_info_size = CBDT_HOST_INFO_SIZE;
+	info->host_num = min(nr_segs, CBDT_HOSTS_MAX);
+
+	info->backend_area_off = info->host_area_off + (CBDT_HOST_INFO_STRIDE * info->host_num);
+	info->backend_info_size = CBDT_BACKEND_INFO_SIZE;
+	info->backend_num = nr_segs;
+
+	info->blkdev_area_off = info->backend_area_off + (CBDT_BACKEND_INFO_STRIDE * info->backend_num);
+	info->blkdev_info_size = CBDT_BLKDEV_INFO_SIZE;
+	info->blkdev_num = nr_segs;
+
+	info->segment_area_off = info->blkdev_area_off + (CBDT_BLKDEV_INFO_STRIDE * info->blkdev_num);
+	info->segment_size = CBDT_SEG_SIZE;
+	info->segment_num = nr_segs;
+
+	memcpy_flushcache(cbdt->transport_info_addr, info, sizeof(struct cbd_transport_info));
+}
+
+static void segments_format(struct cbd_transport *cbdt)
+{
+	u32 i;
+
+	for (i = 0; i < cbdt->transport_info.segment_num; i++)
+		cbdt_segment_info_clear(cbdt, i);
+}
+
+static int cbd_transport_format(struct cbd_transport *cbdt, bool force)
+{
+	struct cbd_transport_info *info = &cbdt->transport_info;
+	int ret;
+
+	ret = format_validate(cbdt, force);
+	if (ret)
+		return ret;
+
+	format_transport_info(cbdt);
+
+	cbdt_zero_range(cbdt, (void *)cbdt->transport_info_addr + info->host_area_off,
+			     info->segment_area_off - info->host_area_off);
+
+	segments_format(cbdt);
+
+	return 0;
+}
+
+/*
+ * This function handles administrative operations for the CBD transport device.
+ * It processes various commands related to backend management, device control,
+ * and host operations. All transport metadata allocation or reclamation
+ * should occur within this function to ensure proper control flow and exclusivity.
+ *
+ * Note: For single-host scenarios, the `adm_lock` mutex is sufficient
+ * to manage mutual exclusion. However, in multi-host scenarios,
+ * a distributed locking mechanism is necessary to guarantee
+ * exclusivity across all `adm_store` calls.
+ *
+ * TODO: Investigate potential locking mechanisms for the CXL shared memory device.
+ */
+static ssize_t adm_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *ubuf,
+			size_t size)
+{
+	int ret;
+	char *buf;
+	struct cbd_adm_options opts = { 0 };
+	struct cbd_transport *cbdt;
+
+	opts.backend_id = U32_MAX;
+	opts.backend.handlers = 1;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	cbdt = container_of(dev, struct cbd_transport, device);
+
+	buf = kmemdup(ubuf, size + 1, GFP_KERNEL);
+	if (IS_ERR(buf)) {
+		cbdt_err(cbdt, "failed to dup buf for adm option: %d", (int)PTR_ERR(buf));
+		return PTR_ERR(buf);
+	}
+	buf[size] = '\0';
+	ret = parse_adm_options(cbdt, buf, &opts);
+	if (ret < 0) {
+		kfree(buf);
+		return ret;
+	}
+	kfree(buf);
+
+	mutex_lock(&cbdt->adm_lock);
+	switch (opts.op) {
+	case CBDT_ADM_OP_B_START:
+		u32 cache_segs = 0;
+
+		if (opts.backend.cache_size_M > 0)
+			cache_segs = DIV_ROUND_UP(opts.backend.cache_size_M,
+					cbdt->transport_info.segment_size / CBD_MB);
+
+		ret = cbd_backend_start(cbdt, opts.backend.path, opts.backend_id, opts.backend.handlers, cache_segs);
+		break;
+	case CBDT_ADM_OP_B_STOP:
+		ret = cbd_backend_stop(cbdt, opts.backend_id);
+		break;
+	case CBDT_ADM_OP_B_CLEAR:
+		ret = cbd_backend_clear(cbdt, opts.backend_id);
+		break;
+	case CBDT_ADM_OP_DEV_START:
+		if (opts.blkdev.queues > CBD_QUEUES_MAX) {
+			mutex_unlock(&cbdt->adm_lock);
+			cbdt_err(cbdt, "invalid queues = %u, larger than max %u\n",
+					opts.blkdev.queues, CBD_QUEUES_MAX);
+			return -EINVAL;
+		}
+		ret = cbd_blkdev_start(cbdt, opts.backend_id, opts.blkdev.queues);
+		break;
+	case CBDT_ADM_OP_DEV_STOP:
+		ret = cbd_blkdev_stop(cbdt, opts.blkdev.devid);
+		break;
+	case CBDT_ADM_OP_DEV_CLEAR:
+		ret = cbd_blkdev_clear(cbdt, opts.blkdev.devid);
+		break;
+	case CBDT_ADM_OP_H_CLEAR:
+		ret = cbd_host_clear(cbdt, opts.host.hid);
+		break;
+	default:
+		mutex_unlock(&cbdt->adm_lock);
+		cbdt_err(cbdt, "invalid op: %d\n", opts.op);
+		return -EINVAL;
+	}
+	mutex_unlock(&cbdt->adm_lock);
+
+	if (ret < 0)
+		return ret;
+
+	return size;
+}
+
+static DEVICE_ATTR_WO(adm);
+
+static ssize_t __transport_info(struct cbd_transport *cbdt, char *buf)
+{
+	struct cbd_transport_info *info = &cbdt->transport_info;
+	ssize_t ret;
+
+	ret = sprintf(buf, "magic: 0x%llx\n"
+			"version: %u\n"
+			"flags: %x\n\n"
+			"host_area_off: %llu\n"
+			"bytes_per_host_info: %u\n"
+			"host_num: %u\n\n"
+			"backend_area_off: %llu\n"
+			"bytes_per_backend_info: %u\n"
+			"backend_num: %u\n\n"
+			"blkdev_area_off: %llu\n"
+			"bytes_per_blkdev_info: %u\n"
+			"blkdev_num: %u\n\n"
+			"segment_area_off: %llu\n"
+			"bytes_per_segment: %u\n"
+			"segment_num: %u\n",
+			le64_to_cpu(info->magic),
+			le16_to_cpu(info->version),
+			le16_to_cpu(info->flags),
+			info->host_area_off,
+			info->host_info_size,
+			info->host_num,
+			info->backend_area_off,
+			info->backend_info_size,
+			info->backend_num,
+			info->blkdev_area_off,
+			info->blkdev_info_size,
+			info->blkdev_num,
+			info->segment_area_off,
+			info->segment_size,
+			info->segment_num);
+
+	return ret;
+}
+
+static ssize_t info_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct cbd_transport *cbdt;
+
+	cbdt = container_of(dev, struct cbd_transport, device);
+
+	return __transport_info(cbdt, buf);
+}
+static DEVICE_ATTR_ADMIN_RO(info);
+
+static ssize_t path_show(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct cbd_transport *cbdt;
+
+	cbdt = container_of(dev, struct cbd_transport, device);
+
+	return sprintf(buf, "%s\n", cbdt->path);
+}
+static DEVICE_ATTR_ADMIN_RO(path);
+
+static struct attribute *cbd_transport_attrs[] = {
+	&dev_attr_adm.attr,
+	&dev_attr_host_id.attr,
+	&dev_attr_info.attr,
+	&dev_attr_path.attr,
+	NULL
+};
+
+static struct attribute_group cbd_transport_attr_group = {
+	.attrs = cbd_transport_attrs,
+};
+
+static const struct attribute_group *cbd_transport_attr_groups[] = {
+	&cbd_transport_attr_group,
+	NULL
+};
+
+static void cbd_transport_release(struct device *dev)
+{
+}
+
+const struct device_type cbd_transport_type = {
+	.name		= "cbd_transport",
+	.groups		= cbd_transport_attr_groups,
+	.release	= cbd_transport_release,
+};
+
+static int cbd_dax_notify_failure(struct dax_device *dax_dev, u64 offset,
+				  u64 len, int mf_flags)
+{
+
+	pr_err("%s: dax_dev %llx offset %llx len %lld mf_flags %x\n",
+	       __func__, (u64)dax_dev, (u64)offset, (u64)len, mf_flags);
+
+	return -EOPNOTSUPP;
+}
+
+const struct dax_holder_operations cbd_dax_holder_ops = {
+	.notify_failure		= cbd_dax_notify_failure,
+};
+
+static int transport_info_validate(struct cbd_transport *cbdt)
+{
+	u16 flags;
+
+	if (le64_to_cpu(cbdt->transport_info.magic) != CBD_TRANSPORT_MAGIC) {
+		cbdt_err(cbdt, "unexpected magic: %llx\n",
+				le64_to_cpu(cbdt->transport_info.magic));
+		return -EINVAL;
+	}
+
+	flags = le16_to_cpu(cbdt->transport_info.flags);
+
+#if defined(__BYTE_ORDER) ? (__BIG_ENDIAN == __BYTE_ORDER) : defined(__BIG_ENDIAN)
+	/* Ensure transport matches the system's endianness */
+	if (!(flags & CBDT_INFO_F_BIGENDIAN)) {
+		cbdt_err(cbdt, "transport is not big endian\n");
+		return -EINVAL;
+	}
+#else
+	if (flags & CBDT_INFO_F_BIGENDIAN) {
+		cbdt_err(cbdt, "transport is big endian\n");
+		return -EINVAL;
+	}
+#endif
+
+#ifndef CONFIG_CBD_CHANNEL_CRC
+	if (flags & CBDT_INFO_F_CHANNEL_CRC) {
+		cbdt_err(cbdt, "transport expects CBD_CHANNEL_CRC enabled.\n");
+		return -EOPNOTSUPP;
+	}
+#endif
+
+#ifndef CONFIG_CBD_CHANNEL_DATA_CRC
+	if (flags & CBDT_INFO_F_CHANNEL_DATA_CRC) {
+		cbdt_err(cbdt, "transport expects CBD_CHANNEL_DATA_CRC enabled.\n");
+		return -EOPNOTSUPP;
+	}
+#endif
+
+#ifndef CONFIG_CBD_CACHE_DATA_CRC
+	if (flags & CBDT_INFO_F_CACHE_DATA_CRC) {
+		cbdt_err(cbdt, "transport expects CBD_CACHE_DATA_CRC enabled.\n");
+		return -EOPNOTSUPP;
+	}
+#endif
+
+#ifndef CONFIG_CBD_MULTIHOST
+	if (flags & CBDT_INFO_F_MULTIHOST) {
+		cbdt_err(cbdt, "transport expects CBD_MULTIHOST enabled.\n");
+		return -EOPNOTSUPP;
+	}
+#endif
+	return 0;
+}
+
+static struct cbd_transport *transport_alloc(void)
+{
+	struct cbd_transport *cbdt;
+	int ret;
+
+	cbdt = kzalloc(sizeof(struct cbd_transport), GFP_KERNEL);
+	if (!cbdt)
+		return NULL;
+
+	mutex_init(&cbdt->lock);
+	mutex_init(&cbdt->adm_lock);
+	INIT_LIST_HEAD(&cbdt->backends);
+	INIT_LIST_HEAD(&cbdt->devices);
+
+	ret = ida_simple_get(&cbd_transport_id_ida, 0, CBD_TRANSPORT_MAX,
+				GFP_KERNEL);
+	if (ret < 0)
+		goto transport_free;
+
+	cbdt->id = ret;
+	cbd_transports[cbdt->id] = cbdt;
+
+	return cbdt;
+
+transport_free:
+	kfree(cbdt);
+	return NULL;
+}
+
+static void transport_free(struct cbd_transport *cbdt)
+{
+	cbd_transports[cbdt->id] = NULL;
+	ida_simple_remove(&cbd_transport_id_ida, cbdt->id);
+	kfree(cbdt);
+}
+
+static int transport_dax_init(struct cbd_transport *cbdt, char *path)
+{
+	struct dax_device *dax_dev = NULL;
+	struct file *bdev_file = NULL;
+	long access_size;
+	void *kaddr;
+	u64 start_off = 0;
+	int ret;
+	int id;
+
+	memcpy(cbdt->path, path, CBD_PATH_LEN);
+
+	bdev_file = bdev_file_open_by_path(path, BLK_OPEN_READ | BLK_OPEN_WRITE, cbdt, NULL);
+	if (IS_ERR(bdev_file)) {
+		cbdt_err(cbdt, "%s: failed blkdev_get_by_path(%s)\n", __func__, path);
+		ret = PTR_ERR(bdev_file);
+		goto err;
+	}
+
+	dax_dev = fs_dax_get_by_bdev(file_bdev(bdev_file), &start_off,
+				     cbdt,
+				     &cbd_dax_holder_ops);
+	if (IS_ERR(dax_dev)) {
+		cbdt_err(cbdt, "%s: unable to get daxdev from bdev_file\n", __func__);
+		ret = -ENODEV;
+		goto fput;
+	}
+
+	id = dax_read_lock();
+	access_size = dax_direct_access(dax_dev, 0, 1, DAX_ACCESS, &kaddr, NULL);
+	if (access_size != 1) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	cbdt->bdev_file = bdev_file;
+	cbdt->dax_dev = dax_dev;
+	cbdt->transport_info_addr = (struct cbd_transport_info *)kaddr;
+	memcpy(&cbdt->transport_info, cbdt->transport_info_addr, sizeof(struct cbd_transport_info));
+	dax_read_unlock(id);
+
+	return 0;
+
+unlock:
+	dax_read_unlock(id);
+	fs_put_dax(dax_dev, cbdt);
+fput:
+	fput(bdev_file);
+err:
+	return ret;
+}
+
+static void transport_dax_exit(struct cbd_transport *cbdt)
+{
+	if (cbdt->dax_dev)
+		fs_put_dax(cbdt->dax_dev, cbdt);
+
+	if (cbdt->bdev_file)
+		fput(cbdt->bdev_file);
+}
+
+static int transport_init(struct cbd_transport *cbdt,
+			  struct cbdt_register_options *opts)
+{
+	struct device *dev;
+	int ret;
+
+	ret = transport_info_validate(cbdt);
+	if (ret)
+		goto err;
+
+	dev = &cbdt->device;
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->bus = &cbd_bus_type;
+	dev->type = &cbd_transport_type;
+	dev->parent = &cbd_root_dev;
+	dev_set_name(&cbdt->device, "transport%d", cbdt->id);
+	ret = device_add(&cbdt->device);
+	if (ret)
+		goto err;
+
+	ret = cbd_host_register(cbdt, opts->hostname, opts->host_id);
+	if (ret)
+		goto dev_unregister;
+
+	if (cbd_hosts_init(cbdt) || cbd_backends_init(cbdt) ||
+	    cbd_segments_init(cbdt) || cbd_blkdevs_init(cbdt)) {
+		ret = -ENOMEM;
+		goto devs_exit;
+	}
+
+	return 0;
+
+devs_exit:
+	cbd_blkdevs_exit(cbdt);
+	cbd_segments_exit(cbdt);
+	cbd_backends_exit(cbdt);
+	cbd_hosts_exit(cbdt);
+
+	cbd_host_unregister(cbdt);
+dev_unregister:
+	device_unregister(&cbdt->device);
+err:
+	return ret;
+}
+
+static void transport_exit(struct cbd_transport *cbdt)
+{
+	cbd_blkdevs_exit(cbdt);
+	cbd_segments_exit(cbdt);
+	cbd_backends_exit(cbdt);
+	cbd_hosts_exit(cbdt);
+
+	cbd_host_unregister(cbdt);
+	device_unregister(&cbdt->device);
+}
+
+int cbdt_unregister(u32 tid)
+{
+	struct cbd_transport *cbdt;
+
+	if (tid >= CBD_TRANSPORT_MAX) {
+		pr_err("invalid tid: %u\n", tid);
+		return -EINVAL;
+	}
+
+	cbdt = cbd_transports[tid];
+	if (!cbdt) {
+		pr_err("tid: %u, is not registered\n", tid);
+		return -EINVAL;
+	}
+
+	mutex_lock(&cbdt->lock);
+	if (!list_empty(&cbdt->backends) || !list_empty(&cbdt->devices)) {
+		mutex_unlock(&cbdt->lock);
+		return -EBUSY;
+	}
+	mutex_unlock(&cbdt->lock);
+
+	transport_exit(cbdt);
+	transport_dax_exit(cbdt);
+	transport_free(cbdt);
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+int cbdt_register(struct cbdt_register_options *opts)
+{
+	struct cbd_transport *cbdt;
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
+	cbdt = transport_alloc();
+	if (!cbdt) {
+		ret = -ENOMEM;
+		goto module_put;
+	}
+
+	ret = transport_dax_init(cbdt, opts->path);
+	if (ret)
+		goto transport_free;
+
+	if (opts->format) {
+		ret = cbd_transport_format(cbdt, opts->force);
+		if (ret < 0)
+			goto dax_release;
+	}
+
+	ret = transport_init(cbdt, opts);
+	if (ret)
+		goto dax_release;
+
+	return 0;
+dax_release:
+	transport_dax_exit(cbdt);
+transport_free:
+	transport_free(cbdt);
+module_put:
+	module_put(THIS_MODULE);
+
+	return ret;
+}
+
+void cbdt_add_backend(struct cbd_transport *cbdt, struct cbd_backend *cbdb)
+{
+	mutex_lock(&cbdt->lock);
+	list_add(&cbdb->node, &cbdt->backends);
+	mutex_unlock(&cbdt->lock);
+}
+
+void cbdt_del_backend(struct cbd_transport *cbdt, struct cbd_backend *cbdb)
+{
+	if (list_empty(&cbdb->node))
+		return;
+
+	mutex_lock(&cbdt->lock);
+	list_del_init(&cbdb->node);
+	mutex_unlock(&cbdt->lock);
+}
+
+struct cbd_backend *cbdt_get_backend(struct cbd_transport *cbdt, u32 id)
+{
+	struct cbd_backend *backend;
+
+	mutex_lock(&cbdt->lock);
+	list_for_each_entry(backend, &cbdt->backends, node) {
+		if (backend->backend_id == id)
+			goto out;
+	}
+	backend = NULL;
+out:
+	mutex_unlock(&cbdt->lock);
+	return backend;
+}
+
+void cbdt_add_blkdev(struct cbd_transport *cbdt, struct cbd_blkdev *blkdev)
+{
+	mutex_lock(&cbdt->lock);
+	list_add(&blkdev->node, &cbdt->devices);
+	mutex_unlock(&cbdt->lock);
+}
+
+void cbdt_del_blkdev(struct cbd_transport *cbdt, struct cbd_blkdev *blkdev)
+{
+	if (list_empty(&blkdev->node))
+		return;
+
+	mutex_lock(&cbdt->lock);
+	list_del_init(&blkdev->node);
+	mutex_unlock(&cbdt->lock);
+}
+
+struct cbd_blkdev *cbdt_get_blkdev(struct cbd_transport *cbdt, u32 id)
+{
+	struct cbd_blkdev *dev;
+
+	mutex_lock(&cbdt->lock);
+	list_for_each_entry(dev, &cbdt->devices, node) {
+		if (dev->blkdev_id == id)
+			goto out;
+	}
+	dev = NULL;
+out:
+	mutex_unlock(&cbdt->lock);
+	return dev;
+}
+
+/**
+ * cbdt_page - Get the page structure for a specific transport offset
+ * @cbdt: Pointer to the cbd_transport structure
+ * @transport_off: Offset within the transport, in bytes
+ * @page_off: Pointer to store the offset within the page, if non-NULL
+ *
+ * This function retrieves the page structure corresponding to a specified
+ * transport offset using dax_direct_access. It first calculates the page frame
+ * number (PFN) at the given offset (aligned to the page boundary) and then
+ * converts the PFN to a struct page pointer.
+ *
+ * If @page_off is provided, it stores the offset within the page.
+ *
+ * Returns:
+ * A pointer to the struct page if successful, or NULL on failure.
+ */
+struct page *cbdt_page(struct cbd_transport *cbdt, u64 transport_off, u32 *page_off)
+{
+	long access_size;
+	pfn_t pfn;
+
+	access_size = dax_direct_access(cbdt->dax_dev, transport_off >> PAGE_SHIFT,
+					1, DAX_ACCESS, NULL, &pfn);
+	if (access_size < 0)
+		return NULL;
+
+	if (page_off)
+		*page_off = transport_off & PAGE_MASK;
+
+	return pfn_t_to_page(pfn);
+}
diff --git a/drivers/block/cbd/cbd_transport.h b/drivers/block/cbd/cbd_transport.h
new file mode 100644
index 000000000000..a0f83d503d6f
--- /dev/null
+++ b/drivers/block/cbd/cbd_transport.h
@@ -0,0 +1,169 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_TRANSPORT_H
+#define _CBD_TRANSPORT_H
+
+#include <linux/device.h>
+
+#include "cbd_internal.h"
+
+#define cbdt_err(transport, fmt, ...)						\
+	cbd_err("cbd_transport%u: " fmt,					\
+		 transport->id, ##__VA_ARGS__)
+#define cbdt_info(transport, fmt, ...)						\
+	cbd_info("cbd_transport%u: " fmt,					\
+		 transport->id, ##__VA_ARGS__)
+#define cbdt_debug(transport, fmt, ...)						\
+	cbd_debug("cbd_transport%u: " fmt,					\
+		 transport->id, ##__VA_ARGS__)
+
+/* Info section offsets and sizes */
+#define CBDT_INFO_OFF                   0                       /* Offset for transport info */
+#define CBDT_INFO_SIZE                  PAGE_SIZE               /* Size of transport info section (1 page) */
+#define CBDT_INFO_STRIDE                (CBDT_INFO_SIZE * CBDT_META_INDEX_MAX) /* Stride for alternating metadata copies */
+
+#define CBDT_HOST_INFO_SIZE             round_up(sizeof(struct cbd_host_info), PAGE_SIZE)
+#define CBDT_HOST_INFO_STRIDE           (CBDT_HOST_INFO_SIZE * CBDT_META_INDEX_MAX)
+
+#define CBDT_BACKEND_INFO_SIZE          round_up(sizeof(struct cbd_backend_info), PAGE_SIZE)
+#define CBDT_BACKEND_INFO_STRIDE        (CBDT_BACKEND_INFO_SIZE * CBDT_META_INDEX_MAX)
+
+#define CBDT_BLKDEV_INFO_SIZE           round_up(sizeof(struct cbd_blkdev_info), PAGE_SIZE)
+#define CBDT_BLKDEV_INFO_STRIDE         (CBDT_BLKDEV_INFO_SIZE * CBDT_META_INDEX_MAX)
+
+#define CBDT_SEG_INFO_SIZE              round_up(sizeof(struct cbd_segment_info), PAGE_SIZE)
+#define CBDT_SEG_INFO_STRIDE            CBDT_SEG_SIZE
+
+#define CBD_TRASNPORT_SIZE_MIN          (512 * 1024 * 1024)     /* Minimum size for CBD transport (512 MB) */
+
+/*
+ * CBD transport flags configured during formatting
+ *
+ * The CBDT_INFO_F_xxx flags define registration requirements based on transport
+ * formatting. For a machine to register a transport:
+ * - CBDT_INFO_F_BIGENDIAN: Requires a big-endian machine.
+ * - CBDT_INFO_F_CHANNEL_CRC: Requires CBD_CHANNEL_CRC enabled.
+ * - CBDT_INFO_F_CHANNEL_DATA_CRC: Requires CBD_CHANNEL_DATA_CRC enabled.
+ * - CBDT_INFO_F_CACHE_DATA_CRC: Requires CBD_CACHE_DATA_CRC enabled.
+ * - CBDT_INFO_F_MULTIHOST: Requires CBD_MULTIHOST enabled for multi-host access.
+ */
+#define CBDT_INFO_F_BIGENDIAN			(1 << 0)
+#define CBDT_INFO_F_CHANNEL_CRC			(1 << 1)
+#define CBDT_INFO_F_CHANNEL_DATA_CRC		(1 << 2)
+#define CBDT_INFO_F_CACHE_DATA_CRC		(1 << 3)
+#define CBDT_INFO_F_MULTIHOST			(1 << 4)
+
+/*
+ * Maximum number of hosts supported in the transport.
+ * Limited to 1 if CONFIG_CBD_MULTIHOST is not enabled.
+ */
+#ifdef CONFIG_CBD_MULTIHOST
+#define CBDT_HOSTS_MAX                  16
+#else
+#define CBDT_HOSTS_MAX                  1
+#endif /* CONFIG_CBD_MULTIHOST */
+
+struct cbd_transport_info {
+	__le64 magic;
+	__le16 version;
+	__le16 flags;
+
+	u64 host_area_off;
+	u32 host_info_size;
+	u32 host_num;
+
+	u64 backend_area_off;
+	u32 backend_info_size;
+	u32 backend_num;
+
+	u64 blkdev_area_off;
+	u32 blkdev_info_size;
+	u32 blkdev_num;
+
+	u64 segment_area_off;
+	u32 segment_size;
+	u32 segment_num;
+};
+
+struct cbd_transport {
+	u16	id;
+	struct device device;
+	struct mutex lock;
+	struct mutex adm_lock;
+
+	struct cbd_transport_info *transport_info_addr;
+	struct cbd_transport_info transport_info;
+
+	struct cbd_host *host;
+	struct list_head backends;
+	struct list_head devices;
+
+	u32 host_hint;
+	u32 backend_hint;
+	u32 blkdev_hint;
+	u32 segment_hint;
+
+	struct cbd_hosts_device *cbd_hosts_dev;
+	struct cbd_segments_device *cbd_segments_dev;
+	struct cbd_backends_device *cbd_backends_dev;
+	struct cbd_blkdevs_device *cbd_blkdevs_dev;
+
+	char path[CBD_PATH_LEN];
+	struct dax_device *dax_dev;
+	struct file *bdev_file;
+};
+
+struct cbdt_register_options {
+	char hostname[CBD_NAME_LEN];
+	char path[CBD_PATH_LEN];
+	u32 host_id;
+	u16 format:1;
+	u16 force:1;
+	u16 unused:14;
+};
+
+struct cbd_blkdev;
+struct cbd_backend;
+struct cbd_backend_io;
+struct cbd_cache;
+
+int cbdt_register(struct cbdt_register_options *opts);
+int cbdt_unregister(u32 transport_id);
+
+#define CBDT_OBJ_DECLARE(OBJ)								\
+extern const struct device_type cbd_##OBJ##_type;					\
+extern const struct device_type cbd_##OBJ##s_type;					\
+struct cbd_##OBJ##_info	*cbdt_get_##OBJ##_info(struct cbd_transport *cbdt, u32 id);	\
+int cbdt_get_empty_##OBJ##_id(struct cbd_transport *cbdt, u32 *id);			\
+struct cbd_##OBJ##_info *cbdt_##OBJ##_info_read(struct cbd_transport *cbdt,		\
+						u32 id);				\
+void cbdt_##OBJ##_info_write(struct cbd_transport *cbdt,				\
+			     void *data,						\
+			     u32 data_size,						\
+			     u32 id);							\
+void cbdt_##OBJ##_info_clear(struct cbd_transport *cbdt, u32 id)
+
+CBDT_OBJ_DECLARE(host);
+CBDT_OBJ_DECLARE(backend);
+CBDT_OBJ_DECLARE(blkdev);
+CBDT_OBJ_DECLARE(segment);
+
+extern const struct bus_type cbd_bus_type;
+extern struct device cbd_root_dev;
+
+void cbdt_add_backend(struct cbd_transport *cbdt, struct cbd_backend *cbdb);
+void cbdt_del_backend(struct cbd_transport *cbdt, struct cbd_backend *cbdb);
+struct cbd_backend *cbdt_get_backend(struct cbd_transport *cbdt, u32 id);
+void cbdt_add_blkdev(struct cbd_transport *cbdt, struct cbd_blkdev *blkdev);
+void cbdt_del_blkdev(struct cbd_transport *cbdt, struct cbd_blkdev *blkdev);
+struct cbd_blkdev *cbdt_get_blkdev(struct cbd_transport *cbdt, u32 id);
+
+struct page *cbdt_page(struct cbd_transport *cbdt, u64 transport_off, u32 *page_off);
+void cbdt_zero_range(struct cbd_transport *cbdt, void *pos, u32 size);
+void cbdt_flush(struct cbd_transport *cbdt, void *pos, u32 size);
+
+static inline bool cbdt_is_single_host(struct cbd_transport *cbdt)
+{
+	return (cbdt->transport_info.host_num == 1);
+}
+
+#endif /* _CBD_TRANSPORT_H */
-- 
2.34.1



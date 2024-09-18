Return-Path: <linux-bcache+bounces-719-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE13197BAAE
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 12:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEC52B2223E
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 10:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86C118594F;
	Wed, 18 Sep 2024 10:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qNrPAewg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3A617D377
	for <linux-bcache@vger.kernel.org>; Wed, 18 Sep 2024 10:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726654734; cv=none; b=nV1/DKGGeq+VDIVsMnCKI9KrSJ0QPo9T53aurmFisKSOgEjKFykN2wL4cdRU0KP6qAS5P+eOrosSRayWmq771ZYvECojKoGvmu/nYUqWrVMQKAfIEi/hSoUQumic2dkdZBHsLDbCdz6ZG41eNl8m7LoDTmKW8uxSyfylbnrqxEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726654734; c=relaxed/simple;
	bh=cPNvongFuOAZs3svQNXpJ/mKG41uzjv2iOw2AIEwjAM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RTFW3ab5x51pIkuz19lKJFjHwtrRZ3d2Iw/Y3t7pQhFO9duDhb3n++DonhXOmAaU+VmH0ZcgsYbwmlkLl/AZY0wB7XxIaNqenWoQLMLUB1jMUvyObVtjf6q1ecF+L4Aua0Mtr/jEyRiLZxUU2cDXTVjelyaEwEjHHkUl7BI2VUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qNrPAewg; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726654727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D9vMquosGNQahw5FgSUZEKnhEmjWaslUdu0G45Swvwc=;
	b=qNrPAewgqGx/23l5830GRIY2rcaypoKIKidPl98ZCfx3+0qFpFXEZoriqMQ+SZ1BiwI3Qh
	TVa1kA8glT3gYkQgwgX/gsUHBwC+89H7MEzvs7pAsLTsk+DtEkofUJQWQWHYIqAk/pwusS
	ZoaeBx+PL/NmrwPt/pj5MAkMwONH7Gw=
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
Subject: [PATCH v2 1/8] cbd: introduce cbd_transport
Date: Wed, 18 Sep 2024 10:18:14 +0000
Message-Id: <20240918101821.681118-2-dongsheng.yang@linux.dev>
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

cbd_transport represents the layout of the entire shared memory, as shown below.

	+-------------------------------------------------------------------------------------------------------------------------------+
	|                           cbd transport                                                                                       |
	+--------------------+-----------------------+-----------------------+----------------------+-----------------------------------+
	|                    |       hosts           |      backends         |       blkdevs        |        channels                   |
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
 drivers/block/cbd/cbd_internal.h  | 1193 +++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_transport.c |  957 +++++++++++++++++++++++
 2 files changed, 2150 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_internal.h
 create mode 100644 drivers/block/cbd/cbd_transport.c

diff --git a/drivers/block/cbd/cbd_internal.h b/drivers/block/cbd/cbd_internal.h
new file mode 100644
index 000000000000..236dbcb62906
--- /dev/null
+++ b/drivers/block/cbd/cbd_internal.h
@@ -0,0 +1,1193 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _CBD_INTERNAL_H
+#define _CBD_INTERNAL_H
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/blk-mq.h>
+#include <asm/byteorder.h>
+#include <asm/types.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/dax.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/idr.h>
+#include <linux/workqueue.h>
+#include <linux/uuid.h>
+#include <linux/bitfield.h>
+#include <linux/crc32.h>
+#include <linux/hashtable.h>
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
+
+#define cbd_err(fmt, ...)							\
+	pr_err("cbd: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define cbd_info(fmt, ...)							\
+	pr_info("cbd: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
+#define cbd_debug(fmt, ...)							\
+	pr_debug("cbd: %s:%u " fmt, __func__, __LINE__, ##__VA_ARGS__)
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
+#define cbdb_err(backend, fmt, ...)						\
+	cbdt_err(backend->cbdt, "backend%d: " fmt,				\
+		 backend->backend_id, ##__VA_ARGS__)
+#define cbdb_info(backend, fmt, ...)						\
+	cbdt_info(backend->cbdt, "backend%d: " fmt,				\
+		 backend->backend_id, ##__VA_ARGS__)
+#define cbdbdebug(backend, fmt, ...)						\
+	cbdt_debug(backend->cbdt, "backend%d: " fmt,				\
+		 backend->backend_id, ##__VA_ARGS__)
+
+#define cbd_handler_err(handler, fmt, ...)					\
+	cbdb_err(handler->cbdb, "handler%d: " fmt,				\
+		 handler->channel.seg_id, ##__VA_ARGS__)
+#define cbd_handler_info(handler, fmt, ...)					\
+	cbdb_info(handler->cbdb, "handler%d: " fmt,				\
+		 handler->channel.seg_id, ##__VA_ARGS__)
+#define cbd_handler_debug(handler, fmt, ...)					\
+	cbdb_debug(handler->cbdb, "handler%d: " fmt,				\
+		 handler->channel.seg_id, ##__VA_ARGS__)
+
+#define cbd_blk_err(dev, fmt, ...)						\
+	cbdt_err(dev->cbdt, "cbd%d: " fmt,					\
+		 dev->mapped_id, ##__VA_ARGS__)
+#define cbd_blk_info(dev, fmt, ...)						\
+	cbdt_info(dev->cbdt, "cbd%d: " fmt,					\
+		 dev->mapped_id, ##__VA_ARGS__)
+#define cbd_blk_debug(dev, fmt, ...)						\
+	cbdt_debug(dev->cbdt, "cbd%d: " fmt,					\
+		 dev->mapped_id, ##__VA_ARGS__)
+
+#define cbd_queue_err(queue, fmt, ...)						\
+	cbd_blk_err(queue->cbd_blkdev, "queue%d: " fmt,			\
+		     queue->channel.seg_id, ##__VA_ARGS__)
+#define cbd_queue_info(queue, fmt, ...)						\
+	cbd_blk_info(queue->cbd_blkdev, "queue%d: " fmt,			\
+		     queue->channel.seg_id, ##__VA_ARGS__)
+#define cbd_queue_debug(queue, fmt, ...)					\
+	cbd_blk_debug(queue->cbd_blkdev, "queue%d: " fmt,			\
+		     queue->channel.seg_id, ##__VA_ARGS__)
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
+#define cbd_cache_err(cache, fmt, ...)						\
+	cbdt_err(cache->cbdt, "cache%d: " fmt,					\
+		 cache->cache_id, ##__VA_ARGS__)
+#define cbd_cache_info(cache, fmt, ...)						\
+	cbdt_info(cache->cbdt, "cache%d: " fmt,					\
+		 cache->cache_id, ##__VA_ARGS__)
+#define cbd_cache_debug(cache, fmt, ...)					\
+	cbdt_debug(cache->cbdt, "cache%d: " fmt,				\
+		 cache->cache_id, ##__VA_ARGS__)
+
+#define CBD_KB	(1024)
+#define CBD_MB	(CBD_KB * CBD_KB)
+
+#define CBD_TRANSPORT_MAX	1024
+#define CBD_PATH_LEN	512
+#define CBD_NAME_LEN	32
+
+#define CBD_QUEUES_MAX		128
+
+#define CBD_PART_SHIFT 4
+#define CBD_DRV_NAME "cbd"
+#define CBD_DEV_NAME_LEN 32
+
+#define CBD_HB_INTERVAL		msecs_to_jiffies(5000) /* 5s */
+#define CBD_HB_TIMEOUT		(30 * 1000) /* 30s */
+
+/*
+ * CBD transport layout:
+ *
+ *	+-------------------------------------------------------------------------------------------------------------------------------+
+ *	|                           cbd transport                                                                                       |
+ *	+--------------------+-----------------------+-----------------------+----------------------+-----------------------------------+
+ *	|                    |       hosts           |      backends         |       blkdevs        |        channels                   |
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
+#define CBDT_SEG_SIZE		(16 * 1024 * 1024)
+
+/* cbd channel seg */
+#define CBDC_META_SIZE		(4 * 1024 * 1024)
+#define CBDC_SUBMR_RESERVED	sizeof(struct cbd_se)
+#define CBDC_CMPR_RESERVED	sizeof(struct cbd_ce)
+
+#define CBDC_DATA_ALIGH		4096
+#define CBDC_DATA_RESERVED	CBDC_DATA_ALIGH
+
+#define CBDC_CTRL_OFF		0
+#define CBDC_CTRL_SIZE		PAGE_SIZE
+#define CBDC_COMPR_OFF		(CBDC_CTRL_OFF + CBDC_CTRL_SIZE)
+#define CBDC_COMPR_SIZE		(sizeof(struct cbd_ce) * 1024)
+#define CBDC_SUBMR_OFF		(CBDC_COMPR_OFF + CBDC_COMPR_SIZE)
+#define CBDC_SUBMR_SIZE		(CBDC_META_SIZE - CBDC_SUBMR_OFF)
+
+#define CBDC_DATA_OFF		CBDC_META_SIZE
+#define CBDC_DATA_SIZE		(CBDT_SEG_SIZE - CBDC_META_SIZE)
+
+#define CBDC_UPDATE_SUBMR_HEAD(head, used, size) (head = ((head % size) + used) % size)
+#define CBDC_UPDATE_SUBMR_TAIL(tail, used, size) (tail = ((tail % size) + used) % size)
+
+#define CBDC_UPDATE_COMPR_HEAD(head, used, size) (head = ((head % size) + used) % size)
+#define CBDC_UPDATE_COMPR_TAIL(tail, used, size) (tail = ((tail % size) + used) % size)
+
+/* cbd transport */
+#define CBD_TRANSPORT_MAGIC		0x65B05EFA96C596EFULL
+#define CBD_TRANSPORT_VERSION		1
+
+#define CBDT_INFO_OFF			0
+#define CBDT_INFO_SIZE			PAGE_SIZE
+
+#define CBDT_HOST_INFO_SIZE		round_up(sizeof(struct cbd_host_info), PAGE_SIZE)
+#define CBDT_BACKEND_INFO_SIZE		round_up(sizeof(struct cbd_backend_info), PAGE_SIZE)
+#define CBDT_BLKDEV_INFO_SIZE		round_up(sizeof(struct cbd_blkdev_info), PAGE_SIZE)
+
+#define CBD_TRASNPORT_SIZE_MIN		(512 * 1024 * 1024)
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
+	struct cbd_## OBJ ##_info *OBJ##_info;		\
+};							\
+							\
+struct cbd_## OBJ ##s_device {				\
+	struct device OBJ ##s_dev;			\
+	struct cbd_## OBJ ##_device OBJ ##_devs[];	\
+}
+
+/* cbd_worker_cfg*/
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
+	/* init cbd_worker_cfg with default values */
+	cfg->busy_retry_cur = 0;
+	cfg->busy_retry_count = 100;
+	cfg->busy_retry_max = cfg->busy_retry_count * 2;
+	cfg->busy_retry_min = 0;
+	cfg->busy_retry_interval = 1;			/* 1us */
+}
+
+/* reset retry_cur and increase busy_retry_count */
+static inline void cbdwc_hit(struct cbd_worker_cfg *cfg)
+{
+	u32 delta;
+
+	cfg->busy_retry_cur = 0;
+
+	if (cfg->busy_retry_count == cfg->busy_retry_max)
+		return;
+
+	/* retry_count increase by 1/16 */
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
+/* reset retry_cur and decrease busy_retry_count */
+static inline void cbdwc_miss(struct cbd_worker_cfg *cfg)
+{
+	u32 delta;
+
+	cfg->busy_retry_cur = 0;
+
+	if (cfg->busy_retry_count == cfg->busy_retry_min)
+		return;
+
+	/* retry_count decrease by 1/16 */
+	delta = cfg->busy_retry_count >> 4;
+	if (!delta)
+		delta = cfg->busy_retry_count;
+
+	cfg->busy_retry_count -= delta;
+}
+
+static inline bool cbdwc_need_retry(struct cbd_worker_cfg *cfg)
+{
+	if (++cfg->busy_retry_cur < cfg->busy_retry_count) {
+		cpu_relax();
+		fsleep(cfg->busy_retry_interval);
+		return true;
+	}
+
+	return false;
+}
+
+/* cbd_transport */
+#define CBDT_INFO_F_BIGENDIAN		(1 << 0)
+#define CBDT_INFO_F_CRC			(1 << 1)
+
+#ifdef CONFIG_CBD_MULTIHOST
+#define CBDT_HOSTS_MAX			16
+#else
+#define CBDT_HOSTS_MAX			1
+#endif /*CONFIG_CBD_MULTIHOST*/
+
+struct cbd_transport_info {
+	__le64 magic;
+	__le16 version;
+	__le16 flags;
+
+	u32 hosts_registered;
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
+	struct cbd_transport_info *transport_info;
+
+	struct cbd_host *host;
+	struct list_head backends;
+	struct list_head devices;
+
+	struct cbd_hosts_device *cbd_hosts_dev;
+	struct cbd_segments_device *cbd_segments_dev;
+	struct cbd_backends_device *cbd_backends_dev;
+	struct cbd_blkdevs_device *cbd_blkdevs_dev;
+
+	struct dax_device *dax_dev;
+	struct file *bdev_file;
+};
+
+struct cbdt_register_options {
+	char hostname[CBD_NAME_LEN];
+	char path[CBD_PATH_LEN];
+	u16 format:1;
+	u16 force:1;
+	u16 unused:15;
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
+struct cbd_host_info *cbdt_get_host_info(struct cbd_transport *cbdt, u32 id);
+struct cbd_backend_info *cbdt_get_backend_info(struct cbd_transport *cbdt, u32 id);
+struct cbd_blkdev_info *cbdt_get_blkdev_info(struct cbd_transport *cbdt, u32 id);
+struct cbd_segment_info *cbdt_get_segment_info(struct cbd_transport *cbdt, u32 id);
+static inline struct cbd_channel_info *cbdt_get_channel_info(struct cbd_transport *cbdt, u32 id)
+{
+	return (struct cbd_channel_info *)cbdt_get_segment_info(cbdt, id);
+}
+
+int cbdt_get_empty_host_id(struct cbd_transport *cbdt, u32 *id);
+int cbdt_get_empty_backend_id(struct cbd_transport *cbdt, u32 *id);
+int cbdt_get_empty_blkdev_id(struct cbd_transport *cbdt, u32 *id);
+int cbdt_get_empty_segment_id(struct cbd_transport *cbdt, u32 *id);
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
+
+/* cbd_host */
+CBD_DEVICE(host);
+
+enum cbd_host_state {
+	cbd_host_state_none	= 0,
+	cbd_host_state_running,
+	cbd_host_state_removing
+};
+
+struct cbd_host_info {
+	u8	state;
+	u64	alive_ts;
+	char	hostname[CBD_NAME_LEN];
+};
+
+struct cbd_host {
+	u32			host_id;
+	struct cbd_transport	*cbdt;
+
+	struct cbd_host_device	*dev;
+	struct cbd_host_info	*host_info;
+	struct delayed_work	hb_work; /* heartbeat work */
+};
+
+int cbd_host_register(struct cbd_transport *cbdt, char *hostname);
+int cbd_host_unregister(struct cbd_transport *cbdt);
+int cbd_host_clear(struct cbd_transport *cbdt, u32 host_id);
+bool cbd_host_info_is_alive(struct cbd_host_info *info);
+
+/* cbd_segment */
+CBD_DEVICE(segment);
+
+enum cbd_segment_state {
+	cbd_segment_state_none		= 0,
+	cbd_segment_state_running,
+	cbd_segment_state_removing
+};
+
+enum cbd_seg_type {
+	cbds_type_none = 0,
+	cbds_type_channel,
+	cbds_type_cache
+};
+
+static inline const char *cbds_type_str(enum cbd_seg_type type)
+{
+	if (type == cbds_type_channel)
+		return "channel";
+	else if (type == cbds_type_cache)
+		return "cache";
+
+	return "Unknown";
+}
+
+struct cbd_segment_info {
+	u8 state;
+	u8 type;
+	u8 ref;
+	u32 next_seg;
+	u64 alive_ts;
+};
+
+struct cbd_seg_pos {
+	struct cbd_segment *segment;
+	u32 off;
+};
+
+struct cbd_seg_ops {
+	void (*sanitize_pos)(struct cbd_seg_pos *pos);
+};
+
+struct cbds_init_options {
+	u32 seg_id;
+	enum cbd_seg_type type;
+	u32 data_off;
+	struct cbd_seg_ops *seg_ops;
+	void *priv_data;
+};
+
+struct cbd_segment {
+	struct cbd_transport		*cbdt;
+	struct cbd_segment		*next;
+
+	u32				seg_id;
+	struct cbd_segment_info		*segment_info;
+	struct cbd_seg_ops		*seg_ops;
+
+	void				*data;
+	u32				data_size;
+
+	void				*priv_data;
+
+	struct delayed_work		hb_work; /* heartbeat work */
+};
+
+int cbd_segment_clear(struct cbd_transport *cbdt, u32 segment_id);
+void cbd_segment_init(struct cbd_transport *cbdt, struct cbd_segment *segment,
+		      struct cbds_init_options *options);
+void cbd_segment_exit(struct cbd_segment *segment);
+bool cbd_segment_info_is_alive(struct cbd_segment_info *info);
+void cbds_copy_to_bio(struct cbd_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+void cbds_copy_from_bio(struct cbd_segment *segment,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+u32 cbd_seg_crc(struct cbd_segment *segment, u32 data_off, u32 data_len);
+int cbds_map_pages(struct cbd_segment *segment, struct cbd_backend_io *io);
+int cbds_pos_advance(struct cbd_seg_pos *seg_pos, u32 len);
+void cbds_copy_data(struct cbd_seg_pos *dst_pos,
+		struct cbd_seg_pos *src_pos, u32 len);
+
+/* cbd_channel */
+
+enum cbdc_blkdev_state {
+	cbdc_blkdev_state_none		= 0,
+	cbdc_blkdev_state_running,
+	cbdc_blkdev_state_stopped,
+};
+
+enum cbdc_backend_state {
+	cbdc_backend_state_none		= 0,
+	cbdc_backend_state_running,
+	cbdc_backend_state_stopped,
+};
+
+struct cbd_channel_info {
+	struct cbd_segment_info seg_info;	/* must be the first member */
+	u8	blkdev_state;
+	u32	blkdev_id;
+
+	u8	backend_state;
+	u32	backend_id;
+
+	u32	polling:1;
+
+	u32	submr_head;
+	u32	submr_tail;
+
+	u32	compr_head;
+	u32	compr_tail;
+};
+
+struct cbd_channel {
+	u32				seg_id;
+	struct cbd_segment		segment;
+
+	struct cbd_channel_info		*channel_info;
+
+	struct cbd_transport		*cbdt;
+
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
+void cbd_channel_init(struct cbd_channel *channel, struct cbd_transport *cbdt, u32 seg_id);
+void cbd_channel_exit(struct cbd_channel *channel);
+void cbdc_copy_from_bio(struct cbd_channel *channel,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+void cbdc_copy_to_bio(struct cbd_channel *channel,
+		u32 data_off, u32 data_len, struct bio *bio, u32 bio_off);
+u32 cbd_channel_crc(struct cbd_channel *channel, u32 data_off, u32 data_len);
+int cbdc_map_pages(struct cbd_channel *channel, struct cbd_backend_io *io);
+int cbd_get_empty_channel_id(struct cbd_transport *cbdt, u32 *id);
+ssize_t cbd_channel_seg_detail_show(struct cbd_channel_info *channel_info, char *buf);
+
+/* cbd cache */
+struct cbd_cache_seg_info {
+	struct cbd_segment_info segment_info;	/* first member */
+	u32 flags;
+	u32 next_cache_seg_id;		/* index in cache->segments */
+	u64 gen;
+};
+
+#define CBD_CACHE_SEG_FLAGS_HAS_NEXT	(1 << 0)
+#define CBD_CACHE_SEG_FLAGS_WB_DONE	(1 << 1)
+#define CBD_CACHE_SEG_FLAGS_GC_DONE	(1 << 2)
+
+enum cbd_cache_blkdev_state {
+	cbd_cache_blkdev_state_none = 0,
+	cbd_cache_blkdev_state_running,
+	cbd_cache_blkdev_state_removing
+};
+
+struct cbd_cache_segment {
+	struct cbd_cache	*cache;
+	u32			cache_seg_id;	/* index in cache->segments */
+	u32			used;
+	spinlock_t		gen_lock;
+	struct cbd_cache_seg_info *cache_seg_info;
+	struct cbd_segment	segment;
+	atomic_t		refs;
+};
+
+struct cbd_cache_pos {
+	struct cbd_cache_segment *cache_seg;
+	u32		seg_off;
+};
+
+struct cbd_cache_pos_onmedia {
+	u32 cache_seg_id;
+	u32 seg_off;
+};
+
+struct cbd_cache_info {
+	u8	blkdev_state;
+	u32	blkdev_id;
+
+	u32	seg_id;
+	u32	n_segs;
+
+	u32	used_segs;
+	u16	gc_percent;
+
+	struct cbd_cache_pos_onmedia key_tail_pos;
+	struct cbd_cache_pos_onmedia dirty_tail_pos;
+};
+
+struct cbd_cache_tree {
+	struct rb_root			root;
+	spinlock_t			tree_lock;
+};
+
+struct cbd_cache_data_head {
+	spinlock_t			data_head_lock;
+	struct cbd_cache_pos		head_pos;
+};
+
+struct cbd_cache_key {
+	struct cbd_cache *cache;
+	struct cbd_cache_tree *cache_tree;
+	struct kref ref;
+
+	struct rb_node rb_node;
+	struct list_head list_node;
+
+	u64		off;
+	u32		len;
+	u64		flags;
+
+	struct cbd_cache_pos	cache_pos;
+
+	u64		seg_gen;
+#ifdef CONFIG_CBD_CRC
+	u32	data_crc;
+#endif
+};
+
+#define CBD_CACHE_KEY_FLAGS_EMPTY	(1 << 0)
+#define CBD_CACHE_KEY_FLAGS_CLEAN	(1 << 1)
+
+struct cbd_cache_key_onmedia {
+	u64	off;
+	u32	len;
+
+	u32	flags;
+
+	u32	cache_seg_id;
+	u32	cache_seg_off;
+
+	u64	seg_gen;
+#ifdef CONFIG_CBD_CRC
+	u32	data_crc;
+#endif
+};
+
+struct cbd_cache_kset_onmedia {
+	u32	crc;
+	u64	magic;
+	u64	flags;
+	u32	key_num;
+	struct cbd_cache_key_onmedia	data[];
+};
+
+#define CBD_KSET_FLAGS_LAST	(1 << 0)
+
+#define CBD_KSET_MAGIC		0x676894a64e164f1aULL
+
+struct cbd_cache_kset {
+	struct cbd_cache		*cache;
+	spinlock_t			kset_lock;
+	struct delayed_work		flush_work;
+	struct cbd_cache_kset_onmedia	kset_onmedia;
+};
+
+enum cbd_cache_state {
+	cbd_cache_state_none = 0,
+	cbd_cache_state_running,
+	cbd_cache_state_stopping
+};
+
+struct cbd_cache {
+	struct cbd_transport		*cbdt;
+	struct cbd_cache_info		*cache_info;
+	u32				cache_id;	/* same with related backend->backend_id */
+
+	u32				n_heads;
+	struct cbd_cache_data_head	*data_heads;
+
+	spinlock_t			key_head_lock;
+	struct cbd_cache_pos		key_head;
+	u32				n_ksets;
+	struct cbd_cache_kset		*ksets;
+
+	struct cbd_cache_pos		key_tail;
+	struct cbd_cache_pos		dirty_tail;
+
+	struct kmem_cache		*key_cache;
+	u32				n_trees;
+	struct cbd_cache_tree		*cache_trees;
+	struct work_struct		clean_work;
+
+	spinlock_t			miss_read_reqs_lock;
+	struct list_head		miss_read_reqs;
+	struct work_struct		miss_read_end_work;
+
+	struct workqueue_struct		*cache_wq;
+
+	struct file			*bdev_file;
+	u64				dev_size;
+	struct delayed_work		writeback_work;
+	struct delayed_work		gc_work;
+	struct bio_set			*bioset;
+
+	struct kmem_cache		*req_cache;
+
+	u32				state:8;
+	u32				init_keys:1;
+	u32				start_writeback:1;
+	u32				start_gc:1;
+
+	u32				n_segs;
+	unsigned long			*seg_map;
+	u32				last_cache_seg;
+	spinlock_t			seg_map_lock;
+	struct cbd_cache_segment	segments[]; /* should be the last member */
+};
+
+struct cbd_request;
+struct cbd_cache_opts {
+	struct cbd_cache_info *cache_info;
+	bool alloc_segs;
+	bool start_writeback;
+	bool start_gc;
+	bool init_keys;
+	u64 dev_size;
+	u32 n_paral;
+	struct file *bdev_file;	/* needed for start_writeback is true */
+};
+
+struct cbd_cache *cbd_cache_alloc(struct cbd_transport *cbdt,
+				  struct cbd_cache_opts *opts);
+void cbd_cache_destroy(struct cbd_cache *cache);
+int cbd_cache_handle_req(struct cbd_cache *cache, struct cbd_request *cbd_req);
+
+/* cbd_handler */
+struct cbd_handler {
+	struct cbd_backend	*cbdb;
+	struct cbd_channel_info *channel_info;
+
+	struct cbd_channel	channel;
+	spinlock_t		compr_lock;
+
+	u32			se_to_handle;
+	u64			req_tid_expected;
+
+	u32			polling:1;
+
+	struct delayed_work	handle_work;
+	struct cbd_worker_cfg	handle_worker_cfg;
+
+	struct hlist_node	hash_node;
+	struct bio_set		bioset;
+};
+
+void cbd_handler_destroy(struct cbd_handler *handler);
+int cbd_handler_create(struct cbd_backend *cbdb, u32 seg_id);
+void cbd_handler_notify(struct cbd_handler *handler);
+
+/* cbd_backend */
+CBD_DEVICE(backend);
+
+enum cbd_backend_state {
+	cbd_backend_state_none	= 0,
+	cbd_backend_state_running,
+	cbd_backend_state_removing
+};
+
+#define CBDB_BLKDEV_COUNT_MAX	1
+
+struct cbd_backend_info {
+	u8			state;
+	u32			host_id;
+	u32			blkdev_count;
+	u64			alive_ts;
+	u64			dev_size; /* nr_sectors */
+	struct cbd_cache_info	cache_info;
+
+	char			path[CBD_PATH_LEN];
+};
+
+struct cbd_backend_io {
+	struct cbd_se		*se;
+	u64			off;
+	u32			len;
+	struct bio		*bio;
+	struct cbd_handler	*handler;
+};
+
+#define CBD_BACKENDS_HANDLER_BITS	7
+
+struct cbd_backend {
+	u32			backend_id;
+	char			path[CBD_PATH_LEN];
+	struct cbd_transport	*cbdt;
+	struct cbd_backend_info *backend_info;
+	spinlock_t		lock;
+
+	struct block_device	*bdev;
+	struct file		*bdev_file;
+
+	struct workqueue_struct	*task_wq;
+	struct delayed_work	state_work;
+	struct delayed_work	hb_work; /* heartbeat work */
+
+	struct list_head	node; /* cbd_transport->backends */
+	DECLARE_HASHTABLE(handlers_hash, CBD_BACKENDS_HANDLER_BITS);
+
+	struct cbd_backend_device *backend_device;
+
+	struct kmem_cache	*backend_io_cache;
+
+	struct cbd_cache	*cbd_cache;
+	struct device		cache_dev;
+	bool			cache_dev_registered;
+};
+
+int cbd_backend_start(struct cbd_transport *cbdt, char *path, u32 backend_id, u32 cache_segs);
+int cbd_backend_stop(struct cbd_transport *cbdt, u32 backend_id);
+int cbd_backend_clear(struct cbd_transport *cbdt, u32 backend_id);
+int cbdb_add_handler(struct cbd_backend *cbdb, struct cbd_handler *handler);
+void cbdb_del_handler(struct cbd_backend *cbdb, struct cbd_handler *handler);
+bool cbd_backend_info_is_alive(struct cbd_backend_info *info);
+bool cbd_backend_cache_on(struct cbd_backend_info *backend_info);
+void cbd_backend_notify(struct cbd_backend *cbdb, u32 seg_id);
+
+/* cbd_queue */
+enum cbd_op {
+	CBD_OP_WRITE = 0,
+	CBD_OP_READ,
+	CBD_OP_FLUSH,
+};
+
+struct cbd_se {
+#ifdef CONFIG_CBD_CRC
+	u32			se_crc;		/* should be the first member */
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
+#ifdef CONFIG_CBD_CRC
+	u32		ce_crc;		/* should be the first member */
+	u32		data_crc;
+#endif
+	u64		req_tid;
+	u32		result;
+	u32		flags;
+};
+
+#ifdef CONFIG_CBD_CRC
+static inline u32 cbd_se_crc(struct cbd_se *se)
+{
+	return crc32(0, (void *)se + 4, sizeof(*se) - 4);
+}
+
+static inline u32 cbd_ce_crc(struct cbd_ce *ce)
+{
+	return crc32(0, (void *)ce + 4, sizeof(*ce) - 4);
+}
+#endif
+
+struct cbd_request {
+	struct cbd_queue	*cbdq;
+
+	struct cbd_se		*se;
+	struct cbd_ce		*ce;
+	struct request		*req;
+
+	u64			off;
+	struct bio		*bio;
+	u32			bio_off;
+	spinlock_t		lock; /* race between cache and complete_work to access bio */
+
+	enum cbd_op		op;
+	u64			req_tid;
+	struct list_head	inflight_reqs_node;
+
+	u32			data_off;
+	u32			data_len;
+
+	struct work_struct	work;
+
+	struct kref		ref;
+	int			ret;
+	struct cbd_request	*parent;
+
+	void			*priv_data;
+	void (*end_req)(struct cbd_request *cbd_req, void *priv_data);
+};
+
+struct cbd_cache_req {
+	struct cbd_cache	*cache;
+	enum cbd_op		op;
+	struct work_struct	work;
+};
+
+#define CBD_SE_FLAGS_DONE	1
+
+static inline bool cbd_se_flags_test(struct cbd_se *se, u32 bit)
+{
+	return (se->flags & bit);
+}
+
+static inline void cbd_se_flags_set(struct cbd_se *se, u32 bit)
+{
+	se->flags |= bit;
+}
+
+enum cbd_queue_state {
+	cbd_queue_state_none	= 0,
+	cbd_queue_state_running,
+	cbd_queue_state_removing
+};
+
+struct cbd_queue {
+	struct cbd_blkdev	*cbd_blkdev;
+	u32			index;
+	struct list_head	inflight_reqs;
+	spinlock_t		inflight_reqs_lock;
+	u64			req_tid;
+
+	u64			*released_extents;
+
+	struct cbd_channel_info	*channel_info;
+	struct cbd_channel	channel;
+
+	atomic_t		state;
+
+	struct delayed_work	complete_work;
+	struct cbd_worker_cfg	complete_worker_cfg;
+};
+
+int cbd_queue_start(struct cbd_queue *cbdq);
+void cbd_queue_stop(struct cbd_queue *cbdq);
+extern const struct blk_mq_ops cbd_mq_ops;
+int cbd_queue_req_to_backend(struct cbd_request *cbd_req);
+void cbd_req_get(struct cbd_request *cbd_req);
+void cbd_req_put(struct cbd_request *cbd_req, int ret);
+void cbd_queue_advance(struct cbd_queue *cbdq, struct cbd_request *cbd_req);
+
+/* cbd_blkdev */
+CBD_DEVICE(blkdev);
+
+enum cbd_blkdev_state {
+	cbd_blkdev_state_none	= 0,
+	cbd_blkdev_state_running,
+	cbd_blkdev_state_removing
+};
+
+struct cbd_blkdev_info {
+	u8	state;
+	u64	alive_ts;
+	u32	backend_id;
+	u32	host_id;
+	u32	mapped_id;
+};
+
+struct cbd_blkdev {
+	u32			blkdev_id; /* index in transport blkdev area */
+	u32			backend_id;
+	int			mapped_id; /* id in block device such as: /dev/cbd0 */
+
+	struct cbd_backend	*backend; /* reference to backend if blkdev and backend on the same host */
+
+	int			major;		/* blkdev assigned major */
+	int			minor;
+	struct gendisk		*disk;		/* blkdev's gendisk and rq */
+
+	struct mutex		lock;
+	unsigned long		open_count;	/* protected by lock */
+
+	struct list_head	node;
+	struct delayed_work	hb_work; /* heartbeat work */
+
+	/* Block layer tags. */
+	struct blk_mq_tag_set	tag_set;
+
+	uint32_t		num_queues;
+	struct cbd_queue	*queues;
+
+	u64			dev_size;
+
+	struct workqueue_struct	*task_wq;
+
+	struct cbd_blkdev_device *blkdev_dev;
+	struct cbd_blkdev_info *blkdev_info;
+
+	struct cbd_transport *cbdt;
+
+	struct cbd_cache	*cbd_cache;
+};
+
+int cbd_blkdev_init(void);
+void cbd_blkdev_exit(void);
+int cbd_blkdev_start(struct cbd_transport *cbdt, u32 backend_id, u32 queues);
+int cbd_blkdev_stop(struct cbd_transport *cbdt, u32 devid, bool force);
+int cbd_blkdev_clear(struct cbd_transport *cbdt, u32 devid);
+bool cbd_blkdev_info_is_alive(struct cbd_blkdev_info *info);
+
+extern struct workqueue_struct	*cbd_wq;
+
+#define cbd_setup_device(DEV, PARENT, TYPE, fmt, ...)		\
+do {								\
+	device_initialize(DEV);					\
+	device_set_pm_not_required(DEV);			\
+	dev_set_name(DEV, fmt, ##__VA_ARGS__);			\
+	DEV->parent = PARENT;					\
+	DEV->type = TYPE;					\
+								\
+	ret = device_add(DEV);					\
+} while (0)
+
+#define CBD_OBJ_HEARTBEAT(OBJ)								\
+static void OBJ##_hb_workfn(struct work_struct *work)					\
+{											\
+	struct cbd_##OBJ *obj = container_of(work, struct cbd_##OBJ, hb_work.work);	\
+	struct cbd_##OBJ##_info *info = obj->OBJ##_info;				\
+											\
+	info->alive_ts = ktime_get_real();						\
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
+static ssize_t cbd_##OBJ##_alive_show(struct device *dev,				\
+			       struct device_attribute *attr,				\
+			       char *buf)						\
+{											\
+	struct cbd_##OBJ##_device *_dev;						\
+											\
+	_dev = container_of(dev, struct cbd_##OBJ##_device, dev);			\
+											\
+	if (cbd_##OBJ##_info_is_alive(_dev->OBJ##_info))				\
+		return sprintf(buf, "true\n");						\
+											\
+	return sprintf(buf, "false\n");							\
+}											\
+											\
+static DEVICE_ATTR(alive, 0400, cbd_##OBJ##_alive_show, NULL)
+
+#endif /* _CBD_INTERNAL_H */
diff --git a/drivers/block/cbd/cbd_transport.c b/drivers/block/cbd/cbd_transport.c
new file mode 100644
index 000000000000..30dc4cd6c77a
--- /dev/null
+++ b/drivers/block/cbd/cbd_transport.c
@@ -0,0 +1,957 @@
+#include <linux/pfn_t.h>
+#include "cbd_internal.h"
+
+#define CBDT_OBJ(OBJ, OBJ_SIZE)							\
+extern struct device_type cbd_##OBJ##_type;					\
+extern struct device_type cbd_##OBJ##s_type;					\
+										\
+static int cbd_##OBJ##s_init(struct cbd_transport *cbdt)			\
+{										\
+	struct cbd_##OBJ##s_device *devs;					\
+	struct cbd_##OBJ##_device *cbd_dev;					\
+	struct device *dev;							\
+	int i;									\
+	int ret;								\
+										\
+	u32 memsize = struct_size(devs, OBJ##_devs,				\
+			cbdt->transport_info->OBJ##_num);			\
+	devs = kzalloc(memsize, GFP_KERNEL);					\
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
+	for (i = 0; i < cbdt->transport_info->OBJ##_num; i++) {			\
+		cbd_dev = &devs->OBJ##_devs[i];					\
+		dev = &cbd_dev->dev;						\
+										\
+		cbd_dev->cbdt = cbdt;						\
+		cbd_dev->OBJ##_info = cbdt_get_##OBJ##_info(cbdt, i);		\
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
+		device_del(dev);						\
+	}									\
+devs_free:									\
+	kfree(devs);								\
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
+	for (i = 0; i < cbdt->transport_info->OBJ##_num; i++) {			\
+		struct cbd_##OBJ##_device *cbd_dev = &devs->OBJ##_devs[i];	\
+		dev = &cbd_dev->dev;						\
+										\
+		device_del(dev);						\
+	}									\
+										\
+	device_del(&devs->OBJ##s_dev);						\
+										\
+	kfree(devs);								\
+	cbdt->cbd_##OBJ##s_dev = NULL;						\
+										\
+	return;									\
+}										\
+										\
+static inline struct cbd_##OBJ##_info						\
+*__get_##OBJ##_info(struct cbd_transport *cbdt, u32 id)				\
+{										\
+	struct cbd_transport_info *info = cbdt->transport_info;			\
+	void *start = cbdt->transport_info;					\
+										\
+	start += info->OBJ##_area_off;						\
+										\
+	return start + ((u64)info->OBJ_SIZE * id);				\
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
+	struct cbd_transport_info *info = cbdt->transport_info;			\
+	struct cbd_##OBJ##_info *_info;						\
+	int ret = 0;								\
+	int i;									\
+										\
+	mutex_lock(&cbdt->lock);						\
+	for (i = 0; i < info->OBJ##_num; i++) {					\
+		_info = __get_##OBJ##_info(cbdt, i);				\
+		if (_info->state == cbd_##OBJ##_state_none) {			\
+			cbdt_zero_range(cbdt, _info, info->OBJ_SIZE);			\
+			*id = i;						\
+			goto out;						\
+		}								\
+	}									\
+										\
+	cbdt_err(cbdt, "No available " #OBJ "_id found.");			\
+	ret = -ENOENT;								\
+out:										\
+	mutex_unlock(&cbdt->lock);						\
+										\
+	return ret;								\
+}
+
+CBDT_OBJ(host, host_info_size);
+CBDT_OBJ(backend, backend_info_size);
+CBDT_OBJ(blkdev, blkdev_info_size);
+CBDT_OBJ(segment, segment_size);
+
+static struct cbd_transport *cbd_transports[CBD_TRANSPORT_MAX];
+static DEFINE_IDA(cbd_transport_id_ida);
+static DEFINE_MUTEX(cbd_transport_mutex);
+
+extern struct bus_type cbd_bus_type;
+extern struct device cbd_root_dev;
+
+static ssize_t cbd_myhost_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
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
+
+static DEVICE_ATTR(my_host_id, 0400, cbd_myhost_show, NULL);
+
+enum {
+	CBDT_ADM_OPT_ERR		= 0,
+	CBDT_ADM_OPT_OP,
+	CBDT_ADM_OPT_FORCE,
+	CBDT_ADM_OPT_PATH,
+	CBDT_ADM_OPT_BID,
+	CBDT_ADM_OPT_DID,
+	CBDT_ADM_OPT_QUEUES,
+	CBDT_ADM_OPT_HID,
+	CBDT_ADM_OPT_SID,
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
+	CBDT_ADM_OP_S_CLEAR,
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
+	[CBDT_ADM_OP_S_CLEAR] = "segment-clear",
+};
+
+static const match_table_t adm_opt_tokens = {
+	{ CBDT_ADM_OPT_OP,		"op=%s"	},
+	{ CBDT_ADM_OPT_FORCE,		"force=%u" },
+	{ CBDT_ADM_OPT_PATH,		"path=%s" },
+	{ CBDT_ADM_OPT_BID,		"backend_id=%u" },
+	{ CBDT_ADM_OPT_DID,		"dev_id=%u" },
+	{ CBDT_ADM_OPT_QUEUES,		"queues=%u" },
+	{ CBDT_ADM_OPT_HID,		"host_id=%u" },
+	{ CBDT_ADM_OPT_SID,		"segment_id=%u" },
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
+				break;
+			}
+			opts->op = ret;
+			break;
+		case CBDT_ADM_OPT_PATH:
+			if (match_strlcpy(opts->backend.path, &args[0],
+				CBD_PATH_LEN) == 0) {
+				ret = -EINVAL;
+				break;
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
+			opts->backend_id = token;
+			break;
+		case CBDT_ADM_OPT_DID:
+			if (match_uint(args, &token)) {
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
+			opts->blkdev.queues = token;
+			break;
+		case CBDT_ADM_OPT_HID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->host.hid = token;
+			break;
+		case CBDT_ADM_OPT_SID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->segment.sid = token;
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
+void cbdt_zero_range(struct cbd_transport *cbdt, void *pos, u32 size)
+{
+	memset(pos, 0, size);
+}
+
+static void segments_format(struct cbd_transport *cbdt)
+{
+	u32 i;
+	struct cbd_segment_info *seg_info;
+
+	for (i = 0; i < cbdt->transport_info->segment_num; i++) {
+		seg_info = cbdt_get_segment_info(cbdt, i);
+		cbdt_zero_range(cbdt, seg_info, sizeof(struct cbd_segment_info));
+	}
+}
+
+static int cbd_transport_format(struct cbd_transport *cbdt, bool force)
+{
+	struct cbd_transport_info *info = cbdt->transport_info;
+	u64 transport_dev_size;
+	u32 seg_size;
+	u32 nr_segs;
+	u64 magic;
+	u16 flags = 0;
+
+	magic = le64_to_cpu(info->magic);
+	if (magic && !force)
+		return -EEXIST;
+
+	transport_dev_size = bdev_nr_bytes(file_bdev(cbdt->bdev_file));
+	if (transport_dev_size < CBD_TRASNPORT_SIZE_MIN) {
+		cbdt_err(cbdt, "dax device is too small, required at least %u",
+				CBD_TRASNPORT_SIZE_MIN);
+		return -ENOSPC;
+	}
+
+	memset(info, 0, sizeof(*info));
+
+	info->magic = cpu_to_le64(CBD_TRANSPORT_MAGIC);
+	info->version = cpu_to_le16(CBD_TRANSPORT_VERSION);
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
+	flags |= CBDT_INFO_F_BIGENDIAN;
+#endif
+#ifdef CONFIG_CBD_CRC
+	flags |= CBDT_INFO_F_CRC;
+#endif
+	info->flags = cpu_to_le16(flags);
+
+	info->hosts_registered = 0;
+	/*
+	 * Try to fully utilize all available space,
+	 * assuming host:blkdev:backend:segment = 1:1:1:1
+	 */
+	seg_size = (CBDT_HOST_INFO_SIZE + CBDT_BACKEND_INFO_SIZE +
+			CBDT_BLKDEV_INFO_SIZE + CBDT_SEG_SIZE);
+	nr_segs = (transport_dev_size - CBDT_INFO_SIZE) / seg_size;
+
+	info->host_area_off = CBDT_INFO_OFF + CBDT_INFO_SIZE;
+	info->host_info_size = CBDT_HOST_INFO_SIZE;
+	info->host_num = nr_segs;
+
+	info->backend_area_off = info->host_area_off + (info->host_info_size * info->host_num);
+	info->backend_info_size = CBDT_BACKEND_INFO_SIZE;
+	info->backend_num = nr_segs;
+
+	info->blkdev_area_off = info->backend_area_off + (info->backend_info_size * info->backend_num);
+	info->blkdev_info_size = CBDT_BLKDEV_INFO_SIZE;
+	info->blkdev_num = nr_segs;
+
+	info->segment_area_off = info->blkdev_area_off + (info->blkdev_info_size * info->blkdev_num);
+	info->segment_size = CBDT_SEG_SIZE;
+	info->segment_num = nr_segs;
+
+	cbdt_zero_range(cbdt, (void *)info + info->host_area_off,
+			     info->segment_area_off - info->host_area_off);
+
+	segments_format(cbdt);
+
+	return 0;
+}
+
+/*
+ * Any transport metadata allocation or reclaim should be in the
+ * control operation rutine
+ *
+ * All transport space allocation and deallocation should occur within the control flow,
+ * specifically within `adm_store()`, so that all transport space allocation
+ * and deallocation are managed within this function. This prevents other processes
+ * from involving transport space allocation and deallocation. By making `adm_store`
+ * exclusive, we can manage space effectively. For a single-host scenario, `adm_lock`
+ * can ensure mutual exclusion of `adm_store`. However, in a multi-host scenario,
+ * we need a distributed lock to guarantee that all `adm_store` calls are mutually exclusive.
+ *
+ * TODO: Is there a way to lock the CXL shared memory device?
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
+					cbdt->transport_info->segment_size / CBD_MB);
+
+		ret = cbd_backend_start(cbdt, opts.backend.path, opts.backend_id, cache_segs);
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
+		ret = cbd_blkdev_stop(cbdt, opts.blkdev.devid, opts.force);
+		break;
+	case CBDT_ADM_OP_DEV_CLEAR:
+		ret = cbd_blkdev_clear(cbdt, opts.blkdev.devid);
+		break;
+	case CBDT_ADM_OP_H_CLEAR:
+		ret = cbd_host_clear(cbdt, opts.host.hid);
+		break;
+	case CBDT_ADM_OP_S_CLEAR:
+		ret = cbd_segment_clear(cbdt, opts.segment.sid);
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
+static ssize_t cbd_transport_info(struct cbd_transport *cbdt, char *buf)
+{
+	struct cbd_transport_info *info = cbdt->transport_info;
+	ssize_t ret;
+
+	mutex_lock(&cbdt->lock);
+	info = cbdt->transport_info;
+	mutex_unlock(&cbdt->lock);
+
+	ret = sprintf(buf, "magic: 0x%llx\n"
+			"version: %u\n"
+			"flags: %x\n\n"
+			"hosts_registered: %u\n"
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
+			info->hosts_registered,
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
+static ssize_t cbd_info_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_transport *cbdt;
+
+	cbdt = container_of(dev, struct cbd_transport, device);
+
+	return cbd_transport_info(cbdt, buf);
+}
+static DEVICE_ATTR(info, 0400, cbd_info_show, NULL);
+
+static struct attribute *cbd_transport_attrs[] = {
+	&dev_attr_adm.attr,
+	&dev_attr_info.attr,
+	&dev_attr_my_host_id.attr,
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
+static int
+cbd_dax_notify_failure(
+	struct dax_device	*dax_devp,
+	u64			offset,
+	u64			len,
+	int			mf_flags)
+{
+
+	pr_err("%s: dax_devp %llx offset %llx len %lld mf_flags %x\n",
+	       __func__, (u64)dax_devp, (u64)offset, (u64)len, mf_flags);
+	return -EOPNOTSUPP;
+}
+
+const struct dax_holder_operations cbd_dax_holder_ops = {
+	.notify_failure		= cbd_dax_notify_failure,
+};
+
+static struct cbd_transport *cbdt_alloc(void)
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
+		goto cbdt_free;
+
+	cbdt->id = ret;
+	cbd_transports[cbdt->id] = cbdt;
+
+	return cbdt;
+
+cbdt_free:
+	kfree(cbdt);
+	return NULL;
+}
+
+static void cbdt_destroy(struct cbd_transport *cbdt)
+{
+	cbd_transports[cbdt->id] = NULL;
+	ida_simple_remove(&cbd_transport_id_ida, cbdt->id);
+	kfree(cbdt);
+}
+
+static int cbdt_dax_init(struct cbd_transport *cbdt, char *path)
+{
+	struct dax_device *dax_dev = NULL;
+	struct file *bdev_file = NULL;
+	long access_size;
+	void *kaddr;
+	u64 start_off = 0;
+	int ret;
+	int id;
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
+		dax_read_unlock(id);
+		ret = -EINVAL;
+		goto dax_put;
+	}
+
+	cbdt->bdev_file = bdev_file;
+	cbdt->dax_dev = dax_dev;
+	cbdt->transport_info = (struct cbd_transport_info *)kaddr;
+	dax_read_unlock(id);
+
+	return 0;
+
+dax_put:
+	fs_put_dax(dax_dev, cbdt);
+fput:
+	fput(bdev_file);
+err:
+	return ret;
+}
+
+static void cbdt_dax_release(struct cbd_transport *cbdt)
+{
+	if (cbdt->dax_dev)
+		fs_put_dax(cbdt->dax_dev, cbdt);
+
+	if (cbdt->bdev_file)
+		fput(cbdt->bdev_file);
+}
+
+static int cbd_transport_init(struct cbd_transport *cbdt)
+{
+	struct device *dev;
+
+	dev = &cbdt->device;
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->bus = &cbd_bus_type;
+	dev->type = &cbd_transport_type;
+	dev->parent = &cbd_root_dev;
+
+	dev_set_name(&cbdt->device, "transport%d", cbdt->id);
+
+	return device_add(&cbdt->device);
+}
+
+
+static int cbdt_validate(struct cbd_transport *cbdt)
+{
+	u16 flags;
+
+	if (le64_to_cpu(cbdt->transport_info->magic) != CBD_TRANSPORT_MAGIC) {
+		cbdt_err(cbdt, "unexpected magic: %llx\n",
+				le64_to_cpu(cbdt->transport_info->magic));
+		return -EINVAL;
+	}
+
+	flags = le16_to_cpu(cbdt->transport_info->flags);
+#if defined(__BYTE_ORDER) ? __BYTE_ORDER == __BIG_ENDIAN : defined(__BIG_ENDIAN)
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
+#ifndef CONFIG_CBD_CRC
+	if (flags & CBDT_INFO_F_CRC) {
+		cbdt_err(cbdt, "transport expects CBD_CRC enabled.\n");
+		return -ENOTSUPP;
+	}
+#endif
+
+	return 0;
+}
+
+int cbdt_unregister(u32 tid)
+{
+	struct cbd_transport *cbdt;
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
+	cbd_blkdevs_exit(cbdt);
+	cbd_segments_exit(cbdt);
+	cbd_backends_exit(cbdt);
+	cbd_hosts_exit(cbdt);
+
+	cbd_host_unregister(cbdt);
+	cbdt->transport_info->hosts_registered--;
+
+	device_unregister(&cbdt->device);
+	cbdt_dax_release(cbdt);
+	cbdt_destroy(cbdt);
+	module_put(THIS_MODULE);
+
+	return 0;
+}
+
+static bool cbdt_register_allowed(struct cbd_transport *cbdt)
+{
+	struct cbd_transport_info *transport_info;
+
+	transport_info = cbdt->transport_info;
+
+	if (transport_info->hosts_registered >= CBDT_HOSTS_MAX) {
+		cbdt_err(cbdt, "too many hosts registered: %u (max %u).",
+				transport_info->hosts_registered,
+				CBDT_HOSTS_MAX);
+		return false;
+	}
+
+	return true;
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
+	cbdt = cbdt_alloc();
+	if (!cbdt) {
+		ret = -ENOMEM;
+		goto module_put;
+	}
+
+	ret = cbdt_dax_init(cbdt, opts->path);
+	if (ret)
+		goto cbdt_destroy;
+
+	if (!cbdt_register_allowed(cbdt)) {
+		ret = -EINVAL;
+		goto dax_release;
+	}
+
+	if (opts->format) {
+		ret = cbd_transport_format(cbdt, opts->force);
+		if (ret < 0)
+			goto dax_release;
+	}
+
+	ret = cbdt_validate(cbdt);
+	if (ret)
+		goto dax_release;
+
+	ret = cbd_transport_init(cbdt);
+	if (ret)
+		goto dax_release;
+
+	ret = cbd_host_register(cbdt, opts->hostname);
+	if (ret)
+		goto dev_unregister;
+
+	if (cbd_hosts_init(cbdt) || cbd_backends_init(cbdt) ||
+	    cbd_segments_init(cbdt) || cbd_blkdevs_init(cbdt)) {
+		ret = -ENOMEM;
+		goto devs_exit;
+	}
+
+	cbdt->transport_info->hosts_registered++;
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
+dax_release:
+	cbdt_dax_release(cbdt);
+cbdt_destroy:
+	cbdt_destroy(cbdt);
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
-- 
2.34.1



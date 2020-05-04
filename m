Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5D1C3E4A
	for <lists+linux-bcache@lfdr.de>; Mon,  4 May 2020 17:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgEDPQ3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 May 2020 11:16:29 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:49284 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729550AbgEDPQ2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 May 2020 11:16:28 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 31EC22E09F9;
        Mon,  4 May 2020 18:16:23 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id XVeBgZvI5z-GMb8w8Td;
        Mon, 04 May 2020 18:16:23 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1588605383; bh=Iq2VGg3dTFvveTYQuhclsV+APQNyHFrGf4+XnK592M0=;
        h=In-Reply-To:Message-ID:References:Date:To:From:Subject:Cc;
        b=lcxS4A/jeKjGpAH2zpE/KLgsCdubXWIf0xpY2moLT6uEHdCorO991XYMokkzBtYc8
         TxqX3yUEe/TjvFGlZ1dEJkCQM4jGPc11frVWS0dPc3wiQvr0up+2fB36OrKTjcY9FZ
         OsU5jeMdRtHydIdfF2grVzOVOgmBa0/nqMULHCfI=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:409::1:8])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id fLmxTYRu2J-GMWmNi9H;
        Mon, 04 May 2020 18:16:22 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: [PATCH RFC 2/2] tracing/block: add request operation and flags into
 trace events
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>
Date:   Mon, 04 May 2020 18:16:21 +0300
Message-ID: <158860538157.30407.6389633238674780245.stgit@buzz>
In-Reply-To: <158860537783.30407.1084087380643625249.stgit@buzz>
References: <158860537783.30407.1084087380643625249.stgit@buzz>
User-Agent: StGit/0.22-32-g6a05
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It's hard to fit all flags into field 'rwbs' and even harder to remove
something without breaking compatibility. Let's expose all request flags
using common trace event methods: __print_symbolic and __print_flags.

This adds 32-bit 'req' field printed as req=OP,FLAGS,... by all events.
Exact constants are not part of ABI thus could be easily added/removed.

Keep 'rwbs' for backward compatibility.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 include/trace/events/block.h |  178 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 156 insertions(+), 22 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index aac9a5c0e2cc..25fff917a07f 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -11,6 +11,96 @@
 #include <linux/tracepoint.h>
 
 
+/* Request operations, see enum req_opf */
+
+TRACE_DEFINE_ENUM(REQ_OP_READ);
+TRACE_DEFINE_ENUM(REQ_OP_WRITE);
+TRACE_DEFINE_ENUM(REQ_OP_FLUSH);
+TRACE_DEFINE_ENUM(REQ_OP_DISCARD);
+TRACE_DEFINE_ENUM(REQ_OP_SECURE_ERASE);
+TRACE_DEFINE_ENUM(REQ_OP_ZONE_RESET);
+TRACE_DEFINE_ENUM(REQ_OP_WRITE_SAME);
+TRACE_DEFINE_ENUM(REQ_OP_ZONE_RESET_ALL);
+TRACE_DEFINE_ENUM(REQ_OP_WRITE_ZEROES);
+TRACE_DEFINE_ENUM(REQ_OP_ZONE_OPEN);
+TRACE_DEFINE_ENUM(REQ_OP_ZONE_CLOSE);
+TRACE_DEFINE_ENUM(REQ_OP_ZONE_FINISH);
+TRACE_DEFINE_ENUM(REQ_OP_SCSI_IN);
+TRACE_DEFINE_ENUM(REQ_OP_SCSI_OUT);
+TRACE_DEFINE_ENUM(REQ_OP_DRV_IN);
+TRACE_DEFINE_ENUM(REQ_OP_DRV_OUT);
+
+#define BLOCK_REQ_OP_STRINGS					\
+	{ REQ_OP_READ,		"READ" },			\
+	{ REQ_OP_WRITE,		"WRITE" },			\
+	{ REQ_OP_FLUSH,		"FLUSH" },			\
+	{ REQ_OP_DISCARD,	"DISCARD" },			\
+	{ REQ_OP_SECURE_ERASE,	"SECURE_ERASE" },		\
+	{ REQ_OP_ZONE_RESET,	"ZONE_RESET" },			\
+	{ REQ_OP_WRITE_SAME,	"WRITE_SAME" },			\
+	{ REQ_OP_ZONE_RESET_ALL,"ZONE_RESET_ALL" },		\
+	{ REQ_OP_WRITE_ZEROES,	"WRITE_ZEROES" },		\
+	{ REQ_OP_ZONE_OPEN,	"ZONE_OPEN" },			\
+	{ REQ_OP_ZONE_CLOSE,	"ZONE_CLOSE" },			\
+	{ REQ_OP_ZONE_FINISH,	"ZONE_FINISH" },		\
+	{ REQ_OP_SCSI_IN,	"SCSI_IN" },			\
+	{ REQ_OP_SCSI_OUT,	"SCSI_OUT" },			\
+	{ REQ_OP_DRV_IN,	"DRV_IN" },			\
+	{ REQ_OP_DRV_OUT,	"DRV_OUT" }
+
+#define show_block_req_op(req)					\
+	__print_symbolic((req) & REQ_OP_MASK, BLOCK_REQ_OP_STRINGS)
+
+
+/* Request operation flags, see enum req_flag_bits */
+
+TRACE_DEFINE_ENUM(__REQ_FAILFAST_DEV);
+TRACE_DEFINE_ENUM(__REQ_FAILFAST_TRANSPORT);
+TRACE_DEFINE_ENUM(__REQ_FAILFAST_DRIVER);
+TRACE_DEFINE_ENUM(__REQ_SYNC);
+TRACE_DEFINE_ENUM(__REQ_META);
+TRACE_DEFINE_ENUM(__REQ_PRIO);
+TRACE_DEFINE_ENUM(__REQ_NOMERGE);
+TRACE_DEFINE_ENUM(__REQ_IDLE);
+TRACE_DEFINE_ENUM(__REQ_INTEGRITY);
+TRACE_DEFINE_ENUM(__REQ_FUA);
+TRACE_DEFINE_ENUM(__REQ_PREFLUSH);
+TRACE_DEFINE_ENUM(__REQ_RAHEAD);
+TRACE_DEFINE_ENUM(__REQ_BACKGROUND);
+TRACE_DEFINE_ENUM(__REQ_NOWAIT);
+TRACE_DEFINE_ENUM(__REQ_NOWAIT_INLINE);
+TRACE_DEFINE_ENUM(__REQ_CGROUP_PUNT);
+TRACE_DEFINE_ENUM(__REQ_NOUNMAP);
+TRACE_DEFINE_ENUM(__REQ_HIPRI);
+TRACE_DEFINE_ENUM(__REQ_DRV);
+TRACE_DEFINE_ENUM(__REQ_SWAP);
+
+#define BLOCK_REQ_FLAG_STRINGS					\
+	{ REQ_FAILFAST_DEV,	"FAILFAST_DEV" },		\
+	{ REQ_FAILFAST_TRANSPORT,"FAILFAST_TRANSPORT" },	\
+	{ REQ_FAILFAST_DRIVER,	"FAILFAST_DRIVER" },		\
+	{ REQ_SYNC,		"SYNC" },			\
+	{ REQ_META,		"META" },			\
+	{ REQ_PRIO,		"PRIO" },			\
+	{ REQ_NOMERGE,		"NOMERGE" },			\
+	{ REQ_IDLE,		"IDLE" },			\
+	{ REQ_INTEGRITY,	"INTEGRITY" },			\
+	{ REQ_FUA,		"FUA" },			\
+	{ REQ_PREFLUSH,		"PREFLUSH" },			\
+	{ REQ_RAHEAD,		"RAHEAD" },			\
+	{ REQ_BACKGROUND,	"BACKGROUND" },			\
+	{ REQ_NOWAIT,		"NOWAIT" },			\
+	{ REQ_NOWAIT_INLINE,	"NOWAIT_INLINE" },		\
+	{ REQ_CGROUP_PUNT,	"CGROUP_PUNT" },		\
+	{ REQ_NOUNMAP,		"NOUNMAP" },			\
+	{ REQ_HIPRI,		"HIPRI" },			\
+	{ REQ_DRV,		"DRV" },			\
+	{ REQ_SWAP,		"SWAP" }
+
+#define show_block_req_flags(req)				\
+	__print_flags((req) & ~REQ_OP_MASK, ",", BLOCK_REQ_FLAG_STRINGS)
+
+
 DECLARE_EVENT_CLASS(block_buffer,
 
 	TP_PROTO(struct buffer_head *bh),
@@ -78,6 +168,7 @@ TRACE_EVENT(block_rq_requeue,
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
+		__field(  unsigned int,	req			)
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__array(  char,		rwbs,	BLK_RWBS_LEN	)
@@ -86,6 +177,7 @@ TRACE_EVENT(block_rq_requeue,
 
 	TP_fast_assign(
 		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->req	   = rq->cmd_flags;
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
 
@@ -93,11 +185,13 @@ TRACE_EVENT(block_rq_requeue,
 		__get_str(cmd)[0] = '\0';
 	),
 
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+	TP_printk("%d,%d %s (%s) %llu + %u [%d] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, 0)
+		  __entry->nr_sector, 0,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 /**
@@ -120,6 +214,7 @@ TRACE_EVENT(block_rq_complete,
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
+		__field(  unsigned int,	req			)
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  int,		error			)
@@ -129,6 +224,7 @@ TRACE_EVENT(block_rq_complete,
 
 	TP_fast_assign(
 		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->req	   = rq->cmd_flags;
 		__entry->sector    = blk_rq_pos(rq);
 		__entry->nr_sector = nr_bytes >> 9;
 		__entry->error     = error;
@@ -137,11 +233,13 @@ TRACE_EVENT(block_rq_complete,
 		__get_str(cmd)[0] = '\0';
 	),
 
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+	TP_printk("%d,%d %s (%s) %llu + %u [%d] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->error)
+		  __entry->nr_sector, __entry->error,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 DECLARE_EVENT_CLASS(block_rq,
@@ -152,6 +250,7 @@ DECLARE_EVENT_CLASS(block_rq,
 
 	TP_STRUCT__entry(
 		__field(  dev_t,	dev			)
+		__field(  unsigned int,	req			)
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  unsigned int,	bytes			)
@@ -162,6 +261,7 @@ DECLARE_EVENT_CLASS(block_rq,
 
 	TP_fast_assign(
 		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
+		__entry->req	   = rq->cmd_flags;
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
 		__entry->bytes     = blk_rq_bytes(rq);
@@ -171,11 +271,13 @@ DECLARE_EVENT_CLASS(block_rq,
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
+	TP_printk("%d,%d %s %u (%s) %llu + %u [%s] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __entry->bytes, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+		  __entry->nr_sector, __entry->comm,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 /**
@@ -229,6 +331,7 @@ TRACE_EVENT(block_bio_bounce,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field( unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
 		__array( char,		rwbs,	BLK_RWBS_LEN	)
@@ -237,16 +340,19 @@ TRACE_EVENT(block_bio_bounce,
 
 	TP_fast_assign(
 		__entry->dev		= bio_dev(bio);
+		__entry->req		= bio->bi_opf;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
+	TP_printk("%d,%d %s %llu + %u [%s] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+		  __entry->nr_sector, __entry->comm,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 /**
@@ -266,6 +372,7 @@ TRACE_EVENT(block_bio_complete,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field( unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( unsigned,	nr_sector		)
 		__field( int,		error			)
@@ -274,16 +381,19 @@ TRACE_EVENT(block_bio_complete,
 
 	TP_fast_assign(
 		__entry->dev		= bio_dev(bio);
+		__entry->req		= bio->bi_opf;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		__entry->error		= error;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%d]",
+	TP_printk("%d,%d %s %llu + %u [%d] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->error)
+		  __entry->nr_sector, __entry->error,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 DECLARE_EVENT_CLASS(block_bio_merge,
@@ -294,6 +404,7 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field(  unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
 		__array( char,		rwbs,	BLK_RWBS_LEN	)
@@ -302,16 +413,19 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 
 	TP_fast_assign(
 		__entry->dev		= bio_dev(bio);
+		__entry->req		= bio->bi_opf;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
+	TP_printk("%d,%d %s %llu + %u [%s] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+		  __entry->nr_sector, __entry->comm,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 /**
@@ -361,6 +475,7 @@ TRACE_EVENT(block_bio_queue,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field( unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
 		__array( char,		rwbs,	BLK_RWBS_LEN	)
@@ -369,16 +484,19 @@ TRACE_EVENT(block_bio_queue,
 
 	TP_fast_assign(
 		__entry->dev		= bio_dev(bio);
+		__entry->req		= bio->bi_opf;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
+	TP_printk("%d,%d %s %llu + %u [%s] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+		  __entry->nr_sector, __entry->comm,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 DECLARE_EVENT_CLASS(block_get_rq,
@@ -389,6 +507,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field( unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
 		__array( char,		rwbs,	BLK_RWBS_LEN	)
@@ -397,16 +516,19 @@ DECLARE_EVENT_CLASS(block_get_rq,
 
 	TP_fast_assign(
 		__entry->dev		= bio ? bio_dev(bio) : 0;
+		__entry->req		= bio ? bio->bi_opf : 0;
 		__entry->sector		= bio ? bio->bi_iter.bi_sector : 0;
 		__entry->nr_sector	= bio ? bio_sectors(bio) : 0;
 		blk_fill_rwbs(__entry->rwbs, bio ? bio->bi_opf : 0);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
         ),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
+	TP_printk("%d,%d %s %llu + %u [%s] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+		  __entry->nr_sector, __entry->comm,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 /**
@@ -523,6 +645,7 @@ TRACE_EVENT(block_split,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field( unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( sector_t,	new_sector		)
 		__array( char,		rwbs,	BLK_RWBS_LEN	)
@@ -531,17 +654,20 @@ TRACE_EVENT(block_split,
 
 	TP_fast_assign(
 		__entry->dev		= bio_dev(bio);
+		__entry->req		= bio->bi_opf;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->new_sector	= new_sector;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu / %llu [%s]",
+	TP_printk("%d,%d %s %llu / %llu [%s] req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  (unsigned long long)__entry->new_sector,
-		  __entry->comm)
+		  __entry->comm,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 /**
@@ -563,6 +689,7 @@ TRACE_EVENT(block_bio_remap,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field( unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
 		__field( dev_t,		old_dev			)
@@ -572,6 +699,7 @@ TRACE_EVENT(block_bio_remap,
 
 	TP_fast_assign(
 		__entry->dev		= bio_dev(bio);
+		__entry->req		= bio->bi_opf;
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
 		__entry->old_dev	= dev;
@@ -579,12 +707,14 @@ TRACE_EVENT(block_bio_remap,
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
 	),
 
-	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
-		  (unsigned long long)__entry->old_sector)
+		  (unsigned long long)__entry->old_sector,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 /**
@@ -607,6 +737,7 @@ TRACE_EVENT(block_rq_remap,
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
+		__field( unsigned int,	req			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
 		__field( dev_t,		old_dev			)
@@ -617,6 +748,7 @@ TRACE_EVENT(block_rq_remap,
 
 	TP_fast_assign(
 		__entry->dev		= disk_devt(rq->rq_disk);
+		__entry->req		= rq->cmd_flags;
 		__entry->sector		= blk_rq_pos(rq);
 		__entry->nr_sector	= blk_rq_sectors(rq);
 		__entry->old_dev	= dev;
@@ -625,12 +757,14 @@ TRACE_EVENT(block_rq_remap,
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
 	),
 
-	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u",
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u req=%s,%s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
-		  (unsigned long long)__entry->old_sector, __entry->nr_bios)
+		  (unsigned long long)__entry->old_sector, __entry->nr_bios,
+		  show_block_req_op(__entry->req),
+		  show_block_req_flags(__entry->req))
 );
 
 #endif /* _TRACE_BLOCK_H */


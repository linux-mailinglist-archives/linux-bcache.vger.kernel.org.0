Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFA21D5E4C
	for <lists+linux-bcache@lfdr.de>; Sat, 16 May 2020 05:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEPDzI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 May 2020 23:55:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:40718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgEPDzI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 23:55:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4AA6AC91;
        Sat, 16 May 2020 03:55:08 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com,
        hch@lst.de, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, kbusch@kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Date:   Sat, 16 May 2020 11:54:31 +0800
Message-Id: <20200516035434.82809-2-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200516035434.82809-1-colyli@suse.de>
References: <20200516035434.82809-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

For a zoned device, e.g. host managed SMR hard drive, REQ_OP_ZONE_RESET
is to reset the LBA of a zone's write pointer back to the start LBA of
this zone. After the write point is reset, all previously stored data
in this zone is invalid and unaccessible anymore. Therefore, this op
code changes on disk data, belongs to a WRITE request op code.

Current REQ_OP_ZONE_RESET is defined as number 6, but the convention of
the op code is, READ requests are even numbers, and WRITE requests are
odd numbers. See how op_is_write defined,

397 static inline bool op_is_write(unsigned int op)
398 {
399         return (op & 1);
400 }

When create bcache device on top of the zoned SMR drive, bcache driver
has to handle the REQ_OP_ZONE_RESET bio by invalidate all cached data
belongs to the LBA range of the restting zone. A wrong op code value
will make the this zone management bio goes into bcache' read requests
code path and causes undefined result.

This patch changes REQ_OP_ZONE_RESET value from 6 to 13, the new odd
number will make bcache driver handle this zone management bio properly
in write requests code path.

Fixes: 87374179c535 ("block: add a proper block layer data direction encoding")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 include/linux/blk_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 31eb92876be7..8f7bc15a6de3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -282,8 +282,6 @@ enum req_opf {
 	REQ_OP_DISCARD		= 3,
 	/* securely erase sectors */
 	REQ_OP_SECURE_ERASE	= 5,
-	/* reset a zone write pointer */
-	REQ_OP_ZONE_RESET	= 6,
 	/* write the same sector many times */
 	REQ_OP_WRITE_SAME	= 7,
 	/* reset all the zone present on the device */
@@ -296,6 +294,8 @@ enum req_opf {
 	REQ_OP_ZONE_CLOSE	= 11,
 	/* Transition a zone to full */
 	REQ_OP_ZONE_FINISH	= 12,
+	/* reset a zone write pointer */
+	REQ_OP_ZONE_RESET	= 13,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
-- 
2.25.0


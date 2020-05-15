Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA5A1D562B
	for <lists+linux-bcache@lfdr.de>; Fri, 15 May 2020 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgEOQg0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 May 2020 12:36:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:47406 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgEOQg0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 12:36:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D4FE8AD66;
        Fri, 15 May 2020 16:36:26 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com,
        hch@lst.de, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC PATCH 2/4] block: block: change REQ_OP_ZONE_RESET from 8 to 15
Date:   Sat, 16 May 2020 00:31:55 +0800
Message-Id: <20200515163157.72796-3-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200515163157.72796-1-colyli@suse.de>
References: <20200515163157.72796-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

For a zoned device, e.g. host managed SMR hard drive, the request op
REQ_OP_ZONE_RESET_ALL is to reset LBA of all zones' writer pointers to
the start LBA of the zone they belong to. After all the write pointers
are reset, all previously stored data is invalid and unaccessible.
Therefore this op code changes on-disk data, belongs to WRITE request
op code.

Similar to the problem of REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET is an
even number 8, it means bios with REQ_OP_ZONE_RESET_ALL in bio->bi_opf
will be treated as READ request by op_is_write().

Same problem will happen when bcache device is created on top of zoned
device like host managed SMR hard drive, bcache driver should invalid
all cached data for the REQ_OP_ZONE_RESET_ALL request, but this zone
management bio is mistakenly treated as READ request and go into bcache
read code path, which will cause undefined behavior.

This patch changes REQ_OP_ZONE_RESET_ALL value from 8 to 15, this new
odd number will make bcache driver handle this zone management bio in
write request code path properly.

Fixes: e84e8f066395 ("block: add req op to reset all zones and flag")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/linux/blk_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8f7bc15a6de3..618032fa1b29 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -284,8 +284,6 @@ enum req_opf {
 	REQ_OP_SECURE_ERASE	= 5,
 	/* write the same sector many times */
 	REQ_OP_WRITE_SAME	= 7,
-	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= 8,
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= 9,
 	/* Open a zone */
@@ -296,6 +294,8 @@ enum req_opf {
 	REQ_OP_ZONE_FINISH	= 12,
 	/* reset a zone write pointer */
 	REQ_OP_ZONE_RESET	= 13,
+	/* reset all the zone present on the device */
+	REQ_OP_ZONE_RESET_ALL	= 15,
 
 	/* SCSI passthrough using struct scsi_request */
 	REQ_OP_SCSI_IN		= 32,
-- 
2.25.0


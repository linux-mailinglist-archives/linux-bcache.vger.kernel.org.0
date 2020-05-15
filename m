Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8973E1D5630
	for <lists+linux-bcache@lfdr.de>; Fri, 15 May 2020 18:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgEOQgf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 May 2020 12:36:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:47524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgEOQge (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 12:36:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 049E2AD5F;
        Fri, 15 May 2020 16:36:34 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com,
        hch@lst.de, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC PATCH 4/4] block: set bi_size to REQ_OP_ZONE_RESET bio
Date:   Sat, 16 May 2020 00:31:57 +0800
Message-Id: <20200515163157.72796-5-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200515163157.72796-1-colyli@suse.de>
References: <20200515163157.72796-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now for zoned device, zone management ioctl commands are converted into
zone management bios and handled by blkdev_zone_mgmt(). There are 4 zone
management bios are handled, their op code is,
- REQ_OP_ZONE_RESET
  Reset the zone's writer pointer and empty all previously stored data.
- REQ_OP_ZONE_OPEN
  Open the zones in the specified sector range, no influence on data.
- REQ_OP_ZONE_CLOSE
  Close the zones in the specified sector range, no influence on data.
- REQ_OP_ZONE_FINISH
  Mark the zone as full, no influence on data.
All the zone management bios has 0 byte size, a.k.a their bi_size is 0.

Exept for REQ_OP_ZONE_RESET request, zero length bio works fine for
other zone management bio, before the zoned device e.g. host managed SMR
hard drive can be created as a bcache device.

When a bcache device (virtual block device to forward bios like md raid
drivers) can be created on top of the zoned device, and a fast SSD is
attached as a cache device, bcache driver may cache the frequent random
READ requests on fast SSD to accelerate hot data READ performance.

When bcache driver receives a zone management bio for REQ_OP_ZONE_RESET
op, while forwarding the request to underlying zoned device e.g. host
managed SMR hard drive, it should also invalidate all cached data from
SSD for the resetting zone. Otherwise bcache will continue provide the
outdated cached data to READ request and cause potential data storage
inconsistency and corruption.

In order to invalidate outdated data from SSD for the reset zone, bcache
needs to know not only the start LBA but also the range length of the
resetting zone. Otherwise, bcache won't be able to accurately invalidate
the outdated cached data.

Is it possible to simply set the bi_size inside bcache driver? The
answer is NO. Although every REQ_OP_ZONE_RESET bio has exact length as
zone size or q->limits.chunk_sectors, it is possible that some other
layer stacking block driver (in the future) exists between bcache driver
and blkdev_zone_mgmt() where the zone management bio is made.

The best location to set bi_size is where the zone management bio is
composed in blkdev_zone_mgmt(), then no matter how this bio is split
before bcache driver receives it, bcache driver can always correctly
invalidate the resetting range.

This patch sets the bi_size of REQ_OP_ZONE_RESET bio for each resetting
zone. Here REQ_OP_ZONE_RESET is special whose bi_size should be set as
capacity of whole drive size, then bcache can invalidate all cached data
from SSD for the zoned backing device.

With this change, now bcache code can handle REQ_OP_ZONE_RESET bio in
the way very similar to REQ_OP_DISCARD bio with very little change.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Ajay Joshi <ajay.joshi@wdc.com>
Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 1e0708c68267..01d91314399b 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -227,11 +227,15 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
 		if (op == REQ_OP_ZONE_RESET &&
 		    blkdev_allow_reset_all_zones(bdev, sector, nr_sectors)) {
 			bio->bi_opf = REQ_OP_ZONE_RESET_ALL;
+			bio->bi_iter.bi_sector = sector;
+			bio->bi_iter.bi_size = nr_sectors;
 			break;
 		}
 
 		bio->bi_opf = op | REQ_SYNC;
 		bio->bi_iter.bi_sector = sector;
+		if (op == REQ_OP_ZONE_RESET)
+			bio->bi_iter.bi_size = zone_sectors;
 		sector += zone_sectors;
 
 		/* This may take a while, so be nice to others */
-- 
2.25.0


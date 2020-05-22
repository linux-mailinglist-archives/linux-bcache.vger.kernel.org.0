Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C751DE6A8
	for <lists+linux-bcache@lfdr.de>; Fri, 22 May 2020 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729850AbgEVMS4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 22 May 2020 08:18:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:52468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728772AbgEVMS4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 May 2020 08:18:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4E77EAEF8;
        Fri, 22 May 2020 12:18:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [RFC PATCH v4 2/3] bcache: handle zone management bios for bcache device
Date:   Fri, 22 May 2020 20:18:36 +0800
Message-Id: <20200522121837.109651-3-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522121837.109651-1-colyli@suse.de>
References: <20200522121837.109651-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Fortunately the zoned device management interface is designed to use
bio operations, the bcache code just needs to do a little change to
handle the zone management bios.

Bcache driver needs to handle 5 zone management bios for now, all of
them are handled by cached_dev_nodata() since their bi_size values
are 0.
- REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE, REQ_OP_ZONE_FINISH:
    The LBA conversion is already done in cached_dev_make_request(),
  just simply send such zone management bios to backing device is
  enough.
- REQ_OP_ZONE_RESET, REQ_OP_ZONE_RESET_ALL:
    If thre is cached data (clean or dirty) on cache device covered
  by the LBA range of resetting zone(s), such cached data must be
  invalidate from the cache device before forwarding the zone reset
  bios to the backing device. Otherwise data inconsistency or further
  corruption may happen from the view of bcache device.
    The difference of REQ_OP_ZONE_RESET_ALL and REQ_OP_ZONE_RESET is
  when the zone management bio is to reset all zones, send all zones
  number reported by the bcache device (s->d->disk->queue->nr_zones)
  into bch_data_invalidate_zones() as parameter 'size_t nr_zones'. If
  only reset a single zone, just set 1 as 'size_t nr_zones'.

By supporting zone managememnt bios with this patch, now a bcache device
can be formatted by zonefs, and the zones can be reset by truncate -s 0
on the zone files under seq/ directory. Supporting REQ_OP_ZONE_RESET_ALL
makes the whole disk zones reset much faster. In my testing on a 14TB
zoned SMR hard drive, 1 by 1 resetting 51632 seq zones by sending
REQ_OP_ZONE_RESET bios takes 4m34s, by sending a single
REQ_OP_ZONE_RESET_ALL bio takes 12s, which is 22x times faster.

REQ_OP_ZONE_RESET_ALL is supported by bcache only when the backing device
supports it. So the bcache queue flag is set QUEUE_FLAG_ZONE_RESETALL on
only when queue of backing device has such flag, which can be checked by
calling blk_queue_zone_resetall() on backing device's request queue.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changelog:
v2: an improved version without any generic block layer change.
v1: initial version depends on other generic block layer changes.

 drivers/md/bcache/request.c | 99 ++++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/super.c   |  2 +
 2 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 34f63da2338d..700b8ab5dec9 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1052,18 +1052,115 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 	continue_at(cl, cached_dev_write_complete, NULL);
 }
 
+/*
+ * Invalidate the LBA range on cache device which is covered by the
+ * the resetting zones.
+ */
+static int bch_data_invalidate_zones(struct closure *cl,
+				      size_t zone_sector,
+				      size_t nr_zones)
+{
+	struct search *s = container_of(cl, struct search, cl);
+	struct data_insert_op *iop = &s->iop;
+	int max_keys, free_keys;
+	size_t start = zone_sector;
+	int ret;
+
+	max_keys = (block_bytes(iop->c) - sizeof(struct jset)) /
+		   sizeof(uint64_t);
+	bch_keylist_init(&iop->insert_keys);
+	ret = bch_keylist_realloc(&iop->insert_keys, max_keys, iop->c);
+	if (ret < 0)
+		return -ENOMEM;
+
+	while (nr_zones-- > 0) {
+		atomic_t *journal_ref = NULL;
+		size_t size = s->d->disk->queue->limits.chunk_sectors;
+more_keys:
+		bch_keylist_reset(&iop->insert_keys);
+		free_keys = max_keys;
+
+		while (size > 0 && free_keys >= 2) {
+			size_t sectors = min_t(size_t, size,
+					       1U << (KEY_SIZE_BITS - 1));
+
+			bch_keylist_add(&iop->insert_keys,
+					&KEY(iop->inode, start, sectors));
+			start += sectors;
+			size -= sectors;
+			free_keys -= 2;
+		}
+
+		/* Insert invalidate keys into btree */
+		journal_ref = bch_journal(iop->c, &iop->insert_keys, NULL);
+		if (!journal_ref) {
+			ret = -EIO;
+			break;
+		}
+
+		ret = bch_btree_insert(iop->c,
+				&iop->insert_keys, journal_ref, NULL);
+		atomic_dec_bug(journal_ref);
+		if (ret < 0)
+			break;
+
+		if (size)
+			goto more_keys;
+	}
+
+	bch_keylist_free(&iop->insert_keys);
+
+	return ret;
+}
+
 static void cached_dev_nodata(struct closure *cl)
 {
 	struct search *s = container_of(cl, struct search, cl);
 	struct bio *bio = &s->bio.bio;
+	int nr_zones = 1;
 
 	if (s->iop.flush_journal)
 		bch_journal_meta(s->iop.c, cl);
 
-	/* If it's a flush, we send the flush to the backing device too */
+	if (bio_op(bio) == REQ_OP_ZONE_RESET_ALL ||
+	    bio_op(bio) == REQ_OP_ZONE_RESET) {
+		int err = 0;
+		/*
+		 * If this is REQ_OP_ZONE_RESET_ALL bio, cached data
+		 * covered by all zones should be invalidate from the
+		 * cache device.
+		 */
+		if (bio_op(bio) == REQ_OP_ZONE_RESET_ALL)
+			nr_zones = s->d->disk->queue->nr_zones;
+
+		err = bch_data_invalidate_zones(
+			cl, bio->bi_iter.bi_sector, nr_zones);
+
+		if (err < 0) {
+			s->iop.status = errno_to_blk_status(err);
+			/* debug, should be removed before post patch */
+			bio->bi_status = BLK_STS_TIMEOUT;
+			/* set by bio_cnt_set() in do_bio_hook() */
+			bio_put(bio);
+			/*
+			 * Invalidate cached data fails, don't send
+			 * the zone reset bio to backing device and
+			 * return failure. Otherwise potential data
+			 * corruption on bcache device may happen.
+			 */
+			goto continue_bio_complete;
+		}
+
+	}
+
+	/*
+	 * For flush or zone management bios, of cause
+	 * they should be sent to backing device too.
+	 */
 	bio->bi_end_io = backing_request_endio;
 	closure_bio_submit(s->iop.c, bio, cl);
 
+continue_bio_complete:
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d5da7ad5157d..70c31950ec1b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1390,6 +1390,8 @@ static int bch_cached_dev_zone_init(struct cached_dev *dc)
 		 */
 		d_q->nr_zones = b_q->nr_zones -
 			(dc->sb.data_offset / d_q->limits.chunk_sectors);
+		if (blk_queue_zone_resetall(b_q))
+			blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, d_q);
 	}
 
 	return 0;
-- 
2.25.0


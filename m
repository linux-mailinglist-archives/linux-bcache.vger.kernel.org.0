Return-Path: <linux-bcache+bounces-678-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9C690F34E
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B178284D10
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDAA155346;
	Wed, 19 Jun 2024 15:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rM1UjcI4"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E922153BDB;
	Wed, 19 Jun 2024 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812020; cv=none; b=mpN42/b8LCmt/v4TaKFQS2kF+Bv86WG4Ui7oY2Hl5hPJMTmaISGHa/W8yzatplA/DJ11kqaAnQrfSv8YF/BQxR3QCFBVBrnxqaNLupiJQLZT4Kg0ewnUPArEUNiSKRSeJzmtsUUYmK7jnmPYtdO2w0xFnA/Be0QREUim1B+ZTgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812020; c=relaxed/simple;
	bh=dzy8FtS5ptyyjEg3F2+R5n491vJchLvqcJqx3tjkXJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn+r8XD3FnVjOE37HCkDDEYRasxVZ+b3//eSpHlxS1Qt9ZWiaalo/EIIMzLlut/u5Y6ao+ollwOsMuPWziJVLab7hbUMZJ5LSu3HKqQH6I3+Y+xoG20HIh7VdT5AxsgaBc7+DQZRQFYiUKjJk66JkMhEZAHoLoOwcldcHkNvYMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rM1UjcI4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EFmCuyU3FDXod3wDEHBU3uceajQieBgAbma/lzHzBoI=; b=rM1UjcI472M5Qyr+SCi/ILajZy
	KkHiZBQ+cnq9ftp4IrwDQYAj51jL/7/Cse/o+kIfAAajZhcJO9ASvfVY6IzVl7UBcIC9tar5VNLqq
	uCrxsHgb3iAvo4v2r3/hrkzwghhdT04M3FJ+rKd0pE7rajavf0s9SRHrfW/3atnL4eXP22PygjED/
	+dVHYnpY+zBSTEAz2K5w+rsi67zXjO3DUhbYFKxJtU8T6ZyLB7oaZuoqXehVVVy3OdQXQBczw+Aqf
	ZosZeIl0hZtNK1mJezMZ7up85kRigTc0nxaPX2BzjVNHBmeKy+mXDliUB+RHYHGT8KeZxmWonH/Ws
	J3rAi/oA==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJxWU-00000001suU-00Op;
	Wed, 19 Jun 2024 15:46:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org
Subject: [PATCH 6/6] block: move the raid_partial_stripes_expensive flag into the features field
Date: Wed, 19 Jun 2024 17:45:38 +0200
Message-ID: <20240619154623.450048-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240619154623.450048-1-hch@lst.de>
References: <20240619154623.450048-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the raid_partial_stripes_expensive flags into the features field to
reclaim a little bit of space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c      | 4 ----
 drivers/md/bcache/super.c | 4 ++--
 drivers/md/raid5.c        | 2 +-
 include/linux/blkdev.h    | 7 +++++--
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 62588d9a38e39a..008fed84edb432 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -556,10 +556,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		ret = -1;
 	}
 
-	t->raid_partial_stripes_expensive =
-		max(t->raid_partial_stripes_expensive,
-		    b->raid_partial_stripes_expensive);
-
 	/* Find lowest common alignment_offset */
 	t->alignment_offset = lcm_not_zero(t->alignment_offset, alignment)
 		% max(t->physical_block_size, t->io_min);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index baa364eedd0051..283b2511c6d21f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1416,8 +1416,8 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	}
 
 	if (bdev_io_opt(dc->bdev))
-		dc->partial_stripes_expensive =
-			q->limits.raid_partial_stripes_expensive;
+		dc->partial_stripes_expensive = q->limits.features &
+			BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
 
 	ret = bcache_device_init(&dc->disk, block_size,
 			 bdev_nr_sectors(dc->bdev) - dc->sb.data_offset,
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e875763d69917d..72f91eaa3201c4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7707,7 +7707,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	blk_set_stacking_limits(&lim);
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
-	lim.raid_partial_stripes_expensive = 1;
+	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
 	lim.discard_granularity = stripe;
 	lim.max_write_zeroes_sectors = 0;
 	mddev_stack_rdev_limits(mddev, &lim, 0);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 86410ce41bf60e..1fa2b148c20696 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -328,6 +328,9 @@ enum {
 
 	/* bounce all highmem pages */
 	BLK_FEAT_BOUNCE_HIGH			= (1u << 14),
+
+	/* undocumented magic for bcache */
+	BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE	= (1u << 15),
 };
 
 /*
@@ -335,7 +338,8 @@ enum {
  */
 #define BLK_FEAT_INHERIT_MASK \
 	(BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA | BLK_FEAT_ROTATIONAL | \
-	 BLK_FEAT_STABLE_WRITES | BLK_FEAT_ZONED | BLK_FEAT_BOUNCE_HIGH)
+	 BLK_FEAT_STABLE_WRITES | BLK_FEAT_ZONED | BLK_FEAT_BOUNCE_HIGH | \
+	 BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE)
 
 /* internal flags in queue_limits.flags */
 enum {
@@ -377,7 +381,6 @@ struct queue_limits {
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
 
-	unsigned char		raid_partial_stripes_expensive;
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
 
-- 
2.43.0



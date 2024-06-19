Return-Path: <linux-bcache+bounces-677-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C670790F34B
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63953B255F1
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF2F15533B;
	Wed, 19 Jun 2024 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f+CfUtsT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966AD15383B;
	Wed, 19 Jun 2024 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812015; cv=none; b=rnLHnYEwsBqTlAQAagjeSVh5Hj96fR1kTJgqQMcNkECk6qSaTSAkARjSSwzbzK6hNKBlWy/e+AYy2w6tlC7Q+0i7GRuwntol10lv2Sp+i9GhfoLX8+tsiU2ojyWBqwPnKBLK/9A8NclsFW/RtlJUkJ1W26CasnGgkWzyUEbmaEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812015; c=relaxed/simple;
	bh=NvMnrrKfqdRLFuy/f51opINNcaQ0mxp4/GAWN1SmY3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABeOyQF5tCRfdLaZBdw83peWQC4+Q8kZbWKDcc3sENF9gokrNmHY2DBYXkxQY0JLbhgBlTbx6mInedVHmoSn6mh5rkSQ5SMdSBoa0/wP6F+onQ1xtoEK3/rc04JaVCMH1cNd/Vy2Bsuhz69/kGqFqdoHcZmO0vZtTx4ug2+QJzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f+CfUtsT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/d3QkhJqFjvc1iUq3mULIHu2OHzRCVURh4ddxY1Aw1Q=; b=f+CfUtsTKsEjFRG7U1xJN1e//e
	FUb3PPPE2S2EcA/frAT68MDhqmP2fYfw4XqnSrYm+3pdHKiYomK4waMfJL/lK1BBwlQxMiIWBq/Zd
	QiHVoh79CaZvhi1WXzymB5AaC+hy7t79HaswschMRktWyCjyo4JDsD/sPhrS1QrfjGnMBmU5O34Pq
	LGYiDg5BkQZM0/SAMQHlP7zejRGTAHd2LcFncNmKLN0Oan2e3x+vKmWzpifdg/ZI+3+Jnkjf9Fadd
	6Lt7l4d+pBdxEengV/8BzhdSSWjUuMnHGkEn/AlWzR2MzDNQ0jl7zSd84Pyrn3fFPzBOKki5Fc0R+
	mIlBYn3g==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJxWP-00000001ssa-1Ixx;
	Wed, 19 Jun 2024 15:46:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org
Subject: [PATCH 5/6] block: remove the discard_alignment flag
Date: Wed, 19 Jun 2024 17:45:37 +0200
Message-ID: <20240619154623.450048-6-hch@lst.de>
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

queue_limits.discard_alignment is never read except in the places
where it is stacked into another limit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c         | 10 ----------
 drivers/md/dm-cache-target.c |  1 -
 drivers/md/dm-clone-target.c |  1 -
 drivers/md/dm-table.c        |  1 -
 include/linux/blkdev.h       |  1 -
 5 files changed, 14 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a1b10404e500bc..62588d9a38e39a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -578,16 +578,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	if (b->discard_granularity) {
 		alignment = queue_limit_discard_alignment(b, start);
 
-		if (t->discard_granularity != 0 &&
-		    t->discard_alignment != alignment) {
-			top = t->discard_granularity + t->discard_alignment;
-			bottom = b->discard_granularity + alignment;
-
-			/* Verify that top and bottom intervals line up */
-			if ((max(top, bottom) % min(top, bottom)) != 0)
-				t->discard_misaligned = 1;
-		}
-
 		t->max_discard_sectors = min_not_zero(t->max_discard_sectors,
 						      b->max_discard_sectors);
 		t->max_hw_discard_sectors = min_not_zero(t->max_hw_discard_sectors,
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 16884b5850532f..2d8dd9283ff4cf 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -3403,7 +3403,6 @@ static void set_discard_limits(struct cache *cache, struct queue_limits *limits)
 	limits->max_hw_discard_sectors = origin_limits->max_hw_discard_sectors;
 	limits->discard_granularity = origin_limits->discard_granularity;
 	limits->discard_alignment = origin_limits->discard_alignment;
-	limits->discard_misaligned = origin_limits->discard_misaligned;
 }
 
 static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index ad79b52ffc1434..b4384a8b13e360 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2059,7 +2059,6 @@ static void set_discard_limits(struct clone *clone, struct queue_limits *limits)
 	limits->max_hw_discard_sectors = dest_limits->max_hw_discard_sectors;
 	limits->discard_granularity = dest_limits->discard_granularity;
 	limits->discard_alignment = dest_limits->discard_alignment;
-	limits->discard_misaligned = dest_limits->discard_misaligned;
 	limits->max_discard_segments = dest_limits->max_discard_segments;
 }
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index df6313c3fe6ba4..502ebc78d490f6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1808,7 +1808,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		limits->max_hw_discard_sectors = 0;
 		limits->discard_granularity = 0;
 		limits->discard_alignment = 0;
-		limits->discard_misaligned = 0;
 	}
 
 	if (!dm_table_supports_write_zeroes(t))
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7ad2b1240fc0bf..86410ce41bf60e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -377,7 +377,6 @@ struct queue_limits {
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
 
-	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
-- 
2.43.0



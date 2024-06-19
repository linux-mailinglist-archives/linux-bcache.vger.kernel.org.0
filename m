Return-Path: <linux-bcache+bounces-676-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DB290F347
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C32BF283B87
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6946415530B;
	Wed, 19 Jun 2024 15:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iFufIJSo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008E215383B;
	Wed, 19 Jun 2024 15:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812011; cv=none; b=NS8NcrGLlXPReB+VvMVAnEqjM5ot4ai+L1Cioctj+mhWFB1rA0IrYD7CvnYmUW4QUJlqvya3Zrtvu6xOkxgg/46Q1ZdCND7px1ID6cooJOro3R9t9h8Wve+z6Ylp2jy8Cp/WdQqnclf1SXYrcWMzDxXRqpM9zhv3F6KUKp7ttmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812011; c=relaxed/simple;
	bh=9LDRQnDuLZaYOfnkh5YwocB6uMVv1z/6AIrboDOicnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEp7oCcwM+aatR9cKz960BTBh4itJeZJrO4e26gGHS3DF5eO4wUt7bZFYn9v9ftKoOoxvFbMpMXP3j9zAjnjQPvKmZ0i83Dd+SsUD+ggXLu4ghPexsVw+kBSiOpD65jN3QkMFbV9pviHiJSsQa3EzsrdqE8tO0K4I69F0ZDvFgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iFufIJSo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o+swq+VE7tcTXydHE94IhwxRJaN9RfBdvh/8jQkpoR0=; b=iFufIJSopVGoAVAETwBgojfrPv
	iZIFnzXRyTZxGKFWOjzdK+4qr/ENqegTxzx2dtSLM69bPctZxZvWz6OtQ/9E4Jtp9AaAZY2gpFdoQ
	0CnVUzvocdlk9JXmmD2fCqTE+oE4owelIhto0y+uodw8lTQ5FvZcJ2j9owpB1788jJlntOOppPsEx
	zyXRIcFP4w9eF9ey5lMiHbzgkKgFTgnrWPkNCE25G8nSN/m6TJHKkEvug/+PbDvSt/nQdiRomn/Ro
	gsimG06IfeunCVTPR/AR+7pFXOSrRPjawNTwhLC8waeDh5DLL4li375sZtl7fDMnbzdKUiIm4NTWk
	3MBCcBLw==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJxWJ-00000001sqP-33s5;
	Wed, 19 Jun 2024 15:46:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org
Subject: [PATCH 4/6] block: move the misaligned flag into the features field
Date: Wed, 19 Jun 2024 17:45:36 +0200
Message-ID: <20240619154623.450048-5-hch@lst.de>
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

Move the misaligned flags into the features field to reclaim a little
bit of space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 20 ++++++++++----------
 include/linux/blkdev.h |  4 +++-
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d0e9096f93ca8a..a1b10404e500bc 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -258,7 +258,7 @@ static int blk_validate_limits(struct queue_limits *lim)
 
 	if (lim->alignment_offset) {
 		lim->alignment_offset &= (lim->physical_block_size - 1);
-		lim->misaligned = 0;
+		lim->features &= ~BLK_FEAT_MISALIGNED;
 	}
 
 	if (!(lim->features & BLK_FEAT_WRITE_CACHE))
@@ -470,6 +470,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	if (!(b->features & BLK_FEAT_POLL))
 		t->features &= ~BLK_FEAT_POLL;
 
+	t->flags |= (b->flags & BLK_FEAT_MISALIGNED);
+
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_user_sectors = min_not_zero(t->max_user_sectors,
 			b->max_user_sectors);
@@ -494,8 +496,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
-	t->misaligned |= b->misaligned;
-
 	alignment = queue_limit_alignment_offset(b, start);
 
 	/* Bottom device has different alignment.  Check that it is
@@ -509,7 +509,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 		/* Verify that top and bottom intervals line up */
 		if (max(top, bottom) % min(top, bottom)) {
-			t->misaligned = 1;
+			t->flags |= BLK_FEAT_MISALIGNED;
 			ret = -1;
 		}
 	}
@@ -531,28 +531,28 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
 		t->physical_block_size = t->logical_block_size;
-		t->misaligned = 1;
+		t->flags |= BLK_FEAT_MISALIGNED;
 		ret = -1;
 	}
 
 	/* Minimum I/O a multiple of the physical block size? */
 	if (t->io_min & (t->physical_block_size - 1)) {
 		t->io_min = t->physical_block_size;
-		t->misaligned = 1;
+		t->flags |= BLK_FEAT_MISALIGNED;
 		ret = -1;
 	}
 
 	/* Optimal I/O a multiple of the physical block size? */
 	if (t->io_opt & (t->physical_block_size - 1)) {
 		t->io_opt = 0;
-		t->misaligned = 1;
+		t->flags |= BLK_FEAT_MISALIGNED;
 		ret = -1;
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
 	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
 		t->chunk_sectors = 0;
-		t->misaligned = 1;
+		t->flags |= BLK_FEAT_MISALIGNED;
 		ret = -1;
 	}
 
@@ -566,7 +566,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	/* Verify that new alignment_offset is on a logical block boundary */
 	if (t->alignment_offset & (t->logical_block_size - 1)) {
-		t->misaligned = 1;
+		t->flags |= BLK_FEAT_MISALIGNED;
 		ret = -1;
 	}
 
@@ -729,7 +729,7 @@ int bdev_alignment_offset(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (q->limits.misaligned)
+	if (q->limits.flags & BLK_FEAT_MISALIGNED)
 		return -1;
 	if (bdev_is_partition(bdev))
 		return queue_limit_alignment_offset(&q->limits,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 713a98b6dbba08..7ad2b1240fc0bf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -341,6 +341,9 @@ enum {
 enum {
 	/* do not send FLUSH/FUA commands despite advertising a write cache */
 	BLK_FLAG_WRITE_CACHE_DISABLED		= (1u << 0),
+
+	/* I/O topology is misaligned */
+	BLK_FEAT_MISALIGNED			= (1u << 1),
 };
 
 struct queue_limits {
@@ -374,7 +377,6 @@ struct queue_limits {
 	unsigned short		max_integrity_segments;
 	unsigned short		max_discard_segments;
 
-	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
 	unsigned int		max_open_zones;
-- 
2.43.0



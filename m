Return-Path: <linux-bcache+bounces-675-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA09B90F342
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83C651F25155
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA5F2154BE5;
	Wed, 19 Jun 2024 15:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SUT5SLmz"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED6C15383B;
	Wed, 19 Jun 2024 15:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718812005; cv=none; b=Xn42oagl3W3Ce8VkuR4i23G6/9sehfvV2RSFadk/cARp6Qu+QcZ0G9AJjRbdZfJyCSVBIEvyNvyW28MRpw/xQ0ya4DCtScmpOS8NpXYzqGUHYnN3GuzjNKXM8eJjcVPGUW06osyklMtVjmayZik8sJ6r359ORek6W8K+rCUl46A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718812005; c=relaxed/simple;
	bh=tiN2bRWunE40KIDbhYdpa981MaxpzGWujd7qj+moaJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgUcJK+4icUTbLnQjygWfIxHngd+gmVrSgvaktgDRbsi2G2c6GcTMs3OrUKn2reQurCFpSvoR043mtIXlKhtBghy1qVe7sQbhCjs0mPQQKObF3G5t3zh1YPmAKTy/0soFwfC64uB/ZkFtLGDJvqLVMd6lXZeU/BRhPigioxYzRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SUT5SLmz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MdQOFX5KYJeMhVeQ/YizIUE44aJQZiKdG4CJwyN/tFo=; b=SUT5SLmzsCdYKbi48FKoCWCA1U
	+rRFosEuS7A5HT2Yy7blSwF1iz1DHvlxVVEDR6Gq0+AqCTLHTirOFN5LFhefxnoiQ8L+LpSpNsxZC
	eOWUIIJoFdyWn2lt07RM/eAd1GZFJFyB4JZitQKFd9eyLF5D5dxZzFjlwBhdVFpl7ILSH+TJM8pg+
	NfaWaYalDrbwHLOLD6CZC2k3+/JVawyTvgrhb4lyBSRO+gW1rP+slZssRp6LizgwaExlq9A+Ru5qQ
	7GYU0dlKAkzp7UBweKCYJUI7ycB2kKJ1cnFjNy9dia+YRlkC1V0rdlG7tN8bBKTc+MEK+ImT6Y1xl
	jV2nQwvA==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJxWF-00000001spR-0DU1;
	Wed, 19 Jun 2024 15:46:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org
Subject: [PATCH 3/6] block: renumber and rename the cache disabled flag
Date: Wed, 19 Jun 2024 17:45:35 +0200
Message-ID: <20240619154623.450048-4-hch@lst.de>
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

Start with the first bit, and drop the plural-S from the name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c      | 6 +++---
 include/linux/blkdev.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index da4e96d686f91e..59e6d111ed059a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -429,7 +429,7 @@ static ssize_t queue_io_timeout_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_wc_show(struct request_queue *q, char *page)
 {
-	if (q->limits.features & BLK_FLAGS_WRITE_CACHE_DISABLED)
+	if (q->limits.features & BLK_FLAG_WRITE_CACHE_DISABLED)
 		return sprintf(page, "write through\n");
 	return sprintf(page, "write back\n");
 }
@@ -452,9 +452,9 @@ static ssize_t queue_wc_store(struct request_queue *q, const char *page,
 
 	lim = queue_limits_start_update(q);
 	if (disable)
-		lim.flags |= BLK_FLAGS_WRITE_CACHE_DISABLED;
+		lim.flags |= BLK_FLAG_WRITE_CACHE_DISABLED;
 	else
-		lim.flags &= ~BLK_FLAGS_WRITE_CACHE_DISABLED;
+		lim.flags &= ~BLK_FLAG_WRITE_CACHE_DISABLED;
 	err = queue_limits_commit_update(q, &lim);
 	if (err)
 		return err;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f7d275e3fb2c1e..713a98b6dbba08 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -339,8 +339,8 @@ enum {
 
 /* internal flags in queue_limits.flags */
 enum {
-	/* do not send FLUSH or FUA command despite advertised write cache */
-	BLK_FLAGS_WRITE_CACHE_DISABLED		= (1u << 31),
+	/* do not send FLUSH/FUA commands despite advertising a write cache */
+	BLK_FLAG_WRITE_CACHE_DISABLED		= (1u << 0),
 };
 
 struct queue_limits {
@@ -1339,7 +1339,7 @@ static inline bool bdev_stable_writes(struct block_device *bdev)
 static inline bool blk_queue_write_cache(struct request_queue *q)
 {
 	return (q->limits.features & BLK_FEAT_WRITE_CACHE) &&
-		!(q->limits.flags & BLK_FLAGS_WRITE_CACHE_DISABLED);
+		!(q->limits.flags & BLK_FLAG_WRITE_CACHE_DISABLED);
 }
 
 static inline bool bdev_write_cache(struct block_device *bdev)
-- 
2.43.0



Return-Path: <linux-bcache+bounces-282-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42935867210
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Feb 2024 11:52:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D12501F25F07
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Feb 2024 10:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0023241E9;
	Mon, 26 Feb 2024 10:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SVmnw1MM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86130249F5;
	Mon, 26 Feb 2024 10:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708944519; cv=none; b=iw8Gh15pucQiWOaIP1Feio39uhrh0Q5vM3iZyNkxEdKEagf6k+u6BZ953uCwNKgsnejMV4hAWXZMdX9XAHBgGToS0Yk16b58UDgy96U+RfFM2rEht1dDd0vQx3y1zEZF/evhJlYo6BQonmmE0INDbUdwXK3atOgVXVHoEgwa4yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708944519; c=relaxed/simple;
	bh=+gGz51qE5Pq4E6kzViPKONB/i+EPyesCW0Ui+8XJdyY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NKZY7V6lWTPbUjg4Rzv7yj7PA6wVAmDxqSxyM3Nb/Sx+ltQuc56o6/KzauBjvFqSroIA+p4HspadKkZ4ZNvmhPvDCCZJp9kqoWx5pnBKwpeZjAX4Mgy0EZY9O85KLTXf73Hjq0PXiRLtn08UVsd+1i27BBe/cRqSONf3xOcuzd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SVmnw1MM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=m2jGMssjsOQHvy4pK6/58foE8FkgoR+leWrTYNZRDYc=; b=SVmnw1MMLyWlzIsT5gMWhCyNqs
	dtoiP0R8+oacc7n6v/D/h9gYhROVD9eNFvJ6wilYx0jy12VTHgRGWNARB9X23Ak5oJQJ3+3Xk42PN
	NmRypNDTzy7Qs8Wp+Z89XRU0wMognJysG8PkUDx6nmdnDPENLQC98KvboPyIwH09hklLRaNxhTy3l
	Rdt0RSLilGlG8gaV44ZFdcn97yXsgN3pOJuJooQSlgsri9DNvNbDRXHM6wW2/1oBGmf9qIUqSwVVL
	ua6XgISbYbFKvNhqlcJBpViWroPWwR1DjOY5cxzy5ow1/feVx0be0jdxTmAahSVW6V9FQCMnLhV+V
	w/krNmtQ==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYXE-00000000BOV-3pp6;
	Mon, 26 Feb 2024 10:48:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH] bcache: move calculation of stripe_size and io_opt into bcache_device_init
Date: Mon, 26 Feb 2024 11:48:26 +0100
Message-Id: <20240226104826.283067-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226104826.283067-1-hch@lst.de>
References: <20240226104826.283067-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

bcache currently calculates the stripe size for the non-cached_dev
case directly in bcache_device_init, but for the cached_dev case it does
it in the caller.  Consolidate it in one places, which also enables
setting the io_opt queue_limit before allocating the gendisk so that it
can be passed in instead of changing the limit just after the allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d06a9649d30269..f716c3265f5cf0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -913,6 +913,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	uint64_t n;
 	int idx;
 
+	if (cached_bdev) {
+		d->stripe_size = bdev_io_opt(cached_bdev) >> SECTOR_SHIFT;
+		lim.io_opt = umax(block_size, bdev_io_opt(cached_bdev));
+	}
 	if (!d->stripe_size)
 		d->stripe_size = 1 << 31;
 	else if (d->stripe_size < BCH_MIN_STRIPE_SZ)
@@ -1418,9 +1422,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 		hlist_add_head(&io->hash, dc->io_hash + RECENT_IO);
 	}
 
-	dc->disk.stripe_size = q->limits.io_opt >> 9;
-
-	if (dc->disk.stripe_size)
+	if (bdev_io_opt(dc->bdev))
 		dc->partial_stripes_expensive =
 			q->limits.raid_partial_stripes_expensive;
 
@@ -1430,9 +1432,6 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	if (ret)
 		return ret;
 
-	blk_queue_io_opt(dc->disk.disk->queue,
-		max(queue_io_opt(dc->disk.disk->queue), queue_io_opt(q)));
-
 	atomic_set(&dc->io_errors, 0);
 	dc->io_disable = false;
 	dc->error_limit = DEFAULT_CACHED_DEV_ERROR_LIMIT;
-- 
2.39.2



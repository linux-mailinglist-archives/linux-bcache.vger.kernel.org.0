Return-Path: <linux-bcache+bounces-180-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B8481F5AA
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 08:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4EDB1F21BE3
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 07:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29614411;
	Thu, 28 Dec 2023 07:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sIUUno5s"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05694401;
	Thu, 28 Dec 2023 07:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yBEmKZVlehpTfMsqJcs5UrNKZT7aMOCpSurlpZlFZsk=; b=sIUUno5s3ItA0BiHZh1mp4seJb
	FmI2ePJmNtv2r8PSBvIL1KHUuJ42E75ZE/2/Q6/Nl826tMfpbyNEyRYkVRgpVmATvwdObOknGKjM/
	/RBJZIFMyY+sk39NISUwuPsK7yRXnlMH+l+u5sh+cMQbvZcs9Q52YKHlVRnP5Xp43mLkGlqdgjGok
	b6CpuM6P/HEdvcBMV4aW0D0oA7uJ3Lb/wDPdirDwTXJ3gWYTDzNQjyIoOin+FUQ3KwsQZKJfJP1Ut
	CSGvByXXdI230c4HlDDykOLsTLoTzUs/orkn1slOE6iCVlBipVBwuPuO/3sxYlBU5AH0qNoEI9UE9
	9EDTx7vg==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlFE-00GMqW-1v;
	Thu, 28 Dec 2023 07:55:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	linux-bcache@vger.kernel.org,
	linux-mtd@lists.infradead.org
Subject: [PATCH 1/9] block: remove two comments in bio_split_discard
Date: Thu, 28 Dec 2023 07:55:37 +0000
Message-Id: <20231228075545.362768-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231228075545.362768-1-hch@lst.de>
References: <20231228075545.362768-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

A zero discard_granularity is not treated the same as a single-block one,
and not having any segments after taking alignment is perfectly fine
and does not need a warning.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 65e75efa9bd366..2d470cf2173e29 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -115,17 +115,13 @@ static struct bio *bio_split_discard(struct bio *bio,
 
 	*nsegs = 1;
 
-	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(lim->discard_granularity >> 9, 1U);
 
 	max_discard_sectors =
 		min(lim->max_discard_sectors, bio_allowed_max_sectors(lim));
 	max_discard_sectors -= max_discard_sectors % granularity;
-
-	if (unlikely(!max_discard_sectors)) {
-		/* XXX: warn */
+	if (unlikely(!max_discard_sectors))
 		return NULL;
-	}
 
 	if (bio_sectors(bio) <= max_discard_sectors)
 		return NULL;
-- 
2.39.2



Return-Path: <linux-bcache+bounces-697-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C922E91BF64
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2024 15:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FAD71F23822
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2024 13:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F031B3F35;
	Fri, 28 Jun 2024 13:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IYu/Xeu8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0406E154434;
	Fri, 28 Jun 2024 13:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719580624; cv=none; b=CeyTBUw/SQpW9avIAQ1dEkez27vLSN+YdsZ/U2NR3gMJT3CgEsMzrcm1W5ysi5cKvSKETvIQgEmqn5DEiLWlK244YZDu+f+w+lJd8EbKJp2063DWiImF5EnJsDC54MGucheAgNO9t0zA1bnBksmVUaYIDu5k/nTi3wPz7dKGYIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719580624; c=relaxed/simple;
	bh=/7UxpBeiZ6fea9V2HjEhJVfXnsJPnPnXOGQFQMRdfM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H+3tYdExN5V6sWV9zmTT8KZFt84dSLRO13e9IaFymmvl2+3otLaFtOq4ZkPJ3sHdqBsiIfJ3GPuETtEZRjfwfqDWYGgqTu8VrVEcc8giMMfr5/NsI1ro1MxExFrlrgQoZZAbyGGrg+5MbvV8naSfouS1gCal/KOvJ7FI9toLpLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IYu/Xeu8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/mdNlHzaW4QksrOOP4Zr61R1pKnUtHC9LrwEXKZ8qDU=; b=IYu/Xeu8hQBH6IV82uNfAUoGhM
	u247ZMKbS42rH+H4+PXGa1NJCfnPkrSTKmfJm5MjMfohqqZ5Yg4omB5Jtq09FwS0pEM5vlJUSuaAD
	6NjZLc6hLQ6+1uxJnznKrFumA3fEFN6aj1mF16skP+YjPPIMAj7njGNnBXLZ30bOm2DAiB17bqtd7
	XeNn9e1GBEN98XO4XbVDREN0GURkQJIFsJKdJwKygrY9o5K1xu+vG2ZFsHI4piNY+fuIoesIDxMiN
	tg1QWHbaqtFARmAj3ARXAU5ZsfalSfy3W1Wuizg5RtsHPAVvz+EwTq/VdlfoKdlWAoTNFHSVKm8h0
	+tTZbnzw==;
Received: from [2001:4bb8:2af:2acb:3b26:86b1:bdec:6790] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sNBTJ-0000000DnST-3v9G;
	Fri, 28 Jun 2024 13:17:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: colyli@suse.de,
	kent.overstreet@linux.dev,
	linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] bcache: work around a __bitwise to bool conversion sparse warning
Date: Fri, 28 Jun 2024 15:16:48 +0200
Message-ID: <20240628131657.667797-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Sparse is a bit dumb about bitwise operation on __bitwise types used
in boolean contexts.  Add a !! to explicitly propagate to boolean
without a warning.

Fixes: fcf865e357f8 ("block: convert features and flags to __bitwise types")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 283b2511c6d21f..b5d6ef430b86fc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1416,8 +1416,8 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	}
 
 	if (bdev_io_opt(dc->bdev))
-		dc->partial_stripes_expensive = q->limits.features &
-			BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
+		dc->partial_stripes_expensive = !!(q->limits.features &
+			BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE);
 
 	ret = bcache_device_init(&dc->disk, block_size,
 			 bdev_nr_sectors(dc->bdev) - dc->sb.data_offset,
-- 
2.43.0



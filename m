Return-Path: <linux-bcache+bounces-673-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4C1E90F33A
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:58:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AD1B2854F2
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4341153BE8;
	Wed, 19 Jun 2024 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zfB9Inlx"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0534915383B;
	Wed, 19 Jun 2024 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718811995; cv=none; b=dgGVEUbV7zjP0+B2iI3e4klXnZrwwiBxQezsm9eQCgseKkQzGHRnAnommOJo/vhb8awrhzqQzYFZPhij5XMbs6EkzA9L5taKC0Lyl3jg9qaAKZrzkHcLHphqMz2ZzsNbDM9af5YTS8oHNgJLcKPcY58Umj18SCL6lt6u5GD5vGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718811995; c=relaxed/simple;
	bh=pP9E1Gydj41nYSOifbdT7gDEY73n7HhM/FdSWReedvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY8IT/NKyZnPVhP+WFj3TtRpuKBWYlJiuVAsOqzRWgzkvSuqw9bMvxsajMtU+HyWgpsYlHsSOROtglEr3W/bnB+CSRtGsbSKUlkaRGBR1kl5yCIYx0NMTInU6xOyIgojSlMRYQJMi52M/UWhFq+3QvnTKyc7THO52DJSdJidQFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zfB9Inlx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZFHW6cZmNbfyInrIJ+LfPJqUpG3HCHTXd6HTHWSG4Bs=; b=zfB9Inlx/dSUTBOS2x8DEIf7NI
	y8JM++BBexQBC03jI3bpQ1+48xw2DzM8wXBGqFMMIt9e1ryRKYTNe5mf5xJ4+UeuSYQIbA9MKBQTr
	nr4W39lNcxC7Ra5zIb4di3eEyobHa3JYniDwzrV4ndR3GnmnGhQzQUlNCOSOTFsvhtL6pPKXcZtno
	PBD15xtUh8Vgk+SjiHoMQ/EIeZvd/qsLTf6SrWnD1gxn02wsnugaEcJNnYPNSITgFzKuo1jD31//r
	YdXRZhYIlXLbjbzWXcs67yvxDZs7dag/mfvef5yr5vawryygDgcY4vxA8sOMy83AJ9ZL4GxRCFU6W
	WgZ5vAEg==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJxW3-00000001smY-41aJ;
	Wed, 19 Jun 2024 15:46:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 1/6] block: remove the unused blk_bounce enum
Date: Wed, 19 Jun 2024 17:45:33 +0200
Message-ID: <20240619154623.450048-2-hch@lst.de>
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

The enum has been replaced with the BLK_FEAT_BOUNCE_HIGH flag.

Reported-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e96ba7b97288d2..f7d275e3fb2c1e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -343,15 +343,6 @@ enum {
 	BLK_FLAGS_WRITE_CACHE_DISABLED		= (1u << 31),
 };
 
-/*
- * BLK_BOUNCE_NONE:	never bounce (default)
- * BLK_BOUNCE_HIGH:	bounce all highmem pages
- */
-enum blk_bounce {
-	BLK_BOUNCE_NONE,
-	BLK_BOUNCE_HIGH,
-};
-
 struct queue_limits {
 	unsigned int		features;
 	unsigned int		flags;
-- 
2.43.0



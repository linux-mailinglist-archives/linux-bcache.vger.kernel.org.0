Return-Path: <linux-bcache+bounces-674-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20CB290F33E
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 374661C21B95
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:58:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF85199E8E;
	Wed, 19 Jun 2024 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lg4vg5uo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2A15383B;
	Wed, 19 Jun 2024 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718811999; cv=none; b=N+sDfXNBadIByNDhue26EEiMD0uAWnrioiq73wwFOWTHHJYeC4N9tOY8YAoV8HzkuZmSqjWXF7SL4HZ5AoStIobnm3EfPGtjLD1trc1OeAxwJkRm0+ymm46asjrV6FiKhLmrW8fSEg7cr7QtZRI7R9G5YCtBlRQqW+d9FmpEIg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718811999; c=relaxed/simple;
	bh=ojkOSgVCppJ3/huMkxkjU1q71hlb+ZZ0xAW4WiF7vug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D++SRa26oPPFZi2fIgP76cqbg/QUbp7LhM7N77SsXbOgzF4jLGQApe0aOugIkXpBENa0gFxmDpBUmV0QkLUMk3fP/JJjsLtzENF3rh0+ZFDSVCm4Kc8waMmAzv+0QU+c8oW2lu88VGgRh80RxkvUth7+fw+bg5cQKiylsV8MWJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lg4vg5uo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1Wdms+Xcf2ZNKk9teFhxm0lC2UVVmYWKAGgDHDGJh8A=; b=lg4vg5uoogT6YpyHRXz96b96X/
	ez6++RGGHvLSPi5hdJaT3aDfbe93lfn+RVroO+BetRYlnE+ggtMuNSqLYSlfDLzNAcZt31evgs7kq
	4qIiUIVwWJZ4AQaI360fq+a/tpvZ3EFSgLbr4eiKOihgLZOytmvNXNtnLlz8hd1msvjjag1mW95Yq
	iVFDxfaNBVaxYolyLY4ZuJA+Yc9nPsemT9xwgp+7XT3q/JfUg8noxPKLLSE+4J+1liUVagG05Usmi
	xmin3ukJqyFACxeYtDwcA1Xs9YIXlqK3b1WTx7aGW4rBhTnMUVQmVFCsIHEZZ+rD1ATK261Jl+5pD
	U1paAFvA==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJxW8-00000001sny-0oRd;
	Wed, 19 Jun 2024 15:46:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 2/6] block: fix spelling and grammar for in writeback_cache_control.rst
Date: Wed, 19 Jun 2024 17:45:34 +0200
Message-ID: <20240619154623.450048-3-hch@lst.de>
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

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/writeback_cache_control.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/block/writeback_cache_control.rst b/Documentation/block/writeback_cache_control.rst
index c575e08beda8e3..c3707d07178045 100644
--- a/Documentation/block/writeback_cache_control.rst
+++ b/Documentation/block/writeback_cache_control.rst
@@ -70,8 +70,8 @@ flag in the features field of the queue_limits structure.
 Implementation details for bio based block drivers
 --------------------------------------------------
 
-For bio based drivers the REQ_PREFLUSH and REQ_FUA bit are simplify passed on
-to the driver if the drivers sets the BLK_FEAT_WRITE_CACHE flag and the drivers
+For bio based drivers the REQ_PREFLUSH and REQ_FUA bit are simply passed on to
+the driver if the driver sets the BLK_FEAT_WRITE_CACHE flag and the driver
 needs to handle them.
 
 *NOTE*: The REQ_FUA bit also gets passed on when the BLK_FEAT_FUA flags is
@@ -89,7 +89,7 @@ When the BLK_FEAT_WRITE_CACHE flag is set, REQ_OP_WRITE | REQ_PREFLUSH requests
 with a payload are automatically turned into a sequence of a REQ_OP_FLUSH
 request followed by the actual write by the block layer.
 
-When the BLK_FEAT_FUA flags is set, the REQ_FUA bit simplify passed on for the
+When the BLK_FEAT_FUA flags is set, the REQ_FUA bit is simply passed on for the
 REQ_OP_WRITE request, else a REQ_OP_FLUSH request is sent by the block layer
 after the completion of the write request for bio submissions with the REQ_FUA
 bit set.
-- 
2.43.0



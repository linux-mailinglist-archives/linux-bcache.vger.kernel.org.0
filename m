Return-Path: <linux-bcache+bounces-183-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ABC581F5B0
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 08:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35A0A283C5F
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 07:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950B44402;
	Thu, 28 Dec 2023 07:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q0Q0ryNe"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5AD63A8;
	Thu, 28 Dec 2023 07:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q/HlW27opIlbbmmp83fWxmA7/2zguajj/Xv/HUI85Ao=; b=q0Q0ryNe8UapoNJP1iv256wXB7
	AKKH1RzReJIql5mHIaDlcciH6hppE8XQzYd0b7I9z9ta6uVqPGlp7jeJje6FZefhf6n8UwS54/DRk
	k7hRoAcxq6Nt2j4xT8CddN59KcRFFFbh+xwES6UEc08OPH78AWblWsWmGodSQ14+JMhc2IfAWfXdL
	/Yjk7FaIeZMs5pDIXvEpaOPq/Z1MhrYNAqtc0NlPsba4XM77DfklCf/8S0ujSbPlHhFzb971QjDAz
	CUnxm5D0UuGnR68fNPqhoFYG0jx9nOiqQ5/uzRnGS4gdEk5n6YtCfPh+uCGHDEigqL9s1axdxKMXB
	TXlGzQIQ==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlFP-00GMsI-1M;
	Thu, 28 Dec 2023 07:56:08 +0000
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
Subject: [PATCH 3/9] block: default the discard granularity to sector size
Date: Thu, 28 Dec 2023 07:55:39 +0000
Message-Id: <20231228075545.362768-4-hch@lst.de>
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

Current the discard granularity defaults to 0 and must be initialized by
any driver that wants to support discard.  Default to the sector size
instead, which is the smallest possible value, and a very useful default.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index ba6e0e97118c08..d993d20dab3c6d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -48,7 +48,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->max_discard_sectors = 0;
 	lim->max_hw_discard_sectors = 0;
 	lim->max_secure_erase_sectors = 0;
-	lim->discard_granularity = 0;
+	lim->discard_granularity = 512;
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
@@ -309,6 +309,9 @@ void blk_queue_logical_block_size(struct request_queue *q, unsigned int size)
 
 	limits->logical_block_size = size;
 
+	if (limits->discard_granularity < limits->logical_block_size)
+		limits->discard_granularity = limits->logical_block_size;
+
 	if (limits->physical_block_size < size)
 		limits->physical_block_size = size;
 
-- 
2.39.2



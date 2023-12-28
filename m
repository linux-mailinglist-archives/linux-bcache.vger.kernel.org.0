Return-Path: <linux-bcache+bounces-181-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2235581F5AD
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 08:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6BC71F2266F
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Dec 2023 07:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EAD25244;
	Thu, 28 Dec 2023 07:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nDIXnjOk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D74F4409;
	Thu, 28 Dec 2023 07:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wsinjDSCV+Rjfc71EDyifigolrdpbzFtrjrUVZw9+FQ=; b=nDIXnjOkHVtMU9aFr1prtKvnZz
	Ki8PpxdH9FY7DbT8gAv6++ktPz9xu0rCdal8U5fn+UG7t34xCTQgYv+ZK1+pgSQqkpVObB+7sIrJY
	4jUWJeigc10tLbt+X8pGHLB0I7of/v3GXZzYvO9SHHsToGvRewQGujunI9x651xVV4kf/ut0cMaQh
	kh1AzFVNER65pYGhmGy5HfZzqJ7f4sLyCVskEooCS8ufrumusn13x60eZwwe8nw4HCGl9Ze9xJZA6
	dmWMKjcehTNQtVJ2nA3y54TrhwdMBvwH42LDCsp3hnWBbY8iGTcWMTWloh1iNQU3FlG9LEBcMEtzP
	Mk1ErNdw==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlF9-00GMqU-1S;
	Thu, 28 Dec 2023 07:55:52 +0000
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
Subject: provide a sane discard_granularity default
Date: Thu, 28 Dec 2023 07:55:36 +0000
Message-Id: <20231228075545.362768-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

this series defaults the discard_granularity to the sector size as
that is a very logical default for devices that have no further
restrictions.  This removes the need for trivial drivers to set
a discard granularity and cleans up the interface.

Diffstat:
 arch/um/drivers/ubd_kern.c    |    1 -
 block/blk-merge.c             |    6 +-----
 block/blk-settings.c          |    5 ++++-
 drivers/block/nbd.c           |    6 +-----
 drivers/block/null_blk/main.c |    1 -
 drivers/block/zram/zram_drv.c |    1 -
 drivers/md/bcache/super.c     |    1 -
 drivers/mtd/mtd_blkdevs.c     |    4 +---
 8 files changed, 7 insertions(+), 18 deletions(-)


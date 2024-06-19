Return-Path: <linux-bcache+bounces-672-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA7190F337
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFDA7B253FF
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E73153BD7;
	Wed, 19 Jun 2024 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ksQRsupe"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3913158D99;
	Wed, 19 Jun 2024 15:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718811991; cv=none; b=jDr2vzvt+oV0lT/iar7F8NnGZg2WcmMdz0QqJ60XsmTOU2OQmIC1I/V3nQUxhOKtErK28UyNCcuBJEWGnYTZTfttALUSt1uDc+DFTAzkkKs0MWYPogzTj4r2driaEIh5spjTeW9FvLBVw3ygImRPb7bnOpSGJGWbKkPqpX38KaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718811991; c=relaxed/simple;
	bh=xqAUjJyKhIKl/svaZYYWknXH07kCIWiOk5uKnoOnCjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S4GFVHj1Z/+kWkFOO+lQIWM4C+6O9JyeoHJCPPScr5N3LUKw/xMJVEZXkF43hR6RAmdlqtUMt65RuZDIncqOmY4uaCbqhksZdjujv8NGVwQMRdhyE7GKS3hKDrQFHZTmPVYaNa1u+97vNs8stt5aLo6L/FP/WGF3AxMcVTqP7Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ksQRsupe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wTeItjpVEkityyzKeP1gv+GXRZ6eAV20wjhNagLSitk=; b=ksQRsupejBe+cWz5DBzQUmcPUI
	TeeB7r2Fuz30neoOI/Zwi5wVyIk7Ug4pVxhkCjFfawdfWhYeHw2RNER6fWnW4co3scVFR7zGdvKXt
	xQ66rGr0hz2shp/krkuzekPQZr18UEo/cZMx1XypIhWSm6nGYnnhXRQj+W58g2m6v73Z83s5uphmN
	l4uGUD9TnbHvVq1akPWCvy7KwTSyAuzvEYe4iK1NTlPzs31zZ8QyZdyXsuHowu5eOH30lSijbVgxh
	aPD/C8ySeqk+Ay3TkTtYImkBZVoUioBy70VC3h28USBXCSrCWBA9Vz+ycIfFvzdyU0Ob005lBWmht
	kIUrT+ew==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJxW0-00000001skf-0r8L;
	Wed, 19 Jun 2024 15:46:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org
Subject: misc queue_limits fixups
Date: Wed, 19 Jun 2024 17:45:32 +0200
Message-ID: <20240619154623.450048-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

this series is a mix of a few fixups for the last round of queue_limits
fixed that I had prepared for a rev of the queue limits features series,
and a bunch of imcremental conversions that I didn't want to bloat that
series with.

Diffstat:
 Documentation/block/writeback_cache_control.rst |    6 ++--
 block/blk-settings.c                            |   34 +++++++-----------------
 block/blk-sysfs.c                               |    6 ++--
 drivers/md/bcache/super.c                       |    4 +-
 drivers/md/dm-cache-target.c                    |    1 
 drivers/md/dm-clone-target.c                    |    1 
 drivers/md/dm-table.c                           |    1 
 drivers/md/raid5.c                              |    2 -
 include/linux/blkdev.h                          |   25 +++++++----------
 9 files changed, 29 insertions(+), 51 deletions(-)


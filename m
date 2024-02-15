Return-Path: <linux-bcache+bounces-261-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB31855B51
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 08:11:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4691128264C
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 07:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D1AB67E;
	Thu, 15 Feb 2024 07:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s6NYKEcM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B886D518;
	Thu, 15 Feb 2024 07:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707981070; cv=none; b=N3Mz6Qm39fDOR+D8XH7no52aHii916kMLlDMhdBNKJl8rRr/TvFq+IEyyCxw8vrEO9x+Nna736V9vZ1X8FXLvzRwAeO9g/CzGrRsaKtZqYeDBFbe5v6w5ZtZ0gKrKbAszc45iyPaA8RIKNOBDpb5YE90U6zOflyssvVYwHHlM3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707981070; c=relaxed/simple;
	bh=WME+GiprMna6xXV4mZBqG46m7hYx6KZ5nkbGB0j/5YI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g8gyGh5OLgON/XKCK4k5wxL5b0MxLAr5zj5m5WzgLgmVbsid1M5PJIMunVx4la3x5+FboBZRRU8sFZ6F6ZiVQctDCGt0LRSjORfDX/pR6MqaHIT8N+yle3YXWWm16RDAURQcjcL+ucNDJiQKtKNj/vShqe3UwkRQFowGZRM2r2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s6NYKEcM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Nxm36FqNxHTO2bUEkPIukbTZrVtZ7SMU3lqBNewlmRw=; b=s6NYKEcMfnp31ToeLegkrxxtgm
	ajKd0J3cEPs9lWZrwB4JvwhxTNESqQjX/hKipTGcDCZEjoWA0nXm8qALOMXDjcAsqByXmtN2xUXm2
	H3Mam83uMZL/lyV2UmnCLuxUMKGZ5q30tZoj8cAcO3lJgnCEuho+z2sCI3Z0yuKS5PxyYZ6s3TK3a
	y7+FbSKMf4exPftSZuE3pc3dxhKGQcx8mmB/ntJfz3iYfWgh9dPqb2rA+ISmtYS4eeFfFZhQ5fcom
	MG58P9oqp3ZJeG+mCtsjXSnM1mxnurL+rxy0BnqMNbpo6xpkib5BICH/Doh0qgf1gDgFh23/hEmS3
	3gDX0sAg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raVte-0000000FCXP-1wpH;
	Thu, 15 Feb 2024 07:11:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Coly Li <colyli@suse.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: pass queue_limits to blk_alloc_disk for simple drivers
Date: Thu, 15 Feb 2024 08:10:46 +0100
Message-Id: <20240215071055.2201424-1-hch@lst.de>
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

this series converts all "simple" bio based drivers that don't have
complex internal layering or other oddities to pass the queue_limits to
blk_mq_alloc_disk.  None of these drivers updates the limits at runtime.


Diffstat:
 arch/m68k/emu/nfblock.c             |   10 ++++---
 arch/xtensa/platforms/iss/simdisk.c |    8 +++--
 block/genhd.c                       |   11 ++++---
 drivers/block/brd.c                 |   26 +++++++++---------
 drivers/block/drbd/drbd_main.c      |    6 ++--
 drivers/block/n64cart.c             |   12 +++++---
 drivers/block/null_blk/main.c       |    7 ++--
 drivers/block/pktcdvd.c             |    7 ++--
 drivers/block/ps3vram.c             |    6 ++--
 drivers/block/zram/zram_drv.c       |   51 +++++++++++++++++-------------------
 drivers/md/bcache/super.c           |   48 +++++++++++++++++----------------
 drivers/md/dm.c                     |    4 +-
 drivers/md/md.c                     |    7 ++--
 drivers/nvdimm/btt.c                |   14 +++++----
 drivers/nvdimm/pmem.c               |   14 +++++----
 drivers/nvme/host/multipath.c       |    6 ++--
 drivers/s390/block/dcssblk.c        |   10 ++++---
 include/linux/blkdev.h              |   10 ++++---
 18 files changed, 143 insertions(+), 114 deletions(-)


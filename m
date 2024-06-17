Return-Path: <linux-bcache+bounces-616-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B601B90A3D5
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:06:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A06E21C22BDE
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EAB5186E55;
	Mon, 17 Jun 2024 06:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ra+HvJbC"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E7B186E3D;
	Mon, 17 Jun 2024 06:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604354; cv=none; b=ZjX58KnyQmlzj6kAFGlwDAJnAkaYClASMHi9yMB1S7WUo/ABul4+x18Mo91dubXarERNnLhIKTb0RgPMnCG+eMSrUa94gHSI1aR9O8G+NKYMYlIrpozYK7ieaf1jO6y3IIbi9k7FioWthmzhF4+n4TJMilI9mUO/+msQxr2nJKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604354; c=relaxed/simple;
	bh=9uoa6eTpb85X1fqGOclqrk0hDcfsokAPEj1D1N9BW/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz8Na+IsEytGT16Qe8A50a1/7dE60dZZqDRkLl6LHZcUXNRjAI0UzsB/31FyDWHhVMXk3ue+r4GbUMA3uwLhP5Ia+CVw+ecrRpkFsWSyaZP5zwi9eXnzL6rD6PbvgOU024M4zbpb5JK9VYqYUwArf7Ag0pI5vrukpcPAUm1IU5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ra+HvJbC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/82cXfoepsjrCLF9yDw8vVInGtt4GPJk52iCZL5X8kA=; b=ra+HvJbCl/BtNyU8RdnS7dRs7s
	O6LBCVDzAMTBjJ+U6/bFUEuKA1u/YpNavXuPiwpaBM2SvFLhrKWKHkSQ1M540dkcyGLo3pmL4QWJT
	2xSmzNE7W7m4yw0S2HfM7DQTNcHjn8OweF4ejpZoPKnI8CvJqF+ZHuFDHDsv9QS4UHWRRHcXw2kRy
	z7JVpylVvNbvCmM4EsAoVdSB5CR3lL9qt7ZSteQka766DrvKfN1np9moQ7J819shVf1699J46ehpx
	PD4BrRSVAZLsmBEWIZpR/Z72M/MhYkKkIRLJsriHO0Q08q8JjUZXaAqIqmk51INY1TifT3fqBt9OT
	c8ga2Wbw==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5Ut-00000009IDo-122H;
	Mon, 17 Jun 2024 06:05:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org,
	linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com,
	nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org,
	ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH 03/26] sd: move zone limits setup out of sd_read_block_characteristics
Date: Mon, 17 Jun 2024 08:04:30 +0200
Message-ID: <20240617060532.127975-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617060532.127975-1-hch@lst.de>
References: <20240617060532.127975-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move a bit of code that sets up the zone flag and the write granularity
into sd_zbc_read_zones to be with the rest of the zoned limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c     | 21 +--------------------
 drivers/scsi/sd_zbc.c |  9 +++++++++
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 664523048ce819..66f7d1e3429c86 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3312,29 +3312,10 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp,
 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
 	}
 
-
-#ifdef CONFIG_BLK_DEV_ZONED /* sd_probe rejects ZBD devices early otherwise */
-	if (sdkp->device->type == TYPE_ZBC) {
-		lim->zoned = true;
-
-		/*
-		 * Per ZBC and ZAC specifications, writes in sequential write
-		 * required zones of host-managed devices must be aligned to
-		 * the device physical block size.
-		 */
-		lim->zone_write_granularity = sdkp->physical_block_size;
-	} else {
-		/*
-		 * Host-aware devices are treated as conventional.
-		 */
-		lim->zoned = false;
-	}
-#endif /* CONFIG_BLK_DEV_ZONED */
-
 	if (!sdkp->first_scan)
 		return;
 
-	if (lim->zoned)
+	if (sdkp->device->type == TYPE_ZBC)
 		sd_printk(KERN_NOTICE, sdkp, "Host-managed zoned block device\n");
 	else if (sdkp->zoned == 1)
 		sd_printk(KERN_NOTICE, sdkp, "Host-aware SMR disk used as regular disk\n");
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 8cc9c025017961..360ec980499529 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -601,6 +601,15 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 	if (sdkp->device->type != TYPE_ZBC)
 		return 0;
 
+	lim->zoned = true;
+
+	/*
+	 * Per ZBC and ZAC specifications, writes in sequential write required
+	 * zones of host-managed devices must be aligned to the device physical
+	 * block size.
+	 */
+	lim->zone_write_granularity = sdkp->physical_block_size;
+
 	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
-- 
2.43.0



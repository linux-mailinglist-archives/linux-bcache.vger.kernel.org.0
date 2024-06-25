Return-Path: <linux-bcache+bounces-690-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 149089161BB
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jun 2024 10:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 996B21F207C6
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jun 2024 08:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73802148836;
	Tue, 25 Jun 2024 08:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iT2Kf8Ts"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCB113A252;
	Tue, 25 Jun 2024 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719305861; cv=none; b=cF7E2A/kjxISS89jPxfu+/gzYf1p44wOsKgGIxJaFuDV01ifrmm/dZ/CcspaeJogErQZDnI2Qcn4oR6uPb2e5NXOOzMhMnkyig/LY1x13nmQ0T1AB3pellaWj+OVmTV+QJQG2/glTvtV+7/7XFlXli2KVnhLJTxWAFOJWeEShfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719305861; c=relaxed/simple;
	bh=Z+RrsOLEVITIAl7yw5ohC8SHpoKA4nCfk4Q+CLDwT68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OOVPNa7fp3JPJC46igY5ZTNixgyP0dS/1p0jVZaa83Yj+Q/A/zrCNk4JwfjVuMXAH1oSgRnOrYzDRzBwEjoElWJNY3kyn64cDLtoMEGwhTedrxyB5rdWyVBfnjXybJVuVfAPrCg+/4IUfeT+ZGztqu8ICYsOP+/8UqY1ykk4Jmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iT2Kf8Ts; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=THcdDm0A+7qsrmlgD/s5mbaI1bo21sJBUVFRJUuckjU=; b=iT2Kf8Ts7SV0ZMpN1tnhXxPtMH
	Ffv8ZJFKB4PVB/IdNXjk7V0C/EqzT+g2n4rI1ZqlvQji9lJIwZfjHfG1Y7Cb5TXIeVGCM4nTH9crp
	4zyWvlsKZ4WoJ7XDaIrgLwNl3YRoXD5zh+VKywveOkw7i38S3zZmoxTmQHKWk7riwSg6VmFiReOf7
	0vMD17gabcLDjQNIftPl8VaQ0ZrC/qk7EH/0G/IiWcIA8u56veyp3C42DoJVrtu8OAb3RerYCYvx8
	kxEfDPsLLm6uiPifVX8Lcu0WzNjdMGJQI+mys12zLdW5z+VY7pu7ChDIbK8PMhXWCu88C5Voy7C5+
	gU8eTZWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM1zb-00000002Btq-1pcn;
	Tue, 25 Jun 2024 08:57:35 +0000
Date: Tue, 25 Jun 2024 01:57:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	linux-block@vger.kernel.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, ying.huang@intel.com,
	feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [axboe-block:for-next] [block]  1122c0c1cc:  aim7.jobs-per-min
 22.6% improvement
Message-ID: <ZnqGf49cvy6W-xWf@infradead.org>
References: <202406250948.e0044f1d-oliver.sang@intel.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202406250948.e0044f1d-oliver.sang@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Oliver,

can you test the patch below?  It restores the previous behavior if
the device did not have a volatile write cache.  I think at least
for raid0 and raid1 without bitmap the new behavior actually is correct
and better, but it will need fixes for other modes.  If the underlying
devices did have a volatile write cache I'm a bit lost what the problem
was and this probably won't fix the issue.

---
From 81c816827197f811e14add7a79220ed9eef6af02 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 25 Jun 2024 08:48:18 +0200
Subject: md: set md-specific flags for all queue limits

The md driver wants to enforce a number of flags to an all devices, even
when not inheriting them from the underlying devices.  To make sure these
flags survive the queue_limits_set calls that md uses to update the
queue limits without deriving them form the previous limits add a new
md_init_stacking_limits helper that calls blk_set_stacking_limits and sets
these flags.

Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c     | 13 ++++++++-----
 drivers/md/md.h     |  1 +
 drivers/md/raid0.c  |  2 +-
 drivers/md/raid1.c  |  2 +-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 6 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 69ea54aedd99a1..8368438e58e989 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5853,6 +5853,13 @@ static void mddev_delayed_delete(struct work_struct *ws)
 	kobject_put(&mddev->kobj);
 }
 
+void md_init_stacking_limits(struct queue_limits *lim)
+{
+	blk_set_stacking_limits(lim);
+	lim->features = BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
+			BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT;
+}
+
 struct mddev *md_alloc(dev_t dev, char *name)
 {
 	/*
@@ -5871,10 +5878,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	int shift;
 	int unit;
 	int error;
-	struct queue_limits lim = {
-		.features		= BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA |
-					  BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT,
-	};
 
 	/*
 	 * Wait for any previous instance of this device to be completely
@@ -5914,7 +5917,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		 */
 		mddev->hold_active = UNTIL_STOP;
 
-	disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
+	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
 	if (IS_ERR(disk)) {
 		error = PTR_ERR(disk);
 		goto out_free_mddev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c4d7ebf9587d07..28cb4b0b6c1740 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -893,6 +893,7 @@ extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
 extern int mddev_init(struct mddev *mddev);
 extern void mddev_destroy(struct mddev *mddev);
+void md_init_stacking_limits(struct queue_limits *lim);
 struct mddev *md_alloc(dev_t dev, char *name);
 void mddev_put(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 62634e2a33bd0f..32d58752477847 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -379,7 +379,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	struct queue_limits lim;
 	int err;
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1a0eba65b8a92b..04a0c2ca173245 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3194,7 +3194,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	struct queue_limits lim;
 	int err;
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3334aa803c8380..2a9c4ee982e023 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3974,7 +3974,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	struct queue_limits lim;
 	int err;
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0192a6323f09ba..10219205160bbf 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7708,7 +7708,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	 */
 	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
 
-	blk_set_stacking_limits(&lim);
+	md_init_stacking_limits(&lim);
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
-- 
2.43.0



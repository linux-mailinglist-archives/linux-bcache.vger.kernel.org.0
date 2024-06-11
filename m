Return-Path: <linux-bcache+bounces-512-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9BF903002
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:20:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CA6B28634B
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88601171E5F;
	Tue, 11 Jun 2024 05:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UXmi+XkX"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7CF17164C;
	Tue, 11 Jun 2024 05:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718083191; cv=none; b=U3CdgpjK93q/AkX2gX3ZiawSV1JxBajigzfurBxeI1/orhglrHGJu25rYlkuiUx4IHD/WLYzgWjcDzVymHPcgnXfoqMjRPmbZ4jkkizeArrot4B1SMRRicL6E2v+uLEJybI9HAb+FzorqKY9h4YyNayRy9bNmrc3w+IWDCXBOVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718083191; c=relaxed/simple;
	bh=hQVLbKvMRzlFbSIHkL+vkDKM8wDx07kbKjaCqB3jk1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYXyXb3aObim8cb7LBmA4GFaavMSBWLfy06nwC9OjY8ZGEZ/I1nvKvtkhhIx+mTcUMlVO7oCEOufP9XunjupLXGcVRi32VhDptnLTKPKvOAdzi0pqLugog9at2payYIjTWho1cJj4LHepY7yiDx4p05lG2Vbz95d+jWIdVrk1d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UXmi+XkX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QZOtfSoQAA02jj5gA5gptGlEH50imtUdZkhUebJgjrY=; b=UXmi+XkXDTmhUIFmQ+lCw4UloG
	14qIavWEJ+8aZIyq6Y+DxHB0S+SOdr/Qm7RnBCGVrQ6ORBr+Hqf8WMeKLVA1Ap/HXQFtuZp9XeHwE
	mLWCp4AAXKrG1/s2Fd8LRv78JletbtIZkPhtpE7wERgDDf281dTYOKtaadOkC4olXUszQKCGm5yP1
	BpkgDcxJ6TrEqCdmFlqaO5NBmiBg3C6wPCtwYpOHue5QOYvKPnHjae3lNtfzFW81dHNN4ZfSiAMBf
	4uq0nk+3pDzVezm1sl4pM5+/+sE3FR5B72qqnqHf1v7fD0uNQAYqOZPwF/oW5OjnMH5uLvQLA7tKb
	NcAQXwJw==;
Received: from 2a02-8389-2341-5b80-cdb4-8e7d-405d-6b77.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cdb4:8e7d:405d:6b77] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGtv2-00000007QpR-0wAa;
	Tue, 11 Jun 2024 05:19:40 +0000
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
Subject: [PATCH 03/26] loop: stop using loop_reconfigure_limits in __loop_clr_fd
Date: Tue, 11 Jun 2024 07:19:03 +0200
Message-ID: <20240611051929.513387-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240611051929.513387-1-hch@lst.de>
References: <20240611051929.513387-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

__loop_clr_fd wants to clear all settings on the device.  Prepare for
moving more settings into the block limits by open coding
loop_reconfigure_limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 93780f41646b75..93a49c40a31a71 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1133,6 +1133,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 
 static void __loop_clr_fd(struct loop_device *lo, bool release)
 {
+	struct queue_limits lim;
 	struct file *filp;
 	gfp_t gfp = lo->old_gfp_mask;
 
@@ -1156,7 +1157,14 @@ static void __loop_clr_fd(struct loop_device *lo, bool release)
 	lo->lo_offset = 0;
 	lo->lo_sizelimit = 0;
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
-	loop_reconfigure_limits(lo, 512, false);
+
+	/* reset the block size to the default */
+	lim = queue_limits_start_update(lo->lo_queue);
+	lim.logical_block_size = 512;
+	lim.physical_block_size = 512;
+	lim.io_min = 512;
+	queue_limits_commit_update(lo->lo_queue, &lim);
+
 	invalidate_disk(lo->lo_disk);
 	loop_sysfs_exit(lo);
 	/* let user-space know about this change */
-- 
2.43.0



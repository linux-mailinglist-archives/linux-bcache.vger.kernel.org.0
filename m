Return-Path: <linux-bcache+bounces-617-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B7A90A3E1
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B16F1283615
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779FB188CC7;
	Mon, 17 Jun 2024 06:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oscIs4jc"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0587C1836C7;
	Mon, 17 Jun 2024 06:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604358; cv=none; b=Q6uagZ0v3REtgvZfxdfcSrMNUXpNTCSjcyRFdprQW9tP2PQD1k4aOSZOSErqOl90NBCNv2zrmEISEIYkcpTjM7YBm1m8c+73ekboNbZDZ8tuuMT+ycsfGCQfffvPqRGLWEAKG3Z04wyLhcrWN1zUm29FW+BMDiyBvU8LqXjAX4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604358; c=relaxed/simple;
	bh=Wo22g866sbbxyKZwprgwne57ml6Flu22+kG1DU1js5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7lmw0mIV8HSHzeIToMJgKgOadUW9nhsm3UbeooPLPT2J/IrIKoC0vAGCeE0w74yqvTWT5ebZ6zsfJvpyLX0apmqgmmYHAsJybD97lV26Lf4mf4LiLNDJPBKsBsZSUh2gvncgK3UA59UwOiBMJD2urN4sFho1YtsR6IitdWe7/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oscIs4jc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cnf/orgh7i7JukB+LIEJmlRlmvoKMDy94ZJrgGiWZn4=; b=oscIs4jcLQ/H/pIAIEcWRH1UuJ
	5LK/eSZ6W2JZDMCo6nnFviBb4mblJSzVsLNO6B8HAOMmp+qeHzTjN84X8LIW4TpX/7W7LZvbQP5qY
	KZx1IFTMn4rG9QGAEP/ThwOA5gLnIpjk10jpqIzyjW2xAxk1Q75bvwh2qR37kybtmDDuOl9LWL/2L
	5iBEGRVoKvGz072Rd8EEYyPo/8bJMPddmN9YCXh6tUKUU6wy9u20KOoHYnVdWP+UVcDmz9hWB2YH9
	5G7EkdlW/vrVtcRRBnJu/EV4+SB6/p1HGwYyTkPiwfojrOSi/XCbUhunIOn419hT1qlQ33GLsMNSm
	jEJV60cA==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5Uw-00000009IFz-1jkT;
	Mon, 17 Jun 2024 06:05:46 +0000
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
	linux-block@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 04/26] loop: stop using loop_reconfigure_limits in __loop_clr_fd
Date: Mon, 17 Jun 2024 08:04:31 +0200
Message-ID: <20240617060532.127975-5-hch@lst.de>
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

__loop_clr_fd wants to clear all settings on the device.  Prepare for
moving more settings into the block limits by open coding
loop_reconfigure_limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/loop.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 93780f41646b75..fd671028fa8554 100644
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
+	lim.logical_block_size = SECTOR_SIZE;
+	lim.physical_block_size = SECTOR_SIZE;
+	lim.io_min = SECTOR_SIZE;
+	queue_limits_commit_update(lo->lo_queue, &lim);
+
 	invalidate_disk(lo->lo_disk);
 	loop_sysfs_exit(lo);
 	/* let user-space know about this change */
-- 
2.43.0



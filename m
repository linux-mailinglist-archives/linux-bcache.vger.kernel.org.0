Return-Path: <linux-bcache+bounces-618-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D46990A3EC
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D98A1C22D55
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368B418413E;
	Mon, 17 Jun 2024 06:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kXJ7ztHF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4AB1836C7;
	Mon, 17 Jun 2024 06:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604364; cv=none; b=FURk4sDpDjzJUVfSAVPgZH496UlwLldPqsg0dRCwVvK6wwMD8OV1BoWGJCxEVi5yW+i0baK0TcfWpC6UziJupNWvN1ncin6eNpkrvvlmfaHzBL0xIiC+hEV2+TLl7mfnr9jkTt4kXTAakRc/N9mdJDg7WqchinEJ7dEqVrIL9Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604364; c=relaxed/simple;
	bh=yxPlERr7INTVihhxrFmzgmeCrzlBY2LFuOFbPxGRaQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuHoZD+jbpcREyt7sWqgbs8MQNR0Dis0iIgEv4Gnwn6gJchTEOIrVbBkeCPTJ/CQcuoI7qgY1yIf3M23+s1KixR0QG6hlJUMVxFs94ot3VIS6H+Iu4ajN1hQEJqLwT99LzRuc3oBJfpa8vOL6nv046rCvYDZpWp/QmsgJaczu58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kXJ7ztHF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=meZuXUdMqnfJKNa8LwE+49M6ExyQLw1VDUKKaUAtY/k=; b=kXJ7ztHFcc1IoznmhgthEbCn2W
	e1Zl0vH8pJJ+B1epWy41WO2zQGJBi7XGUy+4DCl9YDXMqTyH3anZVULv8jW+BHuwQ85BKjVgecb4w
	hAGHoW9h4WP4v1QYat3Jf10IP4aUS7o6JZkLXgjO/8HcnWdwF4gdFcc7AKgkddhvpiw4wY1zPxXr8
	3mk8eCEPPsZL/pesCm8st49vLZsZi08TeEmgYQj7DQG8b6JLAICjztbtSkI7ROD2ePH/Irbhf7bQ+
	3BFsrlrwOKGuxd2zhlnwTsZISXTPAagKKPg7HdaG9zcqs83W9ES5qTSx7HYqlSblbPpRJLwJC6SUc
	Bt14RRKQ==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5Uz-00000009IIF-1FWI;
	Mon, 17 Jun 2024 06:05:49 +0000
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
Subject: [PATCH 05/26] loop: always update discard settings in loop_reconfigure_limits
Date: Mon, 17 Jun 2024 08:04:32 +0200
Message-ID: <20240617060532.127975-6-hch@lst.de>
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

Simplify loop_reconfigure_limits by always updating the discard limits.
This adds a little more work to loop_set_block_size, but doesn't change
the outcome as the discard flag won't change.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/loop.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fd671028fa8554..ce197cbea5f434 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -975,8 +975,7 @@ loop_set_status_from_info(struct loop_device *lo,
 	return 0;
 }
 
-static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize,
-		bool update_discard_settings)
+static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize)
 {
 	struct queue_limits lim;
 
@@ -984,8 +983,7 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize,
 	lim.logical_block_size = bsize;
 	lim.physical_block_size = bsize;
 	lim.io_min = bsize;
-	if (update_discard_settings)
-		loop_config_discard(lo, &lim);
+	loop_config_discard(lo, &lim);
 	return queue_limits_commit_update(lo->lo_queue, &lim);
 }
 
@@ -1086,7 +1084,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	else
 		bsize = 512;
 
-	error = loop_reconfigure_limits(lo, bsize, true);
+	error = loop_reconfigure_limits(lo, bsize);
 	if (WARN_ON_ONCE(error))
 		goto out_unlock;
 
@@ -1496,7 +1494,7 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	invalidate_bdev(lo->lo_device);
 
 	blk_mq_freeze_queue(lo->lo_queue);
-	err = loop_reconfigure_limits(lo, arg, false);
+	err = loop_reconfigure_limits(lo, arg);
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue);
 
-- 
2.43.0



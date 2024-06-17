Return-Path: <linux-bcache+bounces-621-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEF690A41E
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3095B1F23C1F
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8769E18629E;
	Mon, 17 Jun 2024 06:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aj7ZQCaJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036E01850B1;
	Mon, 17 Jun 2024 06:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604374; cv=none; b=IuvGfZwRfoijmBTbjnwOLvCcPXn0CVO4J8brBS2gooJgViPoeaQxmmUFsapztrz0m+N60dm3qSIItjyVXxUmzztSjd9wFKCaUwWOGxer9oTrecgotbuhrgvLe9Gy3IOl2OL6a5zIT4e5h7Wm9ZPXAmkiTmLXQDIIEUI7FNOEK/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604374; c=relaxed/simple;
	bh=41FKTzmYMIVxC7l/tikaEbnKJZo/Rq1AA4bUDeXviBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjDxB5tOyUcCiSt87Kcw9Z0bCeJB+5V+Q8YWuXTMC6PMEfdKNdkgDB0tsh5gyz3DCoVSd5luOHqV29btZBXhjhFcYrB14rLMNZEnnKURVDOf+ELkmFRAw5phMSpgsuSMJ/C3hA+KwGFTX0JO8C6careGcfR83WyD/HWzMZOkMUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aj7ZQCaJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jO/BbvgdYshCVZegwApTYZew4tnox1zjQOC4cbYeSu8=; b=aj7ZQCaJ/Dw/+h4IVcq1v/5m21
	sd6Y2Jb9o7hr0/IPKveOSVb06koCuObSZOOJJS6BaHZrJMVlgKKzavHrMLF/sMnjznKhVuicLMLke
	v9g+0MseSnUCixJ8sOmO6tut3X5QCQCkwOdnVaTVM0xP9Q8KYLnN68GkSujOXDXYgpoq6COw9lhFA
	AsajI2zI/HE5waax+l/bJjII8Ex/A1pXxfAuQwIIdOSj6FGB/F8zL+vLgbpFDG3rcgB9IVB40hwrn
	Nu/xx2wm6ebX4Y16PCW+jpxcNvz7wCipxzDDnXo4ON8dGg3rMzr5qGXsWWvROR2prjhZAamPxmBfY
	vLU/nybQ==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5V8-00000009IPz-27ba;
	Mon, 17 Jun 2024 06:05:59 +0000
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
Subject: [PATCH 08/26] loop: fold loop_update_rotational into loop_reconfigure_limits
Date: Mon, 17 Jun 2024 08:04:35 +0200
Message-ID: <20240617060532.127975-9-hch@lst.de>
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

This prepares for moving the rotational flag into the queue_limits and
also fixes it for the case where the loop device is backed by a block
device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/loop.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6a4826708a3acf..8991de8fb1bb0b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -916,24 +916,6 @@ static void loop_free_idle_workers_timer(struct timer_list *timer)
 	return loop_free_idle_workers(lo, false);
 }
 
-static void loop_update_rotational(struct loop_device *lo)
-{
-	struct file *file = lo->lo_backing_file;
-	struct inode *file_inode = file->f_mapping->host;
-	struct block_device *file_bdev = file_inode->i_sb->s_bdev;
-	struct request_queue *q = lo->lo_queue;
-	bool nonrot = true;
-
-	/* not all filesystems (e.g. tmpfs) have a sb->s_bdev */
-	if (file_bdev)
-		nonrot = bdev_nonrot(file_bdev);
-
-	if (nonrot)
-		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
-	else
-		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
-}
-
 /**
  * loop_set_status_from_info - configure device from loop_info
  * @lo: struct loop_device to configure
@@ -1003,6 +985,10 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize)
 	lim.logical_block_size = bsize;
 	lim.physical_block_size = bsize;
 	lim.io_min = bsize;
+	if (!backing_bdev || bdev_nonrot(backing_bdev))
+		blk_queue_flag_set(QUEUE_FLAG_NONROT, lo->lo_queue);
+	else
+		blk_queue_flag_clear(QUEUE_FLAG_NONROT, lo->lo_queue);
 	loop_config_discard(lo, &lim);
 	return queue_limits_commit_update(lo->lo_queue, &lim);
 }
@@ -1099,7 +1085,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	if (WARN_ON_ONCE(error))
 		goto out_unlock;
 
-	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
 
-- 
2.43.0



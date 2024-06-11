Return-Path: <linux-bcache+bounces-514-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8CE903016
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:21:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1B9D286832
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A57172BAC;
	Tue, 11 Jun 2024 05:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sHoQc0fU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B901170821;
	Tue, 11 Jun 2024 05:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718083200; cv=none; b=I/QxS+JAJE8VgeQ1EkAetKfK7sPNNv6Kcn3WZsl2hbhX4pU6raW0RoC4qpH4zx+mCT2QLl/a+buUaMMh42xyBlNVbwj/OGG1zgULbnUiu8/Qub1lOuAyY4+eqvbNYrqbxndgC7TMUjshDNv0uY+9f1ofMd8Cy6Oz6C1QzT8piBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718083200; c=relaxed/simple;
	bh=QNCPkJ7GdaS6TAdsxGmKEXiDKHNr4FjIPPM6Ixck12A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPHjniA8Xjp5lKUVhdCAQ02AsIFLDXALPh6ZQ5dFpmDk1Jn3O/JD4diYI++VBlnrCVoB5OqZ+cr5a7BX4jFh0r4BDNnaL339nQyH0k1FqqePuEfl4yk3ETYBtvsCOgVLuurrYGEZke8WTZFx0/wilr5OWEm3ixSRAHdZsMGGMHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sHoQc0fU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eTQ/ypSzK4lWAaVunDc3tjHt1iOpV7nN08jg8TeOXAw=; b=sHoQc0fUtpHycjsITV56G6LvHu
	Xm6IZXN1xSVejiDFIWNtspmlJUAy3p7hyoPQDHaK2j8uPpjWRbLpfhR0ew8O9GOJzk9M0kamdKVSK
	h+gO2FlpjqqnZU18qlfXHcI65jms2sw8Gusy9MG0fvAfD2y9LgREXQqEidgiJekt6Ad0BXV8H7wJ7
	laGv8UKsVQsPiuQ/hLbDrBliLkQDBQpg9pL4x4e1mvw/4MdqnWTVfp+cTO0elCEI+YMIJ7UGMAb5i
	o+KErO/5ahImbdE+1ecP+Db6dV/kjpPeVfK/+qvScno/vTvojiYJmwz/wDzBrXkKvWBAHc0v7OlDs
	cGWiEsNA==;
Received: from 2a02-8389-2341-5b80-cdb4-8e7d-405d-6b77.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cdb4:8e7d:405d:6b77] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGtv6-00000007Qry-3x0S;
	Tue, 11 Jun 2024 05:19:48 +0000
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
Subject: [PATCH 05/26] loop: regularize upgrading the lock size for direct I/O
Date: Tue, 11 Jun 2024 07:19:05 +0200
Message-ID: <20240611051929.513387-6-hch@lst.de>
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

The LOOP_CONFIGURE path automatically upgrades the block size to that
of the underlying file for O_DIRECT file descriptors, but the
LOOP_SET_BLOCK_SIZE path does not.  Fix this by lifting the code to
pick the block size into common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c658282454af1b..4f6d8514d19bd6 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -975,10 +975,24 @@ loop_set_status_from_info(struct loop_device *lo,
 	return 0;
 }
 
+static unsigned short loop_default_blocksize(struct loop_device *lo,
+		struct block_device *backing_bdev)
+{
+	/* In case of direct I/O, match underlying block size */
+	if ((lo->lo_backing_file->f_flags & O_DIRECT) && backing_bdev)
+		return bdev_logical_block_size(backing_bdev);
+	return 512;
+}
+
 static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize)
 {
+	struct file *file = lo->lo_backing_file;
+	struct inode *inode = file->f_mapping->host;
 	struct queue_limits lim;
 
+	if (!bsize)
+		bsize = loop_default_blocksize(lo, inode->i_sb->s_bdev);
+
 	lim = queue_limits_start_update(lo->lo_queue);
 	lim.logical_block_size = bsize;
 	lim.physical_block_size = bsize;
@@ -997,7 +1011,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	int error;
 	loff_t size;
 	bool partscan;
-	unsigned short bsize;
 	bool is_loop;
 
 	if (!file)
@@ -1076,15 +1089,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 	if (!(lo->lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_write_cache(lo->lo_queue, true, false);
 
-	if (config->block_size)
-		bsize = config->block_size;
-	else if ((lo->lo_backing_file->f_flags & O_DIRECT) && inode->i_sb->s_bdev)
-		/* In case of direct I/O, match underlying block size */
-		bsize = bdev_logical_block_size(inode->i_sb->s_bdev);
-	else
-		bsize = 512;
-
-	error = loop_reconfigure_limits(lo, bsize);
+	error = loop_reconfigure_limits(lo, config->block_size);
 	if (WARN_ON_ONCE(error))
 		goto out_unlock;
 
-- 
2.43.0



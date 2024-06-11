Return-Path: <linux-bcache+bounces-515-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2703E903021
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B82ABB217F5
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91D6171065;
	Tue, 11 Jun 2024 05:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EJfeUdDK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365B6170821;
	Tue, 11 Jun 2024 05:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718083203; cv=none; b=qDRmYu3jbSqZpWjwu4zKIqT4Y5JAKHlGVCIH7GQw43yPiuOQa8zMJFbXvySHSnc2C0ESp7lL+4OAEHlpj2QBYw1KijeaAEEzcSvd+U4qtyUwKlxeVWs/26lepUxlKB6wAr/EceqVw86A9wLJF4EON79Av/OgxXJHB0goEfCCuxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718083203; c=relaxed/simple;
	bh=1tqAK1mW8JsBjEO7cUHdh2P/GQemnQR8d0cjjQXqMZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxBrYtX9yGIDb+oBB+2Sr3ZBPp7RTxJPCggnfiCBcN9wz4L0FsuCHwNTsD9M+jw9eOScrtjwiNhaT0gQI1j585ZSZU7wGatgvDBoY+4GI4tIEgwY4SSKfmor73PQIHWe+ktRV230l+XpvrXYS7sLd8Q5qzWq1+4PUb2m9nw55Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EJfeUdDK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ssio61bxvyjbVvX4GR2JkhWcuVQT+rCdDVvaw5rJLVc=; b=EJfeUdDKwEweKUiqH+eMopsdVZ
	x0gPUHB6qGWFYwZZXoBfv6LI+X2dpdCL1TKhBlBBGZmhekTG11CsY1Tp8gFm1z77BgnAggRFyPHtv
	/dS9x1QJgeNzRrx5rQgmApC3kW21NnhiRIEaqoJzqGn3bNpz/08IyT53p4q+cqbxaW2iE/+UsRzno
	ybACNAR9eGBjFjHk1OhTQhWhdG1r7xhSZGewPFQ+tjMcJUiDtfg4DFIXSmxBMyXPF8Somg+Z608jF
	modWNKz1rFqGQflCfEdrX2jtnU5vYnXih6AoW/RLdg3bhHrcGssn0BCXi6xxJfpGEC4cpZmmzl8lq
	/NJxmiHw==;
Received: from 2a02-8389-2341-5b80-cdb4-8e7d-405d-6b77.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cdb4:8e7d:405d:6b77] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sGtvC-00000007QuL-20ql;
	Tue, 11 Jun 2024 05:19:51 +0000
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
Subject: [PATCH 06/26] loop: also use the default block size from an underlying block device
Date: Tue, 11 Jun 2024 07:19:06 +0200
Message-ID: <20240611051929.513387-7-hch@lst.de>
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

Fix the code in loop_reconfigure_limits to pick a default block size for
O_DIRECT file descriptors to also work when the loop device sits on top
of a block device and not just on a regular file on a block device based
file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 4f6d8514d19bd6..d7cf6bbbfb1b86 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -988,10 +988,16 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize)
 {
 	struct file *file = lo->lo_backing_file;
 	struct inode *inode = file->f_mapping->host;
+	struct block_device *backing_bdev = NULL;
 	struct queue_limits lim;
 
+	if (S_ISBLK(inode->i_mode))
+		backing_bdev = I_BDEV(inode);
+	else if (inode->i_sb->s_bdev)
+		backing_bdev = inode->i_sb->s_bdev;
+
 	if (!bsize)
-		bsize = loop_default_blocksize(lo, inode->i_sb->s_bdev);
+		bsize = loop_default_blocksize(lo, backing_bdev);
 
 	lim = queue_limits_start_update(lo->lo_queue);
 	lim.logical_block_size = bsize;
-- 
2.43.0



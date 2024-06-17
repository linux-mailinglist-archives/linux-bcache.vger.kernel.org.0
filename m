Return-Path: <linux-bcache+bounces-620-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4058E90A413
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3155E1C230AD
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E85818F2CD;
	Mon, 17 Jun 2024 06:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n9i+YZUf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B60B1850B1;
	Mon, 17 Jun 2024 06:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604369; cv=none; b=hg12TuQLKrvgK99qNKXdGXLqkrnhWT/qDVl6frKVhNc8LTxt3FZUJpfQgdayYCph1vJNFAV6Q1QhdFN3V1MAh2Od5MGdOCT1s9pwGBtYxkZhJzWQb59N7Pi7cd/dkPX8EB9vw7HSFCy0Jr2WuQDPb7FJFUsqtezOmaVsS57cv8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604369; c=relaxed/simple;
	bh=ig4JFparG6fIyQYRsREWbbHcOTr9+m4NOImJE8fKH9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAxyftkXN0b/FTbuqsV8ddhzGgaZZqUBLkImvvprTCcT8Fz50UnEiM4QX9EI0WTLOFNl6gP6Z6PK/eiX+SvrYuyMQInyO+gx7YJDShhaB5pZKkIfSs3yA+ikfWocWIfDdXPpdopdaCvFtNzKKK+IJgIE7gDjkgL+SNuuR2Aw+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n9i+YZUf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Oo/vqAiMbhGGIUiVbZp/kGzW4LeWY27HMYwjVP6TG+4=; b=n9i+YZUfzxRGa/5geWOPJ7qmNM
	VGAksmvvlnyjAcGKbffm0w8YFWj/mx8ZeNfKbo6XukT1i4z/7qqCv7AqN6cGKNzTZRqs/Rlz98kse
	B60tDUVnvOqPTZ+j07UJh958Lv8xgGd4u21/L50kdMEfOjqnyL+uFLGe/y8Jv2z/tzRoXpfQiVdrY
	jeQ4b6Snlu8NDUy4NjmqAdaKi/3dfCdJChMAKWZrLWqfJnBAbbSVrAz3dOz942P3jNCFUIPZAuF0V
	lyFA/GeDUiQcFhHunnGHw4c5QrxgmJmSg34SATZmhO2AM5VBka2mQq5u28GalsDqRmL602GT6Qes+
	Nt4+DKVg==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5V5-00000009IO0-2EQA;
	Mon, 17 Jun 2024 06:05:56 +0000
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
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 07/26] loop: also use the default block size from an underlying block device
Date: Mon, 17 Jun 2024 08:04:34 +0200
Message-ID: <20240617060532.127975-8-hch@lst.de>
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

Fix the code in loop_reconfigure_limits to pick a default block size for
O_DIRECT file descriptors to also work when the loop device sits on top
of a block device and not just on a regular file on a block device based
file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/block/loop.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index eea3e4919e356e..6a4826708a3acf 100644
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



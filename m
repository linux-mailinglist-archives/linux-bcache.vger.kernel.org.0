Return-Path: <linux-bcache+bounces-624-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 135CB90A441
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:09:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABDA91F23DA6
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2FC190489;
	Mon, 17 Jun 2024 06:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3GbbfR6o"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD15A19006D;
	Mon, 17 Jun 2024 06:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604386; cv=none; b=XZ0zTMXCMMHacT49Aji5IZ0OpIFZS/lIa6J0ct1AflT26pat/LcS0siBBNcEi6bWfewNR01rXBFGuAEZ7JYuyeNddf7kZXNPoG6xT4XSZyEQCRUHXmKK6tMJHVBLvDk/pL+M6CfV2pperNQx1ongf7sV6luMNMAYcQXczt96SNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604386; c=relaxed/simple;
	bh=psOPVDCC1+kaXZoLGKJFg9G8iMdgyiftwocbLD07D/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6JRy31iUI98mrAjqRdII8kgVPooElQ00UwAREOfc0W8RFdAJB56Jpc+To/amK0vF08kHqxmXmW/+TNI4eFCURTnKpS7jEOU0euS0ArgO+dheC90IeC04ANwNf82mIHOlaJX7WINxorKGT1IzIoayYh2wxxX5GyasD5JNpV7/NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3GbbfR6o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nxrpabn3Yr7lfkqLutYlwz8cLBay3S4a7er01YqK4F0=; b=3GbbfR6oFpvEzbS2oqb0oMYMb+
	vqbV+2hZnIKX5lmR5QgZlLvnc0rJ2iit5xTHKYaGb9SJqJcZlOfTA6zcbvntPb1Mru5TE9/q6H45n
	19Qfjq1hppB4GOL4exJE6AwoSdINllOz9afFax9HKV1yIlpLy6TmyrnAQy5qwQMQNr7wNK53aH1xH
	SISmmh7ZH7/J6+77ZtbQLY1fpW/7mGqQvnVPmK8FpFL6vWGEFgZQxWrh6KnYBifPtspD+lbza+mC3
	/LOD/BEvCMU6Az9Z7rUSmmuvgHWX5bBPf/2gvUdUSDM49z0i7Rb2ZQwMZLDJBbnCqWBn8gW4Op6iX
	HXdocZug==;
Received: from [91.187.204.140] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ5VG-00000009IXq-2cbZ;
	Mon, 17 Jun 2024 06:06:07 +0000
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
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/26] block: freeze the queue in queue_attr_store
Date: Mon, 17 Jun 2024 08:04:38 +0200
Message-ID: <20240617060532.127975-12-hch@lst.de>
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

queue_attr_store updates attributes used to control generating I/O, and
can cause malformed bios if changed with I/O in flight.  Freeze the queue
in common code instead of adding it to almost every attribute.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq.c    | 5 +++--
 block/blk-sysfs.c | 9 ++-------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0d4cd39c3d25da..58b0d6c7cc34d6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4631,13 +4631,15 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	int ret;
 	unsigned long i;
 
+	if (WARN_ON_ONCE(!q->mq_freeze_depth))
+		return -EINVAL;
+
 	if (!set)
 		return -EINVAL;
 
 	if (q->nr_requests == nr)
 		return 0;
 
-	blk_mq_freeze_queue(q);
 	blk_mq_quiesce_queue(q);
 
 	ret = 0;
@@ -4671,7 +4673,6 @@ int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr)
 	}
 
 	blk_mq_unquiesce_queue(q);
-	blk_mq_unfreeze_queue(q);
 
 	return ret;
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f0f9314ab65c61..5c787965b7d09e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -189,12 +189,9 @@ static ssize_t queue_discard_max_store(struct request_queue *q,
 	if ((max_discard_bytes >> SECTOR_SHIFT) > UINT_MAX)
 		return -EINVAL;
 
-	blk_mq_freeze_queue(q);
 	lim = queue_limits_start_update(q);
 	lim.max_user_discard_sectors = max_discard_bytes >> SECTOR_SHIFT;
 	err = queue_limits_commit_update(q, &lim);
-	blk_mq_unfreeze_queue(q);
-
 	if (err)
 		return err;
 	return ret;
@@ -241,11 +238,9 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 	if (ret < 0)
 		return ret;
 
-	blk_mq_freeze_queue(q);
 	lim = queue_limits_start_update(q);
 	lim.max_user_sectors = max_sectors_kb << 1;
 	err = queue_limits_commit_update(q, &lim);
-	blk_mq_unfreeze_queue(q);
 	if (err)
 		return err;
 	return ret;
@@ -585,13 +580,11 @@ static ssize_t queue_wb_lat_store(struct request_queue *q, const char *page,
 	 * ends up either enabling or disabling wbt completely. We can't
 	 * have IO inflight if that happens.
 	 */
-	blk_mq_freeze_queue(q);
 	blk_mq_quiesce_queue(q);
 
 	wbt_set_min_lat(q, val);
 
 	blk_mq_unquiesce_queue(q);
-	blk_mq_unfreeze_queue(q);
 
 	return count;
 }
@@ -722,9 +715,11 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (!entry->store)
 		return -EIO;
 
+	blk_mq_freeze_queue(q);
 	mutex_lock(&q->sysfs_lock);
 	res = entry->store(q, page, length);
 	mutex_unlock(&q->sysfs_lock);
+	blk_mq_unfreeze_queue(q);
 	return res;
 }
 
-- 
2.43.0



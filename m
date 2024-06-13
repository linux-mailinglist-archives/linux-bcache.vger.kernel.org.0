Return-Path: <linux-bcache+bounces-608-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6024907496
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2024 16:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C9BC1F22DA4
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2024 14:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A395B14535D;
	Thu, 13 Jun 2024 14:05:17 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE08E14265A;
	Thu, 13 Jun 2024 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718287517; cv=none; b=EZJ5VO1JTH4bEyt0l3SFMMAsVQo6FqaJltk0kiP1g7vu6bxs05AioPwyasPiAzbLrS8iw8qo9roBQyw2mJYNGkCeAn4VZxMvtka+1dWmIbgXAsedyG8lB6A9n5D47TAA2XCMNJCMW2nwufu/zqV8Cw50TRVnK0onNn/fyN4nSEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718287517; c=relaxed/simple;
	bh=mWqCF/Q1ylazfgkNhXCkkB36nGt3iLW/vFBDPsVVQaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rK3Mwirb3K5rNlrF3rbX7FxZMFpMCgFZk4VvCPJgkLs9goBVg7wjTIWvZetIGkkcsdnVaRMHZVt3RA3wu5uBvzYRnzZ5OndA66TEG1SxjwLPvJ4LEvx4TBEK/gstJ24pxmZRt4oqzjR1g2+pCh37ixccsbqCQ17yV7KvSQZALD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C2B2968BEB; Thu, 13 Jun 2024 16:05:08 +0200 (CEST)
Date: Thu, 13 Jun 2024 16:05:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 10/26] xen-blkfront: don't disable cache flushes when
 they fail
Message-ID: <20240613140508.GA16529@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-11-hch@lst.de> <ZmlVziizbaboaBSn@macbook> <20240612150030.GA29188@lst.de> <ZmnFH17bTV2Ot_iR@macbook>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZmnFH17bTV2Ot_iR@macbook>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 12, 2024 at 05:56:15PM +0200, Roger Pau Monné wrote:
> Right.  AFAICT advertising "feature-barrier" and/or
> "feature-flush-cache" could be done based on whether blkback
> understand those commands, not on whether the underlying storage
> supports the equivalent of them.
> 
> Worst case we can print a warning message once about the underlying
> storage failing to complete flush/barrier requests, and that data
> integrity might not be guaranteed going forward, and not propagate the
> error to the upper layer?
> 
> What would be the consequence of propagating a flush error to the
> upper layers?

If you propage the error to the upper layer you will generate an
I/O error there, which usually leads to a file system shutdown.

> Given the description of the feature in the blkif header, I'm afraid
> we cannot guarantee that seeing the feature exposed implies barrier or
> flush support, since the request could fail at any time (or even from
> the start of the disk attachment) and it would still sadly be a correct
> implementation given the description of the options.

Well, then we could do something like the patch below, which keeps
the existing behavior, but insolates the block layer from it and
removes the only user of blk_queue_write_cache from interrupt
context:

---
From e6e82c769ab209a77302994c3829cf6ff7a595b8 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 30 May 2024 08:58:52 +0200
Subject: xen-blkfront: don't disable cache flushes when they fail

blkfront always had a robust negotiation protocol for detecting a write
cache.  Stop simply disabling cache flushes in the block layer as the
flags handling is moving to the atomic queue limits API that needs
user context to freeze the queue for that.  Instead handle the case
of the feature flags cleared inside of blkfront.  This removes old
debug code to check for such a mismatch which was previously impossible
to hit, including the check for passthrough requests that blkfront
never used to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/xen-blkfront.c | 44 +++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9b4ec3e4908cce..e2c92d5095ff17 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -788,6 +788,14 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 			 * A barrier request a superset of FUA, so we can
 			 * implement it the same way.  (It's also a FLUSH+FUA,
 			 * since it is guaranteed ordered WRT previous writes.)
+			 *
+			 * Note that can end up here with a FUA write and the
+			 * flags cleared.  This happens when the flag was
+			 * run-time disabled and raced with I/O submission in
+			 * the block layer.  We submit it as a normal write
+			 * here.  A pure flush should never end up here with
+			 * the flags cleared as they are completed earlier for
+			 * the !feature_flush case.
 			 */
 			if (info->feature_flush && info->feature_fua)
 				ring_req->operation =
@@ -795,8 +803,6 @@ static int blkif_queue_rw_req(struct request *req, struct blkfront_ring_info *ri
 			else if (info->feature_flush)
 				ring_req->operation =
 					BLKIF_OP_FLUSH_DISKCACHE;
-			else
-				ring_req->operation = 0;
 		}
 		ring_req->u.rw.nr_segments = num_grant;
 		if (unlikely(require_extra_req)) {
@@ -887,16 +893,6 @@ static inline void flush_requests(struct blkfront_ring_info *rinfo)
 		notify_remote_via_irq(rinfo->irq);
 }
 
-static inline bool blkif_request_flush_invalid(struct request *req,
-					       struct blkfront_info *info)
-{
-	return (blk_rq_is_passthrough(req) ||
-		((req_op(req) == REQ_OP_FLUSH) &&
-		 !info->feature_flush) ||
-		((req->cmd_flags & REQ_FUA) &&
-		 !info->feature_fua));
-}
-
 static blk_status_t blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
 			  const struct blk_mq_queue_data *qd)
 {
@@ -908,23 +904,30 @@ static blk_status_t blkif_queue_rq(struct blk_mq_hw_ctx *hctx,
 	rinfo = get_rinfo(info, qid);
 	blk_mq_start_request(qd->rq);
 	spin_lock_irqsave(&rinfo->ring_lock, flags);
-	if (RING_FULL(&rinfo->ring))
-		goto out_busy;
 
-	if (blkif_request_flush_invalid(qd->rq, rinfo->dev_info))
-		goto out_err;
+	/*
+	 * Check if the backend actually supports flushes.
+	 *
+	 * While the block layer won't send us flushes if we don't claim to
+	 * support them, the Xen protocol allows the backend to revoke support
+	 * at any time.  That is of course a really bad idea and dangerous, but
+	 * has been allowed for 10+ years.  In that case we simply clear the
+	 * flags, and directly return here for an empty flush and ignore the
+	 * FUA flag later on.
+	 */
+	if (unlikely(req_op(qd->rq) == REQ_OP_FLUSH && !info->feature_flush))
+		goto out;
 
+	if (RING_FULL(&rinfo->ring))
+		goto out_busy;
 	if (blkif_queue_request(qd->rq, rinfo))
 		goto out_busy;
 
 	flush_requests(rinfo);
+out:
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
 	return BLK_STS_OK;
 
-out_err:
-	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
-	return BLK_STS_IOERR;
-
 out_busy:
 	blk_mq_stop_hw_queue(hctx);
 	spin_unlock_irqrestore(&rinfo->ring_lock, flags);
@@ -1627,7 +1630,6 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
 					blkif_req(req)->error = BLK_STS_OK;
 				info->feature_fua = 0;
 				info->feature_flush = 0;
-				xlvbd_flush(info);
 			}
 			fallthrough;
 		case BLKIF_OP_READ:
-- 
2.43.0



Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7496302A0F
	for <lists+linux-bcache@lfdr.de>; Mon, 25 Jan 2021 19:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbhAYSWu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 Jan 2021 13:22:50 -0500
Received: from verein.lst.de ([213.95.11.211]:45173 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbhAYSWe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 13:22:34 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id A43DB68B02; Mon, 25 Jan 2021 19:21:50 +0100 (CET)
Date:   Mon, 25 Jan 2021 19:21:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: do not reassig ->bi_bdev when partition
 remapping
Message-ID: <20210125182150.GA15367@lst.de>
References: <20210124100241.1167849-1-hch@lst.de> <20210124100241.1167849-6-hch@lst.de> <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk> <20210125175528.GA13451@lst.de> <2b600368-96fa-7caf-f05b-321de616f7c9@kernel.dk> <13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk> <20210125181349.GA14432@lst.de> <1c0fabdc-9b73-dfd7-f49d-c211d58cbf12@kernel.dk> <20210125181826.GA14957@lst.de> <22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Jan 25, 2021 at 11:19:23AM -0700, Jens Axboe wrote:
> On 1/25/21 11:18 AM, Christoph Hellwig wrote:
> > On Mon, Jan 25, 2021 at 11:15:04AM -0700, Jens Axboe wrote:
> >> On 1/25/21 11:13 AM, Christoph Hellwig wrote:
> >>> On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
> >>>> Partition table entries are not in disk order.
> >>>
> >>> And the issue shows up with the series just up to the this patch,
> >>> without any later patches?
> >>
> >> At that patch specifically. I bisected it, and then I double checked
> >> by running the previous commit (boots fine), then apply this one, and
> >> then I run into that error. So it should be 100% reliable.
> > 
> > Ok, I have an idea.  With EOD message you mean this printk, right:
> > 
> > 	pr_info_ratelimited("attempt to access beyond end of device\n"
> >                             "%s: rw=%d, want=%llu, limit=%llu\n",
> > 			    ...
> > 
> > right?
> 
> Yep

Can you give this untested patch a spin?  This should fix the
case where we check the eod for the original partition with the
remapped bi_sectors.  Looking into a local reproducer now.

diff --git a/block/blk-core.c b/block/blk-core.c
index 88f60890443264..6253a2f9a1c08f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -813,13 +813,16 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 
 	if (should_fail_bio(bio))
 		goto end_io;
+
 	if (unlikely(bio_check_ro(bio)))
 		goto end_io;
-	if (unlikely(bio_check_eod(bio)))
-		goto end_io;
-	if (bio->bi_bdev->bd_partno && !bio_flagged(bio, BIO_REMAPPED) &&
-	    unlikely(blk_partition_remap(bio)))
-		goto end_io;
+	if (!bio_flagged(bio, BIO_REMAPPED)) {
+		if (unlikely(bio_check_eod(bio)))
+			goto end_io;
+		if (bio->bi_bdev->bd_partno &&
+		    unlikely(blk_partition_remap(bio)))
+			goto end_io;
+	}
 
 	/*
 	 * Filter flush bio's early so that bio based drivers without flush

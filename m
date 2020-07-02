Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B301F21277E
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jul 2020 17:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgGBPO7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Jul 2020 11:14:59 -0400
Received: from verein.lst.de ([213.95.11.211]:44496 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgGBPO7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Jul 2020 11:14:59 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9DA8768B05; Thu,  2 Jul 2020 17:14:53 +0200 (CEST)
Date:   Thu, 2 Jul 2020 17:14:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qian Cai <cai@lca.pw>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH 18/20] block: refator submit_bio_noacct
Message-ID: <20200702151453.GA1799@lst.de>
References: <20200629193947.2705954-1-hch@lst.de> <20200629193947.2705954-19-hch@lst.de> <20200702141001.GA3834@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702141001.GA3834@lca.pw>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jul 02, 2020 at 10:10:10AM -0400, Qian Cai wrote:
> On Mon, Jun 29, 2020 at 09:39:45PM +0200, Christoph Hellwig wrote:
> > Split out a __submit_bio_noacct helper for the actual de-recursion
> > algorithm, and simplify the loop by using a continue when we can't
> > enter the queue for a bio.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reverting this commit and its dependencies,
> 
> 5a6c35f9af41 block: remove direct_make_request
> ff93ea0ce763 block: shortcut __submit_bio_noacct for blk-mq drivers
> 
> fixed the stack-out-of-bounds during boot,
> 
> https://lore.kernel.org/linux-block/000000000000bcdeaa05a97280e4@google.com/

Yikes.  bio_alloc_bioset pokes into bio_list[1] in a totally
undocumented way.  But even with that the problem should only show
up with "block: shortcut __submit_bio_noacct for blk-mq drivers".

Can you try this patch?

diff --git a/block/blk-core.c b/block/blk-core.c
index bf882b8d84450c..9f1bf8658b611a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1155,11 +1155,10 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 {
 	struct gendisk *disk = bio->bi_disk;
-	struct bio_list bio_list;
+	struct bio_list bio_list[2] = { };
 	blk_qc_t ret = BLK_QC_T_NONE;
 
-	bio_list_init(&bio_list);
-	current->bio_list = &bio_list;
+	current->bio_list = bio_list;
 
 	do {
 		WARN_ON_ONCE(bio->bi_disk != disk);
@@ -1174,7 +1173,7 @@ static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
 		}
 
 		ret = blk_mq_submit_bio(bio);
-	} while ((bio = bio_list_pop(&bio_list)));
+	} while ((bio = bio_list_pop(&bio_list[0])));
 
 	current->bio_list = NULL;
 	return ret;

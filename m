Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE981E0D47
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 13:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390249AbgEYLag (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 07:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390236AbgEYLaf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 07:30:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB2C061A0E;
        Mon, 25 May 2020 04:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4l6W1pONc3UxiSnk6DubFsvt00KzTgN7kVDel1/2bWw=; b=eb5D4gdOfaLLHkXG2M6FtfiwSg
        jwjPSSnLzU1CLw+QFPZlEt7wjAExb8k+qtx9MiFRUtnFZ+m+gfyAyeYVecHMUuRQ+XUdzlU+yIDx9
        RuZdByv/M1LIWCPEg0066vJdpEsZn9WrnqyIE125/3XLg0V/tlN05+VPLggB9jMfep7Tdn5g0XoTU
        3JspDn3SzsXcMIm3lrdwcLUqF10AiAwqclcXzcSVv4gyqa5vZzRJk2ih1jzp1/eSxHUQsbHCGmg/N
        AyMEicu4E++3K4aZp0zsH+Q9xyHuwIceloLaSOh3lBJDg9pVjicjARBI+OGL/E8RPACTyXoPIonr6
        AlOV1Fcw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdBJP-0002P7-NQ; Mon, 25 May 2020 11:30:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] bcache: use bio_{start,end}_io_acct
Date:   Mon, 25 May 2020 13:30:03 +0200
Message-Id: <20200525113014.345997-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525113014.345997-1-hch@lst.de>
References: <20200525113014.345997-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Switch bcache to use the nicer bio accounting helpers, and call the
routines where we also sample the start time to give coherent accounting
results.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 77d1a26975174..22b483527176b 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -668,9 +668,7 @@ static void backing_request_endio(struct bio *bio)
 static void bio_complete(struct search *s)
 {
 	if (s->orig_bio) {
-		generic_end_io_acct(s->d->disk->queue, bio_op(s->orig_bio),
-				    &s->d->disk->part0, s->start_time);
-
+		bio_end_io_acct(s->orig_bio, s->start_time);
 		trace_bcache_request_end(s->d, s->orig_bio);
 		s->orig_bio->bi_status = s->iop.status;
 		bio_endio(s->orig_bio);
@@ -730,7 +728,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->recoverable		= 1;
 	s->write		= op_is_write(bio_op(bio));
 	s->read_dirty_data	= 0;
-	s->start_time		= jiffies;
+	s->start_time		= bio_start_io_acct(bio);
 
 	s->iop.c		= d->c;
 	s->iop.bio		= NULL;
@@ -1082,8 +1080,7 @@ static void detached_dev_end_io(struct bio *bio)
 	bio->bi_end_io = ddip->bi_end_io;
 	bio->bi_private = ddip->bi_private;
 
-	generic_end_io_acct(ddip->d->disk->queue, bio_op(bio),
-			    &ddip->d->disk->part0, ddip->start_time);
+	bio_end_io_acct(bio, ddip->start_time);
 
 	if (bio->bi_status) {
 		struct cached_dev *dc = container_of(ddip->d,
@@ -1108,7 +1105,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	ddip->d = d;
-	ddip->start_time = jiffies;
+	ddip->start_time = bio_start_io_acct(bio);
 	ddip->bi_end_io = bio->bi_end_io;
 	ddip->bi_private = bio->bi_private;
 	bio->bi_end_io = detached_dev_end_io;
@@ -1190,11 +1187,6 @@ blk_qc_t cached_dev_make_request(struct request_queue *q, struct bio *bio)
 		}
 	}
 
-	generic_start_io_acct(q,
-			      bio_op(bio),
-			      bio_sectors(bio),
-			      &d->disk->part0);
-
 	bio_set_dev(bio, dc->bdev);
 	bio->bi_iter.bi_sector += dc->sb.data_offset;
 
@@ -1311,8 +1303,6 @@ blk_qc_t flash_dev_make_request(struct request_queue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	generic_start_io_acct(q, bio_op(bio), bio_sectors(bio), &d->disk->part0);
-
 	s = search_alloc(bio, d);
 	cl = &s->cl;
 	bio = &s->bio.bio;
-- 
2.26.2


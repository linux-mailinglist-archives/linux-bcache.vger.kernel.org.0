Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7EC1E0D03
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 13:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbgEYLa2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 07:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390195AbgEYLa1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 07:30:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D35AC061A0E;
        Mon, 25 May 2020 04:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=M8Z6K3BGXpa6wsM8eRtzqUskZzTrl5sURaod/wTbfnY=; b=CVllorqXqc/DYRcbSWdIiSZXs9
        b5pSTcP5c4/8xdvxgP8qs+apR5s3hJKNksH8GjVeHL0jQQbAT3rzLoJo/Dsx04+GVyDSOk1kgsCQO
        +WAtQrlJOt7lH7bzCqplW/kKq7KGm/b5dfCKUT5yzTiFl0Una68RkKeAuTMlMZ7U2mswW1+/HOLVW
        sZ0mreBOY3iuDjWZ+0oQ7jRtEl2Y35VvDnsiDjwmv96Boj1tcTWik3nkSq0Lw3W7/uf8uR/+4w5r3
        RGe5e6jbKrX7OrlBcvTgiHm0MsAD0yO6m88H/f+zq5S8ffxtaqebSj00u56ZwSEkiFgt7knhxMEzJ
        lP6YcJ8Q==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdBJH-0002NT-0V; Mon, 25 May 2020 11:30:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/16] drbd: use bio_{start,end}_io_acct
Date:   Mon, 25 May 2020 13:30:00 +0200
Message-Id: <20200525113014.345997-3-hch@lst.de>
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

Switch drbd to use the nicer bio accounting helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_req.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 840c3aef3c5c9..c80a2f1c3c2a7 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -21,24 +21,6 @@
 
 static bool drbd_may_do_local_read(struct drbd_device *device, sector_t sector, int size);
 
-/* Update disk stats at start of I/O request */
-static void _drbd_start_io_acct(struct drbd_device *device, struct drbd_request *req)
-{
-	struct request_queue *q = device->rq_queue;
-
-	generic_start_io_acct(q, bio_op(req->master_bio),
-				req->i.size >> 9, &device->vdisk->part0);
-}
-
-/* Update disk stats when completing request upwards */
-static void _drbd_end_io_acct(struct drbd_device *device, struct drbd_request *req)
-{
-	struct request_queue *q = device->rq_queue;
-
-	generic_end_io_acct(q, bio_op(req->master_bio),
-			    &device->vdisk->part0, req->start_jif);
-}
-
 static struct drbd_request *drbd_req_new(struct drbd_device *device, struct bio *bio_src)
 {
 	struct drbd_request *req;
@@ -263,7 +245,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 		start_new_tl_epoch(first_peer_device(device)->connection);
 
 	/* Update disk stats */
-	_drbd_end_io_acct(device, req);
+	bio_end_io_acct(req->master_bio, req->start_jif);
 
 	/* If READ failed,
 	 * have it be pushed back to the retry work queue,
@@ -1222,16 +1204,15 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 		bio_endio(bio);
 		return ERR_PTR(-ENOMEM);
 	}
-	req->start_jif = start_jif;
+
+	/* Update disk stats */
+	req->start_jif = bio_start_io_acct(req->master_bio);
 
 	if (!get_ldev(device)) {
 		bio_put(req->private_bio);
 		req->private_bio = NULL;
 	}
 
-	/* Update disk stats */
-	_drbd_start_io_acct(device, req);
-
 	/* process discards always from our submitter thread */
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES ||
 	    bio_op(bio) == REQ_OP_DISCARD)
-- 
2.26.2


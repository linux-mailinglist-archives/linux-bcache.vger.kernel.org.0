Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACCC1E3818
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 07:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgE0FZ1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 01:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbgE0FY6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 01:24:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE9C061A0F;
        Tue, 26 May 2020 22:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Bqhnde9dFznWgi2aGOgRLd+HtchsYvr9PHZmbOGgvm4=; b=SUn+0mPicK4jlHHCaQrGP7lCUz
        eT3XvXAXsDRDpJXPJEUby/j+oC3UGTdirGmUi6TC2Cd7lFP1MV88zP0O6VMiKiV+yOzO447xpvHKt
        DlXXSz/CHOrcp72jA6NKbyPfxG+FCO4loHdYZN1F63x3DmHWeRqA4JP2Cp3iOakS8r3S36YQrh6sV
        FwnDTk5VPPwtTjnuyzVtXb60vfuvPwrOXi/FKSkJuPp4utdu9IlQVGAo37+ujlprGhnIT7gfoEKTa
        +3oLWmWzUbLXDlWxTC5rwkx6YSumQtpDrEE9m0tGzua9FcBhDj9TV1JddoKDK0Wnh5Jpvl3zW09tc
        xATfUvRQ==;
Received: from [2001:4bb8:18c:5da7:8164:affc:3c20:853d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdoYh-0000tS-QQ; Wed, 27 May 2020 05:24:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] block: account merge of two requests
Date:   Wed, 27 May 2020 07:24:15 +0200
Message-Id: <20200527052419.403583-13-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Also rename blk_account_io_merge() into blk_account_io_merge_request() to
distinguish it from merging request and bio.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
[hch: rebased]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-merge.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6a4538d39efd2..c3beae5c1be71 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -669,18 +669,16 @@ void blk_rq_set_mixed_merge(struct request *rq)
 	rq->rq_flags |= RQF_MIXED_MERGE;
 }
 
-static void blk_account_io_merge(struct request *req)
+static void blk_account_io_merge_request(struct request *req)
 {
 	if (blk_do_io_stat(req)) {
-		struct hd_struct *part;
-
 		part_stat_lock();
-		part = req->part;
-
-		hd_struct_put(part);
+		part_stat_inc(req->part, merges[op_stat_group(req_op(req))]);
+		hd_struct_put(req->part);
 		part_stat_unlock();
 	}
 }
+
 /*
  * Two cases of handling DISCARD merge:
  * If max_discard_segments > 1, the driver takes every bio
@@ -792,7 +790,7 @@ static struct request *attempt_merge(struct request_queue *q,
 	/*
 	 * 'next' is going away, so update stats accordingly
 	 */
-	blk_account_io_merge(next);
+	blk_account_io_merge_request(next);
 
 	/*
 	 * ownership of bio passed from next to req, return 'next' for
-- 
2.26.2


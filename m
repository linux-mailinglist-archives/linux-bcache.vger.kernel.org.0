Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69C20DA5C
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Jun 2020 22:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387969AbgF2T41 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Jun 2020 15:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387656AbgF2TkY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:24 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7EDC03E979;
        Mon, 29 Jun 2020 12:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=KKN2Rzx949H+NoG0kbydbtU4p/7MhBgkwEQu/fGRZVo=; b=oq4DxXRygnkoBpVqu4ShnFx67a
        pJSZTPl/8bQB6t5SbLzEq7GEtk7yVppnDQoMDkwlIASlkU5Gv3TVvPrB44rfw3eqnI/6/46THwVdz
        bpj2LW1dF9GjmaqLsSZnWCGOiWCgne+0b3/wk5CW3PxduJhQZcvYQZkZnB44cjXI3RV8EqpdASKu/
        RkLdLy683AjRfxZt01zPKBwDhf+S1bMB3O91CxDduFf+rpctsL9V3FYWiqw0E6KmkpHgdogcoq/bv
        FM6mYXGlxSu8Yj3wFLmkB7cMQ6vzzc2fkWPIa1S/y8ELqgdqrW/IuX4PrQsWtaDG8vRqd88y0uRuj
        7Jl9LgYQ==;
Received: from [2001:4bb8:184:76e3:fcca:c8dc:a4bf:12fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpzdN-0004Ju-WF; Mon, 29 Jun 2020 19:40:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 10/20] dm: stop using ->queuedata
Date:   Mon, 29 Jun 2020 21:39:37 +0200
Message-Id: <20200629193947.2705954-11-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Instead of setting up the queuedata as well just use one private data
field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e44473fe0f4873..c8d91f271c272e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1789,7 +1789,7 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
 
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 {
-	struct mapped_device *md = q->queuedata;
+	struct mapped_device *md = bio->bi_disk->private_data;
 	blk_qc_t ret = BLK_QC_T_NONE;
 	int srcu_idx;
 	struct dm_table *map;
@@ -1995,7 +1995,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->queue = blk_alloc_queue(dm_make_request, numa_node_id);
 	if (!md->queue)
 		goto bad;
-	md->queue->queuedata = md;
 
 	md->disk = alloc_disk_node(1, md->numa_node_id);
 	if (!md->disk)
-- 
2.26.2


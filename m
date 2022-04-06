Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACDC4F59F3
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Apr 2022 11:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349249AbiDFJa7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Apr 2022 05:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580078AbiDFJUu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Apr 2022 05:20:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31EF493CFC;
        Tue,  5 Apr 2022 23:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KJplMlY6FbMHXb00APduirYkXbPmkHGLgNPqITMnbRw=; b=FzmvEI8vSyn/6nQja0s8YlHSY0
        VDIJQLy1X4LI11OTVAkB6p326avuiTOtvq2tK01CFEmRmJZniiUIlrJg/db2cSTeDn3BnK8UtHfjF
        Hd1hHxoqa6l/bKmvn3BzIE6FjfaXuaMc9OhFqzcPs+adC89RRP4OMsXsbWyNUW2cBrtl5M/scW3ZS
        Lj8VFF3S7A0P+Y7SFdYmalWsj7RB2JqjV08XsKmJ3qf+aOpT+udOnE8mWIW2gFbPgyfgNH4Aa9T+U
        aVTywWUtPfgoEjBt9A1bREnQu97JQ8co8hwjDhGO3IKqdOsRHdta/aN9o7O5SYaY592Y3lH6IO3v3
        O45eCcag==;
Received: from 213-225-3-188.nat.highway.a1.net ([213.225.3.188] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nbyuI-003zMC-Aw; Wed, 06 Apr 2022 06:12:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
Date:   Wed,  6 Apr 2022 08:12:26 +0200
Message-Id: <20220406061228.410163-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406061228.410163-1-hch@lst.de>
References: <20220406061228.410163-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Remove pscsi_get_bio and simplify the code flow in the only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_pscsi.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ff292b75e23f9..77bd3af4b2bf8 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -821,23 +821,6 @@ static void pscsi_bi_endio(struct bio *bio)
 	bio_put(bio);
 }
 
-static inline struct bio *pscsi_get_bio(int nr_vecs)
-{
-	struct bio *bio;
-	/*
-	 * Use bio_malloc() following the comment in for bio -> struct request
-	 * in block/blk-core.c:blk_make_request()
-	 */
-	bio = bio_kmalloc(GFP_KERNEL, nr_vecs);
-	if (!bio) {
-		pr_err("PSCSI: bio_kmalloc() failed\n");
-		return NULL;
-	}
-	bio->bi_end_io = pscsi_bi_endio;
-
-	return bio;
-}
-
 static sense_reason_t
 pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		struct request *req)
@@ -878,12 +861,10 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			if (!bio) {
 new_bio:
 				nr_vecs = bio_max_segs(nr_pages);
-				/*
-				 * Calls bio_kmalloc() and sets bio->bi_end_io()
-				 */
-				bio = pscsi_get_bio(nr_vecs);
+				bio = bio_kmalloc(GFP_KERNEL, nr_vecs);
 				if (!bio)
 					goto fail;
+				bio->bi_end_io = pscsi_bi_endio;
 
 				if (rw)
 					bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
@@ -912,11 +893,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					goto fail;
 				}
 
-				/*
-				 * Clear the pointer so that another bio will
-				 * be allocated with pscsi_get_bio() above.
-				 */
-				bio = NULL;
 				goto new_bio;
 			}
 
-- 
2.30.2


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458F04D0FF7
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Mar 2022 07:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344427AbiCHGRO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 01:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbiCHGRL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 01:17:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0330233A36;
        Mon,  7 Mar 2022 22:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=A3fib0k9yE436req307FTswBKBWc48R/lbDQgd4elj8=; b=pOwqBwumoyytw0bFxg4h7/CR07
        i8rIXFCAJgs8+yKFMgrD9G/bl1aAQzx2BAkq9zWlVfFrhoGK+kKBMs/H/+gDHK9bfTY5pCBe7TN4q
        RcAhwZe6cWyh8TNZdAJyaWj1dCZPhanAJvV/Byy+ZDEJySD471pVM0zioJ82bOmxBue1X38jSvN2J
        TRMRZh2A2gjxD5wwZ/HAS6fgYeqdUL7proRaCw8AElwH16wJpxLVPhJLWN0sfEbpzkz8RlDNpTM7M
        7IhJ9Yw6TXCYSmIhAckw0ZUhhMx8ZFifHx2gdqPht8j7MT5vRR8MxY0sLqyEPqzxAJzK1zh9a2Gna
        UDkLmuHQ==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRT8c-002lW2-Ag; Tue, 08 Mar 2022 06:16:02 +0000
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
Date:   Tue,  8 Mar 2022 07:15:49 +0100
Message-Id: <20220308061551.737853-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
References: <20220308061551.737853-1-hch@lst.de>
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
index 0fae71ac5cc8a..bd8ae07273f14 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -823,23 +823,6 @@ static void pscsi_bi_endio(struct bio *bio)
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
@@ -880,12 +863,10 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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
@@ -914,11 +895,6 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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


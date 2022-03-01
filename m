Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9624C86F2
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 09:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbiCAIrC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Mar 2022 03:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiCAIqz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 03:46:55 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7588B18;
        Tue,  1 Mar 2022 00:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vZ96Fkp20C3ntwTtfrTvq6UxLwgV6UvOAhdkzhw4eFw=; b=iZxRV++Um42T1f3xr7O9OS1f2N
        I/rj9q1ZOb5kkPL6DHV3XtFjx2Hq8+TryxCn9Q3wWYXxseyLDXOZyKzhIKm8sHLkABo4lb70WeeFo
        /8toxQr8f3RpdhLCZLDiKBACefcwh9J1NddYyy1z2t5+8K6nxpptCac6Kc0Vsc3DAXJxFnwC1LtWm
        DWncsZ5bWcSf3//LqUCZFbxWx6kafxn3rZuucE1Xt7WQmoglFwxXdYGcV/hBBf7aD3FCWCeBPPrWX
        rTcxevWp4rOnLBVnUau3zC47pECBdRGwZ8cEmlUVw5zIXVqxPBvK/3OQFFnyvBwscpBOf28738vcw
        CXVls3pw==;
Received: from [2.53.44.23] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOy91-00FfQZ-Ah; Tue, 01 Mar 2022 08:46:08 +0000
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
Date:   Tue,  1 Mar 2022 10:45:50 +0200
Message-Id: <20220301084552.880256-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301084552.880256-1-hch@lst.de>
References: <20220301084552.880256-1-hch@lst.de>
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


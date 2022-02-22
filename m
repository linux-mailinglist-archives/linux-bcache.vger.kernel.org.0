Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CF94BFDBE
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Feb 2022 16:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbiBVPxQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Feb 2022 10:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbiBVPwx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Feb 2022 10:52:53 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739DD66AFD;
        Tue, 22 Feb 2022 07:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mYLMoZDjZs4nM2uUMfs8K8R/bltMADz1cEKMxm4yh5Y=; b=1PC9OGoQwio4cczU8Znx9JB5Lw
        AwZGoW2JW6FOgsQBp+725OShdlfzReuSImK8HEAbPk2SG1yravIE5BYsf4k4loJIDh0HM2WZ2ZDRe
        s0x5Rpy7gN+6mCsRNMGwWg8kZS8TP+fugbTKzetPDCfgotIQmcpNlD581e+ID3SPmH58i7wmXSO6e
        5hcDcvllwk7mwtt6Xcyt2lzF5aKF3+In45wNomLDcbEgxX7a0XDo69VO6gL+eoR8FAcWAs2uD5R/H
        sRbg6VzQbd8GSVpI+iz+FpdxcJ7kZ9mJyLQyAKrKIKDDo3PVlnZLZ1npQAfBe1sPdEtTbtB9mcGk6
        2IEUFwpw==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMXSc-00APxY-Jx; Tue, 22 Feb 2022 15:52:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Justin Sanders <justin@coraid.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Denis Efremov <efremov@linux.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        nvdimm@lists.linux.dev
Subject: [PATCH 07/10] bcache: use bvec_kmap_local in bio_csum
Date:   Tue, 22 Feb 2022 16:51:53 +0100
Message-Id: <20220222155156.597597-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222155156.597597-1-hch@lst.de>
References: <20220222155156.597597-1-hch@lst.de>
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

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/request.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6869e010475a3..4e55ca8ca67ff 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -44,10 +44,10 @@ static void bio_csum(struct bio *bio, struct bkey *k)
 	uint64_t csum = 0;
 
 	bio_for_each_segment(bv, bio, iter) {
-		void *d = kmap(bv.bv_page) + bv.bv_offset;
+		void *d = bvec_kmap_local(&bv);
 
 		csum = crc64_be(csum, d, bv.bv_len);
-		kunmap(bv.bv_page);
+		kunmap(d);
 	}
 
 	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
-- 
2.30.2


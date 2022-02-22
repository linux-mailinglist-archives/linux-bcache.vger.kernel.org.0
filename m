Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968114BFDA8
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Feb 2022 16:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbiBVPxR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Feb 2022 10:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbiBVPww (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Feb 2022 10:52:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299105FF3D;
        Tue, 22 Feb 2022 07:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=S8+4S3H0UDzuRr7Ri+YrsH/T52KS45+3M/mJXJ1lDz4=; b=u6BHbjkrjI9nVGrOchcq76/SSQ
        je48CtuVFE3/xb8Ni2UAW//vQ5vcj6gIWiRaOkjwy7XBxtOqepLlCzveme9E/3UETUyFIRgaTKwlY
        /WlyIlIQvqaNXwxZvvFWlfP9lTuTfCbGs66YZo50d2MeersSpvzkv/eD0Dk2TukzekCDR1LhmQLiS
        dl9KPrlw+/NzFsgfaV/fXP0REElbMOTDkplElq9yaFieHC2qMNyXYF43ykp+jZm0xjzN45WYRyJaN
        acOnoXVl0PeKl8BON27DJ93h3t8sjblsvfBrELXJ3lfN6+joud3zPH0vH3Q6t0YotP1iRAxjFUv0W
        KvSOPW1g==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMXSW-00APue-Ss; Tue, 22 Feb 2022 15:52:13 +0000
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
Subject: [PATCH 05/10] nvdimm-blk: use bvec_kmap_local in nd_blk_rw_integrity
Date:   Tue, 22 Feb 2022 16:51:51 +0100
Message-Id: <20220222155156.597597-6-hch@lst.de>
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
 drivers/nvdimm/blk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index c1db43524d755..0a38738335941 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -88,10 +88,9 @@ static int nd_blk_rw_integrity(struct nd_namespace_blk *nsblk,
 		 */
 
 		cur_len = min(len, bv.bv_len);
-		iobuf = kmap_atomic(bv.bv_page);
-		err = ndbr->do_io(ndbr, dev_offset, iobuf + bv.bv_offset,
-				cur_len, rw);
-		kunmap_atomic(iobuf);
+		iobuf = bvec_kmap_local(&bv);
+		err = ndbr->do_io(ndbr, dev_offset, iobuf, cur_len, rw);
+		kunmap_local(iobuf);
 		if (err)
 			return err;
 
-- 
2.30.2


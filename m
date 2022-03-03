Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633B24CBC52
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 12:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiCCLUd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Mar 2022 06:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiCCLUd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 06:20:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857F21768D0;
        Thu,  3 Mar 2022 03:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=qKDDkq38t5t7teFveRqUDl+Yuvf3JhSHyxCuJ9t8v8g=; b=DG0x3wQnJDoLnEP3ZXI5Rj92Wy
        1c/RgTh2sGTQ/3qcyDclSbBNUrYHu4iuZ/sgRuA9+vdnmXXD61thl+4pNkxCiPrR9xDd/XYqvyHaI
        ABnccZRZz/xQV/fnefV3nR5jSrk6hT6juMO1bqfjmNeas9EqXDu5uKuTYiqBaUtuPRskHrBxq90E/
        As8KtCk86/vodC95KzroV1ZUGWN1miGRPhJiEVwUikEyrxfBlIJlRbQ64InjmFz5X1LaxbyWmR3d6
        hcLNmo3tnvf9DeBmMeDYtuFEfbpuDR5bYq6sUAJVjD1LehFHA+GOaLMbLX92SZYZoqReepBIp9eI9
        0yEScKyA==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjUk-006ByU-9U; Thu, 03 Mar 2022 11:19:43 +0000
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
        Ira Weiny <ira.weiny@intel.com>, linux-xtensa@linux-xtensa.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev
Subject: [PATCH 03/10] zram: use memcpy_to_bvec in zram_bvec_read
Date:   Thu,  3 Mar 2022 14:18:58 +0300
Message-Id: <20220303111905.321089-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220303111905.321089-1-hch@lst.de>
References: <20220303111905.321089-1-hch@lst.de>
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

Use the proper helper instead of open coding the copy.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/block/zram/zram_drv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a3a5e1e713268..14becdf2815df 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1331,12 +1331,10 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		goto out;
 
 	if (is_partial_io(bvec)) {
-		void *dst = kmap_atomic(bvec->bv_page);
 		void *src = kmap_atomic(page);
 
-		memcpy(dst + bvec->bv_offset, src + offset, bvec->bv_len);
+		memcpy_to_bvec(bvec, src + offset);
 		kunmap_atomic(src);
-		kunmap_atomic(dst);
 	}
 out:
 	if (is_partial_io(bvec))
-- 
2.30.2


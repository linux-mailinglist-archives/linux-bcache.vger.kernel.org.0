Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D644CBC56
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 12:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiCCLUk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Mar 2022 06:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiCCLUk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 06:20:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3731768D0;
        Thu,  3 Mar 2022 03:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dqHSTa5nX0hxYK3KYYVcQs7zhdjSLCR3fiKudpXZiV4=; b=Pllje23oI7gKtOYg1/Im2uld14
        YiK+VQQ83xUEpBKZhxadR55eyks86GETAhyuy2eReyxklCCnmTPEAcoR4JPImPzXobOxxBZsd/Rup
        uoVPrUQ9M4HId0fA6B8PrwP7ljDm3tCg+LZucJSavE0crc05wpe7mYT6yLv0gLpRBXSFBzIs1Mu6i
        N4GxNEmjxvNkfeLI0U7nbus0rZudT+ShhqrlKnuZkrx7D3v2KODNlYaKYFjZeZejbjc/67P6vEYqp
        /aMq7sfBA+CFFR2WItLpK7ci5WI21oNMZCqgkDJOrvp/wEeAUOnZ9F+hZBMZ571GNU87SlCFiTHoB
        G4btDG2Q==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjUq-006C0F-1x; Thu, 03 Mar 2022 11:19:48 +0000
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
Subject: [PATCH 04/10] zram: use memcpy_from_bvec in zram_bvec_write
Date:   Thu,  3 Mar 2022 14:18:59 +0300
Message-Id: <20220303111905.321089-5-hch@lst.de>
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

Use memcpy_from_bvec instead of open coding the logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/block/zram/zram_drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 14becdf2815df..e9474b02012de 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1465,7 +1465,6 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 {
 	int ret;
 	struct page *page = NULL;
-	void *src;
 	struct bio_vec vec;
 
 	vec = *bvec;
@@ -1483,11 +1482,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
 		if (ret)
 			goto out;
 
-		src = kmap_atomic(bvec->bv_page);
 		dst = kmap_atomic(page);
-		memcpy(dst + offset, src + bvec->bv_offset, bvec->bv_len);
+		memcpy_from_bvec(dst + offset, bvec);
 		kunmap_atomic(dst);
-		kunmap_atomic(src);
 
 		vec.bv_page = page;
 		vec.bv_len = PAGE_SIZE;
-- 
2.30.2


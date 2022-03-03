Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A032A4CBC69
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 12:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiCCLVL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Mar 2022 06:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiCCLVK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 06:21:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD39D1795D1;
        Thu,  3 Mar 2022 03:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Ss0aqO+LCHTJbh8lRYeCKR0T6gWpPWKe33M5LaRso80=; b=KQp48Ew8u2NsZnCrLX/iHBqpFy
        daDEOxZ2iyqjxtxGT8ctF47MZV9nd6quauQG6A+2v9x0jXgo7/z57eE/IoeiksJ8EevmXLprAFdM+
        PiKIz/F0GQEMdQ6PKkBgE2BeIMrMNcXga9eaCw5NaiCus3OWsiM+na4feR9uVAYde0NmabEM5gfTN
        P7o2VkzNfn1IaNdKRFfxbESxWSW+H436TUOFTrWNVh77C7yW8p8iYV0poutCkdV1fsc9lIes31JHt
        kShVvs81GfeVlLvagBtC01Zkua8ly2L04xIVI/gZyJ5WgSFa8gYoaDcrv/zovlbC8L0AUGUmiDPTb
        82BCAUYA==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjVK-006CBG-P1; Thu, 03 Mar 2022 11:20:20 +0000
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
Subject: [PATCH 10/10] floppy: use memcpy_{to,from}_bvec
Date:   Thu,  3 Mar 2022 14:19:05 +0300
Message-Id: <20220303111905.321089-11-hch@lst.de>
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

Use the helpers instead of open coding them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/block/floppy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 19c2d0327e157..8c647532e3ce9 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2485,11 +2485,9 @@ static void copy_buffer(int ssize, int max_sector, int max_sector_2)
 		}
 
 		if (CT(raw_cmd->cmd[COMMAND]) == FD_READ)
-			memcpy_to_page(bv.bv_page, bv.bv_offset, dma_buffer,
-				       size);
+			memcpy_to_bvec(&bv, dma_buffer);
 		else
-			memcpy_from_page(dma_buffer, bv.bv_page, bv.bv_offset,
-					 size);
+			memcpy_from_bvec(dma_buffer, &bv);
 
 		remaining -= size;
 		dma_buffer += size;
-- 
2.30.2


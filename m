Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6B44CBC4B
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 12:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiCCLUS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Mar 2022 06:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiCCLUR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 06:20:17 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765DB171EFA;
        Thu,  3 Mar 2022 03:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=QVVaIqgGyDnx9ueY7z/hzj3O9uq8fALFMD1DXm83SrU=; b=OOGFiYRrrPZgXxgrDmd0Ot5+++
        J2ACUC7ZfBTAnB/yKwzsccoWtvqn3jk9jM8Kxj+XQ7PpfC7zK79z8grscIPB9Q5JO2ik15NUcjXg+
        koSBXepexshcqqANRhAoZNg/u8pu9oN6bTTVoEa/V7QCZBlUOSthPFdVPX8r6KsrPN+9nycK9X3NL
        ucbuggOoCDs+VbIj1t5Zq6H1tHDnNC+KXv/DqZQhNi7iMDGfBgh0+7ytTharPyxZj5+2SRjOBEdkh
        xgI0DBTGQMtLVqu2G8rNjnMPAZkZhZcP1l6n8gtl2M01qs78nSKfQYzl4difO/6jtf+vCzKM2xQcG
        2IJ34mXg==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjUS-006Bum-TO; Thu, 03 Mar 2022 11:19:25 +0000
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
Subject: [PATCH 01/10] iss-simdisk: use bvec_kmap_local in simdisk_submit_bio
Date:   Thu,  3 Mar 2022 14:18:56 +0300
Message-Id: <20220303111905.321089-2-hch@lst.de>
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

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/xtensa/platforms/iss/simdisk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 8eb6ad1a3a1de..0f0e0724397f4 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -108,13 +108,13 @@ static void simdisk_submit_bio(struct bio *bio)
 	sector_t sector = bio->bi_iter.bi_sector;
 
 	bio_for_each_segment(bvec, bio, iter) {
-		char *buffer = kmap_atomic(bvec.bv_page) + bvec.bv_offset;
+		char *buffer = bvec_kmap_local(&bvec);
 		unsigned len = bvec.bv_len >> SECTOR_SHIFT;
 
 		simdisk_transfer(dev, sector, len, buffer,
 				bio_data_dir(bio) == WRITE);
 		sector += len;
-		kunmap_atomic(buffer);
+		kunmap_local(buffer);
 	}
 
 	bio_endio(bio);
-- 
2.30.2


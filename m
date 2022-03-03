Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEEE4CBC5C
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 12:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiCCLUx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Mar 2022 06:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiCCLUt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Mar 2022 06:20:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D58A1795D2;
        Thu,  3 Mar 2022 03:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=f0NF498hDCrz75r99TeO+EjHW8Kl3t4Al355uemFwlc=; b=RVOdlleVMmPeGVGcENHOikaH2i
        7Mg7a3r5ZsNimKQNjNjUdz+dBEvY74g/2YuUfrhXXeY82u0nOJh5dqnSvZ7MjAkpeuzfafD4K8nrH
        nUhYYmYoW8+owYQfnl2namiS43Flj/gA7fD1HW2ssydHjwNvxfgQYFE9oh7yZzgr1yqUxVbFO1Qa4
        QG4EdejeAkiXorKBxaeO0u0z7IesuDHtskS2ha5fI6q/sdOuUZ3H+A9Ag3/1UiGxFCz9KduewFgBz
        H5faGUBrRUw8xfeUWUdQlveadnRzGWgx688uz514t7O7ywyCkE44R+rL3Iq4E6fy3KjUbvP932vA7
        vQ+9OTiw==;
Received: from [91.93.38.115] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPjV0-006C3h-15; Thu, 03 Mar 2022 11:19:58 +0000
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
Subject: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
Date:   Thu,  3 Mar 2022 14:19:01 +0300
Message-Id: <20220303111905.321089-7-hch@lst.de>
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
---
 drivers/nvdimm/btt.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index cbd994f7f1fe6..9613e54c7a675 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
 		 */
 
 		cur_len = min(len, bv.bv_len);
-		mem = kmap_atomic(bv.bv_page);
+		mem = bvec_kmap_local(&bv);
 		if (rw)
-			ret = arena_write_bytes(arena, meta_nsoff,
-					mem + bv.bv_offset, cur_len,
+			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,
 					NVDIMM_IO_ATOMIC);
 		else
-			ret = arena_read_bytes(arena, meta_nsoff,
-					mem + bv.bv_offset, cur_len,
+			ret = arena_read_bytes(arena, meta_nsoff, mem, cur_len,
 					NVDIMM_IO_ATOMIC);
 
-		kunmap_atomic(mem);
+		kunmap_local(mem);
 		if (ret)
 			return ret;
 
-- 
2.30.2


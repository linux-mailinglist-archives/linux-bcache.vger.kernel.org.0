Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C41E633B1
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Jul 2019 11:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfGIJxf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 9 Jul 2019 05:53:35 -0400
Received: from smtpbg519.qq.com ([203.205.250.45]:37897 "EHLO smtpbg.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfGIJxf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 9 Jul 2019 05:53:35 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jul 2019 05:53:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1562666012;
        bh=Ew09uSeb8Wzxbyc9W5ePSS9h+l31zYWLIT/U1JxhO/w=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=Q7JN8n4CEsu27vJOswt243k0zb2JAaLPRxjY5fTHSGf0CgkqwiU55AVgKuwCXTy3a
         mPc8vf8XLNBe2cjV2fRStxoTv4PhTzZGJdUHGLEz9aQg0Mw16/dQKjaaxKAZzmZl++
         ILSZxKWvg9PgHPg+Dw+f9KAf3KT9OUv3E0YTACZE=
X-QQ-mid: esmtp5t1562665582t80vrv5fj
Received: from localhost.localdomain (unknown [221.220.250.51])
        by esmtp4.qq.com (ESMTP) with 
        id ; Tue, 09 Jul 2019 17:46:22 +0800 (CST)
X-QQ-SSF: 01010000000000F0FH4000000000000
X-QQ-FEAT: wZSaiLuHvTGkoXNJzx7IUbdOyyv4wE+lCyO00KcsS2KTJc6ybBWVzBPxTcm4Y
        NbOQmSfadwK9w3t//OkP/v/1A1ZEcFrdM8O8knCVOI1e59ISwgjf7vLHFUeO1qHrBOUyAOm
        gTla87CALaJMgb8G/JrKa18KRyiftHRni2TCf/qIixExStsaM9fZc5d16qwc+YTFmm+Ka1R
        yuxEBTpS4tQlzyS3OMWz6Y8kC7Zrlq32h7BBaS0ba6mcNPPc3qNk2G9GeNKKjVt7uRLTFj/
        QdV1JR6JBfwQ+Rrdml8cfVL3I=
X-QQ-GoodBg: 0
From:   Shenghui Wang <shhuiw@foxmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Subject: [PATCH 1/2] bcache: remove redundant KEY_PTRS(k) check in bch_btree_ptr_bad
Date:   Tue,  9 Jul 2019 17:46:05 +0800
Message-Id: <20190709094606.15746-2-shhuiw@foxmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709094606.15746-1-shhuiw@foxmail.com>
References: <20190709094606.15746-1-shhuiw@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtp:foxmail.com:bgweb:bgweb5
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bch_btree_ptr_bad() -> bch_ptr_invalid() -> bch_btree_ptr_invalid()
-> __bch_btree_ptr_invalid() will check !KEY_PTRS(k).
No need check !KEY_PTRS(k) explicitly in bch_btree_ptr_bad().

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/bcache/extents.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 886710043025..5a05407a8126 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -208,7 +208,6 @@ static bool bch_btree_ptr_bad(struct btree_keys *bk, const struct bkey *k)
 	unsigned int i;
 
 	if (!bkey_cmp(k, &ZERO_KEY) ||
-	    !KEY_PTRS(k) ||
 	    bch_ptr_invalid(bk, k))
 		return true;
 
-- 
2.20.1


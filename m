Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 492895A6770
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Aug 2022 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiH3Pat (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Aug 2022 11:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiH3Pas (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Aug 2022 11:30:48 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532C263F1B;
        Tue, 30 Aug 2022 08:30:47 -0700 (PDT)
X-QQ-mid: bizesmtp75t1661873433tnbi9xe6
Received: from localhost.localdomain ( [182.148.13.26])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 23:30:32 +0800 (CST)
X-QQ-SSF: 01000000002000D0E000B00A0000000
X-QQ-FEAT: mhDoKBI5A3Br7zCoWRcaEUCjM/ldsiKNhPKawKofSTMxtH0iYZxkCWw2ZWO3G
        aE0kjZa3ZJeepyD+tGykdmrQ3f2sU8M2rMRKTY1F3tuOT6UhmH+ica5jWDguw5xQXgv+7ET
        5uUoVHWhEFnNyffwgSWHJEmJFrTX/Mm2sfTLRrNGYu3mzJa4hFxoi7Rmpr/Gbtpd4fxOio5
        //Cz+VLCdKbAuhRH+fRSFz21xIT5oNZb7DRJEx9n8uy717NioNHKJUFsDfVtCyyN21iMKP6
        2YrKQ7GW+xPZ7FvH/Q35HonaIfygfaEy9yd6YKn91fmm+jqGz4V4VnpMUpnKPRYAKpXebtQ
        YbgVv0YFOwZjGtGmz+DGZb2P6mHC2QDWbnouXeW5Uo3zKaH4yN7iU8lG9w/dg==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] bcache:: fix repeated words in comments
Date:   Tue, 30 Aug 2022 23:30:26 +0800
Message-Id: <20220830153026.16948-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Delete the redundant word 'we'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/md/bcache/bcache.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 2acda9cea0f9..aebb7ef10e63 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -107,7 +107,7 @@
  *
  * BTREE NODES:
  *
- * Our unit of allocation is a bucket, and we we can't arbitrarily allocate and
+ * Our unit of allocation is a bucket, and we can't arbitrarily allocate and
  * free smaller than a bucket - so, that's how big our btree nodes are.
  *
  * (If buckets are really big we'll only use part of the bucket for a btree node
-- 
2.36.1


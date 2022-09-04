Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEC95AC545
	for <lists+linux-bcache@lfdr.de>; Sun,  4 Sep 2022 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiIDQG4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 4 Sep 2022 12:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbiIDQGz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 4 Sep 2022 12:06:55 -0400
Received: from smtpbg.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F1C37F9D
        for <linux-bcache@vger.kernel.org>; Sun,  4 Sep 2022 09:06:50 -0700 (PDT)
X-QQ-mid: bizesmtp91t1662307599tqak1nhs
Received: from localhost.localdomain ( [182.148.14.80])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 05 Sep 2022 00:06:34 +0800 (CST)
X-QQ-SSF: 01000000000000C0C000000A0000000
X-QQ-FEAT: C4CAQ8sL+YCZ7AXRU04HHIzxOjEh2q1bYKiPGrgtXfvZ7JrBDKaRKWmbZdSFg
        VKG5nbH0FAhWumqdEzEXr9h/iAvnJPNHRs6kOW4WDS5iX02bVNr9wFJIQ+qSiUKyTTnXair
        scQJdR3E1/GBE34oNN31j6IPEpwJpYUSNAemWZOvWieYqSa7gaCA789ogK08+JuigBfFcg8
        uyAs3+96Ih1uhz8mL+TZfOOio5rgJ0qgVt623wCXwbfuQQLGSmqll0cNotAhG9kX5MMOB24
        apj7M5j7MAxGm9RnqIedXQxKVDUntR+ozg9s6dd1L4T7gkl1up6G3AGoDmMh4eS2tdBSwA0
        KgJpIpoPaHPQ2jBG/9ixl36d5bHOM+OYkv/TMEb
X-QQ-GoodBg: 0
From:   Shaomin Deng <dengshaomin@cdjrlc.com>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Cc:     Shaomin Deng <dengshaomin@cdjrlc.com>
Subject: [PATCH] bcache: Fix typo in comments
Date:   Sun,  4 Sep 2022 12:06:33 -0400
Message-Id: <20220904160633.31986-1-dengshaomin@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,RCVD_IN_PBL,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Delete the repeated word "we" in comments.

Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>
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
2.35.1


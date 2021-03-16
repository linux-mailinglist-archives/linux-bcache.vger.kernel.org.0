Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A425C33CF60
	for <lists+linux-bcache@lfdr.de>; Tue, 16 Mar 2021 09:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhCPIL0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 16 Mar 2021 04:11:26 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:51984 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234196AbhCPIKz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Mar 2021 04:10:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0US7EAO1_1615882251;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0US7EAO1_1615882251)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 16 Mar 2021 16:10:52 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] bcache: use NULL instead of using plain integer as pointer
Date:   Tue, 16 Mar 2021 16:10:50 +0800
Message-Id: <1615882250-17846-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This fixes the following sparse warnings:
drivers/md/bcache/features.c:22:16: warning: Using plain integer as NULL
pointer

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/md/bcache/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/features.c b/drivers/md/bcache/features.c
index d636b7b..6d2b7b8 100644
--- a/drivers/md/bcache/features.c
+++ b/drivers/md/bcache/features.c
@@ -19,7 +19,7 @@ struct feature {
 static struct feature feature_list[] = {
 	{BCH_FEATURE_INCOMPAT, BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE,
 		"large_bucket"},
-	{0, 0, 0 },
+	{0, 0, NULL },
 };
 
 #define compose_feature_string(type)				\
-- 
1.8.3.1


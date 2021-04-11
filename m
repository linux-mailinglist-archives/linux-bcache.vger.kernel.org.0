Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8014035B4CF
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Apr 2021 15:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhDKNoL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 11 Apr 2021 09:44:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:47408 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235627AbhDKNoA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 11 Apr 2021 09:44:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 972A7AD2D;
        Sun, 11 Apr 2021 13:43:43 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 3/7] bcache: use NULL instead of using plain integer as pointer
Date:   Sun, 11 Apr 2021 21:43:12 +0800
Message-Id: <20210411134316.80274-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210411134316.80274-1-colyli@suse.de>
References: <20210411134316.80274-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

This fixes the following sparse warnings:
drivers/md/bcache/features.c:22:16: warning: Using plain integer as NULL
pointer

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/features.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/features.c b/drivers/md/bcache/features.c
index d636b7b2d070..6d2b7b84a7b7 100644
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
2.26.2


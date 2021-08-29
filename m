Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381853FA965
	for <lists+linux-bcache@lfdr.de>; Sun, 29 Aug 2021 08:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbhH2GB0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 29 Aug 2021 02:01:26 -0400
Received: from smtp.h3c.com ([221.12.31.13]:42381 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhH2GBZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 29 Aug 2021 02:01:25 -0400
X-Greylist: delayed 3235 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Aug 2021 02:01:22 EDT
Received: from h3cspam01-ex.h3c.com (localhost [127.0.0.2] (may be forged))
        by h3cspam01-ex.h3c.com with ESMTP id 17T56YNQ057804;
        Sun, 29 Aug 2021 13:06:34 +0800 (GMT-8)
        (envelope-from xi.fengfei@h3c.com)
Received: from DAG2EX05-BASE.srv.huawei-3com.com ([10.8.0.68])
        by h3cspam01-ex.h3c.com with ESMTP id 17T56FRB057403;
        Sun, 29 Aug 2021 13:06:15 +0800 (GMT-8)
        (envelope-from xi.fengfei@h3c.com)
Received: from localhost.localdomain (10.99.222.162) by
 DAG2EX05-BASE.srv.huawei-3com.com (10.8.0.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 29 Aug 2021 13:06:17 +0800
From:   Fengfei Xi <xi.fengfei@h3c.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Fengfei Xi <xi.fengfei@h3c.com>
Subject: [PATCH] bcache: remove the redundant judgment on bi_size
Date:   Sun, 29 Aug 2021 12:49:47 +0800
Message-ID: <20210829044947.14703-1-xi.fengfei@h3c.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.99.222.162]
X-ClientProxiedBy: BJSMTP01-EX.srv.huawei-3com.com (10.63.20.132) To
 DAG2EX05-BASE.srv.huawei-3com.com (10.8.0.68)
X-DNSRBL: 
X-MAIL: h3cspam01-ex.h3c.com 17T56YNQ057804
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The bi_size is unsigned int type data not less than 0,
so we can directly add bi_size without extra judgment

Signed-off-by: Fengfei Xi <xi.fengfei@h3c.com>
---
 drivers/md/bcache/request.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6d1de889b..2788eec3a 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -423,9 +423,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	add_sequential(task);
 	i->sequential = 0;
 found:
-	if (i->sequential + bio->bi_iter.bi_size > i->sequential)
-		i->sequential	+= bio->bi_iter.bi_size;
-
+	i->sequential		+= bio->bi_iter.bi_size;
 	i->last			 = bio_end_sector(bio);
 	i->jiffies		 = jiffies + msecs_to_jiffies(5000);
 	task->sequential_io	 = i->sequential;
-- 
2.17.1


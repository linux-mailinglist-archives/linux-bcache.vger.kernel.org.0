Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0F77781E
	for <lists+linux-bcache@lfdr.de>; Sat, 27 Jul 2019 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfG0KUe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 27 Jul 2019 06:20:34 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:2517 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfG0KUe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 27 Jul 2019 06:20:34 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7]) by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee55d3c255ec50-4f39a; Sat, 27 Jul 2019 18:20:15 +0800 (CST)
X-RM-TRANSID: 2ee55d3c255ec50-4f39a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.novalocal (unknown[112.25.65.41])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee45d3c255db6c-ef1e6;
        Sat, 27 Jul 2019 18:20:15 +0800 (CST)
X-RM-TRANSID: 2ee45d3c255db6c-ef1e6
From:   Yaowei Bai <baiyaowei@cmss.chinamobile.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        baiyaowei@cmss.chinamobile.com
Subject: [PATCH 2/3] bcache: use allocator reserves instead of watermarks
Date:   Sat, 27 Jul 2019 18:19:58 +0800
Message-Id: <1564222799-10603-2-git-send-email-baiyaowei@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
References: <1564222799-10603-1-git-send-email-baiyaowei@cmss.chinamobile.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 78365411b344 ("bcache: Rework allocator reserves") introduced
allocator reserves and dropped watermarks, let's keep this consistent
to avoid confusing.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
---
 drivers/md/bcache/alloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index c22c260..609df38 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -622,13 +622,13 @@ bool bch_alloc_sectors(struct cache_set *c,
 	spin_lock(&c->data_bucket_lock);
 
 	while (!(b = pick_data_bucket(c, k, write_point, &alloc.key))) {
-		unsigned int watermark = write_prio
+		unsigned int reserve = write_prio
 			? RESERVE_MOVINGGC
 			: RESERVE_NONE;
 
 		spin_unlock(&c->data_bucket_lock);
 
-		if (bch_bucket_alloc_set(c, watermark, &alloc.key, 1, wait))
+		if (bch_bucket_alloc_set(c, reserve, &alloc.key, 1, wait))
 			return false;
 
 		spin_lock(&c->data_bucket_lock);
-- 
1.8.3.1




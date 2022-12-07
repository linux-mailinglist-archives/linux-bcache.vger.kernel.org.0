Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27516455FD
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Dec 2022 10:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiLGJDn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Dec 2022 04:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiLGJDl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Dec 2022 04:03:41 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41B325EB4;
        Wed,  7 Dec 2022 01:03:39 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NRrtL1hBVz4y0ty;
        Wed,  7 Dec 2022 17:03:38 +0800 (CST)
Received: from xaxapp03.zte.com.cn ([10.88.40.52])
        by mse-fl2.zte.com.cn with SMTP id 2B792X5n085726;
        Wed, 7 Dec 2022 17:02:33 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Wed, 7 Dec 2022 17:02:35 +0800 (CST)
Date:   Wed, 7 Dec 2022 17:02:35 +0800 (CST)
X-Zmail-TransId: 2af9639056abffffffffe1c2ea5b
X-Mailer: Zmail v1.0
Message-ID: <202212071702359325169@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <colyli@suse.de>
Cc:     <kent.overstreet@gmail.com>, <linux-bcache@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBiY2FjaGU6IENvbnZlcnQgdG8gdXNlIHN5c2ZzX2VtaXQoKS9zeXNmc19lbWl0X2F0KCkgQVBJcw==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B792X5n085726
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 639056EA.000 by FangMail milter!
X-FangMail-Envelope: 1670403818/4NRrtL1hBVz4y0ty/639056EA.000/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 639056EA.000/4NRrtL1hBVz4y0ty
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/md/bcache/sysfs.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index c6f677059214..0e2c1880f60b 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1111,26 +1111,25 @@ SHOW(__bch_cache)

 		vfree(p);

-		ret = scnprintf(buf, PAGE_SIZE,
-				"Unused:		%zu%%\n"
-				"Clean:		%zu%%\n"
-				"Dirty:		%zu%%\n"
-				"Metadata:	%zu%%\n"
-				"Average:	%llu\n"
-				"Sectors per Q:	%zu\n"
-				"Quantiles:	[",
-				unused * 100 / (size_t) ca->sb.nbuckets,
-				available * 100 / (size_t) ca->sb.nbuckets,
-				dirty * 100 / (size_t) ca->sb.nbuckets,
-				meta * 100 / (size_t) ca->sb.nbuckets, sum,
-				n * ca->sb.bucket_size / (ARRAY_SIZE(q) + 1));
+		ret = sysfs_emit(buf,
+				 "Unused:		%zu%%\n"
+				 "Clean:		%zu%%\n"
+				 "Dirty:		%zu%%\n"
+				 "Metadata:	%zu%%\n"
+				 "Average:	%llu\n"
+				 "Sectors per Q:	%zu\n"
+				 "Quantiles:	[",
+				 unused * 100 / (size_t) ca->sb.nbuckets,
+				 available * 100 / (size_t) ca->sb.nbuckets,
+				 dirty * 100 / (size_t) ca->sb.nbuckets,
+				 meta * 100 / (size_t) ca->sb.nbuckets, sum,
+				 n * ca->sb.bucket_size / (ARRAY_SIZE(q) + 1));

 		for (i = 0; i < ARRAY_SIZE(q); i++)
-			ret += scnprintf(buf + ret, PAGE_SIZE - ret,
-					 "%u ", q[i]);
+			ret += sysfs_emit_at(buf, ret, "%u ", q[i]);
 		ret--;

-		ret += scnprintf(buf + ret, PAGE_SIZE - ret, "]\n");
+		ret += sysfs_emit_at(buf, ret, "]\n");

 		return ret;
 	}
-- 
2.25.1

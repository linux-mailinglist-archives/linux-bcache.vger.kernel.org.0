Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8649373183E
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jun 2023 14:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239947AbjFOMNk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Jun 2023 08:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbjFOMNi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2023 08:13:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6E419B5;
        Thu, 15 Jun 2023 05:13:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5DE041FE0C;
        Thu, 15 Jun 2023 12:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686831216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6OhOKVIls+DBg+3o9Bkfk3gFzwQc1CUgCUTslWVdBww=;
        b=QiAiTR8f+eoQhmXO0E1mmvNO7x0Cd65HtXDMcvpbyRnmECHYNc/bhosoEKmszFsDgZKMTS
        IGvRJ0tRJXn1BH34UVp/QcQI1bPhTPuVfk8ZCTDspbJit83tqnw5rfhsxO8tVZsosCdUay
        f2UlvKFFRa4YYByEQn2OAUwTSYioRGs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686831216;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6OhOKVIls+DBg+3o9Bkfk3gFzwQc1CUgCUTslWVdBww=;
        b=s8PuNMlLZKe9YCKHFmSuJ+ZE6w2Oy4rfH1XEqJHVyqLdWQDVDifYW59qFrLzYOzg7ThEsi
        anNg0r1SCeUuSsCQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 1C8E82C141;
        Thu, 15 Jun 2023 12:13:33 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>, Coly Li <colyli@suse.de>
Subject: [PATCH 1/6] bcache: Convert to use sysfs_emit()/sysfs_emit_at() APIs
Date:   Thu, 15 Jun 2023 20:12:18 +0800
Message-Id: <20230615121223.22502-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615121223.22502-1-colyli@suse.de>
References: <20230615121223.22502-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
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
Signed-off-by: Coly Li <colyli@suse.de>
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
2.35.3


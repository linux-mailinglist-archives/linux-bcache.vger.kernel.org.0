Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414CF5BD209
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 18:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiISQRo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 12:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiISQRm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 12:17:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D9239BA2;
        Mon, 19 Sep 2022 09:17:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C49F721F41;
        Mon, 19 Sep 2022 16:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663604255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpOfGkXJ0KMqdbtRY5ERKrzxiTg8bYQXFUwSQ1PnUus=;
        b=NlmhLpWAOAWD6fQeZSU0SA1w5GU5FWgK8E4iIItMZmM9phlEjslkqsDIFvrYr5/sXxM9n5
        UZ81YlC5nvsp5cvgT0wdYAqdjT7gMabsL/iJmjC8VfGyVB2D76I01VedVrhHb8v5/HW6yt
        8UeDWdmYC8IXIlFzVcte/2lHnU1XA3E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663604255;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpOfGkXJ0KMqdbtRY5ERKrzxiTg8bYQXFUwSQ1PnUus=;
        b=qq84YO/UN9M7syK+NX/MUXrTHgaha+wQP2anzfyV2U9KhNDKX6SzoRpAnG/F34WhQoC2mQ
        +ZRxOXZnUDJ9xiDA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id CD2BD2C141;
        Mon, 19 Sep 2022 16:17:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 4/5] bcache:: fix repeated words in comments
Date:   Tue, 20 Sep 2022 00:16:46 +0800
Message-Id: <20220919161647.81238-5-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220919161647.81238-1-colyli@suse.de>
References: <20220919161647.81238-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jilin Yuan <yuanjilin@cdjrlc.com>

Delete the redundant word 'we'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
Signed-off-by: Coly Li <colyli@suse.de>
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
2.35.3


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5EC731842
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jun 2023 14:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbjFOMNo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 15 Jun 2023 08:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbjFOMNn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 15 Jun 2023 08:13:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E1F193;
        Thu, 15 Jun 2023 05:13:42 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 52395223D6;
        Thu, 15 Jun 2023 12:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686831221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=845bN8sPk1hk+WbdnrEFvb/J9PndIAjmFQ2BAdC7Lkk=;
        b=nuZZ6hzeK8QimMk/Fd5+tqHYD8lN7rddz83g63++8UElBRitrVIOPeD8GCM3y8c8CeswjT
        A3Ykf3d4IHWuYaCeroabwFBMfKqDLB1ml29pepkaLJ9EkKbJTdYIftO0GccjlFVYW3jOdN
        8thy65zytXQJne2UX/z/+lb48FGV8KU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686831221;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=845bN8sPk1hk+WbdnrEFvb/J9PndIAjmFQ2BAdC7Lkk=;
        b=SWObvp0/4Rg+q4xTTcOk/m4xvS3IgLv3/wGmFiAkjk2ciFYsWuaAxfZGrnU89Wr/FpJxbe
        5WyNOwVvLMHPUMCA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 78F6A2C141;
        Thu, 15 Jun 2023 12:13:39 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 3/6] bcache: Remove dead references to cache_readaheads
Date:   Thu, 15 Jun 2023 20:12:20 +0800
Message-Id: <20230615121223.22502-4-colyli@suse.de>
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

From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>

The cache_readaheads stat counter is not used anymore and should be
removed.

Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 Documentation/admin-guide/bcache.rst | 3 ---
 drivers/md/bcache/stats.h            | 1 -
 2 files changed, 4 deletions(-)

diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
index bb5032a99234..6fdb495ac466 100644
--- a/Documentation/admin-guide/bcache.rst
+++ b/Documentation/admin-guide/bcache.rst
@@ -508,9 +508,6 @@ cache_miss_collisions
   cache miss, but raced with a write and data was already present (usually 0
   since the synchronization for cache misses was rewritten)
 
-cache_readaheads
-  Count of times readahead occurred.
-
 Sysfs - cache set
 ~~~~~~~~~~~~~~~~~
 
diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
index bd3afc856d53..21b445f8af15 100644
--- a/drivers/md/bcache/stats.h
+++ b/drivers/md/bcache/stats.h
@@ -18,7 +18,6 @@ struct cache_stats {
 	unsigned long cache_misses;
 	unsigned long cache_bypass_hits;
 	unsigned long cache_bypass_misses;
-	unsigned long cache_readaheads;
 	unsigned long cache_miss_collisions;
 	unsigned long sectors_bypassed;
 
-- 
2.35.3


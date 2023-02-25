Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393816A2A84
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Feb 2023 16:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjBYPip (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Feb 2023 10:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBYPio (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Feb 2023 10:38:44 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972D212F2A
        for <linux-bcache@vger.kernel.org>; Sat, 25 Feb 2023 07:38:42 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t15so2068011wrz.7
        for <linux-bcache@vger.kernel.org>; Sat, 25 Feb 2023 07:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H4RKgcXYCtPtBdTYN62fBVbhyXiXEr5qMlywr2J57Ps=;
        b=QZpJdc7DmuQrBjPoFzR+Zbw1Be4TbPjs9+S/GQ98o/H9BG2HAirqJe7epHPguMKU/X
         vEM2reMAiCTJuVON1im/YSvE6vruUJxYTmTfRp+ayONmaVrzA/P/gzH5LaeykxnyJjB9
         HeIN0aFP4K5nezuIh7JvaFFvTTtlpPgtT5C/Jver7iYiJyQtrMXlBEE/p0W1VhuoyjoM
         hWrCd9wFKhYECCZn5BibbqfAVYxt8oHxk25B0h0VnMSY0eO24tnWF8tRlWPYjoJC9PHI
         wdUKpJo8V2o/tdza1gLSQLIfT4Yvrg9rFOfwKqZjS6OIU8tUbRbgVD6nQw8m02VHG3PZ
         /CYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4RKgcXYCtPtBdTYN62fBVbhyXiXEr5qMlywr2J57Ps=;
        b=wYYnDVBtxPynSvGb9N+lbLFqtTf6s6avtxLmnzfnqFOuD7STq/JVhVHxBKzOuId9Fa
         1rX3eqVrrYZhQ4WIJ1b75Ijr4MdJ1BRwH15sWacQRjnVG9JsX/c2kQf+X+w1Ma6Evta/
         I8Bs28wzFDmvw/KAirX6QcOVu7cxyrTJ5YphNb3RQDUx+0fhVpHJWRN6bCMtL07/oWFn
         x7RXL5LtIubjpRNBfVWoFEKnNVJWyvWS2V+7y4nj5aZ4Nue2ED+ODq3u3yl6u6NeIPwG
         aW7HYJobEc/ssPC5Rq0PBzlAmvHx/5axOcEW7WDaTdLk+fFI8EgpZcl1JDaDoEVs4PB8
         mDew==
X-Gm-Message-State: AO0yUKVugD+JJ63UpXn0tr1K9qpjd+A+/1aV/ZskW4oqZUhCvj7NByHO
        9qziaOgylude9P1ispjlVEAUtA==
X-Google-Smtp-Source: AK7set/ciPQ+sTZvoTr6owa+ACtfwWI5q/cLiN3vbrHAO4/sFXibnfoegBZTa62nk27JisU7cQujUQ==
X-Received: by 2002:adf:e7c9:0:b0:2c7:1dc4:5c4e with SMTP id e9-20020adfe7c9000000b002c71dc45c4emr4890591wrn.32.1677339521051;
        Sat, 25 Feb 2023 07:38:41 -0800 (PST)
Received: from 2021-EMEA-0269.devotools.com (dynamic-adsl-62-10-37-140.clienti.tiscali.it. [62.10.37.140])
        by smtp.googlemail.com with ESMTPSA id m15-20020a5d6a0f000000b002c707785da4sm2021884wru.107.2023.02.25.07.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 07:38:40 -0800 (PST)
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org,
        Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Subject: [PATCH] bcache: Remove dead references to cache_readaheads
Date:   Sat, 25 Feb 2023 16:33:55 +0100
Message-Id: <20230225153355.2779474-1-andrea.tomassetti-opensource@devo.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The cache_readaheads stat counter is not used anymore and should be
removed.

Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
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
2.39.2


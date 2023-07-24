Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B175F011
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jul 2023 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjGXJt0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jul 2023 05:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjGXJso (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jul 2023 05:48:44 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0063610F8
        for <linux-bcache@vger.kernel.org>; Mon, 24 Jul 2023 02:47:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bb91c20602so2227395ad.0
        for <linux-bcache@vger.kernel.org>; Mon, 24 Jul 2023 02:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192027; x=1690796827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cYIc2pFR4p2fEyppjqJhI12Ags43zx4+1Vguh7yPn/A=;
        b=Mkbkj7G5CQEOG8iOHz5MrSjilpa0Roglbh/CftNIU9Jg3xNX1k/Xj43vnR/S/54ttk
         C3FfMc3SnotTmowd/+id3GM38yUMYBJBhTZIBUulrrZgzYrxT+SQHGW3axYXz1Mzi2fV
         AsX/jIuEEGTsEz+JOjVZRdbKq3nZcbngqtBBtuQhz8//b37rxmcNc4kjft3yYQbvP1Zj
         84eZDPKog/+vrWIKUYa0yatWxoPJwzUv5rccQj+Dyx2lWBxO8FM5qLWfEajMcNN5ZG2/
         nBaypiLs1PufNQuHjnIpPNYd5QiB7rev3NHLgSVLNHqyhO1fbeGyfmflk+kru7Y0DPcw
         GDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192027; x=1690796827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cYIc2pFR4p2fEyppjqJhI12Ags43zx4+1Vguh7yPn/A=;
        b=YOQRIz7d9A6UaGwqveIinJyFtdlH5nqKGkgj49ZfynvxpJAzb2iyfWAc1U1pBio3dG
         x+JgS9pY53ezvc7d9E5Tat5eQWWgN1miXnCJktFz1XsSRUbyuIOS5u0Ka+uWMeFPHV+t
         p56x40ziMxbaQbGiE3edGRRGNz5uszzOYiEyLHioDW6WDVD6ZW3jaH6YRdfhYfuRicBz
         q5oB7HLxuNcQb4SQSLMdmlWssWwOCXVmmry3NIIWNHiGsNLGTeqZkkXbmCKVrcLCR4ov
         gVxI7CpW3TY1DmKd5Y5P4FAy1P+5mXhp94tZrxa4EvIsRUHMpMsMsr+k+m+VZX/JCKLn
         JWFw==
X-Gm-Message-State: ABy/qLaxp44YFRNX8zgV2si0GiaA/L9JzClFmxzqXrEyGowar/su2OU4
        h7lC2Oq3i8rXMS3OoZ92t0kLWg==
X-Google-Smtp-Source: APBJJlE71N8j7jMrL1FzeS7v4yJrry2TgN0JWUZm9wk55uK2Ve/eQ/bXmY0X5mXvJcfiEdGHzkgvbw==
X-Received: by 2002:a17:902:ec8b:b0:1b3:d8ac:8db3 with SMTP id x11-20020a170902ec8b00b001b3d8ac8db3mr12337602plg.6.1690192026938;
        Mon, 24 Jul 2023 02:47:06 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:47:06 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 10/47] gfs2: dynamically allocate the gfs2-glock shrinker
Date:   Mon, 24 Jul 2023 17:43:17 +0800
Message-Id: <20230724094354.90817-11-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use new APIs to dynamically allocate the gfs2-glock shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/gfs2/glock.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 1438e7465e30..77da354667d9 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -2046,11 +2046,7 @@ static unsigned long gfs2_glock_shrink_count(struct shrinker *shrink,
 	return vfs_pressure_ratio(atomic_read(&lru_count));
 }
 
-static struct shrinker glock_shrinker = {
-	.seeks = DEFAULT_SEEKS,
-	.count_objects = gfs2_glock_shrink_count,
-	.scan_objects = gfs2_glock_shrink_scan,
-};
+static struct shrinker *glock_shrinker;
 
 /**
  * glock_hash_walk - Call a function for glock in a hash bucket
@@ -2472,13 +2468,19 @@ int __init gfs2_glock_init(void)
 		return -ENOMEM;
 	}
 
-	ret = register_shrinker(&glock_shrinker, "gfs2-glock");
-	if (ret) {
+	glock_shrinker = shrinker_alloc(0, "gfs2-glock");
+	if (!glock_shrinker) {
 		destroy_workqueue(glock_workqueue);
 		rhashtable_destroy(&gl_hash_table);
-		return ret;
+		return -ENOMEM;
 	}
 
+	glock_shrinker->count_objects = gfs2_glock_shrink_count;
+	glock_shrinker->scan_objects = gfs2_glock_shrink_scan;
+	glock_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(glock_shrinker);
+
 	for (i = 0; i < GLOCK_WAIT_TABLE_SIZE; i++)
 		init_waitqueue_head(glock_wait_table + i);
 
@@ -2487,7 +2489,7 @@ int __init gfs2_glock_init(void)
 
 void gfs2_glock_exit(void)
 {
-	unregister_shrinker(&glock_shrinker);
+	shrinker_unregister(glock_shrinker);
 	rhashtable_destroy(&gl_hash_table);
 	destroy_workqueue(glock_workqueue);
 }
-- 
2.30.2


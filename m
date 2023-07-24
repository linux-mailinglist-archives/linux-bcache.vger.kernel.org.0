Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3565F75EFB7
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jul 2023 11:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbjGXJrP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jul 2023 05:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjGXJqn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jul 2023 05:46:43 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367A9E55
        for <linux-bcache@vger.kernel.org>; Mon, 24 Jul 2023 02:46:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1b8c364ad3bso8856125ad.1
        for <linux-bcache@vger.kernel.org>; Mon, 24 Jul 2023 02:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690191966; x=1690796766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vu9DfqGDIkVtY7CS+mn/8y6VlhAfp+/Q2ofuaCWar5Q=;
        b=At3xco+o52slbk+Wt2XjpJ6Cu9i6sYrBgnCMc/5CS86ucLHJsGEmN+KJGEE3nRi6sH
         tP3qBPXEcwpvnQz66wRWSap6a1c2U02VEHsWoEgBKOJ+J1jRKgicNVIHL7YJb/2E7nTO
         mH8QuWqeK2DOxQytNGG5waBMmbk4L4jbPvrdsdxuK9v3y/Gywd5CYYO64IbHl7UYCZKj
         8Q8aIDwesLUsAzLtg/KQ6AQafF3z6VJJ9ci5NRM3KksRfjknsFWZGEpbW519fA18aLaX
         x2A/u6CY/jHlR9bkZrq6ZtCOein2LXegx+J7Hclhb+m/DWqNAehg6T+OKXqpv2vIgzAt
         zKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690191966; x=1690796766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vu9DfqGDIkVtY7CS+mn/8y6VlhAfp+/Q2ofuaCWar5Q=;
        b=Lr2NIzYjqFAp3N+xNB8akOUMf7ggrdA0gcZa8pUuMgK/sEHo2kwSNJeSkbs3B7h79i
         ZcK0NCSS/5z8XDweE8u+TyrlL+u0TgU8nIvW6fePlZ0DAOoyw0r/tqjqvPLYaU0bvgqU
         ZhwqTQsn1YOY35PJKzkEjxlF6qNybWCVWR97mz7iagnyixKjoubNnM39SNvwL9ca4j86
         t0gyv64g2cvZt1ox9ek4JkZPUuzn+KY50uxc/zJ1jVfRONDjM7S//ex+hEPV7s/0H3Hj
         4lgb5JpEi+JSjC5Vi9oAWTyRmMqUXGyLbTudN+bpm2o19PWwNtjc031oH2QpNaQ/koPl
         jTgg==
X-Gm-Message-State: ABy/qLYKe0u2ZGm2M9cdONS2EFK6jtVXllwhxbwhTcgHQ4mXBpUwH7eB
        wynNm9rxLffaZ9GWnGgCWAtjpw==
X-Google-Smtp-Source: APBJJlGrsdFKJ71ukJT79kDa1W+M4ztJszdSUa3mf2ArYfnWEb5YwD/wtpSbLXe4wEi7ibAUftTBwg==
X-Received: by 2002:a17:902:ecd2:b0:1b8:b4f6:1327 with SMTP id a18-20020a170902ecd200b001b8b4f61327mr12288935plh.6.1690191966684;
        Mon, 24 Jul 2023 02:46:06 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:46:06 -0700 (PDT)
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
Subject: [PATCH v2 05/47] binder: dynamically allocate the android-binder shrinker
Date:   Mon, 24 Jul 2023 17:43:12 +0800
Message-Id: <20230724094354.90817-6-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use new APIs to dynamically allocate the android-binder shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/android/binder_alloc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index e3db8297095a..019981d65e1e 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1053,11 +1053,7 @@ binder_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			    NULL, sc->nr_to_scan);
 }
 
-static struct shrinker binder_shrinker = {
-	.count_objects = binder_shrink_count,
-	.scan_objects = binder_shrink_scan,
-	.seeks = DEFAULT_SEEKS,
-};
+static struct shrinker *binder_shrinker;
 
 /**
  * binder_alloc_init() - called by binder_open() for per-proc initialization
@@ -1077,19 +1073,30 @@ void binder_alloc_init(struct binder_alloc *alloc)
 
 int binder_alloc_shrinker_init(void)
 {
-	int ret = list_lru_init(&binder_alloc_lru);
+	int ret;
 
-	if (ret == 0) {
-		ret = register_shrinker(&binder_shrinker, "android-binder");
-		if (ret)
-			list_lru_destroy(&binder_alloc_lru);
+	ret = list_lru_init(&binder_alloc_lru);
+	if (ret)
+		return ret;
+
+	binder_shrinker = shrinker_alloc(0, "android-binder");
+	if (!binder_shrinker) {
+		list_lru_destroy(&binder_alloc_lru);
+		return -ENOMEM;
 	}
-	return ret;
+
+	binder_shrinker->count_objects = binder_shrink_count;
+	binder_shrinker->scan_objects = binder_shrink_scan;
+	binder_shrinker->seeks = DEFAULT_SEEKS;
+
+	shrinker_register(binder_shrinker);
+
+	return 0;
 }
 
 void binder_alloc_shrinker_exit(void)
 {
-	unregister_shrinker(&binder_shrinker);
+	shrinker_unregister(binder_shrinker);
 	list_lru_destroy(&binder_alloc_lru);
 }
 
-- 
2.30.2


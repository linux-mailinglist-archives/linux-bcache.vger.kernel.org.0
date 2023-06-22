Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD9739B21
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 10:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjFVIzo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 04:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjFVIzE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 04:55:04 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB561FED
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:54:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b5466bc5f8so9652735ad.1
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687424075; x=1690016075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ftOXXP2bfTIIt8St3T9822C8Mz+yI5OAEWwVCqdxqi8=;
        b=AF1n71Ibzw+/eJzW8ZfFCXm2Gb4L6rcgcO3MWUfrJXSOCg2q4/6sdbKki+cciYNMm8
         euETZJp/Yv9okGd+5XPvMxEgndnOAmqccUN3sNROxfnHbIeAfCrF3CESQGiUHVaKUyC0
         MpSE/83T59YTQuiU5NMvjWSDBOsWVTepqqBeQE1tIy9JZFyOQuULXF0wbqj90XyCa0gR
         wARDSKvxEvJy+BtXj+ipth/FF0Y38R/9qPz9cOOh0wy/h6cCvspbbaNHGZoc8L1j5F66
         eXHRgIUKfoLp9EhNKNNczQL499XVYbOwcbEp2A8mZxNkm++j1bZaQj9vcnyBlktuqhCK
         186Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687424075; x=1690016075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ftOXXP2bfTIIt8St3T9822C8Mz+yI5OAEWwVCqdxqi8=;
        b=PfGFavK0UntoRfvIyi8q0x934c3leOBFI0Xv2XyfLm8TqXXT7yiGaFIqW8ecV7dH2f
         lpEaXZnuvPYxJfys2ObSqoHgM0aCIGMrKHGfm2bPnayzsz1Xb//zrmXegxztv7q7vCUK
         uRVNbL9HhgeQqc78XBoOAbjAt/b/yTbupy3XdIBgCmCrAzaoc9CqKZphk27asSSOjnB4
         OnT+0TKN9gwATtKvdFeiNLV7gmkR7n58wKBVFpLkLaNagWdj8TuFU/dgeDLD75lOxcRy
         jz4VyauLLRo1q+UEUShrp0vG7aXAYO+BIsOYSkcmM8Vq/v8LoUjC6ZjSlh3PzqfA9E8Y
         r/UQ==
X-Gm-Message-State: AC+VfDw+2Aw7bWX974p0svSfRWgzdLB03DWtH5de1UEztxujb/zo8Lwk
        kJ7ovoE/P2ik3gxMbqoqZ04O0g==
X-Google-Smtp-Source: ACHHUZ5hV1GhQPf78RPEQj8dLuXzVGGtbX4uDKxYqhUuZR/F2WM6CQGQNWMXHDLRseslqPACLVPKJA==
X-Received: by 2002:a17:903:1246:b0:1b3:d8ac:8db3 with SMTP id u6-20020a170903124600b001b3d8ac8db3mr21942648plh.6.1687424075082;
        Thu, 22 Jun 2023 01:54:35 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:54:34 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 04/29] drm/msm: dynamically allocate the drm-msm_gem shrinker
Date:   Thu, 22 Jun 2023 16:53:10 +0800
Message-Id: <20230622085335.77010-5-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In preparation for implementing lockless slab shrink,
we need to dynamically allocate the drm-msm_gem shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct msm_drm_private.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/gpu/drm/msm/msm_drv.h          |  2 +-
 drivers/gpu/drm/msm/msm_gem_shrinker.c | 25 ++++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index e13a8cbd61c9..4f3ba55058cd 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -217,7 +217,7 @@ struct msm_drm_private {
 	} vram;
 
 	struct notifier_block vmap_notifier;
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 
 	struct drm_atomic_state *pm_state;
 
diff --git a/drivers/gpu/drm/msm/msm_gem_shrinker.c b/drivers/gpu/drm/msm/msm_gem_shrinker.c
index f38296ad8743..db7582ae1f19 100644
--- a/drivers/gpu/drm/msm/msm_gem_shrinker.c
+++ b/drivers/gpu/drm/msm/msm_gem_shrinker.c
@@ -34,8 +34,7 @@ static bool can_block(struct shrink_control *sc)
 static unsigned long
 msm_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
 {
-	struct msm_drm_private *priv =
-		container_of(shrinker, struct msm_drm_private, shrinker);
+	struct msm_drm_private *priv = shrinker->private_data;
 	unsigned count = priv->lru.dontneed.count;
 
 	if (can_swap())
@@ -100,8 +99,7 @@ active_evict(struct drm_gem_object *obj)
 static unsigned long
 msm_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 {
-	struct msm_drm_private *priv =
-		container_of(shrinker, struct msm_drm_private, shrinker);
+	struct msm_drm_private *priv = shrinker->private_data;
 	struct {
 		struct drm_gem_lru *lru;
 		bool (*shrink)(struct drm_gem_object *obj);
@@ -151,7 +149,7 @@ msm_gem_shrinker_shrink(struct drm_device *dev, unsigned long nr_to_scan)
 	int ret;
 
 	fs_reclaim_acquire(GFP_KERNEL);
-	ret = msm_gem_shrinker_scan(&priv->shrinker, &sc);
+	ret = msm_gem_shrinker_scan(priv->shrinker, &sc);
 	fs_reclaim_release(GFP_KERNEL);
 
 	return ret;
@@ -213,10 +211,15 @@ msm_gem_shrinker_vmap(struct notifier_block *nb, unsigned long event, void *ptr)
 void msm_gem_shrinker_init(struct drm_device *dev)
 {
 	struct msm_drm_private *priv = dev->dev_private;
-	priv->shrinker.count_objects = msm_gem_shrinker_count;
-	priv->shrinker.scan_objects = msm_gem_shrinker_scan;
-	priv->shrinker.seeks = DEFAULT_SEEKS;
-	WARN_ON(register_shrinker(&priv->shrinker, "drm-msm_gem"));
+
+	priv->shrinker = shrinker_alloc_and_init(msm_gem_shrinker_count,
+						 msm_gem_shrinker_scan, 0,
+						 DEFAULT_SEEKS, 0, priv);
+	if (priv->shrinker &&
+	    register_shrinker(priv->shrinker, "drm-msm_gem")) {
+		shrinker_free(priv->shrinker);
+		WARN_ON(1);
+	}
 
 	priv->vmap_notifier.notifier_call = msm_gem_shrinker_vmap;
 	WARN_ON(register_vmap_purge_notifier(&priv->vmap_notifier));
@@ -232,8 +235,8 @@ void msm_gem_shrinker_cleanup(struct drm_device *dev)
 {
 	struct msm_drm_private *priv = dev->dev_private;
 
-	if (priv->shrinker.nr_deferred) {
+	if (priv->shrinker->nr_deferred) {
 		WARN_ON(unregister_vmap_purge_notifier(&priv->vmap_notifier));
-		unregister_shrinker(&priv->shrinker);
+		unregister_and_free_shrinker(priv->shrinker);
 	}
 }
-- 
2.30.2


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D6A77220B
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Aug 2023 13:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbjHGL2t (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Aug 2023 07:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbjHGL2Q (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Aug 2023 07:28:16 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6A259E5
        for <linux-bcache@vger.kernel.org>; Mon,  7 Aug 2023 04:24:46 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-56d279a4d5cso868360eaf.1
        for <linux-bcache@vger.kernel.org>; Mon, 07 Aug 2023 04:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407439; x=1692012239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjqO/ZPr/Go39gpx6DVg0WzFepitwPif37hI1XuxbyE=;
        b=Q4LfZpfKfLruqbacrw0V/6Zj0wJBWQjpblt8Gf76xVQ0wXb2JbDjgbhn5BPwoO1hou
         cQcKBE9v3aJPVRHkxyfcvh2Mkvro95hzeihox9pl13ZyCOorEpTN4kAGQR41JOE6h9BX
         ysAL18Nh2Tk/eQ0Eged6wBnoVrgtUBJS6hkNvangvgBfLut0Oug7lj1fqWwfgi9gySfI
         tLEm00T3NSj6LioyjZXIf0SEMOwy5MMnqgiow43Q/I32ntNlHZVulouZQX/H1qVu5qTI
         6dp5JNJrKzIzIGnfT9cZwN1+rjMGf+3wUF2l8KVMPSuuCOZxJceumS5vHAbNpjwfju67
         xr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407439; x=1692012239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vjqO/ZPr/Go39gpx6DVg0WzFepitwPif37hI1XuxbyE=;
        b=fy6EihUIIZOGQtIXGaVqQmVaOjzUm3E6wGEnUMndld8PPhw3/BpGu5AxHXChu6A+pe
         WwVJE+0FXAo519pcKH1D5GtCxWjqjpAQ6AWQQR6wziK8zgybte7oLDNKZzao5G2GrJnb
         QJgvBn0QH7YHSk26culAq4vQk8fV0Bgdvjdi9CNKANIbIlm1CjrWwRCpWgeIsD8WdW2v
         wnZ1RF7vxy4WTtMZ/DXWQQmryLJQCx8WnGyfMYlbkRJpOvWmeYWhkviQ1IrBzSwEFq+c
         Z6csfRGLdMayKMoDvEtrTAaOQqJkyjL9G/zXoyT5C64XwgR6RLCMGTyyv6oVFGB74bYo
         nkIA==
X-Gm-Message-State: ABy/qLaxC45RnpCFRYam+8h3ft7P33yuRcLSD2/D4Cthulz31BV4Aj1K
        B5DJpeiToyhSKEux07FdLsueP2tQCHaCrrhXhbc=
X-Google-Smtp-Source: APBJJlGmDPkOqvUzYBlbH7T7lkG5BB9heuLk9VUuk/u1AhmT0DHlhAEqotepcvwe4m42tykQjmW6CA==
X-Received: by 2002:a17:90a:4104:b0:25c:1ad3:a4a1 with SMTP id u4-20020a17090a410400b0025c1ad3a4a1mr24597319pjf.1.1691406917979;
        Mon, 07 Aug 2023 04:15:17 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:15:17 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev, simon.horman@corigine.com,
        dlemoal@kernel.org
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
Subject: [PATCH v4 25/48] drm/panfrost: dynamically allocate the drm-panfrost shrinker
Date:   Mon,  7 Aug 2023 19:09:13 +0800
Message-Id: <20230807110936.21819-26-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the drm-panfrost shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct panfrost_device.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 drivers/gpu/drm/panfrost/panfrost_device.h    |  2 +-
 drivers/gpu/drm/panfrost/panfrost_drv.c       |  6 +++-
 drivers/gpu/drm/panfrost/panfrost_gem.h       |  2 +-
 .../gpu/drm/panfrost/panfrost_gem_shrinker.c  | 30 +++++++++++--------
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
index b0126b9fbadc..e667e5689353 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.h
+++ b/drivers/gpu/drm/panfrost/panfrost_device.h
@@ -118,7 +118,7 @@ struct panfrost_device {
 
 	struct mutex shrinker_lock;
 	struct list_head shrinker_list;
-	struct shrinker shrinker;
+	struct shrinker *shrinker;
 
 	struct panfrost_devfreq pfdevfreq;
 };
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index a2ab99698ca8..e1d0e3a23757 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -601,10 +601,14 @@ static int panfrost_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_out1;
 
-	panfrost_gem_shrinker_init(ddev);
+	err = panfrost_gem_shrinker_init(ddev);
+	if (err)
+		goto err_out2;
 
 	return 0;
 
+err_out2:
+	drm_dev_unregister(ddev);
 err_out1:
 	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index ad2877eeeccd..863d2ec8d4f0 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -81,7 +81,7 @@ panfrost_gem_mapping_get(struct panfrost_gem_object *bo,
 void panfrost_gem_mapping_put(struct panfrost_gem_mapping *mapping);
 void panfrost_gem_teardown_mappings_locked(struct panfrost_gem_object *bo);
 
-void panfrost_gem_shrinker_init(struct drm_device *dev);
+int panfrost_gem_shrinker_init(struct drm_device *dev);
 void panfrost_gem_shrinker_cleanup(struct drm_device *dev);
 
 #endif /* __PANFROST_GEM_H__ */
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
index 6a71a2555f85..3dfe2b7ccdd9 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem_shrinker.c
@@ -18,8 +18,7 @@
 static unsigned long
 panfrost_gem_shrinker_count(struct shrinker *shrinker, struct shrink_control *sc)
 {
-	struct panfrost_device *pfdev =
-		container_of(shrinker, struct panfrost_device, shrinker);
+	struct panfrost_device *pfdev = shrinker->private_data;
 	struct drm_gem_shmem_object *shmem;
 	unsigned long count = 0;
 
@@ -65,8 +64,7 @@ static bool panfrost_gem_purge(struct drm_gem_object *obj)
 static unsigned long
 panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
 {
-	struct panfrost_device *pfdev =
-		container_of(shrinker, struct panfrost_device, shrinker);
+	struct panfrost_device *pfdev = shrinker->private_data;
 	struct drm_gem_shmem_object *shmem, *tmp;
 	unsigned long freed = 0;
 
@@ -97,13 +95,22 @@ panfrost_gem_shrinker_scan(struct shrinker *shrinker, struct shrink_control *sc)
  *
  * This function registers and sets up the panfrost shrinker.
  */
-void panfrost_gem_shrinker_init(struct drm_device *dev)
+int panfrost_gem_shrinker_init(struct drm_device *dev)
 {
 	struct panfrost_device *pfdev = dev->dev_private;
-	pfdev->shrinker.count_objects = panfrost_gem_shrinker_count;
-	pfdev->shrinker.scan_objects = panfrost_gem_shrinker_scan;
-	pfdev->shrinker.seeks = DEFAULT_SEEKS;
-	WARN_ON(register_shrinker(&pfdev->shrinker, "drm-panfrost"));
+
+	pfdev->shrinker = shrinker_alloc(0, "drm-panfrost");
+	if (!pfdev->shrinker)
+		return -ENOMEM;
+
+	pfdev->shrinker->count_objects = panfrost_gem_shrinker_count;
+	pfdev->shrinker->scan_objects = panfrost_gem_shrinker_scan;
+	pfdev->shrinker->seeks = DEFAULT_SEEKS;
+	pfdev->shrinker->private_data = pfdev;
+
+	shrinker_register(pfdev->shrinker);
+
+	return 0;
 }
 
 /**
@@ -116,7 +123,6 @@ void panfrost_gem_shrinker_cleanup(struct drm_device *dev)
 {
 	struct panfrost_device *pfdev = dev->dev_private;
 
-	if (pfdev->shrinker.nr_deferred) {
-		unregister_shrinker(&pfdev->shrinker);
-	}
+	if (pfdev->shrinker)
+		shrinker_free(pfdev->shrinker);
 }
-- 
2.30.2


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393E5764B65
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jul 2023 10:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjG0IO5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 27 Jul 2023 04:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjG0IMO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Jul 2023 04:12:14 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B1B35BC
        for <linux-bcache@vger.kernel.org>; Thu, 27 Jul 2023 01:07:56 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-6748a616e17so182452b3a.1
        for <linux-bcache@vger.kernel.org>; Thu, 27 Jul 2023 01:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690445222; x=1691050022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hJ9OcOwqZEZhIoLNGrov7as0vMS5t1dTfm2Sm9qefJI=;
        b=AioCATUlkHfrdNMX26y5cMG8yiZzcrqJVPo4kMJoo0a/SPBGZMItYxbURGlfK0qQ3U
         pdquqHjvBnBibcfcPa96/7pchRYEBHxyNnf24E8fTswl7dwSe4DIa81z6/ovJRcM58gW
         OCn1XGDPuwokH00bwAsXcK1Gr5D3vpz/ZXjhjYJknWBgLZAbQPwFGeGyEdzXyVgOqH5z
         Y8WwL8gpftvasBEeZpl0cei4t7+d2ZCdr5qxpBrrzaVJwzr8lwB/25SUTyxKcTGn9xox
         E7xpcSMCUuenHibKLxGm6dPJne0R4y90eWbLKKoQI9m29dm8UqZ2/hC+L12FcXTeAlus
         bdTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445222; x=1691050022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hJ9OcOwqZEZhIoLNGrov7as0vMS5t1dTfm2Sm9qefJI=;
        b=IB5bIYpAaqYQOwqL/iosnYFe28HR1MEV44yxlte8+HVqJrRJLAOty1DCw9R0pm68gx
         gVLwV9yWhJp5UgJCzhX06KklSWYQu8fEs3Oe8ji7Py4QXZoRs/A0sNDTRR4HHMpvWcw+
         VhZs5LAb5QbLoaG7LU3XqLgqt2uBK/8TSxbBQIfyvXrZfPrBKeWllUgXNatuaJbGtWLu
         fCsGVLUWsE6DpOhLfLIgjJvkiQ+laeCQ6G2M56OwcsVXoHgk3lPeX1VuiXJ4PFbKfnEc
         mGmeF2S7U27hea1FtvYawFOM8TU6sz3ayHB8zblJI0YzBOk9spTR9BF3RzAvyrRa8dEg
         Bs9Q==
X-Gm-Message-State: ABy/qLapoFvqBwOUaTMM3gtVGtttL+YJs2S3CrpKOJkiX6r5nAHJW66h
        V21yTMV1PgoHb+jf6LyCnzZZFQ==
X-Google-Smtp-Source: APBJJlEQjBlPfpR5V6JAfBPtQGnM4uH9f200On7b1qJi/VneGv5RiS5uPlFi7ClY0YXsCiY0kjcbBw==
X-Received: by 2002:aa7:8615:0:b0:681:9fe0:b543 with SMTP id p21-20020aa78615000000b006819fe0b543mr4619538pfn.2.1690445222261;
        Thu, 27 Jul 2023 01:07:02 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:07:01 -0700 (PDT)
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
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 06/49] kvm: mmu: dynamically allocate the x86-mmu shrinker
Date:   Thu, 27 Jul 2023 16:04:19 +0800
Message-Id: <20230727080502.77895-7-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
References: <20230727080502.77895-1-zhengqi.arch@bytedance.com>
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

Use new APIs to dynamically allocate the x86-mmu shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..15fc92a24a26 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6847,11 +6847,7 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
-static struct shrinker mmu_shrinker = {
-	.count_objects = mmu_shrink_count,
-	.scan_objects = mmu_shrink_scan,
-	.seeks = DEFAULT_SEEKS * 10,
-};
+static struct shrinker *mmu_shrinker;
 
 static void mmu_destroy_caches(void)
 {
@@ -6984,10 +6980,16 @@ int kvm_mmu_vendor_module_init(void)
 	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
 		goto out;
 
-	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
-	if (ret)
+	mmu_shrinker = shrinker_alloc(0, "x86-mmu");
+	if (!mmu_shrinker)
 		goto out_shrinker;
 
+	mmu_shrinker->count_objects = mmu_shrink_count;
+	mmu_shrinker->scan_objects = mmu_shrink_scan;
+	mmu_shrinker->seeks = DEFAULT_SEEKS * 10;
+
+	shrinker_register(mmu_shrinker);
+
 	return 0;
 
 out_shrinker:
@@ -7009,7 +7011,7 @@ void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
-	unregister_shrinker(&mmu_shrinker);
+	shrinker_free(mmu_shrinker);
 }
 
 /*
-- 
2.30.2


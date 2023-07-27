Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B83C764CAB
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jul 2023 10:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjG0IZD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 27 Jul 2023 04:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234221AbjG0IXC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Jul 2023 04:23:02 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EABC448F
        for <linux-bcache@vger.kernel.org>; Thu, 27 Jul 2023 01:13:30 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-682eef7d752so204762b3a.0
        for <linux-bcache@vger.kernel.org>; Thu, 27 Jul 2023 01:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690445563; x=1691050363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QelXbRgYcu/a7kVf8tT2xmPKs8Q6fhUGUeX576V7Nl8=;
        b=X2/dKeRh3K1ZUeUXRmYcuLAwkmDYhdwx9iwlPAtXfC0B4vHXtLguXST30gjNSIXFT7
         OLt7OLAHNBNYpcouioFmzFwp83h1VVZBZI/b5TZHZteUiScXCbvweVFodKUOy9sCj8AV
         ZENggnGp80mAUTxGhU/fnzaRvZdNkV5cPcoIInnSny5prudiipt4/IqGTm49bA8p77kr
         6rthKHnFEd97DZ60+ymFLTYrwmYvoXhejWrNb12L9I2KL1LTnT8oJzoHo7/LmyIBjEhr
         5sNbvq2AFaPoM5/YQzjEzmuEQi5h7hErc8c8ASDByEVVMFkteQf8s6ncJNWVLrxavMEP
         hYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690445563; x=1691050363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QelXbRgYcu/a7kVf8tT2xmPKs8Q6fhUGUeX576V7Nl8=;
        b=f9KHCY8OUOmyE4Wcb0pofi4EWslFmfskoKMollSGo3eBWxsmB8gSFrLSbBJ4GlArg4
         ScWqyqlPYNssn8+CXM23qRnhtGW4jpeYyEfTfw+o+grBEzqUFgQpNJh5ktVMX5DgNwGo
         F1qx9LIJKAT/ijHLM08Rd8eVP9mNBuZCzaqj+HeduTi7ip3dJxU+WxmOotcbOfl8T/Fx
         8+DpVF++t4Dt1nZ5VcSekD8A0cIFjN0Rj36FCoZ0fKt+B7p5M1oAh9m3Jzezs2c55QcJ
         TcWytH7mO2JMYcwudNT1L8M/f6AGjDeBWD5sn7kobaWs5Fu4Xt6y010OU4Dit4N2iMCd
         zgRA==
X-Gm-Message-State: ABy/qLZ8JrLieSB0k11xyXfIOt1LYPC4dGjLucSxmNALtabN3yntrbh1
        ckFdCmOpqger3nybzt441p9ZMg==
X-Google-Smtp-Source: APBJJlG3us3D1/FzajU+z+h8urvbqwZdl/1CQD95N0Bm05n475Xxe2FLYU/iNliwdKbEyGNSdPUcwg==
X-Received: by 2002:a05:6a00:13a3:b0:676:2a5c:7bc5 with SMTP id t35-20020a056a0013a300b006762a5c7bc5mr5237596pfg.1.1690445563409;
        Thu, 27 Jul 2023 01:12:43 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b006828e49c04csm885872pfe.75.2023.07.27.01.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 01:12:43 -0700 (PDT)
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
Subject: [PATCH v3 34/49] ext4: dynamically allocate the ext4-es shrinker
Date:   Thu, 27 Jul 2023 16:04:47 +0800
Message-Id: <20230727080502.77895-35-zhengqi.arch@bytedance.com>
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

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the ext4-es shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct ext4_sb_info.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/ext4/ext4.h           |  2 +-
 fs/ext4/extents_status.c | 22 ++++++++++++----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e2259d9967d..82397bf0b33e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1657,7 +1657,7 @@ struct ext4_sb_info {
 	__u32 s_csum_seed;
 
 	/* Reclaim extents from extent status tree */
-	struct shrinker s_es_shrinker;
+	struct shrinker *s_es_shrinker;
 	struct list_head s_es_list;	/* List of inodes with reclaimable extents */
 	long s_es_nr_inode;
 	struct ext4_es_stats s_es_stats;
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 9b5b8951afb4..74bb64fadbc4 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1596,7 +1596,7 @@ static unsigned long ext4_es_count(struct shrinker *shrink,
 	unsigned long nr;
 	struct ext4_sb_info *sbi;
 
-	sbi = container_of(shrink, struct ext4_sb_info, s_es_shrinker);
+	sbi = shrink->private_data;
 	nr = percpu_counter_read_positive(&sbi->s_es_stats.es_stats_shk_cnt);
 	trace_ext4_es_shrink_count(sbi->s_sb, sc->nr_to_scan, nr);
 	return nr;
@@ -1605,8 +1605,7 @@ static unsigned long ext4_es_count(struct shrinker *shrink,
 static unsigned long ext4_es_scan(struct shrinker *shrink,
 				  struct shrink_control *sc)
 {
-	struct ext4_sb_info *sbi = container_of(shrink,
-					struct ext4_sb_info, s_es_shrinker);
+	struct ext4_sb_info *sbi = shrink->private_data;
 	int nr_to_scan = sc->nr_to_scan;
 	int ret, nr_shrunk;
 
@@ -1690,14 +1689,17 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 	if (err)
 		goto err3;
 
-	sbi->s_es_shrinker.scan_objects = ext4_es_scan;
-	sbi->s_es_shrinker.count_objects = ext4_es_count;
-	sbi->s_es_shrinker.seeks = DEFAULT_SEEKS;
-	err = register_shrinker(&sbi->s_es_shrinker, "ext4-es:%s",
-				sbi->s_sb->s_id);
-	if (err)
+	sbi->s_es_shrinker = shrinker_alloc(0, "ext4-es:%s", sbi->s_sb->s_id);
+	if (!sbi->s_es_shrinker)
 		goto err4;
 
+	sbi->s_es_shrinker->scan_objects = ext4_es_scan;
+	sbi->s_es_shrinker->count_objects = ext4_es_count;
+	sbi->s_es_shrinker->seeks = DEFAULT_SEEKS;
+	sbi->s_es_shrinker->private_data = sbi;
+
+	shrinker_register(sbi->s_es_shrinker);
+
 	return 0;
 err4:
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
@@ -1716,7 +1718,7 @@ void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_misses);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
-	unregister_shrinker(&sbi->s_es_shrinker);
+	shrinker_free(sbi->s_es_shrinker);
 }
 
 /*
-- 
2.30.2


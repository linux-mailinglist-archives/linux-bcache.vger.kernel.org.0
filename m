Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131E5772132
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Aug 2023 13:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjHGLT6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Aug 2023 07:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjHGLTd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Aug 2023 07:19:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D36CE5B
        for <linux-bcache@vger.kernel.org>; Mon,  7 Aug 2023 04:17:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-268663fb09cso631792a91.0
        for <linux-bcache@vger.kernel.org>; Mon, 07 Aug 2023 04:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691407020; x=1692011820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIUP2Z+Njo4a1BEj4icZmHsMWaHOvZz2gypuwwXx0Do=;
        b=l3d3GmRdHVbykswjvj36xLNJU/HkRN0qQPtaCG+8C7U8JyCsrS7Omd1smNfjTVHq8n
         mmfknLuVWKPue6MQRQdYpG2Cap7GHxCVjCjmXm7SqhyxnTlXTIqiD6Dq4SurElV0d5A7
         yjtafWW6aQouIDt5nRUMTSVpj6O1jVRczCF6pjoLUl7iIEpS61wXJNKr8xLD++xEk/hK
         PFaJuConQXPH9DxAW8LM6Qo0CoTe6tjYe9zN1tPP9wJtycShcCxIvBgENM+8mu3gxPqB
         pNPWVQXnsLY4dcbOjU72J1n4zmuXrZ5CIb4eDvQ0qGFRUeSI2BGNFxZSx5CdqcSToBir
         CZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691407020; x=1692011820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIUP2Z+Njo4a1BEj4icZmHsMWaHOvZz2gypuwwXx0Do=;
        b=Vx3Fcw+So6eQx2pj/8cDWUNQ4Tpl3wOSjlpd+BCa7FF7+pEFwdd9VASUDQMa3bYdLE
         iKBxNW7sxHgTWEMD5pZjFDOOm8NX/RpGnZsT0oOcUo/vcmJVNkpej9bAnpGbipfI2gZ8
         fTzoEXJoePeTGMPK5EXV+D3kT9j5X0GcP5TfKjTV9GdDfs7kKA99HSY3hdpiTMM7XT2T
         tJ/F6PdzD4qTR/7NSn8dL5jVXYjLiEBuiatRjY+/xUrz7UBb2yks5pg2BKHklB15Gr+4
         XjVpWNbK88xION0nj5RJ0S4xMGoUqcFoJwm4A0TBncc5oYkqdpyUcWVpdYD3PMyWE/bf
         RIiw==
X-Gm-Message-State: AOJu0YzeOlvzfsZO3Sx1ynBLvMpmTAg+wsuM4jHtlsfIBpEkiqzgW5DH
        yuxNfHnWZkB6mhMPQDQ864gb0w==
X-Google-Smtp-Source: AGHT+IGL/1gBIk2C+QwkMNr6hEGRZG4q+xpVeUoXNA4D2kibZqrKnrVjY0bqX283iYX9eWQrJAN/xA==
X-Received: by 2002:a17:90a:6701:b0:269:32c7:24dc with SMTP id n1-20020a17090a670100b0026932c724dcmr6036278pjj.0.1691407020016;
        Mon, 07 Aug 2023 04:17:00 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:16:59 -0700 (PDT)
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
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 33/48] ext4: dynamically allocate the ext4-es shrinker
Date:   Mon,  7 Aug 2023 19:09:21 +0800
Message-Id: <20230807110936.21819-34-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 fs/ext4/extents_status.c | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 481491e892df..48baf03eb1a6 100644
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
index 9b5b8951afb4..0532a81a7669 100644
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
 
@@ -1690,13 +1689,18 @@ int ext4_es_register_shrinker(struct ext4_sb_info *sbi)
 	if (err)
 		goto err3;
 
-	sbi->s_es_shrinker.scan_objects = ext4_es_scan;
-	sbi->s_es_shrinker.count_objects = ext4_es_count;
-	sbi->s_es_shrinker.seeks = DEFAULT_SEEKS;
-	err = register_shrinker(&sbi->s_es_shrinker, "ext4-es:%s",
-				sbi->s_sb->s_id);
-	if (err)
+	sbi->s_es_shrinker = shrinker_alloc(0, "ext4-es:%s", sbi->s_sb->s_id);
+	if (!sbi->s_es_shrinker) {
+		err = -ENOMEM;
 		goto err4;
+	}
+
+	sbi->s_es_shrinker->scan_objects = ext4_es_scan;
+	sbi->s_es_shrinker->count_objects = ext4_es_count;
+	sbi->s_es_shrinker->seeks = DEFAULT_SEEKS;
+	sbi->s_es_shrinker->private_data = sbi;
+
+	shrinker_register(sbi->s_es_shrinker);
 
 	return 0;
 err4:
@@ -1716,7 +1720,7 @@ void ext4_es_unregister_shrinker(struct ext4_sb_info *sbi)
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_cache_misses);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_all_cnt);
 	percpu_counter_destroy(&sbi->s_es_stats.es_stats_shk_cnt);
-	unregister_shrinker(&sbi->s_es_shrinker);
+	shrinker_free(sbi->s_es_shrinker);
 }
 
 /*
-- 
2.30.2


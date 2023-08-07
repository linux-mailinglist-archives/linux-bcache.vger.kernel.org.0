Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07D57722C6
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Aug 2023 13:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbjHGLil (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Aug 2023 07:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjHGLh3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Aug 2023 07:37:29 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC99C524E
        for <linux-bcache@vger.kernel.org>; Mon,  7 Aug 2023 04:34:19 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-790af3bfa5cso28227439f.1
        for <linux-bcache@vger.kernel.org>; Mon, 07 Aug 2023 04:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1691408014; x=1692012814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jaqVlo27zysQOw4inLaa7RWYi61naAqQm5GJ5upJpN4=;
        b=SnTpBglMEYCPit1GhsVHUSdo5sXgRcQutwheoXRhOcMNLPbwLK14flaBtOSpZBxNKV
         Clc/pGAY9qN5yvBZFI3W5gaBoTejbOyumUoD/3jtFs+NOX8ezoiXEP3Qn+JRUtHFJn9u
         Oel6mmaHsvZXhqwTTRQEBzgu13XH7q26jRMUbT+VdBf1iEM6kOyjKH0qqjOUMsYAhZeM
         ONUCRoTn5WGEqktYu/ivpW2Lju0z3ov+Cf/+5G6x0gd3+k4gCYqfvNmDktLgxWEXGSJl
         ifm65mVD771ol/FOn3pQ5fv1cSJXZotxS3KXWJO+/Yna2qSosuDvGGtaKTPdg1+ZE9Kb
         exoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691408014; x=1692012814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaqVlo27zysQOw4inLaa7RWYi61naAqQm5GJ5upJpN4=;
        b=KAyFye+NjMbB8QJMmo5jRsnMw8zD168vFkdQo+kJny6MnomSWo3tC/ePt6jaMFY9ZE
         Ccqy3gV/Hbj5+3PoXLydSpV9HDvlUsjEJzaA3jTfuojh+wzkDgh/ALYneUQ8+YOoie7g
         wE/H2u78SlI+ZGBvxdIU5r3TRZk0Aq5g7R8McmZ13+hPW4OE9is/XfbyEemOu1pSbrHi
         eSGrgJQbVpTeCZ+hYcAfx2SNVZa5Ndcwo9gm9fTM05/SASm8+nsUVRJh97QQBiYM6nA4
         sUyL4Y/HHYomui3p5R24OWqJ/UIfZP58bijD+bojmWc11aSnZw+RLM+tbtvEYCvbiFfi
         pPoQ==
X-Gm-Message-State: ABy/qLawV+LXSobW5pOWouCc4VrWZVqwFjkRJx5d1HPudBXJQiqoP+tz
        odS72yKlMgEkTPo1hdydeweIcgxt72440bK15MU=
X-Google-Smtp-Source: AGHT+IHBSjfm4qMxfKY1o30DsQrf62j+YLyyzQgOSjZX7MvZKQZkongUtrzUOFN5xrnWaoCKIehpOA==
X-Received: by 2002:a17:90a:9c3:b0:269:41cf:7212 with SMTP id 61-20020a17090a09c300b0026941cf7212mr4969668pjo.4.1691407071669;
        Mon, 07 Aug 2023 04:17:51 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090aca8d00b0025be7b69d73sm5861191pjt.12.2023.08.07.04.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 04:17:51 -0700 (PDT)
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
Subject: [PATCH v4 37/48] xfs: dynamically allocate the xfs-buf shrinker
Date:   Mon,  7 Aug 2023 19:09:25 +0800
Message-Id: <20230807110936.21819-38-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
References: <20230807110936.21819-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In preparation for implementing lockless slab shrink, use new APIs to
dynamically allocate the xfs-buf shrinker, so that it can be freed
asynchronously using kfree_rcu(). Then it doesn't need to wait for RCU
read-side critical section when releasing the struct xfs_buftarg.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/xfs/xfs_buf.c | 25 ++++++++++++++-----------
 fs/xfs/xfs_buf.h |  2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15d1e5a7c2d3..715730fc91cb 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1906,8 +1906,7 @@ xfs_buftarg_shrink_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buftarg	*btp = shrink->private_data;
 	LIST_HEAD(dispose);
 	unsigned long		freed;
 
@@ -1929,8 +1928,7 @@ xfs_buftarg_shrink_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buftarg	*btp = shrink->private_data;
 	return list_lru_shrink_count(&btp->bt_lru, sc);
 }
 
@@ -1938,7 +1936,7 @@ void
 xfs_free_buftarg(
 	struct xfs_buftarg	*btp)
 {
-	unregister_shrinker(&btp->bt_shrinker);
+	shrinker_free(btp->bt_shrinker);
 	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
@@ -2021,13 +2019,18 @@ xfs_alloc_buftarg(
 	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
 		goto error_lru;
 
-	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
-	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
-	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
-	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
-	if (register_shrinker(&btp->bt_shrinker, "xfs-buf:%s",
-			      mp->m_super->s_id))
+	btp->bt_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE, "xfs-buf:%s",
+					  mp->m_super->s_id);
+	if (!btp->bt_shrinker)
 		goto error_pcpu;
+
+	btp->bt_shrinker->count_objects = xfs_buftarg_shrink_count;
+	btp->bt_shrinker->scan_objects = xfs_buftarg_shrink_scan;
+	btp->bt_shrinker->seeks = DEFAULT_SEEKS;
+	btp->bt_shrinker->private_data = btp;
+
+	shrinker_register(btp->bt_shrinker);
+
 	return btp;
 
 error_pcpu:
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208..4e6969a675f7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -102,7 +102,7 @@ typedef struct xfs_buftarg {
 	size_t			bt_logical_sectormask;
 
 	/* LRU control structures */
-	struct shrinker		bt_shrinker;
+	struct shrinker		*bt_shrinker;
 	struct list_lru		bt_lru;
 
 	struct percpu_counter	bt_io_count;
-- 
2.30.2


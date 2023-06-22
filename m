Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC3C739B84
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 11:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjFVJBz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 05:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjFVJAy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 05:00:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8103C11
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:56:52 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b5079b8cb3so12591025ad.1
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687424188; x=1690016188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTZEGaIAEFBjvotA1NXyBA/23sGgDmW1pgUANJLmL6g=;
        b=RR2ZBd6H05awxDqDqVthUnK8c2aiJ3/40MwwmbAPlBGQiSswQkBwcxNT/M8cNWLnOA
         82Up+za+KnH3T12j6kLa8MWMs1OLNz27XFTdAlPbZ38sAlCSEZeBeei4jIEF3DOGcfFf
         sqLx7qpbJbMhGZOLWmDQDC3qBDYjKQCUQ+pHZmp4+zwVYsBG9SEPO8LfQRHMRrJmIPZH
         mEo73QmcjA4JR+vhCDbl2LS55wzlx82Sg5Hmni0lGgyYmJGvSzc9k9c1k7gD3cDGUkxo
         aNJG0MDIsuR+BfQGSCBSsk1/g4GTm7BXhgoQS8izvkkK6lhK2DzzoNDI+34/82OB/BW3
         znuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687424188; x=1690016188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tTZEGaIAEFBjvotA1NXyBA/23sGgDmW1pgUANJLmL6g=;
        b=b4qoco4T/N2x68tdB93/4I3XN9lW85iVVIE9gTQJNSzS8YG4FueRPDnTWlZTKxg8u5
         p5tDKuBwruh6XNpKhJSLukSs2pgJizGxtPz36qs1RQfxbIcZlNVvmqmzh9i1/c6u30GT
         Ugmd7QEr+JukNW6dpVZYtbEKQRqZ8NHibcvtUbO0Lle1em3EDD/ZSaz7u/ik0YjwbBEy
         w5ZaBjhI8t/32bEGyouWPxLBeXcfz3e9KuHMayr7vaK9xIIrHjU9JWBRLGqBzMB6vYUQ
         HKaeDdUjxbfSZ7htdr4G6kwRV//nXN4bCRjMeYVxz1XS8ZkqN8bLii4Uq0/0NO0HrgJc
         xPCg==
X-Gm-Message-State: AC+VfDyN7birw+Eal8bUUKPSMRdcZUV3w9dczsW4czUfDXC0EFI9CWEo
        aswfnewKVe2etrTKRVw4kGGxlQ==
X-Google-Smtp-Source: ACHHUZ6OWalxJOPaEyVlek6DUPm2brDmU3Y4XuKo9voozhXt0KV98CJSzaGxqKjpiLWREy1Rn2GjcA==
X-Received: by 2002:a17:902:dac6:b0:1ac:656f:a68d with SMTP id q6-20020a170902dac600b001ac656fa68dmr21469547plx.4.1687424187780;
        Thu, 22 Jun 2023 01:56:27 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:56:27 -0700 (PDT)
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
Subject: [PATCH 18/29] xfs: dynamically allocate the xfs-inodegc shrinker
Date:   Thu, 22 Jun 2023 16:53:24 +0800
Message-Id: <20230622085335.77010-19-zhengqi.arch@bytedance.com>
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
we need to dynamically allocate the xfs-inodegc shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct xfs_mount.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/xfs/xfs_icache.c | 27 ++++++++++++++++-----------
 fs/xfs/xfs_mount.c  |  4 ++--
 fs/xfs/xfs_mount.h  |  2 +-
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 453890942d9f..1ef0c9fa57de 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -2225,8 +2225,7 @@ xfs_inodegc_shrinker_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
-						   m_inodegc_shrinker);
+	struct xfs_mount	*mp = shrink->private_data;
 	struct xfs_inodegc	*gc;
 	int			cpu;
 
@@ -2247,8 +2246,7 @@ xfs_inodegc_shrinker_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_mount	*mp = container_of(shrink, struct xfs_mount,
-						   m_inodegc_shrinker);
+	struct xfs_mount	*mp = shrink->private_data;
 	struct xfs_inodegc	*gc;
 	int			cpu;
 	bool			no_items = true;
@@ -2284,13 +2282,20 @@ int
 xfs_inodegc_register_shrinker(
 	struct xfs_mount	*mp)
 {
-	struct shrinker		*shrink = &mp->m_inodegc_shrinker;
+	int ret;
 
-	shrink->count_objects = xfs_inodegc_shrinker_count;
-	shrink->scan_objects = xfs_inodegc_shrinker_scan;
-	shrink->seeks = 0;
-	shrink->flags = SHRINKER_NONSLAB;
-	shrink->batch = XFS_INODEGC_SHRINKER_BATCH;
+	mp->m_inodegc_shrinker =
+		shrinker_alloc_and_init(xfs_inodegc_shrinker_count,
+					xfs_inodegc_shrinker_scan,
+					XFS_INODEGC_SHRINKER_BATCH,
+					0, SHRINKER_NONSLAB, mp);
+	if (!mp->m_inodegc_shrinker)
+		return -ENOMEM;
+
+	ret = register_shrinker(mp->m_inodegc_shrinker, "xfs-inodegc:%s",
+				mp->m_super->s_id);
+	if (ret)
+		shrinker_free(mp->m_inodegc_shrinker);
 
-	return register_shrinker(shrink, "xfs-inodegc:%s", mp->m_super->s_id);
+	return ret;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fb87ffb48f7f..67286859ad34 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1018,7 +1018,7 @@ xfs_mountfs(
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
  out_inodegc_shrinker:
-	unregister_shrinker(&mp->m_inodegc_shrinker);
+	unregister_and_free_shrinker(mp->m_inodegc_shrinker);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
@@ -1100,7 +1100,7 @@ xfs_unmountfs(
 #if defined(DEBUG)
 	xfs_errortag_clearall(mp);
 #endif
-	unregister_shrinker(&mp->m_inodegc_shrinker);
+	unregister_and_free_shrinker(mp->m_inodegc_shrinker);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e2866e7fa60c..562c294ca08e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -217,7 +217,7 @@ typedef struct xfs_mount {
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 
 	/* Memory shrinker to throttle and reprioritize inodegc */
-	struct shrinker		m_inodegc_shrinker;
+	struct shrinker		*m_inodegc_shrinker;
 	/*
 	 * Workqueue item so that we can coalesce multiple inode flush attempts
 	 * into a single flush.
-- 
2.30.2


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D3A75F223
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jul 2023 12:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjGXKIi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jul 2023 06:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbjGXKIT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jul 2023 06:08:19 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6294EFC
        for <linux-bcache@vger.kernel.org>; Mon, 24 Jul 2023 03:01:05 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1bba9539a23so652835ad.1
        for <linux-bcache@vger.kernel.org>; Mon, 24 Jul 2023 03:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690192469; x=1690797269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/oK6bm2Afi7WKsfFLPLaSlUUie3UdhMRHX1z52bb4o=;
        b=W9Prg0fDQM4GlbOp7Efh7k12YSFxbQAIDSIFUNXpcxiaiwsMOqIS9spB+ZW9R8bqkG
         2eUk3vAJhRvOfzbc0lzRJ0pjebzRGDfg8mSr9wE4svx2n4tEZzvgmCHhvlLJZaqcPuTF
         ajZf7zR02a5nB3jGeTnCYDCOv2ZoK+omuzdRQRiU6Gx6ifxD/5gUipR32piSj3zU9ojE
         giQ5EbsOhgO/nBwZ9hR/Jy1y+NlQ/pZ5vMWcA3q2UVTMdeqbP2Ck3FtJpUlMmobx8vUB
         vcMI8GxEI7t1W6HxEfOkf8W6IvWEtYrQu4A2vSBZhjnQNuGVAvXWDybi001tXCfDYH7J
         BNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690192469; x=1690797269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/oK6bm2Afi7WKsfFLPLaSlUUie3UdhMRHX1z52bb4o=;
        b=Bmtz1bxCACexRQnvmwFZ6Gg4HqugAWv05T/27nGC8U2aIGAigq5SbL5qzdHtD1pQ43
         7tiqW57XF8X3dUEbjOOvV1AkHssVTy8EyaRxC7qtVilagTFWS4z6J31Nc2ZIfV8ASZ3T
         Kv19T0L1ZIBQYJ4Eyh2YDVBwu73nTgYvXnQZWi91Y61VgYnZZxXp4zqjddZJtolCP/ml
         nD7zHLMOY2vPR8SVw2VVmkI2UQfjZCyg+G3fJ9re13VWm4T+zBbaq0r51lyyLGHsypWM
         kzhR0ocxJZex+XwmXJSRe2a4Hq5KYGYQn4HGs6pd23Eq3U6faIPMj3Uk+SC5/ujB/DJp
         /86Q==
X-Gm-Message-State: ABy/qLbFsiihPC+OCh7qX85G47oPeffNFyrJCsy+Vg1taW+3yF67+tZe
        tcLGznBxJ0dEeq2yShBiEGkMoA==
X-Google-Smtp-Source: APBJJlFeSJXGwKM1/4Fx4M034iEieIqp39l7VwM/I3gIgSntmWk50xYbsW/3q3bB2XT8c22SamI2Bg==
X-Received: by 2002:a17:902:dad2:b0:1b8:9fc4:2733 with SMTP id q18-20020a170902dad200b001b89fc42733mr12483608plx.3.1690192468770;
        Mon, 24 Jul 2023 02:54:28 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:54:28 -0700 (PDT)
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
Subject: [PATCH v2 47/47] mm: shrinker: convert shrinker_rwsem to mutex
Date:   Mon, 24 Jul 2023 17:43:54 +0800
Message-Id: <20230724094354.90817-48-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now there are no readers of shrinker_rwsem, so we can simply replace it
with mutex lock.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/md/dm-cache-metadata.c |  2 +-
 fs/super.c                     |  2 +-
 mm/shrinker.c                  | 16 ++++++++--------
 mm/shrinker_debug.c            | 14 +++++++-------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index acffed750e3e..9e0c69958587 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1828,7 +1828,7 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
 	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
 	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
-	 * - must take shrinker_rwsem without holding cmd->root_lock
+	 * - must take shrinker_mutex without holding cmd->root_lock
 	 */
 	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 CACHE_MAX_CONCURRENT_LOCKS);
diff --git a/fs/super.c b/fs/super.c
index 04643fd80886..602cf54eb7da 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -54,7 +54,7 @@ static char *sb_writers_name[SB_FREEZE_LEVELS] = {
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
- * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
+ * shrinker path and that leads to deadlock on the shrinker_mutex. Hence we
  * take a passive reference to the superblock to avoid this from occurring.
  */
 static unsigned long super_cache_scan(struct shrinker *shrink,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 90c045620fe3..5c4546d2c234 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -7,7 +7,7 @@
 #include <trace/events/vmscan.h>
 
 LIST_HEAD(shrinker_list);
-DECLARE_RWSEM(shrinker_rwsem);
+DEFINE_MUTEX(shrinker_mutex);
 DEFINE_SPINLOCK(shrinker_lock);
 
 #ifdef CONFIG_MEMCG
@@ -80,7 +80,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 	int nid, ret = 0;
 	int array_size = 0;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	array_size = shrinker_unit_size(shrinker_nr_max);
 	for_each_node(nid) {
 		info = kvzalloc_node(sizeof(*info) + array_size, GFP_KERNEL, nid);
@@ -91,7 +91,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 			goto err;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 
@@ -104,7 +104,7 @@ static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
 						     int nid)
 {
 	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 lockdep_is_held(&shrinker_rwsem));
+					 lockdep_is_held(&shrinker_mutex));
 }
 
 static struct shrinker_info *shrinker_info_rcu(struct mem_cgroup *memcg,
@@ -158,7 +158,7 @@ static int expand_shrinker_info(int new_id)
 	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 
 	if (!root_mem_cgroup)
 		goto out;
@@ -179,7 +179,7 @@ static int expand_shrinker_info(int new_id)
 	if (!ret)
 		shrinker_nr_max = new_nr_max;
 
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 }
@@ -303,7 +303,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -316,7 +316,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			}
 		}
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 }
 #else
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index badda35464c3..44b620b1919d 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -8,7 +8,7 @@
 #include <linux/rculist.h>
 
 /* defined in vmscan.c */
-extern struct rw_semaphore shrinker_rwsem;
+extern struct mutex shrinker_mutex;
 extern struct list_head shrinker_list;
 
 static DEFINE_IDA(shrinker_debugfs_ida);
@@ -168,7 +168,7 @@ int shrinker_debugfs_add(struct shrinker *shrinker)
 	if (!shrinker_debugfs_root)
 		return 0;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	if (shrinker->debugfs_entry)
 		goto fail;
 
@@ -196,7 +196,7 @@ int shrinker_debugfs_add(struct shrinker *shrinker)
 			    &shrinker_debugfs_scan_fops);
 
 fail:
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 	return ret;
 }
 
@@ -215,7 +215,7 @@ int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 	if (!new)
 		return -ENOMEM;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 
 	old = shrinker->name;
 	shrinker->name = new;
@@ -233,7 +233,7 @@ int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 			shrinker->debugfs_entry = entry;
 	}
 
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	kfree_const(old);
 
@@ -246,7 +246,7 @@ struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
 {
 	struct dentry *entry = shrinker->debugfs_entry;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
 
@@ -257,7 +257,7 @@ struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
 	 */
 	smp_wmb();
 	shrinker->debugfs_entry = NULL;
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return entry;
 }
-- 
2.30.2


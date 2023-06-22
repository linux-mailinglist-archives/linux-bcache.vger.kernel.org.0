Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CFE739C02
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 11:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbjFVJGQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 05:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjFVJFJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 05:05:09 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CE12708
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:58:25 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-51f64817809so680242a12.1
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 01:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687424268; x=1690016268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+P5gj8bno5Yz104PoCsSeC7OSXGzrjC+L9aN78tCOOI=;
        b=jvhIGmYE039/syWqcfLyIdo6t9Qplyt6OsSxUBVvxtsPAkw48Ft91VW4Wz2O26wmhx
         R0vxBU2Gya4gcRkfUKW9xk7qtBQ/FB/itjiP7zdM6kYiVPyrZbA9p3LfIx3f71WW1xO7
         LLQ+0DljNwUv19wViW0KnJsUJ8+fuKrQN9IBdM3/tIdgoFSPmAiPoFKu75bet98dvkR/
         1RKnODQtDxONo/sndY6eLEsUvIJFr3WP9l67MNEVgdfQojcwBUWJp7hhTFie6SRhHC3h
         g1EMHwWUjxMnky7BCMGJqXeVS7+DBkpxiGCDfvbg7pDqaD88DLgjwvpVG1NnvXM5z1NX
         rt6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687424268; x=1690016268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+P5gj8bno5Yz104PoCsSeC7OSXGzrjC+L9aN78tCOOI=;
        b=YVLwptpIj4GsGb2EW1GpG+y9DjaBmorHvp9Qt8sqhyPF3R44HWrhSABZah4X1msIFn
         4XkbBE+hrfKxTT8Fhg+JJhA2Li47BXvaWrFfF9bR04UYvLtzVAi7sKa3rGu1UPTtRQAC
         5N05Ol/Z2smIArwaWMlfrf7tp4/vDyvlVTdqocSYGeQ1L+vRSBg7Q0wQKBVI6OZnkmQy
         HHYTqll7mM/Un/jbGJOI4qjRZQdMJ6s6pVl/LDIIzKUB/yKJAnHDR9pbkBIxqRdk9Wef
         EG3imNuKegXIFhuUllyyLDJR/7tIrtB4mbmEu9nykTSBEQIqQ7q1iw8ExYCZeFL6mJ7S
         6NZg==
X-Gm-Message-State: AC+VfDzs+Iy3k04P9bvyrovKBRDVkpBHeINvZuYeuloiq/a9aj5DIfK+
        hvvxIRtbtvVwJ6O34ektgRMIyw==
X-Google-Smtp-Source: ACHHUZ57rUw3vY36SztXPXN7lhzSsB9eXMClAkEXukaFLir2ldlvIHkHUZcbPwVIoKn5tOhLnnwBWg==
X-Received: by 2002:a17:902:ecc6:b0:1ae:1364:6086 with SMTP id a6-20020a170902ecc600b001ae13646086mr21606033plh.2.1687424268179;
        Thu, 22 Jun 2023 01:57:48 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:57:47 -0700 (PDT)
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
Subject: [PATCH 28/29] mm: shrinkers: convert shrinker_rwsem to mutex
Date:   Thu, 22 Jun 2023 16:53:34 +0800
Message-Id: <20230622085335.77010-29-zhengqi.arch@bytedance.com>
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

Now there are no readers of shrinker_rwsem, so we
can simply replace it with mutex lock.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 drivers/md/dm-cache-metadata.c |  2 +-
 drivers/md/dm-thin-metadata.c  |  2 +-
 fs/super.c                     |  2 +-
 mm/shrinker_debug.c            | 14 +++++++-------
 mm/vmscan.c                    | 34 +++++++++++++++++-----------------
 5 files changed, 27 insertions(+), 27 deletions(-)

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
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index fd464fb024c3..9f5cb52c5763 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1887,7 +1887,7 @@ int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
 	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
 	 * pmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
 	 * shrinker associated with the block manager's bufio client vs pmd root_lock).
-	 * - must take shrinker_rwsem without holding pmd->root_lock
+	 * - must take shrinker_mutex without holding pmd->root_lock
 	 */
 	new_bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 THIN_MAX_CONCURRENT_LOCKS);
diff --git a/fs/super.c b/fs/super.c
index 791342bb8ac9..471800ff793a 100644
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
diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index c18fa9b6b7f0..7ad903f84463 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -7,7 +7,7 @@
 #include <linux/memcontrol.h>
 
 /* defined in vmscan.c */
-extern struct rw_semaphore shrinker_rwsem;
+extern struct mutex shrinker_mutex;
 extern struct list_head shrinker_list;
 
 static DEFINE_IDA(shrinker_debugfs_ida);
@@ -177,7 +177,7 @@ int shrinker_debugfs_add(struct shrinker *shrinker)
 	char buf[128];
 	int id;
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	/* debugfs isn't initialized yet, add debugfs entries later. */
 	if (!shrinker_debugfs_root)
@@ -220,7 +220,7 @@ int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 	if (!new)
 		return -ENOMEM;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 
 	old = shrinker->name;
 	shrinker->name = new;
@@ -238,7 +238,7 @@ int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 			shrinker->debugfs_entry = entry;
 	}
 
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	kfree_const(old);
 
@@ -251,7 +251,7 @@ struct dentry *shrinker_debugfs_detach(struct shrinker *shrinker,
 {
 	struct dentry *entry = shrinker->debugfs_entry;
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
@@ -280,14 +280,14 @@ static int __init shrinker_debugfs_init(void)
 	shrinker_debugfs_root = dentry;
 
 	/* Create debugfs entries for shrinkers registered at boot */
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	list_for_each_entry(shrinker, &shrinker_list, list)
 		if (!shrinker->debugfs_entry) {
 			ret = shrinker_debugfs_add(shrinker);
 			if (ret)
 				break;
 		}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0711b63e68d9..bcdd97caa403 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -35,7 +35,7 @@
 #include <linux/cpuset.h>
 #include <linux/compaction.h>
 #include <linux/notifier.h>
-#include <linux/rwsem.h>
+#include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -190,7 +190,7 @@ struct scan_control {
 int vm_swappiness = 60;
 
 LIST_HEAD(shrinker_list);
-DECLARE_RWSEM(shrinker_rwsem);
+DEFINE_MUTEX(shrinker_mutex);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
@@ -210,7 +210,7 @@ static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
 						     int nid)
 {
 	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
-					 lockdep_is_held(&shrinker_rwsem));
+					 lockdep_is_held(&shrinker_mutex));
 }
 
 static struct shrinker_info *shrinker_info_rcu(struct mem_cgroup *memcg,
@@ -283,7 +283,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 	int nid, size, ret = 0;
 	int map_size, defer_size = 0;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	map_size = shrinker_map_size(shrinker_nr_max);
 	defer_size = shrinker_defer_size(shrinker_nr_max);
 	size = map_size + defer_size;
@@ -299,7 +299,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 		info->map_nr_max = shrinker_nr_max;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 }
@@ -315,7 +315,7 @@ static int expand_shrinker_info(int new_id)
 	if (!root_mem_cgroup)
 		goto out;
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	map_size = shrinker_map_size(new_nr_max);
 	defer_size = shrinker_defer_size(new_nr_max);
@@ -364,7 +364,7 @@ static int prealloc_memcg_shrinker(struct shrinker *shrinker)
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
@@ -378,7 +378,7 @@ static int prealloc_memcg_shrinker(struct shrinker *shrinker)
 	shrinker->id = id;
 	ret = 0;
 unlock:
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 	return ret;
 }
 
@@ -388,7 +388,7 @@ static void unregister_memcg_shrinker(struct shrinker *shrinker)
 
 	BUG_ON(id < 0);
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	idr_remove(&shrinker_idr, id);
 }
@@ -433,7 +433,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -442,7 +442,7 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 			atomic_long_add(nr, &parent_info->nr_deferred[i]);
 		}
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 }
 
 static bool cgroup_reclaim(struct scan_control *sc)
@@ -743,9 +743,9 @@ void free_prealloced_shrinker(struct shrinker *shrinker)
 	shrinker->name = NULL;
 #endif
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
-		down_write(&shrinker_rwsem);
+		mutex_lock(&shrinker_mutex);
 		unregister_memcg_shrinker(shrinker);
-		up_write(&shrinker_rwsem);
+		mutex_unlock(&shrinker_mutex);
 		return;
 	}
 
@@ -755,13 +755,13 @@ void free_prealloced_shrinker(struct shrinker *shrinker)
 
 void register_shrinker_prepared(struct shrinker *shrinker)
 {
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	refcount_set(&shrinker->refcount, 1);
 	init_completion(&shrinker->completion_wait);
 	list_add_tail_rcu(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
 	shrinker_debugfs_add(shrinker);
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 }
 
 static int __register_shrinker(struct shrinker *shrinker)
@@ -815,13 +815,13 @@ void unregister_shrinker(struct shrinker *shrinker)
 	shrinker_put(shrinker);
 	wait_for_completion(&shrinker->completion_wait);
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	list_del_rcu(&shrinker->list);
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
 	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
 
-- 
2.30.2


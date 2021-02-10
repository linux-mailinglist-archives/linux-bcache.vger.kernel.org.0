Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB8D315EC2
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhBJFJo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:09:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:40828 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhBJFJd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 79D38B0B6;
        Wed, 10 Feb 2021 05:08:26 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 13/20] bcache: persist owner info when alloc/free pages.
Date:   Wed, 10 Feb 2021 13:07:35 +0800
Message-Id: <20210210050742.31237-14-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implement persist owner info on nvdimm device
when alloc/free pages.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c | 93 ++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 2b079a277e88..c350dcd696dd 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -210,6 +210,19 @@ static struct bch_nvm_namespace *find_nvm_by_addr(void *addr, int order)
 	return NULL;
 }
 
+static void init_pgalloc_recs(struct bch_nvm_pgalloc_recs *recs, const char *owner_uuid)
+{
+	memset(recs, 0, sizeof(struct bch_nvm_pgalloc_recs));
+	memcpy(recs->magic, bch_nvm_pages_pgalloc_magic, 16);
+	memcpy(recs->owner_uuid, owner_uuid, 16);
+	recs->size = BCH_MAX_RECS;
+}
+
+static pgoff_t vaddr_to_nvm_pgoff(struct bch_nvm_namespace *ns, void *kaddr)
+{
+	return (kaddr - ns->kaddr) / PAGE_SIZE;
+}
+
 static int remove_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr, int order)
 {
 	struct list_head *list = alloced_recs->extent_head.next;
@@ -234,6 +247,82 @@ static int remove_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr,
 	return (list == &alloced_recs->extent_head) ? -ENOENT : 0;
 }
 
+#define BCH_RECS_LEN (sizeof(struct bch_nvm_pgalloc_recs))
+
+static void write_owner_info(void)
+{
+	struct bch_owner_list *owner_list;
+	struct bch_nvm_pgalloc_recs *recs;
+	struct bch_nvm_namespace *ns = only_set->nss[0];
+	struct bch_owner_list_head *owner_list_head;
+	struct bch_nvm_pages_owner_head *owner_head;
+	u64 recs_pos = BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
+	struct list_head *list;
+	int i, j;
+
+	owner_list_head = kzalloc(sizeof(*owner_list_head), GFP_KERNEL);
+	recs = kmalloc(sizeof(*recs), GFP_KERNEL);
+	if (!owner_list_head || !recs) {
+		pr_info("can't alloc memory\n");
+		goto free_resouce;
+	}
+
+	owner_list_head->size = BCH_MAX_OWNER_LIST;
+	WARN_ON(only_set->owner_list_used > owner_list_head->size);
+
+	// in-memory owner maybe not contain alloced-pages.
+	for (i = 0; i < only_set->owner_list_used; i++) {
+		owner_head = &owner_list_head->heads[i];
+		owner_list = only_set->owner_lists[i];
+
+		memcpy(owner_head->uuid, owner_list->owner_uuid, 16);
+
+		for (j = 0; j < only_set->total_namespaces_nr; j++) {
+			struct bch_nvm_alloced_recs *extents = owner_list->alloced_recs[j];
+
+			if (!extents || !extents->nr)
+				continue;
+
+			init_pgalloc_recs(recs, owner_list->owner_uuid);
+
+			BUG_ON(recs_pos >= BCH_NVM_PAGES_OFFSET);
+			owner_head->recs[j] = (struct bch_nvm_pgalloc_recs *)(uintptr_t)recs_pos;
+
+			for (list = extents->extent_head.next;
+				list != &extents->extent_head;
+				list = list->next) {
+				struct bch_extent *extent;
+
+				extent = container_of(list, struct bch_extent, list);
+
+				if (recs->used == recs->size) {
+					BUG_ON(recs_pos >= BCH_NVM_PAGES_OFFSET);
+					recs->next = (struct bch_nvm_pgalloc_recs *)
+							(uintptr_t)(recs_pos + BCH_RECS_LEN);
+					memcpy_flushcache(ns->kaddr + recs_pos, recs, BCH_RECS_LEN);
+					init_pgalloc_recs(recs, owner_list->owner_uuid);
+					recs_pos += BCH_RECS_LEN;
+				}
+
+				recs->recs[recs->used].pgoff =
+					vaddr_to_nvm_pgoff(only_set->nss[j], extent->kaddr);
+				recs->recs[recs->used].nr = extent->nr;
+				recs->used++;
+			}
+
+			memcpy_flushcache(ns->kaddr + recs_pos, recs, BCH_RECS_LEN);
+			recs_pos += sizeof(struct bch_nvm_pgalloc_recs);
+		}
+	}
+
+	owner_list_head->used = only_set->owner_list_used;
+	memcpy_flushcache(ns->kaddr + BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET,
+			 (void *)owner_list_head, sizeof(struct bch_owner_list_head));
+free_resouce:
+	kfree(owner_list_head);
+	kfree(recs);
+}
+
 static void __free_space(struct bch_nvm_namespace *ns, void *addr, int order)
 {
 	unsigned int add_pages = (1 << order);
@@ -309,6 +398,7 @@ void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid)
 	}
 
 	__free_space(ns, addr, order);
+	write_owner_info();
 
 unlock:
 	mutex_unlock(&only_set->lock);
@@ -368,7 +458,8 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 			break;
 		}
 	}
-
+	if (kaddr)
+		write_owner_info();
 	mutex_unlock(&only_set->lock);
 	return kaddr;
 }
-- 
2.26.2


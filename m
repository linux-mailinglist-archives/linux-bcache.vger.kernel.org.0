Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F1F312AE4
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Feb 2021 07:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhBHGqb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Feb 2021 01:46:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:44130 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhBHGqb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Feb 2021 01:46:31 -0500
IronPort-SDR: 0QxBAEYSt+U+S4OLbP53KAmXlk6BRyJCU+8/hFFGnVVniQxpZ6FjVEs/xtuOEq4sCqzebyuZ0X
 A1nxz1MHPFRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="245738717"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="245738717"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 22:45:26 -0800
IronPort-SDR: D4YxQGqLcpgq+mXwsKLh3kM9b3CLEEJuZw6MwPL4O7+YbFsn3zsMzZt+jjZ+wzcwPMfWmjcRPA
 HtFuO+Fi201A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="418127600"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2021 22:45:25 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v6 7/7] bcache: persist owner info when alloc/free pages.
Date:   Mon,  8 Feb 2021 09:26:21 -0500
Message-Id: <20210208142621.76815-8-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208142621.76815-1-qiaowei.ren@intel.com>
References: <20210208142621.76815-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implement persist owner info on nvdimm device
when alloc/free pages.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
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
2.17.1


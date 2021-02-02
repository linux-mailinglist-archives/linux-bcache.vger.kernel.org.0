Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FC30B56D
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Feb 2021 03:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBBCoS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Feb 2021 21:44:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:47749 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231433AbhBBCoR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Feb 2021 21:44:17 -0500
IronPort-SDR: 4Y6rcxpA4+UUCMKBxwqUAc81Z8dIukSi+xnyfqroMFKncPqih3jWctYSfW4tkCe68bmwMmby0p
 c7Y2p3UTPjzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167893407"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="167893407"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:43:06 -0800
IronPort-SDR: WZq8muBmKsTzRvgbenjOXC9oqYKDPG1ygytdPnL3eMlW1fsctRITB6wzarZdWVe7nEpnlc1UMJ
 D9PAzYNpNr8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="370226440"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2021 18:43:05 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v5 7/8] bcache: persist owner info when alloc/free pages.
Date:   Tue,  2 Feb 2021 05:23:51 -0500
Message-Id: <20210202102352.4833-8-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202102352.4833-1-qiaowei.ren@intel.com>
References: <20210202102352.4833-1-qiaowei.ren@intel.com>
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
index ce4eb9107ec3..c1cc4af25d6d 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -245,6 +245,18 @@ static struct bch_nvm_namespace *find_nvm_by_addr(void *addr, int order)
 	return NULL;
 }
 
+static void init_pgalloc_recs(struct bch_nvm_pgalloc_recs *recs, const char *owner_uuid)
+{
+	memset(recs, 0, sizeof(struct bch_nvm_pgalloc_recs));
+	memcpy(recs->magic, bch_nvm_pages_pgalloc_magic, 16);
+	memcpy(recs->owner_uuid, owner_uuid, 16);
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
@@ -287,6 +299,83 @@ static int remove_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr,
 	return (list == &alloced_recs->extent_head) ? -ENOENT : 0;
 }
 
+#define BCH_RECS_LEN (sizeof(struct bch_nvm_pgalloc_recs))
+
+static void write_owner_info(void)
+{
+	struct bch_owner_list *owner_list;
+	struct bch_nvm_pgalloc_recs *recs;
+	struct bch_extent *extent;
+	struct bch_nvm_namespace *ns = only_set->nss[0];
+	struct bch_owner_list_head *owner_list_head;
+	struct bch_nvm_pages_owner_head *owner_head;
+	bool update_owner = false;
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
+	// in-memory owner maybe not contain alloced-pages.
+	for (i = 0; i < only_set->owner_list_used; i++) {
+		owner_head = &owner_list_head->heads[owner_list_head->size];
+		owner_list = only_set->owner_lists[i];
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
+				extent = container_of(list, struct bch_extent, list);
+
+				if (recs->size == BCH_MAX_RECS) {
+					BUG_ON(recs_pos >= BCH_NVM_PAGES_OFFSET);
+					recs->next = (struct bch_nvm_pgalloc_recs *)
+							(uintptr_t)(recs_pos + BCH_RECS_LEN);
+					memcpy_flushcache(ns->kaddr + recs_pos, recs, BCH_RECS_LEN);
+					init_pgalloc_recs(recs, owner_list->owner_uuid);
+					recs_pos += BCH_RECS_LEN;
+				}
+
+				recs->recs[recs->size].pgoff =
+					vaddr_to_nvm_pgoff(only_set->nss[j], extent->kaddr);
+				recs->recs[recs->size].nr = extent->nr;
+				recs->size++;
+			}
+
+			update_owner = true;
+			memcpy_flushcache(ns->kaddr + recs_pos, recs, BCH_RECS_LEN);
+			recs_pos += sizeof(struct bch_nvm_pgalloc_recs);
+		}
+
+		if (update_owner) {
+			memcpy(owner_head->uuid, owner_list->owner_uuid, 16);
+			owner_list_head->size++;
+			update_owner = false;
+		}
+	}
+
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
@@ -362,6 +451,7 @@ void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid)
 	}
 
 	__free_space(ns, addr, order);
+	write_owner_info();
 
 unlock:
 	mutex_unlock(&only_set->lock);
@@ -420,7 +510,8 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
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


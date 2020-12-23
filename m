Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB0B2E193E
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgLWHFS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:05:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:26566 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727093AbgLWHFS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:05:18 -0500
IronPort-SDR: kK0pV0hfgubssv9sdRCfmGvouFoXrmWsV/oe5vUKrOI1XtTk1ubjTDDv89GDATj+lHb0vH0UMd
 z043h7LQNSPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="173405202"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="173405202"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:03:45 -0800
IronPort-SDR: ddTutq5e+OYqhjgpv6yBX0asgGCtKcr9NG6Cv8sEefOp9yWLCr1s9yRvsuu2Ok2dkbeTBezhg2
 SDlJwmVulLYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="565083543"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2020 23:03:44 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH v2 7/8] bcache: persist owner info when alloc/free pages.
Date:   Wed, 23 Dec 2020 09:45:01 -0500
Message-Id: <20201223144502.25029-8-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144502.25029-1-qiaowei.ren@intel.com>
References: <20201223144502.25029-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implement persist owner info on nvdimm device
when alloc/free pages.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 92 ++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index ff810110ee90..69b559a4c0b2 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -206,6 +206,17 @@ static struct bch_nvm_namespace *find_nvm_by_addr(void *addr, int order)
 	return NULL;
 }
 
+static void init_pgalloc_recs(struct nvm_pgalloc_recs *recs, const char *owner_uuid)
+{
+	memset(recs, 0, sizeof(struct nvm_pgalloc_recs));
+	memcpy(recs->owner_uuid, owner_uuid, 16);
+}
+
+static pgoff_t vaddr_to_nvm_pgoff(struct bch_nvm_namespace *ns, void *kaddr)
+{
+	return (kaddr - ns->kaddr - ns->pages_offset) / PAGE_SIZE;
+}
+
 static int remove_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr, int order)
 {
 	struct list_head *list = alloced_recs->extent_head.next;
@@ -245,6 +256,83 @@ static int remove_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr,
 	return (list == &alloced_recs->extent_head) ? -ENOENT : 0;
 }
 
+#define RECS_LEN (sizeof(struct nvm_pgalloc_recs))
+
+static void write_owner_info(void)
+{
+	struct bch_owner_list *owner_list;
+	struct nvm_pgalloc_recs *recs;
+	struct bch_extent *extent;
+	struct bch_nvm_namespace *ns = only_set->nss[0];
+	struct owner_list_head *owner_list_head;
+	struct nvm_pages_owner_head *owner_head;
+	bool update_owner = false;
+	u64 recs_pos = NVM_PAGES_SYS_RECS_HEAD_OFFSET;
+	struct list_head *list;
+	int i, j;
+
+	owner_list_head = kzalloc(sizeof(*owner_list_head), GFP_KERNEL);
+	recs = kmalloc(sizeof(*recs), GFP_KERNEL);
+	if (!owner_list_head || !recs) {
+		pr_info("can't alloc memory\n");
+		kfree(owner_list_head);
+		kfree(recs);
+		return;
+	}
+
+	// in-memory owner maybe not contain alloced-pages.
+	for (i = 0; i < only_set->owner_list_size; i++) {
+		owner_head = &owner_list_head->heads[owner_list_head->size];
+		owner_list = only_set->owner_lists[i];
+
+		for (j = 0; j < only_set->total_namespaces_nr; j++) {
+			struct bch_nvm_alloced_recs *extents = owner_list->alloced_recs[j];
+
+			if (!extents || !extents->size)
+				continue;
+
+			init_pgalloc_recs(recs, owner_list->owner_uuid);
+
+			BUG_ON(recs_pos >= NVM_PAGES_OFFSET);
+			owner_head->recs[j] = (struct nvm_pgalloc_recs *)recs_pos;
+
+			for (list = extents->extent_head.next;
+				list != &extents->extent_head;
+				list = list->next) {
+				extent = container_of(list, struct bch_extent, list);
+
+				if (recs->size == MAX_RECORD) {
+					BUG_ON(recs_pos >= NVM_PAGES_OFFSET);
+					recs->next =
+						(struct nvm_pgalloc_recs *)(recs_pos + RECS_LEN);
+					memcpy_flushcache(ns->kaddr + recs_pos, recs, RECS_LEN);
+					init_pgalloc_recs(recs, owner_list->owner_uuid);
+					recs_pos += RECS_LEN;
+				}
+
+				recs->recs[recs->size].pgoff =
+					vaddr_to_nvm_pgoff(only_set->nss[j], extent->kaddr);
+				recs->recs[recs->size].nr = extent->nr;
+				recs->size++;
+			}
+
+			update_owner = true;
+			memcpy_flushcache(ns->kaddr + recs_pos, recs, RECS_LEN);
+			recs_pos += sizeof(struct nvm_pgalloc_recs);
+		}
+
+		if (update_owner) {
+			memcpy(owner_head->uuid, owner_list->owner_uuid, 16);
+			owner_list_head->size++;
+			update_owner = false;
+		}
+	}
+
+	memcpy_flushcache(ns->kaddr + NVM_PAGES_OWNER_LIST_HEAD_OFFSET,
+			 (void *)owner_list_head, sizeof(struct owner_list_head));
+	kfree(owner_list_head);
+}
+
 static void __free_space(struct bch_nvm_namespace *ns, void *addr, int order)
 {
 	unsigned int add_pages = (1 << order);
@@ -318,6 +406,7 @@ void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid)
 	}
 
 	__free_space(ns, addr, order);
+	write_owner_info();
 
 unlock:
 	mutex_unlock(&only_set->lock);
@@ -376,7 +465,8 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
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


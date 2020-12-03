Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFD72CCD16
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 04:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgLCDLa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 22:11:30 -0500
Received: from mga07.intel.com ([134.134.136.100]:1945 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbgLCDL3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 22:11:29 -0500
IronPort-SDR: 4vvCXD9EfQ8CuIza4fkzCGpH6tSIDJQX5fjNThWJfyZrTzmnGHsNylC/NBbynMXcWRNuufaiMJ
 8/4EHBazrgdA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="237248556"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="237248556"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 19:10:25 -0800
IronPort-SDR: y4nsht2O7R5p3lVhEN8OwJ5u/bG8kBlRYtFD1y899sy0nLw9nIf3qIqtCeWIeW47HBwZeu8Bz6
 OxhXdfOkPrAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="481801560"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2020 19:10:24 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Subject: [RFC PATCH 7/8] bcache: persist owner info when alloc/free pages.
Date:   Thu,  3 Dec 2020 05:53:36 -0500
Message-Id: <20201203105337.4592-8-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203105337.4592-1-qiaowei.ren@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implement persist owner info on nvdimm device
when alloc/free pages.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 86 +++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index e8765b0b3398..ba1ff0582b20 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -197,6 +197,17 @@ static struct nvm_namespace *find_nvm_by_addr(void *addr, int order)
 	return NULL;
 }
 
+static void init_pgalloc_recs(struct nvm_pgalloc_recs *recs, const char *owner_uuid)
+{
+	memset(recs, 0, sizeof(struct nvm_pgalloc_recs));
+	memcpy(recs->owner_uuid, owner_uuid, 16);
+}
+
+static pgoff_t vaddr_to_nvm_pgoff(struct nvm_namespace *ns, void *kaddr)
+{
+	return (kaddr - ns->kaddr - ns->pages_offset) / PAGE_SIZE;
+}
+
 static int remove_extent(struct nvm_alloced_recs *alloced_recs, void *addr, int order)
 {
 	struct list_head *list = alloced_recs->extent_head.next;
@@ -275,6 +286,77 @@ static void __free_space(struct nvm_namespace *ns, void *addr, int order)
 	ns->free += add_pages;
 }
 
+#define RECS_LEN (sizeof(struct nvm_pgalloc_recs))
+
+static void write_owner_info(void)
+{
+	struct owner_list *owner_list;
+	struct nvm_pages_owner_head *owner_head;
+	struct nvm_pgalloc_recs *recs;
+	struct extent *extent;
+	struct nvm_namespace *ns = only_set->nss[0];
+	struct owner_list_head *owner_list_head;
+	bool update_owner = false;
+	u64 recs_pos = NVM_PAGES_SYS_RECS_HEAD_OFFSET;
+	struct list_head *list;
+	int i, j;
+
+	owner_list_head = kzalloc(sizeof(struct owner_list_head), GFP_KERNEL);
+	recs = kmalloc(RECS_LEN, GFP_KERNEL);
+
+	// in-memory owner maybe not contain alloced-pages.
+	for (i = 0; i < only_set->owner_list_size; i++) {
+		owner_head = &owner_list_head->heads[owner_list_head->size];
+		owner_list = only_set->owner_lists[i];
+
+		for (j = 0; j < only_set->total_namespaces_nr; j++) {
+			struct nvm_alloced_recs *extents = owner_list->alloced_recs[j];
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
+				extent = container_of(list, struct extent, list);
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
+				(void *)owner_list_head, sizeof(struct owner_list_head));
+	kfree(owner_list_head);
+}
+
 void nvm_free_pages(void *addr, int order, const char *owner_uuid)
 {
 	struct nvm_namespace *ns;
@@ -309,6 +391,7 @@ void nvm_free_pages(void *addr, int order, const char *owner_uuid)
 	}
 
 	__free_space(ns, addr, order);
+	write_owner_info();
 
 unlock:
 	mutex_unlock(&only_set->lock);
@@ -368,7 +451,10 @@ void *nvm_alloc_pages(int order, const char *owner_uuid)
 		}
 	}
 
+	if (kaddr)
+		write_owner_info();
 	mutex_unlock(&only_set->lock);
+
 	return kaddr;
 }
 EXPORT_SYMBOL_GPL(nvm_alloc_pages);
-- 
2.17.1


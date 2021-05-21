Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8238C099
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 09:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhEUHV1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 03:21:27 -0400
Received: from mga04.intel.com ([192.55.52.120]:16559 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhEUHV1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 03:21:27 -0400
IronPort-SDR: R+EmLEMDRDNll/ptYo3pS7e3GFeX07QRrs6Ue4nz9vVnx4/TQOeuD46zNlan58Kp4Iy29gWGLR
 PMOCXkqBV4mQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="199484334"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="199484334"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 00:20:04 -0700
IronPort-SDR: OqEX+GTEYfCywMGgyQ8E4LL2fR4icFaBwbKOQbVlrs2xgMv7S0PU4X+z0zevBfIqc3czf/aGfC
 Htu84LHjqLlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440817160"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2021 00:20:03 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     linux-bcache@vger.kernel.org
Cc:     qiaowei.ren@intel.com, jianpeng.ma@intel.com, colyli@suse.de,
        rdunlap@infradead.oom
Subject: [bch-nvm-pages v10 4/6] cache: bch_nvm_alloc_pages() of the buddy
Date:   Fri, 21 May 2021 10:57:24 -0400
Message-Id: <20210521145726.154276-5-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521145726.154276-1-qiaowei.ren@intel.com>
References: <20210521145726.154276-1-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements the bch_nvm_alloc_pages() of the buddy.
In terms of function, this func is like current-page-buddy-alloc.
But the differences are:
a: it need owner_uuid as parameter which record owner info. And it
make those info persistence.
b: it don't need flags like GFP_*. All allocs are the equal.
c: it don't trigger other ops etc swap/recycle.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c   | 174 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |   6 ++
 include/uapi/linux/bcache-nvm.h |   6 +-
 3 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 58c28b0779dd..5b767fc7e952 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -72,6 +72,180 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
 	}
 }
 
+/* If not found, it will create if create == true */
+static struct bch_nvm_pages_owner_head *find_owner_head(const char *owner_uuid, bool create)
+{
+	struct bch_owner_list_head *owner_list_head = only_set->owner_list_head;
+	struct bch_nvm_pages_owner_head *owner_head = NULL;
+	int i;
+
+	if (owner_list_head == NULL)
+		goto out;
+
+	for (i = 0; i < only_set->owner_list_used; i++) {
+		if (!memcmp(owner_uuid, owner_list_head->heads[i].uuid, 16)) {
+			owner_head = &(owner_list_head->heads[i]);
+			break;
+		}
+	}
+
+	if (!owner_head && create) {
+		u32 used = only_set->owner_list_used;
+
+		if (only_set->owner_list_size > used) {
+			memcpy_flushcache(owner_list_head->heads[used].uuid, owner_uuid, 16);
+			only_set->owner_list_used++;
+
+			owner_list_head->used++;
+			owner_head = &(owner_list_head->heads[used]);
+		} else
+			pr_info("no free bch_nvm_pages_owner_head\n");
+	}
+
+out:
+	return owner_head;
+}
+
+static struct bch_nvm_pgalloc_recs *find_empty_pgalloc_recs(void)
+{
+	unsigned int start;
+	struct bch_nvm_namespace *ns = only_set->nss[0];
+	struct bch_nvm_pgalloc_recs *recs;
+
+	start = bitmap_find_next_zero_area(ns->pgalloc_recs_bitmap, BCH_MAX_PGALLOC_RECS, 0, 1, 0);
+	if (start > BCH_MAX_PGALLOC_RECS) {
+		pr_info("no free struct bch_nvm_pgalloc_recs\n");
+		return NULL;
+	}
+
+	bitmap_set(ns->pgalloc_recs_bitmap, start, 1);
+	recs = (struct bch_nvm_pgalloc_recs *)(ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET)
+		+ start;
+	return recs;
+}
+
+static struct bch_nvm_pgalloc_recs *find_nvm_pgalloc_recs(struct bch_nvm_namespace *ns,
+		struct bch_nvm_pages_owner_head *owner_head, bool create)
+{
+	int ns_nr = ns->sb->this_namespace_nr;
+	struct bch_nvm_pgalloc_recs *prev_recs = NULL, *recs = owner_head->recs[ns_nr];
+
+	/* If create=false, we return recs[nr] */
+	if (!create)
+		return recs;
+
+	/*
+	 * If create=true, it mean we need a empty struct bch_pgalloc_rec
+	 * So we should find non-empty struct bch_nvm_pgalloc_recs or alloc
+	 * new struct bch_nvm_pgalloc_recs. And return this bch_nvm_pgalloc_recs
+	 */
+	while (recs && (recs->used == recs->size)) {
+		prev_recs = recs;
+		recs = recs->next;
+	}
+
+	/* Found empty struct bch_nvm_pgalloc_recs */
+	if (recs)
+		return recs;
+	/* Need alloc new struct bch_nvm_galloc_recs */
+	recs = find_empty_pgalloc_recs();
+	if (recs) {
+		recs->next = NULL;
+		recs->owner = owner_head;
+		memcpy_flushcache(recs->magic, bch_nvm_pages_pgalloc_magic, 16);
+		memcpy_flushcache(recs->owner_uuid, owner_head->uuid, 16);
+		recs->size = BCH_MAX_RECS;
+		recs->used = 0;
+
+		if (prev_recs)
+			prev_recs->next = recs;
+		else
+			owner_head->recs[ns_nr] = recs;
+	}
+
+	return recs;
+}
+
+static void add_pgalloc_rec(struct bch_nvm_pgalloc_recs *recs, void *kaddr, int order)
+{
+	int i;
+
+	for (i = 0; i < recs->size; i++) {
+		if (recs->recs[i].pgoff == 0) {
+			recs->recs[i].pgoff = (unsigned long)kaddr >> PAGE_SHIFT;
+			recs->recs[i].order = order;
+			recs->used++;
+			break;
+		}
+	}
+	BUG_ON(i == recs->size);
+}
+
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	void *kaddr = NULL;
+	struct bch_nvm_pgalloc_recs *pgalloc_recs;
+	struct bch_nvm_pages_owner_head *owner_head;
+	int i, j;
+
+	mutex_lock(&only_set->lock);
+	owner_head = find_owner_head(owner_uuid, true);
+
+	if (!owner_head) {
+		pr_err("can't find bch_nvm_pgalloc_recs by(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
+
+	for (j = 0; j < only_set->total_namespaces_nr; j++) {
+		struct bch_nvm_namespace *ns = only_set->nss[j];
+
+		if (!ns || (ns->free < (1L << order)))
+			continue;
+
+		for (i = order; i < BCH_MAX_ORDER; i++) {
+			struct list_head *list;
+			struct page *page, *buddy_page;
+
+			if (list_empty(&ns->free_area[i]))
+				continue;
+
+			list = ns->free_area[i].next;
+			page = container_of((void *)list, struct page, zone_device_data);
+
+			list_del(list);
+
+			while (i != order) {
+				buddy_page = nvm_vaddr_to_page(ns,
+					nvm_pgoff_to_vaddr(ns, page->index + (1L << (i - 1))));
+				set_page_private(buddy_page, i - 1);
+				buddy_page->index = page->index + (1L << (i - 1));
+				__SetPageBuddy(buddy_page);
+				list_add((struct list_head *)&buddy_page->zone_device_data,
+					&ns->free_area[i - 1]);
+				i--;
+			}
+
+			set_page_private(page, order);
+			__ClearPageBuddy(page);
+			ns->free -= 1L << order;
+			kaddr = nvm_pgoff_to_vaddr(ns, page->index);
+			break;
+		}
+
+		if (i < BCH_MAX_ORDER) {
+			pgalloc_recs = find_nvm_pgalloc_recs(ns, owner_head, true);
+			/* ToDo: handle pgalloc_recs==NULL */
+			add_pgalloc_rec(pgalloc_recs, kaddr, order);
+			break;
+		}
+	}
+
+unlock:
+	mutex_unlock(&only_set->lock);
+	return kaddr;
+}
+EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
+
 #define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
 
 static int init_owner_info(struct bch_nvm_namespace *ns)
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index e08864af96a0..4fd5205146a2 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -62,6 +62,7 @@ extern struct bch_nvm_set *only_set;
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 
 #else
 
@@ -74,6 +75,11 @@ static inline int bch_nvm_init(void)
 	return 0;
 }
 static inline void bch_nvm_exit(void) { }
+static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	return NULL;
+}
+
 
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
index dce013a90f37..d295e8130ef6 100644
--- a/include/uapi/linux/bcache-nvm.h
+++ b/include/uapi/linux/bcache-nvm.h
@@ -135,9 +135,11 @@ union {
 	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /			\
 	 sizeof(struct bch_pgalloc_rec))
 
+/* Currently 64 struct bch_nvm_pgalloc_recs is enough */
 #define BCH_MAX_PGALLOC_RECS						\
-	((BCH_NVM_PAGES_OFFSET - BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET) /	\
-	 sizeof(struct bch_nvm_pgalloc_recs))
+	(min_t(unsigned int, 64,					\
+		(BCH_NVM_PAGES_OFFSET - BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET) / \
+		 sizeof(struct bch_nvm_pgalloc_recs)))
 
 struct bch_nvm_pages_owner_head {
 	unsigned char			uuid[16];
-- 
2.25.1


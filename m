Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37C630B56A
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Feb 2021 03:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBBCoC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Feb 2021 21:44:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:47749 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhBBCoB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Feb 2021 21:44:01 -0500
IronPort-SDR: Fj/5bXBOOB1oNboXYvmbfVhhVefYS7/y/eS2Acal5QVm8k6vEkwEfcBdjJnzzJF90v1Vxe5SKD
 0QRw/XkUrFnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167893402"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="167893402"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:43:02 -0800
IronPort-SDR: 5gzJTZadwweQZY8Nn6sS/N2Kg9gXN/5x8DfqdiQYm91VX3DVZp9SJ5wDda0KfjQmQXreJ/R44i
 yAfge3c4ADVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="370226415"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2021 18:43:01 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v5 4/8] bcache: bch_nvm_alloc_pages() of the buddy
Date:   Tue,  2 Feb 2021 05:23:48 -0500
Message-Id: <20210202102352.4833-5-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202102352.4833-1-qiaowei.ren@intel.com>
References: <20210202102352.4833-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements the bch_nvm_alloc_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 155 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   6 ++
 2 files changed, 161 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 7da178fea603..cdf1594bfd0e 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -124,6 +124,161 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
 	bitmap_set(ns->pages_bitmap, pgoff, nr);
 }
 
+/* If not found, it will create if create == true */
+static struct bch_owner_list *find_owner_list(const char *owner_uuid, bool create)
+{
+	struct bch_owner_list *owner_list;
+	int i;
+
+	for (i = 0; i < only_set->owner_list_used; i++) {
+		if (!memcmp(owner_uuid, only_set->owner_lists[i]->owner_uuid, 16))
+			return only_set->owner_lists[i];
+	}
+
+	if (create) {
+		owner_list = alloc_owner_list(owner_uuid, NULL, only_set->total_namespaces_nr);
+		only_set->owner_lists[only_set->owner_list_used++] = owner_list;
+		return owner_list;
+	} else
+		return NULL;
+}
+
+static struct bch_nvm_alloced_recs *find_nvm_alloced_recs(struct bch_owner_list *owner_list,
+		struct bch_nvm_namespace *ns, bool create)
+{
+	int position = ns->sb.this_namespace_nr;
+
+	if (create && !owner_list->alloced_recs[position]) {
+		struct bch_nvm_alloced_recs *alloced_recs =
+			kzalloc(sizeof(*alloced_recs), GFP_KERNEL|__GFP_NOFAIL);
+
+		alloced_recs->ns = ns;
+		INIT_LIST_HEAD(&alloced_recs->extent_head);
+		owner_list->alloced_recs[position] = alloced_recs;
+		return alloced_recs;
+	} else
+		return owner_list->alloced_recs[position];
+}
+
+static inline void *extent_end_addr(struct bch_extent *extent)
+{
+	return extent->kaddr + ((u64)(extent->nr) << PAGE_SHIFT);
+}
+
+static void add_extent(struct bch_nvm_alloced_recs *alloced_recs, void *addr, int order)
+{
+	struct list_head *list = alloced_recs->extent_head.next;
+	struct bch_extent *extent, *tmp;
+	void *end_addr = addr + (((u64)1 << order) << PAGE_SHIFT);
+
+	while (list != &alloced_recs->extent_head) {
+		extent = container_of(list, struct bch_extent, list);
+		if (end_addr == extent->kaddr) {
+			extent->kaddr = addr;
+			extent->nr += 1 << order;
+
+			if (list->prev != &alloced_recs->extent_head) {
+				tmp = container_of(list->prev, struct bch_extent, list);
+				if (extent_end_addr(tmp) == addr) {
+					tmp->nr += extent->nr;
+					alloced_recs->nr--;
+					list_del(list);
+					kfree(extent);
+				}
+			}
+			break;
+		} else if (extent_end_addr(extent) == addr) {
+			extent->nr += 1 << order;
+
+			if (list->next != &alloced_recs->extent_head) {
+				tmp = container_of(list->next, struct bch_extent, list);
+				if (extent_end_addr(extent) == tmp->kaddr) {
+					extent->nr += tmp->nr;
+					alloced_recs->nr--;
+					list_del(list->next);
+					kfree(tmp);
+				}
+			}
+			break;
+		} else if (end_addr < extent->kaddr) {
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL|__GFP_NOFAIL);
+			tmp->kaddr = addr;
+			tmp->nr = 1 << order;
+			list_add_tail(&tmp->list, &extent->list);
+			alloced_recs->nr++;
+			break;
+		}
+		list = list->next;
+	}
+
+	if (list == &alloced_recs->extent_head) {
+		struct bch_extent *e = kzalloc(sizeof(*e), GFP_KERNEL);
+
+		e->kaddr = addr;
+		e->nr = 1 << order;
+		list_add(&e->list, &alloced_recs->extent_head);
+		alloced_recs->nr++;
+	}
+}
+
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	void *kaddr = NULL;
+	struct bch_owner_list *owner_list;
+	struct bch_nvm_alloced_recs *alloced_recs;
+	int i, j;
+
+	mutex_lock(&only_set->lock);
+	owner_list = find_owner_list(owner_uuid, true);
+
+	for (j = 0; j < only_set->total_namespaces_nr; j++) {
+		struct bch_nvm_namespace *ns = only_set->nss[j];
+
+		if (!ns || (ns->free < (1 << order)))
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
+					nvm_pgoff_to_vaddr(ns, page->index + (1 << (i - 1))));
+				set_page_private(buddy_page, i - 1);
+				buddy_page->index = page->index + (1 << (i - 1));
+				__SetPageBuddy(buddy_page);
+				list_add((struct list_head *)&buddy_page->zone_device_data,
+					&ns->free_area[i - 1]);
+				i--;
+			}
+
+			set_page_private(page, order);
+			__ClearPageBuddy(page);
+			ns->free -= 1 << order;
+			kaddr = nvm_pgoff_to_vaddr(ns, page->index);
+			break;
+		}
+
+		if (i != BCH_MAX_ORDER) {
+			alloced_recs = find_nvm_alloced_recs(owner_list, ns, true);
+			add_extent(alloced_recs, kaddr, order);
+			break;
+		}
+	}
+
+	mutex_unlock(&only_set->lock);
+	return kaddr;
+}
+EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
+
 static int init_owner_info(struct bch_nvm_namespace *ns)
 {
 	struct bch_owner_list_head *owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index ed3431daae06..10157d993126 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -79,6 +79,7 @@ extern struct bch_nvm_set *only_set;
 struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
 int bch_nvm_init(void);
 void bch_nvm_exit(void);
+void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 
 #else
 
@@ -92,6 +93,11 @@ static inline int bch_nvm_init(void)
 }
 static inline void bch_nvm_exit(void) { }
 
+static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1


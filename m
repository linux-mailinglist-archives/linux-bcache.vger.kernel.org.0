Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352BD315EA7
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhBJFJe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:09:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:40752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230470AbhBJFJ3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 620DAAFE6;
        Wed, 10 Feb 2021 05:08:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 10/20] bcache: bch_nvm_alloc_pages() of the buddy
Date:   Wed, 10 Feb 2021 13:07:32 +0800
Message-Id: <20210210050742.31237-11-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements the bch_nvm_alloc_pages() of the buddy.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c | 121 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   6 ++
 2 files changed, 127 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 7efb99c0fc07..0b992c17ce47 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -124,6 +124,127 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
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
+		if (addr > extent->kaddr) {
+			list = list->next;
+			continue;
+		}
+		break;
+	}
+
+	extent = kzalloc(sizeof(*extent), GFP_KERNEL);
+	extent->kaddr = addr;
+	extent->nr = 1 << order;
+	list_add_tail(&extent->list, list);
+	alloced_recs->nr++;
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
2.26.2


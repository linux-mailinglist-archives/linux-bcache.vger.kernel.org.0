Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781473A76AA
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Jun 2021 07:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhFOFvu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Jun 2021 01:51:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45648 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFOFvt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Jun 2021 01:51:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 30F091FD55;
        Tue, 15 Jun 2021 05:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623736184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpE7f2Fh4rhHS8BvwF5DiUomCxJwBM6D+bRkTRUCx6U=;
        b=Cym2Paek+5W/CjXblpSwMRzJ1D0oSEG8Dij7+dBdjXc7PLl6KL99BLG40AvvqYKSDsqE4u
        m2IYhTbVmOlyX1gtc5YuEceAIomNipYMuhDuGAP0aEoVS4T0w0XLu3j4QSJWLxEirJonke
        a0FLkGlDvggU58QIq1QdEuY/AogIs84=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623736184;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpE7f2Fh4rhHS8BvwF5DiUomCxJwBM6D+bRkTRUCx6U=;
        b=25+gO1NZvYqAZ8FG8vuW2kOsb7zWuf4dQJwzuV2rii6ARJyMK0MerADH+JpPDcn9/5dC/B
        6QeqPKsXG33a2NDg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 5EE89A3BB4;
        Tue, 15 Jun 2021 05:49:42 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 06/14] bcache: bch_nvm_alloc_pages() of the buddy
Date:   Tue, 15 Jun 2021 13:49:13 +0800
Message-Id: <20210615054921.101421-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210615054921.101421-1-colyli@suse.de>
References: <20210615054921.101421-1-colyli@suse.de>
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
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c   | 174 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |   6 ++
 include/uapi/linux/bcache-nvm.h |   6 +-
 3 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 804ee66e97be..5d095d241483 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -74,6 +74,180 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
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
index 71beb244b9be..f2583723aca6 100644
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
index 1fdb3eaabf7e..9cb937292202 100644
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
2.26.2


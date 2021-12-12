Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56725471BBD
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhLLRGY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:24 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39764 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhLLRGY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:24 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 452F31F3B0;
        Sun, 12 Dec 2021 17:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAtjIKgVImrNrvHLiu+pIDA46KPV9hGnhf622HlyaA0=;
        b=UDGA41eFiIo9YUJR7nL1l1R1MRM6YLtoJHXTObD1y3qlDlvEWT5+SnylIf7dLCI0L8unEQ
        bCdY+l9Cs/cW39/Z2izjU8VN3BnADT19wRwwQ2SbEyb28JkBLqF5pLrAbpQIQ2KbVWwAIe
        GraC+NzQvkIVGYvD/AL6FlRZqQII42w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328783;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QAtjIKgVImrNrvHLiu+pIDA46KPV9hGnhf622HlyaA0=;
        b=kM+lcVQtzL1TmRasomOPudzwRzKs8QMwQcE7eLTPNbemLgirH/AQ5ZOr3UdqpW/vAseZ2g
        Z19m88FF+MAwUdAw==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id E9EEDA3B87;
        Sun, 12 Dec 2021 17:06:19 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v13 04/12] bcache: bch_nvmpg_alloc_pages() of the buddy
Date:   Mon, 13 Dec 2021 01:05:44 +0800
Message-Id: <20211212170552.2812-5-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements the bch_nvmpg_alloc_pages() of the nvm pages buddy
allocator. In terms of function, this func is like current
page-buddy-alloc. But the differences are:
a: it need owner_uuid as parameter which record owner info. And it
make those info persistence.
b: it don't need flags like GFP_*. All allocs are the equal.
c: it don't trigger other ops etc swap/recycle.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/nvmpg.c | 221 ++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvmpg.h |   9 ++
 2 files changed, 230 insertions(+)

diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
index 2b70ee4a6028..a920779eb548 100644
--- a/drivers/md/bcache/nvmpg.c
+++ b/drivers/md/bcache/nvmpg.c
@@ -42,6 +42,11 @@ void *bch_nvmpg_offset_to_ptr(unsigned long offset)
 	return NULL;
 }
 
+static unsigned long bch_nvmpg_offset_to_pgoff(unsigned long nvmpg_offset)
+{
+	return BCH_NVMPG_GET_OFFSET(nvmpg_offset) >> PAGE_SHIFT;
+}
+
 unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
 {
 	int ns_id = ns->ns_id;
@@ -60,6 +65,15 @@ static void *bch_nvmpg_pgoff_to_ptr(struct bch_nvmpg_ns *ns, pgoff_t pgoff)
 	return ns->base_addr + (pgoff << PAGE_SHIFT);
 }
 
+static unsigned long bch_nvmpg_pgoff_to_offset(struct bch_nvmpg_ns *ns,
+					       pgoff_t pgoff)
+{
+	int ns_id = ns->ns_id;
+	unsigned long offset = pgoff << PAGE_SHIFT;
+
+	return BCH_NVMPG_OFFSET(ns_id, offset);
+}
+
 static void *bch_nvmpg_rec_to_ptr(struct bch_nvmpg_rec *r)
 {
 	struct bch_nvmpg_ns *ns = global_nvmpg_set->ns_tbl[r->ns_id];
@@ -269,6 +283,213 @@ static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
 	}
 }
 
+
+/* If not found, it will create if create == true */
+static struct bch_nvmpg_head *find_nvmpg_head(const char *uuid, bool create)
+{
+	struct bch_nvmpg_set_header *set_header = global_nvmpg_set->set_header;
+	struct bch_nvmpg_head *head = NULL;
+	int i;
+
+	if (set_header == NULL)
+		goto out;
+
+	for (i = 0; i < set_header->size; i++) {
+		struct bch_nvmpg_head *h = &set_header->heads[i];
+
+		if (h->state != BCH_NVMPG_HD_STAT_ALLOC)
+			continue;
+
+		if (!memcmp(uuid, h->uuid, 16)) {
+			head = h;
+			break;
+		}
+	}
+
+	if (!head && create) {
+		u32 used = set_header->used;
+
+		if (set_header->size > used) {
+			head = &set_header->heads[used];
+			memset(head, 0, sizeof(struct bch_nvmpg_head));
+			head->state = BCH_NVMPG_HD_STAT_ALLOC;
+			memcpy(head->uuid, uuid, 16);
+			global_nvmpg_set->heads_used++;
+			set_header->used++;
+		} else
+			pr_info("No free bch_nvmpg_head\n");
+	}
+
+out:
+	return head;
+}
+
+static struct bch_nvmpg_recs *find_empty_nvmpg_recs(void)
+{
+	unsigned int start;
+	struct bch_nvmpg_ns *ns = global_nvmpg_set->ns_tbl[0];
+	struct bch_nvmpg_recs *recs;
+
+	start = bitmap_find_next_zero_area(ns->recs_bitmap,
+					   BCH_MAX_PGALLOC_RECS, 0, 1, 0);
+	if (start > BCH_MAX_PGALLOC_RECS) {
+		pr_info("No free struct bch_nvmpg_recs\n");
+		return NULL;
+	}
+
+	bitmap_set(ns->recs_bitmap, start, 1);
+	recs = (struct bch_nvmpg_recs *)
+		bch_nvmpg_offset_to_ptr(BCH_NVMPG_SYSRECS_OFFSET)
+	       + start;
+
+	memset(recs, 0, sizeof(struct bch_nvmpg_recs));
+	return recs;
+}
+
+
+static struct bch_nvmpg_recs *find_nvmpg_recs(struct bch_nvmpg_ns *ns,
+					      struct bch_nvmpg_head *head,
+					      bool create)
+{
+	int ns_id = ns->sb->this_ns;
+	struct bch_nvmpg_recs *prev_recs = NULL, *recs = NULL;
+
+	recs = bch_nvmpg_offset_to_ptr(head->recs_offset[ns_id]);
+
+	/* If create=false, we return recs[nr] */
+	if (!create)
+		return recs;
+
+	/*
+	 * If create=true, it mean we need a empty struct bch_nvmpg_rec
+	 * So we should find non-empty struct bch_nvmpg_recs or alloc
+	 * new struct bch_nvmpg_recs. And return this bch_nvmpg_recs
+	 */
+	while (recs && (recs->used == recs->size)) {
+		prev_recs = recs;
+		recs = bch_nvmpg_offset_to_ptr(recs->next_offset);
+	}
+
+	/* Found empty struct bch_nvmpg_recs */
+	if (recs)
+		return recs;
+
+	/* Need alloc new struct bch_nvmpg_recs */
+	recs = find_empty_nvmpg_recs();
+	if (recs) {
+		unsigned long offset;
+
+		recs->next_offset = 0;
+		recs->head_offset = bch_nvmpg_ptr_to_offset(ns, head);
+		memcpy(recs->magic, bch_nvmpg_recs_magic, 16);
+		memcpy(recs->uuid, head->uuid, 16);
+		recs->size = BCH_NVMPG_MAX_RECS;
+		recs->used = 0;
+
+		offset = bch_nvmpg_ptr_to_offset(ns, recs);
+		if (prev_recs)
+			prev_recs->next_offset = offset;
+		else
+			head->recs_offset[ns_id] = offset;
+	}
+
+	return recs;
+}
+
+static void add_nvmpg_rec(struct bch_nvmpg_ns *ns,
+			  struct bch_nvmpg_recs *recs,
+			  unsigned long nvmpg_offset,
+			  int order)
+{
+	int i, ns_id;
+	unsigned long pgoff;
+
+	pgoff = bch_nvmpg_offset_to_pgoff(nvmpg_offset);
+	ns_id = ns->sb->this_ns;
+
+	for (i = 0; i < recs->size; i++) {
+		if (recs->recs[i].pgoff == 0) {
+			recs->recs[i].pgoff = pgoff;
+			recs->recs[i].order = order;
+			recs->recs[i].ns_id = ns_id;
+			recs->used++;
+			break;
+		}
+	}
+	BUG_ON(i == recs->size);
+}
+
+
+unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid)
+{
+	unsigned long nvmpg_offset = 0;
+	struct bch_nvmpg_head *head;
+	int n, o;
+
+	mutex_lock(&global_nvmpg_set->lock);
+	head = find_nvmpg_head(uuid, true);
+
+	if (!head) {
+		pr_err("Cannot find bch_nvmpg_recs by uuid.\n");
+		goto unlock;
+	}
+
+	for (n = 0; n < global_nvmpg_set->total_ns; n++) {
+		struct bch_nvmpg_ns *ns = global_nvmpg_set->ns_tbl[n];
+
+		if (!ns || (ns->free < (1L << order)))
+			continue;
+
+		for (o = order; o < BCH_MAX_ORDER; o++) {
+			struct list_head *list;
+			struct page *page, *buddy_page;
+
+			if (list_empty(&ns->free_area[o]))
+				continue;
+
+			list = ns->free_area[o].next;
+			page = container_of((void *)list, struct page,
+					    zone_device_data);
+
+			list_del(list);
+
+			while (o != order) {
+				void *addr;
+				pgoff_t pgoff;
+
+				pgoff = page->index + (1L << (o - 1));
+				addr = bch_nvmpg_pgoff_to_ptr(ns, pgoff);
+				buddy_page = bch_nvmpg_va_to_pg(addr);
+				set_page_private(buddy_page, o - 1);
+				buddy_page->index = pgoff;
+				__SetPageBuddy(buddy_page);
+				list_add((struct list_head *)&buddy_page->zone_device_data,
+					 &ns->free_area[o - 1]);
+				o--;
+			}
+
+			set_page_private(page, order);
+			__ClearPageBuddy(page);
+			ns->free -= 1L << order;
+			nvmpg_offset = bch_nvmpg_pgoff_to_offset(ns, page->index);
+			break;
+		}
+
+		if (o < BCH_MAX_ORDER) {
+			struct bch_nvmpg_recs *recs;
+
+			recs = find_nvmpg_recs(ns, head, true);
+			/* ToDo: handle pgalloc_recs==NULL */
+			add_nvmpg_rec(ns, recs, nvmpg_offset, order);
+			break;
+		}
+	}
+
+unlock:
+	mutex_unlock(&global_nvmpg_set->lock);
+	return nvmpg_offset;
+}
+
 static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
 {
 	struct bch_nvmpg_sb *sb = ns->sb;
diff --git a/drivers/md/bcache/nvmpg.h b/drivers/md/bcache/nvmpg.h
index 55778d4db7da..d03f3241b45a 100644
--- a/drivers/md/bcache/nvmpg.h
+++ b/drivers/md/bcache/nvmpg.h
@@ -76,6 +76,9 @@ struct bch_nvmpg_set {
 /* Indicate which field in bch_nvmpg_sb to be updated */
 #define BCH_NVMPG_TOTAL_NS	0	/* total_ns */
 
+#define BCH_PGOFF_TO_KVADDR(pgoff)					\
+	((void *)((unsigned long)(pgoff) << PAGE_SHIFT))
+
 #define BCH_MAX_PGALLOC_RECS						\
 	(min_t(unsigned int, 64,					\
 	       (BCH_NVMPG_START - BCH_NVMPG_SYSRECS_OFFSET) /		\
@@ -89,6 +92,7 @@ unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr);
 struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path);
 int bch_nvmpg_init(void);
 void bch_nvmpg_exit(void);
+unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid);
 
 #else
 
@@ -104,6 +108,11 @@ static inline int bch_nvmpg_init(void)
 
 static inline void bch_nvmpg_exit(void) { }
 
+static inline unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid)
+{
+	return 0;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.31.1


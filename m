Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210793E9673
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhHKRE1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:04:27 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48364 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhHKRE0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:04:26 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5314B22230;
        Wed, 11 Aug 2021 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzL/DK4YyfDaNOt8X4SJPGZyOBuwC/rMUS8f0mHWqOg=;
        b=nxgg4FjpiXIoqqXYt5+wTDrvudcrr9AaiddY4RTziQ2OR8ZOH61x56z2yjVQ1nq/RXZkcP
        iuAMc4oJBS/zrBGxxY3flMbzP8PO4vB7HI1rf/NKk8UB7nk/ksFZqlJsg361EyjbCULgm/
        Yj5goPTPvjkiq3Oihk/JEG9eZDRXc98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701441;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tzL/DK4YyfDaNOt8X4SJPGZyOBuwC/rMUS8f0mHWqOg=;
        b=10PzYtjgae9mK8d6ZpUfX9J3ur62lPz0O/4mfPEBjMImIfuGy66f/eH9/gzxRRfdEkWZ1K
        HSClKOfb+fTwScBg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 30A11A3D6B;
        Wed, 11 Aug 2021 17:03:56 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v12 04/12] bcache: bch_nvmpg_alloc_pages() of the buddy
Date:   Thu, 12 Aug 2021 01:02:16 +0800
Message-Id: <20210811170224.42837-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
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
 drivers/md/bcache/nvm-pages.c | 210 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |   9 ++
 2 files changed, 219 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 677fdb62f737..420b7c479057 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -50,6 +50,13 @@ unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
 	return BCH_NVMPG_OFFSET(ns_id, offset);
 }
 
+static unsigned long bch_nvmpg_ptr_to_pgoff(struct bch_nvmpg_ns *ns, void *ptr)
+{
+	unsigned long offset = (unsigned long)(ptr - ns->base_addr);
+
+	return offset >> PAGE_SHIFT;
+}
+
 static struct page *bch_nvmpg_va_to_pg(void *addr)
 {
 	return virt_to_page(addr);
@@ -268,6 +275,209 @@ static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
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
+			  void *kaddr, int order)
+{
+	int i;
+
+	for (i = 0; i < recs->size; i++) {
+		if (recs->recs[i].pgoff == 0) {
+			recs->recs[i].pgoff = bch_nvmpg_ptr_to_pgoff(ns, kaddr);
+			recs->recs[i].order = order;
+			recs->recs[i].ns_id = ns->sb->this_ns;
+			recs->used++;
+			break;
+		}
+	}
+	BUG_ON(i == recs->size);
+}
+
+
+void *bch_nvmpg_alloc_pages(int order, const char *uuid)
+{
+	void *kaddr = NULL;
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
+			kaddr = bch_nvmpg_pgoff_to_ptr(ns, page->index);
+			break;
+		}
+
+		if (o < BCH_MAX_ORDER) {
+			struct bch_nvmpg_recs *recs;
+
+			recs = find_nvmpg_recs(ns, head, true);
+			/* ToDo: handle pgalloc_recs==NULL */
+			add_nvmpg_rec(ns, recs, kaddr, order);
+			break;
+		}
+	}
+
+unlock:
+	mutex_unlock(&global_nvmpg_set->lock);
+	return kaddr;
+}
+EXPORT_SYMBOL_GPL(bch_nvmpg_alloc_pages);
+
 static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
 {
 	struct bch_nvmpg_sb *sb = ns->sb;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 2116086c4d01..1bcd7a4e1fd1 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -75,6 +75,9 @@ struct bch_nvmpg_set {
 /* Indicate which field in bch_nvmpg_sb to be updated */
 #define BCH_NVMPG_TOTAL_NS	0	/* total_ns */
 
+#define BCH_PGOFF_TO_KVADDR(pgoff)					\
+	((void *)((unsigned long)(pgoff) << PAGE_SHIFT))
+
 #define BCH_MAX_PGALLOC_RECS						\
 	(min_t(unsigned int, 64,					\
 	       (BCH_NVMPG_START - BCH_NVMPG_SYSRECS_OFFSET) /		\
@@ -88,6 +91,7 @@ unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr);
 struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path);
 int bch_nvmpg_init(void);
 void bch_nvmpg_exit(void);
+void *bch_nvmpg_alloc_pages(int order, const char *uuid);
 
 #else
 
@@ -103,6 +107,11 @@ static inline int bch_nvmpg_init(void)
 
 static inline void bch_nvmpg_exit(void) { }
 
+static inline void *bch_nvmpg_alloc_pages(int order, const char *uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.26.2


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81D4471BBF
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhLLRGa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:30 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39776 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhLLRG2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:28 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7E3FC1F3B3;
        Sun, 12 Dec 2021 17:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=41na2u10WTcRvOuAixMCZMI0++NR4a6O4c4YRbr0YQA=;
        b=l3jxlAUh4BqVDrxZqRA64InWwSiSQaDimOsc28RknNl3xHReBrxf03dXxfN4C+T3i1WfUa
        oFdJGFekie5dGecE/uviKKL9rs1pF/ejJvbhtjht5Ll/jdvwiDJdJDdbQEGAJaRjwwfOEy
        wTvKO/tkBE2xXCS/MNU3hmSYoPDxuZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328787;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=41na2u10WTcRvOuAixMCZMI0++NR4a6O4c4YRbr0YQA=;
        b=dsL5f6bMhjkSRDI7ekJhZ3Ws8KBgunwatKh10Fo4AfqXuRfbUTXTjH5hqWnmYGpKpHSkKR
        Kcra2FCRHQ3cIGBQ==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 03163A3B83;
        Sun, 12 Dec 2021 17:06:23 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v13 05/12] bcache: bch_nvmpg_free_pages() of the buddy allocator
Date:   Mon, 13 Dec 2021 01:05:45 +0800
Message-Id: <20211212170552.2812-6-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements the bch_nvmpg_free_pages() of the buddy allocator.

The difference between this and page-buddy-free:
it need owner_uuid to free owner allocated pages, and must
persistent after free.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/nvmpg.c | 164 ++++++++++++++++++++++++++++++++++++--
 drivers/md/bcache/nvmpg.h |   3 +
 2 files changed, 160 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
index a920779eb548..8ce0c4389b42 100644
--- a/drivers/md/bcache/nvmpg.c
+++ b/drivers/md/bcache/nvmpg.c
@@ -248,6 +248,57 @@ static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
 	return rc;
 }
 
+static void __free_space(struct bch_nvmpg_ns *ns, unsigned long nvmpg_offset,
+			 int order)
+{
+	unsigned long add_pages = (1L << order);
+	pgoff_t pgoff;
+	struct page *page;
+	void *va;
+
+	if (nvmpg_offset == 0) {
+		pr_err("free pages on offset 0\n");
+		return;
+	}
+
+	page = bch_nvmpg_va_to_pg(bch_nvmpg_offset_to_ptr(nvmpg_offset));
+	WARN_ON((!page) || (page->private != order));
+	pgoff = page->index;
+
+	while (order < BCH_MAX_ORDER - 1) {
+		struct page *buddy_page;
+
+		pgoff_t buddy_pgoff = pgoff ^ (1L << order);
+		pgoff_t parent_pgoff = pgoff & ~(1L << order);
+
+		if ((parent_pgoff + (1L << (order + 1)) > ns->pages_total))
+			break;
+
+		va = bch_nvmpg_pgoff_to_ptr(ns, buddy_pgoff);
+		buddy_page = bch_nvmpg_va_to_pg(va);
+		WARN_ON(!buddy_page);
+
+		if (PageBuddy(buddy_page) && (buddy_page->private == order)) {
+			list_del((struct list_head *)&buddy_page->zone_device_data);
+			__ClearPageBuddy(buddy_page);
+			pgoff = parent_pgoff;
+			order++;
+			continue;
+		}
+		break;
+	}
+
+	va = bch_nvmpg_pgoff_to_ptr(ns, pgoff);
+	page = bch_nvmpg_va_to_pg(va);
+	WARN_ON(!page);
+	list_add((struct list_head *)&page->zone_device_data,
+		 &ns->free_area[order]);
+	page->index = pgoff;
+	set_page_private(page, order);
+	__SetPageBuddy(page);
+	ns->free += add_pages;
+}
+
 static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
 {
 	unsigned int start, end, pages;
@@ -261,21 +312,19 @@ static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
 		pages = end - start;
 
 		while (pages) {
-			void *addr;
-
 			for (i = BCH_MAX_ORDER - 1; i >= 0; i--) {
 				if ((pgoff_start % (1L << i) == 0) &&
 				    (pages >= (1L << i)))
 					break;
 			}
 
-			addr = bch_nvmpg_pgoff_to_ptr(ns, pgoff_start);
-			page = bch_nvmpg_va_to_pg(addr);
+			page = bch_nvmpg_va_to_pg(
+					bch_nvmpg_pgoff_to_ptr(ns, pgoff_start));
 			set_page_private(page, i);
 			page->index = pgoff_start;
-			__SetPageBuddy(page);
-			list_add((struct list_head *)&page->zone_device_data,
-				 &ns->free_area[i]);
+
+			/* In order to update ns->free */
+			__free_space(ns, pgoff_start, i);
 
 			pgoff_start += 1L << i;
 			pages -= 1L << i;
@@ -490,6 +539,106 @@ unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid)
 	return nvmpg_offset;
 }
 
+static inline void *nvm_end_addr(struct bch_nvmpg_ns *ns)
+{
+	return ns->base_addr + (ns->pages_total << PAGE_SHIFT);
+}
+
+static inline bool in_nvmpg_ns_range(struct bch_nvmpg_ns *ns,
+				     void *start_addr, void *end_addr)
+{
+	return (start_addr >= ns->base_addr) && (end_addr < nvm_end_addr(ns));
+}
+
+static int remove_nvmpg_rec(struct bch_nvmpg_recs *recs, int ns_id,
+			    unsigned long nvmpg_offset, int order)
+{
+	struct bch_nvmpg_head *head;
+	struct bch_nvmpg_recs *prev_recs, *sys_recs;
+	struct bch_nvmpg_ns *ns;
+	unsigned long pgoff;
+	int i;
+
+	ns = global_nvmpg_set->ns_tbl[0];
+	pgoff = bch_nvmpg_offset_to_pgoff(nvmpg_offset);
+
+	head = bch_nvmpg_offset_to_ptr(recs->head_offset);
+	prev_recs = recs;
+	sys_recs = bch_nvmpg_offset_to_ptr(BCH_NVMPG_SYSRECS_OFFSET);
+	while (recs) {
+		for (i = 0; i < recs->size; i++) {
+			struct bch_nvmpg_rec *rec = &(recs->recs[i]);
+
+			if ((rec->pgoff == pgoff) && (rec->ns_id == ns_id)) {
+				WARN_ON(rec->order != order);
+				rec->_v = 0;
+				recs->used--;
+
+				if (recs->used == 0) {
+					int recs_pos = recs - sys_recs;
+
+					if (recs == prev_recs)
+						head->recs_offset[ns_id] =
+							recs->next_offset;
+					else
+						prev_recs->next_offset =
+							recs->next_offset;
+
+					recs->next_offset = 0;
+					recs->head_offset = 0;
+
+					bitmap_clear(ns->recs_bitmap, recs_pos, 1);
+				}
+				goto out;
+			}
+		}
+		prev_recs = recs;
+		recs = bch_nvmpg_offset_to_ptr(recs->next_offset);
+	}
+out:
+	return (recs ? 0 : -ENOENT);
+}
+
+void bch_nvmpg_free_pages(unsigned long nvmpg_offset, int order,
+			  const char *uuid)
+{
+	struct bch_nvmpg_ns *ns;
+	struct bch_nvmpg_head *head;
+	struct bch_nvmpg_recs *recs;
+	int r;
+
+	mutex_lock(&global_nvmpg_set->lock);
+
+	ns = global_nvmpg_set->ns_tbl[BCH_NVMPG_GET_NS_ID(nvmpg_offset)];
+	if (!ns) {
+		pr_err("can't find namespace by given kaddr from namespace\n");
+		goto unlock;
+	}
+
+	head = find_nvmpg_head(uuid, false);
+	if (!head) {
+		pr_err("can't found bch_nvmpg_head by uuid\n");
+		goto unlock;
+	}
+
+	recs = find_nvmpg_recs(ns, head, false);
+	if (!recs) {
+		pr_err("can't find bch_nvmpg_recs by uuid\n");
+		goto unlock;
+	}
+
+	r = remove_nvmpg_rec(recs, ns->sb->this_ns, nvmpg_offset, order);
+	if (r < 0) {
+		pr_err("can't find bch_nvmpg_rec\n");
+		goto unlock;
+	}
+
+	__free_space(ns, nvmpg_offset, order);
+
+unlock:
+	mutex_unlock(&global_nvmpg_set->lock);
+}
+
 static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
 {
 	struct bch_nvmpg_sb *sb = ns->sb;
@@ -686,6 +835,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
 	ns->pages_offset = sb->pages_offset;
 	ns->pages_total = sb->pages_total;
 	ns->sb = sb;
+	/* increase by __free_space() */
 	ns->free = 0;
 	ns->bdev = bdev;
 	ns->set = global_nvmpg_set;
diff --git a/drivers/md/bcache/nvmpg.h b/drivers/md/bcache/nvmpg.h
index d03f3241b45a..e089936e7f13 100644
--- a/drivers/md/bcache/nvmpg.h
+++ b/drivers/md/bcache/nvmpg.h
@@ -93,6 +93,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path);
 int bch_nvmpg_init(void);
 void bch_nvmpg_exit(void);
 unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid);
+void bch_nvmpg_free_pages(unsigned long nvmpg_offset, int order, const char *uuid);
 
 #else
 
@@ -113,6 +114,8 @@ static inline unsigned long bch_nvmpg_alloc_pages(int order, const char *uuid)
 	return 0;
 }
 
+static inline void bch_nvmpg_free_pages(void *addr, int order, const char *uuid) { }
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.31.1


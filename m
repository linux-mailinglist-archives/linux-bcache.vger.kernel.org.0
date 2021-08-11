Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED63E9675
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhHKREq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:04:46 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58290 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhHKREp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:04:45 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3E97E1FEDC;
        Wed, 11 Aug 2021 17:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oqOSTbWS2JJ3AUVP1NVPqkmZCwkyfGMY0LYovewmgME=;
        b=p0+ws1Vsmfu1JenGxdNuAm4gQfogifCcUgNE7R3CEQGE5OA0rbkoU46LngyKrP2koM5Dqx
        uVnSWHsVadFIhAP2fSKwW1cWO8rX56x3qoKlQrFHT7cJ5So5QujX/pmzF3esXpEtXsxoov
        sYEhDccEm+isiesTTN3krPMpVSQEVpw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701461;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oqOSTbWS2JJ3AUVP1NVPqkmZCwkyfGMY0LYovewmgME=;
        b=lccT5Sc4X/VasjybDrX6Tm9UbTuMpCWrW1U5W9jsRwclAqhlokFaJjZ+HclUN7OyBwNe0p
        Fgn3JVClvKtBYvDw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id D0BC0A3D6F;
        Wed, 11 Aug 2021 17:04:01 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v12 05/12] bcache: bch_nvmpg_free_pages() of the buddy allocator
Date:   Thu, 12 Aug 2021 01:02:17 +0800
Message-Id: <20210811170224.42837-6-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
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
 drivers/md/bcache/nvm-pages.c | 167 +++++++++++++++++++++++++++++++++-
 drivers/md/bcache/nvm-pages.h |   3 +
 2 files changed, 167 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 420b7c479057..ef61fdaaac28 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -240,6 +240,51 @@ static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
 	return rc;
 }
 
+static void __free_space(struct bch_nvmpg_ns *ns, void *addr, int order)
+{
+	unsigned long add_pages = (1L << order);
+	pgoff_t pgoff;
+	struct page *page;
+	void *va;
+
+	page = bch_nvmpg_va_to_pg(addr);
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
@@ -265,9 +310,9 @@ static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
 			page = bch_nvmpg_va_to_pg(addr);
 			set_page_private(page, i);
 			page->index = pgoff_start;
-			__SetPageBuddy(page);
-			list_add((struct list_head *)&page->zone_device_data,
-				 &ns->free_area[i]);
+
+			/* In order to update ns->free */
+			__free_space(ns, addr, i);
 
 			pgoff_start += 1L << i;
 			pages -= 1L << i;
@@ -478,6 +523,121 @@ void *bch_nvmpg_alloc_pages(int order, const char *uuid)
 }
 EXPORT_SYMBOL_GPL(bch_nvmpg_alloc_pages);
 
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
+static struct bch_nvmpg_ns *find_nvmpg_ns_by_addr(void *addr, int order)
+{
+	int i;
+	struct bch_nvmpg_ns *ns;
+
+	for (i = 0; i < global_nvmpg_set->total_ns; i++) {
+		ns = global_nvmpg_set->ns_tbl[i];
+
+		if (ns && in_nvmpg_ns_range(ns, addr, addr + (1L << order)))
+			return ns;
+	}
+
+	return NULL;
+}
+
+static int remove_nvmpg_rec(struct bch_nvmpg_recs *recs, int ns_id,
+			    void *kaddr, int order)
+{
+	struct bch_nvmpg_head *head;
+	struct bch_nvmpg_recs *prev_recs, *sys_recs;
+	struct bch_nvmpg_ns *ns;
+	unsigned long pgoff;
+	int i;
+
+	ns = global_nvmpg_set->ns_tbl[0];
+	pgoff = bch_nvmpg_ptr_to_pgoff(ns, kaddr);
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
+void bch_nvmpg_free_pages(void *addr, int order, const char *uuid)
+{
+	struct bch_nvmpg_ns *ns;
+	struct bch_nvmpg_head *head;
+	struct bch_nvmpg_recs *recs;
+	int r;
+
+	mutex_lock(&global_nvmpg_set->lock);
+
+	ns = find_nvmpg_ns_by_addr(addr, order);
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
+	r = remove_nvmpg_rec(recs, ns->sb->this_ns, addr, order);
+	if (r < 0) {
+		pr_err("can't find bch_nvmpg_rec\n");
+		goto unlock;
+	}
+
+	__free_space(ns, addr, order);
+
+unlock:
+	mutex_unlock(&global_nvmpg_set->lock);
+}
+EXPORT_SYMBOL_GPL(bch_nvmpg_free_pages);
+
 static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
 {
 	struct bch_nvmpg_sb *sb = ns->sb;
@@ -674,6 +834,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
 	ns->pages_offset = sb->pages_offset;
 	ns->pages_total = sb->pages_total;
 	ns->sb = sb;
+	/* increase by __free_space() */
 	ns->free = 0;
 	ns->bdev = bdev;
 	ns->set = global_nvmpg_set;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 1bcd7a4e1fd1..2529dc8b9d49 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -92,6 +92,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path);
 int bch_nvmpg_init(void);
 void bch_nvmpg_exit(void);
 void *bch_nvmpg_alloc_pages(int order, const char *uuid);
+void bch_nvmpg_free_pages(void *addr, int order, const char *uuid);
 
 #else
 
@@ -112,6 +113,8 @@ static inline void *bch_nvmpg_alloc_pages(int order, const char *uuid)
 	return NULL;
 }
 
+static inline void bch_nvmpg_free_pages(void *addr, int order, const char *uuid) { }
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.26.2


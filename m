Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D6B30B56E
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Feb 2021 03:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhBBCoU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Feb 2021 21:44:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:47751 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231433AbhBBCoT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Feb 2021 21:44:19 -0500
IronPort-SDR: h++ZtlF0B/rMdRkTTcuLaZNZ5qe5EOwARZZVjKx25SrPwjcAOVqu2p1o34mlPTGqGQHO7D2WfV
 ITB2y4VOLiHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167893408"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="167893408"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:43:08 -0800
IronPort-SDR: NKlVju9b1Sjog0Kdni/gV1Ojpfsrxq+tM2tyU7NTLEN2aq6/66myxHGp7nXcg3l4YR8pkFIJy9
 z61QJiR7BOwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="370226448"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2021 18:43:06 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v5 8/8] bcache: testing module for nvm pages allocator
Date:   Tue,  2 Feb 2021 05:23:52 -0500
Message-Id: <20210202102352.4833-9-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210202102352.4833-1-qiaowei.ren@intel.com>
References: <20210202102352.4833-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch creates the testing module for nvm pages allocator.
Before this module is loaded, the super block needs to be writen
into nvdimm device (like /dev/pmemX).

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/Kconfig    |   6 ++
 drivers/md/bcache/Makefile   |   2 +
 drivers/md/bcache/test-nvm.c | 202 +++++++++++++++++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 drivers/md/bcache/test-nvm.c

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index fdec9905ef40..68302a9cd476 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -41,3 +41,9 @@ config BCACHE_NVM_PAGES
 	depends on BCACHE
 	help
 	nvm pages allocator for bcache.
+
+config BCACHE_NVM_PAGES_TEST
+       tristate "Testing for NVM pages"
+       depends on BCACHE_NVM_PAGES
+       help
+       Testing module for NVM pages allocator.
diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index 948e5ed2ca66..7b7d3535f4ef 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
 bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
 	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
 	util.o writeback.o features.o nvm-pages.o
+
+obj-$(CONFIG_BCACHE_NVM_PAGES_TEST) += test-nvm.o
diff --git a/drivers/md/bcache/test-nvm.c b/drivers/md/bcache/test-nvm.c
new file mode 100644
index 000000000000..f2e5a9d69843
--- /dev/null
+++ b/drivers/md/bcache/test-nvm.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Nvdimm page-buddy test case
+ *
+ * Copyright (c) 2021, Intel Corporation.
+ * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
+ * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/crc32.h>
+#include <linux/uuid.h>
+#include <linux/prandom.h>
+#include <linux/pagemap.h>
+#include <linux/pfn_t.h>
+#include "nvm-pages.h"
+
+static char *host = "NVDIMM device name";
+module_param(host, charp, 0444);
+
+#define MAX_OWNER 10
+
+static pgoff_t vaddr_to_nvm_pgoff(struct bch_nvm_namespace *ns, void *kaddr)
+{
+	return (kaddr - ns->kaddr) / PAGE_SIZE;
+}
+
+static void print_nvm_extent(struct bch_nvm_alloced_recs *extents)
+{
+	struct list_head *list = extents->extent_head.next;
+	struct bch_nvm_namespace *ns = extents->ns;
+	struct bch_extent *e;
+	pgoff_t pgoff;
+
+	while (list != &extents->extent_head) {
+		e = container_of(list, struct bch_extent, list);
+		pgoff = vaddr_to_nvm_pgoff(ns, e->kaddr);
+		pr_info(" [%ld ~ %u)", pgoff, e->nr);
+		list = list->next;
+	}
+	pr_info("\n");
+}
+
+static void print_owner_list_info(struct bch_nvm_set *nvm_set, bool print_extent)
+{
+	struct bch_owner_list *owner_list;
+	struct bch_nvm_alloced_recs *extents;
+	int i, j;
+
+	for (i = 0; i < nvm_set->owner_list_used; i++) {
+		owner_list = nvm_set->owner_lists[i];
+		pr_info("owner uuid=%pU\n", owner_list->owner_uuid);
+		for (j = 0; j < nvm_set->total_namespaces_nr; j++) {
+			if (owner_list->alloced_recs[j]) {
+				extents = owner_list->alloced_recs[j];
+				pr_info("\t nvm uuid=%pU, allocated extents=%u\n",
+					extents->ns->uuid, extents->nr);
+				if (print_extent)
+					print_nvm_extent(extents);
+			}
+		}
+	}
+}
+
+static void print_buddy_info(struct bch_nvm_namespace *ns)
+{
+	int i;
+	struct list_head *list;
+	struct page *page;
+	u64 expected_free_pages = 0;
+
+	pr_info("namespace total_page=%lld, buddy_range[%lld -%lld], free_pages=%lld\n",
+		ns->pages_total, ns->pages_offset / ns->page_size, ns->pages_total, ns->free);
+
+	for (i = 0; i < BCH_MAX_ORDER; i++) {
+		pr_info("order=%d, page range:\n", i);
+		list = ns->free_area[i].next;
+		while (list != &ns->free_area[i]) {
+			page = container_of((void *)list, struct page, zone_device_data);
+			pr_info("  [%ld -- %ld) ", page->index, page->index + (1 << page->private));
+			expected_free_pages += 1 << page->private;
+			list = list->next;
+		}
+	}
+	WARN_ON(ns->free != expected_free_pages);
+	pr_info("expected_free_pages=%lld\n", expected_free_pages);
+}
+
+/*  alloc all page by order=0 */
+static void alloc_all_pages(struct bch_nvm_set *nvm_set)
+{
+	char owner_uuid[16];
+	int i = 0;
+	int loops = 10;
+	u64 free_pages = nvm_set->nss[0]->free / loops;
+	long long pos = 0;
+	void **addr_array;
+
+	generate_random_uuid(owner_uuid);
+
+	addr_array = kvcalloc(nvm_set->nss[0]->free, sizeof(void *), GFP_KERNEL);
+	if (!addr_array)
+		return;
+
+	pr_info("----%s----- starting\n", __func__);
+	for (i = 0; i < loops; i++) {
+		u64 alloc_pages = free_pages;
+
+		while (alloc_pages > 0) {
+			addr_array[pos++] = bch_nvm_alloc_pages(0, owner_uuid);
+			alloc_pages--;
+		}
+		pr_info("loops=%d\n", i + 1);
+	}
+
+	print_owner_list_info(nvm_set, true);
+	print_buddy_info(nvm_set->nss[0]);
+
+	pr_info("----free all alloced pages--%lld-\n", pos);
+	pos--;
+	for (; pos >= 0 && (addr_array[pos] != NULL); pos--) {
+		struct page *page = virt_to_page(addr_array[pos]);
+
+		bch_nvm_free_pages(addr_array[pos], page->private, owner_uuid);
+
+		if (pos % free_pages == 0)
+			pr_info("current pos=%lld", pos);
+	}
+	print_owner_list_info(nvm_set, true);
+	print_buddy_info(nvm_set->nss[0]);
+
+	kvfree(addr_array);
+}
+
+static void alloc_random_order_pages(struct bch_nvm_set *nvm_set, char **owner_uuids)
+{
+	int i, order;
+	void *addr[MAX_OWNER];
+
+	pr_info("----%s----- starting\n", __func__);
+	for (i = 0; i < MAX_OWNER; i++) {
+		order = prandom_u32() % BCH_MAX_ORDER;
+		addr[i] = bch_nvm_alloc_pages(order, owner_uuids[i]);
+	}
+
+	print_owner_list_info(nvm_set, true);
+	print_buddy_info(nvm_set->nss[0]);
+
+	for (i = 0; i < MAX_OWNER; i++) {
+		struct page *page = virt_to_page(addr[i]);
+
+		bch_nvm_free_pages(addr[i], page->private, owner_uuids[i]);
+	}
+	print_owner_list_info(nvm_set, true);
+	print_buddy_info(nvm_set->nss[0]);
+}
+
+static int __init test_nvm_init(void)
+{
+	char **owner_uuids;
+	struct bch_nvm_set *nvm_set;
+	struct bch_nvm_namespace *ns = bch_register_namespace(host);
+	int i, r = 0;
+
+	pr_info("nvm pages test enter: %s\n", host);
+	if (IS_ERR(ns)) {
+		pr_info("failed to register namespace: %s\n", host);
+		r = -EINVAL;
+		goto err;
+	}
+
+	print_buddy_info(ns);
+
+	owner_uuids = kcalloc(MAX_OWNER, sizeof(char *), GFP_KERNEL);
+	for (i = 0; i < MAX_OWNER; i++) {
+		owner_uuids[i] = kmalloc(16, GFP_KERNEL);
+		generate_random_uuid(owner_uuids[i]);
+	}
+
+	nvm_set = ns->nvm_set;
+	alloc_all_pages(nvm_set);
+	alloc_random_order_pages(nvm_set, owner_uuids);
+
+	for (i = 0; i < MAX_OWNER; i++)
+		kfree(owner_uuids[i]);
+	kfree(owner_uuids);
+
+err:
+	return r;
+}
+module_init(test_nvm_init);
+
+static void __exit test_nvm_exit(void)
+{
+	pr_info("nvm pages test exit\n");
+}
+module_exit(test_nvm_exit);
+
+MODULE_LICENSE("GPL v2");
-- 
2.17.1


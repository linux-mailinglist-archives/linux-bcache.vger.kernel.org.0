Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051622F2ABA
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Jan 2021 10:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389010AbhALJE0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Jan 2021 04:04:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:6871 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389122AbhALJEX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Jan 2021 04:04:23 -0500
IronPort-SDR: UB5RxupaPdF5tkxt6Atyo1WwGTGoPJSN8X2swRzCeCrTdIQw2JF2TC0ivgm+2vETWdhPiMH/Ag
 7QGDcAgNgtsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="262793412"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="262793412"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 01:03:17 -0800
IronPort-SDR: 1A7frCsomLI3MOjJkWopYFAEceEfo5do/IWOmntzx90SuQxEpviFmS7io7i71o4c5ajJEnY26f
 BiuLbt506F6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="352948986"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jan 2021 01:03:15 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v4 8/8] bcache: testing module for nvm pages allocator
Date:   Tue, 12 Jan 2021 11:45:05 -0500
Message-Id: <20210112164505.68228-9-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112164505.68228-1-qiaowei.ren@intel.com>
References: <20210112164505.68228-1-qiaowei.ren@intel.com>
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
 drivers/md/bcache/test-nvm.c | 117 +++++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+)
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
index 000000000000..8b9f2c1e7825
--- /dev/null
+++ b/drivers/md/bcache/test-nvm.c
@@ -0,0 +1,117 @@
+// SPDX-License-Identifier: GPL-2.0
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
+	return (kaddr - ns->kaddr - ns->pages_offset) / PAGE_SIZE;
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
+	for (i = 0; i < nvm_set->owner_list_size; i++) {
+		owner_list = nvm_set->owner_lists[i];
+		pr_info("owner uuid=%pU\n", owner_list->owner_uuid);
+		for (j = 0; j < nvm_set->total_namespaces_nr; j++) {
+			if (owner_list->alloced_recs[j]) {
+				extents = owner_list->alloced_recs[j];
+				pr_info("\t nvm uuid=%pU, allocated extents=%u\n",
+					extents->ns->uuid, extents->size);
+				if (print_extent)
+					print_nvm_extent(extents);
+			}
+		}
+	}
+}
+
+static void test_case(struct bch_nvm_set *nvm_set, char **owner_uuids)
+{
+	int i, order;
+	void *addr[MAX_OWNER];
+
+	for (i = 0; i < MAX_OWNER; i++) {
+		order = prandom_u32() % MAX_ORDER;
+		addr[i] = bch_nvm_alloc_pages(order, owner_uuids[i]);
+	}
+	print_owner_list_info(nvm_set, true);
+	for (i = 0; i < MAX_OWNER; i++) {
+		struct page *page = virt_to_page(addr[i]);
+
+		bch_nvm_free_pages(addr[i], page->private, owner_uuids[i]);
+	}
+	print_owner_list_info(nvm_set, true);
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
+	owner_uuids = kcalloc(MAX_OWNER, sizeof(char *), GFP_KERNEL);
+	for (i = 0; i < MAX_OWNER; i++) {
+		owner_uuids[i] = kmalloc(16, GFP_KERNEL);
+		generate_random_uuid(owner_uuids[i]);
+	}
+
+	nvm_set = ns->nvm_set;
+	test_case(nvm_set, owner_uuids);
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


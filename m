Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E4B2E1933
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgLWHBX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:01:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:58035 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbgLWHBW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:01:22 -0500
IronPort-SDR: rY5981S4B3J0UswwrBcd75jJzz6mZE7dBCeGuxof/r0+eBNTB+KEjidxPqv/t/dlv+ABCmSv7W
 tRAsZ2EEaA0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="163695103"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="163695103"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:00:17 -0800
IronPort-SDR: MADjJhf9nU+H9iC6vnoclu5MfmI8wTiM6YEYI+pRQui0HwqFUjgWMBiHZJnkAWTOEPtVbfrErw
 2NSM8L2vJSQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="344924299"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 22 Dec 2020 23:00:16 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH 8/8] bcache: testing module for nvm pages allocator
Date:   Wed, 23 Dec 2020 09:41:36 -0500
Message-Id: <20201223144136.24966-9-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144136.24966-1-qiaowei.ren@intel.com>
References: <20201223144136.24966-1-qiaowei.ren@intel.com>
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
index 448a99ce13b2..1e4f4ea2f1a0 100644
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
index 000000000000..28133ceaa8fd
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
+static pgoff_t vaddr_to_nvm_pgoff(struct nvm_namespace *ns, void *kaddr)
+{
+	return (kaddr - ns->kaddr - ns->pages_offset) / PAGE_SIZE;
+}
+
+static void print_nvm_extent(struct nvm_alloced_recs *extents)
+{
+	struct list_head *list = extents->extent_head.next;
+	struct nvm_namespace *ns = extents->ns;
+	struct extent *e;
+	pgoff_t pgoff;
+
+	while (list != &extents->extent_head) {
+		e = container_of(list, struct extent, list);
+		pgoff = vaddr_to_nvm_pgoff(ns, e->kaddr);
+		pr_info(" [%ld ~ %u)", pgoff, e->nr);
+		list = list->next;
+	}
+	pr_info("\n");
+}
+
+static void print_owner_list_info(struct nvm_set *nvm_set, bool print_extent)
+{
+	struct owner_list *owner_list;
+	struct nvm_alloced_recs *extents;
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
+static void test_case(struct nvm_set *nvm_set, char **owner_uuids)
+{
+	int i, order;
+	void *addr[MAX_OWNER];
+
+	for (i = 0; i < MAX_OWNER; i++) {
+		order = prandom_u32() % MAX_ORDER;
+		addr[i] = nvm_alloc_pages(order, owner_uuids[i]);
+	}
+	print_owner_list_info(nvm_set, true);
+	for (i = 0; i < MAX_OWNER; i++) {
+		struct page *page = virt_to_page(addr[i]);
+
+		nvm_free_pages(addr[i], page->private, owner_uuids[i]);
+	}
+	print_owner_list_info(nvm_set, true);
+}
+
+static int __init test_nvm_init(void)
+{
+	char **owner_uuids;
+	struct nvm_set *nvm_set;
+	int i, r = 0;
+	struct nvm_namespace *ns = register_namespace(host);
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


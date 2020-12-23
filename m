Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A72C2E192D
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgLWHAy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:00:54 -0500
Received: from mga18.intel.com ([134.134.136.126]:58038 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727314AbgLWHAw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:00:52 -0500
IronPort-SDR: AFf3fTC+oVw4oDg23OEl2zZWlKoQHcElUyh6r8fomBEyfBWlc2M4i7rxsLNFy9tXZebVShw4d+
 kpfIPFqSsXcw==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="163695081"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="163695081"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:00:10 -0800
IronPort-SDR: j4F4TxHQJWlXa8f6XyTk0zYiKFRo/nF3VYh3MNFQfl6oznMSKRrLSnuWnJFRXO/s3ljeXHhNd5
 hF9WEp/V0fJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="344924240"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 22 Dec 2020 23:00:08 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH 2/8] bcache: initialize the nvm pages allocator
Date:   Wed, 23 Dec 2020 09:41:30 -0500
Message-Id: <20201223144136.24966-3-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144136.24966-1-qiaowei.ren@intel.com>
References: <20201223144136.24966-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch define the prototype data structures in memory and initializes
the nvm pages allocator.

The nv address space which is managed by this allocatior can consist of
many nvm namespaces, and some namespaces can compose into one nvm set,
like cache set. For this initial implementation, only one set can be
supported.

The users of this nvm pages allocator need to call regiseter_namespace()
to register the nvdimm device (like /dev/pmemX) into this allocator as
the instance of struct nvm_namespace.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/Kconfig     |   6 +
 drivers/md/bcache/Makefile    |   2 +-
 drivers/md/bcache/nvm-pages.c | 303 ++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |  91 ++++++++++
 drivers/md/bcache/super.c     |   3 +
 5 files changed, 404 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index d1ca4d059c20..448a99ce13b2 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -35,3 +35,9 @@ config BCACHE_ASYNC_REGISTRATION
 	device path into this file will returns immediately and the real
 	registration work is handled in kernel work queue in asynchronous
 	way.
+
+config BCACHE_NVM_PAGES
+	bool "NVDIMM support for bcache"
+	depends on BCACHE
+	help
+	nvm pages allocator for bcache.
diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index 5b87e59676b8..948e5ed2ca66 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
 
 bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
 	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
-	util.o writeback.o features.o
+	util.o writeback.o features.o nvm-pages.o
diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
new file mode 100644
index 000000000000..841616ea3267
--- /dev/null
+++ b/drivers/md/bcache/nvm-pages.c
@@ -0,0 +1,303 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/dax.h>
+#include <linux/pfn_t.h>
+#include <linux/libnvdimm.h>
+#include <linux/mm_types.h>
+#include <linux/err.h>
+#include <linux/pagemap.h>
+#include <linux/bitmap.h>
+#include <linux/blkdev.h>
+#include "nvm-pages.h"
+
+struct nvm_set *only_set;
+
+static struct owner_list *alloc_owner_list(const char *owner_uuid,
+		const char *label, int total_namespaces)
+{
+	struct owner_list *owner_list;
+
+	owner_list = kzalloc(sizeof(struct owner_list), GFP_KERNEL);
+	if (owner_uuid)
+		memcpy(owner_list->owner_uuid, owner_uuid, 16);
+	if (label)
+		memcpy(owner_list->label, label, NVM_PAGES_LABEL_SIZE);
+	owner_list->alloced_recs = kcalloc(total_namespaces,
+			sizeof(struct nvm_alloced_recs *), GFP_KERNEL);
+
+	return owner_list;
+}
+
+static void release_extents(struct nvm_alloced_recs *extents)
+{
+	struct list_head *list = extents->extent_head.next;
+	struct extent *extent;
+
+	while (list != &extents->extent_head) {
+		extent = container_of(list, struct extent, list);
+		list_del(list);
+		kfree(extent);
+		list = extents->extent_head.next;
+	}
+	kfree(extents);
+}
+
+static void release_owner_info(struct nvm_set *nvm_set)
+{
+	struct owner_list *owner_list;
+	int i, j;
+
+	for (i = 0; i < nvm_set->owner_list_size; i++) {
+		owner_list = nvm_set->owner_lists[i];
+		for (j = 0; j < nvm_set->total_namespaces_nr; j++) {
+			if (owner_list->alloced_recs[j])
+				release_extents(owner_list->alloced_recs[j]);
+		}
+		kfree(owner_list->alloced_recs);
+		kfree(owner_list);
+	}
+	kfree(nvm_set->owner_lists);
+}
+
+static void release_nvm_namespaces(struct nvm_set *nvm_set)
+{
+	int i;
+
+	for (i = 0; i < nvm_set->total_namespaces_nr; i++)
+		kfree(nvm_set->nss[i]);
+
+	kfree(nvm_set->nss);
+}
+
+static void release_nvm_set(struct nvm_set *nvm_set)
+{
+	release_nvm_namespaces(nvm_set);
+	release_owner_info(nvm_set);
+	kfree(nvm_set);
+}
+
+static void *nvm_pgoff_to_vaddr(struct nvm_namespace *ns, pgoff_t pgoff)
+{
+	return ns->kaddr + ns->pages_offset + (pgoff << PAGE_SHIFT);
+}
+
+static void init_owner_info(struct nvm_namespace *ns)
+{
+	struct owner_list_head *owner_list_head;
+	struct nvm_pages_owner_head *owner_head;
+	struct nvm_pgalloc_recs *nvm_pgalloc_recs;
+	struct owner_list *owner_list;
+	struct nvm_alloced_recs *extents;
+	struct extent *extent;
+	u32 i, j, k;
+
+	owner_list_head = (struct owner_list_head *)
+			(ns->kaddr + NVM_PAGES_OWNER_LIST_HEAD_OFFSET);
+
+	mutex_lock(&only_set->lock);
+	only_set->owner_list_size = owner_list_head->size;
+	for (i = 0; i < owner_list_head->size; i++) {
+		owner_head = &owner_list_head->heads[i];
+		owner_list = alloc_owner_list(owner_head->uuid, owner_head->label,
+				only_set->total_namespaces_nr);
+
+		for (j = 0; j < only_set->total_namespaces_nr; j++) {
+			if (only_set->nss[j] == NULL || owner_head->recs[j] == NULL)
+				continue;
+
+			nvm_pgalloc_recs = (struct nvm_pgalloc_recs *)
+					((long)owner_head->recs[j] + ns->kaddr);
+
+			extents = kzalloc(sizeof(struct nvm_alloced_recs), GFP_KERNEL);
+			extents->ns = only_set->nss[j];
+			INIT_LIST_HEAD(&extents->extent_head);
+			owner_list->alloced_recs[j] = extents;
+
+			do {
+				struct nvm_pgalloc_rec *rec;
+
+				for (k = 0; k < nvm_pgalloc_recs->size; k++) {
+					rec = &nvm_pgalloc_recs->recs[k];
+					extent = kzalloc(sizeof(struct extent), GFP_KERNEL);
+					extent->kaddr = nvm_pgoff_to_vaddr(extents->ns, rec->pgoff);
+					extent->nr = rec->nr;
+					list_add_tail(&extent->list, &extents->extent_head);
+
+					extents->ns->free -= rec->nr;
+				}
+				extents->size += nvm_pgalloc_recs->size;
+
+				if (nvm_pgalloc_recs->next)
+					nvm_pgalloc_recs = (struct nvm_pgalloc_recs *)
+						((long)nvm_pgalloc_recs->next + ns->kaddr);
+				else
+					nvm_pgalloc_recs = NULL;
+			} while (nvm_pgalloc_recs);
+		}
+		only_set->owner_lists[i] = owner_list;
+		owner_list->nvm_set = only_set;
+	}
+	mutex_unlock(&only_set->lock);
+}
+
+static bool dev_dax_supported(struct block_device *bdev)
+{
+	char buf[BDEVNAME_SIZE];
+	struct page *page;
+	struct nvm_pages_sb *sb;
+	bool supported = false;
+
+	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
+			NVM_PAGES_SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
+
+	if (IS_ERR(page))
+		goto err;
+
+	sb = page_address(page);
+	if (!bdev_dax_supported(bdev, sb->page_size))
+		pr_info("DAX can't supported by %s\n", bdevname(bdev, buf));
+	else
+		supported = true;
+
+	put_page(page);
+err:
+	return supported;
+}
+
+static bool attach_nvm_set(struct nvm_namespace *ns)
+{
+	bool rc = true;
+
+	mutex_lock(&only_set->lock);
+	if (only_set->nss) {
+		if (memcmp(ns->sb->set_uuid, only_set->set_uuid, 16)) {
+			pr_info("namespace id does't match nvm set\n");
+			rc = false;
+			goto unlock;
+		}
+
+		if (only_set->nss[ns->sb->this_namespace_nr]) {
+			pr_info("already has the same position(%d) nvm\n",
+					ns->sb->this_namespace_nr);
+			rc = false;
+			goto unlock;
+		}
+	} else {
+		memcpy(only_set->set_uuid, ns->sb->set_uuid, 16);
+		only_set->total_namespaces_nr = ns->sb->total_namespaces_nr;
+		only_set->nss = kcalloc(only_set->total_namespaces_nr,
+				sizeof(struct nvm_namespace *), GFP_KERNEL);
+		only_set->owner_lists = kcalloc(MAX_OWNER_LIST,
+				sizeof(struct nvm_pages_owner_head *), GFP_KERNEL);
+	}
+
+	only_set->nss[ns->sb->this_namespace_nr] = ns;
+
+unlock:
+	mutex_unlock(&only_set->lock);
+	return rc;
+}
+
+struct nvm_namespace *register_namespace(const char *dev_path)
+{
+	struct nvm_namespace *ns;
+	int err;
+	pgoff_t pgoff;
+	char buf[BDEVNAME_SIZE];
+	struct block_device *bdev;
+
+	bdev = blkdev_get_by_path(dev_path, FMODE_READ|FMODE_WRITE|FMODE_EXEC, NULL);
+	if (IS_ERR(bdev)) {
+		pr_info("get %s error\n", dev_path);
+		return ERR_PTR(PTR_ERR(bdev));
+	}
+
+	err = -EOPNOTSUPP;
+	if (!dev_dax_supported(bdev)) {
+		pr_info("%s don't support DAX\n", bdevname(bdev, buf));
+		goto bdput;
+	}
+
+	err = -EINVAL;
+	if (bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff)) {
+		pr_info("invalid offset of %s\n", bdevname(bdev, buf));
+		goto bdput;
+	}
+
+	err = -ENOMEM;
+	ns = kmalloc(sizeof(struct nvm_namespace), GFP_KERNEL);
+	if (ns == NULL)
+		goto bdput;
+
+	err = -EINVAL;
+	ns->dax_dev = fs_dax_get_by_bdev(bdev);
+	if (ns->dax_dev == NULL) {
+		pr_info(" can't by dax device by %s\n", bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	if (dax_direct_access(ns->dax_dev, pgoff, 1, &ns->kaddr, &ns->start_pfn) < 0) {
+		pr_info("dax_direct_access error\n");
+		goto free_ns;
+	}
+
+	ns->sb = (struct nvm_pages_sb *)(ns->kaddr + NVM_PAGES_SB_OFFSET);
+	if (ns->sb->total_namespaces_nr != 1) {
+		pr_info("only one nvm device\n");
+		goto free_ns;
+	}
+
+	err = -EEXIST;
+	if (!attach_nvm_set(ns))
+		goto free_ns;
+
+	ns->page_size = ns->sb->page_size;
+	ns->pages_offset = ns->sb->pages_offset;
+	ns->pages_total = ns->sb->pages_total;
+	ns->start_pfn.val += ns->pages_offset >> PAGE_SHIFT;
+	ns->free = ns->pages_total;
+	ns->bdev = bdev;
+	ns->nvm_set = only_set;
+
+	mutex_init(&ns->lock);
+
+	if (ns->sb->this_namespace_nr == 0) {
+		pr_info("only first namespace contain owner info\n");
+		init_owner_info(ns);
+	}
+
+	return ns;
+
+free_ns:
+	kfree(ns);
+bdput:
+	bdput(bdev);
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(register_namespace);
+
+int __init bch_nvm_init(void)
+{
+	only_set = kzalloc(sizeof(struct nvm_set), GFP_KERNEL);
+	if (!only_set)
+		return -ENOMEM;
+
+	only_set->total_namespaces_nr = 0;
+	only_set->owner_lists = NULL;
+	only_set->nss = NULL;
+
+	mutex_init(&only_set->lock);
+
+	pr_info("bcache nvm init\n");
+	return 0;
+}
+
+void bch_nvm_exit(void)
+{
+	release_nvm_set(only_set);
+	pr_info("bcache nvm exit\n");
+}
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
new file mode 100644
index 000000000000..1a24af6cb5a9
--- /dev/null
+++ b/drivers/md/bcache/nvm-pages.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _BCACHE_NVM_PAGES_H
+#define _BCACHE_NVM_PAGES_H
+
+#include <linux/bcache-nvm.h>
+
+/*
+ * Bcache NVDIMM in memory data structures
+ */
+
+/*
+ * The following three structures in memory records which page(s) allocated
+ * to which owner. After reboot from power failure, they will be initialized
+ * based on nvm pages superblock in NVDIMM device.
+ */
+struct extent {
+	void *kaddr;
+	u32 nr;
+	struct list_head list;
+};
+
+struct nvm_alloced_recs {
+	u32  size;
+	struct nvm_namespace *ns;
+	struct list_head extent_head;
+};
+
+struct owner_list {
+	u8  owner_uuid[16];
+	char label[NVM_PAGES_LABEL_SIZE];
+
+	struct nvm_set *nvm_set;
+	struct nvm_alloced_recs **alloced_recs;
+};
+
+struct nvm_namespace {
+	void *kaddr;
+
+	u8 uuid[18];
+	u64 free;
+	u32 page_size;
+	u64 pages_offset;
+	u64 pages_total;
+	pfn_t start_pfn;
+
+	struct dax_device *dax_dev;
+	struct block_device *bdev;
+	struct nvm_pages_sb *sb;
+	struct nvm_set *nvm_set;
+
+	struct mutex lock;
+};
+
+/*
+ * A set of namespaces. Currently only one set can be supported.
+ */
+struct nvm_set {
+	u8 set_uuid[16];
+	u32 total_namespaces_nr;
+
+	u32 owner_list_size;
+	struct owner_list **owner_lists;
+
+	struct nvm_namespace **nss;
+
+	struct mutex lock;
+};
+extern struct nvm_set *only_set;
+
+extern struct nvm_namespace *register_namespace(const char *dev_path);
+extern int bch_nvm_init(void);
+extern void bch_nvm_exit(void);

+#ifdef CONFIG_BCACHE_NVM_PAGES
+
+
+#else
+
+static inline struct nvm_namespace *register_namespace(const char *dev_path)
+{
+	return NULL;
+}
+static inline int bch_nvm_init(void)
+{
+	return 0;
+}
+static inline void bch_nvm_exit(void) { }
+
+#endif /* CONFIG_BCACHE_NVM_PAGES */
+
+#endif /* _BCACHE_NVM_PAGES_H */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 46a00134a36a..77b608efbe55 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -14,6 +14,7 @@
 #include "request.h"
 #include "writeback.h"
 #include "features.h"
+#include "nvm-pages.h"
 
 #include <linux/blkdev.h>
 #include <linux/debugfs.h>
@@ -2782,6 +2783,7 @@ static void bcache_exit(void)
 {
 	bch_debug_exit();
 	bch_request_exit();
+	bch_nvm_exit();
 	if (bcache_kobj)
 		kobject_put(bcache_kobj);
 	if (bcache_wq)
@@ -2861,6 +2863,7 @@ static int __init bcache_init(void)
 
 	bch_debug_init();
 	closure_debug_init();
+	bch_nvm_init();
 
 	bcache_is_reboot = false;
 
-- 
2.17.1


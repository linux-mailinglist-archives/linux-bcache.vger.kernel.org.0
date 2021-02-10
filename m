Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAFE315EBE
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBJFJn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:09:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:40748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230429AbhBJFJb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4A700B066;
        Wed, 10 Feb 2021 05:08:16 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 08/20] bcache: initialize the nvm pages allocator
Date:   Wed, 10 Feb 2021 13:07:30 +0800
Message-Id: <20210210050742.31237-9-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

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
Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/Kconfig       |   6 +
 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/nvm-pages.c   | 404 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |  92 ++++++++
 drivers/md/bcache/super.c       |   3 +
 include/uapi/linux/bcache-nvm.h |   7 -
 6 files changed, 506 insertions(+), 8 deletions(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index d1ca4d059c20..fdec9905ef40 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -35,3 +35,9 @@ config BCACHE_ASYNC_REGISTRATION
 	device path into this file will returns immediately and the real
 	registration work is handled in kernel work queue in asynchronous
 	way.
+
+config BCACHE_NVM_PAGES
+	bool "NVDIMM support for bcache (EXPERIMENTAL)"
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
index 000000000000..4fa8e2764773
--- /dev/null
+++ b/drivers/md/bcache/nvm-pages.c
@@ -0,0 +1,404 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Nvdimm page-buddy allocator
+ *
+ * Copyright (c) 2021, Intel Corporation.
+ * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
+ * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
+ */
+
+#include "bcache.h"
+#include "nvm-pages.h"
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
+
+#ifdef CONFIG_BCACHE_NVM_PAGES
+
+static const char bch_nvm_pages_magic[] = {
+	0x17, 0xbd, 0x53, 0x7f, 0x1b, 0x23, 0xd6, 0x83,
+	0x46, 0xa4, 0xf8, 0x28, 0x17, 0xda, 0xec, 0xa9 };
+static const char bch_nvm_pages_pgalloc_magic[] = {
+	0x39, 0x25, 0x3f, 0xf7, 0x27, 0x17, 0xd0, 0xb9,
+	0x10, 0xe6, 0xd2, 0xda, 0x38, 0x68, 0x26, 0xae };
+
+struct bch_nvm_set *only_set;
+
+static struct bch_owner_list *alloc_owner_list(const char *owner_uuid,
+		const char *label, int total_namespaces)
+{
+	struct bch_owner_list *owner_list;
+
+	owner_list = kzalloc(sizeof(*owner_list), GFP_KERNEL);
+	if (!owner_list)
+		return NULL;
+
+	owner_list->alloced_recs = kcalloc(total_namespaces,
+			sizeof(struct bch_nvm_alloced_recs *), GFP_KERNEL);
+	if (!owner_list->alloced_recs) {
+		kfree(owner_list);
+		return NULL;
+	}
+
+	if (owner_uuid)
+		memcpy(owner_list->owner_uuid, owner_uuid, 16);
+	if (label)
+		memcpy(owner_list->label, label, BCH_NVM_PAGES_LABEL_SIZE);
+
+	return owner_list;
+}
+
+static void release_extents(struct bch_nvm_alloced_recs *extents)
+{
+	struct list_head *list = extents->extent_head.next;
+	struct bch_extent *extent;
+
+	while (list != &extents->extent_head) {
+		extent = container_of(list, struct bch_extent, list);
+		list_del(list);
+		kfree(extent);
+		list = extents->extent_head.next;
+	}
+	kfree(extents);
+}
+
+static void release_owner_info(struct bch_nvm_set *nvm_set)
+{
+	struct bch_owner_list *owner_list;
+	int i, j;
+
+	for (i = 0; i < nvm_set->owner_list_used; i++) {
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
+static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
+{
+	int i;
+
+	for (i = 0; i < nvm_set->total_namespaces_nr; i++) {
+		blkdev_put(nvm_set->nss[i]->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
+		kfree(nvm_set->nss[i]);
+	}
+
+	kfree(nvm_set->nss);
+}
+
+static void release_nvm_set(struct bch_nvm_set *nvm_set)
+{
+	release_nvm_namespaces(nvm_set);
+	release_owner_info(nvm_set);
+	kfree(nvm_set);
+}
+
+static void *nvm_pgoff_to_vaddr(struct bch_nvm_namespace *ns, pgoff_t pgoff)
+{
+	return ns->kaddr + (pgoff << PAGE_SHIFT);
+}
+
+static int init_owner_info(struct bch_nvm_namespace *ns)
+{
+	struct bch_owner_list_head *owner_list_head;
+	struct bch_nvm_pages_owner_head *owner_head;
+	struct bch_nvm_pgalloc_recs *nvm_pgalloc_recs;
+	struct bch_owner_list *owner_list;
+	struct bch_nvm_alloced_recs *extents;
+	struct bch_extent *extent;
+	u32 i, j, k;
+
+	owner_list_head = (struct bch_owner_list_head *)
+			(ns->kaddr + BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET);
+
+	mutex_lock(&only_set->lock);
+	only_set->owner_list_size = owner_list_head->size;
+	only_set->owner_list_used = owner_list_head->used;
+
+	for (i = 0; i < owner_list_head->used; i++) {
+		owner_head = &owner_list_head->heads[i];
+		owner_list = alloc_owner_list(owner_head->uuid, owner_head->label,
+				only_set->total_namespaces_nr);
+		if (!owner_list) {
+			mutex_unlock(&only_set->lock);
+			return -ENOMEM;
+		}
+
+		for (j = 0; j < only_set->total_namespaces_nr; j++) {
+			if (!only_set->nss[j] || !owner_head->recs[j])
+				continue;
+
+			nvm_pgalloc_recs = (struct bch_nvm_pgalloc_recs *)
+					((long)owner_head->recs[j] + ns->kaddr);
+			if (memcmp(nvm_pgalloc_recs->magic, bch_nvm_pages_pgalloc_magic, 16)) {
+				pr_info("invalid bch_nvmpages_pgalloc_magic\n");
+				mutex_unlock(&only_set->lock);
+				return -EINVAL;
+			}
+
+			extents = kzalloc(sizeof(*extents), GFP_KERNEL);
+			if (!extents) {
+				mutex_unlock(&only_set->lock);
+				return -ENOMEM;
+			}
+
+			extents->ns = only_set->nss[j];
+			INIT_LIST_HEAD(&extents->extent_head);
+			owner_list->alloced_recs[j] = extents;
+
+			do {
+				struct bch_pgalloc_rec *rec;
+
+				for (k = 0; k < nvm_pgalloc_recs->used; k++) {
+					rec = &nvm_pgalloc_recs->recs[k];
+					extent = kzalloc(sizeof(*extent), GFP_KERNEL);
+					if (!extents) {
+						mutex_unlock(&only_set->lock);
+						return -ENOMEM;
+					}
+					extent->kaddr = nvm_pgoff_to_vaddr(extents->ns, rec->pgoff);
+					extent->nr = rec->nr;
+					list_add_tail(&extent->list, &extents->extent_head);
+				}
+				extents->nr += nvm_pgalloc_recs->used;
+
+				if (nvm_pgalloc_recs->next) {
+					nvm_pgalloc_recs = (struct bch_nvm_pgalloc_recs *)
+						((long)nvm_pgalloc_recs->next + ns->kaddr);
+					if (memcmp(nvm_pgalloc_recs->magic,
+						bch_nvm_pages_pgalloc_magic, 16)) {
+						pr_info("invalid bch_nvmpages_pgalloc_magic\n");
+						mutex_unlock(&only_set->lock);
+						return -EINVAL;
+					}
+				} else
+					nvm_pgalloc_recs = NULL;
+			} while (nvm_pgalloc_recs);
+		}
+		only_set->owner_lists[i] = owner_list;
+		owner_list->nvm_set = only_set;
+	}
+	mutex_unlock(&only_set->lock);
+
+	return 0;
+}
+
+static bool attach_nvm_set(struct bch_nvm_namespace *ns)
+{
+	bool rc = true;
+
+	mutex_lock(&only_set->lock);
+	if (only_set->nss) {
+		if (memcmp(ns->sb.set_uuid, only_set->set_uuid, 16)) {
+			pr_info("namespace id does't match nvm set\n");
+			rc = false;
+			goto unlock;
+		}
+
+		if (only_set->nss[ns->sb.this_namespace_nr]) {
+			pr_info("already has the same position(%d) nvm\n",
+					ns->sb.this_namespace_nr);
+			rc = false;
+			goto unlock;
+		}
+	} else {
+		memcpy(only_set->set_uuid, ns->sb.set_uuid, 16);
+		only_set->total_namespaces_nr = ns->sb.total_namespaces_nr;
+		only_set->nss = kcalloc(only_set->total_namespaces_nr,
+				sizeof(struct bch_nvm_namespace *), GFP_KERNEL);
+		only_set->owner_lists = kcalloc(BCH_MAX_OWNER_LIST,
+				sizeof(struct nvm_pages_owner_head *), GFP_KERNEL);
+		if (!only_set->nss || !only_set->owner_lists) {
+			pr_info("can't alloc nss or owner_list\n");
+			kfree(only_set->nss);
+			kfree(only_set->owner_lists);
+			rc = false;
+			goto unlock;
+		}
+	}
+
+	only_set->nss[ns->sb.this_namespace_nr] = ns;
+
+unlock:
+	mutex_unlock(&only_set->lock);
+	return rc;
+}
+
+static int read_nvdimm_meta_super(struct block_device *bdev,
+			      struct bch_nvm_namespace *ns)
+{
+	struct page *page;
+	struct bch_nvm_pages_sb *sb;
+
+	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
+			BCH_NVM_PAGES_SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
+
+	if (IS_ERR(page))
+		return -EIO;
+
+	sb = page_address(page) + offset_in_page(BCH_NVM_PAGES_SB_OFFSET);
+	memcpy(&ns->sb, sb, sizeof(struct bch_nvm_pages_sb));
+
+	put_page(page);
+
+	return 0;
+}
+
+struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
+{
+	struct bch_nvm_namespace *ns;
+	int err;
+	pgoff_t pgoff;
+	char buf[BDEVNAME_SIZE];
+	struct block_device *bdev;
+	uint64_t expected_csum;
+	int id;
+	char *path = NULL;
+
+	path = kstrndup(dev_path, 512, GFP_KERNEL);
+	if (!path) {
+		pr_err("kstrndup failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	bdev = blkdev_get_by_path(strim(path),
+				  FMODE_READ|FMODE_WRITE|FMODE_EXEC,
+				  only_set);
+	if (IS_ERR(bdev)) {
+		pr_info("get %s error\n", dev_path);
+		kfree(path);
+		return ERR_PTR(PTR_ERR(bdev));
+	}
+
+	ns = kmalloc(sizeof(struct bch_nvm_namespace), GFP_KERNEL);
+	if (!ns)
+		goto bdput;
+
+	err = -EIO;
+	if (read_nvdimm_meta_super(bdev, ns)) {
+		pr_info("%s read nvdimm meta super block failed.\n",
+			bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	if (memcmp(ns->sb.magic, bch_nvm_pages_magic, 16)) {
+		pr_info("invalid bch_nvm_pages_magic\n");
+		goto free_ns;
+	}
+
+	if (ns->sb.sb_offset != BCH_NVM_PAGES_SB_OFFSET) {
+		pr_info("invalid superblock offset\n");
+		goto free_ns;
+	}
+
+	if (ns->sb.total_namespaces_nr != 1) {
+		pr_info("only one nvm device\n");
+		goto free_ns;
+	}
+
+	expected_csum = csum_set(&ns->sb);
+	if (expected_csum != ns->sb.csum) {
+		pr_info("csum is not match with expected one\n");
+		goto free_ns;
+	}
+
+	err = -EOPNOTSUPP;
+	if (!bdev_dax_supported(bdev, ns->sb.page_size)) {
+		pr_info("%s don't support DAX\n", bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	err = -EINVAL;
+	if (bdev_dax_pgoff(bdev, 0, ns->sb.page_size, &pgoff)) {
+		pr_info("invalid offset of %s\n", bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	err = -ENOMEM;
+	ns->dax_dev = fs_dax_get_by_bdev(bdev);
+	if (!ns->dax_dev) {
+		pr_info("can't by dax device by %s\n", bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	err = -EINVAL;
+	id = dax_read_lock();
+	if (dax_direct_access(ns->dax_dev, pgoff, ns->sb.pages_total,
+			      &ns->kaddr, &ns->start_pfn) <= 0) {
+		pr_info("dax_direct_access error\n");
+		dax_read_unlock(id);
+		goto free_ns;
+	}
+	dax_read_unlock(id);
+
+
+	err = -EEXIST;
+	if (!attach_nvm_set(ns))
+		goto free_ns;
+
+	ns->page_size = ns->sb.page_size;
+	ns->pages_offset = ns->sb.pages_offset;
+	ns->pages_total = ns->sb.pages_total;
+	ns->free = 0;
+	ns->bdev = bdev;
+	ns->nvm_set = only_set;
+
+	mutex_init(&ns->lock);
+
+	if (ns->sb.this_namespace_nr == 0) {
+		pr_info("only first namespace contain owner info\n");
+		err = init_owner_info(ns);
+		if (err < 0) {
+			pr_info("init_owner_info met error %d\n", err);
+			goto free_ns;
+		}
+	}
+
+	kfree(path);
+	return ns;
+free_ns:
+	kfree(ns);
+bdput:
+	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
+	kfree(path);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(bch_register_namespace);
+
+int __init bch_nvm_init(void)
+{
+	only_set = kzalloc(sizeof(*only_set), GFP_KERNEL);
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
+
+#endif
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
new file mode 100644
index 000000000000..1b10b4b6db0f
--- /dev/null
+++ b/drivers/md/bcache/nvm-pages.h
@@ -0,0 +1,92 @@
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
+struct bch_extent {
+	void *kaddr;
+	u32 nr;
+	struct list_head list;
+};
+
+struct bch_nvm_alloced_recs {
+	u32  nr;
+	struct bch_nvm_namespace *ns;
+	struct list_head extent_head;
+};
+
+struct bch_owner_list {
+	u8  owner_uuid[16];
+	char label[BCH_NVM_PAGES_LABEL_SIZE];
+
+	struct bch_nvm_set *nvm_set;
+	struct bch_nvm_alloced_recs **alloced_recs;
+};
+
+struct bch_nvm_namespace {
+	struct bch_nvm_pages_sb sb;
+	void *kaddr;
+
+	u8 uuid[16];
+	u64 free;
+	u32 page_size;
+	u64 pages_offset;
+	u64 pages_total;
+	pfn_t start_pfn;
+
+	struct dax_device *dax_dev;
+	struct block_device *bdev;
+	struct bch_nvm_set *nvm_set;
+
+	struct mutex lock;
+};
+
+/*
+ * A set of namespaces. Currently only one set can be supported.
+ */
+struct bch_nvm_set {
+	u8 set_uuid[16];
+	u32 total_namespaces_nr;
+
+	u32 owner_list_size;
+	u32 owner_list_used;
+	struct bch_owner_list **owner_lists;
+
+	struct bch_nvm_namespace **nss;
+
+	struct mutex lock;
+};
+extern struct bch_nvm_set *only_set;
+
+#ifdef CONFIG_BCACHE_NVM_PAGES
+
+struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
+int bch_nvm_init(void);
+void bch_nvm_exit(void);
+
+#else
+
+static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
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
index 0228ccb293fc..915f1ea4dfd9 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -14,6 +14,7 @@
 #include "request.h"
 #include "writeback.h"
 #include "features.h"
+#include "nvm-pages.h"
 
 #include <linux/blkdev.h>
 #include <linux/debugfs.h>
@@ -2816,6 +2817,7 @@ static void bcache_exit(void)
 {
 	bch_debug_exit();
 	bch_request_exit();
+	bch_nvm_exit();
 	if (bcache_kobj)
 		kobject_put(bcache_kobj);
 	if (bcache_wq)
@@ -2914,6 +2916,7 @@ static int __init bcache_init(void)
 
 	bch_debug_init();
 	closure_debug_init();
+	bch_nvm_init();
 
 	bcache_is_reboot = false;
 
diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
index 61108bf2a63e..0a6dc4a6e470 100644
--- a/include/uapi/linux/bcache-nvm.h
+++ b/include/uapi/linux/bcache-nvm.h
@@ -99,13 +99,6 @@
 #define BCH_NVM_PAGES_SB_VERSION		0
 #define BCH_NVM_PAGES_SB_VERSION_MAX		0
 
-static const char bch_nvm_pages_magic[] = {
-	0x17, 0xbd, 0x53, 0x7f, 0x1b, 0x23, 0xd6, 0x83,
-	0x46, 0xa4, 0xf8, 0x28, 0x17, 0xda, 0xec, 0xa9 };
-static const char bch_nvm_pages_pgalloc_magic[] = {
-	0x39, 0x25, 0x3f, 0xf7, 0x27, 0x17, 0xd0, 0xb9,
-	0x10, 0xe6, 0xd2, 0xda, 0x38, 0x68, 0x26, 0xae };
-
 struct bch_pgalloc_rec {
 	__u32			pgoff;
 	__u32			nr;
-- 
2.26.2


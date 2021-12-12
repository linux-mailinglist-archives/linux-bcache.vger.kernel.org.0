Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3830D471BBA
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhLLRGR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:17 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54904 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhLLRGR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:17 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9CED1212B5;
        Sun, 12 Dec 2021 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7PATU2+1T8MxJULpFLGSDwYRqljjBBWx8HiMrzCCWs=;
        b=HmkUhtjkEi1PGdfqc1rmmz+MtYq4cGzazMrDeArAOOPpefS3EfwbyYadMozBssqJmQbto9
        FzFW9y27F1A4Mt99Zv7KWUmPuB9fhu/9naFNOGANg4seljPBXGn/L6TAgDwLcKqimpua78
        cZfJFFPu7mpd+lgHfAIjNtuCTjNJQsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328775;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7PATU2+1T8MxJULpFLGSDwYRqljjBBWx8HiMrzCCWs=;
        b=U5KCrVV7GNGS/up0LtWOUHwVwQQIFIdCqinBbHW9HHdVOMmJmKhLnPgpBasHL5borbRx6y
        1DrwEt6/uMiFq1CQ==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id D03DBA3B81;
        Sun, 12 Dec 2021 17:06:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v13 02/12] bcache: initialize the nvm pages allocator
Date:   Mon, 13 Dec 2021 01:05:42 +0800
Message-Id: <20211212170552.2812-3-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch define the prototype data structures in memory and
initializes the nvm pages allocator.

The nvm address space which is managed by this allocator can consist of
many nvm namespaces, and some namespaces can compose into one nvm set,
like cache set. For this initial implementation, only one set can be
supported.

The users of this nvm pages allocator need to call register_namespace()
to register the nvdimm device (like /dev/pmemX) into this allocator as
the instance of struct nvm_namespace.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/md/bcache/Kconfig  |  10 ++
 drivers/md/bcache/Makefile |   1 +
 drivers/md/bcache/nvmpg.c  | 340 +++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvmpg.h  |  97 +++++++++++
 drivers/md/bcache/super.c  |   3 +
 5 files changed, 451 insertions(+)
 create mode 100644 drivers/md/bcache/nvmpg.c
 create mode 100644 drivers/md/bcache/nvmpg.h

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index cf3e8096942a..4a7c13e882bb 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -36,3 +36,13 @@ config BCACHE_ASYNC_REGISTRATION
 	device path into this file will returns immediately and the real
 	registration work is handled in kernel work queue in asynchronous
 	way.
+
+config BCACHE_NVM_PAGES
+	bool "NVDIMM support for bcache (EXPERIMENTAL)"
+	depends on BCACHE
+	depends on 64BIT
+	depends on LIBNVDIMM
+	depends on DAX
+	help
+	  Allocate/release NV-memory pages for bcache and provide allocated pages
+	  for each requestor after system reboot.
diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index 5b87e59676b8..276b33be5ad5 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
 bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
 	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
 	util.o writeback.o features.o
+bcache-$(CONFIG_BCACHE_NVM_PAGES) += nvmpg.o
diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
new file mode 100644
index 000000000000..b654bbbda03e
--- /dev/null
+++ b/drivers/md/bcache/nvmpg.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Nvdimm page-buddy allocator
+ *
+ * Copyright (c) 2021, Intel Corporation.
+ * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
+ * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
+ */
+
+#include "bcache.h"
+#include "nvmpg.h"
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
+struct bch_nvmpg_set *global_nvmpg_set;
+
+void *bch_nvmpg_offset_to_ptr(unsigned long offset)
+{
+	int ns_id = BCH_NVMPG_GET_NS_ID(offset);
+	struct bch_nvmpg_ns *ns = global_nvmpg_set->ns_tbl[ns_id];
+
+	if (offset == 0)
+		return NULL;
+
+	ns_id = BCH_NVMPG_GET_NS_ID(offset);
+	ns = global_nvmpg_set->ns_tbl[ns_id];
+
+	if (ns)
+		return (void *)(ns->base_addr + BCH_NVMPG_GET_OFFSET(offset));
+
+	pr_err("Invalid ns_id %u\n", ns_id);
+	return NULL;
+}
+
+unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
+{
+	int ns_id = ns->ns_id;
+	unsigned long offset = (unsigned long)(ptr - ns->base_addr);
+
+	return BCH_NVMPG_OFFSET(ns_id, offset);
+}
+
+static void release_ns_tbl(struct bch_nvmpg_set *set)
+{
+	int i;
+	struct bch_nvmpg_ns *ns;
+
+	for (i = 0; i < BCH_NVMPG_NS_MAX; i++) {
+		ns = set->ns_tbl[i];
+		if (ns) {
+			fs_put_dax(ns->dax_dev);
+			blkdev_put(ns->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
+			set->ns_tbl[i] = NULL;
+			set->attached_ns--;
+			kfree(ns);
+		}
+	}
+
+	if (set->attached_ns)
+		pr_err("unexpected attached_ns: %u\n", set->attached_ns);
+}
+
+static void release_nvmpg_set(struct bch_nvmpg_set *set)
+{
+	release_ns_tbl(set);
+	kfree(set);
+}
+
+/* Namespace 0 contains all meta data of the nvmpg allocation set */
+static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
+{
+	struct bch_nvmpg_set_header *set_header;
+
+	if (ns->ns_id != 0) {
+		pr_err("unexpected ns_id %u for first nvmpg namespace.\n",
+		       ns->ns_id);
+		return -EINVAL;
+	}
+
+	set_header = bch_nvmpg_offset_to_ptr(ns->sb->set_header_offset);
+
+	mutex_lock(&global_nvmpg_set->lock);
+	global_nvmpg_set->set_header = set_header;
+	global_nvmpg_set->heads_size = set_header->size;
+	global_nvmpg_set->heads_used = set_header->used;
+	mutex_unlock(&global_nvmpg_set->lock);
+
+	return 0;
+}
+
+static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
+{
+	struct bch_nvmpg_sb *sb = ns->sb;
+	int rc = 0;
+
+	mutex_lock(&global_nvmpg_set->lock);
+
+	if (global_nvmpg_set->ns_tbl[sb->this_ns]) {
+		pr_err("ns_id %u already attached.\n", ns->ns_id);
+		rc = -EEXIST;
+		goto unlock;
+	}
+
+	if (ns->ns_id != 0) {
+		pr_err("unexpected ns_id %u for first namespace.\n", ns->ns_id);
+		rc = -EINVAL;
+		goto unlock;
+	}
+
+	if (global_nvmpg_set->attached_ns > 0) {
+		pr_err("multiple namespace attaching not supported yet\n");
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	if ((global_nvmpg_set->attached_ns + 1) > sb->total_ns) {
+		pr_err("namespace counters error: attached %u > total %u\n",
+		       global_nvmpg_set->attached_ns,
+		       global_nvmpg_set->total_ns);
+		rc = -EINVAL;
+		goto unlock;
+	}
+
+	memcpy(global_nvmpg_set->set_uuid, sb->set_uuid, 16);
+	global_nvmpg_set->ns_tbl[sb->this_ns] = ns;
+	global_nvmpg_set->attached_ns++;
+	global_nvmpg_set->total_ns = sb->total_ns;
+
+unlock:
+	mutex_unlock(&global_nvmpg_set->lock);
+	return rc;
+}
+
+static int read_nvdimm_meta_super(struct block_device *bdev,
+				  struct bch_nvmpg_ns *ns)
+{
+	struct page *page;
+	struct bch_nvmpg_sb *sb;
+	uint64_t expected_csum = 0;
+	int r;
+
+	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
+				BCH_NVMPG_SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
+
+	if (IS_ERR(page))
+		return -EIO;
+
+	sb = (struct bch_nvmpg_sb *)
+	     (page_address(page) + offset_in_page(BCH_NVMPG_SB_OFFSET));
+
+	r = -EINVAL;
+	expected_csum = csum_set(sb);
+	if (expected_csum != sb->csum) {
+		pr_info("csum is not match with expected one\n");
+		goto put_page;
+	}
+
+	if (memcmp(sb->magic, bch_nvmpg_magic, 16)) {
+		pr_info("invalid bch_nvmpg_magic\n");
+		goto put_page;
+	}
+
+	if (sb->sb_offset !=
+	    BCH_NVMPG_OFFSET(sb->this_ns, BCH_NVMPG_SB_OFFSET)) {
+		pr_info("invalid superblock offset 0x%llx\n", sb->sb_offset);
+		goto put_page;
+	}
+
+	r = -EOPNOTSUPP;
+	if (sb->total_ns != 1) {
+		pr_info("multiple name space not supported yet.\n");
+		goto put_page;
+	}
+
+
+	r = 0;
+	/* Necessary for DAX mapping */
+	ns->page_size = sb->page_size;
+	ns->pages_total = sb->pages_total;
+
+put_page:
+	put_page(page);
+	return r;
+}
+
+struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
+{
+	struct bch_nvmpg_ns *ns = NULL;
+	struct bch_nvmpg_sb *sb = NULL;
+	char buf[BDEVNAME_SIZE];
+	struct block_device *bdev;
+	pgoff_t pgoff;
+	int id, err;
+	char *path;
+	long dax_ret = 0;
+
+	path = kstrndup(dev_path, 512, GFP_KERNEL);
+	if (!path) {
+		pr_err("kstrndup failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	bdev = blkdev_get_by_path(strim(path),
+				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
+				  global_nvmpg_set);
+	if (IS_ERR(bdev)) {
+		pr_err("get %s error: %ld\n", dev_path, PTR_ERR(bdev));
+		kfree(path);
+		return ERR_PTR(PTR_ERR(bdev));
+	}
+
+	err = -ENOMEM;
+	ns = kzalloc(sizeof(struct bch_nvmpg_ns), GFP_KERNEL);
+	if (!ns)
+		goto bdput;
+
+	err = -EIO;
+	if (read_nvdimm_meta_super(bdev, ns)) {
+		pr_err("%s read nvdimm meta super block failed.\n",
+		       bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	err = -EOPNOTSUPP;
+	ns->dax_dev = fs_dax_get_by_bdev(bdev);
+	if (!ns->dax_dev) {
+		pr_err("can't get dax device by %s\n", bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	if (!dax_supported(ns->dax_dev, bdev, ns->page_size, 0,
+			   bdev_nr_sectors(bdev))) {
+		pr_err("%s don't support DAX\n", bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	err = -EINVAL;
+	if (bdev_dax_pgoff(bdev, 0, ns->page_size, &pgoff)) {
+		pr_err("invalid offset of %s\n", bdevname(bdev, buf));
+		goto free_ns;
+	}
+
+	err = -EINVAL;
+	id = dax_read_lock();
+	dax_ret = dax_direct_access(ns->dax_dev, pgoff, ns->pages_total,
+				    &ns->base_addr, &ns->start_pfn);
+	if (dax_ret <= 0) {
+		pr_err("dax_direct_access error\n");
+		dax_read_unlock(id);
+		goto free_ns;
+	}
+
+	if (dax_ret < ns->pages_total) {
+		pr_warn("currently first %ld pages (from %lu in total) are used\n",
+			dax_ret, ns->pages_total);
+	}
+	dax_read_unlock(id);
+
+	sb = (struct bch_nvmpg_sb *)(ns->base_addr + BCH_NVMPG_SB_OFFSET);
+
+	err = -EINVAL;
+	/* Check magic again to make sure DAX mapping is correct */
+	if (memcmp(sb->magic, bch_nvmpg_magic, 16)) {
+		pr_err("invalid bch_nvmpg_magic after DAX mapping\n");
+		goto free_ns;
+	}
+
+	if ((global_nvmpg_set->attached_ns > 0) &&
+	     memcmp(sb->set_uuid, global_nvmpg_set->set_uuid, 16)) {
+		pr_err("set uuid does not match with ns_id %u\n", ns->ns_id);
+		goto free_ns;
+	}
+
+	if (sb->set_header_offset !=
+	    BCH_NVMPG_OFFSET(sb->this_ns, BCH_NVMPG_RECLIST_HEAD_OFFSET)) {
+		pr_err("Invalid header offset: this_ns %u, ns_id %llu, offset 0x%llx\n",
+		       sb->this_ns,
+		       BCH_NVMPG_GET_NS_ID(sb->set_header_offset),
+		       BCH_NVMPG_GET_OFFSET(sb->set_header_offset));
+		goto free_ns;
+	}
+
+	ns->page_size = sb->page_size;
+	ns->pages_offset = sb->pages_offset;
+	ns->pages_total = sb->pages_total;
+	ns->sb = sb;
+	ns->free = 0;
+	ns->bdev = bdev;
+	ns->set = global_nvmpg_set;
+
+	err = attach_nvmpg_set(ns);
+	if (err < 0)
+		goto free_ns;
+
+	mutex_init(&ns->lock);
+
+	err = init_nvmpg_set_header(ns);
+	if (err < 0)
+		goto free_ns;
+
+	kfree(path);
+	return ns;
+
+free_ns:
+	fs_put_dax(ns->dax_dev);
+	kfree(ns);
+bdput:
+	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
+	kfree(path);
+	return ERR_PTR(err);
+}
+
+int __init bch_nvmpg_init(void)
+{
+	global_nvmpg_set = kzalloc(sizeof(*global_nvmpg_set), GFP_KERNEL);
+	if (!global_nvmpg_set)
+		return -ENOMEM;
+
+	global_nvmpg_set->total_ns = 0;
+	mutex_init(&global_nvmpg_set->lock);
+
+	pr_info("bcache nvm init\n");
+	return 0;
+}
+
+void bch_nvmpg_exit(void)
+{
+	release_nvmpg_set(global_nvmpg_set);
+	pr_info("bcache nvm exit\n");
+}
diff --git a/drivers/md/bcache/nvmpg.h b/drivers/md/bcache/nvmpg.h
new file mode 100644
index 000000000000..698c890b2d15
--- /dev/null
+++ b/drivers/md/bcache/nvmpg.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _BCACHE_NVM_PAGES_H
+#define _BCACHE_NVM_PAGES_H
+
+#include <linux/libnvdimm.h>
+
+#include "nvmpg_format.h"
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
+struct bch_nvmpg_ns {
+	struct bch_nvmpg_sb *sb;
+	void *base_addr;
+
+	unsigned char uuid[16];
+	int ns_id;
+	unsigned int page_size;
+	unsigned long free;
+	unsigned long pages_offset;
+	unsigned long pages_total;
+	pfn_t start_pfn;
+
+	struct dax_device *dax_dev;
+	struct block_device *bdev;
+	struct bch_nvmpg_set *set;
+
+	struct mutex lock;
+};
+
+/*
+ * A set of namespaces. Currently only one set can be supported.
+ */
+struct bch_nvmpg_set {
+	unsigned char set_uuid[16];
+
+	int heads_size;
+	int heads_used;
+	struct bch_nvmpg_set_header *set_header;
+
+	struct bch_nvmpg_ns *ns_tbl[BCH_NVMPG_NS_MAX];
+	int total_ns;
+	int attached_ns;
+
+	struct mutex lock;
+};
+
+#define BCH_NVMPG_NS_ID_BITS	3
+#define BCH_NVMPG_OFFSET_BITS	61
+#define BCH_NVMPG_NS_ID_MASK	((1UL<<BCH_NVMPG_NS_ID_BITS) - 1)
+#define BCH_NVMPG_OFFSET_MASK	((1UL<<BCH_NVMPG_OFFSET_BITS) - 1)
+
+#define BCH_NVMPG_GET_NS_ID(offset)					\
+	(((offset) >> BCH_NVMPG_OFFSET_BITS) & BCH_NVMPG_NS_ID_MASK)
+
+#define BCH_NVMPG_GET_OFFSET(offset)	((offset) & BCH_NVMPG_OFFSET_MASK)
+
+#define BCH_NVMPG_OFFSET(ns_id, offset)					\
+	((((ns_id) & BCH_NVMPG_NS_ID_MASK) << BCH_NVMPG_OFFSET_BITS) |	\
+	 ((offset) & BCH_NVMPG_OFFSET_MASK))
+
+/* Indicate which field in bch_nvmpg_sb to be updated */
+#define BCH_NVMPG_TOTAL_NS	0	/* total_ns */
+
+void *bch_nvmpg_offset_to_ptr(unsigned long offset);
+unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr);
+
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+
+struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path);
+int bch_nvmpg_init(void);
+void bch_nvmpg_exit(void);
+
+#else
+
+static inline struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
+{
+	return NULL;
+}
+
+static inline int bch_nvmpg_init(void)
+{
+	return 0;
+}
+
+static inline void bch_nvmpg_exit(void) { }
+
+#endif /* CONFIG_BCACHE_NVM_PAGES */
+
+#endif /* _BCACHE_NVM_PAGES_H */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 86b9e355c583..74d51a0b806f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -14,6 +14,7 @@
 #include "request.h"
 #include "writeback.h"
 #include "features.h"
+#include "nvmpg.h"
 
 #include <linux/blkdev.h>
 #include <linux/pagemap.h>
@@ -2818,6 +2819,7 @@ static void bcache_exit(void)
 {
 	bch_debug_exit();
 	bch_request_exit();
+	bch_nvmpg_exit();
 	if (bcache_kobj)
 		kobject_put(bcache_kobj);
 	if (bcache_wq)
@@ -2916,6 +2918,7 @@ static int __init bcache_init(void)
 
 	bch_debug_init();
 	closure_debug_init();
+	bch_nvmpg_init();
 
 	bcache_is_reboot = false;
 
-- 
2.31.1


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EAE2E192C
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgLWHAv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:00:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:58035 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgLWHAv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:00:51 -0500
IronPort-SDR: Ed3EEoTcgh4Coa5ruI7dHjaI3io0rfC/1C1o0PXv7LS06BggOXfZ9QH010oZh1OyQKhFVWrOb9
 QRPPzqw8Q0DA==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="163695073"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="163695073"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:00:08 -0800
IronPort-SDR: LpnBAyhSMIJ3Cyhc4OnW2xUbkbLWPrPKSGhj5ET1ZwbEbiRwWWeuh9vwMy5rRUWyyXwKmp53oU
 lOoqIGV322Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="344924223"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 22 Dec 2020 23:00:07 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH 1/8] bcache: add initial data structures for nvm pages
Date:   Wed, 23 Dec 2020 09:41:29 -0500
Message-Id: <20201223144136.24966-2-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144136.24966-1-qiaowei.ren@intel.com>
References: <20201223144136.24966-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch initializes the prototype data structures for nvm pages
allocator,

- struct nvm_pages_sb
This is the super block allocated on each nvmdimm name space. A nvdimm
set may have multiple namespaces, nvm_pages_sb->set_uuid is used to mark
which nvmdimm set this name space belongs to. Normally we will use the
bcache's cache set UUID to initialize this uuid, to connect this nvdimm
set to a specified bcache cache set.

- struct owner_list_head
This is a table for all heads of all owner lists. A owner list records
which page(s) allocated to which owner. After reboot from power failure,
the ownwer may find all its requested and allocated pages from the owner
list by a handler which is converted by a UUID.

- struct nvm_pages_owner_head
This is a head of an owner list. Each owner only has one owner list,
and a nvm page only belongs to an specific owner. uuid[] will be set to
owner's uuid, for bcache it is the bcache's cache set uuid. label is not
mandatory, it is a human-readable string for debug purpose. The pointer
*recs references to separated nvm page which hold the table of struct
nvm_pgalloc_rec.

- struct nvm_pgalloc_recs
This structure occupies a whole page, owner_uuid should match the uuid
in struct nvm_pages_owner_head. recs[] is the real table contains all
allocated records.

- struct nvm_pgalloc_rec
Each structure records a range of allocated nvm pages. pgoff is offset
in unit of page size of this allocated nvm page range. The adjoint page
ranges of same owner can be merged into a larger one, therefore pages_nr
is NOT always power of 2.

Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 include/uapi/linux/bcache-nvm.h | 184 ++++++++++++++++++++++++++++++++
 1 file changed, 184 insertions(+)
 create mode 100644 include/uapi/linux/bcache-nvm.h

diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
new file mode 100644
index 000000000000..a3a8cdfc7096
--- /dev/null
+++ b/include/uapi/linux/bcache-nvm.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_BCACHE_NVM_H
+#define _UAPI_BCACHE_NVM_H
+
+/*
+ * Bcache on NVDIMM data structures
+ */
+
+/*
+ * - struct nvm_pages_sb
+ *   This is the super block allocated on each nvdimm name space. A nvdimm
+ * set may have multiple namespaces, nvm_pages_sb->set_uuid is used to mark
+ * which nvdimm set this name space belongs to. Normally we will use the
+ * bcache's cache set UUID to initialize this uuid, to connect this nvdimm
+ * set to a specified bcache cache set.
+ *
+ * - struct owner_list_head
+ *   This is a table for all heads of all owner lists. A owner list records
+ * which page(s) allocated to which owner. After reboot from power failure,
+ * the ownwer may find all its requested and allocated pages from the owner
+ * list by a handler which is converted by a UUID.
+ *
+ * - struct nvm_pages_owner_head
+ *   This is a head of an owner list. Each owner only has one owner list,
+ * and a nvm page only belongs to an specific owner. uuid[] will be set to
+ * owner's uuid, for bcache it is the bcache's cache set uuid. label is not
+ * mandatory, it is a human-readable string for debug purpose. The pointer
+ * recs references to separated nvm page which hold the table of struct
+ * nvm_pgalloc_rec.
+ *
+ *- struct nvm_pgalloc_recs
+ *  This structure occupies a whole page, owner_uuid should match the uuid
+ * in struct nvm_pages_owner_head. recs[] is the real table contains all
+ * allocated records.
+ *
+ * - struct nvm_pgalloc_rec
+ *   Each structure records a range of allocated nvm pages. pgoff is offset
+ * in unit of page size of this allocated nvm page range. The adjoint page
+ * ranges of same owner can be merged into a larger one, therefore pages_nr
+ * is NOT always power of 2.
+ *
+ *
+ * Memory layout on nvdimm namespace 0
+ *
+ *    0 +---------------------------------+
+ *      |                                 |
+ *  4KB +---------------------------------+
+ *      |         nvme_pages_sb           |
+ *  8KB +---------------------------------+ <--- nvme_pages_sb.owner_list_head
+ *      |       owner_list_head           |
+ *      |                                 |
+ * 16KB +---------------------------------+ <--- owner_list_head.heads[0].recs[0]
+ *      |       nvm_pgalloc_recs          |
+ *      |  (nvm pages internal usage)     |
+ * 24KB +---------------------------------+
+ *      |                                 |
+ *      |                                 |
+ * 1MB  +---------------------------------+
+ *      |      allocable nvm pages        |
+ *      |      for buddy allocator        |
+ * end  +---------------------------------+
+ *
+ *
+ *
+ * Memory layout on nvdimm namespace N
+ * (doesn't have owner list)
+ *
+ *    0 +---------------------------------+
+ *      |                                 |
+ *  4KB +---------------------------------+
+ *      |         nvme_pages_sb           |
+ *  8KB +---------------------------------+
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ * 1MB  +---------------------------------+
+ *      |      allocable nvm pages        |
+ *      |      for buddy allocator        |
+ * end  +---------------------------------+
+ *
+ */
+
+#include <linux/types.h>
+
+/* In sectors */
+#define NVM_PAGES_SB_OFFSET			4096
+#define NVM_PAGES_OFFSET			(1 << 20)
+#define NVM_PAGES_NAMESPACE_SIZE		(250UL << 30)
+
+#define NVM_PAGES_LABEL_SIZE			32
+#define NVM_PAGES_NAMESPACES_MAX		8
+
+#define NVM_PAGES_OWNER_LIST_HEAD_OFFSET	(8<<10)
+#define NVM_PAGES_SYS_RECS_HEAD_OFFSET		(16<<10)
+
+#define NVM_PAGES_SB_VERSION			0
+#define NVM_PAGES_SB_VERSION_MAX		0
+
+static const char nvm_pages_magic[] = {
+	0x17, 0xbd, 0x53, 0x7f, 0x1b, 0x23, 0xd6, 0x83,
+	0x46, 0xa4, 0xf8, 0x28, 0x17, 0xda, 0xec, 0xa9 };
+static const char nvm_pages_pgalloc_magic[] = {
+	0x39, 0x25, 0x3f, 0xf7, 0x27, 0x17, 0xd0, 0xb9,
+	0x10, 0xe6, 0xd2, 0xda, 0x38, 0x68, 0x26, 0xae };
+
+struct nvm_pgalloc_rec {
+	__u32			pgoff;
+	__u32			nr;
+};
+
+struct nvm_pgalloc_recs {
+union {
+	struct {
+		struct nvm_pages_owner_head	*owner;
+		struct nvm_pgalloc_recs		*next;
+		__u8				magic[16];
+		__u8				owner_uuid[16];
+		__u32				size;
+		struct nvm_pgalloc_rec		recs[];
+	};
+	__u8	pad[8192];
+};
+};
+#define MAX_RECORD					\
+	((sizeof(struct nvm_pgalloc_recs) -		\
+	 offsetof(struct nvm_pgalloc_recs, recs)) /	\
+	 sizeof(struct nvm_pgalloc_rec))
+
+struct nvm_pages_owner_head {
+	__u8			uuid[16];
+	char			label[NVM_PAGES_LABEL_SIZE];
+	/* Per-namespace own lists */
+	struct nvm_pgalloc_recs	*recs[NVM_PAGES_NAMESPACES_MAX];
+};
+
+/* heads[0] is always for nvm_pages internal usage */
+struct owner_list_head {
+union {
+	struct {
+		__u32				size;
+		struct nvm_pages_owner_head	heads[];
+	};
+	__u8	pad[8192];
+};
+};
+#define MAX_OWNER_LIST					\
+	((sizeof(struct owner_list_head) -		\
+	 offsetof(struct owner_list_head, heads)) /	\
+	 sizeof(struct nvm_pages_owner_head))
+
+/* The on-media bit order is local CPU order */
+struct nvm_pages_sb {
+	__u64			csum;
+	__u64			sb_offset;
+	__u64			version;
+	__u8			magic[16];
+	__u8			uuid[16];
+	__u32			page_size;
+	__u32			total_namespaces_nr;
+	__u32			this_namespace_nr;
+	union {
+		__u8		set_uuid[16];
+		__u64		set_magic;
+	};
+
+	__u64			flags;
+	__u64			seq;
+
+	__u64			feature_compat;
+	__u64			feature_incompat;
+	__u64			feature_ro_compat;
+
+	/* For allocable nvm pages from buddy systems */
+	__u64			pages_offset;
+	__u64			pages_total;
+
+	/* Only on the first name space */
+	struct owner_list_head	*owner_list_head;
+};
+
+#endif /* _UAPI_BCACHE_NVM_H */
-- 
2.17.1


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389852CCD0F
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 04:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgLCDK6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 22:10:58 -0500
Received: from mga07.intel.com ([134.134.136.100]:1945 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgLCDK6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 22:10:58 -0500
IronPort-SDR: unr5kzqah+G/0/Rz244NDwM04B+Lh875K8QqFYSHr3+zQ/ALF2BZR7jR/8Vf9oDcDGK7tG/3AP
 vtbnIW4r7vsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="237248530"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="237248530"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 19:10:17 -0800
IronPort-SDR: pHy+bFGAV/FxNyGlL8wEzrsPaFY2N69kcdKQw0JgH60DF7qK8IpG4JzIRcvLtA8oqZ3aS0okKL
 w88yXZ5wKt5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="481801493"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2020 19:10:16 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Subject: [RFC PATCH 1/8] bcache: add initial data structures for nvm pages
Date:   Thu,  3 Dec 2020 05:53:30 -0500
Message-Id: <20201203105337.4592-2-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203105337.4592-1-qiaowei.ren@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
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


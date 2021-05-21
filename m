Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE8A38C096
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 09:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhEUHVV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 03:21:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:16559 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhEUHVV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 03:21:21 -0400
IronPort-SDR: inLw+7Sx3O7b+gFscFZZsdh0zatxWswMpMcvqNki1lhubgr4VE+MaVTdMBC6BA1XFyq1vl+wi7
 2GLVTqsgiCKg==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="199484318"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="199484318"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 00:19:58 -0700
IronPort-SDR: A3OTOuKNGizc93KTfuInRYblLhzxeLcQkL6M+09F7pncX85uqwKtRi0S/7F2RWPYQfNfnLGENi
 I7SKR4JM3pvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440817114"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2021 00:19:57 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     linux-bcache@vger.kernel.org
Cc:     qiaowei.ren@intel.com, jianpeng.ma@intel.com, colyli@suse.de,
        rdunlap@infradead.oom
Subject: [bch-nvm-pages v10 1/6] bcache: add initial data structures for nvm pages
Date:   Fri, 21 May 2021 10:57:21 -0400
Message-Id: <20210521145726.154276-2-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210521145726.154276-1-qiaowei.ren@intel.com>
References: <20210521145726.154276-1-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

This patch initializes the prototype data structures for nvm pages
allocator,

- struct bch_nvm_pages_sb
This is the super block allocated on each nvdimm namespace. A nvdimm
set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used
to mark which nvdimm set this name space belongs to. Normally we will
use the bcache's cache set UUID to initialize this uuid, to connect this
nvdimm set to a specified bcache cache set.

- struct bch_owner_list_head
This is a table for all heads of all owner lists. A owner list records
which page(s) allocated to which owner. After reboot from power failure,
the ownwer may find all its requested and allocated pages from the owner
list by a handler which is converted by a UUID.

- struct bch_nvm_pages_owner_head
This is a head of an owner list. Each owner only has one owner list,
and a nvm page only belongs to an specific owner. uuid[] will be set to
owner's uuid, for bcache it is the bcache's cache set uuid. label is not
mandatory, it is a human-readable string for debug purpose. The pointer
*recs references to separated nvm page which hold the table of struct
bch_nvm_pgalloc_rec.

- struct bch_nvm_pgalloc_recs
This struct occupies a whole page, owner_uuid should match the uuid
in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
allocated records.

- struct bch_nvm_pgalloc_rec
Each structure records a range of allocated nvm pages.
  - Bits  0 - 51: is pages offset of the allocated pages.
  - Bits 52 - 57: allocaed size in page_size * order-of-2
  - Bits 58 - 63: reserved.
Since each of the allocated nvm pages are power of 2, using 6 bits to
represent allocated size can have (1<<(1<<64) - 1) * PAGE_SIZE maximum
value. It can be a 76 bits width range size in byte for 4KB page size,
which is large enough currently.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 include/uapi/linux/bcache-nvm.h | 200 ++++++++++++++++++++++++++++++++
 1 file changed, 200 insertions(+)
 create mode 100644 include/uapi/linux/bcache-nvm.h

diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
new file mode 100644
index 000000000000..1d62e9f0d4bf
--- /dev/null
+++ b/include/uapi/linux/bcache-nvm.h
@@ -0,0 +1,200 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI_BCACHE_NVM_H
+#define _UAPI_BCACHE_NVM_H
+
+#ifdef CONFIG_64BIT
+/*
+ * Bcache on NVDIMM data structures
+ */
+
+/*
+ * - struct bch_nvm_pages_sb
+ *   This is the super block allocated on each nvdimm namespace. A nvdimm
+ * set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used to mark
+ * which nvdimm set this name space belongs to. Normally we will use the
+ * bcache's cache set UUID to initialize this uuid, to connect this nvdimm
+ * set to a specified bcache cache set.
+ *
+ * - struct bch_owner_list_head
+ *   This is a table for all heads of all owner lists. A owner list records
+ * which page(s) allocated to which owner. After reboot from power failure,
+ * the ownwer may find all its requested and allocated pages from the owner
+ * list by a handler which is converted by a UUID.
+ *
+ * - struct bch_nvm_pages_owner_head
+ *   This is a head of an owner list. Each owner only has one owner list,
+ * and a nvm page only belongs to an specific owner. uuid[] will be set to
+ * owner's uuid, for bcache it is the bcache's cache set uuid. label is not
+ * mandatory, it is a human-readable string for debug purpose. The pointer
+ * recs references to separated nvm page which hold the table of struct
+ * bch_pgalloc_rec.
+ *
+ *- struct bch_nvm_pgalloc_recs
+ *  This structure occupies a whole page, owner_uuid should match the uuid
+ * in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
+ * allocated records.
+ *
+ * - struct bch_pgalloc_rec
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
+ *      |         bch_nvm_pages_sb        |
+ *  8KB +---------------------------------+ <--- bch_nvm_pages_sb.bch_owner_list_head
+ *      |       bch_owner_list_head       |
+ *      |                                 |
+ * 16KB +---------------------------------+ <--- bch_owner_list_head.heads[0].recs[0]
+ *      |       bch_nvm_pgalloc_recs      |
+ *      |  (nvm pages internal usage)     |
+ * 24KB +---------------------------------+
+ *      |                                 |
+ *      |                                 |
+ * 16MB  +---------------------------------+
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
+ *      |         bch_nvm_pages_sb        |
+ *  8KB +---------------------------------+
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ *      |                                 |
+ * 16MB  +---------------------------------+
+ *      |      allocable nvm pages        |
+ *      |      for buddy allocator        |
+ * end  +---------------------------------+
+ *
+ */
+
+#include <linux/types.h>
+
+/* In sectors */
+#define BCH_NVM_PAGES_SB_OFFSET			4096
+#define BCH_NVM_PAGES_OFFSET			(16 << 20)
+
+#define BCH_NVM_PAGES_LABEL_SIZE		32
+#define BCH_NVM_PAGES_NAMESPACES_MAX		8
+
+#define BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET	(8<<10)
+#define BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET	(16<<10)
+
+#define BCH_NVM_PAGES_SB_VERSION		0
+#define BCH_NVM_PAGES_SB_VERSION_MAX		0
+
+static const unsigned char bch_nvm_pages_magic[] = {
+	0x17, 0xbd, 0x53, 0x7f, 0x1b, 0x23, 0xd6, 0x83,
+	0x46, 0xa4, 0xf8, 0x28, 0x17, 0xda, 0xec, 0xa9 };
+static const unsigned char bch_nvm_pages_pgalloc_magic[] = {
+	0x39, 0x25, 0x3f, 0xf7, 0x27, 0x17, 0xd0, 0xb9,
+	0x10, 0xe6, 0xd2, 0xda, 0x38, 0x68, 0x26, 0xae };
+
+/* takes 64bit width */
+struct bch_pgalloc_rec {
+	__u64	pgoff:52;
+	__u64	order:6;
+	__u64	reserved:6;
+};
+
+struct bch_nvm_pgalloc_recs {
+union {
+	struct {
+		struct bch_nvm_pages_owner_head	*owner;
+		struct bch_nvm_pgalloc_recs	*next;
+		unsigned char			magic[16];
+		unsigned char			owner_uuid[16];
+		unsigned int			size;
+		unsigned int			used;
+		unsigned long			_pad[4];
+		struct bch_pgalloc_rec		recs[];
+	};
+	unsigned char				pad[8192];
+};
+};
+
+#define BCH_MAX_RECS					\
+	((sizeof(struct bch_nvm_pgalloc_recs) -		\
+	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /	\
+	 sizeof(struct bch_pgalloc_rec))
+
+struct bch_nvm_pages_owner_head {
+	unsigned char			uuid[16];
+	unsigned char			label[BCH_NVM_PAGES_LABEL_SIZE];
+	/* Per-namespace own lists */
+	struct bch_nvm_pgalloc_recs	*recs[BCH_NVM_PAGES_NAMESPACES_MAX];
+};
+
+/* heads[0] is always for nvm_pages internal usage */
+struct bch_owner_list_head {
+union {
+	struct {
+		unsigned int			size;
+		unsigned int			used;
+		unsigned long			_pad[4];
+		struct bch_nvm_pages_owner_head	heads[];
+	};
+	unsigned char				pad[8192];
+};
+};
+#define BCH_MAX_OWNER_LIST				\
+	((sizeof(struct bch_owner_list_head) -		\
+	 offsetof(struct bch_owner_list_head, heads)) /	\
+	 sizeof(struct bch_nvm_pages_owner_head))
+
+/* The on-media bit order is local CPU order */
+struct bch_nvm_pages_sb {
+	unsigned long				csum;
+	unsigned long				ns_start;
+	unsigned long				sb_offset;
+	unsigned long				version;
+	unsigned char				magic[16];
+	unsigned char				uuid[16];
+	unsigned int				page_size;
+	unsigned int				total_namespaces_nr;
+	unsigned int				this_namespace_nr;
+	union {
+		unsigned char			set_uuid[16];
+		unsigned long			set_magic;
+	};
+
+	unsigned long				flags;
+	unsigned long				seq;
+
+	unsigned long				feature_compat;
+	unsigned long				feature_incompat;
+	unsigned long				feature_ro_compat;
+
+	/* For allocable nvm pages from buddy systems */
+	unsigned long				pages_offset;
+	unsigned long				pages_total;
+
+	unsigned long				pad[8];
+
+	/* Only on the first name space */
+	struct bch_owner_list_head		*owner_list_head;
+
+	/* Just for csum_set() */
+	unsigned int				keys;
+	unsigned long				d[0];
+};
+#endif /* CONFIG_64BIT */
+
+#endif /* _UAPI_BCACHE_NVM_H */
-- 
2.25.1


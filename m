Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A56311BE3
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 08:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhBFHUw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 02:20:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:47914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFHUw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 02:20:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A7B4CAE44;
        Sat,  6 Feb 2021 07:20:10 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 1/6] bcache-tools: add initial data structures for nvm_pages
Date:   Sat,  6 Feb 2021 15:20:00 +0800
Message-Id: <20210206072005.24811-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206072005.24811-1-colyli@suse.de>
References: <20210206072005.24811-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch initializes the prototype data structures for nvm pages
allocator,

- struct bch_nvm_pages_sb
  This is the super block allocated on each nvmdimm name space. A nvdimm
set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used to
mark which nvmdimm set this name space belongs to. Normally we will use
the bcache's cache set UUID to initialize this uuid, to connect this
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
  This structure occupies a whole page, owner_uuid should match the uuid
in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
allocated records.

- struct bch_nvm_pgalloc_rec
  Each structure records a range of allocated nvm pages. pgoff is offset
in unit of page size of this allocated nvm page range. The adjoint page
ranges of same owner can be merged into a larger one, therefore pages_nr
is NOT always power of 2.

Signed-off-by: Coly Li <colyli@suse.de>
---
 nvm_pages.h | 187 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 187 insertions(+)
 create mode 100644 nvm_pages.h

diff --git a/nvm_pages.h b/nvm_pages.h
new file mode 100644
index 0000000..1ed18a8
--- /dev/null
+++ b/nvm_pages.h
@@ -0,0 +1,187 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _BCACHE_NVM_PAGES_H
+#define _BCACHE_NVM_PAGES_H
+
+/*
+ * - struct bch_nvm_pages_sb
+ *   This is the super block allocated on each nvmdimm name space. A nvdimm
+ * set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used to
+ * mark which nvmdimm set this name space belongs to. Normally we will use
+ * the bcache's cache set UUID to initialize this uuid, to connect this nvdimm
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
+ * nvm_pgalloc_rec.
+ *
+ *- struct bch_nvm_pgalloc_recs
+ *  This structure occupies a whole page, owner_uuid should match the uuid
+ * in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
+ * allocated records.
+ *
+ * - struct bch_nvm_pgalloc_rec
+ *   Each structure records a range of allocated nvm pages. pgoff is offset
+ * in unit of page size of this allocated nvm page range. The adjoint page
+ * ranges of same owner can be merged into a larger one, therefore pages_nr
+ * is NOT always power of 2.
+ *
+ *
+ * Memory layout on nvdimm namespace 0
+ *
+ *    0 +----------------------------+
+ *      |                            |
+ *  4KB +----------------------------+
+ *      |   bch_nvme_pages_sb        |
+ *  8KB +----------------------------+ <--- bch_nvme_pages_sb.owner_list_head
+ *      |   bch_owner_list_head      |
+ *      |                            |
+ * 16KB +----------------------------+ <--- bch_owner_list_head.heads[0].recs[0]
+ *      |   bch_nvm_pgalloc_recs     |
+ *      | (nvm pages internal usage) |
+ * 24KB +----------------------------+
+ *      |                            |
+ *      |                            |
+ * 1MB  +----------------------------+
+ *      |    allocable nvm pages     |
+ *      |    for buddy allocator     |
+ * end  +----------------------------+
+ *
+ *
+ *
+ * Memory layout on nvdimm namespace N
+ * (doesn't have owner list)
+ *
+ *    0 +----------------------------+
+ *      |                            |
+ *  4KB +----------------------------+
+ *      |     bch_nvme_pages_sb      |
+ *  8KB +----------------------------+
+ *      |                            |
+ *      |                            |
+ *      |                            |
+ *      |                            |
+ *      |                            |
+ *      |                            |
+ * 1MB  +----------------------------+
+ *      |    allocable nvm pages     |
+ *      |    for buddy allocator     |
+ * end  +----------------------------+
+ *
+
+ */
+
+#include <limits.h>
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
+static const char bch_nvm_pages_magic[] = {
+	0x17, 0xbd, 0x53, 0x7f, 0x1b, 0x23, 0xd6, 0x83,
+	0x46, 0xa4, 0xf8, 0x28, 0x17, 0xda, 0xec, 0xa9 };
+static const char bch_nvm_pages_pgalloc_magic[] = {
+	0x39, 0x25, 0x3f, 0xf7, 0x27, 0x17, 0xd0, 0xb9,
+	0x10, 0xe6, 0xd2, 0xda, 0x38, 0x68, 0x26, 0xae };
+
+struct bch_nvm_pgalloc_rec {
+	__u32			pgoff;
+	__u32			nr;
+};
+
+struct bch_nvm_pgalloc_recs {
+union {
+	struct {
+		struct bch_nvm_pages_owner_head	*owner;
+		struct bch_nvm_pgalloc_recs	*next;
+		__u8				magic[16];
+		__u8				owner_uuid[16];
+		__u32				size;
+		__u32				used;
+		__u64				_pad[4];
+		struct bch_nvm_pgalloc_rec	recs[];
+	};
+	__u8	pad[8192];
+};
+};
+
+struct bch_nvm_pages_owner_head {
+	__u8				uuid[16];
+	char				label[BCH_NVM_PAGES_LABEL_SIZE];
+	/* Per-namespace own lists */
+	struct bch_nvm_pgalloc_recs	*recs[BCH_NVM_PAGES_NAMESPACES_MAX];
+};
+
+/* heads[0] is always for nvm_pages internal usage */
+struct bch_owner_list_head {
+union {
+	struct {
+		__u32				size;
+		__u32				used;
+		__u64				_pad[4];
+		struct bch_nvm_pages_owner_head	heads[];
+	};
+	__u8	pad[8192];
+};
+};
+
+
+/* The on-media bit order is local CPU order */
+struct bch_nvm_pages_sb {
+	__u64			csum;
+	__u64			ns_start;
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
+	__u64			pad[8];
+
+	/* Only on the first name space */
+	struct bch_owner_list_head	*owner_list_head;
+
+	/* Just for csum_set() */
+	__u32			keys;
+	__u64			d[0];
+};
+
+
+#endif
-- 
2.26.2


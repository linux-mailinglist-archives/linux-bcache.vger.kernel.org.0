Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327C72CCD19
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 04:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgLCDL2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 22:11:28 -0500
Received: from mga07.intel.com ([134.134.136.100]:1942 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726977AbgLCDL2 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 22:11:28 -0500
IronPort-SDR: +NYipkaFYaSjAchYlC8F/c5zCintIn9gZzgIuBHWYRQMTfnhoUlHtMwCWhvRkx9Cf9RAhoHqPI
 rjVqc9SpNpqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="237248554"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="237248554"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 19:10:24 -0800
IronPort-SDR: Hcl+FI+V44SDsD489QvzjIlJlUs6B3zxT5nGnz2yqR4tgS3buQG0Jtpc4LUBoEdSYxBBUGVYYQ
 Gw9gZ6sJVGJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="481801550"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2020 19:10:23 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Subject: [RFC PATCH 6/8] bcache: get allocated pages from specific owner
Date:   Thu,  3 Dec 2020 05:53:35 -0500
Message-Id: <20201203105337.4592-7-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203105337.4592-1-qiaowei.ren@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements get_allocated_pages() of the buddy to be used to
get allocated pages from specific owner.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 36 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |  7 +++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 16b65a866041..e8765b0b3398 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -373,6 +373,42 @@ void *nvm_alloc_pages(int order, const char *owner_uuid)
 }
 EXPORT_SYMBOL_GPL(nvm_alloc_pages);
 
+struct extent *get_allocated_pages(const char *owner_uuid)
+{
+	struct owner_list *owner_list = find_owner_list(owner_uuid, false);
+	int i;
+	struct extent *head = NULL;
+
+	if (owner_list == NULL)
+		return NULL;
+
+	for (i = 0; i < only_set->total_namespaces_nr; i++) {
+		struct list_head *l;
+		struct nvm_alloced_recs *alloced_recs = owner_list->alloced_recs[i];
+
+		if (!alloced_recs || alloced_recs->size == 0)
+			continue;
+
+		l = alloced_recs->extent_head.next;
+		while (l != &alloced_recs->extent_head) {
+			struct extent *e = container_of(l, struct extent, list);
+			struct extent *tmp = kzalloc(sizeof(struct extent), GFP_KERNEL);
+
+			tmp->kaddr = e->kaddr;
+			tmp->nr = e->nr;
+
+			if (head != NULL)
+				list_add_tail(&tmp->list, &head->list);
+			else
+				head = tmp;
+
+			l = l->next;
+		}
+	}
+	return head;
+}
+EXPORT_SYMBOL_GPL(get_allocated_pages);
+
 static void init_owner_info(struct nvm_namespace *ns)
 {
 	struct owner_list_head *owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 1e435ce0ddf4..4f0374459459 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -80,6 +80,8 @@ extern void bch_nvm_exit(void);
 extern void *nvm_alloc_pages(int order, const char *owner_uuid);
 extern void nvm_free_pages(void *addr, int order, const char *owner_uuid);
 
+extern struct extent *get_allocated_pages(const char *owner_uuid);
+
 #else
 
 static inline struct nvm_namespace *register_namespace(const char *dev_path)
@@ -95,6 +97,11 @@ static inline void bch_nvm_exit(void) { }
 static inline void *nvm_alloc_pages(int order, const char *owner_uuid) { }
 static inline void nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
 
+static inline struct extent *get_allocated_pages(const char *owner_uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1


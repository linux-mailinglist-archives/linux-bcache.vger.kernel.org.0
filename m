Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28202E193D
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 08:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgLWHFL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 02:05:11 -0500
Received: from mga04.intel.com ([192.55.52.120]:26609 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgLWHFL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 02:05:11 -0500
IronPort-SDR: uCx6BQ+oDnGV4V0iAw9zyqit/QrZqwqQ/gKONLHthQUJSkfxM6B82lGUfS1jWQgpESl7AhjNj2
 a5cgNokk0IPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9843"; a="173405201"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="173405201"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 23:03:44 -0800
IronPort-SDR: tjFIfKWSsQvGSV+SlPFRIfM+UyrM58wGVZw6DjSG14jdsOFSB5nDh7FmqpkGdmnOFuOug4Ax+p
 XloHL/ECs4DQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="565083531"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2020 23:03:42 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH v2 6/8] bcache: get allocated pages from specific owner
Date:   Wed, 23 Dec 2020 09:45:00 -0500
Message-Id: <20201223144502.25029-7-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223144502.25029-1-qiaowei.ren@intel.com>
References: <20201223144502.25029-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements bch_get_allocated_pages() of the buddy to be used to
get allocated pages from specific owner.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 38 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |  6 ++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 1dcb5012eccf..ff810110ee90 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -382,6 +382,44 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 }
 EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
 
+struct bch_extent *bch_get_allocated_pages(const char *owner_uuid)
+{
+	struct bch_owner_list *owner_list = find_owner_list(owner_uuid, false);
+	struct bch_nvm_alloced_recs *alloced_recs;
+	struct bch_extent *head = NULL, *e, *tmp;
+	int i;
+
+	if (!owner_list)
+		return NULL;
+
+	for (i = 0; i < only_set->total_namespaces_nr; i++) {
+		struct list_head *l;
+
+		alloced_recs = owner_list->alloced_recs[i];
+
+		if (!alloced_recs || alloced_recs->size == 0)
+			continue;
+
+		l = alloced_recs->extent_head.next;
+		while (l != &alloced_recs->extent_head) {
+			e = container_of(l, struct bch_extent, list);
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL|__GFP_NOFAIL);
+
+			tmp->kaddr = e->kaddr;
+			tmp->nr = e->nr;
+
+			if (head)
+				list_add_tail(&tmp->list, &head->list);
+			else
+				head = tmp;
+
+			l = l->next;
+		}
+	}
+	return head;
+}
+EXPORT_SYMBOL_GPL(bch_get_allocated_pages);
+
 static int init_owner_info(struct bch_nvm_namespace *ns)
 {
 	struct owner_list_head *owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 6a56dd4a2ffc..4d0b3e0f1e73 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -78,6 +78,7 @@ int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
+struct bch_extent *bch_get_allocated_pages(const char *owner_uuid);
 #else
 
 static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
@@ -97,6 +98,11 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 
 static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
 
+static inline struct bch_extent *bch_get_allocated_pages(const char *owner_uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.17.1


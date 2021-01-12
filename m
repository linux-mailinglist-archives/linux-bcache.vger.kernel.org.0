Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D10A2F2AB8
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Jan 2021 10:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389122AbhALJE0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Jan 2021 04:04:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:6859 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732924AbhALJEV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Jan 2021 04:04:21 -0500
IronPort-SDR: 3ZYR7O9GxHxIcwEsKYlxVVVI4lFl6Xrl0dFFTZ/ctTzy3VkJySEE1IKye4CD7zSGaxmtY6CBB2
 Wt052dK5ZsAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="262793396"
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="262793396"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 01:03:14 -0800
IronPort-SDR: 1kC2L+8AnEdGWugRjrRg8vbdU01PkcbRriCoCAZdBSEQxRejpJsZGapZhBD4nEhG3C9vQG+d78
 I10xQCdpT8qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="352948975"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 12 Jan 2021 01:03:13 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v4 6/8] bcache: get allocated pages from specific owner
Date:   Tue, 12 Jan 2021 11:45:03 -0500
Message-Id: <20210112164505.68228-7-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112164505.68228-1-qiaowei.ren@intel.com>
References: <20210112164505.68228-1-qiaowei.ren@intel.com>
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
index 2f6c183baa46..abed789458b4 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -396,6 +396,44 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
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
 	struct bch_owner_list_head *owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 05673d129797..27528d146358 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -79,6 +79,7 @@ int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
+struct bch_extent *bch_get_allocated_pages(const char *owner_uuid);
 #else
 
 static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
@@ -98,6 +99,11 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 
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


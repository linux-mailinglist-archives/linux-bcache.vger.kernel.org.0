Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631652EA58D
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 07:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbhAEGnj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jan 2021 01:43:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:20313 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbhAEGnj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jan 2021 01:43:39 -0500
IronPort-SDR: Gaddi30T7bG7pqQME53G8c8mzpm3CXDPJWBgpOVtsVKV2rbgxlj/8LpL+HrMZaxqB2/ukSzIVI
 QMgsa3KoA0Ww==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177161900"
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="177161900"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 22:42:35 -0800
IronPort-SDR: yTb9zfhAMeTnWcn6JVZgPDzZGDNdlDgGhLZqj0dEfH3utaBSPukeZLRpaAsTldJuOiELtTd8Nl
 51rJAtVeRHZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="350250084"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 22:42:34 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH v3 6/8] bcache: get allocated pages from specific owner
Date:   Tue,  5 Jan 2021 09:22:16 -0500
Message-Id: <20210105142218.56508-7-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210105142218.56508-1-qiaowei.ren@intel.com>
References: <20210105142218.56508-1-qiaowei.ren@intel.com>
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
index e7d948a40662..b095882d3a2b 100644
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


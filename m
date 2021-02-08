Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31031312AE3
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Feb 2021 07:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBHGqb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Feb 2021 01:46:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:44129 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhBHGqa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Feb 2021 01:46:30 -0500
IronPort-SDR: OHggNdD5XrrWLPKGvMe6uK3zVId9HPawV+c8SOtJ0Fc9R+mQr1RM4C0rfSD63nuufBY9yDmMDE
 GYoD3DFvgs/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="245738715"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="245738715"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 22:45:25 -0800
IronPort-SDR: iYWmPaV79c5J4HHhmD0ZzIEeR787lLbTBtS4prPFeTSf/YHauIj6EHJRuB1QxEmm4/30yvTGi2
 dwKFWM+YyJdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="418127594"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2021 22:45:24 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v6 6/7] bcache: get allocated pages from specific owner
Date:   Mon,  8 Feb 2021 09:26:20 -0500
Message-Id: <20210208142621.76815-7-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208142621.76815-1-qiaowei.ren@intel.com>
References: <20210208142621.76815-1-qiaowei.ren@intel.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch implements bch_get_allocated_pages() of the buddy to be used to
get allocated pages from specific owner.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 39 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h |  6 ++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index b40bdbac873f..2b079a277e88 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -374,6 +374,45 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
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
+		if (!alloced_recs || alloced_recs->nr == 0)
+			continue;
+
+		l = alloced_recs->extent_head.next;
+		while (l != &alloced_recs->extent_head) {
+			e = container_of(l, struct bch_extent, list);
+			tmp = kzalloc(sizeof(*tmp), GFP_KERNEL|__GFP_NOFAIL);
+
+			INIT_LIST_HEAD(&tmp->list);
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
index 1bc3129f2482..8ffae11c7c61 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -81,6 +81,7 @@ int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
+struct bch_extent *bch_get_allocated_pages(const char *owner_uuid);
 
 #else
 
@@ -101,6 +102,11 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 
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


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD84335D803
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Apr 2021 08:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhDMG1b (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 13 Apr 2021 02:27:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:18137 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhDMG1b (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Apr 2021 02:27:31 -0400
IronPort-SDR: 4U+lCst9C3nRqYYZy+AVQIh9FoFQRGF2lycXfTBwezQm08SOy5fPIJDYc2KvuofRcxFJ2b1NAv
 J2Ib9HgdN+vQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="181869354"
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="181869354"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 23:27:12 -0700
IronPort-SDR: Rll6wTyMiZDseViZUXkrKPfMTpTx5Y/PsqXLHVbkqYNOwJVzfMZNwihLo1IH9RVDvWhBgKS0HZ
 LvpUbQWqGutw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="460470400"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2021 23:27:10 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [bch-nvm-pages v8 6/6] bcache: get allocated pages from specific owner
Date:   Tue, 13 Apr 2021 10:05:49 -0400
Message-Id: <20210413140549.224482-7-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413140549.224482-1-qiaowei.ren@intel.com>
References: <20210413140549.224482-1-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

This patch implements bch_get_allocated_pages() of the buddy to be used to
get allocated pages from specific owner.

Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 6 ++++++
 drivers/md/bcache/nvm-pages.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index eaa6e18f3cad..c7e3ccc6af46 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -390,6 +390,12 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 }
 EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
 
+struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
+{
+	return find_owner_head(owner_uuid, false);
+}
+EXPORT_SYMBOL_GPL(bch_get_allocated_pages);
+
 static int init_owner_info(struct bch_nvm_namespace *ns)
 {
 	struct bch_owner_list_head *owner_list_head = ns->sb->owner_list_head;
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 918aee6a9afc..ef4aa4a0f286 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -64,6 +64,7 @@ int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
+struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid);
 
 #else
 
@@ -81,6 +82,11 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 	return NULL;
 }
 static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
+static inline struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
+{
+	return NULL;
+}
++
 
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
-- 
2.25.1


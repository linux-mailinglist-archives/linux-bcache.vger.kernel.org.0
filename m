Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FEB35A3BB
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Apr 2021 18:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbhDIQop (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Apr 2021 12:44:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:35102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhDIQop (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Apr 2021 12:44:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 13398B124;
        Fri,  9 Apr 2021 16:44:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.01.org,
        axboe@kernel.dk, jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        hare@suse.com, jack@suse.cz, dan.j.williams@intel.com
Subject: [PATCH v7 06/16] bcache: get allocated pages from specific owner
Date:   Sat, 10 Apr 2021 00:43:33 +0800
Message-Id: <20210409164343.56828-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164343.56828-1-colyli@suse.de>
References: <20210409164343.56828-1-colyli@suse.de>
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
 drivers/md/bcache/nvm-pages.h | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index e576b4cb4850..2ba02091bccf 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -374,6 +374,12 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
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
index 4ea831894583..87b1efc301c8 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -62,7 +62,7 @@ int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
-
+struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid);
 #else
 
 static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
@@ -81,6 +81,11 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 
 static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
 
+static inline struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
 #endif /* _BCACHE_NVM_PAGES_H */
-- 
2.26.2


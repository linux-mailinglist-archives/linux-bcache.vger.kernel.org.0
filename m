Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569AC35EC64
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Apr 2021 07:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347460AbhDNFrm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Apr 2021 01:47:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:43224 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347452AbhDNFrm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Apr 2021 01:47:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5237BB039;
        Wed, 14 Apr 2021 05:47:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH 06/13] bcache: get allocated pages from specific owner
Date:   Wed, 14 Apr 2021 13:46:41 +0800
Message-Id: <20210414054648.24098-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414054648.24098-1-colyli@suse.de>
References: <20210414054648.24098-1-colyli@suse.de>
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
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/nvm-pages.c | 6 ++++++
 drivers/md/bcache/nvm-pages.h | 5 +++++
 2 files changed, 11 insertions(+)

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
index 918aee6a9afc..cfb3e8ef01ee 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -64,6 +64,7 @@ int bch_nvm_init(void);
 void bch_nvm_exit(void);
 void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
 void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
+struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid);
 
 #else
 
@@ -81,6 +82,10 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 	return NULL;
 }
 static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
+static inline struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
+{
+	return NULL;
+}
 
 #endif /* CONFIG_BCACHE_NVM_PAGES */
 
-- 
2.26.2


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67B735A3C0
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Apr 2021 18:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbhDIQow (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Apr 2021 12:44:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:35170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233993AbhDIQov (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Apr 2021 12:44:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4053AE6D;
        Fri,  9 Apr 2021 16:44:37 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.01.org,
        axboe@kernel.dk, jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        hare@suse.com, jack@suse.cz, dan.j.williams@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH v7 07/16] bcache: nvm-pages fixes for bcache integration testing
Date:   Sat, 10 Apr 2021 00:43:34 +0800
Message-Id: <20210409164343.56828-8-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164343.56828-1-colyli@suse.de>
References: <20210409164343.56828-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There are two minor fixes in nvm-pages code, which can be added in next
nvm-pages series. Then I can drop this patch.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 29 +++++++++++++++++++++--------
 drivers/md/bcache/nvm-pages.h |  1 +
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 2ba02091bccf..c3ab396a45fa 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -73,24 +73,32 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
 static struct bch_nvm_pages_owner_head *find_owner_head(const char *owner_uuid, bool create)
 {
 	struct bch_owner_list_head *owner_list_head = only_set->owner_list_head;
+	struct bch_nvm_pages_owner_head *owner_head = NULL;
 	int i;
 
+	if (owner_list_head == NULL)
+		goto out;
+
 	for (i = 0; i < only_set->owner_list_used; i++) {
-		if (!memcmp(owner_uuid, owner_list_head->heads[i].uuid, 16))
-			return &(owner_list_head->heads[i]);
+		if (!memcmp(owner_uuid, owner_list_head->heads[i].uuid, 16)) {
+			owner_head = &(owner_list_head->heads[i]);
+			break;
+		}
 	}
 
-	if (create) {
+	if (!owner_head && create) {
 		int used = only_set->owner_list_used;
 
-		BUG_ON(only_set->owner_list_size == used);
-		memcpy(owner_list_head->heads[used].uuid, owner_uuid, 16);
+		BUG_ON((used > 0) && (only_set->owner_list_size == used));
+		memcpy_flushcache(owner_list_head->heads[used].uuid, owner_uuid, 16);
 		only_set->owner_list_used++;
 
 		owner_list_head->used++;
-		return &(owner_list_head->heads[used]);
-	} else
-		return NULL;
+		owner_head = &(owner_list_head->heads[used]);
+	}
+
+out:
+	return owner_head;
 }
 
 static struct bch_nvm_pgalloc_recs *find_empty_pgalloc_recs(void)
@@ -324,6 +332,10 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 
 	mutex_lock(&only_set->lock);
 	owner_head = find_owner_head(owner_uuid, true);
+	if (!owner_head) {
+		pr_err("can't find bch_nvm_pgalloc_recs by(uuid=%s)\n", owner_uuid);
+		goto unlock;
+	}
 
 	for (j = 0; j < only_set->total_namespaces_nr; j++) {
 		struct bch_nvm_namespace *ns = only_set->nss[j];
@@ -369,6 +381,7 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
 		}
 	}
 
+unlock:
 	mutex_unlock(&only_set->lock);
 	return kaddr;
 }
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 87b1efc301c8..b8a5cd0890d3 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -66,6 +66,7 @@ struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
 #else
 
 static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
+{
 	return NULL;
 }
 static inline int bch_nvm_init(void)
-- 
2.26.2


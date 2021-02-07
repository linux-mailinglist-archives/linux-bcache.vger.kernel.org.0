Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E5731254B
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Feb 2021 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBGP2B (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 7 Feb 2021 10:28:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:35846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhBGPZm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 7 Feb 2021 10:25:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15D34AD29;
        Sun,  7 Feb 2021 15:25:00 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, jianpeng.ma@intel.com,
        qiaowei.ren@intel.com, Coly Li <colyli@suse.de>
Subject: [PATCH 2/6] bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
Date:   Sun,  7 Feb 2021 23:24:19 +0800
Message-Id: <20210207152423.70697-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210207152423.70697-1-colyli@suse.de>
References: <20210207152423.70697-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds BCH_FEATURE_INCOMPAT_NVDIMM_META (value 0x0004) into the
incompat feature set. When this bit is set by bcache-tools, it indicates
bcache meta data should be stored on specific NVDIMM meta device.

The bcache meta data mainly includes journal and btree nodes, when this
bit is set in incompat feature set, bcache will ask the nvm-pages
allocator for NVDIMM space to store the meta data.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/features.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
index d1c8fd3977fc..333fb5efb6bd 100644
--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -17,11 +17,19 @@
 #define BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET		0x0001
 /* real bucket size is (1 << bucket_size) */
 #define BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE	0x0002
+/* store bcache meta data on nvdimm */
+#define BCH_FEATURE_INCOMPAT_NVDIMM_META		0x0004
 
 #define BCH_FEATURE_COMPAT_SUPP		0
 #define BCH_FEATURE_RO_COMPAT_SUPP	0
+#ifdef CONFIG_BCACHE_NVM_PAGES
+#define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
+					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE| \
+					 BCH_FEATURE_INCOMPAT_NVDIMM_META)
+#else
 #define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
 					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE)
+#endif
 
 #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
 		((sb)->feature_compat & (mask))
@@ -89,6 +97,7 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 
 BCH_FEATURE_INCOMPAT_FUNCS(obso_large_bucket, OBSO_LARGE_BUCKET);
 BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LOG_LARGE_BUCKET_SIZE);
+BCH_FEATURE_INCOMPAT_FUNCS(nvdimm_meta, NVDIMM_META);
 
 static inline bool bch_has_unknown_compat_features(struct cache_sb *sb)
 {
-- 
2.26.2


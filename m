Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484EF471BC4
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbhLLRGk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:40 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54958 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhLLRGk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:40 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 13FCD21123;
        Sun, 12 Dec 2021 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Qb4AdcB8+T+dwdlci57Ezb5Prf70SPeiAxdkJ5AFOw=;
        b=Veknugn2B6vvimN++EgHNAErJt0VVqnXUPNkUJfTzbkqUUa3emBbkI13cV+HD3NNeNGpPY
        KyFmYl0KL6m5DdXbLYvzBoflEEzokQsZ60dq0q9COAfMRZBJXt83+vvPnLaFOQ9dqdH+rM
        siHgcMtY7qmvmajNTFOQ2ep9qDgAm5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328799;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Qb4AdcB8+T+dwdlci57Ezb5Prf70SPeiAxdkJ5AFOw=;
        b=lQD9j2rwV/sPdOLxZeGP4ODVV8pPjzt7YjV2oJy3A+fLabAk4qf5fAsGCzaFVErJ8jac8r
        5eynltn1fxTpELAA==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 7BB4FA3B83;
        Sun, 12 Dec 2021 17:06:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v13 08/12] bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
Date:   Mon, 13 Dec 2021 01:05:48 +0800
Message-Id: <20211212170552.2812-9-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/features.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
index 09161b89c63e..fab92678be76 100644
--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -18,11 +18,19 @@
 #define BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET		0x0001
 /* real bucket size is (1 << bucket_size) */
 #define BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE	0x0002
+/* store bcache meta data on nvdimm */
+#define BCH_FEATURE_INCOMPAT_NVDIMM_META		0x0004
 
 #define BCH_FEATURE_COMPAT_SUPP		0
 #define BCH_FEATURE_RO_COMPAT_SUPP	0
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+#define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
+					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE| \
+					 BCH_FEATURE_INCOMPAT_NVDIMM_META)
+#else
 #define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
 					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE)
+#endif
 
 #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
 		((sb)->feature_compat & (mask))
@@ -90,6 +98,7 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 
 BCH_FEATURE_INCOMPAT_FUNCS(obso_large_bucket, OBSO_LARGE_BUCKET);
 BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LOG_LARGE_BUCKET_SIZE);
+BCH_FEATURE_INCOMPAT_FUNCS(nvdimm_meta, NVDIMM_META);
 
 static inline bool bch_has_unknown_compat_features(struct cache_sb *sb)
 {
-- 
2.31.1


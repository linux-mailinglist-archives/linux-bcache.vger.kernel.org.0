Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9C3A76B2
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Jun 2021 07:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFOFv6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Jun 2021 01:51:58 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45668 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhFOFv5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Jun 2021 01:51:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F25061FD2A;
        Tue, 15 Jun 2021 05:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623736192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBAZ0ZjuLQW/pckeEosVADDOYazldmp97Y5zmm0Pj0s=;
        b=FHbd41dh3BuUTGIuxezkr60iBHOjVh/egrPwfNLErNm1YiJV6S6ab4yVaGEekJd2g8W4gt
        uC9SNHGrGe1jkc1PMj5v7KGvGKvoCXI+1FCKjSaMTACdCyFtJDaacTyvjCSio/cAQp4JUF
        /xpMxNZmt2Pn5jkxtoEznRogMXUvoTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623736192;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HBAZ0ZjuLQW/pckeEosVADDOYazldmp97Y5zmm0Pj0s=;
        b=J6BMbYUdUdE+l4uQt0Yn9O8+5Y89aBeiFJBBuH5+b3nnanYeM905e1Q5iyu2Xv/RCKeWTB
        iRyu2ShgN+s59RBg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 32B89A3BAD;
        Tue, 15 Jun 2021 05:49:50 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 10/14] bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
Date:   Tue, 15 Jun 2021 13:49:17 +0800
Message-Id: <20210615054921.101421-11-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210615054921.101421-1-colyli@suse.de>
References: <20210615054921.101421-1-colyli@suse.de>
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
index d1c8fd3977fc..45d2508d5532 100644
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
@@ -89,6 +97,7 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 
 BCH_FEATURE_INCOMPAT_FUNCS(obso_large_bucket, OBSO_LARGE_BUCKET);
 BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LOG_LARGE_BUCKET_SIZE);
+BCH_FEATURE_INCOMPAT_FUNCS(nvdimm_meta, NVDIMM_META);
 
 static inline bool bch_has_unknown_compat_features(struct cache_sb *sb)
 {
-- 
2.26.2


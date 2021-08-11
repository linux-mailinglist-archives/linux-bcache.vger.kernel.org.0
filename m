Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46C73E967B
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhHKRFM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:05:12 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58642 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhHKRFM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:05:12 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E025520194;
        Wed, 11 Aug 2021 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDO6KbUU2BBHFR3gnCnc2pGQo+NHb8DjCJX3xMzrcWc=;
        b=ZlVgU81q6pHRHlmcuUBC++wKpikJ9HDgBaIvtF9LxfMWXbHRVg4hsDj7ZxW5MAUsUILjDQ
        j1VXcd/Pww+MMbnvLklW9cfbHBiy5730ole/LQAhdYI5+y9xJdQpl3Koi32tbSbjXD4MId
        c8z9wGkDlblVvzhgmHE9JGadph5nkKc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701487;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDO6KbUU2BBHFR3gnCnc2pGQo+NHb8DjCJX3xMzrcWc=;
        b=ZQ5ywbr2wBpN9hT831K3oGCFwuFRCU54ydL8y1Pe0RUWtYTFwuuxN3j9iRNY6k8+y6Oxi5
        iAionqaLD+QzOFBg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 1E1F8A3D5E;
        Wed, 11 Aug 2021 17:04:41 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v12 08/12] bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
Date:   Thu, 12 Aug 2021 01:02:20 +0800
Message-Id: <20210811170224.42837-9-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
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


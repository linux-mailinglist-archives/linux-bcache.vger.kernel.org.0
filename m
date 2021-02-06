Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBD3311BE7
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 08:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhBFHU4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 02:20:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:47934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFHU4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 02:20:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 32EEAAE6E;
        Sat,  6 Feb 2021 07:20:14 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 3/6] bcache-tools: add BCH_FEATURE_INCOMPAT_NVDIMM_META to incompatible feature set
Date:   Sat,  6 Feb 2021 15:20:02 +0800
Message-Id: <20210206072005.24811-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206072005.24811-1-colyli@suse.de>
References: <20210206072005.24811-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

A new incompatible feature bit BCH_FEATURE_INCOMPAT_NVDIMM_META is
added into incompatible feature set. When "-M" or "--mdev" is specified
to store cache device meta data on NVDIMM, this feature bit will be
set on cache device's sb.feature_incompat. Then kernel code will know
the journal and btree nodes are stored on nvdimm meta device.

Signed-off-by: Coly Li <colyli@suse.de>
---
 bcache.h   | 7 ++++++-
 features.c | 2 ++
 make.c     | 6 ++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/bcache.h b/bcache.h
index 46d9683..2ae25ee 100644
--- a/bcache.h
+++ b/bcache.h
@@ -203,7 +203,8 @@ uint64_t crc64(const void *data, size_t len);
 #define BCH_FEATURE_COMPAT_SUPP		0
 #define BCH_FEATURE_RO_COMPAT_SUPP	0
 #define BCH_FEATURE_INCOMPAT_SUPP	(BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET| \
-					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE)
+					 BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE| \
+					 BCH_FEATURE_INCOMPAT_NVDIMM_META)
 
 #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
 		((sb)->feature_compat & (mask))
@@ -219,6 +220,9 @@ uint64_t crc64(const void *data, size_t len);
 #define BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET		0x0001
 /* real bucket size is (1 << bucket_size) */
 #define BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE	0x0002
+/* store bcache meta data on nvdimm */
+#define BCH_FEATURE_INCOMPAT_NVDIMM_META		0x0004
+
 
 #define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline int bch_has_feature_##name(struct cache_sb *sb) \
@@ -279,5 +283,6 @@ static inline void bch_clear_feature_##name(struct cache_sb *sb) \
 
 BCH_FEATURE_INCOMPAT_FUNCS(obso_large_bucket, OBSO_LARGE_BUCKET);
 BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LOG_LARGE_BUCKET_SIZE);
+BCH_FEATURE_INCOMPAT_FUNCS(nvdimm_meta, NVDIMM_META);
 
 #endif
diff --git a/features.c b/features.c
index f7f6224..7d9eff6 100644
--- a/features.c
+++ b/features.c
@@ -24,6 +24,8 @@ static struct feature feature_list[] = {
 		"obso_large_bucket"},
 	{BCH_FEATURE_INCOMPAT, BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE,
 		"large_bucket"},
+	{BCH_FEATURE_INCOMPAT, BCH_FEATURE_INCOMPAT_NVDIMM_META,
+		"nvdimm_meta"},
 	{0, 0, 0 },
 };
 
diff --git a/make.c b/make.c
index e8840eb..5c2c1dd 100644
--- a/make.c
+++ b/make.c
@@ -43,6 +43,7 @@ struct sb_context {
 	bool		writeback;
 	bool		discard;
 	bool		wipe_bcache;
+	bool		nvdimm_meta;
 	unsigned int	cache_replacement_policy;
 	uint64_t	data_offset;
 	uuid_t		set_uuid;
@@ -250,6 +251,7 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 	bool wipe_bcache = sbc->wipe_bcache;
 	bool writeback = sbc->writeback;
 	bool discard = sbc->discard;
+	bool nvdimm_meta = sbc->nvdimm_meta;
 	char *label = sbc->label;
 	uint64_t data_offset = sbc->data_offset;
 	unsigned int cache_replacement_policy = sbc->cache_replacement_policy;
@@ -398,6 +400,9 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 		       data_offset);
 		putchar('\n');
 	} else {
+		if (nvdimm_meta)
+			bch_set_feature_nvdimm_meta(&sb);
+
 		set_bucket_size(&sb, bucket_size);
 
 		sb.nbuckets		= getblocks(fd) / sb.bucket_size;
@@ -652,6 +657,7 @@ int make_bcache(int argc, char **argv)
 	sbc.data_offset = data_offset;
 	memcpy(sbc.set_uuid, set_uuid, sizeof(sbc.set_uuid));
 	sbc.label = label;
+	sbc.nvdimm_meta = (mdev == 1) ? true : false;
 
 	for (i = 0; i < ncache_devices; i++)
 		write_sb(cache_devices[i], &sbc, false, force);
-- 
2.26.2


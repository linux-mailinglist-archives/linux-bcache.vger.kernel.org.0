Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C517D311BE4
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 08:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhBFHUz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 02:20:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:47924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhBFHUy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 02:20:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7207FAE6D;
        Sat,  6 Feb 2021 07:20:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 2/6] bcache-tools: reduce parameters of write_sb()
Date:   Sat,  6 Feb 2021 15:20:01 +0800
Message-Id: <20210206072005.24811-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206072005.24811-1-colyli@suse.de>
References: <20210206072005.24811-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There are 12 parameters in write_sb(), and in future there will be more
paramerter added for new feature. In order to make the code more clear
for adding more parameter, this patch introduces struct sb_context to
hold most of these parameters, and send them into write_sb() via pointer
of struct sb_context.

Signed-off-by: Coly Li <colyli@suse.de>
---
 make.c | 53 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 16 deletions(-)

diff --git a/make.c b/make.c
index a3f97f6..e8840eb 100644
--- a/make.c
+++ b/make.c
@@ -37,6 +37,19 @@
 #include "bitwise.h"
 #include "zoned.h"
 
+struct sb_context {
+	unsigned int	block_size;
+	unsigned int	bucket_size;
+	bool		writeback;
+	bool		discard;
+	bool		wipe_bcache;
+	unsigned int	cache_replacement_policy;
+	uint64_t	data_offset;
+	uuid_t		set_uuid;
+	char		*label;
+};
+
+
 #define max(x, y) ({				\
 	typeof(x) _max1 = (x);			\
 	typeof(y) _max2 = (y);			\
@@ -225,18 +238,21 @@ err:
 	return -1;
 }
 
-static void write_sb(char *dev, unsigned int block_size,
-			unsigned int bucket_size,
-			bool writeback, bool discard, bool wipe_bcache,
-			unsigned int cache_replacement_policy,
-			uint64_t data_offset,
-			uuid_t set_uuid, bool bdev, bool force, char *label)
+static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 {
 	int fd;
 	char uuid_str[40], set_uuid_str[40], zeroes[SB_START] = {0};
 	struct cache_sb_disk sb_disk;
 	struct cache_sb sb;
 	blkid_probe pr;
+	unsigned int block_size = sbc->block_size;
+	unsigned int bucket_size = sbc->bucket_size;
+	bool wipe_bcache = sbc->wipe_bcache;
+	bool writeback = sbc->writeback;
+	bool discard = sbc->discard;
+	char *label = sbc->label;
+	uint64_t data_offset = sbc->data_offset;
+	unsigned int cache_replacement_policy = sbc->cache_replacement_policy;
 
 	fd = open(dev, O_RDWR|O_EXCL);
 
@@ -338,7 +354,7 @@ static void write_sb(char *dev, unsigned int block_size,
 
 	memcpy(sb.magic, bcache_magic, 16);
 	uuid_generate(sb.uuid);
-	memcpy(sb.set_uuid, set_uuid, sizeof(sb.set_uuid));
+	memcpy(sb.set_uuid, sbc->set_uuid, sizeof(sb.set_uuid));
 
 	sb.block_size	= block_size;
 
@@ -510,6 +526,7 @@ int make_bcache(int argc, char **argv)
 	unsigned int cache_replacement_policy = 0;
 	uint64_t data_offset = BDEV_DATA_START_DEFAULT;
 	uuid_t set_uuid;
+	struct sb_context sbc;
 
 	uuid_generate(set_uuid);
 
@@ -626,20 +643,24 @@ int make_bcache(int argc, char **argv)
 					 get_blocksize(backing_devices[i]));
 	}
 
+	sbc.block_size = block_size;
+	sbc.bucket_size = bucket_size;
+	sbc.writeback = writeback;
+	sbc.discard = discard;
+	sbc.wipe_bcache = wipe_bcache;
+	sbc.cache_replacement_policy = cache_replacement_policy;
+	sbc.data_offset = data_offset;
+	memcpy(sbc.set_uuid, set_uuid, sizeof(sbc.set_uuid));
+	sbc.label = label;
+
 	for (i = 0; i < ncache_devices; i++)
-		write_sb(cache_devices[i], block_size, bucket_size,
-			 writeback, discard, wipe_bcache,
-			 cache_replacement_policy,
-			 data_offset, set_uuid, false, force, label);
+		write_sb(cache_devices[i], &sbc, false, force);
 
 	for (i = 0; i < nbacking_devices; i++) {
 		check_data_offset_for_zoned_device(backing_devices[i],
-						   &data_offset);
+						   &sbc.data_offset);
 
-		write_sb(backing_devices[i], block_size, bucket_size,
-			 writeback, discard, wipe_bcache,
-			 cache_replacement_policy,
-			 data_offset, set_uuid, true, force, label);
+		write_sb(backing_devices[i], &sbc, true, force);
 	}
 
 	return 0;
-- 
2.26.2


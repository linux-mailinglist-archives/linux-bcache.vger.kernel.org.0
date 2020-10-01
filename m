Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFCD27F9C1
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Oct 2020 08:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgJAGvj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Oct 2020 02:51:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:34084 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgJAGvj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D6382B012;
        Thu,  1 Oct 2020 06:51:37 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/15] bcache: only use bucket_bytes() on struct cache
Date:   Thu,  1 Oct 2020 14:50:52 +0800
Message-Id: <20201001065056.24411-12-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
References: <20201001065056.24411-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Because struct cache_set and struct cache both have struct cache_sb,
macro bucket_bytes() currently are used on both of them. When removing
the embedded struct cache_sb from struct cache_set, this macro won't be
used on struct cache_set anymore.

This patch unifies all bucket_bytes() usage only on struct cache, this is
one of the preparation to remove the embedded struct cache_sb from
struct cache_set.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/bcache.h | 2 +-
 drivers/md/bcache/sysfs.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 48a2585b6bbb..94d4baf4c405 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -757,7 +757,7 @@ struct bbio {
 #define btree_default_blocks(c)						\
 	((unsigned int) ((PAGE_SECTORS * (c)->btree_pages) >> (c)->block_bits))
 
-#define bucket_bytes(c)		((c)->sb.bucket_size << 9)
+#define bucket_bytes(ca)	((ca)->sb.bucket_size << 9)
 #define block_bytes(ca)		((ca)->sb.block_size << 9)
 
 static inline unsigned int meta_bucket_pages(struct cache_sb *sb)
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index b9f524ab5cc8..4bfe98faadcc 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -713,7 +713,7 @@ SHOW(__bch_cache_set)
 
 	sysfs_print(synchronous,		CACHE_SYNC(&c->sb));
 	sysfs_print(journal_delay_ms,		c->journal_delay_ms);
-	sysfs_hprint(bucket_size,		bucket_bytes(c));
+	sysfs_hprint(bucket_size,		bucket_bytes(c->cache));
 	sysfs_hprint(block_size,		block_bytes(c->cache));
 	sysfs_print(tree_depth,			c->root->level);
 	sysfs_print(root_usage_percent,		bch_root_usage(c));
-- 
2.26.2


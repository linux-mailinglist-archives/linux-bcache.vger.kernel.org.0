Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C2245468
	for <lists+linux-bcache@lfdr.de>; Sun, 16 Aug 2020 00:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgHOWYA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 15 Aug 2020 18:24:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:37956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbgHOWXu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Aug 2020 18:23:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C5BF1B1CC;
        Sat, 15 Aug 2020 12:48:28 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v1 09/14] bcache: avoid data copy between cache_set->sb and cache->sb
Date:   Sat, 15 Aug 2020 20:47:38 +0800
Message-Id: <20200815124743.115270-10-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200815124743.115270-1-colyli@suse.de>
References: <20200815124743.115270-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

struct cache_sb embedded in struct cache_set is only partial used and
not a real copy from cache's in-memory super block. When removing the
embedded cache_set->sb, it is unncessary to copy data between these two
in-memory super blocks (cache_set->sb and cache->sb), it is sufficient
to just use cache->sb.

This patch removes the data copy between these two in-memory super
blocks in bch_cache_set_alloc() and bcache_write_super(). In future
except for set_uuid, cache's super block will be referenced by cache
set, no copy any more.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 28257f11d835..20de004ab2ef 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -350,16 +350,10 @@ void bcache_write_super(struct cache_set *c)
 	down(&c->sb_write_mutex);
 	closure_init(cl, &c->cl);
 
-	c->sb.seq++;
+	ca->sb.seq++;
 
-	if (c->sb.version > version)
-		version = c->sb.version;
-
-	ca->sb.version		= version;
-	ca->sb.seq		= c->sb.seq;
-	ca->sb.last_mount	= c->sb.last_mount;
-
-	SET_CACHE_SYNC(&ca->sb, CACHE_SYNC(&c->sb));
+	if (ca->sb.version < version)
+		ca->sb.version = version;
 
 	bio_init(bio, ca->sb_bv, 1);
 	bio_set_dev(bio, ca->bdev);
@@ -1860,16 +1854,6 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	bch_cache_accounting_init(&c->accounting, &c->cl);
 
 	memcpy(c->set_uuid, sb->set_uuid, 16);
-	c->sb.block_size	= sb->block_size;
-	c->sb.bucket_size	= sb->bucket_size;
-	c->sb.nr_in_set		= sb->nr_in_set;
-	c->sb.last_mount	= sb->last_mount;
-	c->sb.version		= sb->version;
-	if (c->sb.version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
-		c->sb.feature_compat = sb->feature_compat;
-		c->sb.feature_ro_compat = sb->feature_ro_compat;
-		c->sb.feature_incompat = sb->feature_incompat;
-	}
 
 	c->bucket_bits		= ilog2(sb->bucket_size);
 	c->block_bits		= ilog2(sb->block_size);
-- 
2.26.2


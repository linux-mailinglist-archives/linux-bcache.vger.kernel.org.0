Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12C727F9C7
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Oct 2020 08:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgJAGvt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Oct 2020 02:51:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:34260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbgJAGvt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 19F5BB012;
        Thu,  1 Oct 2020 06:51:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/15] bcache: check and set sync status on cache's in-memory super block
Date:   Thu,  1 Oct 2020 14:50:55 +0800
Message-Id: <20201001065056.24411-15-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
References: <20201001065056.24411-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Currently the cache's sync status is checked and set on cache set's in-
memory partial super block. After removing the embedded struct cache_sb
from cache set and reference cache's in-memory super block from struct
cache_set, the sync status can set and check directly on cache's super
block.

This patch checks and sets the cache sync status directly on cache's
in-memory super block. This is a preparation for later removing embedded
struct cache_sb from struct cache_set.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/alloc.c   | 2 +-
 drivers/md/bcache/journal.c | 2 +-
 drivers/md/bcache/super.c   | 7 ++-----
 drivers/md/bcache/sysfs.c   | 6 +++---
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 1b8310992dd0..65fdbdeb5134 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -361,7 +361,7 @@ static int bch_allocator_thread(void *arg)
 		 * new stuff to them:
 		 */
 		allocator_wait(ca, !atomic_read(&ca->set->prio_blocked));
-		if (CACHE_SYNC(&ca->set->sb)) {
+		if (CACHE_SYNC(&ca->sb)) {
 			/*
 			 * This could deadlock if an allocation with a btree
 			 * node locked ever blocked - having the btree node
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index ab0d06e4851d..cd46f33db507 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -915,7 +915,7 @@ atomic_t *bch_journal(struct cache_set *c,
 	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags)))
 		return NULL;
 
-	if (!CACHE_SYNC(&c->sb))
+	if (!CACHE_SYNC(&c->cache->sb))
 		return NULL;
 
 	w = journal_wait_for_write(c, bch_keylist_nkeys(keys));
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 78f99f75fa28..f400e84cb653 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1970,7 +1970,7 @@ static int run_cache_set(struct cache_set *c)
 	c->nbuckets = ca->sb.nbuckets;
 	set_gc_sectors(c);
 
-	if (CACHE_SYNC(&c->sb)) {
+	if (CACHE_SYNC(&c->cache->sb)) {
 		struct bkey *k;
 		struct jset *j;
 
@@ -2093,7 +2093,7 @@ static int run_cache_set(struct cache_set *c)
 		 * everything is set up - fortunately journal entries won't be
 		 * written until the SET_CACHE_SYNC() here:
 		 */
-		SET_CACHE_SYNC(&c->sb, true);
+		SET_CACHE_SYNC(&c->cache->sb, true);
 
 		bch_journal_next(&c->journal);
 		bch_journal_meta(c, &cl);
@@ -2139,9 +2139,6 @@ static const char *register_cache_set(struct cache *ca)
 			if (c->cache)
 				return "duplicate cache set member";
 
-			if (!CACHE_SYNC(&ca->sb))
-				SET_CACHE_SYNC(&c->sb, false);
-
 			goto found;
 		}
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 4bfe98faadcc..554e3afc9b68 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -711,7 +711,7 @@ SHOW(__bch_cache_set)
 {
 	struct cache_set *c = container_of(kobj, struct cache_set, kobj);
 
-	sysfs_print(synchronous,		CACHE_SYNC(&c->sb));
+	sysfs_print(synchronous,		CACHE_SYNC(&c->cache->sb));
 	sysfs_print(journal_delay_ms,		c->journal_delay_ms);
 	sysfs_hprint(bucket_size,		bucket_bytes(c->cache));
 	sysfs_hprint(block_size,		block_bytes(c->cache));
@@ -812,8 +812,8 @@ STORE(__bch_cache_set)
 	if (attr == &sysfs_synchronous) {
 		bool sync = strtoul_or_return(buf);
 
-		if (sync != CACHE_SYNC(&c->sb)) {
-			SET_CACHE_SYNC(&c->sb, sync);
+		if (sync != CACHE_SYNC(&c->cache->sb)) {
+			SET_CACHE_SYNC(&c->cache->sb, sync);
 			bcache_write_super(c);
 		}
 	}
-- 
2.26.2


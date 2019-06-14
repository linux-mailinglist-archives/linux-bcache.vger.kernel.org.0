Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D845DB0
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfFNNOe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:14:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:45518 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727766AbfFNNOd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:14:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C09E8AB8C;
        Fri, 14 Jun 2019 13:14:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 07/29] bcache: add reclaimed_journal_buckets to struct cache_set
Date:   Fri, 14 Jun 2019 21:13:36 +0800
Message-Id: <20190614131358.2771-8-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now we have counters for how many times jouranl is reclaimed, how many
times cached dirty btree nodes are flushed, but we don't know how many
jouranl buckets are really reclaimed.

This patch adds reclaimed_journal_buckets into struct cache_set, this
is an increasing only counter, to tell how many journal buckets are
reclaimed since cache set runs. From all these three counters (reclaim,
reclaimed_journal_buckets, flush_write), we can have idea how well
current journal space reclaim code works.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h  | 1 +
 drivers/md/bcache/journal.c | 1 +
 drivers/md/bcache/sysfs.c   | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index ae87cb01401e..732f9b6cb2bb 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -705,6 +705,7 @@ struct cache_set {
 	atomic_long_t		writeback_keys_failed;
 
 	atomic_long_t		reclaim;
+	atomic_long_t		reclaimed_journal_buckets;
 	atomic_long_t		flush_write;
 
 	enum			{
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 303ef3d1fbc6..d75efeaa4baa 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -614,6 +614,7 @@ static void journal_reclaim(struct cache_set *c)
 		k->ptr[n++] = MAKE_PTR(0,
 				  bucket_to_sector(c, ca->sb.d[ja->cur_idx]),
 				  ca->sb.nr_this_dev);
+		atomic_long_inc(&c->reclaimed_journal_buckets);
 	}
 
 	if (n) {
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index a67e1e57ea68..7a88ba4bfbfb 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -84,6 +84,7 @@ read_attribute(bset_tree_stats);
 read_attribute(state);
 read_attribute(cache_read_races);
 read_attribute(reclaim);
+read_attribute(reclaimed_journal_buckets);
 read_attribute(flush_write);
 read_attribute(writeback_keys_done);
 read_attribute(writeback_keys_failed);
@@ -687,6 +688,9 @@ SHOW(__bch_cache_set)
 	sysfs_print(reclaim,
 		    atomic_long_read(&c->reclaim));
 
+	sysfs_print(reclaimed_journal_buckets,
+		    atomic_long_read(&c->reclaimed_journal_buckets));
+
 	sysfs_print(flush_write,
 		    atomic_long_read(&c->flush_write));
 
@@ -905,6 +909,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_bset_tree_stats,
 	&sysfs_cache_read_races,
 	&sysfs_reclaim,
+	&sysfs_reclaimed_journal_buckets,
 	&sysfs_flush_write,
 	&sysfs_writeback_keys_done,
 	&sysfs_writeback_keys_failed,
-- 
2.16.4


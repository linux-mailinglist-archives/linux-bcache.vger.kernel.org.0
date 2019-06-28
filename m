Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4116C599F1
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfF1MC1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:02:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:55284 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726807AbfF1MC1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:02:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92B87B636;
        Fri, 28 Jun 2019 12:02:26 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 34/37] bcache: remove retry_flush_write from struct cache_set
Date:   Fri, 28 Jun 2019 19:59:57 +0800
Message-Id: <20190628120000.40753-35-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In struct cache_set, retry_flush_write is added for commit c4dc2497d50d
("bcache: fix high CPU occupancy during journal") which is reverted in
previous patch.

Now it is useless anymore, and this patch removes it from bcache code.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h  | 1 -
 drivers/md/bcache/journal.c | 1 -
 drivers/md/bcache/sysfs.c   | 5 -----
 3 files changed, 7 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index cb268d7c6cea..35396248a7d5 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -706,7 +706,6 @@ struct cache_set {
 
 	atomic_long_t		reclaim;
 	atomic_long_t		flush_write;
-	atomic_long_t		retry_flush_write;
 
 	enum			{
 		ON_ERROR_UNREGISTER,
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 14a4e2c44de9..1218e3cada3c 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -447,7 +447,6 @@ static void btree_flush_write(struct cache_set *c)
 		if (!btree_current_write(b)->journal) {
 			mutex_unlock(&b->write_lock);
 			/* We raced */
-			atomic_long_inc(&c->retry_flush_write);
 			goto retry;
 		}
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index d62e28643109..701a386a954c 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -83,7 +83,6 @@ read_attribute(state);
 read_attribute(cache_read_races);
 read_attribute(reclaim);
 read_attribute(flush_write);
-read_attribute(retry_flush_write);
 read_attribute(writeback_keys_done);
 read_attribute(writeback_keys_failed);
 read_attribute(io_errors);
@@ -709,9 +708,6 @@ SHOW(__bch_cache_set)
 	sysfs_print(flush_write,
 		    atomic_long_read(&c->flush_write));
 
-	sysfs_print(retry_flush_write,
-		    atomic_long_read(&c->retry_flush_write));
-
 	sysfs_print(writeback_keys_done,
 		    atomic_long_read(&c->writeback_keys_done));
 	sysfs_print(writeback_keys_failed,
@@ -936,7 +932,6 @@ static struct attribute *bch_cache_set_internal_files[] = {
 	&sysfs_cache_read_races,
 	&sysfs_reclaim,
 	&sysfs_flush_write,
-	&sysfs_retry_flush_write,
 	&sysfs_writeback_keys_done,
 	&sysfs_writeback_keys_failed,
 
-- 
2.16.4


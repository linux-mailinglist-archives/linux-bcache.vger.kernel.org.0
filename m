Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEFA995C25
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Aug 2019 12:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbfHTKRU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Aug 2019 06:17:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44747 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729736AbfHTKRT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Aug 2019 06:17:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so2509589plr.11;
        Tue, 20 Aug 2019 03:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oM8IhBRXP73PIG9ExNuj6t3hy7m4N/GP84wDNWZLfIY=;
        b=UZ577GWob5P8SQfZ5uHxnkXnZkwGG86Gn8eJF9YFFoymzkUjIpMF65R6nVG1okae+X
         qetkQIRLmC5oWh+4zycje/qIqi58J/M4nh/cfUxA5N6UAFgAL9uNuLDqFVpvlf73LmeF
         kzfoiHwyMr4YtLk8Efwh4iAWDnwQ3ObJj3Q90nNFsGU/Ud7uCOqaMP7k8KAuX3aj2w3y
         PsMxTOl4CPWIIcNHf7aquh5avaoi1txzNJVDqenMJIv8t7DyH4QNvGtQhe2Zry5qeEnw
         3b/H09a4Nm7N3Wgt0kMfq2040X3HbJtRBpCLkwIxTcfmyu+oe50L3WwwevmBn6mLW1kJ
         B83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oM8IhBRXP73PIG9ExNuj6t3hy7m4N/GP84wDNWZLfIY=;
        b=NU99JGnk4Vh09gQbgTn9AUT+w1mEY8UcBgOLGA2irjlnuEWCAxxbe4lj7bR9XCbsjq
         3h8l5sM1GkJikY27gUNF51dRpUDRZzIpelzeoaMBn78EUFxM0kd2sOl3B0OJtf03k0hs
         NcRDjxucvKozI5KLw+6e1qWPNfR7hAG963w/nX7L2q0WT79n/P8woJNPXz5dzJ4ogqvx
         DxmOxIm8IhnG4fPrAz0irZcsAeBPJXDmzHtA9rsAnlsMv+2EDYA0ond+MsxGpCMpuM09
         4CM/N0RDdubA8oHAfs7XFNL6J1MspiRM4x8Wcv8YPqaujd4HZlOEUefHXyNSSGQj87D6
         NmMw==
X-Gm-Message-State: APjAAAUKOSkyknEcYOc3K1hyZL7UJhYFdqvfL6NrhxuRY6iVeEbY7Akc
        Pz86qXE/6DvqDk6cZ9NYaF4=
X-Google-Smtp-Source: APXvYqybaPpS2nzncktOlgKf8u22/5nn7cjxA4hLRew8A+fST/nEjOd43ojJELiIMI0w2ovDEUFITg==
X-Received: by 2002:a17:902:a8:: with SMTP id a37mr11845618pla.316.1566296239132;
        Tue, 20 Aug 2019 03:17:19 -0700 (PDT)
Received: from localhost.localdomain ([23.83.226.166])
        by smtp.gmail.com with ESMTPSA id o130sm22241610pfg.171.2019.08.20.03.17.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 03:17:18 -0700 (PDT)
From:   Guoju Fang <fangguoju@gmail.com>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Guoju Fang <fangguoju@gmail.com>
Subject: [PATCH] bcache: fix a lost wake-up problem caused by mca_cannibalize_lock
Date:   Tue, 20 Aug 2019 06:13:55 -0400
Message-Id: <1566296035-25080-1-git-send-email-fangguoju@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch fix a lost wake-up problem caused by the race between
mca_cannibalize_lock and bch_cannibalize_unlock.

Consider two processes, A and B. Process A is executing
mca_cannibalize_lock, while process B takes c->btree_cache_alloc_lock
and is executing bch_cannibalize_unlock. The problem happens that after
process A executes cmpxchg and will execute prepare_to_wait. In this
timeslice process B executes wake_up, but after that process A executes
prepare_to_wait and set the state to TASK_INTERRUPTIBLE. Then process A
goes to sleep but no one will wake up it. This problem may cause bcache
device to dead.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
---
 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/btree.c  | 12 ++++++++----
 drivers/md/bcache/super.c  |  1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 013e35a..3653faf 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -582,6 +582,7 @@ struct cache_set {
 	 */
 	wait_queue_head_t	btree_cache_wait;
 	struct task_struct	*btree_cache_alloc_lock;
+	spinlock_t		btree_cannibalize_lock;
 
 	/*
 	 * When we free a btree node, we increment the gen of the bucket the
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ba434d9..7fcf079 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -884,15 +884,17 @@ static struct btree *mca_find(struct cache_set *c, struct bkey *k)
 
 static int mca_cannibalize_lock(struct cache_set *c, struct btree_op *op)
 {
-	struct task_struct *old;
-
-	old = cmpxchg(&c->btree_cache_alloc_lock, NULL, current);
-	if (old && old != current) {
+	spin_lock(&c->btree_cannibalize_lock);
+	if (likely(c->btree_cache_alloc_lock == NULL)) {
+		c->btree_cache_alloc_lock = current;
+	} else if (c->btree_cache_alloc_lock != current) {
 		if (op)
 			prepare_to_wait(&c->btree_cache_wait, &op->wait,
 					TASK_UNINTERRUPTIBLE);
+		spin_unlock(&c->btree_cannibalize_lock);
 		return -EINTR;
 	}
+	spin_unlock(&c->btree_cannibalize_lock);
 
 	return 0;
 }
@@ -927,10 +929,12 @@ static struct btree *mca_cannibalize(struct cache_set *c, struct btree_op *op,
  */
 static void bch_cannibalize_unlock(struct cache_set *c)
 {
+	spin_lock(&c->btree_cannibalize_lock);
 	if (c->btree_cache_alloc_lock == current) {
 		c->btree_cache_alloc_lock = NULL;
 		wake_up(&c->btree_cache_wait);
 	}
+	spin_unlock(&c->btree_cannibalize_lock);
 }
 
 static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 20ed838..ebb854e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1769,6 +1769,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	sema_init(&c->sb_write_mutex, 1);
 	mutex_init(&c->bucket_lock);
 	init_waitqueue_head(&c->btree_cache_wait);
+	spin_lock_init(&c->btree_cannibalize_lock);
 	init_waitqueue_head(&c->bucket_wait);
 	init_waitqueue_head(&c->gc_wait);
 	sema_init(&c->uuid_write_mutex, 1);
-- 
1.8.3.1


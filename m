Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D6B3081D3
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 00:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhA1X3Q (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 18:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhA1X3O (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 18:29:14 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815B6C061573
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 15:28:34 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id kg20so10336610ejc.4
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 15:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LhPAB63wWMLQ/c42n+YNR2BSOGoLuye0ZVC0bKgjkvk=;
        b=aNEaA+JdqKHrg9/w7ysfiFWKM7c70ra6DYa8OEhcmJAANwrux67A04eo6kv732y4P2
         409f28pwyoWjYh7kn4/p1Zb+cvAKLOG0nact4l7MMEcmwxNDtE/TQZ7wN3r31nKTvZCH
         P8nVmVaJVpJpAXX3vY/jKnCeNVIuOKUjOd8cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LhPAB63wWMLQ/c42n+YNR2BSOGoLuye0ZVC0bKgjkvk=;
        b=XClmvKsIzWfUDkANnEwj9TZtXTDstBGGG4ngzPUUsjqeVY3HhDytW3FRJ66iDVpj+0
         HDhf5VYomGeWXvR3sLrE9lI9pCHFpG2+x8HoWrGpxd9s4Kdz8dQvt8qomY15PooQPAzq
         aI4lDznP+2yZwoZMdomdmDvyudg26QzFd2bOimamBDPTiPCwZDg9OqYVVww/l17sVyh3
         LScp1SSQNpweXbqrTsdvqRzjxm5YcCXUZLRakjBbWuDrnbs2Qz3cmWbDMyQfdTHdc5ga
         gWvQe5rHSPPmt5UKu+VBQoho4SX37fmgMIIzFLeAlijNY+a7fRuNNf9efZXr956Hty8i
         bsTQ==
X-Gm-Message-State: AOAM531CdXlMKaTRZZVRcIs/J9vyS5PyjvEYTa2U4Ez7B3PE1J3LXzr7
        hQjl8/R11D1i4+bzF3H/buKVe4T/ZEyR5A==
X-Google-Smtp-Source: ABdhPJzbe7Y6ObOFLZ3B34GdwIQIyLtQvKMYnO9lS/3TSnNCofWJUQMP485F4qIYaTqrgNuuJ7kuMg==
X-Received: by 2002:a17:906:804c:: with SMTP id x12mr1846398ejw.42.1611876512871;
        Thu, 28 Jan 2021 15:28:32 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id i18sm3609883edt.68.2021.01.28.15.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 15:28:32 -0800 (PST)
Received: (nullmailer pid 20720 invoked by uid 500);
        Thu, 28 Jan 2021 23:28:29 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH v3 1/3] Revert "bcache: Kill btree_io_wq"
Date:   Fri, 29 Jan 2021 00:28:23 +0100
Message-Id: <20210128232825.18719-1-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210127132350.557935-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This reverts commit 56b30770b27d54d68ad51eccc6d888282b568cee.

With the btree using the `system_wq`, I seem to see a lot more desktop
latency than I should.

After some more investigation, it looks like the original assumption
of 56b3077 no longer is true, and bcache has a very high potential of
congesting the `system_wq`. In turn, this introduces laggy desktop
performance, IO stalls (at least with btrfs), and input events may be
delayed.

So let's revert this. It's important to note that the semantics of
using `system_wq` previously mean that `btree_io_wq` should be created
before and destroyed after other bcache wqs to keep the same
assumptions.

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kai Krakow <kai@kaishome.de>
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/btree.c  | 21 +++++++++++++++++++--
 drivers/md/bcache/super.c  |  4 ++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d57f48307e66..b1ed16c7a5341 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1042,5 +1042,7 @@ void bch_debug_exit(void);
 void bch_debug_init(void);
 void bch_request_exit(void);
 int bch_request_init(void);
+void bch_btree_exit(void);
+int bch_btree_init(void);
 
 #endif /* _BCACHE_H */
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 910df242c83df..952f022db5a5f 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -99,6 +99,8 @@
 #define PTR_HASH(c, k)							\
 	(((k)->ptr[0] >> c->bucket_bits) | PTR_GEN(k, 0))
 
+static struct workqueue_struct *btree_io_wq;
+
 #define insert_lock(s, b)	((b)->level <= (s)->lock)
 
 
@@ -308,7 +310,7 @@ static void __btree_node_write_done(struct closure *cl)
 	btree_complete_write(b, w);
 
 	if (btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	closure_return_with_destructor(cl, btree_node_write_unlock);
 }
@@ -481,7 +483,7 @@ static void bch_btree_leaf_dirty(struct btree *b, atomic_t *journal_ref)
 	BUG_ON(!i->keys);
 
 	if (!btree_node_dirty(b))
-		schedule_delayed_work(&b->work, 30 * HZ);
+		queue_delayed_work(btree_io_wq, &b->work, 30 * HZ);
 
 	set_btree_node_dirty(b);
 
@@ -2764,3 +2766,18 @@ void bch_keybuf_init(struct keybuf *buf)
 	spin_lock_init(&buf->lock);
 	array_allocator_init(&buf->freelist);
 }
+
+void bch_btree_exit(void)
+{
+	if (btree_io_wq)
+		destroy_workqueue(btree_io_wq);
+}
+
+int __init bch_btree_init(void)
+{
+	btree_io_wq = create_singlethread_workqueue("bch_btree_io");
+	if (!btree_io_wq)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2047a9cccdb5d..77c5d8b6d4316 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2821,6 +2821,7 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	bch_btree_exit();
 
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
@@ -2876,6 +2877,9 @@ static int __init bcache_init(void)
 		return bcache_major;
 	}
 
+	if (bch_btree_init())
+		goto err;
+
 	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
 	if (!bcache_wq)
 		goto err;
-- 
2.26.2


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68F6306128
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 17:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhA0Qlu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 11:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhA0QkQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 11:40:16 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE32C061756
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:40:00 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ox12so3585908ejb.2
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IiK5AvCudPzXIujDULruB+LT7FuiTYYEQPJhO7d/8+I=;
        b=FEliTycEfqDvS3n9Yb/i2SbDTtpvTIEcCqPqdcNej5+M6Ahh+zlXxbcwHtC+nTdBUQ
         hZnQpUzAOcYUXkMnoWfXnMW3M1XIMkC0QeUE9Rrn82X0obzM/3rxJ51gvhJP1+7j1sr/
         CF++Bs4s5Ta/avZgoYk7GQ8gRiJKMZ5CJfauM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IiK5AvCudPzXIujDULruB+LT7FuiTYYEQPJhO7d/8+I=;
        b=fn+b9rlb+gIrXek+XWPRoMoZth+hizLqRXIgT+ESXKtTH9l7g2gArVC6LbR+lZf98J
         OWSr5X7zE7kbswC8JstHetkIBsumRHS89xlM6xuVru059ZzxiBBugouuaHs4U5h7JsR4
         8IkWuFlx+G01wwNOIVKSSUlaQ2vEXEkVa+sqlkz4tHFUQiZ4xaS/601SbMf1Ppoovhyb
         61eifznfNQ9SIw/o+AOsIXaVOSgzsWCWfwFeyCXLx0vGxa8Lq+C+UAL73PM+7Oi1SrCW
         IaOsavC3Sx29IcNFZ9LzihVhHYI7Abxj/9qSYlLyoOrWmhgpzvQ2zYiHdY09AZeMxFfj
         6/JA==
X-Gm-Message-State: AOAM533mxO/fwcCOXOijJ6gpoWqQuSal99hNlUNbw6rjKVDn6p+ukahz
        0Eo9D6/XR7FGa6xMF/kvIPrDLjosbMwtxA==
X-Google-Smtp-Source: ABdhPJzDo6HFEmd7yGjtF92SX+vxr3X5wixIuOWmdn8fyJhe/lU3wG8VKaTq6Y/Hn9Vb+Rhkz7Fqrw==
X-Received: by 2002:a17:906:5e4c:: with SMTP id b12mr7544938eju.297.1611765599297;
        Wed, 27 Jan 2021 08:39:59 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id w12sm1584013edr.29.2021.01.27.08.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 08:39:58 -0800 (PST)
Received: (nullmailer pid 593511 invoked by uid 500);
        Wed, 27 Jan 2021 16:39:57 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 1/2] Revert "bcache: Kill btree_io_wq"
Date:   Wed, 27 Jan 2021 17:39:46 +0100
Message-Id: <20210127163947.593460-1-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210127132350.557935-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This reverts commit 56b30770b27d54d68ad51eccc6d888282b568cee.

With the btree using the system_wq, I seem to see a lot more desktop
latency than I should.

After some more investigation, it looks like the original assumption
of 56b3077 no longer is true, and bcache has a very high potential of
congesting the system_wq. In turn, this introduces laggy desktop
performance, IO stalls (at least with btrfs), and input events may be
delayed.

So let's revert this.

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
index 2047a9cccdb5d..dc4fe7eeda815 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2815,6 +2815,7 @@ static void bcache_exit(void)
 {
 	bch_debug_exit();
 	bch_request_exit();
+	bch_btree_exit();
 	if (bcache_kobj)
 		kobject_put(bcache_kobj);
 	if (bcache_wq)
@@ -2880,6 +2881,9 @@ static int __init bcache_init(void)
 	if (!bcache_wq)
 		goto err;
 
+	if (bch_btree_init())
+		goto err;
+
 	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
 	if (!bch_journal_wq)
 		goto err;
-- 
2.26.2


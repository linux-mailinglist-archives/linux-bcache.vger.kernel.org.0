Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA384308A7F
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 17:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhA2QnP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Jan 2021 11:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhA2Qmj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Jan 2021 11:42:39 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17987C0617AA
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:40:58 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id j13so11287743edp.2
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LhPAB63wWMLQ/c42n+YNR2BSOGoLuye0ZVC0bKgjkvk=;
        b=EeveDW7adIPOXf1NfNrcHWWHQi+cdKNE1jHOJ8dq4aU/NSKCbxGoeidtJj69eXwZUE
         ocoPCiUFbr6oFeqBnxGNVjWiQol8vgUWasR5cVzc+J3/1bFz5HlWSRTgjFFSGiA7JuiT
         RgXp2GKuS0Zy3V8AyvEfoE0DMV+q5wEzFtvqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LhPAB63wWMLQ/c42n+YNR2BSOGoLuye0ZVC0bKgjkvk=;
        b=NxU/gch1vAy/mTB+47xfUdbx5qB9SYfPnDw5zsZjpz6HcJRFfJIRlthNwlNTWMn76u
         ZBKh+Kdv4bY4z+m43RXT5PzDN+EFQ0W6R5UsEpWCjGNYSt0Yk7eJ87nliVrYnVaMisA4
         g904LgE3nlp8xulDQsyxK92vIIWrlVZDPSLtcfpIVgDFVXk/AiwCE58c/3mXgLhr4WJu
         FpmnZuplabsAGc5r6Op+cVn0K8eoGb46rgBfIXPQnZR/a+Vg70aJzX7ki/JiM5spvQeV
         OMnyiIWd7XyfR3deQx3Iki8p7g57l0fFgeUcXQlYcVDKSfq+iWu2Bckgcas5RXP1+hSM
         tkwg==
X-Gm-Message-State: AOAM530fG2okGEpA1b9FuXn9JD1N0/w4ip4wSF0VHK1tTWkR13lesNtP
        14edmtuHLzeVTah6o7ZOnVnMs53LXrUcUQ==
X-Google-Smtp-Source: ABdhPJwV3YoIBw/7vZUs1sX9LwVpkhL8qywav1l4IJm7HbS6zR/cQIAF4mkPo2h1J9eDrZRtX5AGJg==
X-Received: by 2002:a50:d6dc:: with SMTP id l28mr6054002edj.105.1611938441471;
        Fri, 29 Jan 2021 08:40:41 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id g2sm4050533ejk.108.2021.01.29.08.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 08:40:40 -0800 (PST)
Received: (nullmailer pid 188535 invoked by uid 500);
        Fri, 29 Jan 2021 16:40:37 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH v4 1/3] Revert "bcache: Kill btree_io_wq"
Date:   Fri, 29 Jan 2021 17:40:05 +0100
Message-Id: <20210129164007.188468-1-kai@kaishome.de>
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


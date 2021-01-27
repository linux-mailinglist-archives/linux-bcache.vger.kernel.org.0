Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB61305D16
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 14:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbhA0N07 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 08:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238180AbhA0NYq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 08:24:46 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786B7C061756
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 05:24:06 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c6so2445520ede.0
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 05:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R+fQ3FwcKK3adtik+kRXhCj15FIYlpCRgATurezHC/c=;
        b=SZ8T4G4z+ttOecp83G4rCI5QMkMOD05wcePPt8LdK841entGxopD5uRicQwuGvHFrH
         KZk0jDm2XZgeSw+3AVgmIYrCe6Tbq7yLNWrkKu+7T8l/2ex/mmTG0z7+FY9DThOk19du
         YELLRL3ecJ4O7OXZSrpKlwSaSpcu4/4v+20Jc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R+fQ3FwcKK3adtik+kRXhCj15FIYlpCRgATurezHC/c=;
        b=XKvpHAAmObeioZ3F8JZoGsb7s/rM1HbnZuC8DLXbzLBGx0x+vMwfMBabvLyfeftGXe
         1KJIifk5Z9VfgaTL0I1fjpwPhFdh2iKMlYO3KSb6zTsM88+6jrTENPEVl/wDVTQY+qSE
         TPpAcJj5H+vL/Z/pVrwV3M/t2s+nj+/RVMEnLd0LWR4B9/JVcoOGSNCYV5EAdw249jDY
         1qGoGDl90Ww0vy5oOmCr1lONgw2pFUwe7dY9V4RtaFLpw/2GS3j7PsngiLK1qaphmIBP
         x+4wG8KuIL/J0Dd04PWZmdFCOqs9gKVhRaeQ2PZz7M4kVO6OsYIsRzQL9ULKa8jkVqwY
         FuUw==
X-Gm-Message-State: AOAM533jWq+GAbOmHk4dpWOSgZ0BR1qYzRBt93bYIevvtif5jomPIhxw
        X5a0NsF5YZxrBG0sYDy2KlypAjnIX05Ycw==
X-Google-Smtp-Source: ABdhPJxQbF7xDbF21/v3y3aKEH+tbG9Od5XiOFNwr6O0PHt3R+IitmuwftVVH7ShBD7gPgt6Jp3ZiA==
X-Received: by 2002:a50:fd83:: with SMTP id o3mr8818017edt.359.1611753844865;
        Wed, 27 Jan 2021 05:24:04 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id g10sm825685ejp.37.2021.01.27.05.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 05:24:04 -0800 (PST)
Received: (nullmailer pid 558037 invoked by uid 500);
        Wed, 27 Jan 2021 13:24:02 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>
Subject: [PATCH 1/2] Revert "bcache: Kill btree_io_wq"
Date:   Wed, 27 Jan 2021 14:23:49 +0100
Message-Id: <20210127132350.557935-2-kai@kaishome.de>
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
latency than I should. So let's revert this.
---
 drivers/md/bcache/bcache.h |  2 ++
 drivers/md/bcache/btree.c  | 21 +++++++++++++++++++--
 drivers/md/bcache/super.c  |  4 ++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d57f48307e6..b1ed16c7a534 100644
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
index 910df242c83d..952f022db5a5 100644
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
index 2047a9cccdb5..dc4fe7eeda81 100644
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


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63BA305D15
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhA0N0z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 08:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbhA0NYs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 08:24:48 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05825C0613D6
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 05:24:08 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c2so2387911edr.11
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 05:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EGvs4+3Tai+1O1uU2syNKHsO+Hd31hsn/79MXSHQvAk=;
        b=gvfUSO0H1BEqvxKVAuD9loEFSROvCrHrLaMVql/Uoipi73qubNZ1bfPJ5ISs/wRsmP
         uZHjeu9LC0rKnVIy5ZJLwLWZaAbFQIx6Q/5naODp3XDQW0UH/12TGWDFoaSuco0uf69N
         bed8ojygwYsRVRDuiK8daWTXdcjP/SL/BP/l8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EGvs4+3Tai+1O1uU2syNKHsO+Hd31hsn/79MXSHQvAk=;
        b=B1lQUa9Wszq5RKm7Wv4owf9mjFh8YJAKoCFaLZjBeLyHMn6lo4eJ1ql9CjK1d6FH+O
         Y7NNpVEDFxUIgLoXNU7AZvDa4wr7vGP7ofrnl1mvAoICMyqPtLWYAlOQ1zVhy0ngUesI
         qeSxlOSS5/IW1MfMkRyH/VIxb8jAwGtITsVeOvvizhjUepuT4vgBjTiLR9ip4Alq+chU
         t7ZwmLWqFc4RZLH8Pb0kPVXf52k+3J/beApAGpsyY88CjtGcjCZ8XKudm/dcaZ8BS2Y5
         nWKcaG5vhmurxyeUYrJNFvMONUUcOt82TeyH/+8CtnMPvFgy96cZLwdIb+rfdFCkPEyi
         Jt2Q==
X-Gm-Message-State: AOAM531sDur3MjEsdGCWXKBUG0Q0JHksPmvLyltZQXxLIqLfpVwLJpdj
        90OGGmj4nmW6Uzuti2gjlTxIHTsxqCC6ZQ==
X-Google-Smtp-Source: ABdhPJwxZENmrn7lk1Y6ZJhr5BMgSS3S4etN3mky6SWpIICoMUGrlwzg4Y3HZd3YDLV+i6ppXxQqrQ==
X-Received: by 2002:a05:6402:312e:: with SMTP id dd14mr9252342edb.366.1611753846488;
        Wed, 27 Jan 2021 05:24:06 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id e11sm826444ejz.94.2021.01.27.05.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 05:24:05 -0800 (PST)
Received: (nullmailer pid 558046 invoked by uid 500);
        Wed, 27 Jan 2021 13:24:04 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>
Subject: [PATCH 2/2] bcache: Move journal work to new background wq
Date:   Wed, 27 Jan 2021 14:23:50 +0100
Message-Id: <20210127132350.557935-3-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210127132350.557935-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is potentially long running and not latency sensitive, let's get
it out of the way of other latency sensitive events.
---
 drivers/md/bcache/bcache.h  | 1 +
 drivers/md/bcache/journal.c | 4 ++--
 drivers/md/bcache/super.c   | 7 +++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index b1ed16c7a534..70565ed5732d 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1001,6 +1001,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 
 extern struct workqueue_struct *bcache_wq;
 extern struct workqueue_struct *bch_journal_wq;
+extern struct workqueue_struct *bch_background_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
 
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index aefbdb7e003b..942e97dd1755 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -932,8 +932,8 @@ atomic_t *bch_journal(struct cache_set *c,
 		journal_try_write(c);
 	} else if (!w->dirty) {
 		w->dirty = true;
-		schedule_delayed_work(&c->journal.work,
-				      msecs_to_jiffies(c->journal_delay_ms));
+		queue_delayed_work(bch_background_wq, &c->journal.work,
+				   msecs_to_jiffies(c->journal_delay_ms));
 		spin_unlock(&c->journal.lock);
 	} else {
 		spin_unlock(&c->journal.lock);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index dc4fe7eeda81..9e1481917ce6 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -49,6 +49,7 @@ static int bcache_major;
 static DEFINE_IDA(bcache_device_idx);
 static wait_queue_head_t unregister_wait;
 struct workqueue_struct *bcache_wq;
+struct workqueue_struct *bch_background_wq;
 struct workqueue_struct *bch_journal_wq;
 
 
@@ -2822,6 +2823,8 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	if (bch_background_wq)
+		destroy_workqueue(bch_background_wq);
 
 	if (bcache_major)
 		unregister_blkdev(bcache_major, "bcache");
@@ -2884,6 +2887,10 @@ static int __init bcache_init(void)
 	if (bch_btree_init())
 		goto err;
 
+	bch_background_wq = alloc_workqueue("bch_background", 0, 0);
+	if (!bch_background_wq)
+		goto err;
+
 	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
 	if (!bch_journal_wq)
 		goto err;
-- 
2.26.2


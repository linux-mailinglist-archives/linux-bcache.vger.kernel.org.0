Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1430612A
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 17:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhA0QmB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 11:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhA0Qk5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 11:40:57 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4484C0613D6
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:40:10 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id g3so3556490ejb.6
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 08:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CB2E21qOLs+mYCcgGlV2dzax3dvf8IBgQNkkeZGcVJk=;
        b=g/x0rSaze3qssegFVlEdjKpduT83xFrNTtCrzOYjY4g9EONv6O2RH1AjMXXBy/ddGK
         yzmAMyWL9o3Im+Yd1fWFPfp3hANiQLnhlV6nrBxxDU21l27UbwhiX7PqcWVDMGWXMMNF
         xsW8JxU3zVsvCi0fG9SQhmS06kPf7oPgn7kPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CB2E21qOLs+mYCcgGlV2dzax3dvf8IBgQNkkeZGcVJk=;
        b=TiOtBv1mFo1DpI4/oQ3BvBwXNfXrQ+P+bzXnGa68hRnwZeouFiwq9Nf/eeU/0BERj3
         ChBI7ZSretOShqS2zkhN25tqbtMAAE+wN44SaQxPuiFydG3pzsCTy9rSf/fonsW1+rbx
         WB3ZmHMJa1wF/irRQN0FRb9KOBV7XSssJ4SX+GYqyTb7qmGUY+BR9PYjoMx0n/Jhjffw
         cTyWCgTxxjzOXKbdjvur80f4QlrgUDHgOtZg6Xm9bwlikF32o0dgMsJ0DV0Y4R31bGO/
         JCf8LNtm5O10od3SAQzejGcaWyPVDHZHlGrKMqI+WppjZtef64rXlJ3sqGLmV6eaGDLA
         lSNg==
X-Gm-Message-State: AOAM531JPH2gHQsaTxTJC0Xx2fIi6ckDrW8rEK6d8oa6gyIoUHV/QH3J
        WCFXHgN/Qlt2mEgMagX4erBJtJwVR4A9ag==
X-Google-Smtp-Source: ABdhPJz2OTB6ceFgmJjQmf0BKG1tt1INvAb4dyXOlgu++DI+8crY4aqISyYvLE6RB4BVOlfhwbhVyA==
X-Received: by 2002:a17:906:7804:: with SMTP id u4mr7590099ejm.97.1611765609173;
        Wed, 27 Jan 2021 08:40:09 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id re19sm1090085ejb.111.2021.01.27.08.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 08:40:08 -0800 (PST)
Received: (nullmailer pid 593520 invoked by uid 500);
        Wed, 27 Jan 2021 16:40:07 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 2/2] bcache: Move journal work to new background wq
Date:   Wed, 27 Jan 2021 17:39:47 +0100
Message-Id: <20210127163947.593460-2-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210127163947.593460-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
 <20210127163947.593460-1-kai@kaishome.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is potentially long running and not latency sensitive, let's get
it out of the way of other latency sensitive events.

As observed in the previous commit, the system_wq comes easily
congested by bcache, and this fixes a few more stalls I was observing
every once in a while.

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kai Krakow <kai@kaishome.de>
---
 drivers/md/bcache/bcache.h  | 1 +
 drivers/md/bcache/journal.c | 4 ++--
 drivers/md/bcache/super.c   | 7 +++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index b1ed16c7a5341..70565ed5732d7 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1001,6 +1001,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 
 extern struct workqueue_struct *bcache_wq;
 extern struct workqueue_struct *bch_journal_wq;
+extern struct workqueue_struct *bch_background_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
 
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index aefbdb7e003bc..942e97dd17554 100644
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
index dc4fe7eeda815..9e1481917ce6a 100644
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


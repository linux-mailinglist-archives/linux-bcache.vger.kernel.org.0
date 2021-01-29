Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192BE308A81
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 17:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhA2Qni (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Jan 2021 11:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhA2Qm5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Jan 2021 11:42:57 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50DDC0617A9
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:40:52 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id r12so13924615ejb.9
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C3MU3c1aqixRzDm5W95Om9bs0gXTryRpL0x1LIcl+0s=;
        b=hAJNPwMxihg495x/5JlzRPjhKiN6w9o8RXt/OCwcigUtPEb/HG/h/U1z90Gd9e2WYl
         DgOQydnJF8NoQ4YFnjq6OP9rH/lmEDyqwZBfAhxHs7I0jJfxrfDRiEmM/N5CLSYwvnbj
         y+k4XS1hVfus+5B5kZl3zJ6K+TUIQaIE9Kx8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C3MU3c1aqixRzDm5W95Om9bs0gXTryRpL0x1LIcl+0s=;
        b=axxyt3DPulooSupvzuvDMAYddz+Uco5HK4RKKy4qIiUJHkhw7KZ3MwBHNAN1aZ858r
         pdQ2AF/7yiwMJfQcLb0j8cPRStzYofFuXjWvfhQAtMsMihnCxFQVgXXkiRFCeZotvD3Y
         H83zkqMm7PLHdGr8C/vU8SwugEAv71q+s6L6gguleQ4vfSOqB9Ttj6MsDPbZXqk+I4gl
         H9cAgoDCXixHyybJAslXDubDVbgz/rjapGc1Klr2Pf3izmFm75V0dayiJ6NQk1eXQg/2
         ykH7RNBRPnIUQrVMF282tJVDn8b9MUEsllY7sIwpWVtLW2weScK0DWNQcDkaXyN8Iir+
         0XwQ==
X-Gm-Message-State: AOAM533DfqQNTfTMqc/4sk7SYgNypGGN/rAVE+AOY6b08Im7mcRm4+cL
        dUsqfMB/jKkJgcTFb4pG0KCdg0qXxwx4Gw==
X-Google-Smtp-Source: ABdhPJz6xeNx2LjtggAaUkYsMnnyBpjFwyLaS6JxcY/t8rYwJKGYok3nA+VEvBsGpsrHcWF3K0TMQA==
X-Received: by 2002:a17:906:2743:: with SMTP id a3mr5579493ejd.378.1611938451325;
        Fri, 29 Jan 2021 08:40:51 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id k26sm4955841eds.41.2021.01.29.08.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 08:40:50 -0800 (PST)
Received: (nullmailer pid 188540 invoked by uid 500);
        Fri, 29 Jan 2021 16:40:38 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH v4 3/3] bcache: Move journal work to new flush wq
Date:   Fri, 29 Jan 2021 17:40:07 +0100
Message-Id: <20210129164007.188468-3-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129164007.188468-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
 <20210129164007.188468-1-kai@kaishome.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is potentially long running and not latency sensitive, let's get
it out of the way of other latency sensitive events.

As observed in the previous commit, the `system_wq` comes easily
congested by bcache, and this fixes a few more stalls I was observing
every once in a while.

Let's not make this `WQ_MEM_RECLAIM` as it showed to reduce performance
of boot and file system operations in my tests. Also, without
`WQ_MEM_RECLAIM`, I no longer see desktop stalls. This matches the
previous behavior as `system_wq` also does no memory reclaim:

> // workqueue.c:
> system_wq = alloc_workqueue("events", 0, 0);

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kai Krakow <kai@kaishome.de>
---
 drivers/md/bcache/bcache.h  |  1 +
 drivers/md/bcache/journal.c |  4 ++--
 drivers/md/bcache/super.c   | 16 ++++++++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index b1ed16c7a5341..e8bf4f752e8be 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1001,6 +1001,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent);
 
 extern struct workqueue_struct *bcache_wq;
 extern struct workqueue_struct *bch_journal_wq;
+extern struct workqueue_struct *bch_flush_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
 
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index aefbdb7e003bc..c6613e8173337 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -932,8 +932,8 @@ atomic_t *bch_journal(struct cache_set *c,
 		journal_try_write(c);
 	} else if (!w->dirty) {
 		w->dirty = true;
-		schedule_delayed_work(&c->journal.work,
-				      msecs_to_jiffies(c->journal_delay_ms));
+		queue_delayed_work(bch_flush_wq, &c->journal.work,
+				   msecs_to_jiffies(c->journal_delay_ms));
 		spin_unlock(&c->journal.lock);
 	} else {
 		spin_unlock(&c->journal.lock);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 77c5d8b6d4316..7457ec160c9a1 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -49,6 +49,7 @@ static int bcache_major;
 static DEFINE_IDA(bcache_device_idx);
 static wait_queue_head_t unregister_wait;
 struct workqueue_struct *bcache_wq;
+struct workqueue_struct *bch_flush_wq;
 struct workqueue_struct *bch_journal_wq;
 
 
@@ -2821,6 +2822,8 @@ static void bcache_exit(void)
 		destroy_workqueue(bcache_wq);
 	if (bch_journal_wq)
 		destroy_workqueue(bch_journal_wq);
+	if (bch_flush_wq)
+		destroy_workqueue(bch_flush_wq);
 	bch_btree_exit();
 
 	if (bcache_major)
@@ -2884,6 +2887,19 @@ static int __init bcache_init(void)
 	if (!bcache_wq)
 		goto err;
 
+	/*
+	 * Let's not make this `WQ_MEM_RECLAIM` for the following reasons:
+	 *
+	 * 1. It used `system_wq` before which also does no memory reclaim.
+	 * 2. With `WQ_MEM_RECLAIM` desktop stalls, increased boot times, and
+	 *    reduced throughput can be observed.
+	 *
+	 * We still want to user our own queue to not congest the `system_wq`.
+	 */
+	bch_flush_wq = alloc_workqueue("bch_flush", 0, 0);
+	if (!bch_flush_wq)
+		goto err;
+
 	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
 	if (!bch_journal_wq)
 		goto err;
-- 
2.26.2


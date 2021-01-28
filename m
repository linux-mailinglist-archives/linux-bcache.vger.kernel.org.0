Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5018230742D
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 11:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhA1KwL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 05:52:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbhA1Kv0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 05:51:26 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F257C061574
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 02:50:46 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id a10so7017075ejg.10
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 02:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d0q4J0pLOx4U78pZQMzC3oVAq6COBMBUeyhFT903TuY=;
        b=kFsqPNx8P7n6OjsvhvdCAh4cH+B7bN7zIXGXXfnhVZe+Aij9DurA5IMMn2YR/tD6oA
         XXzuj4pKRICfCw8/UPFSgwcXw7Ybx8otKChx8uoUtd2Wq/5wzIxqQTzBgjP7YtRC2Df/
         sKGdzLnmjkG+/8/icHWBFMpoIvgnL/5Y0n7tw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d0q4J0pLOx4U78pZQMzC3oVAq6COBMBUeyhFT903TuY=;
        b=WVkVfqIG2BBIeHmKwNGkgN97DwzQRmShX2UZfJW8t5JVNM8wuF2KJ+3IJrUCfrzPbc
         esRowpLD2OWVCcamdBHdGU+1hZHPeBwnpa2omBhTqG5DknHkjgwoi/QRC7HB8UvayzSM
         H00nZ6Gqa8I87ZOodtiRcB8onS9jnXGGDWfHz6eJe5U3+KBR3hD6lN0opMQQ72tj92zM
         RRxG/nHTWfkSAhYV9RV9TU3qQ/8KsKz1CvsGe9MPKWcKA/o/fF89GSXrQHqVpFV4lC0a
         9Ki7fsAXVd42wZuAV3HQ9rbh97ubIM04BzfYxHKXyP8L21SiJ3qOVmwr68z5LabP6EbG
         TMUQ==
X-Gm-Message-State: AOAM5323EbvXUmsacsI1ZRexPQaZHd+1HlzN+hn/fVAaTIu0oQo1s8tw
        I7vWfs87buOUqB0cON2JatamYxntfovIaA==
X-Google-Smtp-Source: ABdhPJxExXbDDKs5Oqz9nneeRHqftha3nx04kXVRVuGKRuTxOAFW/ZbRDO1ivDT7vQmGB21FvV5aGg==
X-Received: by 2002:a17:906:1f03:: with SMTP id w3mr10450020ejj.463.1611831044648;
        Thu, 28 Jan 2021 02:50:44 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id n2sm2223894ejl.1.2021.01.28.02.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 02:50:44 -0800 (PST)
Received: (nullmailer pid 176755 invoked by uid 500);
        Thu, 28 Jan 2021 10:50:42 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH v2 2/2] bcache: Move journal work to new background wq
Date:   Thu, 28 Jan 2021 11:50:34 +0100
Message-Id: <20210128105034.176668-2-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128105034.176668-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
 <20210128105034.176668-1-kai@kaishome.de>
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
index dc4fe7eeda815..5206c037c13f3 100644
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
 
+	bch_background_wq = alloc_workqueue("bch_background", WQ_MEM_RECLAIM, 0);
+	if (!bch_background_wq)
+		goto err;
+
 	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
 	if (!bch_journal_wq)
 		goto err;
-- 
2.26.2


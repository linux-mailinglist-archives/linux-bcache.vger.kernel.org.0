Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF1D3081F7
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 00:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhA1Xc6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 18:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhA1X3S (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 18:29:18 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2BEC06174A
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 15:28:38 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id d22so8589865edy.1
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 15:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3QWZ+6bip5zrgp59vDcbGvnhx7Nigo4jtTU0d5GcJLE=;
        b=ESuwtbk1wYMSgzwbwKRDNnwZ8EuPTytr49d0irWUwzM/OND7x1chXdZ9F45nsIDEqO
         AfPExDyyTn1lG6LJLskrhSzMsowlCKXcSFqWGivzwg38f7b5tv2/T6vaTzgfb+N7mIGk
         5y6uVZCLKH5n29GG1ZYBjXWQTjGdycC2PS+pY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3QWZ+6bip5zrgp59vDcbGvnhx7Nigo4jtTU0d5GcJLE=;
        b=f4DgJAjrFOuWu8mQeCpEgQGlH+prXDFUGg22gf5nF7uLQ0O/bnC02ob1VY7jvyuaL/
         muT2u0nE1CzKch9Ln4apT8PjcL/NGEY6qFeP10VR/7dpsLUgWT9JEFNwTj/zWv3CVw+Z
         do2Nxj1nTNwaiHLVI8dyCdNapaYkZX8CN5tCZq6uMyIJOL1ZIqlYzpcHGTwcQuZQE1dv
         UMN5V1mOsdwapNOf2HtFeZJifryrqPMISMdhQWZW9vld/N0Zk2TMhXJ6vI5EBj/EYR2I
         I5O3PJbd6vrC4ysxTSL0tx6Vgtq7HPKGm3u4MwhxH15lOAGiH+ONjLPWUvldWWp2S5Pt
         Y9wA==
X-Gm-Message-State: AOAM531mMg2ww7ihRvVUleQByxEakOlHZKkqX8sn4+PbEfDt2B6zw9CO
        dLbLNU80QuJB0aQKV8ueQdWOLEagqNd5ag==
X-Google-Smtp-Source: ABdhPJxZjnAWlCPiKEFnrJ+r3TuwssWFHPlTA2dar3wJg+GBkc/adef4o8sBF5kgIiCcxAtVoSTC9A==
X-Received: by 2002:aa7:ca55:: with SMTP id j21mr2217519edt.172.1611876516701;
        Thu, 28 Jan 2021 15:28:36 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id z25sm2908750ejd.23.2021.01.28.15.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 15:28:36 -0800 (PST)
Received: (nullmailer pid 21271 invoked by uid 500);
        Thu, 28 Jan 2021 23:28:35 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH v3 3/3] bcache: Move journal work to new background wq
Date:   Fri, 29 Jan 2021 00:28:25 +0100
Message-Id: <20210128232825.18719-3-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128232825.18719-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
 <20210128232825.18719-1-kai@kaishome.de>
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
 drivers/md/bcache/bcache.h  | 1 +
 drivers/md/bcache/journal.c | 4 ++--
 drivers/md/bcache/super.c   | 7 +++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

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
index 77c5d8b6d4316..817b36c39b4fc 100644
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
@@ -2884,6 +2887,10 @@ static int __init bcache_init(void)
 	if (!bcache_wq)
 		goto err;
 
+	bch_flush_wq = alloc_workqueue("bch_flush", 0, 0);
+	if (!bch_flush_wq)
+		goto err;
+
 	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
 	if (!bch_journal_wq)
 		goto err;
-- 
2.26.2


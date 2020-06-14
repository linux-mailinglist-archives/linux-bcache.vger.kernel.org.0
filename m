Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CEA1F89B7
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Jun 2020 18:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgFNQxt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 14 Jun 2020 12:53:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:47062 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgFNQxs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 Jun 2020 12:53:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2C6D5AE00;
        Sun, 14 Jun 2020 16:53:51 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] bcache: use delayed kworker fo asynchronous devices registration
Date:   Mon, 15 Jun 2020 00:53:32 +0800
Message-Id: <20200614165333.124999-4-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200614165333.124999-1-colyli@suse.de>
References: <20200614165333.124999-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

This patch changes the asynchronous registration kworker to a delayed
kworker. There is probability queue_work() queues the async registration
kworker to the same CPU (even though very little), then the process
which writing sysfs interface to reigster bcache device may won't return
immeidately. queue_delayed_work() in this patch will delay 10 jiffies
before insert the kworker to run queue, which makes sure the registering
process may always returns to user space in time.

Fixes: 9e23ccf8f0a22 ("bcache: asynchronous devices registration")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/super.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 904ea9bbb5c4..a6e79083010a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -19,6 +19,7 @@
 #include <linux/genhd.h>
 #include <linux/idr.h>
 #include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/reboot.h>
@@ -2380,7 +2381,7 @@ static bool bch_is_open(struct block_device *bdev)
 }
 
 struct async_reg_args {
-	struct work_struct reg_work;
+	struct delayed_work reg_work;
 	char *path;
 	struct cache_sb *sb;
 	struct cache_sb_disk *sb_disk;
@@ -2391,7 +2392,7 @@ static void register_bdev_worker(struct work_struct *work)
 {
 	int fail = false;
 	struct async_reg_args *args =
-		container_of(work, struct async_reg_args, reg_work);
+		container_of(work, struct async_reg_args, reg_work.work);
 	struct cached_dev *dc;
 
 	dc = kzalloc(sizeof(*dc), GFP_KERNEL);
@@ -2421,7 +2422,7 @@ static void register_cache_worker(struct work_struct *work)
 {
 	int fail = false;
 	struct async_reg_args *args =
-		container_of(work, struct async_reg_args, reg_work);
+		container_of(work, struct async_reg_args, reg_work.work);
 	struct cache *ca;
 
 	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
@@ -2449,11 +2450,12 @@ static void register_cache_worker(struct work_struct *work)
 static void register_device_aync(struct async_reg_args *args)
 {
 	if (SB_IS_BDEV(args->sb))
-		INIT_WORK(&args->reg_work, register_bdev_worker);
+		INIT_DELAYED_WORK(&args->reg_work, register_bdev_worker);
 	else
-		INIT_WORK(&args->reg_work, register_cache_worker);
+		INIT_DELAYED_WORK(&args->reg_work, register_cache_worker);
 
-	queue_work(system_wq, &args->reg_work);
+	/* 10 jiffies is enough for a delay */
+	queue_delayed_work(system_wq, &args->reg_work, 10);
 }
 
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
-- 
2.25.0


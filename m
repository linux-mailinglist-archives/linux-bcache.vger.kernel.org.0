Return-Path: <linux-bcache+bounces-1252-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6722EC55D26
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 06:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C2B33B0733
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 05:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE7E303CAF;
	Thu, 13 Nov 2025 05:36:51 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D2BEED8;
	Thu, 13 Nov 2025 05:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763012211; cv=none; b=sknu5NUy0k2Kr5uGM7dY43Qw10PwKjYG7JS4yav1Gs/fBvnH1amAetioq4PVVgA5nQqLngEpwbN7g/V0QaVlu33r2NCTPQCXvxDZMGmppLKAvFe2IAMiztA4j1uW5jeiGllugjT7JPi3n+RxfSquguhlpuj9X/dlGMvlMe7aSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763012211; c=relaxed/simple;
	bh=0NWMHwUMfq6CLAqHnV9rinp7uGxwV+zyXXUOQIoINUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4vzoUvbuA18OIkC0UnXHnfmVIM9AZER1YJK0Z1pteqdAzOQk1I3nNiddH1qXVvnigBLtM4LjIDRFgf3Vkkx8DOcnKZ+sFAHJ5MtAU5cznqfQKFmpFl0CcDJgxaxXY0a7lORtCcO/ndR/v4LMGrivLBy95vOOQ1pftyw8wImSRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12D4C2BC86;
	Thu, 13 Nov 2025 05:36:48 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Marco Crivellari <marco.crivellari@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 7/9] bcache: replace use of system_wq with system_percpu_wq
Date: Thu, 13 Nov 2025 13:36:28 +0800
Message-ID: <20251113053630.54218-8-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113053630.54218-1-colyli@fnnas.com>
References: <20251113053630.54218-1-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Marco Crivellari <marco.crivellari@suse.com>

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistency cannot be addressed without refactoring the API.

This patch continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

system_wq should be the per-cpu workqueue, yet in this name nothing makes
that clear, so replace system_wq with system_percpu_wq.

The old wq (system_wq) will be kept for a few release cycles.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/super.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 91a98ebc3f80..92ced6b28cb2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1388,7 +1388,7 @@ static CLOSURE_CALLBACK(cached_dev_flush)
 	bch_cache_accounting_destroy(&dc->accounting);
 	kobject_del(&d->kobj);
 
-	continue_at(cl, cached_dev_free, system_wq);
+	continue_at(cl, cached_dev_free, system_percpu_wq);
 }
 
 static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
@@ -1400,7 +1400,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 	__module_get(THIS_MODULE);
 	INIT_LIST_HEAD(&dc->list);
 	closure_init(&dc->disk.cl, NULL);
-	set_closure_fn(&dc->disk.cl, cached_dev_flush, system_wq);
+	set_closure_fn(&dc->disk.cl, cached_dev_flush, system_percpu_wq);
 	kobject_init(&dc->disk.kobj, &bch_cached_dev_ktype);
 	INIT_WORK(&dc->detach, cached_dev_detach_finish);
 	sema_init(&dc->sb_write_mutex, 1);
@@ -1513,7 +1513,7 @@ static CLOSURE_CALLBACK(flash_dev_flush)
 	bcache_device_unlink(d);
 	mutex_unlock(&bch_register_lock);
 	kobject_del(&d->kobj);
-	continue_at(cl, flash_dev_free, system_wq);
+	continue_at(cl, flash_dev_free, system_percpu_wq);
 }
 
 static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
@@ -1525,7 +1525,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 		goto err_ret;
 
 	closure_init(&d->cl, NULL);
-	set_closure_fn(&d->cl, flash_dev_flush, system_wq);
+	set_closure_fn(&d->cl, flash_dev_flush, system_percpu_wq);
 
 	kobject_init(&d->kobj, &bch_flash_dev_ktype);
 
@@ -1833,7 +1833,7 @@ static CLOSURE_CALLBACK(__cache_set_unregister)
 
 	mutex_unlock(&bch_register_lock);
 
-	continue_at(cl, cache_set_flush, system_wq);
+	continue_at(cl, cache_set_flush, system_percpu_wq);
 }
 
 void bch_cache_set_stop(struct cache_set *c)
@@ -1863,10 +1863,10 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 
 	__module_get(THIS_MODULE);
 	closure_init(&c->cl, NULL);
-	set_closure_fn(&c->cl, cache_set_free, system_wq);
+	set_closure_fn(&c->cl, cache_set_free, system_percpu_wq);
 
 	closure_init(&c->caching, &c->cl);
-	set_closure_fn(&c->caching, __cache_set_unregister, system_wq);
+	set_closure_fn(&c->caching, __cache_set_unregister, system_percpu_wq);
 
 	/* Maybe create continue_at_noreturn() and use it here? */
 	closure_set_stopped(&c->cl);
@@ -2528,7 +2528,7 @@ static void register_device_async(struct async_reg_args *args)
 		INIT_DELAYED_WORK(&args->reg_work, register_cache_worker);
 
 	/* 10 jiffies is enough for a delay */
-	queue_delayed_work(system_wq, &args->reg_work, 10);
+	queue_delayed_work(system_percpu_wq, &args->reg_work, 10);
 }
 
 static void *alloc_holder_object(struct cache_sb *sb)
@@ -2909,11 +2909,11 @@ static int __init bcache_init(void)
 	/*
 	 * Let's not make this `WQ_MEM_RECLAIM` for the following reasons:
 	 *
-	 * 1. It used `system_wq` before which also does no memory reclaim.
+	 * 1. It used `system_percpu_wq` before which also does no memory reclaim.
 	 * 2. With `WQ_MEM_RECLAIM` desktop stalls, increased boot times, and
 	 *    reduced throughput can be observed.
 	 *
-	 * We still want to user our own queue to not congest the `system_wq`.
+	 * We still want to user our own queue to not congest the `system_percpu_wq`.
 	 */
 	bch_flush_wq = alloc_workqueue("bch_flush", 0, 0);
 	if (!bch_flush_wq)
-- 
2.47.3



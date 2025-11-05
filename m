Return-Path: <linux-bcache+bounces-1233-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B782C36283
	for <lists+linux-bcache@lfdr.de>; Wed, 05 Nov 2025 15:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A94918C60FB
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Nov 2025 14:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16D5324B1C;
	Wed,  5 Nov 2025 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FeFHczlX"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03CD23EA92
	for <linux-bcache@vger.kernel.org>; Wed,  5 Nov 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762354258; cv=none; b=sKepi3upitXnbGXCdjQTeADaZdFGIKctpKj/6PZwJVpTiF1cI9DlLhASr0Zlts51Db5oS9g/2HtMfaPQQdWx/geafKiePxnPuIQOICaVPr7y2s5vc5PV5JioWMEO+vsWbNlxtIGkdGiEIdAcyGsetz5E/vj4xktgmhVYV2j0364=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762354258; c=relaxed/simple;
	bh=Kzf3O5Pfv0M6xSM+kEXKJUJ8D5H545XidDJ6k27PEAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOEEFNQ2GXN9weGbojAWIS64uTeThKUGCak7W5C6ZpGO6IK9dNY4xhO2j1jdTf6/mnSeiY5V/Nsbfx6eXubiUJQlhXQtefp732lN1YtDGrInfOubFEZwcuZ2WjEvOCU02xDu/FLzbXyq0jgfwL89e3ovjfbfcHPBlol6F3hXh7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FeFHczlX; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429c2f6a580so1685180f8f.1
        for <linux-bcache@vger.kernel.org>; Wed, 05 Nov 2025 06:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762354255; x=1762959055; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iqpU7301ZddzKgkBJ5b+qets1xyPEBx6ArgKTOvQVg=;
        b=FeFHczlXxH385gVhfQit/crSWV+w98r5GrQopgF6J8k1z2JHuflftFGcZffBvnVi93
         orO+1P0yiNznRWjwbovh+mznlU49lLk4izxM102Ngm74DX/1rTyg7oX0shELO2psy2Sk
         jWxTTfgTmGF+eaEZWBiL1NxahyB2WLX1gh/EbHQvu7NdeNP96ZaWmJeC0YaWPBYgupNi
         z4rHxZ6UzgRaAxjbAOFaR6DtvC2tmdB/PZbBBDA9UcECRGg1/hjl5oFt1Gd/qm+aFIsN
         DZJfnzitFyO8PYXuVlOut5Hr8mm9Xgk2ohGwhGfgjC//u8QBMH28d7PxvYsyGO2Zkw9A
         iZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762354255; x=1762959055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iqpU7301ZddzKgkBJ5b+qets1xyPEBx6ArgKTOvQVg=;
        b=SYvdlyxt95+3rx4kERSOk9VwDnG6v1tEq9pGGV2Nv5U1FrFTnXVEG8C4271hqus9Nt
         nB0BlyRhf/uEOgCuCaq3dCmqKsfmxCc2o68KhUXExWId+00Av8Z/KO9cLu2XuG3y7g6N
         TNjR6oFASPh4w+3rc4+1yE/5MuAI2Ghl6qNkDDuShrHyG8mjZQpIEqWKfcZjWCL2bEkD
         OLWkp8nV4au9VFF0VwRALRB0eJ7vQOPVvjzIHifYPskyPXOObxSmLxl4ZC5WRJXqMSGL
         +vj3jVIkbzvbPhST+3xDPRXGaml4J5ZxC34TO6KiYXNlqe73Kn31bK6sWQJ5xX2fbwmS
         p1ug==
X-Forwarded-Encrypted: i=1; AJvYcCVkRBfOnS67Gx5YGJeLp8zM51rwbwAF5kjlXnEW5kta1VlPRSqEz5UZs1xJ9KeyOtkL091R8zbomCqTNbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBlwiZxzTYI1ww8KLtYlpoyzee6koBYVABuopofCae2AgO9Kw4
	k3qv6fOZcPOq8UJ1hkI4Y3TDKmFXRu8+qookCJKK1Q+Q5FBWTUZzR9joVx4T48RZw68=
X-Gm-Gg: ASbGncswk9IBoGbBGshMC9uDwbPP3UAV8+L8tmKRXQA199vHv3NVPdTPbl44nMCOu9i
	srXMrqxP8fCVFAkMoAoRaZTjA+vt1nIRxzMmkDBEdBhTcAl4yWdbywLY53wLU2z63BxAzx0PAfI
	7LWBCWy0pvTHA6hTJxzLSOJS/3ZiueWQss4K6i5pbwour0qhxMvkB2lPCORgFoU/SkSZp4eWs/3
	a0Kh5+HyPRYpmYcLdN4pwZfcKI0KAxKs+xmlyR1joyy/jd9pwJKWpkyBgD7VisVTS2gBdQhLqzd
	C8sVp1ackdJlOLVaPv2eoanre+RxTZk1q31YDw8wfcy5GvilHxrfXZviEzDwcQUPg6cCEGiNGbw
	AdkXRUf75ITycHLH+ONizrj95bHnEAekujc2gqndQclvkKmZCfJfq+bDll70gCCHmX/1xjrKDmb
	xSc4rcOCjQMxcWBZfeOGReGJE=
X-Google-Smtp-Source: AGHT+IFrhRlSR2BV3K3SsNYVanRi/LbVHaUuwWiyIlYFXbJgyiRM66Wm0VZiulUCa1X98AgblCJWxQ==
X-Received: by 2002:a05:6000:210c:b0:429:c851:69b3 with SMTP id ffacd0b85a97d-429e3307472mr2299746f8f.30.1762354254929;
        Wed, 05 Nov 2025 06:50:54 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f5ccasm10662873f8f.25.2025.11.05.06.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:50:54 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Coly Li <colyli@fnnas.com>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcache: replace use of system_wq with system_percpu_wq
Date: Wed,  5 Nov 2025 15:50:42 +0100
Message-ID: <20251105145043.231927-2-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251105145043.231927-1-marco.crivellari@suse.com>
References: <20251105145043.231927-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 drivers/md/bcache/super.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 6d250e366412..8ce50753ae28 100644
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
@@ -2531,7 +2531,7 @@ static void register_device_async(struct async_reg_args *args)
 		INIT_DELAYED_WORK(&args->reg_work, register_cache_worker);
 
 	/* 10 jiffies is enough for a delay */
-	queue_delayed_work(system_wq, &args->reg_work, 10);
+	queue_delayed_work(system_percpu_wq, &args->reg_work, 10);
 }
 
 static void *alloc_holder_object(struct cache_sb *sb)
@@ -2912,11 +2912,11 @@ static int __init bcache_init(void)
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
2.51.1



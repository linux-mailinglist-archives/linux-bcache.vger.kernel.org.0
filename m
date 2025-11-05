Return-Path: <linux-bcache+bounces-1234-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C6623C362DD
	for <lists+linux-bcache@lfdr.de>; Wed, 05 Nov 2025 15:55:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D06E74ED994
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Nov 2025 14:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE1832E13B;
	Wed,  5 Nov 2025 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Mikref44"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF835246BB2
	for <linux-bcache@vger.kernel.org>; Wed,  5 Nov 2025 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762354259; cv=none; b=MNPxCl52mAxVhSEH3cqU0tdKrF1G2xx509WzCnDzyFAlTFqPCfnS6ZtpdN+0j56CfdLaebKL0Blp6EPSZoWntPqyWqOiof1L/slWzfOIFbyAPQnPdd6dBGkzjPyHC3g/4yZBIn6+lqcgFXDOrPK3veqiXV57zFxQ7ovvFyR889s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762354259; c=relaxed/simple;
	bh=ewgCy57GvvNL/4ckT/tDm1bzqS9HtAnggSwRh9X34wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=isskDDNq1oUEw83nOPuqvzzJeoBWciQXaZhn1dWEQzx8+uJ3q2c1J1/P0fl/xbheFTmgTdTvxf1cLl7eDkjst1BR57bSf8JmRQ68Gc8YKYPvtw6hDU97TtvAKthWRQXYiQh02pLZR3D9E9yl9HmMYfzPn2ay8q5qzKZ4oK4nrA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Mikref44; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-429bcddad32so4290538f8f.3
        for <linux-bcache@vger.kernel.org>; Wed, 05 Nov 2025 06:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762354256; x=1762959056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSAtykixYoDc8mDqE0NZFVUWNpp9tkRehnUBmieVPhM=;
        b=Mikref44xLhnzAoTkV32Y1KJQ1UqjarEHeCQKpsFG34Duij+eNf/0WNEl0cFHXTGyD
         T+mjaKBToX1BCCL9StF1srwbtDyIcpVAhNJ/HBEQJDmI5FGRj+2pFQkVTMGiAQlG09eu
         pGnyGUHfu6b3hDae66NphwcfozcWxgQLEIbKTUTmJLWuGlptCUdGwZvPFWV9pouvoEYM
         lMyxQXfGEi2FlqJCZyhS/ilq+qdUrJLk4ob6cQG9i9Ih/N4imCbBTsB0iBOGE3CSpSgR
         al5yw+vCpCdPQGE1OBCbKBPBwz/C0W7T9TkVOOohuEXonnTa0Cx7K9XBRwQBBBlIemSe
         4/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762354256; x=1762959056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oSAtykixYoDc8mDqE0NZFVUWNpp9tkRehnUBmieVPhM=;
        b=SwdbO5RhFmmKb/VtV/q7fc4lRVHBZ4jmqDCN4POoDEofHBdQUIl46FGDKQMHdRBd7Y
         xthieOiToAXh/t1BDtSdFCAABqOpL3lqn5o8aEbIVMN/AcJi6G90WiztvHtKkHzvHbxL
         4aRFsoKev6RtiSjVnT/G0hUjhm6YrUpiukbg8QO4Sk1bBTHuWLGiuwCkCzsto1LH31J1
         weR4ANkgz6ghftkqV+Ur7D8nKtog4eqt3J7MDfneS6DucIMTQmJVgn6IVpQB0QWZLnE0
         npXi2Of+UYD1JYeD7+5Mn6TYpDs3KdWSeEswgU21s26HOdduM09kwuizsvwWE4SQE2Wv
         UC1g==
X-Forwarded-Encrypted: i=1; AJvYcCVKUvJXOZtqC2n4rhHgO7NsxEOqSBi49qSSzzjDTysQdlZdFdnUspSHMDKvQn6tD6JVfHn+KNHx0T9Njeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEPojhH7HDZXA43OITPoIU+MhrwLou9kgW8Q/6qnDu4sfMGKPG
	NQVZUTy9NMLbr4/jNT8NcSBzTHswLsjlLfuctbOjNPoPnS8IDAWrfyNctx3jYpggXSc=
X-Gm-Gg: ASbGncsqcjr0v7bXag+1Pq7nRTkaplEyltF/j1dCtXDyZCf1hzU+VVUk7O8XqFfdrL4
	jFK0VNR44cS5Lsj9Q6MadquTgYTeTqYv21k3/rPWjuO0CGSE0XXOtYRFKPJObWVoZK1a6rEYjvp
	G9xQ5ehpUC1mfpadtL/dFyaXgGKLJW1jjmd2KjeUkM/F8Yc565ifidGV/ePkVadbXWHs48Qy3Xo
	kO3dFi51U359gwGnqrm8nh8q/5cZh7yOj61SCSzzN9d4K2T+SxVbZSb+qblXl0YMTESUPJCXKh4
	4Q9PS17HIqv21UlN2LUbk8pUQIOT1HY053qgy5MDY/2tnaMU4eKubZLDABRrO3jRQm4i4sLFybC
	8Y3uFF4+BoAW7uODO0VXMJwwT97tsN4EZ+Les93qe/pmLGiMqotQfdDNVWLtk/xHawZRW2IBkek
	14GgXRIO8c65CbKA77utCpdpc=
X-Google-Smtp-Source: AGHT+IFIMPHuR2cFy/+vGAJGaRdbo/j8v+7gg3T/Gz/ibk8ShofabyYEEVWonAEzkaYjj7GUmFmuDA==
X-Received: by 2002:a05:6000:2282:b0:3e7:5f26:f1e5 with SMTP id ffacd0b85a97d-429e32e4607mr3152625f8f.23.1762354255926;
        Wed, 05 Nov 2025 06:50:55 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f5ccasm10662873f8f.25.2025.11.05.06.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:50:55 -0800 (PST)
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
Subject: [PATCH 2/2] bcache: WQ_PERCPU added to alloc_workqueue users
Date: Wed,  5 Nov 2025 15:50:43 +0100
Message-ID: <20251105145043.231927-3-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251105145043.231927-1-marco.crivellari@suse.com>
References: <20251105145043.231927-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistentcy cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This patch continues the effort to refactor worqueue APIs, which has begun
with the change introducing new workqueues and a new alloc_workqueue flag:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/md/bcache/btree.c     |  3 ++-
 drivers/md/bcache/super.c     | 10 ++++++----
 drivers/md/bcache/writeback.c |  2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 210b59007d98..e7b8c688d963 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2822,7 +2822,8 @@ void bch_btree_exit(void)
 
 int __init bch_btree_init(void)
 {
-	btree_io_wq = alloc_workqueue("bch_btree_io", WQ_MEM_RECLAIM, 0);
+	btree_io_wq = alloc_workqueue("bch_btree_io",
+				      WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!btree_io_wq)
 		return -ENOMEM;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8ce50753ae28..a0425351c179 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1939,7 +1939,8 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	if (!c->uuids)
 		goto err;
 
-	c->moving_gc_wq = alloc_workqueue("bcache_gc", WQ_MEM_RECLAIM, 0);
+	c->moving_gc_wq = alloc_workqueue("bcache_gc",
+					  WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!c->moving_gc_wq)
 		goto err;
 
@@ -2905,7 +2906,7 @@ static int __init bcache_init(void)
 	if (bch_btree_init())
 		goto err;
 
-	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
+	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!bcache_wq)
 		goto err;
 
@@ -2918,11 +2919,12 @@ static int __init bcache_init(void)
 	 *
 	 * We still want to user our own queue to not congest the `system_percpu_wq`.
 	 */
-	bch_flush_wq = alloc_workqueue("bch_flush", 0, 0);
+	bch_flush_wq = alloc_workqueue("bch_flush", WQ_PERCPU, 0);
 	if (!bch_flush_wq)
 		goto err;
 
-	bch_journal_wq = alloc_workqueue("bch_journal", WQ_MEM_RECLAIM, 0);
+	bch_journal_wq = alloc_workqueue("bch_journal",
+					 WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!bch_journal_wq)
 		goto err;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 6ba73dc1a3df..ccbd9a8f28f5 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -1076,7 +1076,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 int bch_cached_dev_writeback_start(struct cached_dev *dc)
 {
 	dc->writeback_write_wq = alloc_workqueue("bcache_writeback_wq",
-						WQ_MEM_RECLAIM, 0);
+						WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!dc->writeback_write_wq)
 		return -ENOMEM;
 
-- 
2.51.1



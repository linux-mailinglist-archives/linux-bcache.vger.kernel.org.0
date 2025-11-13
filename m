Return-Path: <linux-bcache+bounces-1253-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C420C55D12
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 06:36:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9F3A934711F
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Nov 2025 05:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229CC2E06E6;
	Thu, 13 Nov 2025 05:36:53 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084DE2C0287;
	Thu, 13 Nov 2025 05:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763012213; cv=none; b=DmrQsv9oVEZ32qz5WuHP2pLNkfrQEnxPszXIiJ0XQUxoG+HENClf33iJtA7ze58+w+XkuTSrV4pB+q01vg0UF1K5LTuhuQEGXHfgpdix7E3k6j3B1KsOA+Fxj0TFI6pk9GmCwWlLu0T+rlmpdSSlJ6U1xYOSoTbZy+QR/UTM9tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763012213; c=relaxed/simple;
	bh=W1sGhQ/RzBWc7oo+dXOi3ka838gbE0f1x72q6qFmiIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jQx+cCwzo2uZoctHNd3TH+Yfp7LvQKaTwtvOTuoVo/nHy8qBmGukHoPVokCNq3inLdMwK+pp1fKpRhlU77uUz55UL3cdXTW4AN+34DULgek60gdyCo+O+Xp23zPQxJntuei/R0VoIyAmUK1MrthUntKaQhugrjxPcowEb4HgRi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1613EC116D0;
	Thu, 13 Nov 2025 05:36:50 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-bcache@vger.kernel.org,
	linux-block@vger.kernel.org,
	Marco Crivellari <marco.crivellari@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Coly Li <colyli@fnnas.com>
Subject: [PATCH 8/9] bcache: WQ_PERCPU added to alloc_workqueue users
Date: Thu, 13 Nov 2025 13:36:29 +0800
Message-ID: <20251113053630.54218-9-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113053630.54218-1-colyli@fnnas.com>
References: <20251113053630.54218-1-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marco Crivellari <marco.crivellari@suse.com>

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
Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/btree.c     |  3 ++-
 drivers/md/bcache/super.c     | 10 ++++++----
 drivers/md/bcache/writeback.c |  2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 24ddc353cb30..3ed39c823826 100644
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
index 92ced6b28cb2..c17d4517af22 100644
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
 
@@ -2902,7 +2903,7 @@ static int __init bcache_init(void)
 	if (bch_btree_init())
 		goto err;
 
-	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM, 0);
+	bcache_wq = alloc_workqueue("bcache", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!bcache_wq)
 		goto err;
 
@@ -2915,11 +2916,12 @@ static int __init bcache_init(void)
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
index cffef33b4acf..4b237074f453 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -1075,7 +1075,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 int bch_cached_dev_writeback_start(struct cached_dev *dc)
 {
 	dc->writeback_write_wq = alloc_workqueue("bcache_writeback_wq",
-						WQ_MEM_RECLAIM, 0);
+						WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!dc->writeback_write_wq)
 		return -ENOMEM;
 
-- 
2.47.3



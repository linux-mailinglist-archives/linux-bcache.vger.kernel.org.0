Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55887A69C7
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Sep 2019 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfICN0C (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Sep 2019 09:26:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:34526 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728860AbfICN0C (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Sep 2019 09:26:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B21A5B11B;
        Tue,  3 Sep 2019 13:26:01 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 3/3] closures: fix a race on wakeup from closure_sync
Date:   Tue,  3 Sep 2019 21:25:45 +0800
Message-Id: <20190903132545.30059-4-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190903132545.30059-1-colyli@suse.de>
References: <20190903132545.30059-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

The race was when a thread using closure_sync() notices cl->s->done == 1
before the thread calling closure_put() calls wake_up_process(). Then,
it's possible for that thread to return and exit just before
wake_up_process() is called - so we're trying to wake up a process that
no longer exists.

rcu_read_lock() is sufficient to protect against this, as there's an rcu
barrier somewhere in the process teardown path.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Acked-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/closure.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 73f5319295bc..c12cd809ab19 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -105,8 +105,14 @@ struct closure_syncer {
 
 static void closure_sync_fn(struct closure *cl)
 {
-	cl->s->done = 1;
-	wake_up_process(cl->s->task);
+	struct closure_syncer *s = cl->s;
+	struct task_struct *p;
+
+	rcu_read_lock();
+	p = READ_ONCE(s->task);
+	s->done = 1;
+	wake_up_process(p);
+	rcu_read_unlock();
 }
 
 void __sched __closure_sync(struct closure *cl)
-- 
2.16.4


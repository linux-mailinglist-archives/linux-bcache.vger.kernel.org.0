Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB254281EA
	for <lists+linux-bcache@lfdr.de>; Sun, 10 Oct 2021 16:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhJJObb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 10 Oct 2021 10:31:31 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:56543 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232036AbhJJOba (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 10 Oct 2021 10:31:30 -0400
Received: from pop-os.home ([90.126.248.220])
        by mwinf5d78 with ME
        id 4EVW260074m3Hzu03EVWPz; Sun, 10 Oct 2021 16:29:31 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 10 Oct 2021 16:29:31 +0200
X-ME-IP: 90.126.248.220
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] dm: Remove redundant 'flush_workqueue()' calls
Date:   Sun, 10 Oct 2021 16:29:28 +0200
Message-Id: <65c7c385af7b3f825ace8803b1bc6b6403269813.1633876058.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- 	flush_workqueue(E);
	destroy_workqueue(E);

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/md/bcache/writeback.c | 4 +---
 drivers/md/dm-bufio.c         | 1 -
 drivers/md/dm-zoned-target.c  | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 8120da278161..dbb6cb8069d9 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -790,10 +790,8 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
-	if (dc->writeback_write_wq) {
-		flush_workqueue(dc->writeback_write_wq);
+	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
-	}
 	cached_dev_put(dc);
 	wait_for_kthread_stop();
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 50f3e673729c..fc8f8e9f9e39 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2082,7 +2082,6 @@ static void __exit dm_bufio_exit(void)
 	int bug = 0;
 
 	cancel_delayed_work_sync(&dm_bufio_cleanup_old_work);
-	flush_workqueue(dm_bufio_wq);
 	destroy_workqueue(dm_bufio_wq);
 
 	if (dm_bufio_client_count) {
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ae1bc48c0043..dfc822295c25 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -967,7 +967,6 @@ static void dmz_dtr(struct dm_target *ti)
 	struct dmz_target *dmz = ti->private;
 	int i;
 
-	flush_workqueue(dmz->chunk_wq);
 	destroy_workqueue(dmz->chunk_wq);
 
 	for (i = 0; i < dmz->nr_ddevs; i++)
-- 
2.30.2


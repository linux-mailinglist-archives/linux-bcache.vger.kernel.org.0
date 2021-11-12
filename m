Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049F944EBB8
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Nov 2021 18:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhKLREe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Nov 2021 12:04:34 -0500
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:57775 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbhKLREd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Nov 2021 12:04:33 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id lZvpmTuLw1UGBlZvpmGL72; Fri, 12 Nov 2021 18:01:41 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 12 Nov 2021 18:01:41 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] bcache: Remove redundant 'flush_workqueue()' calls
Date:   Fri, 12 Nov 2021 18:01:40 +0100
Message-Id: <b61537b83c7e893d99c6ea05930a42e87679e429.1636736443.git.christophe.jaillet@wanadoo.fr>
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
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c7560f66dca8..384c666605ec 100644
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
 
-- 
2.30.2


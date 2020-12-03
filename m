Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F372CD2F3
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 10:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbgLCJxP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Dec 2020 04:53:15 -0500
Received: from regular1.263xmail.com ([211.150.70.206]:42772 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387548AbgLCJxO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Dec 2020 04:53:14 -0500
Received: from localhost (unknown [192.168.167.32])
        by regular1.263xmail.com (Postfix) with ESMTP id 1C2D71B17;
        Thu,  3 Dec 2020 17:47:24 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P26670T140451924260608S1606988834214421_;
        Thu, 03 Dec 2020 17:47:23 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <4add3ead76855a29643536f784f1c7d0>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: colyli@suse.de
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     colyli@suse.de
Cc:     yilikernel@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yi Li <yili@winhong.com>, Guo Chao <guochao@winhong.com>
Subject: [PATCH v2] bcache: fix panic due to cache_set is null
Date:   Thu,  3 Dec 2020 17:47:11 +0800
Message-Id: <20201203094711.3236551-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <CAJfdMYDLydAtoxvPGzaQ+K5jLvwAXg6MvpE-OM9sFjZgz_01sQ@mail.gmail.com>
References: <CAJfdMYDLydAtoxvPGzaQ+K5jLvwAXg6MvpE-OM9sFjZgz_01sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bcache_device_detach will release the cache_set after hotunplug cache
disk.

Here is how the issue happens.
1) cached_dev_free do cancel_writeback_rate_update_dwork
   without bch_register_lock.
2) Wirting the writeback_percent by sysfs with
   bch_register_lock will insert a writeback_rate_update work.
3) cached_dev_free with bch_register_lock to do bcache_device_free.
   dc->disk.cl will be set NULL
4) update_writeback_rate will crash when access dc->disk.cl

Fixes: 80265d8dfd77 ("bcache: acquire bch_register_lock later in cached_dev_free()")

  IP: [<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
  PGD 879620067 PUD 8755d3067 PMD 0
  Oops: 0000 [#1] SMP
  CPU: 8 PID: 1005702 Comm: kworker/8:0 Tainted: G 4.4.0+10 #1
  Hardware name: Intel BIOS SE5C610.86B.01.01.0021.032120170601 03/21/2017
  Workqueue: events update_writeback_rate [bcache]
  task: ffff8808786f3800 ti: ffff88077082c000 task.ti: ffff88077082c000
  RIP: e030:[<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
  RSP: e02b:ffff88077082fde0  EFLAGS: 00010202
  RAX: 0000000000000018 RBX: ffff8808047f0b08 RCX: 0000000000000000
  RDX: 0000000000000001 RSI: ffff88088170dab8 RDI: ffff88088170dab8
  RBP: ffff88077082fe18 R08: 000000000000000a R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000017bc8 R12: 0000000000000000
  R13: ffff8808047f0000 R14: 0000000000000200 R15: ffff8808047f0b08
  FS:  00007f157b6d6700(0000) GS:ffff880881700000(0000) knlGS:0000000000000000
  CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000368 CR3: 0000000875c05000 CR4: 0000000000040660
  Stack:
   0000000000000001 0000000000007ff0 ffff88085ff600c0 ffff880881714e80
   ffff880881719500 0000000000000200 ffff8808047f0b08 ffff88077082fe60
   ffffffff81088c0c 0000000081714e80 0000000000000000 ffff880881714e80
  Call Trace:
   [<ffffffff81088c0c>] process_one_work+0x1fc/0x3b0
   [<ffffffff81089575>] worker_thread+0x2a5/0x470
   [<ffffffff815a2f58>] ? __schedule+0x648/0x870
   [<ffffffff810892d0>] ? rescuer_thread+0x300/0x300
   [<ffffffff8108e3d5>] kthread+0xd5/0xe0
   [<ffffffff8108e300>] ? kthread_stop+0x110/0x110
   [<ffffffff815a704f>] ret_from_fork+0x3f/0x70
   [<ffffffff8108e300>] ? kthread_stop+0x110/0x110

Reported-by: Guo Chao <guochao@winhong.com>
Signed-off-by: Yi Li <yili@winhong.com>
---
 drivers/md/bcache/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 46a00134a36a..8b341f756ac0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1334,9 +1334,6 @@ static void cached_dev_free(struct closure *cl)
 {
 	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
 
-	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
-		cancel_writeback_rate_update_dwork(dc);
-
 	if (!IS_ERR_OR_NULL(dc->writeback_thread))
 		kthread_stop(dc->writeback_thread);
 	if (!IS_ERR_OR_NULL(dc->status_update_thread))
@@ -1344,6 +1341,9 @@ static void cached_dev_free(struct closure *cl)
 
 	mutex_lock(&bch_register_lock);
 
+	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
+		cancel_writeback_rate_update_dwork(dc);
+
 	if (atomic_read(&dc->running))
 		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
 	bcache_device_free(&dc->disk);
-- 
2.25.3




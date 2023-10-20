Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23BB7D0A1C
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Oct 2023 09:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376570AbjJTH6k (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 20 Oct 2023 03:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376571AbjJTH5R (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:17 -0400
X-Greylist: delayed 352 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 Oct 2023 00:57:10 PDT
Received: from mail-m15592.qiye.163.com (mail-m15592.qiye.163.com [101.71.155.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A6710F3
        for <linux-bcache@vger.kernel.org>; Fri, 20 Oct 2023 00:57:09 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3188.qiye.163.com (Hmail) with ESMTPA id E0F2B5405BC;
        Fri, 20 Oct 2023 15:50:54 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: [PATCH] bcache: fixup multi-threaded bch_sectors_dirty_init() wake-up race
Date:   Fri, 20 Oct 2023 15:50:51 +0800
Message-Id: <20231020075051.261222-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDQksdVh9DS0tCTU5MQx8dGFUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpNT0lMTlVKS0tVSkJLS1kG
X-HM-Tid: 0a8b4c10db8b00eckurme0f2b5405bc
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mkk6IQw4HTEyTxUJKUopDzFI
        IjkwCwFVSlVKTUJMTENDSU5OQ0pNVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTU5ITzcG
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We get a kernel crash about "unable to handle kernel paging request":

```dmesg
[368033.032005] BUG: unable to handle kernel paging request at ffffffffad9ae4b5
[368033.032007] PGD fc3a0d067 P4D fc3a0d067 PUD fc3a0e063 PMD 8000000fc38000e1
[368033.032012] Oops: 0003 [#1] SMP PTI
[368033.032015] CPU: 23 PID: 55090 Comm: bch_dirtcnt[0] Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-147.5.1.es8_24.x86_64 #1
[368033.032017] Hardware name: Tsinghua Tongfang THTF Chaoqiang Server/072T6D, BIOS 2.4.3 01/17/2017
[368033.032027] RIP: 0010:native_queued_spin_lock_slowpath+0x183/0x1d0
[368033.032029] Code: 8b 02 48 85 c0 74 f6 48 89 c1 eb d0 c1 e9 12 83 e0
03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 c0 3d 02 00 48 03 04 cd 60 68 93
ad <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 02
[368033.032031] RSP: 0018:ffffbb48852abe00 EFLAGS: 00010082
[368033.032032] RAX: ffffffffad9ae4b5 RBX: 0000000000000246 RCX: 0000000000003bf3
[368033.032033] RDX: ffff97b0ff8e3dc0 RSI: 0000000000600000 RDI: ffffbb4884743c68
[368033.032034] RBP: 0000000000000001 R08: 0000000000000000 R09: 000007ffffffffff
[368033.032035] R10: ffffbb486bb01000 R11: 0000000000000001 R12: ffffffffc068da70
[368033.032036] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
[368033.032038] FS:  0000000000000000(0000) GS:ffff97b0ff8c0000(0000) knlGS:0000000000000000
[368033.032039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[368033.032040] CR2: ffffffffad9ae4b5 CR3: 0000000fc3a0a002 CR4: 00000000003626e0
[368033.032042] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[368033.032043] bcache: bch_cached_dev_attach() Caching rbd479 as bcache462 on set 8cff3c36-4a76-4242-afaa-7630206bc70b
[368033.032045] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[368033.032046] Call Trace:
[368033.032054]  _raw_spin_lock_irqsave+0x32/0x40
[368033.032061]  __wake_up_common_lock+0x63/0xc0
[368033.032073]  ? bch_ptr_invalid+0x10/0x10 [bcache]
[368033.033502]  bch_dirty_init_thread+0x14c/0x160 [bcache]
[368033.033511]  ? read_dirty_submit+0x60/0x60 [bcache]
[368033.033516]  kthread+0x112/0x130
[368033.033520]  ? kthread_flush_work_fn+0x10/0x10
[368033.034505]  ret_from_fork+0x35/0x40
```

The crash occurred when call wake_up(&state->wait), and then we want
to look at the value in the state. However, bch_sectors_dirty_init()
is not found in the stack of any task. Since state is allocated on
the stack, we guess that bch_sectors_dirty_init() has exited, causing
bch_dirty_init_thread() to be unable to handle kernel paging request.

In order to verify this idea, we added some printing information during
wake_up(&state->wait). We find that "wake up" is printed twice, however
we only expect the last thread to wake up once.

```dmesg
[  994.641004] alcache: bch_dirty_init_thread() wake up
[  994.641018] alcache: bch_dirty_init_thread() wake up
[  994.641523] alcache: bch_sectors_dirty_init() init exit
```

There is a race. If bch_sectors_dirty_init() exits after the first wake
up, the second wake up will trigger this bug("unable to handle kernel
paging request").

Proceed as follows:

bch_sectors_dirty_init
    kthread_run ==============> bch_dirty_init_thread(bch_dirtcnt[0])
            ...                         ...
    atomic_inc(&state.started)          ...
            ...                         ...
    atomic_read(&state.enough)          ...
            ...                 atomic_set(&state->enough, 1)
    kthread_run ======================================================> bch_dirty_init_thread(bch_dirtcnt[1])
            ...                 atomic_dec_and_test(&state->started)            ...
    atomic_inc(&state.started)          ...                                     ...
            ...                 wake_up(&state->wait)                           ...
    atomic_read(&state.enough)                                          atomic_dec_and_test(&state->started)
            ...                                                                 ...
    wait_event(state.wait, atomic_read(&state.started) == 0)                    ...
    return                                                                      ...
                                                                        wake_up(&state->wait)

We believe it is very common to wake up twice if there is no dirty, but
crash is an extremely low probability event. It's hard for us to reproduce
this issue. We attached and detached continuously for a week, with a total
of more than one million attaches and only one crash.

Putting atomic_inc(&state.started) before kthread_run() can avoid waking
up twice.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 24c049067f61..a6ddd0bb9220 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -1014,17 +1014,18 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		if (atomic_read(&state.enough))
 			break;
 
+		atomic_inc(&state.started);
 		state.infos[i].state = &state;
 		state.infos[i].thread =
 			kthread_run(bch_dirty_init_thread, &state.infos[i],
 				    "bch_dirtcnt[%d]", i);
 		if (IS_ERR(state.infos[i].thread)) {
 			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
+			atomic_dec(&state.started);
 			for (--i; i >= 0; i--)
 				kthread_stop(state.infos[i].thread);
 			goto out;
 		}
-		atomic_inc(&state.started);
 	}
 
 out:
-- 
2.17.1.windows.2


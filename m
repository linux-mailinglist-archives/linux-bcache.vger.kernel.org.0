Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4344BB5E
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Nov 2021 06:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhKJFrm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Nov 2021 00:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbhKJFrl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Nov 2021 00:47:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91F3C061764
        for <linux-bcache@vger.kernel.org>; Tue,  9 Nov 2021 21:44:54 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y7so2204381plp.0
        for <linux-bcache@vger.kernel.org>; Tue, 09 Nov 2021 21:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=kSBLeNFiPZl6YEAcfSFjYMYtkU8FDTvFzjvi1MKo1M4=;
        b=p+GlvUcpRoOJK+5j/6gkTk+l64+K13oGp4SkBTLy3gTaiy2Jm6EbgGDU7/WWGTDcua
         sKjp2r0KdvMMmPGSA8b5bdhoBr42PaqeVIQCMCYNx9AgLc7H/blkhQriZuXvAyq8fXbR
         LTStKm7q+wvdeDeFoWjTWjR7H+MufinB+3cFrjbDBgbKt6tmKjqtwQb9YoM4Y1l5iBO0
         F/1a/S1TMgxupPXOtKbfW1DeYAogiSxlEdMgc/ZXobiMh2d0zIZiCjrW70iK9EpEZuEr
         kYG59JJGGt90aOTfCrlHZdJ/J1z+jKbxdz3AQ2dGuNsIdLI3Ekck1620rtrmUUueVUn8
         3Yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kSBLeNFiPZl6YEAcfSFjYMYtkU8FDTvFzjvi1MKo1M4=;
        b=g3WKbZyzpR6qAB/NnViU3y/CTjzZhqrmhwA+VpD+PYzzL9r0+bF8ZNASDHIqWYWw2R
         4a3vPvyeCvI27nHxcsPzu8YOGRuCIjSWAt+2K1HNBV30bgIoh1LIv8gvs1v8dhGFOkFf
         /Yl4Rv775H8sUUSAsrNSd+0eRF6cer4PB1n77iMHyLeqcFotgHR8l5JB07tceml/9PBF
         JWDyvXGYWGc1nS3pn+r08+xp28mkCPKj5D/DZn0ybDodKQThGbxoilAgwU4du2beq93j
         3hwEj0tdBg6X67vj+LUE1cSzXIaNDbWzXLbWIwMihEt7XFGJADGQ81SeO9KjoeI0YxN4
         IZMw==
X-Gm-Message-State: AOAM530WCwIpYT+F0T9pBeCKcb/NNyXBQxVfHZEyW4u89MJIIlvReyQ+
        obGZiyc9GbYZpOOHVnTIooL5boZYtDWRKJAXkdV2oFxCvFLLtQ==
X-Google-Smtp-Source: ABdhPJwQDhABdd+JkXnVYMFt48DF1mGCAORNQdDMHqS/scIWRJR6rNxC1+cJzI39BJ7/bwvgnpwURsECLHD0HQ7OG3M=
X-Received: by 2002:a17:90a:df96:: with SMTP id p22mr13803726pjv.129.1636523093347;
 Tue, 09 Nov 2021 21:44:53 -0800 (PST)
MIME-Version: 1.0
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Wed, 10 Nov 2021 11:14:41 +0530
Message-ID: <CAC6jXv0mw4eOzFSzzm0acBJFM5whhC=hTFG6_8H__rfA6zq5Cg@mail.gmail.com>
Subject: bcache-register hang after reboot
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

After a reboot of an Ubuntu server running 4.15.0-143-generic kernel,
the storage devices using bcache do not come back up and the following
stack traces are seen in kern.log. Please could someone help me
understand if this is due to a full bcache journal? Is there any
workaround, or fix?

Nov  5 05:48:20  kernel: [  242.651880] INFO: task bcache-register:943
blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.655071]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.656717] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.658380] bcache-register D    0   943
   1 0x00000006
Nov  5 05:48:20  kernel: [  242.658385] Call Trace:
Nov  5 05:48:20  kernel: [  242.658398]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.658403]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.658424]  closure_sync+0x18/0x90 [bcache]
Nov  5 05:48:20  kernel: [  242.658439]  bch_journal+0x123/0x380 [bcache]
Nov  5 05:48:20  kernel: [  242.658453]  bch_journal_meta+0x47/0x70 [bcache]
Nov  5 05:48:20  kernel: [  242.658461]  ? __switch_to+0x123/0x4e0
Nov  5 05:48:20  kernel: [  242.658465]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.658467]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:20  kernel: [  242.658473]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.658477]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.658480]  ? mutex_lock+0x2f/0x40
Nov  5 05:48:20  kernel: [  242.658494]  bch_btree_set_root+0x1c2/0x1f0 [bcache]
Nov  5 05:48:20  kernel: [  242.658506]  btree_split+0x69a/0x700 [bcache]
Nov  5 05:48:20  kernel: [  242.658509]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.658511]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:20  kernel: [  242.658513]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.658516]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.658518]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:20  kernel: [  242.658520]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.658524]  ? _cond_resched+0x19/0x40
Nov  5 05:48:20  kernel: [  242.658528]  ? __mutex_lock.isra.5+0x431/0x4e0
Nov  5 05:48:20  kernel: [  242.658532]  ? __switch_to+0x123/0x4e0
Nov  5 05:48:20  kernel: [  242.658534]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.658536]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:20  kernel: [  242.658538]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.658549]
bch_btree_insert_node+0x340/0x410 [bcache]
Nov  5 05:48:20  kernel: [  242.658561]  btree_split+0x551/0x700 [bcache]
Nov  5 05:48:20  kernel: [  242.658568]  ? __internal_add_timer+0x1f/0x60
Nov  5 05:48:20  kernel: [  242.658572]  ? add_timer+0x124/0x2b0
Nov  5 05:48:20  kernel: [  242.658583]
bch_btree_insert_node+0x340/0x410 [bcache]
Nov  5 05:48:20  kernel: [  242.658595]  btree_insert_fn+0x24/0x40 [bcache]
Nov  5 05:48:20  kernel: [  242.658607]
bch_btree_map_nodes_recurse+0x54/0x190 [bcache]
Nov  5 05:48:20  kernel: [  242.658618]  ?
bch_btree_insert_check_key+0x1f0/0x1f0 [bcache]
Nov  5 05:48:20  kernel: [  242.658622]  ? _cond_resched+0x19/0x40
Nov  5 05:48:20  kernel: [  242.658626]  ? down_write+0x12/0x40
Nov  5 05:48:20  kernel: [  242.658637]  ?
bch_btree_node_get+0x80/0x280 [bcache]
Nov  5 05:48:20  kernel: [  242.658642]  ? up_read+0x30/0x30
Nov  5 05:48:20  kernel: [  242.658653]
bch_btree_map_nodes_recurse+0x112/0x190 [bcache]
Nov  5 05:48:20  kernel: [  242.658663]  ?
bch_btree_insert_check_key+0x1f0/0x1f0 [bcache]
Nov  5 05:48:20  kernel: [  242.658675]
__bch_btree_map_nodes+0xf0/0x150 [bcache]
Nov  5 05:48:20  kernel: [  242.658685]  ?
bch_btree_insert_check_key+0x1f0/0x1f0 [bcache]
Nov  5 05:48:20  kernel: [  242.658696]  bch_btree_insert+0xf9/0x170 [bcache]
Nov  5 05:48:20  kernel: [  242.658701]  ? wait_woken+0x80/0x80
Nov  5 05:48:20  kernel: [  242.658714]  bch_journal_replay+0x220/0x2f0 [bcache]
Nov  5 05:48:20  kernel: [  242.658720]  ? sched_clock_cpu+0x11/0xb0
Nov  5 05:48:20  kernel: [  242.658723]  ? try_to_wake_up+0x59/0x4a0
Nov  5 05:48:20  kernel: [  242.658739]  run_cache_set+0x5d6/0x990 [bcache]
Nov  5 05:48:20  kernel: [  242.658752]  register_bcache+0xd04/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.658764]  ? register_bcache+0xd04/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.658769]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:20  kernel: [  242.658776]  kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.658780]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.658784]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:20  kernel: [  242.658787]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:20  kernel: [  242.658791]  __vfs_write+0x1b/0x40
Nov  5 05:48:20  kernel: [  242.658794]  vfs_write+0xb1/0x1a0
Nov  5 05:48:20  kernel: [  242.658797]  SyS_write+0x5c/0xe0
Nov  5 05:48:20  kernel: [  242.658802]  do_syscall_64+0x73/0x130
Nov  5 05:48:20  kernel: [  242.658806]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:20  kernel: [  242.658809] RIP: 0033:0x7f9942e96224
Nov  5 05:48:20  kernel: [  242.658811] RSP: 002b:00007ffc32a525e8
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:20  kernel: [  242.658815] RAX: ffffffffffffffda RBX:
000000000000000d RCX: 00007f9942e96224
Nov  5 05:48:20  kernel: [  242.658816] RDX: 000000000000000d RSI:
000055e5e081c260 RDI: 0000000000000003
Nov  5 05:48:20  kernel: [  242.658818] RBP: 000055e5e081c260 R08:
0000000000000000 R09: 000000000000000c
Nov  5 05:48:20  kernel: [  242.658819] R10: 00000000fffffff4 R11:
0000000000000246 R12: 00007ffc32a52680
Nov  5 05:48:20  kernel: [  242.658821] R13: 000000000000000d R14:
00007f994316e2a0 R15: 00007f994316d760
Nov  5 05:48:20  kernel: [  242.658829] INFO: task bcache-register:969
blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.660133]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.661251] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.662390] bcache-register D    0   969
   1 0x00000004
Nov  5 05:48:20  kernel: [  242.662393] Call Trace:
Nov  5 05:48:20  kernel: [  242.662399]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.662405]  ? find_get_entry+0x1e/0x110
Nov  5 05:48:20  kernel: [  242.662409]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.662412]  schedule_preempt_disabled+0xe/0x10
Nov  5 05:48:20  kernel: [  242.662414]  __mutex_lock.isra.5+0x276/0x4e0
Nov  5 05:48:20  kernel: [  242.662421]  ? alloc_pages_current+0x6a/0xe0
Nov  5 05:48:20  kernel: [  242.662424]  __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.662427]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.662429]  mutex_lock+0x2f/0x40
Nov  5 05:48:20  kernel: [  242.662441]  register_bcache+0x412/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.662445]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:20  kernel: [  242.662450]  kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.662453]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.662455]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:20  kernel: [  242.662458]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:20  kernel: [  242.662461]  __vfs_write+0x1b/0x40
Nov  5 05:48:20  kernel: [  242.662462]  vfs_write+0xb1/0x1a0
Nov  5 05:48:20  kernel: [  242.662465]  SyS_write+0x5c/0xe0
Nov  5 05:48:20  kernel: [  242.662470]  do_syscall_64+0x73/0x130
Nov  5 05:48:20  kernel: [  242.662472]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:20  kernel: [  242.662474] RIP: 0033:0x7f8695ceb224
Nov  5 05:48:20  kernel: [  242.662475] RSP: 002b:00007ffe9698dd58
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:20  kernel: [  242.662477] RAX: ffffffffffffffda RBX:
0000000000000009 RCX: 00007f8695ceb224
Nov  5 05:48:20  kernel: [  242.662478] RDX: 0000000000000009 RSI:
0000559670e98260 RDI: 0000000000000003
Nov  5 05:48:20  kernel: [  242.662479] RBP: 0000559670e98260 R08:
0000000000000000 R09: 0000000000000008
Nov  5 05:48:20  kernel: [  242.662480] R10: 00000000fffffff8 R11:
0000000000000246 R12: 00007ffe9698ddf0
Nov  5 05:48:20  kernel: [  242.662481] R13: 0000000000000009 R14:
00007f8695fc32a0 R15: 00007f8695fc2760
Nov  5 05:48:20  kernel: [  242.662485] INFO: task bcache-register:972
blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.663630]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.664791] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.665968] bcache-register D    0   972
   1 0x00000004
Nov  5 05:48:20  kernel: [  242.665971] Call Trace:
Nov  5 05:48:20  kernel: [  242.665976]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.665980]  ? find_get_entry+0x1e/0x110
Nov  5 05:48:20  kernel: [  242.665983]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.665986]  schedule_preempt_disabled+0xe/0x10
Nov  5 05:48:20  kernel: [  242.665988]  __mutex_lock.isra.5+0x276/0x4e0
Nov  5 05:48:20  kernel: [  242.665992]  ? alloc_pages_current+0x6a/0xe0
Nov  5 05:48:20  kernel: [  242.665995]  __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.665997]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.666000]  mutex_lock+0x2f/0x40
Nov  5 05:48:20  kernel: [  242.666009]  register_bcache+0x412/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.666012]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:20  kernel: [  242.666016]  kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.666019]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.666021]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:20  kernel: [  242.666023]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:20  kernel: [  242.666025]  __vfs_write+0x1b/0x40
Nov  5 05:48:20  kernel: [  242.666027]  vfs_write+0xb1/0x1a0
Nov  5 05:48:20  kernel: [  242.666029]  SyS_write+0x5c/0xe0
Nov  5 05:48:20  kernel: [  242.666033]  do_syscall_64+0x73/0x130
Nov  5 05:48:20  kernel: [  242.666035]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:20  kernel: [  242.666037] RIP: 0033:0x7fb36e40a224
Nov  5 05:48:20  kernel: [  242.666038] RSP: 002b:00007ffdc09c03c8
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:20  kernel: [  242.666040] RAX: ffffffffffffffda RBX:
0000000000000009 RCX: 00007fb36e40a224
Nov  5 05:48:20  kernel: [  242.666041] RDX: 0000000000000009 RSI:
000055ac39f14260 RDI: 0000000000000003
Nov  5 05:48:20  kernel: [  242.666042] RBP: 000055ac39f14260 R08:
0000000000000000 R09: 0000000000000008
Nov  5 05:48:20  kernel: [  242.666043] R10: 00000000fffffff8 R11:
0000000000000246 R12: 00007ffdc09c0460
Nov  5 05:48:20  kernel: [  242.666044] R13: 0000000000000009 R14:
00007fb36e6e22a0 R15: 00007fb36e6e1760
Nov  5 05:48:20  kernel: [  242.666047] INFO: task bcache-register:974
blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.667231]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.668431] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.669479] bcache-register D    0   974
   1 0x00000004
Nov  5 05:48:20  kernel: [  242.669481] Call Trace:
Nov  5 05:48:20  kernel: [  242.669483]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.669485]  ? find_get_entry+0x1e/0x110
Nov  5 05:48:20  kernel: [  242.669487]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.669488]  schedule_preempt_disabled+0xe/0x10
Nov  5 05:48:20  kernel: [  242.669489]  __mutex_lock.isra.5+0x276/0x4e0
Nov  5 05:48:20  kernel: [  242.669491]  ? alloc_pages_current+0x6a/0xe0
Nov  5 05:48:20  kernel: [  242.669492]  __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.669493]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.669494]  mutex_lock+0x2f/0x40
Nov  5 05:48:20  kernel: [  242.669498]  register_bcache+0x412/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.669501]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:20  kernel: [  242.669503]  kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.669504]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.669505]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:20  kernel: [  242.669507]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:20  kernel: [  242.669509]  __vfs_write+0x1b/0x40
Nov  5 05:48:20  kernel: [  242.669510]  vfs_write+0xb1/0x1a0
Nov  5 05:48:20  kernel: [  242.669511]  SyS_write+0x5c/0xe0
Nov  5 05:48:20  kernel: [  242.669512]  do_syscall_64+0x73/0x130
Nov  5 05:48:20  kernel: [  242.669513]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:20  kernel: [  242.669515] RIP: 0033:0x7f6669c01224
Nov  5 05:48:20  kernel: [  242.669515] RSP: 002b:00007ffc30ac1ce8
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:20  kernel: [  242.669516] RAX: ffffffffffffffda RBX:
0000000000000009 RCX: 00007f6669c01224
Nov  5 05:48:20  kernel: [  242.669517] RDX: 0000000000000009 RSI:
0000561588dc9260 RDI: 0000000000000003
Nov  5 05:48:20  kernel: [  242.669517] RBP: 0000561588dc9260 R08:
0000000000000000 R09: 0000000000000008
Nov  5 05:48:20  kernel: [  242.669517] R10: 00000000fffffff8 R11:
0000000000000246 R12: 00007ffc30ac1d80
Nov  5 05:48:20  kernel: [  242.669518] R13: 0000000000000009 R14:
00007f6669ed92a0 R15: 00007f6669ed8760
Nov  5 05:48:20  kernel: [  242.669520] INFO: task bcache-register:977
blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.670046]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.670565] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.671076] bcache-register D    0   977
   1 0x00000004
Nov  5 05:48:20  kernel: [  242.671077] Call Trace:
Nov  5 05:48:20  kernel: [  242.671080]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.671081]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.671083]  schedule_preempt_disabled+0xe/0x10
Nov  5 05:48:20  kernel: [  242.671084]  __mutex_lock.isra.5+0x276/0x4e0
Nov  5 05:48:20  kernel: [  242.671086]  ? alloc_pages_current+0x6a/0xe0
Nov  5 05:48:20  kernel: [  242.671087]  __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.671088]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.671090]  mutex_lock+0x2f/0x40
Nov  5 05:48:20  kernel: [  242.671094]  register_bcache+0x412/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.671096]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:20  kernel: [  242.671098]  kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.671099]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.671100]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:20  kernel: [  242.671101]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:20  kernel: [  242.671102]  __vfs_write+0x1b/0x40
Nov  5 05:48:20  kernel: [  242.671103]  vfs_write+0xb1/0x1a0
Nov  5 05:48:20  kernel: [  242.671103]  SyS_write+0x5c/0xe0
Nov  5 05:48:20  kernel: [  242.671105]  do_syscall_64+0x73/0x130
Nov  5 05:48:20  kernel: [  242.671106]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:20  kernel: [  242.671107] RIP: 0033:0x7f0111112224
Nov  5 05:48:20  kernel: [  242.671107] RSP: 002b:00007fff2f21c788
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:20  kernel: [  242.671108] RAX: ffffffffffffffda RBX:
0000000000000009 RCX: 00007f0111112224
Nov  5 05:48:20  kernel: [  242.671108] RDX: 0000000000000009 RSI:
0000564671709260 RDI: 0000000000000003
Nov  5 05:48:20  kernel: [  242.671109] RBP: 0000564671709260 R08:
0000000000000000 R09: 0000000000000008
Nov  5 05:48:20  kernel: [  242.671109] R10: 00000000fffffff8 R11:
0000000000000246 R12: 00007fff2f21c820
Nov  5 05:48:20  kernel: [  242.671109] R13: 0000000000000009 R14:
00007f01113ea2a0 R15: 00007f01113e9760
Nov  5 05:48:20  kernel: [  242.671111] INFO: task bcache-register:982
blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.671614]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.672154] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.672671] bcache-register D    0   982
   1 0x00000004
Nov  5 05:48:20  kernel: [  242.672672] Call Trace:
Nov  5 05:48:20  kernel: [  242.672674]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.672676]  ? find_get_entry+0x1e/0x110
Nov  5 05:48:20  kernel: [  242.672678]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.672679]  schedule_preempt_disabled+0xe/0x10
Nov  5 05:48:20  kernel: [  242.672680]  __mutex_lock.isra.5+0x276/0x4e0
Nov  5 05:48:20  kernel: [  242.672682]  ? alloc_pages_current+0x6a/0xe0
Nov  5 05:48:20  kernel: [  242.672683]  __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.672684]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.672685]  mutex_lock+0x2f/0x40
Nov  5 05:48:20  kernel: [  242.672689]  register_bcache+0x412/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.672691]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:20  kernel: [  242.672693]  kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.672694]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.672695]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:20  kernel: [  242.672696]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:20  kernel: [  242.672698]  __vfs_write+0x1b/0x40
Nov  5 05:48:20  kernel: [  242.672698]  vfs_write+0xb1/0x1a0
Nov  5 05:48:20  kernel: [  242.672700]  SyS_write+0x5c/0xe0
Nov  5 05:48:20  kernel: [  242.672702]  do_syscall_64+0x73/0x130
Nov  5 05:48:20  kernel: [  242.672703]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:20  kernel: [  242.672704] RIP: 0033:0x7f95ed5c9224
Nov  5 05:48:20  kernel: [  242.672704] RSP: 002b:00007ffd801bf818
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:20  kernel: [  242.672705] RAX: ffffffffffffffda RBX:
0000000000000009 RCX: 00007f95ed5c9224
Nov  5 05:48:20  kernel: [  242.672706] RDX: 0000000000000009 RSI:
00005580aa3d8260 RDI: 0000000000000003
Nov  5 05:48:20  kernel: [  242.672706] RBP: 00005580aa3d8260 R08:
0000000000000000 R09: 0000000000000008
Nov  5 05:48:20  kernel: [  242.672707] R10: 00000000fffffff8 R11:
0000000000000246 R12: 00007ffd801bf8b0
Nov  5 05:48:20  kernel: [  242.672707] R13: 0000000000000009 R14:
00007f95ed8a12a0 R15: 00007f95ed8a0760
Nov  5 05:48:20  kernel: [  242.672709] INFO: task bcache-register:986
blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.673210]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.673676] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.674138] bcache-register D    0   986
   1 0x00000004
Nov  5 05:48:20  kernel: [  242.674139] Call Trace:
Nov  5 05:48:20  kernel: [  242.674142]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.674143]  ? find_get_entry+0x1e/0x110
Nov  5 05:48:20  kernel: [  242.674145]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.674146]  schedule_preempt_disabled+0xe/0x10
Nov  5 05:48:20  kernel: [  242.674147]  __mutex_lock.isra.5+0x276/0x4e0
Nov  5 05:48:20  kernel: [  242.674148]  ? alloc_pages_current+0x6a/0xe0
Nov  5 05:48:20  kernel: [  242.674149]  __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.674150]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:20  kernel: [  242.674151]  mutex_lock+0x2f/0x40
Nov  5 05:48:20  kernel: [  242.674155]  register_bcache+0x412/0x1110 [bcache]
Nov  5 05:48:20  kernel: [  242.674157]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:20  kernel: [  242.674159]  kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.674160]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:20  kernel: [  242.674161]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:20  kernel: [  242.674162]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:20  kernel: [  242.674163]  __vfs_write+0x1b/0x40
Nov  5 05:48:20  kernel: [  242.674164]  vfs_write+0xb1/0x1a0
Nov  5 05:48:20  kernel: [  242.674165]  SyS_write+0x5c/0xe0
Nov  5 05:48:20  kernel: [  242.674167]  do_syscall_64+0x73/0x130
Nov  5 05:48:20  kernel: [  242.674167]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:20  kernel: [  242.674168] RIP: 0033:0x7fb5a170d224
Nov  5 05:48:20  kernel: [  242.674169] RSP: 002b:00007ffcd0691f78
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:20  kernel: [  242.674170] RAX: ffffffffffffffda RBX:
0000000000000009 RCX: 00007fb5a170d224
Nov  5 05:48:20  kernel: [  242.674170] RDX: 0000000000000009 RSI:
000055b23525a260 RDI: 0000000000000003
Nov  5 05:48:20  kernel: [  242.674171] RBP: 000055b23525a260 R08:
0000000000000000 R09: 0000000000000008
Nov  5 05:48:20  kernel: [  242.674171] R10: 00000000fffffff8 R11:
0000000000000246 R12: 00007ffcd0692010
Nov  5 05:48:20  kernel: [  242.674171] R13: 0000000000000009 R14:
00007fb5a19e52a0 R15: 00007fb5a19e4760
Nov  5 05:48:20  kernel: [  242.674175] INFO: task
bcache_allocato:1029 blocked for more than 120 seconds.
Nov  5 05:48:20  kernel: [  242.674630]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:20  kernel: [  242.675072] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:20  kernel: [  242.675521] bcache_allocato D    0  1029
   2 0x80000000
Nov  5 05:48:20  kernel: [  242.675522] Call Trace:
Nov  5 05:48:20  kernel: [  242.675525]  __schedule+0x24e/0x890
Nov  5 05:48:20  kernel: [  242.675525]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:20  kernel: [  242.675526]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:20  kernel: [  242.675527]  schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.675532]  closure_sync+0x18/0x90 [bcache]
Nov  5 05:48:20  kernel: [  242.675535]  bch_journal+0x123/0x380 [bcache]
Nov  5 05:48:20  kernel: [  242.675536]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:20  kernel: [  242.675539]  bch_journal_meta+0x47/0x70 [bcache]
Nov  5 05:48:20  kernel: [  242.675541]  ? schedule+0x2c/0x80
Nov  5 05:48:20  kernel: [  242.675544]  ? closure_sync+0x18/0x90 [bcache]
Nov  5 05:48:20  kernel: [  242.675547]  ?
prio_io.constprop.32+0x116/0x140 [bcache]
Nov  5 05:48:20  kernel: [  242.675548]  ? _cond_resched+0x19/0x40
Nov  5 05:48:20  kernel: [  242.675549]  ? mutex_lock+0x12/0x40
Nov  5 05:48:20  kernel: [  242.675553]  bch_prio_write+0x304/0x470 [bcache]
Nov  5 05:48:20  kernel: [  242.675556]
bch_allocator_thread+0x235/0x4c0 [bcache]
Nov  5 05:48:20  kernel: [  242.675560]  kthread+0x121/0x140
Nov  5 05:48:20  kernel: [  242.675563]  ?
invalidate_buckets+0x890/0x890 [bcache]
Nov  5 05:48:20  kernel: [  242.675564]  ?
kthread_create_worker_on_cpu+0x70/0x70
Nov  5 05:48:20  kernel: [  242.675565]  ret_from_fork+0x35/0x40
Nov  5 05:48:20  kernel: [  330.909260] br-bond1: port 2(veth-br-data)
entered blocking state
Nov  5 05:48:20  kernel: [  330.909264] br-bond1: port 2(veth-br-data)
entered disabled state
Nov  5 05:48:20  kernel: [  330.909472] device veth-br-data entered
promiscuous mode
Nov  5 05:48:20  kernel: [  330.913355] IPv6: ADDRCONF(NETDEV_UP):
veth-br-data: link is not ready
Nov  5 05:48:20  kernel: [  330.933518] IPv6: ADDRCONF(NETDEV_UP):
veth-br-bond1: link is not ready
Nov  5 05:48:20  kernel: [  330.933535] IPv6: ADDRCONF(NETDEV_CHANGE):
veth-br-bond1: link becomes ready
Nov  5 05:48:20  kernel: [  330.933645] IPv6: ADDRCONF(NETDEV_CHANGE):
veth-br-data: link becomes ready
Nov  5 05:48:20  kernel: [  330.933706] br-bond1: port 2(veth-br-data)
entered blocking state
Nov  5 05:48:20  kernel: [  330.933710] br-bond1: port 2(veth-br-data)
entered forwarding state
Nov  5 05:48:20  kernel: [  333.394130] new mount options do not match
the existing superblock, will be ignored
Nov  5 05:48:20  kernel: [  333.738771] Process accounting resumed
Nov  5 05:48:24  kernel: [  339.280833] openvswitch: Open vSwitch
switching datapath
Nov  5 05:48:24  kernel: [  339.640280] device ovs-system entered
promiscuous mode
Nov  5 05:48:24  kernel: [  340.122082] device br-int entered promiscuous mode
Nov  5 05:48:25  kernel: [  340.512290] i40e 0000:09:00.0 eno1: port
4789 already offloaded
Nov  5 05:48:25  kernel: [  340.512294] i40e 0000:09:00.1 eno2: port
4789 already offloaded
Nov  5 05:48:25  kernel: [  340.512297] i40e 0000:2f:00.0 enp47s0f0:
port 4789 already offloaded
Nov  5 05:48:25  kernel: [  340.512300] i40e 0000:2f:00.1 enp47s0f1:
port 4789 already offloaded
Nov  5 05:48:25  kernel: [  340.512303] i40e 0000:58:00.0 enp88s0f0:
port 4789 already offloaded
Nov  5 05:48:25  kernel: [  340.512305] i40e 0000:58:00.1 enp88s0f1:
port 4789 already offloaded
Nov  5 05:48:25  kernel: [  340.512918] device vxlan_sys_4789 entered
promiscuous mode
Nov  5 05:48:25  kernel: [  340.564171] device br-tun entered promiscuous mode
Nov  5 05:48:25  kernel: [  340.570996] device br-ex entered promiscuous mode
Nov  5 05:48:25  kernel: [  340.571508] device veth-br-bond1 entered
promiscuous mode
Nov  5 05:48:25  kernel: [  340.577139] device br-data entered promiscuous mode
Nov  5 05:48:42  kernel: [  357.672105] ip6_tables: (C) 2000-2006
Netfilter Core Team
Nov  5 05:48:43  kernel: [  358.439969] Ebtables v2.0 registered
Nov  5 05:48:48  kernel: [  363.490744] INFO: task bcache-register:943
blocked for more than 120 seconds.
Nov  5 05:48:48  kernel: [  363.490806]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:48  kernel: [  363.490848] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:48  kernel: [  363.490904] bcache-register D    0   943
   1 0x00000006
Nov  5 05:48:48  kernel: [  363.490908] Call Trace:
Nov  5 05:48:48  kernel: [  363.490920]  __schedule+0x24e/0x890
Nov  5 05:48:48  kernel: [  363.490926]  schedule+0x2c/0x80
Nov  5 05:48:48  kernel: [  363.490945]  closure_sync+0x18/0x90 [bcache]
Nov  5 05:48:48  kernel: [  363.490960]  bch_journal+0x123/0x380 [bcache]
Nov  5 05:48:48  kernel: [  363.490973]  bch_journal_meta+0x47/0x70 [bcache]
Nov  5 05:48:48  kernel: [  363.490980]  ? __switch_to+0x123/0x4e0
Nov  5 05:48:48  kernel: [  363.490984]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:48  kernel: [  363.490986]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:48  kernel: [  363.490991]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:48  kernel: [  363.490995]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:48  kernel: [  363.490999]  ? mutex_lock+0x2f/0x40
Nov  5 05:48:48  kernel: [  363.491012]  bch_btree_set_root+0x1c2/0x1f0 [bcache]
Nov  5 05:48:48  kernel: [  363.491024]  btree_split+0x69a/0x700 [bcache]
Nov  5 05:48:48  kernel: [  363.491026]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:48  kernel: [  363.491028]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:48  kernel: [  363.491030]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:48  kernel: [  363.491034]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:48  kernel: [  363.491036]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:48  kernel: [  363.491038]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:48  kernel: [  363.491041]  ? _cond_resched+0x19/0x40
Nov  5 05:48:48  kernel: [  363.491045]  ? __mutex_lock.isra.5+0x431/0x4e0
Nov  5 05:48:48  kernel: [  363.491049]  ? __switch_to+0x123/0x4e0
Nov  5 05:48:48  kernel: [  363.491051]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:48  kernel: [  363.491053]  ? __switch_to_asm+0x41/0x70
Nov  5 05:48:48  kernel: [  363.491055]  ? __switch_to_asm+0x35/0x70
Nov  5 05:48:48  kernel: [  363.491067]
bch_btree_insert_node+0x340/0x410 [bcache]
Nov  5 05:48:48  kernel: [  363.491078]  btree_split+0x551/0x700 [bcache]
Nov  5 05:48:48  kernel: [  363.491086]  ? __internal_add_timer+0x1f/0x60
Nov  5 05:48:48  kernel: [  363.491090]  ? add_timer+0x124/0x2b0
Nov  5 05:48:48  kernel: [  363.491101]
bch_btree_insert_node+0x340/0x410 [bcache]
Nov  5 05:48:48  kernel: [  363.491113]  btree_insert_fn+0x24/0x40 [bcache]
Nov  5 05:48:48  kernel: [  363.491125]
bch_btree_map_nodes_recurse+0x54/0x190 [bcache]
Nov  5 05:48:48  kernel: [  363.491136]  ?
bch_btree_insert_check_key+0x1f0/0x1f0 [bcache]
Nov  5 05:48:48  kernel: [  363.491139]  ? _cond_resched+0x19/0x40
Nov  5 05:48:48  kernel: [  363.491143]  ? down_write+0x12/0x40
Nov  5 05:48:48  kernel: [  363.491154]  ?
bch_btree_node_get+0x80/0x280 [bcache]
Nov  5 05:48:48  kernel: [  363.491159]  ? up_read+0x30/0x30
Nov  5 05:48:48  kernel: [  363.491170]
bch_btree_map_nodes_recurse+0x112/0x190 [bcache]
Nov  5 05:48:48  kernel: [  363.491180]  ?
bch_btree_insert_check_key+0x1f0/0x1f0 [bcache]
Nov  5 05:48:48  kernel: [  363.491192]
__bch_btree_map_nodes+0xf0/0x150 [bcache]
Nov  5 05:48:48  kernel: [  363.491202]  ?
bch_btree_insert_check_key+0x1f0/0x1f0 [bcache]
Nov  5 05:48:48  kernel: [  363.491213]  bch_btree_insert+0xf9/0x170 [bcache]
Nov  5 05:48:48  kernel: [  363.491217]  ? wait_woken+0x80/0x80
Nov  5 05:48:48  kernel: [  363.491230]  bch_journal_replay+0x220/0x2f0 [bcache]
Nov  5 05:48:48  kernel: [  363.491235]  ? sched_clock_cpu+0x11/0xb0
Nov  5 05:48:48  kernel: [  363.491238]  ? try_to_wake_up+0x59/0x4a0
Nov  5 05:48:48  kernel: [  363.491253]  run_cache_set+0x5d6/0x990 [bcache]
Nov  5 05:48:48  kernel: [  363.491267]  register_bcache+0xd04/0x1110 [bcache]
Nov  5 05:48:48  kernel: [  363.491278]  ? register_bcache+0xd04/0x1110 [bcache]
Nov  5 05:48:48  kernel: [  363.491283]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:48  kernel: [  363.491289]  kobj_attr_store+0x12/0x20
Nov  5 05:48:48  kernel: [  363.491293]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:48  kernel: [  363.491297]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:48  kernel: [  363.491299]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:48  kernel: [  363.491303]  __vfs_write+0x1b/0x40
Nov  5 05:48:48  kernel: [  363.491306]  vfs_write+0xb1/0x1a0
Nov  5 05:48:48  kernel: [  363.491309]  SyS_write+0x5c/0xe0
Nov  5 05:48:48  kernel: [  363.491314]  do_syscall_64+0x73/0x130
Nov  5 05:48:48  kernel: [  363.491317]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:48  kernel: [  363.491321] RIP: 0033:0x7f9942e96224
Nov  5 05:48:48  kernel: [  363.491323] RSP: 002b:00007ffc32a525e8
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:48  kernel: [  363.491326] RAX: ffffffffffffffda RBX:
000000000000000d RCX: 00007f9942e96224
Nov  5 05:48:48  kernel: [  363.491328] RDX: 000000000000000d RSI:
000055e5e081c260 RDI: 0000000000000003
Nov  5 05:48:48  kernel: [  363.491329] RBP: 000055e5e081c260 R08:
0000000000000000 R09: 000000000000000c
Nov  5 05:48:48  kernel: [  363.491331] R10: 00000000fffffff4 R11:
0000000000000246 R12: 00007ffc32a52680
Nov  5 05:48:48  kernel: [  363.491333] R13: 000000000000000d R14:
00007f994316e2a0 R15: 00007f994316d760
Nov  5 05:48:48  kernel: [  363.491340] INFO: task bcache-register:969
blocked for more than 120 seconds.
Nov  5 05:48:48  kernel: [  363.491394]       Not tainted
4.15.0-143-generic #147-Ubuntu
Nov  5 05:48:48  kernel: [  363.491435] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov  5 05:48:48  kernel: [  363.491489] bcache-register D    0   969
   1 0x00000004
Nov  5 05:48:48  kernel: [  363.491492] Call Trace:
Nov  5 05:48:48  kernel: [  363.491498]  __schedule+0x24e/0x890
Nov  5 05:48:48  kernel: [  363.491505]  ? find_get_entry+0x1e/0x110
Nov  5 05:48:48  kernel: [  363.491509]  schedule+0x2c/0x80
Nov  5 05:48:48  kernel: [  363.491513]  schedule_preempt_disabled+0xe/0x10
Nov  5 05:48:48  kernel: [  363.491517]  __mutex_lock.isra.5+0x276/0x4e0
Nov  5 05:48:48  kernel: [  363.491523]  ? alloc_pages_current+0x6a/0xe0
Nov  5 05:48:48  kernel: [  363.491528]  __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:48  kernel: [  363.491531]  ? __mutex_lock_slowpath+0x13/0x20
Nov  5 05:48:48  kernel: [  363.491535]  mutex_lock+0x2f/0x40
Nov  5 05:48:48  kernel: [  363.491548]  register_bcache+0x412/0x1110 [bcache]
Nov  5 05:48:48  kernel: [  363.491552]  ? __handle_mm_fault+0xf43/0x1290
Nov  5 05:48:48  kernel: [  363.491559]  kobj_attr_store+0x12/0x20
Nov  5 05:48:48  kernel: [  363.491562]  ? kobj_attr_store+0x12/0x20
Nov  5 05:48:48  kernel: [  363.491565]  sysfs_kf_write+0x3c/0x50
Nov  5 05:48:48  kernel: [  363.491568]  kernfs_fop_write+0x125/0x1a0
Nov  5 05:48:48  kernel: [  363.491571]  __vfs_write+0x1b/0x40
Nov  5 05:48:48  kernel: [  363.491574]  vfs_write+0xb1/0x1a0
Nov  5 05:48:48  kernel: [  363.491577]  SyS_write+0x5c/0xe0
Nov  5 05:48:48  kernel: [  363.491582]  do_syscall_64+0x73/0x130
Nov  5 05:48:48  kernel: [  363.491585]
entry_SYSCALL_64_after_hwframe+0x41/0xa6
Nov  5 05:48:48  kernel: [  363.491587] RIP: 0033:0x7f8695ceb224
Nov  5 05:48:48  kernel: [  363.491588] RSP: 002b:00007ffe9698dd58
EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Nov  5 05:48:48  kernel: [  363.491591] RAX: ffffffffffffffda RBX:
0000000000000009 RCX: 00007f8695ceb224
Nov  5 05:48:48  kernel: [  363.491592] RDX: 0000000000000009 RSI:
0000559670e98260 RDI: 0000000000000003
Nov  5 05:48:48  kernel: [  363.491594] RBP: 0000559670e98260 R08:
0000000000000000 R09: 0000000000000008
Nov  5 05:48:48  kernel: [  363.491596] R10: 00000000fffffff8 R11:
0000000000000246 R12: 00007ffe9698ddf0
Nov  5 05:48:48  kernel: [  363.491597] R13: 0000000000000009 R14:
00007f8695fc32a0 R15: 00007f8695fc2760

Regards,
Nikhil.

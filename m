Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D332B1EE5
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Nov 2020 16:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKMPg0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 Nov 2020 10:36:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgKMPgZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Nov 2020 10:36:25 -0500
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C20AC0613D1
        for <linux-bcache@vger.kernel.org>; Fri, 13 Nov 2020 07:36:25 -0800 (PST)
Received: by mail-ua1-x941.google.com with SMTP id r23so3121863uak.0
        for <linux-bcache@vger.kernel.org>; Fri, 13 Nov 2020 07:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ZCiZp9bzzwRN7NQjMUPIUXRskWv8DO8wb1FNm6+JXS8=;
        b=rNDaUeWmZVQOondo9Z83bchXy/6w+nXmI+UZjIizjnlKLJg7t3+NhzpzkvW0YUqGop
         SIFYpTF/QaQ7zz3l4nuwinlBjIYy4BIYYtPbgIMxKQkn0amzhPUuH+kKd4B8yDxel+gy
         P4HVcmcIc/g6aimYrNfQPlRnqwXaBjDok4pNE7XQn6OKSvhLIv6cmiBec9XQnqrPUgGe
         PrMScW/0qaaRtIuKdlLO5xeIFd0HF0h9Pbg375Xeb61DmSWH9/RQZqjBQZPXVllmleHR
         TboVUivKuDkIom8c0Jdshy3QNt8SRQdcx7IrZBXNbxOqHqSGE1agAdJDi6BctQ0ektbN
         f3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ZCiZp9bzzwRN7NQjMUPIUXRskWv8DO8wb1FNm6+JXS8=;
        b=msHSgZLh89gk/1e3q0n7aPojTL4wm5Pv16IPxT+T0Kc+ECz9i/IGWn7nitnDgaYzA0
         v4OeKM9QIlHaML5ZVtMHlKvXc11xnfvq+vpxRTdX6VXlYBDoziANSbOF9UAdAeDRgYS4
         n8KO1ZXKQG8TOIOe72YTcWQgMv2cPKVTOseKzuEgafrGYKub8HSyGTgovefGrITQ3Zs1
         wsxDLQapsJ2cx3D0SaLyA9HRRSRov5aJbfHNZRx8j+0QySAUyRqKlu4CSbC822gPJ9lH
         JcnAab8cnW3/V1gtxNFi+cigSWlDzXsFnZY6ZiaVOYTg7pHDhK2kfB8pR1piXbMFT2v3
         tRTg==
X-Gm-Message-State: AOAM531kAfgyxMRlgVSdkGJCOxORmVJmOEZFZXVo7DtqA0ooBcNtNMR8
        vVQyUS4J6qEpRRxPYmHMmGM7aMkwaoTbezpfJqPvvEoW/MIBVg==
X-Google-Smtp-Source: ABdhPJwqDKNWv9TGjhU5zAHC57y/nNjRGP1BCpsfHAqVM/OvlKt+oDl/xpFc+mOkLh2MXJchtB/Dz+oc+h9QmXblPhE=
X-Received: by 2002:a9f:37c8:: with SMTP id q66mr1348808uaq.140.1605281779477;
 Fri, 13 Nov 2020 07:36:19 -0800 (PST)
MIME-Version: 1.0
References: <CAH6h+hexmutQkXUh9+VFrnfTX=XYB6dOw8QJXfRLzEX9KNdZRQ@mail.gmail.com>
In-Reply-To: <CAH6h+hexmutQkXUh9+VFrnfTX=XYB6dOw8QJXfRLzEX9KNdZRQ@mail.gmail.com>
From:   Marc Smith <msmith626@gmail.com>
Date:   Fri, 13 Nov 2020 10:36:08 -0500
Message-ID: <CAH6h+hfbmMS1ZtdW3QgFxh05H9JGA3U6dR9_XZCVtD+-1D=UJg@mail.gmail.com>
Subject: Re: Kernel Panic on 5.4.69
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, Oct 30, 2020 at 11:16 AM Marc Smith <msmith626@gmail.com> wrote:
>
> Hi,
>
> I'm using Linux 5.4.69 with the following two patches applied for bcache:
> commit 125d98edd114 ("bcache: remove member accessed from struct btree")
> commit d5c9c470b011 ("bcache: reap c->btree_cache_freeable from the
> tail in bch_mca_scan()")
>
> I'm using bcache in write-back mode... the cache device is a RAID1
> mirror set using NVMe drives, and several backing devices are
> associated with that cache device. While driving I/O, I experienced
> the following kernel panic:
>   SYSTEM MAP: /home/marc.smith/Downloads/System.map-esos.prod
> DEBUG KERNEL: /home/marc.smith/Downloads/vmlinux-esos.prod (5.4.69-esos.prod)
>     DUMPFILE: /home/marc.smith/Downloads/dumpfile-1604062993
>         CPUS: 8
>         DATE: Fri Oct 30 09:02:56 2020
>       UPTIME: 2 days, 12:38:15
> LOAD AVERAGE: 9.48, 8.89, 7.69
>        TASKS: 980
>     NODENAME: node-10cccd-2
>      RELEASE: 5.4.69-esos.prod
>      VERSION: #1 SMP Thu Oct 22 19:45:11 UTC 2020
>      MACHINE: x86_64  (2799 Mhz)
>       MEMORY: 24 GB
>        PANIC: "Oops: 0002 [#1] SMP NOPTI" (check log for details)
>          PID: 18272
>      COMMAND: "kworker/2:13"
>         TASK: ffff88841d9e8000  [THREAD_INFO: ffff88841d9e8000]
>          CPU: 2
>        STATE: TASK_UNINTERRUPTIBLE (PANIC)
>
> crash> bt
> PID: 18272  TASK: ffff88841d9e8000  CPU: 2   COMMAND: "kworker/2:13"
>  #0 [ffffc90000100938] machine_kexec at ffffffff8103d6b5
>  #1 [ffffc90000100980] __crash_kexec at ffffffff8110d37b
>  #2 [ffffc90000100a48] crash_kexec at ffffffff8110e07d
>  #3 [ffffc90000100a58] oops_end at ffffffff8101a9de
>  #4 [ffffc90000100a78] no_context at ffffffff81045e99
>  #5 [ffffc90000100ae0] async_page_fault at ffffffff81e010cf
>     [exception RIP: atomic_try_cmpxchg+2]
>     RIP: ffffffff810d3e3b  RSP: ffffc90000100b98  RFLAGS: 00010046
>     RAX: 0000000000000000  RBX: 0000000000000003  RCX: 0000000000080006
>     RDX: 0000000000000001  RSI: ffffc90000100ba4  RDI: 0000000000000a6c
>     RBP: 0000000000000010   R8: 0000000000000001   R9: ffffffffa0418d4e
>     R10: ffff88841c8b3000  R11: ffff88841c8b3000  R12: 0000000000000046
>     R13: 0000000000000000  R14: ffff8885a3a0a000  R15: 0000000000000a6c
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #6 [ffffc90000100b98] _raw_spin_lock_irqsave at ffffffff81cf7d7d
>  #7 [ffffc90000100bb8] try_to_wake_up at ffffffff810c1624
>  #8 [ffffc90000100c08] closure_sync_fn at ffffffffa040fb07 [bcache]
>  #9 [ffffc90000100c10] clone_endio at ffffffff81aac48c
> #10 [ffffc90000100c40] call_bio_endio at ffffffff81a78e20
> #11 [ffffc90000100c58] raid_end_bio_io at ffffffff81a78e69
> #12 [ffffc90000100c88] raid1_end_write_request at ffffffff81a79ad9
> #13 [ffffc90000100cf8] blk_update_request at ffffffff814c3ab1
> #14 [ffffc90000100d38] blk_mq_end_request at ffffffff814caaf2
> #15 [ffffc90000100d50] blk_mq_complete_request at ffffffff814c91c1
> #16 [ffffc90000100d78] nvme_complete_cqes at ffffffffa002fb03 [nvme]
> #17 [ffffc90000100db8] nvme_irq at ffffffffa002fb7f [nvme]
> #18 [ffffc90000100de0] __handle_irq_event_percpu at ffffffff810e0d60
> #19 [ffffc90000100e20] handle_irq_event_percpu at ffffffff810e0e65
> #20 [ffffc90000100e48] handle_irq_event at ffffffff810e0ecb
> #21 [ffffc90000100e60] handle_edge_irq at ffffffff810e494d
> #22 [ffffc90000100e78] do_IRQ at ffffffff81e01900
> #23 [ffffc90000100eb0] common_interrupt at ffffffff81e00a0a
> #24 [ffffc90000100f38] __softirqentry_text_start at ffffffff8200006a
> #25 [ffffc90000100fc8] irq_exit at ffffffff810a3f6a
> #26 [ffffc90000100fd0] smp_apic_timer_interrupt at ffffffff81e020b2
> bt: invalid kernel virtual address: ffffc90000101000  type: "pt_regs"
> crash>
>
> I noticed in the call trace that closure_sync_fn() is just before the
> thread is woken; I saw one patch from a year ago for closure_sync_fn()
> but of course this is already applied in 5.4.69:
> https://lore.kernel.org/patchwork/patch/1086698/
>
> I haven't encountered this panic in any prior testing, so it appears
> to be rare so far. Not sure what else could be done to debug?
>
> I'll continue testing with heaving I/O to see if this can be reproduced.

Seems we can induce it pretty regularly now; got another one with a
bit more in the back-trace:

crash> bt
PID: 4998   TASK: ffff888578808000  CPU: 1   COMMAND: "H4012_1cc510_0"
 #0 [ffffc900000d4938] machine_kexec at ffffffff8103d6b5
 #1 [ffffc900000d4980] __crash_kexec at ffffffff8110d37b
 #2 [ffffc900000d4a48] crash_kexec at ffffffff8110e07d
 #3 [ffffc900000d4a58] oops_end at ffffffff8101a9de
 #4 [ffffc900000d4a78] no_context at ffffffff81045e99
 #5 [ffffc900000d4ae0] async_page_fault at ffffffff81e010cf
    [exception RIP: atomic_try_cmpxchg+2]
    RIP: ffffffff810d3e3b  RSP: ffffc900000d4b98  RFLAGS: 00010046
    RAX: 0000000000000000  RBX: 0000000000000003  RCX: 0000000000000000
    RDX: 0000000000000001  RSI: ffffc900000d4ba4  RDI: 0000000100000a5b
    RBP: 00000000ffffffff   R8: ffff8884dd4a5000   R9: 0000000000080007
    R10: ffffea0013752800  R11: 0000000080080007  R12: 0000000000000046
    R13: 0000000000000000  R14: ffff88856e5e6800  R15: 0000000100000a5b
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffffc900000d4b98] _raw_spin_lock_irqsave at ffffffff81cf7d7d
 #7 [ffffc900000d4bb8] try_to_wake_up at ffffffff810c1624
 #8 [ffffc900000d4c08] closure_sync_fn at ffffffffa0448b07 [bcache]
 #9 [ffffc900000d4c10] clone_endio at ffffffff81aac48c
#10 [ffffc900000d4c40] call_bio_endio at ffffffff81a78e20
#11 [ffffc900000d4c58] raid_end_bio_io at ffffffff81a78e69
#12 [ffffc900000d4c88] raid1_end_write_request at ffffffff81a79ad9
#13 [ffffc900000d4cf8] blk_update_request at ffffffff814c3ab1
#14 [ffffc900000d4d38] blk_mq_end_request at ffffffff814caaf2
#15 [ffffc900000d4d50] blk_mq_complete_request at ffffffff814c91c1
#16 [ffffc900000d4d78] nvme_complete_cqes at ffffffffa002fb03 [nvme]
#17 [ffffc900000d4db8] nvme_irq at ffffffffa002fb7f [nvme]
#18 [ffffc900000d4de0] __handle_irq_event_percpu at ffffffff810e0d60
#19 [ffffc900000d4e20] handle_irq_event_percpu at ffffffff810e0e65
#20 [ffffc900000d4e48] handle_irq_event at ffffffff810e0ecb
#21 [ffffc900000d4e60] handle_edge_irq at ffffffff810e494d
#22 [ffffc900000d4e78] do_IRQ at ffffffff81e01900
#23 [ffffc900000d4eb0] common_interrupt at ffffffff81e00a0a
#24 [ffffc900000d4f38] __softirqentry_text_start at ffffffff8200006a
#25 [ffffc900000d4fc0] irq_exit at ffffffff810a3f6a
#26 [ffffc900000d4fc8] do_IRQ at ffffffff81e01954
--- <IRQ stack> ---
#27 [ffffc90004eff798] ret_from_intr at ffffffff81e00a0f
    [exception RIP: mod_delayed_work_on+89]
    RIP: ffffffff810b55e1  RSP: ffffc90004eff840  RFLAGS: 00000246
    RAX: 0000000000000001  RBX: 0000000000000000  RCX: 00002b7673202213
    RDX: 00000000000f4240  RSI: 0000000000000046  RDI: ffff888627aa7d80
    RBP: 0000000000000002   R8: ffff88862440c0c0   R9: ffff888627aa8138
    R10: 0000000000000000  R11: 0000000000000000  R12: ffff88861f0bf440
    R13: ffff888623d5ba00  R14: ffff88861accc1e0  R15: ffffe8ffffc5ed80
    ORIG_RAX: ffffffffffffffd2  CS: 0010  SS: 0018
#28 [ffffc90004eff878] kblockd_mod_delayed_work_on at ffffffff814c2bc7
#29 [ffffc90004eff880] blk_mq_run_hw_queue at ffffffff814c9ff1
#30 [ffffc90004eff8b0] blk_mq_sched_insert_requests at ffffffff814cf649
#31 [ffffc90004eff8e8] blk_mq_flush_plug_list at ffffffff814cbd8e
#32 [ffffc90004eff950] blk_flush_plug_list at ffffffff814c4286
#33 [ffffc90004eff990] io_schedule_prepare at ffffffff810c32fe
#34 [ffffc90004eff9a0] io_schedule at ffffffff81cf5644
#35 [ffffc90004eff9b0] blk_mq_get_tag at ffffffff814cdc8d
#36 [ffffc90004effa20] blk_mq_get_request at ffffffff814ca52c
#37 [ffffc90004effa50] blk_mq_make_request at ffffffff814cb848
#38 [ffffc90004effad8] generic_make_request at ffffffff814c3578
#39 [ffffc90004effb60] flush_bio_list at ffffffff81a762dd
#40 [ffffc90004effb80] raid1_unplug at ffffffff81a764e7
#41 [ffffc90004effba8] blk_flush_plug_list at ffffffff814c4270
#42 [ffffc90004effbe8] blk_finish_plug at ffffffff814c42c0
#43 [ffffc90004effbf8] blockio_exec_rw at ffffffffa05f37e2 [scst_vdisk]
#44 [ffffc90004effce0] blockio_exec_write at ffffffffa05f38f1 [scst_vdisk]
#45 [ffffc90004effcf8] vdev_do_job at ffffffffa05ed1e0 [scst_vdisk]
#46 [ffffc90004effd08] blockio_exec at ffffffffa05eea01 [scst_vdisk]
#47 [ffffc90004effdd0] scst_do_real_exec at ffffffffa04760d8 [scst]
#48 [ffffc90004effe08] scst_exec_check_blocking at ffffffffa04774c5 [scst]
#49 [ffffc90004effe38] scst_process_active_cmd at ffffffffa04786d4 [scst]
#50 [ffffc90004effe98] scst_cmd_thread at ffffffffa0479acf [scst]
#51 [ffffc90004efff10] kthread at ffffffff810b9a47
#52 [ffffc90004efff50] ret_from_fork at ffffffff81e00202
crash>

Any tips on what to look at next would be greatly appreciated; I'd
like to assist with a fix... should I perhaps add some monitoring
lines to find out what state process "p" is in? Or follow other
functions that may cause that task to finish in a different thread?


Thanks,

Marc


>
>
> --Marc

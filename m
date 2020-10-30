Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA04E2A0963
	for <lists+linux-bcache@lfdr.de>; Fri, 30 Oct 2020 16:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgJ3PQ2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 30 Oct 2020 11:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgJ3PQ1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Oct 2020 11:16:27 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CE2C0613CF
        for <linux-bcache@vger.kernel.org>; Fri, 30 Oct 2020 08:16:27 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id v27so1828895uau.3
        for <linux-bcache@vger.kernel.org>; Fri, 30 Oct 2020 08:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=XmU3YGLGzTrGENK4eODvNJ92DBiYBDdDJ2HUmRklSzs=;
        b=tTejEiPaokTzTYtFlDrt/yYmi7BL2MxjWzpWwx0PN1tujS6BSdFEngewLZCVKzsVH7
         u5zLLkWbwUf3TUk/u7eL6uvHW2BpSs4pUptut9HRLANf0zhjcEBLbHgLXtdSsk1eTuqe
         sr0J5FBLb/9aesYHwq1U83bbQWA+jZ/vS7trYqwzYj4c/oZL+qyqEi82GicjTL+B2Z+P
         GTj39KLhzqVLB1HfSo8ZVDleW0qOhloJY21XfZPlVeUGRgOCdTyOrlif1uABgN1MFKmn
         TIYWT0Zu+4II8wts5wJfWhMMvFEKnv3+5cHRzppnxbUkN0nrX+i8iJ8kvv8WXuBR3vKP
         j/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=XmU3YGLGzTrGENK4eODvNJ92DBiYBDdDJ2HUmRklSzs=;
        b=qf1o5cDfXd6GbnDzoecwSaoS1FUdgqUyTS+hlom7uZOjnDVVPqnVk2+Lr6FnmfZkix
         /h3YoxzWeZWadNqq+rsPXb5dRJujuQ7dBR1cD0E4zCC0COcsHuGnUS+POJZ6493+GZSW
         oXvn0tXSOAC08rOf3IavhysttDEFjNR9JYrYAWHZ8ix2t9q7WffwDgdHKhsXQxO+/B87
         oTmG0vArNoQpY+WQzuG+1fjL6xFtzxuhw2bDw2WSV1Hf+pj1W0aINNqGljMxMbb5tcVy
         513SJfK/DHbdgFyIWMkDR4bYVaba7g/T8nF7U3uzWaGbwBR/+PFo57aReVe3v7rp9e7c
         2WcA==
X-Gm-Message-State: AOAM532gl5I3BvW5QYvw8xZwZfeJYnKjkBGC/sGQSZZJTmfaN6FyAT54
        HFtJ/GQuTswC7Cv/MrQKQGs8zK88+VwzgdIYZYZdvZBXknqMiw==
X-Google-Smtp-Source: ABdhPJyoY4ooeE6IIF9sFv9UELSee68h42rneSKLH3+XzwZkd8vFcDxKyuug15tiJc5wWRuhLj4Aa42j65442qo5m4A=
X-Received: by 2002:ab0:48ed:: with SMTP id y42mr1740094uac.140.1604070986056;
 Fri, 30 Oct 2020 08:16:26 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Fri, 30 Oct 2020 11:16:15 -0400
Message-ID: <CAH6h+hexmutQkXUh9+VFrnfTX=XYB6dOw8QJXfRLzEX9KNdZRQ@mail.gmail.com>
Subject: Kernel Panic on 5.4.69
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

I'm using Linux 5.4.69 with the following two patches applied for bcache:
commit 125d98edd114 ("bcache: remove member accessed from struct btree")
commit d5c9c470b011 ("bcache: reap c->btree_cache_freeable from the
tail in bch_mca_scan()")

I'm using bcache in write-back mode... the cache device is a RAID1
mirror set using NVMe drives, and several backing devices are
associated with that cache device. While driving I/O, I experienced
the following kernel panic:
  SYSTEM MAP: /home/marc.smith/Downloads/System.map-esos.prod
DEBUG KERNEL: /home/marc.smith/Downloads/vmlinux-esos.prod (5.4.69-esos.prod)
    DUMPFILE: /home/marc.smith/Downloads/dumpfile-1604062993
        CPUS: 8
        DATE: Fri Oct 30 09:02:56 2020
      UPTIME: 2 days, 12:38:15
LOAD AVERAGE: 9.48, 8.89, 7.69
       TASKS: 980
    NODENAME: node-10cccd-2
     RELEASE: 5.4.69-esos.prod
     VERSION: #1 SMP Thu Oct 22 19:45:11 UTC 2020
     MACHINE: x86_64  (2799 Mhz)
      MEMORY: 24 GB
       PANIC: "Oops: 0002 [#1] SMP NOPTI" (check log for details)
         PID: 18272
     COMMAND: "kworker/2:13"
        TASK: ffff88841d9e8000  [THREAD_INFO: ffff88841d9e8000]
         CPU: 2
       STATE: TASK_UNINTERRUPTIBLE (PANIC)

crash> bt
PID: 18272  TASK: ffff88841d9e8000  CPU: 2   COMMAND: "kworker/2:13"
 #0 [ffffc90000100938] machine_kexec at ffffffff8103d6b5
 #1 [ffffc90000100980] __crash_kexec at ffffffff8110d37b
 #2 [ffffc90000100a48] crash_kexec at ffffffff8110e07d
 #3 [ffffc90000100a58] oops_end at ffffffff8101a9de
 #4 [ffffc90000100a78] no_context at ffffffff81045e99
 #5 [ffffc90000100ae0] async_page_fault at ffffffff81e010cf
    [exception RIP: atomic_try_cmpxchg+2]
    RIP: ffffffff810d3e3b  RSP: ffffc90000100b98  RFLAGS: 00010046
    RAX: 0000000000000000  RBX: 0000000000000003  RCX: 0000000000080006
    RDX: 0000000000000001  RSI: ffffc90000100ba4  RDI: 0000000000000a6c
    RBP: 0000000000000010   R8: 0000000000000001   R9: ffffffffa0418d4e
    R10: ffff88841c8b3000  R11: ffff88841c8b3000  R12: 0000000000000046
    R13: 0000000000000000  R14: ffff8885a3a0a000  R15: 0000000000000a6c
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffffc90000100b98] _raw_spin_lock_irqsave at ffffffff81cf7d7d
 #7 [ffffc90000100bb8] try_to_wake_up at ffffffff810c1624
 #8 [ffffc90000100c08] closure_sync_fn at ffffffffa040fb07 [bcache]
 #9 [ffffc90000100c10] clone_endio at ffffffff81aac48c
#10 [ffffc90000100c40] call_bio_endio at ffffffff81a78e20
#11 [ffffc90000100c58] raid_end_bio_io at ffffffff81a78e69
#12 [ffffc90000100c88] raid1_end_write_request at ffffffff81a79ad9
#13 [ffffc90000100cf8] blk_update_request at ffffffff814c3ab1
#14 [ffffc90000100d38] blk_mq_end_request at ffffffff814caaf2
#15 [ffffc90000100d50] blk_mq_complete_request at ffffffff814c91c1
#16 [ffffc90000100d78] nvme_complete_cqes at ffffffffa002fb03 [nvme]
#17 [ffffc90000100db8] nvme_irq at ffffffffa002fb7f [nvme]
#18 [ffffc90000100de0] __handle_irq_event_percpu at ffffffff810e0d60
#19 [ffffc90000100e20] handle_irq_event_percpu at ffffffff810e0e65
#20 [ffffc90000100e48] handle_irq_event at ffffffff810e0ecb
#21 [ffffc90000100e60] handle_edge_irq at ffffffff810e494d
#22 [ffffc90000100e78] do_IRQ at ffffffff81e01900
#23 [ffffc90000100eb0] common_interrupt at ffffffff81e00a0a
#24 [ffffc90000100f38] __softirqentry_text_start at ffffffff8200006a
#25 [ffffc90000100fc8] irq_exit at ffffffff810a3f6a
#26 [ffffc90000100fd0] smp_apic_timer_interrupt at ffffffff81e020b2
bt: invalid kernel virtual address: ffffc90000101000  type: "pt_regs"
crash>

I noticed in the call trace that closure_sync_fn() is just before the
thread is woken; I saw one patch from a year ago for closure_sync_fn()
but of course this is already applied in 5.4.69:
https://lore.kernel.org/patchwork/patch/1086698/

I haven't encountered this panic in any prior testing, so it appears
to be rare so far. Not sure what else could be done to debug?

I'll continue testing with heaving I/O to see if this can be reproduced.


--Marc

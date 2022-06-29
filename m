Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5D55FA26
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jun 2022 10:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiF2IKA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jun 2022 04:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiF2IJ7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jun 2022 04:09:59 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948BB3878D
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 01:09:56 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id b23so17898205ljh.7
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 01:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZrkH69WeO3mqj0riro7Qjqo5xF3et4m+sL61lz2eoxY=;
        b=VJfINBu/924hcBr0SkwKCO/H7fASWsiF/ELSivC+OjO76OrpZol/MWUekTnU0Ha0tc
         5ZeTfgIH1b0pqaOnCRPoQOCtZS929kxFym4Os7k6dCGkGDEnRtJtThQibUr8Niqithkt
         B4xuhi2AQocC3XfVdM8k0M5p8HchuRg5hMLfmt5FHp63Oc9qHPDYkyylyZs3fAebDzBs
         2gXYhVKb9BxfzPj23/3rTq9BllHdGQDSrupR0z5Vukc8wIpfhnHALSGmKAqilYjLo18/
         RyIB3QQsvoldF5vR/wXOTa51OdeZKm5VqaC3c0411v35gIXAPmSfvpxdgTHSTZSikcvR
         8Z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZrkH69WeO3mqj0riro7Qjqo5xF3et4m+sL61lz2eoxY=;
        b=RX4kb8o9rE+iptSM2cf4HWbTLMpTjtX06Ditb98clM8PD4gooiQr0V8ekCHlDAJZH1
         B8UeEyJdibVmIYIONPp5zYM2sJk/4HanaxTExH/0bKjyKj0hvEjia4L74trEZGvIMogl
         r4efbAumkfBDSgMyyZOTDfpThBJ1HvjYNZn7bU6ChLCJ93j5X5INQs0wxdgEXvhJDPxu
         PfBZGDqEOSzmsr49qT8Kjuj7dIZo3dRjoRS0wF/e1pWctNze5QRIgME9GeYdIBSOJdv/
         44f/eO4mZT0Q++TXYe3gq0AoCATdRx0wx4pmiYhr24xBNF3e6rdgIPM7IZTfrY0+Hsa6
         eqUQ==
X-Gm-Message-State: AJIora8JHLdcMx8iklUR9qxCBBMeSw5Fctb0dPE7qD2Ri2qJ3/+WOXGX
        pY7OCn4Jo0vv3Oj3lE9WHHwBhU66oledizqomCGdiKQn6ByuzQ==
X-Google-Smtp-Source: AGRyM1sPtAGJ9kzVBWkyqBReVzGO+npU/a+MJwaYm7hdSEyS3Fcj9derRBC04MzETItklpYvXixZm6zZjKrncQ4MHEw=
X-Received: by 2002:a2e:a90d:0:b0:25a:7edb:4034 with SMTP id
 j13-20020a2ea90d000000b0025a7edb4034mr980916ljq.129.1656490194587; Wed, 29
 Jun 2022 01:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de> <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de> <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
In-Reply-To: <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Wed, 29 Jun 2022 13:39:42 +0530
Message-ID: <CAC6jXv1wRjYsDmkR_BjExQ6-kgF+8bAhy84AnVqgObDg1_BEvA@mail.gmail.com>
Subject: Re: seeing this stace trace on kernel 5.15
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

Note I used partitions for the bcache as well as the hdd, not sure if
that's a factor.

the kernel is upstream kernel -

# uname -a
Linux bronzor 5.15.50-051550-generic #202206251445 SMP Sat Jun 25
14:51:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

lsblk shows the setup,

NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sdd           8:48   0 279.4G  0 disk
=E2=94=94=E2=94=80sdd1        8:49   0    60G  0 part
  =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bcache_m=
ount
nvme0n1     259:0    0 372.6G  0 disk
=E2=94=94=E2=94=80nvme0n1p1 259:2    0    15G  0 part
  =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bcache_m=
ount

echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 0 > /sys/fs/bcache/dbadc4cf-feed-42b6-9534-1eeff569a450/congested_read=
_threshold_us
echo 0 > /sys/fs/bcache/dbadc4cf-feed-42b6-9534-1eeff569a450/congested_writ=
e_threshold_us
echo writeback > /sys/block/bcache0/bcache/cache_mode

test that triggers the deadlock -
fio --name=3Dread_iops --directory=3D/home/ubuntu/bcache_mount --size=3D12G
--ioengine=3Dlibaio --direct=3D1 --verify=3D0 --bs=3D4K --iodepth=3D128
--rw=3Drandread --group_reporting=3D1


[ 4473.699902] INFO: task bcache_writebac:1835 blocked for more than
120 seconds.
[ 4474.050921]       Not tainted 5.15.50-051550-generic #202206251445
[ 4474.350883] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4474.731391] task:bcache_writebac state:D stack:    0 pid: 1835
ppid:     2 flags:0x00004000
[ 4474.731408] Call Trace:
[ 4474.731411]  <TASK>
[ 4474.731413]  __schedule+0x23d/0x5a0
[ 4474.731433]  schedule+0x4e/0xb0
[ 4474.731436]  rwsem_down_write_slowpath+0x220/0x3d0
[ 4474.731441]  down_write+0x43/0x50
[ 4474.731446]  bch_writeback_thread+0x78/0x320 [bcache]
[ 4474.731471]  ? read_dirty_submit+0x70/0x70 [bcache]
[ 4474.731487]  kthread+0x12a/0x150
[ 4474.731491]  ? set_kthread_struct+0x50/0x50
[ 4474.731494]  ret_from_fork+0x22/0x30
[ 4474.731499]  </TASK>
[ 4474.731735] INFO: task fio:16626 blocked for more than 121 seconds.
[ 4475.035858]       Not tainted 5.15.50-051550-generic #202206251445
[ 4475.335859] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4475.716526] task:fio             state:D stack:    0 pid:16626
ppid:  1715 flags:0x00004002
[ 4475.716531] Call Trace:
[ 4475.716546]  <TASK>
[ 4475.716549]  __schedule+0x23d/0x5a0
[ 4475.716555]  ? sysvec_apic_timer_interrupt+0x4e/0x90
[ 4475.716560]  schedule+0x4e/0xb0
[ 4475.716563]  rwsem_down_read_slowpath+0x32e/0x380
[ 4475.716567]  down_read+0x43/0x90
[ 4475.716571]  cached_dev_write+0x7e/0x480 [bcache]
[ 4475.716604]  cached_dev_submit_bio+0x502/0x550 [bcache]
[ 4475.716618]  __submit_bio+0x1a1/0x220
[ 4475.716623]  __submit_bio_noacct+0x85/0x1f0
[ 4475.716626]  submit_bio_noacct+0x4e/0x120
[ 4475.716628]  submit_bio+0x4a/0x130
[ 4475.716631]  iomap_submit_ioend+0x53/0x80
[ 4475.716634]  iomap_writepages+0x35/0x40
[ 4475.716636]  xfs_vm_writepages+0x84/0xb0 [xfs]
[ 4475.716730]  do_writepages+0xda/0x200
[ 4475.716736]  filemap_fdatawrite_wbc+0x81/0xd0
[ 4475.716739]  file_write_and_wait_range+0xac/0xf0
[ 4475.716742]  xfs_file_fsync+0x5b/0x250 [xfs]
[ 4475.716821]  vfs_fsync_range+0x49/0x80
[ 4475.716826]  ? __fget_light+0x32/0x80
[ 4475.716829]  __x64_sys_fsync+0x38/0x60
[ 4475.716832]  do_syscall_64+0x5c/0xc0
[ 4475.716836]  ? ksys_write+0xce/0xe0
[ 4475.716838]  ? exit_to_user_mode_prepare+0x37/0xb0
[ 4475.716843]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4475.716847]  ? __x64_sys_write+0x19/0x20
[ 4475.716849]  ? do_syscall_64+0x69/0xc0
[ 4475.716851]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4475.716855]  ? __x64_sys_write+0x19/0x20
[ 4475.716857]  ? do_syscall_64+0x69/0xc0
[ 4475.716859]  ? exit_to_user_mode_prepare+0x37/0xb0
[ 4475.716862]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4475.716865]  ? __x64_sys_write+0x19/0x20
[ 4475.716867]  ? do_syscall_64+0x69/0xc0
[ 4475.716869]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4475.716873]  ? __x64_sys_write+0x19/0x20
[ 4475.716875]  ? do_syscall_64+0x69/0xc0
[ 4475.716877]  ? do_syscall_64+0x69/0xc0
[ 4475.716879]  ? asm_common_interrupt+0x8/0x40
[ 4475.716883]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 4475.716885] RIP: 0033:0x7fd3c498aa5b
[ 4475.716888] RSP: 002b:00007ffc81602ee0 EFLAGS: 00000293 ORIG_RAX:
000000000000004a
[ 4475.716890] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd3c49=
8aa5b
[ 4475.716892] RDX: 0000000000000000 RSI: 000055ededf41f40 RDI: 00000000000=
00006
[ 4475.716893] RBP: 0000000000001000 R08: 0000000000000000 R09: 000055ededf=
41f40
[ 4475.716895] R10: 00000000e8746551 R11: 0000000000000293 R12: 00007fd3ba5=
33000
[ 4475.716896] R13: 0000000000000000 R14: 00007fd3c1cde110 R15: 00000003000=
00000
[ 4475.716898]  </TASK>
[ 4475.716912] INFO: task kworker/26:87:16682 blocked for more than 122 sec=
onds.
[ 4476.063391]       Not tainted 5.15.50-051550-generic #202206251445
[ 4476.363476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4476.743988] task:kworker/26:87   state:D stack:    0 pid:16682
ppid:     2 flags:0x00004000
[ 4476.743994] Workqueue: events update_writeback_rate [bcache]
[ 4476.744022] Call Trace:
[ 4476.744024]  <TASK>
[ 4476.744026]  __schedule+0x23d/0x5a0
[ 4476.744032]  schedule+0x4e/0xb0
[ 4476.744035]  rwsem_down_read_slowpath+0x32e/0x380
[ 4476.744039]  down_read+0x43/0x90
[ 4476.744042]  update_writeback_rate+0x134/0x190 [bcache]
[ 4476.744057]  process_one_work+0x22b/0x3d0
[ 4476.744063]  worker_thread+0x53/0x410
[ 4476.744066]  ? process_one_work+0x3d0/0x3d0
[ 4476.744070]  kthread+0x12a/0x150
[ 4476.744074]  ? set_kthread_struct+0x50/0x50
[ 4476.744077]  ret_from_fork+0x22/0x30
[ 4476.744082]  </TASK>
[ 4598.626220] INFO: task bcache_writebac:1835 blocked for more than
245 seconds.
[ 4598.978432]       Not tainted 5.15.50-051550-generic #202206251445
[ 4599.279900] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4599.657293] task:bcache_writebac state:D stack:    0 pid: 1835
ppid:     2 flags:0x00004000
[ 4599.657298] Call Trace:
[ 4599.657300]  <TASK>
[ 4599.657302]  __schedule+0x23d/0x5a0
[ 4599.657325]  schedule+0x4e/0xb0
[ 4599.657328]  rwsem_down_write_slowpath+0x220/0x3d0
[ 4599.657333]  down_write+0x43/0x50
[ 4599.657338]  bch_writeback_thread+0x78/0x320 [bcache]
[ 4599.657374]  ? read_dirty_submit+0x70/0x70 [bcache]
[ 4599.657390]  kthread+0x12a/0x150
[ 4599.657393]  ? set_kthread_struct+0x50/0x50
[ 4599.657396]  ret_from_fork+0x22/0x30
[ 4599.657401]  </TASK>
[ 4599.657434] INFO: task kworker/2:63:14895 blocked for more than 124 seco=
nds.
[ 4600.000498]       Not tainted 5.15.50-051550-generic #202206251445
[ 4600.301188] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4600.681984] task:kworker/2:63    state:D stack:    0 pid:14895
ppid:     2 flags:0x00004000
[ 4600.682005] Workqueue: bcache bch_data_insert_start [bcache]
[ 4600.682031] Call Trace:
[ 4600.682033]  <TASK>
[ 4600.682035]  __schedule+0x23d/0x5a0
[ 4600.682040]  schedule+0x4e/0xb0
[ 4600.682043]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
[ 4600.682066]  ? wait_woken+0x70/0x70
[ 4600.682071]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
[ 4600.682082]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
[ 4600.682098]  ? krealloc+0x9d/0xd0
[ 4600.682102]  ? __bch_keylist_realloc+0xb7/0x100 [bcache]
[ 4600.682113]  ? __bch_submit_bbio+0x97/0xb0 [bcache]
[ 4600.682126]  bch_data_insert_start+0x15e/0x3a0 [bcache]
[ 4600.682139]  ? closure_sub+0x94/0xb0 [bcache]
[ 4600.682152]  process_one_work+0x22b/0x3d0
[ 4600.682157]  worker_thread+0x53/0x410
[ 4600.682161]  ? process_one_work+0x3d0/0x3d0
[ 4600.682164]  kthread+0x12a/0x150
[ 4600.682168]  ? set_kthread_struct+0x50/0x50
[ 4600.682171]  ret_from_fork+0x22/0x30
[ 4600.682176]  </TASK>
[ 4600.682240] INFO: task kworker/25:123:16464 blocked for more than
125 seconds.
[ 4601.033116]       Not tainted 5.15.50-051550-generic #202206251445
[ 4601.333405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4601.713829] task:kworker/25:123  state:D stack:    0 pid:16464
ppid:     2 flags:0x00004000
[ 4601.713835] Workqueue: xfs-sync/bcache0 xfs_log_worker [xfs]
[ 4601.713975] Call Trace:
[ 4601.713977]  <TASK>
[ 4601.713979]  __schedule+0x23d/0x5a0
[ 4601.713986]  schedule+0x4e/0xb0
[ 4601.713988]  rwsem_down_read_slowpath+0x32e/0x380
[ 4601.713993]  down_read+0x43/0x90
[ 4601.713996]  cached_dev_write+0x7e/0x480 [bcache]
[ 4601.714018]  cached_dev_submit_bio+0x502/0x550 [bcache]
[ 4601.714031]  __submit_bio+0x1a1/0x220
[ 4601.714035]  ? ttwu_do_activate+0x72/0xf0
[ 4601.714039]  __submit_bio_noacct+0x85/0x1f0
[ 4601.714042]  ? mutex_lock+0x13/0x40
[ 4601.714045]  submit_bio_noacct+0x4e/0x120
[ 4601.714047]  submit_bio+0x4a/0x130
[ 4601.714050]  xlog_write_iclog+0x254/0x300 [xfs]
[ 4601.714142]  xlog_sync+0x1ab/0x2c0 [xfs]
[ 4601.714225]  xlog_state_release_iclog+0x123/0x1d0 [xfs]
[ 4601.714306]  xfs_log_force+0x186/0x250 [xfs]
[ 4601.714386]  xfs_log_worker+0x39/0x90 [xfs]
[ 4601.714466]  process_one_work+0x22b/0x3d0
[ 4601.714471]  worker_thread+0x53/0x410
[ 4601.714474]  ? process_one_work+0x3d0/0x3d0
[ 4601.714477]  kthread+0x12a/0x150
[ 4601.714481]  ? set_kthread_struct+0x50/0x50
[ 4601.714484]  ret_from_fork+0x22/0x30
[ 4601.714489]  </TASK>
[ 4601.714526] INFO: task kworker/22:89:16557 blocked for more than 126 sec=
onds.
[ 4602.056844]       Not tainted 5.15.50-051550-generic #202206251445
[ 4602.357148] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4602.733923] task:kworker/22:89   state:D stack:    0 pid:16557
ppid:     2 flags:0x00004000
[ 4602.733940] Workqueue: bcache bch_data_insert_start [bcache]
[ 4602.733966] Call Trace:
[ 4602.733968]  <TASK>
[ 4602.733970]  __schedule+0x23d/0x5a0
[ 4602.733988]  schedule+0x4e/0xb0
[ 4602.733991]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
[ 4602.734002]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
[ 4602.734014]  ? wait_woken+0x70/0x70
[ 4602.734019]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
[ 4602.734031]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
[ 4602.734043]  ? __wake_up_common_lock+0x8a/0xc0
[ 4602.734046]  bch_data_insert_start+0x15e/0x3a0 [bcache]
[ 4602.734062]  ? closure_sub+0x94/0xb0 [bcache]
[ 4602.734083]  process_one_work+0x22b/0x3d0
[ 4602.734088]  worker_thread+0x53/0x410
[ 4602.734092]  ? process_one_work+0x3d0/0x3d0
[ 4602.734095]  kthread+0x12a/0x150
[ 4602.734099]  ? set_kthread_struct+0x50/0x50
[ 4602.734102]  ret_from_fork+0x22/0x30
[ 4602.734108]  </TASK>
[ 4602.734134] INFO: task fio:16626 blocked for more than 249 seconds.
[ 4603.034541]       Not tainted 5.15.50-051550-generic #202206251445
[ 4603.330400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4603.711013] task:fio             state:D stack:    0 pid:16626
ppid:  1715 flags:0x00004002
[ 4603.711030] Call Trace:
[ 4603.711032]  <TASK>
[ 4603.711046]  __schedule+0x23d/0x5a0
[ 4603.711054]  ? sysvec_apic_timer_interrupt+0x4e/0x90
[ 4603.711060]  schedule+0x4e/0xb0
[ 4603.711063]  rwsem_down_read_slowpath+0x32e/0x380
[ 4603.711067]  down_read+0x43/0x90
[ 4603.711072]  cached_dev_write+0x7e/0x480 [bcache]
[ 4603.711095]  cached_dev_submit_bio+0x502/0x550 [bcache]
[ 4603.711108]  __submit_bio+0x1a1/0x220
[ 4603.711113]  __submit_bio_noacct+0x85/0x1f0
[ 4603.711116]  submit_bio_noacct+0x4e/0x120
[ 4603.711118]  submit_bio+0x4a/0x130
[ 4603.711121]  iomap_submit_ioend+0x53/0x80
[ 4603.711124]  iomap_writepages+0x35/0x40
[ 4603.711126]  xfs_vm_writepages+0x84/0xb0 [xfs]
[ 4603.711223]  do_writepages+0xda/0x200
[ 4603.711229]  filemap_fdatawrite_wbc+0x81/0xd0
[ 4603.711232]  file_write_and_wait_range+0xac/0xf0
[ 4603.711235]  xfs_file_fsync+0x5b/0x250 [xfs]
[ 4603.711312]  vfs_fsync_range+0x49/0x80
[ 4603.711317]  ? __fget_light+0x32/0x80
[ 4603.711321]  __x64_sys_fsync+0x38/0x60
[ 4603.711324]  do_syscall_64+0x5c/0xc0
[ 4603.711327]  ? ksys_write+0xce/0xe0
[ 4603.711330]  ? exit_to_user_mode_prepare+0x37/0xb0
[ 4603.711335]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4603.711338]  ? __x64_sys_write+0x19/0x20
[ 4603.711340]  ? do_syscall_64+0x69/0xc0
[ 4603.711342]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4603.711345]  ? __x64_sys_write+0x19/0x20
[ 4603.711347]  ? do_syscall_64+0x69/0xc0
[ 4603.711349]  ? exit_to_user_mode_prepare+0x37/0xb0
[ 4603.711352]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4603.711355]  ? __x64_sys_write+0x19/0x20
[ 4603.711357]  ? do_syscall_64+0x69/0xc0
[ 4603.711359]  ? syscall_exit_to_user_mode+0x27/0x50
[ 4603.711362]  ? __x64_sys_write+0x19/0x20
[ 4603.711364]  ? do_syscall_64+0x69/0xc0
[ 4603.711366]  ? do_syscall_64+0x69/0xc0
[ 4603.711368]  ? asm_common_interrupt+0x8/0x40
[ 4603.711371]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 4603.711374] RIP: 0033:0x7fd3c498aa5b
[ 4603.711376] RSP: 002b:00007ffc81602ee0 EFLAGS: 00000293 ORIG_RAX:
000000000000004a
[ 4603.711379] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd3c49=
8aa5b
[ 4603.711381] RDX: 0000000000000000 RSI: 000055ededf41f40 RDI: 00000000000=
00006
[ 4603.711382] RBP: 0000000000001000 R08: 0000000000000000 R09: 000055ededf=
41f40
[ 4603.711383] R10: 00000000e8746551 R11: 0000000000000293 R12: 00007fd3ba5=
33000
[ 4603.711384] R13: 0000000000000000 R14: 00007fd3c1cde110 R15: 00000003000=
00000
[ 4603.711387]  </TASK>
[ 4603.711421] INFO: task kworker/26:87:16682 blocked for more than 250 sec=
onds.
[ 4604.058441]       Not tainted 5.15.50-051550-generic #202206251445
[ 4604.359128] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4604.739950] task:kworker/26:87   state:D stack:    0 pid:16682
ppid:     2 flags:0x00004000
[ 4604.739968] Workqueue: events update_writeback_rate [bcache]
[ 4604.739995] Call Trace:
[ 4604.739997]  <TASK>
[ 4604.740012]  __schedule+0x23d/0x5a0
[ 4604.740017]  schedule+0x4e/0xb0
[ 4604.740020]  rwsem_down_read_slowpath+0x32e/0x380
[ 4604.740024]  down_read+0x43/0x90
[ 4604.740027]  update_writeback_rate+0x134/0x190 [bcache]
[ 4604.740043]  process_one_work+0x22b/0x3d0
[ 4604.740049]  worker_thread+0x53/0x410
[ 4604.740052]  ? process_one_work+0x3d0/0x3d0
[ 4604.740055]  kthread+0x12a/0x150
[ 4604.740059]  ? set_kthread_struct+0x50/0x50
[ 4604.740062]  ret_from_fork+0x22/0x30
[ 4604.740067]  </TASK>
[ 4725.600602] INFO: task bcache_writebac:1835 blocked for more than
372 seconds.
[ 4725.952827]       Not tainted 5.15.50-051550-generic #202206251445
[ 4726.253763] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4726.630937] task:bcache_writebac state:D stack:    0 pid: 1835
ppid:     2 flags:0x00004000
[ 4726.630954] Call Trace:
[ 4726.630956]  <TASK>
[ 4726.630959]  __schedule+0x23d/0x5a0
[ 4726.630966]  schedule+0x4e/0xb0
[ 4726.630970]  rwsem_down_write_slowpath+0x220/0x3d0
[ 4726.630976]  down_write+0x43/0x50
[ 4726.630980]  bch_writeback_thread+0x78/0x320 [bcache]
[ 4726.631005]  ? read_dirty_submit+0x70/0x70 [bcache]
[ 4726.631021]  kthread+0x12a/0x150
[ 4726.631025]  ? set_kthread_struct+0x50/0x50
[ 4726.631028]  ret_from_fork+0x22/0x30
[ 4726.631033]  </TASK>

Regards,
Nikhil.

On Wed, 29 Jun 2022 at 13:26, Nikhil Kshirsagar <nkshirsagar@gmail.com> wro=
te:
>
> 60gb slow hdd, 15gb fast nvme cache. shall i file upstream bug for this i=
ssue?
>
> On Wed, 29 Jun 2022 at 13:20, Coly Li <colyli@suse.de> wrote:
> >
> >
> >
> > > 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 15:02=EF=BC=8CNikhil Kshirsagar <n=
kshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi Coly,
> > >
> > > I see the same bug on upstream kernel when I tried with
> > > https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/  (
> > > cod/mainline/v5.15.50 (767db4b286c3e101ac220b813c873f492d9e4ee8)
> >
> >
> > Can you help to try the linux-stable tree, or the latest upstream Linus=
 tree? Then I can have a clean code base.
> >
> > >
> > > Reads seem to trigger it, not writes. So this test triggered it -
> > >
> > > fio --name=3Dread_iops --directory=3D/home/ubuntu/bcache_mount --size=
=3D12G
> > > --ioengine=3Dlibaio --direct=3D1 --verify=3D0 --bs=3D4K --iodepth=3D1=
28
> > > --rw=3Drandread --group_reporting=3D1
> > >
> > > https://pastebin.com/KyVSfnik has all the details.
> >
> >
> > OK, I will try to reproduce with above operation. What is the preferred=
 cache and backing device sizes to reproduce the soft lockup?
> >
> > Thanks.
> >
> > Coly Li
> >
> >
> > >
> > > Regards,
> > > Nikhil.
> > >
> > > On Tue, 28 Jun 2022 at 20:08, Coly Li <colyli@suse.de> wrote:
> > >>
> > >>
> > >>
> > >>> 2022=E5=B9=B46=E6=9C=8828=E6=97=A5 14:31=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>
> > >>> Hi Coly,
> > >>>
> > >>> I just kicked off a 20gb random readwrite test using fio to a bcach=
e device,
> > >>>
> > >>> fio --filename=3D/home/ubuntu/bcache_mount/cacahedfile --size=3D20G=
B
> > >>> --direct=3D1 --rw=3Drandrw --bs=3D4k --ioengine=3Dlibaio --iodepth=
=3D128
> > >>> --name=3Diops-test-job --eta-newline=3D1
> > >>>
> > >>> # lsblk /dev/sdc /dev/nvme0n1
> > >>> NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
> > >>> sdc           8:32   0 279.4G  0 disk
> > >>> =E2=94=94=E2=94=80sdc1        8:33   0    60G  0 part
> > >>> =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bc=
ache_mount
> > >>> nvme0n1     259:0    0 372.6G  0 disk
> > >>> =E2=94=94=E2=94=80nvme0n1p1 259:2    0    15G  0 part
> > >>> =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bc=
ache_mount
> > >>>
> > >>> and am seeing this trace in the dmesg,
> > >>>
> > >>> [ 2475.034909] XFS (bcache0): Ending clean mount
> > >>> [ 2475.036238] xfs filesystem being mounted at
> > >>> /home/ubuntu/bcache_mount supports timestamps until 2038 (0x7ffffff=
f)
> > >>>
> > >>> [ 2782.176705] INFO: task kworker/2:1:255 blocked for more than 120=
 seconds.
> > >>> [ 2782.507171]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2782.774078] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2783.155206] task:kworker/2:1     state:D stack:    0 pid:  255
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2783.155210] Workqueue: bcache bch_data_insert_start [bcache]
> > >>> [ 2783.155259] Call Trace:
> > >>> [ 2783.155261]  <TASK>
> > >>> [ 2783.155263]  __schedule+0x23d/0x590
> > >>> [ 2783.155269]  schedule+0x4e/0xb0
> > >>> [ 2783.155271]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> > >>> [ 2783.155281]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> > >>> [ 2783.155294]  ? wait_woken+0x70/0x70
> > >>> [ 2783.155298]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> > >>> [ 2783.155309]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> > >>> [ 2783.155319]  ? bch_btree_insert+0xea/0x130 [bcache]
> > >>> [ 2783.155331]  ? __queue_work+0x211/0x480
> > >>> [ 2783.155336]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> > >>> [ 2783.155349]  ? closure_sub+0x94/0xb0 [bcache]
> > >>> [ 2783.155362]  process_one_work+0x22b/0x3d0
> > >>> [ 2783.155366]  worker_thread+0x53/0x410
> > >>> [ 2783.155369]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2783.155372]  kthread+0x12a/0x150
> > >>> [ 2783.155376]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2783.155379]  ret_from_fork+0x22/0x30
> > >>> [ 2783.155385]  </TASK>
> > >>> [ 2783.155423] INFO: task kworker/3:1:267 blocked for more than 121=
 seconds.
> > >>> [ 2783.485797]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2783.752485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2784.133541] task:kworker/3:1     state:D stack:    0 pid:  267
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2784.133544] Workqueue: events update_writeback_rate [bcache]
> > >>> [ 2784.133588] Call Trace:
> > >>> [ 2784.133589]  <TASK>
> > >>> [ 2784.133591]  __schedule+0x23d/0x590
> > >>> [ 2784.133594]  schedule+0x4e/0xb0
> > >>> [ 2784.133596]  rwsem_down_read_slowpath+0x32e/0x380
> > >>> [ 2784.133600]  down_read+0x43/0x90
> > >>> [ 2784.133602]  update_writeback_rate+0x134/0x190 [bcache]
> > >>> [ 2784.133619]  process_one_work+0x22b/0x3d0
> > >>> [ 2784.133623]  worker_thread+0x53/0x410
> > >>> [ 2784.133626]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2784.133630]  kthread+0x12a/0x150
> > >>> [ 2784.133633]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2784.133636]  ret_from_fork+0x22/0x30
> > >>> [ 2784.133640]  </TASK>
> > >>> [ 2784.133650] INFO: task kworker/25:2:326 blocked for more than 12=
2 seconds.
> > >>> [ 2784.467880]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2784.734405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2785.114677] task:kworker/25:2    state:D stack:    0 pid:  326
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2785.114692] Workqueue: bcache bch_data_insert_start [bcache]
> > >>> [ 2785.114720] Call Trace:
> > >>> [ 2785.114721]  <TASK>
> > >>> [ 2785.114723]  __schedule+0x23d/0x590
> > >>> [ 2785.114726]  schedule+0x4e/0xb0
> > >>> [ 2785.114729]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> > >>> [ 2785.114740]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> > >>> [ 2785.114753]  ? wait_woken+0x70/0x70
> > >>> [ 2785.114756]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> > >>> [ 2785.114766]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> > >>> [ 2785.114777]  ? bch_btree_insert+0xea/0x130 [bcache]
> > >>> [ 2785.114789]  ? __queue_work+0x211/0x480
> > >>> [ 2785.114793]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> > >>> [ 2785.114806]  ? closure_sub+0x94/0xb0 [bcache]
> > >>> [ 2785.114818]  process_one_work+0x22b/0x3d0
> > >>> [ 2785.114822]  worker_thread+0x53/0x410
> > >>> [ 2785.114826]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2785.114829]  kthread+0x12a/0x150
> > >>> [ 2785.114832]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2785.114835]  ret_from_fork+0x22/0x30
> > >>> [ 2785.114839]  </TASK>
> > >>> [ 2785.114864] INFO: task kworker/6:0:3038 blocked for more than 12=
3 seconds.
> > >>> [ 2785.444697]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2785.711071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2786.091440] task:kworker/6:0     state:D stack:    0 pid: 3038
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2786.091446] Workqueue: xfs-sync/bcache0 xfs_log_worker [xfs]
> > >>> [ 2786.091582] Call Trace:
> > >>> [ 2786.091584]  <TASK>
> > >>> [ 2786.091585]  __schedule+0x23d/0x590
> > >>> [ 2786.091589]  schedule+0x4e/0xb0
> > >>> [ 2786.091591]  rwsem_down_read_slowpath+0x32e/0x380
> > >>> [ 2786.091594]  down_read+0x43/0x90
> > >>> [ 2786.091597]  cached_dev_write+0x7e/0x480 [bcache]
> > >>> [ 2786.091613]  cached_dev_submit_bio+0x4ef/0x540 [bcache]
> > >>> [ 2786.091626]  __submit_bio+0x1a1/0x220
> > >>> [ 2786.091631]  __submit_bio_noacct+0x85/0x1f0
> > >>> [ 2786.091634]  ? mutex_lock+0x13/0x40
> > >>> [ 2786.091637]  submit_bio_noacct+0x4e/0x120
> > >>> [ 2786.091640]  submit_bio+0x4a/0x130
> > >>> [ 2786.091642]  xlog_write_iclog+0x254/0x300 [xfs]
> > >>> [ 2786.091725]  xlog_sync+0x1ab/0x2c0 [xfs]
> > >>> [ 2786.091807]  xlog_state_release_iclog+0x123/0x1d0 [xfs]
> > >>> [ 2786.091925]  xfs_log_force+0x186/0x250 [xfs]
> > >>> [ 2786.091994]  xfs_log_worker+0x39/0x90 [xfs]
> > >>> [ 2786.092063]  process_one_work+0x22b/0x3d0
> > >>> [ 2786.092067]  worker_thread+0x53/0x410
> > >>> [ 2786.092069]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2786.092072]  kthread+0x12a/0x150
> > >>> [ 2786.092074]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2786.092077]  ret_from_fork+0x22/0x30
> > >>> [ 2786.092081]  </TASK>
> > >>> [ 2786.092088] INFO: task kworker/25:0:3047 blocked for more than 1=
24 seconds.
> > >>> [ 2786.430313]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2786.696626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2787.077056] task:kworker/25:0    state:D stack:    0 pid: 3047
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2787.077071] Workqueue: bcache bch_data_insert_start [bcache]
> > >>> [ 2787.077098] Call Trace:
> > >>> [ 2787.077099]  <TASK>
> > >>> [ 2787.077101]  __schedule+0x23d/0x590
> > >>> [ 2787.077104]  schedule+0x4e/0xb0
> > >>> [ 2787.077106]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> > >>> [ 2787.077116]  ? wait_woken+0x70/0x70
> > >>> [ 2787.077119]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> > >>> [ 2787.077142]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> > >>> [ 2787.077153]  ? __bch_submit_bbio+0x97/0xb0 [bcache]
> > >>> [ 2787.077166]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> > >>> [ 2787.077179]  ? closure_sub+0x94/0xb0 [bcache]
> > >>> [ 2787.077191]  process_one_work+0x22b/0x3d0
> > >>> [ 2787.077195]  worker_thread+0x53/0x410
> > >>> [ 2787.077198]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2787.077202]  kthread+0x12a/0x150
> > >>> [ 2787.077205]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2787.077207]  ret_from_fork+0x22/0x30
> > >>> [ 2787.077212]  </TASK>
> > >>> [ 2787.077247] INFO: task bcache_writebac:3080 blocked for more tha=
n
> > >>> 125 seconds.
> > >>> [ 2787.423890]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2787.690476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2788.071063] task:bcache_writebac state:D stack:    0 pid: 3080
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2788.071080] Call Trace:
> > >>> [ 2788.071081]  <TASK>
> > >>> [ 2788.071082]  __schedule+0x23d/0x590
> > >>> [ 2788.071086]  schedule+0x4e/0xb0
> > >>> [ 2788.071100]  rwsem_down_write_slowpath+0x220/0x3d0
> > >>> [ 2788.071105]  ? del_timer_sync+0x6c/0xb0
> > >>> [ 2788.071109]  down_write+0x43/0x50
> > >>> [ 2788.071112]  bch_writeback_thread+0x78/0x320 [bcache]
> > >>> [ 2788.071142]  ? read_dirty+0x5a0/0x5a0 [bcache]
> > >>> [ 2788.071158]  kthread+0x12a/0x150
> > >>> [ 2788.071161]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2788.071164]  ret_from_fork+0x22/0x30
> > >>> [ 2788.071168]  </TASK>
> > >>> [ 2788.071199] INFO: task fio:3123 blocked for more than 126 second=
s.
> > >>> [ 2788.367175]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2788.633386] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2789.014084] task:fio             state:D stack:    0 pid: 3123
> > >>> ppid:  2378 flags:0x00004002
> > >>> [ 2789.014087] Call Trace:
> > >>> [ 2789.014089]  <TASK>
> > >>> [ 2789.014090]  __schedule+0x23d/0x590
> > >>> [ 2789.014106]  schedule+0x4e/0xb0
> > >>> [ 2789.014108]  io_schedule+0x46/0x70
> > >>> [ 2789.014110]  wait_on_page_bit_common+0x10c/0x3d0
> > >>> [ 2789.014115]  ? filemap_invalidate_unlock_two+0x40/0x40
> > >>> [ 2789.014118]  wait_on_page_bit+0x3f/0x50
> > >>> [ 2789.014120]  wait_on_page_writeback+0x26/0x80
> > >>> [ 2789.014124]  __filemap_fdatawait_range+0x97/0x110
> > >>> [ 2789.014126]  file_write_and_wait_range+0xcc/0xf0
> > >>> [ 2789.014130]  xfs_file_fsync+0x5b/0x250 [xfs]
> > >>> [ 2789.014207]  vfs_fsync_range+0x49/0x80
> > >>> [ 2789.014212]  ? __fget_light+0x32/0x80
> > >>> [ 2789.014217]  __x64_sys_fsync+0x38/0x60
> > >>> [ 2789.014220]  do_syscall_64+0x5c/0xc0
> > >>> [ 2789.014223]  ? do_syscall_64+0x69/0xc0
> > >>> [ 2789.014225]  ? do_syscall_64+0x69/0xc0
> > >>> [ 2789.014226]  ? syscall_exit_to_user_mode+0x27/0x50
> > >>> [ 2789.014230]  ? __x64_sys_write+0x19/0x20
> > >>> [ 2789.014232]  ? do_syscall_64+0x69/0xc0
> > >>> [ 2789.014234]  ? do_syscall_64+0x69/0xc0
> > >>> [ 2789.014235]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
> > >>> [ 2789.014239]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >>> [ 2789.014243] RIP: 0033:0x7f2cfdcfea5b
> > >>> [ 2789.014245] RSP: 002b:00007ffcd87c6e60 EFLAGS: 00000293 ORIG_RAX=
:
> > >>> 000000000000004a
> > >>> [ 2789.014248] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000=
07f2cfdcfea5b
> > >>> [ 2789.014249] RDX: 0000000000000000 RSI: 000055c8d26e6f40 RDI: 000=
0000000000006
> > >>> [ 2789.014250] RBP: 0000000000001000 R08: 0000000000000000 R09: 000=
055c8d26e6f40
> > >>> [ 2789.014252] R10: 00000000a318c620 R11: 0000000000000293 R12: 000=
07f2cf38a7000
> > >>> [ 2789.014253] R13: 0000000000000000 R14: 00007f2cfb0522f0 R15: 000=
0000500000000
> > >>> [ 2789.014255]  </TASK>
> > >>> [ 2909.151501] INFO: task kworker/2:1:255 blocked for more than 247=
 seconds.
> > >>> [ 2909.481856]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2909.748707] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2910.130132] task:kworker/2:1     state:D stack:    0 pid:  255
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2910.130147] Workqueue: bcache bch_data_insert_start [bcache]
> > >>> [ 2910.130176] Call Trace:
> > >>> [ 2910.130177]  <TASK>
> > >>> [ 2910.130179]  __schedule+0x23d/0x590
> > >>> [ 2910.130182]  schedule+0x4e/0xb0
> > >>> [ 2910.130184]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> > >>> [ 2910.130194]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> > >>> [ 2910.130219]  ? wait_woken+0x70/0x70
> > >>> [ 2910.130222]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> > >>> [ 2910.130233]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> > >>> [ 2910.130243]  ? bch_btree_insert+0xea/0x130 [bcache]
> > >>> [ 2910.130255]  ? __queue_work+0x211/0x480
> > >>> [ 2910.130259]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> > >>> [ 2910.130272]  ? closure_sub+0x94/0xb0 [bcache]
> > >>> [ 2910.130285]  process_one_work+0x22b/0x3d0
> > >>> [ 2910.130288]  worker_thread+0x53/0x410
> > >>> [ 2910.130292]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2910.130295]  kthread+0x12a/0x150
> > >>> [ 2910.130298]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2910.130301]  ret_from_fork+0x22/0x30
> > >>> [ 2910.130305]  </TASK>
> > >>> [ 2910.130307] INFO: task kworker/3:1:267 blocked for more than 248=
 seconds.
> > >>> [ 2910.456520]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2910.723476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2911.104601] task:kworker/3:1     state:D stack:    0 pid:  267
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2911.104617] Workqueue: events update_writeback_rate [bcache]
> > >>> [ 2911.104647] Call Trace:
> > >>> [ 2911.104648]  <TASK>
> > >>> [ 2911.104649]  __schedule+0x23d/0x590
> > >>> [ 2911.104652]  schedule+0x4e/0xb0
> > >>> [ 2911.104654]  rwsem_down_read_slowpath+0x32e/0x380
> > >>> [ 2911.104657]  down_read+0x43/0x90
> > >>> [ 2911.104660]  update_writeback_rate+0x134/0x190 [bcache]
> > >>> [ 2911.104676]  process_one_work+0x22b/0x3d0
> > >>> [ 2911.104680]  worker_thread+0x53/0x410
> > >>> [ 2911.104683]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2911.104687]  kthread+0x12a/0x150
> > >>> [ 2911.104690]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2911.104693]  ret_from_fork+0x22/0x30
> > >>> [ 2911.104697]  </TASK>
> > >>> [ 2911.104733] INFO: task kworker/25:2:326 blocked for more than 24=
9 seconds.
> > >>> [ 2911.439086]       Not tainted 5.15.0-40-generic #43-Ubuntu
> > >>> [ 2911.706294] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > >>> disables this message.
> > >>> [ 2912.087471] task:kworker/25:2    state:D stack:    0 pid:  326
> > >>> ppid:     2 flags:0x00004000
> > >>> [ 2912.087475] Workqueue: bcache bch_data_insert_start [bcache]
> > >>> [ 2912.087495] Call Trace:
> > >>> [ 2912.087497]  <TASK>
> > >>> [ 2912.087498]  __schedule+0x23d/0x590
> > >>> [ 2912.087503]  schedule+0x4e/0xb0
> > >>> [ 2912.087505]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> > >>> [ 2912.087516]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> > >>> [ 2912.087528]  ? wait_woken+0x70/0x70
> > >>> [ 2912.087532]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> > >>> [ 2912.087543]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> > >>> [ 2912.087553]  ? bch_btree_insert+0xea/0x130 [bcache]
> > >>> [ 2912.087565]  ? __queue_work+0x211/0x480
> > >>> [ 2912.087570]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> > >>> [ 2912.087583]  ? closure_sub+0x94/0xb0 [bcache]
> > >>> [ 2912.087595]  process_one_work+0x22b/0x3d0
> > >>> [ 2912.087599]  worker_thread+0x53/0x410
> > >>> [ 2912.087602]  ? process_one_work+0x3d0/0x3d0
> > >>> [ 2912.087606]  kthread+0x12a/0x150
> > >>> [ 2912.087609]  ? set_kthread_struct+0x50/0x50
> > >>> [ 2912.087612]  ret_from_fork+0x22/0x30
> > >>> [ 2912.087617]  </TASK>
> > >>>
> > >>> Is this a bug? It's in writeback mode. I'd setup the cache and run =
stuff like,
> > >>>
> > >>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> > >>>
> > >>> I had also echoed 0 into congested_read_threshold_us,
> > >>> congested_write_threshold_us.
> > >>>
> > >>> echo writeback > /sys/block/bcache0/bcache/cache_mode
> > >>
> > >> Where do you get the kernel? If this is stable kernel, could you giv=
e me the HEAD commit id?
> > >>
> > >> Coly Li
> > >>
> >

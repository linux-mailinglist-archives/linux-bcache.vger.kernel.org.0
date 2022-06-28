Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C632B55DD46
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Jun 2022 15:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbiF1HXh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Jun 2022 03:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiF1HXg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Jun 2022 03:23:36 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159812CDF4
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jun 2022 00:23:34 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id j21so20749104lfe.1
        for <linux-bcache@vger.kernel.org>; Tue, 28 Jun 2022 00:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CIi3HyvZBcWQwOzOluOZ7hZfPrJcAFg6Aztou1BK7Z4=;
        b=PPv5o2Puzp1qs2/rBJs2rP9R1n0w6W+DEWhngl/wLD0HAtdzAY9xGgGq7+Ak2ivoUh
         Jj6AwvG1r1DDj11FsFzDjDE8IwfR5FRxOOmaYtvESLOXE59R1502Jcj6gGyz9iMSBkuX
         Au5LT4IxY00orX/9noN4LB3dJ7rkjApzGsXdtw1tOV36kcLD07OHRsPSQ4jKAauUox/m
         L/F2l+ESluM4VCoRSKs4wBnR1WwloBiA1FkuP/7UDpviUJtWKnHv8XUNn96mR4sVX5Sp
         2nZDwGMkS5nQFwDWB3soIq5D2ituCmNliFLvAqbXsQdGGr1Th4UMuTeX8SwLirIzrUTU
         yPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=CIi3HyvZBcWQwOzOluOZ7hZfPrJcAFg6Aztou1BK7Z4=;
        b=QH5Jz7btLkQoWBj3dsxwJdNEHaeAIiszyTvuvtQ3/FjDK6BI6kf0Ma2JcWOWWJO9dq
         66v4YoBfdhC365/ifUiIIUwE8pTQU/CflUFhgyvnP+LTTHrLyPV9Cm0Dls3Qcxz8Auck
         bQAkqumn/FrncTtvrpjeA+trLe1IGHIpQtK4fx8RxE9Of1uQnJhruYH4RyHau72iGsrq
         jE0alcF8vnO0wSPHsuJqjmicnTuSGUnGms9odfmjmaDQ515Q4/mhj7ldJLB4cx+ff8U8
         BoB2CBm0KRqWYX8ebQi3BTt6VKcjK8QtHtrOD7KGMIWz87pC0li4q16RZVdhiR1nPvT6
         A68g==
X-Gm-Message-State: AJIora/CrvOOH3bRs3P65kG0nBLodwkLE68+zK5hKp5YrLqkmlcuQSuH
        lchuQK4OZ6o8k68rxHQWvpFJ+qRqq0VhtD6uHKwi3BlPcIOjeg==
X-Google-Smtp-Source: AGRyM1tEcsjFgEoynLTeMLizrCRJN/YwRAsT871HQ0Mz6vXCTY4D+EpzLyQ7H/ZPBNRtgfPO/4temge+W6syVs2cS7g=
X-Received: by 2002:a05:6512:1104:b0:481:d6b:450 with SMTP id
 l4-20020a056512110400b004810d6b0450mr8127928lfg.346.1656401012076; Tue, 28
 Jun 2022 00:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
In-Reply-To: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Tue, 28 Jun 2022 12:53:19 +0530
Message-ID: <CAC6jXv0iVXLaMrDzj7q4wd=VfgH7c05QsH7HVD7zujoQ7vpTNA@mail.gmail.com>
Subject: Re: seeing this stace trace on kernel 5.15
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
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

Able to reproduce this very easily each time I run the same fio test -

[  969.525374] INFO: task kworker/0:6:261 blocked for more than 120 seconds=
.
[  969.850975]       Not tainted 5.15.0-40-generic #43-Ubuntu
[  970.117328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  970.497751] task:kworker/0:6     state:D stack:    0 pid:  261
ppid:     2 flags:0x00004000
[  970.497768] Workqueue: events update_writeback_rate [bcache]
[  970.497806] Call Trace:
[  970.497808]  <TASK>
[  970.497810]  __schedule+0x23d/0x590
[  970.497826]  schedule+0x4e/0xb0
[  970.497828]  rwsem_down_read_slowpath+0x32e/0x380
[  970.497832]  down_read+0x43/0x90
[  970.497834]  update_writeback_rate+0x134/0x190 [bcache]
[  970.497850]  process_one_work+0x22b/0x3d0
[  970.497856]  worker_thread+0x53/0x410
[  970.497859]  ? process_one_work+0x3d0/0x3d0
[  970.497862]  kthread+0x12a/0x150
[  970.497865]  ? set_kthread_struct+0x50/0x50
[  970.497868]  ret_from_fork+0x22/0x30
[  970.497874]  </TASK>
[  970.497885] INFO: task kworker/22:2:326 blocked for more than 121 second=
s.
[  970.831922]       Not tainted 5.15.0-40-generic #43-Ubuntu
[  971.098073] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  971.478693] task:kworker/22:2    state:D stack:    0 pid:  326
ppid:     2 flags:0x00004000
[  971.478696] Workqueue: bcache bch_data_insert_start [bcache]
[  971.478734] Call Trace:
[  971.478736]  <TASK>
[  971.478737]  __schedule+0x23d/0x590
[  971.478740]  schedule+0x4e/0xb0
[  971.478742]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
[  971.478752]  ? wait_woken+0x70/0x70
[  971.478756]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
[  971.478779]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
[  971.478790]  ? __bch_submit_bbio+0x97/0xb0 [bcache]
[  971.478803]  bch_data_insert_start+0x15e/0x3a0 [bcache]
[  971.478816]  ? closure_sub+0x94/0xb0 [bcache]
[  971.478829]  process_one_work+0x22b/0x3d0
[  971.478832]  worker_thread+0x53/0x410
[  971.478836]  ? process_one_work+0x3d0/0x3d0
[  971.478839]  kthread+0x12a/0x150
[  971.478842]  ? set_kthread_struct+0x50/0x50
[  971.478845]  ret_from_fork+0x22/0x30
[  971.478849]  </TASK>
[  971.478895] INFO: task bcache_writebac:2911 blocked for more than
122 seconds.
[  971.829737]       Not tainted 5.15.0-40-generic #43-Ubuntu
[  972.096191] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  972.476825] task:bcache_writebac state:D stack:    0 pid: 2911
ppid:     2 flags:0x00004000
[  972.476841] Call Trace:
[  972.476842]  <TASK>
[  972.476843]  __schedule+0x23d/0x590
[  972.476847]  schedule+0x4e/0xb0
[  972.476861]  rwsem_down_write_slowpath+0x220/0x3d0
[  972.476865]  ? del_timer_sync+0x6c/0xb0
[  972.476869]  down_write+0x43/0x50
[  972.476872]  bch_writeback_thread+0x78/0x320 [bcache]
[  972.476891]  ? read_dirty+0x5a0/0x5a0 [bcache]
[  972.476919]  kthread+0x12a/0x150
[  972.476922]  ? set_kthread_struct+0x50/0x50
[  972.476926]  ret_from_fork+0x22/0x30
[  972.476930]  </TASK>
[  972.476933] INFO: task xfsaild/bcache0:2955 blocked for more than
123 seconds.
[  972.825513]       Not tainted 5.15.0-40-generic #43-Ubuntu
[  973.092507] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  973.473651] task:xfsaild/bcache0 state:D stack:    0 pid: 2955
ppid:     2 flags:0x00004000
[  973.473653] Call Trace:
[  973.473654]  <TASK>
[  973.473667]  __schedule+0x23d/0x590
[  973.473669]  ? cpumask_next_and+0x24/0x30
[  973.473674]  schedule+0x4e/0xb0
[  973.473687]  rwsem_down_read_slowpath+0x32e/0x380
[  973.473690]  down_read+0x43/0x90
[  973.473693]  cached_dev_write+0x7e/0x480 [bcache]
[  973.473707]  ? recalibrate_cpu_khz+0x10/0x10
[  973.473712]  cached_dev_submit_bio+0x4ef/0x540 [bcache]
[  973.473725]  __submit_bio+0x1a1/0x220
[  973.473740]  ? kmem_cache_alloc+0x1ab/0x2e0
[  973.473744]  ? mempool_alloc_slab+0x17/0x20
[  973.473747]  __submit_bio_noacct+0x85/0x1f0
[  973.473750]  submit_bio_noacct+0x4e/0x120
[  973.473753]  ? bio_add_page+0x68/0x90
[  973.473757]  submit_bio+0x4a/0x130
[  973.473761]  xfs_buf_ioapply_map+0x205/0x290 [xfs]
[  973.473860]  _xfs_buf_ioapply+0xe2/0x1b0 [xfs]
[  973.473936]  ? wake_up_q+0x90/0x90
[  973.473940]  __xfs_buf_submit+0x6d/0x1d0 [xfs]
[  973.474016]  xfs_buf_delwri_submit_buffers+0xd9/0x200 [xfs]
[  973.474093]  xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
[  973.474179]  xfsaild_push+0x185/0x890 [xfs]
[  973.474260]  ? del_timer_sync+0x6c/0xb0
[  973.474262]  xfsaild+0xf2/0x210 [xfs]
[  973.474343]  ? xfsaild_push+0x890/0x890 [xfs]
[  973.474437]  kthread+0x12a/0x150
[  973.474440]  ? set_kthread_struct+0x50/0x50
[  973.474443]  ret_from_fork+0x22/0x30
[  973.474447]  </TASK>
[  973.474483] INFO: task fio:2965 blocked for more than 124 seconds.
[  973.771249]       Not tainted 5.15.0-40-generic #43-Ubuntu
[  974.038183] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  974.419303] task:fio             state:D stack:    0 pid: 2965
ppid:  2613 flags:0x00004002
[  974.419307] Call Trace:
[  974.419308]  <TASK>
[  974.419310]  __schedule+0x23d/0x590
[  974.419325]  schedule+0x4e/0xb0
[  974.419327]  io_schedule+0x46/0x70
[  974.419329]  wait_on_page_bit_common+0x10c/0x3d0
[  974.419332]  ? filemap_invalidate_unlock_two+0x40/0x40
[  974.419335]  wait_on_page_bit+0x3f/0x50
[  974.419337]  wait_on_page_writeback+0x26/0x80
[  974.419341]  __filemap_fdatawait_range+0x97/0x110
[  974.419344]  file_write_and_wait_range+0xcc/0xf0
[  974.419347]  xfs_file_fsync+0x5b/0x250 [xfs]
[  974.419439]  vfs_fsync_range+0x49/0x80
[  974.419443]  ? __fget_light+0x32/0x80
[  974.419448]  __x64_sys_fsync+0x38/0x60
[  974.419451]  do_syscall_64+0x5c/0xc0
[  974.419454]  ? fput+0x13/0x20
[  974.419457]  ? ksys_write+0xce/0xe0
[  974.419459]  ? exit_to_user_mode_prepare+0x37/0xb0
[  974.419463]  ? syscall_exit_to_user_mode+0x27/0x50
[  974.419466]  ? __x64_sys_write+0x19/0x20
[  974.419468]  ? do_syscall_64+0x69/0xc0
[  974.419470]  ? do_syscall_64+0x69/0xc0
[  974.419471]  ? do_syscall_64+0x69/0xc0
[  974.419473]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
[  974.419477]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  974.419480] RIP: 0033:0x7f91f1c76a5b
[  974.419483] RSP: 002b:00007fff7fc22340 EFLAGS: 00000293 ORIG_RAX:
000000000000004a
[  974.419485] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f91f1c=
76a5b
[  974.419487] RDX: 0000000000000000 RSI: 0000564d2447bf40 RDI: 00000000000=
00006
[  974.419488] RBP: 0000000000001000 R08: 0000000000000000 R09: 0000564d244=
7bf40
[  974.419489] R10: 00000000a318c620 R11: 0000000000000293 R12: 00007f91e78=
1f000
[  974.419491] R13: 0000000000000000 R14: 00007f91eefca2f0 R15: 00000005000=
00000
[  974.419493]  </TASK>
[  974.419534] INFO: task kworker/16:0:3008 blocked for more than 125 secon=
ds.
[  974.758685]       Not tainted 5.15.0-40-generic #43-Ubuntu
[  975.025650] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  975.407087] task:kworker/16:0    state:D stack:    0 pid: 3008
ppid:     2 flags:0x00004000
[  975.407103] Workqueue: bcache bch_data_insert_start [bcache]
[  975.407133] Call Trace:
[  975.407135]  <TASK>
[  975.407136]  __schedule+0x23d/0x590
[  975.407140]  schedule+0x4e/0xb0
[  975.407143]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
[  975.407153]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
[  975.407166]  ? wait_woken+0x70/0x70
[  975.407169]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
[  975.407180]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
[  975.407191]  ? __wake_up_common_lock+0x8a/0xc0
[  975.407193]  bch_data_insert_start+0x15e/0x3a0 [bcache]
[  975.407207]  ? closure_sub+0x94/0xb0 [bcache]
[  975.407220]  process_one_work+0x22b/0x3d0
[  975.407224]  worker_thread+0x53/0x410
[  975.407228]  ? process_one_work+0x3d0/0x3d0
[  975.407231]  kthread+0x12a/0x150
[  975.407234]  ? set_kthread_struct+0x50/0x50
[  975.407237]  ret_from_fork+0x22/0x30
[  975.407242]  </TASK>


On Tue, 28 Jun 2022 at 12:01, Nikhil Kshirsagar <nkshirsagar@gmail.com> wro=
te:
>
> Hi Coly,
>
> I just kicked off a 20gb random readwrite test using fio to a bcache devi=
ce,
>
> fio --filename=3D/home/ubuntu/bcache_mount/cacahedfile --size=3D20GB
> --direct=3D1 --rw=3Drandrw --bs=3D4k --ioengine=3Dlibaio --iodepth=3D128
> --name=3Diops-test-job --eta-newline=3D1
>
> # lsblk /dev/sdc /dev/nvme0n1
> NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
> sdc           8:32   0 279.4G  0 disk
> =E2=94=94=E2=94=80sdc1        8:33   0    60G  0 part
>   =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bcache=
_mount
> nvme0n1     259:0    0 372.6G  0 disk
> =E2=94=94=E2=94=80nvme0n1p1 259:2    0    15G  0 part
>   =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bcache=
_mount
>
> and am seeing this trace in the dmesg,
>
> [ 2475.034909] XFS (bcache0): Ending clean mount
> [ 2475.036238] xfs filesystem being mounted at
> /home/ubuntu/bcache_mount supports timestamps until 2038 (0x7fffffff)
>
> [ 2782.176705] INFO: task kworker/2:1:255 blocked for more than 120 secon=
ds.
> [ 2782.507171]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2782.774078] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2783.155206] task:kworker/2:1     state:D stack:    0 pid:  255
> ppid:     2 flags:0x00004000
> [ 2783.155210] Workqueue: bcache bch_data_insert_start [bcache]
> [ 2783.155259] Call Trace:
> [ 2783.155261]  <TASK>
> [ 2783.155263]  __schedule+0x23d/0x590
> [ 2783.155269]  schedule+0x4e/0xb0
> [ 2783.155271]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> [ 2783.155281]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> [ 2783.155294]  ? wait_woken+0x70/0x70
> [ 2783.155298]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> [ 2783.155309]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> [ 2783.155319]  ? bch_btree_insert+0xea/0x130 [bcache]
> [ 2783.155331]  ? __queue_work+0x211/0x480
> [ 2783.155336]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> [ 2783.155349]  ? closure_sub+0x94/0xb0 [bcache]
> [ 2783.155362]  process_one_work+0x22b/0x3d0
> [ 2783.155366]  worker_thread+0x53/0x410
> [ 2783.155369]  ? process_one_work+0x3d0/0x3d0
> [ 2783.155372]  kthread+0x12a/0x150
> [ 2783.155376]  ? set_kthread_struct+0x50/0x50
> [ 2783.155379]  ret_from_fork+0x22/0x30
> [ 2783.155385]  </TASK>
> [ 2783.155423] INFO: task kworker/3:1:267 blocked for more than 121 secon=
ds.
> [ 2783.485797]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2783.752485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2784.133541] task:kworker/3:1     state:D stack:    0 pid:  267
> ppid:     2 flags:0x00004000
> [ 2784.133544] Workqueue: events update_writeback_rate [bcache]
> [ 2784.133588] Call Trace:
> [ 2784.133589]  <TASK>
> [ 2784.133591]  __schedule+0x23d/0x590
> [ 2784.133594]  schedule+0x4e/0xb0
> [ 2784.133596]  rwsem_down_read_slowpath+0x32e/0x380
> [ 2784.133600]  down_read+0x43/0x90
> [ 2784.133602]  update_writeback_rate+0x134/0x190 [bcache]
> [ 2784.133619]  process_one_work+0x22b/0x3d0
> [ 2784.133623]  worker_thread+0x53/0x410
> [ 2784.133626]  ? process_one_work+0x3d0/0x3d0
> [ 2784.133630]  kthread+0x12a/0x150
> [ 2784.133633]  ? set_kthread_struct+0x50/0x50
> [ 2784.133636]  ret_from_fork+0x22/0x30
> [ 2784.133640]  </TASK>
> [ 2784.133650] INFO: task kworker/25:2:326 blocked for more than 122 seco=
nds.
> [ 2784.467880]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2784.734405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2785.114677] task:kworker/25:2    state:D stack:    0 pid:  326
> ppid:     2 flags:0x00004000
> [ 2785.114692] Workqueue: bcache bch_data_insert_start [bcache]
> [ 2785.114720] Call Trace:
> [ 2785.114721]  <TASK>
> [ 2785.114723]  __schedule+0x23d/0x590
> [ 2785.114726]  schedule+0x4e/0xb0
> [ 2785.114729]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> [ 2785.114740]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> [ 2785.114753]  ? wait_woken+0x70/0x70
> [ 2785.114756]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> [ 2785.114766]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> [ 2785.114777]  ? bch_btree_insert+0xea/0x130 [bcache]
> [ 2785.114789]  ? __queue_work+0x211/0x480
> [ 2785.114793]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> [ 2785.114806]  ? closure_sub+0x94/0xb0 [bcache]
> [ 2785.114818]  process_one_work+0x22b/0x3d0
> [ 2785.114822]  worker_thread+0x53/0x410
> [ 2785.114826]  ? process_one_work+0x3d0/0x3d0
> [ 2785.114829]  kthread+0x12a/0x150
> [ 2785.114832]  ? set_kthread_struct+0x50/0x50
> [ 2785.114835]  ret_from_fork+0x22/0x30
> [ 2785.114839]  </TASK>
> [ 2785.114864] INFO: task kworker/6:0:3038 blocked for more than 123 seco=
nds.
> [ 2785.444697]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2785.711071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2786.091440] task:kworker/6:0     state:D stack:    0 pid: 3038
> ppid:     2 flags:0x00004000
> [ 2786.091446] Workqueue: xfs-sync/bcache0 xfs_log_worker [xfs]
> [ 2786.091582] Call Trace:
> [ 2786.091584]  <TASK>
> [ 2786.091585]  __schedule+0x23d/0x590
> [ 2786.091589]  schedule+0x4e/0xb0
> [ 2786.091591]  rwsem_down_read_slowpath+0x32e/0x380
> [ 2786.091594]  down_read+0x43/0x90
> [ 2786.091597]  cached_dev_write+0x7e/0x480 [bcache]
> [ 2786.091613]  cached_dev_submit_bio+0x4ef/0x540 [bcache]
> [ 2786.091626]  __submit_bio+0x1a1/0x220
> [ 2786.091631]  __submit_bio_noacct+0x85/0x1f0
> [ 2786.091634]  ? mutex_lock+0x13/0x40
> [ 2786.091637]  submit_bio_noacct+0x4e/0x120
> [ 2786.091640]  submit_bio+0x4a/0x130
> [ 2786.091642]  xlog_write_iclog+0x254/0x300 [xfs]
> [ 2786.091725]  xlog_sync+0x1ab/0x2c0 [xfs]
> [ 2786.091807]  xlog_state_release_iclog+0x123/0x1d0 [xfs]
> [ 2786.091925]  xfs_log_force+0x186/0x250 [xfs]
> [ 2786.091994]  xfs_log_worker+0x39/0x90 [xfs]
> [ 2786.092063]  process_one_work+0x22b/0x3d0
> [ 2786.092067]  worker_thread+0x53/0x410
> [ 2786.092069]  ? process_one_work+0x3d0/0x3d0
> [ 2786.092072]  kthread+0x12a/0x150
> [ 2786.092074]  ? set_kthread_struct+0x50/0x50
> [ 2786.092077]  ret_from_fork+0x22/0x30
> [ 2786.092081]  </TASK>
> [ 2786.092088] INFO: task kworker/25:0:3047 blocked for more than 124 sec=
onds.
> [ 2786.430313]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2786.696626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2787.077056] task:kworker/25:0    state:D stack:    0 pid: 3047
> ppid:     2 flags:0x00004000
> [ 2787.077071] Workqueue: bcache bch_data_insert_start [bcache]
> [ 2787.077098] Call Trace:
> [ 2787.077099]  <TASK>
> [ 2787.077101]  __schedule+0x23d/0x590
> [ 2787.077104]  schedule+0x4e/0xb0
> [ 2787.077106]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> [ 2787.077116]  ? wait_woken+0x70/0x70
> [ 2787.077119]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> [ 2787.077142]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> [ 2787.077153]  ? __bch_submit_bbio+0x97/0xb0 [bcache]
> [ 2787.077166]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> [ 2787.077179]  ? closure_sub+0x94/0xb0 [bcache]
> [ 2787.077191]  process_one_work+0x22b/0x3d0
> [ 2787.077195]  worker_thread+0x53/0x410
> [ 2787.077198]  ? process_one_work+0x3d0/0x3d0
> [ 2787.077202]  kthread+0x12a/0x150
> [ 2787.077205]  ? set_kthread_struct+0x50/0x50
> [ 2787.077207]  ret_from_fork+0x22/0x30
> [ 2787.077212]  </TASK>
> [ 2787.077247] INFO: task bcache_writebac:3080 blocked for more than
> 125 seconds.
> [ 2787.423890]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2787.690476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2788.071063] task:bcache_writebac state:D stack:    0 pid: 3080
> ppid:     2 flags:0x00004000
> [ 2788.071080] Call Trace:
> [ 2788.071081]  <TASK>
> [ 2788.071082]  __schedule+0x23d/0x590
> [ 2788.071086]  schedule+0x4e/0xb0
> [ 2788.071100]  rwsem_down_write_slowpath+0x220/0x3d0
> [ 2788.071105]  ? del_timer_sync+0x6c/0xb0
> [ 2788.071109]  down_write+0x43/0x50
> [ 2788.071112]  bch_writeback_thread+0x78/0x320 [bcache]
> [ 2788.071142]  ? read_dirty+0x5a0/0x5a0 [bcache]
> [ 2788.071158]  kthread+0x12a/0x150
> [ 2788.071161]  ? set_kthread_struct+0x50/0x50
> [ 2788.071164]  ret_from_fork+0x22/0x30
> [ 2788.071168]  </TASK>
> [ 2788.071199] INFO: task fio:3123 blocked for more than 126 seconds.
> [ 2788.367175]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2788.633386] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2789.014084] task:fio             state:D stack:    0 pid: 3123
> ppid:  2378 flags:0x00004002
> [ 2789.014087] Call Trace:
> [ 2789.014089]  <TASK>
> [ 2789.014090]  __schedule+0x23d/0x590
> [ 2789.014106]  schedule+0x4e/0xb0
> [ 2789.014108]  io_schedule+0x46/0x70
> [ 2789.014110]  wait_on_page_bit_common+0x10c/0x3d0
> [ 2789.014115]  ? filemap_invalidate_unlock_two+0x40/0x40
> [ 2789.014118]  wait_on_page_bit+0x3f/0x50
> [ 2789.014120]  wait_on_page_writeback+0x26/0x80
> [ 2789.014124]  __filemap_fdatawait_range+0x97/0x110
> [ 2789.014126]  file_write_and_wait_range+0xcc/0xf0
> [ 2789.014130]  xfs_file_fsync+0x5b/0x250 [xfs]
> [ 2789.014207]  vfs_fsync_range+0x49/0x80
> [ 2789.014212]  ? __fget_light+0x32/0x80
> [ 2789.014217]  __x64_sys_fsync+0x38/0x60
> [ 2789.014220]  do_syscall_64+0x5c/0xc0
> [ 2789.014223]  ? do_syscall_64+0x69/0xc0
> [ 2789.014225]  ? do_syscall_64+0x69/0xc0
> [ 2789.014226]  ? syscall_exit_to_user_mode+0x27/0x50
> [ 2789.014230]  ? __x64_sys_write+0x19/0x20
> [ 2789.014232]  ? do_syscall_64+0x69/0xc0
> [ 2789.014234]  ? do_syscall_64+0x69/0xc0
> [ 2789.014235]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
> [ 2789.014239]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 2789.014243] RIP: 0033:0x7f2cfdcfea5b
> [ 2789.014245] RSP: 002b:00007ffcd87c6e60 EFLAGS: 00000293 ORIG_RAX:
> 000000000000004a
> [ 2789.014248] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2cf=
dcfea5b
> [ 2789.014249] RDX: 0000000000000000 RSI: 000055c8d26e6f40 RDI: 000000000=
0000006
> [ 2789.014250] RBP: 0000000000001000 R08: 0000000000000000 R09: 000055c8d=
26e6f40
> [ 2789.014252] R10: 00000000a318c620 R11: 0000000000000293 R12: 00007f2cf=
38a7000
> [ 2789.014253] R13: 0000000000000000 R14: 00007f2cfb0522f0 R15: 000000050=
0000000
> [ 2789.014255]  </TASK>
> [ 2909.151501] INFO: task kworker/2:1:255 blocked for more than 247 secon=
ds.
> [ 2909.481856]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2909.748707] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2910.130132] task:kworker/2:1     state:D stack:    0 pid:  255
> ppid:     2 flags:0x00004000
> [ 2910.130147] Workqueue: bcache bch_data_insert_start [bcache]
> [ 2910.130176] Call Trace:
> [ 2910.130177]  <TASK>
> [ 2910.130179]  __schedule+0x23d/0x590
> [ 2910.130182]  schedule+0x4e/0xb0
> [ 2910.130184]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> [ 2910.130194]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> [ 2910.130219]  ? wait_woken+0x70/0x70
> [ 2910.130222]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> [ 2910.130233]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> [ 2910.130243]  ? bch_btree_insert+0xea/0x130 [bcache]
> [ 2910.130255]  ? __queue_work+0x211/0x480
> [ 2910.130259]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> [ 2910.130272]  ? closure_sub+0x94/0xb0 [bcache]
> [ 2910.130285]  process_one_work+0x22b/0x3d0
> [ 2910.130288]  worker_thread+0x53/0x410
> [ 2910.130292]  ? process_one_work+0x3d0/0x3d0
> [ 2910.130295]  kthread+0x12a/0x150
> [ 2910.130298]  ? set_kthread_struct+0x50/0x50
> [ 2910.130301]  ret_from_fork+0x22/0x30
> [ 2910.130305]  </TASK>
> [ 2910.130307] INFO: task kworker/3:1:267 blocked for more than 248 secon=
ds.
> [ 2910.456520]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2910.723476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2911.104601] task:kworker/3:1     state:D stack:    0 pid:  267
> ppid:     2 flags:0x00004000
> [ 2911.104617] Workqueue: events update_writeback_rate [bcache]
> [ 2911.104647] Call Trace:
> [ 2911.104648]  <TASK>
> [ 2911.104649]  __schedule+0x23d/0x590
> [ 2911.104652]  schedule+0x4e/0xb0
> [ 2911.104654]  rwsem_down_read_slowpath+0x32e/0x380
> [ 2911.104657]  down_read+0x43/0x90
> [ 2911.104660]  update_writeback_rate+0x134/0x190 [bcache]
> [ 2911.104676]  process_one_work+0x22b/0x3d0
> [ 2911.104680]  worker_thread+0x53/0x410
> [ 2911.104683]  ? process_one_work+0x3d0/0x3d0
> [ 2911.104687]  kthread+0x12a/0x150
> [ 2911.104690]  ? set_kthread_struct+0x50/0x50
> [ 2911.104693]  ret_from_fork+0x22/0x30
> [ 2911.104697]  </TASK>
> [ 2911.104733] INFO: task kworker/25:2:326 blocked for more than 249 seco=
nds.
> [ 2911.439086]       Not tainted 5.15.0-40-generic #43-Ubuntu
> [ 2911.706294] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2912.087471] task:kworker/25:2    state:D stack:    0 pid:  326
> ppid:     2 flags:0x00004000
> [ 2912.087475] Workqueue: bcache bch_data_insert_start [bcache]
> [ 2912.087495] Call Trace:
> [ 2912.087497]  <TASK>
> [ 2912.087498]  __schedule+0x23d/0x590
> [ 2912.087503]  schedule+0x4e/0xb0
> [ 2912.087505]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> [ 2912.087516]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> [ 2912.087528]  ? wait_woken+0x70/0x70
> [ 2912.087532]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> [ 2912.087543]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> [ 2912.087553]  ? bch_btree_insert+0xea/0x130 [bcache]
> [ 2912.087565]  ? __queue_work+0x211/0x480
> [ 2912.087570]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> [ 2912.087583]  ? closure_sub+0x94/0xb0 [bcache]
> [ 2912.087595]  process_one_work+0x22b/0x3d0
> [ 2912.087599]  worker_thread+0x53/0x410
> [ 2912.087602]  ? process_one_work+0x3d0/0x3d0
> [ 2912.087606]  kthread+0x12a/0x150
> [ 2912.087609]  ? set_kthread_struct+0x50/0x50
> [ 2912.087612]  ret_from_fork+0x22/0x30
> [ 2912.087617]  </TASK>
>
> Is this a bug? It's in writeback mode. I'd setup the cache and run stuff =
like,
>
> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
>
> I had also echoed 0 into congested_read_threshold_us,
> congested_write_threshold_us.
>
> echo writeback > /sys/block/bcache0/bcache/cache_mode
>
> Regards,
> Nikhil.

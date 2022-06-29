Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43F555F9AD
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jun 2022 09:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiF2H4a (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jun 2022 03:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiF2H43 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jun 2022 03:56:29 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7529B19C2E
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 00:56:26 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id r9so12559095ljp.9
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 00:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DCT12xeAhabUZgSrnDPeJ73ROJUwBg05RiEKnTHZvKA=;
        b=Ym5sERQBXuSp/+64gqoaAQQaFNiLxaeQs2WH/BemZMVIyJOyLIf2oyyt9+r8oq7rYX
         1Ff47Rjxjc61B7J1CMO++2QgvVWxyD3NeVh4cgpfpjslD/gzrzFQiRqsmWGQixGVS4d9
         b7kfVeQxOZszB0kemWbL7KqwZsPkuUkW6qhKHPsDiQYE6DtgCjnywDnaHRMCmLlZ2gxl
         uahseDo9ZgjgXCvhYC3qjTnw5Fe46k1AE2pWbyvdan+saOZ9ec9hpWa/BynkavJOJCbZ
         /GSdmrm8Z3RI8p40YyVG3KoRqwD0Cl1PJTh8bUwuaqtw31VBQUE6z9XjtHj5BC3fnimM
         PLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DCT12xeAhabUZgSrnDPeJ73ROJUwBg05RiEKnTHZvKA=;
        b=8MHeAaLb8Tw7G1ba5ZkcerIPwvk6mKd+I5W6xZs3F/V1acdVvYPbxaW0ZUrS8xq6aN
         uhFt0zpdsFQCTC0nqPu6cCEL0+xHJJ9ixJq45zTayuZPVjxFCNZF8/co3ADlDcn4AKtF
         JpkWjrh9HVKq8DN8su4r0PKwxo2oJWc/09LKJbjlplE+gvqmgfbHoEUnNPFskNh78JwZ
         F1ClpeNALlR3WmTxB/pyGjGbmKEX2BX8hnqFePwOf911bBdwvViw3Tj5zL5olUFJxYQ0
         QRgI3nF/8DktRPiZUA7OqUZTO6Go0WV1006gKWR2PJflbufUEs91aCHNs+if3fbqs/CS
         Egew==
X-Gm-Message-State: AJIora8VuCfZO5Jh8xNgrQKZJkhAHkDHkHW17/MLfIUn2NkxuUwM0DLr
        GP6QBmwx2OkFz+CI/XgmJy7usSUjcFRDIz8LfdOOl5u+Ejw=
X-Google-Smtp-Source: AGRyM1vJ1zTZhg4KWCzHab3XKJkz8lPorT2UBbFVqnJd4+5n39rJ/oFNvArydyZJdkXVSIjkbyjG2FOdF+DEvQMVq20=
X-Received: by 2002:a2e:a90d:0:b0:25a:7edb:4034 with SMTP id
 j13-20020a2ea90d000000b0025a7edb4034mr956706ljq.129.1656489384510; Wed, 29
 Jun 2022 00:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de> <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de>
In-Reply-To: <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de>
From:   Nikhil Kshirsagar <nkshirsagar@gmail.com>
Date:   Wed, 29 Jun 2022 13:26:11 +0530
Message-ID: <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
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

60gb slow hdd, 15gb fast nvme cache. shall i file upstream bug for this iss=
ue?

On Wed, 29 Jun 2022 at 13:20, Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 15:02=EF=BC=8CNikhil Kshirsagar <nks=
hirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly,
> >
> > I see the same bug on upstream kernel when I tried with
> > https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/  (
> > cod/mainline/v5.15.50 (767db4b286c3e101ac220b813c873f492d9e4ee8)
>
>
> Can you help to try the linux-stable tree, or the latest upstream Linus t=
ree? Then I can have a clean code base.
>
> >
> > Reads seem to trigger it, not writes. So this test triggered it -
> >
> > fio --name=3Dread_iops --directory=3D/home/ubuntu/bcache_mount --size=
=3D12G
> > --ioengine=3Dlibaio --direct=3D1 --verify=3D0 --bs=3D4K --iodepth=3D128
> > --rw=3Drandread --group_reporting=3D1
> >
> > https://pastebin.com/KyVSfnik has all the details.
>
>
> OK, I will try to reproduce with above operation. What is the preferred c=
ache and backing device sizes to reproduce the soft lockup?
>
> Thanks.
>
> Coly Li
>
>
> >
> > Regards,
> > Nikhil.
> >
> > On Tue, 28 Jun 2022 at 20:08, Coly Li <colyli@suse.de> wrote:
> >>
> >>
> >>
> >>> 2022=E5=B9=B46=E6=9C=8828=E6=97=A5 14:31=EF=BC=8CNikhil Kshirsagar <n=
kshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>
> >>> Hi Coly,
> >>>
> >>> I just kicked off a 20gb random readwrite test using fio to a bcache =
device,
> >>>
> >>> fio --filename=3D/home/ubuntu/bcache_mount/cacahedfile --size=3D20GB
> >>> --direct=3D1 --rw=3Drandrw --bs=3D4k --ioengine=3Dlibaio --iodepth=3D=
128
> >>> --name=3Diops-test-job --eta-newline=3D1
> >>>
> >>> # lsblk /dev/sdc /dev/nvme0n1
> >>> NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
> >>> sdc           8:32   0 279.4G  0 disk
> >>> =E2=94=94=E2=94=80sdc1        8:33   0    60G  0 part
> >>> =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bcac=
he_mount
> >>> nvme0n1     259:0    0 372.6G  0 disk
> >>> =E2=94=94=E2=94=80nvme0n1p1 259:2    0    15G  0 part
> >>> =E2=94=94=E2=94=80bcache0 252:0    0    60G  0 disk /home/ubuntu/bcac=
he_mount
> >>>
> >>> and am seeing this trace in the dmesg,
> >>>
> >>> [ 2475.034909] XFS (bcache0): Ending clean mount
> >>> [ 2475.036238] xfs filesystem being mounted at
> >>> /home/ubuntu/bcache_mount supports timestamps until 2038 (0x7fffffff)
> >>>
> >>> [ 2782.176705] INFO: task kworker/2:1:255 blocked for more than 120 s=
econds.
> >>> [ 2782.507171]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2782.774078] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2783.155206] task:kworker/2:1     state:D stack:    0 pid:  255
> >>> ppid:     2 flags:0x00004000
> >>> [ 2783.155210] Workqueue: bcache bch_data_insert_start [bcache]
> >>> [ 2783.155259] Call Trace:
> >>> [ 2783.155261]  <TASK>
> >>> [ 2783.155263]  __schedule+0x23d/0x590
> >>> [ 2783.155269]  schedule+0x4e/0xb0
> >>> [ 2783.155271]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> >>> [ 2783.155281]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> >>> [ 2783.155294]  ? wait_woken+0x70/0x70
> >>> [ 2783.155298]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> >>> [ 2783.155309]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> >>> [ 2783.155319]  ? bch_btree_insert+0xea/0x130 [bcache]
> >>> [ 2783.155331]  ? __queue_work+0x211/0x480
> >>> [ 2783.155336]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> >>> [ 2783.155349]  ? closure_sub+0x94/0xb0 [bcache]
> >>> [ 2783.155362]  process_one_work+0x22b/0x3d0
> >>> [ 2783.155366]  worker_thread+0x53/0x410
> >>> [ 2783.155369]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2783.155372]  kthread+0x12a/0x150
> >>> [ 2783.155376]  ? set_kthread_struct+0x50/0x50
> >>> [ 2783.155379]  ret_from_fork+0x22/0x30
> >>> [ 2783.155385]  </TASK>
> >>> [ 2783.155423] INFO: task kworker/3:1:267 blocked for more than 121 s=
econds.
> >>> [ 2783.485797]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2783.752485] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2784.133541] task:kworker/3:1     state:D stack:    0 pid:  267
> >>> ppid:     2 flags:0x00004000
> >>> [ 2784.133544] Workqueue: events update_writeback_rate [bcache]
> >>> [ 2784.133588] Call Trace:
> >>> [ 2784.133589]  <TASK>
> >>> [ 2784.133591]  __schedule+0x23d/0x590
> >>> [ 2784.133594]  schedule+0x4e/0xb0
> >>> [ 2784.133596]  rwsem_down_read_slowpath+0x32e/0x380
> >>> [ 2784.133600]  down_read+0x43/0x90
> >>> [ 2784.133602]  update_writeback_rate+0x134/0x190 [bcache]
> >>> [ 2784.133619]  process_one_work+0x22b/0x3d0
> >>> [ 2784.133623]  worker_thread+0x53/0x410
> >>> [ 2784.133626]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2784.133630]  kthread+0x12a/0x150
> >>> [ 2784.133633]  ? set_kthread_struct+0x50/0x50
> >>> [ 2784.133636]  ret_from_fork+0x22/0x30
> >>> [ 2784.133640]  </TASK>
> >>> [ 2784.133650] INFO: task kworker/25:2:326 blocked for more than 122 =
seconds.
> >>> [ 2784.467880]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2784.734405] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2785.114677] task:kworker/25:2    state:D stack:    0 pid:  326
> >>> ppid:     2 flags:0x00004000
> >>> [ 2785.114692] Workqueue: bcache bch_data_insert_start [bcache]
> >>> [ 2785.114720] Call Trace:
> >>> [ 2785.114721]  <TASK>
> >>> [ 2785.114723]  __schedule+0x23d/0x590
> >>> [ 2785.114726]  schedule+0x4e/0xb0
> >>> [ 2785.114729]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> >>> [ 2785.114740]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> >>> [ 2785.114753]  ? wait_woken+0x70/0x70
> >>> [ 2785.114756]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> >>> [ 2785.114766]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> >>> [ 2785.114777]  ? bch_btree_insert+0xea/0x130 [bcache]
> >>> [ 2785.114789]  ? __queue_work+0x211/0x480
> >>> [ 2785.114793]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> >>> [ 2785.114806]  ? closure_sub+0x94/0xb0 [bcache]
> >>> [ 2785.114818]  process_one_work+0x22b/0x3d0
> >>> [ 2785.114822]  worker_thread+0x53/0x410
> >>> [ 2785.114826]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2785.114829]  kthread+0x12a/0x150
> >>> [ 2785.114832]  ? set_kthread_struct+0x50/0x50
> >>> [ 2785.114835]  ret_from_fork+0x22/0x30
> >>> [ 2785.114839]  </TASK>
> >>> [ 2785.114864] INFO: task kworker/6:0:3038 blocked for more than 123 =
seconds.
> >>> [ 2785.444697]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2785.711071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2786.091440] task:kworker/6:0     state:D stack:    0 pid: 3038
> >>> ppid:     2 flags:0x00004000
> >>> [ 2786.091446] Workqueue: xfs-sync/bcache0 xfs_log_worker [xfs]
> >>> [ 2786.091582] Call Trace:
> >>> [ 2786.091584]  <TASK>
> >>> [ 2786.091585]  __schedule+0x23d/0x590
> >>> [ 2786.091589]  schedule+0x4e/0xb0
> >>> [ 2786.091591]  rwsem_down_read_slowpath+0x32e/0x380
> >>> [ 2786.091594]  down_read+0x43/0x90
> >>> [ 2786.091597]  cached_dev_write+0x7e/0x480 [bcache]
> >>> [ 2786.091613]  cached_dev_submit_bio+0x4ef/0x540 [bcache]
> >>> [ 2786.091626]  __submit_bio+0x1a1/0x220
> >>> [ 2786.091631]  __submit_bio_noacct+0x85/0x1f0
> >>> [ 2786.091634]  ? mutex_lock+0x13/0x40
> >>> [ 2786.091637]  submit_bio_noacct+0x4e/0x120
> >>> [ 2786.091640]  submit_bio+0x4a/0x130
> >>> [ 2786.091642]  xlog_write_iclog+0x254/0x300 [xfs]
> >>> [ 2786.091725]  xlog_sync+0x1ab/0x2c0 [xfs]
> >>> [ 2786.091807]  xlog_state_release_iclog+0x123/0x1d0 [xfs]
> >>> [ 2786.091925]  xfs_log_force+0x186/0x250 [xfs]
> >>> [ 2786.091994]  xfs_log_worker+0x39/0x90 [xfs]
> >>> [ 2786.092063]  process_one_work+0x22b/0x3d0
> >>> [ 2786.092067]  worker_thread+0x53/0x410
> >>> [ 2786.092069]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2786.092072]  kthread+0x12a/0x150
> >>> [ 2786.092074]  ? set_kthread_struct+0x50/0x50
> >>> [ 2786.092077]  ret_from_fork+0x22/0x30
> >>> [ 2786.092081]  </TASK>
> >>> [ 2786.092088] INFO: task kworker/25:0:3047 blocked for more than 124=
 seconds.
> >>> [ 2786.430313]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2786.696626] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2787.077056] task:kworker/25:0    state:D stack:    0 pid: 3047
> >>> ppid:     2 flags:0x00004000
> >>> [ 2787.077071] Workqueue: bcache bch_data_insert_start [bcache]
> >>> [ 2787.077098] Call Trace:
> >>> [ 2787.077099]  <TASK>
> >>> [ 2787.077101]  __schedule+0x23d/0x590
> >>> [ 2787.077104]  schedule+0x4e/0xb0
> >>> [ 2787.077106]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> >>> [ 2787.077116]  ? wait_woken+0x70/0x70
> >>> [ 2787.077119]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> >>> [ 2787.077142]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> >>> [ 2787.077153]  ? __bch_submit_bbio+0x97/0xb0 [bcache]
> >>> [ 2787.077166]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> >>> [ 2787.077179]  ? closure_sub+0x94/0xb0 [bcache]
> >>> [ 2787.077191]  process_one_work+0x22b/0x3d0
> >>> [ 2787.077195]  worker_thread+0x53/0x410
> >>> [ 2787.077198]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2787.077202]  kthread+0x12a/0x150
> >>> [ 2787.077205]  ? set_kthread_struct+0x50/0x50
> >>> [ 2787.077207]  ret_from_fork+0x22/0x30
> >>> [ 2787.077212]  </TASK>
> >>> [ 2787.077247] INFO: task bcache_writebac:3080 blocked for more than
> >>> 125 seconds.
> >>> [ 2787.423890]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2787.690476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2788.071063] task:bcache_writebac state:D stack:    0 pid: 3080
> >>> ppid:     2 flags:0x00004000
> >>> [ 2788.071080] Call Trace:
> >>> [ 2788.071081]  <TASK>
> >>> [ 2788.071082]  __schedule+0x23d/0x590
> >>> [ 2788.071086]  schedule+0x4e/0xb0
> >>> [ 2788.071100]  rwsem_down_write_slowpath+0x220/0x3d0
> >>> [ 2788.071105]  ? del_timer_sync+0x6c/0xb0
> >>> [ 2788.071109]  down_write+0x43/0x50
> >>> [ 2788.071112]  bch_writeback_thread+0x78/0x320 [bcache]
> >>> [ 2788.071142]  ? read_dirty+0x5a0/0x5a0 [bcache]
> >>> [ 2788.071158]  kthread+0x12a/0x150
> >>> [ 2788.071161]  ? set_kthread_struct+0x50/0x50
> >>> [ 2788.071164]  ret_from_fork+0x22/0x30
> >>> [ 2788.071168]  </TASK>
> >>> [ 2788.071199] INFO: task fio:3123 blocked for more than 126 seconds.
> >>> [ 2788.367175]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2788.633386] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2789.014084] task:fio             state:D stack:    0 pid: 3123
> >>> ppid:  2378 flags:0x00004002
> >>> [ 2789.014087] Call Trace:
> >>> [ 2789.014089]  <TASK>
> >>> [ 2789.014090]  __schedule+0x23d/0x590
> >>> [ 2789.014106]  schedule+0x4e/0xb0
> >>> [ 2789.014108]  io_schedule+0x46/0x70
> >>> [ 2789.014110]  wait_on_page_bit_common+0x10c/0x3d0
> >>> [ 2789.014115]  ? filemap_invalidate_unlock_two+0x40/0x40
> >>> [ 2789.014118]  wait_on_page_bit+0x3f/0x50
> >>> [ 2789.014120]  wait_on_page_writeback+0x26/0x80
> >>> [ 2789.014124]  __filemap_fdatawait_range+0x97/0x110
> >>> [ 2789.014126]  file_write_and_wait_range+0xcc/0xf0
> >>> [ 2789.014130]  xfs_file_fsync+0x5b/0x250 [xfs]
> >>> [ 2789.014207]  vfs_fsync_range+0x49/0x80
> >>> [ 2789.014212]  ? __fget_light+0x32/0x80
> >>> [ 2789.014217]  __x64_sys_fsync+0x38/0x60
> >>> [ 2789.014220]  do_syscall_64+0x5c/0xc0
> >>> [ 2789.014223]  ? do_syscall_64+0x69/0xc0
> >>> [ 2789.014225]  ? do_syscall_64+0x69/0xc0
> >>> [ 2789.014226]  ? syscall_exit_to_user_mode+0x27/0x50
> >>> [ 2789.014230]  ? __x64_sys_write+0x19/0x20
> >>> [ 2789.014232]  ? do_syscall_64+0x69/0xc0
> >>> [ 2789.014234]  ? do_syscall_64+0x69/0xc0
> >>> [ 2789.014235]  ? asm_sysvec_apic_timer_interrupt+0xa/0x20
> >>> [ 2789.014239]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>> [ 2789.014243] RIP: 0033:0x7f2cfdcfea5b
> >>> [ 2789.014245] RSP: 002b:00007ffcd87c6e60 EFLAGS: 00000293 ORIG_RAX:
> >>> 000000000000004a
> >>> [ 2789.014248] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007=
f2cfdcfea5b
> >>> [ 2789.014249] RDX: 0000000000000000 RSI: 000055c8d26e6f40 RDI: 00000=
00000000006
> >>> [ 2789.014250] RBP: 0000000000001000 R08: 0000000000000000 R09: 00005=
5c8d26e6f40
> >>> [ 2789.014252] R10: 00000000a318c620 R11: 0000000000000293 R12: 00007=
f2cf38a7000
> >>> [ 2789.014253] R13: 0000000000000000 R14: 00007f2cfb0522f0 R15: 00000=
00500000000
> >>> [ 2789.014255]  </TASK>
> >>> [ 2909.151501] INFO: task kworker/2:1:255 blocked for more than 247 s=
econds.
> >>> [ 2909.481856]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2909.748707] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2910.130132] task:kworker/2:1     state:D stack:    0 pid:  255
> >>> ppid:     2 flags:0x00004000
> >>> [ 2910.130147] Workqueue: bcache bch_data_insert_start [bcache]
> >>> [ 2910.130176] Call Trace:
> >>> [ 2910.130177]  <TASK>
> >>> [ 2910.130179]  __schedule+0x23d/0x590
> >>> [ 2910.130182]  schedule+0x4e/0xb0
> >>> [ 2910.130184]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> >>> [ 2910.130194]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> >>> [ 2910.130219]  ? wait_woken+0x70/0x70
> >>> [ 2910.130222]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> >>> [ 2910.130233]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> >>> [ 2910.130243]  ? bch_btree_insert+0xea/0x130 [bcache]
> >>> [ 2910.130255]  ? __queue_work+0x211/0x480
> >>> [ 2910.130259]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> >>> [ 2910.130272]  ? closure_sub+0x94/0xb0 [bcache]
> >>> [ 2910.130285]  process_one_work+0x22b/0x3d0
> >>> [ 2910.130288]  worker_thread+0x53/0x410
> >>> [ 2910.130292]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2910.130295]  kthread+0x12a/0x150
> >>> [ 2910.130298]  ? set_kthread_struct+0x50/0x50
> >>> [ 2910.130301]  ret_from_fork+0x22/0x30
> >>> [ 2910.130305]  </TASK>
> >>> [ 2910.130307] INFO: task kworker/3:1:267 blocked for more than 248 s=
econds.
> >>> [ 2910.456520]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2910.723476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2911.104601] task:kworker/3:1     state:D stack:    0 pid:  267
> >>> ppid:     2 flags:0x00004000
> >>> [ 2911.104617] Workqueue: events update_writeback_rate [bcache]
> >>> [ 2911.104647] Call Trace:
> >>> [ 2911.104648]  <TASK>
> >>> [ 2911.104649]  __schedule+0x23d/0x590
> >>> [ 2911.104652]  schedule+0x4e/0xb0
> >>> [ 2911.104654]  rwsem_down_read_slowpath+0x32e/0x380
> >>> [ 2911.104657]  down_read+0x43/0x90
> >>> [ 2911.104660]  update_writeback_rate+0x134/0x190 [bcache]
> >>> [ 2911.104676]  process_one_work+0x22b/0x3d0
> >>> [ 2911.104680]  worker_thread+0x53/0x410
> >>> [ 2911.104683]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2911.104687]  kthread+0x12a/0x150
> >>> [ 2911.104690]  ? set_kthread_struct+0x50/0x50
> >>> [ 2911.104693]  ret_from_fork+0x22/0x30
> >>> [ 2911.104697]  </TASK>
> >>> [ 2911.104733] INFO: task kworker/25:2:326 blocked for more than 249 =
seconds.
> >>> [ 2911.439086]       Not tainted 5.15.0-40-generic #43-Ubuntu
> >>> [ 2911.706294] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >>> disables this message.
> >>> [ 2912.087471] task:kworker/25:2    state:D stack:    0 pid:  326
> >>> ppid:     2 flags:0x00004000
> >>> [ 2912.087475] Workqueue: bcache bch_data_insert_start [bcache]
> >>> [ 2912.087495] Call Trace:
> >>> [ 2912.087497]  <TASK>
> >>> [ 2912.087498]  __schedule+0x23d/0x590
> >>> [ 2912.087503]  schedule+0x4e/0xb0
> >>> [ 2912.087505]  bch_bucket_alloc+0x21a/0x5b0 [bcache]
> >>> [ 2912.087516]  ? bch_btree_insert_check_key+0x1e0/0x1e0 [bcache]
> >>> [ 2912.087528]  ? wait_woken+0x70/0x70
> >>> [ 2912.087532]  __bch_bucket_alloc_set+0x52/0xf0 [bcache]
> >>> [ 2912.087543]  bch_alloc_sectors+0x1c9/0x4c0 [bcache]
> >>> [ 2912.087553]  ? bch_btree_insert+0xea/0x130 [bcache]
> >>> [ 2912.087565]  ? __queue_work+0x211/0x480
> >>> [ 2912.087570]  bch_data_insert_start+0x15e/0x3a0 [bcache]
> >>> [ 2912.087583]  ? closure_sub+0x94/0xb0 [bcache]
> >>> [ 2912.087595]  process_one_work+0x22b/0x3d0
> >>> [ 2912.087599]  worker_thread+0x53/0x410
> >>> [ 2912.087602]  ? process_one_work+0x3d0/0x3d0
> >>> [ 2912.087606]  kthread+0x12a/0x150
> >>> [ 2912.087609]  ? set_kthread_struct+0x50/0x50
> >>> [ 2912.087612]  ret_from_fork+0x22/0x30
> >>> [ 2912.087617]  </TASK>
> >>>
> >>> Is this a bug? It's in writeback mode. I'd setup the cache and run st=
uff like,
> >>>
> >>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> >>>
> >>> I had also echoed 0 into congested_read_threshold_us,
> >>> congested_write_threshold_us.
> >>>
> >>> echo writeback > /sys/block/bcache0/bcache/cache_mode
> >>
> >> Where do you get the kernel? If this is stable kernel, could you give =
me the HEAD commit id?
> >>
> >> Coly Li
> >>
>

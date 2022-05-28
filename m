Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9BC536E07
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 20:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbiE1SLz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 14:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbiE1SLy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 14:11:54 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A0DD55
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 11:11:52 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id q4so6853728plr.11
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 11:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=64Bl/tEMmEX2jLl8AFk47v6lKW7iXxvjpMZs254nsVo=;
        b=MHfHYj0ZLGBfsfeEwkipMUGer0rUBZCzpfq8CG63DzhBuTdXeGXgDllY75fX/jZdsN
         VONfdrIj99vCZBG9Y281xEoHDN7rFCjaA27c/iZvTwIk4+5VgygodYW4zCviQsHPfbc8
         sa9qtGmTopk2KglNHa0AdueVk2uiPIpJcrBdFUIni+rVJl4lTaZUtrUPUXn0zLX3WHt+
         ttYnj54D9xypXL6X8lhdt3ZBGargrGoxjyEAS5ZLErl7mB3wPSCuocxZzwkyAYTIgQXQ
         z9N41r3Z1E/he2F98yu8vaVACmVoZfMULlto/Fp53J6wkutOULJbwr6+5cOL0rMraj19
         dqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=64Bl/tEMmEX2jLl8AFk47v6lKW7iXxvjpMZs254nsVo=;
        b=A3Rv994pkziQxtGkYEWq0u1Gl2Ihk/lSEHL2Uvj4+wFO043uiOLufcrutB9OnytnN9
         u+N12j8OWoxvaqrwTtwDuhNtSDsAkoFt1WhFCkVIu7aMdq11jNTMvsskNXfr1hy7gbeD
         AGcMsSSfZYEXvp8xMRtU5MfD/nfEm7RcZ2v/qmVYn1Vcf4at9M/9tdz+6hTvQhoWv0H9
         My4vgvrhc7Zhf2eECnJ+CUlH/D4nEYJHTgRwQNpYpcwALCr4tOKwe7m7dXrtkaUQZ9QB
         JwvXjC13i1iApqcZvfnHxxjvNCpkC+bJtOloJ7XXLqh+LeGMbJoJ6iUxnGH3CvjosEcI
         bNSw==
X-Gm-Message-State: AOAM530dhRxI3W7aJnXX8qBsAZFAv4KnA7b3QRpZtPLA/+NuW1jSSWz3
        D7UEAMzLTDGKkd7QQNNnRquIIuD7EDoFEkhpaielQeXxD66ijGAC
X-Google-Smtp-Source: ABdhPJyIKx1KHpPTNiSJ3J7yqJJG+F39YIuZdHpXNDF+zLsqXLnSyv1FKa29MDqYKjk2QGuH5Vkn4Cz2O1hafN/hfZY=
X-Received: by 2002:a17:902:ce87:b0:163:6c9:b070 with SMTP id
 f7-20020a170902ce8700b0016306c9b070mr21893079plg.51.1653761511588; Sat, 28
 May 2022 11:11:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220327072038.12385-1-lilei@szsandstone.com> <40862b68-e81d-089b-d713-b0e6e2bd7e04@suse.de>
 <CAMhKsXnLdAjSN00WpCrq4P-3Z6PEf+vp_QfiHcwCLuVH9s5z_Q@mail.gmail.com> <428a70b3-f671-e6fb-93d1-0a975da35ad8@suse.de>
In-Reply-To: <428a70b3-f671-e6fb-93d1-0a975da35ad8@suse.de>
From:   Lei Li <noctis.akm@gmail.com>
Date:   Sun, 29 May 2022 02:11:42 +0800
Message-ID: <CAMhKsX=boc+pgUbm6HTA0rs1YpLO4Twif+SC=3w++tAys2im+g@mail.gmail.com>
Subject: Re: [PATCH] bcache: remove unnecessary flush_workqueue
To:     Coly Li <colyli@suse.de>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        Li Lei <lilei@szsandstone.com>
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

Sorry for replying so late, because of my testing environment. After
several fio random writing and reboot tests,
this patch worked well. Here is the test result.

1. I successfully reproduced deadlock warning by reverting commit
7e865eba00a3 ("bcache: fix potential
deadlock in cached_def_free()").
[  105.448074] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  105.449634] WARNING: possible circular locking dependency detected
[  105.451185] 5.4.191-MANJARO #1 Not tainted
[  105.452221] ------------------------------------------------------
[  105.453742] kworker/9:15/1272 is trying to acquire lock:
[  105.455042] ffff9e9ef1c44348
((wq_completion)bcache_writeback_wq){+.+.}, at:
flush_workqueue+0x8a/0x550
[  105.457482]
[  105.457482] but task is already holding lock:
[  105.458926] ffffbaba01203e68
((work_completion)(&cl->work)#2){+.+.}, at:
process_one_work+0x1c3/0x5a0
[  105.461568]
[  105.461568] which lock already depends on the new lock.
[  105.461568]
[  105.463810]
[  105.463810] the existing dependency chain (in reverse order) is:
[  105.465570]
[  105.465570] -> #1 ((work_completion)(&cl->work)#2){+.+.}:
[  105.467230]        process_one_work+0x21a/0x5a0
[  105.468449]        worker_thread+0x52/0x3c0
[  105.469653]        kthread+0x132/0x150
[  105.470695]        ret_from_fork+0x3a/0x50
[  105.471649]
[  105.471649] -> #0 ((wq_completion)bcache_writeback_wq){+.+.}:
[  105.473453]        __lock_acquire+0x105b/0x1c50
[  105.474678]        lock_acquire+0xc4/0x1b0
[  105.476007]        flush_workqueue+0xad/0x550
[  105.477160]        drain_workqueue+0xb6/0x170
[  105.478237]        destroy_workqueue+0x36/0x290
[  105.479328]        cached_dev_free+0x45/0x1e0 [bcache]
[  105.480595]        process_one_work+0x243/0x5a0
[  105.481714]        worker_thread+0x52/0x3c0
[  105.482687]        kthread+0x132/0x150
[  105.483667]        ret_from_fork+0x3a/0x50
[  105.484707]
[  105.484707] other info that might help us debug this:
[  105.484707]
[  105.486856]  Possible unsafe locking scenario:
[  105.486856]
[  105.488314]        CPU0                    CPU1
[  105.489336]        ----                    ----
[  105.490438]   lock((work_completion)(&cl->work)#2);
[  105.491587]
lock((wq_completion)bcache_writeback_wq);
[  105.493554]
lock((work_completion)(&cl->work)#2);
[  105.495360]   lock((wq_completion)bcache_writeback_wq);
[  105.496878]
[  105.496878]  *** DEADLOCK ***
[  105.496878]
[  105.498303] 2 locks held by kworker/9:15/1272:
[  105.499373]  #0: ffff9e9f16c21148 ((wq_completion)events){+.+.},
at: process_one_work+0x1c3/0x5a0
[  105.501514]  #1: ffffbaba01203e68
((work_completion)(&cl->work)#2){+.+.}, at:
process_one_work+0x1c3/0x5a0
[  105.504221]
[  105.504221] stack backtrace:
[  105.505271] CPU: 9 PID: 1272 Comm: kworker/9:15 Not tainted
5.4.191-MANJARO #1
[  105.507069] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
[  105.509485] Workqueue: events cached_dev_free [bcache]
[  105.510805] Call Trace:
[  105.511471]  dump_stack+0x8b/0xbd
[  105.512327]  check_noncircular+0x198/0x1b0
[  105.513462]  __lock_acquire+0x105b/0x1c50
[  105.514675]  lock_acquire+0xc4/0x1b0
[  105.515557]  ? flush_workqueue+0x8a/0x550
[  105.516535]  flush_workqueue+0xad/0x550
[  105.517587]  ? flush_workqueue+0x8a/0x550
[  105.518530]  ? drain_workqueue+0xb6/0x170
[  105.519518]  drain_workqueue+0xb6/0x170
[  105.520572]  destroy_workqueue+0x36/0x290
[  105.521658]  cached_dev_free+0x45/0x1e0 [bcache]
[  105.522879]  process_one_work+0x243/0x5a0
[  105.523854]  worker_thread+0x52/0x3c0
[  105.524734]  ? process_one_work+0x5a0/0x5a0
[  105.525768]  kthread+0x132/0x150
[  105.526594]  ? __kthread_bind_mask+0x60/0x60
[  105.527706]  ret_from_fork+0x3a/0x50
[  105.571043] bcache: bcache_device_free() bcache0 stopped
[  105.730801] bcache: cache_set_free() Cache set
74f01341-0881-4c77-a49b-39fafcabb99e unregistered
[  105.730819] bcache: bcache_reboot() All devices stopped
[  105.930055] reboot: Restarting system
[  105.930996] reboot: machine restart
[  105.932182] ACPI MEMORY or I/O RESET_REG.

2. After applied 7e865eba00a3 and this patch, no warning showed again.
[   58.296057] bcache: bcache_reboot() Stopping all devices:
[   58.337730] bcache: bcache_device_free() bcache0 stopped
[   58.484177] bcache: cache_set_free() Cache set
74f01341-0881-4c77-a49b-39fafcabb99e unregistered
[   58.484202] bcache: bcache_reboot() All devices stopped
[   58.731929] reboot: Restarting system
[   58.732845] reboot: machine restart
[   58.734044] ACPI MEMORY or I/O RESET_REG.

Coly Li <colyli@suse.de> =E4=BA=8E2022=E5=B9=B45=E6=9C=8813=E6=97=A5=E5=91=
=A8=E4=BA=94 23:17=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/9/22 9:17 AM, =E6=9D=8E=E7=A3=8A wrote:
> > Coly Li <colyli@suse.de> =E4=BA=8E2022=E5=B9=B44=E6=9C=888=E6=97=A5=E5=
=91=A8=E4=BA=94 00:54=E5=86=99=E9=81=93=EF=BC=9A
> >> On 3/27/22 3:20 PM, Li Lei wrote:
> >>> All pending works will be drained by destroy_workqueue(), no need to =
call
> >>> flush_workqueue() explicitly.
> >>>
> >>> Signed-off-by: Li Lei <lilei@szsandstone.com>
> >>> ---
> >>>    drivers/md/bcache/writeback.c | 5 ++---
> >>>    1 file changed, 2 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeb=
ack.c
> >>> index 9ee0005874cd..2a6d9f39a9b1 100644
> >>> --- a/drivers/md/bcache/writeback.c
> >>> +++ b/drivers/md/bcache/writeback.c
> >>> @@ -793,10 +793,9 @@ static int bch_writeback_thread(void *arg)
> >>>                }
> >>>        }
> >>>
> >>> -     if (dc->writeback_write_wq) {
> >>> -             flush_workqueue(dc->writeback_write_wq);
> >>> +     if (dc->writeback_write_wq)
> >>>                destroy_workqueue(dc->writeback_write_wq);
> >>> -     }
> >>> +
> >>>        cached_dev_put(dc);
> >>>        wait_for_kthread_stop();
> >>>
> >> The above code is from commit 7e865eba00a3 ("bcache: fix potential
> >> deadlock in cached_def_free()"). I explicitly added extra
> >> flush_workqueue() was because of workqueue_sysfs_unregister(wq) in
> >> destory_workqueue().
> >>
> >> workqueue_sysfs_unregister() is not simple because it calls
> >> device_unregister(), and the code path is long. During reboot I am not
> >> sure whether extra deadlocking issue might be introduced. So the safe
> >> way is to explicitly call flush_workqueue() firstly to wait for all
> >> kwork finished, then destroy it.
> >>
> >> It has been ~3 years passed, now I am totally OK with your above chang=
e.
> >> But could you please test your patch with lockdep enabled, and see
> >> whether there is no lock warning observed? Then I'd like to add it int=
o
> >> my test directory.
> >>
> > OK=EF=BC=8CI will test this scenario.
>
>
> Any progress?
>
>
> Coly Li
>

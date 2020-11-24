Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D172C3458
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Nov 2020 00:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731850AbgKXXIJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Nov 2020 18:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbgKXXII (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Nov 2020 18:08:08 -0500
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0E0C0613D6
        for <linux-bcache@vger.kernel.org>; Tue, 24 Nov 2020 15:08:08 -0800 (PST)
Received: by mail-ua1-x942.google.com with SMTP id q4so112311ual.8
        for <linux-bcache@vger.kernel.org>; Tue, 24 Nov 2020 15:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fgFrHoHW04d5WZTDQChXM19KSkscAQ68Nzv+duXCeMY=;
        b=X5WOey2L74ijRycDaEVvuZLArs+wL0DvXcLOQZ9mxcNXlIHQkd7MtHq/nvcPRn1drx
         40HJhCKwTKN8j9Aw3bnHmtMx5PsCDsZz7aBQk0yKJzCup4uTaJcLuj3/siFJmSqslX5A
         3OFvexw0e3H6O4P+WlCaAr14FCGOX81G9OFmFE53ZHT3H05vvwqzccYeshr/ekjP1zus
         vuA8dlnxPXgmH79Y6uwvkcNC4ripyi/btbvH4tmKFwbcFGH4FdCE1nz17bP6eswl3UPd
         L3razbfW5Disg9JEvk1yUPtO2M7xEniVDArGnfry9tYGHYRskEtX2iCtfw5tqIQnkbjW
         9Zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fgFrHoHW04d5WZTDQChXM19KSkscAQ68Nzv+duXCeMY=;
        b=Sc+38Ky5REDjWsjxPeiAoX5r6m/xj/xrPblr9tk4BQP+Ufsbo7Vb3a9RRRofIsRFQR
         77Dgztb9jytSN5MEtss4i/U3G5omqEudsRIhgs5xxw6hxmezw2mfNsn3OsCrTBwASZHd
         9swjNkTcW8dzJIve7qOa2UxjvuX5JyAVKB125xYGD1a2DpOrDWGVAd4TSNo13ZgbH/ED
         sixe8fo7kddr4NKtTIMXP/OquHwS3l8EXmvWys9FFaEQ+fvJxb7RRW2r3mXCATF4sMGD
         RypSsVKB3aIW3hODU6ugdAwKHzCg1F2zRBMXSljpnl5Lisr17qon1ehIZqapL7dNzn+M
         Ysyg==
X-Gm-Message-State: AOAM5335GDNoAJAh4HSa6S3RoWSp4AeA+aBwuQXLgpZub9JkKQQuX72G
        vGO8luLhAkcEvpfPtxnn+DIOGFAjeD4y6HaYKfI=
X-Google-Smtp-Source: ABdhPJyCj9zFBH1vNqqUKpCSt8E5Kj9IjgE1nwSB18V+CVIvF9drR5VXsvwD3yeaH/1/8t9GhR+DKbRR+ES0OZHgWiw=
X-Received: by 2002:a9f:37c8:: with SMTP id q66mr347004uaq.140.1606259287528;
 Tue, 24 Nov 2020 15:08:07 -0800 (PST)
MIME-Version: 1.0
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <20190610191420.27007-13-kent.overstreet@gmail.com> <8381178e-4c1e-e0fe-430b-a459be1a9389@suse.de>
 <48527b97-e39a-0791-e038-d9f2ec28943e@suse.de> <20190722172209.GA25176@kmo-pixel>
In-Reply-To: <20190722172209.GA25176@kmo-pixel>
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 24 Nov 2020 18:07:56 -0500
Message-ID: <CAH6h+heM6asTvfY8zo_-vra8cuavNih1K-jukwQt-E1UoK51eQ@mail.gmail.com>
Subject: Re: [PATCH 12/12] closures: fix a race on wakeup from closure_sync
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,


On Mon, Jul 22, 2019 at 1:51 PM Kent Overstreet
<kent.overstreet@gmail.com> wrote:
>
> On Thu, Jul 18, 2019 at 03:46:46PM +0800, Coly Li wrote:
> > On 2019/7/16 6:47 =E4=B8=8B=E5=8D=88, Coly Li wrote:
> > > Hi Kent,
> > >
> > > On 2019/6/11 3:14 =E4=B8=8A=E5=8D=88, Kent Overstreet wrote:
> > >> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> > > Acked-by: Coly Li <colyli@suse.de>
> > >
> > > And also I receive report for suspicious closure race condition in
> > > bcache, and people ask for having this patch into Linux v5.3.
> > >
> > > So before this patch gets merged into upstream, I plan to rebase it t=
o
> > > drivers/md/bcache/closure.c at this moment. Of cause the author is yo=
u.
> > >
> > > When lib/closure.c merged into upstream, I will rebase all closure us=
age
> > > from bcache to use lib/closure.{c,h}.
> >
> > Hi Kent,
> >
> > The race bug reporter replies me that the closure race bug is very rare
> > to reproduce, after applying the patch and testing, they are not sure
> > whether their closure race problem is fixed or not.
> >
> > And I notice rcu_read_lock()/rcu_read_unlock() is used here, but it is
> > not clear to me what is the functionality of the rcu read lock in
> > closure_sync_fn(). I believe you have reason to use the rcu stuffs here=
,
> > could you please provide some hints to help me to understand the change
> > better ?
>
> The race was when a thread using closure_sync() notices cl->s->done =3D=
=3D 1 before
> the thread calling closure_put() calls wake_up_process(). Then, it's poss=
ible
> for that thread to return and exit just before wake_up_process() is calle=
d - so
> we're trying to wake up a process that no longer exists.
>
> rcu_read_lock() is sufficient to protect against this, as there's an rcu =
barrier
> somewhere in the process teardown path.

Is rcu_read_lock() sufficient even in a kernel that uses
"CONFIG_PREEMPT_NONE=3Dy"? I ask because I hit this panic quite
frequently and it sounds like what you described as this patch is
supposed to fix/prevent:
crash> bt
PID: 0      TASK: ffff88862461ab00  CPU: 2   COMMAND: "swapper/2"
 #0 [ffffc90000100a88] machine_kexec at ffffffff8103d6b5
 #1 [ffffc90000100ad0] __crash_kexec at ffffffff8110d37b
 #2 [ffffc90000100b98] crash_kexec at ffffffff8110e07d
 #3 [ffffc90000100ba8] oops_end at ffffffff8101a9de
 #4 [ffffc90000100bc8] no_context at ffffffff81045e99
 #5 [ffffc90000100c30] async_page_fault at ffffffff81e010cf
    [exception RIP: atomic_try_cmpxchg+2]
    RIP: ffffffff810d3e3b  RSP: ffffc90000100ce8  RFLAGS: 00010046
    RAX: 0000000000000000  RBX: 0000000000000003  RCX: 0000000080080007
    RDX: 0000000000000001  RSI: ffffc90000100cf4  RDI: 0000000100000a5b
    RBP: 00000000ffffffff   R8: 0000000000000001   R9: ffffffffa0422d4e
    R10: ffff888532779000  R11: ffff888532779000  R12: 0000000000000046
    R13: 0000000000000000  R14: ffff88858a062000  R15: 0000000100000a5b
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffffc90000100ce8] _raw_spin_lock_irqsave at ffffffff81cf7d7d
 #7 [ffffc90000100d08] try_to_wake_up at ffffffff810c1624
 #8 [ffffc90000100d58] closure_sync_fn at ffffffffa0419b07 [bcache]
 #9 [ffffc90000100d60] clone_endio at ffffffff81aac48c
#10 [ffffc90000100d90] call_bio_endio at ffffffff81a78e20
#11 [ffffc90000100da8] raid_end_bio_io at ffffffff81a78e69
#12 [ffffc90000100dd8] raid1_end_write_request at ffffffff81a79ad9
#13 [ffffc90000100e48] blk_update_request at ffffffff814c3ab1
#14 [ffffc90000100e88] blk_mq_end_request at ffffffff814caaf2
#15 [ffffc90000100ea0] blk_mq_complete_request at ffffffff814c91c1
#16 [ffffc90000100ec8] nvme_complete_cqes at ffffffffa002fb03 [nvme]
#17 [ffffc90000100f08] nvme_irq at ffffffffa002fb7f [nvme]
#18 [ffffc90000100f30] __handle_irq_event_percpu at ffffffff810e0d60
#19 [ffffc90000100f70] handle_irq_event_percpu at ffffffff810e0e65
#20 [ffffc90000100f98] handle_irq_event at ffffffff810e0ecb
#21 [ffffc90000100fb0] handle_edge_irq at ffffffff810e494d
#22 [ffffc90000100fc8] do_IRQ at ffffffff81e01900
--- <IRQ stack> ---
#23 [ffffc90000077e38] ret_from_intr at ffffffff81e00a0f
    [exception RIP: default_idle+24]
    RIP: ffffffff81cf7938  RSP: ffffc90000077ee0  RFLAGS: 00000246
    RAX: 0000000000000000  RBX: ffff88862461ab00  RCX: ffff888627a96000
    RDX: 0000000000000001  RSI: 0000000000000002  RDI: 0000000000000001
    RBP: 0000000000000000   R8: 000000cd42e4dffb   R9: 00023d75261d1b20
    R10: 00000000000001f0  R11: 0000000000000000  R12: 0000000000000000
    R13: 0000000000000002  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffdb  CS: 0010  SS: 0018
#24 [ffffc90000077ee0] do_idle at ffffffff810c4ee4
#25 [ffffc90000077f20] cpu_startup_entry at ffffffff810c514f
#26 [ffffc90000077f30] start_secondary at ffffffff81037045
#27 [ffffc90000077f50] secondary_startup_64 at ffffffff810000d4
crash> dis closure_sync_fn
0xffffffffa0419af4 <closure_sync_fn>:   mov    0x8(%rdi),%rax
0xffffffffa0419af8 <closure_sync_fn+4>: movl   $0x1,0x8(%rax)
0xffffffffa0419aff <closure_sync_fn+11>:        mov    (%rax),%rdi
0xffffffffa0419b02 <closure_sync_fn+14>:        callq
0xffffffff810c185f <wake_up_process>
0xffffffffa0419b07 <closure_sync_fn+19>:        retq
crash>

I'm using Linux 5.4.69.

--Marc

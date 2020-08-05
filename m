Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E6123C916
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Aug 2020 11:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgHEJXn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Aug 2020 05:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgHEJXD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Aug 2020 05:23:03 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AD1C06174A;
        Wed,  5 Aug 2020 02:23:02 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id v4so37180396ljd.0;
        Wed, 05 Aug 2020 02:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k3yjqFYKdJesN5lripMjBQkzUelOUOp0oDH31apSxZA=;
        b=okZSXdw6Y0ttXICPSCmW6GXQBbfYHEVTDCOJQarVL0Y1p6OaYWConGm15iukUXTi7v
         z6XGAoeP2We2TueeUobi5Z1hm0fx/RJA07FQbZWcZklj/XLTyO/UtfdR7OPGyPyuekiN
         XNYHeP5aWq5NixbJosMl+3cPRJn30BEUb6+IBVYa4FFdS5uFvZWNovkJJLNkCMiZdi0D
         5UVs/Jumc8C3tYBAJiFRMdv1Zo+vYj4N3dfealzZc92le6EHTsNpgbi4vG+XU6tNPi8j
         MsXDUUohVqbcEttpwJvdEV8yLhKtlX+loH4y8tPBJTqsNl61orKP14NbYB30pYxRCtQf
         oF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k3yjqFYKdJesN5lripMjBQkzUelOUOp0oDH31apSxZA=;
        b=uWcZ3mXBBqQGkVFtGnB96FX86vpVXYzIzUGG1hN+jdb2kR9sgLxhl+5SHiMe2qxfgp
         mqVbRQZMQzjm8WYAEO39jKXUdSKbLf9sfKekpepY7fZF6TvIdP24GCBU97iJ24iBr+sB
         bQxScDaEYUnR0PXxmOsSa/+BNa9Frf3CDblwunG/p7u9opZoc6GitBJBAlh+s0+IVo+k
         c5jju2eql9XS843+Rnc+1IlNeYWG3UyIr98gCyVXajGFnO6kb4OCu4KKOY8YOhOi95rv
         3iS92CaqeThvzm+CoTxf0bhAR/X7Nm6YFH2k8TMMyApx5NetoDe+iFsY+KHAj+wtIB/T
         hmlw==
X-Gm-Message-State: AOAM5313F/TWmqev5xBOeSWRKJldCXDdAhFKv2KeY4A4a/y41rZ+k6mw
        +BLT42yyi9VrnokWlZixa0X+PMRfrhJCuQbIj+kUcQ==
X-Google-Smtp-Source: ABdhPJywvMDkz221y0MsWfBaVkgJOm6owKQe1lt9e2rtIOfWC9DbwWapS6yCjGQh6hGxnNByXT8lM7A+UKjCKKQF5Rw=
X-Received: by 2002:a2e:b4e5:: with SMTP id s5mr936003ljm.153.1596619381093;
 Wed, 05 Aug 2020 02:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200805063150.41037-1-colyli@suse.de>
In-Reply-To: <20200805063150.41037-1-colyli@suse.de>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Wed, 5 Aug 2020 11:22:49 +0200
Message-ID: <CAD9gYJLDPLiF+-8gjk4cpgXBROLy_Hg5zcx+rU8-Bi+jVRiz=w@mail.gmail.com>
Subject: Re: [PATCH v3] block: check queue's limits.discard_granularity in __blkdev_issue_discard()
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Evan Green <evgreen@chromium.org>,
        Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiao Ni <xni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

one question below:
Coly Li <colyli@suse.de> =E4=BA=8E2020=E5=B9=B48=E6=9C=885=E6=97=A5=E5=91=
=A8=E4=B8=89 =E4=B8=8A=E5=8D=888:36=E5=86=99=E9=81=93=EF=BC=9A
>
> If create a loop device with a backing NVMe SSD, current loop device
> driver doesn't correctly set its  queue's limits.discard_granularity and
> leaves it as 0. If a discard request at LBA 0 on this loop device, in
> __blkdev_issue_discard() the calculated req_sects will be 0, and a zero
> length discard request will trigger a BUG() panic in generic block layer
> code at block/blk-mq.c:563.
>
> [  955.565006][   C39] ------------[ cut here ]------------
> [  955.559660][   C39] invalid opcode: 0000 [#1] SMP NOPTI
> [  955.622171][   C39] CPU: 39 PID: 248 Comm: ksoftirqd/39 Tainted: G    =
        E     5.8.0-default+ #40
> [  955.622171][   C39] Hardware name: Lenovo ThinkSystem SR650 -[7X05CTO1=
WW]-/-[7X05CTO1WW]-, BIOS -[IVE160M-2.70]- 07/17/2020
> [  955.622175][   C39] RIP: 0010:blk_mq_end_request+0x107/0x110
> [  955.622177][   C39] Code: 48 8b 03 e9 59 ff ff ff 48 89 df 5b 5d 41 5c=
 e9 9f ed ff ff 48 8b 35 98 3c f4 00 48 83 c7 10 48 83 c6 19 e8 cb 56 c9 ff=
 eb cb <0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 56 41 54
> [  955.622179][   C39] RSP: 0018:ffffb1288701fe28 EFLAGS: 00010202
> [  955.749277][   C39] RAX: 0000000000000001 RBX: ffff956fffba5080 RCX: 0=
000000000004003
> [  955.749278][   C39] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0=
000000000000000
> [  955.749279][   C39] RBP: 0000000000000000 R08: 0000000000000000 R09: 0=
000000000000000
> [  955.749279][   C39] R10: ffffb1288701fd28 R11: 0000000000000001 R12: f=
fffffffa8e05160
> [  955.749280][   C39] R13: 0000000000000004 R14: 0000000000000004 R15: f=
fffffffa7ad3a1e
> [  955.749281][   C39] FS:  0000000000000000(0000) GS:ffff95bfbda00000(00=
00) knlGS:0000000000000000
> [  955.749282][   C39] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  955.749282][   C39] CR2: 00007f6f0ef766a8 CR3: 0000005a37012002 CR4: 0=
0000000007606e0
> [  955.749283][   C39] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0=
000000000000000
> [  955.749284][   C39] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0=
000000000000400
> [  955.749284][   C39] PKRU: 55555554
> [  955.749285][   C39] Call Trace:
> [  955.749290][   C39]  blk_done_softirq+0x99/0xc0
> [  957.550669][   C39]  __do_softirq+0xd3/0x45f
> [  957.550677][   C39]  ? smpboot_thread_fn+0x2f/0x1e0
> [  957.550679][   C39]  ? smpboot_thread_fn+0x74/0x1e0
> [  957.550680][   C39]  ? smpboot_thread_fn+0x14e/0x1e0
> [  957.550684][   C39]  run_ksoftirqd+0x30/0x60
> [  957.550687][   C39]  smpboot_thread_fn+0x149/0x1e0
> [  957.886225][   C39]  ? sort_range+0x20/0x20
> [  957.886226][   C39]  kthread+0x137/0x160
> [  957.886228][   C39]  ? kthread_park+0x90/0x90
> [  957.886231][   C39]  ret_from_fork+0x22/0x30
> [  959.117120][   C39] ---[ end trace 3dacdac97e2ed164 ]---
>
> This is the procedure to reproduce the panic,
>   # modprobe scsi_debug delay=3D0 dev_size_mb=3D2048 max_queue=3D1
Why do you need scsi_debug here, it's not relevant and not used?
>   # losetup -f /dev/nvme0n1 --direct-io=3Don
>   # blkdiscard /dev/loop0 -o 0 -l 0x200
>
> This patch fixes the issue by checking q->limits.discard_granularity in
> __blkdev_issue_discard() before composing the discard bio. If the value
> is 0, then prints a warning oops information and returns -EOPNOTSUPP to
> the caller to indicate that this buggy device driver doesn't support
> discard request.
The patch itself looks correct to me.
>
> Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_is=
sue_discard()")
> Fixes: c52abf563049 ("loop: Better discard support for block devices")
> Reported-and-suggested-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Enzo Matsumiya <ematsumiya@suse.com>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Xiao Ni <xni@redhat.com>
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>

Thanks
> ---
> Changelog:
> v3: print device name assocated with the buggy driver.
> v2: fix typo of the wrong return error code.
> v1: first version.
>
>  block/blk-lib.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 019e09bb9c0e..d3bbb3d9fac3 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -47,6 +47,15 @@ int __blkdev_issue_discard(struct block_device *bdev, =
sector_t sector,
>                 op =3D REQ_OP_DISCARD;
>         }
>
> +       /* In case the discard granularity isn't set by buggy device driv=
er */
> +       if (WARN_ON_ONCE(!q->limits.discard_granularity)) {
> +               char dev_name[BDEVNAME_SIZE];
> +
> +               bdevname(bdev, dev_name);
> +               pr_err("%s: Error: discard_granularity is 0.\n", dev_name=
);
> +               return -EOPNOTSUPP;
> +       }
> +
>         bs_mask =3D (bdev_logical_block_size(bdev) >> 9) - 1;
>         if ((sector | nr_sects) & bs_mask)
>                 return -EINVAL;
> --
> 2.26.2
>

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFF32108FA6
	for <lists+linux-bcache@lfdr.de>; Mon, 25 Nov 2019 15:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfKYOMQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 Nov 2019 09:12:16 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:43845 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbfKYOMP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Nov 2019 09:12:15 -0500
Received: by mail-vs1-f67.google.com with SMTP id b16so10109753vso.10
        for <linux-bcache@vger.kernel.org>; Mon, 25 Nov 2019 06:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uDu43lOjeyVlmlVF+NxJZxd/xBxGqeyhLnYE7eJNQSU=;
        b=RemYLND8YdQeORIV/goceG1wupp5+0LyaakcoguOVQT4B4tEK4r+MZspDovyrmoJ8+
         uVi2ZUE4Xv/AO2WnwbZ0ogq+WKl+J5vEP23prQaFkqpkQD9tOG3BTRwNX0MMX6rpUxlf
         TiCkRrPv3w2tw+bV2tWY1/DyTn4hyOokv/a3HHWsl0Dkqd9chYfJlZJliVN/vJzIc43o
         ED+U2jFtIhbZLOs5yEc86bVvHuhm09ahX3a2Qg1kSb77uAhvAWhGT3q2Sg1lcsChNAAX
         5yFhealL+ODkqTRAt1YxVee0s3beGkwYXUZrEV02JvoEMadNhiXICkWuTq7pyT9MHHiY
         gosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uDu43lOjeyVlmlVF+NxJZxd/xBxGqeyhLnYE7eJNQSU=;
        b=QgCAeAqOvVVi4OI102134IEl1+JnHDUe0pHiaf40VMe4ZpuAwvcHNTjEiYnCgzeV3T
         OcnTqO4JEi/gg74+9sZboAD4XE1bYKqvEkI6W4XFjcA+/wSeLBqKlpfI1jjwBLM9H3nx
         5nFXziuP8L45L3aqcn2lOOfkWq8xlbG6KGhNHX3fAKHTTzvdElhtwSVxDeLWPDUQw5uk
         LoME43rk01XDiQrSQ2o/jjDxqFhZP0HedaFpPYPE23djXxJK7qNeKnOB3za0C+q9Mo35
         v2osQcvbMZ663yD/rxcCy6WFYye4FrPHR+bj9POlx6V2zPMXUTZG5G7z4JF3AByVvXo3
         nwZg==
X-Gm-Message-State: APjAAAWJQFAtfikFT4lGaucJ4A1aTd7VKcTxmxSYOFCxZih9oxC85swK
        NauX9UXvoUroZqyvB+I79L8XXst564Z5K6dDLEQ5mw==
X-Google-Smtp-Source: APXvYqxXEPGkcQ/12TgHcqfF1J8+t86NQQWG9FxAZ8loULwuGtP17WG1UGYV3cIDjIJCUvwl3sFimbmPBuFhsgih8tI=
X-Received: by 2002:a05:6102:536:: with SMTP id m22mr9428012vsa.114.1574691134100;
 Mon, 25 Nov 2019 06:12:14 -0800 (PST)
MIME-Version: 1.0
References: <CAH6h+hdWRN-wG9_JJoCSfxs55jeTLzE5ia+DK19GPtJA59EXxQ@mail.gmail.com>
 <497aac95-c9c9-61e7-edc1-c38154f1e881@suse.de>
In-Reply-To: <497aac95-c9c9-61e7-edc1-c38154f1e881@suse.de>
From:   Marc Smith <msmith626@gmail.com>
Date:   Mon, 25 Nov 2019 09:12:02 -0500
Message-ID: <CAH6h+hfjXxBSAJSfSEXnzB8OvYMELFeM0fNmmhZYPv_AvbTVkA@mail.gmail.com>
Subject: Re: [ 186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thanks Coly; tested with Linux 5.4 and I am unable to reproduce this
issue using that version.

--Marc

On Mon, Nov 18, 2019 at 11:21 AM Coly Li <colyli@suse.de> wrote:
>
> On 2019/11/14 3:46 =E4=B8=8A=E5=8D=88, Marc Smith wrote:
> > Hi,
> >
> > I'm using bcache on Linux 4.14.154 and I'm hitting a BUG_ON() in
> > writeback.c, which occurs quite a bit on my systems (using write-back
> > mode). This occurs typically after the backing device is assembled,
> > and the bcache udev rule registers it. Here are the kernel messages
> > when this occurs:
> >
> > [  186.463146] md: md126 stopped.
> > [  186.475151] md/raid:md126: device sdc operational as raid disk 0
> > [  186.475155] md/raid:md126: device sdn operational as raid disk 11
> > [  186.475157] md/raid:md126: device sdm operational as raid disk 10
> > [  186.475158] md/raid:md126: device sdl operational as raid disk 9
> > [  186.475160] md/raid:md126: device sdk operational as raid disk 8
> > [  186.475161] md/raid:md126: device sdj operational as raid disk 7
> > [  186.475163] md/raid:md126: device sdi operational as raid disk 6
> > [  186.475165] md/raid:md126: device sdh operational as raid disk 5
> > [  186.475166] md/raid:md126: device sdg operational as raid disk 4
> > [  186.475168] md/raid:md126: device sdf operational as raid disk 3
> > [  186.475169] md/raid:md126: device sde operational as raid disk 2
> > [  186.475170] md/raid:md126: device sdd operational as raid disk 1
> > [  186.476349] md/raid:md126: raid level 6 active with 12 out of 12
> > devices, algorithm 2
> > [  186.487142] md126: detected capacity change from 0 to 12001083392000
> > [  186.745889] bcache: register_bdev() registered backing device md126
> > [  186.757725] bcache: bch_cached_dev_attach() Caching md126 as
> > bcache0 on set 81c4d4e3-4feb-4f88-8fcb-00f367e69906
> > [  186.758120] ------------[ cut here ]------------
> > [  186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
> > [  186.758128] invalid opcode: 0000 [#1] SMP NOPTI
> > [  186.758301] Modules linked in: qla2xxx(O) bonding ntb_transport
> > ntb_hw_switchtec(OE) cls_switchtec(OE) mlx5_ib mlx5_core bna ib_umad
> > rdma_ucm rdma_cm iw_cm ib_uverbs ib_srp ib_cm iw_nes iw_cxgb4 cxgb4
> > iw_cxgb3 ib_qib rdmavt mlx4_ib mlx4_core ib_mthca ib_core
> > [  186.758741] CPU: 13 PID: 2109 Comm: bcache_writebac Tainted: G
> >      OE   4.14.154-esos.prod #1
> > [  186.758945] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> > [  186.759101] task: ffff888327af0000 task.stack: ffffc90003014000
> > [  186.759262] RIP: 0010:dirty_pred+0x17/0x21
> > [  186.759391] RSP: 0018:ffffc90003017ca0 EFLAGS: 00010202
> > [  186.759537] RAX: 9000001000200002 RBX: ffff888329840b90 RCX: 0000000=
000000003
> > [  186.760235] RDX: 0000000000000002 RSI: ffff888327b01f10 RDI: ffff888=
329840b90
> > [  186.760922] RBP: ffff888327b01f10 R08: 0000000000000000 R09: 000007f=
fffffffff
> > [  186.761603] R10: 0000000000000001 R11: 0000000000000001 R12: ffffc90=
003017dd8
> > [  186.762289] R13: 0000000000000000 R14: ffff88842b503800 R15: ffff888=
42b5038c8
> > [  186.762977] FS:  0000000000000000(0000) GS:ffff88842f540000(0000)
> > knlGS:0000000000000000
> > [  186.764185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  186.764856] CR2: 00007f5fd478ee80 CR3: 00000003af48a000 CR4: 0000000=
0000006e0
> > [  186.765541] Call Trace:
> > [  186.766160]  refill_keybuf_fn+0x64/0x19b
> > [  186.766799]  ? bch_btree_gc_finish+0x2b9/0x2b9
> > [  186.767441]  bch_btree_map_keys_recurse+0x6a/0x140
> > [  186.768983]  bch_btree_map_keys+0x98/0xfb
> > [  186.769626]  ? bch_btree_gc_finish+0x2b9/0x2b9
> > [  186.770269]  ? write_dirty+0xcb/0xcb
> > [  186.770904]  bch_refill_keybuf+0xa0/0x1ab
> > [  186.771544]  ? wait_woken+0x6a/0x6a
> > [  186.772178]  ? write_dirty+0xcb/0xcb
> > [  186.772812]  bch_writeback_thread+0x2a8/0x73d
> > [  186.773458]  ? __switch_to+0x31b/0x342
> > [  186.774096]  ? read_dirty_submit+0x55/0x55
> > [  186.774744]  kthread+0x117/0x11f
> > [  186.775369]  ? kthread_create_on_node+0x36/0x36
> > [  186.776019]  ret_from_fork+0x35/0x40
> > [  186.776656] Code: 5b be 01 00 00 20 48 c7 45 18 20 73 a2 81 5d e9
> > 2d 0a ff ff 48 8b 06 8b 8f f8 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48
> > 39 d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 55 48 89 fd f0 ff 47 28 48
> > 83 c7
> > [  186.778552] RIP: dirty_pred+0x17/0x21 RSP: ffffc90003017ca0
> > [  186.779240] ---[ end trace f9cfb637b4062277 ]---
> >
> >
> > I had experienced this same issue on 4.14.120 as well. I noticed some
> > bug fixes since that patch release so I updated to .154 but the issue
> > still persists. Perhaps it's worth noting this kernel is built with
> > GCC 9.x -- I saw another patch for a stack corruption issue involving
> > GCC 9.x (4.14.128).
> >
> > The 4.14.154 kernel is vanilla from 'kernel.org' (not a distro variant)=
.
> >
> > Any hints on where to start would be greatly appreciated.
>
> Hi Marc,
>
> This is new in my memory. v4.14.154 already has the fix "bcache: fix
> stack corruption by PRECEDING_KEY()", so I guess this issue might be new.
>
> Is it possible to try Linux v5.3, or later kernel ? There are quite a
> lot fixes from v4.14 to v5.3, if you may still observe the issue from
> v5.3, I can try to look into it.
>
> Thanks.
>
> --
>
> Coly Li

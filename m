Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D55127D6B9
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Sep 2020 21:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgI2TSy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Sep 2020 15:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI2TSx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Sep 2020 15:18:53 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CCFC061755
        for <linux-bcache@vger.kernel.org>; Tue, 29 Sep 2020 12:18:53 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id j185so3631169vsc.3
        for <linux-bcache@vger.kernel.org>; Tue, 29 Sep 2020 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PPwSdwGSxXwjf86zWSebSyUe7TuupOZYmVF98Avbgzs=;
        b=Qmqp8lZ4uLBbjZ/J0ZrP8H2CGST74hRnns7q2t5f4b/tTgSdc3f6ybzycDZGogxe1C
         LPL0qnxcF46zaxiHO0Vc7GPq0O7TSWT1z4OEx4HhTtslD3C1EnyA0B7L1zZVMb+w59Bo
         c31syFHfa+Li21P3KBY9xJbHu2wo+xtm3jJPtAWteXTwCeltUBfD7EQx1Yku3NUXisOs
         ZUKQkJczAPIiN1Vw8/FVkyMVBTAWy9r745d+Azg5GCpw5NlvG48vkv27WSDFIPjKJLBs
         u38hC7Hh2ZTOS0UV/Wdv02SQK4qGYX6NYhsIMkq0NeS50WTYxYp6zPevcHIDskjXCdj0
         FR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PPwSdwGSxXwjf86zWSebSyUe7TuupOZYmVF98Avbgzs=;
        b=M42hH6vvPCZfnrx3rLlocG+ouS6dnS/5f5uyW+USH23h15QwUuLyR2xczkvxdblWX6
         UaO39Ub00kz3gjPPOtOaQap2XutEMCATlxmoL8JfrEvIFowjuppx7v3QvRg2PJiL4ROo
         AlKlW9qYUbbFa4C3dWTOOMcBRsLBOxNmHuc4kCq9Tp8v8SoWiLwD3873zq0fg3SHtFSB
         tWdMLSA+/pJtgfQLhxfx2eMH0becwHGq1mbxF3NV3U7GJsmudj9cy99jUTxX6zQs9KAO
         5Usq6fTXXa92H1Rahds5xtM1KTIZ64NkWAoyEk6RbaTfwd8n1YeYf+C+dgI6bM6/hXdC
         oS1Q==
X-Gm-Message-State: AOAM532x3Qbvm17u2Ak8rUpna/qVlUIH4gAB9xmmkDKYXq5qjkQjpm52
        +OIbi5KWxUncG0feQKDl0FIq6X+AiilBmZLN4KeYSaaN/+xm/A==
X-Google-Smtp-Source: ABdhPJzY2ueiWiv+0bIPFhLAC7P9YFvich6duPejTYsOBPdPv5dWrxzSQSTRpZdmohlguSZazjE1uqHKlvT0X+WFSUI=
X-Received: by 2002:a67:8097:: with SMTP id b145mr4162775vsd.40.1601407132606;
 Tue, 29 Sep 2020 12:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+hdWRN-wG9_JJoCSfxs55jeTLzE5ia+DK19GPtJA59EXxQ@mail.gmail.com>
 <497aac95-c9c9-61e7-edc1-c38154f1e881@suse.de> <CAH6h+hfjXxBSAJSfSEXnzB8OvYMELFeM0fNmmhZYPv_AvbTVkA@mail.gmail.com>
In-Reply-To: <CAH6h+hfjXxBSAJSfSEXnzB8OvYMELFeM0fNmmhZYPv_AvbTVkA@mail.gmail.com>
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 29 Sep 2020 15:18:41 -0400
Message-ID: <CAH6h+hex3-AwfvGZoCpsttdUp69f52gE8mUM9Ua+1xyZ=54bMg@mail.gmail.com>
Subject: Re: [ 186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

So nearly one year later, and I haven't hit this issue since running
5.4.x until now. It seems to happen on a system for just ONE of the
backing devices (4 backing devices per cache device). Running Linux
5.4.45 (vanilla kernel.org):

--snip--
[ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
keys in 1 entries, seq 1412486
[ 1597.712131] bcache: bch_cached_dev_attach() Caching md123 as
bcache3 on set 521f7664-690d-4680-9b0d-1299fcee4321
[ 1597.715109] bcache: bch_cached_dev_attach() Caching md124 as
bcache2 on set 521f7664-690d-4680-9b0d-1299fcee4321
[ 1597.718674] bcache: bch_cached_dev_attach() Caching md125 as
bcache1 on set 521f7664-690d-4680-9b0d-1299fcee4321
[ 1597.723378] ------------[ cut here ]------------
[ 1597.723381] kernel BUG at drivers/md/bcache/writeback.c:562!
[ 1597.723389] invalid opcode: 0000 [#1] SMP NOPTI
[ 1597.723514] CPU: 0 PID: 2356 Comm: bcache_writebac Kdump: loaded
Tainted: G           OE     5.4.45-esos.prod #1
[ 1597.723746] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 1597.723877] RIP: 0010:dirty_pred+0x17/0x21 [bcache]
[ 1597.723991] Code: 09 89 43 68 5b 5d 41 5c e9 e4 fd ff ff f0 48 0f
b3 3e c3 48 8b 06 8b 8f 38 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48 39
d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 41 56 41 55 41 54 55 48 89 fd
48 83
[ 1597.724426] RSP: 0018:ffffc900007f7bf0 EFLAGS: 00010297
[ 1597.724543] RAX: 9000000001000002 RBX: ffff88855f800c50 RCX: 00000000000=
00001
[ 1597.724699] RDX: 0000000000000002 RSI: ffff8885125a4f08 RDI: ffff88855f8=
00c50
[ 1597.724857] RBP: ffff8885125a4f08 R08: 0000000000000001 R09: 00000000000=
00001
[ 1597.725015] R10: 9000000001000002 R11: 0000000000000001 R12: ffffc900007=
f7dd0
[ 1597.725175] R13: ffff8885a8797400 R14: ffff8885a87974c8 R15: 00000000000=
00000
[ 1597.725309] FS:  0000000000000000(0000) GS:ffff888627a00000(0000)
knlGS:0000000000000000
[ 1597.725428] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1597.725517] CR2: 0000000000ce9d00 CR3: 000000059f304000 CR4: 00000000003=
40ef0
[ 1597.725623] Call Trace:
[ 1597.725672]  refill_keybuf_fn+0x66/0x1a3 [bcache]
[ 1597.725743]  ? mca_find+0x50/0x50 [bcache]
[ 1597.726310]  bch_btree_map_keys_recurse+0x79/0x14c [bcache]
[ 1597.726433] bcache: bch_cached_dev_attach() Caching md126 as
bcache0 on set 521f7664-690d-4680-9b0d-1299fcee4321
[ 1597.726880]  ? __switch_to_asm+0x34/0x70
[ 1597.728612] bcache: register_cache() registered cache device dm-0
[ 1597.729128]  ? bch_btree_node_get+0xce/0x1bd [bcache]
[ 1597.730553]  ? mca_find+0x50/0x50 [bcache]
[ 1597.731102]  bch_btree_map_keys_recurse+0xc1/0x14c [bcache]
[ 1597.731672]  ? __switch_to_asm+0x40/0x70
[ 1597.732219]  ? __switch_to_asm+0x34/0x70
[ 1597.732770]  ? __schedule+0x492/0x4b5
[ 1597.733319]  ? rwsem_optimistic_spin+0x186/0x1ae
[ 1597.733873]  ? mca_find+0x50/0x50 [bcache]
[ 1597.734431]  bch_btree_map_keys+0x87/0xd5 [bcache]
[ 1597.734987]  ? clear_bit+0x6/0x6 [bcache]
[ 1597.735537]  bch_refill_keybuf+0x81/0x1ae [bcache]
[ 1597.736091]  ? remove_wait_queue+0x41/0x41
[ 1597.736645]  ? clear_bit+0x6/0x6 [bcache]
[ 1597.737189]  bch_writeback_thread+0x35e/0x507 [bcache]
[ 1597.737755]  ? read_dirty+0x448/0x448 [bcache]
[ 1597.738311]  kthread+0xe4/0xe9
[ 1597.738843]  ? kthread_flush_worker+0x70/0x70
[ 1597.739405]  ret_from_fork+0x22/0x40
[ 1597.739951] Modules linked in: nvmet_fc(O) nvmet_rdma(O) nvmet(O)
bcache qla2xxx_scst(OE) nvme_fc(O) nvme_fabrics(O) bonding
cls_switchtec(O) qede qed mlx5_core(O) mlxfw(O) bna rdmavt(O)
ib_umad(O) rdma_ucm(O) ib_uverbs(O) ib_srp(O) rdma_cm(O) ib_cm(O)
iw_cm(O) iw_cxgb4(O) iw_cxgb3(O) ib_qib(O) mlx4_ib(O) mlx4_core(O)
ib_core(O) ib_mthca(O) nvme(O) nvme_core(O) mlx_compat(O)
[ 1597.743363] ---[ end trace 095defe1dc682fed ]---
[ 1597.743983] RIP: 0010:dirty_pred+0x17/0x21 [bcache]
[ 1597.746015] Code: 09 89 43 68 5b 5d 41 5c e9 e4 fd ff ff f0 48 0f
b3 3e c3 48 8b 06 8b 8f 38 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48 39
d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 41 56 41 55 41 54 55 48 89 fd
48 83
[ 1597.747806] RSP: 0018:ffffc900007f7bf0 EFLAGS: 00010297
[ 1597.748449] RAX: 9000000001000002 RBX: ffff88855f800c50 RCX: 00000000000=
00001
[ 1597.749097] RDX: 0000000000000002 RSI: ffff8885125a4f08 RDI: ffff88855f8=
00c50
[ 1597.749769] RBP: ffff8885125a4f08 R08: 0000000000000001 R09: 00000000000=
00001
[ 1597.750427] R10: 9000000001000002 R11: 0000000000000001 R12: ffffc900007=
f7dd0
[ 1597.751073] R13: ffff8885a8797400 R14: ffff8885a87974c8 R15: 00000000000=
00000
[ 1597.751745] FS:  0000000000000000(0000) GS:ffff888627a00000(0000)
knlGS:0000000000000000
[ 1597.752900] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1597.753544] CR2: 0000000000ce9d00 CR3: 000000059f304000 CR4: 00000000003=
40ef0
--snip--

This line at the beginning of that snippet above catches my eye (when
registering the cache device):
[ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
keys in 1 entries, seq 1412486

This machine was in a crashed state, and then upon resetting it, I hit
the issue above when registering the backing/cache devices. Is the
cache/journal perhaps corrupted? Any way to manually
intervene/resolve?

Thanks for your time.


--Marc

On Mon, Nov 25, 2019 at 9:12 AM Marc Smith <msmith626@gmail.com> wrote:
>
> Thanks Coly; tested with Linux 5.4 and I am unable to reproduce this
> issue using that version.
>
> --Marc
>
> On Mon, Nov 18, 2019 at 11:21 AM Coly Li <colyli@suse.de> wrote:
> >
> > On 2019/11/14 3:46 =E4=B8=8A=E5=8D=88, Marc Smith wrote:
> > > Hi,
> > >
> > > I'm using bcache on Linux 4.14.154 and I'm hitting a BUG_ON() in
> > > writeback.c, which occurs quite a bit on my systems (using write-back
> > > mode). This occurs typically after the backing device is assembled,
> > > and the bcache udev rule registers it. Here are the kernel messages
> > > when this occurs:
> > >
> > > [  186.463146] md: md126 stopped.
> > > [  186.475151] md/raid:md126: device sdc operational as raid disk 0
> > > [  186.475155] md/raid:md126: device sdn operational as raid disk 11
> > > [  186.475157] md/raid:md126: device sdm operational as raid disk 10
> > > [  186.475158] md/raid:md126: device sdl operational as raid disk 9
> > > [  186.475160] md/raid:md126: device sdk operational as raid disk 8
> > > [  186.475161] md/raid:md126: device sdj operational as raid disk 7
> > > [  186.475163] md/raid:md126: device sdi operational as raid disk 6
> > > [  186.475165] md/raid:md126: device sdh operational as raid disk 5
> > > [  186.475166] md/raid:md126: device sdg operational as raid disk 4
> > > [  186.475168] md/raid:md126: device sdf operational as raid disk 3
> > > [  186.475169] md/raid:md126: device sde operational as raid disk 2
> > > [  186.475170] md/raid:md126: device sdd operational as raid disk 1
> > > [  186.476349] md/raid:md126: raid level 6 active with 12 out of 12
> > > devices, algorithm 2
> > > [  186.487142] md126: detected capacity change from 0 to 120010833920=
00
> > > [  186.745889] bcache: register_bdev() registered backing device md12=
6
> > > [  186.757725] bcache: bch_cached_dev_attach() Caching md126 as
> > > bcache0 on set 81c4d4e3-4feb-4f88-8fcb-00f367e69906
> > > [  186.758120] ------------[ cut here ]------------
> > > [  186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
> > > [  186.758128] invalid opcode: 0000 [#1] SMP NOPTI
> > > [  186.758301] Modules linked in: qla2xxx(O) bonding ntb_transport
> > > ntb_hw_switchtec(OE) cls_switchtec(OE) mlx5_ib mlx5_core bna ib_umad
> > > rdma_ucm rdma_cm iw_cm ib_uverbs ib_srp ib_cm iw_nes iw_cxgb4 cxgb4
> > > iw_cxgb3 ib_qib rdmavt mlx4_ib mlx4_core ib_mthca ib_core
> > > [  186.758741] CPU: 13 PID: 2109 Comm: bcache_writebac Tainted: G
> > >      OE   4.14.154-esos.prod #1
> > > [  186.758945] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> > > [  186.759101] task: ffff888327af0000 task.stack: ffffc90003014000
> > > [  186.759262] RIP: 0010:dirty_pred+0x17/0x21
> > > [  186.759391] RSP: 0018:ffffc90003017ca0 EFLAGS: 00010202
> > > [  186.759537] RAX: 9000001000200002 RBX: ffff888329840b90 RCX: 00000=
00000000003
> > > [  186.760235] RDX: 0000000000000002 RSI: ffff888327b01f10 RDI: ffff8=
88329840b90
> > > [  186.760922] RBP: ffff888327b01f10 R08: 0000000000000000 R09: 00000=
7ffffffffff
> > > [  186.761603] R10: 0000000000000001 R11: 0000000000000001 R12: ffffc=
90003017dd8
> > > [  186.762289] R13: 0000000000000000 R14: ffff88842b503800 R15: ffff8=
8842b5038c8
> > > [  186.762977] FS:  0000000000000000(0000) GS:ffff88842f540000(0000)
> > > knlGS:0000000000000000
> > > [  186.764185] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [  186.764856] CR2: 00007f5fd478ee80 CR3: 00000003af48a000 CR4: 00000=
000000006e0
> > > [  186.765541] Call Trace:
> > > [  186.766160]  refill_keybuf_fn+0x64/0x19b
> > > [  186.766799]  ? bch_btree_gc_finish+0x2b9/0x2b9
> > > [  186.767441]  bch_btree_map_keys_recurse+0x6a/0x140
> > > [  186.768983]  bch_btree_map_keys+0x98/0xfb
> > > [  186.769626]  ? bch_btree_gc_finish+0x2b9/0x2b9
> > > [  186.770269]  ? write_dirty+0xcb/0xcb
> > > [  186.770904]  bch_refill_keybuf+0xa0/0x1ab
> > > [  186.771544]  ? wait_woken+0x6a/0x6a
> > > [  186.772178]  ? write_dirty+0xcb/0xcb
> > > [  186.772812]  bch_writeback_thread+0x2a8/0x73d
> > > [  186.773458]  ? __switch_to+0x31b/0x342
> > > [  186.774096]  ? read_dirty_submit+0x55/0x55
> > > [  186.774744]  kthread+0x117/0x11f
> > > [  186.775369]  ? kthread_create_on_node+0x36/0x36
> > > [  186.776019]  ret_from_fork+0x35/0x40
> > > [  186.776656] Code: 5b be 01 00 00 20 48 c7 45 18 20 73 a2 81 5d e9
> > > 2d 0a ff ff 48 8b 06 8b 8f f8 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48
> > > 39 d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 55 48 89 fd f0 ff 47 28 4=
8
> > > 83 c7
> > > [  186.778552] RIP: dirty_pred+0x17/0x21 RSP: ffffc90003017ca0
> > > [  186.779240] ---[ end trace f9cfb637b4062277 ]---
> > >
> > >
> > > I had experienced this same issue on 4.14.120 as well. I noticed some
> > > bug fixes since that patch release so I updated to .154 but the issue
> > > still persists. Perhaps it's worth noting this kernel is built with
> > > GCC 9.x -- I saw another patch for a stack corruption issue involving
> > > GCC 9.x (4.14.128).
> > >
> > > The 4.14.154 kernel is vanilla from 'kernel.org' (not a distro varian=
t).
> > >
> > > Any hints on where to start would be greatly appreciated.
> >
> > Hi Marc,
> >
> > This is new in my memory. v4.14.154 already has the fix "bcache: fix
> > stack corruption by PRECEDING_KEY()", so I guess this issue might be ne=
w.
> >
> > Is it possible to try Linux v5.3, or later kernel ? There are quite a
> > lot fixes from v4.14 to v5.3, if you may still observe the issue from
> > v5.3, I can try to look into it.
> >
> > Thanks.
> >
> > --
> >
> > Coly Li

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135B027DEF9
	for <lists+linux-bcache@lfdr.de>; Wed, 30 Sep 2020 05:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgI3DbH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Sep 2020 23:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgI3DbH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Sep 2020 23:31:07 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C031C061755
        for <linux-bcache@vger.kernel.org>; Tue, 29 Sep 2020 20:31:05 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id f63so252033vsc.8
        for <linux-bcache@vger.kernel.org>; Tue, 29 Sep 2020 20:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XIRpRCNLMuNL74eZKmAoSX8j9BKCwNVsRYzgisp7APY=;
        b=MNc1aDji1CqLAYt7I0EAFyKoAv0VTt4+tgpQFU0mcFoXUJeQKNApYMNR0s5BXemsIF
         JGZ/xsgRy52M1hHSAxYHqUIoKTUXUflHE/E6L/06p/jkU1PGo8dCT3G9MFsDSt5R9xxf
         vxzAFBMhohhPa7SY9pLWBd8mSsppNWUQt0WeYtpZowrL6ubH99I5DqzVZsB+U+l4BLy9
         2976DqLqsA2/Bg30ToLpJE6EOSkpvV5MVWlCkZ4Sj+PUz2PMt8vYGGBMtDoyn9yLOiom
         OePBa3vrnU1lY6IpYN/nPvEBkgl/hRuRaVOrxO4G6lzKY8vTzRo1oPhgKsdITNOigHBG
         kDdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XIRpRCNLMuNL74eZKmAoSX8j9BKCwNVsRYzgisp7APY=;
        b=QGMEP0iF7tRJNnf/p+nCWlJTZiLtqWtM+sYZbVydKAWOhXvi2LSsrMOyS0gEmEM43T
         +awBw08JuxeBzRjdcnqliWt3HC2JP1odwj0W6NozEGN25SjhyHkRL4vny3xQ6xFFaj5C
         P7nUTwFV3poyqlQwz7nZBXCpGHN2XcFaFSe8vFNMzZlgqTZLENRlNr1w27QN5u44gOAk
         VRVSJK38pOfLlFDJ0+qpgiazuVEVapZRv7cYObi1W6dyOY+Jv2a3Nxdu8fVMcWPLpY57
         GQg62vaued+Hzzyq+IPvDJukpc/SEsZiUcmzKItSGqtvdKDEs8LwKxHxdiog39++a9Uk
         LWCA==
X-Gm-Message-State: AOAM533bnFG5svlfs+p57iIF5h5OssGP3dTmcNQGtb3QRjdkRFHwAWDP
        op6d2GRgmXgwAXiM0Pvu9Nxs9trDYZQyME3W/es=
X-Google-Smtp-Source: ABdhPJyYI6Tu4wz+hTzW6XLX6ikKEagAGGnkD8I7n0JHXuw0DwyXu+7qbIuA2N/QA6NPnecRecEDtLrXYPtlrT6SPlI=
X-Received: by 2002:a67:8a46:: with SMTP id m67mr216558vsd.28.1601436664480;
 Tue, 29 Sep 2020 20:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAH6h+hdWRN-wG9_JJoCSfxs55jeTLzE5ia+DK19GPtJA59EXxQ@mail.gmail.com>
 <497aac95-c9c9-61e7-edc1-c38154f1e881@suse.de> <CAH6h+hfjXxBSAJSfSEXnzB8OvYMELFeM0fNmmhZYPv_AvbTVkA@mail.gmail.com>
 <CAH6h+hex3-AwfvGZoCpsttdUp69f52gE8mUM9Ua+1xyZ=54bMg@mail.gmail.com> <ba2bbdcc-d894-dea6-1537-76dc87fcc320@suse.de>
In-Reply-To: <ba2bbdcc-d894-dea6-1537-76dc87fcc320@suse.de>
From:   Marc Smith <msmith626@gmail.com>
Date:   Tue, 29 Sep 2020 23:30:53 -0400
Message-ID: <CAH6h+hfKpFad=pE2vsvRBUGpA09hmwkP3DDboxyDZ2EGSwT=bg@mail.gmail.com>
Subject: Re: [ 186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Sep 29, 2020 at 9:37 PM Coly Li <colyli@suse.de> wrote:
>
> On 2020/9/30 03:18, Marc Smith wrote:
> > Hi Coly,
> >
> > So nearly one year later, and I haven't hit this issue since running
> > 5.4.x until now. It seems to happen on a system for just ONE of the
> > backing devices (4 backing devices per cache device). Running Linux
> > 5.4.45 (vanilla kernel.org):
> >
> > --snip--
> > [ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
> > keys in 1 entries, seq 1412486
> > [ 1597.712131] bcache: bch_cached_dev_attach() Caching md123 as
> > bcache3 on set 521f7664-690d-4680-9b0d-1299fcee4321
> > [ 1597.715109] bcache: bch_cached_dev_attach() Caching md124 as
> > bcache2 on set 521f7664-690d-4680-9b0d-1299fcee4321
> > [ 1597.718674] bcache: bch_cached_dev_attach() Caching md125 as
> > bcache1 on set 521f7664-690d-4680-9b0d-1299fcee4321
> > [ 1597.723378] ------------[ cut here ]------------
> > [ 1597.723381] kernel BUG at drivers/md/bcache/writeback.c:562!
> > [ 1597.723389] invalid opcode: 0000 [#1] SMP NOPTI
> > [ 1597.723514] CPU: 0 PID: 2356 Comm: bcache_writebac Kdump: loaded
> > Tainted: G           OE     5.4.45-esos.prod #1
> > [ 1597.723746] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> > [ 1597.723877] RIP: 0010:dirty_pred+0x17/0x21 [bcache]
> > [ 1597.723991] Code: 09 89 43 68 5b 5d 41 5c e9 e4 fd ff ff f0 48 0f
> > b3 3e c3 48 8b 06 8b 8f 38 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48 39
> > d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 41 56 41 55 41 54 55 48 89 fd
> > 48 83
> > [ 1597.724426] RSP: 0018:ffffc900007f7bf0 EFLAGS: 00010297
> > [ 1597.724543] RAX: 9000000001000002 RBX: ffff88855f800c50 RCX: 0000000000000001
> > [ 1597.724699] RDX: 0000000000000002 RSI: ffff8885125a4f08 RDI: ffff88855f800c50
> > [ 1597.724857] RBP: ffff8885125a4f08 R08: 0000000000000001 R09: 0000000000000001
> > [ 1597.725015] R10: 9000000001000002 R11: 0000000000000001 R12: ffffc900007f7dd0
> > [ 1597.725175] R13: ffff8885a8797400 R14: ffff8885a87974c8 R15: 0000000000000000
> > [ 1597.725309] FS:  0000000000000000(0000) GS:ffff888627a00000(0000)
> > knlGS:0000000000000000
> > [ 1597.725428] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1597.725517] CR2: 0000000000ce9d00 CR3: 000000059f304000 CR4: 0000000000340ef0
> > [ 1597.725623] Call Trace:
> > [ 1597.725672]  refill_keybuf_fn+0x66/0x1a3 [bcache]
> > [ 1597.725743]  ? mca_find+0x50/0x50 [bcache]
> > [ 1597.726310]  bch_btree_map_keys_recurse+0x79/0x14c [bcache]
> > [ 1597.726433] bcache: bch_cached_dev_attach() Caching md126 as
> > bcache0 on set 521f7664-690d-4680-9b0d-1299fcee4321
> > [ 1597.726880]  ? __switch_to_asm+0x34/0x70
> > [ 1597.728612] bcache: register_cache() registered cache device dm-0
> > [ 1597.729128]  ? bch_btree_node_get+0xce/0x1bd [bcache]
> > [ 1597.730553]  ? mca_find+0x50/0x50 [bcache]
> > [ 1597.731102]  bch_btree_map_keys_recurse+0xc1/0x14c [bcache]
> > [ 1597.731672]  ? __switch_to_asm+0x40/0x70
> > [ 1597.732219]  ? __switch_to_asm+0x34/0x70
> > [ 1597.732770]  ? __schedule+0x492/0x4b5
> > [ 1597.733319]  ? rwsem_optimistic_spin+0x186/0x1ae
> > [ 1597.733873]  ? mca_find+0x50/0x50 [bcache]
> > [ 1597.734431]  bch_btree_map_keys+0x87/0xd5 [bcache]
> > [ 1597.734987]  ? clear_bit+0x6/0x6 [bcache]
> > [ 1597.735537]  bch_refill_keybuf+0x81/0x1ae [bcache]
> > [ 1597.736091]  ? remove_wait_queue+0x41/0x41
> > [ 1597.736645]  ? clear_bit+0x6/0x6 [bcache]
> > [ 1597.737189]  bch_writeback_thread+0x35e/0x507 [bcache]
> > [ 1597.737755]  ? read_dirty+0x448/0x448 [bcache]
> > [ 1597.738311]  kthread+0xe4/0xe9
> > [ 1597.738843]  ? kthread_flush_worker+0x70/0x70
> > [ 1597.739405]  ret_from_fork+0x22/0x40
> > [ 1597.739951] Modules linked in: nvmet_fc(O) nvmet_rdma(O) nvmet(O)
> > bcache qla2xxx_scst(OE) nvme_fc(O) nvme_fabrics(O) bonding
> > cls_switchtec(O) qede qed mlx5_core(O) mlxfw(O) bna rdmavt(O)
> > ib_umad(O) rdma_ucm(O) ib_uverbs(O) ib_srp(O) rdma_cm(O) ib_cm(O)
> > iw_cm(O) iw_cxgb4(O) iw_cxgb3(O) ib_qib(O) mlx4_ib(O) mlx4_core(O)
> > ib_core(O) ib_mthca(O) nvme(O) nvme_core(O) mlx_compat(O)
> > [ 1597.743363] ---[ end trace 095defe1dc682fed ]---
> > [ 1597.743983] RIP: 0010:dirty_pred+0x17/0x21 [bcache]
> > [ 1597.746015] Code: 09 89 43 68 5b 5d 41 5c e9 e4 fd ff ff f0 48 0f
> > b3 3e c3 48 8b 06 8b 8f 38 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48 39
> > d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 41 56 41 55 41 54 55 48 89 fd
> > 48 83
> > [ 1597.747806] RSP: 0018:ffffc900007f7bf0 EFLAGS: 00010297
> > [ 1597.748449] RAX: 9000000001000002 RBX: ffff88855f800c50 RCX: 0000000000000001
> > [ 1597.749097] RDX: 0000000000000002 RSI: ffff8885125a4f08 RDI: ffff88855f800c50
> > [ 1597.749769] RBP: ffff8885125a4f08 R08: 0000000000000001 R09: 0000000000000001
> > [ 1597.750427] R10: 9000000001000002 R11: 0000000000000001 R12: ffffc900007f7dd0
> > [ 1597.751073] R13: ffff8885a8797400 R14: ffff8885a87974c8 R15: 0000000000000000
> > [ 1597.751745] FS:  0000000000000000(0000) GS:ffff888627a00000(0000)
> > knlGS:0000000000000000
> > [ 1597.752900] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1597.753544] CR2: 0000000000ce9d00 CR3: 000000059f304000 CR4: 0000000000340ef0
> > --snip--
> >
> > This line at the beginning of that snippet above catches my eye (when
> > registering the cache device):
> > [ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
> > keys in 1 entries, seq 1412486
> >
> > This machine was in a crashed state, and then upon resetting it, I hit
> > the issue above when registering the backing/cache devices. Is the
> > cache/journal perhaps corrupted? Any way to manually
> > intervene/resolve?
> >
> > Thanks for your time.
>
> Hi Marc,
>
> Thanks for the reporting. Maybe this is a hidden issue in btree code
> (just a quick guess without any evidence).
>
> For the journal information you mentioned,
> "[ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
> keys in 1 entries, seq 1412486"
> Because a journal_meta() operation may only flush a journal set block
> with cache set meta data without any extra btree key, the message itself
> is legal. I am not able to get suspicious clue from it.

Okay, thank you for the explanation. I took a peek at
bch_journal_replay() and understand now.


>
> Maybe the new kernel just improves to make less mistake for the hidden
> bug, but the root cause is not identified yet.
>
> BTW, there are 2 things in my brain,
> 1) Do you have this patch in your kernel,
>    commit be23e837333a ("bcache: fix potential deadlock problem in
> btree_gc_coalesce")

No, looks like this fix came with 5.4.49 (I'm using .45 currently).
Will update ASAP.


> 2) The journal and btree flush issue was not totally fixed in v5.4. If I
> remember correctly the (currently) final fixes went into mainline kernel
> in v5.6. Could you please to try v5.6 stable tree see whether the
> situation might be better.

I can't move to or really test all that well 5.6.x at this moment.
However, if you know of a specific patch or set of patches you could
point me at, I could look at back porting these to 5.4.x for my use.


>
> It's pity that I am not able to tell where the problem immediately. But
> I keep this issue in my mind and I will try to trace it.
>
> Thank you again, for the important issue report.

Understood, thank you.

--Marc


>
> Coly Li

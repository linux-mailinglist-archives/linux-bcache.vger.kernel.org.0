Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156D47946B4
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Sep 2023 00:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbjIFW4p (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Sep 2023 18:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjIFW4p (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Sep 2023 18:56:45 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8473719A9
        for <linux-bcache@vger.kernel.org>; Wed,  6 Sep 2023 15:56:37 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-59209b12c50so3932917b3.0
        for <linux-bcache@vger.kernel.org>; Wed, 06 Sep 2023 15:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google; t=1694040997; x=1694645797; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tRu96XJtdFgSg4WFJc/B8ZZ7oHwRLyep0lVPVobuNrI=;
        b=C5BXy29YR9CnkaMC9hHOiGCALn7ocL5DDPcVDFpLyq0mC/rnXOHzhiE5BqQkBDawiz
         ykqOzGC0TW/TYuksf/+WWUy10cf/Yw30Pb3tt4Xtq1IkcHoWvTfALUqtay3vWgb5CoyR
         3erRi3mY35ZcQ3vnKjjiKKzSiJH0PgpJEPVI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694040997; x=1694645797;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tRu96XJtdFgSg4WFJc/B8ZZ7oHwRLyep0lVPVobuNrI=;
        b=kqkoNXpC33GycTU5lHLNsY6FvyTiQkbBKYzScU+CLKTQtELmnXMHJ6J/xlo5ZVkvkL
         WGzvR9/+oQdmo5VPS3JNVs9Tlf3tuV+nHalpLp5sR2RV5sDFOxQBoWFzJXyqFshzJ0nq
         n+bkQNjb2VEi34apLmSG6WfWUO1BpJ9RxoM82yKtgsYbwV+M7l1GoWBx8FmTdSDSfwnr
         FD/Fdz8yTGoAwtiB/ltiDpOY4UspGiR06DtMICViPnATR9EijzMQvENhTKeUeM7lLJmY
         f00EAcYaR4e8yAW6x6BMUnv/rP95wZG6VbfLP+gqz/Hk/hfDUKgwBlIDPjCY7tCsXf8o
         GvOA==
X-Gm-Message-State: AOJu0YynBQU6Hvo1wW4aKIJnC1TLgbRn9Juy07wJtu2KUR0dIQGAfhNp
        BPxe+Lg6p4oTdLXgyTlvZPKkvQcssmjJ+T9P1gJ5LQ==
X-Google-Smtp-Source: AGHT+IHtYYcyd4UlqQUeMyDcgtUKuK1z8d6r60KQWnfMvRxNVIU8UbsDHZPLd5t7v2VlyKD0oBV1ZGGJpmd2Y/bKSvk=
X-Received: by 2002:a05:690c:300d:b0:592:9236:9460 with SMTP id
 ey13-20020a05690c300d00b0059292369460mr17182106ywb.31.1694040996579; Wed, 06
 Sep 2023 15:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
 <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
 <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
 <CAC2ZOYuBhFbpZeRnnc-1-Vt-tV_3iwkf3i21+YjVukYkx7J7YQ@mail.gmail.com>
 <70b9cdd0-ace9-9ee7-19c7-5c47a4d2fce9@suse.de> <CAC2ZOYuCLQpD___YBua7yEuuG85+OQ+HiRGDy=FRLS9cgMg4rA@mail.gmail.com>
 <6ab4d6a-de99-6464-cb2-ad66d0918446@ewheeler.net>
In-Reply-To: <6ab4d6a-de99-6464-cb2-ad66d0918446@ewheeler.net>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 7 Sep 2023 00:56:25 +0200
Message-ID: <CAC2ZOYsLB72OJpAxHm+1eNgAxFOW3wsWDXQNgkOSFT7sDBgLkQ@mail.gmail.com>
Subject: Re: Dirty data loss after cache disk error recovery
To:     Eric Wheeler <lists@bcache.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Wow!

I call that a necro-bump... ;-)

Am Mi., 6. Sept. 2023 um 22:33 Uhr schrieb Eric Wheeler
<lists@bcache.ewheeler.net>:
>
> On Fri, 7 May 2021, Kai Krakow wrote:
>
> > > Adding a new "stop" error action IMHO doesn't make things better. When
> > > the cache device is disconnected, it is always risky that some caching
> > > data or meta data is not updated onto cache device. Permit the cache
> > > device to be re-attached to the backing device may introduce "silent
> > > data loss" which might be worse....  It was the reason why I didn't add
> > > new error action for the device failure handling patch set.
> >
> > But we are actually now seeing silent data loss: The system f'ed up
> > somehow, needed a hard reset, and after reboot the bcache device was
> > accessible in cache mode "none" (because they have been unregistered
> > before, and because udev just detected it and you can use bcache
> > without an attached cache in "none" mode), completely hiding the fact
> > that we lost dirty write-back data, it's even not quite obvious that
> > /dev/bcache0 now is detached, cache mode none, but accessible
> > nevertheless. To me, this is quite clearly "silent data loss",
> > especially since the unregister action threw the dirty data away.
> >
> > So this:
> >
> > > Permit the cache
> > > device to be re-attached to the backing device may introduce "silent
> > > data loss" which might be worse....
> >
> > is actually the situation we are facing currently: Device has been
> > unregistered, after reboot, udev detects it has clean backing device
> > without cache association, using cache mode none, and it is readable
> > and writable just fine: It essentially permitted access to the stale
> > backing device (tho, it didn't re-attach as you outlined, but that's
> > more or less the same situation).
> >
> > Maybe devices that become disassociated from a cache due to IO errors
> > but have dirty data should go to a caching mode "stale", and bcache
> > should refuse to access such devices or throw away their dirty data
> > until I decide to force them back online into the cache set or force
> > discard the dirty data. Then at least I would discover that something
> > went badly wrong. Otherwise, I may not detect that dirty data wasn't
> > written. In the best case, that makes my FS unmountable, in the worst
> > case, some file data is simply lost (aka silent data loss), besides
> > both situations are the worst-case scenario anyways.
> >
> > The whole situation probably comes from udev auto-registering bcache
> > backing devices again, and bcache has no record of why the device was
> > unregistered - it looks clean after such a situation.

[...]

> I think we hit this same issue from 2021. Here is that original thread from 2021:
>         https://lore.kernel.org/all/2662a21d-8f12-186a-e632-964ac7bae72d@suse.de/T/#m5a6cc34a043ecedaeb9469ec9d218e084ffec0de
>
> Kai, did you end up with a good patch for this? We are running a 5.15
> kernel with the many backported bcache commits that Coly suggested here:
>         https://www.spinics.net/lists/linux-bcache/msg12084.html

I'm currently running 6.1 with bcache on mdraid1 and device-level
write caching disabled. I didn't see this ever occur again.

BUT: Between that time and now I eventually also replaced my faulty
RAM which had a few rare bit-flips.


> Based on the thread from Kai (from 2021), I think we need to restore from
> backup. While the root of the problem may be hardware related, bcache
> should be more gracefully than unplugging the cache.

Yes, it may be hardware-related and you should probably confirm your
RAM working properly.

Currently, I'm running with no bcache patches on LTS 6.1, only some
btrfs patches:
https://github.com/kakra/linux/pull/26

Especially the allocation-hint patches provide better speedups for
meta data than bcache could ever do. With these patches, you could
dedicate a small amount of two SSD partitions (on different drivers)
to a btrfs metadata raid1, and use the remainder of the SSDs as a
bcache mdraid1. Then just don't use writeback caching but writearound
or writethrough instead. Most btrfs performance issues come from slow
metadata which can be much better improved by allocator-hints than by
bcache.

But as written above, I had bad RAM, and meanwhile upgraded to kernel
6.1, and had no issues since with bcache even on power loss.


> Coly, is there already a patch to prevent complete dirty cache loss?

This is probably still an issue. The cache attachment MUST NEVER EVER
automatically degrade to "none" which it did for my fail-cases I had
back then. I don't know if this has changed meanwhile. But because
bcache explicitly does not honor write-barriers from upstream writes
for its own writeback (which is okay because it guarantees to write
back all data anyways and give a consistent view to upstream FS -
well, unless it has to handle write errors), the backed filesystem is
guaranteed to be effed up in that case, and allowing it to mount and
write because bcache silently has fallen back to "none" will only make
the matter worse.

(HINT: I never used brbd personally, most of the following is
theoretical thinking without real-world experience)

I see that you're using drbd? Did it fail due to networking issues?
I'm pretty sure it should be robust in that case but maybe bcache
cannot handle the situation? Does brbd have a write log to replay
writes after network connection loss? It looks like it doesn't and
thus bcache exploded.

Anyways, since your backing device seems to be on drbd, using metadata
allocation hinting is probably no option. You could of course still
use drbd with bcache for metadata hinted partitions, and then use
writearound caching only for that. At least, in the fail-case, your
btrfs won't be destroyed. But your data chunks may have unreadable
files then. But it should be easy to select them and restore from
backup individually. Btrfs is very robust for that fail case: if
metadata is okay, data errors are properly detected and handled. If
you're not using btrfs, all of this doesn't apply ofc.

I'm not sure if write-back caching for drbd backing is a wise decision
anyways. drbd is slow for writes, that's part of the design (and no
writeback caching could fix that). I would not rely on
bcache-writeback to fix that for you because it is not prepared for
storage that may be temporarily not available, iow, it would freeze
and continue when drbd is available again. I think you should really
use writearound/writethrough so your FS can be sure data has been
written, replicated and persisted. In case of btrfs, you could still
split data and metadata as written above, and use writeback for data,
but reliable writes for metadata.

So concluding:

1. I'm now persisting metadata directly to disk with no intermediate
layers (no bcache, no md)

2. I'm using allocation-hinted data-only partitions with bcache
write-back, with bcache on mdraid1. If anything goes wrong, I have
file crc errors in btrfs files only, but the filesystem itself is
valid because no metadata is broken or lost. I have snapshots of
recently modified files. I have daily backups.

3. Your problem is that bcache can - by design - detect write errors
only when it's too late with no chance telling the filesystem. In that
case, writethrough/writearound is the correct choice.

4. Maybe bcache should know if backing is on storage that may be
temporarily unavailable and then freeze until the backing storage is
back online, similar to how iSCSI handles that. But otoh, maybe drbd
should freeze until the replicated storage is available again while
writing (from what I've read, it's designed to not do that but let
local storage get ahead of the replica, which is btw incompatible with
bcache-writeback assumptions). Or maybe using async mirroring can fix
this for you but then, the mirror will be compromised if a hardware
failure immediately follows a previous drbd network connection loss.
But, it may still be an issue with the local hardware (bit-flips etc)
because maybe just bcache internals broke - Coly may have a better
idea of that.

I think your main issue here is that bcache decouples writebarriers
from the underlying backing storage - and you should just not use
writeback, it is incompatible by design with how drbd works: your
replica will be broken when you need it.


> Here is our trace:
>
> [Sep 6 13:01] bcache: bch_cache_set_error() error on a3292185-39ff-4f67-bec7-0f738d3cc28a: spotted extent 829560:7447835265109722923 len 26330 -> [0:112365451 gen 48, 0:1163806048 gen 3: bad, length too big, disabling caching
> [  +0.001940] CPU: 12 PID: 2435752 Comm: kworker/12:0 Kdump: loaded Not tainted 5.15.0-7.86.6.1.el9uek.x86_64-TEST+ #7
> [  +0.000548] block drbd8143: write: error=10 s=9205904s
> [  +0.000301] Hardware name: Supermicro Super Server/H11SSL-i, BIOS 2.4 12/27/2021
> [  +0.000866] block drbd8143: Local IO failed in drbd_endio_write_sec_final.
> [  +0.000809] Workqueue: bcache bch_data_insert_keys
> [  +0.000833] block drbd8143: disk( UpToDate -> Inconsistent )
> [  +0.000826] Call Trace:
> [  +0.000875] block drbd8143: write: error=10 s=8394752s
> [  +0.000797]  <TASK>
> [  +0.000006]  dump_stack_lvl+0x57/0x7e
> [  +0.000791] block drbd8143: Local IO failed in drbd_endio_write_sec_final.
> [  +0.000755]  bch_extent_invalid.cold+0x9/0x10
> [  +0.000760] block drbd8143: write: error=10 s=8397840s
> [  +0.000759]  btree_mergesort+0x27e/0x36e
> [  +0.000005]  ? bch_cache_allocator_start+0x50/0x50
> [  +0.000009]  __btree_sort+0xa4/0x1e9
> [  +0.002085] block drbd8143: drbd_md_sync_page_io(,41943032s,WRITE) failed with error -5
> [  +0.000109]  bch_btree_sort_partial+0xbc/0x14d
> [  +0.000878] block drbd8143: meta data update failed!
> [  +0.000836]  bch_btree_init_next+0x39/0xb6
> [  +0.000004]  bch_btree_insert_node+0x26e/0x2d3
> [  +0.000877] block drbd8143: disk( Inconsistent -> Failed )
> [  +0.000863]  btree_insert_fn+0x20/0x48
> [  +0.000866] block drbd8143: Local IO failed in drbd_md_write. Detaching...
> [  +0.000864]  bch_btree_map_nodes_recurse+0x111/0x1a7
> [  +0.004270]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> [  +0.000850]  __bch_btree_map_nodes+0x1e0/0x1fb
> [  +0.000858]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> [  +0.000848]  bch_btree_insert+0x102/0x188
> [  +0.000844]  ? do_wait_intr_irq+0xb0/0xaf
> [  +0.000857]  bch_data_insert_keys+0x39/0xde
> [  +0.000845]  process_one_work+0x280/0x5cf
> [  +0.000858]  worker_thread+0x52/0x3bd
> [  +0.000851]  ? process_one_work.cold+0x52/0x51
> [  +0.000877]  kthread+0x13e/0x15b
> [  +0.000858]  ? set_kthread_struct+0x60/0x52
> [  +0.000855]  ret_from_fork+0x22/0x2d
> [  +0.000854]  </TASK>


Regards,
Kai

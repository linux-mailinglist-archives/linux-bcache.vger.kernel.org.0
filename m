Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B094C797664
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Sep 2023 18:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbjIGQIk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Sep 2023 12:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbjIGQHx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Sep 2023 12:07:53 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C19D16A
        for <linux-bcache@vger.kernel.org>; Thu,  7 Sep 2023 09:00:45 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-64a8826dde2so7073376d6.1
        for <linux-bcache@vger.kernel.org>; Thu, 07 Sep 2023 09:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google; t=1694102370; x=1694707170; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jWMBrq6FXIBBTK56gB/+HaQIIJthqHHTRmfxVC+1K5w=;
        b=BLXp8wbygLCx7XZ/KgE1yDN6WgCLtrIUSjSw3BuT2aR4H4tskVAjfoKlnSk6X9YD21
         QssEW4KlBAfWZOgbceBdAsCSZcB8hp+7t1E15mGgd3nuiYU/UnaoVeMTC/b/9tNG7Nad
         KSjc5AvGAVt28opiLF+B0kzJr/lD23SSfGADE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694102370; x=1694707170;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWMBrq6FXIBBTK56gB/+HaQIIJthqHHTRmfxVC+1K5w=;
        b=QR3fMzD1rPTFEh+zVPMqA/yFUETyLvq9KQ9DM1hzFkGNugL8uy7sgWpEq/jDuFK06c
         Kx8rj4GGuGmSxE5DICh1sogrlzZ1TjNISn+bAtBqlaIybrDGY28u34gI7ki2Jf980tIW
         ncJbut1U1C4VMpZORAFrRCcZ22ARW9cQVKvh0b8eNi+k2vpi089mhq3CF/2rEu8pDAiD
         WqDzuKah6AaulEoLTSkERs6fQQOtuLg+uq+okGzLvfNwzjJhCfBVG59BBk7jcry9LOYW
         rgPdd9hT08cxtsBJyo144gjUKPB6xHsTkGv7+8DKUYYd/f8JFZOMwukKJXV8giyyl15K
         m+7Q==
X-Gm-Message-State: AOJu0YxbMaWabh+NtFcv3SFr9UzD1nxYvvi3BDefNwe5N5H+08vs8xqF
        258Bwe1G7TVbpZT2e40Izitlsfy8elHg71dhbRbM244+wOnuymJeTuw=
X-Google-Smtp-Source: AGHT+IGW0vmBYFnAr+v32Vmh9dSoNnc35KhWtwlN0gOF59DjxAnAkOPRMLdeIcgboKcmfQXkAg9DijYsR7IMBqe+0mk=
X-Received: by 2002:a25:ae5a:0:b0:cfd:58aa:b36e with SMTP id
 g26-20020a25ae5a000000b00cfd58aab36emr21348868ybe.9.1694088044872; Thu, 07
 Sep 2023 05:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
 <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
 <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
 <CAC2ZOYuBhFbpZeRnnc-1-Vt-tV_3iwkf3i21+YjVukYkx7J7YQ@mail.gmail.com>
 <70b9cdd0-ace9-9ee7-19c7-5c47a4d2fce9@suse.de> <CAC2ZOYuCLQpD___YBua7yEuuG85+OQ+HiRGDy=FRLS9cgMg4rA@mail.gmail.com>
 <6ab4d6a-de99-6464-cb2-ad66d0918446@ewheeler.net> <CAC2ZOYsLB72OJpAxHm+1eNgAxFOW3wsWDXQNgkOSFT7sDBgLkQ@mail.gmail.com>
 <7cadf9ff-b496-5567-9d60-f0af48122595@ewheeler.net>
In-Reply-To: <7cadf9ff-b496-5567-9d60-f0af48122595@ewheeler.net>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 7 Sep 2023 14:00:33 +0200
Message-ID: <CAC2ZOYvqTgd0vQO01-qWkmQVT2onr43-pp0DgEBSRtf8y+7WJw@mail.gmail.com>
Subject: Re: Dirty data loss after cache disk error recovery
To:     Eric Wheeler <lists@bcache.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Do., 7. Sept. 2023 um 02:42 Uhr schrieb Eric Wheeler
<lists@bcache.ewheeler.net>:
>
> +Mingzhe, Coly: please comment on the proposed fix below when you have a
> moment:
>
> > > Coly, is there already a patch to prevent complete dirty cache loss?
> >
> > This is probably still an issue. The cache attachment MUST NEVER EVER
> > automatically degrade to "none" which it did for my fail-cases I had
> > back then. I don't know if this has changed meanwhile.
>
> I would rather that bcache went to a read-only mode in failure
> conditions like this.  Maybe write-around would be acceptable since
> bcache returns -EIO for any failed dirty cache reads.  But if the cache
> is dirty, and it gets an error, it _must_never_ read from the bdev, which
> is what appears to happens now.
>
> Coly, Mingzhe, would this be an easy change?
>
> Here are the relevant bits:
>
> The allocator called btree_mergesort which called bch_extent_invalid:
>         https://elixir.bootlin.com/linux/latest/source/drivers/md/bcache/extents.c#L480
>
> Which called the `cache_bug` macro, which triggered bch_cache_set_error:
>         https://elixir.bootlin.com/linux/v6.5/source/drivers/md/bcache/super.c#L1626
>
> It then calls `bch_cache_set_unregister` which shuts down the cache:
>         https://elixir.bootlin.com/linux/v6.5/source/drivers/md/bcache/super.c#L1845
>
>         bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...)
>         {
>                 ...
>                 bch_cache_set_unregister(c);
>                 return true;
>         }
>
> Proposed solution:
>
> What if, instead of bch_cache_set_unregister() that this was called instead:
>         SET_BDEV_CACHE_MODE(&c->cache->sb, CACHE_MODE_WRITEAROUND)
>
> This would bypass the cache for future writes, and allow reads to
> proceed if possible, and -EIO otherwise to let upper layers handle the
> failure.

Ensuring to not read stale content from bdev by switching to
writearound is probably a proper solution - if there are no other
side-effects. But due to the error, the cdev may be in some broken
limbo state. So it should probably try to writeback dirty data while
adding no more future data - neither for read-caching nor
write-caching. Maybe this was the intention of unregister but instead
of writing back dirty data and still serving dirty data from cdev, it
immediately unregisters and invalidates the cdev.

So maybe the bugfix should be about why unregister() doesn't write
back dirty data first...

So actually switching to "none" but without unregister should probably
provide that exact behavior? No more read/write but finishing
outstanding dirty writeback.

Earlier I write:

> > This is probably still an issue. The cache attachment MUST NEVER EVER
> > automatically degrade to "none" which it did for my fail-cases I had

This was meant under the assumption that "none" is the state after
unregister - just to differentiate from what I wrote immediately
before.


> What do you think?
>
> > But because bcache explicitly does not honor write-barriers from
> > upstream writes for its own writeback (which is okay because it
> > guarantees to write back all data anyways and give a consistent view to
> > upstream FS - well, unless it has to handle write errors), the backed
> > filesystem is guaranteed to be effed up in that case, and allowing it to
> > mount and write because bcache silently has fallen back to "none" will
> > only make the matter worse.
> >
> > (HINT: I never used brbd personally, most of the following is
> > theoretical thinking without real-world experience)
> >
> > I see that you're using drbd? Did it fail due to networking issues?
> > I'm pretty sure it should be robust in that case but maybe bcache
> > cannot handle the situation? Does brbd have a write log to replay
> > writes after network connection loss? It looks like it doesn't and
> > thus bcache exploded.
>
> DRBD is _above_ bcache, not below it.  In this case, DRBD hung because
> bcache hung, not the other way around, so DRBD is not the issue here.
> Here is our stack:
>
> bcache:
>         bdev:     /dev/sda hardware RAID5
>         cachedev: LVM volume from /dev/md0, which is /dev/nvme{0,1} RAID1
>
> And then bcache is stacked like so:
>
>         bcache <- dm-thin <- DRBD <- dm-crypt <- KVM
>                               |
>                               v
>                          [remote host]
>
> > Anyways, since your backing device seems to be on drbd, using metadata
> > allocation hinting is probably no option. You could of course still use
> > drbd with bcache for metadata hinted partitions, and then use
> > writearound caching only for that. At least, in the fail-case, your
> > btrfs won't be destroyed. But your data chunks may have unreadable files
> > then. But it should be easy to select them and restore from backup
> > individually. Btrfs is very robust for that fail case: if metadata is
> > okay, data errors are properly detected and handled. If you're not using
> > btrfs, all of this doesn't apply ofc.
> >
> > I'm not sure if write-back caching for drbd backing is a wise decision
> > anyways. drbd is slow for writes, that's part of the design (and no
> > writeback caching could fix that).
>
> Bcache-backed DRBD provides a noticable difference, especially with a
> 10GbE link (or faster) and the same disk stack on both sides.
>
> > I would not rely on bcache-writeback to fix that for you because it is
> > not prepared for storage that may be temporarily not available
>
> True, which is why we put drbd /on top/ of bcache, so bcache is unaware of
> DRBD's existence.
>
> > iow, it would freeze and continue when drbd is available again. I think
> > you should really use writearound/writethrough so your FS can be sure
> > data has been written, replicated and persisted. In case of btrfs, you
> > could still split data and metadata as written above, and use writeback
> > for data, but reliable writes for metadata.
> >
> > So concluding:
> >
> > 1. I'm now persisting metadata directly to disk with no intermediate
> > layers (no bcache, no md)
> >
> > 2. I'm using allocation-hinted data-only partitions with bcache
> > write-back, with bcache on mdraid1. If anything goes wrong, I have
> > file crc errors in btrfs files only, but the filesystem itself is
> > valid because no metadata is broken or lost. I have snapshots of
> > recently modified files. I have daily backups.
> >
> > 3. Your problem is that bcache can - by design - detect write errors
> > only when it's too late with no chance telling the filesystem. In that
> > case, writethrough/writearound is the correct choice.
> >
> > 4. Maybe bcache should know if backing is on storage that may be
> > temporarily unavailable and then freeze until the backing storage is
> > back online, similar to how iSCSI handles that.
>
> I don't think "temporarily unavailable" should be bcache's burden, as
> bcache is a local-only solution.  If someone is using iSCSI under bcache,
> then good luck ;)
>
> > But otoh, maybe drbd should freeze until the replicated storage is
> > available again while writing (from what I've read, it's designed to not
> > do that but let local storage get ahead of the replica, which is btw
> > incompatible with bcache-writeback assumptions).
>
> N/A for this thread, but FYI: DRBD will wait (hang) if it is disconnected
> and has no local copy for some reason.  If local storage is available, it
> will use that and resync when its peer comes up.
>
> > Or maybe using async mirroring can fix this for you but then, the mirror
> > will be compromised if a hardware failure immediately follows a previous
> > drbd network connection loss. But, it may still be an issue with the
> > local hardware (bit-flips etc) because maybe just bcache internals broke
> > - Coly may have a better idea of that.
>
> This isn't DRBDs fault since it is above bcache. I wish only address the
> the bcache cache=none issue.
>
> -Eric
>
> >
> > I think your main issue here is that bcache decouples writebarriers
> > from the underlying backing storage - and you should just not use
> > writeback, it is incompatible by design with how drbd works: your
> > replica will be broken when you need it.
>
>
> >
> >
> > > Here is our trace:
> > >
> > > [Sep 6 13:01] bcache: bch_cache_set_error() error on
> > > a3292185-39ff-4f67-bec7-0f738d3cc28a: spotted extent
> > > 829560:7447835265109722923 len 26330 -> [0:112365451 gen 48,
> > > 0:1163806048 gen 3: bad, length too big, disabling caching
> >
> > > [  +0.001940] CPU: 12 PID: 2435752 Comm: kworker/12:0 Kdump: loaded Not tainted 5.15.0-7.86.6.1.el9uek.x86_64-TEST+ #7
> > > [  +0.000301] Hardware name: Supermicro Super Server/H11SSL-i, BIOS 2.4 12/27/2021
> > > [  +0.000809] Workqueue: bcache bch_data_insert_keys
> > > [  +0.000826] Call Trace:
> > > [  +0.000797]  <TASK>
> > > [  +0.000006]  dump_stack_lvl+0x57/0x7e
> > > [  +0.000755]  bch_extent_invalid.cold+0x9/0x10
> > > [  +0.000759]  btree_mergesort+0x27e/0x36e
> > > [  +0.000005]  ? bch_cache_allocator_start+0x50/0x50
> > > [  +0.000009]  __btree_sort+0xa4/0x1e9
> > > [  +0.000109]  bch_btree_sort_partial+0xbc/0x14d
> > > [  +0.000836]  bch_btree_init_next+0x39/0xb6
> > > [  +0.000004]  bch_btree_insert_node+0x26e/0x2d3
> > > [  +0.000863]  btree_insert_fn+0x20/0x48
> > > [  +0.000864]  bch_btree_map_nodes_recurse+0x111/0x1a7
> > > [  +0.004270]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> > > [  +0.000850]  __bch_btree_map_nodes+0x1e0/0x1fb
> > > [  +0.000858]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> > > [  +0.000848]  bch_btree_insert+0x102/0x188
> > > [  +0.000844]  ? do_wait_intr_irq+0xb0/0xaf
> > > [  +0.000857]  bch_data_insert_keys+0x39/0xde
> > > [  +0.000845]  process_one_work+0x280/0x5cf
> > > [  +0.000858]  worker_thread+0x52/0x3bd
> > > [  +0.000851]  ? process_one_work.cold+0x52/0x51
> > > [  +0.000877]  kthread+0x13e/0x15b
> > > [  +0.000858]  ? set_kthread_struct+0x60/0x52
> > > [  +0.000855]  ret_from_fork+0x22/0x2d
> > > [  +0.000854]  </TASK>
> >
> >
> > Regards,
> > Kai
> >

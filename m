Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D207C5921
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Oct 2023 18:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjJKQaD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Oct 2023 12:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbjJKQaA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Oct 2023 12:30:00 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEB093
        for <linux-bcache@vger.kernel.org>; Wed, 11 Oct 2023 09:29:57 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-d81adf0d57fso7442338276.1
        for <linux-bcache@vger.kernel.org>; Wed, 11 Oct 2023 09:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google; t=1697041796; x=1697646596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFgIhO5/guD7Q7+QqibN5/fGctdmkXz9PeIns8Jpf2s=;
        b=f1XcpwkeohScZg9zcv9JadRr4llekA3nU9grmiO2V/IdeKcpWjS54Q5UR0/BHUNdRj
         6yk6cHmT7DLbIRM0cX5k0B6a7wvKW5wznEdNjbEgQwYhVmzixeyWvb3cQebGo23TofVD
         RG9Nly2DbUkdngLt36Ftia2SF2IqffyutKWPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697041796; x=1697646596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFgIhO5/guD7Q7+QqibN5/fGctdmkXz9PeIns8Jpf2s=;
        b=olmNsXv2MoDU/eIkUM/ue4gbDOGTMhPSgDMmOf2UbdhU9lWesanhk4yoy9WpFIoJOe
         iXSzID/cKo4pFg75skknDDGEUiTnQL02wphiZtyibN7CBYIPHRrVvtlnkvNqRyBhdB0S
         UVfzgMkn5rZrikk1TPOebJlqMK9mfZ+4k4B265IwsYW+dG6slpROjuX9AfeYugzIAGQO
         4ppoW5G31/SvMsTBDxQ2fMo54gCjLBEZh+UQxZNRdnh8MZ1WUpZC3+t7DRjGlj8bl1/M
         wUm3IR9bQzGKc+RyhH69ztee+f8pa+IM55mN8k6akEKCUG/UP8Gs7Mp4IARQsyAAy51o
         S/Og==
X-Gm-Message-State: AOJu0YxI/8DeOHERJGy4ag6yu2TXosKFRgoqI9F+SwG1PbfFix0u4Uez
        9Mz+3K3NXNf5i88MjS2WtwKjvVS5SdQG1YoJ0ODVB1cEr8yii7tBK10=
X-Google-Smtp-Source: AGHT+IE/SLhNSIWIrzIH+tLoSa51/Q+hQHRs4wWoh+fsHczFoysr2hStVj3yWipf62nbg4GHNDRTFM/RBoY9b65Prk4=
X-Received: by 2002:a05:6902:188e:b0:d78:be:6f02 with SMTP id
 cj14-20020a056902188e00b00d7800be6f02mr22147060ybb.11.1697041796630; Wed, 11
 Oct 2023 09:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <7cadf9ff-b496-5567-9d60-f0af48122595@ewheeler.net>
 <AJUA3AAkJBN4GUdLmkiuQ4qP.3.1694501683518.Hmail.mingzhe.zou@easystack.cn> <f2fcf354-29ec-e2f7-b251-fb9b7d36f4@ewheeler.net>
In-Reply-To: <f2fcf354-29ec-e2f7-b251-fb9b7d36f4@ewheeler.net>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 11 Oct 2023 18:29:45 +0200
Message-ID: <CAC2ZOYux_CJ=+qVsiGmpKnH-fdA7-kJm5Z2MPomiv9P50R993A@mail.gmail.com>
Subject: Re: Re: Dirty data loss after cache disk error recovery
To:     Eric Wheeler <lists@bcache.ewheeler.net>
Cc:     =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>,
        Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Eric,

your "from" mail (lists@bcache.ewheeler.net) does not exist:
> DNS Error: DNS type 'mx' lookup of bcache.ewheeler.net responded with cod=
e NXDOMAIN Domain name not found: bcache.ewheeler.net

Or is something messed up on my side?

All others, please ignore. Doesn't add to the conversation. Thanks. :-)

Am Di., 12. Sept. 2023 um 22:02 Uhr schrieb Eric Wheeler
<lists@bcache.ewheeler.net>:
>
> On Tue, 12 Sep 2023, =E9=82=B9=E6=98=8E=E5=93=B2 wrote:
> > From: Eric Wheeler <lists@bcache.ewheeler.net>
> > Date: 2023-09-07 08:42:41
> > To:  Coly Li <colyli@suse.de>
> > Cc:  Kai Krakow <kai@kaishome.de>,"linux-bcache@vger.kernel.org" <linux=
-bcache@vger.kernel.org>,"=E5=90=B4=E6=9C=AC=E5=8D=BF(=E4=BA=91=E6=A1=8C=E9=
=9D=A2 =E7=A6=8F=E5=B7=9E)" <wubenqing@ruijie.com.cn>,Mingzhe Zou <mingzhe.=
zou@easystack.cn>
> > Subject: Re: Dirty data loss after cache disk error recovery
> > >+Mingzhe, Coly: please comment on the proposed fix below when you have=
 a
> > >moment:
> >
> > Hi, Eric
> >
> > This is an old issue, and it took me a long time to understand what
> > happened.
> >
> > >
> > >On Thu, 7 Sep 2023, Kai Krakow wrote:
> > >> Wow!
> > >>
> > >> I call that a necro-bump... ;-)
> > >>
> > >> Am Mi., 6. Sept. 2023 um 22:33 Uhr schrieb Eric Wheeler
> > >> <lists@bcache.ewheeler.net>:
> > >> >
> > >> > On Fri, 7 May 2021, Kai Krakow wrote:
> > >> >
> > >> > > > Adding a new "stop" error action IMHO doesn't make things bett=
er. When
> > >> > > > the cache device is disconnected, it is always risky that some=
 caching
> > >> > > > data or meta data is not updated onto cache device. Permit the=
 cache
> > >> > > > device to be re-attached to the backing device may introduce "=
silent
> > >> > > > data loss" which might be worse....  It was the reason why I d=
idn't add
> > >> > > > new error action for the device failure handling patch set.
> > >> > >
> > >> > > But we are actually now seeing silent data loss: The system f'ed=
 up
> > >> > > somehow, needed a hard reset, and after reboot the bcache device=
 was
> > >> > > accessible in cache mode "none" (because they have been unregist=
ered
> > >> > > before, and because udev just detected it and you can use bcache
> > >> > > without an attached cache in "none" mode), completely hiding the=
 fact
> > >> > > that we lost dirty write-back data, it's even not quite obvious =
that
> > >> > > /dev/bcache0 now is detached, cache mode none, but accessible
> > >> > > nevertheless. To me, this is quite clearly "silent data loss",
> > >> > > especially since the unregister action threw the dirty data away=
.
> > >> > >
> > >> > > So this:
> > >> > >
> > >> > > > Permit the cache
> > >> > > > device to be re-attached to the backing device may introduce "=
silent
> > >> > > > data loss" which might be worse....
> > >> > >
> > >> > > is actually the situation we are facing currently: Device has be=
en
> > >> > > unregistered, after reboot, udev detects it has clean backing de=
vice
> > >> > > without cache association, using cache mode none, and it is read=
able
> > >> > > and writable just fine: It essentially permitted access to the s=
tale
> > >> > > backing device (tho, it didn't re-attach as you outlined, but th=
at's
> > >> > > more or less the same situation).
> > >> > >
> > >> > > Maybe devices that become disassociated from a cache due to IO e=
rrors
> > >> > > but have dirty data should go to a caching mode "stale", and bca=
che
> > >> > > should refuse to access such devices or throw away their dirty d=
ata
> > >> > > until I decide to force them back online into the cache set or f=
orce
> > >> > > discard the dirty data. Then at least I would discover that some=
thing
> > >> > > went badly wrong. Otherwise, I may not detect that dirty data wa=
sn't
> > >> > > written. In the best case, that makes my FS unmountable, in the =
worst
> > >> > > case, some file data is simply lost (aka silent data loss), besi=
des
> > >> > > both situations are the worst-case scenario anyways.
> > >> > >
> > >> > > The whole situation probably comes from udev auto-registering bc=
ache
> > >> > > backing devices again, and bcache has no record of why the devic=
e was
> > >> > > unregistered - it looks clean after such a situation.
> > >>
> > >> [...]
> > >>
> > >> > I think we hit this same issue from 2021. Here is that original th=
read from 2021:
> > >> >         https://lore.kernel.org/all/2662a21d-8f12-186a-e632-964ac7=
bae72d@suse.de/T/#m5a6cc34a043ecedaeb9469ec9d218e084ffec0de
> > >> >
> > >> > Kai, did you end up with a good patch for this? We are running a 5=
.15
> > >> > kernel with the many backported bcache commits that Coly suggested=
 here:
> > >> >         https://www.spinics.net/lists/linux-bcache/msg12084.html
> > >>
> > >> I'm currently running 6.1 with bcache on mdraid1 and device-level
> > >> write caching disabled. I didn't see this ever occur again.
> > >
> > >Awesome, good to know.
> > >
> > >> But as written above, I had bad RAM, and meanwhile upgraded to kerne=
l
> > >> 6.1, and had no issues since with bcache even on power loss.
> > >>
> > >> > Coly, is there already a patch to prevent complete dirty cache los=
s?
> > >>
> > >> This is probably still an issue. The cache attachment MUST NEVER EVE=
R
> > >> automatically degrade to "none" which it did for my fail-cases I had
> > >> back then. I don't know if this has changed meanwhile.
> > >
> > >I would rather that bcache went to a read-only mode in failure
> > >conditions like this.  Maybe write-around would be acceptable since
> > >bcache returns -EIO for any failed dirty cache reads.  But if the cach=
e
> > >is dirty, and it gets an error, it _must_never_ read from the bdev, wh=
ich
> > >is what appears to happens now.
> > >
> > >Coly, Mingzhe, would this be an easy change?
> >
> > First of all, we have never had this problem. We have had an nvme
> > controller failure, but at this time the cache cannot be read or
> > written, so even unregister will not succeed.
> >
> > Coly once replied like this:
> >
> > """
> > There is an option to panic the system when cache device failed. It
> > is in errors file with available options as "unregister" and "panic".
> > This option is default set to "unregister", if you set it to "panic"
> > then panic() will be called.
> > """
> >
> > I think "panic" is a better way to handle this situation. If cache
> > returns an error, there may be more unknown errors if the operation
> > continues.
>
> Depending on how the block devices are stacked, the OS can continue if
> bcache fails (eg, bcache under raid1, drbd, etc).  Returning IO requests
> with -EIO or setting bcache read-only would be better, because a panic
> would crash services that could otherwise proceed without noticing the
> bcache outage.
>
> If bcache has a critical failure, I would rather that it fail the IOs so
> upper-layers in the block stack can compensate.
>
> What if we extend /sys/fs/bcache/<uuid>/errors to include a "readonly"
> option, and make that the default setting?  The gendisk(s) for related
> /dev/bcacheX devices can be flagged BLKROSET in the error handler:
>         https://patchwork.kernel.org/project/dm-devel/patch/2020112918192=
6.897775-2-hch@lst.de/
>
> This would protect the data and keep the host online.
>
> --
> Eric Wheeler
>
>
>
> >
> > >
> > >Here are the relevant bits:
> > >
> > >The allocator called btree_mergesort which called bch_extent_invalid:
> > >     https://elixir.bootlin.com/linux/latest/source/drivers/md/bcache/=
extents.c#L480
> > >
> > >Which called the `cache_bug` macro, which triggered bch_cache_set_erro=
r:
> > >     https://elixir.bootlin.com/linux/v6.5/source/drivers/md/bcache/su=
per.c#L1626
> > >
> > >It then calls `bch_cache_set_unregister` which shuts down the cache:
> > >     https://elixir.bootlin.com/linux/v6.5/source/drivers/md/bcache/su=
per.c#L1845
> > >
> > >     bool bch_cache_set_error(struct cache_set *c, const char *fmt, ..=
.)
> > >     {
> > >             ...
> > >             bch_cache_set_unregister(c);
> > >             return true;
> > >     }
> > >
> > >Proposed solution:
> > >
> > >What if, instead of bch_cache_set_unregister() that this was called in=
stead:
> > >     SET_BDEV_CACHE_MODE(&c->cache->sb, CACHE_MODE_WRITEAROUND)
> >
> > If cache_mode can be automatically modified, when will it be restored
> > to writeback? I think we need to be able to enable or disable this.
> >
> > >
> > >This would bypass the cache for future writes, and allow reads to
> > >proceed if possible, and -EIO otherwise to let upper layers handle the
> > >failure.
> > >
> > >What do you think?
> >
> > If we switch to writearound mode, how to ensure that the IO is read-onl=
y,
> > because writing IO may require invalidating dirty data. If the backing
> > write is successful but invalid fails, how should we handle it?
> >
> > Maybe "panic" could be the default option. What do you think?
> >
> > >
> > >> But because bcache explicitly does not honor write-barriers from
> > >> upstream writes for its own writeback (which is okay because it
> > >> guarantees to write back all data anyways and give a consistent view=
 to
> > >> upstream FS - well, unless it has to handle write errors), the backe=
d
> > >> filesystem is guaranteed to be effed up in that case, and allowing i=
t to
> > >> mount and write because bcache silently has fallen back to "none" wi=
ll
> > >> only make the matter worse.
> > >>
> > >> (HINT: I never used brbd personally, most of the following is
> > >> theoretical thinking without real-world experience)
> > >>
> > >> I see that you're using drbd? Did it fail due to networking issues?
> > >> I'm pretty sure it should be robust in that case but maybe bcache
> > >> cannot handle the situation? Does brbd have a write log to replay
> > >> writes after network connection loss? It looks like it doesn't and
> > >> thus bcache exploded.
> > >
> > >DRBD is _above_ bcache, not below it.  In this case, DRBD hung because
> > >bcache hung, not the other way around, so DRBD is not the issue here.
> > >Here is our stack:
> > >
> > >bcache:
> > >     bdev:     /dev/sda hardware RAID5
> > >     cachedev: LVM volume from /dev/md0, which is /dev/nvme{0,1} RAID1
> > >
> > >And then bcache is stacked like so:
> > >
> > >        bcache <- dm-thin <- DRBD <- dm-crypt <- KVM
> > >                              |
> > >                              v
> > >                         [remote host]
> > >
> > >> Anyways, since your backing device seems to be on drbd, using metada=
ta
> > >> allocation hinting is probably no option. You could of course still =
use
> > >> drbd with bcache for metadata hinted partitions, and then use
> > >> writearound caching only for that. At least, in the fail-case, your
> > >> btrfs won't be destroyed. But your data chunks may have unreadable f=
iles
> > >> then. But it should be easy to select them and restore from backup
> > >> individually. Btrfs is very robust for that fail case: if metadata i=
s
> > >> okay, data errors are properly detected and handled. If you're not u=
sing
> > >> btrfs, all of this doesn't apply ofc.
> > >>
> > >> I'm not sure if write-back caching for drbd backing is a wise decisi=
on
> > >> anyways. drbd is slow for writes, that's part of the design (and no
> > >> writeback caching could fix that).
> > >
> > >Bcache-backed DRBD provides a noticable difference, especially with a
> > >10GbE link (or faster) and the same disk stack on both sides.
> > >
> > >> I would not rely on bcache-writeback to fix that for you because it =
is
> > >> not prepared for storage that may be temporarily not available
> > >
> > >True, which is why we put drbd /on top/ of bcache, so bcache is unawar=
e of
> > >DRBD's existence.
> > >
> > >> iow, it would freeze and continue when drbd is available again. I th=
ink
> > >> you should really use writearound/writethrough so your FS can be sur=
e
> > >> data has been written, replicated and persisted. In case of btrfs, y=
ou
> > >> could still split data and metadata as written above, and use writeb=
ack
> > >> for data, but reliable writes for metadata.
> > >>
> > >> So concluding:
> > >>
> > >> 1. I'm now persisting metadata directly to disk with no intermediate
> > >> layers (no bcache, no md)
> > >>
> > >> 2. I'm using allocation-hinted data-only partitions with bcache
> > >> write-back, with bcache on mdraid1. If anything goes wrong, I have
> > >> file crc errors in btrfs files only, but the filesystem itself is
> > >> valid because no metadata is broken or lost. I have snapshots of
> > >> recently modified files. I have daily backups.
> > >>
> > >> 3. Your problem is that bcache can - by design - detect write errors
> > >> only when it's too late with no chance telling the filesystem. In th=
at
> > >> case, writethrough/writearound is the correct choice.
> > >>
> > >> 4. Maybe bcache should know if backing is on storage that may be
> > >> temporarily unavailable and then freeze until the backing storage is
> > >> back online, similar to how iSCSI handles that.
> > >
> > >I don't think "temporarily unavailable" should be bcache's burden, as
> > >bcache is a local-only solution.  If someone is using iSCSI under bcac=
he,
> > >then good luck ;)
> > >
> > >> But otoh, maybe drbd should freeze until the replicated storage is
> > >> available again while writing (from what I've read, it's designed to=
 not
> > >> do that but let local storage get ahead of the replica, which is btw
> > >> incompatible with bcache-writeback assumptions).
> > >
> > >N/A for this thread, but FYI: DRBD will wait (hang) if it is disconnec=
ted
> > >and has no local copy for some reason.  If local storage is available,=
 it
> > >will use that and resync when its peer comes up.
> > >
> > >> Or maybe using async mirroring can fix this for you but then, the mi=
rror
> > >> will be compromised if a hardware failure immediately follows a prev=
ious
> > >> drbd network connection loss. But, it may still be an issue with the
> > >> local hardware (bit-flips etc) because maybe just bcache internals b=
roke
> > >> - Coly may have a better idea of that.
> > >
> > >This isn't DRBDs fault since it is above bcache. I wish only address t=
he
> > >the bcache cache=3Dnone issue.
> > >
> > >-Eric
> > >
> > >>
> > >> I think your main issue here is that bcache decouples writebarriers
> > >> from the underlying backing storage - and you should just not use
> > >> writeback, it is incompatible by design with how drbd works: your
> > >> replica will be broken when you need it.
> > >
> > >
> > >>
> > >>
> > >> > Here is our trace:
> > >> >
> > >> > [Sep 6 13:01] bcache: bch_cache_set_error() error on
> > >> > a3292185-39ff-4f67-bec7-0f738d3cc28a: spotted extent
> > >> > 829560:7447835265109722923 len 26330 -> [0:112365451 gen 48,
> > >> > 0:1163806048 gen 3: bad, length too big, disabling caching
> > >>
> > >> > [  +0.001940] CPU: 12 PID: 2435752 Comm: kworker/12:0 Kdump: loade=
d Not tainted 5.15.0-7.86.6.1.el9uek.x86_64-TEST+ #7
> > >> > [  +0.000301] Hardware name: Supermicro Super Server/H11SSL-i, BIO=
S 2.4 12/27/2021
> > >> > [  +0.000809] Workqueue: bcache bch_data_insert_keys
> > >> > [  +0.000826] Call Trace:
> > >> > [  +0.000797]  <TASK>
> > >> > [  +0.000006]  dump_stack_lvl+0x57/0x7e
> > >> > [  +0.000755]  bch_extent_invalid.cold+0x9/0x10
> > >> > [  +0.000759]  btree_mergesort+0x27e/0x36e
> > >> > [  +0.000005]  ? bch_cache_allocator_start+0x50/0x50
> > >> > [  +0.000009]  __btree_sort+0xa4/0x1e9
> > >> > [  +0.000109]  bch_btree_sort_partial+0xbc/0x14d
> > >> > [  +0.000836]  bch_btree_init_next+0x39/0xb6
> > >> > [  +0.000004]  bch_btree_insert_node+0x26e/0x2d3
> > >> > [  +0.000863]  btree_insert_fn+0x20/0x48
> > >> > [  +0.000864]  bch_btree_map_nodes_recurse+0x111/0x1a7
> > >> > [  +0.004270]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> > >> > [  +0.000850]  __bch_btree_map_nodes+0x1e0/0x1fb
> > >> > [  +0.000858]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> > >> > [  +0.000848]  bch_btree_insert+0x102/0x188
> > >> > [  +0.000844]  ? do_wait_intr_irq+0xb0/0xaf
> > >> > [  +0.000857]  bch_data_insert_keys+0x39/0xde
> > >> > [  +0.000845]  process_one_work+0x280/0x5cf
> > >> > [  +0.000858]  worker_thread+0x52/0x3bd
> > >> > [  +0.000851]  ? process_one_work.cold+0x52/0x51
> > >> > [  +0.000877]  kthread+0x13e/0x15b
> > >> > [  +0.000858]  ? set_kthread_struct+0x60/0x52
> > >> > [  +0.000855]  ret_from_fork+0x22/0x2d
> > >> > [  +0.000854]  </TASK>
> > >>
> > >>
> > >> Regards,
> > >> Kai
> > >>
> >
> >
> >
> >
> >

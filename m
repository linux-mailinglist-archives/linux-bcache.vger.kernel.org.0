Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F94E7CB715
	for <lists+linux-bcache@lfdr.de>; Tue, 17 Oct 2023 01:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbjJPXjQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 16 Oct 2023 19:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjJPXjP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2023 19:39:15 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1147D9F
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2023 16:39:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id B61B249;
        Mon, 16 Oct 2023 16:39:12 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id g80_vEWNuf8g; Mon, 16 Oct 2023 16:39:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 360C740;
        Mon, 16 Oct 2023 16:39:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 360C740
Date:   Mon, 16 Oct 2023 16:39:08 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Kai Krakow <kai@kaishome.de>
cc:     =?GB2312?B?197D99Xc?= <mingzhe.zou@easystack.cn>,
        Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?GB2312?B?zuKxvsfkKNTG18DD5iC4o9bdKQ==?= <wubenqing@ruijie.com.cn>
Subject: Re: Re: Dirty data loss after cache disk error recovery
In-Reply-To: <CAC2ZOYti00duQqPJJqGm=GZRmH+X_uZW+V-WitvwP2s_12JGWA@mail.gmail.com>
Message-ID: <87b4cac-6b15-14d9-7179-9becc24816d7@ewheeler.net>
References: <7cadf9ff-b496-5567-9d60-f0af48122595@ewheeler.net> <AJUA3AAkJBN4GUdLmkiuQ4qP.3.1694501683518.Hmail.mingzhe.zou@easystack.cn> <f2fcf354-29ec-e2f7-b251-fb9b7d36f4@ewheeler.net> <CAC2ZOYti00duQqPJJqGm=GZRmH+X_uZW+V-WitvwP2s_12JGWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-462103965-1697499498=:25715"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-462103965-1697499498=:25715
Content-Type: text/plain; CHARSET=GB2312
Content-Transfer-Encoding: 8BIT

On Wed, 11 Oct 2023, Kai Krakow wrote:
> I've now faced a similar issue where one of my HDDs spontaneously
> decided to have a series of bad blocks. It looks like it has 26145
> failed writes due to how bcache handles writeback. It had 5275 failed
> reads with btrfs loudly complaining about it. The system also became
> really slow to respond until it eventually froze.
> 
> After a reboot it worked again but of course there were still bad
> blocks because bcache did writeback, so no blocks have been replaced
> with btrfs auto-repair on read feature. This time, the system handled
> the situation a bit better but files became inaccessible in the middle
> of writing them which destroyed my Plasma desktop configuration and
> Chrome profile (I restored them from the last snapper snapshot
> successfully). Essentially, the file system was in a readonly-like
> state: most requests failed with IO errors despite the btrfs didn't
> switch to read-only. Something messed up in the error path of
> userspace -> bcache -> btrfs -> device. Also, btrfs was seeing the

Do you mean userspace -> btrfs -> bcache -> device

> device somewhere in the limbo of not existing and not working - it
> still tried to access it while bcache claimed the backend device would
> be missing. To me this looks like bcache error handling may need some
> fine tuning - it should not fail in that way, especially not with
> btrfs-raid, but still the system was seeing IO errors and broken files
> in the middle of writes.
> 
> "bcache show" showed the backend device missing while "btrfs dev show"
> was still seeing the attached bcache device, and the system threw IO
> errors to user-space despite btrfs still having a valid copy of the
> blocks.
> 
> I've rebooted and now switched the bad device from bcache writeback to
> bcache none - and guess what: The system runs stable now, btrfs
> auto-repair does its thing. The above mentioned behavior does not
> occur (IO errors in user-space). A final scrub across the bad devices
> repaired the bad blocks, I currently do not see any more problems.
> 
> It's probably better to replace that device but this also shows that
> switching bcache to "none" (if the backing device fails) or "write
> through" at least may be a better choice than doing some other error
> handling. Or bcache should have been able to make btrfs see the device
> as missing (which obviously did not happen).

Noted.  Did bcache actually detach its cache in the failure scenario 
you describe?

> Of course, if the cache device fails we have a completely different
> situation. I'm not sure which situation Eric was seeing (I think the
> caching device failed) but for me, the backing device failed - and
> with bcache involved, the result was very unexpected.

Ahh, so you are saying the cache continued to service requests even though 
the bdev was offline?  Was the bdev completely "unplugged" or was it just 
having IO errors?

> So we probably need at least two error handlers: Handling caching
> device errors, and handling backing device errors (for which bcache
> doesn't currently seem to have a setting).

I think it tries to write to the cache if the bdev dies.  Dirty or cached 
blocks are read from cache and other IOs are passed to bdev which may 
return end up returning an EIO.  Coly, is this correct?

-Eric
 
> Except for the strange IO errors and resulting incomplete writes (and
> I really don't know why that happened), btrfs survived this perfectly
> well - and somehow bcache did a good enough job. This has been
> different in the past. So this is already a great achievement. Thank
> you.
> 
> BTW: This probably only worked for me because I split btrfs metadata
> and data to different devices
> (https://github.com/kakra/linux/pull/26), and metadata does not pass
> through bcache at all but natively to SSD. Otherwise I fear btrfs may
> have seen partial metadata writes on different RAID members.
> 
> Regards,
> Kai
> 
> 
> Am Di., 12. Sept. 2023 um 22:02 Uhr schrieb Eric Wheeler
> <lists@bcache.ewheeler.net>:
> >
> > On Tue, 12 Sep 2023, ×ÞÃ÷ÕÜ wrote:
> > > From: Eric Wheeler <lists@bcache.ewheeler.net>
> > > Date: 2023-09-07 08:42:41
> > > To:  Coly Li <colyli@suse.de>
> > > Cc:  Kai Krakow <kai@kaishome.de>,"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,"Îâ±¾Çä(ÔÆ×ÀÃæ ¸£ÖÝ)" <wubenqing@ruijie.com.cn>,Mingzhe Zou <mingzhe.zou@easystack.cn>
> > > Subject: Re: Dirty data loss after cache disk error recovery
> > > >+Mingzhe, Coly: please comment on the proposed fix below when you have a
> > > >moment:
> > >
> > > Hi, Eric
> > >
> > > This is an old issue, and it took me a long time to understand what
> > > happened.
> > >
> > > >
> > > >On Thu, 7 Sep 2023, Kai Krakow wrote:
> > > >> Wow!
> > > >>
> > > >> I call that a necro-bump... ;-)
> > > >>
> > > >> Am Mi., 6. Sept. 2023 um 22:33 Uhr schrieb Eric Wheeler
> > > >> <lists@bcache.ewheeler.net>:
> > > >> >
> > > >> > On Fri, 7 May 2021, Kai Krakow wrote:
> > > >> >
> > > >> > > > Adding a new "stop" error action IMHO doesn't make things better. When
> > > >> > > > the cache device is disconnected, it is always risky that some caching
> > > >> > > > data or meta data is not updated onto cache device. Permit the cache
> > > >> > > > device to be re-attached to the backing device may introduce "silent
> > > >> > > > data loss" which might be worse....  It was the reason why I didn't add
> > > >> > > > new error action for the device failure handling patch set.
> > > >> > >
> > > >> > > But we are actually now seeing silent data loss: The system f'ed up
> > > >> > > somehow, needed a hard reset, and after reboot the bcache device was
> > > >> > > accessible in cache mode "none" (because they have been unregistered
> > > >> > > before, and because udev just detected it and you can use bcache
> > > >> > > without an attached cache in "none" mode), completely hiding the fact
> > > >> > > that we lost dirty write-back data, it's even not quite obvious that
> > > >> > > /dev/bcache0 now is detached, cache mode none, but accessible
> > > >> > > nevertheless. To me, this is quite clearly "silent data loss",
> > > >> > > especially since the unregister action threw the dirty data away.
> > > >> > >
> > > >> > > So this:
> > > >> > >
> > > >> > > > Permit the cache
> > > >> > > > device to be re-attached to the backing device may introduce "silent
> > > >> > > > data loss" which might be worse....
> > > >> > >
> > > >> > > is actually the situation we are facing currently: Device has been
> > > >> > > unregistered, after reboot, udev detects it has clean backing device
> > > >> > > without cache association, using cache mode none, and it is readable
> > > >> > > and writable just fine: It essentially permitted access to the stale
> > > >> > > backing device (tho, it didn't re-attach as you outlined, but that's
> > > >> > > more or less the same situation).
> > > >> > >
> > > >> > > Maybe devices that become disassociated from a cache due to IO errors
> > > >> > > but have dirty data should go to a caching mode "stale", and bcache
> > > >> > > should refuse to access such devices or throw away their dirty data
> > > >> > > until I decide to force them back online into the cache set or force
> > > >> > > discard the dirty data. Then at least I would discover that something
> > > >> > > went badly wrong. Otherwise, I may not detect that dirty data wasn't
> > > >> > > written. In the best case, that makes my FS unmountable, in the worst
> > > >> > > case, some file data is simply lost (aka silent data loss), besides
> > > >> > > both situations are the worst-case scenario anyways.
> > > >> > >
> > > >> > > The whole situation probably comes from udev auto-registering bcache
> > > >> > > backing devices again, and bcache has no record of why the device was
> > > >> > > unregistered - it looks clean after such a situation.
> > > >>
> > > >> [...]
> > > >>
> > > >> > I think we hit this same issue from 2021. Here is that original thread from 2021:
> > > >> >         https://lore.kernel.org/all/2662a21d-8f12-186a-e632-964ac7bae72d@suse.de/T/#m5a6cc34a043ecedaeb9469ec9d218e084ffec0de
> > > >> >
> > > >> > Kai, did you end up with a good patch for this? We are running a 5.15
> > > >> > kernel with the many backported bcache commits that Coly suggested here:
> > > >> >         https://www.spinics.net/lists/linux-bcache/msg12084.html
> > > >>
> > > >> I'm currently running 6.1 with bcache on mdraid1 and device-level
> > > >> write caching disabled. I didn't see this ever occur again.
> > > >
> > > >Awesome, good to know.
> > > >
> > > >> But as written above, I had bad RAM, and meanwhile upgraded to kernel
> > > >> 6.1, and had no issues since with bcache even on power loss.
> > > >>
> > > >> > Coly, is there already a patch to prevent complete dirty cache loss?
> > > >>
> > > >> This is probably still an issue. The cache attachment MUST NEVER EVER
> > > >> automatically degrade to "none" which it did for my fail-cases I had
> > > >> back then. I don't know if this has changed meanwhile.
> > > >
> > > >I would rather that bcache went to a read-only mode in failure
> > > >conditions like this.  Maybe write-around would be acceptable since
> > > >bcache returns -EIO for any failed dirty cache reads.  But if the cache
> > > >is dirty, and it gets an error, it _must_never_ read from the bdev, which
> > > >is what appears to happens now.
> > > >
> > > >Coly, Mingzhe, would this be an easy change?
> > >
> > > First of all, we have never had this problem. We have had an nvme
> > > controller failure, but at this time the cache cannot be read or
> > > written, so even unregister will not succeed.
> > >
> > > Coly once replied like this:
> > >
> > > """
> > > There is an option to panic the system when cache device failed. It
> > > is in errors file with available options as "unregister" and "panic".
> > > This option is default set to "unregister", if you set it to "panic"
> > > then panic() will be called.
> > > """
> > >
> > > I think "panic" is a better way to handle this situation. If cache
> > > returns an error, there may be more unknown errors if the operation
> > > continues.
> >
> > Depending on how the block devices are stacked, the OS can continue if
> > bcache fails (eg, bcache under raid1, drbd, etc).  Returning IO requests
> > with -EIO or setting bcache read-only would be better, because a panic
> > would crash services that could otherwise proceed without noticing the
> > bcache outage.
> >
> > If bcache has a critical failure, I would rather that it fail the IOs so
> > upper-layers in the block stack can compensate.
> >
> > What if we extend /sys/fs/bcache/<uuid>/errors to include a "readonly"
> > option, and make that the default setting?  The gendisk(s) for related
> > /dev/bcacheX devices can be flagged BLKROSET in the error handler:
> >         https://patchwork.kernel.org/project/dm-devel/patch/20201129181926.897775-2-hch@lst.de/
> >
> > This would protect the data and keep the host online.
> >
> > --
> > Eric Wheeler
> >
> >
> >
> > >
> > > >
> > > >Here are the relevant bits:
> > > >
> > > >The allocator called btree_mergesort which called bch_extent_invalid:
> > > >     https://elixir.bootlin.com/linux/latest/source/drivers/md/bcache/extents.c#L480
> > > >
> > > >Which called the `cache_bug` macro, which triggered bch_cache_set_error:
> > > >     https://elixir.bootlin.com/linux/v6.5/source/drivers/md/bcache/super.c#L1626
> > > >
> > > >It then calls `bch_cache_set_unregister` which shuts down the cache:
> > > >     https://elixir.bootlin.com/linux/v6.5/source/drivers/md/bcache/super.c#L1845
> > > >
> > > >     bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...)
> > > >     {
> > > >             ...
> > > >             bch_cache_set_unregister(c);
> > > >             return true;
> > > >     }
> > > >
> > > >Proposed solution:
> > > >
> > > >What if, instead of bch_cache_set_unregister() that this was called instead:
> > > >     SET_BDEV_CACHE_MODE(&c->cache->sb, CACHE_MODE_WRITEAROUND)
> > >
> > > If cache_mode can be automatically modified, when will it be restored
> > > to writeback? I think we need to be able to enable or disable this.
> > >
> > > >
> > > >This would bypass the cache for future writes, and allow reads to
> > > >proceed if possible, and -EIO otherwise to let upper layers handle the
> > > >failure.
> > > >
> > > >What do you think?
> > >
> > > If we switch to writearound mode, how to ensure that the IO is read-only,
> > > because writing IO may require invalidating dirty data. If the backing
> > > write is successful but invalid fails, how should we handle it?
> > >
> > > Maybe "panic" could be the default option. What do you think?
> > >
> > > >
> > > >> But because bcache explicitly does not honor write-barriers from
> > > >> upstream writes for its own writeback (which is okay because it
> > > >> guarantees to write back all data anyways and give a consistent view to
> > > >> upstream FS - well, unless it has to handle write errors), the backed
> > > >> filesystem is guaranteed to be effed up in that case, and allowing it to
> > > >> mount and write because bcache silently has fallen back to "none" will
> > > >> only make the matter worse.
> > > >>
> > > >> (HINT: I never used brbd personally, most of the following is
> > > >> theoretical thinking without real-world experience)
> > > >>
> > > >> I see that you're using drbd? Did it fail due to networking issues?
> > > >> I'm pretty sure it should be robust in that case but maybe bcache
> > > >> cannot handle the situation? Does brbd have a write log to replay
> > > >> writes after network connection loss? It looks like it doesn't and
> > > >> thus bcache exploded.
> > > >
> > > >DRBD is _above_ bcache, not below it.  In this case, DRBD hung because
> > > >bcache hung, not the other way around, so DRBD is not the issue here.
> > > >Here is our stack:
> > > >
> > > >bcache:
> > > >     bdev:     /dev/sda hardware RAID5
> > > >     cachedev: LVM volume from /dev/md0, which is /dev/nvme{0,1} RAID1
> > > >
> > > >And then bcache is stacked like so:
> > > >
> > > >        bcache <- dm-thin <- DRBD <- dm-crypt <- KVM
> > > >                              |
> > > >                              v
> > > >                         [remote host]
> > > >
> > > >> Anyways, since your backing device seems to be on drbd, using metadata
> > > >> allocation hinting is probably no option. You could of course still use
> > > >> drbd with bcache for metadata hinted partitions, and then use
> > > >> writearound caching only for that. At least, in the fail-case, your
> > > >> btrfs won't be destroyed. But your data chunks may have unreadable files
> > > >> then. But it should be easy to select them and restore from backup
> > > >> individually. Btrfs is very robust for that fail case: if metadata is
> > > >> okay, data errors are properly detected and handled. If you're not using
> > > >> btrfs, all of this doesn't apply ofc.
> > > >>
> > > >> I'm not sure if write-back caching for drbd backing is a wise decision
> > > >> anyways. drbd is slow for writes, that's part of the design (and no
> > > >> writeback caching could fix that).
> > > >
> > > >Bcache-backed DRBD provides a noticable difference, especially with a
> > > >10GbE link (or faster) and the same disk stack on both sides.
> > > >
> > > >> I would not rely on bcache-writeback to fix that for you because it is
> > > >> not prepared for storage that may be temporarily not available
> > > >
> > > >True, which is why we put drbd /on top/ of bcache, so bcache is unaware of
> > > >DRBD's existence.
> > > >
> > > >> iow, it would freeze and continue when drbd is available again. I think
> > > >> you should really use writearound/writethrough so your FS can be sure
> > > >> data has been written, replicated and persisted. In case of btrfs, you
> > > >> could still split data and metadata as written above, and use writeback
> > > >> for data, but reliable writes for metadata.
> > > >>
> > > >> So concluding:
> > > >>
> > > >> 1. I'm now persisting metadata directly to disk with no intermediate
> > > >> layers (no bcache, no md)
> > > >>
> > > >> 2. I'm using allocation-hinted data-only partitions with bcache
> > > >> write-back, with bcache on mdraid1. If anything goes wrong, I have
> > > >> file crc errors in btrfs files only, but the filesystem itself is
> > > >> valid because no metadata is broken or lost. I have snapshots of
> > > >> recently modified files. I have daily backups.
> > > >>
> > > >> 3. Your problem is that bcache can - by design - detect write errors
> > > >> only when it's too late with no chance telling the filesystem. In that
> > > >> case, writethrough/writearound is the correct choice.
> > > >>
> > > >> 4. Maybe bcache should know if backing is on storage that may be
> > > >> temporarily unavailable and then freeze until the backing storage is
> > > >> back online, similar to how iSCSI handles that.
> > > >
> > > >I don't think "temporarily unavailable" should be bcache's burden, as
> > > >bcache is a local-only solution.  If someone is using iSCSI under bcache,
> > > >then good luck ;)
> > > >
> > > >> But otoh, maybe drbd should freeze until the replicated storage is
> > > >> available again while writing (from what I've read, it's designed to not
> > > >> do that but let local storage get ahead of the replica, which is btw
> > > >> incompatible with bcache-writeback assumptions).
> > > >
> > > >N/A for this thread, but FYI: DRBD will wait (hang) if it is disconnected
> > > >and has no local copy for some reason.  If local storage is available, it
> > > >will use that and resync when its peer comes up.
> > > >
> > > >> Or maybe using async mirroring can fix this for you but then, the mirror
> > > >> will be compromised if a hardware failure immediately follows a previous
> > > >> drbd network connection loss. But, it may still be an issue with the
> > > >> local hardware (bit-flips etc) because maybe just bcache internals broke
> > > >> - Coly may have a better idea of that.
> > > >
> > > >This isn't DRBDs fault since it is above bcache. I wish only address the
> > > >the bcache cache=none issue.
> > > >
> > > >-Eric
> > > >
> > > >>
> > > >> I think your main issue here is that bcache decouples writebarriers
> > > >> from the underlying backing storage - and you should just not use
> > > >> writeback, it is incompatible by design with how drbd works: your
> > > >> replica will be broken when you need it.
> > > >
> > > >
> > > >>
> > > >>
> > > >> > Here is our trace:
> > > >> >
> > > >> > [Sep 6 13:01] bcache: bch_cache_set_error() error on
> > > >> > a3292185-39ff-4f67-bec7-0f738d3cc28a: spotted extent
> > > >> > 829560:7447835265109722923 len 26330 -> [0:112365451 gen 48,
> > > >> > 0:1163806048 gen 3: bad, length too big, disabling caching
> > > >>
> > > >> > [  +0.001940] CPU: 12 PID: 2435752 Comm: kworker/12:0 Kdump: loaded Not tainted 5.15.0-7.86.6.1.el9uek.x86_64-TEST+ #7
> > > >> > [  +0.000301] Hardware name: Supermicro Super Server/H11SSL-i, BIOS 2.4 12/27/2021
> > > >> > [  +0.000809] Workqueue: bcache bch_data_insert_keys
> > > >> > [  +0.000826] Call Trace:
> > > >> > [  +0.000797]  <TASK>
> > > >> > [  +0.000006]  dump_stack_lvl+0x57/0x7e
> > > >> > [  +0.000755]  bch_extent_invalid.cold+0x9/0x10
> > > >> > [  +0.000759]  btree_mergesort+0x27e/0x36e
> > > >> > [  +0.000005]  ? bch_cache_allocator_start+0x50/0x50
> > > >> > [  +0.000009]  __btree_sort+0xa4/0x1e9
> > > >> > [  +0.000109]  bch_btree_sort_partial+0xbc/0x14d
> > > >> > [  +0.000836]  bch_btree_init_next+0x39/0xb6
> > > >> > [  +0.000004]  bch_btree_insert_node+0x26e/0x2d3
> > > >> > [  +0.000863]  btree_insert_fn+0x20/0x48
> > > >> > [  +0.000864]  bch_btree_map_nodes_recurse+0x111/0x1a7
> > > >> > [  +0.004270]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> > > >> > [  +0.000850]  __bch_btree_map_nodes+0x1e0/0x1fb
> > > >> > [  +0.000858]  ? bch_btree_insert_check_key+0x1f0/0x1e1
> > > >> > [  +0.000848]  bch_btree_insert+0x102/0x188
> > > >> > [  +0.000844]  ? do_wait_intr_irq+0xb0/0xaf
> > > >> > [  +0.000857]  bch_data_insert_keys+0x39/0xde
> > > >> > [  +0.000845]  process_one_work+0x280/0x5cf
> > > >> > [  +0.000858]  worker_thread+0x52/0x3bd
> > > >> > [  +0.000851]  ? process_one_work.cold+0x52/0x51
> > > >> > [  +0.000877]  kthread+0x13e/0x15b
> > > >> > [  +0.000858]  ? set_kthread_struct+0x60/0x52
> > > >> > [  +0.000855]  ret_from_fork+0x22/0x2d
> > > >> > [  +0.000854]  </TASK>
> > > >>
> > > >>
> > > >> Regards,
> > > >> Kai
> > > >>
> > >
> > >
> > >
> > >
> > >
> 
--8323328-462103965-1697499498=:25715--

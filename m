Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2681C485F0E
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 04:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiAFDBc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jan 2022 22:01:32 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:32852 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241687AbiAFDAW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jan 2022 22:00:22 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 7869049;
        Wed,  5 Jan 2022 19:00:21 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 50baReEubkwS; Wed,  5 Jan 2022 19:00:17 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id C647E39;
        Wed,  5 Jan 2022 19:00:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net C647E39
Date:   Wed, 5 Jan 2022 19:00:14 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Kai Krakow <kai@kaishome.de>
cc:     =?ISO-8859-2?Q?Tobiasz_Karo=F1?= <unfa00@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how
 to clear?
In-Reply-To: <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
Message-ID: <1e5966aa-602d-56e2-d83c-d78433345cf5@ewheeler.net>
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com> <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2088935010-1641438016=:4450"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2088935010-1641438016=:4450
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 23 Nov 2021, Kai Krakow wrote:

> Hello Tobiasz!
> 
> Am Di., 23. Nov. 2021 um 15:48 Uhr schrieb Tobiasz Karoń <unfa00@gmail.com>:
> >
> > Hi!
> >
> > TL;DR
> >
> > My cache is inconsistent, and that's probably preventing Bcache for m
> > using it (all I/O goes to the backing device). How can I clear that?
> 
> I've had a similar problem after bcache crashed due to a bug in the
> latest kernel.
> 
> I could resolve it by the following steps (I think you figure out what
> the PLACEHOLDERS mean):
> 
> For each backend device, set the cache_mode to none and detach it:
> 
> # echo none >/sys/block/BDEV/BPART/bcache/cache_mode
> # echo 1 >/sys/block/BDEV/BPART/bcache/detach
> 
> Unregister the cache and re-create it (4096 works around the kernel
> bug, also, it's potentially broken, so re-create):
> 
> # echo 1 >/sys/fs/bcache/CSETUUID/unregister
> # bcache make -C -w 4096 -l LABEL --force /dev/CPART

I didn't know the cache could be formated with -w 4096.  Isn't that for 
the bdev?  If not, then beware of the 4Kn bcache bug that is floating 
around.  Not sure if -w 4096 on a cachedev would hit that or not...

-Eric

> 
> Re-attach the devices and set cache mode:
> 
> # echo NEW_CSETUUID >/sys/block/BDEV/BPART/bcache/attach
> # echo writearound >/sys/block/BDEV/BPART/bcache/cache_mode
> 
> I'm explicitly using writearound for btrfs because:
> 
> * writethrough would write data potentially relocated by COW
> * writeback potentially destroys btrfs on unexpected bcache failures
> * the performance difference between writeback and writearound for
> btrfs is virtually non-existent
> 
> However, writearound will cache only reads, that means boot-time
> improvements will lag one boot behind: During the first boot, bcache
> will read btrfs and cache the reads, on the next boot, it will read
> the cached data. Using writethrough could work around that but that's
> not really useful with a COW filesystem because btrfs relocated
> extents on each and every tiny write - making any cached data stale
> and thus occupy bcache space for no reason. So it will also amplify
> writes to the SSD for no real reason.
> 
> Youtube:
> 
> The problem you see and documented is exactly what happened to me (but
> on Gentoo: system froze, reboot hung, rescue disk said: cache disabled
> with a similar message), and you can work around it by using blocksize
> 4096 - and in any case it still happens: Do NOT use writeback caching,
> use writearound as mentioned above, then at least it won't destroy
> btrfs and it's a matter of re-creating the cache as outlined above.
> 
> HTH
> Kai
> 
> 
> > Details:
> >
> > I've been using Bcache for the past few months on my root Btrfs
> > filesystem with success.
> > Then one day out of the blue Bcache failed and took my Btrfs
> > filesystem with it (details:
> > https://www.youtube.com/watch?v=Hf3zr6CxvmI, looks similar to this:
> > https://stackoverflow.com/questions/22820492/how-to-revert-bcache-device-to-regular-device).
> > That's not the topic of my message though.
> > I've done a clean Arch Linux installation on Bcache + Btrfs once again
> > using an SSD partition for cache and an HDD as the backing device.
> >
> > However, this time it doesn't do anything...
> > I was unable to find any information online to solve this.
> >
> > My Bcache device works fine, the system boots off of it. However all
> > I/O goes straight to the backing HDD, and the SSD is unused. Needless
> > to say this means the performance is not what I got used to when
> > Bcache was working fine.
> >
> > Here's what a 3rd party bcache-status script says (it'd be great if
> > bcache-tools would provide something like this, BTW):
> >
> > ❯ bcache-status
> > --- bcache ---
> > Device                      ? (?)
> > UUID                        c9cd8259-3cee-42ff-a8ec-e11193c09b7e
> > Block Size                  0.50KiB
> > Bucket Size                 512.00KiB
> > Congested?                  False
> > Read Congestion             2.0ms
> > Write Congestion            20.0ms
> > Total Cache Size            173.97GiB
> > Total Cache Used            8.70GiB     (5%)
> > Total Cache Unused          165.27GiB   (95%)
> > Dirty Data                  0.50KiB     (0%)
> > Evictable Cache             173.97GiB   (100%)
> > Replacement Policy          [lru] fifo random
> > Cache Mode                  (Unknown)
> > Total Hits                  0
> > Total Misses                0
> > Total Bypass Hits           0
> > Total Bypass Misses         0
> > Total Bypassed              0B
> >
> > The Total Cache Used value has not changed since I've done my initial
> > Arch Linux installation. It seems that Bcache has "turned off" by that
> > point.
> >
> > Here's the bcache supers fro the backing device and cache
> >
> > ❯ bcache-super-show /dev/sda
> > sb.magic                ok
> > sb.first_sector         8 [match]
> > sb.csum                 4E6EACCA74AB0AE5 [match]
> > sb.version              1 [backing device]
> >
> > dev.label               unfa-desktop%20root
> > dev.uuid                49202fdf-fbe5-48fd-bdd8-df5414da817c
> > dev.sectors_per_block   8
> > dev.sectors_per_bucket  1024
> > dev.data.first_sector   16
> > dev.data.cache_mode     0 [writethrough]
> > dev.data.cache_state    3 [inconsistent]
> >
> > cset.uuid               9572380e-8e6f-4ce4-8323-80b98a85eeed
> >
> > ❯ bcache-super-show /dev/sdd3
> > sb.magic                ok
> > sb.first_sector         8 [match]
> > sb.csum                 259C90FD74B4D4BE [match]
> > sb.version              3 [cache device]
> >
> > dev.label               (empty)
> > dev.uuid                95c6449a-03b5-40f2-a8cc-80b1b61c5ef0
> > dev.sectors_per_block   1
> > dev.sectors_per_bucket  1024
> > dev.cache.first_sector  1024
> > dev.cache.cache_sectors 364833792
> > dev.cache.total_sectors 364834816
> > dev.cache.ordered       yes
> > dev.cache.discard       no
> > dev.cache.pos           0
> > dev.cache.replacement   0 [lru]
> >
> > cset.uuid               c9cd8259-3cee-42ff-a8ec-e11193c09b7e
> >
> > BTW - I've now realized I've set a label for the backing device but
> > not the cache. maybe this is the reason? I don't think it should work
> > this way but I've cleared the label on my backing device just to be
> > sure.
> >
> > Hmm. The cache in inconsistent. I had this before I reinstalled my OS.
> > I have recreated the bcache cache on the SSD and was hoping that will
> > solve it.
> > I don't know what I should do with this, is this the  reason why it's
> > not working?
> >
> > I was wondering if washing the partition and recreating the cache
> > would help, but I don't want to needlessly wear down the SSD if that
> > won't help.
> >
> > Needless to say I would really like to avoid data loss when using
> > Bcache - it's awesome, and the developer says it's perfectly stable
> > and safe, but I've had a sudden failure and others had such as well
> > (without seeing any hardware issues that could be causing that). Maybe
> > I should quit using Bcache all together? Maybe it's not
> > production-ready? I was wondering about maybe using Bcachefs, though
> > the need to compile a custom kernel for it is quite a deterrent. I
> > tried it briefly, but the bcachefs-tools stopped working at some point
> > without a visible reason. I know Btrfs is flawed, though it seems to
> > be the best so far.
> >
> > Thank you for your work,
> > - unfa
> >
> > --
> > - Tobiasz 'unfa' Karoń
> >
> > www.youtube.com/unfa000
> 
--8323328-2088935010-1641438016=:4450--

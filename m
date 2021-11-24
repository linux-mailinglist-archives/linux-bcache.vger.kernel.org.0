Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0FC45C716
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Nov 2021 15:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353608AbhKXOVQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 24 Nov 2021 09:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357550AbhKXOUX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Nov 2021 09:20:23 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D5FC0E4899
        for <linux-bcache@vger.kernel.org>; Wed, 24 Nov 2021 04:41:33 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id q25so5163184oiw.0
        for <linux-bcache@vger.kernel.org>; Wed, 24 Nov 2021 04:41:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ipy7oa1mL707eyY3xGvIagjxH74GnN1FUvan7vfhYes=;
        b=plsGPacVlF6UDpeFQhuqO9Xh6N1AwyYGkWxTKfhB6K1vZlOKGn/dl/sqljXUquuZt0
         I81iWxnunL8vvlje/O1PNjkid8AlwsoJUUgpOB0WDs0kuWCpE4jSEspKuicL/FprgKPN
         zD9fafLT41t7ZVEHwcFTrFZu//vBXhPOu0lodF7SSfnornYSKVz92pyt82v5Dg/Os0O5
         Vi6KwPSXq4PkD8TBFT6iSksT38F37HmmVq+HLU6V23yCoCrnH4TlY2CeS/DcBkFAh7sm
         qvLNOKvZp7ITXk+mEVit11LrgTS2bkoPQsImQ9CXP1IYfU/YBhJKjO5PbLKMUgw73eVP
         TOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ipy7oa1mL707eyY3xGvIagjxH74GnN1FUvan7vfhYes=;
        b=f1BVoSZpLIyr+8g9cmDyy5bjJB5O5u0TerGM08NzdIV6jBYh0ADWsFC7G+UW9K6Fwd
         61aWf1AyF9bK1kbEwyshL58qAuqBmKlIivuc+4mtfFII+xU+pTsb7nWQrNsLZhTvJ2bH
         zbZknnmPMbSC8jWH/se+rF1uqPH4HWz5NhjG05US72EFEV1tM0aR1BDnPlRp3R8PLV+l
         snwsNmFjx0Do8a63v7/A7Z0ee3oZcPqTpCXM1h4e26Duk5wQWil06hKzyX8nLkJtoG28
         ruJPo4sDLLs+iCrgfwNqAmQT4EVczB65KJwYzrdsp2alMNcrDws+No8lVIivV0s80PIG
         2+hQ==
X-Gm-Message-State: AOAM532j96APoSX45jgvxJlxvgM0LuFCTtpIRGF9i7dwsgKFN5Ef9ISD
        Bg9voEXb7AbBudU2QvvOd8WWCNRw8CCiNPREiGr7W8sAuUM=
X-Google-Smtp-Source: ABdhPJzEmC8iFCEDxnpMCEolL2HXL4Tqm5pDcpShoHy487ZAUAHT515CPji9ItRRPAAFNp+sTeGnYZ1nFRGOO8pujSI=
X-Received: by 2002:a05:6808:16ac:: with SMTP id bb44mr5715967oib.122.1637757692557;
 Wed, 24 Nov 2021 04:41:32 -0800 (PST)
MIME-Version: 1.0
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
 <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
 <CAC2ZOYtJXL=WOJ6bLvNNnq7SHzHfmzt6AkOSR1m=g95hrggP4w@mail.gmail.com>
 <CAOsCCbM04NjDR67uZpxz6JC2Tx5a-_eVjvwMnhhyJADGccuqOw@mail.gmail.com> <CAC2ZOYtZhYMk9XrSnLz04sEB_tCOeYWT0B13XLZpbe9d7Do12A@mail.gmail.com>
In-Reply-To: <CAC2ZOYtZhYMk9XrSnLz04sEB_tCOeYWT0B13XLZpbe9d7Do12A@mail.gmail.com>
From:   =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Date:   Wed, 24 Nov 2021 13:41:20 +0100
Message-ID: <CAOsCCbMQk4BN03OuwWX5jOYuJBWiwiT2x3GLHX2=zN7eQ_rOxQ@mail.gmail.com>
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     Kai Krakow <kai@kaishome.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

=C5=9Br., 24 lis 2021 o 06:36 Kai Krakow <kai@kaishome.de> napisa=C5=82(a):
>
> Hello!
>
> Am Di., 23. Nov. 2021 um 23:34 Uhr schrieb Tobiasz Karo=C5=84 <unfa00@gma=
il.com>:
> >
> > Thank you for your detailed reply and sharing your experience and solut=
ion.
> >
> > So it seems Bcache and Btrfs are fundamentally incompatible when it
> > comes to caching writes? It has worked fine for 2 months, and then it
> > just imploded. I'll stay in writearound mode to be safe.
>
> No, they are not fundamentally incompatible but losing writeback data
> on btrfs is much more a visible catastrophic event than to other file
> systems (which write data in-place when btrfs writes cow).
My issue with Btrfs is - it seems to become trashed very easily. I
would expect a COW filesystem to be much more resilient to various
errors. It seems to me that sometimes a single bad sector can make the
filesystem unmountable and unrecoverable. Maybe I am just not handling
such events properly I've definitely made mistakes in the past
(sometimes due to not enough spares to do images before messing around
- not gonna do that again).
>
> Even with other filesystems and bcache destroying itself in writeback
> mode would cause severe damage of your filesystem (on classical
> filesystem, usually you end up with garbled files having partially old
> and new data, maybe some fixable metadata errors) - BUT: it is still a
> catastrophic event, maybe even more so because data loss could go
> silent, ending up in your backups, only to find later that you're
> missing data that has already been rotated out of the backup.
>
> Don't use writeback if you cannot afford to recover from backup when
> writeback fails. That's a property of how caching works, not a
> property of btrfs or bcache. It's the same for any writeback cache you
> might be using: RAID-controllers come with writeback caches, and
> decide to throw it away sometimes, leaving you with destroyed
> filesystems, so you usually turn that off unless your workload
> requires it and you can afford to throw lost data away). That doesn't
> make them fundamentally incompatible with filesystems, right? Your HDD
> comes with write caches which may destroy your filesystem, too, on
> power-loss. You might want to turn that off, especially when using
> btrfs (but also for better write latency behavior, and the kernel has
> better IO scheduling anyways than the really small writecaches of
> HDDs): `hdparm -W0 /dev/HDDDEV`. HDD write caches are only useful for
> operating systems that do no proper write ordering/merging (usually
> DOS, and maybe Windows), and sometimes HDD firmwares are buggy and
> cannot use async queueing, when write caches may improve performance a
> lot. But usually, you want to keep that setting off. That becomes even
> more important when you use bcache in writeback mode (because HDD
> write caching may then break assumptions of bcache).

I've found out that hard drives I am using have a firmware bug that
can corrupt data when using write cache:
https://www.reddit.com/r/linux/comments/c59nry/btrfs_vs_write_caching_firmw=
are_bugs_tldr_some/es1krq2/

I'm going to disable write cache on all of these drives. This could
explain some spontaneous collapses of Btrfs and Bcache on my system in
the past. But again: I'd expect a COW filesystem to be able to recover
from incomplete writes. I've been using Btrfs for about 3-4 years now.
Maybe I just don't know how to handle issues...

I wonder if there's an option fro me to update the firmware on my
existing drives without booting into Windows.
it seems that *some* HDD manufacturers have easy tools for Linux to do
that, but I don't know what they are, as that was redacted:
https://forum.corsair.com/forums/topic/77369-flashing-firmware-with-linux-h=
dparm-command/

I see that hdparm has an option called --fwdownload, thought  I'd
certainly not try that without being absolutely sure it'll work.

>
> > I've checked and my cache device has a block size of 512 bytes.
>
> Yep, all my bcache systems using 512 bytes are affected by that 5.15.2
> kernel bug. Use 4k and you should be okay. The problem seems to come
> from page-unaligned writes - and using 4k (the page size of your CPU)
> seems to work around that. Kernel 5.15.3 has the most part of the fix,
> another fix is queued for one of the next releases. Another lesson
> learned: Don't use a new kernel until it's in its x.y.{4,5,6}
> releases. This is not the first time I had catastrophic events with
> kernels in their infancy. That's why I usually avoid .0 and .1
> kernels. Seems I should add .2 and .3 kernels to that list, too. Never
> do a major kernel upgrade without creating a full backup first. Kernel
> components like bcache are much less well-tested than other
> components, so they likely break on early kernel releases for some
> exotic use-cases (exotic because nobody who cares about their data
> uses writeback).
I'm at kernel 5.15.3 right now. I think Arch Linux ships kernel
updates after they reach .3. The 5.15 came out like 2 weeks ago.

>
> > That's
> > a strange value, as the backing device is a AF HDD (like all of them
> > in the past decade or more), so the block size should be 4Kb.
> > I guess this also works until it doesn't.
>
> You won't have catastrophic events with writearound - and that's as
> good as writeback on btrfs (and even better because it won't destroy
> the filesystem in case of a cache hiccup). Bcache can break for any
> reason, due to bugs, like any other kernel component. And bcache in
> writeback mode usually means catastrophic results for ANY file system
> attached to it - where btrfs is just much more likely to detect those
> events. Even if you COULD repair the file system logical structure, it
> still means some data wasn't written - btrfs just has a much better
> understanding about what should be on the disk while other filesystems
> silently accept the data loss after recovering from structural errors.
> BTW: 4k should be safe, there's another problem in bcache unrelated to
> this which still needs fixing.
>
> > Can I destroy and recreate the cache device on a live system (my root
> > filesystem is on this bcache set). I guess I can't.
>
> Yes, you can. Detaching the cache makes the backing devices pass
> through, they are still available as /dev/bcache* even with no caching
> device.
>
> > This is probably what I've done wrong today - I did
> > not unregister the whole cset before attempting to recreate the cache
> > device.
>
> Okay, unregistering should be quite essential but you don't need to
> reboot. Also, I recommend using a new cset UUID so it cannot conflict
> with any stale data that MAY be stored in the cache.
Yeah, I used existing cset UUID. That has probably caused bcache to
write garbage and corrupt the cache...
>
> > I am honestly a little afraid to touch it, after what happened.
>
> Well, the cache backend is stopped or detached - it doesn't matter
> anyways. Just don't use writeback for the next couple of kernel
> releases (or maybe rather avoid it for the future completely).
> Writeback really doesn't gain you a lot on btrfs because due to COW,
> btrfs is already quite good writing (because writes are usually going
> to be sequential anyways), and it has become a lot better during the
> last few kernel release cycles. I've been using writeback for a long
> time now but this is just another occasion why I should not have been
> using writeback but writearound instead (the other one being that
> sometimes on boot, my SSD detaches from the bus, making bcache throw
> away all writeback data and leaving me with a destroyed filesystem).

Ok, I've booted into a live ISO and recreated the cache with 4K
blocks. I hope it's gonna spare me some adventures in the future.

>
> > I hope Bcachefs will eliminate these problems and provide a stable
> > unified solution.
>
> You're swapping one "experimental" FS (btrfs) which has matured great
> ways during at least the last 5 years with another experimental
> filesystem which is not yet battle-tested and performance-tuned.
> bcachefs and bcache are two completely distinctive products with
> different use-cases, they only share a similar name because the
> fundamental inner structures are based on the same code and idea (and
> probably because the author thought it's cool).
Yeah, honestly I wish he renamed Bcachefs to something shorter.
Anyway - I'm not gonna use it until it reaches mainline kernel, and
then still only for experiments, not for production.

>
> I'm not sure if you use device pooling with btrfs (multiple disks) but
> for my system, it showed useful to NOT use RAID-0 for btrfs data, it's
> actually slower in normal desktop use and the way how btrfs internally
> distributes data access across devices. I found that using single-data
> mode even with multidisk has better write behavior and better read
> latency, and it makes better use of bcache. So maybe its worth a try
> if you fear that using writearound mode could degrade your system
> responsiveness too much.
I am not using multiple devices in a single Btrfs filesystem at the moment.
I assumed using 2 drives in RAID1 would double the read speed (on
large files) since the extents can be read from two disks at once.
It's strange that it doesn't work like that...

>
> > Take care
> > - unfa
>
> Good luck
> Kai

Thank you so much for your insight!
That's all invaluable information you're sharing.

I hope these messages are going to be available publicly in some
mailing list archive for future reference when I inevitably encounter
the same problems in 5 years after I forgot what it was all about...

Thank you!
- unfa

>
>
> > wt., 23 lis 2021 o 18:40 Kai Krakow <kai@kaishome.de> napisa=C5=82(a):
> > >
> > > Oops:
> > >
> > > > # echo 1 >/sys/fs/bcache/CSETUUID/unregister
> > > > # bcache make -C -w 4096 -l LABEL --force /dev/BPART
> > >
> > > CPART of course!
> > >
> > > # bcache make -C -w 4096 -l LABEL --force /dev/CPART
> > >
> > > Bye
> > > Kai
> >
> >
> >
> > --
> > - Tobiasz 'unfa' Karo=C5=84
> >
> > www.youtube.com/unfa000



--=20
- Tobiasz 'unfa' Karo=C5=84

www.youtube.com/unfa000

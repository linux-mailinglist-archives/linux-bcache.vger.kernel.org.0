Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BAD45C779
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Nov 2021 15:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353820AbhKXOgf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 24 Nov 2021 09:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356187AbhKXOg2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Nov 2021 09:36:28 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC29C1A4417
        for <linux-bcache@vger.kernel.org>; Wed, 24 Nov 2021 05:24:52 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id f9so7229571ybq.10
        for <linux-bcache@vger.kernel.org>; Wed, 24 Nov 2021 05:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vs/YDvTboYHa+PYsQNM0bUGKEi99ebPuL8Pt9yRz5Tg=;
        b=f/g4Xs8v/9N8jmEB9vS4jWHJURb45fyp2F8LVeE83zdJfsog1/Fj0RKWsVbRp7A9WR
         HV3XJNwxY9gBAfU3Dx7CRPA+93/1BqqlW19dBzeDcXi/ldUzTOqujhuTQp4DEa86pQUm
         IC6E7iJB5BbyZLZmpP0lOA7Aqt9wec6lNSI4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vs/YDvTboYHa+PYsQNM0bUGKEi99ebPuL8Pt9yRz5Tg=;
        b=tqsdb37vn+0oGIM3n3JqRXzmc1NysDR34QdzujqmMUuMhZpS/6PjNm/0fYQBfQBP4v
         du9ALUzEYzsXx9WeUPHeQQFc37n0/5VbOZTJ4GEDp6ORtvWdrJ6uZMshbct/wzDr/ero
         ZfFhxy+7dG2YRP98I3VFNr6q5BO5oMlOviR6/DpoEhfju8g5oDOwZhGVkEE78tY5HADQ
         VY/ZYtYqvBM6vLevOiM2zDSqBiK6Waw4aa+A8lutrxr88HTQ3ukMvV66Tagzdinv7l42
         PE8uRNQu5AeOgxfAObW8P7SB3rEYLQ7QjLZlGPJnG7nY4whntpkEqngMhJVK/Vzzd4b5
         l4ZA==
X-Gm-Message-State: AOAM531xT9wz1Ru0lHN/uzc3Xd7TMA/SIP0Pz+EnIE15Geht5Gk4aUiM
        HK2ITVr6NPyeaxPbLCg02IFITR/kS0RLAbgB3n0tOg==
X-Google-Smtp-Source: ABdhPJzaj3BPJ17lfM+5cmcOxbQUTxFj8H9hiLKyTIrJt3XlTG8/p5eZ6hNeNxKb82FYSLQMb4tk/vLiKMAB1IX4DH0=
X-Received: by 2002:a25:bbc4:: with SMTP id c4mr17664553ybk.309.1637760291465;
 Wed, 24 Nov 2021 05:24:51 -0800 (PST)
MIME-Version: 1.0
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
 <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
 <CAC2ZOYtJXL=WOJ6bLvNNnq7SHzHfmzt6AkOSR1m=g95hrggP4w@mail.gmail.com>
 <CAOsCCbM04NjDR67uZpxz6JC2Tx5a-_eVjvwMnhhyJADGccuqOw@mail.gmail.com>
 <CAC2ZOYtZhYMk9XrSnLz04sEB_tCOeYWT0B13XLZpbe9d7Do12A@mail.gmail.com> <CAOsCCbMQk4BN03OuwWX5jOYuJBWiwiT2x3GLHX2=zN7eQ_rOxQ@mail.gmail.com>
In-Reply-To: <CAOsCCbMQk4BN03OuwWX5jOYuJBWiwiT2x3GLHX2=zN7eQ_rOxQ@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 24 Nov 2021 14:24:39 +0100
Message-ID: <CAC2ZOYt8mYW6e4ehUgp2Xxzd4p+UPbR+J6KUFoC1dHds9Va6Hg@mail.gmail.com>
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hey there!

Am Mi., 24. Nov. 2021 um 13:41 Uhr schrieb Tobiasz Karo=C5=84 <unfa00@gmail=
.com>:
>
> =C5=9Br., 24 lis 2021 o 06:36 Kai Krakow <kai@kaishome.de> napisa=C5=82(a=
):
> >
> > Hello!
> >
> > Am Di., 23. Nov. 2021 um 23:34 Uhr schrieb Tobiasz Karo=C5=84 <unfa00@g=
mail.com>:
> > >
> > > Thank you for your detailed reply and sharing your experience and sol=
ution.
> > >
> > > So it seems Bcache and Btrfs are fundamentally incompatible when it
> > > comes to caching writes? It has worked fine for 2 months, and then it
> > > just imploded. I'll stay in writearound mode to be safe.
> >
> > No, they are not fundamentally incompatible but losing writeback data
> > on btrfs is much more a visible catastrophic event than to other file
> > systems (which write data in-place when btrfs writes cow).
> My issue with Btrfs is - it seems to become trashed very easily. I
> would expect a COW filesystem to be much more resilient to various
> errors. It seems to me that sometimes a single bad sector can make the
> filesystem unmountable and unrecoverable.

This should not happen, at least not when you're using dup or raid-1
for metadata. You should really use dup metadata on a single drive
(and probably you do because it's default).

OTOH, when you HDD has write caching enabled it MAY decouple reporting
of IO errors from actual write errors (write behind mode), that is, if
the drive reports data as written when it hit the cache, and later the
data cannot be written, a filesystem is actually already broken before
it could take notice. That's one failure mode but that should actually
not exist with modern drives that support write barriers (i.e., the
filesystem waits for cached writes to complete successfully). But
firmware bugs may apply here and break that assumption.

> Maybe I am just not handling
> such events properly I've definitely made mistakes in the past
> (sometimes due to not enough spares to do images before messing around
> - not gonna do that again).
> >
> > Even with other filesystems and bcache destroying itself in writeback
> > mode would cause severe damage of your filesystem (on classical
> > filesystem, usually you end up with garbled files having partially old
> > and new data, maybe some fixable metadata errors) - BUT: it is still a
> > catastrophic event, maybe even more so because data loss could go
> > silent, ending up in your backups, only to find later that you're
> > missing data that has already been rotated out of the backup.
> >
> > Don't use writeback if you cannot afford to recover from backup when
> > writeback fails. That's a property of how caching works, not a
> > property of btrfs or bcache. It's the same for any writeback cache you
> > might be using: RAID-controllers come with writeback caches, and
> > decide to throw it away sometimes, leaving you with destroyed
> > filesystems, so you usually turn that off unless your workload
> > requires it and you can afford to throw lost data away). That doesn't
> > make them fundamentally incompatible with filesystems, right? Your HDD
> > comes with write caches which may destroy your filesystem, too, on
> > power-loss. You might want to turn that off, especially when using
> > btrfs (but also for better write latency behavior, and the kernel has
> > better IO scheduling anyways than the really small writecaches of
> > HDDs): `hdparm -W0 /dev/HDDDEV`. HDD write caches are only useful for
> > operating systems that do no proper write ordering/merging (usually
> > DOS, and maybe Windows), and sometimes HDD firmwares are buggy and
> > cannot use async queueing, when write caches may improve performance a
> > lot. But usually, you want to keep that setting off. That becomes even
> > more important when you use bcache in writeback mode (because HDD
> > write caching may then break assumptions of bcache).
>
> I've found out that hard drives I am using have a firmware bug that
> can corrupt data when using write cache:
> https://www.reddit.com/r/linux/comments/c59nry/btrfs_vs_write_caching_fir=
mware_bugs_tldr_some/es1krq2/
>
> I'm going to disable write cache on all of these drives.

You probably should do that anyways if your drive properly supports
NCQ with a queue depth greater than maybe 30? The thing is, there are
drives with a queue depth of only 1 or 2, and those will be slow
without write caching.

Write caching in the drive without BBU isn't a stable operation mode:
When you lose power, you've lost data.

> This could
> explain some spontaneous collapses of Btrfs and Bcache on my system in
> the past.

Yes, definitely!

> But again: I'd expect a COW filesystem to be able to recover
> from incomplete writes. I've been using Btrfs for about 3-4 years now.
> Maybe I just don't know how to handle issues...

No, this is probably and incomplete understanding of how btrfs
operates: btrfs CAN and DOES fix single write errors no problems at
all, that is, it detects wrong writes. And it can also handle
incomplete write AS LONG AS those missing writes are the end of the
transaction. BUT for btrfs to provide that stability it REALLY needs
the storage to preserve the order of transactions.

bcache does not do this: With writeback caching, it completely ignores
orders of transactions for writeback. It still ensures it ABOVE it
(where btrfs lives), that is if it reports data to be persisted, it's
persisted in the cache, and it guarantees data will eventually be
persisted back to backend storage. But BELOW it (where the backend
storage lives) it writes dirty data completely out of transactional
order, it rather reorders written data in order of head positioning.
This is where the speed gain comes from.

But this also means things break in a horrible way if dirty writeback
data is lost: Suddenly, the transactional order ABOVE bcache broke in
horrible ways because potentially much older data hasn't been
persisted yet while newer data has been (as in time travelling back
and revert changed data as if it was never written, if you watched
"Back to the Future" you can imagine the consequences). This
completely destroys the internal block trees of btrfs which depend on
older data written before newer data.

But yes, as a btree filesystem using COW, btrfs is especially
sensitive to such problems while other filesystems would simply see
overwritten data coming partially back from time travel mode, or some
broken metadata which eventually resolves to blocks still existing
blocks, usually resulting in cross-linked files. Often, this is easy
to repair but you end up with "repaired" files having either no
content at all (xfs does that), or the same content (fat does this),
or old content (ext4 may do this due to how its journal works). But
however the content changes, it changes partially, thus usually
breaking applications that stored the data (e.g., databases).
Essentially, it's the same catastrophic problem just you don't notice
then.

> I wonder if there's an option fro me to update the firmware on my
> existing drives without booting into Windows.
> it seems that *some* HDD manufacturers have easy tools for Linux to do
> that, but I don't know what they are, as that was redacted:
> https://forum.corsair.com/forums/topic/77369-flashing-firmware-with-linux=
-hdparm-command/

Most such vendors usually have a Windows-only solution, or a boot CD
(which is usually based on FreeDOS or Linux). You may look into the
enterprise downloads, those usually have Linux tools.

> I see that hdparm has an option called --fwdownload, thought  I'd
> certainly not try that without being absolutely sure it'll work.

I wouldn't... Last time I updated my Samsung or Crucial disk, I
extracted the update tool from the boot CD ISO which I could download
from the firmware update website and used that.

> > > I've checked and my cache device has a block size of 512 bytes.
> >
> > Yep, all my bcache systems using 512 bytes are affected by that 5.15.2
> > kernel bug. Use 4k and you should be okay. The problem seems to come
> > from page-unaligned writes - and using 4k (the page size of your CPU)
> > seems to work around that. Kernel 5.15.3 has the most part of the fix,
> > another fix is queued for one of the next releases. Another lesson
> > learned: Don't use a new kernel until it's in its x.y.{4,5,6}
> > releases. This is not the first time I had catastrophic events with
> > kernels in their infancy. That's why I usually avoid .0 and .1
> > kernels. Seems I should add .2 and .3 kernels to that list, too. Never
> > do a major kernel upgrade without creating a full backup first. Kernel
> > components like bcache are much less well-tested than other
> > components, so they likely break on early kernel releases for some
> > exotic use-cases (exotic because nobody who cares about their data
> > uses writeback).
> I'm at kernel 5.15.3 right now. I think Arch Linux ships kernel
> updates after they reach .3. The 5.15 came out like 2 weeks ago.

In your YT video, it shows 5.15.2...

> > > That's
> > > a strange value, as the backing device is a AF HDD (like all of them
> > > in the past decade or more), so the block size should be 4Kb.
> > > I guess this also works until it doesn't.
> >
> > You won't have catastrophic events with writearound - and that's as
> > good as writeback on btrfs (and even better because it won't destroy
> > the filesystem in case of a cache hiccup). Bcache can break for any
> > reason, due to bugs, like any other kernel component. And bcache in
> > writeback mode usually means catastrophic results for ANY file system
> > attached to it - where btrfs is just much more likely to detect those
> > events. Even if you COULD repair the file system logical structure, it
> > still means some data wasn't written - btrfs just has a much better
> > understanding about what should be on the disk while other filesystems
> > silently accept the data loss after recovering from structural errors.
> > BTW: 4k should be safe, there's another problem in bcache unrelated to
> > this which still needs fixing.
> >
> > > Can I destroy and recreate the cache device on a live system (my root
> > > filesystem is on this bcache set). I guess I can't.
> >
> > Yes, you can. Detaching the cache makes the backing devices pass
> > through, they are still available as /dev/bcache* even with no caching
> > device.
> >
> > > This is probably what I've done wrong today - I did
> > > not unregister the whole cset before attempting to recreate the cache
> > > device.
> >
> > Okay, unregistering should be quite essential but you don't need to
> > reboot. Also, I recommend using a new cset UUID so it cannot conflict
> > with any stale data that MAY be stored in the cache.
> Yeah, I used existing cset UUID. That has probably caused bcache to
> write garbage and corrupt the cache...

Probably not but you never know. Coly may have some insight here. It
usually should be safe to reuse the same UUID after re-formatting the
cache - and it should never ever reach a point to use some stale data.
But if something triggers a bug, there's extra safety now that UUIDs
don't become confused between new and old data.

> > > I am honestly a little afraid to touch it, after what happened.
> >
> > Well, the cache backend is stopped or detached - it doesn't matter
> > anyways. Just don't use writeback for the next couple of kernel
> > releases (or maybe rather avoid it for the future completely).
> > Writeback really doesn't gain you a lot on btrfs because due to COW,
> > btrfs is already quite good writing (because writes are usually going
> > to be sequential anyways), and it has become a lot better during the
> > last few kernel release cycles. I've been using writeback for a long
> > time now but this is just another occasion why I should not have been
> > using writeback but writearound instead (the other one being that
> > sometimes on boot, my SSD detaches from the bus, making bcache throw
> > away all writeback data and leaving me with a destroyed filesystem).
>
> Ok, I've booted into a live ISO and recreated the cache with 4K
> blocks. I hope it's gonna spare me some adventures in the future.

Works for me since a few days now and some heavy workloads - but in
writearound mode... I won't try writeback for a while now.

> > > I hope Bcachefs will eliminate these problems and provide a stable
> > > unified solution.
> >
> > You're swapping one "experimental" FS (btrfs) which has matured great
> > ways during at least the last 5 years with another experimental
> > filesystem which is not yet battle-tested and performance-tuned.
> > bcachefs and bcache are two completely distinctive products with
> > different use-cases, they only share a similar name because the
> > fundamental inner structures are based on the same code and idea (and
> > probably because the author thought it's cool).
> Yeah, honestly I wish he renamed Bcachefs to something shorter.
> Anyway - I'm not gonna use it until it reaches mainline kernel, and
> then still only for experiments, not for production.

Rule of thumb: It usually takes a new filesystem around 10 years to
reach fully stable operation even for corner cases after being
released to the wild. Btrfs is older meanwhile, meaning it should be
rock-solid. Bcachefs will still have to walk that route. I think you
can give it a first production ride after 3 years (not without
backups, tho).

> > I'm not sure if you use device pooling with btrfs (multiple disks) but
> > for my system, it showed useful to NOT use RAID-0 for btrfs data, it's
> > actually slower in normal desktop use and the way how btrfs internally
> > distributes data access across devices. I found that using single-data
> > mode even with multidisk has better write behavior and better read
> > latency, and it makes better use of bcache. So maybe its worth a try
> > if you fear that using writearound mode could degrade your system
> > responsiveness too much.
> I am not using multiple devices in a single Btrfs filesystem at the momen=
t.
> I assumed using 2 drives in RAID1 would double the read speed (on
> large files) since the extents can be read from two disks at once.
> It's strange that it doesn't work like that...

That's due to how btrfs spreads RAID-1 reads across devices: It's
PID-based: every even PID reads one mirror, every odd PID reads the
other - that simple. It usually works well enough and avoids some
pitfalls with alternating between devices too often. Even real
hardware RAID has a stripe size, and you only read from one stripe at
a time, you'll never read from stripes in parallel. Reads become
parallel, when either enough readers read the disks at alternating
stripe sets, or the reads become big enough to span stripe sets.
Something similar will happen for btrfs in the first case but probably
not the latter. In any case, there's never ever a doubling of read
speed, at most you can see a doubling of readers without compromising
speed. That also means that RAID usually makes no sense for desktop
use (there's mostly always just one application accessing data at a
time which makes it difficult to engage all spindles in parallel).

Writes have to go to all spindles in parallel anyways. That's why
single-spindle data for my multi-disk btrfs is faster for me: It has a
higher chance of decoupling readers from writers.

It's not very different from how hardware RAID works, it has about the
same properties. But it may do more intelligent things than PID-based
stripe rotation (similar to how kernel mdraid does it with rotation
based on queue length and avg device response time).


> > > Take care
> > > - unfa
> >
> > Good luck
> > Kai
>
> Thank you so much for your insight!
> That's all invaluable information you're sharing.
>
> I hope these messages are going to be available publicly in some
> mailing list archive for future reference when I inevitably encounter
> the same problems in 5 years after I forgot what it was all about...
>
> Thank you!
> - unfa
>
> >
> >
> > > wt., 23 lis 2021 o 18:40 Kai Krakow <kai@kaishome.de> napisa=C5=82(a)=
:
> > > >
> > > > Oops:
> > > >
> > > > > # echo 1 >/sys/fs/bcache/CSETUUID/unregister
> > > > > # bcache make -C -w 4096 -l LABEL --force /dev/BPART
> > > >
> > > > CPART of course!
> > > >
> > > > # bcache make -C -w 4096 -l LABEL --force /dev/CPART
> > > >
> > > > Bye
> > > > Kai
> > >
> > >
> > >
> > > --
> > > - Tobiasz 'unfa' Karo=C5=84
> > >
> > > www.youtube.com/unfa000
>
>
>
> --
> - Tobiasz 'unfa' Karo=C5=84
>
> www.youtube.com/unfa000

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA3245B400
	for <lists+linux-bcache@lfdr.de>; Wed, 24 Nov 2021 06:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhKXFjK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 24 Nov 2021 00:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhKXFjJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Nov 2021 00:39:09 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E06C061574
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 21:36:00 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id g17so3854545ybe.13
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 21:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iud0nABWTdE+Kjus5egnHZsUe4BHp8W/FwFnaMesjKc=;
        b=OQozEFtuhJ3VJ/kAK4sG9eyN0qyFrMtdV6DD4hcYalizWmNYBFEGfPYF39wKObBVmF
         rFJ89WEcQ9IFGjgiCJci9Kuzub7cFAKFUH1dozEAOORFMSRUKdpcKt6dwxiaGaNql671
         CWECldiLsbDJBh6ukjg2S2rCKymguWbYt9tNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iud0nABWTdE+Kjus5egnHZsUe4BHp8W/FwFnaMesjKc=;
        b=crkUv6q2i836sEvEebD8wSPT40go0/hnM8H+bKKb9O0ACAKiV2gOJAOWx3b0C06OHd
         Ufo4THru0w861xZiuijyRjJWf/TUu/iQmhAsQ55N1kRjYhO+/xETzQVVUXaB3w0MORy8
         vUoqmduVde2xEKg7jZ8odPKaYY4zibVFEAbNMB/I+Z5OPLJKAX9f1Tdd2TIK3ZMkZMrS
         rLp5IrRGQ9i/0t6nahQWRkAlZbqh5wMhP+TLpbmGs1j0XcQKDDQYMRBYNDb+WvUE6em/
         NzS2s6uqgjdvMUzg1d4qb8Tv0cObe6TIqpWo2tij7b3JioxMxWskXm3lc+jJFPvoXgzX
         V/UQ==
X-Gm-Message-State: AOAM5335X7AtVgWWLQ5YjAsDRPgd1aZfLzVckYEPxDOmJgCALKl7SjKJ
        S3l+YGrtLiqWQDWLzCvM0GShyozsahHe0L2wOkxYd4I1d7FMdg==
X-Google-Smtp-Source: ABdhPJzk9FtCpIWE2RtjAtmlz83Amy7Q6s+gTcDGjIvfvHq2GpnhwIeM97/C3gToZNfRVHiRukDNBN2jebX0hsfj9rA=
X-Received: by 2002:a25:bbc4:: with SMTP id c4mr14104074ybk.309.1637732159512;
 Tue, 23 Nov 2021 21:35:59 -0800 (PST)
MIME-Version: 1.0
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
 <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
 <CAC2ZOYtJXL=WOJ6bLvNNnq7SHzHfmzt6AkOSR1m=g95hrggP4w@mail.gmail.com> <CAOsCCbM04NjDR67uZpxz6JC2Tx5a-_eVjvwMnhhyJADGccuqOw@mail.gmail.com>
In-Reply-To: <CAOsCCbM04NjDR67uZpxz6JC2Tx5a-_eVjvwMnhhyJADGccuqOw@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 24 Nov 2021 06:35:48 +0100
Message-ID: <CAC2ZOYtZhYMk9XrSnLz04sEB_tCOeYWT0B13XLZpbe9d7Do12A@mail.gmail.com>
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello!

Am Di., 23. Nov. 2021 um 23:34 Uhr schrieb Tobiasz Karo=C5=84 <unfa00@gmail=
.com>:
>
> Thank you for your detailed reply and sharing your experience and solutio=
n.
>
> So it seems Bcache and Btrfs are fundamentally incompatible when it
> comes to caching writes? It has worked fine for 2 months, and then it
> just imploded. I'll stay in writearound mode to be safe.

No, they are not fundamentally incompatible but losing writeback data
on btrfs is much more a visible catastrophic event than to other file
systems (which write data in-place when btrfs writes cow).

Even with other filesystems and bcache destroying itself in writeback
mode would cause severe damage of your filesystem (on classical
filesystem, usually you end up with garbled files having partially old
and new data, maybe some fixable metadata errors) - BUT: it is still a
catastrophic event, maybe even more so because data loss could go
silent, ending up in your backups, only to find later that you're
missing data that has already been rotated out of the backup.

Don't use writeback if you cannot afford to recover from backup when
writeback fails. That's a property of how caching works, not a
property of btrfs or bcache. It's the same for any writeback cache you
might be using: RAID-controllers come with writeback caches, and
decide to throw it away sometimes, leaving you with destroyed
filesystems, so you usually turn that off unless your workload
requires it and you can afford to throw lost data away). That doesn't
make them fundamentally incompatible with filesystems, right? Your HDD
comes with write caches which may destroy your filesystem, too, on
power-loss. You might want to turn that off, especially when using
btrfs (but also for better write latency behavior, and the kernel has
better IO scheduling anyways than the really small writecaches of
HDDs): `hdparm -W0 /dev/HDDDEV`. HDD write caches are only useful for
operating systems that do no proper write ordering/merging (usually
DOS, and maybe Windows), and sometimes HDD firmwares are buggy and
cannot use async queueing, when write caches may improve performance a
lot. But usually, you want to keep that setting off. That becomes even
more important when you use bcache in writeback mode (because HDD
write caching may then break assumptions of bcache).

> I've checked and my cache device has a block size of 512 bytes.

Yep, all my bcache systems using 512 bytes are affected by that 5.15.2
kernel bug. Use 4k and you should be okay. The problem seems to come
from page-unaligned writes - and using 4k (the page size of your CPU)
seems to work around that. Kernel 5.15.3 has the most part of the fix,
another fix is queued for one of the next releases. Another lesson
learned: Don't use a new kernel until it's in its x.y.{4,5,6}
releases. This is not the first time I had catastrophic events with
kernels in their infancy. That's why I usually avoid .0 and .1
kernels. Seems I should add .2 and .3 kernels to that list, too. Never
do a major kernel upgrade without creating a full backup first. Kernel
components like bcache are much less well-tested than other
components, so they likely break on early kernel releases for some
exotic use-cases (exotic because nobody who cares about their data
uses writeback).

> That's
> a strange value, as the backing device is a AF HDD (like all of them
> in the past decade or more), so the block size should be 4Kb.
> I guess this also works until it doesn't.

You won't have catastrophic events with writearound - and that's as
good as writeback on btrfs (and even better because it won't destroy
the filesystem in case of a cache hiccup). Bcache can break for any
reason, due to bugs, like any other kernel component. And bcache in
writeback mode usually means catastrophic results for ANY file system
attached to it - where btrfs is just much more likely to detect those
events. Even if you COULD repair the file system logical structure, it
still means some data wasn't written - btrfs just has a much better
understanding about what should be on the disk while other filesystems
silently accept the data loss after recovering from structural errors.
BTW: 4k should be safe, there's another problem in bcache unrelated to
this which still needs fixing.

> Can I destroy and recreate the cache device on a live system (my root
> filesystem is on this bcache set). I guess I can't.

Yes, you can. Detaching the cache makes the backing devices pass
through, they are still available as /dev/bcache* even with no caching
device.

> This is probably what I've done wrong today - I did
> not unregister the whole cset before attempting to recreate the cache
> device.

Okay, unregistering should be quite essential but you don't need to
reboot. Also, I recommend using a new cset UUID so it cannot conflict
with any stale data that MAY be stored in the cache.

> I am honestly a little afraid to touch it, after what happened.

Well, the cache backend is stopped or detached - it doesn't matter
anyways. Just don't use writeback for the next couple of kernel
releases (or maybe rather avoid it for the future completely).
Writeback really doesn't gain you a lot on btrfs because due to COW,
btrfs is already quite good writing (because writes are usually going
to be sequential anyways), and it has become a lot better during the
last few kernel release cycles. I've been using writeback for a long
time now but this is just another occasion why I should not have been
using writeback but writearound instead (the other one being that
sometimes on boot, my SSD detaches from the bus, making bcache throw
away all writeback data and leaving me with a destroyed filesystem).

> I hope Bcachefs will eliminate these problems and provide a stable
> unified solution.

You're swapping one "experimental" FS (btrfs) which has matured great
ways during at least the last 5 years with another experimental
filesystem which is not yet battle-tested and performance-tuned.
bcachefs and bcache are two completely distinctive products with
different use-cases, they only share a similar name because the
fundamental inner structures are based on the same code and idea (and
probably because the author thought it's cool).

I'm not sure if you use device pooling with btrfs (multiple disks) but
for my system, it showed useful to NOT use RAID-0 for btrfs data, it's
actually slower in normal desktop use and the way how btrfs internally
distributes data access across devices. I found that using single-data
mode even with multidisk has better write behavior and better read
latency, and it makes better use of bcache. So maybe its worth a try
if you fear that using writearound mode could degrade your system
responsiveness too much.

> Take care
> - unfa

Good luck
Kai


> wt., 23 lis 2021 o 18:40 Kai Krakow <kai@kaishome.de> napisa=C5=82(a):
> >
> > Oops:
> >
> > > # echo 1 >/sys/fs/bcache/CSETUUID/unregister
> > > # bcache make -C -w 4096 -l LABEL --force /dev/BPART
> >
> > CPART of course!
> >
> > # bcache make -C -w 4096 -l LABEL --force /dev/CPART
> >
> > Bye
> > Kai
>
>
>
> --
> - Tobiasz 'unfa' Karo=C5=84
>
> www.youtube.com/unfa000

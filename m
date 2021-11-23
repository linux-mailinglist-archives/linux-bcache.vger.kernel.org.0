Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB9C45AA26
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 18:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhKWRlR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 12:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhKWRlR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 12:41:17 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32634C061574
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 09:38:09 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id x32so25335349ybi.12
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 09:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HDPO907rmE2DSJcKSBzxk6l0OLiPHtJxGgezVUtBvRs=;
        b=LBADPRkCz24ofEmfJ1c8/3z+sm4cmqheBjmZBxsM4O7/MSRSDRYx3l9C81SVflpzYn
         a3ZTtHEg8VK3luSHNzLqfegsoKHfTrBSlNnhDxzdl0tIgair2AoyazEJmsBtbgVRt9AY
         f/mXQUgfpdrCXuRGh3et7JL/I605khr72hkvw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HDPO907rmE2DSJcKSBzxk6l0OLiPHtJxGgezVUtBvRs=;
        b=d8i9nFNGGLIyUlPJUd1laveQipFCpRW+IfuVbC/PVnA6L/rEacreOSAQ/g2RgICbKk
         GRGWZ/Jd2nutleWBf8LGj40+RakTbgZQMWayOwVWQnHm/rYGBjDNTUWlPeURMKx6xkCl
         /xDaSxG7iWEC0QKwtkaOaLMAElC4cKQTeaao4lc/oUX7D8YwXjsmQjYMEcAOkjxz9DzD
         t0kmAr2YXzeS4yMYSStwAb9GfvVf9Q263j8zhe0RgqwvnvwIo8Aq7Mg6iTbeG/ZMt3vW
         NyVARh7qu+kn4rSBVevSk+EUeWmPSwuV8+c6Q+ZCab2ZpXCXIOFYCoTJPgasW4sK5c9X
         Pv2g==
X-Gm-Message-State: AOAM532NGp1OP4CmuZEFepj4i9RPGFv7EsCOE+yLIS84lB4IFLAxlV+U
        Itc6KXxENjboKc8YbpQ4aByZ7AhTkBc1tIBR983RBdD0wtm68w==
X-Google-Smtp-Source: ABdhPJz1A7vFfq4FnuSlFI3AvuFIKAQ47Chd2xuDj+tzFNS831zrGT6OmI85bZrKe4/+0wJ+5gZAdD/ahpxV/tIUlLw=
X-Received: by 2002:a05:6902:1350:: with SMTP id g16mr7939427ybu.202.1637689088152;
 Tue, 23 Nov 2021 09:38:08 -0800 (PST)
MIME-Version: 1.0
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
In-Reply-To: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 23 Nov 2021 18:37:57 +0100
Message-ID: <CAC2ZOYs6iVbqgw8RiiTN7TrHwy3LDTc2AVXm53+2BNjOx04Cmw@mail.gmail.com>
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Tobiasz!

Am Di., 23. Nov. 2021 um 15:48 Uhr schrieb Tobiasz Karo=C5=84 <unfa00@gmail=
.com>:
>
> Hi!
>
> TL;DR
>
> My cache is inconsistent, and that's probably preventing Bcache for m
> using it (all I/O goes to the backing device). How can I clear that?

I've had a similar problem after bcache crashed due to a bug in the
latest kernel.

I could resolve it by the following steps (I think you figure out what
the PLACEHOLDERS mean):

For each backend device, set the cache_mode to none and detach it:

# echo none >/sys/block/BDEV/BPART/bcache/cache_mode
# echo 1 >/sys/block/BDEV/BPART/bcache/detach

Unregister the cache and re-create it (4096 works around the kernel
bug, also, it's potentially broken, so re-create):

# echo 1 >/sys/fs/bcache/CSETUUID/unregister
# bcache make -C -w 4096 -l LABEL --force /dev/BPART

Re-attach the devices and set cache mode:

# echo NEW_CSETUUID >/sys/block/BDEV/BPART/bcache/attach
# echo writearound >/sys/block/BDEV/BPART/bcache/cache_mode

I'm explicitly using writearound for btrfs because:

* writethrough would write data potentially relocated by COW
* writeback potentially destroys btrfs on unexpected bcache failures
* the performance difference between writeback and writearound for
btrfs is virtually non-existent

However, writearound will cache only reads, that means boot-time
improvements will lag one boot behind: During the first boot, bcache
will read btrfs and cache the reads, on the next boot, it will read
the cached data. Using writethrough could work around that but that's
not really useful with a COW filesystem because btrfs relocated
extents on each and every tiny write - making any cached data stale
and thus occupy bcache space for no reason. So it will also amplify
writes to the SSD for no real reason.

Youtube:

The problem you see and documented is exactly what happened to me (but
on Gentoo: system froze, reboot hung, rescue disk said: cache disabled
with a similar message), and you can work around it by using blocksize
4096 - and in any case it still happens: Do NOT use writeback caching,
use writearound as mentioned above, then at least it won't destroy
btrfs and it's a matter of re-creating the cache as outlined above.

HTH
Kai


> Details:
>
> I've been using Bcache for the past few months on my root Btrfs
> filesystem with success.
> Then one day out of the blue Bcache failed and took my Btrfs
> filesystem with it (details:
> https://www.youtube.com/watch?v=3DHf3zr6CxvmI, looks similar to this:
> https://stackoverflow.com/questions/22820492/how-to-revert-bcache-device-=
to-regular-device).
> That's not the topic of my message though.
> I've done a clean Arch Linux installation on Bcache + Btrfs once again
> using an SSD partition for cache and an HDD as the backing device.
>
> However, this time it doesn't do anything...
> I was unable to find any information online to solve this.
>
> My Bcache device works fine, the system boots off of it. However all
> I/O goes straight to the backing HDD, and the SSD is unused. Needless
> to say this means the performance is not what I got used to when
> Bcache was working fine.
>
> Here's what a 3rd party bcache-status script says (it'd be great if
> bcache-tools would provide something like this, BTW):
>
> =E2=9D=AF bcache-status
> --- bcache ---
> Device                      ? (?)
> UUID                        c9cd8259-3cee-42ff-a8ec-e11193c09b7e
> Block Size                  0.50KiB
> Bucket Size                 512.00KiB
> Congested?                  False
> Read Congestion             2.0ms
> Write Congestion            20.0ms
> Total Cache Size            173.97GiB
> Total Cache Used            8.70GiB     (5%)
> Total Cache Unused          165.27GiB   (95%)
> Dirty Data                  0.50KiB     (0%)
> Evictable Cache             173.97GiB   (100%)
> Replacement Policy          [lru] fifo random
> Cache Mode                  (Unknown)
> Total Hits                  0
> Total Misses                0
> Total Bypass Hits           0
> Total Bypass Misses         0
> Total Bypassed              0B
>
> The Total Cache Used value has not changed since I've done my initial
> Arch Linux installation. It seems that Bcache has "turned off" by that
> point.
>
> Here's the bcache supers fro the backing device and cache
>
> =E2=9D=AF bcache-super-show /dev/sda
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 4E6EACCA74AB0AE5 [match]
> sb.version              1 [backing device]
>
> dev.label               unfa-desktop%20root
> dev.uuid                49202fdf-fbe5-48fd-bdd8-df5414da817c
> dev.sectors_per_block   8
> dev.sectors_per_bucket  1024
> dev.data.first_sector   16
> dev.data.cache_mode     0 [writethrough]
> dev.data.cache_state    3 [inconsistent]
>
> cset.uuid               9572380e-8e6f-4ce4-8323-80b98a85eeed
>
> =E2=9D=AF bcache-super-show /dev/sdd3
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 259C90FD74B4D4BE [match]
> sb.version              3 [cache device]
>
> dev.label               (empty)
> dev.uuid                95c6449a-03b5-40f2-a8cc-80b1b61c5ef0
> dev.sectors_per_block   1
> dev.sectors_per_bucket  1024
> dev.cache.first_sector  1024
> dev.cache.cache_sectors 364833792
> dev.cache.total_sectors 364834816
> dev.cache.ordered       yes
> dev.cache.discard       no
> dev.cache.pos           0
> dev.cache.replacement   0 [lru]
>
> cset.uuid               c9cd8259-3cee-42ff-a8ec-e11193c09b7e
>
> BTW - I've now realized I've set a label for the backing device but
> not the cache. maybe this is the reason? I don't think it should work
> this way but I've cleared the label on my backing device just to be
> sure.
>
> Hmm. The cache in inconsistent. I had this before I reinstalled my OS.
> I have recreated the bcache cache on the SSD and was hoping that will
> solve it.
> I don't know what I should do with this, is this the  reason why it's
> not working?
>
> I was wondering if washing the partition and recreating the cache
> would help, but I don't want to needlessly wear down the SSD if that
> won't help.
>
> Needless to say I would really like to avoid data loss when using
> Bcache - it's awesome, and the developer says it's perfectly stable
> and safe, but I've had a sudden failure and others had such as well
> (without seeing any hardware issues that could be causing that). Maybe
> I should quit using Bcache all together? Maybe it's not
> production-ready? I was wondering about maybe using Bcachefs, though
> the need to compile a custom kernel for it is quite a deterrent. I
> tried it briefly, but the bcachefs-tools stopped working at some point
> without a visible reason. I know Btrfs is flawed, though it seems to
> be the best so far.
>
> Thank you for your work,
> - unfa
>
> --
> - Tobiasz 'unfa' Karo=C5=84
>
> www.youtube.com/unfa000

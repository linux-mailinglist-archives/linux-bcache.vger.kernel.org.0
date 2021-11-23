Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B245AF01
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 23:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbhKWW2X (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 17:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240009AbhKWW2T (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 17:28:19 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F109FC061714
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 14:25:10 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso1113558ota.5
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 14:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=v4V0kQJyaYHWrluXZ+3/3irBKD+6kZKxUDGdBm90DXg=;
        b=cjxlZoWGE3TyLM3RJkBUiSUumkhqXDNw4gluWZcBWQYM0oY8PbDro02oeMXox+Gp23
         5VsQup1w7xW5ex4mVosBsyLjpTE083jNp5sZ8oOVdZ5I7prs1HJUStVm5YgcSf1FNbTO
         aARq4961zT1FuGq+cT/wyJkfLdwaUCLC8VRPHE3siQfcypfqfYMT2mvSW2yRONmx2wJB
         Np/M7ON2jiggTUrxx4putMI5S2Fy4gjYEUSCMBoxnMwOGjECDEpsbuODrk8U9y7Pexud
         Q5LUj8pvr8Gj39T8WWw7FH7R7A/DlYQfFTWRix5Qdq7HXBuG35CeLn1CTsHO4WSFckdb
         I+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=v4V0kQJyaYHWrluXZ+3/3irBKD+6kZKxUDGdBm90DXg=;
        b=1oGfe7k8HreAwglX83zDM6L8l51mNoQeX8RZo5YsK+uenz/RnQEuk5tloj+GxF24W2
         z+l3PvMDwPpY7pA5GD3z5Ttz9ED/7lK7P7YgcwTJdLwhcqkbF50ng7qRBO6/jBixvpms
         hbCcFzoKtuN0VE98YN+aaw0x8QeG/JmUjxo9gj6pizbFIy+SBcFmoxFv+3FXrlmvqPR/
         r30ImwfsZlNqSNY0bPpv46HngfR3Q9W+JLTkCJSMCPin0Ea86crbjXLBjWaie00ns42n
         mam8Na1hZjCVCd8/2aHttT518rM/RtLp7vOHGG8dsV9Ij1RpAoS4f/rzxvCTk3OeNzDQ
         l6pw==
X-Gm-Message-State: AOAM531M7pNPRGJQeAok+R+QbeEElQ9v3F5Ogm8g4pQ6OW61YCyjp2aG
        KKRavLbKjjSdUSHAOa2JwPOTn16XKcl8+nUe6yPt/5ql
X-Google-Smtp-Source: ABdhPJwqG9V2riQB4eJz2TTe5UhTgLu7q6Um/kTzn/xLIj1O8djET6ttrmb22gX8UrZIjgVpx+IPb+HQcQS+aSreKYc=
X-Received: by 2002:a9d:f45:: with SMTP id 63mr8053813ott.350.1637706310234;
 Tue, 23 Nov 2021 14:25:10 -0800 (PST)
MIME-Version: 1.0
References: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
In-Reply-To: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
From:   =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Date:   Tue, 23 Nov 2021 23:24:59 +0100
Message-ID: <CAOsCCbME6A3DYJOXTa=dNvBLOzbpPhGQimAb+2CisC3sXw1Vmw@mail.gmail.com>
Subject: Re: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I think I have solved it after reading up on
https://www.kernel.org/doc/html/latest/admin-guide/bcache.html.

1. I've set caching to none.
2. I've detached the caching device
3. I've unregistered it
4. I've done wipe-fs
5. I've recreated bcache caching device (also used --cset-uuid to
already put it into the write bcache set)
6. I've registered and reattached the cache to the backing device
7. Now my backing device shows the status as clean again.
8. I've enabled writearound caching for now (will enable writeback if
all goes well)

It seems the cache is working again:

=E2=9D=AF bcache-status
--- bcache ---
Device                      /dev/sda (8:0)
UUID                        c9cd8259-3cee-42ff-a8ec-e11193c09b7e
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            173.97GiB
Total Cache Used            1.74GiB     (1%)
Total Cache Unused          172.23GiB   (99%)
Dirty Data                  0.50KiB     (0%)
Evictable Cache             173.97GiB   (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  [writethrough] writeback writearound none
Total Hits                  2   (0%)
Total Misses                1506
Total Bypass Hits           0   (0%)
Total Bypass Misses         9138
Total Bypassed              183.70MiB

### Part 2: It's not over!

Soon after I've done this and all seemed to be well, bcache has
imploded once again, this time thankfully not taking down my root
filesystem. Probably because it was not in writeback mode.
My OS didn't boot, and I got another checksum error at some bucket and
"disabled caching" message.

I suspect it as due to my mistake - I have deleted and recreated
bcache cache without rebooting in the middle maybe something went
wrong because of that. I've rebooted into a live system, deleted the
cache again (my backing device was clean).

I've written all zeros to the partition before recreating the cache
this time though.
I suspect maybe bcache found old data there and got confused? Wipefs
only deletes superblocks.

Before doing anything though I've mounted my backing filesystem with
`mount -o 8192` and backed it up using a btrfs-clone Python script.
After I've verified my backup was working I've unmounted the backup
medium and proceeded to recreate the cache and reattach it.

I've also found that `running` was `0` fro my bcache set, so I have
turned it on.

After a reboot everything was back to normal.

I *hope* this will keep working. Last time Bcache broke and took my
filesystem with it without anything significant happening. I'd love to
know if it's considered stable or what could be causing spontaneous
failues.

- unfa



wt., 23 lis 2021 o 15:48 Tobiasz Karo=C5=84 <unfa00@gmail.com> napisa=C5=82=
(a):
>
> Hi!
>
> TL;DR
>
> My cache is inconsistent, and that's probably preventing Bcache for m
> using it (all I/O goes to the backing device). How can I clear that?
>
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



--
- Tobiasz 'unfa' Karo=C5=84

www.youtube.com/unfa000

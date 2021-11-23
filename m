Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B6845A606
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 15:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhKWOvX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 09:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhKWOvW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 09:51:22 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5700C061574
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 06:48:14 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso34035488otj.11
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 06:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Dyps2xCVc861OHDKZkfXuBVUhLGM3wLPwLpkj23oiFk=;
        b=GgE2BsYjJv87nFJjp0R5XNBOYrs1/faOe+VPIjONJrHDCeH92PVKcgJbzojs3LNzFE
         Ymt1+86nlztwsDjxuIJwWsmr/ynUY+910oUzDSaTq+Kb0lAygPKZz3hvOJuzrSmopBS7
         DyKdF2nBLL5LzHH2aoO/7WPZ0ZiYEU/AXxmcYydJMje3Q0eIp486rsaaKTUoodQko9o4
         wEXK0y61eUf6IgJcDs06QHmPTSSvo5CslgixacjLUbG2VTAyn6ppXAFVWNeJoCqyvvwX
         NWyoVZC/gj3pXft0oW3HxHIDm3tmr7vdFQ1HQoPpI+AN30IuG473lc3kgaC+/6qOBxeO
         3Rxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Dyps2xCVc861OHDKZkfXuBVUhLGM3wLPwLpkj23oiFk=;
        b=ffTESVyum5UI6V8doyBe+s3FBzH58k3/mrC+qL+OJfBkpfokqukhRSTKBucNeCshf1
         agMyIPYFjaj/3ImCSp0FuhHtVC8I13JSvFqsY7WspnHZGAIj9/AB5E0ZZ+af/Sv0+V6S
         Vpx6Z1LK5NF2kHfdqMgVfmC4sh8D8QU7/AOZ0tdAVtSkzoo8X9SrPfH0VmuIHQ1NTA6O
         fa3xqUvhH607oX11umEMWnAf9bT7h8jjksOdau+zPE1CR+JPDTpxxEm6es4SOMuZw8UA
         03jJDs7yGn4vBKPpmOllOlIfZkTihe5OlieEVdfpkxAj6WFMijrRhQ3Jl4rDkdABcOjx
         7cBw==
X-Gm-Message-State: AOAM532IwteQt6OCs3QJqJhFrxwdSsEFRfbyfyUYxq7bMzvIUuqQEf11
        9H35aGKunoSzDs6Sa/rKvvE0ET2fAyNLRk6mNLTlyNHo0gs=
X-Google-Smtp-Source: ABdhPJxXcZEhNg15C/KcqcVZwT+CWLQawnPCWRm1tADnOb9HTLb1fOaBncN+PcIOh8rd/ZPM7WxMv1V4jsGNNkfXH9I=
X-Received: by 2002:a9d:f45:: with SMTP id 63mr4969423ott.350.1637678893863;
 Tue, 23 Nov 2021 06:48:13 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Tobiasz_Karo=C5=84?= <unfa00@gmail.com>
Date:   Tue, 23 Nov 2021 15:48:02 +0100
Message-ID: <CAOsCCbM1mx55-uCN-c2VKPwuctt95Hd3joDuj22612a6uBa-nQ@mail.gmail.com>
Subject: Bcache is not caching anything. cache state=inconsistent, how to clear?
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi!

TL;DR

My cache is inconsistent, and that's probably preventing Bcache for m
using it (all I/O goes to the backing device). How can I clear that?

Details:

I've been using Bcache for the past few months on my root Btrfs
filesystem with success.
Then one day out of the blue Bcache failed and took my Btrfs
filesystem with it (details:
https://www.youtube.com/watch?v=3DHf3zr6CxvmI, looks similar to this:
https://stackoverflow.com/questions/22820492/how-to-revert-bcache-device-to=
-regular-device).
That's not the topic of my message though.
I've done a clean Arch Linux installation on Bcache + Btrfs once again
using an SSD partition for cache and an HDD as the backing device.

However, this time it doesn't do anything...
I was unable to find any information online to solve this.

My Bcache device works fine, the system boots off of it. However all
I/O goes straight to the backing HDD, and the SSD is unused. Needless
to say this means the performance is not what I got used to when
Bcache was working fine.

Here's what a 3rd party bcache-status script says (it'd be great if
bcache-tools would provide something like this, BTW):

=E2=9D=AF bcache-status
--- bcache ---
Device                      ? (?)
UUID                        c9cd8259-3cee-42ff-a8ec-e11193c09b7e
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            173.97GiB
Total Cache Used            8.70GiB     (5%)
Total Cache Unused          165.27GiB   (95%)
Dirty Data                  0.50KiB     (0%)
Evictable Cache             173.97GiB   (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  (Unknown)
Total Hits                  0
Total Misses                0
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0B

The Total Cache Used value has not changed since I've done my initial
Arch Linux installation. It seems that Bcache has "turned off" by that
point.

Here's the bcache supers fro the backing device and cache

=E2=9D=AF bcache-super-show /dev/sda
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 4E6EACCA74AB0AE5 [match]
sb.version              1 [backing device]

dev.label               unfa-desktop%20root
dev.uuid                49202fdf-fbe5-48fd-bdd8-df5414da817c
dev.sectors_per_block   8
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     0 [writethrough]
dev.data.cache_state    3 [inconsistent]

cset.uuid               9572380e-8e6f-4ce4-8323-80b98a85eeed

=E2=9D=AF bcache-super-show /dev/sdd3
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 259C90FD74B4D4BE [match]
sb.version              3 [cache device]

dev.label               (empty)
dev.uuid                95c6449a-03b5-40f2-a8cc-80b1b61c5ef0
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 364833792
dev.cache.total_sectors 364834816
dev.cache.ordered       yes
dev.cache.discard       no
dev.cache.pos           0
dev.cache.replacement   0 [lru]

cset.uuid               c9cd8259-3cee-42ff-a8ec-e11193c09b7e

BTW - I've now realized I've set a label for the backing device but
not the cache. maybe this is the reason? I don't think it should work
this way but I've cleared the label on my backing device just to be
sure.

Hmm. The cache in inconsistent. I had this before I reinstalled my OS.
I have recreated the bcache cache on the SSD and was hoping that will
solve it.
I don't know what I should do with this, is this the  reason why it's
not working?

I was wondering if washing the partition and recreating the cache
would help, but I don't want to needlessly wear down the SSD if that
won't help.

Needless to say I would really like to avoid data loss when using
Bcache - it's awesome, and the developer says it's perfectly stable
and safe, but I've had a sudden failure and others had such as well
(without seeing any hardware issues that could be causing that). Maybe
I should quit using Bcache all together? Maybe it's not
production-ready? I was wondering about maybe using Bcachefs, though
the need to compile a custom kernel for it is quite a deterrent. I
tried it briefly, but the bcachefs-tools stopped working at some point
without a visible reason. I know Btrfs is flawed, though it seems to
be the best so far.

Thank you for your work,
- unfa

--=20
- Tobiasz 'unfa' Karo=C5=84

www.youtube.com/unfa000

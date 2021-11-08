Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A19E447EE7
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Nov 2021 12:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhKHLcs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Nov 2021 06:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbhKHLcs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Nov 2021 06:32:48 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D60C061714
        for <linux-bcache@vger.kernel.org>; Mon,  8 Nov 2021 03:30:04 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id s186so42560099yba.12
        for <linux-bcache@vger.kernel.org>; Mon, 08 Nov 2021 03:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hV+FDIiWBw3ycDOp9K16ic223eJv7sFiridEZNCdmQA=;
        b=TzVSrhflEDy8+VEXaGeqj+kVLH1sg3LHg3q16QYF5PsZ0dWF0HQy1JZl/05BZVKy2n
         3SMIf6FLp++Jlef7rwozkXTMK0T93+iD/z8bKs+h4D7DvonDUyIwpLzS4FBCrPUedXdS
         dRbDg2+iWQVd1Gqoidl4pkRvSOM2BOeg/kYxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hV+FDIiWBw3ycDOp9K16ic223eJv7sFiridEZNCdmQA=;
        b=iOBwjZJX6Tg4BpP5htgTlfqzF2H85TfY3jGyAruxu4q1tYWKLju+ebNpqy9V5zbppX
         3/ptr6LMLFs1cS7UMEL+QeBNxn5jtBwX0sQaMDdSDNN4qVzZ5z7ZDJzDx940WUtgx+hZ
         uIRWMityEVm3Ys3zdhqI+cLv/fQ6/N/C91Snakg2lDB36TkRV5dt8Bc1UTnGCs+kiTPe
         qmIW6S3u+XEEmnBrNx8iUODWHJKb6miLoFzI0C4Ijkb1jPfgahPctdqZXO/tp0/ov7wM
         9yE6xRcUyY5Y/lrm0bmeekZ3bnwmVWKIVIZOLvBSHwNKE1NJScJuCmZPjA5azF8oVnAz
         blcg==
X-Gm-Message-State: AOAM5337zjf3pIj/w24GG7u5/FX9wIB4z5vUlR85lXdEl1NPZsWDUx27
        oDfMJ4m7fjsK5Y/5yE/37U4JpN4vI/XCOoHjaACP5A==
X-Google-Smtp-Source: ABdhPJw/B6J43yWOmV9/HAU9NzhMKf5/aOZIRNSiqKi8JPsvoTdiZnPngB/T7jrLxK1KVnMqleblokC5CmyRhZoWNfs=
X-Received: by 2002:a25:1487:: with SMTP id 129mr92089339ybu.206.1636371003187;
 Mon, 08 Nov 2021 03:30:03 -0800 (PST)
MIME-Version: 1.0
References: <10612571636111279@vla5-f98fea902492.qloud-c.yandex.net>
 <CAJS8hV+KdLA6c8c5OV=z_KmJN2TSWROR6k9Y6_qut4EavJ0=tA@mail.gmail.com>
 <CAC2ZOYu36PAJO-b-vWYJftFT2PQ-JwiP9q79yqXDS_1z6V7M3g@mail.gmail.com> <3d3c78f8-ed3c-7520-fa8a-d55eabe741c2@suse.de>
In-Reply-To: <3d3c78f8-ed3c-7520-fa8a-d55eabe741c2@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Mon, 8 Nov 2021 12:29:52 +0100
Message-ID: <CAC2ZOYsdk9FOHMnr3Z4O05wiYPMZJNb1oasR7goCYyOhckO5HA@mail.gmail.com>
Subject: Latency, performance, detach behavior (was: A lot of flush requests
 to the backing device)
To:     Coly Li <colyli@suse.de>
Cc:     Aleksei Zakharov <zakharov.a.g@yandex.ru>,
        Dongdong Tao <dongdong.tao@canonical.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Mo., 8. Nov. 2021 um 09:11 Uhr schrieb Coly Li <colyli@suse.de>:
> On 11/8/21 2:35 PM, Kai Krakow wrote:
> > [1]: And some odd behavior where bcache would detach dirty caches on
> > caching device problems, which happens for me sometimes at reboot just
> > after bcache was detected (probably due to a SSD firmware hiccup, the
> > device temporarily goes missing and re-appears) - and then all dirty
> > data is lost and discarded. In consequence, on next reboot, cache mode
> > is set to "none" and the devices need to be re-attached. But until
> > then, dirty data is long gone.
>
> Just an off topic question, when you experienced the above situation,
> what is the kernel version for this?
> We recently have a bkey oversize regression triggered in Linux v5.12 or
> v5.13, which behaved quite similar to the above description.
> The issue was fixed in Linux v5.13 by the following commits,

You mean exactly the above mentioned situation? Or the latency problems?

I'm using LTS kernels, that is currently the 5.10 series, and usually
I'm updating it as soon as possible. I didn't switch to 5.15 yet.

Latency problems: That's a long-standing issue, and may be more
related to how btrfs works on top of bcache. It has improved during
the course of 5.10 probably due to changes in btrfs. But it seems that
using bcache writeback causes more writeback blocking than it should
while without bcache writeback, dirty writeback takes longer but
doesn't block desktop so much. It may be related to sometimes varying
latency performance of Samsung Evo SSD drives.

> commit 1616a4c2ab1a ("bcache: remove bcache device self-defined readahead")
> commit 41fe8d088e96 ("bcache: avoid oversized read request in cache
> missing code path")

Without having looked at the commits, this mostly sounds like it would
affect latency and performance.

So your request was probably NOT about the detach-on-error situation.

Just for completeness: That one isn't really a software problem (I'll
just ditch Samsung on the next SSD swap, maybe going to Seagate
Ironwolf instead which was recommended by Zygo who created bees and
works on btrfs). I then expect that situation not to occur again, I
never experienced it back when I used Crucial MX (which also had
better latency behavior). Since using Samsung SSDs, I've lost parts of
EFI more than once (2 MB where just zeroed out in vfat), which didn't
happen again since I turned TRIM off (some filesystems or even bcache
seem to enable it, the kernel doesn't blacklist the feature for my
model). This also caused bcache to sometimes complain about a broken
journal structure. But well, this is not the lost-data-on-TRIM
situation:

Due to the nature of the problem, I cannot really pinpoint when it
happened first. The problem is, usually on cold boots, that the SSD
firmware would shortly after power-cycle detach from SATA and come
back, since I use fast-boot UEFI, that means it can happen when the
kernel already booted and bcache loaded. This never happens on a
running system, only during boot/POST. The problematic bcache commit
introduced a behavior to detach errored caching backends which in turn
invalidates dirty cache data. Looking at the cache status after such
an incident, the cache mode of the detached members is set to "none",
they are no longer attached, but the cache device still has the same
amount of data so data of the detached device was not freed from the
cache. But on re-attach, dirty data won't be replayed, dirty data
stays 0, and btrfs tells me that expected transaction numbers are some
300 generations behind (which is usually not fixable, I was lucky this
time because only one btrfs member had dirty data, scrub fixed it).
bcache still keeps its usage level (like 90%, or 860GB in my case),
and it seems to just discard old "stale" data from before the detach
situation.

I still think that bcache should not detach backends when the cache
device goes missing with dirty data - instead it must reply with IO
errors and/or go to read-only mode, until I either manually bring the
cache back or decide to resolve the situation by declaring the dirty
data as lost manually. Even simple RAID controllers do that: If the
cache contents are lost or broken, they won't "auto fix" themselves by
purging the cache, they halt on boot telling me that I can either work
without the device set, or accept that the dirty data is lost. bcache
should go into read-only mode, leave the cache attached but mark it
missing/errored, until I decided to either accept the data loss, or
resolve the situation with the missing cache device. Another
work-around would be if I could instruct bcache to flush all dirty
data during shutdown.

Regards,
Kai

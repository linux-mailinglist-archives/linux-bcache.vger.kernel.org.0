Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFB1284FF0
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Oct 2020 18:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgJFQem (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Oct 2020 12:34:42 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:47298 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgJFQem (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Oct 2020 12:34:42 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 096GYYti006487;
        Tue, 6 Oct 2020 17:34:34 +0100
From:   Nix <nix@esperi.org.uk>
To:     Kai Krakow <kai@kaishome.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] bcache: introduce bcache sysfs entries for ioprio-based bypass/writeback hints
References: <20201003111056.14635-1-kai@kaishome.de>
        <20201003111056.14635-2-kai@kaishome.de>
        <87362ucen3.fsf@esperi.org.uk>
        <CAC2ZOYt+ZMep=PT5FbQKiqZ0EE1f4+JJn=oTJUtQjLwGvy=KfQ@mail.gmail.com>
        <alpine.LRH.2.11.2010051923330.2180@pop.dreamhost.com>
        <87o8lfa692.fsf@esperi.org.uk>
        <CAC2ZOYvA966Jwa1CGepRDUmBn4=-vpZR82YZZQxT8L+f7-HTUQ@mail.gmail.com>
Emacs:  (setq software-quality (/ 1 number-of-authors))
Date:   Tue, 06 Oct 2020 17:34:34 +0100
In-Reply-To: <CAC2ZOYvA966Jwa1CGepRDUmBn4=-vpZR82YZZQxT8L+f7-HTUQ@mail.gmail.com>
        (Kai Krakow's message of "Tue, 6 Oct 2020 15:10:37 +0200")
Message-ID: <87imbn9uud.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-x.dcc-servers-Metrics: loom 104; Body=4 Fuz1=4 Fuz2=4
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6 Oct 2020, Kai Krakow verbalised:

> Am Di., 6. Okt. 2020 um 14:28 Uhr schrieb Nix <nix@esperi.org.uk>:
>> That sounds like a bug in the mq-scsi machinery: it surely should be
>> passing the ioprio off to the worker thread so that the worker thread
>> can reliably mimic the behaviour of the thread it's acting on behalf of.
>
> Maybe this was only an issue early in mq-scsi before it got more
> schedulers than just iosched-none? It has bfq now, and it should work.
> Depending on the filesystem, tho, that may still not fully apply...
> e.g. btrfs doesn't use ioprio for delayed refs resulting from such io,
> it will simply queue it up at the top of the io queue.

Yeah. FWIW I'm using bfq for all the underlying devices and everything
still seems to be working, idle I/O doesn't get bcached etc.

>> using cgroups would make this essentially unusable for
>> me, and probably for most other people, because on a systemd system the
>> cgroup hierarchy is more or less owned in fee simple by systemd, and it
>> won't let you use cgroups for something else,
>
> That's probably not completely true, you can still define slices which
> act as a cgroup container for all services and processes contained in
> it, and you can use "systemctl edit myscope.slice" to change
> scheduler, memory accounting, and IO params at runtime.

That's... a lot clunkier than being able to say 'ionice -c 3 foo' to run
foo without caching. root has to prepare for it on a piece-by-piece
basis... not that ionice is the most pleasant of utilities to use
either.

>> (And as for making systemd set up suitable cgroups, that too would make
>> it unusable for me: I tend to run jobs ad-hoc with ionice, use ionice in
>> scripts etc to reduce caching when I know it won't be needed, and that
>> sort of thing is just not mature enough to be reliable in systemd yet.
>
> You can still define a slice for such ad-hoc processes by using
> systemd-run to make your process into a transient one-shot service.

That's one of the things that crashed my system when I tried it. I just
tried it again and it seems to work now. :) (Hm, does systemd-run wait
for return and hand back the exit code... yes, via --scope or --wait,
both of which seem to have elaborate constraints that I don't fully
understand and that makes me rather worried that using them might not be
reliable: but in this it is just like almost everything else in
systemd.)

>> It's rare for a systemd --user invocation to get everything so confused
>> that the entire system is reundered unusable, but it has happened to me
>> in the past, so unlike ionice I am now damn wary of using systemd --user
>> invocations for anything. They're a hell of a lot clunkier for ad-hoc
>> use than a simple ionice, too: you can't just say "run this command in a
>> --user", you have to set up a .service file etc.)
>
> Not sure what you did, I never experienced that. Usually that happens

It was early in the development of --user, so it may well have been a
bug that was fixed later on. In general I have found systemd to be too
tightly coupled and complex to be reliable: there seem to be all sorts
of ways to use local mounts and fs namespaces and the like to fubar PID
1 and force a reboot (which you can't do because PID 1 is too unhappy,
so it's /sbin/reboot -f time). Admittedly I do often do rather extreme
things with tens of thousands of mounts and the like, but y'know the
only thing that makes unhappy is... systemd. :/

(I have used systemd enough to both rely on it and cordially loathe it
as an immensely overcomplicated monster with far too many edge cases and
far too much propensity to insist on your managing the system its way
(e.g. what it does with cgroups), and if I do anything but the simplest
stuff I'm likely to trip over one or more bugs in those edge cases. I'd
switch to something else simple enough to understand if only all the
things I might switch to were not also too simple to be able to do the
things I want to do. The usual software engineering dilemma...)

In general, though, the problem with cgroups is that courtesy of v2
having a unified hierarchy, if any one thing uses cgroups, nothing else
really can, because they all have to agree on the shape of the
hierarchy, which is most unlikely if they're using cgroups for different
purposes. So it is probably a mistake to use cgroups for *anything*
other than handing control of it to a single central thing (like
systemd) and then trying to forget that cgroups ever existed for any
other purpose because you'll never be able to use them yourself.

A shame. They could have been a powerful abstraction...

> and some more. The trick is to define all slices with a
> lower bound of memory below which the kernel won't reclaim memory from
> it - I found that's one of the most important knobs to fight laggy
> desktop usage.

I cheated and just got a desktop with 16GiB RAM and no moving parts and
a server with so much RAM that it never swaps, and 10GbE between the two
so the desktop can get stuff off the server as fast as its disks can do
contiguous reads. bcace cuts down seek time enough that I hardly ever
have to wait for it, and bingo :)

(But my approach is probably overkill: yours is more elegant.)

> I usually look at the memory needed by the processes when running,

I've not bothered with that for years: 16GiB seems to be enough that
Chrome plus even a fairly big desktop doesn't cause the remotest
shortage of memory, and the server, well, I can run multiple Emacsen and
20+ VMs on that without touching the sides. (Also... how do you look at
it? PSS is pretty good, but other than ps_mem almost nothing uses it,
not even the insanely overdesigned procps top.)

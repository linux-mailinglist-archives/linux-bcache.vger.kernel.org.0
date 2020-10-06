Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F20284C4C
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Oct 2020 15:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgJFNKv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Oct 2020 09:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgJFNKv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Oct 2020 09:10:51 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061BCC0613D1
        for <linux-bcache@vger.kernel.org>; Tue,  6 Oct 2020 06:10:51 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 19so12953018qtp.1
        for <linux-bcache@vger.kernel.org>; Tue, 06 Oct 2020 06:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AbUhUUNI4zeM3nS4/k6XhwyQZ4L7s7xPoEddzecSbmM=;
        b=fs1T0rMzfHiHp+0QkvdBQfRrR9yAufazbcMprA/zXvF9LAW7nhhug6gvCM7JazsNlK
         sKjwQSqEh127P2s9b2crM96nLRBhlY/U506zCnQb03k1bIb10DUSH8tXgg1jcR/fH3cS
         dH9w04F6ff3wE9BWdMkNaxlvnNZp3EuI4e3mE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AbUhUUNI4zeM3nS4/k6XhwyQZ4L7s7xPoEddzecSbmM=;
        b=cYBkNX0Gn/5KsQdJAZaEv2OjEQgD0qSCFsNiimSQI/MPWLk590ar7dekiocZcfo8Oz
         RtAtBrfsI98k/3xphVwI0kZ27Ymlms3aadJq7Ma9KQHSeuSdK6nSiTP7u0yXqNGR+OrG
         HtvCHC9l8pV+3FDY2FPEONcD0kitkM3R9tcX/GkYr37v8Ex/0j50IlVKSfS2JyeynS+7
         hXxIy+10C7L5WB1BIgLh/6NEq9niF30K5p9ID1gCxl3D8JfumiF+4wefrNRm3lPTopKD
         wKtf/P7PBK0X5JkR4LHQDES2hIO9Ecy6l/0sXwcpe9OrZdo/ck+Nx1vQlgGje5nIV+MH
         dolw==
X-Gm-Message-State: AOAM530AQxBLaGCmoCnBxCgqjuG0aW2plfDGjEu3Jj274SbO6k7A/A5I
        mLoW0raAfDPmgNt5tArq4TcNjHjK6aX1Cxtg9ZpFNDGz9fAGSiEo
X-Google-Smtp-Source: ABdhPJzkDe0vlNSFdhQSqP5I4mfR397Rmx3jtq7Stx8cVcMRdRIfUDiHLVvMCOYAloTzTzjRbupOIEnNPiq77mkcrk0=
X-Received: by 2002:ac8:24b9:: with SMTP id s54mr4984732qts.138.1601989850064;
 Tue, 06 Oct 2020 06:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <20201003111056.14635-1-kai@kaishome.de> <20201003111056.14635-2-kai@kaishome.de>
 <87362ucen3.fsf@esperi.org.uk> <CAC2ZOYt+ZMep=PT5FbQKiqZ0EE1f4+JJn=oTJUtQjLwGvy=KfQ@mail.gmail.com>
 <alpine.LRH.2.11.2010051923330.2180@pop.dreamhost.com> <87o8lfa692.fsf@esperi.org.uk>
In-Reply-To: <87o8lfa692.fsf@esperi.org.uk>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 6 Oct 2020 15:10:37 +0200
Message-ID: <CAC2ZOYvA966Jwa1CGepRDUmBn4=-vpZR82YZZQxT8L+f7-HTUQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] bcache: introduce bcache sysfs entries for
 ioprio-based bypass/writeback hints
To:     Nix <nix@esperi.org.uk>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Di., 6. Okt. 2020 um 14:28 Uhr schrieb Nix <nix@esperi.org.uk>:
>
> On 5 Oct 2020, Eric Wheeler verbalised:
>
> > [+cc:bcache and blocklist]
> >
> > (It did not look like this was being CC'd to the list so I have pasted the
> > relevant bits of conversation. Kai, please resend your patch set and CC
> > the list linux-bcache@vger.kernel.org)
>
> Oh sorry. I don't know what's been going on with the Cc:s here.
>
> > I am glad that people are still making effective use of this patch!
>
> :)
>
> > It works great unless you are using mq-scsi (or perhaps mq-dm). For the
> > multi-queue systems out there, ioprio does not seem to pass down through
> > the stack into bcache, probably because it is passed through a worker
> > thread for the submission or some other detail that I have not researched.
>
> That sounds like a bug in the mq-scsi machinery: it surely should be
> passing the ioprio off to the worker thread so that the worker thread
> can reliably mimic the behaviour of the thread it's acting on behalf of.

Maybe this was only an issue early in mq-scsi before it got more
schedulers than just iosched-none? It has bfq now, and it should work.
Depending on the filesystem, tho, that may still not fully apply...
e.g. btrfs doesn't use ioprio for delayed refs resulting from such io,
it will simply queue it up at the top of the io queue.

>
> > Long ago others had concerns using ioprio as the mechanism for cache
> > hinting, so what does everyone think about implementing cgroup inside of
> > bcache? From what I can tell, cgroups have a stronger binding to an IO
> > than ioprio hints.
>
> Nice idea, but...

Yeah, it would fit my use-case perfectly.

> using cgroups would make this essentially unusable for
> me, and probably for most other people, because on a systemd system the
> cgroup hierarchy is more or less owned in fee simple by systemd, and it
> won't let you use cgroups for something else,

That's probably not completely true, you can still define slices which
act as a cgroup container for all services and processes contained in
it, and you can use "systemctl edit myscope.slice" to change
scheduler, memory accounting, and IO params at runtime.

> or even make your own
> underneath the ones it's managing: it sometimes seems to work but they
> can suddenly go away without warning and all the processes in them get
> transferred out by systemd or even killed off.

See above, use slices, don't try to sneak around systemd's cgroup
management - especially not in services.

> (And as for making systemd set up suitable cgroups, that too would make
> it unusable for me: I tend to run jobs ad-hoc with ionice, use ionice in
> scripts etc to reduce caching when I know it won't be needed, and that
> sort of thing is just not mature enough to be reliable in systemd yet.

You can still define a slice for such ad-hoc processes by using
systemd-run to make your process into a transient one-shot service.
It's not much different from prepending "ionice ... schedtool ...".
I'm using that put some desktop programs in a resource jail to avoid
cache thrashing, e.g. by browsers which tend to dominate the cache:
https://github.com/kakra/gentoo-cgw (this will integrate with the
package manager to replace the original executable with a wrapper).
But that has some flaws, as in when running a browser from a Steam
container, it starts to act strange... But otherwise I'm using it
quite successfully.

> It's rare for a systemd --user invocation to get everything so confused
> that the entire system is reundered unusable, but it has happened to me
> in the past, so unlike ionice I am now damn wary of using systemd --user
> invocations for anything. They're a hell of a lot clunkier for ad-hoc
> use than a simple ionice, too: you can't just say "run this command in a
> --user", you have to set up a .service file etc.)

Not sure what you did, I never experienced that. Usually that happens
when processes managed by a systemd service try to escape the current
session, i.e. by running "su -" or "sudo", so some uses of ionice may
experience similar results.

So my current situation is: I defined a slice for background jobs
(backup, maintenance jobs etc), one for games (boosting the CPU/IO/mem
share), one for browsers (limiting CPU to fight against run-away
javascripts), and some more. The trick is to define all slices with a
lower bound of memory below which the kernel won't reclaim memory from
it - I found that's one of the most important knobs to fight laggy
desktop usage. I usually look at the memory needed by the processes
when running, then add some amount of cache I think would be useful
for the processes, as cgroup memory accounting luckily app allocations
AND cache memory. Actually, limiting memory with cgroups can have
quite an opposite effect (as processes tend to swap then, even with
plenty of RAM available).

Regards,
Kai

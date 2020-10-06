Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E483284C80
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Oct 2020 15:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgJFNZD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Oct 2020 09:25:03 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:46016 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFNZD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Oct 2020 09:25:03 -0400
X-Greylist: delayed 3404 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2020 09:25:03 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 096CS9p4002479;
        Tue, 6 Oct 2020 13:28:09 +0100
From:   Nix <nix@esperi.org.uk>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Kai Krakow <kai@kaishome.de>, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] bcache: introduce bcache sysfs entries for ioprio-based bypass/writeback hints
References: <20201003111056.14635-1-kai@kaishome.de>
        <20201003111056.14635-2-kai@kaishome.de>
        <87362ucen3.fsf@esperi.org.uk>
        <CAC2ZOYt+ZMep=PT5FbQKiqZ0EE1f4+JJn=oTJUtQjLwGvy=KfQ@mail.gmail.com>
        <alpine.LRH.2.11.2010051923330.2180@pop.dreamhost.com>
Emacs:  the answer to the world surplus of CPU cycles.
Date:   Tue, 06 Oct 2020 13:28:09 +0100
In-Reply-To: <alpine.LRH.2.11.2010051923330.2180@pop.dreamhost.com> (Eric
        Wheeler's message of "Mon, 5 Oct 2020 19:41:18 +0000 (UTC)")
Message-ID: <87o8lfa692.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=4 Fuz1=4 Fuz2=4
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5 Oct 2020, Eric Wheeler verbalised:

> [+cc:bcache and blocklist]
>
> (It did not look like this was being CC'd to the list so I have pasted the 
> relevant bits of conversation. Kai, please resend your patch set and CC 
> the list linux-bcache@vger.kernel.org)

Oh sorry. I don't know what's been going on with the Cc:s here.

> I am glad that people are still making effective use of this patch!

:)

> It works great unless you are using mq-scsi (or perhaps mq-dm). For the 
> multi-queue systems out there, ioprio does not seem to pass down through 
> the stack into bcache, probably because it is passed through a worker 
> thread for the submission or some other detail that I have not researched. 

That sounds like a bug in the mq-scsi machinery: it surely should be
passing the ioprio off to the worker thread so that the worker thread
can reliably mimic the behaviour of the thread it's acting on behalf of.

> Long ago others had concerns using ioprio as the mechanism for cache 
> hinting, so what does everyone think about implementing cgroup inside of 
> bcache? From what I can tell, cgroups have a stronger binding to an IO 
> than ioprio hints. 

Nice idea, but... using cgroups would make this essentially unusable for
me, and probably for most other people, because on a systemd system the
cgroup hierarchy is more or less owned in fee simple by systemd, and it
won't let you use cgroups for something else, or even make your own
underneath the ones it's managing: it sometimes seems to work but they
can suddenly go away without warning and all the processes in them get
transferred out by systemd or even killed off.

(And as for making systemd set up suitable cgroups, that too would make
it unusable for me: I tend to run jobs ad-hoc with ionice, use ionice in
scripts etc to reduce caching when I know it won't be needed, and that
sort of thing is just not mature enough to be reliable in systemd yet.
It's rare for a systemd --user invocation to get everything so confused
that the entire system is reundered unusable, but it has happened to me
in the past, so unlike ionice I am now damn wary of using systemd --user
invocations for anything. They're a hell of a lot clunkier for ad-hoc
use than a simple ionice, too: you can't just say "run this command in a
--user", you have to set up a .service file etc.)

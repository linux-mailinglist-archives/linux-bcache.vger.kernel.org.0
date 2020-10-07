Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B82285F67
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Oct 2020 14:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgJGMnd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Oct 2020 08:43:33 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:52288 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgJGMnc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Oct 2020 08:43:32 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTP id 097ChQrw024233;
        Wed, 7 Oct 2020 13:43:26 +0100
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
        <87o8lfa692.fsf@esperi.org.uk>
        <CAC2ZOYvA966Jwa1CGepRDUmBn4=-vpZR82YZZQxT8L+f7-HTUQ@mail.gmail.com>
        <87imbn9uud.fsf@esperi.org.uk>
        <alpine.LRH.2.11.2010070035310.27518@pop.dreamhost.com>
Emacs:  you'll understand when you're older, dear.
Date:   Wed, 07 Oct 2020 13:43:26 +0100
In-Reply-To: <alpine.LRH.2.11.2010070035310.27518@pop.dreamhost.com> (Eric
        Wheeler's message of "Wed, 7 Oct 2020 00:41:59 +0000 (UTC)")
Message-ID: <87362q9pg1.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1102; Body=4 Fuz1=4 Fuz2=4
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7 Oct 2020, Eric Wheeler said:

> I always make my own cgroups with cgcreate, cgset, and cgexec.  We're 
> using centos7 which is all systemd and I've never had a problem:

Oh, maybe I'm panicking about nothing as usual then. Maybe this is all
ancient systemd bugs that were fixed roughly when the Americas split off
from Europe but which I've been worrying over without retesting ever
since. :)

> Something (hypothetically) like this:
> 	cgcreate -g blkio:/my_bcache_settings
> 	cgset -r blkio.bcache.bypass='read,write'    my_bcache_settings
> 	cgset -r blkio.bcache.writeback='write,meta' my_bcache_settings
>
> Then all you need to do is run this which isn't all that different from an 
> ionice invocation:
> 	cgexec -g blkio:my_bcache_settings /usr/local/bin/some-program

... if it's that easy, I have no objections :) actually that looks
significantly more expressive than what we have now.

-- 
NULL && (void)

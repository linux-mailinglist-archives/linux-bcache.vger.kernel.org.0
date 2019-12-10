Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E0F119050
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Dec 2019 20:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfLJTHp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 Dec 2019 14:07:45 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:34624 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727610AbfLJTHp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Dec 2019 14:07:45 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 4C889A0633;
        Tue, 10 Dec 2019 19:07:44 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id x0CuDp1PCeTT; Tue, 10 Dec 2019 19:07:13 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 0EF5BA0440;
        Tue, 10 Dec 2019 19:07:13 +0000 (UTC)
Date:   Tue, 10 Dec 2019 19:07:11 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Nathan Dehnel <ncdehnel@gmail.com>
cc:     linux-bcache@vger.kernel.org
Subject: Re: Trying to attach a cache drive gives "invalid argument"
In-Reply-To: <CAEEhgEsNabxWPyk5JmAePk5oMnmYOT_wxXy7YseCc3j8Y+2HDw@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1912101905560.11561@mx.ewheeler.net>
References: <CAEEhgEtXKoQymHyS278GvE=95jNiW71sb1bz_-2AfOkDPp0dMw@mail.gmail.com> <alpine.LRH.2.11.1912100029180.11561@mx.ewheeler.net> <CAEEhgEsy8+aZuEfw5vX_ytKhCq2WxnC=N6AS0msKx_JgJb+=-g@mail.gmail.com> <alpine.LRH.2.11.1912100111590.11561@mx.ewheeler.net>
 <CAEEhgEsNabxWPyk5JmAePk5oMnmYOT_wxXy7YseCc3j8Y+2HDw@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, 9 Dec 2019, Nathan Dehnel wrote:

> root@gentooserver /home/nathan # blockdev --report /dev/bcache0
> RO    RA   SSZ   BSZ   StartSec            Size   Device
> rw   256   512  4096          0   1000203083776   /dev/bcache0
> root@gentooserver /home/nathan # blockdev --report /dev/md0
> RO    RA   SSZ   BSZ   StartSec            Size   Device
> rw   256   512  4096          0     14255390720   /dev/md0
> root@gentooserver /home/nathan # blockdev --report /dev/sda1
> RO    RA   SSZ   BSZ   StartSec            Size   Device
> rw   256   512  4096       2048   1000203091968   /dev/sda1
> root@gentooserver /home/nathan # bcache-super-show /dev/md0
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 E9D560726742DDAB [match]
> sb.version              3 [cache device]
> 
> dev.label               (empty)
> dev.uuid                cf8bc992-9797-4f47-8d3c-78731f5d1c2e
> dev.sectors_per_block   8   <<<
  ^^^^^^^^^^^^^^^^^^^^^^^^^

> dev.sectors_per_bucket  1024
> dev.cache.first_sector  1024
> dev.cache.cache_sectors 27841536
> dev.cache.total_sectors 27842560
> dev.cache.ordered       yes
> dev.cache.discard       no
> dev.cache.pos           0
> dev.cache.replacement   0 [lru]
> 
> cset.uuid               45511b33-6bb8-42d5-a255-3de1749f8dda
> root@gentooserver /home/nathan # bcache-super-show /dev/sda1
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 7D8A76D84F264724 [match]
> sb.version              1 [backing device]
> 
> dev.label               (empty)
> dev.uuid                d4d2b9d6-077d-4328-b2cd-14f6db259955
> dev.sectors_per_block   1   <<<
  ^^^^^^^^^^^^^^^^^^^^^^^^^

I think this is the issue.

Assuming your cache doesn't have data on it yet, try this:
	make-bcache --block 4k -B /dev/sdX1

--
Eric Wheeler



> dev.sectors_per_bucket  1024
> dev.data.first_sector   16
> dev.data.cache_mode     0 [writethrough]
> dev.data.cache_state    0 [detached]
> 
> cset.uuid               4ae1adfc-b345-419f-9ce0-b450854370b0
> 
> On Mon, Dec 9, 2019 at 7:15 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> >
> > On Mon, 9 Dec 2019, Nathan Dehnel wrote:
> >
> > > [ 9651.101227] bcache: bch_cached_dev_attach() Couldn't attach sda1:
> > > block size less than set's block size
> >
> > What do these report:
> >
> > blockdev --report /dev/bcache0
> > blockdev --report /dev/sdX     # bcache cache dev
> > blockdev --report /dev/sdY     # bcache bdev
> >
> >
> > bcache-super-show /dev/sdX # bcache cache dev
> > bcache-super-show /dev/sdY # bcache bdev
> >
> > --
> > Eric Wheeler
> >
> > >
> > > On Mon, Dec 9, 2019 at 6:30 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > > >
> > > > On Mon, 9 Dec 2019, Nathan Dehnel wrote:
> > > >
> > > > > root@gentooserver / # echo 45511b33-6bb8-42d5-a255-3de1749f8dda >
> > > > > /sys/block/bcache0/bcache/attach
> > > > > -bash: echo: write error: Invalid argument
> > > >
> > > > What does `dmesg` say?
> > > >
> > > >
> > > > --
> > > > Eric Wheeler
> > > >
> > > >
> > > >
> > > > >
> > > > > How should I fix this?
> > > > >
> > >
> 

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13B311BF62
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Dec 2019 22:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLKVr3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Dec 2019 16:47:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55689 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLKVr3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Dec 2019 16:47:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so8877150wmj.5
        for <linux-bcache@vger.kernel.org>; Wed, 11 Dec 2019 13:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QFSjM5NvXrwENzO84Pa6APTBAjNUOz+f450h3Dge/Pk=;
        b=mB9DEiW2MTGbk+Xg4pSmYOG8hvY9o15lqqP04lmbhgS8Sr/qYbN+I1Nqt6eQEdWkjC
         MGeLgzicKgLhTNtHj18IZg+qzfH139GOhtbDJCI5Z/v18CQ/NnzXKzpgXBtjCvWrFo38
         dCYBntdLZAkWzCYJzYD48L/uAekWtyiDRi38mgWFwWFv7afO+OFKd/berLGY3abV/TYe
         Q/XF9pwqN/5m9tWxxk2QyDgSibEMKdU4Hd2/O8NmYHieQpjFnYofqcG+2KkXbjNiSzlN
         pHT7SVDaUAZFAho7NQ+Ag+1m67q3AVwUFq6+8s/gTnaBF/rDxQaN/MlSCwbEhEXYZUFj
         rUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QFSjM5NvXrwENzO84Pa6APTBAjNUOz+f450h3Dge/Pk=;
        b=a3YyzEm/6VbNfnmjAyaZM5T7HMzOao7iQ0/HKWsF2MkcxoAGUHfu2XuftkCGOGZcpA
         hQaZ5Sqt6kHIErdFfgFJNWE9yFt3cwszWtjNHUFa4LX+u01/zuhOgKGv4Mak2+tzU6NE
         I/7VjqA3mLJF/RicM2T6ZUpRHhsd/AkuherjtjI7PgjE1hGdS8grohdQtkiRLLQO4tO4
         q/nbfhRAkDblvD1ua7YAT3t1vk1+P3vLVXDyk05VLmgmihC+vdDwR5euNQM0tc3ODT5R
         KppXGatTvW1etmk8FzlZVXk8OFjr0lR/lLdNnLK0On33TsRtiYH+f02sGTAUW43X/o7s
         ucwQ==
X-Gm-Message-State: APjAAAWEkEJW7H0ArIsA1dWdBqv50g4BDv77jGwxGOWXZPYFfaz7Ydva
        C+Wj4iAcDd51QX9lAtTqeVmR2zzBDYCrgmmFQmlJ82oJ
X-Google-Smtp-Source: APXvYqxx1iYmWNTRhmIbJNlp+chL4Gx2kLhJ4a3eDltP1BJVVUWQ0JKKQxSQ94mvUe0G5PAO28drOTrsR6HVYvsuJWI=
X-Received: by 2002:a7b:ce81:: with SMTP id q1mr2269213wmj.47.1576100846756;
 Wed, 11 Dec 2019 13:47:26 -0800 (PST)
MIME-Version: 1.0
References: <CAEEhgEtXKoQymHyS278GvE=95jNiW71sb1bz_-2AfOkDPp0dMw@mail.gmail.com>
 <alpine.LRH.2.11.1912100029180.11561@mx.ewheeler.net> <CAEEhgEsy8+aZuEfw5vX_ytKhCq2WxnC=N6AS0msKx_JgJb+=-g@mail.gmail.com>
 <alpine.LRH.2.11.1912100111590.11561@mx.ewheeler.net> <CAEEhgEsNabxWPyk5JmAePk5oMnmYOT_wxXy7YseCc3j8Y+2HDw@mail.gmail.com>
 <alpine.LRH.2.11.1912101905560.11561@mx.ewheeler.net>
In-Reply-To: <alpine.LRH.2.11.1912101905560.11561@mx.ewheeler.net>
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Wed, 11 Dec 2019 15:47:14 -0600
Message-ID: <CAEEhgEuahEbqX-mt9t0nKkzT4dhR-OtTokirQ_D-kqrF4G1NbA@mail.gmail.com>
Subject: Re: Trying to attach a cache drive gives "invalid argument"
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I figured it out. The backing drives have a 512B sector size, and I
used 4k with the cache drive. I'm shocked they don't use 4k, they're
all relatively recent WD blacks. I thought they all transitioned years
and years ago.
Thanks anyways.

On Tue, Dec 10, 2019 at 1:07 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
>
> On Mon, 9 Dec 2019, Nathan Dehnel wrote:
>
> > root@gentooserver /home/nathan # blockdev --report /dev/bcache0
> > RO    RA   SSZ   BSZ   StartSec            Size   Device
> > rw   256   512  4096          0   1000203083776   /dev/bcache0
> > root@gentooserver /home/nathan # blockdev --report /dev/md0
> > RO    RA   SSZ   BSZ   StartSec            Size   Device
> > rw   256   512  4096          0     14255390720   /dev/md0
> > root@gentooserver /home/nathan # blockdev --report /dev/sda1
> > RO    RA   SSZ   BSZ   StartSec            Size   Device
> > rw   256   512  4096       2048   1000203091968   /dev/sda1
> > root@gentooserver /home/nathan # bcache-super-show /dev/md0
> > sb.magic                ok
> > sb.first_sector         8 [match]
> > sb.csum                 E9D560726742DDAB [match]
> > sb.version              3 [cache device]
> >
> > dev.label               (empty)
> > dev.uuid                cf8bc992-9797-4f47-8d3c-78731f5d1c2e
> > dev.sectors_per_block   8   <<<
>   ^^^^^^^^^^^^^^^^^^^^^^^^^
>
> > dev.sectors_per_bucket  1024
> > dev.cache.first_sector  1024
> > dev.cache.cache_sectors 27841536
> > dev.cache.total_sectors 27842560
> > dev.cache.ordered       yes
> > dev.cache.discard       no
> > dev.cache.pos           0
> > dev.cache.replacement   0 [lru]
> >
> > cset.uuid               45511b33-6bb8-42d5-a255-3de1749f8dda
> > root@gentooserver /home/nathan # bcache-super-show /dev/sda1
> > sb.magic                ok
> > sb.first_sector         8 [match]
> > sb.csum                 7D8A76D84F264724 [match]
> > sb.version              1 [backing device]
> >
> > dev.label               (empty)
> > dev.uuid                d4d2b9d6-077d-4328-b2cd-14f6db259955
> > dev.sectors_per_block   1   <<<
>   ^^^^^^^^^^^^^^^^^^^^^^^^^
>
> I think this is the issue.
>
> Assuming your cache doesn't have data on it yet, try this:
>         make-bcache --block 4k -B /dev/sdX1
>
> --
> Eric Wheeler
>
>
>
> > dev.sectors_per_bucket  1024
> > dev.data.first_sector   16
> > dev.data.cache_mode     0 [writethrough]
> > dev.data.cache_state    0 [detached]
> >
> > cset.uuid               4ae1adfc-b345-419f-9ce0-b450854370b0
> >
> > On Mon, Dec 9, 2019 at 7:15 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > >
> > > On Mon, 9 Dec 2019, Nathan Dehnel wrote:
> > >
> > > > [ 9651.101227] bcache: bch_cached_dev_attach() Couldn't attach sda1:
> > > > block size less than set's block size
> > >
> > > What do these report:
> > >
> > > blockdev --report /dev/bcache0
> > > blockdev --report /dev/sdX     # bcache cache dev
> > > blockdev --report /dev/sdY     # bcache bdev
> > >
> > >
> > > bcache-super-show /dev/sdX # bcache cache dev
> > > bcache-super-show /dev/sdY # bcache bdev
> > >
> > > --
> > > Eric Wheeler
> > >
> > > >
> > > > On Mon, Dec 9, 2019 at 6:30 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > > > >
> > > > > On Mon, 9 Dec 2019, Nathan Dehnel wrote:
> > > > >
> > > > > > root@gentooserver / # echo 45511b33-6bb8-42d5-a255-3de1749f8dda >
> > > > > > /sys/block/bcache0/bcache/attach
> > > > > > -bash: echo: write error: Invalid argument
> > > > >
> > > > > What does `dmesg` say?
> > > > >
> > > > >
> > > > > --
> > > > > Eric Wheeler
> > > > >
> > > > >
> > > > >
> > > > > >
> > > > > > How should I fix this?
> > > > > >
> > > >
> >

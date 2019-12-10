Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E568117D1F
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Dec 2019 02:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfLJBXv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Dec 2019 20:23:51 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:45404 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbfLJBXu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Dec 2019 20:23:50 -0500
Received: by mail-wr1-f49.google.com with SMTP id j42so18141561wrj.12
        for <linux-bcache@vger.kernel.org>; Mon, 09 Dec 2019 17:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R9Ln30ImcSDkitb/hcDfGCOdtBloPFbMB6MP/RAohTs=;
        b=uOHO1cMioYvJJGJaZd5qdABpI6Iuv/51qK4XvxZ5S+uVaLTZeMrSLJkWBs2kzD1Hnf
         O0wYAo3c15VCDIP/hGEzfJBAW8kEpBYeyhPQRh5XCp3tAlDaVqoczYowEIab2RIFSxUN
         bCUDuKyP3mkW/YjXW1UAlbCDK/25HwxxNaK7RWIarBaW5HlV0ysdzBCtPRiLBg9Pxke8
         2tS+P6SOQ/hZbkeq6Sx/IUluxsKPyk/qQf7ZH0N8Oi12b8kwMH4NxW6PF0NfdK0Hz62L
         8dxfRjXj8GyaWz1fULSKZ5Z2A3n7MavhON47tBWyk6r8JTJTtp7FpJyCSB/qYumVM22F
         azkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9Ln30ImcSDkitb/hcDfGCOdtBloPFbMB6MP/RAohTs=;
        b=mo2kVbN6OEu0EzMVmSG3aGmJNZ2hAhR4zE3L1sWtV+V1KPW/fkpxoe68SHc6GRtXyz
         Z5kZE07qK2DhezPhs3bay5aPYAAYILwoLcEAuENUiyo4XRu5yC5w82pv5GkJ7/bgtcTL
         MMTOkk/AYXs/6ojS9rAOTiATD072QG2i+o8lLcW/XXDk6H7+n2jnoLoDivYan6gHCby9
         epSvkK8YL6ZqOvrWl46qEgGSG+AgN3HLpSaSye+7Q3+5cOaVx0Iqmpz57vqE8Zn44mce
         v10NgnaVdC826Aq2Gpx3LCFNrfFlvSyUqmWClqstaivw/agm5/e8vipDQ6Ph+tHnT0CJ
         Msig==
X-Gm-Message-State: APjAAAWoZvyOadA2T1gbYu+KpxRTkOAlxJ29BaOcq+BqF8zv9aseQIPU
        1+ILfTNHKGGciCn9LGVJpoRZR526pFn5RifimGaRY8aZ9iQ=
X-Google-Smtp-Source: APXvYqxBLLHrqX5mhbDY0ehLP/lj1VBVS92I2DD/I6A7BsuO5DEn6G8O21Xitoatgawp3Ti5foSYaCOadXAXlM70CwY=
X-Received: by 2002:a5d:56ca:: with SMTP id m10mr4869206wrw.313.1575941028439;
 Mon, 09 Dec 2019 17:23:48 -0800 (PST)
MIME-Version: 1.0
References: <CAEEhgEtXKoQymHyS278GvE=95jNiW71sb1bz_-2AfOkDPp0dMw@mail.gmail.com>
 <alpine.LRH.2.11.1912100029180.11561@mx.ewheeler.net> <CAEEhgEsy8+aZuEfw5vX_ytKhCq2WxnC=N6AS0msKx_JgJb+=-g@mail.gmail.com>
 <alpine.LRH.2.11.1912100111590.11561@mx.ewheeler.net>
In-Reply-To: <alpine.LRH.2.11.1912100111590.11561@mx.ewheeler.net>
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Mon, 9 Dec 2019 19:23:29 -0600
Message-ID: <CAEEhgEsNabxWPyk5JmAePk5oMnmYOT_wxXy7YseCc3j8Y+2HDw@mail.gmail.com>
Subject: Re: Trying to attach a cache drive gives "invalid argument"
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

root@gentooserver /home/nathan # blockdev --report /dev/bcache0
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw   256   512  4096          0   1000203083776   /dev/bcache0
root@gentooserver /home/nathan # blockdev --report /dev/md0
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw   256   512  4096          0     14255390720   /dev/md0
root@gentooserver /home/nathan # blockdev --report /dev/sda1
RO    RA   SSZ   BSZ   StartSec            Size   Device
rw   256   512  4096       2048   1000203091968   /dev/sda1
root@gentooserver /home/nathan # bcache-super-show /dev/md0
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 E9D560726742DDAB [match]
sb.version              3 [cache device]

dev.label               (empty)
dev.uuid                cf8bc992-9797-4f47-8d3c-78731f5d1c2e
dev.sectors_per_block   8
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 27841536
dev.cache.total_sectors 27842560
dev.cache.ordered       yes
dev.cache.discard       no
dev.cache.pos           0
dev.cache.replacement   0 [lru]

cset.uuid               45511b33-6bb8-42d5-a255-3de1749f8dda
root@gentooserver /home/nathan # bcache-super-show /dev/sda1
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 7D8A76D84F264724 [match]
sb.version              1 [backing device]

dev.label               (empty)
dev.uuid                d4d2b9d6-077d-4328-b2cd-14f6db259955
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.data.first_sector   16
dev.data.cache_mode     0 [writethrough]
dev.data.cache_state    0 [detached]

cset.uuid               4ae1adfc-b345-419f-9ce0-b450854370b0

On Mon, Dec 9, 2019 at 7:15 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
>
> On Mon, 9 Dec 2019, Nathan Dehnel wrote:
>
> > [ 9651.101227] bcache: bch_cached_dev_attach() Couldn't attach sda1:
> > block size less than set's block size
>
> What do these report:
>
> blockdev --report /dev/bcache0
> blockdev --report /dev/sdX     # bcache cache dev
> blockdev --report /dev/sdY     # bcache bdev
>
>
> bcache-super-show /dev/sdX # bcache cache dev
> bcache-super-show /dev/sdY # bcache bdev
>
> --
> Eric Wheeler
>
> >
> > On Mon, Dec 9, 2019 at 6:30 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > >
> > > On Mon, 9 Dec 2019, Nathan Dehnel wrote:
> > >
> > > > root@gentooserver / # echo 45511b33-6bb8-42d5-a255-3de1749f8dda >
> > > > /sys/block/bcache0/bcache/attach
> > > > -bash: echo: write error: Invalid argument
> > >
> > > What does `dmesg` say?
> > >
> > >
> > > --
> > > Eric Wheeler
> > >
> > >
> > >
> > > >
> > > > How should I fix this?
> > > >
> >

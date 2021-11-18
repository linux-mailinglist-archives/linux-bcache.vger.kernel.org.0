Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C541455909
	for <lists+linux-bcache@lfdr.de>; Thu, 18 Nov 2021 11:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243415AbhKRKan (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 18 Nov 2021 05:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243409AbhKRKak (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 18 Nov 2021 05:30:40 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0F1C061570
        for <linux-bcache@vger.kernel.org>; Thu, 18 Nov 2021 02:27:40 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v7so16737902ybq.0
        for <linux-bcache@vger.kernel.org>; Thu, 18 Nov 2021 02:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjp6/TFpdVV5N/lQmQ2M9sjQXnwcl/VH+Pr6DdFrduo=;
        b=A2drXt9d1gdM6EuRCeJfpebzAfzZNDIzi9BFYBNWrRqjKyKE0WiMYogZxTO0NM8MOG
         JVakuuuj8YGFh8HTDemUZ8jhw3uKm5x/HKfsWAM0wP6MJcNLdZWsHYhsPIedUV68xAc+
         NRijm+eBiR/5bm0SAcYCqi0nUS4gTioJ1cuBk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjp6/TFpdVV5N/lQmQ2M9sjQXnwcl/VH+Pr6DdFrduo=;
        b=DeniVzvkhDQyVEH2IlUh9TABQCUhvGjmvbkjlyWVnw6OCXp1l5RSQ/4++R0I3CQQfp
         9hSBHRWVmklN1+4kO8MJudsvdrbiM7ghQ8ul3GjEGSNYpGAYz0SKjI8U4lFJ01sLxkgu
         kTdrYAt48TAvcYGGXX5jmJdNN5sDvrsmagqb42OfbFAia3kYW459FsaKUr5NrkEhsXPN
         uKZXVWl+0g3ApRCjrX0QcXGqODkF74DvnBbixMZ84G2iyjtKJ0/fz96/3l/QsrHqJyx6
         tItgNc17UOO9kv7LDUtWqWepL2Ct3NeYJVpK5aWBYT9pyeOg0Cg35piqrRSeZ8oEgBwq
         S8wg==
X-Gm-Message-State: AOAM532FvS3xkuTKQVc0itI/Z3OOicK5LuvAuddqS/phhgjv1fqOi3Dx
        W9EpZc1oMmvUrSa3rqHaD/7orlbdvbFJqn6dvxqdPw2A7f6Dzw==
X-Google-Smtp-Source: ABdhPJweC8H0oquY/P/uvHrcUIgGMdgl42fKP1Hw4iP94SPPDAY2pDmVH1Y3/z4NGtwnb8aTvrAF23sOV6sUrGV+Xqg=
X-Received: by 2002:a05:6902:134b:: with SMTP id g11mr25887198ybu.202.1637231260054;
 Thu, 18 Nov 2021 02:27:40 -0800 (PST)
MIME-Version: 1.0
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
In-Reply-To: <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 18 Nov 2021 11:27:29 +0100
Message-ID: <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly!

Reading the commit logs, it seems to come from using a non-default
block size, 512 in my case (although I'm pretty sure that *is* the
default on the affected system). I've checked:
```
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
```

The non-affected machines use 4k blocks (sectors per block = 8).

Can this value be changed "on the fly"? I think I remember that the
bdev super block must match the cdev super block - although that
doesn't make that much sense to me.

By "on the fly" I mean: Re-create the cdev super block, then just
attach the bdev - in this case, the sectors per block should not
matter because this is a brand new cdev with no existing cache data.
But I think it will refuse attaching the devices because of
non-matching block size (at least this was the case in the past). I
don't see a point in having a block size in both super blocks at all
if the only block size that matters lives in the cdev superblock.

Thanks
Kai

Am Di., 16. Nov. 2021 um 12:02 Uhr schrieb Coly Li <colyli@suse.de>:
>
> On 11/16/21 6:10 PM, Kai Krakow wrote:
> > Hello Coly!
> >
> > I think I can consistently reproduce a failure mode of bcache when
> > going from 5.10 LTS to 5.15.2 - on one single system (my other systems
> > do just fine).
> >
> > In 5.10, bcache is stable, no problems at all. After booting to
> > 5.15.2, btrfs would complain about broken btree generation numbers,
> > then freeze completely. Going back to 5.10, bcache complains about
> > being broken and cannot start the cache set.
> >
> > I was able to reproduce the following behavior after the problem
> > struck me twice in a row:
> >
> > 1. Boot into SysRescueCD
> > 2. modprobe bcache
> > 3. Manually detach the btrfs disks from bcache, set cache mode to
> > none, force running
> > 4. Reboot into 5.15.2 (now works)
> > 5. See this error in dmesg:
> >
> > [   27.334306] bcache: bch_cache_set_error() error on
> > 04af889c-4ccb-401b-b525-fb9613a81b69: empty set at bucket 1213, block
> > 1, 0 keys, disabling caching
> > [   27.334453] bcache: cache_set_free() Cache set
> > 04af889c-4ccb-401b-b525-fb9613a81b69 unregistered
> > [   27.334510] bcache: register_cache() error sda3: failed to run cache set
> > [   27.334512] bcache: register_bcache() error : failed to register device
> >
> > 6. wipefs the failed bcache cache
> > 7. bcache make -C -w 512 /dev/sda3 -l bcache-cdev0 --force
> > 8. re-attach the btrfs disks in writearound mode
> > 9. btrfs immediately fails, freezing the system (with transactions IDs way off)
> > 10. reboot loops to 5, unable to mount
> > 11. escape the situation by starting at 1, and not make a new bcache
> >
> > Is this a known error? Why does it only hit this machine?
> >
> > SSD Model: Samsung SSD 850 EVO 250GB
>
> This is already known, there are 3 locations to fix,
>
> 1, Revert commit 2fd3e5efe791946be0957c8e1eed9560b541fe46
> 2, Revert commit  f8b679a070c536600c64a78c83b96aa617f8fa71
> 3, Do the following change in drivers/md/bcache.c,
> @@ -885,9 +885,9 @@ static void bcache_device_free(struct bcache_device *d)
>
>                 bcache_device_detach(d);
>
>         if (disk) {
> -               blk_cleanup_disk(disk);
>                 ida_simple_remove(&bcache_device_idx,
>                                   first_minor_to_idx(disk->first_minor));
> +               blk_cleanup_disk(disk);
>         }
>
> The fix 1) and 3) are on the way to stable kernel IMHO, and fix 2) is only my workaround and I don't see upstream fix yet.
>
> Just FYI.
>
> Coly Li
>

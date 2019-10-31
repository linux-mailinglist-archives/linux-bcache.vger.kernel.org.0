Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED694EAD68
	for <lists+linux-bcache@lfdr.de>; Thu, 31 Oct 2019 11:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfJaK3L (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 31 Oct 2019 06:29:11 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40479 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfJaK3L (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 31 Oct 2019 06:29:11 -0400
Received: by mail-qk1-f195.google.com with SMTP id y81so6414718qkb.7
        for <linux-bcache@vger.kernel.org>; Thu, 31 Oct 2019 03:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ioRVVclOVd3ufE+VE82OhlhNUZArPoJLpbMZg4bTfDs=;
        b=W0VFE2/kmmbMdOZA+ATw3VPhJOagKN3tYLsrmx00fnR1x1hfVyeQh87RfWmqeciNgi
         YH2bxXy7qA9eJrZ7OOOtV/HyV9URpB7m6iU65oEF+XbRcF8CSpuHPekA6j0WJJ5xrtmJ
         mb1rHtKsnzrbf6jgbALvTZyxlt1RzHgUPsUfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ioRVVclOVd3ufE+VE82OhlhNUZArPoJLpbMZg4bTfDs=;
        b=M8gy75ZDwlv9osCvebN7u8JCrudDMc3KIfcXtzE0CGcWu6cr1VzyKRkf9EYf0Tbg4Q
         GZCr7igt2XoLaoHrAICJP1PKxlJSO5gtyCfNTb7ITSo4R5EirSGRjMtZ1Drlon8w42Js
         MiIj/Vs4VN2Lf5muTCf9HTuwkbsfoHn9jd+cH35lw+EQ5xOQXelFRGsznp9sWAsnsLrE
         aEHl9pjA3ceIzjqPasGkSg0ImOP6OW/Kpgar7s3k+tzSRbqmonIfXP7YBdd+azZpq/GY
         0vUpnoYPErdnRpoZvoiq7q6rbLGegiyqi0rxqhNaIQPEDmQBNeZoFMplgMngLhZfReHJ
         N5ag==
X-Gm-Message-State: APjAAAWp0EMyWUgkajjy1vlgaRPOkSkkknsb8mo0tR6xCZsKCaHuNRZo
        00A0YjTjHXBWAjihmBhCsPkzAnbbzgkPSpSDzLI6R3S2
X-Google-Smtp-Source: APXvYqypglHFTRtxySzLRw9dWWYJnKBTx4Cg5ufN02wHaMbhXOvz6gOA3p3IRW0nEQzcuqXiuaWzZ1oKy8DHQLNr3IU=
X-Received: by 2002:a37:9b4f:: with SMTP id d76mr4321245qke.439.1572517749913;
 Thu, 31 Oct 2019 03:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
 <alpine.LRH.2.11.1910242322110.25870@mx.ewheeler.net> <fa7a7125-195f-a2ad-4b5e-287c02cd9327@suse.de>
 <89f29562-409b-7b4e-e299-1c8e8db77ea5@nuclearwinter.com> <0b20203f-84c5-ce3e-e9e2-13600cb2d77c@suse.de>
 <1a07d296-82ec-6fa6-bbd4-357a972c0e63@nuclearwinter.com> <CAC2ZOYsrwObbMD+2khsbpiM+e9FUCdiONNQbBMFt9Mx7aXpyZQ@mail.gmail.com>
 <00dfeefe-73f8-eeb8-b256-a51b2002e9e3@nuclearwinter.com>
In-Reply-To: <00dfeefe-73f8-eeb8-b256-a51b2002e9e3@nuclearwinter.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 31 Oct 2019 11:28:58 +0100
Message-ID: <CAC2ZOYtap2wZzJWYqO36Hp9DbFjA4krNZsaPe8BU3fkDe0id0g@mail.gmail.com>
Subject: Re: bcache writeback infinite loop?
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> On 10/30/2019 3:18 PM, Kai Krakow wrote:
> >> I did a scrub with bcache running and 19 errors were found and corrected
> >> using duplicate metadata. That seems encouraging.
> > What kind of scrub? Did it affect bcache caching or backing device?
>
> btrfs scrub. Not sure what, if anything, was actually effected.

So this should do nothing about any loops you're facing in bcache.
Bcache doesn't care about which FS it serves, it's just a bunch of
data. No matter what you fix or reorganize in the background: It's
still a bunch of data to bcache.


> >> Unfortunately, I can't
> >> seem to shut down bcache in order to test as you suggest. I can stop
> >> bcache0 but I am unable to stop the cache device. I do the usual:
> >>
> >> echo 1 > /sys/fs/bcache/dc2877bc-d1b3-43fa-9f15-cad018e73bf6/stop
> > I was seeing a similar issue. I'm not sure "stop" always works as
> > expected. You should try "detach" instead. When it finished writeback
> > eventually, it would detach cache from backing, and upon next mount
> > they won't be attached to each other any longer and you should be able
> > to unmount.
> >
> > If you cannot get rid of dirty data, you could also unregister bcache,
> > then wipe the cache device, and then re-register and force-run the
> > bcache backing device. Tho, discarding write-back data will eventually
> > damage your FS. You should try switching to write-around first and see
> > if you can convince bcache to write back data that way (maybe through
> > a clean reboot after switching to write-around).
>
> Duh, yes, unregistering the backing device did what I needed.

Sometimes it helps to just talk about it again. ;-)


> I'm now
> running a new scrub without the cache device. Interestingly, the initial
> scrub speed with bcache ran at 900MB/s and without bcache it's 1400MB/s.

Yes, I can confirm that bcache throughput performance has degraded a
lot over time. Latency performance is still very good. But I was never
sure if this comes from general kernel changes, btrfs, or bcache
itself.


> Thanks for the un-register tip!

You're welcome.

- Kai

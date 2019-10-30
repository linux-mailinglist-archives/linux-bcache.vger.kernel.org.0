Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBABEA3F5
	for <lists+linux-bcache@lfdr.de>; Wed, 30 Oct 2019 20:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfJ3TSf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 30 Oct 2019 15:18:35 -0400
Received: from mail-qk1-f181.google.com ([209.85.222.181]:39874 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfJ3TSf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 30 Oct 2019 15:18:35 -0400
Received: by mail-qk1-f181.google.com with SMTP id 15so3981326qkh.6
        for <linux-bcache@vger.kernel.org>; Wed, 30 Oct 2019 12:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cv+iPOttunRjr0sP5wBFS3lZSAdfVOYGpn4TlTJ3YZw=;
        b=cPJ6bIWVencLFZb7geBwFHC3l80V3SndIid783A4KPPX0HT49cqAPq6KKw7e+PMRoY
         gOucJnPAS3Lt4cuTCpee4zq6ZIUgzEXZM1TLjE7Si2UJpcwu7gnNx2OuZoI8cP9LGihy
         s3hXCjPRp0qECA/+cktC2uoXBkFqAinFPZC1Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cv+iPOttunRjr0sP5wBFS3lZSAdfVOYGpn4TlTJ3YZw=;
        b=J2MAq3KqAy8Z1CFePUJcqA/embAnA3bje2gDtuD2+5MvS5mdQoVe8ScfI5OHj6mgfv
         FFoSgNHMp/o6IA4DyyUP5lz0vMQ+HlsHOXwgmEnP27MzZ1rwfkYT9vqEXb9rC9fcAK4H
         10MElHCtt3qXP9EOf01EmO9sGLiVg4mPqw8NPqld+1OdAStqWf6ZrKwnBIH/j/JhRvxb
         CXL16Ghzvq4li/7s7YQ3Q38rzm9CsVam+aiFMPqbyewrqpnDDkCHSDfTfy1P5r2qA7Kl
         X6tKsBGxur4RswBM9WgY+QaexCl1uZlxQpVgRpy8qIKHTP+2kg64DYH5vXPLX7gpUp+1
         rq4g==
X-Gm-Message-State: APjAAAWtH4o90w87ZNo/L9AodpuFMicPNsuwqtbxnUrxzVOmOsLhrq1T
        6HaGHkzJujLidMU+wcKgVcbtTh2XjGX3OxF+Uh4y3A==
X-Google-Smtp-Source: APXvYqycbRo2K5U6T46M2a5osFlV0pBfT8U18z3AnheAkZVRHu5U3XPEWpkJSL3efH0x/khJisog05GhdrMG6C+ud/s=
X-Received: by 2002:a37:b345:: with SMTP id c66mr1510945qkf.425.1572463114077;
 Wed, 30 Oct 2019 12:18:34 -0700 (PDT)
MIME-Version: 1.0
References: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
 <alpine.LRH.2.11.1910242322110.25870@mx.ewheeler.net> <fa7a7125-195f-a2ad-4b5e-287c02cd9327@suse.de>
 <89f29562-409b-7b4e-e299-1c8e8db77ea5@nuclearwinter.com> <0b20203f-84c5-ce3e-e9e2-13600cb2d77c@suse.de>
 <1a07d296-82ec-6fa6-bbd4-357a972c0e63@nuclearwinter.com>
In-Reply-To: <1a07d296-82ec-6fa6-bbd4-357a972c0e63@nuclearwinter.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Wed, 30 Oct 2019 20:18:21 +0100
Message-ID: <CAC2ZOYsrwObbMD+2khsbpiM+e9FUCdiONNQbBMFt9Mx7aXpyZQ@mail.gmail.com>
Subject: Re: bcache writeback infinite loop?
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> I did a scrub with bcache running and 19 errors were found and corrected
> using duplicate metadata. That seems encouraging.

What kind of scrub? Did it affect bcache caching or backing device?

> Unfortunately, I can't
> seem to shut down bcache in order to test as you suggest. I can stop
> bcache0 but I am unable to stop the cache device. I do the usual:
>
> echo 1 > /sys/fs/bcache/dc2877bc-d1b3-43fa-9f15-cad018e73bf6/stop

I was seeing a similar issue. I'm not sure "stop" always works as
expected. You should try "detach" instead. When it finished writeback
eventually, it would detach cache from backing, and upon next mount
they won't be attached to each other any longer and you should be able
to unmount.

If you cannot get rid of dirty data, you could also unregister bcache,
then wipe the cache device, and then re-register and force-run the
bcache backing device. Tho, discarding write-back data will eventually
damage your FS. You should try switching to write-around first and see
if you can convince bcache to write back data that way (maybe through
a clean reboot after switching to write-around).


> ... and nothing happens. I assume that's because it can't do a clean
> shutdown. Is there any other way to unload bcache?

I needed to bump the minimum writeback rate up to get that done in time.

But I think you're facing a different problem than I had. My bcache
btree was technically okay.


> My alternative is to dig up a bootable usb drive that doesn't auto-start
> bcache. So far, all of the boot images I've tried init bcache automatically.

You could try disabling the bcache module, or if using dracut,
"rd.break=pre-mount" or similar break-points may work.


HTH
Kai

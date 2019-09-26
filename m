Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05CCBF09C
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Sep 2019 12:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfIZK4M (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 Sep 2019 06:56:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37882 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfIZK4M (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Sep 2019 06:56:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id l3so2292745qtr.4
        for <linux-bcache@vger.kernel.org>; Thu, 26 Sep 2019 03:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Cgf4frUaLMveFOkczz8Ptq+yjvLZmslJxc2/HPQ5pgs=;
        b=MLXtIt68kjeZ6jFNaZvj+8Gx13aaJkSB9ITOvVuwJX9UCiNo0zHkCk/YiTt3XcuOfp
         5eQmPCJkmbdyWmLd0jWGKdG38PPESpJUr0u53Ief/gXUKRCN+F8K1Hq33C6ltlr7wYid
         3GyWPdQO9n7ZU1SyKdkuGRku5UzAcj8Cd6WK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Cgf4frUaLMveFOkczz8Ptq+yjvLZmslJxc2/HPQ5pgs=;
        b=DZrvLhTeQXL1qGhZEXOGXzbvkjCn9hQkpNwDucmR2M9j/M3tKw/kGCVZBSA4vWN+yX
         R8ix2n74SSblmOYGJzjZypk0bJS3GYH3xpWkm/5H0RhCNuJLlO0/4mIhxb/yltbs85An
         a3yZ70KZ8VtL2JjJ39BNZ0fwZtjcnJRmHMdOG/xFMQtLNM3sL8pR+TxRjuIUTgjGXjv/
         QUJOOEYIBuszX2bWYbytmmgS94rXAOXxvnLczyO/2alB5LI6VYbmqaIUD9zsFEeQa5yO
         zuUy30JJTcva1ayh4vhgjxp/5zWkgrA/9/vSWkgQMp8lZATtQr2z4keDRyxBOozPmcLT
         irjw==
X-Gm-Message-State: APjAAAXZszkPXQiGX41CqQllcFGdlFhxCCPqqHJN5WLMX3DimWMKF1Vp
        ADfqP8gQEX3lAwHl9IyiJHIu2p8Cd1L/qYJB1O1mm5BF5nM=
X-Google-Smtp-Source: APXvYqzgjplaDboyxTGtN6uEG65gNxQKlFHL4IPqPmnMTWUGbpRSzTFKFCsK/sAbCUduIYn4M/fNCMpFz9F9l+anxGI=
X-Received: by 2002:ac8:18c2:: with SMTP id o2mr3249285qtk.276.1569495371348;
 Thu, 26 Sep 2019 03:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
 <7d0723a2-c9cf-652a-fecf-699ea389a247@suse.de> <CAC2ZOYs8ucFhUh-dQohMcCjU4FH5QpQkEUD81MPKF-2mnH5O=A@mail.gmail.com>
 <CAG32U2fs0V13hBvNfCojgmOtcGvf1nyLm_1k9iu2Bw6m2bZ8sA@mail.gmail.com>
In-Reply-To: <CAG32U2fs0V13hBvNfCojgmOtcGvf1nyLm_1k9iu2Bw6m2bZ8sA@mail.gmail.com>
From:   Kai Krakow <kai@kaishome.de>
Date:   Thu, 26 Sep 2019 12:56:00 +0200
Message-ID: <CAC2ZOYutqsEFxqRdufgVtipFfeAaFA_owL=gcZ4N3yT8gUggFQ@mail.gmail.com>
Subject: Re: Issue with kernel 5.x
To:     Marcelo RE <marcelo.re@gmail.com>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello!

Am Di., 24. Sept. 2019 um 15:32 Uhr schrieb Marcelo RE <marcelo.re@gmail.co=
m>:

> I have set rootdelay=3D1,2,3,4,5 but it do not solve the problem.
> I will see dracut to see if it works.

Similar to my experience. That worked for a while but later it didn't
because there was a bug in dracut. But that seems fixed now. I removed
all my manual patches and it still works.

If you set a debug breakpoint in dracut (kernel cmdline
"rd.pre-mount=3Dbreak"), then wait for a few seconds, and then resume
dracut and it works from there, it's probably a timing issue. If it's
still missing devices, you can try probing bcache from within the
breakpoint and see if it then resumes properly. While in the
breakpoint, you can also try manually mounting your rootfs to
"/sysroot" and look for error messages. Don't forget to unmount before
rebooting because dracut won't run any shutdown logic when rebooting
from the breakpoint.


> For the record, I use Kubuntu 19.04 in an Asus Strix GL702Z with a
> 256GB SSD and 1TB HD. I have a 100GB SSD partition for the bcache.
> With Kubuntu 16.04, the config with bcache was really fast. 9s to
> start to login and 14s to start all the apps in the previous session
> of KDE.

Yes, back with earlier kernels, I had boot times to full desktop in
under 30 seconds, with rootfs on bcache/btrfs. BTW: When I write "boot
time" I always mean "... to the full desktop" in my following answers.


> When I update, I jump to 18.04. I boot without problem and
> intermediately update to 19.04 and in that moment the kernel change.
> Now it take far more time to boot. Aprox 35s to login plus 20s to show
> the desktop.

I'm seeing this, too: Currently my boot times are at least twice as
long, with a semi-cold bcache even more than a minute. But I'm not
sure where we should look for the problem: Is it in bcache? Is it in
btrfs? Is it somewhere else in the kernel layer? After all, a lot has
changed in memory management, VFS, and drivers... The kernel has
switched to multi-queue, old IO schedulers no longer exist...

Additionally, I turned write-back caching off because I saw effects
that under memory pressure bcache could loose writes to its journal
without noticing it. Upon reboot it would fall over a transaction
missing in the middle of the journal. Also, bcache write-back is sooo
slow (only 4kb/s) that it has no chance of writing back all data to
the disk because my system generates at least 4kb/s writes constantly
(usually 8-12), so the cache is slowly piling up unwritten data. If
something goes wrong, my FS on the backing device is potentially
missing days over days of important metadata writes (because those
mainly go through writeback) and it will be broken just beyond repair.
I've semi-fixed it by bumping the minimum writeback rate to 4 MB/s but
that feels wrong. Or the default is just way too low (it should be
higher than the normal in-flow of a mostly-idle system which would
write log data every once in a while, or updates access metadata).
Maybe it should auto-tune itself somehow. 4 MB/s seemed reasonable to
me as it should still allow good enough random access throughput even
while this rate of writeback is enforced to the backing devices.

But all in all, using bcache feels much less of an improvement to a
desktop system than it did maybe 1-2 years ago. But again: I'm not
sure if we can accuse bcache of that or other changes to the kernel
(and btrfs in my case). Especially, low but constant throughput
write-loads seem to make the system much more sluggish today than
maybe 1-2 years ago.


Regards,
Kai


> El mar., 24 sept. 2019 a las 9:37, Kai Krakow (<kai@kaishome.de>) escribi=
=C3=B3:
> >
> > Hello!
> >
> > I was experiencing that, too. There may be a race in initramfs between
> > the kernel enumerating the bcache devices and the scripts trying to
> > figure out the filesystems. There's two ways around it: The
> > distribution should fix the initramfs scripts to wait longer for
> > rootfs device nodes to appear, or you could try adding rootdelay=3D5 to
> > your kernel cmdline as a temporary workaround (this delays mounting
> > for 5 seconds, you can try different values).
> >
> > I'm using dracut as initramfs generator and it seems fixed since a few
> > versions. I don't think this is a bcache issue: initramfs needs to
> > probe bcache, then the filesystems. It's more likely this is a udev
> > issue.
> >
> > Regards,
> > Kai
> >
> > Am Di., 24. Sept. 2019 um 10:40 Uhr schrieb Coly Li <colyli@suse.de>:
> > >
> > > On 2019/9/24 1:33 =E4=B8=8A=E5=8D=88, Marcelo RE wrote:
> > > > Hi.
> > > >
> > > >  have problems running bcache with the kernel 5.x in KUbuntu. It wo=
rk
> > > > fine with kernel 4.x but fail to start with 5.x. Currently using 5.=
2.3
> > > > (linux-image-unsigned-5.2.3-050203-generic).
> > > > When power on the laptop, sometimes it start to busybox and sometim=
e
> > > > it boot fine.
> > > > If boot to busybox, I just enter reboot until it starts correctly.
> > > > I tested:
> > > > linux-image-4.15.0-29-generic
> > > > linux-image-4.15.0-34-generic
> > > > linux-image-5.0.0-20-generic
> > > > linux-image-5.0.0-21-generic
> > > > linux-image-5.0.0-23-generic
> > > > linux-image-5.0.0-25-generic
> > > > linux-image-5.0.0-27-generic
> > > > linux-image-5.0.0-29-generic
> > > > linux-image-unsigned-5.2.3-050203-generic
> > > >
> > > > What can be done?
> > >
> > > It is not easy to locate the problem by kernel versions. There are qu=
ite
> > > a lot fixes since 4.15 to 5.2.
> > >
> > > If there is any more information or clue, maybe I can help to guess.
> > >
> > > --
> > >
> > > Coly Li

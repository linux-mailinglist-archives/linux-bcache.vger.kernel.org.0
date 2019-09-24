Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC4BBC914
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2019 15:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389812AbfIXNob (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Sep 2019 09:44:31 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:44929 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbfIXNob (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Sep 2019 09:44:31 -0400
Received: by mail-oi1-f193.google.com with SMTP id w6so1640214oie.11
        for <linux-bcache@vger.kernel.org>; Tue, 24 Sep 2019 06:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Bsc6G21KEnBdUw222qkVS6qMOaL1Q97W8x3OkXxb61w=;
        b=ZWxQfHk9LhtJSA8r1Lokq1V4xq008mxJOZVrBoPcihzWb0//xDhZdoswJEVgB7baS3
         24+pqJQOO51JOrytAU3tgHGW5sC79mnte5BXzvIJEOMHxp4eVqLKe9JW8lvo6KR51veD
         rcEBWPtYWI5feq7x0t4CWfK4303Rs6yEJt6KbmGu2GO271dtA4qlHRaTu6JxnUVOaWf1
         WeVf0x6Nci+/aOjFPFJ1UM2FsinKCgxYUe1QjznIPk2IU0e8deG6rWnXV/eQEFM3TL69
         SR/Mz++VEQE+5qeKzuq4Y0SD9zR7lA8kbq6Pc1LAWxvXoWa5HiBAhlah6EnFCq8jfVha
         tTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=Bsc6G21KEnBdUw222qkVS6qMOaL1Q97W8x3OkXxb61w=;
        b=IroQXOMW2nzIodFLLLFCGRTwWKipswC6iJOeRNTPxJXnx2lSphUywVdhf9bg36RdF4
         dr3UulVrc+sivO1Fp4V4XXE3zPKdXnl55oXdcq+5+i2AXAuGzd+bKJYYdIvliDVatGlx
         Pt/4IMf+vbWn88NDsA68ZQvV5KOO1037wjHRzeusmtyrHNK4vMEs+4uB2EkS95XndzYz
         MwTrPYsT2LeO1GT51D6iBpSfjwAZc1T1HjjuB732OVpyZ+vlPq4EdoL8AyF4zjuQYDIh
         hX5lyhOWqBR2co39N6ngpNtLiEYn6bGJgo+fdebtKhUmMayO737ZIoWDnjSZnAShPoNd
         TrLQ==
X-Gm-Message-State: APjAAAWQ5wII32aRxax7+g75+zXaT874aXIC+nDhb1JZnm3s9zvQfvKs
        ERZ5AGMTWikml7loRIs04ob4+nGNxrALHXwsHmDF1jxgcFI=
X-Google-Smtp-Source: APXvYqyjSeAIxl5GupeFLwEH0t8RqK+TNdo/Frtydh7s/ieH71GP4iH5Rn0SfDRjOJvZSi+nmY5Cdt4rxrNgXirTNws=
X-Received: by 2002:aca:5045:: with SMTP id e66mr76535oib.7.1569332670510;
 Tue, 24 Sep 2019 06:44:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
 <7d0723a2-c9cf-652a-fecf-699ea389a247@suse.de> <CAC2ZOYs8ucFhUh-dQohMcCjU4FH5QpQkEUD81MPKF-2mnH5O=A@mail.gmail.com>
 <CAG32U2fs0V13hBvNfCojgmOtcGvf1nyLm_1k9iu2Bw6m2bZ8sA@mail.gmail.com>
From:   Marcelo RE <marcelo.re@gmail.com>
Date:   Tue, 24 Sep 2019 10:44:19 -0300
Message-ID: <CAG32U2dMHxNS_EUuw+C9Y9hzBt_3A2NjnnSmQUvyspQ=GgER0w@mail.gmail.com>
Subject: Re: Issue with kernel 5.x
To:     Kai Krakow <kai@kaishome.de>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Sorry for the last mail. Don't know what happend but I loose what I
wrote. Here again:

Hi Kai.

I have set rootdelay=3D1,2,3,4,5 but it do not solve the problem.
I will see dracut to see if it works.
For the record, I use Kubuntu 19.04 in an Asus Strix GL702Z with a
256GB SSD and 1TB HD. I have a 100GB SSD partition for the bcache.
With Kubuntu 16.04, the config with bcache was really fast. 7s to
start to login and 14s to start all the apps in the previous session
of KDE.
When I update, I jump to 18.04. I boot without problem and
intermediately update to 19.04 and in that moment the kernel change.
Now it take far more time to boot. Aprox 35s to show the login plus
20s to show the desktop.

Regards,

Marcelo

El mar., 24 sept. 2019 a las 10:32, Marcelo RE
(<marcelo.re@gmail.com>) escribi=C3=B3:
>
>
>
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

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36141BC8F6
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2019 15:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfIXNc5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Sep 2019 09:32:57 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:32951 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfIXNc5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Sep 2019 09:32:57 -0400
Received: by mail-oi1-f196.google.com with SMTP id e18so1644098oii.0
        for <linux-bcache@vger.kernel.org>; Tue, 24 Sep 2019 06:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t8PDv33zEbixvTRnALa0j5FnX9qomNRsW2rVYGH5Tko=;
        b=DOy/spWmdokghYgV4jpJki/B5NEtWORhlgzoUq7nK2jUoTJwCRRDkjzVDEAh4wjZws
         VrVqloPcVlw1yWE1fvEh8ZqwihyqFkcZ712iayiGqGGkKhEibA+sCH2d+fzGj7CSYjng
         BGSSrTMKR7jVdrheSxk3uBwEItAIEghxSALLu9UyWsjfTVThV8yLKeLT/NWQ10CrSBBr
         ZrNZZupNHnImjP+mIBO/Oh/dlv7kLnGf6PEMah2Bz0H2DghsmI0ce9rxWLSc01uQ5dmT
         pUmyZjzFIZOjbS5PBXELlOZ5uXwaDgCfO4PoIUoj75BK0FHqS7thyElNO3TaFR721WXY
         qotw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t8PDv33zEbixvTRnALa0j5FnX9qomNRsW2rVYGH5Tko=;
        b=hrDKm+C44zqCyaT7fPB81Uqe9/Oky/otwOeqlSCg3GfRSk4q8q8PhNX/07it9zEOZz
         5/pka0KzDi9FVuME7NMEUAslzt8R5xREqWggCcmKIPWAuSOUwsD4fgef6Q6LfmHFm4hH
         6esHpGOruliFs/2F0WBNOBUtR/9DR9Qixzgq0kNiv2MH3r4iFJzWz3v3NCZ4pkllyf1N
         NSTl5BUfF+4hbc0I2vJ0t2Y5SoItMH810KPkBu5n4buyV1Pfrm56LdWs+NOyA3juKx8P
         z3T3QyphfCw6JFA1WwPOfy7d3+BXkouQCapfBGPqE39Erzxe4/atitgP/xU0l8SxpXj0
         xgPA==
X-Gm-Message-State: APjAAAXpdO2IHN9KL//gir9msDpV2/O63l3Y8dYmq1SxIMgCBkg0qsgd
        1YNnMyUa/GEBWVz7RRQ2ey47cz0oO3uQ/AIhci0=
X-Google-Smtp-Source: APXvYqw9VqGvKXLC2XtQT7H86qERfWcFvI3YfeTdfn9oNl/wOb7Z/L1GInk4QJYIEUsgBUHrcNFDl1A+LYQ02OjY6B0=
X-Received: by 2002:aca:882:: with SMTP id 124mr1983357oii.125.1569331976193;
 Tue, 24 Sep 2019 06:32:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
 <7d0723a2-c9cf-652a-fecf-699ea389a247@suse.de> <CAC2ZOYs8ucFhUh-dQohMcCjU4FH5QpQkEUD81MPKF-2mnH5O=A@mail.gmail.com>
In-Reply-To: <CAC2ZOYs8ucFhUh-dQohMcCjU4FH5QpQkEUD81MPKF-2mnH5O=A@mail.gmail.com>
From:   Marcelo RE <marcelo.re@gmail.com>
Date:   Tue, 24 Sep 2019 10:32:45 -0300
Message-ID: <CAG32U2fs0V13hBvNfCojgmOtcGvf1nyLm_1k9iu2Bw6m2bZ8sA@mail.gmail.com>
Subject: Re: Issue with kernel 5.x
To:     Kai Krakow <kai@kaishome.de>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Kai.

I have set rootdelay=3D1,2,3,4,5 but it do not solve the problem.
I will see dracut to see if it works.
For the record, I use Kubuntu 19.04 in an Asus Strix GL702Z with a
256GB SSD and 1TB HD. I have a 100GB SSD partition for the bcache.
With Kubuntu 16.04, the config with bcache was really fast. 9s to
start to login and 14s to start all the apps in the previous session
of KDE.
When I update, I jump to 18.04. I boot without problem and
intermediately update to 19.04 and in that moment the kernel change.
Now it take far more time to boot. Aprox 35s to login plus 20s to show
the desktop.
Regards,

Marcelo

El mar., 24 sept. 2019 a las 9:37, Kai Krakow (<kai@kaishome.de>) escribi=
=C3=B3:
>
> Hello!
>
> I was experiencing that, too. There may be a race in initramfs between
> the kernel enumerating the bcache devices and the scripts trying to
> figure out the filesystems. There's two ways around it: The
> distribution should fix the initramfs scripts to wait longer for
> rootfs device nodes to appear, or you could try adding rootdelay=3D5 to
> your kernel cmdline as a temporary workaround (this delays mounting
> for 5 seconds, you can try different values).
>
> I'm using dracut as initramfs generator and it seems fixed since a few
> versions. I don't think this is a bcache issue: initramfs needs to
> probe bcache, then the filesystems. It's more likely this is a udev
> issue.
>
> Regards,
> Kai
>
> Am Di., 24. Sept. 2019 um 10:40 Uhr schrieb Coly Li <colyli@suse.de>:
> >
> > On 2019/9/24 1:33 =E4=B8=8A=E5=8D=88, Marcelo RE wrote:
> > > Hi.
> > >
> > >  have problems running bcache with the kernel 5.x in KUbuntu. It work
> > > fine with kernel 4.x but fail to start with 5.x. Currently using 5.2.=
3
> > > (linux-image-unsigned-5.2.3-050203-generic).
> > > When power on the laptop, sometimes it start to busybox and sometime
> > > it boot fine.
> > > If boot to busybox, I just enter reboot until it starts correctly.
> > > I tested:
> > > linux-image-4.15.0-29-generic
> > > linux-image-4.15.0-34-generic
> > > linux-image-5.0.0-20-generic
> > > linux-image-5.0.0-21-generic
> > > linux-image-5.0.0-23-generic
> > > linux-image-5.0.0-25-generic
> > > linux-image-5.0.0-27-generic
> > > linux-image-5.0.0-29-generic
> > > linux-image-unsigned-5.2.3-050203-generic
> > >
> > > What can be done?
> >
> > It is not easy to locate the problem by kernel versions. There are quit=
e
> > a lot fixes since 4.15 to 5.2.
> >
> > If there is any more information or clue, maybe I can help to guess.
> >
> > --
> >
> > Coly Li

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E81E8BC7F0
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Sep 2019 14:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405876AbfIXMhy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Sep 2019 08:37:54 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41538 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405807AbfIXMhx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Sep 2019 08:37:53 -0400
Received: by mail-qk1-f196.google.com with SMTP id p10so1548700qkg.8
        for <linux-bcache@vger.kernel.org>; Tue, 24 Sep 2019 05:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=z0Sg2SkQ8FLz0xNXphFBeLB0T9RekhOQkVah0RfhhVc=;
        b=e/zIOfIj5zfYqTzlF3cCDARI7ZqHubo4MsMqf+S+fUFuL2IhmdlCNOsMk8qDnjaopp
         RhnakPMEBX79fPRC/Dk8+TAcZ62pX44XYgYwyooShRqXi2VCrSyAo1zPF+SMG/72Wenx
         zd6CH8QrnVroRKYYyTXGt0UG67vVuy2QB35QI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=z0Sg2SkQ8FLz0xNXphFBeLB0T9RekhOQkVah0RfhhVc=;
        b=cxa6sOSJf9a5MGYyH62KsgRfRIHhJq7hX5rxReieVM2JK1LmQV/jHD8FDqPXRTErYp
         HtL2CoF1pl5BIi5bMVwUErYja+/DqE5dusDjUq7u8SGUNF5TT018zzdFIHvJdYktbQNJ
         sfiULDwN6KlSj6M5Kxa2bG3HbOOqD1eHrHlpmlFK3hTvEMMJAU+WrUlv79v8W/z1CZk2
         USMhKoHfoRhPgvPJYx+BKgVsE4LK4Z0Ja61M/vNyU5U+s1OSLsbZH9YquOWAWtA9BQ9I
         3rQDZtoP89CnsK2Hdd2jggTmrDylCwawYCo7V54rdkoi91pn1cvrRPHaSMdGBmNaIBd3
         r77w==
X-Gm-Message-State: APjAAAUqVDvObaK64qxRX90ML+57ryPViVM3K3poN4XNUStiIR4ivcWZ
        BeCpgDxoBZKXUaNZiJE7mK6m+DaCUpkNSS3aqQsybQ==
X-Google-Smtp-Source: APXvYqzqYx0vtACxoLqB/UH677ePSgjjC3fP0LifuRw/85qpCtonS/mSZV3h/WHXy9EXWQX9fsxCrPAZvXR/YmmFzD4=
X-Received: by 2002:a37:ea18:: with SMTP id t24mr1959579qkj.425.1569328671479;
 Tue, 24 Sep 2019 05:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAG32U2fdDmaSzgCsuc4JVB4L0w_QujcbiK8YWMNVv+Sj4TdbvQ@mail.gmail.com>
 <7d0723a2-c9cf-652a-fecf-699ea389a247@suse.de>
In-Reply-To: <7d0723a2-c9cf-652a-fecf-699ea389a247@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 24 Sep 2019 14:37:40 +0200
Message-ID: <CAC2ZOYs8ucFhUh-dQohMcCjU4FH5QpQkEUD81MPKF-2mnH5O=A@mail.gmail.com>
Subject: Re: Issue with kernel 5.x
To:     Coly Li <colyli@suse.de>
Cc:     Marcelo RE <marcelo.re@gmail.com>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello!

I was experiencing that, too. There may be a race in initramfs between
the kernel enumerating the bcache devices and the scripts trying to
figure out the filesystems. There's two ways around it: The
distribution should fix the initramfs scripts to wait longer for
rootfs device nodes to appear, or you could try adding rootdelay=3D5 to
your kernel cmdline as a temporary workaround (this delays mounting
for 5 seconds, you can try different values).

I'm using dracut as initramfs generator and it seems fixed since a few
versions. I don't think this is a bcache issue: initramfs needs to
probe bcache, then the filesystems. It's more likely this is a udev
issue.

Regards,
Kai

Am Di., 24. Sept. 2019 um 10:40 Uhr schrieb Coly Li <colyli@suse.de>:
>
> On 2019/9/24 1:33 =E4=B8=8A=E5=8D=88, Marcelo RE wrote:
> > Hi.
> >
> >  have problems running bcache with the kernel 5.x in KUbuntu. It work
> > fine with kernel 4.x but fail to start with 5.x. Currently using 5.2.3
> > (linux-image-unsigned-5.2.3-050203-generic).
> > When power on the laptop, sometimes it start to busybox and sometime
> > it boot fine.
> > If boot to busybox, I just enter reboot until it starts correctly.
> > I tested:
> > linux-image-4.15.0-29-generic
> > linux-image-4.15.0-34-generic
> > linux-image-5.0.0-20-generic
> > linux-image-5.0.0-21-generic
> > linux-image-5.0.0-23-generic
> > linux-image-5.0.0-25-generic
> > linux-image-5.0.0-27-generic
> > linux-image-5.0.0-29-generic
> > linux-image-unsigned-5.2.3-050203-generic
> >
> > What can be done?
>
> It is not easy to locate the problem by kernel versions. There are quite
> a lot fixes since 4.15 to 5.2.
>
> If there is any more information or clue, maybe I can help to guess.
>
> --
>
> Coly Li

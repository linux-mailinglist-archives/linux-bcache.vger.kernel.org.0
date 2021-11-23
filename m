Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12794459F47
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Nov 2021 10:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhKWJd4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 23 Nov 2021 04:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhKWJd4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 23 Nov 2021 04:33:56 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B92FC061574
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 01:30:48 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id y68so57896612ybe.1
        for <linux-bcache@vger.kernel.org>; Tue, 23 Nov 2021 01:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oz0iiMllorbmPWOBFabruE+ufobzM7owpyAcUmGiIVA=;
        b=STxuDjloUd/fXwbt92aOsuwjjywfyiXUkenM7CH0Alr2AJ5DaYrg+nbGZK1wXclCYB
         LvPRa3utZ78hEPKamt+9Ji2hKiKHVCHyGs4vGGJku94zbxSHRhcWlaGXb6gUmRjTlWBL
         D6v5KIwFnNfFX4+zQZkXeuc9+2FANW40afujM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oz0iiMllorbmPWOBFabruE+ufobzM7owpyAcUmGiIVA=;
        b=k1n3hhdj5zZLr9B4sQH4BaFnxlBZMdTys88tiEA77OtrLjHkIUTkMsNbxjUT0iHcEF
         WfmiyYUZ1gsrQKAXEPYHcbnjsypxRsYtdGIZ6KuTclRtQF+2pD5wmWdI6+/0OXtAws5i
         yH2YUeytENjNXYbwwVlEy+idZGg1VLnaIyu9Zgz7vwyK0Dm/NzeiNIsKKlySpwHnpYEe
         987BMJUB9/L9dqsFQb3+RHeTpuyvXvSm50OxMU8KPXyPJLIVModsUQ70hTdqXsr4uh6u
         A8OnUifDYAJRxrYrGY8CD8sFA6Io5BS0AlP+nB2InKOZuPC4MNaR7ikORqWh372aIJeK
         YClQ==
X-Gm-Message-State: AOAM533Fs/bsGfcReRIY8Hfkd5Ng+QxQHm7sYNJ5xefo6K5jiBqww45O
        mqyPLz1AcQrDBL23kJGpgdjZ19TwA41On1I1VM90tA==
X-Google-Smtp-Source: ABdhPJwVceuVS2rc5ypnvbdkDKX/1aS9gheBimjNzYY8Eu92WyOzBGWJy0JexmElSrc71KAedxqeuOrtMy/NslxtsWQ=
X-Received: by 2002:a25:30a:: with SMTP id 10mr4723549ybd.492.1637659847768;
 Tue, 23 Nov 2021 01:30:47 -0800 (PST)
MIME-Version: 1.0
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de> <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net> <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
In-Reply-To: <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 23 Nov 2021 10:30:36 +0100
Message-ID: <CAC2ZOYuTP4ErWELz93JWCTbDK_1pNABdktW3ejWMWhzE942j1w@mail.gmail.com>
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org,
        =?UTF-8?B?RnLDqWTDqXJpYyBEdW1hcw==?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Di., 23. Nov. 2021 um 09:54 Uhr schrieb Coly Li <colyli@suse.de>:
>
> On 11/20/21 8:06 AM, Eric Wheeler wrote:
> > (Fixed mail header and resent, ignore possible duplicate message and
> > reply to this one instead because the From header was broken.)
> >
> >
> > Hi Coly, Kai, and Kent, I hope you are well!
> >
> > On Thu, 18 Nov 2021, Kai Krakow wrote:
> >
> >> Hi Coly!
> >>
> >> Reading the commit logs, it seems to come from using a non-default
> >> block size, 512 in my case (although I'm pretty sure that *is* the
> >> default on the affected system). I've checked:
> >> ```
> >> dev.sectors_per_block   1
> >> dev.sectors_per_bucket  1024
> >> ```
> >>
> >> The non-affected machines use 4k blocks (sectors per block =3D 8).
> > If it is the cache device with 4k blocks, then this could be a known is=
sue
> > (perhaps) not directly related to the 5.15 release. We've hit a before:
> >    https://www.spinics.net/lists/linux-bcache/msg05983.html
> >
> > and I just talked to Fr=C3=A9d=C3=A9ric Dumas this week who hit it too =
(cc'ed).
> > His solution was to use manufacturer disk tools to change the cachedev'=
s
> > logical block size from 4k to 512-bytes and reformat (see below).
> >
> > We've not seen issues with the backing device using 4k blocks, but bcac=
he
> > doesn't always seem to make 4k-aligned IOs to the cachedev.  It would b=
e
> > nice to find a long-term fix; more and more SSDs support 4k blocks, whi=
ch
> > is a nice x86 page-alignment and may provide for less CPU overhead.
> >
> > I think this was the last message on the subject from Kent and Coly:
> >
> >       > On 2018/5/9 3:59 PM, Kent Overstreet wrote:
> >       > > Have you checked extent merging?
> >       >
> >       > Hi Kent,
> >       >
> >       > Not yet. Let me look into it.
> >       >
> >       > Thanks for the hint.
> >       >
> >       > Coly Li
>
> I tried and I still remember this, the headache is, I don't have a 4Kn
> SSD to debug and trace, just looking at the code is hard...
>
> If anybody can send me (in China to Beijing) a 4Kn SSD to debug and
> testing, maybe I can make some progress. Or can I configure the kernel
> to force a specific non-4Kn SSD to only accept 4K aligned I/O ?

I think you can switch at least SOME models to native 4k?

https://unix.stackexchange.com/questions/606072/change-logical-sector-size-=
to-4k

> Changing a HDD to native 4k sectors works at least with WD Red Plus 14 TB=
 drives but LOSES ALL DATA. The data is not actually wiped but partition ta=
bles and filesystems cannot be found after the change because of their now =
incorrect LBA locations.
>
> hdparm --set-sector-size 4096 --please-destroy-my-drive /dev/sdX

HTH
Kai

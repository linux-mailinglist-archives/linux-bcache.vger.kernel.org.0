Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FE31417C8
	for <lists+linux-bcache@lfdr.de>; Sat, 18 Jan 2020 14:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgARNuP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 18 Jan 2020 08:50:15 -0500
Received: from mail-qk1-f170.google.com ([209.85.222.170]:37263 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgARNuO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Jan 2020 08:50:14 -0500
Received: by mail-qk1-f170.google.com with SMTP id 21so25690246qky.4
        for <linux-bcache@vger.kernel.org>; Sat, 18 Jan 2020 05:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=1d9zLs93t+1ev+IAHTAQVGWcO+rJ7cYB/qqimN7mMz0=;
        b=N9ACceYZajfZk5m32N5zLf7/LdbGgRQDSGLDhWBJbVL1PIWcyEM19nEPcd/EZmU8jQ
         lGqc9RWgBIki0AgwuIHZQQffCr+xjevU2MaDEefKIfLbyqtIhADnNoZJWt6At6076M4L
         oKZH15LqPjHKzuHBYOQ0wN7HZUdjgkdEtIsQWYUOkBkPmb2LxQX2G9Y8EqayxUQmJCjK
         wI6kFNdPeQCGwcFeSlQYR+z0K+PV1y1acKFhDpdQWH8Ye7IkXfOb/xrVjK6MBpFARO0U
         MLen72nISG9MP5r0zA9bFgY64c8jGoqpkfLJztdgqGk3PdARSfup4tKMasBC+5DlOsAU
         Uy2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=1d9zLs93t+1ev+IAHTAQVGWcO+rJ7cYB/qqimN7mMz0=;
        b=WTjDA7vQOHwcC99FO1fKKLQJSjyyEragMKNVtRVGoO99V1o63GpvoVyZbFbu2uzMAY
         xD4BDAsR+PJWxGyZ5gjhhJ/AtmD9VKOUTsJTx/gBxJqKwd+JshQpVhvLyqfzrC0ND5xJ
         CY2o2epjiDS1c6uOyS1Nox66o3X+gu6GtIp6cAVIdNq7zx7SKKHtQl0vUVi+pTwVXZPT
         i/JO2QTKFFlV3rQRMVtEIqDw1xOOlY8OmPJ6r3bRgBf0bt1hnHlnRlHxZCUvkuM3lkgR
         sORP2aKTjn4QpI2BhygIwMk2jewyRE3ItsfXdrflqU48mq9eSlQGUJ5D1EHG1W2yxe5B
         R61g==
X-Gm-Message-State: APjAAAU+D1RFQ1fXNNID2t+jLcWktXHENxGjy6KbzYlHUaxPVmEjlI6O
        WiOuqIThqH+tWrUC6z5VXK+cm7tCdvMYz8wKoH50GP8ENHdiNQ==
X-Google-Smtp-Source: APXvYqy3201twJmeeaOELVwUIMo/QipGnr0UeVQbPl46iA7JMiDxtJ28KtlVG3pXDU/KVYNAsy+QJilKOQ4UB7qMGz4=
X-Received: by 2002:a37:e203:: with SMTP id g3mr42733366qki.479.1579355024165;
 Sat, 18 Jan 2020 05:43:44 -0800 (PST)
MIME-Version: 1.0
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de> <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de> <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com>
 <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
 <32fb3244-cb9e-460d-3156-99e418dda44f@suse.de> <CA+Z73LE8GEHqvsFqNuQ3+aSbSmC93D68zd+gTw8Hk=78RjUj7A@mail.gmail.com>
 <CA+Z73LFpXFOcWNzn3nMN7kCWjzUa0myQiOc+tozFbNZGemxXhA@mail.gmail.com> <43edbec0-d29f-dcdb-2cf3-791a937a3090@suse.de>
In-Reply-To: <43edbec0-d29f-dcdb-2cf3-791a937a3090@suse.de>
Reply-To: clodoaldo.pinto.neto@gmail.com
From:   Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
Date:   Sat, 18 Jan 2020 10:43:33 -0300
Message-ID: <CA+Z73LEuZCw6EHG386jZrqUKuqGw0E8z+nEvrNmLQ0NLzh9+kw@mail.gmail.com>
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing device)
To:     Coly Li <colyli@suse.de>
Cc:     "Jens-U. Mozdzen" <jmozdzen@nde.ag>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Jan 18, 2020 at 9:35 AM Coly Li <colyli@suse.de> wrote:
>
> On 2020/1/18 8:22 =E4=B8=8B=E5=8D=88, Clodoaldo Neto wrote:
> > On Sat, Jan 18, 2020 at 7:54 AM Clodoaldo Neto
> > <clodoaldo.pinto.neto@gmail.com> wrote:
> >>
> >> On Thu, Jan 16, 2020 at 9:59 PM Coly Li <colyli@suse.de> wrote:
> >>>
> >>> On 2020/1/17 5:52 =E4=B8=8A=E5=8D=88, Clodoaldo Neto wrote:
> >>>>
> >>>> Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de
> >>>> <mailto:colyli@suse.de>> escreveu:
> >>>>>
> >>>>> On 2020/1/13 8:44 =E4=B8=8B=E5=8D=88, Jens-U. Mozdzen wrote:
> >>>>>> Hi Coly,
> >>>>>>
> >>>>>> jumping in here, because I was looking for a way to revert from bc=
ache
> >>>>>> to plain device:
> >>>>>>
> >>>>>> Zitat von Coly Li <colyli@suse.de <mailto:colyli@suse.de>>:
> >>>>>>> The super block location of the backing disk is occupied by bcach=
e. You
> >>>>>>> cannot mount the file system directly from the backing disk which=
 is
> >>>>>>> formated as bcache backing device [...] (bcache offset all I/Os o=
n
> >>>>>>> bcache device 4KB behind the requesting
> >>>>>>> LBA on backing disk).
> >>>>>>
> >>>>>> Assuming that no caching device is associated with a backing devic=
e (so
> >>>>>> the backing device is "clean" as in "containing all data blocks wi=
th the
> >>>>>> current content"), could one convert the content of a backing devi=
ce to
> >>>>>> a "non-bcached device" by removing the first 4096 octets of the ba=
cking
> >>>>>> device content?
> >>>>>>
> >>>>>> Something like "dd if=3Dbackingdev of=3Dnewdev skip_bytes=3D4096 .=
.."?
> >>>>>
> >>>>> Hi Jens-U,
> >>>>>
> >>>>> you may try dmsetup to setup a linear device mapper target, and the=
 map
> >>>>> table just skipping the first 4KB (bcache superblock area). If you =
are
> >>>>> lucky, I mean the real file system is not corrupted, the created de=
vice
> >>>>> mapper target can be mounted directly.
> >>>>
> >>>>
> >>>> I'm trying dmsetup but it does not accept anything other than 0 and =
0
> >>>> at the beginning and end of the table:
> >>>>
> >>>> # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup
> >>>> create dmb
> >>>> device-mapper: reload ioctl on dmb  failed: Invalid argument
> >>>> Command failed.
> >>>
> >>> The above line should work, if 3774578672 is a correct size number in
> >>> sectors.
> >>
> >> I took it from the original map:
> >>
> >> # dmsetup table /dev/mapper/backing-device
> >> 0 3774578672 crypt aes-xts-plain64
> >> :64:logon:cryptsetup:7e2c0b40-8dec-4b13-8d00-b53b55160775-d0 0 251:0
> >> 32768
> >
> > It works like this:
> >
> > # echo '0 3774578664 linear /dev/mapper/backing-device 8' | dmsetup cre=
ate dmb
> >
> > But then I can't mount it:
> >
> > # mount /dev/mapper/dmb /r
> > mount: /r: wrong fs type, bad option, bad superblock on
> > /dev/mapper/dmb, missing codepage or helper program, or other error.
>
> It might be my fault, from bcache-tools, it seems the offset is
> BDEV_DATA_START_DEFAULT (16 sectors). How about:
> # echo '0 3774578656 linear /dev/mapper/backing-device 16' | dmsetup
> create dmb

Still no luck

# echo '0 3774578656 linear /dev/mapper/backing-device 16' | dmsetup create=
 dmb
# mount /dev/mapper/dmb /r
mount: /r: wrong fs type, bad option, bad superblock on
/dev/mapper/dmb, missing codepage or helper program, or other error.

Clodoaldo
>
>
> --
>
> Coly Li

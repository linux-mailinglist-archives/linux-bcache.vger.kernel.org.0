Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74832141713
	for <lists+linux-bcache@lfdr.de>; Sat, 18 Jan 2020 11:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgARKya (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 18 Jan 2020 05:54:30 -0500
Received: from mail-qt1-f174.google.com ([209.85.160.174]:46055 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbgARKya (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Jan 2020 05:54:30 -0500
Received: by mail-qt1-f174.google.com with SMTP id w30so23834021qtd.12
        for <linux-bcache@vger.kernel.org>; Sat, 18 Jan 2020 02:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=aHoqcdcjoYVhvWhOltpuPss8/aZXQEBXsEMdTTJ4a8s=;
        b=MgLOhCAZF+bFXxHmImBHUkjuLw41pRc4sX5CdN8Spy6QAHA6Fldb0W3ayvoGPavHQn
         URbSipKEkSJ66sK5nisYf1z5FL85a7hlDZ7AFfkLDp78UkouF6C+8pmsXiSM0T5ehPq7
         nC7BMnZvrXrZo6diWOy2wSIj++Bq44i6MgseosbeqDomtkRodSKuy7YeqgAkeaB9CVVI
         XfQWPKKH8UhtJKgbHBepbixN9SlG3sMDJGQsY3ZbSO71QpUBk+caQUaF5Xy4XBfGlrRi
         9cZ5+oCphjONhqUohkeeZbUDJ2IXgY5Ef/EfCGyzMiepugu2175XEWDEgc5g7rrzDCQi
         N5mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=aHoqcdcjoYVhvWhOltpuPss8/aZXQEBXsEMdTTJ4a8s=;
        b=sJ08iVKh1lc0P24peorft5VEtemBpOgIuLmvZ8uF5uwBR+3ewENwJhjbPpdHH/GZgj
         87QwEfVlrJGR7p+eBrsrOX8yAxOfKdefZz5eDKxMOr5lgnAhTPuuG9/zJ/wkEF7tXV7A
         61/38DmYU7f/dnR5KW4oA5PoR6MNWEE81iQ5zOw6Uegv1KTphbZfpX9iLpQWWFlFWkJd
         bdqq7cKQq8Q4k7FuRP5SfCxwpVjo7zBdG3YNDjdvZDEJ8dkRnkTtMg88USbGhlHfG3it
         IzwHtNKFSUOHmfKwNpuAJ1u0r+KLpuWaXXmnQl9Tzbwq4eoEztR5OxVX8B6ANL7enNIv
         PWNw==
X-Gm-Message-State: APjAAAXNFI+ZfCtqsoxRBwSeiXVYxW4ISFtsKMjLwCpA26xK0Lgah5oF
        8kOsCq1LVXNLqWIWqGw5ldL6oFFeylpij8LENykXbXN/Oqg=
X-Google-Smtp-Source: APXvYqzn4o+4gTBvbjFWAyss27V8Y30aFl+OhaWRDJac7QK4WNp6HfcfxczkRgXU7DA/G/USn8pQie5ksiQiwu+1iVg=
X-Received: by 2002:ac8:7088:: with SMTP id y8mr11246842qto.325.1579344869252;
 Sat, 18 Jan 2020 02:54:29 -0800 (PST)
MIME-Version: 1.0
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de> <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de> <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com>
 <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com> <32fb3244-cb9e-460d-3156-99e418dda44f@suse.de>
In-Reply-To: <32fb3244-cb9e-460d-3156-99e418dda44f@suse.de>
Reply-To: clodoaldo.pinto.neto@gmail.com
From:   Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
Date:   Sat, 18 Jan 2020 07:54:18 -0300
Message-ID: <CA+Z73LE8GEHqvsFqNuQ3+aSbSmC93D68zd+gTw8Hk=78RjUj7A@mail.gmail.com>
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing device)
To:     Coly Li <colyli@suse.de>
Cc:     "Jens-U. Mozdzen" <jmozdzen@nde.ag>, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jan 16, 2020 at 9:59 PM Coly Li <colyli@suse.de> wrote:
>
> On 2020/1/17 5:52 =E4=B8=8A=E5=8D=88, Clodoaldo Neto wrote:
> >
> > Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de
> > <mailto:colyli@suse.de>> escreveu:
> >>
> >> On 2020/1/13 8:44 =E4=B8=8B=E5=8D=88, Jens-U. Mozdzen wrote:
> >> > Hi Coly,
> >> >
> >> > jumping in here, because I was looking for a way to revert from bcac=
he
> >> > to plain device:
> >> >
> >> > Zitat von Coly Li <colyli@suse.de <mailto:colyli@suse.de>>:
> >> >> The super block location of the backing disk is occupied by bcache.=
 You
> >> >> cannot mount the file system directly from the backing disk which i=
s
> >> >> formated as bcache backing device [...] (bcache offset all I/Os on
> >> >> bcache device 4KB behind the requesting
> >> >> LBA on backing disk).
> >> >
> >> > Assuming that no caching device is associated with a backing device =
(so
> >> > the backing device is "clean" as in "containing all data blocks with=
 the
> >> > current content"), could one convert the content of a backing device=
 to
> >> > a "non-bcached device" by removing the first 4096 octets of the back=
ing
> >> > device content?
> >> >
> >> > Something like "dd if=3Dbackingdev of=3Dnewdev skip_bytes=3D4096 ...=
"?
> >>
> >> Hi Jens-U,
> >>
> >> you may try dmsetup to setup a linear device mapper target, and the ma=
p
> >> table just skipping the first 4KB (bcache superblock area). If you are
> >> lucky, I mean the real file system is not corrupted, the created devic=
e
> >> mapper target can be mounted directly.
> >
> >
> > I'm trying dmsetup but it does not accept anything other than 0 and 0
> > at the beginning and end of the table:
> >
> > # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup
> > create dmb
> > device-mapper: reload ioctl on dmb  failed: Invalid argument
> > Command failed.
>
> The above line should work, if 3774578672 is a correct size number in
> sectors.

I took it from the original map:

# dmsetup table /dev/mapper/backing-device
0 3774578672 crypt aes-xts-plain64
:64:logon:cryptsetup:7e2c0b40-8dec-4b13-8d00-b53b55160775-d0 0 251:0
32768

>
> >
> > # echo '8 3774578664 linear /dev/mapper/backing-device 0' | dmsetup
> > create dmb
> > device-mapper: reload ioctl on dmb  failed: Invalid argument
> > Command failed.
> >
> > I'm not sure about how it works. Is it not 8 sectors for 4k bytes?
> >
>
> It works on my side, my kernel is Linux v5.5-rc2, lvm2 version is
> 2.02.180, dmsetup version is 1.02.149. The difference is the device
> size, my disk size is much less.
>
> --
>
> Coly Li

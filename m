Return-Path: <linux-bcache+bounces-860-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83D65A80C73
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 15:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5FF5017B6
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 13:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1241F1A8F84;
	Tue,  8 Apr 2025 13:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNfk1Y+P"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA1782899;
	Tue,  8 Apr 2025 13:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744118924; cv=none; b=VD8VBHEvAF7NXvuy6QiMo1An+EXbTvtVDfq+JcpxB7L4fEUnSrnoNHKokTL5VaQxt3j+oG+O23suhN4sNs2PYqVcyfnMVn9SpjWT4ww3wIoAgn5Pg2lQz4tAlgmLmyqwCM+N/QphZ5h9uzMvUk7/6dc0QsBh5Ko8oxiIa/CMH/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744118924; c=relaxed/simple;
	bh=mRavdQhL1DtEwVkn4eshOK9bHbUZ9e8U1h5lXfkfZxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bvVyAKTURvA4FlfHlczySQ+QBqw0+YI5W4NUwB6mB29V5ITj2PMON1sPz0ylkYgg/MXmCFQVkQpNv32rhIN3+bIFgrsXPfvryWuli2ka5MVaGO3vF9k/HDKMa6YXf434uacoFqBmITBJT3gTzBm+k0s6gEHJwSP+PuHuQ4GbuC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNfk1Y+P; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7c08fc20194so1058342785a.2;
        Tue, 08 Apr 2025 06:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744118921; x=1744723721; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwUccFj/IlodGJeJZB3OFwnoyGFO8e7MmCQycSPGjCw=;
        b=UNfk1Y+Pb05QZ4QVxMT/Nu+J6KtgGvZMadkAdSWET2/3GoywHt/b/7tKZu2PWwmJhT
         sA/y1zBjIv6q6XiG4cmP9N1v9BlP1b9DZpJEbD4NIPC3AF+YL0CAPPLc8cWGVYR+AFhE
         o+ZFZ541PDe8ghM195TcByBAAhhth556o2YRJY0XtXxH9CWaxtQE8kKg978ah9AGHDvy
         Mg9i5Rq7F5+1TeXzDx5SHjX23uQQZ3mOfY12F5RCtDMRi9TM5R2zA6wiPSk7+pWloDUq
         VmoNyhnVbrpAvAsnZo2KD/KRgDhQK//BJRImmvWH+SVExLMPhfxmD7EETxwlOx1aCH3k
         K8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744118921; x=1744723721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwUccFj/IlodGJeJZB3OFwnoyGFO8e7MmCQycSPGjCw=;
        b=EaesfcOwbkxq+NmxOxoY0RrUD1gHtfLajQmbg5FBwj3OElrK4ucupvnPHNxH66JZVq
         ShNTCrddPA39MJcLtGBkB4RAIP1Aj/hEkaSlAJBZBuG0kXY5NgYCKYmeTNI0Jbjg+j0C
         aRb2N9of7muCrDM9NubZ1FliXz3p3SD6UUYr+ZIlnF3J/a5SH/HHA/m0AlA4jfwfNMN8
         8Ge8SGv9VIWJx1GQBDhjlsy/MTzcPGnEHbs7S4yFrgjQ2EHg1fPqkUuLJf1XKBcph+TT
         zpe0Nag2d3xNrbwwt4CxS3/bdSl4dz1/K1pWHSwAc+2EKi7AeHchTOQhPGh5tPWNTXhG
         lO7A==
X-Forwarded-Encrypted: i=1; AJvYcCUa/aauv8J+h3gaOozdGkVfN1UtotGsP8zn/3lgCjoswYVlx18tzzkYKa6Fg5PDYiz0Z/Iid1qZsQ6yEsU=@vger.kernel.org, AJvYcCXmdTuMSi+ROwXUxm0y6409/RQKcJ59vriBvOqnoh08osIW8yba7ZxcWdwB8LxXPG4qLGm/uRSf+P1ptpg+@vger.kernel.org
X-Gm-Message-State: AOJu0Yy44820wpdsYgWTMRAyrJEtv0IRZQALUFYxLJTlollvJrw2oepB
	rjzTI7NKW6+rQfhRj3/hqjWB4r5WaHM5nBExBD4JEuFtBDwNK2iOuU1161ZyARAuL3Bnly+MQyk
	MPNwYACiT1qQT32wjYPOGS86o9l+xmwx7uPw=
X-Gm-Gg: ASbGncss8fVA3qTn3K23mB8IHPwvZv1RcDxfGdYh1VN9RqTDRgmGO0xGMkqJqOgxxv8
	pmZUsBJt0CYgJjlTV/sClJJCnbbwfSIPiV4Gkan9xh0amztBoc/fzg8zbRqvYbFMq00sKWUui91
	UupgRLEbMhamloKDYo9EVPod61e1VNGPUNit7jH7C0tC6MGVKCmgF8Dzq1BA==
X-Google-Smtp-Source: AGHT+IHr8oAZ9ILp/+vmcbU4Qrch200Fo7fv0NJkBS9PHMuY3WdaclWR5R52F1Tff1FAlcZ+9m1h9VrKFNMNmvVs2b4=
X-Received: by 2002:a05:620a:4544:b0:7c5:44d0:7dbb with SMTP id
 af79cd13be357-7c774d5d871mr2469271585a.28.1744118921014; Tue, 08 Apr 2025
 06:28:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250408033322.401680-1-gshahrouzi@gmail.com> <20250408033322.401680-3-gshahrouzi@gmail.com>
 <7muoawncdumcsclkcxklw6olqcjko63et26ptbh5lidximffoh@lu34aqtcujtn>
 <CAKUZ0zKWDVocdSa60ZZPjq9u24wEW+EaUsXoUrrCF=Z+pacGHQ@mail.gmail.com> <zqhlvh3jftam6ka5hu7ardcnaeyzvbvbmttjqubeeutuhcmurp@dsgpwpwvgj6y>
In-Reply-To: <zqhlvh3jftam6ka5hu7ardcnaeyzvbvbmttjqubeeutuhcmurp@dsgpwpwvgj6y>
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Date: Tue, 8 Apr 2025 09:27:00 -0400
X-Gm-Features: ATxdqUG56mAfd5E_qXTksehi_Hqmq4fEX4-kUMk8_Qch3TsiTY4D0y6G2rlkzh0
Message-ID: <CAKUZ0zKp0r0ydTSFrdkUBzG+rWXDvP5uwVYZ+C8Xwy9wvZU-3w@mail.gmail.com>
Subject: Re: [PATCH 2/2] bcache: Fix warnings for incorrect type in assignments
To: Coly Li <colyli@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	kernelmentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 6:39=E2=80=AFAM Coly Li <colyli@kernel.org> wrote:
>
> On Tue, Apr 08, 2025 at 03:15:00AM +0800, Gabriel Shahrouzi wrote:
> > On Tue, Apr 8, 2025 at 12:58=E2=80=AFAM Coly Li <colyli@kernel.org> wro=
te:
> > >
> > > On Mon, Apr 07, 2025 at 11:33:22PM +0800, Gabriel Shahrouzi wrote:
> > > > Remove unnecessary cpu_to_le16() and cpu_to_le32() conversions when
> > > > assigning values (priorities, timestamps) to native integer type
> > > > members. Prevent incorrect byte ordering for big-endian systems.
> > > >
> > >
> > > Hmm, why do you feel the conversions are unncessary? Please explain
> > > with details.
> > I used Sparse for static analysis on bcache and it gave incorrect type
> > in assignment warnings.
> >
> > For example:
> >
> > u->invalidated =3D cpu_to_le32((u32)ktime_get_real_seconds());
> >
> > ktime_get_real_seconds() returns back u64 and gets casted down to a
> > u32. u is of type struct uuid_entry whose member fields are either u8,
> > u32, or u64. A conversion here contradicts the type it should be
> > assigned.
> >
> > From my understanding, this would not produce an unexpected result if
> > the value were to be read from or written to some location which seems
> > to be the case here. I believe it would only cause issues on
> > big-endian systems if the value were to be modified in some way.
> >
>
> Yes you are right, and I agree with you.
>
>
> > Looking at the commit history for when the code for this specific
> > example was first introduced (12 years ago), it seems like this was
> > the author=E2=80=99s intent. It looks like the intention was to store t=
he
> > value as little endian in uint32_t. Doing this, the author saves space
> > / time. If the type was le32 instead, the conversion would have to be
> > applied each time it=E2=80=99s used. Alternatively, if another member v=
ariable
> > was defined but for the le32 version, then extra space is used up.
> >
>
> This is kind of convention that on-media values are stored in little
> endian, for portablity purpose. But bcache is special, current
> implementation and usage don't require/support portability on different
> byte order machines. So cpu_to/from_le** routines are almostly
> unnecessary indeed.
>
> *BUT* the cast (u32) works as expected on big endian machine as well,
> same result generated as little indian machine does. The out-of-order
> issue on big endian machine for the code you mentioned won't happen.
Got it.
>
> > In the unlikely event that these specific files change drastically,
> > making sure the types are the same serves as a preventative measure
> > to make sure it=E2=80=99s not misused. On the other hand, making the ch=
ange
> > most likely goes against the author=E2=80=99s original intent and could=
 cause
> > something unintended.
> > >
> > > I don't mean the modification is correct or incorrect, just want to
> > > see detailed analysis and help me understand in correct why as you
> > > are.
> > >
> > > BTW, did you have chance to test your patch on big-endian machine?
> > I only analyzed the compilation warnings so far. I=E2=80=99ll look into=
 trying
> > to test this on a big-endian machine.
> >
> >
>
> You may have a try and verify my statement.
>
> And for the change in bch_prio_write(), this is something out of your
> orignal scope of this patch. The prio width is 16bits, byte order and
> length truncation issue doesn't apply here.
Ah I should have been more clear about this when explaining. My main
concern was with the endian conversion which is what prompted me to
group them together.
>
> After all, no mather the cpu_to_le*() or le*_to_cpu() routines are used
> or not, the code works well. Because bcache cache device dosn't port
> between big and little endian machines.
Ah ok this makes sense when considering the use case of bcache.
>
> I don't want to unify the code to all use cpu_to_le*() routines or
> remove all these routines, both sides make sense and resonable.
> IMHO they are just changes for changing. So I intend to keep it as what
> Kent orignally wrote it.
Makes sense.
>
> Thanks.
>
> > > > Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
> > > > ---
> > > >  drivers/md/bcache/super.c | 12 ++++++------
> > > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > > > index e42f1400cea9d..c4c5ca17fb600 100644
> > > > --- a/drivers/md/bcache/super.c
> > > > +++ b/drivers/md/bcache/super.c
> > > > @@ -648,7 +648,7 @@ int bch_prio_write(struct cache *ca, bool wait)
> > > >               for (b =3D ca->buckets + i * prios_per_bucket(ca);
> > > >                    b < ca->buckets + ca->sb.nbuckets && d < end;
> > > >                    b++, d++) {
> > > > -                     d->prio =3D cpu_to_le16(b->prio);
> > > > +                     d->prio =3D b->prio;
> > > >                       d->gen =3D b->gen;
> > > >               }
> > > >
> > > > @@ -721,7 +721,7 @@ static int prio_read(struct cache *ca, uint64_t=
 bucket)
> > > >                       d =3D p->data;
> > > >               }
> > > >
> > > > -             b->prio =3D le16_to_cpu(d->prio);
> > > > +             b->prio =3D d->prio;
> > > >               b->gen =3D b->last_gc =3D d->gen;
> > > >       }
> > > >
> > > > @@ -832,7 +832,7 @@ static void bcache_device_detach(struct bcache_=
device *d)
> > > >
> > > >               SET_UUID_FLASH_ONLY(u, 0);
> > > >               memcpy(u->uuid, invalid_uuid, 16);
> > > > -             u->invalidated =3D cpu_to_le32((u32)ktime_get_real_se=
conds());
> > > > +             u->invalidated =3D (u32)ktime_get_real_seconds();
> > > >               bch_uuid_write(d->c);
> > > >       }
> > > >
> > > > @@ -1188,7 +1188,7 @@ void bch_cached_dev_detach(struct cached_dev =
*dc)
> > > >  int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set =
*c,
> > > >                         uint8_t *set_uuid)
> > > >  {
> > > > -     uint32_t rtime =3D cpu_to_le32((u32)ktime_get_real_seconds())=
;
> > > > +     uint32_t rtime =3D (u32)ktime_get_real_seconds();
> > > >       struct uuid_entry *u;
> > > >       struct cached_dev *exist_dc, *t;
> > > >       int ret =3D 0;
> > > > @@ -1230,7 +1230,7 @@ int bch_cached_dev_attach(struct cached_dev *=
dc, struct cache_set *c,
> > > >           (BDEV_STATE(&dc->sb) =3D=3D BDEV_STATE_STALE ||
> > > >            BDEV_STATE(&dc->sb) =3D=3D BDEV_STATE_NONE)) {
> > > >               memcpy(u->uuid, invalid_uuid, 16);
> > > > -             u->invalidated =3D cpu_to_le32((u32)ktime_get_real_se=
conds());
> > > > +             u->invalidated =3D (u32)ktime_get_real_seconds();
> > > >               u =3D NULL;
> > > >       }
> > > >
> > > > @@ -1591,7 +1591,7 @@ int bch_flash_dev_create(struct cache_set *c,=
 uint64_t size)
> > > >
> > > >       get_random_bytes(u->uuid, 16);
> > > >       memset(u->label, 0, 32);
> > > > -     u->first_reg =3D u->last_reg =3D cpu_to_le32((u32)ktime_get_r=
eal_seconds());
> > > > +     u->first_reg =3D u->last_reg =3D (u32)ktime_get_real_seconds(=
);
> > > >
> > > >       SET_UUID_FLASH_ONLY(u, 1);
> > > >       u->sectors =3D size >> 9;
> > > > --
> > > > 2.43.0
> > > >
> > >
> > > --
> > > Coly Li
> >
>
> --
> Coly Li


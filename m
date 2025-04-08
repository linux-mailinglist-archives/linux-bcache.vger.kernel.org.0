Return-Path: <linux-bcache+bounces-858-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD8E0A7F5BE
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 09:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B04175027
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 07:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B31825F965;
	Tue,  8 Apr 2025 07:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IGNNlSAU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91FF25FA0F;
	Tue,  8 Apr 2025 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744096524; cv=none; b=HoZPX5wyRfjD94pSANEHS0Ka8YJNazLtwPgcQAdOjPltv9EGE467jTHIyr9Sop+bHSoGb2MMFxMJH4iJWJkpNDHEGlZ0pQQ0lZ+YtqnlfVLmwMrBNmW61xKz1ZNXNVisrNFlVNWYRHimo91bMQdMcDh/vHL6eFawiKl7zDHYJdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744096524; c=relaxed/simple;
	bh=w79wsZ+Z3zvxnUteGzbjczmdUN5Ud24ThtVl5U+j6xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ehCuDOM2Y/8eBVFryAVLsZ57r25k6zKnDqrOXatCMKrSanZGt58t7auxalhSjdKFBh3Aais1mdLA16nrMFYNhMTXXg71upBy7YTRdPjxf7axAZQmXlmlrNObbx/rAPtS0mj6QEopmLa4fjaSqSvaLAcbEhtSR7K1qXGJ8nLjcWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IGNNlSAU; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-47663aeff1bso47079511cf.0;
        Tue, 08 Apr 2025 00:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744096521; x=1744701321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4fUW/nDY6dt7KyQHcmGyhHOCX6yvJ4vqRJp6uTh4Dk=;
        b=IGNNlSAUO3iS3qHACgTQtihIUKzg5KvJSFGFOm4uyacwIqwjsMpAKdOpLC/487SVDD
         X8Pfbo8K9NwniUspzgvXAOGRAdkAfxn8cqKWfVghVQY1hyAdLLhYQLGCiQ5qEz6gMNly
         NgpvwfgnXBWkhHH6kbr1m41HIIxbX0D5rbhYIDXbB7DdcBwGoiNkKyGQ6TbhPJBpucAR
         s3e5rrPAPNy7hPKEK5E7I9o5Tiy3cLelmklASHg7uTs0wH7jkKqUndmpRLxU1I0atPeT
         urIcyqAjdN4TecgjKmdjzUVwCttCVztX4aGkkO8Omlk+LX6rwTdXdx94rfNo1kTScuyh
         1jtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744096521; x=1744701321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4fUW/nDY6dt7KyQHcmGyhHOCX6yvJ4vqRJp6uTh4Dk=;
        b=cj5v6XxnuuQ30c+EevClL09W5i6XasrIiJA5u8hrp95mrGTuAQ5FeNLHvytZG2ZIis
         ShaNZxTwrVlybNUNyZMfBYOXyL1r3DWiTOPKE7aREZH1b/hffX93uVqJhauXI7BqBa0C
         dbLzR8ewr5UbaCP1+pEoZt7y46g9yCJKGSjLsTTPOKTzcLwOVF+EJf58zE9AnT/grHVh
         i+AicZ9ZX7D8j6Y9nb+7gYJRgyDH6u1iaEGOkiGMBplhgk89f64gOABBzUR3/HexHS2n
         DtFIsVOVU4hBXf7jy+BjNr6mJbAR+XTi6iAYz5k0XXFL+D7NwsrBHfyutaYmq7wcuu7W
         ZPkg==
X-Forwarded-Encrypted: i=1; AJvYcCVkqN1zmuKSCXz8AdtpXeuRsCsyF5VXEsMtsVB+JsRyoQo3eOA3rhVbIhiiqQzg1k+MOsX4DWZ253yOJto8@vger.kernel.org, AJvYcCWHGVoztIT9IMQPVt8E8PSJZLiXDUENsIkUXHc2H9LyskwiItTm8AHxGaHklT6llWMTujvTW1OtU1Bj/8g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxgqv+vH+/C+sz0VrrqvhX/N83+hLHsBLwxIbvnLJV9fnrl3cdV
	FFR27zz7AgXjSHv6XhD8Ox9M/+6MT3eNDHPiZvQfJcTbu5Pfv6ex7pwMcbWaWAaXrUtNzEQrNs/
	DhGPUH3JcpUKvTWU/ksrzpQMoApH9lFVc3z4=
X-Gm-Gg: ASbGncvInbpnf1vPUtH+AD6zp9xsUMaUvEfQ+cpR9DRqR08u6L5GIQPHWCHlNKjFdw1
	IbjxeQhK96rrGMMhgfAP+UVTu0PT8bHDzN3XtSal+pR78yg9MqBijb8fP+iMk4pTuVqJDp3tgBm
	Tc9G+cAaRkHbsfxCuVyI/RZYLemgbY28K3XpwoB1aM5c+UQzZ0/7koT28eVA==
X-Google-Smtp-Source: AGHT+IE3QPodmDDoq2scPLjifIAKN6EhHjqSM3us4hHgKtwjH+njxwgHT0RLwG1U29V7IyhwIcx7h8RR/7sSNmr2no8=
X-Received: by 2002:ac8:7d8a:0:b0:476:8c68:dcbc with SMTP id
 d75a77b69052e-47930f5064cmr129579801cf.9.1744096521423; Tue, 08 Apr 2025
 00:15:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250408033322.401680-1-gshahrouzi@gmail.com> <20250408033322.401680-3-gshahrouzi@gmail.com>
 <7muoawncdumcsclkcxklw6olqcjko63et26ptbh5lidximffoh@lu34aqtcujtn>
In-Reply-To: <7muoawncdumcsclkcxklw6olqcjko63et26ptbh5lidximffoh@lu34aqtcujtn>
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Date: Tue, 8 Apr 2025 03:15:00 -0400
X-Gm-Features: ATxdqUGyy3-JgqqBSrqvELuHcNhq2Y3RCtUWedAqomuG1z8PZ_996LyWmnSlJh4
Message-ID: <CAKUZ0zKWDVocdSa60ZZPjq9u24wEW+EaUsXoUrrCF=Z+pacGHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] bcache: Fix warnings for incorrect type in assignments
To: Coly Li <colyli@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	kernelmentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 12:58=E2=80=AFAM Coly Li <colyli@kernel.org> wrote:
>
> On Mon, Apr 07, 2025 at 11:33:22PM +0800, Gabriel Shahrouzi wrote:
> > Remove unnecessary cpu_to_le16() and cpu_to_le32() conversions when
> > assigning values (priorities, timestamps) to native integer type
> > members. Prevent incorrect byte ordering for big-endian systems.
> >
>
> Hmm, why do you feel the conversions are unncessary? Please explain
> with details.
I used Sparse for static analysis on bcache and it gave incorrect type
in assignment warnings.

For example:

u->invalidated =3D cpu_to_le32((u32)ktime_get_real_seconds());

ktime_get_real_seconds() returns back u64 and gets casted down to a
u32. u is of type struct uuid_entry whose member fields are either u8,
u32, or u64. A conversion here contradicts the type it should be
assigned.

From my understanding, this would not produce an unexpected result if
the value were to be read from or written to some location which seems
to be the case here. I believe it would only cause issues on
big-endian systems if the value were to be modified in some way.

Looking at the commit history for when the code for this specific
example was first introduced (12 years ago), it seems like this was
the author=E2=80=99s intent. It looks like the intention was to store the
value as little endian in uint32_t. Doing this, the author saves space
/ time. If the type was le32 instead, the conversion would have to be
applied each time it=E2=80=99s used. Alternatively, if another member varia=
ble
was defined but for the le32 version, then extra space is used up.

In the unlikely event that these specific files change drastically,
making sure the types are the same serves as a preventative measure
to make sure it=E2=80=99s not misused. On the other hand, making the change
most likely goes against the author=E2=80=99s original intent and could cau=
se
something unintended.
>
> I don't mean the modification is correct or incorrect, just want to
> see detailed analysis and help me understand in correct why as you
> are.
>
> BTW, did you have chance to test your patch on big-endian machine?
I only analyzed the compilation warnings so far. I=E2=80=99ll look into try=
ing
to test this on a big-endian machine.


>
> Thanks.
>
>
> > Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
> > ---
> >  drivers/md/bcache/super.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index e42f1400cea9d..c4c5ca17fb600 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -648,7 +648,7 @@ int bch_prio_write(struct cache *ca, bool wait)
> >               for (b =3D ca->buckets + i * prios_per_bucket(ca);
> >                    b < ca->buckets + ca->sb.nbuckets && d < end;
> >                    b++, d++) {
> > -                     d->prio =3D cpu_to_le16(b->prio);
> > +                     d->prio =3D b->prio;
> >                       d->gen =3D b->gen;
> >               }
> >
> > @@ -721,7 +721,7 @@ static int prio_read(struct cache *ca, uint64_t buc=
ket)
> >                       d =3D p->data;
> >               }
> >
> > -             b->prio =3D le16_to_cpu(d->prio);
> > +             b->prio =3D d->prio;
> >               b->gen =3D b->last_gc =3D d->gen;
> >       }
> >
> > @@ -832,7 +832,7 @@ static void bcache_device_detach(struct bcache_devi=
ce *d)
> >
> >               SET_UUID_FLASH_ONLY(u, 0);
> >               memcpy(u->uuid, invalid_uuid, 16);
> > -             u->invalidated =3D cpu_to_le32((u32)ktime_get_real_second=
s());
> > +             u->invalidated =3D (u32)ktime_get_real_seconds();
> >               bch_uuid_write(d->c);
> >       }
> >
> > @@ -1188,7 +1188,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
> >  int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
> >                         uint8_t *set_uuid)
> >  {
> > -     uint32_t rtime =3D cpu_to_le32((u32)ktime_get_real_seconds());
> > +     uint32_t rtime =3D (u32)ktime_get_real_seconds();
> >       struct uuid_entry *u;
> >       struct cached_dev *exist_dc, *t;
> >       int ret =3D 0;
> > @@ -1230,7 +1230,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, =
struct cache_set *c,
> >           (BDEV_STATE(&dc->sb) =3D=3D BDEV_STATE_STALE ||
> >            BDEV_STATE(&dc->sb) =3D=3D BDEV_STATE_NONE)) {
> >               memcpy(u->uuid, invalid_uuid, 16);
> > -             u->invalidated =3D cpu_to_le32((u32)ktime_get_real_second=
s());
> > +             u->invalidated =3D (u32)ktime_get_real_seconds();
> >               u =3D NULL;
> >       }
> >
> > @@ -1591,7 +1591,7 @@ int bch_flash_dev_create(struct cache_set *c, uin=
t64_t size)
> >
> >       get_random_bytes(u->uuid, 16);
> >       memset(u->label, 0, 32);
> > -     u->first_reg =3D u->last_reg =3D cpu_to_le32((u32)ktime_get_real_=
seconds());
> > +     u->first_reg =3D u->last_reg =3D (u32)ktime_get_real_seconds();
> >
> >       SET_UUID_FLASH_ONLY(u, 1);
> >       u->sectors =3D size >> 9;
> > --
> > 2.43.0
> >
>
> --
> Coly Li


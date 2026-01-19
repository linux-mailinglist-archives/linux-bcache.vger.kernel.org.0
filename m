Return-Path: <linux-bcache+bounces-1378-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1ED6D39F22
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 07:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD6B230A59AB
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 06:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C150A29B764;
	Mon, 19 Jan 2026 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hy7SdXq+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA4F28B7DB
	for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 06:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768805673; cv=pass; b=CYW5M3Xi3Af/YmLBbwGWHHBAlUJwwESuGXyy0BUqL6zBknEVCqoFaJBUAXccuUeCU68liqqdoHqF0gLRWu/Vm1mir7MVzV03rXdQC4LVbWGHgVlyNBXBMruRaAALSH/OrKZ7QNH9TvajUW4bgawkWALdujcSg5fQRNgN0V5WQqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768805673; c=relaxed/simple;
	bh=Fyp4sXzC5fOPcRRVIIMH0LH0uN2MlzPNOQSYkw7yzRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RBCLpmL/UDJD1wybRs4IJWRgsqmwfsM/V37AL1/+9KGsUbWon17lPZ2kk9kwMMBM3UVSC92EFDA3I8/LhKg9Bi47qrPGhx0p8f9lrBn3PlxNrMsBdGWEQk7mXemTuoyNbGPfNZHmy6YQzg9MEX068jyKDlfBpBEjii8FHg3NS5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hy7SdXq+; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88a367a1dbbso65753586d6.0
        for <linux-bcache@vger.kernel.org>; Sun, 18 Jan 2026 22:54:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768805669; cv=none;
        d=google.com; s=arc-20240605;
        b=JjPeHb5i7gdOwz3RugZoO3r3PJz8yG8eKcPhRO2U8p9l3KGQEs2J7Yp/mp+Y1S8hkD
         JTeDP9Ia9mijp1QgH39ISAZSO26q2RF3MG8ma8SQCUr+M2wuTQF9MBL1nnNQNRPdEDyU
         +GqJHijXhzW6T4wv8rHHIMctMHgNim9oOOPtis+NCpmKO060QZmGm1RD9DxA1FYlNX9i
         tMSX/t+/o4sK4nSq8bLysaKOlBeeIRfLRwBr4HwJwX0wcnMDd1CYmKRj5Ax3VoSCRp/N
         zZj9wGJCQFuRPRwVJGZv8julSGBcgx03NEg5tyG6/jwKjHJRvoYqxT4aVxodYbdY+bAZ
         obHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AgcNM7mHtaO+OL/6KOJnHbvIv967ZgFdsxMSYCeBbzg=;
        fh=RuYgbzNMpr2/L5/1rYAgCUoaakVfwb47aMXR+zR+jvg=;
        b=gN97N6oM8AOQ+2ei4yhjveLlXJ15QsTcgJ3lAIiRdFSEdwueP4Dp/OePPVcpg6Pa7Z
         ecbSyf9Lyk2OasGVYoTwAaksDO8U+0c/fXHF8ZvyGh//tTROtuDcUieeIma/oO2nsi+R
         Cx67wYq3PRcIXp1VNirItUH8H/cyLYNUjB7dNb+k0IORNmDt/BnXqu+yu4FcKrXSV6Ex
         UwUcc5uVwNrt0BofiRBezoeOQ/8QQdVBgaH6qB2b9I0TtjWucFO4OxRgdAWjabrqushu
         AhZLF9b8jdRkCsmLIFor+tnkP4DNZCz4vhfwu7ldT7MZrJL2O0QrMrDiNwIZJeqwJyVc
         E82A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768805669; x=1769410469; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgcNM7mHtaO+OL/6KOJnHbvIv967ZgFdsxMSYCeBbzg=;
        b=hy7SdXq+AC4Anbo0TZ2JWhTyHco0UsF51iLpu88ozj2gUpEkJI7QIWdbp7aordWSna
         qAChw5u4ZGXoZLiCyJj24+9elahPRo83UraJNYxjOAiADw35o0xEJ6TTCLhY6QCeC7Nh
         +2Quv80M7btJ7D+AtvtN6mCVO8PDxXkyFEj4jOm9rqz/5pu9+RwM4zk4Rq1z/RnViM8A
         fonjLb7s2z2KWrbejdYOYbwSGsDMvdjEU1FhhtQVy4noqAPAH6MgBAoup3DTegvFyxHY
         tANiDwIKoz7DIjxfwcWcW2v5SmgOv0CdDpo1NUxF/qjuY56LJlBglTstPz9ZKXxZVFR0
         Qhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768805669; x=1769410469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AgcNM7mHtaO+OL/6KOJnHbvIv967ZgFdsxMSYCeBbzg=;
        b=SAvx8ch7JixrBcVfTiY4LfIsSGUzm5JCdU2+xZowlRrzyj/LRtxJL+QhOjXyiqbY/C
         OWxW5dcZoDbu/j/+1b0qEldTAiGPbaOAOdcMqKk4U6qIV1kr7oyrENs6IjhP9WSQ+Beo
         6Xa8I78/6jg9Oy4uMPfZtlwIROKOoCN3i/osokNfJfPMaZEUdqO44/hc4KbyHWK1zd5g
         FpFcneohyojtMG+jkeRmLwjplThMHcjiBi8pertkOlOHFPVeRsc4+f7ezFnIcGO4FocR
         C/v77H+dr4kDjjHbAumvzqQXFhG7IlFsOlKTB2se8Tyt7u3VKz7xJVy7a+1GGrHNBK5e
         Af6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLwjEMcu1HlWsFM4CKbQ+nG2UjpSWcpCnAqi3+8DaYq/u6/tdHYcprmNJfUeVlEsk1X59xxVZR/lrJZRk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6FA3/2kioBf+iM79kPAshePTNbg1bD2q7LlV5msKNhNPTzYto
	c8Ac1x2gZkz26YlbmgxAEwyn1a5i0FC8V1dPrpRZAoZKcJEaroX7lM6RYPO4u49AZ9OLbt5ZZ7c
	NvUD1fCftaqM/Y+qpXk8lHQ+BYvzwLwk=
X-Gm-Gg: AY/fxX5bkC5C3e5JKeJ43A8RHgKC+tz68jALmi0fNksADM+m7PzyWYjM8QWRvx/T7Lu
	Pp5rz37s1bwcbuKacqijD+kCN0olbbGOuxg3kgIjBLBBeiv5Dlj93GZIlZvzN0liDz8Uvs2LctV
	dmuyCxyhauvHOncR9OROBNF1HxJYsy8UVy+mgW/6K839hhUk2/EpuaK2JUa8jpMxh5zFU65ho2V
	wz5qYmZY55k76ijiL1Hh9caDBQOBryvSiYexyEm4ByBaG021ndpmc4H6+L6i/4FJL2wFXLlJGJ0
	S488tg==
X-Received: by 2002:a05:622a:199c:b0:4ed:dec2:301a with SMTP id
 d75a77b69052e-502a1e1da21mr180408531cf.16.1768805669514; Sun, 18 Jan 2026
 22:54:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
 <aWilW0RKQiHJzpsZ@infradead.org> <aWzIU3ASp139lHNz@studio.local>
In-Reply-To: <aWzIU3ASp139lHNz@studio.local>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 19 Jan 2026 14:53:53 +0800
X-Gm-Features: AZwV_QjxfteoFX-hsTfB_BenCT4nI5WDeUb6xxa4uPnuwLNDVEpVwo_4BjhrVzQ
Message-ID: <CANubcdWajHf_vJQpcsmLvU8U=Vd9Q2=9E4_mpncRy2A0iiMnWQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix double bio_endio completion in detached_dev_end_io
To: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, kent.overstreet@linux.dev, axboe@kernel.dk, 
	sashal@kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Coly Li <colyli@fnnas.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=8818=E6=97=A5=E5=
=91=A8=E6=97=A5 19:49=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jan 15, 2026 at 12:29:15AM +0800, Christoph Hellwig wrote:
> > Can you please test this patch?
> >
>
> Shida,
> can you also test it and confirm? We need to get the fix in within 6.19 c=
ycle.
>
> Yes, we need to make a dicision ASAP.
> I prefer the clone bio solution, and it looks fine to me.
>
> Thanks in advance.
>
> Coly Li
>
>
>
>
> > commit d14f13516f60424f3cffc6d1837be566e360a8a3
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Tue Jan 13 09:53:34 2026 +0100
> >
> >     bcache: clone bio in detached_dev_do_request
> >
> >     Not-yet-Signed-off-by: Christoph Hellwig <hch@lst.de>
> >

Thank you, Coly and Christoph, for giving me the opportunity to continue
your outstanding work on this patch.

If given the chance to complete the next steps, I will begin by adding a
proper commit message:

bcache: use bio cloning for detached device requests

Previously, bcache hijacked the bi_end_io and bi_private fields of the inco=
ming
bio when the backing device was in a detached state. This is fragile and
breaks if the bio is needed to be processed by other layers.

This patch transitions to using a cloned bio embedded within a private
structure.
This ensures the original bio's metadata remains untouched.

Co-developed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>


Additionally, I would like to conduct a thorough code review to identify an=
y
potential issues that may not be easily caught through normal testing.

> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index 82fdea7dea7a..9e7b59121313 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
> > @@ -1078,67 +1078,66 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
> >  }
> >
> >  struct detached_dev_io_private {
> > -     struct bcache_device    *d;
> >       unsigned long           start_time;
> > -     bio_end_io_t            *bi_end_io;
> > -     void                    *bi_private;
> > -     struct block_device     *orig_bdev;
> > +     struct bio              *orig_bio;
> > +     struct bio              bio;
> >  };
> >
> >  static void detached_dev_end_io(struct bio *bio)
> >  {
> > -     struct detached_dev_io_private *ddip;
> > -
> > -     ddip =3D bio->bi_private;
> > -     bio->bi_end_io =3D ddip->bi_end_io;
> > -     bio->bi_private =3D ddip->bi_private;
> > +     struct detached_dev_io_private *ddip =3D
> > +             container_of(bio, struct detached_dev_io_private, bio);
> > +     struct bio *orig_bio =3D ddip->orig_bio;
> >
> >       /* Count on the bcache device */
> > -     bio_end_io_acct_remapped(bio, ddip->start_time, ddip->orig_bdev);
> > +     bio_end_io_acct(orig_bio, ddip->start_time);
> >
> >       if (bio->bi_status) {
> > -             struct cached_dev *dc =3D container_of(ddip->d,
> > -                                                  struct cached_dev, d=
isk);
> > +             struct cached_dev *dc =3D bio->bi_private;
> > +
> >               /* should count I/O error for backing device here */
> >               bch_count_backing_io_errors(dc, bio);
> > +             orig_bio->bi_status =3D bio->bi_status;
> >       }
> >

bio_init_clone must be paired with a bio_uninit() call before the
memory is freed?

+ bio_uninit(bio);


Thanks,
Shida

> >       kfree(ddip);
> > -     bio_endio(bio);
> > +     bio_endio(orig_bio);
> >  }
> >
> > -static void detached_dev_do_request(struct bcache_device *d, struct bi=
o *bio,
> > -             struct block_device *orig_bdev, unsigned long start_time)
> > +static void detached_dev_do_request(struct bcache_device *d,
> > +             struct bio *orig_bio, unsigned long start_time)
> >  {
> >       struct detached_dev_io_private *ddip;
> >       struct cached_dev *dc =3D container_of(d, struct cached_dev, disk=
);
> >
> > +     if (bio_op(orig_bio) =3D=3D REQ_OP_DISCARD &&
> > +         !bdev_max_discard_sectors(dc->bdev)) {
> > +             bio_endio(orig_bio);
> > +             return;
> > +     }
> > +
> >       /*
> >        * no need to call closure_get(&dc->disk.cl),
> >        * because upper layer had already opened bcache device,
> >        * which would call closure_get(&dc->disk.cl)
> >        */
> >       ddip =3D kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO=
);
> > -     if (!ddip) {
> > -             bio->bi_status =3D BLK_STS_RESOURCE;
> > -             bio_endio(bio);
> > -             return;
> > -     }
> > -
> > -     ddip->d =3D d;
> > +     if (!ddip)
> > +             goto enomem;
> > +     if (bio_init_clone(dc->bdev, &ddip->bio, orig_bio, GFP_NOIO))
> > +             goto free_ddip;
> >       /* Count on the bcache device */
> > -     ddip->orig_bdev =3D orig_bdev;
> >       ddip->start_time =3D start_time;
> > -     ddip->bi_end_io =3D bio->bi_end_io;
> > -     ddip->bi_private =3D bio->bi_private;
> > -     bio->bi_end_io =3D detached_dev_end_io;
> > -     bio->bi_private =3D ddip;
> > -
> > -     if ((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
> > -         !bdev_max_discard_sectors(dc->bdev))
> > -             detached_dev_end_io(bio);
> > -     else
> > -             submit_bio_noacct(bio);
> > +     ddip->orig_bio =3D orig_bio;
> > +     ddip->bio.bi_end_io =3D detached_dev_end_io;
> > +     ddip->bio.bi_private =3D dc;
> > +     submit_bio_noacct(&ddip->bio);
> > +     return;
> > +free_ddip:
> > +     kfree(ddip);
> > +enomem:
> > +     orig_bio->bi_status =3D BLK_STS_RESOURCE;
> > +     bio_endio(orig_bio);
> >  }
> >
> >  static void quit_max_writeback_rate(struct cache_set *c,
> > @@ -1214,10 +1213,10 @@ void cached_dev_submit_bio(struct bio *bio)
> >
> >       start_time =3D bio_start_io_acct(bio);
> >
> > -     bio_set_dev(bio, dc->bdev);
> >       bio->bi_iter.bi_sector +=3D dc->sb.data_offset;
> >
> >       if (cached_dev_get(dc)) {
> > +             bio_set_dev(bio, dc->bdev);
> >               s =3D search_alloc(bio, d, orig_bdev, start_time);
> >               trace_bcache_request_start(s->d, bio);
> >
> > @@ -1237,9 +1236,10 @@ void cached_dev_submit_bio(struct bio *bio)
> >                       else
> >                               cached_dev_read(dc, s);
> >               }
> > -     } else
> > +     } else {
> >               /* I/O request sent to backing device */
> > -             detached_dev_do_request(d, bio, orig_bdev, start_time);
> > +             detached_dev_do_request(d, bio, start_time);
> > +     }
> >  }
> >
> >  static int cached_dev_ioctl(struct bcache_device *d, blk_mode_t mode,


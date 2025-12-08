Return-Path: <linux-bcache+bounces-1347-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF02CAC9CC
	for <lists+linux-bcache@lfdr.de>; Mon, 08 Dec 2025 10:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B65BE306C2F2
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Dec 2025 09:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFCE931A564;
	Mon,  8 Dec 2025 09:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SL4qP5uC"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB5831985E
	for <linux-bcache@vger.kernel.org>; Mon,  8 Dec 2025 09:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765184601; cv=none; b=XD0IiMfZJzH0RAfF/Afj+QVJYciMUSmyCEFjg6wI2R4MNeOxyYfa7ZGQn7T2jeZgsAL20+CvO2yj5B9bEgmLJlAtYtSPN+1YlI3n7oA+s99eSrEKV6RF7a1OcTM+/dDRxb+jbOeTP3JlqcW6wna66Jr6Sc7OvIDUEPGOnNMbbV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765184601; c=relaxed/simple;
	bh=xmR28IaaF9nKj4dqQJUQXvae3UpVRNnFUf/OMWTEm0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E3iByEQTRjIeG5zbnvjHoYxQ/I8XkUYIXg+1cyFH3TSIVHR4L0z/+TUlTmXJkbXfjN88WQJ3E7XKjV9qAVrHqkP9/z0gmr4VjRQQ8UIluP3ToOtWLJcdacls/53kCrWJI53/pNudv7IIs+nPEMIskXrmAjeE5KV9gM6O8YLuQjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SL4qP5uC; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ed75832448so60328501cf.2
        for <linux-bcache@vger.kernel.org>; Mon, 08 Dec 2025 01:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765184595; x=1765789395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFNPtodxXWt5Thf93tD054e493TCPaIRwICEb5+aRZ4=;
        b=SL4qP5uCCpmULw5Eu9O4BD6HWoTa99JO7h/8si2gsyGa/VIha5u+FePjtE8c8hpkmV
         6V4hls5yJFtsnejuDesheZh10gzcYZWCb5FrJteDzxMR2kcwKMseqKw9zQcTiJ1e4ZZi
         7u+K0UVVYElhiFkAtKnS2t848TYyXKsRJ1Md47nwdnxSSeUbDFapgK8s0POotpVHv9Wc
         eJzXAXNrH5uCxfQ9HqUyAzY/XMXw3TkOZOyHjMbsYUmoLYbIXJMCRmhsBojTFKw0pGvs
         zOOyD9WFW78hhtlelbrxbhaX7r3IW64i6mpPAot5pkJrohEKvvO79ia3ark8XzRj6gVN
         bHLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765184595; x=1765789395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sFNPtodxXWt5Thf93tD054e493TCPaIRwICEb5+aRZ4=;
        b=lWJB3LGddyf7QKSfa143n/Cn95Qa9znTEtKxNJB6wqyYFfrVX3G7HVJPDUCf4Cmgim
         Uxl/9D2Ydgvw2iUPTSkQr9ovhgGkJyzyfkgN6WX7KB9oIa2jBSsFdCTH0yPgJuZnPLhx
         EwlrZ7gHgre/qUTjcUwmDGhzIOp8X8q5BTo8auuLR/kaHck4LVWEyQKXsqjourSWpUSP
         8nnjJifQjNT3OBCqhWbzOeAzkWZL0/5UouGSKp3mco+ujaoSLXg5Uhc6M5bVV/56ml98
         7n/YqjqBSDqnZmrc33CqAqTX/66XsAWajv4qSqtml55qIlcsr+iJ0POB519kUL/W9RTE
         hhZg==
X-Forwarded-Encrypted: i=1; AJvYcCWQSJnXlvyC6nC9mRqUu9y5cqDva0sa2N9KTXxUEgg0Nle2nNdRQt3c4f1DrdJYxapkYkRd1fqzxXD3IrA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP+wGGGJz708/odNr7uWOgr5dKHA8crvqI0FRXmhYAEp7tHNuH
	85QMEjxLa2GKRC/165mUJx5c2MKTgfXNQFAZs/MTlImDhlq5aWVYFNteXHL3YtyuuEnRVlBzv+I
	FlTA9W0ekMmuD5y4Yf+AWhf6yHRA+1u4=
X-Gm-Gg: ASbGncsV92PZGCAwBFndwXKBNJoWFYE5W3MWdpVsPhIuRYjFYdA3ChwtC8al8UKw4p6
	2PgN6OSU/NiiTgHn85TrdRWpDq4pXqwTAgCqWC+z8LWipeIfjZTA5hZK7gFsUlpW8a9Fr2e+SCG
	/4m9wIlwGtgKjv8O07NaxDZaV+gnL5Rfue5mWVIJ4FAzYDRGm/zttzqrAXwQcVsSJiy5my6MNBF
	GxxqdV3Gjr1XDmgeozvUfBvp6LtmsPA/x1pr/vpoSbId7uVWyWNHr3C4fp63mbSPGjcmks=
X-Google-Smtp-Source: AGHT+IGIkzL28sT6p6sHHt80WO2WaduAwsABGOknJWn3+PKdTWs//JTVokCkbxDwbiaJN5b1fBdoaRLK+6PY3xW0EGs=
X-Received: by 2002:ac8:5a4c:0:b0:4ed:af59:9df0 with SMTP id
 d75a77b69052e-4f03fef2e6fmr113096381cf.40.1765184594906; Mon, 08 Dec 2025
 01:03:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251207122126.3518192-1-zhangshida@kylinos.cn>
 <20251207122126.3518192-4-zhangshida@kylinos.cn> <CAHc6FU5urJotiNOJEC4hyJz8HsNechZm9W07e_-DhgkYJmuDmA@mail.gmail.com>
In-Reply-To: <CAHc6FU5urJotiNOJEC4hyJz8HsNechZm9W07e_-DhgkYJmuDmA@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 8 Dec 2025 17:02:38 +0800
X-Gm-Features: AQt7F2qzVM3qX0lIGsVmmMGQ2bZcm4pD2OyMECaPkDdNJjgAQX0YAAlAmy5mJrg
Message-ID: <CANubcdXUvVdMeMK_dJ0eE+A3Un_UzQ6PfjW8m6pGofmFnt+69g@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=88=
7=E6=97=A5=E5=91=A8=E6=97=A5 21:30=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Dec 7, 2025 at 1:22=E2=80=AFPM zhangshida <starzhangzsd@gmail.com=
> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Andreas point out that multiple completions can race setting
> > bi_status.
> >
> > If __bio_chain_endio() is called concurrently from multiple threads
> > accessing the same parent bio, it should use WRITE_ONCE()/READ_ONCE()
> > to access parent->bi_status and avoid data races.
> >
> > On x86 and ARM, these macros compile to the same instruction as a
> > normal write, but they may be required on other architectures to
> > prevent tearing, and to ensure the compiler does not add or remove
> > memory accesses under the assumption that the values are not accessed
> > concurrently.
> >
> > Adopting a cmpxchg approach, as used in other code paths, resolves all
> > these issues, as suggested by Christoph.
> >
> > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index d236ca35271..8b4b6b4e210 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -314,8 +314,9 @@ static struct bio *__bio_chain_endio(struct bio *bi=
o)
> >  {
> >         struct bio *parent =3D bio->bi_private;
> >
> > -       if (bio->bi_status && !parent->bi_status)
> > -               parent->bi_status =3D bio->bi_status;
> > +       if (bio->bi_status)
> > +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> > +
> >         bio_put(bio);
> >         return parent;
> >  }
> > --
> > 2.34.1
> >
>
> I thought you were going to drop this??
>

Okay, I will drop it.

Thanks,
Shida

> Andreas
>


Return-Path: <linux-bcache+bounces-1323-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE10CC9D9C6
	for <lists+linux-bcache@lfdr.de>; Wed, 03 Dec 2025 04:10:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86B103A7A13
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Dec 2025 03:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAFD2417C6;
	Wed,  3 Dec 2025 03:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hqb0JAzv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1BB1F5842
	for <linux-bcache@vger.kernel.org>; Wed,  3 Dec 2025 03:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764731415; cv=none; b=TJ/WYVA2uH0q0V3FDsVw70NgLj0sUoZp9+RtSQQ6UFp/z3zJmE9pBwzXGQRbogBUR1dqK67CyTbvBCLP4eDsBrP9kOmB5K9D/NnsY8Vu/fHsXvbBObG9jvIKO4Y/xr0yrVPjQ20jZ+tyqFJqBDtYWSR4pOaMvvoavcBmawrd6gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764731415; c=relaxed/simple;
	bh=dZN4WVnkipc85rk8nkTuXzZoX9R6uWz0FXNT3hLqQtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+WcxCHVnRueVhzSWYbb036AkfMkqyLOcY5sTq5cl+QhH+dVG9oyK96ndFSNsPp0xs1/7Fo3TQVLw7516ZUwBbtUGsSdOu8g+3BJsdpE95Qz9E7bGpufuPc8aghi5FSERnPQEE6CBQCap3kOSLKcJHzhb3WepkMFhs0wDM7CejA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hqb0JAzv; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4eda057f3c0so46875041cf.2
        for <linux-bcache@vger.kernel.org>; Tue, 02 Dec 2025 19:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764731413; x=1765336213; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Da50DXWuPPV4XcN/IgeMyPMOa+pTGHDkioCpUx5+o3U=;
        b=Hqb0JAzv5Fetm6vvIzH0TVVffeUYQUyX5xcepWaVQB+KA2rG4trC/2lDtbbo1WsUK8
         qnMaX6t4wxS6AyJh0mdZwmeKakyLayvfGbxuqwkI4R9kyrwjjjzaKf6uIo343YcfrFVX
         xw/n0nCs/YxjMZATr33PxdcBRIbj6FjCviKV66z+obESxUZ3YmvJ9uUGNkDS2hfJwc5S
         TDacpLQzPoOUfn3Vya1o1eTwRQn2T1C5RQOnVTSNmrT1EPTONhQzhNwST9EgD1fuczG/
         pssLhfVfJ0fDeMLDpO4tLJE95UwdNPw2RXXwXkreMtvPLv2B1e9R5l0t6REHwj01y1pt
         wazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764731413; x=1765336213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Da50DXWuPPV4XcN/IgeMyPMOa+pTGHDkioCpUx5+o3U=;
        b=Zm+nhvcQlQW0siVFiG2hFItsRyzaESrLt+tXAOVhQMcHhrCeK2LNxOAiXWmsE1mwLx
         7S677V+HKc6q7vMscOp6ympc61Kp/bk4gvv//6jPujJDy0jl4mCpP4ayWdeeJQo0l4Py
         hRypU8Mu9ilN5jxVCC6HBO3F3LxTipb+/RGsHVjZzdmRGgWh8Xz+M+6PdFn/6y3RVECq
         xUHVr/JsbjqZOsGbLG4Xk5hK5yAzLsbs4RALwv/rLI8xV2Z2qgADavaXSHKki0EOwUiJ
         G/VLsj4Ur2xZgnKRin94Rf7gG0DdX1OJp+8qgaccIoM4d15qRY6aNZD0kMB45yuYTU2y
         oxVA==
X-Forwarded-Encrypted: i=1; AJvYcCWQlOZlld+jHbGIvISqC+csvDqOnwAzf5ASeCdeZo+2rv7NMTi07RU5HN541Fv2jYInqpO1eQ/yCABLXN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNX3aBXSjMFWx04EI2u634BP5giVBKaJdYyYMDKtU7JdBe3n6F
	ru+FLW8UmahqxhTSFz07Q0Knm5Lcn58lH/CCXaTusVD/36PsSBKanjbmUSPQFMfJHpEPPgw6AEM
	BfonUr53/aZoj2WftH/8l6ba/WIImGAs=
X-Gm-Gg: ASbGncsQZELZqUtKIz5s1qyVe5ApzTUocHG1AaljcO03KgLXYHNIxN1l2/xOzkyAJG9
	JUuw1qHeNPbziav2wTJpBuhv44RVpizKb4CHq/w/6/rkrFY4XnFbIqUVfSBHE6qlGMjTiGI7+d0
	MJyp2pR1BVlE6sZn2NvmUPGEtqvTDX6SUbl1OUcZI3oJNGLqmbONItG2Tj0AVUvk3YVxUYrdNvW
	pnQuk/raJWCyQW4j9Jl8c7fW0sotyQPMxDvH+t6eASi+Tm4t+T8/pNnlRVOdK4d2LgJ/3sGJ8D3
	fIVTmg==
X-Google-Smtp-Source: AGHT+IFKj9nQ1yW2Qdi7amywixjfuhwbrJxLsfaLBhk60aClgLDyRt7rXIoN0mQ/5gg9IEpDjYYZGqQMKhBVvtX6Jyw=
X-Received: by 2002:a05:622a:15c7:b0:4f0:1543:6762 with SMTP id
 d75a77b69052e-4f0174fe734mr15479451cf.2.1764731412842; Tue, 02 Dec 2025
 19:10:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251201090442.2707362-1-zhangshida@kylinos.cn>
 <20251201090442.2707362-4-zhangshida@kylinos.cn> <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com>
 <aS17LOwklgbzNhJY@infradead.org> <CAHc6FU7k7vH5bJaM6Hk6rej77t4xijBESDeThdDe1yCOqogjtA@mail.gmail.com>
 <20251202054841.GC15524@lst.de> <CAHc6FU6B6ip8e-+VXaAiPN+oqJTW2Tuoh0Vv-E96Baf2SSbt7w@mail.gmail.com>
 <CANubcdWHor3Jx+5yeY84nx0yFe3JosqVG4wGdVkpMfbQLVAWpQ@mail.gmail.com>
In-Reply-To: <CANubcdWHor3Jx+5yeY84nx0yFe3JosqVG4wGdVkpMfbQLVAWpQ@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Wed, 3 Dec 2025 11:09:36 +0800
X-Gm-Features: AWmQ_bn7qJQi1QOaQkYkEYIXtU-m8JUkCUbhC8-ZBvDQ79P6S19scEkkxp42Vgw
Message-ID: <CANubcdWBF5tCfrutAOiUkFaZb=9s4=bMKzi7dSwQxTGbC_3_1Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes.Thumshirn@wdc.com, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Stephen Zhang <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=883=
=E6=97=A5=E5=91=A8=E4=B8=89 09:51=E5=86=99=E9=81=93=EF=BC=9A
>
> Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=
=883=E6=97=A5=E5=91=A8=E4=B8=89 05:15=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Tue, Dec 2, 2025 at 6:48=E2=80=AFAM Christoph Hellwig <hch@lst.de> w=
rote:
> > > On Mon, Dec 01, 2025 at 02:07:07PM +0100, Andreas Gruenbacher wrote:
> > > > On Mon, Dec 1, 2025 at 12:25=E2=80=AFPM Christoph Hellwig <hch@infr=
adead.org> wrote:
> > > > > On Mon, Dec 01, 2025 at 11:22:32AM +0100, Andreas Gruenbacher wro=
te:
> > > > > > > -       if (bio->bi_status && !parent->bi_status)
> > > > > > > -               parent->bi_status =3D bio->bi_status;
> > > > > > > +       if (bio->bi_status)
> > > > > > > +               cmpxchg(&parent->bi_status, 0, bio->bi_status=
);
> > > > > >
> > > > > > Hmm. I don't think cmpxchg() actually is of any value here: for=
 all
> > > > > > the chained bios, bi_status is initialized to 0, and it is only=
 set
> > > > > > again (to a non-0 value) when a failure occurs. When there are
> > > > > > multiple failures, we only need to make sure that one of those
> > > > > > failures is eventually reported, but for that, a simple assignm=
ent is
> > > > > > enough here.
> > > > >
> > > > > A simple assignment doesn't guarantee atomicy.
> > > >
> > > > Well, we've already discussed that bi_status is a single byte and s=
o
> > > > tearing won't be an issue. Otherwise, WRITE_ONCE() would still be
> > > > enough here.
> > >
> > > No.  At least older alpha can tear byte updates as they need a
> > > read-modify-write cycle.
> >
> > I know this used to be a thing in the past, but to see that none of
> > that is relevant anymore today, have a look at where [*] quotes the
> > C11 standard:
> >
> >         memory location
> >                 either an object of scalar type, or a maximal sequence
> >                 of adjacent bit-fields all having nonzero width
> >
> >                 NOTE 1: Two threads of execution can update and access
> >                 separate memory locations without interfering with
> >                 each other.
> >
> >                 NOTE 2: A bit-field and an adjacent non-bit-field membe=
r
> >                 are in separate memory locations. The same applies
> >                 to two bit-fields, if one is declared inside a nested
> >                 structure declaration and the other is not, or if the t=
wo
> >                 are separated by a zero-length bit-field declaration,
> >                 or if they are separated by a non-bit-field member
> >                 declaration. It is not safe to concurrently update two
> >                 bit-fields in the same structure if all members declare=
d
> >                 between them are also bit-fields, no matter what the
> >                 sizes of those intervening bit-fields happen to be.
> >
> > [*] Documentation/memory-barriers.txt
> >
> > > But even on normal x86 the check and the update would be racy.
> >
> > There is no check and update (RMW), though. Quoting what I wrote
> > earlier in this thread:
> >
> > On Mon, Dec 1, 2025 at 11:22=E2=80=AFAM Andreas Gruenbacher <agruenba@r=
edhat.com> wrote:
> > > Hmm. I don't think cmpxchg() actually is of any value here: for all
> > > the chained bios, bi_status is initialized to 0, and it is only set
> > > again (to a non-0 value) when a failure occurs. When there are
> > > multiple failures, we only need to make sure that one of those
> > > failures is eventually reported, but for that, a simple assignment is
> > > enough here. The cmpxchg() won't guarantee that a specific error valu=
e
> > > will survive; it all still depends on the timing. The cmpxchg() only
> > > makes it look like something special is happening here with respect t=
o
> > > ordering.
> >
> > So with or without the cmpxchg(), if there are multiple errors, we
> > won't know which bi_status code will survive, but we do know that we
> > will end up with one of those error codes.
> >
>
> Thank you for sharing your insights=E2=80=94I found the discussion very e=
nlightening.
>
> While I agree with Andreas=E2=80=99s perspective, I also very much apprec=
iate
> the clarity
> and precision offered by the cmpxchg() approach. That=E2=80=99s why when =
Christoph
> suggested it, I was happy to incorporate it into the code.
>
> But a cmpxchg is a little bit redundant here.
> so we will change it to the simple assignment:
>
> -       if (bio->bi_status && !parent->bi_status)
>                  parent->bi_status =3D bio->bi_status;
> +       if (bio->bi_status)
>                  parent->bi_status =3D bio->bi_status;
>
> I will integrate this discussion into the commit message, it is very insi=
ghtful.
>

Hi,

I=E2=80=99ve been reconsidering the two approaches for the upcoming patch r=
evision.
Essentially, we=E2=80=99re comparing two methods:
A:
        if (bio->bi_status)
                   parent->bi_status =3D bio->bi_status;
B:
        if (bio->bi_status)
                cmpxchg(&parent->bi_status, 0, bio->bi_status);

Both appear correct, but B seems a little bit redundant here.
Upon further reflection, I=E2=80=99ve noticed a subtle difference:
A unconditionally writes to parent->bi_status when bio->bi_status is non-ze=
ro,
regardless of the current value of parent->bi_status.
B uses cmpxchg to only update parent->bi_status if it is still zero.

Thus, B could avoid unnecessary writes in cases where parent->bi_status has
already been set to a non-zero value.

Do you think this optimization would be beneficial in practice, or is
the difference
negligible?

Thanks,
Shida

> Thanks,
> Shida
>
> > Andreas
> >


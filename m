Return-Path: <linux-bcache+bounces-1324-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 85126C9DBFD
	for <lists+linux-bcache@lfdr.de>; Wed, 03 Dec 2025 05:34:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 633294E03E6
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Dec 2025 04:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E363621C160;
	Wed,  3 Dec 2025 04:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZpX6ZY62"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD2827732
	for <linux-bcache@vger.kernel.org>; Wed,  3 Dec 2025 04:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764736466; cv=none; b=dZ8pvL2uRyo37m5ku9+vsgJzrug6lUMKy5/3Q/x0taGgx/tfU8vA/+nNP3yT78zl0TLzeBtph41MdOHdJjVpHKqWknqUDzCDaLcg7dGgRoGDXQRVD4s7d2aDejQjlwr6fjdcoBuYACcT6LwFIKPv9dPLPlXqy5Z1B1rTVbkjeSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764736466; c=relaxed/simple;
	bh=J3ud9c+B59CpaGcXxCgeLWI/I7zbSGuZCKk9VSUdFk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Beq241yMwTERjQhH1reyWE4vqYjq1g05umh1SBk1i+yIsIYoOfSevUEgEx5M7y9GI09qXspaPz3XHrRFS07lV+aIX+kTF9X/PqrHQ3f5147+V3DIrESMizSrgC7nEuyrpL7jXzZPDEGXNh8x8rMQ9xKvZXEs6sqEcVjHVM7x9LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZpX6ZY62; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7a9fb70f7a9so544635b3a.1
        for <linux-bcache@vger.kernel.org>; Tue, 02 Dec 2025 20:34:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764736464; x=1765341264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxg6NZLOv9ZCG/sjoM6MZuhlX+NYCjdQCAFs3JbKTvw=;
        b=ZpX6ZY62rTnA4qp7sExNCrOPP425el2xtwYFD2N+o+4KsnD3WRibgAd2f/k5npQnJp
         wmM5g3RE24lcP/Hc1swtsctzcUb/Bas3qxmb6ug033VBVi/JEjAShcP/fyN2GUD5A741
         BqKQ98amNGtHeH/wUL5FWdZLW1GUcYd0a4upNAbnH6B8c8SSLFs66mHXQX/hv95n6ekS
         dT5uc0fGkW/zijOxIf9RXia1Hla6Y1F96WB72CWHLTbce86qTpl1CtZQUws7kZ7xAIQt
         AxucJ32nNSpvSnU5UYEDJMWAKBqXElw++Rez27lQo55WIiSHrT1V7B92d2B/tYNCP7HZ
         dcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764736464; x=1765341264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nxg6NZLOv9ZCG/sjoM6MZuhlX+NYCjdQCAFs3JbKTvw=;
        b=mKSkGbZkj4iyvfipelQQM9egCnxRpyiv1tAEwYsXE8rbqlG7MqqiP/woQRff4rDGJu
         tFYRQ4GZt+10uXXMQeIg+OjhHFnn8EmxkpVcaJED8FbIS8UIy2K6/h51zqdJgeXxv7k9
         +iHteg1ShFW8zKqEzcoVjwN5TooEkxTjqKrc5uakFCdSpvh+9hk+dklxhnj0O7qZ4sRo
         LBucz8JDjnCR9M/lqhpfzr+dalRAs1MeT27xzAEDOBYg4mkSX0GFvhwBTsGWl3RkPpCV
         hLCPutwOfAFS1hU13azBEHvqmqSgzYnCJTUbd4d6LfHXr3k89uUC7rTRUSLHsHfgFVKa
         Uzyw==
X-Forwarded-Encrypted: i=1; AJvYcCUbR3I75QFQMpGtQY++Ex8fVk5W2b8wREqAm5AIn9k0utOpJFXehlOUF/562J+VybHSu+Lnmv/m9vLkXN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWQXQWtESzNa0rZX1r7NE6/hVKo8AQLiCjfI5sCHjS2hj9mZNi
	3Yx3fthNAkugVwkwQzoDKdJpSFByl0f/I9/NQBnWFZpY6mj+hLcghvIjaBoUMeOtr2F4FMtaeFI
	s0zUeF16pXX9ty3zwGHgtb2qgoiWUaxec3mA7PQqLrQ==
X-Gm-Gg: ASbGncuBAH8Q0p10lsjPn6JSXzKCo5b4/FR5g0uttKc3S8OhPhbStNZYHgkl+t3BHy0
	efmIEIb2BTxb382dxZMX0T5b1Ax4e8F8s0IE7mWEhpUdUjAxBlBd9sL08shIY7Bas9LbbYmOxTg
	O6NZPHHN6hVBiLzAYysvgn1A6/24koaukh46TktMxc5MqBjWfwIG6NHnBxEGBBsSdU4pN4aE9/S
	9AZk04lgYeBmECnig1R2/mJq8JAoe6H8W5uOu2rD4ioUDxh75VLL0tQ7461mYJG6MwV00Gk
X-Google-Smtp-Source: AGHT+IECnDzApJ5NyNLW8rGHiHxtldS0FYY+rhs6YCEvY55DQGZQH4fAIX45fRAqvDe7ic9LbXXirxdXMRcmPw0X94E=
X-Received: by 2002:a05:7022:f902:10b0:119:e56a:4ffb with SMTP id
 a92af1059eb24-11df2491f44mr64587c88.0.1764736464174; Tue, 02 Dec 2025
 20:34:24 -0800 (PST)
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
 <CANubcdWHor3Jx+5yeY84nx0yFe3JosqVG4wGdVkpMfbQLVAWpQ@mail.gmail.com> <CANubcdWBF5tCfrutAOiUkFaZb=9s4=bMKzi7dSwQxTGbC_3_1Q@mail.gmail.com>
In-Reply-To: <CANubcdWBF5tCfrutAOiUkFaZb=9s4=bMKzi7dSwQxTGbC_3_1Q@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 2 Dec 2025 20:34:11 -0800
X-Gm-Features: AWmQ_bm3LS7Up9zs78OFsHjIPFx_Ldz_doIQ0KD7HcFfO0Yxjj_mgU4AGtQS6xg
Message-ID: <CADUfDZoWjSHRVFnxh=QK7HkQSB5zBZvePjkV-+2Esrf8jtnekg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@lst.de>, Johannes.Thumshirn@wdc.com, 
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 7:10=E2=80=AFPM Stephen Zhang <starzhangzsd@gmail.co=
m> wrote:
>
> Stephen Zhang <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=883=
=E6=97=A5=E5=91=A8=E4=B8=89 09:51=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=
=9C=883=E6=97=A5=E5=91=A8=E4=B8=89 05:15=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Tue, Dec 2, 2025 at 6:48=E2=80=AFAM Christoph Hellwig <hch@lst.de>=
 wrote:
> > > > On Mon, Dec 01, 2025 at 02:07:07PM +0100, Andreas Gruenbacher wrote=
:
> > > > > On Mon, Dec 1, 2025 at 12:25=E2=80=AFPM Christoph Hellwig <hch@in=
fradead.org> wrote:
> > > > > > On Mon, Dec 01, 2025 at 11:22:32AM +0100, Andreas Gruenbacher w=
rote:
> > > > > > > > -       if (bio->bi_status && !parent->bi_status)
> > > > > > > > -               parent->bi_status =3D bio->bi_status;
> > > > > > > > +       if (bio->bi_status)
> > > > > > > > +               cmpxchg(&parent->bi_status, 0, bio->bi_stat=
us);
> > > > > > >
> > > > > > > Hmm. I don't think cmpxchg() actually is of any value here: f=
or all
> > > > > > > the chained bios, bi_status is initialized to 0, and it is on=
ly set
> > > > > > > again (to a non-0 value) when a failure occurs. When there ar=
e
> > > > > > > multiple failures, we only need to make sure that one of thos=
e
> > > > > > > failures is eventually reported, but for that, a simple assig=
nment is
> > > > > > > enough here.
> > > > > >
> > > > > > A simple assignment doesn't guarantee atomicy.
> > > > >
> > > > > Well, we've already discussed that bi_status is a single byte and=
 so
> > > > > tearing won't be an issue. Otherwise, WRITE_ONCE() would still be
> > > > > enough here.
> > > >
> > > > No.  At least older alpha can tear byte updates as they need a
> > > > read-modify-write cycle.
> > >
> > > I know this used to be a thing in the past, but to see that none of
> > > that is relevant anymore today, have a look at where [*] quotes the
> > > C11 standard:
> > >
> > >         memory location
> > >                 either an object of scalar type, or a maximal sequenc=
e
> > >                 of adjacent bit-fields all having nonzero width
> > >
> > >                 NOTE 1: Two threads of execution can update and acces=
s
> > >                 separate memory locations without interfering with
> > >                 each other.
> > >
> > >                 NOTE 2: A bit-field and an adjacent non-bit-field mem=
ber
> > >                 are in separate memory locations. The same applies
> > >                 to two bit-fields, if one is declared inside a nested
> > >                 structure declaration and the other is not, or if the=
 two
> > >                 are separated by a zero-length bit-field declaration,
> > >                 or if they are separated by a non-bit-field member
> > >                 declaration. It is not safe to concurrently update tw=
o
> > >                 bit-fields in the same structure if all members decla=
red
> > >                 between them are also bit-fields, no matter what the
> > >                 sizes of those intervening bit-fields happen to be.
> > >
> > > [*] Documentation/memory-barriers.txt
> > >
> > > > But even on normal x86 the check and the update would be racy.
> > >
> > > There is no check and update (RMW), though. Quoting what I wrote
> > > earlier in this thread:
> > >
> > > On Mon, Dec 1, 2025 at 11:22=E2=80=AFAM Andreas Gruenbacher <agruenba=
@redhat.com> wrote:
> > > > Hmm. I don't think cmpxchg() actually is of any value here: for all
> > > > the chained bios, bi_status is initialized to 0, and it is only set
> > > > again (to a non-0 value) when a failure occurs. When there are
> > > > multiple failures, we only need to make sure that one of those
> > > > failures is eventually reported, but for that, a simple assignment =
is
> > > > enough here. The cmpxchg() won't guarantee that a specific error va=
lue
> > > > will survive; it all still depends on the timing. The cmpxchg() onl=
y
> > > > makes it look like something special is happening here with respect=
 to
> > > > ordering.
> > >
> > > So with or without the cmpxchg(), if there are multiple errors, we
> > > won't know which bi_status code will survive, but we do know that we
> > > will end up with one of those error codes.
> > >
> >
> > Thank you for sharing your insights=E2=80=94I found the discussion very=
 enlightening.
> >
> > While I agree with Andreas=E2=80=99s perspective, I also very much appr=
eciate
> > the clarity
> > and precision offered by the cmpxchg() approach. That=E2=80=99s why whe=
n Christoph
> > suggested it, I was happy to incorporate it into the code.
> >
> > But a cmpxchg is a little bit redundant here.
> > so we will change it to the simple assignment:
> >
> > -       if (bio->bi_status && !parent->bi_status)
> >                  parent->bi_status =3D bio->bi_status;
> > +       if (bio->bi_status)
> >                  parent->bi_status =3D bio->bi_status;
> >
> > I will integrate this discussion into the commit message, it is very in=
sightful.
> >
>
> Hi,
>
> I=E2=80=99ve been reconsidering the two approaches for the upcoming patch=
 revision.
> Essentially, we=E2=80=99re comparing two methods:
> A:
>         if (bio->bi_status)
>                    parent->bi_status =3D bio->bi_status;
> B:
>         if (bio->bi_status)
>                 cmpxchg(&parent->bi_status, 0, bio->bi_status);
>
> Both appear correct, but B seems a little bit redundant here.
> Upon further reflection, I=E2=80=99ve noticed a subtle difference:
> A unconditionally writes to parent->bi_status when bio->bi_status is non-=
zero,
> regardless of the current value of parent->bi_status.
> B uses cmpxchg to only update parent->bi_status if it is still zero.
>
> Thus, B could avoid unnecessary writes in cases where parent->bi_status h=
as
> already been set to a non-zero value.
>
> Do you think this optimization would be beneficial in practice, or is
> the difference
> negligible?

cmpxchg() is much more expensive than a plain write, as it compiles
into an atomic instruction (or load-linked/store-conditional pair on
architectures that don't provide such an instruction). This requires
the processor to take exclusive access of the cache line for the
duration of the operation (or check whether the cache line has been
invalidated during the operation). On x86, cmpxchg() marks the cache
line as modified regardless of whether the compare succeeds and the
value is updated. So it doesn't actually avoid the cost of a write.
However, the original code's check of parent->bi_status before writing
to it *does* avoid the write if parent->bi_status is already nonzero.
So the optimization you're looking for is already implemented :)
If __bio_chain_endio() can be called concurrently from multiple
threads accessing the same parent bio, it should be using WRITE_ONCE()
(and READ_ONCE(), if applicable) to access parent->bi_status to avoid
the data race. On x86 and ARM these macros produce the same
instruction as a normal write, but they may be required on other
architectures to avoid tearing, as well as to prevent the compiler
from adding or removing memory accesses based on the assumption that
the values aren't being accessed concurrently by other threads.

Best,
Caleb


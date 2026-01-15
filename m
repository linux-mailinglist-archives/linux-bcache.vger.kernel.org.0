Return-Path: <linux-bcache+bounces-1374-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA90D23654
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 10:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 205EA302D2FA
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 09:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C415432D0FE;
	Thu, 15 Jan 2026 09:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A/YI+dQ6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EED3054D0
	for <linux-bcache@vger.kernel.org>; Thu, 15 Jan 2026 09:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768468697; cv=none; b=I72JMKuuwhi4gyfWnV8XVLRUSPKGlt1Y1AOXzSfSynzEW+F+yzA7vhoR386z7fgQEs0+Hx0ZrWHBXX0IfHybz5sOchJdft8IboOHeGfIg/HueToyhb6pL1MyyzUalQVvm9U5DpAJinC8FIG7EzDLKAgC8dc+UqNVa/g+JmQ/oxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768468697; c=relaxed/simple;
	bh=WjYsIBQxEkneazbWWMrLx2D5qlNcxIgBmq4U3HBdY7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZRmvzNF2LtjiEEQURs1Pnr8Esc2CmARz5tTX/sZeMfZVc6TjFAs98NSrFX4DU/BHvC0kUobd6HSv6LsgGTeJxBaiB61AzavP473ZkajxrLuy2NsD3gnYF+6cj3UesGl3FjYYOR8x0unzykth2K3SGAg1xuSqjl/Gl5nhnfYcwsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A/YI+dQ6; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5018ec2ae21so6909971cf.0
        for <linux-bcache@vger.kernel.org>; Thu, 15 Jan 2026 01:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768468695; x=1769073495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cPLSNjN+R17/wAXwPXcJYRqBCPtytyhtK+b5wvZe+3g=;
        b=A/YI+dQ6GwDWmypvm45WKmIHoz9nyvjSD6o8QDkdr+P+5wcVtQz07N//g2Pzsfbv4l
         rWbbZnz3EksQa4wK5n6BmZOS/d1nrZclWhJHwE/m0oV44wBorxACwvbo4wzXbpzvceIK
         1o9EjRtJ1hkPc0T+fg6/5+q6qfD9l8peYrMixS4pUW4RG4kOoCoHgJ1ZB2c0QOVdwkkE
         2KxmLarBfhX+9XTFw+jQl1QeE98Rbj3BD46eGj8h+Icr960dqe4bVya3vLBef5RLIRAf
         WmLJiUm9PXQFYGv1YHDJ06J7/U5XRj+id+D3+xjXlE9OmgizImFOI7KnOIU+ns0lNgGY
         GBLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768468695; x=1769073495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cPLSNjN+R17/wAXwPXcJYRqBCPtytyhtK+b5wvZe+3g=;
        b=xOTkMo/B7r9QldoZnpbhziTPKOzyjDZy4Fm9Jsx1vlAhK9CWiwgxsnVCg2lAaVBZnH
         EHxa8DG+RDdEN5wAP3FL1qw/uHtDBZZ6bG20EAa/I7HeOai9W/NySwjwUdCS/sLF9Qax
         JvmJbdqLonkSV2fDsTaBv8quR4JlEUbGBTgbZgJxDX+XnmmbkNuyaEZHuPCdqsCQRxLS
         FlV5F7H2y4GJLdT2FuYioqXuqQSZRP0rM2nzDb9xk2pGybmsCKwB6uHLox7O3cA1/2kU
         UBDTVc7EcmNz6EmGkBB0fF1cLUV+GM6n6IMSyZ0xYzkrKvUKHKd4OcF2ourPQUzj+tMC
         C1mg==
X-Forwarded-Encrypted: i=1; AJvYcCV+u9gEnA3VwM5tF/i6y60trFk+OjWs/l0NLT3R5DAHf3yB5BVvQRI5TZj1HDAvYa4uEK0WqpssM3vOIhA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAw2JgDH1N5fhIlr//beMHZNNshJeRJOvzSOHQ6qZoefwdZvYk
	lXCXAqRXKIC29MxOXLgy6wYR4J2YmpGpvCpmHI7CtQvVCcV8/eyszghhQQsN9V8EJDYaeVan+BD
	sONRW3zCI4gYMjeTln7HcgBDBT7pyUhs=
X-Gm-Gg: AY/fxX5vVogb14/LS2gfE1xl6fFbpX0D2XcPwnvjuv5MiSkpiRumPDhTtHPPRLnfJiF
	HetyWuJaQvTEeF4uZqFXilD+eBSeGIfQuKJ6FSDzYgtGWjesJ5DntKyhRYSTe3sTRoUBxDgVxp9
	v2j4aEt9h5HBw0275xut6CRlQgEjOxNXon7ItzF58tqOoLl1k/Kkdw2jbvAYIFqgO0cb4oCoLJ0
	8un1K20dNU4JC190Uqe9HI9LDh6lWKWmvXKvKu85PD0qQN46JewLLR7gBOPVPgqywFx+Xo=
X-Received: by 2002:a05:622a:4d44:b0:4f1:b9e1:f08f with SMTP id
 d75a77b69052e-501481e4c3fmr76406101cf.5.1768468695326; Thu, 15 Jan 2026
 01:18:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com> <aWiqMzQ9PIWFfyfP@moria.home.lan>
In-Reply-To: <aWiqMzQ9PIWFfyfP@moria.home.lan>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 15 Jan 2026 17:17:39 +0800
X-Gm-Features: AZwV_QgcjYZpFp4H9PsSOSayKOHOc8L-vbN36WnVzZ7cdDVoL1CHW4DVALgj_Ns
Message-ID: <CANubcdXk5BHTJL+5J8n80r6O7pyhF0qOhEXBgvYo_UY_iUQYgg@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix double bio_endio completion in detached_dev_end_io
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@fnnas.com, axboe@kernel.dk, sashal@kernel.org, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Kent Overstreet <kent.overstreet@linux.dev> =E4=BA=8E2026=E5=B9=B41=E6=9C=
=8815=E6=97=A5=E5=91=A8=E5=9B=9B 16:59=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Jan 15, 2026 at 04:06:53PM +0800, Stephen Zhang wrote:
> > zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=8815=
=E6=97=A5=E5=91=A8=E5=9B=9B 15:48=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > From: Shida Zhang <zhangshida@kylinos.cn>
> > >
> > > Commit 53280e398471 ("bcache: fix improper use of bi_end_io") attempt=
ed
> > > to fix up bio completions by replacing manual bi_end_io calls with
> > > bio_endio(). However, it introduced a double-completion bug in the
> > > detached_dev path.
> > >
> > > In a normal completion path, the call stack is:
> > >    blk_update_request
> > >      bio_endio(bio)
> > >        bio->bi_end_io(bio) -> detached_dev_end_io
> > >          bio_endio(bio)    <- BUG: second call
> > >
> > > To fix this, detached_dev_end_io() must manually call the next comple=
tion
> > > handler in the chain.
> > >
> > > However, in detached_dev_do_request(), if a discard is unsupported, t=
he
> > > bio is rejected before being submitted to the lower level. In this ca=
se,
> > > we can use the standard bio_endio().
> > >
> > >    detached_dev_do_request
> > >      bio_endio(bio)        <- Correct: starts completion for
> > >                                 unsubmitted bio
> > >
> > > Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> > > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > > ---
> > >  drivers/md/bcache/request.c | 11 +++++++++--
> > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.=
c
> > > index 82fdea7dea7..ec712b5879f 100644
> > > --- a/drivers/md/bcache/request.c
> > > +++ b/drivers/md/bcache/request.c
> > > @@ -1104,7 +1104,14 @@ static void detached_dev_end_io(struct bio *bi=
o)
> > >         }
> > >
> > >         kfree(ddip);
> > > -       bio_endio(bio);
> > > +       /*
> > > +        * This is an exception where bio_endio() cannot be used.
> > > +        * We are already called from within a bio_endio() stack;
> > > +        * calling it again here would result in a double-completion
> > > +        * (decrementing bi_remaining twice). We must call the
> > > +        * original completion routine directly.
> > > +        */
> > > +       bio->bi_end_io(bio);
> > >  }
> > >
> > >  static void detached_dev_do_request(struct bcache_device *d, struct =
bio *bio,
> > > @@ -1136,7 +1143,7 @@ static void detached_dev_do_request(struct bcac=
he_device *d, struct bio *bio,
> > >
> > >         if ((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
> > >             !bdev_max_discard_sectors(dc->bdev))
> > > -               detached_dev_end_io(bio);
> > > +               bio_endio(bio);
> > >         else
> > >                 submit_bio_noacct(bio);
> > >  }
> > > --
> > > 2.34.1
> > >
> >
> > Hi,
> >
> > My apologies for the late reply due to a delay in checking my working i=
nbox.
> > I see the issue mentioned in:
> > https://lore.kernel.org/all/aWU2mO5v6RezmIpZ@moria.home.lan/
> > this was indeed an oversight on my part.
> >
> > To resolve this quickly, I've prepared a direct fix for the
> > double-completion bug.
> > I hope this is better than a full revert.
>
> In general, it's just safer, simpler and saner to revert, reverting a
> patch is not something to be avoided. If there's _any_ new trickyness
> required in the fix, it's better to just revert than rush things.
>
> I revert or kick patches out - including my own - all the time.
>
> That said, this patch is good, you've got a comment explaining what's
> going on. Christoph's version of just always cloning the bio is
> definitely cleaner, but that's a bigger change,

Thank you for the feedback.

I sincerely hope that Christoph's version can resolve this issue properly, =
and
that it helps remedy the regression I introduced. I appreciate everyone's
patience and the efforts to address this.

Let me know if there's anything further needed from my side.

Best regards,
Shida


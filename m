Return-Path: <linux-bcache+bounces-1326-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 98580CA216C
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 02:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8C2B9300FA1B
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 01:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37E1E1D63D1;
	Thu,  4 Dec 2025 01:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jg10WYTv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1682866
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 01:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764811118; cv=none; b=jMzbKWbFv2fThtbvGG2P3HOrEpB+Xt7RGtyqdo28MUk4nKv+nyEEg7W2WDQ0dTYr4i3W4SVyt4AmmdEuIUBoXPL45PbkgozhlkH02y7wFdhNOd5FtBbfnyWO61VK/rMG/tbaFrJb94MX8FfZqT0k8mhiNf0A+sWH5ghczLW+uB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764811118; c=relaxed/simple;
	bh=wC9lqEIoN8sq5g8JhY/4krcB2BXJ+ZczTeStEg6GGck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G0N5iqZANmtB/+K5Tf8po1F6y8a6tJsGnY5EHFtfNJHq7GPQG9ZcraC3EgHBlUKmugmv6Knrj/RsKeMcB/2QdTwBBwqVgPZ5+bJYIE51Upe28YPsCgkhw7q6qHAa1eg4gHAYC6R/wi9O46IkEefawMeGb7DAO+cP3zQTPHi5LMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jg10WYTv; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ee04609ffaso1736621cf.3
        for <linux-bcache@vger.kernel.org>; Wed, 03 Dec 2025 17:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764811115; x=1765415915; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=laiLiH0/HusFXriU7bmpWTj4dFA6FGxaKSRdrze3lyk=;
        b=jg10WYTv/Gxt0kev0zd5DS0NUc1IGgJUBqIMeveG88ohVK8YRsB7cwi3Ip623lNGP/
         Y5b+d/ve92R9ABd5u0WHl6VCMHsUMYft2twvvH0JIoHXS5DOFsJ23SEEMsG6QTVpQq4R
         rH3cZkX7eVvmXkn/RxqWSOs/9x1g0gFYDx7YqtgVAroEhWZ0lJPP1cHP+YhMOBQSSKV0
         xwLN0+z9NtfR3qB44+LU9dbShdAM9KEygAbRxiCpLeX7Dth/dg9urZ3ZI5VcESsRvPf8
         tJss4UKUGJvjFzQc2EwcWITabdxcaZOkVL9hGuZFXQ14x1sQ5D3+AFgpGQQqY72HgYYO
         Gfcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764811115; x=1765415915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=laiLiH0/HusFXriU7bmpWTj4dFA6FGxaKSRdrze3lyk=;
        b=bR1b0NC0CFbJnIfxAAqR03/OU0UuDju2txMbI+N51w34w2Le1muvDidLor/pUAee6B
         5Zpi/PgYhX3DcLy1f21AQSfbPjZ7Yeu9NNV+ICSsiL29Y60IDZUsorWgHd44UIAvMkv0
         EGUqn0d9DX+Mq8DX1xpqXJhjz4f+Ebdaw7C7zRxjU3YSa/+WVNx+z1S0bXCaadViT3Xo
         y9bpOajbO0VQZecpHtcIVEyK2naE2ZxvI2+vnqKJQefEGglXOC+yroQQh/LeLGXzWnL+
         VRoO8XCh3rv4uJrBBdJHjfeB51yi2lJ3RXzm+moZQpfstJM/qsABwxFkmKFChz+yAuqO
         lCzA==
X-Forwarded-Encrypted: i=1; AJvYcCU7UgZrWhKFnK87Lo4nD33wYZDixkA234mw0RcNsjfjUWw3sC7AlsKgP6WCN9OnsUHmMhJDkxvTuemRkrs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTAPzGtW3iQeaEPQKyiqSu3AMg6JeEzAyZigXzZ1tuq2UYC6Y6
	O8yJOVOtsP5YaDVdGl2tjisdL77oZKoL4ZSakv2OquReXXxUoyAGDmLi46rLlWq/i+FabLWi5oj
	GonEaYsfI1e+U43k1FNAUyMmrhqzz2vY=
X-Gm-Gg: ASbGnctCY7NO7gj/BglHjDSAuvVsVc4SJAUEYkxLvI5gwYOEBmnibPpTT54yVUqxQOc
	6eKV57TrVDX8i5zunN2aFSGRgz1/Q7QZYKfNYAR7JA550o/GV1vztY3TCSKPOK1KXRRGHeI24Mf
	wI4LcZx+LDrfETapTsD3lw2kAudQuEx/7A29GfT5sdO/LawfLKiFTpainmOtsLo5BFidaeNvhJM
	MBcAKlHMDRejzW6QrgkF9EoE+rC/pOdBM5UXCimmvF3NBG0Yjtf5XYNCtnPpcILZpSXlpBUooeK
	zlT7sg==
X-Google-Smtp-Source: AGHT+IE21KasvmyCNqhdEgk2h7QhOUH0VPEKE5ffxcK3aRkFD34vSJuFO2kCq2OVEl95+NlsaexaOS6OAQX65H8UXlY=
X-Received: by 2002:ac8:5a46:0:b0:4ed:a9c0:1e30 with SMTP id
 d75a77b69052e-4f023a12961mr18362611cf.25.1764811115311; Wed, 03 Dec 2025
 17:18:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251201090442.2707362-1-zhangshida@kylinos.cn>
 <20251201090442.2707362-3-zhangshida@kylinos.cn> <CAHc6FU53qroW6nj_ToKrSJoMZG4xrucq=jMJhc2qMr22UAWMCw@mail.gmail.com>
In-Reply-To: <CAHc6FU53qroW6nj_ToKrSJoMZG4xrucq=jMJhc2qMr22UAWMCw@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 4 Dec 2025 09:17:58 +0800
X-Gm-Features: AWmQ_bniayhQIzEfyEULK5EZFSw6I1TPfQlUIuPrClXqSdR1WYg5VtjGIi4Mihg
Message-ID: <CANubcdVXUS_i79=1Zx5R7cGC7JwHrUXRCZoQ0kes7gdZUTW0Dg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] block: prohibit calls to bio_chain_endio
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=88=
1=E6=97=A5=E5=91=A8=E4=B8=80 17:34=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Dec 1, 2025 at 10:05=E2=80=AFAM zhangshida <starzhangzsd@gmail.co=
m> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Now that all potential callers of bio_chain_endio have been
> > eliminated, completely prohibit any future calls to this function.
> >
> > Suggested-by: Ming Lei <ming.lei@redhat.com>
> > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index b3a79285c27..1b5e4577f4c 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -320,9 +320,13 @@ static struct bio *__bio_chain_endio(struct bio *b=
io)
> >         return parent;
> >  }
> >
> > +/**
> > + * This function should only be used as a flag and must never be calle=
d.
> > + * If execution reaches here, it indicates a serious programming error=
.
> > + */
> >  static void bio_chain_endio(struct bio *bio)
> >  {
> > -       bio_endio(__bio_chain_endio(bio));
> > +       BUG_ON(1);
>
> Just 'BUG()'.
>

Yeah, that=E2=80=99s much clearer now. I'll resend the updated version.

Thanks,
Shida

> >  }
> >
> >  /**
>
> > --
> > 2.34.1
> >
>
> Andreas
>


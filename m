Return-Path: <linux-bcache+bounces-1285-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 13246C9365A
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 02:48:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 273544E288A
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 01:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8011DDC3F;
	Sat, 29 Nov 2025 01:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MkFe5ENj"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391061E4BE
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764380889; cv=none; b=ppmsow+k/jRNfmi6+xcOXovrD+RL2r+OZb/xTvhDL4S0fFzzRh1G5VnscLRfSNmKX7/oDz3zR/sOIrB7U5zUKHdyEJevHMA+6X2cP8EcxA9O4GBR36BhTiwJAWmJsRvaHU36+vRMv5pZi+wG9eOpv7SAeo8Ge4mdtHUddHp0Xfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764380889; c=relaxed/simple;
	bh=FQHmHJ0lPvX1FL9p7r+Yxofhpz0r6kDOY6kzIzT8s1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kOsWHF/ha9+Ndxog8Cn9t3N0JtZXgq3GZUAdgz3phShAiVZSQMAV/sGzB/zNVUbUt7XT7MXS6P9Yxmxgwar/UbSD2wrtrZ/5Fa5lKZgqADAmHGeK5ZIfDbAxN/knqWxE1zWDUJrCbfX6AubM5uM2vwgHzvtRdLyL63+ocnOep7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MkFe5ENj; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8a3eac7ca30so143495385a.2
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 17:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764380886; x=1764985686; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTMvUg1UMZTZ4C3O9OiBQ8cOr6Brx+qDSX2glns7W/k=;
        b=MkFe5ENjB2rgxutDtmOfY8KxlzF0R+Fq+dpyC1NSpTc/iHS4Mzld+qiDgRVC3ZPFmg
         9dUpnH0iZixTu4C4/XYIrPwO1dkl+LPp3RAcAN+x0yoJB1qjJoQ1CXvUue4ubK7x/3Xv
         NhRNfRhVBJ/g3QeR3vOp+BB6XMlA6UHGwimp5QY8BBcv7jdhxkMXyJxXXSfyMzJrXh6T
         03wYTpnWaHHdSteQslzP/082RtSFqrBt2NIL6VpAdstezX9l+nZZE9jBHn0GABd+Z8kK
         WXQn+lsIcH0aQMo755k5cgqP8uaRLtk+BiVjtRzfBWPaaDIqcoCDBy0tu3xfbFSDu9J3
         uehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764380886; x=1764985686;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gTMvUg1UMZTZ4C3O9OiBQ8cOr6Brx+qDSX2glns7W/k=;
        b=UDFZkNotjfJpSHIXtSDv5ZlNV2KNBRgIeDNJfJpF4zhC52MvXAb5JnmLyVZBiHZDg0
         AXEjqvLKEVzCZrBrhrv72KIUZT3hDRM0GNiwYeLvJMaLBGPLSfMeURTRabCu67EIN181
         4yu0Lc/CBO8O4JyOhgwKavd/Lw7FMU+vaFFg2Sx/BfOueHq5u3CKj2s5QeLO2vymI0Wo
         uhEgWuR099aOtYVklPjmwuNEJqDzncMQUmRXGjfZ2lTbYzQjn470OmUuwkqMpeftA5of
         n25rIugEl2r3jIkp0LtDpfTSGMVvacn2nuQi3c5HVqEMS/p5PDOR9APZdZlvpyL6T01v
         1bUw==
X-Forwarded-Encrypted: i=1; AJvYcCX2+WW9LdXTOkQLbdRDq2uEil/Npf4c2+QtHxae9dC7hycAQexGsqvd1x9yyvO9ZMbo7EhDBWZkp69MjkM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnhUHK5fS0dnbyPu0MlobJ0U1d6pT30041OnQyMf4CMh2lI7Ob
	a3CcL7lH4T6VrkdrjK+bsQly1JWo4dQtLE2dQSjwm14BSUymMzfwMeIXty+fgjhWS6XZ4i1izIR
	JjbxCYC2OZtQI3a7eEPs3//PgzI6MDEg=
X-Gm-Gg: ASbGnctp6b4f3M/tIANoI38+qPdgHJNW22pjLd4KXQqH6YQQ0O3FSDRlx4UQASmH1s+
	xgPl6Z9PVh4ujhef3Jw4dPOaYHZWQZOwgxt0upaofhTALCwqhSZbhAN0brJVXR+OWXZ8ohjyeGW
	R/qe/juc9wALtS/hfA62/jmGQFm1ObwzKZ+biaaqrHGUcCc5uK8anU1CfUk2pQ0mWR+d1j7+vAC
	yr/ZbrQBgAwLtlek4IgEAhyts9sRgxMxPwlEhnM5gKm9J51ahvg20k68AkcZjA690XGLcHIqOIz
	X1nZ
X-Google-Smtp-Source: AGHT+IF8UylZfxilGeMhsr8XVt5PLAPqSaRXTvsYHaw6wpySxcukJ+AHM3ybyVlNv3V0Obv4Zo5rqIkfGVVhf2kHlvM=
X-Received: by 2002:a05:622a:1489:b0:4ed:afd0:c5ea with SMTP id
 d75a77b69052e-4efbd8f5186mr241469781cf.31.1764380886123; Fri, 28 Nov 2025
 17:48:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-3-zhangshida@kylinos.cn> <CADUfDZqBYdygou9BSgpC+Mg+6+vaE2q-K=i1WJB1+KAeBkS1dg@mail.gmail.com>
In-Reply-To: <CADUfDZqBYdygou9BSgpC+Mg+6+vaE2q-K=i1WJB1+KAeBkS1dg@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 09:47:30 +0800
X-Gm-Features: AWmQ_bnN3cSo6zqXXCSLK6iMVHLbQkMYnCeHd1k_eisM5wRG4bYg-EFq2EOhH5Y
Message-ID: <CANubcdUmUJKeabgagPTWhBd42vzOqx9oxG23FefFJVCcVa_t5A@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Andreas Gruenbacher <agruenba@redhat.com>, Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Caleb Sander Mateos <csander@purestorage.com> =E4=BA=8E2025=E5=B9=B411=E6=
=9C=8829=E6=97=A5=E5=91=A8=E5=85=AD 03:44=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 28, 2025 at 12:34=E2=80=AFAM zhangshida <starzhangzsd@gmail.c=
om> wrote:
> >
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Andreas point out that multiple completions can race setting
> > bi_status.
> >
> > The check (parent->bi_status) and the subsequent write are not an
> > atomic operation. The value of parent->bi_status could have changed
> > between the time you read it for the if check and the time you write
> > to it. So we use cmpxchg to fix the race, as suggested by Christoph.
> >
> > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index 55c2c1a0020..aa43435c15f 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
> >  static struct bio *__bio_chain_endio(struct bio *bio)
> >  {
> >         struct bio *parent =3D bio->bi_private;
> > +       blk_status_t *status =3D &parent->bi_status;
>
> nit: this variable seems unnecessary, just use &parent->bi_status
> directly in the one place it's needed?
>

Thanks, Caleb and Andreas. I will integrate your suggestions to:

      if (!bio->bi_status)
               cmpxchg(&parent->bi_status, 0, bio->bi_status);

Thanks,
Shida

> Best,
> Caleb
>
> > +       blk_status_t new_status =3D bio->bi_status;
> > +
> > +       if (new_status !=3D BLK_STS_OK)
> > +               cmpxchg(status, BLK_STS_OK, new_status);
> >
> > -       if (bio->bi_status && !parent->bi_status)
> > -               parent->bi_status =3D bio->bi_status;
> >         bio_put(bio);
> >         return parent;
> >  }
> > --
> > 2.34.1
> >
> >


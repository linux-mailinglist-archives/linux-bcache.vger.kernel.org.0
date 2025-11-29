Return-Path: <linux-bcache+bounces-1286-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AD06C9366C
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 02:51:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 936AA4E23A7
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 01:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF4C1DE8AD;
	Sat, 29 Nov 2025 01:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJaomsKU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7753515A85A
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764381050; cv=none; b=YS1tEkl7nS5NM5XA5EGsq7Z6LygTgkpTxMLmLu5KTA3oJ2W+Luj1z9OjQQKVyk2Vz1b8Rk0N2LEKsH5MG7BDKtZJ9PIc3b4Ymn67lF+PXPLVJkvkG0qRwQqnYn6Pjc3N6jv0fRQ5WLrlQCiS37BNCMQ53MxdREUc2veam3F9sG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764381050; c=relaxed/simple;
	bh=NaSVgYTQZj//T0kXBeK5L/YqRjV2JfM4MD+L1BQ61uA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YCRgZ2xJGIbbJrXucF6cOWQKZ//kAkKB0b7TdRDDhWOcYI8dwhHiPu+O23LD4/b7jFPVJx84wF4seefeL8UBhomV9VbObmepxEkAqt6GHOHFYdxsgRz2BBdBZ0108Fvo2GY8EOyI2G4TZwAczVfwnnYI4KkBX7EtoRzW9IcUzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJaomsKU; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee1939e70bso22335871cf.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 17:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764381046; x=1764985846; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xXq5BoozcLEtMZPipx/4wTBGFkZq8n4VHxCYYlUf+vY=;
        b=RJaomsKU0RFImSp0lKj+tCXDBYiRDR6Ym99JMqbxsanbLdacTBoZI8afLEDT2XVHyL
         jf3qT2d6hBUsHJ5gr1BWXz72DX7Eeh0gSdtMFoGa4c1/4IT5gXrdHr/Bf2Sz7r2L+N2J
         FwvVZ28GXeKVQ6swn1L23xHmOOM5aYMwQKGdMVkXQ4vNWUK8cKrp4RBAV1T1yzjhHEaY
         JlC05worradVWjm1d+w107iZ5W+cSmrxuUCoC1aEfktG+Rf4xdXwXhpBtR6hLZefwp7r
         nnNsMjNvUSCpqDmgskmxOc4n0pqDHHVWxf1Ixq2XvuGV1BmEgaxtZgPJbiYVH12ISwgS
         hd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764381046; x=1764985846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xXq5BoozcLEtMZPipx/4wTBGFkZq8n4VHxCYYlUf+vY=;
        b=gVWBm6YWmQRQOtdcnnwyBJsrlBrhs75SXqMzD+Bd5qF/dfQVb1z+mZpzbbrRyEm2tn
         DvwjjuDQEexHaD5hSRTqOnKaqKO1XZq0XnnC6RxDgZ7SCEMNgOtstApj/Zdi3dZJJ44Y
         PZjSkIBfM2C2CK1LBlkZJ6gkCooRzIxkvKv4R14LVFVe5bb19OG810k5PwJ1sookSZ8V
         0XApfy/MT48uqhwyeL7vykG4Fmkvkmw1gqB5piHooXP1ZKtdqCQMkCOXupsHfgm2xxYn
         c2dXwUGI0Qb7XCZiQH7HroOh4W+U3z6mFscMGCzP84OOx5YIAHgqPRtA7mRM95BnVzgz
         FO0A==
X-Forwarded-Encrypted: i=1; AJvYcCWAjuoNUQaLWClS0L1IRrdMoJqpqmWzGiKqQ4T0Wk0xbxdQzFlDSneFlEJMpEAzpHRS0xpFzjDRkAOiUhs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkQdp1AMA6vMorxxVC8ybwU8WzwmzvRZSvgbVzvUSq4+ktMkKm
	a7wq5LCAryZasbcbtgIXN3Y2uvSFNE7RgAby7JagiL4w4Gi4OWKCPN12ATxDCCckERW3SFjvGce
	v9PpCAXvcBtc+JIurYXwJSaF/pUaCyXw=
X-Gm-Gg: ASbGncsfq0N56z5i52cLTxW/6o9xI2Ppu8WMgcUUGsHyKIBqiXsAYCaO6Hq1a3EhG+7
	1y0D8dKdCyxtZT0HjaWUx3Aqdw2BCs8LRyfmirwr33YiYuQ68JogYnD7RL3llyhYOCUCOe0X+fQ
	WMAYYYs5SPO8mKUJDuC6b8Vm1C6Bq8PAe16Es5j5egAqMJtS7LBjvtJJbQH9PzvpuY55/v2j3Ty
	AzJi0bfHlNcbSwjBf5gdmO/MjNZlexF32XqtwMQGiCP5Lz6+NYaFGgJNsg3bfpxRkt8OccqJyiN
	MdOO
X-Google-Smtp-Source: AGHT+IE+Tw+9Y5Bub3lN6sC4Pj0OtdTK9knmaYL6GikYTYtgwTjW4uUHcZO2kGFVdLFpIVKdsMHQoOJ3Bk1wdK27dic=
X-Received: by 2002:a05:622a:1909:b0:4ee:2942:c4fb with SMTP id
 d75a77b69052e-4ee5882d9d4mr417978631cf.31.1764381046350; Fri, 28 Nov 2025
 17:50:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-5-zhangshida@kylinos.cn> <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
In-Reply-To: <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 09:50:10 +0800
X-Gm-Features: AWmQ_bmFiM-2nj0DOVO633rnw-D1LMnVAvls5FZ2mk8-RJDyk4i3to2si2g7WjI
Message-ID: <CANubcdW7FxbtSRzePgO4wQwUFBpgbSYdL-GR87vUXKq7tAPsJg@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=88=
28=E6=97=A5=E5=91=A8=E4=BA=94 20:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 28, 2025 at 9:33=E2=80=AFAM zhangshida <starzhangzsd@gmail.co=
m> wrote:
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Now that all potential callers of bio_chain_endio have been
> > eliminated, completely prohibit any future calls to this function.
> >
> > Suggested-by: Ming Lei <ming.lei@redhat.com>
> > Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  block/bio.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index aa43435c15f..2473a2c0d2f 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *b=
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
> > +       BUG_ON(1);
>
> The below call is dead code and should be removed. With that, nothing
> remains of the first patch in this queue ("block: fix incorrect logic
> in bio_chain_endio") and that patch can be dropped.

Yeah, that makes it much clearer. I will do that.

Thanks,
Shida

>
> >         bio_endio(bio);
> >  }
> >
> > --
> > 2.34.1
> >
>
> Thanks,
> Andreas
>


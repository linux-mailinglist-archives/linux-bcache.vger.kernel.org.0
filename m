Return-Path: <linux-bcache+bounces-1346-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A5027CAB571
	for <lists+linux-bcache@lfdr.de>; Sun, 07 Dec 2025 14:30:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A225E3003BFC
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Dec 2025 13:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38C820B80B;
	Sun,  7 Dec 2025 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="abpO20rL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kjaguT/K"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ACC274B3B
	for <linux-bcache@vger.kernel.org>; Sun,  7 Dec 2025 13:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765114230; cv=none; b=YBjUhpdgReR2wNB9CHo6NdrFfORv0flX+iF0gzstqBwTg+LAR2Q/d9/MlNE3Ao8JV36z4T4e7bD2Bzuh+GZYD8AhDizrcFMD2oms14l3wqCUiu5Y1faJ3R9k3I5llicpNffH68N9ArjLWP0ILH6lx0ErZrsldRheNZFsXaBsX2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765114230; c=relaxed/simple;
	bh=W5VgE4r2CVWoGwWRjm61UM1/NAP7KmItMDhR9b0IcpQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKgq3n09u9UIsjW3MxN6AlqC8SI/oyIqCylNZPYE/1vYiKIVrAAsIpxu6WCDBQRS14ObMwN/VqfOSGp3LeoqArj2iDBt3to6NZ/OwfbcZVcSi7keKl5aJ2O/DtDgrvOvnIuBSSN4/ueNHw7KxQiy5Et9nvkxaNQVZEVGqtqZntI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=abpO20rL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kjaguT/K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765114227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dyJaX3Br1gUfDH7aDIFFQJYtt7YC2wra38Oz5IMJMOs=;
	b=abpO20rLXh03xCFVjLL6C5/hwnW5P+ASnEijl1JunG3OCzRLT5bufrzNTVjEPpi+sVbbcE
	k+x1UIm/9CcjbBimaGoEq3RGtyo4h7ixOOrQ5UqBfZttQzXNUVhBOLnGWstZ+sDaiQyzoc
	jY98CraicoIFBYmd8FGinVuT2/k3VwI=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-oi8BO_WAOb-rR6VwF1E-cQ-1; Sun, 07 Dec 2025 08:30:26 -0500
X-MC-Unique: oi8BO_WAOb-rR6VwF1E-cQ-1
X-Mimecast-MFC-AGG-ID: oi8BO_WAOb-rR6VwF1E-cQ_1765114226
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-640b8f1f66cso4668660d50.0
        for <linux-bcache@vger.kernel.org>; Sun, 07 Dec 2025 05:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765114226; x=1765719026; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dyJaX3Br1gUfDH7aDIFFQJYtt7YC2wra38Oz5IMJMOs=;
        b=kjaguT/K0p4P5MmSx6YhsbhXhFOISUHERO8XqV2ukuXbUIf4PK2vlw0CkOnHQFcWbQ
         M4nWqLwhO4KcJgKtTnmxkbq1/5SNAYyT8CLsAicuRwuqCLms4DglQJiBh7A0HwxbV6mo
         tCcTgfRe01HYiQ4qFZAhVZyc2nwCPAKc9TkpmNzxwoCjHk+xcSVroUO5q73hcYFWAm0T
         mWoW/iLxPKEg8urucctI2tYzcdHmlLm4HLs95wMXo3u4TVjc1JPM0qIdqT11J1RSc+kg
         ZKvpnwGqykHP+YI0rbUqsDwjlzKy0cBx2cSS9NaLgvSxS5YTScMyDqNlVw/dI0XX660Y
         LWPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765114226; x=1765719026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dyJaX3Br1gUfDH7aDIFFQJYtt7YC2wra38Oz5IMJMOs=;
        b=TXS9NqjiSzyg2JvNsaI76rAHmred4AoNQqaJN5zElg03mWOLqcxkZRGjVN1xGv52j3
         seRVaDcbnszDEkFGoAq47Ie6p2ULbIEQMZ+4lFLsLHbRZG13eP0jqGyu18Yuyk2MK/SR
         S23W8k+Fz5N8IMnIAaGENfn57gPyJPElKrM0P+KBJ2NxoP0nMJJ2MIreOomiFx2J/+9u
         iYya8S+hkjQtUUkRuGdh/m0SAMoSisBV6CpJsGR0Op597+3hgvgYvR5ueautiq4cIofW
         W4NPIGD6E5NLScT0Ljr6H5VzrkBsNYYLWRsTeSXLTfUf3d05GkE6hd4yVC39Be1cX4nq
         wkjA==
X-Forwarded-Encrypted: i=1; AJvYcCV4++gSf41Fh9Tt83nlJHakJPuZHU2KGXuUdTC/Nhz2DroBoLJsJYhsAtEVy39wAULCw3PM3ls0xn5cnUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKmWswqc1BBJtwWx52hnxGmRtJcipIlkJF385ehAqS6IJbX9lH
	FkIIZZcGUadSl8GmKK8Cqh3EOz1y7TskwunchaPoTmoVdl6x4ljDdDlU0LDuhboVYEFc9AvZTYV
	4xpaFO6NGMT8SC96WRuKzHp3sqXo6TLlD1O/YLrf2F362yN0VA3bWw4CunvYKTqvpwSEwIlOyXC
	xKMoSQ0CpcWwQ/RuWzxB6JDYoh9W4IJcc8dvfIYIx4
X-Gm-Gg: ASbGncuEYILwUIXpWhwrLTq8et6ngYx/6eY2Pk8FS7X8Z6nHBUE/GSL+F5i85s0ozA2
	4+TJNlOp52LAHe8L7dxXiXNRE9LNNQoG7e+kBe+WQ96ioASmso90Z362HP/wDlllG9krtNpeehT
	QW0phxtua7PncGJFVJJWja93MDqYDonQkTiICJa2RGwgT0jix2Lvn8w+9ocDFDIc2y
X-Received: by 2002:a05:690e:1558:20b0:63e:d1f:d685 with SMTP id 956f58d0204a3-6444e7a7349mr3378298d50.51.1765114225826;
        Sun, 07 Dec 2025 05:30:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEsn94jBMoBtCfC8cOMR7Xi5Q38jNQ4OxAQtSaZJowhI0RPQWMyYAHpWjEOclJ1tIBrXif951eLBGPvNrNBnac=
X-Received: by 2002:a05:690e:1558:20b0:63e:d1f:d685 with SMTP id
 956f58d0204a3-6444e7a7349mr3378279d50.51.1765114225448; Sun, 07 Dec 2025
 05:30:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251207122126.3518192-1-zhangshida@kylinos.cn> <20251207122126.3518192-4-zhangshida@kylinos.cn>
In-Reply-To: <20251207122126.3518192-4-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sun, 7 Dec 2025 14:30:14 +0100
X-Gm-Features: AQt7F2prHqWgr_4RxHUQSeBpsi93bplDx1qYL7XLgoYg1x8_8EqR7WBy3ifdzP8
Message-ID: <CAHc6FU5urJotiNOJEC4hyJz8HsNechZm9W07e_-DhgkYJmuDmA@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 1:22=E2=80=AFPM zhangshida <starzhangzsd@gmail.com> =
wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Andreas point out that multiple completions can race setting
> bi_status.
>
> If __bio_chain_endio() is called concurrently from multiple threads
> accessing the same parent bio, it should use WRITE_ONCE()/READ_ONCE()
> to access parent->bi_status and avoid data races.
>
> On x86 and ARM, these macros compile to the same instruction as a
> normal write, but they may be required on other architectures to
> prevent tearing, and to ensure the compiler does not add or remove
> memory accesses under the assumption that the values are not accessed
> concurrently.
>
> Adopting a cmpxchg approach, as used in other code paths, resolves all
> these issues, as suggested by Christoph.
>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index d236ca35271..8b4b6b4e210 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -314,8 +314,9 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>         struct bio *parent =3D bio->bi_private;
>
> -       if (bio->bi_status && !parent->bi_status)
> -               parent->bi_status =3D bio->bi_status;
> +       if (bio->bi_status)
> +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> +
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>

I thought you were going to drop this??

Andreas



Return-Path: <linux-bcache+bounces-1315-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA344C96669
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 10:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4592E3A4F7D
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 09:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8C03016E3;
	Mon,  1 Dec 2025 09:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1ySRkXZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kgnj2fEK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C0D30147D
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 09:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764581697; cv=none; b=U+plbmwG9XLitFczxBY9+nP/550B5eUMVoSStcCmN8pTQShU6lsDv1QqQ5wpEbzuWAZ2WNof4laGgwHYvba4mAXP3GRsYJI9m6EX02Lb9OT8nauCumYFDNpo4LxRi0Dye+NbQZEwlCWexRGE0Ul8X/TxcURPBVyZW3p7gT5bivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764581697; c=relaxed/simple;
	bh=T52AtHPElaPUhvMaiSySl1nDPtYlKqOJljlXi1j8qDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALITWtmrdUuLuqT5F5qvNI1SYAIpZnpey44Ew7L8XduoP00y3hG4Q4Zh0L97sh6PrZtaeJU2ornmj26FUUZl5Dk+uhPicK3LK2F0Ha4EPzESW4TIJ59Hv2N9IGYiD+qZlVSy5Oqmw9ysA1qTpkKJnD7/0yD/SnKNzQnh9urvW7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1ySRkXZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kgnj2fEK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764581694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YnXOTrBkDWFfUknE1oxAp7HDSV9l35AiIkERLzX4GY=;
	b=a1ySRkXZGxAUiTfbngehExE4V+oFMiLpCDswlGj3X4BN2QMT5c5qo30+YyLGjKNP9fqXea
	cH0o1CdSGWxaxsIHNkXA9qD7J6hQRXcx86F7TyIGWFkItSscnmXhJ75gzFma5uvoB6wIAn
	SPu+icR8C4besMD+Q/o0DdpIjBwKaXY=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-q97VzfTWMCOmcezAf3oJPQ-1; Mon, 01 Dec 2025 04:34:53 -0500
X-MC-Unique: q97VzfTWMCOmcezAf3oJPQ-1
X-Mimecast-MFC-AGG-ID: q97VzfTWMCOmcezAf3oJPQ_1764581693
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-78659774402so50135437b3.2
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 01:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764581693; x=1765186493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YnXOTrBkDWFfUknE1oxAp7HDSV9l35AiIkERLzX4GY=;
        b=kgnj2fEKyuJ6SrAFR9hQ+Z0PhkkELMpCJhItlNnTYxDRqDZf1Y/ZnZPXaxsue3IUSm
         2xCowS2Hnz6IdyCBUd7At94+M80Jeyvj45r3Lit8Bc3G+2N1CYkv01DwDRgR0uPCCXx9
         JhhJdT9ARMyV18LfrwU/Ep+V3vlv0dTNHGhB/UBhabH9zTpxJrUrC6tzBIwBVvP9Colg
         P1sqvp6R2PUlyN77eR4a2Y9Ezwt3lrA7d1GmpGqN461SZHOV+4HCnh5h0WVLp5hNWBJX
         HBOd9H6HFQJGwa+5SHIHNBLl9M4h2j8/2Euea8hYkUBJ/iOmqV004Ny9oVaxn468bRN4
         1UOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764581693; x=1765186493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7YnXOTrBkDWFfUknE1oxAp7HDSV9l35AiIkERLzX4GY=;
        b=d27RMlUxcnqRjPD1UsPKZYhidLn3rZ8BTX5JlTdYYgn2WW840HJUlpNUwdKR/THh+5
         q1CBewDdoYsQyUuSzyS/Wdpryd7lAm6DNlFrJDrZFUIGdBKXudiLnaeo7XQmdQuZkoXI
         dqQvIYn7LJuVdoYdGxcddsw91/2QIotFsJjVIwKWlY/m5Rhf64g+V0m7AMy8BpKMAfu2
         NR5spqtvigXsTb9tNxipT/VE4rz9ujMbJElDVvW3WZ1WlpatmJAswn8dTA9ToNpAIh+F
         pw5E3ODsW9Ns6wwkm7/xoO+pKEhijWF7Xvt6srdQOeeFeEr/hT0+jNPV/RFwe+JyylLG
         OYPg==
X-Forwarded-Encrypted: i=1; AJvYcCX4oh8GEPmwGodknTEkZbMwJoE1lPbzyz5H9ESKsgtZvyl2PR93GrU2Ath0nW2NLWOgL0k2HFvCezgBDnk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI3ruPNdjVX9aZzF2RXT1wzABW86pT7LjeUZgIbjg/192U3Kvs
	CXUnhKMNbTVSyTl9SBeaXKv3YDTVl+EK/t/b8GBcliLQ9WjpL285rZVzSdi+BBz5g5bGvgPvEm1
	R4B5k81ptTqsDMHObA30HeNKNrn+X/AfqUb3LQuDYY0CWjzAy+OSdjtciPkoHm/Pi8Kjzb7ncRB
	hOQbvy/wiGg82UbOqwTY4MJ9E3rONgf15oFdpSbUYU
X-Gm-Gg: ASbGncuQrVlnq6ucgNXOEuWHPQ6eb6ctZn9tkNUXxa8J7qcDnQdTN6IRvsbKJuPF1L8
	ekAMBXlEr8DihZ5kqijYu17TBbSoEQS3rLbAdFo99qAxXEnzsFmwHdH/QO3C1jbCHgYJIpuLFvQ
	I/A76JRhqblE/JYsGtdB2pIM3+umt+TynQrWPctnhjVwEk6gnYLPTJ9ugWLRAesdBm
X-Received: by 2002:a05:690c:4b89:b0:789:6c45:5ee with SMTP id 00721157ae682-78a8b529321mr327732197b3.42.1764581693221;
        Mon, 01 Dec 2025 01:34:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEE+ydvQLXLWR4PLDlpL5sDe/7ms/CBFUiYi8OzSrRwSjG/eFnKOHmSMbzUo+6JiXvQr8GsLl9rt2B5meQ6+yY=
X-Received: by 2002:a05:690c:4b89:b0:789:6c45:5ee with SMTP id
 00721157ae682-78a8b529321mr327732007b3.42.1764581692913; Mon, 01 Dec 2025
 01:34:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251201090442.2707362-1-zhangshida@kylinos.cn> <20251201090442.2707362-3-zhangshida@kylinos.cn>
In-Reply-To: <20251201090442.2707362-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 1 Dec 2025 10:34:42 +0100
X-Gm-Features: AWmQ_bkx-ahSOMJme7sYbH0k3cAGQiXM2JSUj318w4dIuYwRxb1qdF2fgZVmzjo
Message-ID: <CAHc6FU53qroW6nj_ToKrSJoMZG4xrucq=jMJhc2qMr22UAWMCw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] block: prohibit calls to bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 10:05=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Now that all potential callers of bio_chain_endio have been
> eliminated, completely prohibit any future calls to this function.
>
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index b3a79285c27..1b5e4577f4c 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -320,9 +320,13 @@ static struct bio *__bio_chain_endio(struct bio *bio=
)
>         return parent;
>  }
>
> +/**
> + * This function should only be used as a flag and must never be called.
> + * If execution reaches here, it indicates a serious programming error.
> + */
>  static void bio_chain_endio(struct bio *bio)
>  {
> -       bio_endio(__bio_chain_endio(bio));
> +       BUG_ON(1);

Just 'BUG()'.

>  }
>
>  /**

> --
> 2.34.1
>

Andreas



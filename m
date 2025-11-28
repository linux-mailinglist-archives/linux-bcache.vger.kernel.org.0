Return-Path: <linux-bcache+bounces-1279-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF30C920A4
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 13:58:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95B4C3AD6AF
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 12:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 284FB32B993;
	Fri, 28 Nov 2025 12:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqGtPdEJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkmTyH/+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C391732ABFA
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 12:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334659; cv=none; b=hWcuBdDpFGDwhvJHTUBCd+hnSb5m5dSnpYAK03aDpSH5QaG0PwWsfd5N8KY8enB/4OUB2qv60LjxjuAAEAv9TeLubJm3SSSKtlBZSlCn0A/xib3ZOPzSN4ERJDCLvIdSTYdCjQR1u+YB+IHvx0Huy9KD9TF7M/zXQx9hXqEsOPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334659; c=relaxed/simple;
	bh=77RRIbnmoJwy1cEKeO1cRn3JJgXHE29OKRRM9cIvMcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MMbbP7oB97N99SbGkAFGf86EOlP+UFZ9Bhj+s47uu+dNw8M6DcQQN1FY+vfeokC77FlIj+5lUgMpfVgL8/bB62RxhtD71obfUpWoXzCTMiSBfyVC649gvkaRYdS7P819/34Mzflf9WGe/2e0ULZ+t/HVBPrli6k3ahR9NjIcYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqGtPdEJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkmTyH/+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764334655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2NUtFfF9SbHj+pN5h7ZLsSymt83AD97eoXiZYz42dA=;
	b=eqGtPdEJ27UP49AIWSoGhqx3ahsyvnrQiOQhYP1ZdyQwTXcEviCdg6ZNVKwpUbnqreNB9f
	qZ3RdIPMgWU5nzNRfCaCAksCgGIhROBnVFjWZZ58I2kb0DhIlAIDIFfZXIMaZJL89uO9PP
	sRmQBWHdY3mROQAuySMyzMetrhn7IY8=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-bzCfuPn9NJS2nKuyX-xK7A-1; Fri, 28 Nov 2025 07:57:34 -0500
X-MC-Unique: bzCfuPn9NJS2nKuyX-xK7A-1
X-Mimecast-MFC-AGG-ID: bzCfuPn9NJS2nKuyX-xK7A_1764334654
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-787d4af9896so23868697b3.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 04:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764334654; x=1764939454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2NUtFfF9SbHj+pN5h7ZLsSymt83AD97eoXiZYz42dA=;
        b=KkmTyH/+YC8Pr4pIQyvVOsSh7/2QgJLBbxgIZuOBDms7KR0jqwCdQJMYK0noUZabxW
         vW8EAUlW+I8yoPMRzsbbDc3BUEBQhAU4HonDoHxc1UHSxUCbI9D97catXteU/hsdKV8Q
         ghvO4e2HPI5CtwvSeOTymnEKR6q3xn4yE6kaKM9Cp8R7wy8mkAbjS1FbExKgFNg8lEne
         EFTD/D7wom7Pm1bnDbG9EL0phHFOL1uiNXahyh1YTgrj41RoQ8bsb7BZI66wvhqLAQiv
         IsIlXGncrulI4vLTi8kEkyLyfe4OJKN0fUtfD60sUZ6W8Wk3aXd8IlwtoXYIx0BO9rPl
         HcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334654; x=1764939454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k2NUtFfF9SbHj+pN5h7ZLsSymt83AD97eoXiZYz42dA=;
        b=ZY0tK2/jk9K/x0PgNN++4CQGVtoWGCAmF0gx4OczA7krZczG4s6+mKPqilF+xyKVO1
         TdJunnUyaJlwu3HHtd+7wpyTJj608w/INaJGh852nWPSWM3WObW3bytppCtQFfpg3TSu
         +CJ7u+hBpaL1Wpuj0dcb/nGcoE4/38h87wQKleUtqmJG3jV6oe1eE62b6+bCEgiguveT
         s2b+7usU+lCj9HMQnmKklWSuvr5sdsrvr7+rvag8RktEQzK2v5E5cGHeOChvb60SlUdG
         KRuQnBt9rlx+R6evUs9yoojH84NYsoxHVumQf7ZTHt89Zw80KDCVW2GMXcDcRJ6tE65I
         +rUw==
X-Forwarded-Encrypted: i=1; AJvYcCUots9a8i82j6m01KeJT7JFPCl/deHTyWRoB7vP0/xg42KPEBBg15sgcpRPcgNgvzSx18FRiCGf+Geun1E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2pmUVbquwSNfa97G1kxCrZmxBTju8UYmkycZ0hZYmhhFtBYp0
	5uchP9tpkUW9SI1/rAZnA2Vr+3dm0Cqo6QZcG3KRHOeAhRjI9gaU5HMWk869EsevplwmRqx0bok
	I3xDoD5TLbp4hY8e81T9oKRaPUJVv4wWwnFkQzCqg4eYd2a5+atQimI5fDh52yyXpjsxTkpLX8X
	o+dQ46ylSS7z6WXqJHcXhYJCB6aaqEystigVbsgkvO5C2bVU8E
X-Gm-Gg: ASbGnctJBXDspiOEUYzgfhKKM3lnpxjhaBrAsaR0B7ONzbR6Yn6vvU3tTG5Z3it6X33
	8I9uIKB+fqi1PI/mvWpl1V2415AOUhssiVKdEAMSMsUy769zh+WzlQktPq70NHyEHelaJpmPaJu
	Wg+CFP8TRQxyHqPE5PzSIBrU7MwNQSVBKHIRo/G2h+Ivi6WQkHe/WFvYiua1bdoBp8
X-Received: by 2002:a05:690c:3348:b0:786:a967:5a8a with SMTP id 00721157ae682-78a8b521351mr209364477b3.51.1764334653921;
        Fri, 28 Nov 2025 04:57:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYKB1oLuPGJAVoxdwBsDfFu85nnaWrR7frU4rGijoJHAkyVO4VlXEEBnQXgKFqXNy1QVvTkGpWt9+fdpViZKM=
X-Received: by 2002:a05:690c:3348:b0:786:a967:5a8a with SMTP id
 00721157ae682-78a8b521351mr209364247b3.51.1764334653580; Fri, 28 Nov 2025
 04:57:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 13:57:22 +0100
X-Gm-Features: AWmQ_bncrRsjrklAzt9B3bsSktqMzFJHIbAcDYZydnWE535duaAjUcuyPEWTG9Q
Message-ID: <CAHc6FU53GR-FTPzWSuxQumJXX7z6HrzFGo5=kfA1VHt3KxwNOA@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:32=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Andreas point out that multiple completions can race setting
> bi_status.
>
> The check (parent->bi_status) and the subsequent write are not an
> atomic operation. The value of parent->bi_status could have changed
> between the time you read it for the if check and the time you write
> to it. So we use cmpxchg to fix the race, as suggested by Christoph.
>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 55c2c1a0020..aa43435c15f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
>  static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>         struct bio *parent =3D bio->bi_private;
> +       blk_status_t *status =3D &parent->bi_status;
> +       blk_status_t new_status =3D bio->bi_status;
> +
> +       if (new_status !=3D BLK_STS_OK)
> +               cmpxchg(status, BLK_STS_OK, new_status);

This isn't wrong, but bi_status is explicitly set to 0 and compared
with 0 all over the place, so putting in BLK_STS_OK here doesn't
really help IMHO.

> -       if (bio->bi_status && !parent->bi_status)
> -               parent->bi_status =3D bio->bi_status;
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>

Thanks,
Andreas



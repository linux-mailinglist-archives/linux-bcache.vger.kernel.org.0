Return-Path: <linux-bcache+bounces-1371-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 01837D23020
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 09:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D90D3062BCF
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 08:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35A132E6BB;
	Thu, 15 Jan 2026 08:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G02FI+Lk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6678932E690
	for <linux-bcache@vger.kernel.org>; Thu, 15 Jan 2026 08:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768464451; cv=none; b=GxFlBk9F7ON5+1Pl4xkVEKBFyEDnOcGYbvuNszYKdCRlx7wjOT+iqmaXOBSrNkbn+5NO8mdghZNBl4mxNnaJLLww5a5gPWfX7KBPZtEl+sb+uE7PJtuLCPyHAXi+GggfqS6ca8TzNCE8eryWByETvan1WKcNhQvqtXXNGEm3+X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768464451; c=relaxed/simple;
	bh=+XHNwT1eqDOScPRqfqvo1LFqU0o2+OVjaeZQd9mO4FY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mlA94BbfDVKTaA4GRy9IM90eH+IZlawcwkNIxeB6M2PruTvSF91uerQy66BJSsBgQMkxAaB+vCwPX4DU6rvPH/3Fd5Q4KJwLDxyj5A6DbADNd2uK4eSVaZ2c+gjxb0TFtQpF8E+L8V0SFpff/nRYv+9bw7qZCrRdvvnP0iirB5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G02FI+Lk; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so3492436d6.1
        for <linux-bcache@vger.kernel.org>; Thu, 15 Jan 2026 00:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768464449; x=1769069249; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+1HbL/2SygVmeuJIqI/yyMqReifWEjU2or+bwXISJo=;
        b=G02FI+LkjBwn9s1kFSdWDo2uJoQ2YwqDlRYb1D/nw7+TitquVrYX/L+8aOGNA7hZJd
         ikidQVOUcFKxOThdZwabDicpmWhS6TAz1TZPK2JTC2qmgEXruZy7xQ96SlcWXE9fNtSu
         KwzO5th66FKEm+o+9f32ZKep0GqjZBGxR6haCG81VbRbAv375iMw/LkU2jQFJSEAg2vr
         +t/KWHpEZ1gWGfsCRnBylVg1zv1MrJV4c2twWQpopmLQ4GZFWtJmoOa5/tnrdcjeiLAq
         Qt8xbUMSri8/lk2koX8uV1wV4eXySrX+xrfdZd9fzNYn+ihru8/go0PP1nxFpcO1Ei39
         G3zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768464449; x=1769069249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I+1HbL/2SygVmeuJIqI/yyMqReifWEjU2or+bwXISJo=;
        b=OK05B4KO8ji8HJZQNV13yCCX4h2MaGHgFxM6mlQlaesxIcjuF+FqOuiJAO/IB+7W9N
         dTt+v9zdwn2mZoQb9c0GbYnS3rnEOiSrbMtoWNbDR7P+pvGP4UyKKO3TlIt0P5Q0xX/R
         MWxi9HljK6gBvVdtkx8GEubvDcYWTyB9dzPXtltTDEbedxt0QEzSrKtcVqp8nDM4bvnf
         Slx9ylAHFS6csQse4FR3VnQ/IxgE0T1zbEwVcbyxbwGTHfRFxnx8ji6gLa190Ex500S6
         nI/wZ7Ua0O/25dBU6b0K0682ZixZRlELrfHayFvoL8u5xAQ+ZB73tgYXrdHYcDuS7z0C
         Cdgg==
X-Gm-Message-State: AOJu0Yznxq8qxFX0wBUchN+8PqWiWAqCtYHE/D3f9SMePQ606uA4OLjV
	QpetBmbyNbHLsWi24PaxqPAbbIArD0bMp2wNIKg5BWA5qRZKLdgTuzy64Ygqpk4Vnafjv61QtyH
	H/R0i12t//tF0rUyP/Bwh1HXkwyLYhwA=
X-Gm-Gg: AY/fxX4NelAArBsY25lpFki0rH66BEdU0Vg7u5enHcwOa9w6Rn0FQ0C7ufX0Qfb08oe
	35/W70gldIZOda1dMcYb2Gfa5RD8MpXOh/lhWvO4XVu+pzNQ8UqwyIaN1GKMeIw1HX+pthiOqNl
	A4Zj2a2avSjilytm2kuP4nDkCrjXdifSl37ZII05iQkq7uvM+139UM6HqIjPwARQz8HoT1fJFyz
	MZuXp4oqxlqaESdoLQoMpJOWtXc/viG37UeLrcdqYoQ513vTp3mgRIZHz8LbtPjgHJ90Ko=
X-Received: by 2002:a05:6214:2307:b0:7f5:eda2:a54b with SMTP id
 6a1803df08f44-8927440bf8amr73398796d6.62.1768464449333; Thu, 15 Jan 2026
 00:07:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
In-Reply-To: <20260115074811.230807-1-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Thu, 15 Jan 2026 16:06:53 +0800
X-Gm-Features: AZwV_QjjKYKaMjflr-0zf-nIcyiQgY61xPo4gs_yhBBE61Q3citczKHR5lKrtO0
Message-ID: <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix double bio_endio completion in detached_dev_end_io
To: colyli@fnnas.com, kent.overstreet@linux.dev, axboe@kernel.dk, 
	sashal@kernel.org
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2026=E5=B9=B41=E6=9C=8815=E6=
=97=A5=E5=91=A8=E5=9B=9B 15:48=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Commit 53280e398471 ("bcache: fix improper use of bi_end_io") attempted
> to fix up bio completions by replacing manual bi_end_io calls with
> bio_endio(). However, it introduced a double-completion bug in the
> detached_dev path.
>
> In a normal completion path, the call stack is:
>    blk_update_request
>      bio_endio(bio)
>        bio->bi_end_io(bio) -> detached_dev_end_io
>          bio_endio(bio)    <- BUG: second call
>
> To fix this, detached_dev_end_io() must manually call the next completion
> handler in the chain.
>
> However, in detached_dev_do_request(), if a discard is unsupported, the
> bio is rejected before being submitted to the lower level. In this case,
> we can use the standard bio_endio().
>
>    detached_dev_do_request
>      bio_endio(bio)        <- Correct: starts completion for
>                                 unsubmitted bio
>
> Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  drivers/md/bcache/request.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 82fdea7dea7..ec712b5879f 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1104,7 +1104,14 @@ static void detached_dev_end_io(struct bio *bio)
>         }
>
>         kfree(ddip);
> -       bio_endio(bio);
> +       /*
> +        * This is an exception where bio_endio() cannot be used.
> +        * We are already called from within a bio_endio() stack;
> +        * calling it again here would result in a double-completion
> +        * (decrementing bi_remaining twice). We must call the
> +        * original completion routine directly.
> +        */
> +       bio->bi_end_io(bio);
>  }
>
>  static void detached_dev_do_request(struct bcache_device *d, struct bio =
*bio,
> @@ -1136,7 +1143,7 @@ static void detached_dev_do_request(struct bcache_d=
evice *d, struct bio *bio,
>
>         if ((bio_op(bio) =3D=3D REQ_OP_DISCARD) &&
>             !bdev_max_discard_sectors(dc->bdev))
> -               detached_dev_end_io(bio);
> +               bio_endio(bio);
>         else
>                 submit_bio_noacct(bio);
>  }
> --
> 2.34.1
>

Hi,

My apologies for the late reply due to a delay in checking my working inbox=
.
I see the issue mentioned in:
https://lore.kernel.org/all/aWU2mO5v6RezmIpZ@moria.home.lan/
this was indeed an oversight on my part.

To resolve this quickly, I've prepared a direct fix for the
double-completion bug.
I hope this is better than a full revert.

Thank,
Shida


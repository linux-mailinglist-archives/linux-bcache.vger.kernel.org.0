Return-Path: <linux-bcache+bounces-1283-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 531E8C930AD
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 20:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9B0F934B45F
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 19:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1AA334395;
	Fri, 28 Nov 2025 19:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="el59bO9j"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC13332EAC
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764359100; cv=none; b=YzGaCler8cX+w/ZMSZPnSb8x17QUiLhcOQkgy//K3Ua/luTV1J+/DSAFv296/ifSTgAQvStEqunxkD0xq7QYl2qBn3yc51Pc14RHtlPfDJWVeDPfWaSEhXIopOSwiilMuZxaJXwxIqg/RUcKREHRsrRgZ5NDVoVT5JVieiPpiG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764359100; c=relaxed/simple;
	bh=Bj3AP+5QeibKDhdHKJOIKyIGtMszqSOZbOkDUOZlHKs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PzcXXWqNBH8NFuf+l90yXT/ez6GKnlIudgFGiCs1hH0s+2kpGebWxeE3zIzNjL3969bp4fofqTElRMMuaRbobZ4e5we6QffF7cPhYREgtV5I9CWKR98hqf1KtxvS369CWJzdaJCjPpFUhE1OhVpBzP4eyGrOwTFS7eezG8vY7c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=el59bO9j; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a9fb70f7a9so157160b3a.1
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 11:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764359098; x=1764963898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EL5lnQB6ArvqmktVf7HK0TGQSj04Cghit8sLG5wYDU0=;
        b=el59bO9jJMLyO96OLuSFBH9W3kcxAcyqEkait77EQx9Az/+wt4rx8HvikHsM9tMhx/
         C4agcYQr/61bgLiBvO03xMwUb1D7MyukgjO5pi9bjx8nk5cgT5e5iruwVf7oZvCGHecq
         NKi3FBScD9t7ergYvrO5N5wAkuB0B9iOVp9PNekyyWkhfTE2bD994FfIVI/itMmYc9Ar
         zkWZal4nSzzpvWaj4ra1Ydnu2WWqaBGjzxf/zVONBv6icacw2KKopTmN9M3kmSjj22y7
         T07Zta5oWLLDCtOK17IPmMoIFJC6s10lxpu1M+LebEnu3iCILK8gnie8yD8CZ+gJbfgT
         WcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764359098; x=1764963898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EL5lnQB6ArvqmktVf7HK0TGQSj04Cghit8sLG5wYDU0=;
        b=JDAFtMEeszkoysKxRA8iHP7KxHeUwoijbaw14o5YmGR0SpsFTbokgatRaYk042LnAP
         Xv/aOaixPEQYe0rVQOT8q/Iq+AhdSur5hbLxLeS9DsXyu/MjClaYes49Lyww8Fnq+xkZ
         lcaWfiS2J9w21lP794CuTDK1+7ZUk0SrKFR5r4QJSOMwlYkr65HHkORn6+aQtEGF8qQ/
         HWklvKAivs9I74wV9D+raVS0JDnBgGBPYny+XxOXS71LtF3g0Ci68KEOY8koyBK4GvLQ
         dgGniFqqOgrtzvBMy++vxd+1GC0b9v0l2u3Oj1Ij46o2Ha9JbfuwqOTXH7NaT09H9ijw
         LkXw==
X-Forwarded-Encrypted: i=1; AJvYcCXmWKpIXAmZFqKfx7HHvoO+/USt/PVXQPSq0fVrDu/w23mk5Tkht5gGIp8r9GDp4vScpVF1gG1MfbVjuLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJYG7TS36Ddct/rcEQih+n3SOkI1wMtLbmqIi5Dvhs8XdCuDck
	w3AK0N5s5+dje3KBj+bUJvADBRIcv7DIAG/TiwgWkpAzi2LKYcxA+73KXF8PbGXhHT7wnaPgs7M
	WVVOw16oCyxE0gzaT8O65tnZuRk1TsweSQnzxkHDf4A==
X-Gm-Gg: ASbGncvChdxjZOIIHoChlavcgGXK1+vmhfxCqG+DQkTQ6qKZVlbKRD4+EjBs0Ac2ODa
	BswEcMlUNts+ddN0aQc970nQYqMZbLGnMp6Po5AQfSuCshRzEspYYkN2wxO4OhhWXmUZvwA96Uc
	5koSMzdhoMaz3QnhYLjtkF+9ObUquq1l//srxv+Rcxd7aJ/iOuxUZOG5+QS6j0Bs7KoJGF4k18J
	qzKtqf0zGNpghizeP33zqT4eRMMITvZRHYdfPxfYbytVhvoUEWGZPak04LR9ezRt/A8JLQS0Ovn
	osVBZ98=
X-Google-Smtp-Source: AGHT+IGrCksmBbxz9v6OODWXw3jg5JUAuqr2uXfNM+p+AOqeGW6UtPYXkYo+cITOMsNqpMT81gOSwHim2ngfe4fkcew=
X-Received: by 2002:a05:7022:69a9:b0:119:e56a:4ffb with SMTP id
 a92af1059eb24-11c9d5538e8mr18207898c88.0.1764359097859; Fri, 28 Nov 2025
 11:44:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 28 Nov 2025 11:44:46 -0800
X-Gm-Features: AWmQ_bnZzeizOKu2WLPi5AEBKsrxZhyOw3plwI8tIQrc3qIRhB_hMon5zXQE3Nw
Message-ID: <CADUfDZqBYdygou9BSgpC+Mg+6+vaE2q-K=i1WJB1+KAeBkS1dg@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Andreas Gruenbacher <agruenba@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 12:34=E2=80=AFAM zhangshida <starzhangzsd@gmail.com=
> wrote:
>
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

nit: this variable seems unnecessary, just use &parent->bi_status
directly in the one place it's needed?

Best,
Caleb

> +       blk_status_t new_status =3D bio->bi_status;
> +
> +       if (new_status !=3D BLK_STS_OK)
> +               cmpxchg(status, BLK_STS_OK, new_status);
>
> -       if (bio->bi_status && !parent->bi_status)
> -               parent->bi_status =3D bio->bi_status;
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>
>


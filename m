Return-Path: <linux-bcache+bounces-1339-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF99CAA368
	for <lists+linux-bcache@lfdr.de>; Sat, 06 Dec 2025 10:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CFE49308ED2F
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Dec 2025 09:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31032E285C;
	Sat,  6 Dec 2025 09:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qq1zBoTv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FC42E22BD
	for <linux-bcache@vger.kernel.org>; Sat,  6 Dec 2025 09:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765013210; cv=none; b=jZ7Ecav/97x5wHtczNAhLcROYgtZiJB9Ppq+1nH147rCxDn/+JkHSYhWE+IhCcv7AF03yrFth3VxHx8FHgItpU5fJOlWz+y5hJCgIEVT5/jvGzprtOvSKXjnQjd2XSgTwcUEj7+coxvLTttAFw+LsS2Y6VKZd7u1fiHQtRrycIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765013210; c=relaxed/simple;
	bh=U2cyg0CRWB2HshiXhIkvPbUF9ckk6zfXQWgmnUX/HfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZvbWd7UcaDHrrqtsCAqzBOTWqqPDNQ0IOKgPC4oIAZ9C2LZlQu48OHPHNfn1bNpFWH6py6MsVn1Th52E7TqwCx7HiYu2Ucx+7Yr3CbZWFqNt79WA+P0QhXD1ETVI3ZlMJb/hOBMFTCJBNzhqkmPI1T4mpzzpsv0FlMcjN6anv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qq1zBoTv; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee328b8e38so27825821cf.0
        for <linux-bcache@vger.kernel.org>; Sat, 06 Dec 2025 01:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765013208; x=1765618008; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFq0oc8pMr+gyKPI+JedBdUGzF3CFNc+V/Wsq4FQfLE=;
        b=Qq1zBoTvgsNqJtmT3SC2qB+68Tbq4CbwcqrUf8BBun5ksjn8GfDP0hch9RTBb83bTO
         QWmrMY85avTTy1EijiakUxqgP4NipvADUUerJCT+EQBT4uUsdHx1JR9z/AIKKEsl8nWP
         U6UYUT9MFw+TdR+ieyTrsZm0s4q4xMAdzPka2bn3hzPGtdopIOdehLJi5Fy5uE+qlvGG
         gT0ulQrxA6QYrgq9Seq/faInKGFp1XneQGhyHtPKLx4Y1nKPlUvFj7IGy2gssGEZjMI7
         EtavdMOvUQfYIcrPDjom2/uoXBkg3+XN/uEYcwZzIGCHMWZaXiS0DCj2THTRz47TGcXh
         tMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765013208; x=1765618008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DFq0oc8pMr+gyKPI+JedBdUGzF3CFNc+V/Wsq4FQfLE=;
        b=Dsd+9JjiMpQ2+yJ6YMmnEn5eSdb6ihSuyb7I6uIXl9VdJc76ThXinF7YQvbBOutYoJ
         AmTgZGE+vkeLZHk4V826bBkADtKgayMrzKCHQUnZ7jqBmewn9F6Mg1IkAOs7oNZ9XdN1
         6iZvX1EqGYnohLeD4z0tPB3CEUI3gck8pkc5FfdRk3K5QFeUiV5vgdaL8Ga0KeEUWdNj
         YKjXCaZ42tJivLfWoP+AX11hAMZ2GKXWRbkj0hmg2Ou3aQHMshkHIOqZkGIZstUAdKyd
         cAtIuhYGK1nl9rjwE1vvF1wnfw8U2Qa5DK6EhyABtyMqEqq1TzVJGeFP5EA7dJwWA3j0
         9uLA==
X-Forwarded-Encrypted: i=1; AJvYcCX07aUPOBmdSxWzc3cV2Gv7UOg5Tgh/OWfA+XvPYoFGe6dk931omC0OHzfOEtDKksSDrzsfXz0HPsvjMVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI6zq/xMvRqgAqha5q5B2UqNNhYYzlcxCJfrcSykPINmy+BgtX
	AUG0QQRztvQxOUJ5Yk3iYh24Cj9HdfI9jcKhfOnoLzyAVVW0RNV61jGdZR3fCpC6tru7A1BI5di
	LY0jOorFz6eWKwH8ycDDvk7iBhSMgBwE=
X-Gm-Gg: ASbGncvJVKDoHb8Icuphbd7axtrNKMVlfPYMbgU+vLBrU1O6BvFCQCaG7LDJNXBTxgJ
	nDT+QsUUzZpG2E8qJHEZ/Y0DRFZpJ7NwHB5KC6ebKE9oXbGEm/5VpkDtXW5eNpO+AntMh4saSuD
	RXGnuLp8q+Uli9NYTLgpRwBLYraG4nos8gz8UQXG1vB9g1Y0v2tAluvi5An1LfVHHWPcsvgoCGG
	7BXj5NhXH8vhrPKpAZYQbMFLks+PrGyOqd7qKgMlNpTiVdniusc2e4spXmvo9Dho2uz2Hk=
X-Google-Smtp-Source: AGHT+IFspZZ6ukZmncarZXsvudX/fTFn7X4UqQQLpC7cwpKhlBQrJVKiC6JvXdnBKnL/BP0NqWEJAP6XaakAFwO/Qk8=
X-Received: by 2002:a05:622a:40b:b0:4e8:a413:bb3a with SMTP id
 d75a77b69052e-4f03fecb7b0mr26065551cf.46.1765013207871; Sat, 06 Dec 2025
 01:26:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204024748.3052502-1-zhangshida@kylinos.cn>
 <20251204024748.3052502-3-zhangshida@kylinos.cn> <aTFW_gdWmXmCP5fd@infradead.org>
In-Reply-To: <aTFW_gdWmXmCP5fd@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 6 Dec 2025 17:26:11 +0800
X-Gm-Features: AWmQ_bnus57zLSjJ12Ea0wTIQU-JiJap0bH-CABljQkrwQsCmNED2Krc5F7dwk4
Message-ID: <CANubcdVyvXTo98cOWLXr8JuEmo7P3H4kq2JASBURwZZG5oSYXQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] block: prohibit calls to bio_chain_endio
To: Christoph Hellwig <hch@infradead.org>
Cc: Johannes.Thumshirn@wdc.com, agruenba@redhat.com, ming.lei@redhat.com, 
	hsiangkao@linux.alibaba.com, csander@purestorage.com, colyli@fnnas.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B412=E6=9C=884=E6=
=97=A5=E5=91=A8=E5=9B=9B 17:40=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Dec 04, 2025 at 10:47:47AM +0800, zhangshida wrote:
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
> >  block/bio.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/block/bio.c b/block/bio.c
> > index b3a79285c27..cfb751dfcf5 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -320,9 +320,13 @@ static struct bio *__bio_chain_endio(struct bio *b=
io)
> >       return parent;
> >  }
> >
> > +/**
> > + * This function should only be used as a flag and must never be calle=
d.
> > + * If execution reaches here, it indicates a serious programming error=
.
> > + */
>
> This is not a kerneldoc comment and thus should not use /** to start
> the comment, otherwise the kerneldoc script will complain about
> missing kernel doc elelemts.
>

Thanks for catching that. I'll fix the comment format in the next revision.

Thanks,
Shida


> Otherwise looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>


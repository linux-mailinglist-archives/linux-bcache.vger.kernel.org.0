Return-Path: <linux-bcache+bounces-1284-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA390C935B5
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 02:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 626E0349CFE
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 01:20:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A6E1AC44D;
	Sat, 29 Nov 2025 01:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mx1oiJ55"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE936D4F9
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764379206; cv=none; b=tZctjQG1A9nQJXeUN7+S2WHb5hFCI7jfcPAYgF5/hcl/BeFdwKk/Ck5RnAsIhRe48ii5w0b+IQjlSKF4B6/vZjovwPKkjt7nMkJ5YS/Th1oBgL+Xuz8zIBNAZJ991iRkufiMvDG3VDgYAzjSCReuuvZu19pHQXDpmm+zj7/6heI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764379206; c=relaxed/simple;
	bh=CQ4gu5qwHISanFuymuvKH3qflMdaqJ/uuGBrjJ6tlTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwqH3Biia6oTk9M7d5OZx2NeHqaPS6vJOvEgqSx1cVVMt6zsxVfb8RkgN6krLeXIi97jLhemjkOtsJJiIrns3eVrbtQnDdK+/EKFSM1qHTM3YmL1Av6v7a3S02dGcQxrufTuIVCDXX7Hr+/E6Hfc+8GbVYvo4jz3c7Ew5EqestA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mx1oiJ55; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4edf1be4434so16496951cf.1
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 17:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764379204; x=1764984004; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fs0ohHvC2dybiBLIXiSQxGJyUXrOOQGSRM7UOWCS5dA=;
        b=Mx1oiJ55XOPXMyCAiN/Br5JFA3l1n2xcoNVlmgHTqEMYK+hrtl5bY6f7CurTScUiUz
         yRo6zDSIsPseHekpeKZlMJEnTeZPKLEVk4bJUHMUeeGWtVjHwyxC7NfzstE02D7PhQZe
         cUuVXgAensM9BqOkyuN1JmUc+x478me9YpEmKsW8oEB7sX37qyXCjNPI6QqGdmS8YiAt
         XoUo5REunWFNrEbtzHsRTuJftl5Z85x4meYDc4yQLp8zvQ4WPoq39zoCDnx41WOhWYTL
         uiZ6qVuE4mtikutYXDXrISPMG5kIpN1XYJqGpye5MMY1HxFHrPfiH+fLJzpajKKWwxsD
         oP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764379204; x=1764984004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fs0ohHvC2dybiBLIXiSQxGJyUXrOOQGSRM7UOWCS5dA=;
        b=SFhd6mmBW3qQE58cYA88SdHYxbG+9ugJRx0gWOcsqIbfj/adKZw4wWhiyo/GBzbPWd
         Hm/hshx59hPimKQl0nK77MUqoVUi9HlPJ2GYi/QaT2LZ41G0e2sxTV+7fVdwB1yEdeAx
         f99OoKRh3H9ZL5GXM0ozrNYFFWR84wmtgQ7DLjOYAQqLWPYmeNlb9/S/gtcldXGVaui7
         t2VjzmPpdMbMoLLmyEfq9Mxq4D1kc1kVUPiIKknHPy4QSX1zWCVWF93QOsjB37am2kKs
         qfytEjy5l0OGB7r8OjQIdTfD6m6W3GUyV58hdTSjb88RG/KUww6RtlOKop4EcxUVzXTY
         4A9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUakv83kAnrPHu6zg9dY/FVBJE/k9043mB5N1av6onM7oB5GukFsgLUELADQhKi9ygPPk4mS0cm1GKsSr4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY8PiMV7FYd9YU5M31W52kgKSz6m8cRJK7LZ/j9+4q6GK4AsNb
	RfC30lKQiZHX4ghZub7iFE0m+H208AaS5PPl21K6OmfMHIPDe41jHmvWd9IPq/Ztt/b0/UmrrxX
	gKfaMVauesezVO7OajCXZJ+VbMwm9ub8=
X-Gm-Gg: ASbGncsvMzsQYHPHr2hI7SWJvJjrcOaX5JFs/cnRltlsejpT07JTLDBIjR9MnapiTON
	fGu37NUUnqW1MJ6/8uKIE7D2t24epNUCOvcdQW1dKPQ26skgIql8jpqXWbzM1RKChA9IM3x7DUQ
	VbMQlFCv/bvwCbikGmRNTFq2zdnmcZpS5TVaQOsDyEOogj9uOBbZYFFar2cBi2rnCJLEYIdpcPM
	U7N+TxKDwr7oU7eZ7X6YeyheO5usc0+9mUg5XAigqaFaXj0T6h5LU96ZntcorRszwfUHA==
X-Google-Smtp-Source: AGHT+IGvVajIc41VyAxCuPyxqWUXb2OrVTIXZXouCyBBkNWEtauVL8pGUlccoVwLRAWDPyhKgINw+5nh517v8WUU60c=
X-Received: by 2002:ac8:7c43:0:b0:4ed:b1fe:f87f with SMTP id
 d75a77b69052e-4efbda3957amr254551091cf.20.1764379203672; Fri, 28 Nov 2025
 17:20:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-13-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-13-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 09:19:27 +0800
X-Gm-Features: AWmQ_bn06KtcfeC8pChk4HEBjz19bArSXx8IRJxxttyX3p2OYoBSLr0JgGawFZU
Message-ID: <CANubcdXJyE6Y5J3C5Zgc1jA7qSXk+_Hb0pm8Q-8cTb3Z_eM4sA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
To: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=E6=
=97=A5=E5=91=A8=E4=BA=94 16:33=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Replace repetitive bio chaining patterns with bio_chain_and_submit.
> Note that while the parameter order (prev vs new) differs from the
> original code, the chaining order does not affect bio chain
> functionality.
>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  drivers/nvme/target/io-cmd-bdev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-c=
md-bdev.c
> index 8d246b8ca60..4af45659bd2 100644
> --- a/drivers/nvme/target/io-cmd-bdev.c
> +++ b/drivers/nvme/target/io-cmd-bdev.c
> @@ -312,8 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *r=
eq)
>                                         opf, GFP_KERNEL);
>                         bio->bi_iter.bi_sector =3D sector;
>
> -                       bio_chain(bio, prev);
> -                       submit_bio(prev);
> +                       bio_chain_and_submit(prev, bio);
>                 }
>

My apologies.  I think the order really matters here, will drop this patch.

Thanks,
shida

>                 sector +=3D sg->length >> 9;
> --
> 2.34.1
>


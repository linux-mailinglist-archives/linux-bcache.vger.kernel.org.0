Return-Path: <linux-bcache+bounces-1288-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 26981C936D1
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 03:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EF8344E0F66
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 02:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625211E834B;
	Sat, 29 Nov 2025 02:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCo97o/Z"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1FB1DF248
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 02:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764384051; cv=none; b=rZskUKUjpKG4cZDgPdD+L3ZPmrMRwOmcbADfv80jj5mQUlnBRIXlRELF9VaH8HdXCjIsyRQIsCJzoTdy25GAJGrgE7O0XYXqtZjECrH8+iGrBNOW+KuaREsUbuMh2FoTSVQ6rShCwSYmm2yF86O/DFtkBtkYHOpRLZE0xKDV7W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764384051; c=relaxed/simple;
	bh=zHvwDf5Xq+iEVnjbasw1OMjmqc8Je/9Bg17U+6o9Pt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=djZU61TWAm9p6oZXnkeNsXLz4jdCjI8grxsbBXO0vMcXe8mnoz/SoylJHePgJX4VR5qgg/4CBjquwzSGoDp0ljH+yn3yCA++zqqHVuYm79shJEVcXTDd1UF7/xgrIMH+TrbA9/k9QvKuHR1vgMpS57PaA0tk6l06kBaNm5fpytk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCo97o/Z; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4edb6e678ddso31420511cf.2
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 18:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764384048; x=1764988848; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAPySlCz6W7rFB53xcBPcWM3i1+fAM460YdX4Fw6oEA=;
        b=CCo97o/ZznC1eYG5L1PrHUi7Tb5m2ILT15A2NutRwS9h8rBiavWDBFGlkOfkDQB5oB
         0X/BB1tXUWIMix9N0z0KmsOYBWqEExAsJNAPKKgsu8rFvDf42xCNF2R7K2eZ63CG6ilB
         H1a56ecPjNdSJiE0vHy9bjkS6cp9Z0nSUTfI+r4JpvpQpTherxSC+/tZtOkSaFgiLdjG
         qmE4kl8wxTwO8YvwVJqeZhYSsojWWzZfWS3eyvQqyOptCdxzbMqb9Bo5vQd8W+licGur
         40NtoB/FJslnZyBBtvbSVnwREtWFRl4siYiJlkw03UqA9KdvrNtpJEJyCPOQqVahMHAP
         Itdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764384048; x=1764988848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QAPySlCz6W7rFB53xcBPcWM3i1+fAM460YdX4Fw6oEA=;
        b=JWTs1Z1ks/n6kmBfRYjPUImTmCsCr7y8NqFvMG/aWiZHgIgRVvlseje6iVvz9XwCEc
         3FCFjPVtBhPn3FJ7/zHM1WNgDmtk4UyD1RSWj3O0CWE4Y3DYr1MScnw5A6v4LTKhpm/W
         G5kG9VUfTvl+aYRl8y8ZukH+4Anc8qe6HPg7bex6U1lo8YgAtUzqdufio+pY3J51hM6K
         gOHL7VhgAosSRyWQoTWc7v9VBGIFTznU2nXLXkPDL5ytKMD7vVg3vA8lKN4EiRX7jwc3
         4DNiinIl0/FO20X5Cimt3gNjraKCelQxiz/BkzWwJh2P72lYAv9CDf88S9RQcJz5DR/7
         Azwg==
X-Forwarded-Encrypted: i=1; AJvYcCVZwvjkNGB5W2hJx/ldGBGriFE2/txsRv2OSj2HtZAUkUBPFVQjXPrOcjIE5JrXT9lYHrSt7rtviWgejnY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFIJr8r6rwJrT1mMVr272/0uFlDf2gqXibtT7eS/6K2P2Lem1R
	FvJIdDKbEt5CgChpqGKXyh2zYZRhtugq5BgQgbEP2rgfb/aJUdrBX+9CbLnYjrKXEe26nAMB+x0
	8GpMkIoreL7gMQVNGvbNI+RHHqLOXlJ7JUJT2LMXxkg==
X-Gm-Gg: ASbGncu/9V6xA+C5zr5xVjbAMIxf4wiL3JeaY2hkpIf9UqEcPwT2J+zlgvyacybE3D2
	pWSLpsd1n2+kzO7uHeJFGk6N627n+39wJqDCrGXfw9PbIykuQbW0gu1x4x+3IL+tfFUIjU0f90V
	PraTAbykH/Td8Ub+BTsVdlkm4Nmw9oPbGXJXqHBPOYuZJifOWhaE2SZRjIQ9JwLulh2H1Wn4ZwM
	Q/rOuA3bdOarjB2GajCPfy47Yznb1/gH0+RoXI4Lp4YHZCYNV5lqVHbkOxvsl9+nkTQCw==
X-Google-Smtp-Source: AGHT+IEc3jQjTSh2wGwA1eyD2xP/eWtKWxB49pbTJ6uDNzgYaFeaO9lvwOhTEy0qjR7rLP4x3OvjjW+3HSCvva4PQqk=
X-Received: by 2002:ac8:5753:0:b0:4ee:1b36:b5c2 with SMTP id
 d75a77b69052e-4ee58af12d0mr418152811cf.68.1764384048425; Fri, 28 Nov 2025
 18:40:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-7-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-7-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 10:40:12 +0800
X-Gm-Features: AWmQ_bkvl1bn1ab0FbiQv1s_-KpnO8A0jbXWmROhOJd-0tcEov6J9fzUaa8ydUI
Message-ID: <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
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
> Replace duplicate bio chaining logic with the common
> bio_chain_and_submit helper function.
>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  fs/gfs2/lops.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> index 9c8c305a75c..0073fd7c454 100644
> --- a/fs/gfs2/lops.c
> +++ b/fs/gfs2/lops.c
> @@ -487,8 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, u=
nsigned int nr_iovecs)
>         new =3D bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOI=
O);
>         bio_clone_blkg_association(new, prev);
>         new->bi_iter.bi_sector =3D bio_end_sector(prev);
> -       bio_chain(new, prev);
> -       submit_bio(prev);
> +       bio_chain_and_submit(prev, new);

This one should also be dropped because the 'prev' and 'new' are in
the wrong order.

Thanks,
Shida

>         return new;
>  }
>
> --
> 2.34.1
>


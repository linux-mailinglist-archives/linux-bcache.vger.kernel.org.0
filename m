Return-Path: <linux-bcache+bounces-1282-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 70B43C9213C
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 14:11:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E985134F775
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 13:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBC732C948;
	Fri, 28 Nov 2025 13:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NIygpMCj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hcyUvvIv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C6732AAA0
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 13:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764335495; cv=none; b=Vmh32+Mnxn3bn9rej3sgtKhD0FeVvXsh7RhBgj/WLPeMgkDpLmXCzlLoNNGdy4TsDaMWe618I7G1YeHgJF1G3wocr96d6f4cxErH1lTkK/fmq2GyatSUSKUTCj62EwoSSwFkpGVmCDMKUfcuK4Hzbo2UyohOCKcvIl6B6wnxcv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764335495; c=relaxed/simple;
	bh=cT5VambQLzg4yYEkETS1DAEPp4cL0vkJ6BivaulYb7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VWrt8U/6vgGChEGm20T4gprTzXe6qS39bhJvIyymaTdUfwjZMulYr8DHiZJ0ZY8xWUkvENdHlEUegPLOUIgML5wnvX3nRbc0e3mES0NwkzbLlQ15+UrifRZ60oz+eqchhxpRImjzxRJ7tnh3nqqGANoI5nEar5jzwfgjcOgO2zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NIygpMCj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hcyUvvIv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764335492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
	b=NIygpMCjROe06ApYalrjCwRGN6G2Tx+linFraEADItEpQw2KNmtseValASb2gjO06Aw76q
	n1FD02DdItSdCyNLrX400ubJ06v/7QuXk03zt3yYqPeTo2DW/sTEKRYaCG2V9XX/LqKz6H
	ia/Dj+q5XlYYmWUNeQDjF/EmM7g2jfs=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-d0Pz7WzvMAikDBr6BGjygA-1; Fri, 28 Nov 2025 08:11:31 -0500
X-MC-Unique: d0Pz7WzvMAikDBr6BGjygA-1
X-Mimecast-MFC-AGG-ID: d0Pz7WzvMAikDBr6BGjygA_1764335490
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-640dd6e322cso2534244d50.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 05:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764335490; x=1764940290; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
        b=hcyUvvIvuav6RH+u70kqFcSAh3EVr1cbA2yCr6KDZhA+V701MG7dD3bdZoZjEJfvcW
         qghp+0oiRVyV4HcjWac3sQpN6S4i+ix50w6Eon+dq21W+hgPcWmw20v53vBmAkMrw2Ms
         GoOKcZRqfAB3NJIY4eLnDwO0kOyS2RXv8kCWJxC4Ou4JZGIJ6uG5FBQ1ER4TqN53Suqd
         LVdSNBUGjyJ+0S/+s5EU7axwq+Mh2IYs+ta5pJKgT7276mm/Zd2NsrzFekq6626EE5kK
         Kd5vQ7sCLpVlxulSx793TVyXmQe+Pb6uMFgWQPVf4GngQO0fbKGlO1N+CSyYi1+4AobW
         F/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764335490; x=1764940290;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cDb8wvl+/S3cs8WDouA4IaIUDYl/lhw5kT6xFlbeDqo=;
        b=o1y6S9CHg1Dc2xZd83nSvSc/XMueK3MRuYWe9lor6iMTiVGFxIBbY/M6qhB2hWJEa4
         cMHif1+KyV6IFRka3RmeAJkFg1z4NreF7CMR5gHat8CeW3D6WQk+SYBCSb2T50ohCsjw
         Kq7gPp4YUw9hHIhqlx5mjpXstiyHCOUiEa0AKSEKrda5ar/oy+Peat6+XqatBGBj3JmK
         sGhNEtoXbOhntqAY+S1B3xq89zgF26Q1vtq0cI1rugqjvqhJM9WHSnNq7pXb4vDm34ts
         YBfU72Jld9uOpvGD2eFBi2Y3IgrHoAJ+gkKP+uQwA5rGaahW03FInuJMylmOnTmbQd3l
         KjOw==
X-Forwarded-Encrypted: i=1; AJvYcCU17KCiW1PnuNEuhMQhaN6/FCFiiJU4cU0QJVoRM+DJ/0XSAKRuXqxEi6TN66Im5sQQV7/uD67CQMVQJtY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6RDafJVIeoj7wRY/oBVNEjZGb7dT703A42GLuKVg5d25n6u0S
	TxQTzUkBagD9LERSTBAA+mfDRbWgYsaG7pJoCTrk9dPdIXYioWI9nohZMAohbDiFeuo34P2/YSq
	7vAe3pkkl+D98/8835a5Glg7Nzo6QdwJ0pzbQnUIGryljyAIreNX/cukWsLP0/J+GMy86aU+thj
	uIrAOqFc9GeMPEeK73N8Gb+UhCSBnob7YjXiJhCFpA
X-Gm-Gg: ASbGncvYBTnw5yv6nhOUy2fvNFuqqy1SnnbTvolKczmEpcCc8rmFx2A85k88i4/hZqj
	q+Ng9Zcs10GOkStwZ7nTVk0zIcZaksc5Mf1zK8+Nkf7GqE3dtLqAVVYj8K//Depj39kfuQMdlwJ
	IvVDQGlDw973v0T4YglY3W3O59PUGZvrUYchyWNBzHnC3ZkJJoF1r87VAbRQgjAACB
X-Received: by 2002:a05:690e:8d2:b0:63f:bd67:7c52 with SMTP id 956f58d0204a3-64302a48446mr15103916d50.29.1764335490420;
        Fri, 28 Nov 2025 05:11:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpYs6Bqkkw2QMj53nrShI4JIcUgw0aEZxMMPQ2h/FT8I7boFY7Ao7pNuY9j2sTWaBF/Hvop1CT06FKU/ZbYVo=
X-Received: by 2002:a05:690e:8d2:b0:63f:bd67:7c52 with SMTP id
 956f58d0204a3-64302a48446mr15103893d50.29.1764335490100; Fri, 28 Nov 2025
 05:11:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-3-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-3-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 14:11:19 +0100
X-Gm-Features: AWmQ_bmMbDxUx7xf6l9s72idOADcxGPBv_GTFewzDFs5Yo-0xMy2x8K16_Wfsjs
Message-ID: <CAHc6FU43FWMYm2y2b9EvrFzsJdOn55s2QOMxCfRiHKVMVRqQaQ@mail.gmail.com>
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

>
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



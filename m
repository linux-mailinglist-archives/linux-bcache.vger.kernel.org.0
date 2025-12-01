Return-Path: <linux-bcache+bounces-1316-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF65C969E5
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 11:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9FDB8342603
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 10:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4390302CC4;
	Mon,  1 Dec 2025 10:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aLIDVGbZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EVPq57cj"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77553019DC
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 10:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764584568; cv=none; b=KxKweKQ+q7yxRREUlU9YPGZKJWI/f87eLYAvJw19hOkWDek9biCdi3oxaY4ya8XdIkyT/+2UP1VjKRRW3Bg4UA0tz9W0KVnSxG5kKUb4jLBfoft3tdreQPeKwpBF5feParIwGsiX/86QIzwQlF6FTxFR/EQrVWs3KIPpeJVjInE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764584568; c=relaxed/simple;
	bh=GHynjB11VydlixiHXe9VOWVM5ovQLhUkAeX8048lzP8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gHzPNg3FN7S2Ou2Yp/mvNUgZ9AoRSZzTOT0N3mdFEJpXxc+qYWUxaQkAmbnJw3h+fagaPkB6ofPKt8KGPAs0oNgkAEplR0BZ+1HpddMH97fazTqicwhe8/K4aHUA7T8c9KAQtUVVxM8FSnKlUf8j3bxzW5fEa/rZOUjWgpZZxtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aLIDVGbZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EVPq57cj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764584565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iYMXl2leQV6rV+opabS8EJEKmnrywYVBBQqDTRyLKxA=;
	b=aLIDVGbZH8BAoigwNLXgfXcD+WxSqc/jrTmugEz0NKlpY/A5uCmwNIY3OyHl2/57p8dOjQ
	ixiAaOHnSFv2bZyqi/0eW5FKblPibZ2kagWY7X0M0HKLvSaHHdrTz7w6q4Xa4nNfBIIn5h
	InEgGi0gvWD7A/yd1IwV8NitAq8/37E=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554--MhNpPsTNTSkMrDYvaA_JQ-1; Mon, 01 Dec 2025 05:22:44 -0500
X-MC-Unique: -MhNpPsTNTSkMrDYvaA_JQ-1
X-Mimecast-MFC-AGG-ID: -MhNpPsTNTSkMrDYvaA_JQ_1764584564
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-78a712cfae6so53318847b3.3
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 02:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764584564; x=1765189364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYMXl2leQV6rV+opabS8EJEKmnrywYVBBQqDTRyLKxA=;
        b=EVPq57cjizCJDmih777btcD4UD+a6PCkPCczM3+v8RfZ7at5xeYmbtYu3u0eXzuNKj
         a52bL0mll6/7do+N4zu2hiYfiZMFtdHiDVAn4LYOEur8scoDJLfU/kxWaRicW7kqNoCJ
         h4RcnBpqWQEFznnufg5F0H525XAl6tox7V/Hw2MzMAUb1MdojiCKhmnOR7+u8X5iWXIH
         YQ6dxuVTwdpVICJVFgD12Y3tEapTACnlu9xS94ZAHzQzQajnDdiBOIPqPEjLUKWmNhia
         QzYTwGW0JUP349DFTWVN7w1Xwp14WlejhVTi0eDTa50BTUe2lov2wBR6q9uzIW5nNjV+
         lkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764584564; x=1765189364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iYMXl2leQV6rV+opabS8EJEKmnrywYVBBQqDTRyLKxA=;
        b=brKlKYK4QC+soKLBEirPnMYBQjyLnHBVrQzJCp3Hp2c8nXusE85Do7KxPoFTTeMu+4
         xRcMpzn5M+1fW9VadD1OBhh+w/3UL+l4YezpTu/Z6omCiw3tayd8Yx6prd1NsXRWg2Kj
         LSbrlsp4HR8Bfa0mOFn1+HACIeF5F2Hl2/S5kfW4ytHu/kMbWu2eiB/MxqLWx9mRZI71
         XsggbkOn27QFNB5JHvzYN/ATedNelEPO2MH3dtquO9UOh+NjuxIqdnVr/A2oB35wDwY+
         BuuPChDunuBzrjmnNkN8U3aIvBuCfyAkdcv3T9ETMKao0OTJlAi7ORpj4z7c+JSSRwdL
         nMNg==
X-Forwarded-Encrypted: i=1; AJvYcCVH7i9sxsgMvwcWlNt+b9qFv/Ma0wN7XuFmDP+6LhclfRSxC3QMln9o2XwzgkgrwrhONfzHcI0lNOQcf20=@vger.kernel.org
X-Gm-Message-State: AOJu0YwteNlsi0o+EUrRkAqA3aZNjwmr2ll2OSVhu20VngU1rAsFTdvs
	0P8NltnaPivzd9fwDGkbDSGgIO+YKLd3n7Pd1J1Lj718Sch2GmQPx2+vAHJsjrTrw5dcTssST05
	K8ysrn4Nafw/gSYI5yUIJuWMdsgBU/6TIpGbgrtla141c5T63N++XndJ0vf0I+4CLSewynnog+r
	fTjWwWba6rWgzoZlgKNixH0FtCgeKCTXbzpOxztOoU
X-Gm-Gg: ASbGncuFnCfc/pBQvhWmWBpQEFpus7AG+Re0MjMW0Q1PCXi3paSytJRy4rwnoMtUYdq
	XrFirWV60MUFopyPrNXDHwaW5B/cR8zOBq9q2+aLkO+sCmIrb3RgG7vX1tCPP0dcEYmBgJrQziN
	gVPaHci8NKmajZF3Iw7fpeW+W/s3r/wE/dbHmN+hBsgPoNdSLorshFGC8yrottAARa
X-Received: by 2002:a05:690c:6605:b0:786:5620:faf8 with SMTP id 00721157ae682-78a8b54b2ecmr302187947b3.47.1764584563653;
        Mon, 01 Dec 2025 02:22:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGS71cctF98/tpuQ7bluHnJLOFwFlKy0to+fHor5jid4UKgwl/ohRzDnSdvSv1QOzcDeFP7RVMS4MQ6iYFWx04=
X-Received: by 2002:a05:690c:6605:b0:786:5620:faf8 with SMTP id
 00721157ae682-78a8b54b2ecmr302187817b3.47.1764584563288; Mon, 01 Dec 2025
 02:22:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251201090442.2707362-1-zhangshida@kylinos.cn> <20251201090442.2707362-4-zhangshida@kylinos.cn>
In-Reply-To: <20251201090442.2707362-4-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 1 Dec 2025 11:22:32 +0100
X-Gm-Features: AWmQ_bkqho-CvFePzaqDAhJz1XgBGxgdhL1q7VGK-N0FA5fVPePnp-svBeyw9Ns
Message-ID: <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in __bio_chain_endio
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
> Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio.c b/block/bio.c
> index 1b5e4577f4c..097c1cd2054 100644
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

Hmm. I don't think cmpxchg() actually is of any value here: for all
the chained bios, bi_status is initialized to 0, and it is only set
again (to a non-0 value) when a failure occurs. When there are
multiple failures, we only need to make sure that one of those
failures is eventually reported, but for that, a simple assignment is
enough here. The cmpxchg() won't guarantee that a specific error value
will survive; it all still depends on the timing. The cmpxchg() only
makes it look like something special is happening here with respect to
ordering.

> +
>         bio_put(bio);
>         return parent;
>  }
> --
> 2.34.1
>

Thanks,
Andreas



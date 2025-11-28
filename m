Return-Path: <linux-bcache+bounces-1280-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 13834C9209E
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 13:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 864B04E145D
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 12:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2450532B99A;
	Fri, 28 Nov 2025 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJWYU+6u";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WPWcoa9K"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EE43054C1
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 12:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764334696; cv=none; b=ZniIsHvNRNP+YTh1O+UgOlHS3T5YLjJRaFn68iWsyO8rIYkzeJUJyQdGYFgXoOhp1Ml+KOjZG62PU9EiHDq0GbVBEwWcTMgQt44Mbc6mG2RD4A39xUuoeHpV5L4DdKOb7wlmf67gJXt+RqacLzWy60C4oIQve45pQghJYyS35vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764334696; c=relaxed/simple;
	bh=MuFoqSXPuLC7mZdpb7+pS1mI6Pzog4fHqbrI6/r2Fik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jnjMOmKRxnSOzIvGyeTmYjKlzJRAPZ8yAbEp8HOKlGCWZVJUY/sfYiKG+GYQzXlUBztH03MDosDjlgMa1SsZVZhWJMmrYatZFVfP5bjub+wtWQZuRyRFJRpjhX9QTkb8oHvh9kxxQgLOqwgcUbOmxTAILPbc6yDBWmRbmGc5t34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XJWYU+6u; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WPWcoa9K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764334693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
	b=XJWYU+6uD2TNlbVBS1FWSfq/vP8XVoyGeNQVA2MIuhO/W4T8uQBNHQgULFu1ufsrLZrJlY
	lFTx9xa+7BzUc6E0ZglUBSgSsLJ1mcbujDT0vhlLqJzytcH4lFSPmNaTFKhsd58bsoLE/y
	/U0BTvNl50SHvZA1e3jAbGdy75xr+Ms=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-kDXJhdtCNei89J3JgcdvaA-1; Fri, 28 Nov 2025 07:58:11 -0500
X-MC-Unique: kDXJhdtCNei89J3JgcdvaA-1
X-Mimecast-MFC-AGG-ID: kDXJhdtCNei89J3JgcdvaA_1764334691
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-78954aac3e7so25488217b3.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 04:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764334691; x=1764939491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
        b=WPWcoa9K2JrOd9FDfgVkzocSG7sIh/Sb3C9vxn/L1H6MGGrIBNlnWd/ZCJ0pHJL1K2
         Evidr0CTr+HE8pVUeTKfSXLZuQpDrERIbsMyI3sxa+pcP/2M5IulrB1iBVr1uKfEFQ9J
         u9m7Q+NUZkJXnkQwDgWe1CzoD9ZNnQSCVW9UlhQBdeww3TckJu00QyjYwemY8O/dIOre
         gVRG2NC95/0Fx+4M1fKiWpOKaWlSSPRpSXTw25Y75Kab/VTH2P5H/pnhcOwcaRhTRwHM
         jFIC/IySLQO86vdb/ma9VqciHHcNwo55Si+W6YOgi+DZfOxt6HMmwRwnC+4jmTRAYEQI
         UdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764334691; x=1764939491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nNammxq+ggHJRHkPcyBw0qZgJjTAIfnPB/5V2CCXd5w=;
        b=BqYbTjsaKg46Yz+6gh3ezqu8HUE3AZC3e1FK63j07tMuo7idra7/+C7CwwxCDaW5cc
         Dkg5EvC4dommATMOgU0qcwoHoH5A48npF7LNbmW2Ewu8ua2x6rkcn0wjtLqARdl8rBY5
         9NDbjf2Y4n4/WnOdEO3raN64e9hgyaeA2NbH9V+KvgDVaUB23Cv7PTtei/espEiba9KW
         pvWytMDlXm3FrkoM5sDolKOD+iknYipH1gMujwM81H7Q4Bhhp4ML+nRe7easqrPfz33J
         i7ommYhIAeqZACoQL6YJO7CqGYmkedotb0xySQ+1aGVdfra/3gdPkkmxm5hbvaLRRhmr
         96sg==
X-Forwarded-Encrypted: i=1; AJvYcCXXyn4h7kHMIM1CfMAaMl7XMk1ymYtSRADExBXb9Cwaj6x5Yw1JrwgQrINGmHzg0XeaVJWHclijVpLeQpg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxKf2xkxjIJjjR9CfjmS5meOgGKCUUtnqIjjHHe0a0EY6zN3tN
	u1FCT25OTJvdF5L2YZsntEKjasZygXb10xeOFv5S5HhY43ZqlrGHA6SPrTHr+0EjuGYVRQsd/Cx
	kvqTG64FjhOZGV94QkP2mko8lcerB+Oij5SLlhKJRYLfPZH30rI9MYT2uDLp+3Y6J7TJn8MF6VX
	L7SH90rbd3itXHO/IZyGD37yNPPCph9JB3YMcq1Wjv
X-Gm-Gg: ASbGncsJ3ypS7OcFuJe731AgFdLjA8GdaY7rDCvOi3HJTskfn4c6nG+Se/uRczp3J0L
	H7mxmJ4cJsfWfeKfJK3WekzJ/X01iAkbw+dWskrnMbaEGtZX3THs3qAdLJzB6sNHAXeMamjlDBP
	OfIZR7MP61O8Sr3qF/HkfstltZD91y1K2+fZAnXtnBhfJC/djiqWYp2vBHRdGni7Jl
X-Received: by 2002:a05:690c:4c12:b0:786:68da:26d6 with SMTP id 00721157ae682-78a8b47f539mr225392487b3.2.1764334691005;
        Fri, 28 Nov 2025 04:58:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6o2vx3XDXGg+LlkIovRC1qPDpHivJwIyySPFZW+LOu2PT9QpULnJt3ZozP3PJjgQPuJtToIp2pCOkRf4ONwA=
X-Received: by 2002:a05:690c:4c12:b0:786:68da:26d6 with SMTP id
 00721157ae682-78a8b47f539mr225392307b3.2.1764334690627; Fri, 28 Nov 2025
 04:58:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-5-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-5-zhangshida@kylinos.cn>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 28 Nov 2025 13:57:59 +0100
X-Gm-Features: AWmQ_bkpqINzOqnBww77x7L-xnpoIyN1fhsiEmRMn1madN6s7Ak0j6O_sI0bIl0
Message-ID: <CAHc6FU6dmK1udCgj9vMj1ew-4+bZOK7BA47kyEgONEwGg42veg@mail.gmail.com>
Subject: Re: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, siangkao@linux.alibaba.com, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 28, 2025 at 9:33=E2=80=AFAM zhangshida <starzhangzsd@gmail.com>=
 wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Now that all potential callers of bio_chain_endio have been
> eliminated, completely prohibit any future calls to this function.
>
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/block/bio.c b/block/bio.c
> index aa43435c15f..2473a2c0d2f 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *bio=
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
> +       BUG_ON(1);

The below call is dead code and should be removed. With that, nothing
remains of the first patch in this queue ("block: fix incorrect logic
in bio_chain_endio") and that patch can be dropped.

>         bio_endio(bio);
>  }
>
> --
> 2.34.1
>

Thanks,
Andreas



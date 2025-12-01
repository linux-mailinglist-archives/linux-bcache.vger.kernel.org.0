Return-Path: <linux-bcache+bounces-1309-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE5BC96277
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 09:30:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5F6F43420E2
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 08:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45782F9DA1;
	Mon,  1 Dec 2025 08:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3Qh7cAB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6F22F7AA8
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 08:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764577820; cv=none; b=Mdxcdtr0k0GjYetjZQ0+IP1FnWdQstckQw9LqmzacEJiYWrFEh5CJUHcKv3FecJE732cLMpV8ddCDxgHOyNKamXAbuNm0ZfF/90Tam5p1NcUIc59w/RUZOHtMTOaaN66shriw5Yunl2/mJwt1fRxuz6qZuL1gPNbBsO9h2GnSDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764577820; c=relaxed/simple;
	bh=SwVqI6MJM5Lrg97Ok9vpLMdiyd5GgCZUgGLi9eNg6mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LdDxAe7nxKGmLB7xWHonxgfDS1CRx+rUbwgJDLJ4IB/1YwQpKAUVQMuI4lHQnnAaJ1u+Hgr97UsYCeoQi6WOey/I0g/f8BcZ06exlMHnpEZEusHWC1n/567u5EXHUALs7EN4erjG5Lfu1ISQ06G2eK1TMpdDSk+ZmEA/8bm0tRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T3Qh7cAB; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee05b2b1beso33965111cf.2
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 00:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764577816; x=1765182616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2eJc3g3YpMCQbgaI10ZHeYIFEHAk4BHGKD03PpLocf4=;
        b=T3Qh7cAB45/DpmST+9oRFHxmslGeoYmVjzx/YUVq+LY/QMEUPNRhzetvVDrPMljeQX
         UpilVG/cNZP8C1HoEA9NHWW8t5VzYFMLOzpZHnfWeCIT5plKCPYKS3ZBcvOwrVw/620I
         HWu9Wb8faSnEL+VY9zGXkeJuXiz5uS/j+FHnDPYDT1q4sG2dQVC4HSqGnSoRoEZ9R1P6
         jI4Qo73InDRtLjuv0hi8RWak9TUQwSxde+ExHdwgQ3vJbWsBBOA4nWlzFQ5SX/OXMc4b
         v+0lYSjX+faFk3s86bM1VWKzadoIlKGZ+dGsFhNDY6eY6M5esYUxdVA3ZXGeSP7WtCcy
         yPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764577816; x=1765182616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2eJc3g3YpMCQbgaI10ZHeYIFEHAk4BHGKD03PpLocf4=;
        b=dqdPw70UZuAylP7z8QRWq9BMpgIKoxMKVHA66d1uzkh99X2kbwjJBrvQk5qi/ItYzi
         BlBODMUu/px5pEsJ4+HQVf3zD/2gsiowN5sR6SmHOBOIWQM0pcyoRxiVBY3WJyVeN0Jg
         h9CkgzTPsrVK9Ws8flXsvYC22Bc79bUF3zhgsGjz3LfDHxnN0l3IIrNMAu2X0ktVc0YP
         tLY9edOBu45IagZmbb+CpdXUY+C7SYWVl9JlNM5wWRMD1cVdKpYmsSsLE37ZjYwCqe4V
         wdjWg6b5yv7+3PkF9jKTDaZQr2t9mlOsNhJlWSSLx8DBwsUVcB2qkpbrzgOqMrpR5tYh
         V1pA==
X-Forwarded-Encrypted: i=1; AJvYcCUtiGtAAgxi+nX1IaLpuO6Fco1gJl+guydaLdnkIk40nGlDH1pr2qxMKExEN7ihkpo0UtIt7H45IA6+/fg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKZWL8ePbGWB6MnLFXXlFnVABqKvY++053/OwGqis+AlS72RDF
	Wg7Vx3EWSUVjcI8lZGYQGCZkNzWnMKQV+dMQQj/fML8FLgfhMUsLKk94A3WxRhdl91hwJ6tGK6A
	WKPSrBBzQqE4QSV0dS1nVsB+uQh9D2hw=
X-Gm-Gg: ASbGncvCxetdMiqq7V0VHx4VCKl/4aIeg6Eqfa61m1Gc3OOUIRO/jk7EGKhbzNRelx4
	Q7eco7Q11GHI1Y5Bo1MngxnfWJ+efV8m8t3+iHAGMDrNQEXrwMqr3sHGRa0mrAo4emV7uMGcMPE
	Oa63OwfiG3kFIPfKIlPYQ86yGFMg5OKeCDKMcjF5Oag+hg2isnAiCLP/63DpQHhjXo49jP1Hof/
	QX/UV3eugi57BmN2EjdzN8D1QssAr6EXsEGW+t1DH2twpnFQLhMcd2X8N4pLm45Lve6p8c=
X-Google-Smtp-Source: AGHT+IHsCmYuVPkQVfU+yWs4legJ9LdKct4F60FxyJiLbura9Wp1LF6O9gYr9xGvWJ06vP7t0LTxtkuDR8IlXcjYyW0=
X-Received: by 2002:a05:622a:392:b0:4ee:2bfb:1658 with SMTP id
 d75a77b69052e-4ee588e099cmr550604311cf.45.1764577816018; Mon, 01 Dec 2025
 00:30:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-2-zhangshida@kylinos.cn> <DFAC6F10-B224-4524-9D8F-506B5312A2E8@coly.li>
In-Reply-To: <DFAC6F10-B224-4524-9D8F-506B5312A2E8@coly.li>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Mon, 1 Dec 2025 16:29:40 +0800
X-Gm-Features: AWmQ_bnNbz0I6L6p96dlX3gePB04hX8D_DO2J9xuy2-homPgSXL859tuVJ_3RFk
Message-ID: <CANubcdWbKoC3RgPz1Eb=auxfnq-4_tMoqWiRaZiPcZUxNHYwVQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] md: bcache: fix improper use of bi_end_io
To: Coly Li <colyli@fnnas.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com, 
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com, csander@purestorage.com, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Coly Li <colyli@fnnas.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=881=E6=97=A5=E5=
=91=A8=E4=B8=80 13:45=E5=86=99=E9=81=93=EF=BC=9A
>
> > 2025=E5=B9=B411=E6=9C=8829=E6=97=A5 17:01=EF=BC=8Czhangshida <starzhang=
zsd@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Don't call bio->bi_end_io() directly. Use the bio_endio() helper
> > function instead, which handles completion more safely and uniformly.
> >
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> > drivers/md/bcache/request.c | 6 +++---
> > 1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index af345dc6fde..82fdea7dea7 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
>
> [snipped]
>
> The patch is good. Please modify the patch subject to:  bcache: fix impro=
per use of bi_end_io
>
> You may directly send the refined version to linux-bcache mailing list, I=
 will take it.
>

Thank you. This has now been taken care of.

Thanks,
Shida

> Thanks.
>
> Coly Li


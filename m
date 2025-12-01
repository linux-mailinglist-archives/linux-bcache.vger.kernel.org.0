Return-Path: <linux-bcache+bounces-1317-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6B7C96AC0
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 11:33:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9EA80344DCC
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 10:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F5B303A37;
	Mon,  1 Dec 2025 10:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DKwBQ+kx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fMxYKy3c"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00F8303A06
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 10:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764585093; cv=none; b=eMlMAjUR1KE7+b/ZRw2vu+CPqVSx6oQ4I3+lKexhjdV6UWv4CNVknGRl6T+LwSjJTZVJW0M/bPS24gzHlEsIA7gNKxWUOQR00LgkwApxHfrm+NhSdb1rZHeAP4H1uannaS99KZxYoWW8zslYZWP0sQ8Y9plDp43NxiQcMw3onug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764585093; c=relaxed/simple;
	bh=oAKELPmBA2BqrK0o9QFtBWPRSKg+tCcCo1sXueOdRDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ib3Lryb7G5sMwPUbEEhypfyNTWmcoCokg4da2n2NPzvw6kioS2OQNga9Lo8ogiG4nYMkFTcXk1PRZhTw0ZcDbmYBswzVXicuwxlPU+yiuY3i5x+2fugz/OOLoWL7KJB99fPiRH+82PUl5h0cqizyeRTMLzed8+uEyPm5HrLRGH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DKwBQ+kx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fMxYKy3c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764585090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XepCzKXSZv6JjslqxB2za4xngOadSy78tcQeBtMRexk=;
	b=DKwBQ+kxeZbiHRbCMiLmH1/AsEZKyLuCzzWwfc+PkGVIunWLEIWTCTNOTzn3vp+PM2Zf5o
	Fly9NEuBqYiJ/Be4lPNam2lPcT4dQWx6K5eY+sBsBagCCtxYmwAFqTEHehyFY3U1v+YsEo
	tH18tzg0CNwbuq9Rx42aZInd1xWlqa0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-6k1ZS2LYNo60sAstPTefmg-1; Mon, 01 Dec 2025 05:31:28 -0500
X-MC-Unique: 6k1ZS2LYNo60sAstPTefmg-1
X-Mimecast-MFC-AGG-ID: 6k1ZS2LYNo60sAstPTefmg_1764585088
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-78aa57a8157so53158977b3.0
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 02:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764585088; x=1765189888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XepCzKXSZv6JjslqxB2za4xngOadSy78tcQeBtMRexk=;
        b=fMxYKy3cJ4tark0sL7K9JtbCqEZ7KVjErUVli+G0PvJvDU606y5THy+ZZmWTznga9J
         CAeaT/xHvrJjzjYrEdRjOU25DKMJH/a/LW+JTEDL8Aahv/E7trigGSfB5NBwMtdny5Ul
         wDJ6ypjmjxGwX6ARTCg36NFxz4kSir+yWtLkGBWqSS9ahQS988VYsrgEuSScWeEHvSGJ
         GyaLbTv7DnoOBzLxPHlgoUGJ+7Nj9Xko4uhAoUV6Uoq5z6r+kkjYserZ7v/SY9UTONsa
         fbrBvjAK7FtKcoamaocUBJ2ZMOyb/J78cYWbjMFQQO6XuXD9r7hrY9Td9m9QjhARqyUs
         vPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764585088; x=1765189888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XepCzKXSZv6JjslqxB2za4xngOadSy78tcQeBtMRexk=;
        b=DZ18fjciAJ8ErOkohZCRB/HFvVH829I9/FLVWrpj4XsLWPJn9Mq4g+CQ0H7KWMcevc
         V7ghdsntwg7JoTOv+6MjGD40G+u9kPbEVtxcFYup0TxIj0dX8x49/EF6UvQQCn5/LreQ
         NeAQPFAquHXqhLftbEyF936Tfk3P+xHi/13aArm/dj/ONt+cF1Rk664M6KvRzEJz3TDM
         OGZ+/V51ia12uoxLGwR5taGPg9IyiFniCtfX5igtgQ5hkI3Gnq1HQdQ6WpzrE4MqjD5i
         PYli+V2vP8WPNajAwzFSI5mcswwGzdAU2koVrn/jMAp5H3fvAEViPFeo2a0jT1R+r7et
         qKhA==
X-Forwarded-Encrypted: i=1; AJvYcCX0O36Rc6AALIvBUFTer/d4TcbJsNqIlR77Fr+IpxHMKrM478+b/ic55jsCYloqsUngxU3ird2xHGjEcck=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYUCCwe7jcTx8y8+X5rUl3eg3TXTGGzDe/Wgzx8QHYitZj7i3g
	Tu1o+jo93qi40VTN1QyQilqZKPalQ7xE2BNIpJd+N0vqAUIdiBqZw7gztO5SYuhxYzNi4nfcky8
	NFInFtCQOClpfMTlE0HeZ8R5waeeqjMn4m7yVVGOtwy8ArTASUiL3L2Sz1KogehqMAd9YhdMkUq
	qyb92AP/eqnDkiIGu+JWJBNosItT9RZjm3etgshRC4
X-Gm-Gg: ASbGnct1+IFk5C4bKQAALByYMrsRmJZsDqkQTv9DR7hoPU1g/m4Av6dr4ervSthbE1P
	m7JOyUWmCgcRDxxFpivATsBvtzPYE7lw34jHCbEB5kpvhnQYSiq80gOJMJ1G6FLwVgwerN81J22
	CIQA/iPhuYBd8CwNBPiKGctevYGPv/OYqPhg71GVXpod7ywpwDSeSfrZZ86loxofDt
X-Received: by 2002:a05:690c:6f8e:b0:77f:a301:4634 with SMTP id 00721157ae682-78ab6f19dbemr204012207b3.45.1764585088399;
        Mon, 01 Dec 2025 02:31:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHv5zzmMokroNvK6hxRqePUK2sUy1kyOakdwZXoQ77gSpCZtxQfALMHCo45aGmJsVIK/6txSFE4cjS1pCWEh08=
X-Received: by 2002:a05:690c:6f8e:b0:77f:a301:4634 with SMTP id
 00721157ae682-78ab6f19dbemr204012007b3.45.1764585088053; Mon, 01 Dec 2025
 02:31:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
In-Reply-To: <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 1 Dec 2025 11:31:17 +0100
X-Gm-Features: AWmQ_bnf2BodBLtXxgPiuMZc2dFAC9eikQedB20yLRtD3dfyefefH-ZDvfFzYn8
Message-ID: <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail.c=
om> wrote:
> zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=
=E6=97=A5=E5=91=A8=E4=BA=94 16:33=E5=86=99=E9=81=93=EF=BC=9A
> >
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Replace duplicate bio chaining logic with the common
> > bio_chain_and_submit helper function.
> >
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  fs/gfs2/lops.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
> > index 9c8c305a75c..0073fd7c454 100644
> > --- a/fs/gfs2/lops.c
> > +++ b/fs/gfs2/lops.c
> > @@ -487,8 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev,=
 unsigned int nr_iovecs)
> >         new =3D bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_N=
OIO);
> >         bio_clone_blkg_association(new, prev);
> >         new->bi_iter.bi_sector =3D bio_end_sector(prev);
> > -       bio_chain(new, prev);
> > -       submit_bio(prev);
> > +       bio_chain_and_submit(prev, new);
>
> This one should also be dropped because the 'prev' and 'new' are in
> the wrong order.

Ouch. Thanks for pointing this out.

> Thanks,
> Shida
>
> >         return new;
> >  }
> >
> > --
> > 2.34.1
> >
>

Andreas



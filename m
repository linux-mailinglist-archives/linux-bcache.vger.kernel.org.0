Return-Path: <linux-bcache+bounces-1337-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76DF1CA6AF8
	for <lists+linux-bcache@lfdr.de>; Fri, 05 Dec 2025 09:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E43BC32BB6A0
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Dec 2025 08:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA1E34A3D8;
	Fri,  5 Dec 2025 07:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CIUg0V2J"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FA73043D5
	for <linux-bcache@vger.kernel.org>; Fri,  5 Dec 2025 07:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920780; cv=none; b=JYTSfoDZyAXClfOxgdjzLI0kFTxR2fkGGXH7KtjTg4iXvg+iS6hxMTwnTJf71s+aqXw+jnJSDlU097VAGI+e3XZbcaKZiSdpJ8aJDgVBWdqgleOVbISPRKEW5F6azx/yOAlldD62VNc5MEHaSCVFj/MMjrP24mrXL4RkTlA5dO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920780; c=relaxed/simple;
	bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzK16FO7d7bfy56Kuo78gH7SkZAx7eVNsUQoPG/4bWN4YHoUmXcT+fee4D9rwk6dB3xCngTCUmPTREo7aCfwD+KSrtOnniX6N5ACPUvINelCCBx+A5HTXooX8j5NGVkypni9uDDwHK0I22L8bTY2MtslusfN7KgjZRctx350j+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CIUg0V2J; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ed75832448so24707001cf.2
        for <linux-bcache@vger.kernel.org>; Thu, 04 Dec 2025 23:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764920762; x=1765525562; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
        b=CIUg0V2JCjbHzU6ZgNrXL+2mqVIMDpb1IdmtbxtfnZytV22IH7UwGHwoviMMW/F+5F
         mvWYMXJ8iYXTuTkp17az4Tbr3aOdT/tAm0wBsJ71KFdrlf3H6u8UdDzGENzaEIT2J4jQ
         cZvELfdybc8PUSZO+i4HqoEJ/VeNRIRAPdjuizdDzp3BNuvnw0Zv0S/lFHCIywOWnpUu
         uSraOQuqQvStJBboIXJeewQR0mPOs1mkVlXAu+QvtbgfVY2QYsD1xkg+cqvdTc1ZEp9Q
         w2HaXk9ADarjsh1zIszaafX9d35TLjLSbsw3ynNDNJHN9Ej8SU1pn95ZpfPt1mv/XW1m
         3+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764920762; x=1765525562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
        b=o8yXqOWgGuzvcuUJy/E7cqFed8+p33d6XtyT75qQQIjkDXyEhva8drKAc5M6Lg/7eC
         tSJs1qWiKdyISeMkanlCeJ04762h2HHwI3oP9V7+iVF/X/EscyW3LhQJMtdyjp5VvAD+
         89YzttHiFNp++KfsepAPvIasdF60dS/lcRADdcJUn5lYmYY0mPEUklO+CsnTL9rk/jFz
         XvBnhFGv0TFepdExawVMwQPnAtekV5w9GMvIWhMqpjxOOzt9QEAh4jIofR9z9tj4KGhf
         xV38nOiMuJTHo6erSmD+SPYCmSmxlEMPRQtg0MZ/ixO68rzP0/uonkZQz4azB9xKYCxY
         i+ww==
X-Forwarded-Encrypted: i=1; AJvYcCUBZX79x3awRXQFrjlPBDcCvvvgKTeB9i1fLNeomUMXCl7rU0BkKAu5mQY+hVj1JHzoJcak9iGgIi5/6Gg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ6oIgNLbV/QpEdWH7ARmiLBsDbZV80dNDcNHyQOVtyNvMWFOK
	OfehRA0LTlnjeCj5prVuDhBgIhk30SgOrEjBlLAQ0NV1nnhuLG3gdWguf6d6FsUt7eI34UI4wq3
	DTpQaqc/kBfu0Smm27IGfd+xtnPIjjHk=
X-Gm-Gg: ASbGncvsNFiKYiW3N8fNq9PGEnCWf9MNIhWAkQSOIn/NmV2f3d97MQVPhUvAY3rsow0
	91MvnmKs8fkzm5WojlVPD0EgQ/rVEdTZ1Y5vAVdPtQKxzDDakxbZwG1DTRhRJuR++Wa75RSQyeZ
	khuHYCqwLjy37tShPLvLs9kU1IbDkwB6t7lO/njAjdcFxqwscJz6F9aI7nmR9X0FHfCCAWf/hNU
	U7t8dW5ktHre6h0QSNXupaaD0Vs3peLEswYjAUdy/+wYhGa+nM7GtTf8iOGpqp9A5sjNAn9vdve
	v5OtNA==
X-Google-Smtp-Source: AGHT+IGno4YCEk34HtoQAUN6GrFl01k867Kp7tydcNcb8xmuE9aFUTESOSk0G3T3M/y8W6zfCnRmuyMISYmpdGJqEvo=
X-Received: by 2002:a05:622a:5c6:b0:4ed:2164:5018 with SMTP id
 d75a77b69052e-4f01770bf40mr116570781cf.80.1764920762038; Thu, 04 Dec 2025
 23:46:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com> <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
In-Reply-To: <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 5 Dec 2025 15:45:25 +0800
X-Gm-Features: AWmQ_bnqjBxuauDVJJL96EAzZiNCKi7bmfbcq5aA841m6f5U8UUuamAPefRv5L8
Message-ID: <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=88=
4=E6=97=A5=E5=91=A8=E5=9B=9B 17:37=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@red=
hat.com> wrote:
> > On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@gma=
il.com> wrote:
> > > This one should also be dropped because the 'prev' and 'new' are in
> > > the wrong order.
> >
> > Ouch. Thanks for pointing this out.
>
> Linus has merged the fix for this bug now, so this patch can be
> updated / re-added.
>

Thank you for the update. I'm not clear on what specifically has been
merged or how to verify it.
Could you please clarify which fix was merged, and if I should now
resubmit the cleanup patches?

Thanks,
Shida

> Thanks,
> Andreas
>


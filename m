Return-Path: <linux-bcache+bounces-1338-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F21F9CA771B
	for <lists+linux-bcache@lfdr.de>; Fri, 05 Dec 2025 12:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F4EE3243AC5
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Dec 2025 08:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDD83128CD;
	Fri,  5 Dec 2025 08:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xlnz3tOy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCUaHuew"
X-Original-To: linux-bcache@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C484D311C20
	for <linux-bcache@vger.kernel.org>; Fri,  5 Dec 2025 08:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764925031; cv=none; b=BnRd93Ku7peQ2moe90rqJm8csUvyoz7Z1TgApUldJSI5/aiiRsXtBz5NPjRULQlSBF4I9AXApPFxW4mXI9PkVRmUqcj6YnEq/y77/mM1itVgFMGcy9nUSWQncxj8lGyLyJHcvTDGvx+ZcTMCUnQ0px13ym/Ymqf6K2JT1j0CJQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764925031; c=relaxed/simple;
	bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n/c6ViIBBFNnXO8FKldD8ui6t9gMBtQLJiBLpg9BhWCeM+WxyIYjFsDe4HuYXzM+hsdLtP2/LLlRyXPN5FZHRLMWCvXyxDTOMBokyHi6bXnm1QWb0nv9CH0ksb5Fau1rxP9PDXAkyu8aTG0xkD5E6zdHn4e9A0nujUZO3SYgoAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xlnz3tOy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCUaHuew; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764925022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
	b=Xlnz3tOyAvnzTEu5P5xXFQGUu8B4tZ+K3kVdrmQIrDEjMbzfP+WZ62DQRlKWZ8k9jgt13A
	GBW/4PrNYEaaS8eaA95OMcWzNb4bnB9Nwrd7gegUFJgQsh3mcB9kUT5Cmdh9j9z0MzdgB9
	8gR0B9N1u/1ZU83koUKjuA/d2oxwSxw=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-Kag1ekvANb6_bXMu_etMJg-1; Fri, 05 Dec 2025 03:55:51 -0500
X-MC-Unique: Kag1ekvANb6_bXMu_etMJg-1
X-Mimecast-MFC-AGG-ID: Kag1ekvANb6_bXMu_etMJg_1764924951
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-787e19a09c3so34090737b3.1
        for <linux-bcache@vger.kernel.org>; Fri, 05 Dec 2025 00:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764924951; x=1765529751; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
        b=FCUaHuewzJr0ItO7Uo5L86Nrwo8aqenxBPuUb4bOmmHTFVJq4vye7IGq70AzxJQPQJ
         MHpqO0Zv+YzfSv64JvUgkD68IQ4Lkc3wos/W+YYRiElerTTNXTrXoq1Rr4p+jAYZfsbN
         JreJtV1czwU96ygq6Q3u1xVnllUdIFs5eTJ3oPH4q/Gl1S2E39PLAL7pqzwTE7QeJN3F
         kOSWg7rR2muJhZo3iZDiEnVMnXG5DxGVVep0O/oH1ge1SlzgsDukPDMk7dO98luRVhk3
         3mS9L5Vt/N5sLgAR7b6aKv45HjlhCO9tzMcrE4fkXJyB6ntno3MmvwVqbPvQSmo+eGT9
         jLag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764924951; x=1765529751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kI/BmZknfJEnMAoux6UNqNWZZavATt2Ci9CEQ2NFztc=;
        b=VBkJvO0CPglyTbfcaJysZ/ZBJXSTR02cBTNzD+t73GW+NBPbm4JaREuQNhvKUwWpw7
         pF97VeISjJSLZjuNckDmi02rnnzriK0aoCNVjjhqhksEZvSeZZx218KCFb3Q083swUt1
         ahfw2pOnolhrW6ZwcSoTqVJ/J9zLc5gGAFjvAZGqJoqwruub2zncVIPnZT8D/IEloxvf
         EEFNRa3+ZswdKJ4RGc/FimaLZCSlZsZn2Fuj2fbefG3U2QtC5N6WXf6/iPwp2+2DoLrA
         9iRHw9oYrPOmp9UCdTrtl8Wvl+axiTsgLfLMcVmDp8unOP0LiLdVK/rPZUgYlJKorvJS
         Hayw==
X-Forwarded-Encrypted: i=1; AJvYcCXmRXkNxTDdgPO+jp2SRKVsHnfmIODwn3bl6pz8iNbqmFVA2+s1ZDjLPY4pEgj5DvK6gxPEkH/JwEvdr18=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLl0vUP3Z0cFrCIc4wm5Tdv/24H9oAAKu4yaIvYvGge003Xvru
	hM1mSA/G+4JgD7UVjGkI3x+WpWgBRh/yOwntEMadVVZbaHeOJnt8WDaOIpst4zUpRqt4Azy6c0v
	XC95IWM9O6NN6zvxlIOBEhwaDxMaVQMhO6m9awBja1ZAi2yb6j0GUe7IMzpzF7fnJ3W5MYDtKbv
	8q1hNy8FmVmIGlT8ASuVM2qeqheIh9NNJ4/5Fqkw8cqBX8i7IwDq0=
X-Gm-Gg: ASbGncvQ9Lko6CL7rVHZtIgolGO382pu8e0pzLl/ZKSt1UqcIUXAi0AQU6HT4n86cV/
	MOnF9KlH92WCnybTezlBKhaIGZunc1C1CCsieBrTz/9hd6anXeCSKJBZN7NqdX3t4JVvRGdX9zN
	yxf+T0TytQaddYl1n8WQ4MHimMinile360oaU/TMvU+rah8Jhla4420xiBshd1uytV
X-Received: by 2002:a05:690e:11c7:b0:63f:a876:ae58 with SMTP id 956f58d0204a3-6443d6e683bmr5035625d50.9.1764924951054;
        Fri, 05 Dec 2025 00:55:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH06t5ScTL3/41cXQ9/KNdNBUKke6bRZRDIIsDOJI/s90MmtU+OELXMsXOy8CKQ41Y5BIrK12B8cMtyqGUq3aU=
X-Received: by 2002:a05:690e:11c7:b0:63f:a876:ae58 with SMTP id
 956f58d0204a3-6443d6e683bmr5035612d50.9.1764924950709; Fri, 05 Dec 2025
 00:55:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
 <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com> <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
In-Reply-To: <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 5 Dec 2025 09:55:39 +0100
X-Gm-Features: AWmQ_bn5nYIfNoOVXdPvu9TIQvwvBK4TRvGDwrtrakvgOSxNJSsbjWkIZFSXMho
Message-ID: <CAHc6FU4G+5QnSgXoMN726DOTF9R-d88-CrfYMof0kME6P_o-7w@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 8:46=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail.co=
m> wrote:
> Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=
=884=E6=97=A5=E5=91=A8=E5=9B=9B 17:37=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@r=
edhat.com> wrote:
> > > On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@g=
mail.com> wrote:
> > > > This one should also be dropped because the 'prev' and 'new' are in
> > > > the wrong order.
> > >
> > > Ouch. Thanks for pointing this out.
> >
> > Linus has merged the fix for this bug now, so this patch can be
> > updated / re-added.
> >
>
> Thank you for the update. I'm not clear on what specifically has been
> merged or how to verify it.
> Could you please clarify which fix was merged,

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D8a157e0a0aa5
"gfs2: Fix use of bio_chain"


> and if I should now resubmit the cleanup patches?
>
> Thanks,
> Shida
>
> > Thanks,
> > Andreas
> >
>



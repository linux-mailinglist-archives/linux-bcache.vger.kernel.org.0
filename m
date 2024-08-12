Return-Path: <linux-bcache+bounces-713-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D0D5D94E540
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Aug 2024 04:54:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76C6A1F21274
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Aug 2024 02:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20B154759;
	Mon, 12 Aug 2024 02:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="qMDDRKIO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD54013A242
	for <linux-bcache@vger.kernel.org>; Mon, 12 Aug 2024 02:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723431241; cv=none; b=rcDTyEIJr10MGKfVeuPm+xYHEQvLKEbSHH4t6kn/17uRmMGEGWYlkXQJ3Qbm7+blfeD8WaufoaU7JvqkDfVS2YVd2yb9ntfZqCNHxorZEz4W4hmAknAXOPd8p4J5kw7aD8QPt0p88uQRQNSXGTh7etaU7SHo1eGNcVFA7ofUvN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723431241; c=relaxed/simple;
	bh=yDkoSDfreqlRK6bv5skP2d8EULTtMbDZA4WwBNmjEh4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aSA1wLxEFsEQ6UsXfqziyUfq7CfK/BzNWxrszWsawWruTgPG4x0ajtX5WXbE2TOLYdyEjihz4XYgOhN+z3Jk+4YHvC1eS7LIQAdahhA5DNJ6EqeSA3F+vLcHG68ApX2E6W+5desfGxkDi27UiIP25ZbVITfxUf6s0zMP9Kkvy38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=qMDDRKIO; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0B3753F1EF
	for <linux-bcache@vger.kernel.org>; Mon, 12 Aug 2024 02:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1723431231;
	bh=yDkoSDfreqlRK6bv5skP2d8EULTtMbDZA4WwBNmjEh4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=qMDDRKIOv4HAGSZ7i8g9ZsTJ7eao9w5UdYdJbWpZXAgOxNBmCdOIO9AwrlYXEIBMV
	 TDvG9HkF0P0Tnl8SUhHC3TwSSZLOl1B4fREAr273bixV8aHjfUMd49qvk6dY0a8aOT
	 JiKqT+YEUZ2rSVl2zK02DjnAVlOYZQL6MnxtZHqJkMxUcCNrH+2q40qI6MGF0PAPiJ
	 vif3uHfmXDou34ZDXN00BQl890p7H6z4QGHeMHqYCrqfy9sAOaNU3zMe7oxKSUJZ/x
	 vlmA6e/DQX1vThUG45w8OJ9N9hXNxOmnrIY63NYda5ZHPuUCuZwoS5HuW/Mi6GOMKt
	 tKUENhvUR1YeA==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a7bcaa94892so312469866b.0
        for <linux-bcache@vger.kernel.org>; Sun, 11 Aug 2024 19:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723431230; x=1724036030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDkoSDfreqlRK6bv5skP2d8EULTtMbDZA4WwBNmjEh4=;
        b=Gk+t93uLYN1Zzl0vDf+mHe42le+d+E5uluBZbWX0+PUX6zmrNsZQV6loP7H1ntbt7F
         P1gclPkIz9I0Lrx2e2ICJ/6a1uljKGA28/JlIEgp+ijQQ48rs9XLwnyCkSNx/leXQZDq
         nNh9EGp49P1ioMV6lYATBM9ZFCPhFKpcghuQM02EsjigdSgKUStfrt8EkDskOOxkciyM
         bpV2je6kJbgMd+5S7jCO4SB92outBTx2l/xeWfeXCEVbn7JTOdKXgCgrg4QWOsMQoXiU
         qveoaTj1xH+az+nYUBH6aeZfm8LgWhU1VvV2rwQ4HX7zLZNqDjVF4bjcDpLcAbD3/BUd
         F4xA==
X-Gm-Message-State: AOJu0YxymEsUWKR1JTPeQETbeZ4tvhP7Rfz3UGRX2kOAMIvLHS6cD9ME
	qQLvDwy+SvPx6UYSepW3jRSA56yFhyo3XmvFy7kcCgcRzwmC+0Iw8cMS1N5pWeqVzE8Y8xk+hkh
	dvpyGfr7TbwL/7HFqwyCL0i2KzzBlRlAbCoYPBMR0QHWPndJdjOqKK+zxHt0JgMfuKVAP3ej52l
	RviOYKNz5KvYyAqZrp0tqU3HPs2tNYBMGDC/PIWmMHuh0ABGfjf/00JrA3w1fYMvA=
X-Received: by 2002:a17:907:6d28:b0:a7d:a031:7bad with SMTP id a640c23a62f3a-a80aa5a500emr636097666b.16.1723431230279;
        Sun, 11 Aug 2024 19:53:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHqLPQVVkDUCWXMhq7xo2/t9jJ1BpFXSgL4n1UG6Sa30Vg6sXpNzJG+t1pP+XwzMDmA2KnNbOFBykeK5+iYJIY=
X-Received: by 2002:a17:907:6d28:b0:a7d:a031:7bad with SMTP id
 a640c23a62f3a-a80aa5a500emr636096566b.16.1723431229381; Sun, 11 Aug 2024
 19:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
 <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de>
In-Reply-To: <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de>
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Sun, 11 Aug 2024 19:54:14 -0700
Message-ID: <CAG2GFaFQBkzhOJZedHPVdZLYRvU_XMs4MZ-4KKPkDUfbU9AfVg@mail.gmail.com>
Subject: Re: multipath'd bcache device
To: Coly Li <colyli@suse.de>
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the reply Coly.

I've been able to reproduce this in Ubuntu Noble and Oracular (24.04
&& 24.10). It should be an issue in Jammy but haven't tested that yet.
The current kernel used in Oracular is 6.8.0-31.31 and the current
kernel used in Noble is 6.8.0-40.40.

Unfortunately you need an account to access pastebin. I can copy that
information elsewhere for you if that would be helpful, but I can also
just gather any extra information you may want from my testbed.

I also have some steps in the bug report to reproduce this issue using kvm.

Lastly, if there's any steps you'd like me to try or look into, I'd be
glad to hear :)

-Mitch

On Sun, Aug 11, 2024 at 5:31=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzurick <mitch=
ell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hello bcache team.
> >
> > I know this project is done and stable as [0] says, but I have a
> > question if anyone is around to answer.
> >
> > Has bcache devices been tested and supported on multipath'd disks? I'm
> > looking into an Ubuntu bug[1], where these 2 projects are clashing.
> > I'm wondering if there was any consideration or support for
> > multipathing when this project was made.
> >
> > Also, your new project, bcachefs, might be hitting the same scenario.
> > I haven't had the time to test this though unfortunately.
> >
> > Thanks for your time,
> > -Mitch
> >
> > [0] - https://bcache.evilpiepirate.org/#index4h1
> > [1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/18875=
58
> >
>
> From the Ubuntu bug report, I don=E2=80=99t see the kernel version. After=
 parallel and asynchronous initialization was enabled, the udev rule won=E2=
=80=99t always occupy the bcache block device for long time.
>
> It might be a bit helpful if you may provide the kernel version and Ubunt=
u os version. BTW I don=E2=80=99t have ubuntu account and cannot access pas=
tern.canonical.com.
>
> Thanks.
>
> Coly Li


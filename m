Return-Path: <linux-bcache+bounces-1087-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0B8AC3600
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 19:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 839C71732C8
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 17:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9802B13FD86;
	Sun, 25 May 2025 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SanOulDg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7092AF0E;
	Sun, 25 May 2025 17:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748195282; cv=none; b=L1vvZe6xGf9zlglzI1bsOk0aP58tvJ1Y5R3zJwj3sUgV9uQdNYS9QiHVj9zPPxOKzlmzLOByOMG5V8r5kgmoateRm8qgBH+YTauS9HYZGBt8s1LDuLQ1fOt6hOGgc4uMz/RT2c+pr/CwGPOVFP+ZaGw2cCh6KAQU6gDRAYZU23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748195282; c=relaxed/simple;
	bh=JcHqCmsSFPDcJJiAaYbKb37QS/ul6o9rxhbcf1SM+lI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJgMB+YrkQ93wXpC4ySRlFkx+3SK647kKIBtCROHzcgQUHGRpb6PQjfvPcAqb6xJKyrVx3o2/WDiKoWVp5KOCMVuSxlRWoTsd0lTkZQuuWxgkWe3fZ6so/FqyAEV/bK3oHpHMbjqNYCXDjeDlRCNY6kgNVeeo4+gdx6aua28smo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SanOulDg; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-440685d6afcso19882785e9.0;
        Sun, 25 May 2025 10:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748195279; x=1748800079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQ0Oi+AEZGLioKq4Pf1ZIIAp9uKpwWAvvG0QNpbXWLg=;
        b=SanOulDgCrzCr7qp2Ypay/jyZf5vzotzW6p/erDGbHUrFwIuowZopQVNKEC33QBYlj
         Rzh7fPj+tr81m6HDNzbi41wKebWHp2YXcPbmyLzPt7VFsAfenqjAuNCB9xXRPFHxhWyE
         IKCBBiTDURUbbq+USlGsMdstJKsIcEcjbEQ8wgfkmHW5AwTdUdccFFkxkcS0xNtbw8TO
         TaSG00uggWODhSA17Qdc6il7CRjAHW7e2+18tVXWQR+Qwo+q9vm3AO0GnIPZkeyPp/Cc
         Jnzx5by1E9K6/GiwoF2Np/jeFH3TSdyt2kENqqu+WvGw4Egn+YiW8iLhYgm9VNahA8g5
         O2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748195279; x=1748800079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQ0Oi+AEZGLioKq4Pf1ZIIAp9uKpwWAvvG0QNpbXWLg=;
        b=mdn45wP+z3UDC5QxefZaMYMGgVQTEIZZTp29d1ceT5Trp64v65GiN4TuPHlo/+7jfy
         3Hq9nIGhCkKhNT2pxVEytFVnEcRE/+PHSKmYpwyicibc3/7BvtJ0EiJAkYH2okHJRLuW
         9V63LzwKuh6fsayWc413ebqRZf/pLdIdHq1z0oXO9+zTU22UrRnTek5OIlOUHf8afY43
         VTEs/Qtt1S/v4iVpKwfB5zGPytKhcNcYS++NQVUrSq0WspRmNAZBYJAR4AFymXMA2yf7
         IpHGZ9XKUsLw96IgjrfFn2uIRn5turRONbQMaVjq/gSdSCqM8SS18PSon3WPWb2m3cnG
         Nn0g==
X-Forwarded-Encrypted: i=1; AJvYcCUGlCkFKKz+G5bnKP7vg9OfOjtMtRkKD87o4qaNAvvLYa0A3OZCj1oYZ2wd1JuaXALFTizAUXyyapWN6k0=@vger.kernel.org, AJvYcCUfW8+4O6i6p49thYnQ7EqX0+M0h5a5rcrrFW5kQ7XKb7x6q8mGE1w/uaSNlrENuYPmi5yTHRo4IFUNWm4j@vger.kernel.org
X-Gm-Message-State: AOJu0YznwlCWh4kteawI2ghpKt/zP0i3L7rgnV7OVqHruZ8xG1CvUPOr
	iNbkG+YiRsa3RgT2Qo4h2xOS365+IIkwji7hgySHJM2TLSX9UgGlkYlj
X-Gm-Gg: ASbGncuJOFLwINptG+NYEke7ewDYQpYjBTQrKxnn7aCxeVcsPPPPGVYSCnwV+064c2D
	06uWhoApOSNhYL7WaHZmFBJ+sHCiadvU5USAk/IwAnY7fZA4dMHZQTh4Q9KbOKvjIfw4PUDa/YJ
	Bx6KXqdeqypAR2lz2y3QMiTPFfbHirQnfz8VARK3/+33NaX8G9h1vFe+UpJ3Uoy3xIQsehGDHjO
	Atg6KiEItLd+3q2WKxmxmpANkFMY4Pd4rYZCmKToT7TkjObpkdV7q9Y3tlQv7l1zOjoEuT42NhP
	ftaRYq8H/R+zBla6DOZGH+gZfu8i4FEtZyfq7eqHBfnOsZpPnODLyMqtwqRBekRaapX3Gfs92hA
	wxF+hevjszUbUvxW3mwcwspT3
X-Google-Smtp-Source: AGHT+IGMx9RwnjN3gFTwm6NsJ1bSuN/SbYAqvI26NGXWUD2ifOyK8sgp8xRzjOdZXEkYm0U7HSgMUQ==
X-Received: by 2002:a05:600c:3b8a:b0:442:f485:6fa4 with SMTP id 5b1f17b1804b1-44c95aad94fmr57860655e9.31.1748195278969;
        Sun, 25 May 2025 10:47:58 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4cce08411sm5300031f8f.51.2025.05.25.10.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 May 2025 10:47:58 -0700 (PDT)
Date: Sun, 25 May 2025 18:47:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Arnd Bergmann <arnd@arndb.de>, Naresh Kamboju
 <naresh.kamboju@linaro.org>, linux-bcache@vger.kernel.org, open list
 <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, Linux
 Regressions <regressions@lists.linux.dev>, Dan Carpenter
 <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
Message-ID: <20250525184757.23c5e5d2@pumpkin>
In-Reply-To: <zbifzd2fa3epywbhfznfr24mmacsndkwlengq3cqcgply5it5v@33zajtzvjetj>
References: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
	<6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
	<CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
	<6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
	<7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
	<566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
	<hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
	<692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
	<20250525181842.2e2c47fd@pumpkin>
	<zbifzd2fa3epywbhfznfr24mmacsndkwlengq3cqcgply5it5v@33zajtzvjetj>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 May 2025 13:36:16 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> +cc Steve
...
> > I've a cunning plan to do a proper static analysis of stack usage.
> > It is a 'simple' matter of getting objtool to output all calls with
> > the stack offset.
> > Indirect calls need the function hashes from fine-ibt, but also need
> > clang to support 'hash seeds' to disambiguate all the void (*)(void *)
> > functions.
> > That'll first barf at all recursion, and then, I expect, show a massive
> > stack use inside snprintf() in some error path.  
> 
> I suspect recursion will make the results you get with that approach
> useless.

Recursion is an issue, but the kernel really doesn't support recursion.
So you actually want to know the possible recursion loops anyway.
I suspect (hope) most will be the 'recurses only once' type.
If not they need some other bound.

> We already have "trace max stack", but that only checks at process exit,
> so it doesn't tell you much.
> 
> We could do better with tracing - just inject a trampoline that checks
> the current stack usage against the maximum stack usage we've seen, and
> emits a trace event with a stack trace if it's greater.

Both those only tells you the stack you've used.
The static analysis will show you the stack 'you might use'.
Which is really much more important.

I did this for an embedded system a long time ago.
The outcome was that we didn't have enough memory to allocate the
'worst case' stacks!

	David




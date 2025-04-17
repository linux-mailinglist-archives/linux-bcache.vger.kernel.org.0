Return-Path: <linux-bcache+bounces-901-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 118C9A91F29
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 16:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C954A3B9B93
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 14:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E593824EAB2;
	Thu, 17 Apr 2025 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZGRSEao"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CFE22E40F;
	Thu, 17 Apr 2025 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744898917; cv=none; b=cAimk9+e/HotBJjfxaYrwNwLT8anmAQT0xSGAVUkv9LT53vt3RnwTh2wgEeE+lHDZ7eO/W+rciMVte3AV0NIDzww4rBTA4fo4a8AmNojFYeM/6xsp+eO5B9ynuGSGTrNoeuPUk4kvMmnibhZduqV+gINVgQfEYD6s2TBhKnbJgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744898917; c=relaxed/simple;
	bh=TPLMm1ZndoiDToH+KUk2/lN3biqed27I3c3jpuhsKvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cfQubIF9JwEsPQxkZ9/UGRTBkdDbUouZfg2VT6MD8A6G/OPBQyMnXUOrEo3iMlsv659Y3zdyAA4rO+RGYA7H9x+kGBSm9ExvMQJ4vVmltcESo4MrcXnV7FK5PnaWn0tXUOHnaqaZ/CzaZez1Z0eABsTxG7k2dDWvAgFvlW0gnEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZGRSEao; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256C9C4CEED;
	Thu, 17 Apr 2025 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744898917;
	bh=TPLMm1ZndoiDToH+KUk2/lN3biqed27I3c3jpuhsKvA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HZGRSEaoi+oQbsNROhJiRLUVIfgxqTSPTNtMFtRxthU/aLNxaoIw3NxN7jYvtCKW/
	 B1Gohm2E9jSlQPq9yNq9CqO8L14Sd88RSaPsAQussnHTiR9RF17mFM0kF8zH7Qzlqf
	 Lg29hVkepKat6sey+Yce5/KqJ69XEwzyL3NTsyt9rtRxez9GH7jDOv8YdohPlR8FQQ
	 ZDgamB2stsRFXRN9lsNL+6B9AgaLAushp4m7R1yH6IHQ9QltsAh3Si5wGmSPjKCAMe
	 yhHWTVcXzh4Msu+VxmWtttSKm45c2PHc5QeyPjW4UjyMiZqnBX9aYeIc3XY4rZaVVQ
	 EtcZgLS5g8WJw==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30bfb6ab47cso7492391fa.3;
        Thu, 17 Apr 2025 07:08:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVXJ3PB+tkhrdwf8Nu6EIaJCrlS+tvUXjblmB+OFnleZeHMXVm/IwxPIjZ7Aihl6w9Dh9ZxXVqHIQvjEjQ=@vger.kernel.org, AJvYcCWffx7OhX9UJ8qKsMdhZIG6t9A4w4nITrpOGqyxkuucxGlsXonFFYYk6qXAg8aVeJZiqqJZwAmobYbYi7F16tk5@vger.kernel.org, AJvYcCXxYLowet4VM/8J7uUE8a/4uLBZ37QnJhD6j8nBLR3P1fFcaOLPQaFHz068iVX5qDQVdch4R7kgBt5NSMB2@vger.kernel.org
X-Gm-Message-State: AOJu0YwO2CpoCRnxP0CAXS6KDs9yIEVySN1Ulr4ziPpMsfIhgxazxNZu
	rfHw1I63BUaeimJOcv5ebl4tfU8pubhL+WBi9dJG1BJgaMZUnOEULvtce7Z2luHmFFgInIJsB8P
	WDWfpVl0AXC6D6/zvilwrNl4nH2s=
X-Google-Smtp-Source: AGHT+IEaWJ0x/aIHicJH+1QFpi6ZvgoGXGxaTEIbros01uIBaTwGaYG+LL59AV/3MLt6Wza4qg4HBbIxWtRg0LWEKGU=
X-Received: by 2002:a05:651c:983:b0:307:e498:1254 with SMTP id
 38308e7fff4ca-3107f73b152mr23930761fa.35.1744898915141; Thu, 17 Apr 2025
 07:08:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250416220135.work.394-kees@kernel.org> <CAMj1kXHfearSZG6TFTxxX87qmRkUmAefQm-TfPNS8j09kWxujQ@mail.gmail.com>
 <994E520B-64B1-4387-8DFF-88755346FE55@kernel.org> <208BFA1D-F3E9-4D9F-A4A1-4E4C3F4CA309@coly.li>
In-Reply-To: <208BFA1D-F3E9-4D9F-A4A1-4E4C3F4CA309@coly.li>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 17 Apr 2025 16:08:22 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHwBKu1K=yjJprnEArZFKphvDPsfZzA5KgTtyo5L866=w@mail.gmail.com>
X-Gm-Features: ATxdqUHUUxsySpjImSVW-rg1mZFOWA4rV7sSuMoXiMZYR4kYnV5xepnxWqT88QY
Message-ID: <CAMj1kXHwBKu1K=yjJprnEArZFKphvDPsfZzA5KgTtyo5L866=w@mail.gmail.com>
Subject: Re: [PATCH] md/bcache: Mark __nonstring look-up table
To: Coly Li <i@coly.li>
Cc: Kees Cook <kees@kernel.org>, Coly Li <colyli@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Apr 2025 at 15:12, Coly Li <i@coly.li> wrote:
>
>
>
> > 2025=E5=B9=B44=E6=9C=8817=E6=97=A5 15:10=EF=BC=8CKees Cook <kees@kernel=
.org> =E5=86=99=E9=81=93=EF=BC=9A
> >
> >
> >
> > On April 16, 2025 11:16:45 PM PDT, Ard Biesheuvel <ardb@kernel.org> wro=
te:
> >> On Thu, 17 Apr 2025 at 00:01, Kees Cook <kees@kernel.org> wrote:
> >>>
> >>> GCC 15's new -Wunterminated-string-initialization notices that the 16
> >>> character lookup table "zero_uuid" (which is not used as a C-String)
> >>> needs to be marked as "nonstring":
> >>>
> >>> drivers/md/bcache/super.c: In function 'uuid_find_empty':
> >>> drivers/md/bcache/super.c:549:43: warning: initializer-string for arr=
ay of 'char' truncates NUL terminator but destination lacks 'nonstring' att=
ribute (17 chars into 16 available) [-Wunterminated-string-initialization]
> >>>  549 |         static const char zero_uuid[16] =3D "\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0";
> >>>      |                                           ^~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~
> >>>
> >>> Add the annotation to silence the GCC warning.
> >>>
> >>> Signed-off-by: Kees Cook <kees@kernel.org>
> >>> ---
> >>> Cc: Coly Li <colyli@kernel.org>
> >>> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> >>> Cc: linux-bcache@vger.kernel.org
> >>> ---
> >>> drivers/md/bcache/super.c | 2 +-
> >>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >>> index e42f1400cea9..577d048170fe 100644
> >>> --- a/drivers/md/bcache/super.c
> >>> +++ b/drivers/md/bcache/super.c
> >>> @@ -546,7 +546,7 @@ static struct uuid_entry *uuid_find(struct cache_=
set *c, const char *uuid)
> >>>
> >>> static struct uuid_entry *uuid_find_empty(struct cache_set *c)
> >>> {
> >>> -       static const char zero_uuid[16] =3D "\0\0\0\0\0\0\0\0\0\0\0\0=
\0\0\0\0";
> >>> +       static const char zero_uuid[] __nonstring =3D "\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0\0\0";
> >>>
> >>
> >> Just
> >>
> >> static const char zero_uuid[16] =3D {};
> >>
> >> should work fine here too. No need for the initializer.
> >
> > =F0=9F=A4=A6 Yes. This is what I get for fixing dozens of these. I'll s=
end a v2...
>
>
> Can we do this,
>
> static const char zero_uuid[16] =3D {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, =
0, 0, 0, 0};
>
> I like the explicit array element number 16, and the explicit uuid conten=
t by obvious zero (=E2=80=980=E2=80=99) symbols. They provide redundant inf=
ormation.
> Not sure whether GCC 15 complains or not.
>

Even the {} initializer is entirely redundant, given that the variable
has static linkage, and so C guarantees that it will be zero
initialized.

Could you use NULL_GUID and be done with it?


Return-Path: <linux-bcache+bounces-898-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E9CA6A913DA
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 08:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80580188E0D4
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Apr 2025 06:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E561E5B75;
	Thu, 17 Apr 2025 06:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ohQFtaV8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4451A1A2554;
	Thu, 17 Apr 2025 06:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744870618; cv=none; b=hcG3mep/fx0qO2Uq9cY7YF6345aQdFLr53BOEwiLllSuv2BhP+cTtelQbLInC53oTjxNtA9ArId4zFtyGdelxs5HOU7zpCZilLoJvQ26AnbR6q4mve+eQu+UWTqS2r455sqvmz6LBqjcprUV/NkSaGpD6bVT8we/XReU1ySCxoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744870618; c=relaxed/simple;
	bh=iKWt0M60fm9Kxz2/cP9xQaB/Ji02xwJlF4wlL+lnafE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qrn783ge14ux3oHx+B+VUK/buUBuGyv1LnN+YihxDSrjAXZGFgbWbuV34FIf2ZgD1qiNVErDZrc//PH2EVQYjJIGc8+Jk0dNESdpLuX8toZs//4WU0yoxIbrroh0vXJnbeMiaZmZwUe++Ab14/+g08x0r+Gtif0HyVfNQYXx/Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ohQFtaV8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C038DC4CEE4;
	Thu, 17 Apr 2025 06:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744870617;
	bh=iKWt0M60fm9Kxz2/cP9xQaB/Ji02xwJlF4wlL+lnafE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ohQFtaV8AQ/3UyPjq/wYUGk6Sr3Paqy7WNSylzEK4l7agYoqUspnOoQ7DNOegWbN5
	 NMeO7jCg+/k/u15savL93xkZfLsgMz+EmjdWS2VwmEiEYyhOuAQNdM09+zyMNgXDBn
	 PeUBKpiRhP/tGfg3VYFMhFjk9w0ZvRD6F5IeiBM1ZibU+3uGdfZ26QJZzu6H7XcoCR
	 IP+r4Yk8HWgmxLjEi2bo85bdrxMcrj5mOvYjOLtUCNGg+DM1prfR9HuREzfxXVi1f8
	 lCGfsgmWY8ax5+wjE5PEk5RAKvs3rNOZVWMDR8bsgwmsrVAN2QreYCiU+RwLMfq2+b
	 JmlKY7RhB3lNQ==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-30bfe0d2b6dso3877801fa.3;
        Wed, 16 Apr 2025 23:16:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+YXrMEPPsrD6e6c6LvmwKtJcgIPhhSs4kLTLZ65kRaYmwobLkb6zo/L+jtshyPZ4BbWa6TxPda5HmO2BV9gOd@vger.kernel.org, AJvYcCUGoDWTR4o4A1MHvN3F5fK4SKK2+ozYGHbjI/gyCHgmI5M4+bbeYFH+PBQCuQQltoY+lrTV/qidZulPrCih@vger.kernel.org, AJvYcCXjuJzzSnnrDgiBKqUeweV20nY258pcP07uRyOXHzP36i+lLEg+M9XrUeAQtZGQzuTjdetIX6ufUema8o8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQZo1TfWEkp5TKp5TKkzSJ2y5oIB7ZvootesIayhqaCvZd4bmd
	O0V9ZwHt2HMlLl/j5qwib4fOn3uRJODvR4ANwAD0u6NHxi/s1XCasR/aQ0j7AKSCN0lQGlZqBW4
	b816buFkwv6WgQ/0d3Svn7egHbhw=
X-Google-Smtp-Source: AGHT+IFJFMhcRogBoh9bsWUtiURFChPdUG1PiejQs+Hcg18HHSr74LoMxvw9NZJZnU+cTYLcSStKzPSy+E5M13yNz54=
X-Received: by 2002:a05:651c:883:b0:30c:460f:f56 with SMTP id
 38308e7fff4ca-3107f6cdf12mr15064411fa.20.1744870616089; Wed, 16 Apr 2025
 23:16:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250416220135.work.394-kees@kernel.org>
In-Reply-To: <20250416220135.work.394-kees@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 17 Apr 2025 08:16:45 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHfearSZG6TFTxxX87qmRkUmAefQm-TfPNS8j09kWxujQ@mail.gmail.com>
X-Gm-Features: ATxdqUEXLNTaidkdZkAuf5TP88fl1OFyAaAm6dy4iq9wo3sfgOFtsjB0k1CMTa0
Message-ID: <CAMj1kXHfearSZG6TFTxxX87qmRkUmAefQm-TfPNS8j09kWxujQ@mail.gmail.com>
Subject: Re: [PATCH] md/bcache: Mark __nonstring look-up table
To: Kees Cook <kees@kernel.org>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 17 Apr 2025 at 00:01, Kees Cook <kees@kernel.org> wrote:
>
> GCC 15's new -Wunterminated-string-initialization notices that the 16
> character lookup table "zero_uuid" (which is not used as a C-String)
> needs to be marked as "nonstring":
>
> drivers/md/bcache/super.c: In function 'uuid_find_empty':
> drivers/md/bcache/super.c:549:43: warning: initializer-string for array of 'char' truncates NUL terminator but destination lacks 'nonstring' attribute (17 chars into 16 available) [-Wunterminated-string-initialization]
>   549 |         static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>       |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Add the annotation to silence the GCC warning.
>
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Coly Li <colyli@kernel.org>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: linux-bcache@vger.kernel.org
> ---
>  drivers/md/bcache/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e42f1400cea9..577d048170fe 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -546,7 +546,7 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
>
>  static struct uuid_entry *uuid_find_empty(struct cache_set *c)
>  {
> -       static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
> +       static const char zero_uuid[] __nonstring = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
>

Just

static const char zero_uuid[16] = {};

should work fine here too. No need for the initializer.


>         return uuid_find(c, zero_uuid);
>  }
> --
> 2.34.1
>
>


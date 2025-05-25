Return-Path: <linux-bcache+bounces-1085-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 954A4AC35DA
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 19:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3439E1890C85
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 17:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28BD4259CBA;
	Sun, 25 May 2025 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+uBXIpD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5659C1F4621;
	Sun, 25 May 2025 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748193528; cv=none; b=uCHzJjSdSM6zNuvqHhGecHoP5nNIS0kzTKKGEAaoARfqEbtg7j7/bx1Zp7VirbCGbPF8udDV2k6kaontMQp/PemYlp1jpQMaAdWmubG1A+HFNXuVbxZD49swoteq7rGZFjE0MncUMxhgWk8B9UQhB4Qrbb4dAgfzqxFuT5tw8YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748193528; c=relaxed/simple;
	bh=COq+of+8BuZtfNXyiUexIBrj58KJja2RnZzseXsk28Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BO9ocCmnl2jGX+zY6LB2cnacyh1My/jryd967J4+yE5svdaJexOBZWQKE/iCe+mbRxzOewrmBtaP/MGN2LNHjnIB1iMWHE4ehy4686VwufiSHpZmkV9f+wa/SU0ESCfcQXe99GKp5My7UqwcKpMgaONnScQiKlaCyHu+Q2CEjGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+uBXIpD; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a3798794d3so1583218f8f.1;
        Sun, 25 May 2025 10:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748193524; x=1748798324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQtkFrAhszohoQiv0Q39d8Ie0LTEmozRH+F/ZmwBlXc=;
        b=I+uBXIpDDqSsavieZN1z2WyEQTsX4BcY0hZ9wHPq90nme2snvoJzYrK9fHR9FVzuyM
         SVoIY1cT9VyoadezgopaQq/Q4KKmquEbBFwslTLckMFwWYrjcNXjVOF93/MsuunSc72a
         jCTMlwbA0EcjkdFDISaN95t7dgvS21AO4ygueKWAX4mbO9TSdZiu+Mh339t4OzGbJ4me
         HFyELcqy68PTi6DvtH+QI70CDa75kr+x3MNcKVFWXqS02uPMqTDX3hFdjhxP/++5idbo
         L6VFvFDdF/TmhE4eL6iDiThVQkM6Uaw2Bh4P6HOyMgLfZG4v/P1q5U8Th83LgnXpIrRX
         xaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748193524; x=1748798324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OQtkFrAhszohoQiv0Q39d8Ie0LTEmozRH+F/ZmwBlXc=;
        b=L6vJUVttO9sejxzypvBz7kH0AXU/b1J7s1W1W+CifGVYvazE2DGIjnHndPxVlUx2jF
         7aAqqZPZikoWpvQXeek+qIlNELOgZ9e6s0kuTxf3YTPg+gM9hVoawYWuP7deis7g15PT
         z4cLvUjwBO8fW4wpPmBn7VG5keTLZ8dt4y//p4qo0Nn3bEHCp3gIy5d4t0OMAFRla2JJ
         kG33v9oPNY/FQRGmAXWkkK3jGkasTjxMMLf1/fspy2BLMGhefEGqakueRdfgXgqW5iFG
         hKPFIcOKUDqbEpu4S4BlaSJ/aJf2HM85jz0WQCQH2xd0/aU3E7SJBKHHDlMM3X4hpAhr
         QGaw==
X-Forwarded-Encrypted: i=1; AJvYcCUKOq7vZPskOW0XT/uoG5ycj4RL0iVhy9WWmYkhcuuB51ejvVP+KLdL4N0zAXkWIvKRZPhcCFCSuzwmetU=@vger.kernel.org, AJvYcCXG8XtLlwGqmrSVhqqzX134Pla0KX+YGOcais5WOfO8RudKCPFUXX1LXecSP0SGc41ijVUIEDCiZSbVF5Kc@vger.kernel.org
X-Gm-Message-State: AOJu0YwaVGpolMdwXlj9m4Z+yntbqx/hgTWjXTblK+X3wrHnBA68YqBu
	fJCdejUWBZ94Wg7+ICswubXDjRHsiKtXXUFOb8XlPJxLgL0Fh6ha8SJx
X-Gm-Gg: ASbGncv4OaZP15jPI8Mb2cwqW4ALkjzdpQXpDtoubfpizq1PWfF+K2WDvuyeTwKWhRi
	NZIZpR03a0kAaiRiTEPEsc9ppGWsj8w0aOL93lJlO4aWJcgeyTBpxHW+nWyEXU07WYErJgq+Zai
	eJ4PU7jevKx+bkcKZUsv0zYY1pkofPhuDC8CBDW73x1dpmWfB8pCl4E4JAFvgaRHMT32ZnoqIhp
	THeDKoue9SR1rtDpE86tAviml4Tgc5G/ffeFvarUH78OA5mLOyTznSRlCC9CkKQsBDCDZdtzF8N
	7LxEWs4eK4LjtcAQ2mqLbOWSAhghY6EcWu5IgQ/tsONqxw90TvRc3YgkYDRN3aInItKkUSV4Dhc
	yBJ5HwLh1cUeasQ==
X-Google-Smtp-Source: AGHT+IEE2q/fVFjpifs7t/ga1WjBiQLJh3mtGrvBsi7/40oxJN2TB8Sed6XHs3XOjpIAZTnmZ4VEEA==
X-Received: by 2002:a05:6000:4203:b0:3a4:79e8:d1d8 with SMTP id ffacd0b85a97d-3a4cb0eaf18mr4926116f8f.0.1748193524317;
        Sun, 25 May 2025 10:18:44 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f6f0556bsm209947455e9.12.2025.05.25.10.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 May 2025 10:18:44 -0700 (PDT)
Date: Sun, 25 May 2025 18:18:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Kent Overstreet" <kent.overstreet@linux.dev>, "Naresh Kamboju"
 <naresh.kamboju@linaro.org>, linux-bcache@vger.kernel.org, "open list"
 <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, "Linux
 Regressions" <regressions@lists.linux.dev>, "Dan Carpenter"
 <dan.carpenter@linaro.org>, "Anders Roxell" <anders.roxell@linaro.org>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
Message-ID: <20250525181842.2e2c47fd@pumpkin>
In-Reply-To: <692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
References: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
	<6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
	<CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
	<6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
	<7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
	<566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
	<hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
	<692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 May 2025 20:01:33 +0200
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Fri, May 23, 2025, at 19:11, Kent Overstreet wrote:
> > On Fri, May 23, 2025 at 05:17:15PM +0200, Arnd Bergmann wrote:  
> >> 
> >> - KASAN_STACK adds extra redzones for each variable
> >> - KASAN_STACK further prevents stack slots from getting
> >>   reused inside one function, in order to better pinpoint
> >>   which instance caused problems like out-of-scope access
> >> - passing structures by value causes them to be put on
> >>   the stack on some architectures, even when the structure
> >>   size is only one or two registers  
> >
> > We mainly do this with bkey_s_c, which is just two words: on x86_64,
> > that gets passed in registers. Is riscv different?  
> 
> Not sure, I think it's mostly older ABIs that are limited,
> either not passing structures in registers at all, or only
> possibly one but not two of them.
> 
> >> - sanitizers turn off optimizations that lead to better
> >>   stack usage
> >> - in some cases, the missed optimization ends up causing
> >>   local variables to get spilled to the stack many times
> >>   because of a combination of all the above.  
> >
> > Yeesh.
> >
> > I suspect we should be running with a larger stack when the sanitizers
> > are running, and perhaps tweak the warnings accordingly. I did a bunch
> > of stack usage work after I found a kmsan build was blowing out the
> > stack, but then running with max stack usage tracing enabled showed it
> > to be a largely non issue on non-sanitizer builds, IIRC.  
> 
> Enabling KASAN does double the available stack space. However, I don't
> think we should use that as an excuse to raise the per-function
> warning limit, because
> 
>  - the majority of all function stacks do not grow that much when
>    sanitizers are enabled
>  - allmodconfig enables KASAN and should still catch mistakes
>    where a driver accidentally puts a large structure on the stack

That is rather annoying when you want to look at the generated code :-(

>  - 2KB on 64-bit targes is a really large limit. At some point
>    in the past I had a series that lowered the limit to 1536 byte
>    for 64-bit targets, but I never managed to get all the changes
>    merged.

I've a cunning plan to do a proper static analysis of stack usage.
It is a 'simple' matter of getting objtool to output all calls with
the stack offset.
Indirect calls need the function hashes from fine-ibt, but also need
clang to support 'hash seeds' to disambiguate all the void (*)(void *)
functions.
That'll first barf at all recursion, and then, I expect, show a massive
stack use inside snprintf() in some error path.

Just need a big stack of 'round tuits'.

	David

>   
> 
>      Arnd
> 



Return-Path: <linux-bcache+bounces-1083-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD4CAC2846
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 19:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D01BC3BF026
	for <lists+linux-bcache@lfdr.de>; Fri, 23 May 2025 17:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B7A297A4C;
	Fri, 23 May 2025 17:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JcpyuU5e"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322D5183CC3
	for <linux-bcache@vger.kernel.org>; Fri, 23 May 2025 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748020312; cv=none; b=dr0ADoar/3CgieFGo2tBokRVosm9KuxAM2mWJybqymZTIKfv3POjVFzSUiJWkpilV60XEgYod94oNb4xHOFsf+CAjsEZ1qmuMjzQIkZZESA7WVMh/hibeYCayrDffR5D2v/5VMBZnvR7ATICLh2N+1pAAlNqk+3WjnThQVC9sN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748020312; c=relaxed/simple;
	bh=I5HRgTYbjAei0NoiDbnXhBGNnuDxKXavufUf2oKHFrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrKC8H9SkDw6INybczuga2nJ4VR/e5bR3aJ9u8vVkYAezypP/oUBWGn7pz0YHk3GsZLgHGiFexgDWY+ceaOCA428cymScR7hNQchH4G/nNvgeD7roT0/e+PpTouuxfy1tqfOZDTMnS5truNpXITktff/ALF5w1IYodL9IqsIAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JcpyuU5e; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 23 May 2025 13:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748020308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJXkmNZTsKrW2Bxn55ngQ1cX8S5IwgBjPpV67nxcMZ8=;
	b=JcpyuU5egag6kdnxDgTqogCxBAgjouV7BD7doc+ndVQaaVUgbboakZDHicwyd0WdNupVjk
	Q6VDR0gW/jAoEFBJjHyAl4RB+vNdOpia7qbK5JQtGJb1P3iS/c+E6Z/QDNVO0QGaAyeTgr
	O2R7uUJh9ItaXDCBhUOcfu5KLI6dDBA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, 
	linux-bcache@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
Message-ID: <hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
References: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
 <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
 <6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
 <7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
 <566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 23, 2025 at 05:17:15PM +0200, Arnd Bergmann wrote:
> On Fri, May 23, 2025, at 16:08, Kent Overstreet wrote:
> > On Fri, May 23, 2025 at 03:49:54PM +0200, Arnd Bergmann wrote:
> >> On Fri, May 23, 2025, at 15:19, Naresh Kamboju wrote:
> >
> >> I reproduced the problem locally and found this to go down to
> >> 1440 bytes after I turn off KASAN_STACK. next-20250523 has
> >> some changes that take the number down further to 1136 with
> >> KASAN_STACK and or 1552 with KASAN_STACK.
> >> 
> >> I've turned bcachefs with kasan-stack on for my randconfig
> >> builds again to see if there are any remaining corner cases.
> >
> > Thanks for the numbers - that does still seem high, I'll have to have a
> > look with pahole.
> 
> I agree it's still larger than it should be: having more than
> a few hundred bytes on a function usually means that there is
> both the risk for actual overflow and general inefficiency if
> all the stack data gets accessed as well.
> 
> It's probably not actually structure data though, but a
> combination of effects:
> 
> - KASAN_STACK adds extra redzones for each variable
> - KASAN_STACK further prevents stack slots from getting
>   reused inside one function, in order to better pinpoint
>   which instance caused problems like out-of-scope access
> - passing structures by value causes them to be put on
>   the stack on some architectures, even when the structure
>   size is only one or two registers

We mainly do this with bkey_s_c, which is just two words: on x86_64,
that gets passed in registers. Is riscv different?

> - sanitizers turn off optimizations that lead to better
>   stack usage
> - in some cases, the missed optimization ends up causing
>   local variables to get spilled to the stack many times
>   because of a combination of all the above.

Yeesh.

I suspect we should be running with a larger stack when the sanitizers
are running, and perhaps tweak the warnings accordingly. I did a bunch
of stack usage work after I found a kmsan build was blowing out the
stack, but then running with max stack usage tracing enabled showed it
to be a largely non issue on non-sanitizer builds, IIRC.

> The good news is that so far my randconfig builds have not
> shown any more stack frame warnings on next-20230523 with
> bcachefs force-enabled, now 55 builds into the change,
> across arm32/arm64/x86 using gcc-15.1.

Good to know, thanks.


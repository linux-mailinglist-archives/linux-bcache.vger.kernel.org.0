Return-Path: <linux-bcache+bounces-1086-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E052AAC35F8
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 19:36:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B613D3A6988
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 17:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E7C20E00C;
	Sun, 25 May 2025 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cu7rOmhS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC6E1FAC54
	for <linux-bcache@vger.kernel.org>; Sun, 25 May 2025 17:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748194599; cv=none; b=pL1vwbxkQPGtc3jpPB9lDY9Im9ZlzW3p1NEXqnX3KiTssBUMpYudwsOOqUWvI1NIp0KycJlkuRZZ++GiA3ouGBpyqNVpe9iK+z5vI3SDwkq4WHm6jVr1+x0qtRPK5D7YsyP9pzpGewMoOoN9HlVkefUa8ZbfzU7kV/gednROBsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748194599; c=relaxed/simple;
	bh=DH55LpZqJeh+O8Ipg9+CFUV+kshSj88VsgnPPzafZvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KvYgx30ZxzNTEVMn55IX8xGGs9Bj2ARX1VDEiuMbEOJ+4rRllH3KV3ZUuuqWFL3ZKbctyv/Bo/P4VlvPsbSUlQ0mUl7a4c42LDz1/No+qtAHY5+k9b9+DbBydmzEM2dR+p5zIUr+9ofpt7AIQEa6tTdjTmDtZwpKrt2HPuhQ4ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cu7rOmhS; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 25 May 2025 13:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748194585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPquWNVcy25QbuJztp/q6NZqS5icVInrtL89/XNAjPk=;
	b=Cu7rOmhSTjOeVqNCHzk3h40sQCJXPZN6hlE2eFukEAFOl2K7w+emJ7c4/q10/mNsm1G+J+
	GAsz/+URbtyghiQzfeNP4YiwEHz3wEA7RjdQb3+hNfYwnA0LLeT4ryP8zmDeBH16jSCoJq
	sdYrWqRHW92FqPUKaj8ncJ2tP7XBO28=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Laight <david.laight.linux@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, linux-bcache@vger.kernel.org, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
Message-ID: <zbifzd2fa3epywbhfznfr24mmacsndkwlengq3cqcgply5it5v@33zajtzvjetj>
References: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
 <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
 <6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
 <7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
 <566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
 <hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
 <692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
 <20250525181842.2e2c47fd@pumpkin>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250525181842.2e2c47fd@pumpkin>
X-Migadu-Flow: FLOW_OUT

+cc Steve

On Sun, May 25, 2025 at 06:18:42PM +0100, David Laight wrote:
> On Fri, 23 May 2025 20:01:33 +0200
> "Arnd Bergmann" <arnd@arndb.de> wrote:
> 
> > On Fri, May 23, 2025, at 19:11, Kent Overstreet wrote:
> > > On Fri, May 23, 2025 at 05:17:15PM +0200, Arnd Bergmann wrote:  
> > >> 
> > >> - KASAN_STACK adds extra redzones for each variable
> > >> - KASAN_STACK further prevents stack slots from getting
> > >>   reused inside one function, in order to better pinpoint
> > >>   which instance caused problems like out-of-scope access
> > >> - passing structures by value causes them to be put on
> > >>   the stack on some architectures, even when the structure
> > >>   size is only one or two registers  
> > >
> > > We mainly do this with bkey_s_c, which is just two words: on x86_64,
> > > that gets passed in registers. Is riscv different?  
> > 
> > Not sure, I think it's mostly older ABIs that are limited,
> > either not passing structures in registers at all, or only
> > possibly one but not two of them.
> > 
> > >> - sanitizers turn off optimizations that lead to better
> > >>   stack usage
> > >> - in some cases, the missed optimization ends up causing
> > >>   local variables to get spilled to the stack many times
> > >>   because of a combination of all the above.  
> > >
> > > Yeesh.
> > >
> > > I suspect we should be running with a larger stack when the sanitizers
> > > are running, and perhaps tweak the warnings accordingly. I did a bunch
> > > of stack usage work after I found a kmsan build was blowing out the
> > > stack, but then running with max stack usage tracing enabled showed it
> > > to be a largely non issue on non-sanitizer builds, IIRC.  
> > 
> > Enabling KASAN does double the available stack space. However, I don't
> > think we should use that as an excuse to raise the per-function
> > warning limit, because
> > 
> >  - the majority of all function stacks do not grow that much when
> >    sanitizers are enabled
> >  - allmodconfig enables KASAN and should still catch mistakes
> >    where a driver accidentally puts a large structure on the stack
> 
> That is rather annoying when you want to look at the generated code :-(
> 
> >  - 2KB on 64-bit targes is a really large limit. At some point
> >    in the past I had a series that lowered the limit to 1536 byte
> >    for 64-bit targets, but I never managed to get all the changes
> >    merged.
> 
> I've a cunning plan to do a proper static analysis of stack usage.
> It is a 'simple' matter of getting objtool to output all calls with
> the stack offset.
> Indirect calls need the function hashes from fine-ibt, but also need
> clang to support 'hash seeds' to disambiguate all the void (*)(void *)
> functions.
> That'll first barf at all recursion, and then, I expect, show a massive
> stack use inside snprintf() in some error path.

I suspect recursion will make the results you get with that approach
useless.

We already have "trace max stack", but that only checks at process exit,
so it doesn't tell you much.

We could do better with tracing - just inject a trampoline that checks
the current stack usage against the maximum stack usage we've seen, and
emits a trace event with a stack trace if it's greater.

(and now Steve's going to tell us he's already done this :)


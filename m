Return-Path: <linux-bcache+bounces-1088-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AEE3AC3629
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 20:10:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E9C6D7A9D01
	for <lists+linux-bcache@lfdr.de>; Sun, 25 May 2025 18:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B6861F4725;
	Sun, 25 May 2025 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tI/SNjyf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056861DFF0
	for <linux-bcache@vger.kernel.org>; Sun, 25 May 2025 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748196612; cv=none; b=U47WzFUqJdFzKeF577dX5cTYJbVj9lgg5iot1XukQ9LIyAAK03VcbKdF+MbK8DZ3ilwUK/0ul5J55TyeBeashzIMe9yoN6OCBV0DhYoLSs2vKrZOnoRaaRbsDA0Dh38KfRebg72LpKg+GY6W9kQMUPWxWbGs5MQyJAOqd/f+e4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748196612; c=relaxed/simple;
	bh=s89BNDQdKqJ5IqxY7EhHLW2SQhLkqmeGjSCo1kxun0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y26WGmzST13ubfpmieNGjL7TNUxiu0MQsyMAmKZuq+JDsBQaElUBxgyBcNyjhOPeRlOriAS0cG3fmMJ81sTueBqR6HAlgh3sJynZXbwpIqA497cM7ayGDP+DpZ5f1pZVpPrrwCgIuuij8OzEVKrq+te8e/PyjB4pXz/cTSkuWjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tI/SNjyf; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 25 May 2025 14:10:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748196606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0vd0sHl8w/GaeRmXhaDis/25ZNGdLqLOuwdI9AeDzOY=;
	b=tI/SNjyfh707b6Koumbb11CNdfQwGScOVxUhy+Xr2XRkmAkaZWGt4OgAxlClrNkUCN/p/L
	1foSIjuAXmmFWZEiPqt4toPnyoWt+eY/ttUDawykzgzKCJQUmJ4R1MhO0u+0hHaeSyQzTX
	UHOZ97OgQpQxbSef2xIt1VO6xMUJSYA=
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
Message-ID: <tr3y27pqkm4d6txcqwh4eiwvcr4limzzwnbaybwuigfjcbw43f@krfnu37d5zd7>
References: <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
 <CA+G9fYsjBXvm9NNKRbVo_7heX1537K8yOjH7OaSEQhGRmkLvgA@mail.gmail.com>
 <6247de76-d1f5-4357-83bd-4dd9268f44aa@app.fastmail.com>
 <7tsvzu2mubrpclr75yezqj7ncuzebpsgqskbehhjy6gll73rez@5cj7griclubx>
 <566aefc9-7cad-4eb8-8eb0-8640d745efa2@app.fastmail.com>
 <hplrd5gufo2feylgs4ieufticwemeteaaoilo2jllgauclua2c@o4erpizekm5y>
 <692e313d-ea31-45c0-8c66-36b25c9d955d@app.fastmail.com>
 <20250525181842.2e2c47fd@pumpkin>
 <zbifzd2fa3epywbhfznfr24mmacsndkwlengq3cqcgply5it5v@33zajtzvjetj>
 <20250525184757.23c5e5d2@pumpkin>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250525184757.23c5e5d2@pumpkin>
X-Migadu-Flow: FLOW_OUT

On Sun, May 25, 2025 at 06:47:57PM +0100, David Laight wrote:
> On Sun, 25 May 2025 13:36:16 -0400
> Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > +cc Steve
> ...
> > > I've a cunning plan to do a proper static analysis of stack usage.
> > > It is a 'simple' matter of getting objtool to output all calls with
> > > the stack offset.
> > > Indirect calls need the function hashes from fine-ibt, but also need
> > > clang to support 'hash seeds' to disambiguate all the void (*)(void *)
> > > functions.
> > > That'll first barf at all recursion, and then, I expect, show a massive
> > > stack use inside snprintf() in some error path.  
> > 
> > I suspect recursion will make the results you get with that approach
> > useless.
> 
> Recursion is an issue, but the kernel really doesn't support recursion.
> So you actually want to know the possible recursion loops anyway.
> I suspect (hope) most will be the 'recurses only once' type.
> If not they need some other bound.

Recursion is a fact of life when you get different subsystems
interacting in unpredictable ways.

You can be in one filesystem, and then end up in a fault handler (gup(),
or a simple copy to/from user), and then end up in a completely
different filesystem - and then you call into the block layer, or
networking if it's NFS.

Static analysis might get you some useful data within a subsystem, but
it won't tell you much about the kernel as a whole as people are
actually running it.


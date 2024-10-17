Return-Path: <linux-bcache+bounces-760-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F7B9A194D
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Oct 2024 05:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76F65282059
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Oct 2024 03:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB2D7E583;
	Thu, 17 Oct 2024 03:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vkAt4tgE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5706953E15
	for <linux-bcache@vger.kernel.org>; Thu, 17 Oct 2024 03:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729135600; cv=none; b=NnySDtq+8Zt0lwgf4CtJeBYWKHoAzAp8dGesRKK+JUrPUcH1OUc5EEhfSXkDXQpaJsWBfsn2ypXKV59gZB5Mb/Vnrfk7NOjinZduV+LceIykMeAFWyqjKmyLuRtVlWnHIcjcmo/az0+fV32leuceouD9ZgEgF3Jl82wGE3RsYms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729135600; c=relaxed/simple;
	bh=J28GNYOl7Kl6KER8/vpEaFACYR9JoPkE3Q+drXXkVww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iuwwqOtUXgLIFE61M3WWeB29Y6DYI8DzfgrFFxVH1+WYSOqeWwAV5fTy9Lra1NXc7SxaxXDNTE6Uu+ys/1o7DcfVQSUhW8tkYW744/XcyGyGKULr84ZBw8as7ea3MISISSQE4oZXSjNrIq7gxFsWPMKywRxxz7KkZ2Sn3xURJbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vkAt4tgE; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 16 Oct 2024 23:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729135596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7+LUdLIA2nYBPUaWnD6NUUhpO7j0hr4+N2026tjzPoA=;
	b=vkAt4tgEjbXPDBwFIbyedOwKdJn2ji3kxAsKF53GypUe4TbahqTAmkFxuyo73irxQH6nsr
	1nV314VA8qcaPlpoOchiM/3+11q22jA59WBeuNeo0aSdunMofCKF0r3AtUO8oW9ef1yE1u
	Rs3dWFdQXt0bSDTa3yOEaJP/UY34fCw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, colyli@suse.de, 
	msakai@redhat.com, corbet@lwn.net, mingo@redhat.com, acme@kernel.org, 
	namhyung@kernel.org, akpm@linux-foundation.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <xb2gihmastm3wjn2o2sufvtglvjkelhiiwhnlzoiz4qncywyga@txf4vvnyxhvu>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
 <ZwznQzdZsg82KNT4@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZwznQzdZsg82KNT4@visitorckw-System-Product-Name>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 14, 2024 at 05:41:23PM +0800, Kuan-Wei Chiu wrote:
> On Mon, Oct 14, 2024 at 10:13:58AM +0200, Peter Zijlstra wrote:
> > On Mon, Oct 14, 2024 at 02:47:01AM +0800, Kuan-Wei Chiu wrote:
> > > All current min heap API functions are marked with '__always_inline'.
> > > However, as the number of users increases, inlining these functions
> > > everywhere leads to a significant increase in kernel size.
> > > 
> > > In performance-critical paths, such as when perf events are enabled and
> > > min heap functions are called on every context switch, it is important
> > > to retain the inline versions for optimal performance. To balance this,
> > > the original inline functions are kept, and additional non-inline
> > > versions of the functions have been added in lib/min_heap.c.
> > 
> > The reason it is all __always_inline is because then the whole
> > min_heap_callbacks thing can be constant propagated and the func->less()
> > etc calls become direct calls.
> > 
> > Doing out of line for this stuff, makes them indirect calls, and
> > indirect calls are super retarded expensive ever since spectre. But also
> > things like kCFI add significant cost to indirect calls.
> > 
> > Something that would be a trivial subtract instruction becomes this
> > giant mess of an indirect function call.
> >
> Yes, I also learned from reading the lib/sort.c git log that indirect
> function calls can become especially expensive when
> CONFIG_MITIGATION_RETPOLINE is enabled.
> 
> I'm not an expert in bcache, bcachefs, or dm-vdo, but when Andrew
> previously suggested moving these functions to lib/min_heap, Kent
> expressed his support. This led me to believe that in bcache and
> bcachefs (which are the primary users of min_heap), these indirect
> function calls are considered acceptable. However, that's just my
> assumption — I'll wait for Kent to chime in on this.

yeah, I think we would prefer smaller codesize, by default.

it'd be well worth checking the code size difference on inlined vs. not,
and then the really think to do would be to provide optional _inlined()
helpers that we can switch to if/when a particular codepath shows up in
a profile


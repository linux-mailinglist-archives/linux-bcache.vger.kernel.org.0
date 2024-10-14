Return-Path: <linux-bcache+bounces-755-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B72299C2F2
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 10:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27DEB283202
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 08:21:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE14B14D70B;
	Mon, 14 Oct 2024 08:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lh0Qqn+w"
X-Original-To: linux-bcache@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D9714B080;
	Mon, 14 Oct 2024 08:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894058; cv=none; b=Wnet+Vifl33M3YA4ovyIzjb4Av9uu1k+qhx16SRDVgmmHBIYuu3flWVpMy/p5I1A71eOUxD5DUxfJz9Csz0RdNe6X+5tXfWd0bLzB6lcIcZJS8XrEzOmWlQ9DLqpt+2/qEndu3gvMF1/D7HI4UymJcR/oJgAa670mZYFqyaBx48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894058; c=relaxed/simple;
	bh=1ZdCMUdAKTlVOB5LXlRMmwEGSDqxdD6AiP3O4Jg/Pg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbz3R3QAa+Jn6nuDxXQQqWVxvLBmulJu9qgPDXitoFIHGwwevku0Et0sk6ulV8MBLhevMaw0I1JKKhanLO/uqhputCQpOYD/RadQLS3qv3XWEEjLC1WI0Yv6RWvu0drF81OnpAETVQvnWb5UpFftbPetXOAWKk/9Wj9qu3mOXuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lh0Qqn+w; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dnetulA4MehDQO7QsNr210bmbXUoCBaiLRb2Ng9icDg=; b=lh0Qqn+w2Glieb3GwFDAXo9LGX
	n17CdO9OJuIWg5TAK+EelfhEHbVtMsT4zyVEfRJMVQQkDw0RqFn+cDu4rg/m98xC/HjsitnKcpHNo
	REAf2NL3ZdkTk4ytFuqldUsoNNHf+NJFcHPdpJ2ucAeUMKDzBgEAXLMs0K0vlg6XgChgTWbZkOu4K
	GmOvwEXjt8qDukGAx0FFEHzNEXqFUZ7jtFkJvA35uhgSeHmA88ONAVteiQsEO/Br1+LAOu7RvRV70
	pZbIbP+tuCyXtxU6dvLFAitNmbdohJTuxw9ojndplhAU0+dI/XVmOr/ezL5pTlLqiJtHz7AEkYRsC
	4LyNHsIw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GJm-00000006HDR-2Udf;
	Mon, 14 Oct 2024 08:20:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BDE00300777; Mon, 14 Oct 2024 10:20:41 +0200 (CEST)
Date: Mon, 14 Oct 2024 10:20:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <20241014082041.GN33184@noisy.programming.kicks-ass.net>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014081358.GS17263@noisy.programming.kicks-ass.net>

On Mon, Oct 14, 2024 at 10:13:58AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 14, 2024 at 02:47:01AM +0800, Kuan-Wei Chiu wrote:
> > All current min heap API functions are marked with '__always_inline'.
> > However, as the number of users increases, inlining these functions
> > everywhere leads to a significant increase in kernel size.
> > 
> > In performance-critical paths, such as when perf events are enabled and
> > min heap functions are called on every context switch, it is important
> > to retain the inline versions for optimal performance. To balance this,
> > the original inline functions are kept, and additional non-inline
> > versions of the functions have been added in lib/min_heap.c.
> 
> The reason it is all __always_inline is because then the whole
> min_heap_callbacks thing can be constant propagated and the func->less()
> etc calls become direct calls.

Or better, they can get inlined too.

> Doing out of line for this stuff, makes them indirect calls, and
> indirect calls are super retarded expensive ever since spectre. But also
> things like kCFI add significant cost to indirect calls.
> 
> Something that would be a trivial subtract instruction becomes this
> giant mess of an indirect function call.
> 
> Given the whole min_heap thing is basically a ton of less() and swp()
> calls, I really don't think this trade off makes any kind of sense.


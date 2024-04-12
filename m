Return-Path: <linux-bcache+bounces-399-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2569A8A2804
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Apr 2024 09:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B98B61F22438
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Apr 2024 07:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 781684CB35;
	Fri, 12 Apr 2024 07:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eX4CZHVJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D282C683;
	Fri, 12 Apr 2024 07:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712907029; cv=none; b=BymKsUHSf6h+v1qZ5o9ZBEj0GJykyosGsw4dKrwerl23RX5+pRC2nGEhhRn3Q4OSckbc8t7p3ykOU7i4X2ekbyiEl02VvVF2nDcn5crHj6Bb0QeaBFTvR4B+MlZlrSipOgex3H0LLjTs6PFoljFl0aKD8sS41+yOfcQiArw8uB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712907029; c=relaxed/simple;
	bh=SMJxN39eSTs8bPxN1doXBcsVnwkQ15ZuSI+TQzwARyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fDx/toZQ+4LZ2BmDAzDCFyzIsNfFDNfvlAWt13RMari9GiiP9Uxt/FgtlK0elae3f48HS8N1LQ87YTCDQVI+JHjqy3tRSxF/uc+VbcUgx6yPFXGG/RqtfrBBSRgfuw7X5pAe3PvQ8cyUw7GbyzFQKhX3N4DUUe013Jz/eN4BTlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eX4CZHVJ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WqsHOb8ca3wTRadlCQz8Y2C98VyRQKabao20sZYMVuU=; b=eX4CZHVJ3CoJuRj6xZ6ZoMY55b
	E4+cHxnKRhwlspEuPLkPOEMBgu62L57QQplzsmnmGOU1X/5uNFjzPdfUO2PsB+gHBIqcqlsApOVvS
	w0j47DZ6P36mawIWZi5pmYEEus/SkD8JgwMq6grItMkqZ948DCry5qcbupThkgcWrmkJ6dmvMRMc3
	sgPanGppQemRKHkCd0b57PPzi6cFhYXZGz/I0dodBsrg49id0nMMEsQ1qvgunJZfvOqw0FnYbd3kM
	Ym1mlyAaQHZyhzXHPSM1ktyo1vLV6kYiHMYC1g+FS26tGu8xjub1jjlvPX/seM/9iG3HKuQzqZgtb
	m/G5bwCA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rvBMY-00000008fV6-1VBb;
	Fri, 12 Apr 2024 07:30:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0880E3004D5; Fri, 12 Apr 2024 09:30:18 +0200 (CEST)
Date: Fri, 12 Apr 2024 09:30:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 04/17] lib min_heap: Add type safe interface
Message-ID: <20240412073017.GE30852@noisy.programming.kicks-ass.net>
References: <20240406164727.577914-1-visitorckw@gmail.com>
 <20240406164727.577914-5-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240406164727.577914-5-visitorckw@gmail.com>

On Sun, Apr 07, 2024 at 12:47:14AM +0800, Kuan-Wei Chiu wrote:

> -struct min_heap {
> -	void *data;
> -	int nr;
> -	int size;
> -};
> +#define MIN_HEAP_PREALLOCATED(_type, _name, _nr)	\
> +struct _name {	\
> +	int nr;	\
> +	int size;	\
> +	_type *data;	\
> +	_type preallocated[_nr];	\
> +}


> @@ -3738,7 +3739,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
>  	struct perf_cpu_context *cpuctx = NULL;
>  	/* Space for per CPU and/or any CPU event iterators. */
>  	struct perf_event *itrs[2];
> -	struct min_heap event_heap;
> +	struct perf_event_min_heap event_heap;
>  	struct perf_event **evt;
>  	int ret;
>  
> @@ -3747,11 +3748,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
>  
>  	if (!ctx->task) {
>  		cpuctx = this_cpu_ptr(&perf_cpu_context);
> -		event_heap = (struct min_heap){
> -			.data = cpuctx->heap,
> -			.nr = 0,
> -			.size = cpuctx->heap_size,
> -		};
> +		event_heap.data = cpuctx->heap;
> +		event_heap.nr = 0;
> +		event_heap.size = cpuctx->heap_size;
>  
>  		lockdep_assert_held(&cpuctx->ctx.lock);
>  
> @@ -3760,11 +3759,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
>  			css = &cpuctx->cgrp->css;
>  #endif
>  	} else {
> -		event_heap = (struct min_heap){
> -			.data = itrs,
> -			.nr = 0,
> -			.size = ARRAY_SIZE(itrs),
> -		};
> +		event_heap.data = itrs;
> +		event_heap.nr = 0;
> +		event_heap.size = ARRAY_SIZE(itrs);
>  		/* Events not within a CPU context may be on any CPU. */
>  		__heap_add(&event_heap, perf_event_groups_first(groups, -1, pmu, NULL));
>  	}

Not too happy about these. If you ever add more fields they will go
uninitialized. Why not keep the existing form and fix the struct name?


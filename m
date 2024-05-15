Return-Path: <linux-bcache+bounces-460-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 140D98C62F2
	for <lists+linux-bcache@lfdr.de>; Wed, 15 May 2024 10:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75BC7B227DE
	for <lists+linux-bcache@lfdr.de>; Wed, 15 May 2024 08:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29AF4F20E;
	Wed, 15 May 2024 08:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VC8ZzEVW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3884F1E2;
	Wed, 15 May 2024 08:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715762297; cv=none; b=TgZXhDPhB/gYtMTylpsNxoObW/TmiNLgqamujSMO9ZVaXvOHhMx8Z3E6uDISMBmCb1vQ5PQz6g9PxI6BrEiNMWsznfK7xo/T8h6mwZFrz1MvriZlno49pdOqh8B3hdR4uYmcOXSE6V89xFgGPpTrPrInlvp110puZDGB0D5pcCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715762297; c=relaxed/simple;
	bh=Tpla7BbjcnmioeU0TB5vZhZhEFVFx+ygWRQ+4ZTjSs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+5uQmP7zj4SD2v9/0Sh2FfmsWVoeUfrRB//UB02K1sblLBLI1l+JkwSN9W6CMdNCtW9duOu3ROpbc3ka+HF14XU1L/68BmgTKoLcaH0D23q/0pOLs4vtkBJP4jMAp9excrbJhUR7smCs3+9ty7AwQBkO6HHqFiTYcb7IihhJ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VC8ZzEVW; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Keg0jiSN81Wa3nYaggknvxCwoJj5PEJrMVbonyZKJTw=; b=VC8ZzEVW7pcHbnf3lULvD3cxgN
	VffP1SHapl/sAgpWcQPzagL8HPWl2CZaISZnehAXQ82tXyFpY9sc3b7/p6VKALiN+/LrwnIMP4RkC
	MZNzovUkZBgJdk+tj32EjQunWtvsQpMZn/S6qt9NTfLDZh8S2Q4/I9iZbOpBEhQygIA5gkYnOFmom
	fWyIRpAsJswXfRvuBRYyAcvAn25N7coAP4UyLnzrrKBihNTz7Bodow3MJJurHVN1p6InDTWCmTsdJ
	I8Nlpkh9Psb98XRsZH1B30ZAlWsgZdlny3xaRngSLGIaid5sNAirBkKujgo3Hg7JTPrXxTv+mAb0K
	r6d/nqZg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s7A96-000000052j7-1pIs;
	Wed, 15 May 2024 08:38:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 629AA30068B; Wed, 15 May 2024 10:37:55 +0200 (CEST)
Date: Wed, 15 May 2024 10:37:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [RESEND PATCH v5 11/16] lib min_heap: Update min_heap_push() and
 min_heap_pop() to return bool values
Message-ID: <20240515083755.GB40213@noisy.programming.kicks-ass.net>
References: <20240514084724.557100-1-visitorckw@gmail.com>
 <20240514084724.557100-12-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240514084724.557100-12-visitorckw@gmail.com>

On Tue, May 14, 2024 at 04:47:19PM +0800, Kuan-Wei Chiu wrote:
> Modify the min_heap_push() and min_heap_pop() to return a boolean
> value. They now return false when the operation fails and true when it
> succeeds.

But why ?!

> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Reviewed-by: Ian Rogers <irogers@google.com>
> ---
>  include/linux/min_heap.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index c94f9d303205..2d080f85ad0d 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
>  
>  /* Remove minimum element from the heap, O(log2(nr)). */
>  static __always_inline
> -void __min_heap_pop(min_heap_char *heap, size_t elem_size,
> +bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
>  		const struct min_heap_callbacks *func, void *args)
>  {
>  	void *data = heap->data;
>  
>  	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
> -		return;
> +		return false;
>  
>  	/* Place last element at the root (position 0) and then sift down. */
>  	heap->nr--;
>  	memcpy(data, data + (heap->nr * elem_size), elem_size);
>  	__min_heapify(heap, 0, elem_size, func, args);
> +
> +	return true;
>  }
>  
>  #define min_heap_pop(_heap, _func, _args)	\
> @@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *heap,
>  
>  /* Push an element on to the heap, O(log2(nr)). */
>  static __always_inline
> -void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> +bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
>  		const struct min_heap_callbacks *func, void *args)
>  {
>  	void *data = heap->data;
> @@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
>  	int pos;
>  
>  	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
> -		return;
> +		return false;
>  
>  	/* Place at the end of data. */
>  	pos = heap->nr;
> @@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
>  			break;
>  		func->swp(parent, child, args);
>  	}
> +
> +	return true;
>  }
>  
>  #define min_heap_push(_heap, _element, _func, _args)	\
> -- 
> 2.34.1
> 


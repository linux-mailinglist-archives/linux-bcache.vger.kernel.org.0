Return-Path: <linux-bcache+bounces-1106-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA1E9AD029A
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 14:52:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 556671897F3E
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 12:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37A528850D;
	Fri,  6 Jun 2025 12:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2d8yC//"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B20220D4E2
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 12:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749214366; cv=none; b=Kzk01hNoyoj4byQLTZr+roSqNvIq/IK8IcXTbmOpBYXwhxTH3MxhWRFM8zlot2LUtxiTgDjfWJrcDlfsZZGHTkTkNwCJztzp3vD27gKGnuK2wse11yoxn5pSUqcWI0Llmss+eAiZxaAVJoqHWWjVY25h4VrcEyrn1vRiUXXKFXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749214366; c=relaxed/simple;
	bh=dqN5niXw6NGTg3SX1wBpYkGFj/I6cJGeB2TTF2wS8iM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hc/2bAEhA4dBWn12FAyqOBuoucIxIA94DPxTlzLoYytcb80s0ndJNDvNR6k/mDweQ0aw1L70sdGPYbIGw+A+kPNODfK0o9g3FBmg/vNGzpNKXOwdVrPtec0XXSAba6xW+frsQAChDDI31BsdnEUhpAIKDHe7sW9rNFK5TtDUJXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2d8yC//; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-311da0bef4aso2111325a91.3
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 05:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749214364; x=1749819164; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6WIMDjX9Shd/e5qQYy7IRFFUs7MFYzn3E/yLxfzjkds=;
        b=d2d8yC//qtomJM0MFzfHJGHV/ln/L0lP+lVF0/U3BAiFyJ7kWCr1WMo85s5SnL7SDI
         ZKrksR+EGhnszh/3HXk2DgWYNKTZvdDynj0vJNdDDpiveR+R8K2m++05hXGrrjdvL0bF
         5EnRXuNcsvCXLjPZo/+PG9ueokT1kTiabbShuhXGNUTbASvMV3m9ViW7C03vKhTvVmuv
         GI1azMF9H0tMaPSnNqsXlHd3IlF6A/qmB3ORmJVJ5xhUThTIo1efiEMPIowZLg43xaLD
         deuqZf8tv1UFWVQtooxj5TFf5IW+MJIKmTfOOM/fj3eBfkXhVi8PeWmSSqw+Hy8soi+f
         XuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749214364; x=1749819164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6WIMDjX9Shd/e5qQYy7IRFFUs7MFYzn3E/yLxfzjkds=;
        b=S35Sj0GtTi8GcJmWGrIHMcOCDppvpA42qUb/yggJl6FJgrAUxiEE30N9QODsFHfF/O
         PYoAXTOXHEoOo9mcENSJs0FaDCvKVJIWOdAqXjTEJYcsZ8mVRwdevNnYRJa3TTT9cvcP
         yEyZNU6YSDBFpTqdX9NjO7MwuZOxOJMVEiWb6+T5cMaxCeOX6Xl7qX3JsUyyKKDW44l7
         clXCBfobA9Att+xXbCfoYZ9B3+sN31JDNG0nw9Wmn9+YvYpI/7uWjtwn/8aiXDY7AS0R
         AP+gh6IU2VDoxo3FgqFdG1qIKHVwtGL+Vq9qbL3ixR50ONVKk1hIjKwT1KdQzSbsJRSc
         q9QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeyb6G41Hw2YDQKuV/EA3RavSea0QbJqJlrHlwFhX/ZYRse3goGADl6UXwXLa/E5Ad/5gIkpTMV1cQsRE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVPVc+qCxaTOF4nuDQz4It1A7iRTpauMOLJydoXjcBGyvx8NGN
	VuhDSQBAQoOLJFfTFGRzwfkvWuWx6JcJnKZHx9U5YAhu4Rc9+vRtzirg
X-Gm-Gg: ASbGncvAHX4AcDC0cgiBVca0OIvbIV6690Ktd9xD52VautHMqhTuwZDFnn/MyEtV9Ei
	kZKaycxsO7i/6l/NXyLMTg35y+tqoEuKyq4KhDl5QmEwK6clGbdpg9BnRXcbeUbmQw2WUrsjjHI
	WLEXwXz8M2aDfYgUFavi1lRdkUWlwzhDOrL7uTwrBw3W2bH4fjxT25gHyN/7Mria6/W9uVVLxrF
	6jbYlUcto/hCQTf1CUsXo7+y7di0GPf043NJ7qD1VjlAUO797UXTXW36NomjnmVwABnkmh/VeXi
	GGY7D7XFY19TFFMkw+A3ll6Tf1gj24q+wyfGiFyBuJ3w73QxsiyNrTxBIbZBGQFgiStgsJ0FZpb
	bZtDkqw7MHD1eQw==
X-Google-Smtp-Source: AGHT+IGK1O7AH86FUDhxc9TsaBPjMcqyMtUQyX8tzHRBf3+38dprV1XA1ILVzJxPPhpFeJeFV9IJvQ==
X-Received: by 2002:a17:90b:5291:b0:311:eb85:96ea with SMTP id 98e67ed59e1d1-313472f7642mr6231328a91.9.1749214364212;
        Fri, 06 Jun 2025 05:52:44 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3134b13addasm1153550a91.34.2025.06.06.05.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 05:52:43 -0700 (PDT)
Date: Fri, 6 Jun 2025 20:52:41 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Robert Pang <robertpang@google.com>
Cc: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/3] lib min_heap: add alternative APIs that use the
 conventional top-down strategy to sift down elements
Message-ID: <aELkmbQpRFejwtIl@visitorckw-System-Product-Name>
References: <20250606071959.1685079-1-robertpang@google.com>
 <20250606071959.1685079-3-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606071959.1685079-3-robertpang@google.com>

On Fri, Jun 06, 2025 at 12:19:44AM -0700, Robert Pang wrote:
> Add these min_heap functions that re-introduce the conventional top-down
> strategy to sift down elements. This strategy offers significant performance
> improvements for data that are mostly identical. [1]
> 
> - heapify_all_top_down
> - heap_pop_top_down
> - heap_pop_push_top_down
> - heap_del_top_down
> 
> [1] https://lore.kernel.org/linux-bcache/wtfuhfntbi6yorxqtpcs4vg5w67mvyckp2a6jmxuzt2hvbw65t@gznwsae5653d/T/#m155a21be72ff0cc57d825affbcafc77ac5c2dd0d

Nit: I'd prefer using a Link: tag here.

> 
> Signed-off-by: Robert Pang <robertpang@google.com>
> ---
>  include/linux/min_heap.h | 75 ++++++++++++++++++++++++++++++++++++++++
>  lib/min_heap.c           |  7 ++++
>  2 files changed, 82 insertions(+)
> 
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 1fe6772170e7..149069317bb3 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -494,4 +494,79 @@ bool __min_heap_del(min_heap_char *heap, size_t elem_size, size_t idx,
>  	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
>  		       __minheap_obj_size(_heap), _idx, _func, _args, __min_heap_sift_down)
>  
> +static __always_inline
> +void __min_heap_sift_down_top_down_inline(min_heap_char *heap, int pos, size_t elem_size,
> +					  const struct min_heap_callbacks *func, void *args)
> +{
> +	void *data = heap->data;
> +	void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
> +	/* pre-scale counters for performance */
> +	size_t a = pos * elem_size;
> +	size_t b, c, d, smallest;
> +	size_t n = heap->nr * elem_size;
> +
> +	if (!swp)
> +		swp = select_swap_func(data, elem_size);
> +
> +	for (;;) {
> +		if (2 * a + elem_size >= n)
> +			break;
> +
> +		c = 2 * a + elem_size;
> +		b = a;
> +		smallest = b;
> +		if (func->less(data + c, data + smallest, args))
> +			smallest = c;
> +
> +		if (c + elem_size < n) {
> +			d = c + elem_size;
> +			if (func->less(data + d, data + smallest, args))
> +				smallest = d;
> +		}
> +		if (smallest == b)
> +			break;
> +		do_swap(data + smallest, data + b, elem_size, swp, args);
> +		a = (smallest == c) ? c : d;
> +	}
> +}

The logic looks correct, but we actually only need variables a, b, and
c. The use of d and the extra nested if seem unnecessary. I think the
following version is shorter and easier to understand:

for (;;) {
	b = 2 * a + elem_size;
	c = b + elem_size;
	smallest = a;

	if (b >= n)
		break;

	if (func->less(data + b, data + smallest, args))
		smallest = b;

	if (c < n && func->less(data + c, data + smallest, args))
		smallest = c;

	if (smallest == a)
		break;

	do_swap(data + a, data + smallest, elem_size, swp, args);
	a = smallest;
}

> +
> +#define min_heap_sift_down_top_down_inline(_heap, _pos, _func, _args)	\
> +	__min_heap_sift_down_top_down_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
> +					     _pos, __minheap_obj_size(_heap), _func, _args)
> +#define min_heapify_all_top_down_inline(_heap, _func, _args)	\
> +	__min_heapify_all_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
> +				 __minheap_obj_size(_heap), _func, _args,	\
> +				 __min_heap_sift_down_top_down_inline)
> +#define min_heap_pop_top_down_inline(_heap, _func, _args)	\
> +	__min_heap_pop_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
> +			      __minheap_obj_size(_heap), _func, _args,	\
> +			      __min_heap_sift_down_top_down_inline)
> +#define min_heap_pop_push_top_down_inline(_heap, _element, _func, _args)	\
> +	__min_heap_pop_push_inline(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
> +				   __minheap_obj_size(_heap), _func, _args,	\
> +				   __min_heap_sift_down_top_down_inline)
> +#define min_heap_del_top_down_inline(_heap, _idx, _func, _args)	\
> +	__min_heap_del_inline(container_of(&(_heap)->nr, min_heap_char, nr),	\
> +			      __minheap_obj_size(_heap), _idx, _func, _args,	\
> +			      __min_heap_sift_down_top_down_inline))
> +
> +void __min_heap_sift_down_top_down(min_heap_char *heap, int pos, size_t elem_size,
> +                                   const struct min_heap_callbacks *func, void *args);
> +
> +#define min_heap_sift_down_top_down(_heap, _pos, _func, _args)	\
> +	__min_heap_sift_down(container_of(&(_heap)->nr, min_heap_char, nr), _pos,	\
> +			     __minheap_obj_size(_heap), _func, _args)
> +#define min_heapify_all_top_down(_heap, _func, _args)	\
> +	__min_heapify_all(container_of(&(_heap)->nr, min_heap_char, nr),	\
> +			  __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down_top_down)
> +#define min_heap_pop_top_down(_heap, _func, _args)	\
> +	__min_heap_pop(container_of(&(_heap)->nr, min_heap_char, nr),	\
> +		       __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down_top_down)
> +#define min_heap_pop_push_top_down(_heap, _element, _func, _args)	\
> +	__min_heap_pop_push(container_of(&(_heap)->nr, min_heap_char, nr), _element,	\
> +			    __minheap_obj_size(_heap), _func, _args, __min_heap_sift_down_top_down)
> +#define min_heap_del_top_down(_heap, _idx, _func, _args)	\
> +	__min_heap_del(container_of(&(_heap)->nr, min_heap_char, nr),	\
> +		       __minheap_obj_size(_heap), _idx, _func, _args, __min_heap_sift_down_top_down)
> +

I think we should document in Documentation/core-api/min_heap.rst why
the *_top_down variants exist and how to choose between them.
Otherwise, it could be confusing for future users.

Regards,
Kuan-Wei

>  #endif /* _LINUX_MIN_HEAP_H */
> diff --git a/lib/min_heap.c b/lib/min_heap.c
> index 4ec425788783..a10d3a7cc525 100644
> --- a/lib/min_heap.c
> +++ b/lib/min_heap.c
> @@ -27,6 +27,13 @@ void __min_heap_sift_down(min_heap_char *heap, int pos, size_t elem_size,
>  }
>  EXPORT_SYMBOL(__min_heap_sift_down);
>  
> +void __min_heap_sift_down_top_down(min_heap_char *heap, int pos, size_t elem_size,
> +				   const struct min_heap_callbacks *func, void *args)
> +{
> +	__min_heap_sift_down_top_down_inline(heap, pos, elem_size, func, args);
> +}
> +EXPORT_SYMBOL(__min_heap_sift_down_top_down);
> +
>  void __min_heap_sift_up(min_heap_char *heap, size_t elem_size, size_t idx,
>  			const struct min_heap_callbacks *func, void *args)
>  {
> -- 
> 2.50.0.rc1.591.g9c95f17f64-goog
> 


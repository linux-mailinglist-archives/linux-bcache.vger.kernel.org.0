Return-Path: <linux-bcache+bounces-1107-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFBBFAD02B7
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 15:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E52D7AA2D2
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 13:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5061E3787;
	Fri,  6 Jun 2025 13:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ubg4FkS5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C64120330
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 13:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749214914; cv=none; b=RS2KqyBzUZ8yiRhdgYf4vpMPQLXJSKfk54n1VNcxYDBL/0QgNspilOKgM3/LO9aPNRACpEI1vKwmCJYwxOEdKVbh89y8/ZGoi3HhUAT9qXUBbDQm8QBTHrtOBvxMcQ/s0irW5GFAt41/XekgPgmj6tIRLiwXFNtayt689ItUdSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749214914; c=relaxed/simple;
	bh=SDLhKAguddGt2geZvcSHfyAPlrbXWG9c/LJnK/yvikc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayY5LfT1bl89wbqOTsse8AZnv1gKkTkR1YB1L4OGZg4fCVSGEFhHyO5KS9yYlr/S4mWk6o5BvTWaT5715x2lGE1o0EOcvzAIkEr2SWLl9iCmn90xgfQXqhGDjHoospyW5HnfI87VzjkK8kVfw7ELdmtXM3rqhDyON8jPmsLnInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ubg4FkS5; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2320d06b728so19196635ad.1
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 06:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749214912; x=1749819712; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h+qbD8rvws2edlgCFRsxMh+Qhv3OsOK4zaxW5n2vuh8=;
        b=Ubg4FkS542e4aAa/egbJfZV3ks9kq3pBFZj/dJkWBpcCUWLGJuYEjPhJflwsObLFni
         NIU3SPlK1+uBAdZ91V0X83unuIBCSbyqhWO3764XuYkzvXj0dl+4flfhd1a9RlqYBgCN
         hbemqjEvkHu9yGGwh/OysWDnGTmnuKUKJsZDi0Svad9wDH/Ue/9IYX1Bp2SkH+JtufzL
         9j9hmQaCMOUQN5OgPCMzr5TybhdCzBnqWCsNYSHuaLuEnHQuy0N23PGO9DtPwpENsUNI
         EGerfuBH546NVrEulcwdLcBchrbg8/wig+oZtzve4cBW/om/sOaifNKKFpyNvW+eg73K
         j5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749214912; x=1749819712;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h+qbD8rvws2edlgCFRsxMh+Qhv3OsOK4zaxW5n2vuh8=;
        b=IR3j9d5g/WYkG5GBb5ybkRupjWaXBzrrex5xSdHHyiOof7iO041Es8WfvAIgIB/Iim
         abI3EnGAEhVIx+ap8KXKDR68QSkR4rzuNU/QUoAmzc8at/BApi3hdq4DdCKLJRHpqMcg
         DGTaP3Daje2TraqXkO/1rSdnthGaeIPcGuWIPJkwH1O7TzWsCTCi6+bVkN2P3BjbM7aw
         /w6mCEi0u1+qZDv6Gm+NS9EVpY0RXcIArJyc7Q4otTdLZyj7RvuBfuE3KtpNZWFnFkdV
         gcW6ayB+pCXVgBJaLJ2g95Jb5cW0el3yLJtb2rERQKGKWEYnYSbNc10SKqM+N0wehc4a
         7Giw==
X-Forwarded-Encrypted: i=1; AJvYcCWZJ8W+CoqkA8tKMBUT5EMhQEPLvJrxQISZ9WfqLJhIvj+BGD5UXzABx0Of07TozG2kuWUT/pQjYowryT0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Uxl2MHh7oeKcSlYYD9deFGF7bd1CahxUmymD/AZCp2WG0Hgp
	eoytBRsd+SMtVzjFP7Z/6tOPHcz/WaWJSw/mn1rDiJ2f+LzLvPmmsrLH
X-Gm-Gg: ASbGncv9OuT9n2IZursCvSlHG89rMvyQb8kTO/HzIoGgTuoavwQcw63yZUkRznyzo58
	7JNutHnJ6a36gG28BZw0PpGLOXWFRnKqOywUG+6xTUUlBf7N+YsgWIdpgCxB2b3SQ+dxqSOTw/t
	lDB4jv+F5cTGlDEjkc4UJ5INs6cdWjDrQAxOGDunS0h2yMArI4bjZZ9ecFUY67xu0lvQDBNkM5k
	rTNWC1q1goOqn4+yZmM927r7u5UiJiWx41xRuquesA4W1O53AcmOnD12LwEhwV+57MCKk9T8umf
	X6VfrGTgW0fJ4ehu7dTUbLnCSL/s0JSB/zICz8ianAqmzNdOeuPH/3wUmJGx1RiPP/2KSxbL5FU
	w0ms=
X-Google-Smtp-Source: AGHT+IEcemlEOkjwKsMeDpYrVB9Gmi3Na+NynSNgQ2OMrRfQsThSbVatH1zmHNGk6dj33zK1oPuCTw==
X-Received: by 2002:a17:902:e84b:b0:234:cf24:3be8 with SMTP id d9443c01a7336-23601d172bbmr47954285ad.28.1749214912075;
        Fri, 06 Jun 2025 06:01:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603405161sm11790845ad.147.2025.06.06.06.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 06:01:51 -0700 (PDT)
Date: Fri, 6 Jun 2025 21:01:49 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Robert Pang <robertpang@google.com>
Cc: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org
Subject: Re: [PATCH 3/3] bcache: Fix the tail IO latency regression due to
 the use of lib min_heap
Message-ID: <aELmvZ4Mm7gwGqhj@visitorckw-System-Product-Name>
References: <20250606071959.1685079-1-robertpang@google.com>
 <20250606071959.1685079-4-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606071959.1685079-4-robertpang@google.com>

On Fri, Jun 06, 2025 at 12:19:45AM -0700, Robert Pang wrote:
> In commit "lib/min_heap: introduce non-inline versions of min heap API functions"
> (92a8b22), bcache migrates to the generic lib min_heap for all heap operations.
> This causes sizeable the tail IO latency regression during the cache replacement.

Nit: According to the documentation, I'd prefer referencing the commit
like this:

92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap
API functions")
https://docs.kernel.org/process/submitting-patches.html#describe-your-changes

Also, if the regression is caused by the heapify method, shouldn't the
commit that introduced it be 866898efbb25 ("bcache: remove heap-related
macros and switch to generic min_heap") ?

> 
> This commit updates invalidate_buckets_lru() to use the alternative APIs that
> sift down elements using the top-down approach like bcache's own original heap
> implementation.
> 
> [1] https://lore.kernel.org/linux-bcache/wtfuhfntbi6yorxqtpcs4vg5w67mvyckp2a6jmxuzt2hvbw65t@gznwsae5653d/T/#me50a9ddd0386ce602b2f17415e02d33b8e29f533
> 
> Signed-off-by: Robert Pang <robertpang@google.com>
> ---
>  drivers/md/bcache/alloc.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 8998e61efa40..547d1cd0c7c2 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -207,15 +207,15 @@ static void invalidate_buckets_lru(struct cache *ca)
>  		if (!bch_can_invalidate_bucket(ca, b))
>  			continue;
>  
> -		if (!min_heap_full(&ca->heap))
> -			min_heap_push(&ca->heap, &b, &bucket_max_cmp_callback, ca);
> -		else if (!new_bucket_max_cmp(&b, min_heap_peek(&ca->heap), ca)) {
> +		if (!min_heap_full_inline(&ca->heap))
> +			min_heap_push_inline(&ca->heap, &b, &bucket_max_cmp_callback, ca);

If the regression is caused by the heapify method rather than the
inline vs non-inline change, is it necessary to switch to the
non-inline version here?

Regards,
Kuan-Wei

> +		else if (!new_bucket_max_cmp(&b, min_heap_peek_inline(&ca->heap), ca)) {
>  			ca->heap.data[0] = b;
> -			min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_callback, ca);
> +			min_heap_sift_down_top_down_inline(&ca->heap, 0, &bucket_max_cmp_callback, ca);
>  		}
>  	}
>  
> -	min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
> +	min_heapify_all_top_down_inline(&ca->heap, &bucket_min_cmp_callback, ca);
>  
>  	while (!fifo_full(&ca->free_inc)) {
>  		if (!ca->heap.nr) {
> @@ -227,8 +227,8 @@ static void invalidate_buckets_lru(struct cache *ca)
>  			wake_up_gc(ca->set);
>  			return;
>  		}
> -		b = min_heap_peek(&ca->heap)[0];
> -		min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
> +		b = min_heap_peek_inline(&ca->heap)[0];
> +		min_heap_pop_top_down_inline(&ca->heap, &bucket_min_cmp_callback, ca);
>  
>  		bch_invalidate_one_bucket(ca, b);
>  	}
> -- 
> 2.50.0.rc1.591.g9c95f17f64-goog
> 


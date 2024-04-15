Return-Path: <linux-bcache+bounces-402-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAB38A5932
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Apr 2024 19:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F450B20CD2
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Apr 2024 17:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BFC583CA0;
	Mon, 15 Apr 2024 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZRh5BP4"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD3582C7E;
	Mon, 15 Apr 2024 17:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713202539; cv=none; b=m+PqZ8jjUVhVWP0UuAepGeMWHPZ4zGXYblRCHcZVdqyeHmoXYGDAz1P55CuUwmijNGd/K8KrU8o/n1T0zxuCAfm3af4If9tG/dBTnBDnTKkKcvvZ3ECq/7O8xfHZDIcdpiaXZm2H/8NSiCmKU3QCM8nVm+vpMKTcSPUf8kfwnsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713202539; c=relaxed/simple;
	bh=+mDx52s9ABbP+qylPDjlEdQbUbUBCGmkdgYzyLRZEsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fqeNeb/Z19YIaPnZaa6lP5S/kM9ifYZxEJ6rAH7AL7A+V4BaleeEjAEFZKzfdTiO+0i3I74mmMQ+4GunAPFDYIaxEGo3kAqm0S1bT0bM3l2Wz9DL7Pv1nFOwvAt4iYkoDOZdKwPOpmo69ZnGw9d5nQIvhDPqe9rUoNGDUFs/MeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OZRh5BP4; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-6ecff85b21cso494643b3a.1;
        Mon, 15 Apr 2024 10:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713202537; x=1713807337; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yND2zUfUi+v4q+Fs4T63lVmVArBJWibOzfGLa99Xn9w=;
        b=OZRh5BP45gs7u13Xk0gSprV0+Z7z6T13T2rmRTsg1AOar+YqX9mYPrruGPrLyvoq2P
         /s7oPyW+pT588hzUNo83NAckQ+ubiE7df5Bk3bpFleAXuTLqVLtE6s2kMJRVFQh53t8i
         9xFgzPQ3HsdLb7LQTQe+/qnsIrxlK0J/DeSqe6+0Sda7IIf/1oYwqUcc7HYX2tpJLMyI
         xCAdwkxyRYaFoRexbp79lkoWNtjEwVy8AH3Rc03PgIpx7V/IuLoTYboG4DY0zLPJ2+iQ
         qlI7gh3z2WKfbzCbRNA5rL5XgOP3ThjotzKdNe3PJBS4fezf1CB9FuPBhIyDJJyx+C2p
         /7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713202537; x=1713807337;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yND2zUfUi+v4q+Fs4T63lVmVArBJWibOzfGLa99Xn9w=;
        b=lA5IPzMBRucgtJTKCxuALZ/u3Rmhuxu/AimODy3e1heYLQnDtMtbAE62LcFn7WTjfh
         f64eB5NMu/u5JkoTjZYZ4vcB0SYn90v5ld1l41TxX41bggnlt3WuusiBQjc9PtwDh8uJ
         23GNwcGsEdAL3wfZhpGbpq2hb04xZPOnFW/XFqbWnVvonWDr3qonPJlvh4JFFvIaQhJ0
         ywWv8b96QWWISmVn9uHktffLo2ftzxS/nbYC7sd80faQbCLbbjn3sg7Oj8fjVE2uzXl3
         LRrDE7l02+QOShGB/MIzlZyRvCl9TZXPW2cEKpkwvHvFh/8NmBB4T1vKGwubBt9UJ93f
         v11w==
X-Forwarded-Encrypted: i=1; AJvYcCW+1ebhUs4LbpqqqEF5LvUXgaRis44eUC6Cpp0aIwP12Qh5KAPirmVVkQKq14fTrEj7Z00+rNI2f1tOz4nG8T9jGwGdo5BWg76vVUp+mpJ3ztlcD3DjfxdeflbFhNZ19bzMhImMZ+9KN58tcLD8u/rdGJRRMYPhWIye91VWGUur0v85xZrk4t+mIQuchsM52uawzsfu7KxU6o1B8z1CztMRCtEPCudWcZsLWmp1
X-Gm-Message-State: AOJu0Yws6C4neanW3YH9iIygAcri4vSuqC2Y8bDEU/LxIsLnRAbCJhB3
	iS2r77EznTPzeQTlMWueON1mCI6abT+iUqxfzAP3U/QNfRG1deKs
X-Google-Smtp-Source: AGHT+IG6NKLoYgtNA0zwWTzkP8WTGQd4qLXhWBTEEVWaqnnI2QLPzr1rMVeOMKwzxaqVx/1yQ3sSow==
X-Received: by 2002:a05:6a20:2590:b0:1a9:a31a:1b69 with SMTP id k16-20020a056a20259000b001a9a31a1b69mr13640576pzd.6.1713202537217;
        Mon, 15 Apr 2024 10:35:37 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id t6-20020a056a00138600b006ecef9e9615sm7456833pfg.200.2024.04.15.10.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 10:35:36 -0700 (PDT)
Date: Tue, 16 Apr 2024 01:35:31 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 04/17] lib min_heap: Add type safe interface
Message-ID: <Zh1lY8EFyE943+89@visitorckw-System-Product-Name>
References: <20240406164727.577914-1-visitorckw@gmail.com>
 <20240406164727.577914-5-visitorckw@gmail.com>
 <20240412073017.GE30852@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412073017.GE30852@noisy.programming.kicks-ass.net>

On Fri, Apr 12, 2024 at 09:30:17AM +0200, Peter Zijlstra wrote:
> On Sun, Apr 07, 2024 at 12:47:14AM +0800, Kuan-Wei Chiu wrote:
> 
> > -struct min_heap {
> > -	void *data;
> > -	int nr;
> > -	int size;
> > -};
> > +#define MIN_HEAP_PREALLOCATED(_type, _name, _nr)	\
> > +struct _name {	\
> > +	int nr;	\
> > +	int size;	\
> > +	_type *data;	\
> > +	_type preallocated[_nr];	\
> > +}
> 
> 
> > @@ -3738,7 +3739,7 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  	struct perf_cpu_context *cpuctx = NULL;
> >  	/* Space for per CPU and/or any CPU event iterators. */
> >  	struct perf_event *itrs[2];
> > -	struct min_heap event_heap;
> > +	struct perf_event_min_heap event_heap;
> >  	struct perf_event **evt;
> >  	int ret;
> >  
> > @@ -3747,11 +3748,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  
> >  	if (!ctx->task) {
> >  		cpuctx = this_cpu_ptr(&perf_cpu_context);
> > -		event_heap = (struct min_heap){
> > -			.data = cpuctx->heap,
> > -			.nr = 0,
> > -			.size = cpuctx->heap_size,
> > -		};
> > +		event_heap.data = cpuctx->heap;
> > +		event_heap.nr = 0;
> > +		event_heap.size = cpuctx->heap_size;
> >  
> >  		lockdep_assert_held(&cpuctx->ctx.lock);
> >  
> > @@ -3760,11 +3759,9 @@ static noinline int visit_groups_merge(struct perf_event_context *ctx,
> >  			css = &cpuctx->cgrp->css;
> >  #endif
> >  	} else {
> > -		event_heap = (struct min_heap){
> > -			.data = itrs,
> > -			.nr = 0,
> > -			.size = ARRAY_SIZE(itrs),
> > -		};
> > +		event_heap.data = itrs;
> > +		event_heap.nr = 0;
> > +		event_heap.size = ARRAY_SIZE(itrs);
> >  		/* Events not within a CPU context may be on any CPU. */
> >  		__heap_add(&event_heap, perf_event_groups_first(groups, -1, pmu, NULL));
> >  	}
> 
> Not too happy about these. If you ever add more fields they will go
> uninitialized. Why not keep the existing form and fix the struct name?

Sorry for the late reply. I'm traveling.
I'll change that back in v4.

Regards,
Kuan-Wei


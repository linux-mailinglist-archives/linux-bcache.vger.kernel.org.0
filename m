Return-Path: <linux-bcache+bounces-461-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE7E98C63A1
	for <lists+linux-bcache@lfdr.de>; Wed, 15 May 2024 11:26:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 702C31F237C6
	for <lists+linux-bcache@lfdr.de>; Wed, 15 May 2024 09:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7C057CBB;
	Wed, 15 May 2024 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmIo/tLI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF344D5AB;
	Wed, 15 May 2024 09:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715765161; cv=none; b=Nv7yL2ok5XnA8bCoQODROwhnWBHm0I6GIy+HKF3hDSpfwnpWC1g/xZ0bwCWTJEAWtLXxr5rdP4TGTt7xr/3KG3oChst2cv8sui/HzwkyLTLaOF4L2zYahGjaBpqB9FyQoI+sCqMV5LBMoN9ET5f4Fl/yoPoqzD+Zsf+zDn2FMug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715765161; c=relaxed/simple;
	bh=U537H0j/9PlQaC0LiL9fsVT4K5alZFkllM7ciYu/MeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C14nU+pTiDLxbj0/B8gV5PP/x9Q+ZBOPwS5Vr4IfKOHQG0OcBwxJLN4jBgM10WTT2RlUdjKtWM2faOuPY6w9+CvGReCb6ahsU9bbYsLZNJ8CXOuACvNe2Qe+dfhgKXdrvbjUWYzrspkVUWU4HWyjdwukEfxcozGSTQdEAgZaTWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmIo/tLI; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2b345894600so1470605a91.2;
        Wed, 15 May 2024 02:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715765160; x=1716369960; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OPKfNooZp8Km8QQjbs+4OOukYiKVYt2UrV4I2QW6i4c=;
        b=lmIo/tLIrvX2xWYXD60DzlGLY3GrSgRaVxAwdgCnj1P2IOWLCCbL6WN5vmuWBsk8fl
         Gi255OD2MpDqcIRBS+zV8140QQA5Af6SlyjjBuyl2piJgtC4nv8QdI5Mk7OKxl3KNkMo
         LJAJ6jfBAAAAv9h9vW7YsSukCQrOMxTCHlNEGRNsYN57nFqU0ndwAR5CuBw6HJiSbtn6
         XPIliY9mfAZmIzV5Z79jZ7eYOxEPzfX8RZgJFDaYXRVf5peUPqErcF+VnYgwYMIAUSmj
         V5MN6Rfu750gVP4w+pHw1BZedvMJNQHjwHwEOk1TNzQyMRzbqJDFPB+2yrM1WRdS+uCL
         lubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715765160; x=1716369960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPKfNooZp8Km8QQjbs+4OOukYiKVYt2UrV4I2QW6i4c=;
        b=vZft5pflapvwPnq0Swi9eNdWkg3DAOCB6fATvDoZ0cfFsabsMkuV8ESlBuNC0EGlrU
         R2jQ3iWiO51zdD50ltByVKQ4vafdaHm24DEx5Cci9XHiYDUDg+s3Zr7Ax37WPDbUU2pY
         EQcLziqi5XSu98WzVj78TMd0LFHLRbHSkY+Q03gNcbjAEydU2ImuYl1LLeCUjy91kpdg
         PVfop/PYyFGNbL6NDJ+mgOaLbyfs/ivu2t8B+9nZBd8or6LNdgdCrqmJHw+0NKI7RFOG
         Ky8nkk6DkG454fi89O8YneTi3dKP8te4UXwxM8wz1rCjAue7ZE2685ImqHsmLlSCE2Ts
         kwRw==
X-Forwarded-Encrypted: i=1; AJvYcCXNXcRof4Z7LSAY1c/x/MSIRjuUq0BHHpMEej2bdOx8PITbSBFsnCF9eiZYrK1rvRteEsEl2QItKLNUBuFhZlmzluQlLFsLo1vDhu+3Ah/Isynsjz794iP/rhr+fcBmBw4T0lcUkTW3LCqj3KVeP5dMcTMwGzLKCnVFV68zTH0kqnZPegzEkHo6l9X/lBEmht4Zmq1cS9bmTMlG2DpztmBxUs+Wzh8A9oRBKMuP
X-Gm-Message-State: AOJu0YwGtSNgb/jUa70xj0+8aknemstuov2hLB+9xpDgb9O8XR52LQko
	Jm4ukdlt06wmfp/0Nr0JMEBlkviXPEMGF3WRQdRVtwqymxiVZD1c
X-Google-Smtp-Source: AGHT+IF2x8/iHfJaxUooX4X3TGoGoXPwzr8yltF5Wclj64bedUjHLoWk82Et3XcILWR8yWtSNWfX5A==
X-Received: by 2002:a17:902:cec6:b0:1eb:ac3c:e39f with SMTP id d9443c01a7336-1ef441b5da6mr178395365ad.6.1715765159464;
        Wed, 15 May 2024 02:25:59 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d16dasm113812805ad.15.2024.05.15.02.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 02:25:58 -0700 (PDT)
Date: Wed, 15 May 2024 17:25:54 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <ZkR/ovACvPFqvFCv@visitorckw-System-Product-Name>
References: <20240514084724.557100-1-visitorckw@gmail.com>
 <20240514084724.557100-12-visitorckw@gmail.com>
 <20240515083755.GB40213@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515083755.GB40213@noisy.programming.kicks-ass.net>

On Wed, May 15, 2024 at 10:37:55AM +0200, Peter Zijlstra wrote:
> On Tue, May 14, 2024 at 04:47:19PM +0800, Kuan-Wei Chiu wrote:
> > Modify the min_heap_push() and min_heap_pop() to return a boolean
> > value. They now return false when the operation fails and true when it
> > succeeds.
> 
> But why ?!

When handling failures of push/pop operations, although we could
achieve the same effect by checking whether the heap is empty/full
before push/pop, we have already performed such checks within the
push/pop operations. Therefore, I believe directly using the result
of the check as the return value will make the code written by the user
more concise. This return value is used in subsequent patches for
replacing the heap macro in bcache and bcachefs to determine if an
error has occurred. The original heap macros in bcache and bcachefs
also do the same thing.

Regards,
Kuan-Wei
> 
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Reviewed-by: Ian Rogers <irogers@google.com>
> > ---
> >  include/linux/min_heap.h | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index c94f9d303205..2d080f85ad0d 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -147,18 +147,20 @@ void __min_heapify_all(min_heap_char *heap, size_t elem_size,
> >  
> >  /* Remove minimum element from the heap, O(log2(nr)). */
> >  static __always_inline
> > -void __min_heap_pop(min_heap_char *heap, size_t elem_size,
> > +bool __min_heap_pop(min_heap_char *heap, size_t elem_size,
> >  		const struct min_heap_callbacks *func, void *args)
> >  {
> >  	void *data = heap->data;
> >  
> >  	if (WARN_ONCE(heap->nr <= 0, "Popping an empty heap"))
> > -		return;
> > +		return false;
> >  
> >  	/* Place last element at the root (position 0) and then sift down. */
> >  	heap->nr--;
> >  	memcpy(data, data + (heap->nr * elem_size), elem_size);
> >  	__min_heapify(heap, 0, elem_size, func, args);
> > +
> > +	return true;
> >  }
> >  
> >  #define min_heap_pop(_heap, _func, _args)	\
> > @@ -184,7 +186,7 @@ void __min_heap_pop_push(min_heap_char *heap,
> >  
> >  /* Push an element on to the heap, O(log2(nr)). */
> >  static __always_inline
> > -void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> > +bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> >  		const struct min_heap_callbacks *func, void *args)
> >  {
> >  	void *data = heap->data;
> > @@ -192,7 +194,7 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> >  	int pos;
> >  
> >  	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
> > -		return;
> > +		return false;
> >  
> >  	/* Place at the end of data. */
> >  	pos = heap->nr;
> > @@ -207,6 +209,8 @@ void __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
> >  			break;
> >  		func->swp(parent, child, args);
> >  	}
> > +
> > +	return true;
> >  }
> >  
> >  #define min_heap_push(_heap, _element, _func, _args)	\
> > -- 
> > 2.34.1
> > 


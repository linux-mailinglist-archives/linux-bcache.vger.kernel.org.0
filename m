Return-Path: <linux-bcache+bounces-361-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86EFA8876A0
	for <lists+linux-bcache@lfdr.de>; Sat, 23 Mar 2024 03:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FA5828357A
	for <lists+linux-bcache@lfdr.de>; Sat, 23 Mar 2024 02:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D76EC2;
	Sat, 23 Mar 2024 02:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+zEOslN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5248B10E5;
	Sat, 23 Mar 2024 02:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711160350; cv=none; b=NYiQj8gI4xV8z6+pYoRnvj6hmJrxvub8xYzDsMpwmtJS0GSci8oHGrd/kkE4ucok3PxKglgqXRK2xCAPeqjxxAzXfKm+jwQfAdSG35MXiWlYMQPTBwrCa1P1/0Xf8r+ddDyuGWGkHaC4xRWd1X/fETpced9jk9psNNTQ8UyIrPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711160350; c=relaxed/simple;
	bh=gAMXekvrV6ZKXab4d1ERZxjVZVzrG9Fx8iCOxKUw+YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gotfj/Q/q4WKVZ6NlaRNjCJxiOQ8IHAbiHL7oPg1f0TwSy+A+IfsHB0klpMDe/2xlKskWO07PYjZV46OYP8z+JUbUlr8jFzfPDvGJnU5qmEoO1gcTdyeLCY1d1GU52/nb3WNefkOhIPR574D2EkmMVVmp4ooRLoUz1BJmits2Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+zEOslN; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-29d51cdde7eso724035a91.0;
        Fri, 22 Mar 2024 19:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711160349; x=1711765149; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5lTwxDxwY27GakzptqgwyUTb6+DEPiSueWO/uwZZ9+4=;
        b=C+zEOslNnm6aM7YMC99YoT6uF2/iREuNT+hqscIyM5x9bz+VMxZgU0/W3hMOrA9D2+
         89V2amEo5Fcr6SoUGVxxGDmDX5HIjRhSGF8TNm57pYRxI9FbWgpAyzynIQwpJlkuomXI
         n7BdyGcYg/cSjojqv+3QQVeNh+3BbPaf7bd6nMpObTSgeDv4Zzl5tVe2EUhcK4uw2ThC
         JbGZGlud6BEqhLm8yuAeMQHLhKHKO5ckxokH4YjQZrxY3VCdw7l8OL0J0oQ7P1mUg7wq
         xAbCI68SPjGc41RAOvoq0/MzMEcgDtDUMvJpjQK8lgO7jlWO/5aZMXGXY/vRwpEhhGPw
         TAkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711160349; x=1711765149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lTwxDxwY27GakzptqgwyUTb6+DEPiSueWO/uwZZ9+4=;
        b=qLK2ykKhdc28JDqjuRgp0hZEbbDMb9q+A8OrPLk4y3fv1cVOdVLRDh6LSWCeizdUTu
         BKM4DuLzAYJf3q1Yg6Gg7oyNdeQj1VNWsdMx5lFJ/gGWDRGmuz0X7pvJUBErAwoLR8Uu
         bLg8b0wOf8+7se0BIkHyV5vhMVaIBahNw9Sb97zW0qpDn5rLS6F90eDUVcJfs4isg39N
         dagaVc9ggRCGRFdjb+fxO+IX/NpV3j3GM+mAjkDyaY5ZbaRgReWcOqKWbbkbfaFx7zw1
         8BdkGygjPdwNNjXB5Hx/9BVWTVy/0rAKVOu66TANTUYITrvbUOl4DG2d3T9XXweerFWL
         YipQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAzvcnJzDCtkffqT3quLA/jx3ymP8u1iT37Hvtc/FMugVC18z2Q4r3qWWyHig5jjjV/rA47eGDCYcwX/sriwBSatFi17NaFJC5uRdYQd8mchFMqCDKdVEaFxhqK+mJ4jNSGsfT4LtzNMKfe9PK9MBXf72/qgu9ndDqh6rWLv/dgut4QRQe1C5i5S9AC8rnEQowIs/kEJQl7p8M1iZzubHiy4JAR8JvMndxetG0
X-Gm-Message-State: AOJu0YxRn4h0m8gJRRZVG4JUHW7qxurFN4HTPT2XtYQ3Iu2Ape9epMra
	8Jh+UNE5PQ7aMTyK92jbi849h5rYeAtJwem6OMnezHIrDfXzBJej
X-Google-Smtp-Source: AGHT+IEVpJlVSi/GN7Uznx+4tr5sLyoneciAh6D/p0FO9ZxEEi73L38a1h4zDmZ1l6dT85sXU176jA==
X-Received: by 2002:a05:6a00:2da5:b0:6ea:7ff6:31ed with SMTP id fb37-20020a056a002da500b006ea7ff631edmr1727001pfb.1.1711160348544;
        Fri, 22 Mar 2024 19:19:08 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id c13-20020a62f84d000000b006e6c81b6055sm435168pfm.6.2024.03.22.19.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 19:19:08 -0700 (PDT)
Date: Sat, 23 Mar 2024 10:19:03 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 04/15] lib min_heap: Add type safe interface
Message-ID: <Zf48FxpOo4/NZwk/@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
 <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
 <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>
 <Zf25pSI4p0d5pFXX@visitorckw-System-Product-Name>
 <gx3skkrp6pfp7ch3dmludzmqrsyncsptzhlvuwqt2abdhcli5m@xsny7x4nkxv3>
 <Zf42BA7EMCRI3hik@visitorckw-System-Product-Name>
 <ako4ddhjw4i7nt6mq54g4coeht4ksgwmoas3bdds2pzvfgqibc@ko3voxva75ge>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ako4ddhjw4i7nt6mq54g4coeht4ksgwmoas3bdds2pzvfgqibc@ko3voxva75ge>

On Fri, Mar 22, 2024 at 10:08:59PM -0400, Kent Overstreet wrote:
> On Sat, Mar 23, 2024 at 09:53:08AM +0800, Kuan-Wei Chiu wrote:
> > On Fri, Mar 22, 2024 at 02:23:26PM -0400, Kent Overstreet wrote:
> > > On Sat, Mar 23, 2024 at 01:02:29AM +0800, Kuan-Wei Chiu wrote:
> > > > On Thu, Mar 21, 2024 at 05:22:14PM -0400, Kent Overstreet wrote:
> > > > > On Thu, Mar 21, 2024 at 07:57:47PM +0800, Kuan-Wei Chiu wrote:
> > > > > > On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> > > > > > > On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > > > > > > > Introduce a type-safe interface for min_heap by adding small macro
> > > > > > > > wrappers around functions and using a 0-size array to store type
> > > > > > > > information. This enables the use of __minheap_cast and
> > > > > > > > __minheap_obj_size macros for type casting and obtaining element size.
> > > > > > > > The implementation draws inspiration from generic-radix-tree.h,
> > > > > > > > eliminating the need to pass element size in min_heap_callbacks.
> > > > > > > 
> > > > > > > let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> > > > > > > trick for that. All heaps have the same memory layout, so we can just
> > > > > > > cast to a void pointer heap to get something the C code can use.
> > > > > > >
> > > > > > If I understand correctly, you're suggesting adding APIs similar to
> > > > > > darray_top(), darray_first(), and darray_last() within min_heap and
> > > > > > having them return a pointer. However, some users are using heap.nr in
> > > > > > conditional statements instead of utilizing heap.nr for memory
> > > > > > operations, so returning pointers may not be as convenient. What about
> > > > > > adding get and set functions for nr instead?
> > > > > 
> > > > > No, I mean not having separate inner and outer types. Want me to sketch
> > > > > something out?
> > > > 
> > > > Based on your suggestion, I've come up with the following code snippet:
> > > > 
> > > > #define MIN_HEAP_PREALLOCATED(_type, _name, _nr) \
> > > > struct _name {  \
> > > >     int nr; \
> > > >     int size;   \
> > > >     _type *data;    \
> > > >     _type preallocated[_nr];    \
> > > > };
> > > > 
> > > > #define MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)
> > > > 
> > > > typdef MIN_HEAP(char, _) min_heap_char;
> > > > 
> > > > static __always_inline
> > > > void min_heap_init(min_heap_char *heap, void *data, int size)
> > > > {
> > > > 	heap->nr = 0;
> > > > 	heap->size = size;
> > > >     heap->data = size <= ARRAY_SIZE(heap->preallocated) ? heap->preallocated : data;
> > > > }
> > > > 
> > > > But I'm not sure how to implement other inline functions like
> > > > min_heap_push or min_heap_pop if I do that, unless they are rewritten
> > > > using macros. Also, I'm not sure how to make the less and swp functions
> > > > in the min_heap_callbacks not use void * type parameters. Or perhaps I
> > > > misunderstood your meaning again. If you could sketch out your idea or
> > > > have a better approach, it would be a great help to me. Any guidance
> > > > would be greatly appreciated.
> > > 
> > > No, you're on the right track. To call C functions on different types of
> > > heaps you have to cast them all to a common type, say HEAP(char), also
> > > pass the element size as a paremeter (which you had to do previously
> > > anyways).
> > 
> > The other question I want to ask is, I'm not sure how this relates to
> > avoiding the heap->heap.nr. In cases where we need to know the current
> > number of elements in the heap, don't we still need to use the same
> > method to determine the number of elements?
> 
> Yes, but this eliminates the nested types; so it's just heap->nr.
> 
> It's a pretty minor detail, cosmetic really, but I managed it in darray
> so it'd be nice to have here as well :)

Ah, got it. I'll make that change in v3.

Regards,
Kuan-Wei


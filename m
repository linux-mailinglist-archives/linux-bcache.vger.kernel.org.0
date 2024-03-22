Return-Path: <linux-bcache+bounces-358-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 882238872FD
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Mar 2024 19:23:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27E7A1F23275
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Mar 2024 18:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02DEE65BB9;
	Fri, 22 Mar 2024 18:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rn45MCTu"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E21B65BB3
	for <linux-bcache@vger.kernel.org>; Fri, 22 Mar 2024 18:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711131814; cv=none; b=UgvP44xia02NhAMcYLHu+b73R2SWmlhaFwyAbcDePQlu7uaWgQ3FD1/ci/ZneNO/D68K2QeLuqcac9EWtQTNOHaaCcMJzaBAxQ0rub2ZnWV0YrpXWPBPnpD5wuBLDGa+nmYK5h3Ymr1oM2mk6QiyAgP6NH8oF04cobU8BRDFn7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711131814; c=relaxed/simple;
	bh=40VVfM6/809+pYJgj2wzfEjVNEU0Bg0sahyBYokr3rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GkcaZAXHJywHx8R+FZlYT4ll0xK2G4QThGoxPhgDHKQhrQUrTdPC8Fzbr/qPg0CcAkVKVSWQJvMjT8Krtb6skBz6vczgkDxbm3iXkrCDikdwSPUeklsoESvAw0Vw3yYF/MfS7J5fgik0Mcwu8ZO7QpqO7QAGDUIpQGNPYMlpbtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rn45MCTu; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 22 Mar 2024 14:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711131811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HGAD06oDDixz/25yvLztOQXn8pWPlf8SP7amw2+5Ywg=;
	b=rn45MCTud1uEVpZzz9hgmmrzdwnqyZPa0nupO4gg+Qbf2//Ozo+YE4rOBPIR+OrlOyb4J9
	KKQxqH4RWXeS5pOhyk+/FblibwpYDe/DPpMOxRIax59Wu2wtT2bu7C9YHjW2fWxCE7M2wA
	x/Wd5P9nsmTnXr8zB9yZHQDt+9+I0A8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org, 
	bfoster@redhat.com, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 04/15] lib min_heap: Add type safe interface
Message-ID: <gx3skkrp6pfp7ch3dmludzmqrsyncsptzhlvuwqt2abdhcli5m@xsny7x4nkxv3>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
 <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
 <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>
 <Zf25pSI4p0d5pFXX@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf25pSI4p0d5pFXX@visitorckw-System-Product-Name>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 23, 2024 at 01:02:29AM +0800, Kuan-Wei Chiu wrote:
> On Thu, Mar 21, 2024 at 05:22:14PM -0400, Kent Overstreet wrote:
> > On Thu, Mar 21, 2024 at 07:57:47PM +0800, Kuan-Wei Chiu wrote:
> > > On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> > > > On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > > > > Introduce a type-safe interface for min_heap by adding small macro
> > > > > wrappers around functions and using a 0-size array to store type
> > > > > information. This enables the use of __minheap_cast and
> > > > > __minheap_obj_size macros for type casting and obtaining element size.
> > > > > The implementation draws inspiration from generic-radix-tree.h,
> > > > > eliminating the need to pass element size in min_heap_callbacks.
> > > > 
> > > > let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> > > > trick for that. All heaps have the same memory layout, so we can just
> > > > cast to a void pointer heap to get something the C code can use.
> > > >
> > > If I understand correctly, you're suggesting adding APIs similar to
> > > darray_top(), darray_first(), and darray_last() within min_heap and
> > > having them return a pointer. However, some users are using heap.nr in
> > > conditional statements instead of utilizing heap.nr for memory
> > > operations, so returning pointers may not be as convenient. What about
> > > adding get and set functions for nr instead?
> > 
> > No, I mean not having separate inner and outer types. Want me to sketch
> > something out?
> 
> Based on your suggestion, I've come up with the following code snippet:
> 
> #define MIN_HEAP_PREALLOCATED(_type, _name, _nr) \
> struct _name {  \
>     int nr; \
>     int size;   \
>     _type *data;    \
>     _type preallocated[_nr];    \
> };
> 
> #define MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)
> 
> typdef MIN_HEAP(char, _) min_heap_char;
> 
> static __always_inline
> void min_heap_init(min_heap_char *heap, void *data, int size)
> {
> 	heap->nr = 0;
> 	heap->size = size;
>     heap->data = size <= ARRAY_SIZE(heap->preallocated) ? heap->preallocated : data;
> }
> 
> But I'm not sure how to implement other inline functions like
> min_heap_push or min_heap_pop if I do that, unless they are rewritten
> using macros. Also, I'm not sure how to make the less and swp functions
> in the min_heap_callbacks not use void * type parameters. Or perhaps I
> misunderstood your meaning again. If you could sketch out your idea or
> have a better approach, it would be a great help to me. Any guidance
> would be greatly appreciated.

No, you're on the right track. To call C functions on different types of
heaps you have to cast them all to a common type, say HEAP(char), also
pass the element size as a paremeter (which you had to do previously
anyways).


Return-Path: <linux-bcache+bounces-356-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4790488627A
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 22:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98C70B21630
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 21:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BA21353EC;
	Thu, 21 Mar 2024 21:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KXyqdB/5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6DB135A5F
	for <linux-bcache@vger.kernel.org>; Thu, 21 Mar 2024 21:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711056143; cv=none; b=EU9BRPgM1bUwczKEGd+htf9x1vs5K4nq1M5MgDCgI5ijnv8tBHsQizb/qJ9eZZ34TgB1yOufRJB+lc3/bOTtIZqWZYiyfbFfnidZ1U5I5O5u20MgTB0lqbJ4VY8JDbMpR3AgUSiXqQ/c8fFBLwjyLND4pvFCSO3izQmyKjjfjO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711056143; c=relaxed/simple;
	bh=Anq4NcuB/lwgoTXLF75lThmEeR+MuCgA6bicmSCWtE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atOXxiBVElGY0R+/CFOLB/QoX+F5204Q0moOQdDPsmVzIMYaTsa9J5NHYI57q6rZHYQsJBd4WSgMpB+mb5uEYINQSOIR9sXauIsTzouK2DLQ6JoPGCOflT+xSbQk7+0JZxSr6RT7IA2icopDJ0NiSgZmsTCefVP6Ojn3n76CxwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KXyqdB/5; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 21 Mar 2024 17:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711056139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S05qIGXtD9xW8hBhYLVEJF2bePesL9LF4WflE+oBdCA=;
	b=KXyqdB/5x6fm8sKDy7Wx6c1+9/aaeEK0c6jkGhTWGiLB9kU+pA76QZmr1Kf9DTr66Dc60G
	fB2C5gKBmUG3J3KTzZLaNkFSoCZTsVYWkK9kLZLejwfJhbprlY/Qz7wCVcISG86ycSSRRM
	37QJ0vm12wWgJX97hIfyhbDmoQVqYJg=
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
Message-ID: <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
 <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 21, 2024 at 07:57:47PM +0800, Kuan-Wei Chiu wrote:
> On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> > On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > > Introduce a type-safe interface for min_heap by adding small macro
> > > wrappers around functions and using a 0-size array to store type
> > > information. This enables the use of __minheap_cast and
> > > __minheap_obj_size macros for type casting and obtaining element size.
> > > The implementation draws inspiration from generic-radix-tree.h,
> > > eliminating the need to pass element size in min_heap_callbacks.
> > 
> > let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> > trick for that. All heaps have the same memory layout, so we can just
> > cast to a void pointer heap to get something the C code can use.
> >
> If I understand correctly, you're suggesting adding APIs similar to
> darray_top(), darray_first(), and darray_last() within min_heap and
> having them return a pointer. However, some users are using heap.nr in
> conditional statements instead of utilizing heap.nr for memory
> operations, so returning pointers may not be as convenient. What about
> adding get and set functions for nr instead?

No, I mean not having separate inner and outer types. Want me to sketch
something out?


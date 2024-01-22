Return-Path: <linux-bcache+bounces-242-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E40836CE4
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jan 2024 18:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A770BB347EB
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jan 2024 17:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B6C657C8;
	Mon, 22 Jan 2024 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uGXmZNt2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9AA657BD
	for <linux-bcache@vger.kernel.org>; Mon, 22 Jan 2024 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705939607; cv=none; b=Q7fVQa5xHjsQQ9zf3IgZc1v+wyrsVNnaGScCPoZUq9KsGcREhqrNfrclBB3ldVzOQrCmvnP0r9T5r6FYo+ExElTUlBKxe66SDzSq6KGIg5HC8cEvR2yDrzPKM4yNf9cO1xtCikBirDfe04t7IaBYmt8n4nnDdBJSLPHYRgy2UR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705939607; c=relaxed/simple;
	bh=fsmtq2XF8bbAr6rNw2kj7QtYSt4c9bDE/aZE2TVghmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtbgkihoeN1Qn2/i51l/rFSBz8hAE580/KYZ8CMVz3veLYMRBzt4TcHhkw96B5f+tGk7o6d5MWfX7HAWINpJLCjTNTVIDz54+xQyMwX7GTKLVAAz6VR6MletORPFiY6Pr5R2U+ApELSnXopLngAXoPCinigZeF/Q9XBXis5JtW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uGXmZNt2; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Jan 2024 11:06:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705939602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=55SCyM8CEbCM9qBiiJ38WDhwyohhGRMvyGZuunU3L6U=;
	b=uGXmZNt2uUm+IaoPPbYv6wnl01a+haxm2bkGN0EhzSumcgRoACV/fmma7oNeW9V49ceyMA
	8pHpHtR1I0PLvtFfmVlDlr/mQDU+osZtvXyyfGrWLGopCx0vhxGFBnc7sQPAie2waB++Is
	4ZDqikiFimgmbYabsvGMEJtowwtFqY4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize number of comparisons for heap/heapsort
 implementaion
Message-ID: <zwcm35flig23fttyybenorsu27ki3dsurqjkjxhrlbnk5zg3n7@vmagssufbuy2>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>
 <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
 <ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu>
 <Za6EjshZWFUPLJef@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za6EjshZWFUPLJef@visitorckw-System-Product-Name>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 22, 2024 at 11:06:54PM +0800, Kuan-Wei Chiu wrote:
> On Sun, Jan 21, 2024 at 12:41:55PM -0500, Kent Overstreet wrote:
> > On Mon, Jan 22, 2024 at 12:55:51AM +0800, Kuan-Wei Chiu wrote:
> > > On Sun, Jan 21, 2024 at 11:21:06AM -0500, Kent Overstreet wrote:
> > > > On Sun, Jan 21, 2024 at 11:36:44PM +0800, Kuan-Wei Chiu wrote:
> > > > > Hello,
> > > > > 
> > > > > The existing implementations of heap/heapsort follow the conventional
> > > > > textbook approach, where each heapify operation requires approximately
> > > > > 2*log2(n) comparisons. In this series, I introduce a bottom-up variant
> > > > > that reduces the number of comparisons during heapify operations to
> > > > > approximately log2(n), while maintaining the same number of swap
> > > > > operations.
> > > > > 
> > > > > Thanks,
> > > > > Kuan-Wei
> > > > > 
> > > > > Kuan-Wei Chiu (5):
> > > > >   bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
> > > > >   bcachefs: Introduce parent function for sort_cmp_size()
> > > > >   bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
> > > > >   bcachefs: Optimize number of comparisons in heap_sift_down
> > > > >   bcache: Optimize number of comparisons in heap_sift
> > > > > 
> > > > >  drivers/md/bcache/util.h |  23 +++++----
> > > > >  fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
> > > > >  fs/bcachefs/util.h       |  23 +++++----
> > > > >  3 files changed, 98 insertions(+), 57 deletions(-)
> > > > 
> > > > Good stuff
> > > > 
> > > > While we're looking at this code, we should be doing some cleanup too -
> > > > there's no reason for the heap code to be duplicated in bcache and
> > > > bcachefs anymore, and it'd also be nice to get fs/bcachefs/eytzinger.h
> > > > moved to include/linux and bcache converted to use it.
> > > > 
> > > > I also would not be surprised if there's another heap implementation in
> > > > include/linux; we'll want to check for that and if there is decide which
> > > > is worth keeping.
> > > >
> > > Yes, we have 'min_heap.h' in include/linux.
> > 
> > So that has the advantage of more readable code - functions instead of
> > macros - whereas my version has the type safe interface.
> > 
> > We could combine the two approaches, and put a type-safe interface on
> > top of the min_heap.h code with some small macro wrappers - see
> > generic-radix-tree.h for an example of how that's done.
> 
> Without modifying the interface provided by min_heap.h, it seems
> challenging to implement the functionality of heap_add due to the
> relationship with heap_setbackpointer.

min_heap.h has the same functionality, different interface - updating
the callers for an interface change is fine.

> 
> Additionally, when looking into the code in generic-radix-tree.h,
> should we replace type[0] with type[]? This is because zero-length
> arrays are deprecated language features mentioned in document [1].

Zero length arrays are deprecated as VLAs, but this isn't a VLA - we're
not storing anything there, the variable is just so that macros have
access to the type.

> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
> > 
> > min_heap.h has only one user though? I don't think I can quite believe
> > that's the only other code in the kernel using a heap, there must be
> > more open coded out there...
> 
> I'm not sure why, but it seems that in the kernel, other places using
> the heap implement their own subsystem-specific solutions rather than
> utilizing a generic heap interface. For instance,
> kernel/sched/cpudeadline.c and net/sched/sch_cake.c both have their own
> implementations.

Sounds like a fun cleanup project :)


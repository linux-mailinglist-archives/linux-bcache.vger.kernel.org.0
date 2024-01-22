Return-Path: <linux-bcache+bounces-241-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D918F8368E5
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jan 2024 16:49:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 437AB1F23CB9
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jan 2024 15:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927746D1A7;
	Mon, 22 Jan 2024 15:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCO8JNh+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B719495D9;
	Mon, 22 Jan 2024 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705936020; cv=none; b=LzRYYQK2+VunwFDw6La6wxfmfUGVeSbfi7OYD/8Rju0tjPu5UWux3wuP1njvyGtVQq67kkZbtPz4Wt7aOA4281rhN7uxaEr56oKATOncOixDE9pirhbPRouPVtnrxXRybdkOWjkVCPRVZBb/s3HhbW4uyGS28JQ2a2aS3k2U+kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705936020; c=relaxed/simple;
	bh=4UjfoZOWKhz9CUcE2OAu1F/mEKNnn+MN6pIwNPWP0kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJTz7LG5Z7SPibbTDRNnIsPrAXSP9I8aQZpWTjLguI59B0gIZFK2uFW6EZhi29khyXTTgq0kIE++UxNaStPaHW6CrqpxQaXyZWbk/KfRo4M66AtXKYjCNS4VOBhRIdZK0j38YPt+18VpqFtmAKskXcICuWoHmI/HuPEX9NjQrf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCO8JNh+; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d7517fe9d4so836105ad.0;
        Mon, 22 Jan 2024 07:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705936018; x=1706540818; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pB8swrgfuo82HJIoA7WtzOzLJAOPh3SgeZ4ldwd4D6U=;
        b=DCO8JNh+kOCXQkxFVcIdv8AcW4E/R8N5fKeFvWpNMb+7COl2LdAgDEXLWoZYn9hdQB
         I1TTWhw/23Uh5CvgsXZH6Fbd/P4FIylo4IH0wJS5vxvsyNwICHtrpzu5Dex4gQ6nzWpc
         BhgB5CPJl3OLZqIH8Eyhhh3DNT2uP1HHtGNiq0vjdndC9xhgwdE4uqo/qIs8ZuTqSbYV
         tQqo9WQERPxePqEhTwdhAgLV0+dcnutFDUWh2CraCjnPWCrrtkHe3fJ026G6qfr9Hx/a
         /ZGFM2AYQwPJpz4NzOAqg+MfG8ocONBSTD6mQmowPZS3/TVVBY6n2Q5CNEi+RfIicdzf
         xDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705936018; x=1706540818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pB8swrgfuo82HJIoA7WtzOzLJAOPh3SgeZ4ldwd4D6U=;
        b=L8yVn5/VjB7kLjt4jxyODeAFodMFAsMpnKslNcSuX/uYikvETGz9WRS01CCiJCi1jv
         dtTK+3lLbNo1qBrz7SkrEN12ST/6A1xiwc971hmXgVuwACZfEEVDDtnC4IGKSA2aNG6f
         4Btkmc6LhPlp/VYLqDfm/TSpehnYBo2zIUTEs31E/9OuxNWfWD/wY9HZoafscjGDVCRr
         s029z9wAOEf+CXzbc6II9t9rgN/SqlsUtU175l/sEnExIAIWDjQAP4ltNaY0gHXkZWHo
         lUQDPk7C3Ar1O2rQbNMS5InXa2swgS+DTnB2Q9jXCl+rT6vKuwOkCC4NAdCW2jD1nNt/
         ucxg==
X-Gm-Message-State: AOJu0Yz20wVZuVHul23rDwmjfsXs8kXgd0FXq4HAS0mdS1s4mcPXxGjO
	x9R3HBRIuzLXy+D/0bV7eTuskz8Tg4My+q4xRMLP7zSYFEFIhRnq
X-Google-Smtp-Source: AGHT+IHqAgflk104ZbHizf63K/+tBR8ze0aFA/FPCHNIZ4lPx6NazJ9AFhqEO6Jbnej/ZCpb1JDW9g==
X-Received: by 2002:a17:903:54a:b0:1d5:f667:10a1 with SMTP id jo10-20020a170903054a00b001d5f66710a1mr8439165plb.6.1705936018228;
        Mon, 22 Jan 2024 07:06:58 -0800 (PST)
Received: from visitorckw-System-Product-Name (IP-216-168.cs.nctu.edu.tw. [140.113.216.168])
        by smtp.gmail.com with ESMTPSA id t1-20020a1709028c8100b001d7505a6894sm2020913plo.230.2024.01.22.07.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 07:06:57 -0800 (PST)
Date: Mon, 22 Jan 2024 23:06:54 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize number of comparisons for heap/heapsort
 implementaion
Message-ID: <Za6EjshZWFUPLJef@visitorckw-System-Product-Name>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>
 <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
 <ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu>

On Sun, Jan 21, 2024 at 12:41:55PM -0500, Kent Overstreet wrote:
> On Mon, Jan 22, 2024 at 12:55:51AM +0800, Kuan-Wei Chiu wrote:
> > On Sun, Jan 21, 2024 at 11:21:06AM -0500, Kent Overstreet wrote:
> > > On Sun, Jan 21, 2024 at 11:36:44PM +0800, Kuan-Wei Chiu wrote:
> > > > Hello,
> > > > 
> > > > The existing implementations of heap/heapsort follow the conventional
> > > > textbook approach, where each heapify operation requires approximately
> > > > 2*log2(n) comparisons. In this series, I introduce a bottom-up variant
> > > > that reduces the number of comparisons during heapify operations to
> > > > approximately log2(n), while maintaining the same number of swap
> > > > operations.
> > > > 
> > > > Thanks,
> > > > Kuan-Wei
> > > > 
> > > > Kuan-Wei Chiu (5):
> > > >   bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
> > > >   bcachefs: Introduce parent function for sort_cmp_size()
> > > >   bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
> > > >   bcachefs: Optimize number of comparisons in heap_sift_down
> > > >   bcache: Optimize number of comparisons in heap_sift
> > > > 
> > > >  drivers/md/bcache/util.h |  23 +++++----
> > > >  fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
> > > >  fs/bcachefs/util.h       |  23 +++++----
> > > >  3 files changed, 98 insertions(+), 57 deletions(-)
> > > 
> > > Good stuff
> > > 
> > > While we're looking at this code, we should be doing some cleanup too -
> > > there's no reason for the heap code to be duplicated in bcache and
> > > bcachefs anymore, and it'd also be nice to get fs/bcachefs/eytzinger.h
> > > moved to include/linux and bcache converted to use it.
> > > 
> > > I also would not be surprised if there's another heap implementation in
> > > include/linux; we'll want to check for that and if there is decide which
> > > is worth keeping.
> > >
> > Yes, we have 'min_heap.h' in include/linux.
> 
> So that has the advantage of more readable code - functions instead of
> macros - whereas my version has the type safe interface.
> 
> We could combine the two approaches, and put a type-safe interface on
> top of the min_heap.h code with some small macro wrappers - see
> generic-radix-tree.h for an example of how that's done.

Without modifying the interface provided by min_heap.h, it seems
challenging to implement the functionality of heap_add due to the
relationship with heap_setbackpointer.

Additionally, when looking into the code in generic-radix-tree.h,
should we replace type[0] with type[]? This is because zero-length
arrays are deprecated language features mentioned in document [1].

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
> 
> min_heap.h has only one user though? I don't think I can quite believe
> that's the only other code in the kernel using a heap, there must be
> more open coded out there...

I'm not sure why, but it seems that in the kernel, other places using
the heap implement their own subsystem-specific solutions rather than
utilizing a generic heap interface. For instance,
kernel/sched/cpudeadline.c and net/sched/sch_cake.c both have their own
implementations.


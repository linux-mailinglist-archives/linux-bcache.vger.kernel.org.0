Return-Path: <linux-bcache+bounces-320-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D401880727
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 23:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE6321F22E42
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 22:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DE94F5E6;
	Tue, 19 Mar 2024 22:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tvKCpo8r"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E465F86E
	for <linux-bcache@vger.kernel.org>; Tue, 19 Mar 2024 22:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710886347; cv=none; b=sqx/PIRvNyB/V6tTz3q3JSPdn6Qd3Eo0lD7yiG5jj+kSDdt3AbvEGqDPNhDWc/g3fW4+K6K4rQ1zLnmsr9IfeuX4dqEANO/x1zRTzgRoiaQuUhKV++GHsG1+OPLfGHwFjpxAyw0RXAE8p+bBNShH+XAeVOffsnKmbVI+GokVE3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710886347; c=relaxed/simple;
	bh=FSpXGTTyVcFLmOBYzG68wQp9qZCfjPDZWoIzafxsexY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVN/j9ZZCYcJmXCik1kO+nMrcvTjunrYXlC+gk7qh8z3yyz5RlVMsbOHGV0eD//P8xH0vx/71WQGT5y/yrpA0pn6CZZTOpUk3mvI8DzMPEtVA/9vyk2aEjrQFpzAFg/TnzVvC7G/JUQ+0GY/RKVmuWCH9I4dWSbs4/i5qST/eiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tvKCpo8r; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 19 Mar 2024 18:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710886342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHwWUj98l5L/yUkAsvEJGLxMWq5ZltzecbPLlxTRTAE=;
	b=tvKCpo8ruu978e0ft9bxNb7vjIwS7F5eiZdqRWl4ERqglw7xu6OCOFCp33AoWTP3aDM8nN
	fztlSwH0Fg+RK/ajUVdHbb46irQ6Rf9lS8Cb6SwSkgq1t3J6zu1bjyiPwa9tULiSYiHL9v
	FLnbpGwUVRYQ+9WAvnZa/DGd++zZAAA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org, 
	bfoster@redhat.com, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] treewide: Refactor heap related implementation
Message-ID: <4t6kkvswhacphbjloh3fps7twqp5d3wgxv7yrkvthb5u3uzaoe@6pf7mnvsv3rm>
References: <20240319180005.246930-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 01:59:52AM +0800, Kuan-Wei Chiu wrote:
> Hello,
> 
> This patch series focuses on several adjustments related to heap
> implementation. Firstly, a type-safe interface has been added to the
> min_heap, along with the introduction of several new functions to
> enhance its functionality. Additionally, the heap implementation for
> bcache and bcachefs has been replaced with the generic min_heap
> implementation from include/linux. Furthermore, several typos have been
> corrected.
> 
> Previous discussion with Kent Overstreet:
> https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu

Hey, thanks for doing this. Can you post a git repo link? I'll point my
CI at it.

> 
> Regards,
> Kuan-Wei
> 
> Kuan-Wei Chiu (13):
>   perf/core: Fix several typos
>   bcache: Fix typo
>   bcachefs: Fix typo
>   lib min_heap: Add type safe interface
>   lib min_heap: Add min_heap_init()
>   lib min_heap: Add min_heap_peek()
>   lib min_heap: Add min_heap_full()
>   lib min_heap: Add args for min_heap_callbacks
>   lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
>     values
>   bcache: Remove heap-related macros and switch to generic min_heap
>   lib min_heap: Add min_heap_del()
>   lib min_heap: Add min_heap_sift_up()
>   bcachefs: Remove heap-related macros and switch to generic min_heap
> 
>  drivers/md/bcache/alloc.c      |  66 ++++++++----
>  drivers/md/bcache/bcache.h     |   2 +-
>  drivers/md/bcache/bset.c       |  73 ++++++++-----
>  drivers/md/bcache/bset.h       |  38 ++++---
>  drivers/md/bcache/btree.c      |  27 ++++-
>  drivers/md/bcache/extents.c    |  44 ++++----
>  drivers/md/bcache/movinggc.c   |  40 ++++++--
>  drivers/md/bcache/super.c      |  16 +++
>  drivers/md/bcache/sysfs.c      |   3 +
>  drivers/md/bcache/util.c       |   2 +-
>  drivers/md/bcache/util.h       |  81 +--------------
>  drivers/md/dm-vdo/repair.c     |  29 +++---
>  drivers/md/dm-vdo/slab-depot.c |  21 ++--
>  fs/bcachefs/clock.c            |  53 +++++++---
>  fs/bcachefs/clock_types.h      |   2 +-
>  fs/bcachefs/ec.c               |  99 +++++++++++-------
>  fs/bcachefs/ec_types.h         |   2 +-
>  fs/bcachefs/util.c             |   2 +-
>  fs/bcachefs/util.h             | 127 ++---------------------
>  include/linux/min_heap.h       | 180 ++++++++++++++++++++++++++-------
>  kernel/events/core.c           |  53 +++++-----
>  lib/test_min_heap.c            |  75 +++++++-------
>  22 files changed, 565 insertions(+), 470 deletions(-)
> 
> -- 
> 2.34.1
> 


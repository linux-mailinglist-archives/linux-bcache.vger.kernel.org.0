Return-Path: <linux-bcache+bounces-403-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B3418AD5C4
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Apr 2024 22:20:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCC811C20E51
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Apr 2024 20:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E95155721;
	Mon, 22 Apr 2024 20:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uQePScF2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EA71553AE
	for <linux-bcache@vger.kernel.org>; Mon, 22 Apr 2024 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713817237; cv=none; b=HubZfW+vZvc96Lp+vhiyWTzTkOooia5Hh+3QX57tQN6Ijf5EV3cXBT//08lFAtHHidtoWXvVOVxucpp/vLbYg4ueFtdyzcF+6LCG0bVf6SB1Uz0gWUQGfp/ZGYmj5gKxc77kCeAIkcGQpm1JM4SK2gmVuIT0V89cwXfY2iMlbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713817237; c=relaxed/simple;
	bh=tB4j3Mp1cAbAPzA7/QjfWJaHulMX9TPibSa9gTEbIbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HsLE7XY21ZfhlBMVGjhYFA5Q3j+YR0Ew5XG8h55xXxVDtbnoAF9qJ+c8rK85tRBlX4+xWlCdRLhHRHrqnp8aeIFttcGH1cpqi7ThXSWbXoDduElzq88sDGSL7SKPUeqY2tNnlK7G/Ib7nPSs4TvOzEeWAdWQi6ss4tNC2Os/BB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uQePScF2; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 22 Apr 2024 16:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713817234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5RG8Ru3lhWn45ANoWDq3cq77hbBwMzq6GTS3tURq8Wo=;
	b=uQePScF2xaCNayfHvN64HjSAdSMcLDdhKvjoFTZmqhwGG2g0Jkx6fWZ1g964VvWbejPnhE
	chFx2UEJnZNQMFh4stRdMHwcs2VFVtMhpsm5n/5T9QrwMT3PoHsG+USG/ZgoQokZ4pEk/r
	Pr7mR4uih1x7UhF4jRH5+kHb2m4YPVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org, 
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org, 
	bfoster@redhat.com, mark.rutland@arm.com, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 00/17] treewide: Refactor heap related implementation
Message-ID: <asgiyolfhg2sfwarkrexbcx3y6mborcxklnncz4cn2g6ffubku@vhoumzvwdpzp>
References: <20240406164727.577914-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 07, 2024 at 12:47:10AM +0800, Kuan-Wei Chiu wrote:
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
> 
> Regards,
> Kuan-Wei

We need to get this into -next, where are you at with v4?


Return-Path: <linux-bcache+bounces-752-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D83D499BD44
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 03:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 164D61C2150E
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 01:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21125171BB;
	Mon, 14 Oct 2024 01:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uk2F6Ajb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422CADDD9;
	Mon, 14 Oct 2024 01:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728869037; cv=none; b=joz1Fd5Ql7X9sMXi1G/WUOwhtG95g0NDyIj6/dHtTftRzIq1oYDArxaJfTIAVlio5xaEQtjws2uw8yJDTIbWMbW8huCqjUG/sMrJKOkzwQqaIxuMTiQi1K2S+DGRCGzXzMpxoAmx0LlpPVxpDshEhFANtsDYx1J6og6rHWsfJRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728869037; c=relaxed/simple;
	bh=s3R31T+SRgLrDrlJOvoWAA/+i0h1hN410H/EfmuSzZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6KWvqXRF3p2sFGK33HGkJS0i6QgXw0OMFB2qJI6th47AAcl8OgW1wprx251iCyCgLdlyZyo9WH4lM3/5lN3/I3kyParOMNt2mjqjhcdvs+yw6IgNYiLCqe8pQ5o61YZKFQqHdMi+IMCGmnzGm/ZkW4tEPpnn7CxqTIhTVUMRPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uk2F6Ajb; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 13 Oct 2024 21:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728869027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RNUnSGn+eCIsw8VlyKUwayAn2ge3BmlHxZjdPl5f8cs=;
	b=uk2F6AjbF5dUpTYpQyzToGAVZ+qhCYUMfcafExPTWuz92rYUFr19EStdIDGvwAZ96lJKWO
	uQfNf5ZIJRldB/B7UnBPyGsd0cDF1A2qE13g0NYGOK0oZKpvv64W/a6CYpp3fn97FcMLIE
	jsZT2M8EX4w4c+yuqPxMZU6V+lDxSoI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Coly Li <colyli@suse.de>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, msakai@redhat.com, 
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com, acme@kernel.org, 
	namhyung@kernel.org, akpm@linux-foundation.org, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] Enhance min heap API with non-inline functions and
 optimizations
Message-ID: <zzpz6gpcxrk67wgyx5wkophdpvsv32nyfbn5ywdifmoe6tn5um@tzg44lbnjskk>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>
 <D65079CE-3DFF-4FC2-B18D-DD54A5563878@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D65079CE-3DFF-4FC2-B18D-DD54A5563878@suse.de>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 14, 2024 at 09:18:33AM GMT, Coly Li wrote:
> 
> 
> > 2024年10月14日 07:05，Kent Overstreet <kent.overstreet@linux.dev> 写道：
> > 
> > On Mon, Oct 14, 2024 at 02:47:00AM GMT, Kuan-Wei Chiu wrote:
> >> Add non-inline versions of the min heap API functions in lib/min_heap.c
> >> and updates all users outside of kernel/events/core.c to use these
> >> non-inline versions. Additionally, it micro-optimizes the efficiency of
> >> the min heap by pre-scaling the counter, following the same approach as
> >> in lib/sort.c. Documentation for the min heap API has also been added
> >> to the core-api section.
> > 
> > Nice, has it been tested - do you need a CI account?
> > 
> > I'd like to start seeing links to CI results in patch postings (and I
> > need to tweak the CI to add git fetch links, as well).
> > 
> > Coly, there's ktest tests for bcache that need to be updated - if you
> > wanted to take that on it'd be lovely to consolidate how our subsystems
> > are getting tested; I can give you a CI account as well.
> 
> Yes, please do. And let me take a look at the test cases for bcache part.

Send me the username you want and your ssh pubkey

bcache tests are here:
https://evilpiepirate.org/git/ktest.git/tree/tests/bcache

they are _old_, and need a lot of updating - you'll probably want to hit
me up on IRC


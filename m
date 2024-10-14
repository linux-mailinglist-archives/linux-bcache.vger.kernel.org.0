Return-Path: <linux-bcache+bounces-754-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F4E99C2B9
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 10:14:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 256B5B20EE6
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 08:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1CC514F118;
	Mon, 14 Oct 2024 08:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ceH6GsK0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0312C14AD2E;
	Mon, 14 Oct 2024 08:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893651; cv=none; b=qEcXD+BmQJQNHL0hUV9WDEzYhJcW6eit4iS5ZZiEXa+31HyKVxwXMgm/SGeaUqsGcqSBKMP7Fs9jWm70GGV+gyZZvqZCVesdR4ad7gUSEywibPXbc04+wspP+IEKioaL/zP/Y1sHGI1bkY5U4hNg1pi1bsvWFRloVqcSIPUQ9mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893651; c=relaxed/simple;
	bh=EKD07Qj6JcVqClDp8w5hX4Ow8T50FvUf1cSyUeXs/8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c45AFVKCq7T+Nwk7sDDdi6aFa/C5IEwBLJeztYWvZKV6QIsp/fa3qvSiPHosWXM0ipWl4rcP+az0CQNHQFOi5XLLO7/sFBO3Zy4GTLh14Wdbx6M2ZXC+G55U1kolLj2cwHSM3TNOzSO/zoeONGAjIvPbqoV9byYxH3PyVG107FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ceH6GsK0; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Wk8EcJ/7b4OEG+IFikYEtXUWa6XJYMvqVFBhG68Lv7Q=; b=ceH6GsK0E6q43xq2xtT81K5DtF
	3Nv2eWGdf1mapppB0kDWQVaJ2UaTYBDWU2VnALi+jCZfOvEhbOubKwj/k5GWwIl5Z/L5pVgoLCA2v
	fl1ZNnPuY4jH12qm20XvZgXEFuKOj55yxd5DeypDIOTvRr2DLZhLuYgojbFs3ZWKwj8I9vsjhh9Yz
	t4rN/M1l8bCR4Lb49UiBA46djQowVK5t4LppB3HjTqDLEdGvZA82l15S8xI8ainkw+9UBJvjsk37Z
	19vllUQfPQ48dNNu2iJMCGmfvBPSlWj5GdivVduMjfRslZoROENMKpnk4b64wT3K3Bi9ieN16NbUp
	GeSC4EKw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GDG-000000012qw-0aZ2;
	Mon, 14 Oct 2024 08:13:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1C7BB300777; Mon, 14 Oct 2024 10:13:58 +0200 (CEST)
Date: Mon, 14 Oct 2024 10:13:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <20241014081358.GS17263@noisy.programming.kicks-ass.net>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013184703.659652-2-visitorckw@gmail.com>

On Mon, Oct 14, 2024 at 02:47:01AM +0800, Kuan-Wei Chiu wrote:
> All current min heap API functions are marked with '__always_inline'.
> However, as the number of users increases, inlining these functions
> everywhere leads to a significant increase in kernel size.
> 
> In performance-critical paths, such as when perf events are enabled and
> min heap functions are called on every context switch, it is important
> to retain the inline versions for optimal performance. To balance this,
> the original inline functions are kept, and additional non-inline
> versions of the functions have been added in lib/min_heap.c.

The reason it is all __always_inline is because then the whole
min_heap_callbacks thing can be constant propagated and the func->less()
etc calls become direct calls.

Doing out of line for this stuff, makes them indirect calls, and
indirect calls are super retarded expensive ever since spectre. But also
things like kCFI add significant cost to indirect calls.

Something that would be a trivial subtract instruction becomes this
giant mess of an indirect function call.

Given the whole min_heap thing is basically a ton of less() and swp()
calls, I really don't think this trade off makes any kind of sense.


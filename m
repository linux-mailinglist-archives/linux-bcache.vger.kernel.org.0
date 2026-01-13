Return-Path: <linux-bcache+bounces-1364-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CF518D19EA6
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 16:32:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 05C99303095D
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 15:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69D63939A8;
	Tue, 13 Jan 2026 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F/6d8kLE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA8E3933FB
	for <linux-bcache@vger.kernel.org>; Tue, 13 Jan 2026 15:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318212; cv=none; b=lu98iOW5wBxayik3iQ87Pp/3aOYFfHdoVFGCB5P0dilYuyxyeMwi+KrtTNd6B9J9nQQAERSwuMbQ188s7KE/HwI1qYWu1LtlW6RV3Ml+oQfmVIVVkmNR01+Q/0yXKoaDwFIzjHYC/HExvE20cv3PvBDYjlXqZ5SkWLpL4aV2QFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318212; c=relaxed/simple;
	bh=rsYKvONA2P2QDpCx0CTx6kcZtWnLaIak/A/O5IsFJcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJUvcgsgBa8VWUaRMVBiyprv4I41NU0qMovdsnoVjxj5CWauMriUNI60GEkk2N6MnNwqde309NtEy8JMwJehb2aDKmVkcgfCYNg/OTMd2ryk4WiwwvOIkgWuXQ9oSTKFADmCAFiHfsMym68WnDA9VhJKKNaLpuoIHKRsG5+wO0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F/6d8kLE; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Jan 2026 10:30:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768318209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3iq0pufe/fVx+G1577+gUH3BRzBiC1OYaQ2kf+II1gk=;
	b=F/6d8kLEDVPdKAp+mPwZsoykPFA8jMQh64AZ3kVEaPH3I5l+20Z9gCD2QYRROzF3qjCuov
	8mqLUARaZrqBNBec7DjfWRrhI2N6cPSta0DkisuQM9nrdJjPx7ABiN6Aj98cLE5GbSGX4L
	5Y2kKhpDhERx2iPu0Mre1KTmNKLN+6U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: colyli@fnnas.com, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWZjT-QrKPrzOFPc@moria.home.lan>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
 <aWYL9x5s1nB_B1Ho@moria.home.lan>
 <aWZd8xCPXV7Djx7J@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWZd8xCPXV7Djx7J@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 13, 2026 at 07:00:03AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 13, 2026 at 04:27:19AM -0500, Kent Overstreet wrote:
> > It's not being a dick to tell someone they need to slow down and be more
> > careful when they're doing something broken and arguing over the revert.
> 
> Yes, you are.  I did not actually do anything here but point out that
> bcache is broken.

There've been no bug reports, people are using the code and it works.
You keep claiming breakage, and I asked you to explain what you thought
was wrong with the bare bi_end_io call - but you still haven't, and I'm
not buying it because I know what the code in bio_endio() does - I wrote
some of it, after all, and none of it expects to be called twice on the
same bio.

You're making changes in code you didn't write, bypassing the
maintainers to get it in, without providing any real justification -
that's reckless. And you have a habit of calling things "broken"
without a good reason, so please cut that out.

If, as you claim, calling a bare bi_end_io function in this context is a
problem, you better be able to explain why.


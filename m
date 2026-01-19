Return-Path: <linux-bcache+bounces-1384-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 18585D3A4AD
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 11:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B7FE30550EF
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 10:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DD827F724;
	Mon, 19 Jan 2026 10:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NUUe4kh7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEA827B336
	for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 10:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768817912; cv=none; b=YoyoevzZOwANoNCV8mlwXDs6q4N6qbzFzIelR8x929597mfXtd8CLkMnBfiPHiC18Qu/2NgP0MUMHcYhPxsPkzgrY4UHa2TxjvbbT8SN+Ka3KMeNGBH1gSFo8TqNWwwGMNtaVkI5snTEln2v2cnKKcZ0vnWk2zD9faqNE0+p0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768817912; c=relaxed/simple;
	bh=HC7TLvf3//GCwRLvhQq4nekbKLxPnJB3rO2+KeKKXzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8fIGOlOTpt0E6JBq0ZDKFvL+BlXOes0+qUlRiqdDfCgDPi/ume49UIAtsQJNoujVAjxgFELU71U2evZUIMNsKIjuwU2VeheZHTg7i4JqX319qxFSg183cqtv8cWGQEZn7vTITCB3915B1QRiLMHaxEqCd/BM1jYc/AkJ+CHvY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NUUe4kh7; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 19 Jan 2026 05:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768817899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=judHjY1NulyclqVN1tEAJsZ8iFAy2VC8CBrW9yugBCw=;
	b=NUUe4kh73Q/5lSTy4gTD3EymcVm6TXzGbNWdrCSj8RyEg4UyF/Ye2WUMt0AfKeYkf17ezd
	QDIjViWY91RpfS96SZJSk3jFgW9NPESrM03Q+P0zgORBRONtVIr+XNZI+nYKdSn0LJW0oi
	NReV0BoeCERW4JPJWkC2XfDTyc7XiKE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Daniel Wagner <dwagner@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@fnnas.com>, 
	axboe@kernel.dk, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aW4D0UPTBXEap1Jg@moria.home.lan>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
 <aWZwBZaVVBC0otPd@studio.local>
 <aWZyHz_eZWN-yQiD@infradead.org>
 <aWZyWJiOi9hZgtqo@moria.home.lan>
 <f7af1e25-fbe9-4d37-b902-5b3a9ed4c8f4@flourine.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7af1e25-fbe9-4d37-b902-5b3a9ed4c8f4@flourine.local>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 19, 2026 at 10:51:46AM +0100, Daniel Wagner wrote:
> On Tue, Jan 13, 2026 at 11:34:18AM -0500, Kent Overstreet wrote:
> > Coly and I were just on a call discussing updating my old test suite. I
> > haven't used the bcache tests in > 10 years so they do need to be
> > updated, but the harness and related tooling is well supported both for
> > local development and has full CI.
> > 
> > https://evilpiepirate.org/git/ktest.git/tree/README.md
> > https://evilpiepirate.org/git/ktest.git/tree/tests/bcache/
> 
> I just quickly look at the tests and I got the impression some of those
> tests could be added to blktests. blktests is run by various people,
> thus bcache would get some basic test exposure, e.g. in linux-next.

ktest has features that blktests/fstests don't - it's a full testrunner,
with a CI and test dashboard, with subtest level sharding that runs on
entire cluster.

What would make sense would be for ktest to wrap blktests, like it
already does fstests.


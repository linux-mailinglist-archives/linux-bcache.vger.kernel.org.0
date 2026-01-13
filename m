Return-Path: <linux-bcache+bounces-1358-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 63058D174E0
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 09:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C50383028313
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 08:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3EB37FF6A;
	Tue, 13 Jan 2026 08:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uWrUHXxk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33F7318BB2
	for <linux-bcache@vger.kernel.org>; Tue, 13 Jan 2026 08:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768293066; cv=none; b=nbHT29B87SZmulEbGn5QWfTTohDz3zMgyptiNJu/4RcKvMevxNFKVNo51nK8bZqdAQldCz3ba8/rAOHBfjsEkVzKRNIu8IlSw4+i+BFatJnsvo9adB3fbEWgH8h6ZQEvNU1Wl7TH637M1eSm85gnOPlL+7lV2nuIz78iIoiIUVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768293066; c=relaxed/simple;
	bh=Pkew2NY+RN8ybiFm5bfLBCcke4L7RO4YuZmnMwl8JaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWHIBbTPlbWp4oO4Alnv5WOOlW1YbLvD0u3aj41TWCYOhLf6m39Bxxf75TpAqDxAaZ4w16awxQLRzUfDMAlXJUIkO6w8fxdH7xYTdtxcJIMkXzP3D/v8APJ5bcF5fLPcfP00/eudeETMEmkUI9U0dcPcMYIGfiJ/81O/Gb8t8ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uWrUHXxk; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Jan 2026 03:30:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768293053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=so2RvNMlsxrWq7StUEBpmOy2EOmE32uBMjS/rIHy5EQ=;
	b=uWrUHXxkbd29Zs71sE2XIgAcXzakFA2GZWvFrvXUbt/wjMH4FVUk6AFbuPnQyo/Kc12xfz
	a/Y6gNY+QmqLJ8vD+jDEZwQk8s7NnSYjayulJucA1tPO60uilXEUGdjFrOC7kdWwXXfMhM
	A7KBzGFB+hsyDmCxawYeqkV3j4UIp5g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: colyli@fnnas.com, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWYCe-MJKFaS__vi@moria.home.lan>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWX9WmRrlaCRuOqy@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 13, 2026 at 12:07:54AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 13, 2026 at 02:09:39PM +0800, colyli@fnnas.com wrote:
> > From: Coly Li <colyli@fnnas.com>
> > 
> > This reverts commit 53280e398471f0bddbb17b798a63d41264651325.
> > 
> > The above commit tries to address the race in bio chain handling,
> > but it seems in detached_dev_end_io() simply using bio_endio() to
> > replace bio->bi_end_io() may introduce potential regression.
> > 
> > This patch revert the commit, let's wait for better fix from Shida.
> 
> That's a pretty vague commit message for reverting a clear API
> violation that has caused trouble.  What is the story here?

Christoph, you can't call bio_endio() on the same bio twice. You should
know this. Calling a bare bi_end_io function is the correct thing to do
when we're getting called from bio_endio().


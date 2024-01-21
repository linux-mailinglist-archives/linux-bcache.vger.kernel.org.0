Return-Path: <linux-bcache+bounces-240-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2AE4835724
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 18:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAAB71C20B59
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 17:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98980381CA;
	Sun, 21 Jan 2024 17:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SAnE/LP1"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D7D381C0
	for <linux-bcache@vger.kernel.org>; Sun, 21 Jan 2024 17:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705858921; cv=none; b=Qj+0CuDmHrpcsKtFgG10ae/dwrbb89e9934NcUgEIdWAP2Lp05sm2JYaeYExZ47lLGOpmwfU2XI8PHXVIuEUU6UF7femYCQLjE+Uys/04RDxGHZ+TTKs6ZH2cPIICIlvk7WKqYyuCsodxzCXM/fSZ8qkuo5leXUl8GzByE8A9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705858921; c=relaxed/simple;
	bh=N2g0NHGKWWZmb/qlzQ163FWOfAKGzGlUYORWKPpiytI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+etJqK0Gcp8wKyyFVAHb9qunCyE/IonGo8JqiGrBmpuXI+2tSIC52GZ0IcbwI1CF5thqNjZF7RFjr6HWcxK1/ahaEmvAF71qlPyekNFj2d0UIZVWFXQ3MAxeGk5hJy1HBMEm8dlNTQP1iA/S+D72FPef1eCxvwPEnuSqcz0yqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SAnE/LP1; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 21 Jan 2024 12:41:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705858918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zEZ5U22ZGrF+dm4NBxH8Qr8fPO+NuB0IQfzMnXwEl2I=;
	b=SAnE/LP1jwOwzXFkLVsJ3sKoqSTNCqYfTEYCKAmoFk1FmHnZ26Iz4mV15j37lFPDee+j3n
	sgRxhokF3swjiFCXQMxWTxwVZP3QhEUF+rp94gIAEpt0o4e6y/XV2kDywFSZTWBKXPT5wK
	JqXTf9UqF55p7CtlVOD/ol70LJ9tJIM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize number of comparisons for heap/heapsort
 implementaion
Message-ID: <ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>
 <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
X-Migadu-Flow: FLOW_OUT

On Mon, Jan 22, 2024 at 12:55:51AM +0800, Kuan-Wei Chiu wrote:
> On Sun, Jan 21, 2024 at 11:21:06AM -0500, Kent Overstreet wrote:
> > On Sun, Jan 21, 2024 at 11:36:44PM +0800, Kuan-Wei Chiu wrote:
> > > Hello,
> > > 
> > > The existing implementations of heap/heapsort follow the conventional
> > > textbook approach, where each heapify operation requires approximately
> > > 2*log2(n) comparisons. In this series, I introduce a bottom-up variant
> > > that reduces the number of comparisons during heapify operations to
> > > approximately log2(n), while maintaining the same number of swap
> > > operations.
> > > 
> > > Thanks,
> > > Kuan-Wei
> > > 
> > > Kuan-Wei Chiu (5):
> > >   bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
> > >   bcachefs: Introduce parent function for sort_cmp_size()
> > >   bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
> > >   bcachefs: Optimize number of comparisons in heap_sift_down
> > >   bcache: Optimize number of comparisons in heap_sift
> > > 
> > >  drivers/md/bcache/util.h |  23 +++++----
> > >  fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
> > >  fs/bcachefs/util.h       |  23 +++++----
> > >  3 files changed, 98 insertions(+), 57 deletions(-)
> > 
> > Good stuff
> > 
> > While we're looking at this code, we should be doing some cleanup too -
> > there's no reason for the heap code to be duplicated in bcache and
> > bcachefs anymore, and it'd also be nice to get fs/bcachefs/eytzinger.h
> > moved to include/linux and bcache converted to use it.
> > 
> > I also would not be surprised if there's another heap implementation in
> > include/linux; we'll want to check for that and if there is decide which
> > is worth keeping.
> >
> Yes, we have 'min_heap.h' in include/linux.

So that has the advantage of more readable code - functions instead of
macros - whereas my version has the type safe interface.

We could combine the two approaches, and put a type-safe interface on
top of the min_heap.h code with some small macro wrappers - see
generic-radix-tree.h for an example of how that's done.

min_heap.h has only one user though? I don't think I can quite believe
that's the only other code in the kernel using a heap, there must be
more open coded out there...


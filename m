Return-Path: <linux-bcache+bounces-1068-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3723DABA1A9
	for <lists+linux-bcache@lfdr.de>; Fri, 16 May 2025 19:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A3A43A977A
	for <lists+linux-bcache@lfdr.de>; Fri, 16 May 2025 17:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5323B24EF8B;
	Fri, 16 May 2025 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WUPsZ861"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EC626C3B9
	for <linux-bcache@vger.kernel.org>; Fri, 16 May 2025 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415436; cv=none; b=IW7X/MffUpx/r69SbIOU7+1SE36gRj/g+L4lGn1WQvBEnK0VlK5FHpayYA6CwuNg12/K4WbNSlpe6DH6O1JFH48e/PSjf8NtgDVx/gmi7P6c4u7PhEaXU42weUF42vHcq12dR5mI/qHZUX1BMlt4PUqTr26Iw3rSOHvoGgkPEjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415436; c=relaxed/simple;
	bh=GOz+lgnPVPdatzRuM+y10HDDw5cmJtB7kEHiZhvanFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2BaFMOYA/lJ6SqthOKiZP3NPhOkw9IN4WFzxwvter7OvE8egtCS+siBEYgdV9Av3abFjIKyfnQOIE1/XYDa3qNphE1x8pgrvRGtEAgoE2qi7h2wK7p0YfZl5mWKSwHNtSOzQn0AGF7J3rjj/yWqLTijTiOJXb2olachAyj7aWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WUPsZ861; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 16 May 2025 13:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747415431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YQvDx2mRdTHSCLyjAff829yikdT98Etpmo+8UgzD6xg=;
	b=WUPsZ861P9TSPobxsSx0RqyN5mqZttllBpeB2cAv5D3EF2OLXc5hJaHCT6Cx0sdTvOl6Mk
	oMBfWRByvDM0Krx/RN6g2kkPRqdBM58lVwmWGruhH4lu2w5ZmX5Wdfo9DRHVv1KpT5C3i5
	WI59/32FRXkt8gjGkfuBU2dPeyqwJL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Robert Pang <robertpang@google.com>
Cc: Coly Li <colyli@kernel.org>, linux-bcache@vger.kernel.org, 
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Message-ID: <wtfuhfntbi6yorxqtpcs4vg5w67mvyckp2a6jmxuzt2hvbw65t@gznwsae5653d>
References: <20250414224415.77926-1-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414224415.77926-1-robertpang@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 14, 2025 at 03:44:03PM -0700, Robert Pang wrote:
> In performance benchmarks on disks with bcache using the Linux 6.6 kernel, we
> observe noticeable IO latency increase during btree garbage collection. The
> increase ranges from high tens to hundreds of milliseconds, depending on the
> size of the cache device. Further investigation reveals that it is the same
> issue reported in [1], where the large number of nodes processed in each
> incremental GC cycle causes the front IO latency.
> 
> Building upon the approach suggested in [1], this patch decomposes the
> incremental GC process into more but smaller cycles. In contrast to [1], this
> implementation adopts a simpler strategy by setting a lower limit of 10 nodes
> per cycle to reduce front IO delay and introducing a fixed 10ms sleep per cycle
> when front IO is in progress. Furthermore, when garbage collection statistics
> are available, the number of nodes processed per cycle is dynamically rescaled
> based on the average GC frequency to ensure GC completes well within the next
> subsequent scheduled interval.
> 
> Testing with a 750GB NVMe cache and 256KB bucket size using the following fio
> configuration demonstrates that our patch reduces front IO latency during GC
> without significantly increasing GC duration.

Have you been looking at bcachefs yet? It solves all the latency issues
in bcache.


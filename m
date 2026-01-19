Return-Path: <linux-bcache+bounces-1380-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BEBDD3A164
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 09:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 710483016AFE
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 08:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30BC133BBBD;
	Mon, 19 Jan 2026 08:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="teYW2V/V"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-23.ptr.blmpb.com (sg-1-23.ptr.blmpb.com [118.26.132.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45D733C1BC
	for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 08:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768810791; cv=none; b=api7i8HVZJ7c59uvE1Zpw2tQ6eaj9cLPSXPWd8PKL1gD5xlervGuprGJgMYSf9sMhEJRtl+LPrTZLiD8n9vz2bkxRW5FjqGP6iDX11ZxNNRk7wVySLNdDNFYVxbDhRZlrG6aVy21db762VFEL+AjrKV0YeVNi+qh6CatXoDAsYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768810791; c=relaxed/simple;
	bh=wTHIDzc9tg54mscUXD/rYllVf8e0+7SFatwCfvC0azw=;
	h=Date:Content-Type:To:Cc:Message-Id:Subject:Mime-Version:
	 In-Reply-To:From:References:Content-Disposition; b=Tfl+vKXp5fOotCJi0Ko81VWAmML95lJhU1IGGrl8ODOg16KgRyEV8zImY9BwlF2EoXmOKtDvHQD7RMnyEGL7hal2Lfm6twygtR8DoKnE4VWcd1CwM9ZpdtrA0tOS92qpk3sEc3LXrTJESz+DGjoL/FUtDQtesDoz6xmVI2MDVJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=teYW2V/V; arc=none smtp.client-ip=118.26.132.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768810783;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=7v91HUxvDViHixOdd6XakW/xWAn7tPIwpJkQ/eeVQm4=;
 b=teYW2V/VJPNXtL71obLK+MXGJBGBa1B0esLDAFN6L+mJou2UmjwrpY7adq5ysf1BRkAtWb
 n2DYwVn1qcurb6ZSIOLgf0qBxkVEKV4kA5yAPg65161kzMghOBnpDmnPdks8srgopSVbGO
 Ps0pmhzhxkTlNw5vfiZBaCCUTO+NSvwApg5jMDIIPgXEWCzZxDwd489utNeE+va8Xupa9M
 oSsUOYN05JhsZ6gfSqXqkrWDVAc5FFB/6mzgGBw6qztoPKYr8TCrCLC8Fle6Nvp4soJcv7
 TTXpDEexAV9vz/Zi1QPvGFZbNAwPInUhkokfENm+evprpdEow4nszxaGCTzfSg==
Date: Mon, 19 Jan 2026 16:19:38 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fnnas.com>
X-Lms-Return-Path: <lba+2696de91d+012c58+vger.kernel.org+colyli@fnnas.com>
Content-Transfer-Encoding: 7bit
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Stephen Zhang" <starzhangzsd@gmail.com>, <kent.overstreet@linux.dev>, 
	<axboe@kernel.dk>, <sashal@kernel.org>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <zhangshida@kylinos.cn>
Message-Id: <aW3nzb2lOSVSbqQZ@studio.local>
Subject: Re: [PATCH] bcache: fix double bio_endio completion in detached_dev_end_io
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <aW3Sq4H_OosPVaNe@infradead.org>
From: "Coly Li" <colyli@fnnas.com>
References: <20260115074811.230807-1-zhangshida@kylinos.cn> <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com> <aWilW0RKQiHJzpsZ@infradead.org> <aWzIU3ASp139lHNz@studio.local> <aW3Sq4H_OosPVaNe@infradead.org>
Content-Disposition: inline
Received: from studio.local ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Mon, 19 Jan 2026 16:19:40 +0800

On Sun, Jan 18, 2026 at 10:43:55PM +0800, Christoph Hellwig wrote:
> On Sun, Jan 18, 2026 at 07:49:36PM +0800, Coly Li wrote:
> > Shida,
> > can you also test it and confirm? We need to get the fix in within 6.19 cycle.
> > 
> > Yes, we need to make a dicision ASAP.
> > I prefer the clone bio solution, and it looks fine to me.
> 
> Do you have any maintainer QA that exercises this?  For basically any

Normally I do testing by following methods,
1) normal file system testing on it
2) long time I/O pressure e.g. at least 48 hours
3) deploy on my working machines with real workload for weeks

Current tests are not automatically. And I will integreate Kent's test
tools in.

> other maintained subsystem we'd have a maintainer jump on verity fixes
> like this ASAP and test them.
> 

Before I work on it, I want to know the author already ran and tested the
patch firstly. Normally I won't test any patches posted on mailing list.

Thanks.

Coly Li


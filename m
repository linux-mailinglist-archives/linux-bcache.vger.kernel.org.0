Return-Path: <linux-bcache+bounces-1131-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E49D2AD941E
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 20:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7F231E0FE5
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 18:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7BE23182D;
	Fri, 13 Jun 2025 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cgCTvs0W"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C2E22F774;
	Fri, 13 Jun 2025 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749837857; cv=none; b=iyFIy+eWKVI5+sfXV/sFTQcxR+rmAtXtYPXFLIHj4WEsrAFR9JPIk5F1zZs5w7WEfbwSev6ufvsJHXsqyxbAgyLvfXMn5AYXbQMpkgbaZ0ydjGus5YT568tBGFqmx7Df0DfbgqGpdSBrxB0PXuQvsUGe2SZDISgC5b67LDxp7Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749837857; c=relaxed/simple;
	bh=k06ojrMVttfbbL990yVC8yu59w25ry+eDhakMB1d0nc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=U+acKQ3ghwqi285kA8dUu9pbpoQzY+NirgLHUtcBCuh+49rIXW5EFbT1631+5MVEYCV4HGlYKetdcE0difC6tG7EX5mEn0TzLYULTSOs9Vj1yl7e7bZtXzedbOtgHBEBrioGtnbET7Gd6p+p8iIrbt01QkbbxSX6Kq+JsMa7OC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cgCTvs0W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD822C4CEE3;
	Fri, 13 Jun 2025 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749837856;
	bh=k06ojrMVttfbbL990yVC8yu59w25ry+eDhakMB1d0nc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cgCTvs0WGSJL7LwUsZCaLwKpZ/QUfJB9UWn5PKrCpwOSwZZMC97VKX9gEGwZfGLUW
	 iM+3bkXTFbJzcjQ/ChQP5shRXwJjgCTakHlo9wuQ3VyMZgBMHChWQfuLmqhv3mzyyy
	 EFSr6Cyuj5A5J6D/DjAPOjwH6/ufUeKVQAC8FjEQ=
Date: Fri, 13 Jun 2025 11:04:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Pang <robertpang@google.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, corbet@lwn.net, colyli@kernel.org,
 kent.overstreet@linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-bcache@vger.kernel.org,
 jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix bcache regression with equality-aware heap APIs
Message-Id: <20250613110415.b898c62c7c09ff6e8b0149e9@linux-foundation.org>
In-Reply-To: <CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
	<20250611184817.bf9fee25d6947a9bcf60b6f9@linux-foundation.org>
	<aEvCHUcNOe1YPv37@visitorckw-System-Product-Name>
	<CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Jun 2025 23:26:33 +0900 Robert Pang <robertpang@google.com> wrote:

> Hi Andrew
> 
> Bcache is designed to boost the I/O performance of slower storage
> (HDDs, network-attached storage) by leveraging fast SSDs as a block
> cache. This functionality is critical in significantly reducing I/O
> latency. Therefore, any notable increase in bcache's latency severely
> diminishes its value. For instance, our tests show a P100 (max)
> latency spike from 600 ms to 2.4 seconds every 5 minutes due to this
> regression. In real-world environments, this  increase will cause
> frequent timeouts and stalls in end-user applications that rely on
> bcache's latency improvements, highlighting the urgent need to address
> this issue.

Great, thanks.  Let's please incorporate this into the v2 changelogging.

> > > Also, if we are to address this regression in -stable kernels then
> > > reverting 866898efbb25 is an obvious way - it is far far safer.  So
> > > please also tell us why the proposed patchset is a better way for us to
> > > go.
> > >
> > I agree that reverting 866898efbb25 is a much safer and smaller change
> > for backporting. In fact, I previously raised the discussion of whether
> > we should revert the commit or instead introduce an equality-aware API
> > and use it. The bcache maintainer preferred the latter, and I also
> > believe that it is a more forward-looking approach. Given that bcache
> > has run into this issue, it's likely that other users with similar use
> > cases may encounter it as well. We wouldn't want those users to
> > continue relying on the current default heapify behavior. So, although
> > reverting may be more suitable for stable in isolation, adding an
> > equality-aware API could better serve a broader set of use cases going
> > forward.

"much safer and smaller" is very desirable for backporting, please. 
After all, 866898efbb25 didn't really fix anything and reverting that
takes us back to a known-to-work implementation.

I of course have no problem making the changes in this patchset for
"going forward"!

So if agreeable, please prepare a patch which reverts 866898efbb25. 
Robert's words above are a great basis for that patch's description.



Return-Path: <linux-bcache+bounces-1141-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24118ADA121
	for <lists+linux-bcache@lfdr.de>; Sun, 15 Jun 2025 07:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB0B7172034
	for <lists+linux-bcache@lfdr.de>; Sun, 15 Jun 2025 05:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DECE1DFE12;
	Sun, 15 Jun 2025 05:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btczkAG+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3E61A5BA0;
	Sun, 15 Jun 2025 05:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749966727; cv=none; b=H0PZLswSfd248ZyCkEEoNnuFoQfu5mXZOw1TwFWd6uGk/rHnabAx4xH7LvHM7zVRZDakh/vD0/5WBzBqbp15Wv3lm595zgTupP7hcYO+sMTRRg/3BkwHg8jtLjuYaFjRCShaYgTV09nBRcjDp5hw0vPzWglOWyZaFlajbeJR3Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749966727; c=relaxed/simple;
	bh=zI6zkvnQVVugf6EBRx3Vq3G3uZciw5X+vHRqxd8/BcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y4UmzCiMrOExMdihXJXOceivse1lhjmL/sRNEQRsT6NHUdMjKHtmMW4eeGu069zAZpBFHEmP3fkRI5bY88DJowKbbGRwzrPvzfNwfAsquERx9PyV/RP5vobkF07sTE+JMpCR2QDrqOR9mNifuww2ObSglay+JOX6iNp2m987UDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btczkAG+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFB8C4CEE3;
	Sun, 15 Jun 2025 05:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749966726;
	bh=zI6zkvnQVVugf6EBRx3Vq3G3uZciw5X+vHRqxd8/BcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=btczkAG+Fb2Yx5+cCIJ9hvtjEbzbo491e40+H24nYR+V3xjk/7/JazDTMPQ78MAMA
	 8kTg8xu6W47a0Y94xME/mVwCNiD5wqm0FGH17GUhQ57qpSoUzuAe5KVJ8HigBF/M+A
	 MgKB5ltVavNfbluZBizFnGZm9AyR34FpizJ8LQsQlwzr9Iwq/kxoRdBAwv2av+cctf
	 gM5wjNzA9Ryvnhux0/durWzKg5rDce55QpD1JTWw0ZcQIQ+TkG2s0Vs9n8hLplTmrc
	 /hYHV9h8KUcwm2HSMFJRwiFu4vfLYMM75c/RQZ13nLcTWa9BYTlJwjryX17jh4rd9A
	 k+RE8ujW68qtA==
Date: Sun, 15 Jun 2025 13:52:01 +0800
From: Coly Li <colyli@kernel.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	robertpang@google.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, 
	jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] bcache: Remove unnecessary select MIN_HEAP
Message-ID: <d45nj54fidgmxfjryx42tuaddwkjeogq2zb2i3oki7rstdeut6@obcycu7j4igw>
References: <20250614202353.1632957-1-visitorckw@gmail.com>
 <20250614202353.1632957-4-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250614202353.1632957-4-visitorckw@gmail.com>

On Sun, Jun 15, 2025 at 04:23:53AM +0800, Kuan-Wei Chiu wrote:
> After reverting the transition to the generic min heap library, bcache
> no longer depends on MIN_HEAP. The select entry can be removed to
> reduce code size and shrink the kernel's attack surface.
> 
> This change effectively reverts the bcache-related part of commit
> 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap
> API functions").
> 
> This is part of a series of changes to address a performance
> regression caused by the use of the generic min_heap implementation.
> 
> As reported by Robert, bcache now suffers from latency spikes, with
> P100 (max) latency increasing from 600 ms to 2.4 seconds every 5
> minutes. These regressions degrade bcache's effectiveness as a
> low-latency cache layer and lead to frequent timeouts and application
> stalls in production environments.
> 
> Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
> Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
> Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
> Reported-by: Robert Pang <robertpang@google.com>
> Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Acked-by: Coly Li <colyli@kernel.org>

Thanks.


> ---
>  drivers/md/bcache/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index d4697e79d5a3..b2d10063d35f 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -5,7 +5,6 @@ config BCACHE
>  	select BLOCK_HOLDER_DEPRECATED if SYSFS
>  	select CRC64
>  	select CLOSURES
> -	select MIN_HEAP
>  	help
>  	Allows a block device to be used as cache for other devices; uses
>  	a btree for indexing and the layout is optimized for SSDs.
> -- 
> 2.34.1
> 

-- 
Coly Li


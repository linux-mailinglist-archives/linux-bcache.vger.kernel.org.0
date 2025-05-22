Return-Path: <linux-bcache+bounces-1078-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E92AC1162
	for <lists+linux-bcache@lfdr.de>; Thu, 22 May 2025 18:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E13743A800B
	for <lists+linux-bcache@lfdr.de>; Thu, 22 May 2025 16:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3396F29AAFC;
	Thu, 22 May 2025 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UKUCUp0u"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5F2299ABD
	for <linux-bcache@vger.kernel.org>; Thu, 22 May 2025 16:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932552; cv=none; b=dqrqsMep7pCCIo3Hkg1iXLRM0JKisKDeKgsoQQbFnTQdaD9y/3wE/P13LJHz9VtHpjEFE1x0EBfyxQgG3v8fJXk3vD8cSd3FZGeZX2RErHLkqsNKBkF51qWZTSs776LFYcOHUs7rE8BrPhKx/9LdgkIwmqIXDw9r4GKT3DOiEOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932552; c=relaxed/simple;
	bh=j35fmLgetkmSXQUe+NPZE0gq2nxVdxLHs49rTm9DE9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxcos6jwe5xbrvBMzN4dUQS7TZ4zpus8vxLUHzWgbnB/qBbDYWR+VjmeA4r9DbKE3unUYyR+6kLZ3PSlFemlp/VX3FKtTv1Bj3ujsqFNqnR5lcjOU1CfEGuE305iniv4ITY6MZOnXXseOPGqzueP5GO5e+k9mnhlwKYi/0zvCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UKUCUp0u; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 22 May 2025 12:48:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747932537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RQIsaiqTMB+Ttm8nI69su9Y65q0oEsoQR0Y/F7m8Jk0=;
	b=UKUCUp0uKZRsL5+TEW9oPVweOe+3qwmHQ0BIgxfxOh6xgIoImjNIXGE5TFIh+CYqYSy+6P
	hT5cl70b/uEtdPLr2XmR/1pg9zoqMM5sius7lj4bnhv87w3YyzZa82eCqMuD7LEKweZge0
	1ckWib6i12JVhhXDiDs+PGBY/cUp4o8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: linux-bcache@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	lkft-triage@lists.linaro.org, Linux Regressions <regressions@lists.linux.dev>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: riscv gcc-13 allyesconfig error the frame size of 2064 bytes is
 larger than 2048 bytes [-Werror=frame-larger-than=]
Message-ID: <6tgxbull5sqlxbpiw3jafxtio2a3kc53yh27td4g2otb6kae5t@lr6wjawp6vfa>
References: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYv08Rbg4f8ZyoZC9qseKdRygy8y86qFvts5D=BoJg888g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 22, 2025 at 06:59:53PM +0530, Naresh Kamboju wrote:
> Regressions on riscv allyesconfig build failed with gcc-13 on the Linux next
> tag next-20250516 and next-20250522.
> 
> First seen on the next-20250516
>  Good: next-20250515
>  Bad:  next-20250516
> 
> Regressions found on riscv:
>  - build/gcc-13-allyesconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducible? Yes
> 
> Build regression: riscv gcc-13 allyesconfig error the frame size of
> 2064 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Is this a kmsan build? kmsan seems to inflate stack usage by quite a
lot.


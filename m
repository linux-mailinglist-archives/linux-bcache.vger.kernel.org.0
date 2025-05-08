Return-Path: <linux-bcache+bounces-1061-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B88AAFFC6
	for <lists+linux-bcache@lfdr.de>; Thu,  8 May 2025 17:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 881D24C3ECF
	for <lists+linux-bcache@lfdr.de>; Thu,  8 May 2025 15:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9994127A931;
	Thu,  8 May 2025 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqVYuR8f"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C21227A127;
	Thu,  8 May 2025 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719933; cv=none; b=KwCnJjf1aCA6uGgQ6WiCzvDhy6+ZIS5CDubm3TFyygM0HNAzCOOpZvyo7AletXicjz8PMfOw4YwAhUeIGFM4ff2H+b0+kFAU/o1WgC25cNJ1K0RR4/Ph2yemzWnyFLAFORRXMBGWs3Km0nJ+LJFgn8f6fYQOsjmwffgQ+5T307o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719933; c=relaxed/simple;
	bh=8jYZVX0/2dxdtW2AwtBMm0nQOTU2ozp7HEs7ay7+F5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWWo5UVwN1fqysG/VeHzbi06yaF9wLFzibHefp6ouh4OzlMrrsTMrLntidxNvTts5Z2wspwkBben28DH4CyPnxVzKJ/p/+ZpEARYhAGe5tFG3voWQK2DeuONSmsRJWoxTQwWdiCWZZI9TQDSybHyiD9QnqcVOOhr1s0dpxexK78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqVYuR8f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA38EC4CEE7;
	Thu,  8 May 2025 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746719931;
	bh=8jYZVX0/2dxdtW2AwtBMm0nQOTU2ozp7HEs7ay7+F5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QqVYuR8f9MAE6X0M+Ea5uUkt3BwJhEeAVhK5N9Yat9xDZzbF8VVkdoMEn4Goh4A1Z
	 ZEpAvA5i2+y0R8R7Y2mQRlht2k25qEfWDFexE6AyD/cKh0JaF9+A2sEFf9GzBJXRDj
	 LrbHXVruSyA5zXfVv9zY2a1GaeGANKjrBwYToBymmz4qY2/i8TgtlydHsrUK/Y9lmw
	 SCOcIhQXDgFyXLJyxoE+3APIM8l6+JueosfnWznRJVivvQ7K+uHlm4oVs0OB7LHrMr
	 MN09X8O0PSPGs10h1UKbT9ehMf1v6HI9UUQSgCBHaJVrd7PHL25FswAC/ysHTVSeMJ
	 d0mobG3Pwsnaw==
Date: Thu, 8 May 2025 08:58:48 -0700
From: Kees Cook <kees@kernel.org>
To: Coly Li <i@coly.li>
Cc: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] md/bcache: Mark __nonstring look-up table
Message-ID: <202505080844.DD7F50F0A@keescook>
References: <20250418202130.it.887-kees@kernel.org>
 <389A9925-0990-422C-A1B3-0195FAA73288@coly.li>
 <851B250D-A22C-4B47-BBAC-55284B5B5790@coly.li>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <851B250D-A22C-4B47-BBAC-55284B5B5790@coly.li>

On Thu, May 08, 2025 at 11:01:34AM +0800, Coly Li wrote:
> 
> > 2025年4月19日 11:55，Coly Li <i@coly.li> 写道：
> > 
> > 
> > 
> >> 2025年4月19日 04:21，Kees Cook <kees@kernel.org> 写道：
> >> 
> >> GCC 15's new -Wunterminated-string-initialization notices that the 16
> >> character lookup table "zero_uuid" (which is not used as a C-String)
> >> needs to be marked as "nonstring":
> >> 
> >> drivers/md/bcache/super.c: In function 'uuid_find_empty':
> >> drivers/md/bcache/super.c:549:43: warning: initializer-string for array of 'char' truncates NUL terminator but destination lacks 'nonstring' attribute (17 chars into 16 available) [-Wunterminated-string-initialization]
> >> 549 |         static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
> >>     |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> 
> >> Add the annotation (since it is not used as a C-String), and switch the
> >> initializer to an array of bytes.
> >> 
> >> Signed-off-by: Kees Cook <kees@kernel.org>
> >> ---
> >> v2: use byte array initializer (colyli)
> >> v1: https://lore.kernel.org/all/20250416220135.work.394-kees@kernel.org/
> >> Cc: Coly Li <colyli@kernel.org>
> >> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> >> Cc: Ard Biesheuvel <ardb@kernel.org>
> >> Cc: linux-bcache@vger.kernel.org
> >> ---
> >> drivers/md/bcache/super.c | 3 ++-
> >> 1 file changed, 2 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >> index e42f1400cea9..a76ce92502ed 100644
> >> --- a/drivers/md/bcache/super.c
> >> +++ b/drivers/md/bcache/super.c
> >> @@ -546,7 +546,8 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
> >> 
> >> static struct uuid_entry *uuid_find_empty(struct cache_set *c)
> >> {
> >> - static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
> >> + static const char zero_uuid[] __nonstring =
> > 
> 
> Hi Kees,
> 
> > I notice zero_uuid[16] changes to zero_uuid[], then the element number information is removed.
> > 
> > Is it OK for GCC 15 to only add __nonstring and keep zero_uuid[16]?

Either way is fine. I can update the patch to use the "[16]" again if
you'd like?

-Kees

> Ping ?
> 
> You are expert here, I need your opinion.
> 
> Thanks.
> 
> Coly Li
> 
> 
> 
> >> + { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
> >> 
> >> return uuid_find(c, zero_uuid);
> >> }
> >> -- 
> >> 2.34.1
> 
> 

-- 
Kees Cook


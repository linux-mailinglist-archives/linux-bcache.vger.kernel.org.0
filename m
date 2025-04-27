Return-Path: <linux-bcache+bounces-968-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E633AA9E49B
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Apr 2025 22:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53A3E3BAE1E
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Apr 2025 20:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F478201017;
	Sun, 27 Apr 2025 20:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gbhRtubs"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99F71DFDB9
	for <linux-bcache@vger.kernel.org>; Sun, 27 Apr 2025 20:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745787025; cv=none; b=fO66jemqil3P4xja+xvqFP68lGba5DBNgbS9vi2EbpvBt904JnMEjaSXaT8iRuJD+2nf47Xvh8/P3UAMUQISypLBljr9Yp0BHoXoFnylahkdezp2000vEt0u2Nt+tusDL7RCA4Z8J6ZBIFIm7ED8Gfl2+j09jqlcA5zbewVexaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745787025; c=relaxed/simple;
	bh=IySfsG/Fon0rlcGAzIt0Y80/E514IZK3vTvQ6N8Lp4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHcGNGMBSUF2ryuijrP9t8Lmx2xnnRnGLDyty9VqUsYdhLwKAPYtf+7L+yKwSAUCxuA6xz8z/B046Y3rlwmjIf4JI+tGJ8BFdCMzK51blHViICNpgt7qwiPBDq19/SxvX0f5W7tVi2aoyyzOKIsxQbpVhoQNwl5G0aBvmLxVSe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gbhRtubs; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 27 Apr 2025 16:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745787007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DjaP+b4X34P31aw/uqok/yS3GcR1WDAXWGJx5LawSFw=;
	b=gbhRtubsr8dhX6Tb8BlH4xKRLQ/mQlxnmWIJkzzATi86vUmsAWzp3ML+CGxxgwWf2+OfyT
	Gx80UEI+IBB712adtpbS82uo4YSIFDouFwiy3Qx+MyVzgzJitkXBJqjeeee78VJJWm2jxY
	FRqdHR/aQTEJOvdk7/Bzq6BJv/m4MVo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: linux-kernel@vger.kernel.org, Coly Li <colyli@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] sort.h: hoist cmp_int() into generic header file
Message-ID: <ztruxbvaatkgbngjr42twcpwmsowvpvlzxls6f576nzfqs7po2@ttzbexdvps3h>
References: <20250427201451.900730-1-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427201451.900730-1-pchelkin@ispras.ru>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 27, 2025 at 11:14:49PM +0300, Fedor Pchelkin wrote:
> Deduplicate the same functionality implemented in several places by
> moving the cmp_int() helper macro into linux/sort.h.
> 
> The macro performs a three-way comparison of the arguments mostly useful
> in different sorting strategies and algorithms.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>

Acked-by: Kent Overstreet <kent.overstreet@linux.dev>


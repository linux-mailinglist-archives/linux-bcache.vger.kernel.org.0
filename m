Return-Path: <linux-bcache+bounces-1238-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3304BC4E16D
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 14:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 108364E7092
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 13:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594D2324701;
	Tue, 11 Nov 2025 13:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="CEYcImm+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988B7261B77
	for <linux-bcache@vger.kernel.org>; Tue, 11 Nov 2025 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762867185; cv=none; b=NIeH9JbnfPBPNuQba/4i/X8siavdwM8tbW4VoqHXFOVrsQka00cNv5lqkaFbgKZmkIwNRwzuLZ/6p+pvJrp1VB6S8qo4h4Q8lcGwBUjjVQpWLK1GW1w4/WenvGEi1AzAsvVpUrcARQJ+ptcdanK8rLt4O0Fm4A/9UcTqUcQvioI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762867185; c=relaxed/simple;
	bh=awKwiwuSRCWT0kyJeo4gNkXWoOGLHXIgo4pDjHA1q20=;
	h=Content-Type:Subject:Message-Id:Mime-Version:In-Reply-To:
	 References:To:Cc:Date:From:Content-Disposition; b=bc32nbcFv9hu7lkMJroucs+rNXEf3H5dxIVxUa1NzhzeLT2a7b9Ewz80CjZpJ2FWghARZXibJy81Bz/rMnXjy2QY1McLzOcr+697DMDXyiMXJMquB/k+SW2RRO0INXxnrY2tRXJHsCC9YPM0mgLe8H7GFh2ikGEI4Uxaa+OKlqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=CEYcImm+; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762867052;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=pKv8Nt8oRFQ94pEmzKvEJBVB1zRjVj1//CmenNLWeXM=;
 b=CEYcImm+Dy90JNYfuqv/t5wwAjsgUIm75nMIZ0b56Z+bmvM+DLBygTiCnFO9E/zgN97yuq
 yP5VDSzLw/R61qymd3sHlLziPZIKa3bm6RYkjLLNKqth+Mb1AeWLxiLGt50PUvlxPHMaK1
 HiqFrz3Yjs+pJMO25PI7phIkdEJd3qwTewdD3ycU3eUO1zFTwgtdt3qoJ/NIn636OSaNz+
 eWso5SqgzBhzkPMBQvtcc7ZDGRcdcZQlLegpZO6Z3GrWfp++iYDYq/n6pTi+UDzxFzd74Q
 3X686Uua446W6hg0XaFj+BrN2Jg6vUBIBnowax+yVwPW8JaRsLqwjBJ7iNp4nQ==
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH][next] bcache: Avoid -Wflex-array-member-not-at-end warning
Message-Id: <7g2dkwi2nzxe2luykodsknobzr5bkl23d5mbahkyo7adhg55oy@6uisoc7jzgy6>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <aRHFchrO3BmVMH5c@kspp>
References: <aRHFchrO3BmVMH5c@kspp>
X-Lms-Return-Path: <lba+26913376a+96212c+vger.kernel.org+colyli@fnnas.com>
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>
Date: Tue, 11 Nov 2025 21:17:28 +0800
X-Original-From: Coly Li <colyli@fnnas.com>
Received: from studio.coly ([120.245.64.178]) by smtp.feishu.cn with ESMTPS; Tue, 11 Nov 2025 21:17:29 +0800
From: "Coly Li" <colyli@fnnas.com>
Content-Disposition: inline

On Mon, Nov 10, 2025 at 07:58:58PM +0800, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Use the new TRAILING_OVERLAP() helper to fix the following warning:
> 
> drivers/md/bcache/bset.h:330:27: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> This helper creates a union between a flexible-array member (FAM) and a
> set of MEMBERS that would otherwise follow it.
> 
> This overlays the trailing MEMBER struct btree_iter_set stack_data[MAX_BSETS];
> onto the FAM struct btree_iter::data[], while keeping the FAM and the start
> of MEMBER aligned.
> 
> The static_assert() ensures this alignment remains, and it's
> intentionally placed inmediately after the corresponding structures --no
> blank line in between.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/md/bcache/bset.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index 011f6062c4c0..6ee2c6a506a2 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -327,9 +327,13 @@ struct btree_iter {
>  /* Fixed-size btree_iter that can be allocated on the stack */
>  
>  struct btree_iter_stack {
> -	struct btree_iter iter;
> -	struct btree_iter_set stack_data[MAX_BSETS];
> +	/* Must be last as it ends in a flexible-array member. */
> +	TRAILING_OVERLAP(struct btree_iter, iter, data,
> +		struct btree_iter_set stack_data[MAX_BSETS];
> +	);
>  };
> +static_assert(offsetof(struct btree_iter_stack, iter.data) ==
> +	      offsetof(struct btree_iter_stack, stack_data));
> 

I have to say this is ugly. Not the patch, but the gcc 14 warning option
of such coding style. Look at TRAILING_OVERLAP() usage here, this is not
C, this is something to fix a gcc bug which cannot handle FAM properly.

Gustavo, this complain is not to you, just I feel a bit sad how GCC makes
the code comes to such an ugly way, and it makes things much complicated.
For anyone doesn't have deep understanding of TRAILING_OVERLAP(), I
highly suspect whether he or she can understand what happens here.

Andrew and Gustavo, is this a mandatary to fix FAM in such way? If yes
I take the patch and keep my own opinion. If not, I'd like to see gcc
fixes its bug, for the this code I don't see the author does things
wrong.

Coly Li


Return-Path: <linux-bcache+bounces-1229-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D4C62BFF34F
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Oct 2025 07:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 80A273567EC
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Oct 2025 05:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFD92505AF;
	Thu, 23 Oct 2025 05:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="dNep91em"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5942C78F20
	for <linux-bcache@vger.kernel.org>; Thu, 23 Oct 2025 05:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761195650; cv=none; b=XQqJaLd1E0J8tzXZ7jJjH8gWsjHPFr0CWOHZpkkql0G0f/KKF7fjHym++Bcv0h3/BboZeJ9t/fUPrb+HNigQn32PA+SmXFadT9pCgRwmQ35rZ8H/XsNsk1c+pvOMpK9VT1GJjsQdqEDU+cvnMeFLNKC92FHUOdnchA2ELR1bL2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761195650; c=relaxed/simple;
	bh=FQXTnbv1bvauZj78N7ykzqkq6dv7hrF3chrA44wxY4M=;
	h=Subject:Content-Type:Content-Disposition:From:Mime-Version:Cc:
	 Message-Id:References:To:In-Reply-To:Date; b=FhjDxzOnwHrF+6h4UNyVfdDMR/BOKgj+DRDRZSoQH0eU4cqsl33UuO9qxh8laxJrEEz0dJfBJ3yq9pzEUNe9Ux70GnmKXaduLQFp6LfcqnvkwyZlZuP43AgK9XeORhLP95pqxMu4MY1natX+qny3UYnCeL0/Exc4tzxzWQZH8lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=dNep91em; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761195631;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IqBun6SK5zYteTMRGeM2xa7tDPOyynjGF6PVhLTaUDs=;
 b=dNep91emgreCQ7xN8XskQY+Z1EewBPRGsT5qksW3yxPIQqTZYXzSJgkp3VSyyjfBaHg5Iz
 cARjOJRwh/UERU/lLTt3mVBDz9musmLyJPmyvqOHSx9vUsNjptTLt9FTavUu2G0/qglI7y
 HppAIGgPCzOj8DLJFfzh6dSs2VXQdV4cr9CP5SCAjWrwGx/710lxsvN87V8UQHcEPiy/VR
 N1PJbbUR9VulWGDkXcWKe26zxWqjPe6ZMVTd0wPH0D71E/vSX18qTQ1p+iLLt81TGaHsrp
 QezTSm2Z7SNq2wNdKKLX6AUhU4/P4CBafRt0YNTsgmrM/7FXnrsUY3j4DotSww==
Subject: Re: [PATCH v2] bcache: Use vmalloc_array() to improve code
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Received: from studio.lan ([120.245.65.31]) by smtp.feishu.cn with ESMTPS; Thu, 23 Oct 2025 13:00:28 +0800
Content-Transfer-Encoding: 7bit
From: "Coly Li" <colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <john.g.garry@oracle.com>, <kent.overstreet@linux.dev>, 
	<linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <pnqowugugnnhnaibg5jikdwowv5ycwtcwarddopfylwk6wbvik@t5kwuwukt2ga>
X-Lms-Return-Path: <lba+268f9b66d+e91ff5+vger.kernel.org+colyli@fnnas.com>
References: <20251023022642.742834-1-tanze@kylinos.cn>
To: "tanze" <tanze@kylinos.cn>
In-Reply-To: <20251023022642.742834-1-tanze@kylinos.cn>
Date: Thu, 23 Oct 2025 13:00:26 +0800

On Thu, Oct 23, 2025 at 10:26:42AM +0800, tanze wrote:
> Remove array_size() calls and replace vmalloc(),
> due to vmalloc_array() being optimized better,
> using fewer instructions, and handling overflow more concisely.
> 
> Signed-off-by: tanze <tanze@kylinos.cn>
> ---
> Hi, Coly Li.
> 
> Thank you for your suggestions. 
> I have made revisions according to your requirements. 
> Do you have any further suggestions?
> 
> ---
> Changes in v2:
> - Fix coding style and formatting issues.
> ---
>  drivers/md/bcache/sysfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 826b14cae4e5..1ecd2cb3d302 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -1061,8 +1061,8 @@ SHOW(__bch_cache)
>  		uint16_t q[31], *p, *cached;
>  		ssize_t ret;
>  
> -		cached = p = vmalloc(array_size(sizeof(uint16_t),
> -						ca->sb.nbuckets));
> +		cached = p = vmalloc_array(ca->sb.nbuckets, sizeof(uint16_t));
> +
^^^^-> this empty line is new in v2 patch, and I would suggest to remove it.


>  		if (!p)
>  			return -ENOMEM;

Rested part looks fine.

Thanks.

Coly Li


Return-Path: <linux-bcache+bounces-1225-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8B6BFBC58
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Oct 2025 14:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98C1319A132F
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Oct 2025 12:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E53533F8C7;
	Wed, 22 Oct 2025 12:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="f9z5XYmo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF630506E
	for <linux-bcache@vger.kernel.org>; Wed, 22 Oct 2025 12:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761134681; cv=none; b=mXpf6HmC+1h6+I9B4GYJMo7iqDJ/5MttWiinpDEhLgkz8Lj4CBoUpTS91vu5qQdVlWwBpDhhOs/in2a9zxpuhv8JKxLM9p1jkuRrCUUoslu0vrZ44hhCriG+59NvFCf09UdBcpF/UpWcBdzCy2mHehdASj0nlizErKjCnSz3zCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761134681; c=relaxed/simple;
	bh=i6dcns4rfVr5VbGGPnenj2tbF84Z/fVXCBxxl9IrQ1g=;
	h=Subject:Message-Id:In-Reply-To:From:To:Cc:Date:Mime-Version:
	 Content-Type:Content-Disposition:References; b=O2qU8Vx4XqHAd7zoM+3hDFngzq6UQx6tYtSY3imlC8gjvicLuFK6hF6FaH1gtuLQH06xx87xvIv0DY4SD371b8cwZCMMEZoz4o2MxomuwcMaA77z0PwDgwYOmYNf0fYT1ELIiWNLvmspEl1h/xLZyZfsf5P42Nlo5NSbclX7ybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=f9z5XYmo; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761134626;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uWVXxPUe4aOEyytuKBvG8xN7BzM5nAQ8VOqRB60qzJc=;
 b=f9z5XYmonRP+AKZyiCcnnchsDw4yG9XtadOCKbUw4OQMPwNk+01dp/yNC8lL7kUUABbHpA
 Dr9MitEs+0mcPscidocboI5b6Q46arScRge1n9Klahu6H7zmN7ZD9C8pPTsPLT2QL4jV0X
 u4Nv/AYCrsyntVaTN7nMNLQ0nyLsztGh8StSObppyRtBQvGs3ZvKxNDctk/oWqImM56Fw/
 RCGcVIg0K9IwekBpNC2yq+06DTArc7BFQ5z+fYMxUEplUZ2YstCJV0GbQeFN+kNG6L5kI2
 izGrBt21HgJxyT31DfUMAETb/dsCBn451qGbhVAMtmBN8Ap0y72dNVmr0sKGOA==
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] bcache: Use vmalloc_array() to improve code
Message-Id: <bb26wdvihppk6wjpy3ysijfxaj6kofw7zbich4b72bwwnl7fec@cpkvrdhpkj3e>
X-Lms-Return-Path: <lba+268f8c820+af4560+vger.kernel.org+colyli@fnnas.com>
In-Reply-To: <20251017111306.239064-1-tanze@kylinos.cn>
From: "Coly Li" <colyli@fnnas.com>
Received: from studio.lan ([120.245.65.31]) by smtp.feishu.cn with ESMTPS; Wed, 22 Oct 2025 20:03:43 +0800
X-Original-From: Coly Li <colyli@fnnas.com>
To: "tanze" <tanze@kylinos.cn>
Cc: <kent.overstreet@linux.dev>, <john.g.garry@oracle.com>, 
	<linux-kernel@vger.kernel.org>, <linux-bcache@vger.kernel.org>
Date: Wed, 22 Oct 2025 20:03:42 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20251017111306.239064-1-tanze@kylinos.cn>

On Fri, Oct 17, 2025 at 07:13:06PM +0800, tanze wrote:
> Remove array_size() calls and replace vmalloc(), Due to vmalloc_array() is optimized better,
> uses fewer instructions, and handles overflow more concisely[1].
> 
> Signed-off-by: tanze <tanze@kylinos.cn>
> ---
>  drivers/md/bcache/sysfs.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 826b14cae4e5..dc568e8eb6eb 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -1061,8 +1061,7 @@ SHOW(__bch_cache)
>  		uint16_t q[31], *p, *cached;
>  		ssize_t ret;
>  
> -		cached = p = vmalloc(array_size(sizeof(uint16_t),
> -						ca->sb.nbuckets));
> +		cached = p = vmalloc_array(ca->sb.nbuckets,sizeof(uint16_t));
                                                          ^^^-> a blank missing?
>  		if (!p)
>  			return -ENOMEM;

Except for the missing blank, overall the patch is fine.

BTW, IMHO tanze is not a formal method to spell the name, could you please
use a formal format? It will be helpful to identify your contribution in
future.


Thanks.

Coly Li


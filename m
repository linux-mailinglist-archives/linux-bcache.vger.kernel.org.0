Return-Path: <linux-bcache+bounces-494-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3D38D1049
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 00:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EADDB1C20C34
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 22:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9560160880;
	Mon, 27 May 2024 22:33:39 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CDE2208E
	for <linux-bcache@vger.kernel.org>; Mon, 27 May 2024 22:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716849219; cv=none; b=jhF8/AfSwyt3jwdi0d7F4FYZOT5aJD4F5EDIOzIwSmy+9CiGNij1OM1JxbLM2AkKNBl70doS+1z9vHCLFyEebolutzCyELGWxhugTwE5eOQGKoHxqS1ZeEimNXwKcEwrkflZFcBLoR5bKQB4+gt4muZ9H+n/WYgZZ1+0w38kYwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716849219; c=relaxed/simple;
	bh=aRfMs7+vxJGVhaJeXXqXqhobnIu0xdK730YWAjPrcK8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZwVsrWc+G+m7FV4TGWCqmtpyGbFU4nZDh+ILfghP5NYg1qLp5ht3rYuaL8pqWxNpChy9EpfnL1jdRqfHUuQt0gKai5TTPpoS7+DMcELHjnqZi0wiWLZlLO+POgrarbwLSz1Mrm8MyZrjwhAMWVtr9K3fdugM9J2gikbEj/ZZW1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id BCD7C85;
	Mon, 27 May 2024 15:33:37 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JCqp9_IB8PBB; Mon, 27 May 2024 15:33:33 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id E535245;
	Mon, 27 May 2024 15:33:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net E535245
Date: Mon, 27 May 2024 15:33:32 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Coly Li <colyli@suse.de>
cc: linux-bcache@vger.kernel.org
Subject: Re: [PATCH 3/3] bcache: code cleanup in __bch_bucket_alloc_set()
In-Reply-To: <20240527174733.16351-2-colyli@suse.de>
Message-ID: <c6e740e5-6e9-4c43-9cfd-5ff1e52a986@ewheeler.net>
References: <20240527174733.16351-1-colyli@suse.de> <20240527174733.16351-2-colyli@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 28 May 2024, Coly Li wrote:
> In __bch_bucket_alloc_set() the lines after lable 'err:' indeed do
> nothing useful after multiple cache devices are removed from bcache
> code. This cleanup patch drops the useless code to save a bit CPU
> cycles.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/alloc.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 32a46343097d..48ce750bf70a 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -498,8 +498,8 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
>  
>  	ca = c->cache;
>  	b = bch_bucket_alloc(ca, reserve, wait);
> -	if (b == -1)
> -		goto err;
> +	if (b < 0)
> +		return -1;
>  
>  	k->ptr[0] = MAKE_PTR(ca->buckets[b].gen,
>  			     bucket_to_sector(c, b),
> @@ -508,10 +508,6 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
>  	SET_KEY_PTRS(k, 1);
>  
>  	return 0;
> -err:
> -	bch_bucket_free(c, k);
> -	bkey_put(c, k);


Is there a matching "get" somewhere that should be removed, too?

--
Eric Wheeler



> -	return -1;
>  }
>  
>  int bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
> -- 
> 2.35.3
> 
> 
> 


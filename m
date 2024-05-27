Return-Path: <linux-bcache+bounces-493-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 789148D1046
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 00:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301A31F22052
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 22:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A150167DA8;
	Mon, 27 May 2024 22:31:41 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CCD167268
	for <linux-bcache@vger.kernel.org>; Mon, 27 May 2024 22:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.205.220.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716849101; cv=none; b=G1En0av/IA4/X6dTBXHwFjCG1OCZFwxFZmGaNDErXScUwqrgp/xxAZIzcPXvZf0mk6nwCSDoBl6hRG1N/oKUJ+TC58mRNCHIQg+3vdPO9FxIV0AraSgsy+K9jnPUyohMj29zutTLFeCvn6i2d8VqWNW5XZSkBHUKUh/pfwxu2KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716849101; c=relaxed/simple;
	bh=Ev66zCCgIQYvu4jxXu5NrB6wRN0mSgHPhHlbuJAZ2IM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=INGbj0ofgRabRvVqv9q9OBwdE7jPy+fjLoZSZ88GGlx4K3flfgfpN2+U5/mFhUNB/uwF8se8PUeJvI3gxYe9KUGNP47AwM2Ga+Y9om17bClJEGsMZmd6Ar4EwOFwFQkj8XgWHRRnKHdtlwYSJOEA/A/4dp55z5dVQ9kC4u6MADQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net; spf=none smtp.mailfrom=lists.ewheeler.net; arc=none smtp.client-ip=173.205.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lists.ewheeler.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=lists.ewheeler.net
Received: from localhost (localhost [127.0.0.1])
	by mx.ewheeler.net (Postfix) with ESMTP id 1D72C85;
	Mon, 27 May 2024 15:31:39 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
	by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id OBgejTELjC0I; Mon, 27 May 2024 15:31:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx.ewheeler.net (Postfix) with ESMTPSA id 697D245;
	Mon, 27 May 2024 15:31:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 697D245
Date: Mon, 27 May 2024 15:31:34 -0700 (PDT)
From: Eric Wheeler <bcache@lists.ewheeler.net>
To: Coly Li <colyli@suse.de>
cc: linux-bcache@vger.kernel.org
Subject: Re: [PATCH 2/3] bcache: call force_wake_up_gc() if necessary in
 check_should_bypass()
In-Reply-To: <20240527174733.16351-1-colyli@suse.de>
Message-ID: <1f87c967-d593-b11c-55e8-a2b7a0a75c2@ewheeler.net>
References: <20240527174733.16351-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 28 May 2024, Coly Li wrote:

> If there are extreme heavy write I/O continuously hit on relative small
> cache device (512GB in my testing), it is possible to make counter
> c->gc_stats.in_use continue to increase and exceed CUTOFF_CACHE_ADD.
> 
> If 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, all following write
> requests will bypass the cache device because check_should_bypass()
> returns 'true'. Because all writes bypass the cache device, counter
> c->sectors_to_gc has no chance to be negative value, and garbage
> collection thread won't be waken up even the whole cache becomes clean
> after writeback accomplished. The aftermath is that all write I/Os go
> directly into backing device even the cache device is clean.
> 
> To avoid the above situation, this patch uses a quite conservative way
> to fix: if 'c->gc_stats.in_use > CUTOFF_CACHE_ADD' happens, only wakes
> up garbage collection thread when the whole cache device is clean.

Nice fix.

If I understand correctly, even with this fix, bcache can reach a point 
where it must wait until garbage collection frees a bucket (via 
force_wake_up_gc) before buckets can be used again.  Waiting to call 
force_wake_up_gc until `c->gc_stats.in_use` exceeds CUTOFF_CACHE_ADD may 
not respond as fast as it could, and IO latency is important.

It may be a good idea to do `c->gc_stats.in_use > CUTOFF_CACHE_ADD/2` to
start garbage collection when it is half-way "full".

Reaching 50% is still quite conservative, but if you want to wait longer, 
then even 80% or 90% would be fine; however, I think 100% is too far.  We 
want to avoid the case where bcache is completely "out" of buckets and we 
have to wait for garbage collection latency before a cache bucket can 
fill, since buckets should be available.

For example on our system we have 736824 buckets available:
	# cat /sys/devices/virtual/block/dm-9/bcache/nbuckets
	736824

There should be no reason to wait until all buckets are exhausted. Forcing 
garbage collection at 50% (368412 buckets "in use") would be good house 
keeping.

You know this code very well so if I have misinterpreted something here, 
then please fill me in on the details.

--
Eric Wheeler


> 
> Before the fix, the writes-always-bypass situation happens after 10+
> hours write I/O pressure on 512GB Intel optane memory which acts as
> cache device. After this fix, such situation doesn't happen after 36+
> hours testing.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/request.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 83d112bd2b1c..af345dc6fde1 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -369,10 +369,24 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>  	struct io *i;
>  
>  	if (test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags) ||
> -	    c->gc_stats.in_use > CUTOFF_CACHE_ADD ||
>  	    (bio_op(bio) == REQ_OP_DISCARD))
>  		goto skip;
>  
> +	if (c->gc_stats.in_use > CUTOFF_CACHE_ADD) {
> +		/*
> +		 * If cached buckets are all clean now, 'true' will be
> +		 * returned and all requests will bypass the cache device.
> +		 * Then c->sectors_to_gc has no chance to be negative, and
> +		 * gc thread won't wake up and caching won't work forever.
> +		 * Here call force_wake_up_gc() to avoid such aftermath.
> +		 */
> +		if (BDEV_STATE(&dc->sb) == BDEV_STATE_CLEAN &&
> +		    c->gc_mark_valid)
> +			force_wake_up_gc(c);
> +
> +		goto skip;
> +	}
> +
>  	if (mode == CACHE_MODE_NONE ||
>  	    (mode == CACHE_MODE_WRITEAROUND &&
>  	     op_is_write(bio_op(bio))))
> -- 
> 2.35.3
> 
> 
> 


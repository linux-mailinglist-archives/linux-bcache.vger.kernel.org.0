Return-Path: <linux-bcache+bounces-877-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8165AA891C6
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 04:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DCBD160F89
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 02:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523AC19F133;
	Tue, 15 Apr 2025 02:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fL3CmXtM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC8C3C463
	for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 02:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744682921; cv=none; b=ZEgtXrBEknXvZnVizi8sBv2o8Kq2Juf0F1XZmgFU89yUPfZSWQ6w4cLn1qTOhTcjuC2psojd3axOjd4A/bxYf8uuuRHd4PXwAPNi+dPUS+ulnBatD8mOcCJzP6vwVR+o1PDDmsoBWPVUw1znPl5/zrtLH77WnhUtrFi8h6F12Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744682921; c=relaxed/simple;
	bh=WNfBR7KbIwPp09spdtobuccvaPpBEGf7g+6gg/nl6QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4UM7AtcDw1jrzOW0+Fv/+fq7ST69dTnI1dFETAFFrAMnFkNiQ91GTEfiwiheqQGu+luleKlfKj6JqHivK4TyFRN5PLUqa4M1taxvCqIuB/CgjwTlFoKt7NVZAgFll4I4fpstRyPOjM+/VOmowNGOhsDYw4JJBC+lBO4rM2LCQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fL3CmXtM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692B3C4CEE2;
	Tue, 15 Apr 2025 02:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744682920;
	bh=WNfBR7KbIwPp09spdtobuccvaPpBEGf7g+6gg/nl6QA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fL3CmXtMac8Pkr01IC4dGjPNK/Tp2nOMquWHQiipzgVxt5iOANlTLCFa/4tnrjNf/
	 nxaJHnvo/izVdeDv6wA8HKp2/rHnk4IL7eibS1g6wPfnAkLJ12TXBN2YXCgXwqIGyQ
	 3NRykbPEf98teAxsgSMCsfkVAC3T66MdVmdSs0ufkoUkSW3YC/ont6OgrFFagzgmgf
	 bcyQc6mZEl7MIyu8+5TzPHW8XVCp1lmrr+L6L21vnD+wK3wIZa/AnazACI9r1m1PiM
	 7Q34x0yHBbkBi/hOTp+/wDWB4pIj1HZcrOzLmfQoL8l78UihY1RzNOrF011vFI4x07
	 ARgnmbqTnYhFg==
Date: Tue, 15 Apr 2025 10:08:37 +0800
From: Coly Li <colyli@kernel.org>
To: Robert Pang <robertpang@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 1/1] bcache: process fewer btree nodes in incremental GC
 cycles
Message-ID: <6bqyfgs2oq7fjn5an533yoi23fpttwdoyhrtqku6xm77j6zw45@mmptlxdk2ukm>
References: <20250414224415.77926-1-robertpang@google.com>
 <20250414224415.77926-2-robertpang@google.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250414224415.77926-2-robertpang@google.com>

On Mon, Apr 14, 2025 at 03:44:04PM +0800, Robert Pang wrote:
> Current incremental GC processes a minimum of 100 btree nodes per cycle,
> followed by a 100ms sleep. For NVMe cache devices, where the average node
> processing time is ~1ms, this leads to front-side I/O latency potentially
> reaching tens or hundreds of milliseconds during GC execution.
> 
> This commit resolves this latency issue by reducing the minimum node processing
> count per cycle to 10 and the inter-cycle sleep duration to 10ms. It also
> integrates a check of existing GC statistics to re-scale the number of nodes
> processed per sleep interval when needed, ensuring GC finishes well before the
> next GC is due.
> 
> Signed-off-by: Robert Pang <robertpang@google.com>
> ---
>  drivers/md/bcache/btree.c | 38 +++++++++++++++++---------------------
>  drivers/md/bcache/util.h  |  3 +++
>  2 files changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index ed40d8600656..093e1edcaa53 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -88,11 +88,8 @@
>   * Test module load/unload
>   */
>  
> -#define MAX_NEED_GC		64
> -#define MAX_SAVE_PRIO		72

You may compose another patch for the above changes, to separte them
from main idea of this patch.

> -#define MAX_GC_TIMES		100
> -#define MIN_GC_NODES		100
> -#define GC_SLEEP_MS		100
> +#define GC_MIN_NODES		10
> +#define GC_SLEEP_MS		10
>  
>  #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
>  
> @@ -1585,25 +1582,24 @@ static unsigned int btree_gc_count_keys(struct btree *b)
>  
>  static size_t btree_gc_min_nodes(struct cache_set *c)
>  {
> -	size_t min_nodes;
> +	size_t min_nodes = GC_MIN_NODES;
> +	uint64_t gc_max_ms = time_stat_average(&c->btree_gc_time, frequency, ms) / 2;
>  
>  	/*
> -	 * Since incremental GC would stop 100ms when front
> -	 * side I/O comes, so when there are many btree nodes,
> -	 * if GC only processes constant (100) nodes each time,
> -	 * GC would last a long time, and the front side I/Os
> -	 * would run out of the buckets (since no new bucket
> -	 * can be allocated during GC), and be blocked again.
> -	 * So GC should not process constant nodes, but varied
> -	 * nodes according to the number of btree nodes, which
> -	 * realized by dividing GC into constant(100) times,
> -	 * so when there are many btree nodes, GC can process
> -	 * more nodes each time, otherwise, GC will process less
> -	 * nodes each time (but no less than MIN_GC_NODES)
> +	 * The incremental garbage collector operates by processing
> +	 * GC_MIN_NODES at a time, pausing for GC_SLEEP_MS between
> +	 * each interval. If historical garbage collection statistics
> +	 * (btree_gc_time) is available, the maximum allowable GC
> +	 * duration is set to half of this observed frequency. To
> +	 * prevent exceeding this maximum duration, the number of
> +	 * nodes processed in the current step may be increased if
> +	 * the projected completion time based on the current pace
> +	 * extends beyond the allowed limit. This ensures timely GC
> +	 * completion before the next GC is due.
>  	 */
> -	min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
> -	if (min_nodes < MIN_GC_NODES)
> -		min_nodes = MIN_GC_NODES;
> +	if ((gc_max_ms >= GC_SLEEP_MS) &&
> +	    (GC_SLEEP_MS * (c->gc_stats.nodes / min_nodes)) > gc_max_ms)
> +		min_nodes = c->gc_stats.nodes / (gc_max_ms / GC_SLEEP_MS);
>  

Is it possible that gc_max_ms becomes 0?


>  	return min_nodes;
>  }
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index 539454d8e2d0..21a370f444b7 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -305,6 +305,9 @@ static inline unsigned int local_clock_us(void)
>  #define NSEC_PER_ms			NSEC_PER_MSEC
>  #define NSEC_PER_sec			NSEC_PER_SEC
>  
> +#define time_stat_average(stats, stat, units)				\
> +	div_u64((stats)->average_ ## stat >> 8, NSEC_PER_ ## units)
> +

Could you please add a few code comments here to explain what does
time_stat_average() do?


Thanks in advance.

>  #define __print_time_stat(stats, name, stat, units)			\
>  	sysfs_print(name ## _ ## stat ## _ ## units,			\
>  		    div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
> -- 
> 2.49.0.604.gff1f9ca942-goog
> 

-- 
Coly Li


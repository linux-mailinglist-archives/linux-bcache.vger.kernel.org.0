Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8B750A0D3
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Apr 2022 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiDUNbS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 21 Apr 2022 09:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiDUNbR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Apr 2022 09:31:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771AA37031
        for <linux-bcache@vger.kernel.org>; Thu, 21 Apr 2022 06:28:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 32780210E8;
        Thu, 21 Apr 2022 13:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650547706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MVNq4YzktcXldzwasOZMw8JMhM8g21ou2dhkJ1tOW1E=;
        b=S3PbVbHIoEoEZlEjtYmOPHNCbv+DJrAhKyN/xtfyQ2QgEMXxQRInwmA+9evmJLe/1d2BSq
        Qd0Ky+k7ATWL/FCxryoDH8E/pqgZRTwr93L75RMB1JnniyLVrdmfV5LbokcV82/7tGkT9d
        ZQ0HNseDt0E6iz7zJfXorUqSI7Pln30=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650547706;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MVNq4YzktcXldzwasOZMw8JMhM8g21ou2dhkJ1tOW1E=;
        b=jOFhH6aEPJ6vB5LZeONCrP5OXOTgG47UjiV7lq0t//Sz/g8GFpBaKvFBxEUl5xa2AuuBCc
        lO01ceGvpXymPXAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 89F8C13446;
        Thu, 21 Apr 2022 13:28:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Q5o1KvdbYWItNAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 21 Apr 2022 13:28:23 +0000
Message-ID: <1a198363-caba-6f20-c448-6b46f3d8ddf6@suse.de>
Date:   Thu, 21 Apr 2022 21:28:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH] bcache: dynamic incremental gc
Content-Language: en-US
To:     mingzhe.zou@easystack.cn
Cc:     zoumingzhe@qq.com, linux-bcache@vger.kernel.org
References: <20220421121735.11591-1-mingzhe.zou@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220421121735.11591-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/21/22 8:17 PM, mingzhe.zou@easystack.cn wrote:
> From: ZouMingzhe <mingzhe.zou@easystack.cn>
>
> During GC, IO performance would be reduced by half or more.
> According to our test data, when nvme is used as the cache,
> it takes about 1ms for GC to handle each node (block 4k and
> bucket 512k).
>
> So, GC process at least 100 nodes each time, resulting in
> IOPS decreasing by half and latency increasing.
>
> This patch add some cost statistics and hold the inflight peak.
> When IO depth up to maximum, gc sleep and handle these requests.
> GC sleep time dynamically calculate based on gc_cost.

Hi Mingzhe,

What the problem this patch intends to solve, and what is the result of 
the change?


Thanks.

Coly Li


> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>   drivers/md/bcache/bcache.h |  8 ++++
>   drivers/md/bcache/btree.c  | 83 ++++++++++++++++++++++++++++++++------
>   2 files changed, 78 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 9ed9c955add7..065a1137db68 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -471,6 +471,14 @@ struct cache {
>   };
>   
>   struct gc_stat {
> +	uint64_t		gc_cost;
> +	uint64_t		sleep_cost;
> +	uint64_t		average_cost;
> +	uint64_t		start_time;
> +	uint64_t		finish_time;
> +	size_t			max_inflight;
> +
> +	size_t			times;
>   	size_t			nodes;
>   	size_t			nodes_pre;
>   	size_t			key_bytes;
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index f5f2718e03e5..fc721f216eb7 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -88,11 +88,12 @@
>    * Test module load/unload
>    */
>   
> -#define MAX_NEED_GC		64
> -#define MAX_SAVE_PRIO		72
>   #define MAX_GC_TIMES		100
>   #define MIN_GC_NODES		100
> -#define GC_SLEEP_MS		100
> +#define MAX_GC_NODES		1000
> +#define MAX_GC_PERCENT		10
> +#define MIN_GC_SLEEP_MS		10
> +#define MAX_GC_SLEEP_MS		1000
>   
>   #define PTR_DIRTY_BIT		(((uint64_t) 1 << 36))
>   
> @@ -1542,12 +1543,56 @@ static unsigned int btree_gc_count_keys(struct btree *b)
>   	return ret;
>   }
>   
> -static size_t btree_gc_min_nodes(struct cache_set *c)
> +static uint64_t btree_gc_sleep_ms(struct cache_set *c, struct gc_stat *gc)
> +{
> +	uint64_t now = local_clock();
> +	uint64_t expect_time, sleep_time = 0;
> +
> +	/*
> +	 * GC maybe process very few nodes when IO requests are very frequent.
> +	 * If the sleep time is constant (100ms) each time, whole GC would last
> +	 * a long time.
> +	 * The IO performance also decline if a single GC takes a long time
> +	 * (such as single GC 100ms and sleep 100ms, IOPS is only half).
> +	 * So GC sleep time should be calculated dynamically based on gc_cost.
> +	 */
> +	gc->finish_time = time_after64(now, gc->start_time)
> +				? now - gc->start_time : 0;
> +	gc->gc_cost = gc->finish_time > gc->sleep_cost
> +			? gc->finish_time - gc->sleep_cost : 0;
> +	expect_time = div_u64(gc->gc_cost * (100 - MAX_GC_PERCENT), MAX_GC_PERCENT);
> +	if (expect_time > gc->sleep_cost)
> +		sleep_time = div_u64(expect_time - gc->sleep_cost, NSEC_PER_MSEC);
> +
> +	if (sleep_time < MIN_GC_SLEEP_MS)
> +		sleep_time = MIN_GC_SLEEP_MS;
> +	if (sleep_time > MAX_GC_SLEEP_MS)
> +		sleep_time = MAX_GC_SLEEP_MS;
> +
> +	return sleep_time;
> +}
> +
> +static size_t btree_gc_min_nodes(struct cache_set *c, struct gc_stat *gc)
>   {
>   	size_t min_nodes;
> +	size_t inflight;
> +
> +	/*
> +	 * If there are no requests, the GC is not stopped. Also, we hope to
> +	 * process the increasing number of IO requests immediately and hold
> +	 * the inflight peak. When IO depth up to maximum, gc sleep and handle
> +	 * these requests.
> +	 */
> +	inflight = atomic_read(&c->search_inflight);
> +	if (inflight <= 0)
> +		return max(c->gc_stats.nodes, gc->nodes) + 1;
> +	if (inflight > gc->max_inflight)
> +		gc->max_inflight = inflight;
> +	if (inflight >= gc->max_inflight)
> +		return 1;
>   
>   	/*
> -	 * Since incremental GC would stop 100ms when front
> +	 * Since incremental GC would dynamic sleep when front
>   	 * side I/O comes, so when there are many btree nodes,
>   	 * if GC only processes constant (100) nodes each time,
>   	 * GC would last a long time, and the front side I/Os
> @@ -1558,11 +1603,14 @@ static size_t btree_gc_min_nodes(struct cache_set *c)
>   	 * realized by dividing GC into constant(100) times,
>   	 * so when there are many btree nodes, GC can process
>   	 * more nodes each time, otherwise, GC will process less
> -	 * nodes each time (but no less than MIN_GC_NODES)
> +	 * nodes each time (but no less than MIN_GC_NODES and
> +	 * no more than MAX_GC_NODES)
>   	 */
>   	min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
>   	if (min_nodes < MIN_GC_NODES)
>   		min_nodes = MIN_GC_NODES;
> +	if (min_nodes > MAX_GC_NODES)
> +		min_nodes = MAX_GC_NODES;
>   
>   	return min_nodes;
>   }
> @@ -1633,8 +1681,7 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
>   		memmove(r + 1, r, sizeof(r[0]) * (GC_MERGE_NODES - 1));
>   		r->b = NULL;
>   
> -		if (atomic_read(&b->c->search_inflight) &&
> -		    gc->nodes >= gc->nodes_pre + btree_gc_min_nodes(b->c)) {
> +		if (gc->nodes >= gc->nodes_pre + btree_gc_min_nodes(b->c, gc)) {
>   			gc->nodes_pre =  gc->nodes;
>   			ret = -EAGAIN;
>   			break;
> @@ -1789,7 +1836,7 @@ static void bch_btree_gc(struct cache_set *c)
>   	struct gc_stat stats;
>   	struct closure writes;
>   	struct btree_op op;
> -	uint64_t start_time = local_clock();
> +	uint64_t sleep_time;
>   
>   	trace_bcache_gc_start(c);
>   
> @@ -1798,24 +1845,34 @@ static void bch_btree_gc(struct cache_set *c)
>   	bch_btree_op_init(&op, SHRT_MAX);
>   
>   	btree_gc_start(c);
> +	stats.start_time = local_clock();
>   
>   	/* if CACHE_SET_IO_DISABLE set, gc thread should stop too */
>   	do {
> +		stats.times++;
>   		ret = bcache_btree_root(gc_root, c, &op, &writes, &stats);
>   		closure_sync(&writes);
>   		cond_resched();
>   
> -		if (ret == -EAGAIN)
> +		sleep_time = btree_gc_sleep_ms(c, &stats);
> +		if (ret == -EAGAIN) {
> +			stats.sleep_cost += sleep_time * NSEC_PER_MSEC;
>   			schedule_timeout_interruptible(msecs_to_jiffies
> -						       (GC_SLEEP_MS));
> -		else if (ret)
> +						       (sleep_time));
> +		} else if (ret)
>   			pr_warn("gc failed!\n");
>   	} while (ret && !test_bit(CACHE_SET_IO_DISABLE, &c->flags));
>   
>   	bch_btree_gc_finish(c);
>   	wake_up_allocators(c);
>   
> -	bch_time_stats_update(&c->btree_gc_time, start_time);
> +	bch_time_stats_update(&c->btree_gc_time, stats.start_time);
> +	stats.average_cost = stats.gc_cost / stats.nodes;
> +	pr_info("gc %llu times with %llu nodes, sleep %llums, "
> +		"average gc cost %lluus per node",
> +		(uint64_t)stats.times, (uint64_t)stats.nodes,
> +		div_u64(stats.sleep_cost, NSEC_PER_MSEC),
> +		div_u64(stats.average_cost, NSEC_PER_USEC));
>   
>   	stats.key_bytes *= sizeof(uint64_t);
>   	stats.data	<<= 9;



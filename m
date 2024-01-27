Return-Path: <linux-bcache+bounces-251-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CF1B83EB98
	for <lists+linux-bcache@lfdr.de>; Sat, 27 Jan 2024 08:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0EDF1C2186D
	for <lists+linux-bcache@lfdr.de>; Sat, 27 Jan 2024 07:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6323C1D524;
	Sat, 27 Jan 2024 07:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z5tnlT+L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9XokEcRo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z5tnlT+L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9XokEcRo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66DB1D698;
	Sat, 27 Jan 2024 07:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706339379; cv=none; b=mZl/1PeyrikdhwD1WRgHramrr9JqmR/Pi3wXZhWszs5uIUgkYQKkNo7BdGCNsBuF06D3CWPVu2EMjYAXgnWHG9vG30MNA8ZCqstndEVf7qftGl5aMnbIRCy0uYtHiSGe3Fjnj7lEaM6+hQ4J2pkKwHyLPZF1sZBEuPmHw39WJGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706339379; c=relaxed/simple;
	bh=nJ3XMpyBdAn4KVx/zA5UMEHZLRQbCPG1Q13J7jJX7BI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDN5jBRBhwsdn4xFy2bhTjGtqAIdI+up1/OBJXow1UBQsWwY+SgTiyV1iLGSFfzdx6kuBA0TE5gG9kvzo+TYIH7xkVWcK/YCp/uUdij9OQa7YG+QHzUji57xzZlpFP8v91FX9HufJi6d84xb+L0FoHAz4UE1S0aBSbNdctL7ddk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z5tnlT+L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9XokEcRo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z5tnlT+L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9XokEcRo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BB225221F6;
	Sat, 27 Jan 2024 07:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706339372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WKhB/abyTpWx61dLe773hcrF0KdSeDTs/mYA9fZ79us=;
	b=Z5tnlT+LPC/WllSBav/+mWo0ND+TYTKmKDQt0XHaXelvc+mJRuNwVZR3dolx9PVN7obfdT
	Qny2Cy553U0MRQd/3RgQ2ffHzfLBOIcD764d6slSDaDfqTI0jgAQt3WhFy0ZX2s76DYTof
	CQR90RyyD8w6QdhvpO8q4KyZcCwTbds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706339372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WKhB/abyTpWx61dLe773hcrF0KdSeDTs/mYA9fZ79us=;
	b=9XokEcRoHo3CojZ9MqLRCCfk+stPq/UuDl/PcYdsXKLB9hU3k1CBOSyuHPRWUcbfYcywcJ
	fGckeCykQj2Wv4DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706339372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WKhB/abyTpWx61dLe773hcrF0KdSeDTs/mYA9fZ79us=;
	b=Z5tnlT+LPC/WllSBav/+mWo0ND+TYTKmKDQt0XHaXelvc+mJRuNwVZR3dolx9PVN7obfdT
	Qny2Cy553U0MRQd/3RgQ2ffHzfLBOIcD764d6slSDaDfqTI0jgAQt3WhFy0ZX2s76DYTof
	CQR90RyyD8w6QdhvpO8q4KyZcCwTbds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706339372;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WKhB/abyTpWx61dLe773hcrF0KdSeDTs/mYA9fZ79us=;
	b=9XokEcRoHo3CojZ9MqLRCCfk+stPq/UuDl/PcYdsXKLB9hU3k1CBOSyuHPRWUcbfYcywcJ
	fGckeCykQj2Wv4DQ==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 81FD61329F;
	Sat, 27 Jan 2024 07:09:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id HH3vDCqstGXFRwAAn2gu4w
	(envelope-from <colyli@suse.de>); Sat, 27 Jan 2024 07:09:30 +0000
Date: Sat, 27 Jan 2024 15:09:27 +0800
From: Coly Li <colyli@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 5/5] bcache: Convert to lib/time_stats
Message-ID: <e7kzceocawdddumyjrnaggfu2vkhoyihutlx5azjrmwyicmpht@446bwu3h2hy5>
References: <20240126220655.395093-1-kent.overstreet@linux.dev>
 <20240126220655.395093-5-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240126220655.395093-5-kent.overstreet@linux.dev>
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,linux.dev:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Flag: NO

On Fri, Jan 26, 2024 at 05:06:55PM -0500, Kent Overstreet wrote:
> delete bcache's time stats code, convert to newer version from bcachefs.
> 
> example output:
> 
> root@moria-kvm:/sys/fs/bcache/bdaedb8c-4554-4dd2-87e4-276e51eb47cc# cat internal/btree_sort_times
> count: 6414
>                        since mount        recent
> duration of events
>   min:                          440 ns
>   max:                         1102 us
>   total:                        674 ms
>   mean:                         105 us     102 us
>   stddev:                       101 us      88 us
> time between events
>   min:                          881 ns
>   max:                            3 s
>   mean:                           7 ms       6 ms
>   stddev:                        52 ms       6 ms
> 
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Acked-by: Coly Li <colyli@suse.de>

Thanks.


Coly Li

> ---
>  drivers/md/bcache/Kconfig  |  1 +
>  drivers/md/bcache/bcache.h |  1 +
>  drivers/md/bcache/bset.c   |  6 +++--
>  drivers/md/bcache/bset.h   |  1 +
>  drivers/md/bcache/btree.c  |  6 ++---
>  drivers/md/bcache/super.c  |  7 +++++
>  drivers/md/bcache/sysfs.c  | 25 +++++++++---------
>  drivers/md/bcache/util.c   | 30 ----------------------
>  drivers/md/bcache/util.h   | 52 +++++---------------------------------
>  9 files changed, 37 insertions(+), 92 deletions(-)
> 
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index b2d10063d35f..7ea057983d3d 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -5,6 +5,7 @@ config BCACHE
>  	select BLOCK_HOLDER_DEPRECATED if SYSFS
>  	select CRC64
>  	select CLOSURES
> +	select TIME_STATS
>  	help
>  	Allows a block device to be used as cache for other devices; uses
>  	a btree for indexing and the layout is optimized for SSDs.
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 6ae2329052c9..76e7b494c394 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -186,6 +186,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/rwsem.h>
>  #include <linux/refcount.h>
> +#include <linux/time_stats.h>
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
>  #include <linux/kthread.h>
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 2bba4d6aaaa2..31c08d4ab83b 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -1177,6 +1177,7 @@ struct bkey *bch_btree_iter_next_filter(struct btree_iter *iter,
>  
>  void bch_bset_sort_state_free(struct bset_sort_state *state)
>  {
> +	time_stats_exit(&state->time);
>  	mempool_exit(&state->pool);
>  }
>  
> @@ -1184,6 +1185,7 @@ int bch_bset_sort_state_init(struct bset_sort_state *state,
>  			     unsigned int page_order)
>  {
>  	spin_lock_init(&state->time.lock);
> +	time_stats_init(&state->time);
>  
>  	state->page_order = page_order;
>  	state->crit_factor = int_sqrt(1 << page_order);
> @@ -1286,7 +1288,7 @@ static void __btree_sort(struct btree_keys *b, struct btree_iter *iter,
>  	bch_bset_build_written_tree(b);
>  
>  	if (!start)
> -		bch_time_stats_update(&state->time, start_time);
> +		time_stats_update(&state->time, start_time);
>  }
>  
>  void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
> @@ -1329,7 +1331,7 @@ void bch_btree_sort_into(struct btree_keys *b, struct btree_keys *new,
>  
>  	btree_mergesort(b, new->set->data, &iter, false, true);
>  
> -	bch_time_stats_update(&state->time, start_time);
> +	time_stats_update(&state->time, start_time);
>  
>  	new->set->size = 0; // XXX: why?
>  }
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index d795c84246b0..13e524ad7783 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -3,6 +3,7 @@
>  #define _BCACHE_BSET_H
>  
>  #include <linux/kernel.h>
> +#include <linux/time_stats.h>
>  #include <linux/types.h>
>  
>  #include "bcache_ondisk.h"
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 196cdacce38f..0ed337c5f0dc 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -270,7 +270,7 @@ static void bch_btree_node_read(struct btree *b)
>  		goto err;
>  
>  	bch_btree_node_read_done(b);
> -	bch_time_stats_update(&b->c->btree_read_time, start_time);
> +	time_stats_update(&b->c->btree_read_time, start_time);
>  
>  	return;
>  err:
> @@ -1852,7 +1852,7 @@ static void bch_btree_gc(struct cache_set *c)
>  	bch_btree_gc_finish(c);
>  	wake_up_allocators(c);
>  
> -	bch_time_stats_update(&c->btree_gc_time, start_time);
> +	time_stats_update(&c->btree_gc_time, start_time);
>  
>  	stats.key_bytes *= sizeof(uint64_t);
>  	stats.data	<<= 9;
> @@ -2343,7 +2343,7 @@ static int btree_split(struct btree *b, struct btree_op *op,
>  	btree_node_free(b);
>  	rw_unlock(true, n1);
>  
> -	bch_time_stats_update(&b->c->btree_split_time, start_time);
> +	time_stats_update(&b->c->btree_split_time, start_time);
>  
>  	return 0;
>  err_free2:
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index dc3f50f69714..625e4883299c 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1676,6 +1676,9 @@ static CLOSURE_CALLBACK(cache_set_free)
>  
>  	debugfs_remove(c->debug);
>  
> +	time_stats_exit(&c->btree_read_time);
> +	time_stats_exit(&c->btree_split_time);
> +	time_stats_exit(&c->btree_gc_time);
>  	bch_open_buckets_free(c);
>  	bch_btree_cache_free(c);
>  	bch_journal_free(c);
> @@ -1913,6 +1916,10 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  	INIT_LIST_HEAD(&c->btree_cache_freed);
>  	INIT_LIST_HEAD(&c->data_buckets);
>  
> +	time_stats_init(&c->btree_gc_time);
> +	time_stats_init(&c->btree_split_time);
> +	time_stats_init(&c->btree_read_time);
> +
>  	iter_size = ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size + 1) *
>  		sizeof(struct btree_iter_set);
>  
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index a438efb66069..01cc5c632f08 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -14,6 +14,7 @@
>  #include "features.h"
>  
>  #include <linux/blkdev.h>
> +#include <linux/seq_buf.h>
>  #include <linux/sort.h>
>  #include <linux/sched/clock.h>
>  
> @@ -79,10 +80,10 @@ read_attribute(active_journal_entries);
>  read_attribute(backing_dev_name);
>  read_attribute(backing_dev_uuid);
>  
> -sysfs_time_stats_attribute(btree_gc,	sec, ms);
> -sysfs_time_stats_attribute(btree_split, sec, us);
> -sysfs_time_stats_attribute(btree_sort,	ms,  us);
> -sysfs_time_stats_attribute(btree_read,	ms,  us);
> +read_attribute(btree_gc_times);
> +read_attribute(btree_split_times);
> +read_attribute(btree_sort_times);
> +read_attribute(btree_read_times);
>  
>  read_attribute(btree_nodes);
>  read_attribute(btree_used_percent);
> @@ -743,10 +744,10 @@ SHOW(__bch_cache_set)
>  	sysfs_print(btree_cache_max_chain,	bch_cache_max_chain(c));
>  	sysfs_print(cache_available_percent,	100 - c->gc_stats.in_use);
>  
> -	sysfs_print_time_stats(&c->btree_gc_time,	btree_gc, sec, ms);
> -	sysfs_print_time_stats(&c->btree_split_time,	btree_split, sec, us);
> -	sysfs_print_time_stats(&c->sort.time,		btree_sort, ms, us);
> -	sysfs_print_time_stats(&c->btree_read_time,	btree_read, ms, us);
> +	sysfs_print_time_stats(&c->btree_gc_time,	btree_gc_times);
> +	sysfs_print_time_stats(&c->btree_split_time,	btree_split_times);
> +	sysfs_print_time_stats(&c->sort.time,		btree_sort_times);
> +	sysfs_print_time_stats(&c->btree_read_time,	btree_read_times);
>  
>  	sysfs_print(btree_used_percent,	bch_btree_used(c));
>  	sysfs_print(btree_nodes,	c->gc_stats.nodes);
> @@ -989,10 +990,10 @@ KTYPE(bch_cache_set);
>  static struct attribute *bch_cache_set_internal_attrs[] = {
>  	&sysfs_active_journal_entries,
>  
> -	sysfs_time_stats_attribute_list(btree_gc, sec, ms)
> -	sysfs_time_stats_attribute_list(btree_split, sec, us)
> -	sysfs_time_stats_attribute_list(btree_sort, ms, us)
> -	sysfs_time_stats_attribute_list(btree_read, ms, us)
> +	&sysfs_btree_gc_times,
> +	&sysfs_btree_split_times,
> +	&sysfs_btree_sort_times,
> +	&sysfs_btree_read_times,
>  
>  	&sysfs_btree_nodes,
>  	&sysfs_btree_used_percent,
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index ae380bc3992e..95282bf0f9a7 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -160,36 +160,6 @@ int bch_parse_uuid(const char *s, char *uuid)
>  	return i;
>  }
>  
> -void bch_time_stats_update(struct time_stats *stats, uint64_t start_time)
> -{
> -	uint64_t now, duration, last;
> -
> -	spin_lock(&stats->lock);
> -
> -	now		= local_clock();
> -	duration	= time_after64(now, start_time)
> -		? now - start_time : 0;
> -	last		= time_after64(now, stats->last)
> -		? now - stats->last : 0;
> -
> -	stats->max_duration = max(stats->max_duration, duration);
> -
> -	if (stats->last) {
> -		ewma_add(stats->average_duration, duration, 8, 8);
> -
> -		if (stats->average_frequency)
> -			ewma_add(stats->average_frequency, last, 8, 8);
> -		else
> -			stats->average_frequency  = last << 8;
> -	} else {
> -		stats->average_duration  = duration << 8;
> -	}
> -
> -	stats->last = now ?: 1;
> -
> -	spin_unlock(&stats->lock);
> -}
> -
>  /**
>   * bch_next_delay() - update ratelimiting statistics and calculate next delay
>   * @d: the struct bch_ratelimit to update
> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
> index f61ab1bada6c..6fcb9db4f50d 100644
> --- a/drivers/md/bcache/util.h
> +++ b/drivers/md/bcache/util.h
> @@ -344,20 +344,6 @@ ssize_t bch_hprint(char *buf, int64_t v);
>  bool bch_is_zero(const char *p, size_t n);
>  int bch_parse_uuid(const char *s, char *uuid);
>  
> -struct time_stats {
> -	spinlock_t	lock;
> -	/*
> -	 * all fields are in nanoseconds, averages are ewmas stored left shifted
> -	 * by 8
> -	 */
> -	uint64_t	max_duration;
> -	uint64_t	average_duration;
> -	uint64_t	average_frequency;
> -	uint64_t	last;
> -};
> -
> -void bch_time_stats_update(struct time_stats *stats, uint64_t time);
> -
>  static inline unsigned int local_clock_us(void)
>  {
>  	return local_clock() >> 10;
> @@ -372,40 +358,16 @@ static inline unsigned int local_clock_us(void)
>  	sysfs_print(name ## _ ## stat ## _ ## units,			\
>  		    div_u64((stats)->stat >> 8, NSEC_PER_ ## units))
>  
> -#define sysfs_print_time_stats(stats, name,				\
> -			       frequency_units,				\
> -			       duration_units)				\
> +#define sysfs_print_time_stats(stats, name)				\
>  do {									\
> -	__print_time_stat(stats, name,					\
> -			  average_frequency,	frequency_units);	\
> -	__print_time_stat(stats, name,					\
> -			  average_duration,	duration_units);	\
> -	sysfs_print(name ## _ ##max_duration ## _ ## duration_units,	\
> -			div_u64((stats)->max_duration,			\
> -				NSEC_PER_ ## duration_units));		\
> -									\
> -	sysfs_print(name ## _last_ ## frequency_units, (stats)->last	\
> -		    ? div_s64(local_clock() - (stats)->last,		\
> -			      NSEC_PER_ ## frequency_units)		\
> -		    : -1LL);						\
> +	if (attr == &sysfs_##name) {					\
> +		struct seq_buf seq;					\
> +		seq_buf_init(&seq, buf, PAGE_SIZE);			\
> +		time_stats_to_seq_buf(&seq, stats);			\
> +		return seq.len;						\
> +	}								\
>  } while (0)
>  
> -#define sysfs_time_stats_attribute(name,				\
> -				   frequency_units,			\
> -				   duration_units)			\
> -read_attribute(name ## _average_frequency_ ## frequency_units);		\
> -read_attribute(name ## _average_duration_ ## duration_units);		\
> -read_attribute(name ## _max_duration_ ## duration_units);		\
> -read_attribute(name ## _last_ ## frequency_units)
> -
> -#define sysfs_time_stats_attribute_list(name,				\
> -					frequency_units,		\
> -					duration_units)			\
> -&sysfs_ ## name ## _average_frequency_ ## frequency_units,		\
> -&sysfs_ ## name ## _average_duration_ ## duration_units,		\
> -&sysfs_ ## name ## _max_duration_ ## duration_units,			\
> -&sysfs_ ## name ## _last_ ## frequency_units,
> -
>  #define ewma_add(ewma, val, weight, factor)				\
>  ({									\
>  	(ewma) *= (weight) - 1;						\
> -- 
> 2.43.0
> 


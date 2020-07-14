Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A4C21E7B6
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Jul 2020 07:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgGNF5K (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 Jul 2020 01:57:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:58310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgGNF5K (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 Jul 2020 01:57:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 49906B031;
        Tue, 14 Jul 2020 05:57:10 +0000 (UTC)
Subject: Re: [PATCH] bcache: add a new sysfs interface to disable refill when
 read miss
To:     Guoju Fang <fangguoju@gmail.com>, colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <1594610902-4428-1-git-send-email-fangguoju@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <141fbeaf-8fb6-43fb-56ed-5f8a5a019cc7@suse.de>
Date:   Tue, 14 Jul 2020 07:57:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594610902-4428-1-git-send-email-fangguoju@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/13/20 5:28 AM, Guoju Fang wrote:
> When read cache miss, backing device will be read first, and then refill
> the cache device. But under some scenarios there are large number of new
> reads and rarely hit, so it's necessary to disable the refill when read
> miss to save space for writes.
> 
> This patch add a new config called refill_on_miss_disabled which is not set
> by default. Bcache user can set it by sysfs interface and then the bcache
> device will not refill when read cache miss.
> 
> Signed-off-by: Guoju Fang <fangguoju@gmail.com>
> ---
>   drivers/md/bcache/bcache.h  | 1 +
>   drivers/md/bcache/request.c | 2 ++
>   drivers/md/bcache/super.c   | 1 +
>   drivers/md/bcache/sysfs.c   | 5 +++++
>   4 files changed, 9 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 221e0191b687..3a19ee6de3a7 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -730,6 +730,7 @@ struct cache_set {
>   	unsigned int		shrinker_disabled:1;
>   	unsigned int		copy_gc_enabled:1;
>   	unsigned int		idle_max_writeback_rate_enabled:1;
> +	unsigned int		refill_on_miss_disabled:1;
>   
>   #define BUCKET_HASH_BITS	12
>   	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 7acf024e99f3..4bfa0e0b4b3f 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -378,6 +378,8 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>   	     op_is_write(bio_op(bio))))
>   		goto skip;
>   
> +	if (c->refill_on_miss_disabled && !op_is_write(bio_op(bio)))
> +		goto skip;
>   	/*
>   	 * If the bio is for read-ahead or background IO, bypass it or
>   	 * not depends on the following situations,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 2014016f9a60..c1e9bfec1267 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1862,6 +1862,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   	c->congested_write_threshold_us	= 20000;
>   	c->error_limit	= DEFAULT_IO_ERROR_LIMIT;
>   	c->idle_max_writeback_rate_enabled = 1;
> +	c->refill_on_miss_disabled = 0;
>   	WARN_ON(test_and_clear_bit(CACHE_SET_IO_DISABLE, &c->flags));
>   
>   	return c;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 0dadec5a78f6..178300f401bb 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -144,6 +144,7 @@ rw_attribute(copy_gc_enabled);
>   rw_attribute(idle_max_writeback_rate);
>   rw_attribute(gc_after_writeback);
>   rw_attribute(size);
> +rw_attribute(refill_on_miss_disabled);
>   
>   static ssize_t bch_snprint_string_list(char *buf,
>   				       size_t size,
> @@ -779,6 +780,8 @@ SHOW(__bch_cache_set)
>   	if (attr == &sysfs_bset_tree_stats)
>   		return bch_bset_print_stats(c, buf);
>   
> +	sysfs_printf(refill_on_miss_disabled, "%i", c->refill_on_miss_disabled);
> +
>   	return 0;
>   }
>   SHOW_LOCKED(bch_cache_set)
> @@ -898,6 +901,7 @@ STORE(__bch_cache_set)
>   	 * set in next chance.
>   	 */
>   	sysfs_strtoul_clamp(gc_after_writeback, c->gc_after_writeback, 0, 1);
> +	sysfs_strtoul(refill_on_miss_disabled, c->refill_on_miss_disabled);
>   
>   	return size;
>   }
> @@ -948,6 +952,7 @@ static struct attribute *bch_cache_set_files[] = {
>   	&sysfs_congested_read_threshold_us,
>   	&sysfs_congested_write_threshold_us,
>   	&sysfs_clear_stats,
> +	&sysfs_refill_on_miss_disabled,
>   	NULL
>   };
>   KTYPE(bch_cache_set);
> 
Please don't call the attribute refill_on_miss_disabled.
This kind of double-negation will always lead to issues; please invert 
the meaning and call it 'refill_on_miss'.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

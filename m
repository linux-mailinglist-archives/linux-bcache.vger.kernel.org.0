Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C032511F2
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Aug 2020 08:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgHYGRU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Aug 2020 02:17:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:36940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgHYGRU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Aug 2020 02:17:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A2351AC61;
        Tue, 25 Aug 2020 06:17:48 +0000 (UTC)
Subject: Re: [PATCH v2 02/12] bcache: explicitly make cache_set only have
 single cache
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200822114536.23491-1-colyli@suse.de>
 <20200822114536.23491-3-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <04a41d67-5591-4ef6-7083-67ae367e63fc@suse.de>
Date:   Tue, 25 Aug 2020 08:17:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200822114536.23491-3-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/22/20 1:45 PM, Coly Li wrote:
> Currently although the bcache code has a framework for multiple caches
> in a cache set, but indeed the multiple caches never completed and users
> use md raid1 for multiple copies of the cached data.
> 
> This patch does the following change in struct cache_set, to explicitly
> make a cache_set only have single cache,
> - Change pointer array "*cache[MAX_CACHES_PER_SET]" to a single pointer
>    "*cache".
> - Remove pointer array "*cache_by_alloc[MAX_CACHES_PER_SET]".
> - Remove "caches_loaded".
> 
> Now the code looks as exactly what it does in practic: only one cache is
> used in the cache set.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/alloc.c  |  2 +-
>   drivers/md/bcache/bcache.h |  8 +++-----
>   drivers/md/bcache/super.c  | 19 ++++++++-----------
>   3 files changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 4493ff57476d..3385f6add6df 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -501,7 +501,7 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
>   
>   	bkey_init(k);
>   
> -	ca = c->cache_by_alloc[0];
> +	ca = c->cache;
>   	b = bch_bucket_alloc(ca, reserve, wait);
>   	if (b == -1)
>   		goto err;
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 5ff6e9573935..aa112c1adba1 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -519,9 +519,7 @@ struct cache_set {
>   
>   	struct cache_sb		sb;
>   
> -	struct cache		*cache[MAX_CACHES_PER_SET];
> -	struct cache		*cache_by_alloc[MAX_CACHES_PER_SET];
> -	int			caches_loaded;
> +	struct cache		*cache;
>   
>   	struct bcache_device	**devices;
>   	unsigned int		devices_max_used;
> @@ -808,7 +806,7 @@ static inline struct cache *PTR_CACHE(struct cache_set *c,
>   				      const struct bkey *k,
>   				      unsigned int ptr)
>   {
> -	return c->cache[PTR_DEV(k, ptr)];
> +	return c->cache;
>   }
>   
>   static inline size_t PTR_BUCKET_NR(struct cache_set *c,
> @@ -890,7 +888,7 @@ do {									\
>   /* Looping macros */
>   
>   #define for_each_cache(ca, cs, iter)					\
> -	for (iter = 0; ca = cs->cache[iter], iter < (cs)->sb.nr_in_set; iter++)
> +	for (iter = 0; ca = cs->cache, iter < 1; iter++)
>   
>   #define for_each_bucket(b, ca)						\
>   	for (b = (ca)->buckets + (ca)->sb.first_bucket;			\
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 7057ec48f3d1..e9ccfa17beb8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1675,7 +1675,7 @@ static void cache_set_free(struct closure *cl)
>   	for_each_cache(ca, c, i)
>   		if (ca) {
>   			ca->set = NULL;
> -			c->cache[ca->sb.nr_this_dev] = NULL;
> +			c->cache = NULL;
>   			kobject_put(&ca->kobj);
>   		}
>   
Please kill 'for_each_cache()', too, and replace it by an if clause.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

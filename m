Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E1432E05C
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Mar 2021 05:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCEEFS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 Mar 2021 23:05:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:55998 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhCEEFS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Mar 2021 23:05:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D92B7AEE5;
        Fri,  5 Mar 2021 04:05:16 +0000 (UTC)
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20210305024609.4880-1-baijiaju1990@gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH] md: bcache: fix error return code of
 cached_dev_cache_miss()
Message-ID: <ee960cbc-352a-cae6-3d57-41dd16249bff@suse.de>
Date:   Fri, 5 Mar 2021 12:05:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305024609.4880-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/5/21 10:46 AM, Jia-Ju Bai wrote:
> When bch_bio_alloc_pages() fails, no error return code of 
> cached_dev_cache_miss() is assigned.
> To fix this bug, ret is assigned with -ENOMEN as error return code.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/md/bcache/request.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 29c231758293..9ecaf26c8d60 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -930,8 +930,10 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
>  	cache_bio->bi_private	= &s->cl;
>  
>  	bch_bio_map(cache_bio, NULL);
> -	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO))
> +	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO)) {
> +		ret = -ENOMEM;
>  		goto out_put;
> +	}
>  
>  	if (reada)
>  		bch_mark_cache_readahead(s->iop.c, s->d);
> 

Thanks for looking at bcache :-)

Without the above change, -EINTR will be returned. -EINTR is special in
bache's btree iteration code. See bcache_btree_root() from bcache.h,

347 #define bcache_btree_root(fn, c, op, ...)	\
348 ({						\
349	int _r = -EINTR;			\
350	do {					\
351		struct btree *_b = (c)->root; 	\
352		bool _w = insert_lock(op, _b);	\
353		rw_lock(_w, _b, _b->level);	\
354		if (_b == (c)->root &&		\
355			_w == insert_lock(op, _b)) { \
356			_r = bch_btree_ ## fn(_b, op, ##__VA_ARGS__); \
357		}				\
358	rw_unlock(_w, _b);			\
359	bch_cannibalize_unlock(c);		\
360	if (_r == -EINTR)			\
361						\
362	} while (_r == -EINTR);			\
363						\
364	finish_wait(&(c)->btree_cache_wait, &(op)->wait); \
365	_r;					\
366 })

cached_dev_cache_miss() is called by the following code path,

cache_lookup() ==> bch_btree_map_keys() ==> bcache_btree_root() ==>
bch_btree_map_keys_recurse() ==> cache_lookup_fn()

Therefore the return value of cached_dev_cache_miss() will be returned
from where s->d->cache_miss() is called from cache_lookup_fn(). And in
macro bcache_btree_root() this return value will be checked. If the
return value is -EINTR, then the whole iteration will be re-do again.

Returning -ENOMEM works but if the memory allocation failed, there is no
chance to re-do the cache lookup again from bcache_btree_root(). When
system memory is in heavy usage, we want the lookup to try more times
(because GFP_NOIO is set), which is much better then returning -EIO
immediately to caller.

Therefore NOT setting ret to -ENOMEM in the patching location should be
an on-purpose coding, IMHO.

Thanks.

Coly Li


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC6221C5E
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jul 2020 08:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgGPGI7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 02:08:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:40394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgGPGI7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 02:08:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 497C3B6D8;
        Thu, 16 Jul 2020 06:09:01 +0000 (UTC)
Subject: Re: [PATCH v3 12/16] bcache: handle btree node memory allocation
 properly for bucket size > 8MB
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-13-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9a66ca8e-c120-bdc3-ee76-8692bcdb07d8@suse.de>
Date:   Thu, 16 Jul 2020 08:08:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715143015.14957-13-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/15/20 4:30 PM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> Currently the bcache internal btree node occupies a whole bucket. When
> loading the btree node from cache device into memory, mca_data_alloc()
> will call bch_btree_keys_alloc() to allocate memory for the whole bucket
> size, ilog2(b->c->btree_pages) is send to bch_btree_keys_alloc() as the
> parameter 'page_order'.
> 
> c->btree_pages is set as bucket_pages() in bch_cache_set_alloc(), for
> bucket size > 8MB, ilog2(b->c->btree_pages) is 12 for 4KB page size. By
> default the maximum page order __get_free_pages() accepts is MAX_ORDER
> (11), in this condition bch_btree_keys_alloc() will always fail.
> 
> Because of other over-page-order allocation failure fails the cache
> device registration, such btree node allocation failure wasn't observed
> during runtime. After other blocking page allocation failures for bucket
> size > 8MB, this btree node allocation issue may trigger potentical risk
> e.g. infinite dead-loop to retry btree node allocation after failure.
> 
> This patch fixes the potential problem by setting c->btree_pages to
> meta_bucket_pages() in bch_cache_set_alloc(). In the condition that
> bucket size > 8MB, meta_bucket_pages() will always return a number which
> won't exceed the maximum page order of the buddy allocator.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/super.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index b1d8388ef57d..02901d0ae8e2 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1867,7 +1867,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   	c->nr_uuids		= meta_bucket_bytes(&c->sb) / sizeof(struct uuid_entry);
>   	c->devices_max_used	= 0;
>   	atomic_set(&c->attached_dev_nr, 0);
> -	c->btree_pages		= bucket_pages(c);
> +	c->btree_pages		= meta_bucket_pages(&c->sb);
>   	if (c->btree_pages > BTREE_MAX_PAGES)
>   		c->btree_pages = max_t(int, c->btree_pages / 4,
>   				       BTREE_MAX_PAGES);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

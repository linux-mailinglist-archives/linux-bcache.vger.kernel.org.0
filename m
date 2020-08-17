Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCC9245C57
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgHQGRv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:17:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:45078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHQGRv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:17:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B3960AD7D;
        Mon, 17 Aug 2020 06:18:14 +0000 (UTC)
Subject: Re: [PATCH 06/14] bcache: remove useless alloc_bucket_pages()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-7-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <16bc0fe0-79a1-8d70-26b7-0848285bb790@suse.de>
Date:   Mon, 17 Aug 2020 08:17:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-7-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> Now no one uses alloc_bucket_pages() anymore, remove it from bcache.h.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/super.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 5636648902e3..748b08ab4f11 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1832,9 +1832,6 @@ void bch_cache_set_unregister(struct cache_set *c)
>   	bch_cache_set_stop(c);
>   }
>   
> -#define alloc_bucket_pages(gfp, c)			\
> -	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(bucket_pages(c))))
> -
>   #define alloc_meta_bucket_pawedges(gfp, sb)		\
>   	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(meta_bucket_pages(sb))))
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

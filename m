Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2E022113B
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgGOPgH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 11:36:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOPgH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 11:36:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3FFE8AB76;
        Wed, 15 Jul 2020 15:36:08 +0000 (UTC)
Subject: Re: [PATCH v3 08/16] bcache: introduce meta_bucket_pages() related
 helper routines
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-9-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <b6083e37-9eb2-5e9e-7b90-27b1308828d2@suse.de>
Date:   Wed, 15 Jul 2020 17:36:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715143015.14957-9-colyli@suse.de>
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
> Currently the in-memory meta data like c->uuids or c->disk_buckets
> are allocated by alloc_bucket_pages(). The macro alloc_bucket_pages()
> calls __get_free_pages() to allocated continuous pages with order
> indicated by ilog2(bucket_pages(c)),
>   #define alloc_bucket_pages(gfp, c)                      \
>       ((void *) __get_free_pages(__GFP_ZERO|gfp, ilog2(bucket_pages(c))))
> 
> The maximum order is defined as MAX_ORDER, the default value is 11 (and
> can be overwritten by CONFIG_FORCE_MAX_ZONEORDER). In bcache code the
> maximum bucket size width is 16bits, this is restricted both by KEY_SIZE
> size and bucket_size size from struct cache_sb_disk. The maximum 16bits
> width and power-of-2 value is (1<<15) in unit of sector (512byte). It
> means the maximum value of bucket size in bytes is (1<<24) bytes a.k.a
> 4096 pages.
> 
> When the bucket size is set to maximum permitted value, ilog2(4096) is
> 12, which exceeds the default maximum order __get_free_pages() can
> accepted, the failed pages allocation will fail cache set registration
> procedure and print a kernel oops message for the exceeded pages order.
> 
> This patch introduces meta_bucket_pages(), meta_bucket_bytes(), and
> alloc_bucket_pages() helper routines. meta_bucket_pages() indicates the
> maximum pages can be allocated to meta data bucket, meta_bucket_bytes()
> indicates the according maximum bytes, and alloc_bucket_pages() does
> the pages allocation for meta bucket. Because meta_bucket_pages()
> chooses the smaller value among the bucket size and MAX_ORDER_NR_PAGES,
> it still works when MAX_ORDER overwritten by CONFIG_FORCE_MAX_ZONEORDER.
> 
> Following patches will use these helper routines to decide maximum pages
> can be allocated for different meta data buckets. If the bucket size is
> larger than meta_bucket_bytes(), the bcache registration can continue to
> success, just the space more than meta_bucket_bytes() inside the bucket
> is wasted. Comparing bcache failed for large bucket size, wasting some
> space for meta data buckets is acceptable at this moment.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/bcache.h | 20 ++++++++++++++++++++
>   drivers/md/bcache/super.c  |  3 +++
>   2 files changed, 23 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 80e3c4813fb0..972f1aff0f70 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -762,6 +762,26 @@ struct bbio {
>   #define bucket_bytes(c)		((c)->sb.bucket_size << 9)
>   #define block_bytes(c)		((c)->sb.block_size << 9)
>   
> +static inline unsigned int meta_bucket_pages(struct cache_sb *sb)
> +{
> +	unsigned int n, max_pages;
> +
> +	max_pages = min_t(unsigned int,
> +			  __rounddown_pow_of_two(USHRT_MAX) / PAGE_SECTORS,
> +			  MAX_ORDER_NR_PAGES);
> +
> +	n = sb->bucket_size / PAGE_SECTORS;
> +	if (n > max_pages)
> +		n = max_pages;
> +
> +	return n;
> +}
> +
> +static inline unsigned int meta_bucket_bytes(struct cache_sb *sb)
> +{
> +	return meta_bucket_pages(sb) << PAGE_SHIFT;
> +}
> +
>   #define prios_per_bucket(c)				\
>   	((bucket_bytes(c) - sizeof(struct prio_set)) /	\
>   	 sizeof(struct bucket_disk))
I'm not particular happy with the division followed by a shift; might be 
an idea to replace the division by a shift.

But that's minor, so:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

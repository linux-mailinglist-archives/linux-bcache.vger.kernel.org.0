Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCEB245C63
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgHQGWb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:22:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:45788 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgHQGW3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:22:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EA095AD5F;
        Mon, 17 Aug 2020 06:22:52 +0000 (UTC)
Subject: Re: [PATCH 09/14] bcache: avoid data copy between cache_set->sb and
 cache->sb
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-10-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <041fed5e-f54f-d0eb-a5cc-2a52ded7b623@suse.de>
Date:   Mon, 17 Aug 2020 08:22:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-10-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> struct cache_sb embedded in struct cache_set is only partial used and
> not a real copy from cache's in-memory super block. When removing the
> embedded cache_set->sb, it is unncessary to copy data between these two
> in-memory super blocks (cache_set->sb and cache->sb), it is sufficient
> to just use cache->sb.
> 
> This patch removes the data copy between these two in-memory super
> blocks in bch_cache_set_alloc() and bcache_write_super(). In future
> except for set_uuid, cache's super block will be referenced by cache
> set, no copy any more.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/super.c | 22 +++-------------------
>   1 file changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 748b08ab4f11..05c5a7e867bb 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -350,16 +350,10 @@ void bcache_write_super(struct cache_set *c)
>   	down(&c->sb_write_mutex);
>   	closure_init(cl, &c->cl);
>   
> -	c->sb.seq++;
> +	ca->sb.seq++;
>   
> -	if (c->sb.version > version)
> -		version = c->sb.version;
> -
> -	ca->sb.version		= version;
> -	ca->sb.seq		= c->sb.seq;
> -	ca->sb.last_mount	= c->sb.last_mount;
> -
> -	SET_CACHE_SYNC(&ca->sb, CACHE_SYNC(&c->sb));
> +	if (ca->sb.version < version)
> +		ca->sb.version = version;
>   
>   	bio_init(bio, ca->sb_bv, 1);
>   	bio_set_dev(bio, ca->bdev);
> @@ -1860,16 +1854,6 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   	bch_cache_accounting_init(&c->accounting, &c->cl);
>   
>   	memcpy(c->set_uuid, sb->set_uuid, 16);
> -	c->sb.block_size	= sb->block_size;
> -	c->sb.bucket_size	= sb->bucket_size;
> -	c->sb.nr_in_set		= sb->nr_in_set;
> -	c->sb.last_mount	= sb->last_mount;
> -	c->sb.version		= sb->version;
> -	if (c->sb.version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
> -		c->sb.feature_compat = sb->feature_compat;
> -		c->sb.feature_ro_compat = sb->feature_ro_compat;
> -		c->sb.feature_incompat = sb->feature_incompat;
> -	}
>   
>   	c->bucket_bits		= ilog2(sb->bucket_size);
>   	c->block_bits		= ilog2(sb->block_size);
> 
Please fold it into patch 13, as then it's obvious why we don't need 
this copy actions anymore.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEEA7237E7
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Jun 2023 08:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbjFFGm3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Jun 2023 02:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjFFGm2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Jun 2023 02:42:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B2EE41
        for <linux-bcache@vger.kernel.org>; Mon,  5 Jun 2023 23:42:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 105B61FD5F;
        Tue,  6 Jun 2023 06:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686033741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oFsPTXsSss0toUwFId/ELowAR2yBIt+bF6Y40qABa64=;
        b=tJUFNEidZCz8/zlkLcVdtfjIkY0hYwGJIwG11/xSuQ68aOPUlkhVPVbahd9zC/HeuLZDGf
        SY69k76b76v18/F7le14AJe2BezoStyI6t+7lR9ol4okCJ1+XQs83U5EmM08GYxaiiLEU1
        Wdhmyaw+jrQ1x3QODZnRWPTmxF2u44U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686033741;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oFsPTXsSss0toUwFId/ELowAR2yBIt+bF6Y40qABa64=;
        b=OFbG/TOhUmuzyj/P1mdAU2dF1drdg5kYKgRRuxlY0uii4lNhofUC1BSpcsN1F9WvfwamyD
        p2t78gGB2cYGtuAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1076113776;
        Tue,  6 Jun 2023 06:42:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id FloXNEvVfmScdQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 06 Jun 2023 06:42:19 +0000
Date:   Tue, 6 Jun 2023 14:42:17 +0800
From:   Coly Li <colyli@suse.de>
To:     mingzhe.zou@easystack.cn
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
Subject: Re: [PATCH 2/3] bcache: allocate stripe memory when
 partial_stripes_expensive is true
Message-ID: <a5kmqikoltztrdezjlcwsemmffodxkvihzmicbsv7iiqcsueky@sq6dzbfpabtp>
References: <20221212032050.9511-1-mingzhe.zou@easystack.cn>
 <20221212032050.9511-2-mingzhe.zou@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221212032050.9511-2-mingzhe.zou@easystack.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Dec 12, 2022 at 11:20:49AM +0800, mingzhe.zou@easystack.cn wrote:
> From: mingzhe <mingzhe.zou@easystack.cn>
> 
> Currently, bcache_device (cached_dev and flash_dev) always allocate
> memory for stripe_sectors_dirty and full_dirty_stripes, regardless of
> whether partial_stripes_expensive is true or not. When the device's
> partial_stripes_expensive is false, only bcache_dev_sectors_dirty_add()
> will use stripe_sectors_dirty.
> 
> When stripe_size is 0, it is forced to 2^31, which is about 1T (2^31*512).
> However, some non-raid devices (such as rbd) will provide non-zero io_opt.
> In https://bugzilla.redhat.com/show_bug.cgi?id=1783075, some block devices
> which large capacity (e.g. 8TB) but small io_opt size (e.g. 8 sectors), the
> nr_stripes will be very large. Even though the overflow bug is fixed in
> 65f0f017e7be and 7a1481267999, it still returns an error when register.
> 
> I don't think it's necessary to allocate stripe memory for devices where
> partial_stripes_expensive is false. This patch will allocate stripe memory
> when partial_stripes_expensive is true.
> 
> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
> ---
>  drivers/md/bcache/super.c     | 31 ++++++++++++++++++++++---------
>  drivers/md/bcache/writeback.c | 14 ++++++++++----
>  2 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index a91a1c3f4055..83b5bbb5dcc8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -887,15 +887,20 @@ static void bcache_device_free(struct bcache_device *d)
>  	}
>  
>  	bioset_exit(&d->bio_split);
> -	kvfree(d->full_dirty_stripes);
> -	kvfree(d->stripe_sectors_dirty);
> +
> +	if (d->full_dirty_stripes)
> +		kvfree(d->full_dirty_stripes);
> +
> +	if (d->stripe_sectors_dirty)
> +		kvfree(d->stripe_sectors_dirty);
>  
>  	closure_debug_destroy(&d->cl);
>  }
>  
>  static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> -		sector_t sectors, struct block_device *cached_bdev,
> -		const struct block_device_operations *ops)
> +			      sector_t sectors, bool enable_stripe,
> +			      struct block_device *cached_bdev,
> +			      const struct block_device_operations *ops)

The extra enable_stripe parameter might not be necessary. You have parameter cached_bdev,
dc->partial_stripes_expensive can be read without an extra parameter.
 

>  {
>  	struct request_queue *q;
>  	const size_t max_stripes = min_t(size_t, INT_MAX,
> @@ -903,6 +908,9 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	uint64_t n;
>  	int idx;
>  
> +	if (!enable_stripe)
> +		goto skip_stripe;
> +

Since the stripes related  calculation and allocation might not be mandatory, the
calculation of max_stripes even can be delayed to here.


>  	if (!d->stripe_size)
>  		d->stripe_size = 1 << 31;
>  
> @@ -924,6 +932,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	if (!d->full_dirty_stripes)
>  		goto out_free_stripe_sectors_dirty;
>  
> +skip_stripe:
>  	idx = ida_simple_get(&bcache_device_idx, 0,
>  				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
>  	if (idx < 0)
> @@ -982,9 +991,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  out_ida_remove:
>  	ida_simple_remove(&bcache_device_idx, idx);
>  out_free_full_dirty_stripes:
> -	kvfree(d->full_dirty_stripes);
> +	if (d->full_dirty_stripes)
> +		kvfree(d->full_dirty_stripes);
>  out_free_stripe_sectors_dirty:
> -	kvfree(d->stripe_sectors_dirty);
> +	if (d->stripe_sectors_dirty)
> +		kvfree(d->stripe_sectors_dirty);
>  	return -ENOMEM;
>  


The above code looks fine.


>  }
> @@ -1397,6 +1408,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  	int ret;
>  	struct io *io;
>  	struct request_queue *q = bdev_get_queue(dc->bdev);
> +	sector_t sectors = dc->bdev->bd_part->nr_sects - dc->sb.data_offset;
>  
>  	__module_get(THIS_MODULE);
>  	INIT_LIST_HEAD(&dc->list);
> @@ -1423,8 +1435,9 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  			q->limits.raid_partial_stripes_expensive;
>  
>  	ret = bcache_device_init(&dc->disk, block_size,
> -			 bdev_nr_sectors(dc->bdev) - dc->sb.data_offset,
> -			 dc->bdev, &bcache_cached_ops);
> +				 bdev_nr_sectors(dc->bdev) - dc->sb.data_offset,
> +				 dc->partial_stripes_expensive,
> +				 dc->bdev, &bcache_cached_ops);
>  	if (ret)
>  		return ret;
>  
> @@ -1535,7 +1548,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>  
>  	kobject_init(&d->kobj, &bch_flash_dev_ktype);
>  
> -	if (bcache_device_init(d, block_bytes(c->cache), u->sectors,
> +	if (bcache_device_init(d, block_bytes(c->cache), u->sectors, false,
>  			NULL, &bcache_flash_ops))
>  		goto err;
>  

As I said the extra parameter enable_stripe is unnecessary, the above change can be avoided.

> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 7b5009e8b4ff..3f4af7ce6936 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -758,6 +758,7 @@ static void read_dirty(struct cached_dev *dc)
>  void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
>  				  uint64_t offset, int nr_sectors)
>  {
> +	struct cached_dev *dc = NULL;
>  	struct bcache_device *d = c->devices[inode];
>  	unsigned int stripe_offset, sectors_dirty;
>  	int stripe;
> @@ -765,14 +766,19 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
>  	if (!d)
>  		return;
>  
> -	stripe = offset_to_stripe(d, offset);
> -	if (stripe < 0)
> -		return;
> -
>  	atomic_long_add(nr_sectors, &d->dirty_sectors);
>  
>  	if (UUID_FLASH_ONLY(&c->uuids[inode]))
>  		atomic_long_add(nr_sectors, &c->flash_dev_dirty_sectors);
> +	else
> +		dc = container_of(d, struct cached_dev, disk);
> +
> +	if (!dc || !dc->partial_stripes_expensive)
> +		return;
> +
> +	stripe = offset_to_stripe(d, offset);
> +	if (stripe < 0)
> +		return;
>  
>  	stripe_offset = offset & (d->stripe_size - 1);
> 

Once you changed the first patch, the above change might be modified to follow the previous change
as well.

 
> -- 
> 2.17.1
> 

-- 
Coly Li

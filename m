Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7829073A685
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 18:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjFVQw7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjFVQwt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 12:52:49 -0400
Received: from out-38.mta0.migadu.com (out-38.mta0.migadu.com [IPv6:2001:41d0:1004:224b::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99E510A
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 09:52:47 -0700 (PDT)
Date:   Thu, 22 Jun 2023 12:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687452765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K27duhf3kHhjPBxHjwhVsM6uiuT9t5uMbpk8FN4/yqM=;
        b=ewcroFUZ9soiWtdfut5oaSkx7iaXWt3BJNrqbhJQ6W61hejHJyyRP/MNachy3kdzcMO31A
        mE5nHZzLltVEbOdGFhJs5K6pLetTzyG4SJVHYuju5Ceh6ICLb13X4cT5KB56hjRR7bEAN6
        yDumHgf/0nEd2vqIbBIMxie1ExEzIvk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Jan Kara <jack@suse.cz>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2 2/2] bcache: Fix bcache device claiming
Message-ID: <20230622165243.nvcrfhdyrq2ilxpu@moria.home.lan>
References: <20230622164149.17134-1-jack@suse.cz>
 <20230622164658.12861-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622164658.12861-2-jack@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jun 22, 2023 at 06:46:55PM +0200, Jan Kara wrote:
> Commit 2736e8eeb0cc ("block: use the holder as indication for exclusive
> opens") introduced a change that blkdev_put() has to get exclusive
> holder of the bdev as an argument. However it overlooked that
> register_bdev() and register_cache() overwrite the bdev->bd_holder field
> in the block device to point to the real owning object which was not
> available at the time we called blkdev_get_by_path(). Messing with bdev
> internals like this is a layering violation and it also causes
> blkdev_put() to issue warning about mismatching holders.
> 
> Fix bcache to reopen the block device with appropriate holder once it is
> available which also restores the behavior that multiple bcache caches
> cannot claim the same device which was broken by commit 29499ab060fe
> ("bcache: don't pass a stack address to blkdev_get_by_path").
> 
> Fixes: 2736e8eeb0cc ("block: use the holder as indication for exclusive opens")
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>

> ---
>  drivers/md/bcache/super.c | 65 +++++++++++++++++++++++----------------
>  1 file changed, 38 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 913dd94353b6..0ae2b3676293 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1369,7 +1369,7 @@ static void cached_dev_free(struct closure *cl)
>  		put_page(virt_to_page(dc->sb_disk));
>  
>  	if (!IS_ERR_OR_NULL(dc->bdev))
> -		blkdev_put(dc->bdev, bcache_kobj);
> +		blkdev_put(dc->bdev, dc);
>  
>  	wake_up(&unregister_wait);
>  
> @@ -1453,7 +1453,6 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>  
>  	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
>  	dc->bdev = bdev;
> -	dc->bdev->bd_holder = dc;
>  	dc->sb_disk = sb_disk;
>  
>  	if (cached_dev_init(dc, sb->block_size << 9))
> @@ -2218,7 +2217,7 @@ void bch_cache_release(struct kobject *kobj)
>  		put_page(virt_to_page(ca->sb_disk));
>  
>  	if (!IS_ERR_OR_NULL(ca->bdev))
> -		blkdev_put(ca->bdev, bcache_kobj);
> +		blkdev_put(ca->bdev, ca);
>  
>  	kfree(ca);
>  	module_put(THIS_MODULE);
> @@ -2345,7 +2344,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>  
>  	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
>  	ca->bdev = bdev;
> -	ca->bdev->bd_holder = ca;
>  	ca->sb_disk = sb_disk;
>  
>  	if (bdev_max_discard_sectors((bdev)))
> @@ -2359,7 +2357,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>  		 * call blkdev_put() to bdev in bch_cache_release(). So we
>  		 * explicitly call blkdev_put() here.
>  		 */
> -		blkdev_put(bdev, bcache_kobj);
> +		blkdev_put(bdev, ca);
>  		if (ret == -ENOMEM)
>  			err = "cache_alloc(): -ENOMEM";
>  		else if (ret == -EPERM)
> @@ -2516,10 +2514,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	char *path = NULL;
>  	struct cache_sb *sb;
>  	struct cache_sb_disk *sb_disk;
> -	struct block_device *bdev;
> -	void *holder;
> +	struct block_device *bdev, *bdev2;
> +	void *holder = NULL;
>  	ssize_t ret;
>  	bool async_registration = false;
> +	bool quiet = false;
>  
>  #ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
>  	async_registration = true;
> @@ -2548,24 +2547,9 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  
>  	ret = -EINVAL;
>  	err = "failed to open device";
> -	bdev = blkdev_get_by_path(strim(path), BLK_OPEN_READ | BLK_OPEN_WRITE,
> -				  bcache_kobj, NULL);
> -	if (IS_ERR(bdev)) {
> -		if (bdev == ERR_PTR(-EBUSY)) {
> -			dev_t dev;
> -
> -			mutex_lock(&bch_register_lock);
> -			if (lookup_bdev(strim(path), &dev) == 0 &&
> -			    bch_is_open(dev))
> -				err = "device already registered";
> -			else
> -				err = "device busy";
> -			mutex_unlock(&bch_register_lock);
> -			if (attr == &ksysfs_register_quiet)
> -				goto done;
> -		}
> +	bdev = blkdev_get_by_path(strim(path), BLK_OPEN_READ, NULL, NULL);
> +	if (IS_ERR(bdev))
>  		goto out_free_sb;
> -	}
>  
>  	err = "failed to set blocksize";
>  	if (set_blocksize(bdev, 4096))
> @@ -2582,6 +2566,32 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  		goto out_put_sb_page;
>  	}
>  
> +	/* Now reopen in exclusive mode with proper holder */
> +	bdev2 = blkdev_get_by_dev(bdev->bd_dev, BLK_OPEN_READ | BLK_OPEN_WRITE,
> +				  holder, NULL);
> +	blkdev_put(bdev, NULL);
> +	bdev = bdev2;
> +	if (IS_ERR(bdev)) {
> +		ret = PTR_ERR(bdev);
> +		bdev = NULL;
> +		if (ret == -EBUSY) {
> +			dev_t dev;
> +
> +			mutex_lock(&bch_register_lock);
> +			if (lookup_bdev(strim(path), &dev) == 0 &&
> +			    bch_is_open(dev))
> +				err = "device already registered";
> +			else
> +				err = "device busy";
> +			mutex_unlock(&bch_register_lock);
> +			if (attr == &ksysfs_register_quiet) {
> +				quiet = true;
> +				ret = size;
> +			}
> +		}
> +		goto out_free_holder;
> +	}
> +
>  	err = "failed to register device";
>  
>  	if (async_registration) {
> @@ -2619,7 +2629,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  			goto out_free_sb;
>  	}
>  
> -done:
>  	kfree(sb);
>  	kfree(path);
>  	module_put(THIS_MODULE);
> @@ -2631,7 +2640,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  out_put_sb_page:
>  	put_page(virt_to_page(sb_disk));
>  out_blkdev_put:
> -	blkdev_put(bdev, register_bcache);
> +	if (bdev)
> +		blkdev_put(bdev, holder);
>  out_free_sb:
>  	kfree(sb);
>  out_free_path:
> @@ -2640,7 +2650,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  out_module_put:
>  	module_put(THIS_MODULE);
>  out:
> -	pr_info("error %s: %s\n", path?path:"", err);
> +	if (!quiet)
> +		pr_info("error %s: %s\n", path?path:"", err);
>  	return ret;
>  }
>  
> -- 
> 2.35.3
> 

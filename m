Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE39738E23
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Jun 2023 20:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjFUSHY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Jun 2023 14:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjFUSHX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Jun 2023 14:07:23 -0400
X-Greylist: delayed 582 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Jun 2023 11:07:20 PDT
Received: from out-39.mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BE01739
        for <linux-bcache@vger.kernel.org>; Wed, 21 Jun 2023 11:07:20 -0700 (PDT)
Date:   Wed, 21 Jun 2023 13:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687370225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZCuC0N5VxiTy0FBGpNcTC3V9UKKDdwQ7mvS3OdFcB8=;
        b=epmaj8wWDehCMB0UiexoFAAwYJpmmW/Ar7jFnm66ONLUtNvfIe5kDp7ZK6gQX7StwCgdq7
        g/h4unluYGVUnuE98jT3BC9WSJeYX+foYidD2wTC9qKLpdAHO5wbojCok2h587FjU73lhG
        PNUqEyNLTRI5+ma4NFOw4hg3kwLuIw8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/2] bcache: Alloc holder object before async registration
Message-ID: <20230621175659.ugkaawkuanlzt736@moria.home.lan>
References: <20230621162024.29310-1-jack@suse.cz>
 <20230621162333.30027-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621162333.30027-1-jack@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jun 21, 2023 at 06:23:26PM +0200, Jan Kara wrote:
> Allocate holder object (cache or cached_dev) before offloading the
> rest of the startup to async work. This will allow us to open the block
> block device with proper holder.

This is a pretty big change for this fix, and we'd want to retest the
error paths - that's hard to do, because the fault injection framework I
was using for that never made it upstream.

What about just exposing a proper API for changing the holder? Wouldn't
that be simpler?




> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/md/bcache/super.c | 66 +++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e2a803683105..913dd94353b6 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2448,6 +2448,7 @@ struct async_reg_args {
>  	struct cache_sb *sb;
>  	struct cache_sb_disk *sb_disk;
>  	struct block_device *bdev;
> +	void *holder;
>  };
>  
>  static void register_bdev_worker(struct work_struct *work)
> @@ -2455,22 +2456,13 @@ static void register_bdev_worker(struct work_struct *work)
>  	int fail = false;
>  	struct async_reg_args *args =
>  		container_of(work, struct async_reg_args, reg_work.work);
> -	struct cached_dev *dc;
> -
> -	dc = kzalloc(sizeof(*dc), GFP_KERNEL);
> -	if (!dc) {
> -		fail = true;
> -		put_page(virt_to_page(args->sb_disk));
> -		blkdev_put(args->bdev, bcache_kobj);
> -		goto out;
> -	}
>  
>  	mutex_lock(&bch_register_lock);
> -	if (register_bdev(args->sb, args->sb_disk, args->bdev, dc) < 0)
> +	if (register_bdev(args->sb, args->sb_disk, args->bdev, args->holder)
> +	    < 0)
>  		fail = true;
>  	mutex_unlock(&bch_register_lock);
>  
> -out:
>  	if (fail)
>  		pr_info("error %s: fail to register backing device\n",
>  			args->path);
> @@ -2485,21 +2477,11 @@ static void register_cache_worker(struct work_struct *work)
>  	int fail = false;
>  	struct async_reg_args *args =
>  		container_of(work, struct async_reg_args, reg_work.work);
> -	struct cache *ca;
> -
> -	ca = kzalloc(sizeof(*ca), GFP_KERNEL);
> -	if (!ca) {
> -		fail = true;
> -		put_page(virt_to_page(args->sb_disk));
> -		blkdev_put(args->bdev, bcache_kobj);
> -		goto out;
> -	}
>  
>  	/* blkdev_put() will be called in bch_cache_release() */
> -	if (register_cache(args->sb, args->sb_disk, args->bdev, ca) != 0)
> +	if (register_cache(args->sb, args->sb_disk, args->bdev, args->holder))
>  		fail = true;
>  
> -out:
>  	if (fail)
>  		pr_info("error %s: fail to register cache device\n",
>  			args->path);
> @@ -2520,6 +2502,13 @@ static void register_device_async(struct async_reg_args *args)
>  	queue_delayed_work(system_wq, &args->reg_work, 10);
>  }
>  
> +static void *alloc_holder_object(struct cache_sb *sb)
> +{
> +	if (SB_IS_BDEV(sb))
> +		return kzalloc(sizeof(struct cached_dev), GFP_KERNEL);
> +	return kzalloc(sizeof(struct cache), GFP_KERNEL);
> +}
> +
>  static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  			       const char *buffer, size_t size)
>  {
> @@ -2528,6 +2517,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	struct cache_sb *sb;
>  	struct cache_sb_disk *sb_disk;
>  	struct block_device *bdev;
> +	void *holder;
>  	ssize_t ret;
>  	bool async_registration = false;
>  
> @@ -2585,6 +2575,13 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	if (err)
>  		goto out_blkdev_put;
>  
> +	holder = alloc_holder_object(sb);
> +	if (!holder) {
> +		ret = -ENOMEM;
> +		err = "cannot allocate memory";
> +		goto out_put_sb_page;
> +	}
> +
>  	err = "failed to register device";
>  
>  	if (async_registration) {
> @@ -2595,44 +2592,29 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  		if (!args) {
>  			ret = -ENOMEM;
>  			err = "cannot allocate memory";
> -			goto out_put_sb_page;
> +			goto out_free_holder;
>  		}
>  
>  		args->path	= path;
>  		args->sb	= sb;
>  		args->sb_disk	= sb_disk;
>  		args->bdev	= bdev;
> +		args->holder	= holder;
>  		register_device_async(args);
>  		/* No wait and returns to user space */
>  		goto async_done;
>  	}
>  
>  	if (SB_IS_BDEV(sb)) {
> -		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
> -
> -		if (!dc) {
> -			ret = -ENOMEM;
> -			err = "cannot allocate memory";
> -			goto out_put_sb_page;
> -		}
> -
>  		mutex_lock(&bch_register_lock);
> -		ret = register_bdev(sb, sb_disk, bdev, dc);
> +		ret = register_bdev(sb, sb_disk, bdev, holder);
>  		mutex_unlock(&bch_register_lock);
>  		/* blkdev_put() will be called in cached_dev_free() */
>  		if (ret < 0)
>  			goto out_free_sb;
>  	} else {
> -		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
> -
> -		if (!ca) {
> -			ret = -ENOMEM;
> -			err = "cannot allocate memory";
> -			goto out_put_sb_page;
> -		}
> -
>  		/* blkdev_put() will be called in bch_cache_release() */
> -		ret = register_cache(sb, sb_disk, bdev, ca);
> +		ret = register_cache(sb, sb_disk, bdev, holder);
>  		if (ret)
>  			goto out_free_sb;
>  	}
> @@ -2644,6 +2626,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  async_done:
>  	return size;
>  
> +out_free_holder:
> +	kfree(holder);
>  out_put_sb_page:
>  	put_page(virt_to_page(sb_disk));
>  out_blkdev_put:
> -- 
> 2.35.3
> 

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856F97B0D70
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Sep 2023 22:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjI0U3p (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Sep 2023 16:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjI0U3o (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Sep 2023 16:29:44 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E0010A
        for <linux-bcache@vger.kernel.org>; Wed, 27 Sep 2023 13:29:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0C4FB46;
        Wed, 27 Sep 2023 13:29:43 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id RHufuFe7qOWq; Wed, 27 Sep 2023 13:29:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 7F06445;
        Wed, 27 Sep 2023 13:29:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 7F06445
Date:   Wed, 27 Sep 2023 13:29:38 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH v2] bcache: avoid oversize memory allocation by small
 stripe_size
In-Reply-To: <20230927160000.28388-1-colyli@suse.de>
Message-ID: <4acb5ab-e3a8-7d28-27d2-78fc60f39765@ewheeler.net>
References: <20230927160000.28388-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Thu, 28 Sep 2023, Coly Li wrote:

> Arraies bcache->stripe_sectors_dirty and bcache->full_dirty_stripes are
> used for dirty data writeback, their sizes are decided by backing device
> capacity and stripe size. Larger backing device capacity or smaller
> stripe size make these two arraies occupies more dynamic memory space.
> 
> Currently bcache->stripe_size is directly inherited from
> queue->limits.io_opt of underlying storage device. For normal hard
> drives, its limits.io_opt is 0, and bcache sets the corresponding
> stripe_size to 1TB (1<<31 sectors), it works fine 10+ years. But for
> devices do declare value for queue->limits.io_opt, small stripe_size
> (comparing to 1TB) becomes an issue for oversize memory allocations of
> bcache->stripe_sectors_dirty and bcache->full_dirty_stripes, while the
> capacity of hard drives gets much larger in recent decade.
> 
> For example a raid5 array assembled by three 20TB hardrives, the raid
> device capacity is 40TB with typical 512KB limits.io_opt. After the math
> calculation in bcache code, these two arraies will occupy 400MB dynamic
> memory. Even worse Andrea Tomassetti reports that a 4KB limits.io_opt is
> declared on a new 2TB hard drive, then these two arraies request 2GB and
> 512MB dynamic memory from kzalloc(). The result is that bcache device
> always fails to initialize on his system.
> 
> To avoid the oversize memory allocation, bcache->stripe_size should not
> directly inherited by queue->limits.io_opt from the underlying device.
> This patch defines BCH_MIN_STRIPE_SZ (4MB) as minimal bcache stripe size
> and set bcache device's stripe size against the declared limits.io_opt
> value from the underlying storage device,
> - If the declared limits.io_opt > BCH_MIN_STRIPE_SZ, bcache device will
>   set its stripe size directly by this limits.io_opt value.
> - If the declared limits.io_opt < BCH_MIN_STRIPE_SZ, bcache device will
>   set its stripe size by a value multiplying limits.io_opt and euqal or
>   large than BCH_MIN_STRIPE_SZ.
> 
> Then the minimal stripe size of a bcache device will always be >= 4MB.
> For a 40TB raid5 device with 512KB limits.io_opt, memory occupied by
> bcache->stripe_sectors_dirty and bcache->full_dirty_stripes will be 50MB
> in total. For a 2TB hard drive with 4KB limits.io_opt, memory occupied
> by these two arraies will be 2.5MB in total.
> 
> Such mount of memory allocated for bcache->stripe_sectors_dirty and
> bcache->full_dirty_stripes is reasonable for most of storage devices.
> 
> Reported-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Eric Wheeler <bcache@lists.ewheeler.net>
> ---
> Changelog:
> v2: use roundup() to replace round_up() as Eric Wheeler suggested.
> v1: the initial version.
> 
>  drivers/md/bcache/bcache.h | 1 +
>  drivers/md/bcache/super.c  | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 5a79bb3c272f..83eb7f27db3d 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -265,6 +265,7 @@ struct bcache_device {
>  #define BCACHE_DEV_WB_RUNNING		3
>  #define BCACHE_DEV_RATE_DW_RUNNING	4
>  	int			nr_stripes;
> +#define BCH_MIN_STRIPE_SZ		((4 << 20) >> SECTOR_SHIFT)
>  	unsigned int		stripe_size;
>  	atomic_t		*stripe_sectors_dirty;
>  	unsigned long		*full_dirty_stripes;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 0ae2b3676293..0eb71543d773 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -905,6 +905,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	if (!d->stripe_size)
>  		d->stripe_size = 1 << 31;
> +	else if (d->stripe_size < BCH_MIN_STRIPE_SZ)
> +		d->stripe_size = roundup(BCH_MIN_STRIPE_SZ, d->stripe_size);
>  
>  	n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
>  	if (!n || n > max_stripes) {
> -- 
> 2.35.3
> 

Thanks Coly.  

Reviewed-by: Eric Wheeler <bcache@linux.ewheeler.net>


--
Eric Wheeler

> 

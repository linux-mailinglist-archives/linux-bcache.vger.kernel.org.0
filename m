Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353FE7AF591
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Sep 2023 22:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbjIZUyC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Sep 2023 16:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjIZUyA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2023 16:54:00 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42073126
        for <linux-bcache@vger.kernel.org>; Tue, 26 Sep 2023 13:53:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id E145184;
        Tue, 26 Sep 2023 13:53:52 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id rhWflZVIm-RJ; Tue, 26 Sep 2023 13:53:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 6FF6D45;
        Tue, 26 Sep 2023 13:53:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 6FF6D45
Date:   Tue, 26 Sep 2023 13:53:48 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: Unusual value of optimal_io_size prevents bcache
 initialization
In-Reply-To: <C02D29AF-02FB-4814-A387-E78E2CB52872@suse.de>
Message-ID: <cfaa794e-e1b4-b014-c018-4e72457f554f@ewheeler.net>
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com> <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie> <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com> <7BFB15E2-7FC6-40F8-8E26-8F23D12F2CD2@suse.de>
 <C02D29AF-02FB-4814-A387-E78E2CB52872@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-800823963-1695761628=:31246"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-800823963-1695761628=:31246
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 26 Sep 2023, Coly Li wrote:
> > 2023年9月24日 22:06，Coly Li <colyli@suse.de> 写道：
> > 
> 
> [snipped]
> 
> >>> Maybe bcache should not directly use q->limits.io_opt as d->stripe_size,
> >>> it should be some value less than 1<<31 and aligned to optimal_io_size.
> >>> After the code got merged into kernel for 10+ years, it is time to improve
> >>> this calculation :-) >
> >> Yeah, one of the other doubts I had was exactly regarding this value and if it is still "actual" to calculate it that way. Unfortunately, I don't have the expertise to have an opinion on it. Would you be so kind to share your knowledge and let me understand why it is calculated this way and why is it using the optimal io size? Is it using it to "writeback" optimal-sized blokes?
> >> 
> > 
> > Most of the conditions when underlying hardware doesn’t declare its optimal io size, bcache uses 1<<31 as a default stripe size. It works fine for decade, so I will use it and make sure it is aligned to value of optimal io size. It should work fine. And I will compose a simple patch for this fix.
> > 
> >>>> Another consideration, stripe_sectors_dirty and full_dirty_stripes, the two
> >>>> arrays allocated using n, are being used just in writeback mode, is this
> >>>> correct? In my specific case, I'm not planning to use writeback mode so I
> >>>> would expect bcache to not even try to create those arrays. Or, at least, to
> >>>> not create them during initialization but just in case of a change in the
> >>>> working mode (i.e. write-through -> writeback).
> >>> Indeed, Mingzhe Zou (if I remember correctly) submitted a patch for this
> >>> idea, but it is blocked by other depending patches which are not finished
> >>> by me. Yes I like the idea to dynamically allocate/free d->stripe_sectors_dirty
> >>> and d->full_dirty_stripes when they are necessary. I hope I may help to make
> >>> the change go into upstream sooner.
> >>> I will post a patch for your testing.
> >> This would be great! Thank you very much! On the other side, if there's anything I can do to help I would be glad to contribute.
> > 
> > I will post a simple patch for the reported memory allocation failure for you to test soon.
> 
> 
> Hi Andrea,
> 
> Could you please try the attached patch and see whether it makes some difference? Thank you in advance.

> From: Coly Li <colyli@suse.de>
> Date: Tue, 26 Sep 2023 20:13:19 +0800
> Subject: [PATCH] bcache: avoid oversize memory allocation by small stripe_size
> 
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

This will create expensive unaligned writes on RAID5/6 arrays for most
cases.  For example, if the stripe size of 6 disks with 64 k chunks has
a size of 384 k, then when you round up to an even value of 4MB
you will introduce a read-copy-write behavior since 384KB
does not divide evenly into 4MB (4MB/384KB =~ 10.667).

The best way to handle this would be to Use 4 megabytes as a minimum,
but round up to a multiple of the value in limits.io_opt.

Here is a real-world example of a non-power-of-2 io_opt value:

	]# cat /sys/block/sdc/queue/optimal_io_size 
	196608

More below:

> Such mount of memory allocated for bcache->stripe_sectors_dirty and
> bcache->full_dirty_stripes is reasonable for most of storage devices.
> 
> Reported-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Eric Wheeler <bcache@lists.ewheeler.net>
> ---
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
> +		d->stripe_size = round_up(BCH_MIN_STRIPE_SZ, d->stripe_size);

I think you want "roundup" (not "round_up") to solve alignment problem:

+		d->stripe_size = roundup(BCH_MIN_STRIPE_SZ, d->stripe_size);
  
Both roundup() and round_up() are defined in math.h:

  * round_up - round up to next specified power of 2
  * roundup - round up to the next specified multiple 

	https://elixir.bootlin.com/linux/v6.0/source/include/linux/math.h#L17

-Eric

>  	n = DIV_ROUND_UP_ULL(sectors, d->stripe_size);
>  	if (!n || n > max_stripes) {
> -- 
> 2.35.3
> 

--
Eric Wheeler


> 
> Coly Li
> 
> 
--8323328-800823963-1695761628=:31246--

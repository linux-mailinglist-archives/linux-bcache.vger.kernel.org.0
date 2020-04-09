Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DED91A36B0
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Apr 2020 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgDIPNX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 9 Apr 2020 11:13:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:39048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbgDIPNW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Apr 2020 11:13:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A685AD2C;
        Thu,  9 Apr 2020 15:13:19 +0000 (UTC)
Subject: Re: [PATCH] bcache:cleanup resources when bcache device init failed
To:     Wu Bo <wubo40@huawei.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, liuzhiqiang26@huawei.com,
        linfeilong@huawei.com
References: <80a757d9-011b-6a58-f6ec-744f02153c74@huawei.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <9d236938-9071-66cc-0874-7afe65651764@suse.de>
Date:   Thu, 9 Apr 2020 23:13:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <80a757d9-011b-6a58-f6ec-744f02153c74@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/4/8 6:02 下午, Wu Bo wrote:
> From: Wu Bo <wubo40@huawei.com>
> 
> Cleanup resources when device init failed on bcache_device_init function
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>

Hi Wu Bo,

Do you test this patch ? I am not sure whether it may work properly,
because all the resources will be released in bcache_device_stop() from
register_bdev(). Your patch makes them being released twice.

If bcache_device_init() fails, cached_dev_init() will fail, then the
caller register_bdev() will fail and jump to err label to call
bcache_device_stop().

If this is a cached device, in bcache_device_stop(),
closure_queue(&d->cl) will call the callback routine cached_dev_flush().
Then in cached_dev_flush() the continue_at() callback cached_dev_free()
will be called. In cached_dev_free() you will see these resources are
freed properly.


Coly Li

> ---
>  drivers/md/bcache/super.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index d98354f..b4e3d0e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -823,6 +823,7 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>                                          SIZE_MAX / sizeof(atomic_t));
>         size_t n;
>         int idx;
> +       int rtn = -ENOMEM;
> 
>         if (!d->stripe_size)
>                 d->stripe_size = 1 << 31;
> @@ -843,20 +844,22 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
>         n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
>         d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
>         if (!d->full_dirty_stripes)
> -               return -ENOMEM;
> +               goto out_free_sectors_dirty;
> 
>         idx = ida_simple_get(&bcache_device_idx, 0,
>                                 BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
> -       if (idx < 0)
> -               return idx;
> +       if (idx < 0) {
> +               rtn = idx;
> +               goto out_free_dirty_stripes;
> +       }
> 
>         if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
>                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> -               goto err;
> +               goto out_free_idx;
> 
>         d->disk = alloc_disk(BCACHE_MINORS);
>         if (!d->disk)
> -               goto err;
> +               goto out_bioset_exit;
> 
>         set_capacity(d->disk, sectors);
>         snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
> @@ -868,7 +871,7 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
> 
>         q = blk_alloc_queue(make_request_fn, NUMA_NO_NODE);
>         if (!q)
> -               return -ENOMEM;
> +               goto out_free_disk;
> 
>         d->disk->queue                  = q;
>         q->queuedata                    = d;
> @@ -890,9 +893,17 @@ static int bcache_device_init(struct bcache_device
> *d, unsigned int block_size,
> 
>         return 0;
> 
> -err:
> +out_free_disk:
> +       put_disk(d->disk);
> +out_bioset_exit:
> +       bioset_exit(&d->bio_split);
> +out_free_idx:
>         ida_simple_remove(&bcache_device_idx, idx);
> -       return -ENOMEM;
> +out_free_dirty_stripes:
> +       kvfree(d->full_dirty_stripes);
> +out_free_sectors_dirty:
> +       kvfree(d->stripe_sectors_dirty);
> +       return rtn;
> 
>  }

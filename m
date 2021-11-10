Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4823744BB91
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Nov 2021 07:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhKJGSR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Nov 2021 01:18:17 -0500
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:53208
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229572AbhKJGSQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Nov 2021 01:18:16 -0500
X-Greylist: delayed 93737 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2021 01:18:15 EST
Received: from [10.8.148.37] (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewCnr0N+Y4th6_kAAA--.117S2;
        Wed, 10 Nov 2021 14:15:26 +0800 (CST)
Message-ID: <5f6cc0b9-50d0-de90-3a52-09abb959b991@wangsu.com>
Date:   Wed, 10 Nov 2021 14:15:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] bcache: fix NULL pointer reference in
 cached_dev_detach_finish
Content-Language: en-US
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211109041304.87225-1-linf@wangsu.com>
From:   Lin Feng <linf@wangsu.com>
In-Reply-To: <20211109041304.87225-1-linf@wangsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: 4zNnewCnr0N+Y4th6_kAAA--.117S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWF47JF4kKw4xCrWDZrWkWFg_yoW5Jw4fpr
        Z3XFyjyFWvqw48Ww43Zr43Wryrt34DAFyfWr1Fya1Y9ryfW347trW5Was8C3yUJrW7uF42
        yr45Kr4kZF4kGaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

Since previous patch(faulted) has been merged into upstream, this issue
has to be fix ASAP, else kernel will crash once detach runs, I'm so sorry
for my mistake!

Thanks,
LinFeng

On 11/9/21 12:13, Lin Feng wrote:
> Commit 0259d4498ba484("bcache: move calc_cached_dev_sectors to proper
> place on backing device detach") tries to fix calc_cached_dev_sectors
> when bcache device detaches, but now we have:
> 
> cached_dev_detach_finish
>      ...
>      bcache_device_detach(&dc->disk);
>          ...
>          closure_put(&d->c->caching);
>          d->c = NULL; [*explicitly set dc->disk.c to NULL*]
>      list_move(&dc->list, &uncached_devices);
>      calc_cached_dev_sectors(dc->disk.c); [*passing a NULL pointer*]
>      ...
> 
> Upper codeflows shows how bug happens, this patch fix the problem by
> caching dc->disk.c beforehand, and cache_set won't be freed under us
> because c->caching closure at least holds a reference count and closure
> callback __cache_set_unregister only being called by bch_cache_set_stop
> which using closure_queue(&c->caching), that means c->caching closure
> callback for destroying cache_set won't be trigger by previous
> closure_put(&d->c->caching).
> So at this stage(while cached_dev_detach_finish is calling) it's safe to
> access cache_set dc->disk.c.
> 
> Fixes: 0259d4498ba484("bcache: move calc_cached_dev_sectors to proper place on backing device detach")
> Signed-off-by: Lin Feng <linf@wangsu.com>
> ---
>   drivers/md/bcache/super.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 4a9a65dff95e..3d9bc7cd27f8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1139,6 +1139,7 @@ static void cancel_writeback_rate_update_dwork(struct cached_dev *dc)
>   static void cached_dev_detach_finish(struct work_struct *w)
>   {
>   	struct cached_dev *dc = container_of(w, struct cached_dev, detach);
> +	struct cache_set *c = dc->disk.c;
>   
>   	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
>   	BUG_ON(refcount_read(&dc->count));
> @@ -1156,7 +1157,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
>   
>   	bcache_device_detach(&dc->disk);
>   	list_move(&dc->list, &uncached_devices);
> -	calc_cached_dev_sectors(dc->disk.c);
> +	calc_cached_dev_sectors(c);
>   
>   	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
>   	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);
> 


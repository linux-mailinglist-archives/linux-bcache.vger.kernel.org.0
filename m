Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A2465976A
	for <lists+linux-bcache@lfdr.de>; Fri, 30 Dec 2022 11:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiL3KlR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 30 Dec 2022 05:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiL3KlQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Dec 2022 05:41:16 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E732BF74
        for <linux-bcache@vger.kernel.org>; Fri, 30 Dec 2022 02:41:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C1F6B22567;
        Fri, 30 Dec 2022 10:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672396873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cvh40b00ZLQKvXxhLoKiVwfdJ2zagGWgrfdas39XDXE=;
        b=ojcSBJxyd6hlUsuiJK4ZvwIvWtTE+YvcoVO0Vzit9b189nQ+57HSCZhDkH9MeXX3ZUfZZB
        Q0/gSMQfO+B9gnFUGmT2zodQTvD7D2MSLtkauKHE8yqmAZ79CdjbDD81FgA2BSoR4ZdX6f
        4LtTD6zk47bU/hTxbt39lgaE9cn/XpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672396873;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cvh40b00ZLQKvXxhLoKiVwfdJ2zagGWgrfdas39XDXE=;
        b=FlwG5knnGUviw6G3seWftBoMWf5u2+4fGItTUjeGV6xCpS30sZQWSO+2YFmI/W5n+PIZ2S
        HZNu1bWcDh1z9GAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 53A19138FA;
        Fri, 30 Dec 2022 10:41:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Oi22NELArmNAVAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 30 Dec 2022 10:41:06 +0000
Message-ID: <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
Date:   Fri, 30 Dec 2022 18:40:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC] Live resize of backing device
Content-Language: en-US
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 9/8/22 4:32 PM, Andrea Tomassetti wrote:
> From 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 2001
> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> Date: Thu, 8 Sep 2022 09:47:55 +0200
> Subject: [PATCH] bcache: Add support for live resize of backing devices
>
> Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>

Hi Andrea,

I am just recovered from Omicron, and able to reply email. Let me place 
my comments inline.


> ---
> Hi Coly,
> Here is the first version of the patch. There are some points I noted 
> down
> that I would like to discuss with you:
>  - I found it pretty convenient to hook the call of the new added 
> function
>    inside the `register_bcache`. In fact, every time (at least from my
>    understandings) a disk changes size, it will trigger a new probe and,
>    thus, `register_bcache` will be triggered. The only inconvenient
>    is that, in case of success, the function will output

The resize should be triggered manually, and not to do it automatically.

You may create a sysfs file under the cached device's directory, name it 
as "extend_size" or something else you think better.

Then the sysadmin may extend the cached device size explicitly on a 
predictable time.

> `error: capacity changed` even if it's not really an error.
>  - I'm using `kvrealloc`, introduced in kernel version 5.15, to resize
>    `stripe_sectors_dirty` and `full_dirty_stripes`. It shouldn't be a
>    problem, right?
>  - There is some reused code between this new function and
>    `bcache_device_init`. Maybe I can move `const size_t max_stripes` to
>    a broader scope or make it a macro, what do you think?
>
> Thank you very much,
> Andrea
>
>  drivers/md/bcache/super.c | 75 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..9a77caf2a18f 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
>      return bch_is_open_cache(dev) || bch_is_open_backing(dev);
>  }
>
> +static bool bch_update_capacity(dev_t dev)
> +{
> +    const size_t max_stripes = min_t(size_t, INT_MAX,
> +                     SIZE_MAX / sizeof(atomic_t));
> +
> +    uint64_t n, n_old;
> +    int nr_stripes_old;
> +    bool res = false;
> +
> +    struct bcache_device *d;
> +    struct cache_set *c, *tc;
> +    struct cached_dev *dcp, *t, *dc = NULL;
> +
> +    uint64_t parent_nr_sectors;
> +
> +    list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
> +        list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
> +            if (dcp->bdev->bd_dev == dev) {
> +                dc = dcp;
> +                goto dc_found;
> +            }
> +
> +dc_found:
> +    if (!dc)
> +        return false;
> +
> +    parent_nr_sectors = bdev_nr_sectors(dc->bdev) - dc->sb.data_offset;
> +
> +    if (parent_nr_sectors == bdev_nr_sectors(dc->disk.disk->part0))
> +        return false;
> +

The above code only handles whole disk using as cached device. If a 
partition of a hard drive is used as cache device, and there are other 
data after this partition, such condition should be handled as well. So 
far I am fine to only extend size when using the whole hard drive as 
cached device, but more code is necessary to check and only permits 
size-extend for such condition.

> +    if (!set_capacity_and_notify(dc->disk.disk, parent_nr_sectors))
> +        return false;

The above code should be done when all rested are set.


> +
> +    d = &dc->disk;
> +
> +    /* Force cached device sectors re-calc */
> +    calc_cached_dev_sectors(d->c);

Here c->cached_dev_sectors might be changed, if any of the following 
steps fails, it should be restored to previous value.


> +
> +    /* Block writeback thread */
> +    down_write(&dc->writeback_lock);
> +    nr_stripes_old = d->nr_stripes;
> +    n = DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
> +    if (!n || n > max_stripes) {
> +        pr_err("nr_stripes too large or invalid: %llu (start sector 
> beyond end of disk?)\n",
> +            n);
> +        goto unblock_and_exit;
> +    }
> +    d->nr_stripes = n;
> +
> +    n = d->nr_stripes * sizeof(atomic_t);
> +    n_old = nr_stripes_old * sizeof(atomic_t);
> +    d->stripe_sectors_dirty = kvrealloc(d->stripe_sectors_dirty, n_old,
> +        n, GFP_KERNEL);
> +    if (!d->stripe_sectors_dirty)
> +        goto unblock_and_exit;
> +
> +    n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
> +    n_old = BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
> +    d->full_dirty_stripes = kvrealloc(d->full_dirty_stripes, n_old, 
> n, GFP_KERNEL);
> +    if (!d->full_dirty_stripes)
> +        goto unblock_and_exit;

If kvrealloc() fails and NULL set to d->full_dirty_sripes, the previous 
array should be restored.

> +
> +    res = true;
> +
> +unblock_and_exit:
> +    up_write(&dc->writeback_lock);
> +    return res;
> +}
> +

I didn't test the patch, from the first glance, I feel the failure 
handling should restore all previous values, otherwise the cache device 
may be in a non-consistent state when extend size fails.


>  struct async_reg_args {
>      struct delayed_work reg_work;
>      char *path;
> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject 
> *k, struct kobj_attribute *attr,
>              mutex_lock(&bch_register_lock);
>              if (lookup_bdev(strim(path), &dev) == 0 &&
>                  bch_is_open(dev))
> -                err = "device already registered";
> +                if (bch_update_capacity(dev))
> +                    err = "capacity changed";
> +                else
> +                    err = "device already registered";


As I said, it should be a separated write-only sysfile under the cache 
device's directory.


> else
>                  err = "device busy";
>              mutex_unlock(&bch_register_lock);
> -- 
> 2.37.3
>


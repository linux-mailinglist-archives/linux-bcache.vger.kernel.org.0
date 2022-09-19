Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2B05BCAF4
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 13:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiISLmV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 07:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiISLmU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 07:42:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820E312AEB
        for <linux-bcache@vger.kernel.org>; Mon, 19 Sep 2022 04:42:19 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v185-20020a1cacc2000000b003b42e4f278cso4470469wme.5
        for <linux-bcache@vger.kernel.org>; Mon, 19 Sep 2022 04:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=OSD8nTG55/o0a7cx1mYXsjrOVZrUpbPfsUtHCCDpY5Y=;
        b=Y848SKtM0l/HbGGfe1f4wMcayQYzY0+IFprLrzmvrefa/lSLWByOnaqB3u7X6flRUv
         KIHth4BDi0MsN2OMOUOVuLhcHRn2ct410PdRM7YTjAfqyuJ1uKpJt1EIamz3B6SBKGtR
         z7o/wvElX8kGljRqzonfLo+wX8IpATY3/WRiK/e7CSnAEHy1zbvLP2Vdhnl8qnyRnHZH
         H7nzh0Fl2kQT4XCVRrDEaZW0UnSeYnlCJw+lcvlMew2M8yN6F/teAQwZys2GFLAT4kXH
         fx4oXT9VfbdN5MxUPYqeYlOZRR36fsn9y/o8pKYIug/8+0H2AjPzwB28gdYBJCMXZT64
         BYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=OSD8nTG55/o0a7cx1mYXsjrOVZrUpbPfsUtHCCDpY5Y=;
        b=wxTvfulynrHK2BWoml9/unDNj/QgaXC5kGeqao51sEp+XUIxzA+U71RfRP9gxWaEZc
         ChSls2DvkR2YmrZqGk+njuB5yET07q4RMyigMBX+fI9DLZ9GpbnMLoZcld3CkG11u09t
         DLLx9s7hGKIxlpcLWibJ5RUlyIHISNDIZiDHJKlpbhn5ek7YH8CWRseCWsiidsx/Fb/L
         DeiI8/JMw8eTi1A4PKFAkyVF10Pspm1IOuxM6be3r1KzqHex9vtERswGIEx0Xy5rP+O8
         K/4RbTUfmc4nL+sCeK84+FIfYbCRuVCYhZ05P4qYYOcHz4SjofVFmhTrQ/we6LdqYgaa
         yRIg==
X-Gm-Message-State: ACrzQf2aZp1Ui8JdR1FdSpJ2xoFZ91SI3395adjOoAMMtPIXj/Cqa0fi
        z9LmYjmv5KUge+wbuXN4zi0eoQ==
X-Google-Smtp-Source: AMsMyM5+Echz1YAwmwIn7k6DGAAg9iftNAJ7KJoq1BZNoQ8OWEeW00KKkoVcvEudiRqizSVGbaqRdg==
X-Received: by 2002:a05:600c:5120:b0:3b4:b3d7:c315 with SMTP id o32-20020a05600c512000b003b4b3d7c315mr13236902wms.65.1663587738017;
        Mon, 19 Sep 2022 04:42:18 -0700 (PDT)
Received: from [192.168.0.68] (143.69.14.37.dynamic.jazztel.es. [37.14.69.143])
        by smtp.gmail.com with ESMTPSA id k38-20020a05600c1ca600b003b31fc77407sm14151941wms.30.2022.09.19.04.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 04:42:17 -0700 (PDT)
Message-ID: <14c2bdbd-e4ae-a5d1-3947-6ea6dc29f0bc@devo.com>
Date:   Mon, 19 Sep 2022 13:42:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC] Live resize of backing device
Content-Language: en-US
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
In-Reply-To: <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,
have you had any time to take a look at this? Do you prefer if I send 
the patch as a separate thread?

Thank you very much,
Andrea

On 8/9/22 10:32, Andrea Tomassetti wrote:
>  From 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 2001
> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> Date: Thu, 8 Sep 2022 09:47:55 +0200
> Subject: [PATCH] bcache: Add support for live resize of backing devices
> 
> Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> ---
> Hi Coly,
> Here is the first version of the patch. There are some points I noted down
> that I would like to discuss with you:
>   - I found it pretty convenient to hook the call of the new added function
>     inside the `register_bcache`. In fact, every time (at least from my
>     understandings) a disk changes size, it will trigger a new probe and,
>     thus, `register_bcache` will be triggered. The only inconvenient
>     is that, in case of success, the function will output
>     `error: capacity changed` even if it's not really an error.
>   - I'm using `kvrealloc`, introduced in kernel version 5.15, to resize
>     `stripe_sectors_dirty` and `full_dirty_stripes`. It shouldn't be a
>     problem, right?
>   - There is some reused code between this new function and
>     `bcache_device_init`. Maybe I can move `const size_t max_stripes` to
>     a broader scope or make it a macro, what do you think?
> 
> Thank you very much,
> Andrea
> 
>   drivers/md/bcache/super.c | 75 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 74 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..9a77caf2a18f 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
>       return bch_is_open_cache(dev) || bch_is_open_backing(dev);
>   }
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
> +    if (!set_capacity_and_notify(dc->disk.disk, parent_nr_sectors))
> +        return false;
> +
> +    d = &dc->disk;
> +
> +    /* Force cached device sectors re-calc */
> +    calc_cached_dev_sectors(d->c);
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
> +    d->full_dirty_stripes = kvrealloc(d->full_dirty_stripes, n_old, n, 
> GFP_KERNEL);
> +    if (!d->full_dirty_stripes)
> +        goto unblock_and_exit;
> +
> +    res = true;
> +
> +unblock_and_exit:
> +    up_write(&dc->writeback_lock);
> +    return res;
> +}
> +
>   struct async_reg_args {
>       struct delayed_work reg_work;
>       char *path;
> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject *k, 
> struct kobj_attribute *attr,
>               mutex_lock(&bch_register_lock);
>               if (lookup_bdev(strim(path), &dev) == 0 &&
>                   bch_is_open(dev))
> -                err = "device already registered";
> +                if (bch_update_capacity(dev))
> +                    err = "capacity changed";
> +                else
> +                    err = "device already registered";
>               else
>                   err = "device busy";
>               mutex_unlock(&bch_register_lock);
> -- 
> 2.37.3
> 
> 
> 
> On 6/9/22 15:22, Andrea Tomassetti wrote:
>> Hi Coly,
>> I have finally some time to work on the patch. I already have a first
>> prototype that seems to work but, before sending it, I would like to
>> ask you two questions:
>>    1. Inspecting the code, I found that the only lock mechanism is the
>> writeback_lock semaphore. Am I correct?
>>    2. How can I effectively test my patch? So far I'm doing something 
>> like this:
>>       a. make-bcache --writeback -B /dev/vdb -C /dev/vdc
>>       b. mkfs.xfs /dev/bcache0
>>       c. dd if=/dev/random of=/mnt/random bs=1M count=1000
>>       d. md5sum /mnt/random | tee /mnt/random.md5
>>       e. live resize the disk and repeat c. and d.
>>       f. umount/reboot/remount and check that the md5 hashes are correct
>>
>> Any suggestions?
>>
>> Thank you very much,
>> Andrea
>>
>> On Fri, Aug 5, 2022 at 9:38 PM Eric Wheeler 
>> <bcache@lists.ewheeler.net> wrote:
>>>
>>> On Wed, 3 Aug 2022, Andrea Tomassetti wrote:
>>>> Hi Coly,
>>>> In one of our previous emails you said that
>>>>> Currently bcache doesn’t support cache or backing device resize
>>>>
>>>> I was investigating this point and I actually found a solution. I
>>>> briefly tested it and it seems to work fine.
>>>> Basically what I'm doing is:
>>>>    1. Check if there's any discrepancy between the nr of sectors
>>>> reported by the bcache backing device (holder) and the nr of sectors
>>>> reported by its parent (slave).
>>>>    2. If the number of sectors of the two devices are not the same,
>>>> then call set_capacity_and_notify on the bcache device.
>>>>    3. From user space, depending on the fs used, grow the fs with some
>>>> utility (e.g. xfs_growfs)
>>>>
>>>> This works without any need of unmounting the mounted fs nor stopping
>>>> the bcache backing device.
>>>
>>> Well done! +1, would love to see a patch for this!
>>>
>>>
>>>> So my question is: am I missing something? Can this live resize cause
>>>> some problems (e.g. data loss)? Would it be useful if I send a patch on
>>>> this?
>>>
>>> A while a go we looked into doing this.  Here is the summary of our
>>> findings, not sure if there are any other considerations:
>>>
>>>    1. Create a sysfs file like /sys/block/bcache0/bcache/resize to 
>>> trigger
>>>       resize on echo 1 >.
>>>    2. Refactor the set_capacity() bits from  bcache_device_init() 
>>> into its
>>>       own function.
>>>    3. Put locks around bcache_device.full_dirty_stripes and
>>>       bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and 
>>> zero the
>>>       new bytes at the end.  Grep where 
>>> bcache_device.full_dirty_stripes is
>>>       used and make sure it is locked appropriately, probably in the
>>>       writeback thread, maybe other places too.
>>>
>>> The cachedev's don't know anything about the bdev size, so (according to
>>> Kent) they will "just work" by referencing new offsets that were
>>> previously beyond the disk. (This is basically the same as resizing the
>>> bdev and then unregister/re-register which is how we resize bdevs now.)
>>>
>>> As for resizing a cachedev, I've not looked at all---not sure about that
>>> one.  We always detach, resize, make-bcache and re-attach the new cache.
>>> Maybe it is similarly simple, but haven't looked.
>>>
>>>
>>> -- 
>>> Eric Wheeler
>>>
>>>
>>>
>>>>
>>>> Kind regards,
>>>> Andrea
>>>>

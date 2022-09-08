Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56AF5B170E
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Sep 2022 10:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiIHIcg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Sep 2022 04:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiIHIcf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Sep 2022 04:32:35 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656FCDABBB
        for <linux-bcache@vger.kernel.org>; Thu,  8 Sep 2022 01:32:34 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bq9so11845945wrb.4
        for <linux-bcache@vger.kernel.org>; Thu, 08 Sep 2022 01:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=NW1IQKeyiIRtd6tB55t5ryrgysanQ6J8DbuQt4esINU=;
        b=K+ZGBOtzLRJ5aV4poA+nNN2waxqab5ANAmhCh2sJJQ/h6rTbyXGJuWtO3yNjgOagFk
         KhqsNZdd+7B5IwkgMPPFpAS08xbw5hbHh0avOnfh9E4x1BMXOxNatLyngF44cXHxeat6
         sxSdutf+7uN5L0kGCVHbEuGUngbidza8QCxnRsdC5ayiUEoWHYqqC7G75VaLkLh1s5Xh
         kmpnafLOjp1uFsNK9qlb5I/8LVwgqDbR9Enq5itqeTQVXLQPEJSMweFtHWTu8u6mROEr
         VS8VX81mqXB2ptX4dNkH8wFX+H6ULKU8M4qOmx4UblXeWz0bxaVo5gLMoVHz/+hg3hO5
         wRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NW1IQKeyiIRtd6tB55t5ryrgysanQ6J8DbuQt4esINU=;
        b=1fdIor3oJXHVRGOarnCULLob70qcLRsmMBXgum1YY4VETw0WWDcARkRe48dxyNQM/0
         UIzCsIXcMi+Syd85nKbY7ANECgbdlsj/MWMHw5PAyQWnw+I4Qk2GSwe69ief7pA/e3z1
         SaRVPJbRWzl05STsqDApmNawU7DoYQ7Tks84nEkMXEJk5VnIY05fm9LDwmqWZi6JCigi
         5LxjKqG0QMqZ7TLSukqDR8H+lU8v7utY/aWT2DCzm8EH2Cvc+vdoGusyiJ0HVXAQzlz/
         ppm9nZ5nxfPMhmh+U3R6BS7/Fk5aoCuoD5fX14zH88UNFPAD9Fknh/sfHUCXRGu45Eyw
         tyjg==
X-Gm-Message-State: ACgBeo0KE8F7LGbOrv29vo6IC/fT6WQyhq3Z7YkgQq/4/lVhUqVgxGwc
        ydfi/4Gb7BdCh7FkusH3JvuMbQ==
X-Google-Smtp-Source: AA6agR5zq0HDK/N91F86PiCE7reYWrotnGZivU6Myq/wxM82FJjQYQ4tmrUI3Gp+aQJ5kG21DTsO+g==
X-Received: by 2002:adf:d1ec:0:b0:228:d9ea:cbd2 with SMTP id g12-20020adfd1ec000000b00228d9eacbd2mr4360954wrd.609.1662625952000;
        Thu, 08 Sep 2022 01:32:32 -0700 (PDT)
Received: from [192.168.0.68] (143.69.14.37.dynamic.jazztel.es. [37.14.69.143])
        by smtp.gmail.com with ESMTPSA id bh5-20020a05600005c500b0021ee65426a2sm19550172wrb.65.2022.09.08.01.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 01:32:31 -0700 (PDT)
Message-ID: <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
Date:   Thu, 8 Sep 2022 10:32:30 +0200
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
In-Reply-To: <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

 From 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 2001
From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date: Thu, 8 Sep 2022 09:47:55 +0200
Subject: [PATCH] bcache: Add support for live resize of backing devices

Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
---
Hi Coly,
Here is the first version of the patch. There are some points I noted down
that I would like to discuss with you:
  - I found it pretty convenient to hook the call of the new added function
    inside the `register_bcache`. In fact, every time (at least from my
    understandings) a disk changes size, it will trigger a new probe and,
    thus, `register_bcache` will be triggered. The only inconvenient
    is that, in case of success, the function will output
    `error: capacity changed` even if it's not really an error.
  - I'm using `kvrealloc`, introduced in kernel version 5.15, to resize
    `stripe_sectors_dirty` and `full_dirty_stripes`. It shouldn't be a
    problem, right?
  - There is some reused code between this new function and
    `bcache_device_init`. Maybe I can move `const size_t max_stripes` to
    a broader scope or make it a macro, what do you think?

Thank you very much,
Andrea

  drivers/md/bcache/super.c | 75 ++++++++++++++++++++++++++++++++++++++-
  1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..9a77caf2a18f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
  	return bch_is_open_cache(dev) || bch_is_open_backing(dev);
  }

+static bool bch_update_capacity(dev_t dev)
+{
+	const size_t max_stripes = min_t(size_t, INT_MAX,
+					 SIZE_MAX / sizeof(atomic_t));
+
+	uint64_t n, n_old;
+	int nr_stripes_old;
+	bool res = false;
+
+	struct bcache_device *d;
+	struct cache_set *c, *tc;
+	struct cached_dev *dcp, *t, *dc = NULL;
+
+	uint64_t parent_nr_sectors;
+
+	list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
+		list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
+			if (dcp->bdev->bd_dev == dev) {
+				dc = dcp;
+				goto dc_found;
+			}
+
+dc_found:
+	if (!dc)
+		return false;
+
+	parent_nr_sectors = bdev_nr_sectors(dc->bdev) - dc->sb.data_offset;
+
+	if (parent_nr_sectors == bdev_nr_sectors(dc->disk.disk->part0))
+		return false;
+
+	if (!set_capacity_and_notify(dc->disk.disk, parent_nr_sectors))
+		return false;
+
+	d = &dc->disk;
+
+	/* Force cached device sectors re-calc */
+	calc_cached_dev_sectors(d->c);
+
+	/* Block writeback thread */
+	down_write(&dc->writeback_lock);
+	nr_stripes_old = d->nr_stripes;
+	n = DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
+	if (!n || n > max_stripes) {
+		pr_err("nr_stripes too large or invalid: %llu (start sector beyond 
end of disk?)\n",
+			n);
+		goto unblock_and_exit;
+	}
+	d->nr_stripes = n;
+
+	n = d->nr_stripes * sizeof(atomic_t);
+	n_old = nr_stripes_old * sizeof(atomic_t);
+	d->stripe_sectors_dirty = kvrealloc(d->stripe_sectors_dirty, n_old,
+		n, GFP_KERNEL);
+	if (!d->stripe_sectors_dirty)
+		goto unblock_and_exit;
+
+	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
+	n_old = BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
+	d->full_dirty_stripes = kvrealloc(d->full_dirty_stripes, n_old, n, 
GFP_KERNEL);
+	if (!d->full_dirty_stripes)
+		goto unblock_and_exit;
+
+	res = true;
+
+unblock_and_exit:
+	up_write(&dc->writeback_lock);
+	return res;
+}
+
  struct async_reg_args {
  	struct delayed_work reg_work;
  	char *path;
@@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject *k, 
struct kobj_attribute *attr,
  			mutex_lock(&bch_register_lock);
  			if (lookup_bdev(strim(path), &dev) == 0 &&
  			    bch_is_open(dev))
-				err = "device already registered";
+				if (bch_update_capacity(dev))
+					err = "capacity changed";
+				else
+					err = "device already registered";
  			else
  				err = "device busy";
  			mutex_unlock(&bch_register_lock);
--
2.37.3



On 6/9/22 15:22, Andrea Tomassetti wrote:
> Hi Coly,
> I have finally some time to work on the patch. I already have a first
> prototype that seems to work but, before sending it, I would like to
> ask you two questions:
>    1. Inspecting the code, I found that the only lock mechanism is the
> writeback_lock semaphore. Am I correct?
>    2. How can I effectively test my patch? So far I'm doing something like this:
>       a. make-bcache --writeback -B /dev/vdb -C /dev/vdc
>       b. mkfs.xfs /dev/bcache0
>       c. dd if=/dev/random of=/mnt/random bs=1M count=1000
>       d. md5sum /mnt/random | tee /mnt/random.md5
>       e. live resize the disk and repeat c. and d.
>       f. umount/reboot/remount and check that the md5 hashes are correct
> 
> Any suggestions?
> 
> Thank you very much,
> Andrea
> 
> On Fri, Aug 5, 2022 at 9:38 PM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
>>
>> On Wed, 3 Aug 2022, Andrea Tomassetti wrote:
>>> Hi Coly,
>>> In one of our previous emails you said that
>>>> Currently bcache doesn’t support cache or backing device resize
>>>
>>> I was investigating this point and I actually found a solution. I
>>> briefly tested it and it seems to work fine.
>>> Basically what I'm doing is:
>>>    1. Check if there's any discrepancy between the nr of sectors
>>> reported by the bcache backing device (holder) and the nr of sectors
>>> reported by its parent (slave).
>>>    2. If the number of sectors of the two devices are not the same,
>>> then call set_capacity_and_notify on the bcache device.
>>>    3. From user space, depending on the fs used, grow the fs with some
>>> utility (e.g. xfs_growfs)
>>>
>>> This works without any need of unmounting the mounted fs nor stopping
>>> the bcache backing device.
>>
>> Well done! +1, would love to see a patch for this!
>>
>>
>>> So my question is: am I missing something? Can this live resize cause
>>> some problems (e.g. data loss)? Would it be useful if I send a patch on
>>> this?
>>
>> A while a go we looked into doing this.  Here is the summary of our
>> findings, not sure if there are any other considerations:
>>
>>    1. Create a sysfs file like /sys/block/bcache0/bcache/resize to trigger
>>       resize on echo 1 >.
>>    2. Refactor the set_capacity() bits from  bcache_device_init() into its
>>       own function.
>>    3. Put locks around bcache_device.full_dirty_stripes and
>>       bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and zero the
>>       new bytes at the end.  Grep where bcache_device.full_dirty_stripes is
>>       used and make sure it is locked appropriately, probably in the
>>       writeback thread, maybe other places too.
>>
>> The cachedev's don't know anything about the bdev size, so (according to
>> Kent) they will "just work" by referencing new offsets that were
>> previously beyond the disk. (This is basically the same as resizing the
>> bdev and then unregister/re-register which is how we resize bdevs now.)
>>
>> As for resizing a cachedev, I've not looked at all---not sure about that
>> one.  We always detach, resize, make-bcache and re-attach the new cache.
>> Maybe it is similarly simple, but haven't looked.
>>
>>
>> --
>> Eric Wheeler
>>
>>
>>
>>>
>>> Kind regards,
>>> Andrea
>>>

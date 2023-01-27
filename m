Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5CA967E5AD
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Jan 2023 13:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjA0MpD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Jan 2023 07:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbjA0Mo5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Jan 2023 07:44:57 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0372BA25C
        for <linux-bcache@vger.kernel.org>; Fri, 27 Jan 2023 04:44:55 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j17so3390453wms.0
        for <linux-bcache@vger.kernel.org>; Fri, 27 Jan 2023 04:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=46Hle9tt58K64uJO5hXccujVHsArdtDFEJ4nmACYja0=;
        b=Pu1ITDqbgvSxSVLj8BP7Wwb9A3luUQx2OeUuEnq/jMpSZA6lZXvmKjQmNr0eegg0MR
         0aI4qhcSz5OitM5jkDyJrAs3qsH+HWz0xaGXq3HttywWysd/miz93m9A79BOVEg2fSOD
         rx2xnzltKL5TXJnUgaznqvZyBEab/fXC+q0WVddGmnqsRMbjzC0hvM3+cYy7+7blPtas
         YEVpDbKWoLOWPzNCH2nA8j4wa1m6NyHc4PMl6NBnmn1jb5zLZ63NIg/CSC5TrU3hH+4J
         fm/vKKsZXBt4y7AgkKGvAx/CQJHLG4EL0oV9JMy3JxaWvZoahR5Hm3fPIN7JOqTFN3ZA
         bBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=46Hle9tt58K64uJO5hXccujVHsArdtDFEJ4nmACYja0=;
        b=5MF+uA38V7YQD5OdCNt3MdVwVJEEJAGHVPl72SGFFXDZqA5KISNRuDaZAC5RA4XVJ6
         WSovotYzfQv9O4nhvhNEwY0GDIdw2oK82sUfQSTygFqP/RYCEE3c3weaoyb9r2FlTSJy
         R2WigxwAJkYlSWIzH8OhEskmmywHEUdPWkCPnd2jXopN2GqZXnVUNXEcK7V5OfVuDOTX
         Mp9/ZYpg536ddzfYw6CHqSWe9IfT4PbS5vWzw5eyE6eZ/0T/rRbgC4tROM8KRJH4TSFj
         VjcnkH1KZ6wtFwhgdZTo0Tk9prUCHevL7u9JVr8+98Nr4veJKexln4HbDAPK9noP3CjU
         jPjw==
X-Gm-Message-State: AFqh2kp7YkkQxoNieqrCrxuUpDucH4/BCw8HRArIiURhW9/0w/KKfX8X
        ZPouI78I5EyRfokSANhEnyWgoQ==
X-Google-Smtp-Source: AMrXdXux/WyexcEwwDZUnLEnc01FawiLkI43DEAT0xu1KzHLhwTSW1u1s4U8blB4Jz5iqS3CffvwUQ==
X-Received: by 2002:a05:600c:540b:b0:3da:282b:e774 with SMTP id he11-20020a05600c540b00b003da282be774mr47214111wmb.38.1674823493595;
        Fri, 27 Jan 2023 04:44:53 -0800 (PST)
Received: from [192.168.0.68] (143.69.14.37.dynamic.jazztel.es. [37.14.69.143])
        by smtp.gmail.com with ESMTPSA id n17-20020a1c7211000000b003dc3f07c876sm960114wmc.46.2023.01.27.04.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 04:44:53 -0800 (PST)
Message-ID: <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com>
Date:   Fri, 27 Jan 2023 13:44:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC] Live resize of backing device
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
 <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de>
 <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
 <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
In-Reply-To: <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

 From 83f490ec8e81c840bdaf69e66021d661751975f2 Mon Sep 17 00:00:00 2001
From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date: Thu, 8 Sep 2022 09:47:55 +0200
Subject: [PATCH v2] bcache: Add support for live resize of backing devices

Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
---
Hi Coly,
this is the second version of the patch. As you correctly pointed out,
I implemented roll-back functionalities in case of error.
I'm testing this funcionality using QEMU/KVM vm via libvirt.
Here the steps:
   1. make-bcache --writeback -B /dev/vdb -C /dev/vdc
   2. mkfs.xfs /dev/bcache0
   3. mount /dev/bcache0 /mnt
   3. dd if=/dev/random of=/mnt/random0 bs=1M count=1000
   4. md5sum /mnt/random0 | tee /mnt/random0.md5
   5. [HOST] virsh blockresize <vm-name> --path <disk-path> --size 
<new-size>
   6. xfs_growfs /dev/bcache0
   6. Repeat steps 3 and 4 with a different file name (e.g. random1.md5)
   7. umount/reboot/remount and check that the md5 hashes are correct with
         md5sum -c /mnt/random?.md5

  drivers/md/bcache/super.c | 84 ++++++++++++++++++++++++++++++++++++++-
  1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..1435a3f605f8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2443,6 +2443,85 @@ static bool bch_is_open(dev_t dev)
  	return bch_is_open_cache(dev) || bch_is_open_backing(dev);
  }

+static bool bch_update_capacity(dev_t dev)
+{
+	const size_t max_stripes = min_t(size_t, INT_MAX,
+					 SIZE_MAX / sizeof(atomic_t));
+
+	uint64_t n, n_old, orig_cached_sectors = 0;
+	void *tmp_realloc;
+
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
+	d = &dc->disk;
+	orig_cached_sectors = d->c->cached_dev_sectors;
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
+		goto restore_dev_sectors;
+	}
+	d->nr_stripes = n;
+
+	n = d->nr_stripes * sizeof(atomic_t);
+	n_old = nr_stripes_old * sizeof(atomic_t);
+	tmp_realloc = kvrealloc(d->stripe_sectors_dirty, n_old,
+		n, GFP_KERNEL);
+	if (!tmp_realloc)
+		goto restore_nr_stripes;
+
+	d->stripe_sectors_dirty = (atomic_t *) tmp_realloc;
+
+	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
+	n_old = BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
+	tmp_realloc = kvrealloc(d->full_dirty_stripes, n_old, n, GFP_KERNEL);
+	if (!tmp_realloc)
+		goto restore_nr_stripes;
+
+	d->full_dirty_stripes = (unsigned long *) tmp_realloc;
+
+	if ((res = set_capacity_and_notify(dc->disk.disk, parent_nr_sectors)))
+		goto unblock_and_exit;
+
+restore_nr_stripes:
+	d->nr_stripes = nr_stripes_old;
+restore_dev_sectors:
+	d->c->cached_dev_sectors = orig_cached_sectors;
+unblock_and_exit:
+	up_write(&dc->writeback_lock);
+	return res;
+}
+
  struct async_reg_args {
  	struct delayed_work reg_work;
  	char *path;
@@ -2569,7 +2648,10 @@ static ssize_t register_bcache(struct kobject *k, 
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
2.39.0



On 25/1/23 18:59, Coly Li wrote:
> 
> 
>> 2023年1月25日 18:07，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
>>
>> On Tue, Jan 17, 2023 at 5:18 PM Coly Li <colyli@suse.de> wrote:
>>>>
> 
>>>>>
>>>>>> struct async_reg_args {
>>>>>>     struct delayed_work reg_work;
>>>>>>     char *path;
>>>>>> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject
>>>>>> *k, struct kobj_attribute *attr,
>>>>>>             mutex_lock(&bch_register_lock);
>>>>>>             if (lookup_bdev(strim(path), &dev) == 0 &&
>>>>>>                 bch_is_open(dev))
>>>>>> -                err = "device already registered";
>>>>>> +                if (bch_update_capacity(dev))
>>>>>> +                    err = "capacity changed";
>>>>>> +                else
>>>>>> +                    err = "device already registered";
>>>>>
>>>>>
>>>>> As I said, it should be a separated write-only sysfile under the cache
>>>>> device's directory.
>>>> Can I ask why you don't like the automatic resize way? Why should the
>>>> resize be manual?
>>>
>>> Most of system administrators don’t like such silently automatic things. They want to extend the size explicitly, especially when there is other dependences in their configurations.
>>>
>> What I was trying to say is that, in order to resize a block device, a
>> manual command should be executed. So, this is already a "non-silent"
>> automatic thing.
>> Moreover, if the block device has a FS on it, the FS needs to be
>> manually grown with some special utilities, e.g. xfs_growfs. So,
>> again, another non-silent automatic step. Don't you agree?
>> For example, to resize a qcow device attached to a VM I'm manually
>> doing a `virsh blockresize`. As soon as I issue that command, the
>> virtio_blk driver inside the VM detects the disk size change and calls
>> the `set_capacity_and_notify` function. Why then should bcache behave
>> differently?
> 
> The above VM example makes sense, I am almost convinced.
> 
>>
>> If you're concerned that this can somehow break the
>> behaviour-compatibility with older versions of the driver, can we
>> protect this automatic discovery with an optional parameter? Will this
>> be an option you will take into account?
> 
> Then let’s forget the option sysfs at this moment. Once you feel the patch is ready for me to testing, please notice me with detailed steps to redo your testing.
> At that time during my testing, let’s discuss whether an extra option is necesssary, for now just keep your idea as automatically resize the cached device.
> 
> Thanks for your detailed explanation.
> 
> Coly Li
> 

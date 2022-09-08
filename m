Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B985B1434
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Sep 2022 07:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiIHF4H (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Sep 2022 01:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiIHF4G (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Sep 2022 01:56:06 -0400
Received: from mail-m2838.qiye.163.com (mail-m2838.qiye.163.com [103.74.28.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E53A2237
        for <linux-bcache@vger.kernel.org>; Wed,  7 Sep 2022 22:56:01 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2838.qiye.163.com (Hmail) with ESMTPA id 3F9AC3C025A;
        Thu,  8 Sep 2022 13:55:58 +0800 (CST)
Message-ID: <c6824e56-3579-33f1-9fa3-ee3e7bc2ced5@easystack.cn>
Date:   Thu, 8 Sep 2022 13:55:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] bcache: limit create flash device size
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
References: <20220907112913.16488-1-mingzhe.zou@easystack.cn>
 <AA4299A9-337A-4710-89DA-5C1E3520DA91@suse.de>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <AA4299A9-337A-4710-89DA-5C1E3520DA91@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZThoZVhgaTU5PSxlLHx1IH1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NS46MSo5FDIWDT40GhkITAws
        DVYwChRVSlVKTU1JTUpNTk5DQ0lLVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT05NSjcG
X-HM-Tid: 0a831bab5b028420kuqw3f9ac3c025a
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/9/8 01:15, Coly Li 写道:
>
>> 2022年9月7日 19:29，mingzhe.zou@easystack.cn 写道：
>>
>> From: mingzhe <mingzhe.zou@easystack.cn>
>>
>> Currently, size is specified and not checked when creating a flash device.
>> This will cause a problem, IO maybe hang when creating a flash device with
>> the actual size of the device.
>>
>> ```
>> 	if (attr == &sysfs_flash_vol_create) {
>> 		int r;
>> 		uint64_t v;
>>
>> 		strtoi_h_or_return(buf, v);
>>
>> 		r = bch_flash_dev_create(c, v);
>> 		if (r)
>> 			return r;
>> 	}
>> ```
>>
>> Because the flash device needs some space for superblock, journal and btree.
>> If the size of data reaches the available size, the new IO cannot allocate
>> space and will hang. At this time, the gc thread will be started frequently.
>>
>> Even more unreasonable, we can create flash devices larger than actual size.
>>
>> ```
>> [root@zou ~]# echo 2G > /sys/block/vdb/bcache/set/flash_vol_create
>> [root@zou ~]# lsblk /dev/vdb
>> NAME       MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
>> vdb        252:16   0   1G  0 disk
>> └─bcache0  251:0    0   2G  0 disk
>> ```
>>
>> This patch will limit the size of flash device, reserving at least 5% of
>> available size for the btree.
>>
>> ```
>> [root@zou ~]# echo 2G > /sys/block/vdb/bcache/set/flash_vol_create
>> [root@zou ~]# lsblk /dev/vdb
>> NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>> vdb        252:16   0    1G  0 disk
>> └─bcache0  251:0    0  950M  0 disk
>> ```
>>
>> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
>> ---
>> drivers/md/bcache/super.c | 13 ++++++++++++-
>> 1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index ba3909bb6bea..f41e09e0e8ee 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1579,6 +1579,17 @@ static int flash_devs_run(struct cache_set *c)
>> 	return ret;
>> }
>>
>
> Hi Mingzhe,
>
>> +static inline sector_t flash_dev_max_sectors(struct cache_set *c)
>> +{
>> +	size_t avail_nbuckets;
>> +	struct cache *ca = c->cache;
>> +	size_t first_bucket = ca->sb.first_bucket;
>> +	size_t njournal_buckets = ca->sb.njournal_buckets;
>> +
>> +	avail_nbuckets = c->nbuckets - first_bucket - njournal_buckets;
>> +	return bucket_to_sector(c, avail_nbuckets / 100 * 95);
>> +}
> Overall I like this idea. This is really something I didn’t realize to fix, nice catch!
>
> BTW, I feel 95% is still quite high rate, how about using 90%? And you may define the rate as a macro in bcache.h.
Hi Coly

Of course, it would be better to define as a macro, I will send v2.

 From my testing, 95% should be safe, no IO hung.

But 90% is better than 95%, because every write 6.25% (1/16) of the 
total capacity will trigger a gc.

mingzhe
>
> Thanks for this patch.
>
> Coly Li
>
>> +
>> int bch_flash_dev_create(struct cache_set *c, uint64_t size)
>> {
>> 	struct uuid_entry *u;
>> @@ -1600,7 +1611,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
>> 	u->first_reg = u->last_reg = cpu_to_le32((u32)ktime_get_real_seconds());
>>
>> 	SET_UUID_FLASH_ONLY(u, 1);
>> -	u->sectors = size >> 9;
>> +	u->sectors = min(flash_dev_max_sectors(c), size >> 9);
>>
>> 	bch_uuid_write(c);
>>
>> -- 
>> 2.17.1
>>
>

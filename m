Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC37544122A
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Nov 2021 03:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhKACa5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 31 Oct 2021 22:30:57 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:41356
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S230222AbhKACa5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 31 Oct 2021 22:30:57 -0400
Received: from [10.8.148.37] (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewDn72PBUH9hlncAAA--.123S2;
        Mon, 01 Nov 2021 10:28:17 +0800 (CST)
Message-ID: <e33c0951-f882-8b2d-a86f-eb9342334b1b@wangsu.com>
Date:   Mon, 1 Nov 2021 10:28:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] bcache: kill macro MAX_CACHES_PER_SET
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20211029125958.95298-1-linf@wangsu.com>
 <9516418b-27d0-d84b-d9cb-be72d5e8f9ce@suse.de>
From:   Lin Feng <linf@wangsu.com>
In-Reply-To: <9516418b-27d0-d84b-d9cb-be72d5e8f9ce@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: 4zNnewDn72PBUH9hlncAAA--.123S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCry7GFWDur43XF4kJryUtrb_yoW5Aw15pF
        WDZFySyr4kZFyUCrykZw1rur1Fy34YkFy8Was3Za40vFy2yFy8ZFW7Kan8Ar1rXryrJF4f
        tr4UtrnxWa4DtaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

OK, I will send another patch but keep MAX_CACHES_PER_SET, thanks :)

linfeng

On 10/30/21 23:19, Coly Li wrote:
> On 10/29/21 8:59 PM, Lin Feng wrote:
>> Commit 697e23495c94f0380c1ed8b11f830b92b64c99ea
>> ("bcache: explicitly make cache_set only have single cache")
>> explicitly makes a cache_set only have single cache and based on the
>> fact that historily only one cache is ever used in the cache set, so
>> macro defination for MAX_CACHES_PER_SET as 8 is misleading now.
>>
>> In fact it should be redefined to 1 and valid number fo sb.nr_in_set
>> should be 1 and sb.nr_this_dev should always be 0.
>>
>> But jset's disk layout replies on MAX_CACHES_PER_SET(8), so replace it
>> with a hardcoded number 8.
>>
>> Signed-off-by: Lin Feng <linf@wangsu.com>
>> ---
>>    drivers/md/bcache/bcache.h  | 2 +-
>>    drivers/md/bcache/super.c   | 4 +---
>>    include/uapi/linux/bcache.h | 4 ++--
>>    3 files changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 5fc989a6d452..a4a410a178c0 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -833,7 +833,7 @@ static inline uint8_t ptr_stale(struct cache_set *c, const struct bkey *k,
>>    static inline bool ptr_available(struct cache_set *c, const struct bkey *k,
>>    				 unsigned int i)
>>    {
>> -	return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && c->cache;
>> +	return (PTR_DEV(k, i) == 0) && c->cache;
>>    }
>>    
>>    /* Btree key macros */
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index f2874c77ff79..2253044c9289 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -140,9 +140,7 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
>>    		goto err;
>>    
>>    	err = "Bad cache device number in set";
>> -	if (!sb->nr_in_set ||
>> -	    sb->nr_in_set <= sb->nr_this_dev ||
>> -	    sb->nr_in_set > MAX_CACHES_PER_SET)
>> +	if (sb->nr_in_set != 1 || sb->nr_this_dev != 0)
>>    		goto err;
>>    
>>    	err = "Journal buckets not sequential";
> 
> Hi Feng,
> 
> The above changes are fine to me. But let's keep the below part as what
> it is at this moment.
> 
> Thanks.
> 
> Coly Li
> 
>> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
>> index cf7399f03b71..4beb3e7826ca 100644
>> --- a/include/uapi/linux/bcache.h
>> +++ b/include/uapi/linux/bcache.h
>> @@ -155,7 +155,6 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsigned int nr_keys)
>>    #define SB_LABEL_SIZE			32
>>    #define SB_JOURNAL_BUCKETS		256U
>>    /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
>> -#define MAX_CACHES_PER_SET		8
>>    
>>    #define BDEV_DATA_START_DEFAULT		16	/* sectors */
>>    
>> @@ -356,7 +355,8 @@ struct jset {
>>    	__u16			btree_level;
>>    	__u16			pad[3];
>>    
>> -	__u64			prio_bucket[MAX_CACHES_PER_SET];
>> +	/* only a single cache is available */
>> +	__u64			prio_bucket[8];
>>    
>>    	union {
>>    		struct bkey	start[0];


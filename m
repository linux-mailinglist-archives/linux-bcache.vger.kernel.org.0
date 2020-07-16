Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2A0221D05
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jul 2020 09:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgGPHId (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 03:08:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:39778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgGPHId (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 03:08:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3D4A3B16E;
        Thu, 16 Jul 2020 07:08:33 +0000 (UTC)
To:     Hannes Reinecke <hare@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-14-colyli@suse.de>
 <ce7d11f4-e77d-d0c2-0e9b-e7f7a16fd3c9@suse.de>
 <c34b9fc4-3458-c7cc-72ba-cb2da7f18d03@suse.de>
 <d7d44a3d-3126-1aea-d31f-a56054511759@suse.de>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Subject: Re: [PATCH v3 13/16] bcache: add bucket_size_hi into struct
 cache_sb_disk for large bucket
Message-ID: <394f1ff9-d130-1e1e-7871-69dd73af6fca@suse.de>
Date:   Thu, 16 Jul 2020 15:08:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d7d44a3d-3126-1aea-d31f-a56054511759@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/7/16 15:02, Hannes Reinecke wrote:
> On 7/16/20 8:41 AM, Coly Li wrote:
>> On 2020/7/16 14:15, Hannes Reinecke wrote:
>>> On 7/15/20 4:30 PM, colyli@suse.de wrote:
>>>> From: Coly Li <colyli@suse.de>
>>>>
>>>> The large bucket feature is to extend bucket_size from 16bit to 32bit.
>>>>
>>>> When create cache device on zoned device (e.g. zoned NVMe SSD), making
>>>> a single bucket cover one or more zones of the zoned device is the
>>>> simplest way to support zoned device as cache by bcache.
>>>>
>>>> But current maximum bucket size is 16MB and a typical zone size of
>>>> zoned
>>>> device is 256MB, this is the major motiviation to extend bucket size to
>>>> a larger bit width.
>>>>
>>>> This patch is the basic and first change to support large bucket size,
>>>> the major changes it makes are,
>>>> - Add BCH_FEATURE_INCOMPAT_LARGE_BUCKET for the large bucket feature,
>>>>     INCOMPAT means it introduces incompatible on-disk format change.
>>>> - Add BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LARGE_BUCKET) routines.
>>>> - Adds __le32 bucket_size_hi into struct cache_sb_disk at offset 0x8d0
>>>>     for the on-disk super block format.
>>>> - For the in-memory super block struct cache_sb, member bucket_size is
>>>>     extended from __u16 to __32.
>>>> - Add get_bucket_size() to combine the bucket_size and bucket_size_hi
>>>>     from struct cache_sb_disk into an unsigned int value.
>>>>
>>>> Since we already have large bucket size helpers meta_bucket_pages(),
>>>> meta_bucket_bytes() and alloc_meta_bucket_pages(), they make sure when
>>>> bucket size > 8MB, the memory allocation for bcache meta data bucket
>>>> won't fail no matter how large the bucket size extended. So these meta
>>>> data buckets are handled properly when the bucket size width increase
>>>> from 16bit to 32bit, we don't need to worry about them.
>>>>
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> ---
>>>>    drivers/md/bcache/alloc.c    |  2 +-
>>>>    drivers/md/bcache/features.c | 22 ++++++++++++++++++++++
>>>>    drivers/md/bcache/features.h |  9 ++++++---
>>>>    drivers/md/bcache/movinggc.c |  4 ++--
>>>>    drivers/md/bcache/super.c    | 23 +++++++++++++++++++----
>>>>    include/uapi/linux/bcache.h  |  3 ++-
>>>>    6 files changed, 52 insertions(+), 11 deletions(-)
>>>>    create mode 100644 drivers/md/bcache/features.c
>>>>
>>>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>>>> index a1df0d95151c..52035a78d836 100644
>>>> --- a/drivers/md/bcache/alloc.c
>>>> +++ b/drivers/md/bcache/alloc.c
>>>> @@ -87,7 +87,7 @@ void bch_rescale_priorities(struct cache_set *c, int
>>>> sectors)
>>>>    {
>>>>        struct cache *ca;
>>>>        struct bucket *b;
>>>> -    unsigned int next = c->nbuckets * c->sb.bucket_size / 1024;
>>>> +    unsigned long next = c->nbuckets * c->sb.bucket_size / 1024;
>>>>        unsigned int i;
>>>>        int r;
>>>>    diff --git a/drivers/md/bcache/features.c
>>>> b/drivers/md/bcache/features.c
>>>> new file mode 100644
>>>> index 000000000000..ba53944bb390
>>>> --- /dev/null
>>>> +++ b/drivers/md/bcache/features.c
>>>> @@ -0,0 +1,22 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +/*
>>>> + * Feature set bits and string conversion.
>>>> + * Inspired by ext4's features compat/incompat/ro_compat related code.
>>>> + *
>>>> + * Copyright 2020 Coly Li <colyli@suse.de>
>>>> + *
>>>> + */
>>>> +#include <linux/bcache.h>
>>>> +#include "bcache.h"
>>>> +
>>>> +struct feature {
>>>> +    int        compat;
>>>> +    unsigned int    mask;
>>>> +    const char    *string;
>>>> +};
>>>> +
>>>> +static struct feature feature_list[] = {
>>>> +    {BCH_FEATURE_INCOMPAT, BCH_FEATURE_INCOMPAT_LARGE_BUCKET,
>>>> +        "large_bucket"},
>>>> +    {0, 0, 0 },
>>>> +};
>>>> diff --git a/drivers/md/bcache/features.h
>>>> b/drivers/md/bcache/features.h
>>>> index ae7df37b9862..dca052cf5203 100644
>>>> --- a/drivers/md/bcache/features.h
>>>> +++ b/drivers/md/bcache/features.h
>>>> @@ -11,9 +11,13 @@
>>>>    #define BCH_FEATURE_INCOMPAT        2
>>>>    #define BCH_FEATURE_TYPE_MASK        0x03
>>>>    +/* Feature set definition */
>>>> +/* Incompat feature set */
>>>> +#define BCH_FEATURE_INCOMPAT_LARGE_BUCKET    0x0001 /* 32bit bucket
>>>> size */
>>>> +
>>>>    #define BCH_FEATURE_COMPAT_SUUP        0
>>>>    #define BCH_FEATURE_RO_COMPAT_SUUP    0
>>>> -#define BCH_FEATURE_INCOMPAT_SUUP    0
>>>> +#define BCH_FEATURE_INCOMPAT_SUUP    BCH_FEATURE_INCOMPAT_LARGE_BUCKET
>>>>      #define BCH_HAS_COMPAT_FEATURE(sb, mask) \
>>>>            ((sb)->feature_compat & (mask))
>>>> @@ -22,8 +26,6 @@
>>>>    #define BCH_HAS_INCOMPAT_FEATURE(sb, mask) \
>>>>            ((sb)->feature_incompat & (mask))
>>>>    -/* Feature set definition */
>>>> -
>>>>    #define BCH_FEATURE_COMPAT_FUNCS(name, flagname) \
>>>>    static inline int bch_has_feature_##name(struct cache_sb *sb) \
>>>>    { \
>>>> @@ -75,4 +77,5 @@ static inline void bch_clear_feature_##name(struct
>>>> cache_sb *sb) \
>>>>            ~BCH##_FEATURE_INCOMPAT_##flagname; \
>>>>    }
>>>>    +BCH_FEATURE_INCOMPAT_FUNCS(large_bucket, LARGE_BUCKET);
>>>>    #endif
>>>> diff --git a/drivers/md/bcache/movinggc.c
>>>> b/drivers/md/bcache/movinggc.c
>>>> index b7dd2d75f58c..5872d6470470 100644
>>>> --- a/drivers/md/bcache/movinggc.c
>>>> +++ b/drivers/md/bcache/movinggc.c
>>>> @@ -206,8 +206,8 @@ void bch_moving_gc(struct cache_set *c)
>>>>        mutex_lock(&c->bucket_lock);
>>>>          for_each_cache(ca, c, i) {
>>>> -        unsigned int sectors_to_move = 0;
>>>> -        unsigned int reserve_sectors = ca->sb.bucket_size *
>>>> +        unsigned long sectors_to_move = 0;
>>>> +        unsigned long reserve_sectors = ca->sb.bucket_size *
>>>>                     fifo_used(&ca->free[RESERVE_MOVINGGC]);
>>>>              ca->heap.used = 0;
>>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>>> index 02901d0ae8e2..e0da52f8e8c9 100644
>>>> --- a/drivers/md/bcache/super.c
>>>> +++ b/drivers/md/bcache/super.c
>>>> @@ -60,6 +60,17 @@ struct workqueue_struct *bch_journal_wq;
>>>>      /* Superblock */
>>>>    +static unsigned int get_bucket_size(struct cache_sb *sb, struct
>>>> cache_sb_disk *s)
>>>> +{
>>>> +    unsigned int bucket_size = le16_to_cpu(s->bucket_size);
>>>> +
>>>> +    if (sb->version >= BCACHE_SB_VERSION_CDEV_WITH_FEATURES &&
>>>> +         bch_has_feature_large_bucket(sb))
>>>> +        bucket_size |= le32_to_cpu(s->bucket_size_hi) << 16;
>>>> +
>>>> +    return bucket_size;
>>>> +}
>>>> +
>>>>    static const char *read_super_common(struct cache_sb *sb,  struct
>>>> block_device *bdev,
>>>>                         struct cache_sb_disk *s)
>>>>    {
>>> That is a bit unfortunate; bucket_size_hi is 32 bits, so we might end up
>>> with an overflow here if bucket_size_hi is larger that USHRT_MAX.
>>>
>>
>> In bcache-tools, the maximum value of bucket_size is restricted to
>> UINT_MAX in make_bcache(),
>>     case 'b':
>>         bucket_size =
>>             hatoi_validate(optarg, "bucket size", UINT_MAX);
>>         break;
>>
>> So the overflow won't happen if people use bcache program to make the
>> cache device.
>>
>> If people want to modify bucket_size_hi themselves, in
>> read_super_common(), there are several checks to make sure the hacked
>> cache_sb->bucket_size composed from the hacked bucket_size_hi won't mess
>> up whole kernel,
>> 1) should be power of 2
>>     if (!is_power_of_2(sb->bucket_size))
>> 2) should large than page size
>>     if (sb->bucket_size < PAGE_SECTORS)
>> 3) should match sb->nbuckets
>>     if (get_capacity(bdev->bd_disk) <
>>         sb->bucket_size * sb->nbuckets)
>> 4) no overlap with super block
>>     if (sb->first_bucket * sb->bucket_size < 16)
>>
>> Therefore the overflow won't happen, and even happen by hacking it won't
>> panic kernel.
>>
>>> So to avoid overflow either make bucket_size_hi 16 bit, too, or define
>>> this feature such that the original bucket_size field is ignored and
>>> just the new size field is used.
>>>
>>
>> Now cache_sb_disk is for on-disk format, it contains 16bit bucket_size
>> and 32bit bucket_size_hi. cache_sb is for in-memory object only, it
>> simply has a 32bit bucket_size.
>>
>> Indeed I planed to set cache_sb->bucket_size to be uint64_t, but I feel
>> people won't use bucket size > 1TB, and finally make it to be a 32bit
>> value.
>>
>> I will add more code comments to explain why there won't be overflow in
>> get_bucket_size() because user space tool limits the maximum size.
>>
> So why not make bucket_size_hi 16-bit?
> That would clear up the ambiguity, and you wouldn't need to add comments
> ...

I did seriously think maybe many years later for some crazy reason
people do want >4TB bucket size.... also I though 48bit bucket size
should be large enough in whole Linux life cycle....

Maybe I can set bucket_size_hi as 16bit and pad the following 2 bytes
for the on-disk format, or just make buket_size_hi as 16bit if I was
over thoughtful.

Coly Li

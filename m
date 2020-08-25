Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E82251717
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Aug 2020 13:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgHYLIK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Aug 2020 07:08:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:39780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729458AbgHYLIJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Aug 2020 07:08:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F262B5BA;
        Tue, 25 Aug 2020 11:08:36 +0000 (UTC)
Subject: Re: [PATCH v2 02/12] bcache: explicitly make cache_set only have
 single cache
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200822114536.23491-1-colyli@suse.de>
 <20200822114536.23491-3-colyli@suse.de>
 <04a41d67-5591-4ef6-7083-67ae367e63fc@suse.de>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <4e8c76d7-04c4-f33c-ea0b-74dfceb9ae01@suse.de>
Date:   Tue, 25 Aug 2020 19:08:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <04a41d67-5591-4ef6-7083-67ae367e63fc@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/8/25 14:17, Hannes Reinecke wrote:
> On 8/22/20 1:45 PM, Coly Li wrote:
>> Currently although the bcache code has a framework for multiple caches
>> in a cache set, but indeed the multiple caches never completed and users
>> use md raid1 for multiple copies of the cached data.
>>
>> This patch does the following change in struct cache_set, to explicitly
>> make a cache_set only have single cache,
>> - Change pointer array "*cache[MAX_CACHES_PER_SET]" to a single pointer
>>    "*cache".
>> - Remove pointer array "*cache_by_alloc[MAX_CACHES_PER_SET]".
>> - Remove "caches_loaded".
>>
>> Now the code looks as exactly what it does in practic: only one cache is
>> used in the cache set.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>   drivers/md/bcache/alloc.c  |  2 +-
>>   drivers/md/bcache/bcache.h |  8 +++-----
>>   drivers/md/bcache/super.c  | 19 ++++++++-----------
>>   3 files changed, 12 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>> index 4493ff57476d..3385f6add6df 100644
>> --- a/drivers/md/bcache/alloc.c
>> +++ b/drivers/md/bcache/alloc.c
>> @@ -501,7 +501,7 @@ int __bch_bucket_alloc_set(struct cache_set *c,
>> unsigned int reserve,
>>         bkey_init(k);
>>   -    ca = c->cache_by_alloc[0];
>> +    ca = c->cache;
>>       b = bch_bucket_alloc(ca, reserve, wait);
>>       if (b == -1)
>>           goto err;
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 5ff6e9573935..aa112c1adba1 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -519,9 +519,7 @@ struct cache_set {
>>         struct cache_sb        sb;
>>   -    struct cache        *cache[MAX_CACHES_PER_SET];
>> -    struct cache        *cache_by_alloc[MAX_CACHES_PER_SET];
>> -    int            caches_loaded;
>> +    struct cache        *cache;
>>         struct bcache_device    **devices;
>>       unsigned int        devices_max_used;
>> @@ -808,7 +806,7 @@ static inline struct cache *PTR_CACHE(struct
>> cache_set *c,
>>                         const struct bkey *k,
>>                         unsigned int ptr)
>>   {
>> -    return c->cache[PTR_DEV(k, ptr)];
>> +    return c->cache;
>>   }
>>     static inline size_t PTR_BUCKET_NR(struct cache_set *c,
>> @@ -890,7 +888,7 @@ do {                                    \
>>   /* Looping macros */
>>     #define for_each_cache(ca, cs, iter)                    \
>> -    for (iter = 0; ca = cs->cache[iter], iter < (cs)->sb.nr_in_set;
>> iter++)
>> +    for (iter = 0; ca = cs->cache, iter < 1; iter++)
>>     #define for_each_bucket(b, ca)                        \
>>       for (b = (ca)->buckets + (ca)->sb.first_bucket;            \
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 7057ec48f3d1..e9ccfa17beb8 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1675,7 +1675,7 @@ static void cache_set_free(struct closure *cl)
>>       for_each_cache(ca, c, i)
>>           if (ca) {
>>               ca->set = NULL;
>> -            c->cache[ca->sb.nr_this_dev] = NULL;
>> +            c->cache = NULL;
>>               kobject_put(&ca->kobj);
>>           }
>>   
> Please kill 'for_each_cache()', too, and replace it by an if clause.

Yes, it is done in next patch: [PATCH v2 03/12] bcache: remove
for_each_cache()

Thanks.

Coly Li

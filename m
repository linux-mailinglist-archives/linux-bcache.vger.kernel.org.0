Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63B5BA73E
	for <lists+linux-bcache@lfdr.de>; Fri, 16 Sep 2022 09:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIPHKx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 16 Sep 2022 03:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiIPHKe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Sep 2022 03:10:34 -0400
Received: from mail-m31106.qiye.163.com (mail-m31106.qiye.163.com [103.74.31.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFEE10E2
        for <linux-bcache@vger.kernel.org>; Fri, 16 Sep 2022 00:10:17 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m31106.qiye.163.com (Hmail) with ESMTPA id 48CA0A3A29;
        Fri, 16 Sep 2022 15:10:15 +0800 (CST)
Message-ID: <d806a566-446a-1649-3621-edd66a629f69@easystack.cn>
Date:   Fri, 16 Sep 2022 15:10:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] bcache: set cool backing device to maximum writeback rate
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
References: <20220915120544.9086-1-mingzhe.zou@easystack.cn>
 <993D46BB-D0BF-499C-B8B3-89405DD1DB66@suse.de>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <993D46BB-D0BF-499C-B8B3-89405DD1DB66@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGRhDVhhMShgeHxhLQx5PSVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBw6FAw*MDIOMzQBAi8LExM5
        HxMKFDdVSlVKTU1ISEpJSUpNS0xNVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSktOT0o3Bg++
X-HM-Tid: 0a8345223d6a00fekurm48ca0a3a29
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



在 2022/9/15 22:44, Coly Li 写道:
> 
> 
>> 2022年9月15日 20:05，mingzhe.zou@easystack.cn 写道：
>>
>> From: mingzhe <mingzhe.zou@easystack.cn>
>>
>> If the data in the cache is dirty, gc thread cannot reclaim the space.
>> We need to writeback dirty data to backing, and then gc can reclaim
>> this area. So bcache will writeback dirty data more aggressively.
>>
> 
> The writeback operation should try to avoid negative influence to front end I/O performance. Especially the I/O latency.
> 
> 
>> Currently, there is no io request within 30 seconds of the cache_set,
>> all backing devices in it will be set to the maximum writeback rate.
> 
> The idle time depends how many backing devices there are. If there is 1 backing device, the idle time before maximum writeback rate setting is 30 seconds, if there are 2 backing device, the idle time will be 60 seconds. If there are 6 backing device attached with a cache set, the maximum writeback rate will be set after 180 seconds without any incoming I/O request. That is to say, the maximum writeback rate setting is not a aggressive writeback policy, it is just try to writeback more dirty data without interfering regular I/O request when the cache set is really idle.
> 
The idle time does not depend on how many backing devices there are. 
Although the threshold of c->idle_counter is c->attached_dev_nr * 6, 
each backing device has its own writeback thread. If all backing devices 
are in writeback mode (writeback_percent is not 0) , it should be fixed 
for 30 seconds.

```

void bch_cached_dev_writeback_init(struct cached_dev *dc)
{
     ......
     INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
}


static void update_writeback_rate(struct work_struct *work)
{

     ......

     /*
      * If the whole cache set is idle, set_at_max_writeback_rate()
      * will set writeback rate to a max number. Then it is
      * unncessary to update writeback rate for an idle cache set
      * in maximum writeback rate number(s).
      */
     if (atomic_read(&dc->has_dirty) && dc->writeback_percent &&
         !set_at_max_writeback_rate(c, dc)) {
         do {
             if (!down_read_trylock((&dc->writeback_lock))) {
                 dc->rate_update_retry++;
                 if (dc->rate_update_retry <=
                     BCH_WBRATE_UPDATE_MAX_SKIPS)
                     break;
                 down_read(&dc->writeback_lock);
                 dc->rate_update_retry = 0;
             }
             __update_writeback_rate(dc);
             update_gc_after_writeback(c);
             up_read(&dc->writeback_lock);
         } while (0);
     }
     ......
}

```

The c->idle_counter is increased everytime when update_writeback_rate() 
is called. If all backing devices attached to the same cache set have 
identical dc->writeback_rate_update_seconds values, it is about 6 rounds 
of update_writeback_rate() on each backing device before 
c->at_max_writeback_rate is set to 1.
> 
>>
>> However, for multiple backings in the same cache_set, there maybe both
>> cold and hot devices. Since the cold device has no read or write requests,
>> dirty data should writeback as soon as possible.
>>
> 
> NACK. The writeback thread will take mutex lock(s) of btree nodes, increasing writeback rate may introduce negative contribution to front end I/O performance. And your change will make the P.I controller for writeback rate not work properly.
> Indeed, increasing the writeback rate will introduce negative 
contribution to front end I/O performance. But the upper limit of 
writeback is the limit of the backing device. Generally, the performance 
of cache device is more than 10x better than that of baking device. So, 
the  front end I/O performance impact is not entirely unacceptable. It's 
a waste to keep dirty for a device without any io requests for about 30 
seconds.
> 
>> This patch reduces the control granularity of set_at_max_writeback_rate()
>> from cache_set to cached_dev. Because even cache_set still has io requests,
>> writeback cold data can make more space for hot data.
> 
> I won’t take this patch, because it will obviously interfere front I/O performance. Maybe it really works fine in your condition, but other people with other workload will not happy.
> 
That's okay,  we love to hear what other people think about this patch. 
  This is very helpful for us.
> Thanks.
> 
> Coly Li
> 
> 
>>
>> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
>> ---
>> drivers/md/bcache/bcache.h    |  5 +++--
>> drivers/md/bcache/request.c   | 10 +++++-----
>> drivers/md/bcache/writeback.c | 16 +++++++---------
>> 3 files changed, 15 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index f4436229cd83..768bb217e156 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -330,6 +330,9 @@ struct cached_dev {
>> 	 */
>> 	atomic_t		has_dirty;
>>
>> +	atomic_t		idle_counter;
>> +	atomic_t		at_max_writeback_rate;
>> +
>> #define BCH_CACHE_READA_ALL		0
>> #define BCH_CACHE_READA_META_ONLY	1
>> 	unsigned int		cache_readahead_policy;
>> @@ -520,8 +523,6 @@ struct cache_set {
>> 	struct cache_accounting accounting;
>>
>> 	unsigned long		flags;
>> -	atomic_t		idle_counter;
>> -	atomic_t		at_max_writeback_rate;
>>
>> 	struct cache		*cache;
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index f2c5a7e06fa9..f53b5831f500 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -1141,7 +1141,7 @@ static void quit_max_writeback_rate(struct cache_set *c,
>> 	 * To avoid such situation, if mutext_trylock() failed, only writeback
>> 	 * rate of current cached device is set to 1, and __update_write_back()
>> 	 * will decide writeback rate of other cached devices (remember now
>> -	 * c->idle_counter is 0 already).
>> +	 * dc->idle_counter is 0 already).
>> 	 */
>> 	if (mutex_trylock(&bch_register_lock)) {
>> 		for (i = 0; i < c->devices_max_used; i++) {
>> @@ -1184,16 +1184,16 @@ void cached_dev_submit_bio(struct bio *bio)
>> 	}
>>
>> 	if (likely(d->c)) {
>> -		if (atomic_read(&d->c->idle_counter))
>> -			atomic_set(&d->c->idle_counter, 0);
>> +		if (atomic_read(&dc->idle_counter))
>> +			atomic_set(&dc->idle_counter, 0);
>> 		/*
>> 		 * If at_max_writeback_rate of cache set is true and new I/O
>> 		 * comes, quit max writeback rate of all cached devices
>> 		 * attached to this cache set, and set at_max_writeback_rate
>> 		 * to false.
>> 		 */
>> -		if (unlikely(atomic_read(&d->c->at_max_writeback_rate) == 1)) {
>> -			atomic_set(&d->c->at_max_writeback_rate, 0);
>> +		if (unlikely(atomic_read(&dc->at_max_writeback_rate) == 1)) {
>> +			atomic_set(&dc->at_max_writeback_rate, 0);
>> 			quit_max_writeback_rate(d->c, dc);
>> 		}
>> 	}
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index 3f0ff3aab6f2..40e10fd3552e 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -172,7 +172,7 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
>> 	 * called. If all backing devices attached to the same cache set have
>> 	 * identical dc->writeback_rate_update_seconds values, it is about 6
>> 	 * rounds of update_writeback_rate() on each backing device before
>> -	 * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
>> +	 * dc->at_max_writeback_rate is set to 1, and then max wrteback rate set
>> 	 * to each dc->writeback_rate.rate.
>> 	 * In order to avoid extra locking cost for counting exact dirty cached
>> 	 * devices number, c->attached_dev_nr is used to calculate the idle
>> @@ -180,12 +180,11 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
>> 	 * back mode, but it still works well with limited extra rounds of
>> 	 * update_writeback_rate().
>> 	 */
>> -	if (atomic_inc_return(&c->idle_counter) <
>> -	    atomic_read(&c->attached_dev_nr) * 6)
>> +	if (atomic_inc_return(&dc->idle_counter) < 6)
>> 		return false;
>>
>> -	if (atomic_read(&c->at_max_writeback_rate) != 1)
>> -		atomic_set(&c->at_max_writeback_rate, 1);
>> +	if (atomic_read(&dc->at_max_writeback_rate) != 1)
>> +		atomic_set(&dc->at_max_writeback_rate, 1);
>>
>> 	atomic_long_set(&dc->writeback_rate.rate, INT_MAX);
>>
>> @@ -195,14 +194,13 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
>> 	dc->writeback_rate_change = 0;
>>
>> 	/*
>> -	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
>> +	 * Check dc->idle_counter and dc->at_max_writeback_rate agagain in case
>> 	 * new I/O arrives during before set_at_max_writeback_rate() returns.
>> 	 * Then the writeback rate is set to 1, and its new value should be
>> 	 * decided via __update_writeback_rate().
>> 	 */
>> -	if ((atomic_read(&c->idle_counter) <
>> -	     atomic_read(&c->attached_dev_nr) * 6) ||
>> -	    !atomic_read(&c->at_max_writeback_rate))
>> +	if ((atomic_read(&dc->idle_counter) < 6) ||
>> +	    !atomic_read(&dc->at_max_writeback_rate))
>> 		return false;
>>
>> 	return true;
>> -- 
>> 2.17.1
>>
> 
> 

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606E64F8F74
	for <lists+linux-bcache@lfdr.de>; Fri,  8 Apr 2022 09:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiDHHYh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 Apr 2022 03:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiDHHYb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 Apr 2022 03:24:31 -0400
Received: from mail-m2835.qiye.163.com (mail-m2835.qiye.163.com [103.74.28.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494972E5C5D
        for <linux-bcache@vger.kernel.org>; Fri,  8 Apr 2022 00:22:26 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2835.qiye.163.com (Hmail) with ESMTPA id 1FC2C8A0276;
        Fri,  8 Apr 2022 15:22:24 +0800 (CST)
Message-ID: <d1ac0a9c-1e6b-0399-8cd3-2e1e2d41e419@easystack.cn>
Date:   Fri, 8 Apr 2022 15:22:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] bcache: fixup btree_cache_wait list damage
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     zoumingzhe@qq.com, linux-bcache@vger.kernel.org
References: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
 <5bb2307b-829f-f772-5539-d36a2d3e2403@suse.de>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <5bb2307b-829f-f772-5539-d36a2d3e2403@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRkdTR1WGEhIHkgZTUsaSU
        pJVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PVE6Hzo6QjIoTCorFFFLMzw*
        SEoKCRNVSlVKTU9CT0tJTk9PT0JIVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSktJSEg3Bg++
X-HM-Tid: 0a80080d8061841dkuqw1fc2c8a0276
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/4/7 23:53, Coly Li 写道:
> On 4/1/22 8:27 PM, mingzhe.zou@easystack.cn wrote:
>> From: ZouMingzhe <mingzhe.zou@easystack.cn>
>>
>> We get a kernel crash about "list_add corruption. next->prev should be
>> prev (ffff9c801bc01210), but was ffff9c77b688237c. 
>> (next=ffffae586d8afe68)."
>>
>> crash> struct list_head 0xffff9c801bc01210
>> struct list_head {
>>    next = 0xffffae586d8afe68,
>>    prev = 0xffffae586d8afe68
>> }
>> crash> struct list_head 0xffff9c77b688237c
>> struct list_head {
>>    next = 0x0,
>>    prev = 0x0
>> }
>> crash> struct list_head 0xffffae586d8afe68
>> struct list_head struct: invalid kernel virtual address: 
>> ffffae586d8afe68  type: "gdb_readmem_callback"
>> Cannot access memory at address 0xffffae586d8afe68
>>
>> [230469.019492] Call Trace:
>> [230469.032041]  prepare_to_wait+0x8a/0xb0
>> [230469.044363]  ? bch_btree_keys_free+0x6c/0xc0 [escache]
>> [230469.056533]  mca_cannibalize_lock+0x72/0x90 [escache]
>> [230469.068788]  mca_alloc+0x2ae/0x450 [escache]
>> [230469.080790]  bch_btree_node_get+0x136/0x2d0 [escache]
>> [230469.092681]  bch_btree_check_thread+0x1e1/0x260 [escache]
>> [230469.104382]  ? finish_wait+0x80/0x80
>> [230469.115884]  ? bch_btree_check_recurse+0x1a0/0x1a0 [escache]
>> [230469.127259]  kthread+0x112/0x130
>> [230469.138448]  ? kthread_flush_work_fn+0x10/0x10
>> [230469.149477]  ret_from_fork+0x35/0x40
>>
>> bch_btree_check_thread() and bch_dirty_init_thread() maybe call
>> mca_cannibalize() to cannibalize other cached btree nodes. Only
>> one thread can do it at a time, so the op of other threads will
>> be added to the btree_cache_wait list.
>>
>> We must call finish_wait() to remove op from btree_cache_wait
>> before free it's memory address. Otherwise, the list will be
>> damaged. Also should call bch_cannibalize_unlock() to release
>> the btree_cache_alloc_lock and wake_up other waiters.
>>
>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>
>
> Thank you for this fix, it is really cool to find such defect on 
> cannibalize lock/unlock. It spent me a little time to understand how 
> it happens, and reply you late.
>
> I feel the root cause is not from where you patched in 
> bch_btree_check() and bch_root_node_dirty_init(), something really 
> fishing when using mca_cannibalize_lock(),
>
> 843 static int mca_cannibalize_lock(struct cache_set *c, struct 
> btree_op *op)
>  844 {
>  845         spin_lock(&c->btree_cannibalize_lock);
>  846         if (likely(c->btree_cache_alloc_lock == NULL)) {
>  847                 c->btree_cache_alloc_lock = current;
>  848         } else if (c->btree_cache_alloc_lock != current) {
>  849                 if (op)
>  850 prepare_to_wait(&c->btree_cache_wait, &op->wait,
>  851 TASK_UNINTERRUPTIBLE);
>  852 spin_unlock(&c->btree_cannibalize_lock);
>  853                 return -EINTR;
>  854         }
>  855         spin_unlock(&c->btree_cannibalize_lock);
>  856
>  857         return 0;
>  858 }
>
> In line 849-851, if the cannibalized locking failed, insert current 
> op->wait into c->btree_cache_wait. Then at line 852, return -EINTR to 
> indicate the caller should retry. But it seems no caller checks 
> whether the return value is -EINTR and handles it properly.
>
> Your patch should work, but I feel the issue of bch_cannibalize_lock() 
> is not solved yet. Maybe we should work on handling -EINTR returned 
> from mca_cannibalize_lock() IMHO.
>
The patch 2 handle the return value.
>
> BTW, when you observe the panic, how are the hardware configurations 
> about,
>
> - CPU cores
0-39, total 40 cpus
>
> - Memory size
memory status:
crash> kmem -i
                  PAGES        TOTAL      PERCENTAGE
     TOTAL MEM  32919429     125.6 GB         ----
          FREE   638133       2.4 GB    1% of TOTAL MEM
          USED  32281296     123.1 GB   98% of TOTAL MEM
        SHARED  1353791       5.2 GB    4% of TOTAL MEM
       BUFFERS   131366     513.1 MB    0% of TOTAL MEM
        CACHED  2022521       7.7 GB    6% of TOTAL MEM
          SLAB   590919       2.3 GB    1% of TOTAL MEM

    TOTAL HUGE        0            0         ----
     HUGE FREE        0            0    0% of TOTAL HUGE

    TOTAL SWAP        0            0         ----
     SWAP USED        0            0    0% of TOTAL SWAP
     SWAP FREE        0            0    0% of TOTAL SWAP

  COMMIT LIMIT  16459714      62.8 GB         ----
     COMMITTED  67485109     257.4 GB  410% of TOTAL LIMIT
>
> - Cache size

cache disk 460G

>
> -  Number of keys on the btree root node

c->root->keys->set->data info:

crash> btree 0xffff9c6bd873cc00|grep data
         data = 0xffff9c6bda6c0000
         data = 0xffff9c6bda6cd000
         data = 0x0
         data = 0x0
         data = {
       data = {
crash> bset 0xffff9c6bda6c0000
struct bset {
   csum = 4228267359687445853,
   magic = 15660900678624291974,
   seq = 15025931623832980119,
   version = 1,
   keys = 6621,
   {
     start = 0xffff9c6bda6c0020,
     d = 0xffff9c6bda6c0020
   }
}
crash> bset 0xffff9c6bda6cd000
struct bset {
   csum = 38040912,
   magic = 15660900678624291974,
   seq = 15025931623832980119,
   version = 0,
   keys = 0,
   {
     start = 0xffff9c6bda6cd020,
     d = 0xffff9c6bda6cd020
   }
}


>
> Thanks.
>
>
> Coly Li
>
>
>
>> ---
>>   drivers/md/bcache/btree.c     | 10 +++++++++-
>>   drivers/md/bcache/btree.h     |  2 ++
>>   drivers/md/bcache/writeback.c |  8 ++++++++
>>   3 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
>> index ad9f16689419..f8e6f5c7c736 100644
>> --- a/drivers/md/bcache/btree.c
>> +++ b/drivers/md/bcache/btree.c
>> @@ -885,7 +885,7 @@ static struct btree *mca_cannibalize(struct 
>> cache_set *c, struct btree_op *op,
>>    * cannibalize_bucket() will take. This means every time we unlock 
>> the root of
>>    * the btree, we need to release this lock if we have it held.
>>    */
>> -static void bch_cannibalize_unlock(struct cache_set *c)
>> +void bch_cannibalize_unlock(struct cache_set *c)
>>   {
>>       spin_lock(&c->btree_cannibalize_lock);
>>       if (c->btree_cache_alloc_lock == current) {
>> @@ -1968,6 +1968,14 @@ static int bch_btree_check_thread(void *arg)
>>               c->gc_stats.nodes++;
>>               bch_btree_op_init(&op, 0);
>>               ret = bcache_btree(check_recurse, p, c->root, &op);
>> +            /* The op may be added to cache_set's btree_cache_wait
>> +            * in mca_cannibalize(), must ensure it is removed from
>> +            * the list and release btree_cache_alloc_lock before
>> +            * free op memory.
>> +            * Otherwise, the btree_cache_wait will be damaged.
>> +            */
>> +            bch_cannibalize_unlock(c);
>> +            finish_wait(&c->btree_cache_wait, &(&op)->wait);
>>               if (ret)
>>                   goto out;
>>           }
>> diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
>> index 50482107134f..435e82574ac3 100644
>> --- a/drivers/md/bcache/btree.h
>> +++ b/drivers/md/bcache/btree.h
>> @@ -365,6 +365,8 @@ static inline void force_wake_up_gc(struct 
>> cache_set *c)
>> _r; \
>>   })
>>   +void bch_cannibalize_unlock(struct cache_set *c);
>> +
>>   #define MAP_DONE    0
>>   #define MAP_CONTINUE    1
>>   diff --git a/drivers/md/bcache/writeback.c 
>> b/drivers/md/bcache/writeback.c
>> index 9ee0005874cd..5b828555bca8 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -865,6 +865,14 @@ static int bch_root_node_dirty_init(struct 
>> cache_set *c,
>>           }
>>       } while (ret == -EAGAIN);
>>   +    /* The op may be added to cache_set's btree_cache_wait
>> +     * in mca_cannibalize(), must ensure it is removed from
>> +     * the list and release btree_cache_alloc_lock before
>> +     * free op memory.
>> +     * Otherwise, the btree_cache_wait will be damaged.
>> +     */
>> +    bch_cannibalize_unlock(c);
>> +    finish_wait(&c->btree_cache_wait, &(&op.op)->wait);
>>       return ret;
>>   }
>
>
>

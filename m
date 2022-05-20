Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B686C52E732
	for <lists+linux-bcache@lfdr.de>; Fri, 20 May 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346931AbiETIWr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 20 May 2022 04:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiETIWo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 May 2022 04:22:44 -0400
Received: from mail-m2839.qiye.163.com (mail-m2839.qiye.163.com [103.74.28.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA9A14041B
        for <linux-bcache@vger.kernel.org>; Fri, 20 May 2022 01:22:41 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2839.qiye.163.com (Hmail) with ESMTPA id 4619EC029E;
        Fri, 20 May 2022 16:22:39 +0800 (CST)
Message-ID: <112eaaf7-05fd-3b4f-0190-958d0c85fa1f@easystack.cn>
Date:   Fri, 20 May 2022 16:22:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3] bcache: dynamic incremental gc
Content-Language: en-US
To:     linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
References: <20220511073903.13568-1-mingzhe.zou@easystack.cn>
 <ecce38e7-8ba0-5fbf-61a6-2dfc21c7793d@suse.de>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <ecce38e7-8ba0-5fbf-61a6-2dfc21c7793d@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUJDSxhWQkhIH0wfSEJJT0
        8ZVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NhQ6Agw4ETIuFkNLARACTlE4
        LBIaFEJVSlVKTU5IS0hPQk5CTUJIVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0xNTjcG
X-HM-Tid: 0a80e08fc21a8421kuqw4619ec029e
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/5/12 21:41, Coly Li 写道:
> On 5/11/22 3:39 PM, mingzhe.zou@easystack.cn wrote:
>> From: ZouMingzhe <mingzhe.zou@easystack.cn>
>>
>> Currently, GC wants no more than 100 times, with at least
>> 100 nodes each time, the maximum number of nodes each time
>> is not limited.
>>
>> ```
>> static size_t btree_gc_min_nodes(struct cache_set *c)
>> {
>>          ......
>>          min_nodes = c->gc_stats.nodes / MAX_GC_TIMES;
>>          if (min_nodes < MIN_GC_NODES)
>>                  min_nodes = MIN_GC_NODES;
>>
>>          return min_nodes;
>> }
>> ```
>>
>> According to our test data, when nvme is used as the cache,
>> it takes about 1ms for GC to handle each node (block 4k and
>> bucket 512k). This means that the latency during GC is at
>> least 100ms. During GC, IO performance would be reduced by
>> half or more.
>>
>> I want to optimize the IOPS and latency under high pressure.
>> This patch hold the inflight peak. When IO depth up to maximum,
>> GC only process very few(10) nodes, then sleep immediately and
>> handle these requests.
>>
>> bch_bucket_alloc() maybe wait for bch_allocator_thread() to
>> wake up, and and bch_allocator_thread() needs to wait for gc
>> to complete, in which case gc needs to end quickly. So, add
>> bucket_alloc_inflight to cache_set in v3.
>>
>> ```
>> long bch_bucket_alloc(struct cache *ca, unsigned int reserve, bool wait)
>> {
>>          ......
>>          do {
>> prepare_to_wait(&ca->set->bucket_wait, &w,
>>                                  TASK_UNINTERRUPTIBLE);
>>
>>                  mutex_unlock(&ca->set->bucket_lock);
>>                  schedule();
>>                  mutex_lock(&ca->set->bucket_lock);
>>          } while (!fifo_pop(&ca->free[RESERVE_NONE], r) &&
>>                   !fifo_pop(&ca->free[reserve], r));
>>          ......
>> }
>>
>> static int bch_allocator_thread(void *arg)
>> {
>>     ......
>>     allocator_wait(ca, bch_allocator_push(ca, bucket));
>>     wake_up(&ca->set->btree_cache_wait);
>>     wake_up(&ca->set->bucket_wait);
>>     ......
>> }
>>
>> static void bch_btree_gc(struct cache_set *c)
>> {
>>     ......
>>     bch_btree_gc_finish(c);
>>     wake_up_allocators(c);
>>     ......
>> }
>> ```
>>
>> Apply this patch, each GC maybe only process very few nodes,
>> GC would last a long time if sleep 100ms each time. So, the
>> sleep time should be calculated dynamically based on gc_cost.
>>
>> At the same time, I added some cost statistics in gc_stat,
>> hoping to provide useful information for future work.
>
>
> Hi Mingzhe,
>
> From the first glance, I feel this change may delay the small GC 
> period, and finally result a large GC period, which is not expected.
>
> But it is possible that my feeling is incorrect. Do you have detailed 
> performance number about both I/O latency  and GC period, then I can 
> have more understanding for this effort.
>
> BTW, I will add this patch to my testing set and experience myself.
>
>
> Thanks.
>
>
> Coly Li
>
>
Hi Coly,

First, your feeling is right. Then, I have some performance number abort 
before and after this patch.
Since the mailing list does not accept attachments, I put them on the gist.

Please visit the page for details:
https://gist.github.com/zoumingzhe/69a353e7c6fffe43142c2f42b94a67b5
mingzhe
>
>
> [snipped]
>
>
>

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AC25307D3
	for <lists+linux-bcache@lfdr.de>; Mon, 23 May 2022 04:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345712AbiEWCxA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 22 May 2022 22:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240967AbiEWCxA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 May 2022 22:53:00 -0400
Received: from mail-m2839.qiye.163.com (mail-m2839.qiye.163.com [103.74.28.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ACB37A3E
        for <linux-bcache@vger.kernel.org>; Sun, 22 May 2022 19:52:58 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2839.qiye.163.com (Hmail) with ESMTPA id 384F9C0423;
        Mon, 23 May 2022 10:52:56 +0800 (CST)
Message-ID: <2cc994af-292f-ae7e-e793-058ada23c1ca@easystack.cn>
Date:   Mon, 23 May 2022 10:52:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3] bcache: dynamic incremental gc
Content-Language: en-US
To:     linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
References: <20220511073903.13568-1-mingzhe.zou@easystack.cn>
 <ecce38e7-8ba0-5fbf-61a6-2dfc21c7793d@suse.de>
 <112eaaf7-05fd-3b4f-0190-958d0c85fa1f@easystack.cn>
 <37d75ff-877c-5453-b6a0-81c8d737299@ewheeler.net>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <37d75ff-877c-5453-b6a0-81c8d737299@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRpKQhhWSUkdTENITU9MH0
        NKVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OSo6Kjo6TzIqTjoDLCtCNhI#
        IgMwCjdVSlVKTU5ISUxPSExNTUtJVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0lLSTcG
X-HM-Tid: 0a80eed4f8828421kuqw384f9c0423
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/5/21 02:24, Eric Wheeler 写道:
> On Fri, 20 May 2022, Zou Mingzhe wrote:
>> 在 2022/5/12 21:41, Coly Li 写道:
>>> On 5/11/22 3:39 PM, mingzhe.zou@easystack.cn wrote:
>>> Hi Mingzhe,
>>>
>>>  From the first glance, I feel this change may delay the small GC period, and
>>> finally result a large GC period, which is not expected.
>>>
>>> But it is possible that my feeling is incorrect. Do you have detailed
>>> performance number about both I/O latency  and GC period, then I can have
>>> more understanding for this effort.
>>>
>>> BTW, I will add this patch to my testing set and experience myself.
>>>
>>>
>>> Thanks.
>>>
>>>
>>> Coly Li
>>>
>>>
>> Hi Coly,
>>
>> First, your feeling is right. Then, I have some performance number abort
>> before and after this patch.
>> Since the mailing list does not accept attachments, I put them on the gist.
>>
>> Please visit the page for details:
>> “https://gist.github.com/zoumingzhe/69a353e7c6fffe43142c2f42b94a67b5”
>> mingzhe
> The graphs certainly show that peak latency is much lower, that is
> improvement, and dmesg shows the avail_nbuckets stays about the same so GC
> is keeping up.
>
> Questions:
>
> 1. Why is the after-"BW NO GC" graph so much flatter than the before-"BW
>     NO GC" graph?  I would expect your control measurements to be about the
>     same before vs after.  You might `blkdiscard` the cachedev and
>     re-format between runs in case the FTL is getting in the way, or maybe
>     something in the patch is affecting the "NO GC" graphs.
Hi Eric,

First, I re-format the disk with make-bcache before each fio. Then, the 
graph after "BW NO GC" is much flatter than the graph before "BW NO GC", 
I think you may have seen another patch (bcache: allow allocator 
invalidate bucket in gc) I pushed . I also noticed a drop in iops of at 
least 20%, but we added a lot of patches between before and after, so it 
will take some time to figure out which patch is causing it.
>
> 2. I wonder how the latency looks if you zoom into to the latency graph:
>     If you truncate the before-"LATENCY DO GC" graph at 3000 us then how
>     does the average latency look between the two?
I will test the performance numbers for each patch one by one, and 
provide more detailed graph and number later.

mingzhe
>
> 3. This may be solved if you can fix the control graph issue in #1, but
>     the before vs after of "BW DO GC" shows about a 30% decrease in
>     bandwidth performance outside of the GC spikes.  "IOPS DO GC" is lower
>     with the patch too.  Do you think that your dynamic incremental gc
>     algorithm be tuned to deal with GC latency and still provide nearly the
>     same IOPS and bandwidth as before?
>
>
> --
> Eric Wheeler
>
>
>
>>>
>>> [snipped]
>>>
>>>
>>>

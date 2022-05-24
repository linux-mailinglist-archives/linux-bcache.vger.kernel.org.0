Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E61532138
	for <lists+linux-bcache@lfdr.de>; Tue, 24 May 2022 04:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiEXCrV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 May 2022 22:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiEXCrU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 May 2022 22:47:20 -0400
Received: from mail-m2839.qiye.163.com (mail-m2839.qiye.163.com [103.74.28.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DFA3617F
        for <linux-bcache@vger.kernel.org>; Mon, 23 May 2022 19:47:19 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2839.qiye.163.com (Hmail) with ESMTPA id D69A9C060F;
        Tue, 24 May 2022 10:47:17 +0800 (CST)
Message-ID: <00681253-d238-3597-7bc7-83d0dc735175@easystack.cn>
Date:   Tue, 24 May 2022 10:47:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH v3] bcache: dynamic incremental gc
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
References: <20220511073903.13568-1-mingzhe.zou@easystack.cn>
 <ecce38e7-8ba0-5fbf-61a6-2dfc21c7793d@suse.de>
 <112eaaf7-05fd-3b4f-0190-958d0c85fa1f@easystack.cn>
 <37d75ff-877c-5453-b6a0-81c8d737299@ewheeler.net>
 <2cc994af-292f-ae7e-e793-058ada23c1ca@easystack.cn>
 <28a044fd-e10e-ce25-6ce5-023ea9085139@easystack.cn>
 <c781bbd4-5093-3f9a-38e2-bbe2846387a@ewheeler.net>
Content-Language: en-US
In-Reply-To: <c781bbd4-5093-3f9a-38e2-bbe2846387a@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWUJLHxlWSx1NHhkZT0tLHx
        pIVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ogg6ETo5DjIoCT4zIz8dFTUO
        ISowCiJVSlVKTU5ISE1LT0hDSENKVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0JMTjcG
X-HM-Tid: 0a80f3f62ad08421kuqwd69a9c060f
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/5/24 01:55, Eric Wheeler 写道:
> On Mon, 23 May 2022, Zou Mingzhe wrote:
>> 在 2022/5/23 10:52, Zou Mingzhe 写道:
>>> 在 2022/5/21 02:24, Eric Wheeler 写道:
>>>> On Fri, 20 May 2022, Zou Mingzhe wrote:
>>>>
>>>> Questions:
>>>>
>>>> 1. Why is the after-"BW NO GC" graph so much flatter than the before-"BW
>>>>      NO GC" graph?  I would expect your control measurements to be about the
>>>>      same before vs after.  You might `blkdiscard` the cachedev and
>>>>      re-format between runs in case the FTL is getting in the way, or maybe
>>>>      something in the patch is affecting the "NO GC" graphs.
>>>> 2. I wonder how the latency looks if you zoom into to the latency graph:
>>>>      If you truncate the before-"LATENCY DO GC" graph at 3000 us then how
>>>>      does the average latency look between the two?
>>>> 3. This may be solved if you can fix the control graph issue in #1, but
>>>>      the before vs after of "BW DO GC" shows about a 30% decrease in
>>>>      bandwidth performance outside of the GC spikes.  "IOPS DO GC" is lower
>>>>      with the patch too.  Do you think that your dynamic incremental gc
>>>>      algorithm be tuned to deal with GC latency and still provide nearly the
>>>>      same IOPS and bandwidth as before?
>>>>
>>>>
>>>> -- 
>>>> Eric Wheeler
>> Hi Eric,
>>
>> I have done a retest round and update all data on
>> "https://gist.github.com/zoumingzhe/69a353e7c6fffe43142c2f42b94a67b5".
>>
>> First, there is only this patch between before and after, I re-format the disk
>> with make-bcache before each fio. Each case was tested 5 times, and the
>> results are as follows:
>>
>>                      before after
>>        NO GC           DO GC          NO GC          DO GC
>> 1    99162.29     97366.28     99970.89     98290.81
>> 2    99897.80     97879.99     96829.14     95548.88
>> 3    98183.49     98834.29     101508.06   98581.53
>> 4    98563.17     98476.61     96866.40     96676.87
>> 5    97059.91     98356.50     96248.10     94442.61
>>
>> Some details are also shown in the new graph, in addition to the raw data
>> available for download.
>>
>> I confirm that this patch does not cause a drop in iops. We have some other
>> patches that may have affected the previous test, but this patch works fine.
> Looks great, glad to see that it performs well!
>
> What is the 3000us spike on the "after" line of "LATENCY DO GC" at about
> t=40s ? There is a drop in IOPS and BW on the other graphs at t=40s, too,
> but I don't see the same behavior on the "NO GC" side.
>
> -Eric
>
Hi, Eric

I tested each case 5 times and used the last result to make this graph, 
you can check the raw data.

The first 4 times results also have graph in the raw data, you can also 
find some spikes over  2000us on the "NO GC" side.

So, I don't think the 3000us "spike" at 40s are a problem, it just looks 
like a system fluctuation.

mingzhe
>> In fact, we mostly modified the gc handling.
>>
>> mingzhe
>>
>>
>>
>>
>>
>>
>>
>>

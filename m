Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF99527BE08
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Sep 2020 09:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgI2Hbz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Sep 2020 03:31:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14702 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725535AbgI2Hbz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Sep 2020 03:31:55 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E4E625DD713540E622CC
        for <linux-bcache@vger.kernel.org>; Tue, 29 Sep 2020 15:31:53 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 15:31:53 +0800
Subject: Re: [PATCH] bcache: remove unused function closure_set_ret_ip()
To:     Coly Li <colyli@suse.de>, <kent.overstreet@gmail.com>,
        <linux-bcache@vger.kernel.org>
References: <20200929064741.3604133-1-yanaijie@huawei.com>
 <9b928925-2b86-c007-48bd-583423b19c09@suse.de>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <8ec300f6-3ef6-a180-6c45-a368e31db0c2@huawei.com>
Date:   Tue, 29 Sep 2020 15:31:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <9b928925-2b86-c007-48bd-583423b19c09@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.92]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2020/9/29 14:49, Coly Li 写道:
> On 2020/9/29 14:47, Jason Yan wrote:
>> This function has no caller after commit e4bf791937d8 ("bcache: Fix,
>> improve efficiency of closure_sync()").
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> 
> NACK. Indeed, it is necessary for closure debug, you don't want to make
> current life even worse.
> 

Get it. Thanks.

Jason

> 
> Coly Li
> 
> 
>> ---
>>   drivers/md/bcache/closure.h | 7 -------
>>   1 file changed, 7 deletions(-)
>>
>> diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
>> index c88cdc4ae4ec..35f3f87f74e4 100644
>> --- a/drivers/md/bcache/closure.h
>> +++ b/drivers/md/bcache/closure.h
>> @@ -205,13 +205,6 @@ static inline void closure_set_ip(struct closure *cl)
>>   #endif
>>   }
>>   
>> -static inline void closure_set_ret_ip(struct closure *cl)
>> -{
>> -#ifdef CONFIG_BCACHE_CLOSURES_DEBUG
>> -	cl->ip = _RET_IP_;
>> -#endif
>> -}
>> -
>>   static inline void closure_set_waiting(struct closure *cl, unsigned long f)
>>   {
>>   #ifdef CONFIG_BCACHE_CLOSURES_DEBUG
>>
> 

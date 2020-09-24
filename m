Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7937B27704E
	for <lists+linux-bcache@lfdr.de>; Thu, 24 Sep 2020 13:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgIXLvP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Sep 2020 07:51:15 -0400
Received: from mail-m964.mail.126.com ([123.126.96.4]:42550 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgIXLvP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Sep 2020 07:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=3TqyY
        /Xr/nUxMdrccC1nS0zQyMQTxFb5jQkSUN+hTBc=; b=jPlq6IfMoEvth2TJWyslA
        IkLYTrpjxuPjaROXZy7f/OCc5FGmLxCRyFc2DPaR5PesY0sNtr+lRodlo236xPz2
        MDDlDLPeAIJevMI016YmAm1NZxO2V7HD5D0ZfaB4ZlFUUIDcA6yu2IHxQvUtc35s
        atAnTvzKdFCHZIvgcM20Rg=
Received: from liusdudeMacBook-Pro.local (unknown [114.246.35.136])
        by smtp9 (Coremail) with SMTP id NeRpCgBXZBUpiGxfPFfmJw--.21544S2;
        Thu, 24 Sep 2020 19:51:05 +0800 (CST)
Subject: Re: [PATCH] bcache: insert bkeys without overlap when placeholder
 missed
To:     Coly Li <colyli@suse.de>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        sdu.liu@huawei.com
References: <20200922154727.30389-1-liusdu@126.com>
 <985ee4e6-3eab-741d-59bd-f9fbf615986a@suse.de>
 <847d3dad-e9be-b79f-da61-41466dc4d6ef@126.com>
 <4c36992e-6c6c-3931-f1a6-134928c91914@suse.de>
From:   Liu Hua <liusdu@126.com>
Message-ID: <cc46324a-6197-de42-5a70-9bd04eaf5bea@126.com>
Date:   Thu, 24 Sep 2020 19:51:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <4c36992e-6c6c-3931-f1a6-134928c91914@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NeRpCgBXZBUpiGxfPFfmJw--.21544S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF1rAryxArW5ur4fKw1UGFg_yoW5Jw47pr
        W3CanrK3W8Zw10v39rAw1xXa1Fq398GFWUXw13WFW3ZF90kr15urWSgw45G3Wjgrnaywsr
        Xr48J3s8WF4qvFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jQrcfUUUUU=
X-Originating-IP: [114.246.35.136]
X-CM-SenderInfo: polx2vbx6rjloofrz/1tbi2wmpNF16IXhcgQAAss
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hope My email client configured correctly this time.

在 2020/9/23 下午11:26, Coly Li 写道:
> On 2020/9/23 23:18, Liu Hua wrote:
>> Hi Coly,
>>
>>  Thanks for you reply!
>>
>> 在 2020/9/22 下午11:51, Coly Li 写道:
>>> On 2020/9/22 23:47, Liu Hua wrote:
>>>> Btree spliting and garbage collection process will drop
>>>> placeholders, which may cause cache miss collision. We can
>>>> insert nonoverlapping bkeys with write lock. It is helpful
>>>> for performance.
>>>>
>>> Could you please to explain more detais about,
>>> - How does "Btree spliting and garbage collection process will drop
>>> placeholders" happen?
>>> - And how does the consequence "cache miss collision" happen?
>> Cache miss process is as following:
>>
>> A. Insert placeholder with read lock
>>   - lookup missed cache
>>   - insert placeholder bkey
>> B. Read data from backing disk and write to cache
>> C. Insert real bkey with write lock
>>   - check and fixup placeholder in bch_extent_insert_fixup.
>>   - if bkey to be inserted does not match placeholder bkey. Inserting
>> will failed.
>>     Bcache marks this type of failure as cache miss collision.  we can
>> get this number
>>     from /sys/block/bcacheX/bcache/cache/stats_total/cache_miss_collision
>> So a failed "c" process will lead the cache miss process fail, even if
>> we have data
>> in place but metadata failed.  There are two types of reasons causing
>> this failure:
>>
>> 1. Two cache miss processes collide as following (two processes names
>> ABC and A'B'C')
LBAs of the two process should overlap, otherwise ABC will not fail.

>>    A   
>>    A'
>>    B
>>    B'
>>    C(will fail)
>>    C'(will succeed)
>> 2. placeholder bkeys were dropped before "C".  btree_mergesort called
>> from GC and 
>> btree_split will drop "bad" bkeys including placeholder bkeys.
>>
>> For reason 2，since we hold write lock，if there is no overlaps with
>> existing bkeys.
>> we can insert bkeys safely. this is what this patch does.
>>> - Do you observe performance improvement? If yes, which part is improved
>>> and what is the performance number?
>> Can we treat this patch as a bugfix?  We add a prefetch framework in
>> bcache and find 3% performace
>> improvement and reduction of collision in an order of one, in spark
>> word-count test with 1G ram
>> disk as cache. And I think it is helpful both for our situation and
>> original bcache. I can add a test based on original bcache.
> 
> Copied. Give me some time to understand your change. Maybe more question
> will follow up. Thank you for the above detailed information :-)
> 
> Coly Li
> 


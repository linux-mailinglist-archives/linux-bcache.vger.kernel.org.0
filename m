Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27A85BC2C7
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 08:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiISGYp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 02:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiISGYo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 02:24:44 -0400
Received: from mail-m31106.qiye.163.com (mail-m31106.qiye.163.com [103.74.31.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088FF655D
        for <linux-bcache@vger.kernel.org>; Sun, 18 Sep 2022 23:24:42 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m31106.qiye.163.com (Hmail) with ESMTPA id AA189A03B5;
        Mon, 19 Sep 2022 14:24:40 +0800 (CST)
Message-ID: <7239cacc-9bad-389b-2838-36d38a147c4f@easystack.cn>
Date:   Mon, 19 Sep 2022 14:24:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] bcache: fix set_at_max_writeback_rate() for multiple
 attached devices
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com
References: <20220918121647.103458-1-colyli@suse.de>
 <6d8a2888-b20a-c71c-733f-97c6a91f1244@easystack.cn>
 <EABD6CA2-9BC2-4243-B3DE-3B0FA6F43583@suse.de>
From:   mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <EABD6CA2-9BC2-4243-B3DE-3B0FA6F43583@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZGhhOVh1NSElCQxkZTRhOS1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hOT1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBw6MSo*MjIQQipRIjUNVktN
        DwwKChBVSlVKTU1ITk1DTUNKSk5OVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0pPTDcG
X-HM-Tid: 0a83546b975500fekurmaa189a03b5
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



在 2022/9/19 12:38, Coly Li 写道:
> 
> 
>> 2022年9月19日 11:29，mingzhe <mingzhe.zou@easystack.cn> 写道：
>>
>>
>>
>> 在 2022/9/18 20:16, Coly Li 写道:
>>> Inside set_at_max_writeback_rate() the calculation in following if()
>>> check is wrong,
>>> 	if (atomic_inc_return(&c->idle_counter) <
>>> 	    atomic_read(&c->attached_dev_nr) * 6)
>>> Because each attached backing device has its own writeback thread
>>> running and increasing c->idle_counter, the counter increates much
>>> faster than expected. The correct calculation should be,
>>> 	(counter / dev_nr) < dev_nr * 6
>>> which equals to,
>>> 	counter < dev_nr * dev_nr * 6
>>> This patch fixes the above mistake with correct calculation, and helper
>>> routine idle_counter_exceeded() is added to make code be more clear.
>>> Reported-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>> Signed-off-by: Coly Li <colyli@suse.de>
>>> ---
>>> Changelog:
>>> v2: Add the missing "!atomic_read(&c->at_max_writeback_rate)" part
>>>      back.
>>> v1: Original verison.
>>>   drivers/md/bcache/writeback.c | 73 +++++++++++++++++++++++++----------
>>>   1 file changed, 52 insertions(+), 21 deletions(-)
>>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>>> index 647661005176..c186bf55fe61 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -157,6 +157,53 @@ static void __update_writeback_rate(struct cached_dev *dc)
>>>   	dc->writeback_rate_target = target;
>>>   }
>>>   +static bool idle_counter_exceeded(struct cache_set *c)
>>> +{
>>> +	int counter, dev_nr;
>>> +
>>> +	/*
>>> +	 * If c->idle_counter is overflow (idel for really long time),
>>> +	 * reset as 0 and not set maximum rate this time for code
>>> +	 * simplicity.
>>> +	 */
>>> +	counter = atomic_inc_return(&c->idle_counter);
>>> +	if (counter <= 0) {
>>> +		atomic_set(&c->idle_counter, 0);
>>> +		return false;
>>> +	}
>>> +
>>> +	dev_nr = atomic_read(&c->attached_dev_nr);
>>> +	if (dev_nr == 0)
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * c->idle_counter is increased by writeback thread of all
>>> +	 * attached backing devices, in order to represent a rough
>>> +	 * time period, counter should be divided by dev_nr.
>>> +	 * Otherwise the idle time cannot be larger with more backing
>>> +	 * device attached.
>>> +	 * The following calculation equals to checking
>>> +	 *	(counter / dev_nr) < (dev_nr * 6)
>>> +	 */
>>> +	if (counter < (dev_nr * dev_nr * 6))
>>> +		return false;
>> Hi, Coly

> 
> BTW, if the patch looks fine to you, could you please to response a Reviewed-by or Acked-by for it?
> 
> Thanks.
> 
> Coly Li
> 
Acked-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

Thanks

mingzhe
> 

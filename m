Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678254CB497
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 02:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiCCBpo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Mar 2022 20:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiCCBpm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Mar 2022 20:45:42 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034CF1B60BF;
        Wed,  2 Mar 2022 17:44:58 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o26so3187615pgb.8;
        Wed, 02 Mar 2022 17:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=GKfixL+RCzxQ3nMzM1T0+qIgNpu8yUbRoteeaJl5UQ8=;
        b=Dz/Pb0xq1QnJ/gpcIs2Ch9yQ9/8AKuR9lyfZMGALXJmweXehRVOUktVxyjOmC3zKVp
         d+SUGE+vBUyQbH6PRe21i5LOIzXAbZ4icyTi8ft7gBiKq/+IjYSLxCCW0QoGxnLu91Ko
         O+nY4E/3YEAZFkGPJg3m5U6HreYpNEHTAVytYuNc/w68WzEBQQb697PqnOHhzOAjHH+o
         9tV7SjFXI/cVysjMJX/w5ONeG7awuncpDBvHZjHQQEYW6I9KkrG8mr7a0G8tsEd+H98d
         zs3QSddgWRpN9G72o0TuEXPQYBkpA1qbe09g3gMp9pZPR4OtcRAgXzqwp2jF1HIBkv8c
         oJBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GKfixL+RCzxQ3nMzM1T0+qIgNpu8yUbRoteeaJl5UQ8=;
        b=ptMQcwYAPer7ZLOJRW6txcJo6jRvfmuNcf+OR+fg31GNdA8YP2wDLFNmHHa03HV4Sh
         wOTAwmnUGKrchedjtDwBZqN032cluKpVi7R9dsvZRwRj/VZE8axueio6rnJgOy8dGCpb
         e41yRs45TFGIa978UJGmC8htjMLiHRv0twBtjEZ62K9znuh420NIkrhF2IZ98IaGgCYs
         2V5F7voOXwIIwpv0fAerCAzHyG9K7VDVZv1Vvb1fn/KM6kRreglN7NOUHdLS6oR5AICf
         rI3lFD9IiURNQsMCdd9rJAmi3Tp4gBD0dBwJ0gHaO+6UU3M7Oyncslxz58O7tPGtST4l
         Q1wQ==
X-Gm-Message-State: AOAM531aQFtzN/mgDQJr/GSMAMaAF8VzYyXV6yLk8uNn+EHRdspPKmJ1
        sjMsFxJZfkAQwKVeYCMC9w7mK+5y+PU=
X-Google-Smtp-Source: ABdhPJz0KFd8PFj7ISxVnahSjAqzpG/yEEGAA+s8rQrVLBPtPMBk1Qd8+2n+oTQzAUVhmpVWRvPzwQ==
X-Received: by 2002:a63:af06:0:b0:378:3582:a49f with SMTP id w6-20020a63af06000000b003783582a49fmr23650458pge.125.1646271897466;
        Wed, 02 Mar 2022 17:44:57 -0800 (PST)
Received: from [10.100.0.6] ([194.5.48.183])
        by smtp.gmail.com with ESMTPSA id o17-20020a056a0015d100b004e1c11d833fsm453352pfu.90.2022.03.02.17.44.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:44:56 -0800 (PST)
Subject: Re: [PATCH] md: bcache: check the return value of kzalloc() in
 detached_dev_do_request()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20220225082048.19524-1-baijiaju1990@gmail.com>
 <f9a07f10-9d9d-de94-64b9-acf722cea8cd@suse.de>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <35f6f57d-5253-bd49-34ba-be919f3a36d9@gmail.com>
Date:   Thu, 3 Mar 2022 09:44:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f9a07f10-9d9d-de94-64b9-acf722cea8cd@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 2022/3/2 18:11, Coly Li wrote:
> On 2/25/22 4:20 PM, Jia-Ju Bai wrote:
>> The function kzalloc() in detached_dev_do_request() can fail, so its
>> return value should be checked.
>>
>> Fixes: bc082a55d25c (bcache: fix inaccurate io state for detached 
>> bcache devices)
>> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/md/bcache/request.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index d15aae6c51c1..1b5ccfa93b8c 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -1107,6 +1107,8 @@ static void detached_dev_do_request(struct 
>> bcache_device *d, struct bio *bio,
>>        * which would call closure_get(&dc->disk.cl)
>>        */
>>       ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
>
> Yes this is a potential problem, may result NULL pointer deference.
>
>
>> +    if (!ddip)
>> +        return;
>
> The fix here is incorrect. A proper way to fix might be something like 
> this,
>
>     if (!ddip) {
>
>         bio->bi_status = BLK_STS_RESOURCE;
>
>         bio->bi_end_io(bio);
>
>         return;
>
>     }
>
>
> The orignal patch will make I/O task be in sleep forever.
>
>>       ddip->d = d;
>>       /* Count on the bcache device */
>>       ddip->orig_bdev = orig_bdev;
>

Hi Coly,

Thanks for the advice!
I will send a V2 patch.


Best wishes,
Jia-Ju Bai

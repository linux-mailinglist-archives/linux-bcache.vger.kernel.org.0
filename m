Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11054536944
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 02:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244102AbiE1AAf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 20:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiE1AAf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 20:00:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E9FF137C
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 17:00:33 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso5658664pjb.3
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 17:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a1MsHWRtqv4pb08/jqHeIuyx7ylNcBjCYFYxSe1BUtg=;
        b=JAiJeyUUfP5cJ/dZ+inOXmOvPiRn49BlEGGRtcJWjZvkxZRkN8cEVX8D1oIrQfiH1M
         lIAYB/VH6mbCYcGUp5W6E+uTknkS/drZLwzVV4TQAhUYvdWiCs93cQdGizvhET1ue6eL
         gbN2iMoemPMAKjmbLZhqudaWUTC6FFHxPmtDS4UGXaHxayMwrznTDJcTTLY4sGWrblvQ
         SwHiIcvuQqVhMqyOAmnQCCWBh9hqfxa/9aM4hC++qCh7aUtDbUEUqlk31RhB8GJompzl
         W5ZMt3TbR+nZt+26mljKAQHOSZ5/dCqqQdWf7FrY0wgPw6WUwJejWP650wgwe9HVQX+t
         xz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a1MsHWRtqv4pb08/jqHeIuyx7ylNcBjCYFYxSe1BUtg=;
        b=g3jGg0gnRnzRdvm7uh//2aMb7f7z6WTkYy7lsoJd+vemXsa95fZTPde0hBc/G+FlgC
         CTaUXqnlWJ0AQ45+AOlm8SovkjlZbzXD5c/ytTyjp3W2wIQuPCTagIDg4IMnPFIrSM4D
         j+ryXirOsO1h0mEFYuDv60R+JU+4ElAwIILns4cwa05uGqy3WgyzpaKUuFij148EHwdQ
         boa2FSfbert+tt1fxRdrfIe+ZekwYUc+y63MOJftAX8zShPkWS1un7htuFYFr/i5v7ob
         JIQ3qdCqKLukuHbrKnsE2ri52XaM0MzCGqv7TkqujCcz45QR93dgSgg5rMPczPIBHHO/
         Gbsw==
X-Gm-Message-State: AOAM5301nrjnYiX15ZGK4ZZQC1wymiGZJrvioiKmxHxU5pFKC0fLMnnU
        329xONM1PioVQ7sFRuBCk8wtOQ==
X-Google-Smtp-Source: ABdhPJxJqSlAvieCyXh6CZ/xq9vd1V5dUvjkwHdGMdyt6DjumzKQVokFxc3hQS7INiyRKoCUDIW1bg==
X-Received: by 2002:a17:90b:1d8f:b0:1e0:37a5:17e3 with SMTP id pf15-20020a17090b1d8f00b001e037a517e3mr10615432pjb.246.1653696032483;
        Fri, 27 May 2022 17:00:32 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902f64a00b0016196bd15f4sm1541063plg.15.2022.05.27.17.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 17:00:31 -0700 (PDT)
Message-ID: <1a3a151e-a8f9-7f53-f9fc-e7eaea42a462@kernel.dk>
Date:   Fri, 27 May 2022 18:00:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/3] bcache: avoid unnecessary soft lockup in kworker
 update_writeback_rate()
Content-Language: en-US
To:     colyli <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20220527152818.27545-1-colyli@suse.de>
 <20220527152818.27545-3-colyli@suse.de>
 <ebf7c9e4-89cb-59e4-8304-d7f8a28966f3@kernel.dk>
 <8251ee2fab43b59ecd5a6140655eeb47@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8251ee2fab43b59ecd5a6140655eeb47@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/27/22 11:05 AM, colyli wrote:
> ? 2022-05-27 23:49?Jens Axboe ???
>> On 5/27/22 9:28 AM, Coly Li wrote:
>>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>>> index d138a2d73240..c51671abe74e 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -214,6 +214,7 @@ static void update_writeback_rate(struct work_struct *work)
>>>                           struct cached_dev,
>>>                           writeback_rate_update);
>>>      struct cache_set *c = dc->disk.c;
>>> +    bool contention = false;
>>>
>>>      /*
>>>       * should check BCACHE_DEV_RATE_DW_RUNNING before calling
>>> @@ -243,13 +244,41 @@ static void update_writeback_rate(struct work_struct *work)
>>>           * in maximum writeback rate number(s).
>>>           */
>>>          if (!set_at_max_writeback_rate(c, dc)) {
>>> -            down_read(&dc->writeback_lock);
>>> -            __update_writeback_rate(dc);
>>> -            update_gc_after_writeback(c);
>>> -            up_read(&dc->writeback_lock);
>>> +            /*
>>> +             * When contention happens on dc->writeback_lock with
>>> +             * the writeback thread, this kwork may be blocked for
>>> +             * very long time if there are too many dirty data to
>>> +             * writeback, and kerne message will complain a (bogus)
>>> +             * software lockup kernel message. To avoid potential
>>> +             * starving, if down_read_trylock() fails, writeback
>>> +             * rate updating will be skipped for dc->retry_max times
>>> +             * at most while delay this worker a bit longer time.
>>> +             * If dc->retry_max times are tried and the trylock
>>> +             * still fails, then call down_read() to wait for
>>> +             * dc->writeback_lock.
>>> +             */
>>> +            if (!down_read_trylock((&dc->writeback_lock))) {
>>> +                contention = true;
>>> +                dc->retry_nr++;
>>> +                if (dc->retry_nr > dc->retry_max)
>>> +                    down_read(&dc->writeback_lock);
>>> +            }
>>> +
>>> +            if (!contention || dc->retry_nr > dc->retry_max) {
>>> +                __update_writeback_rate(dc);
>>> +                update_gc_after_writeback(c);
>>> +                up_read(&dc->writeback_lock);
>>> +                dc->retry_nr = 0;
>>> +            }
>>>          }
>>>      }
>>
> 
> Hi Jens,
> 
> Thanks for looking into this :-)
> 
>> This is really not very pretty. First of all, why bother with storing a
>> max retry value in there? Doesn't seem like it'd ever be different per
> 
> It is because the probability of the lock contention on
> dc->writeback_lock depends on the I/O speed backing device. From my
> observation during the tests, for fast backing device with larger
> cache device, its writeback thread may work harder to flush more dirty
> data to backing device, the lock contention happens more and longer,
> so the writeback rate update kworker has to wait longer time before
> acquires dc->writeback_lock. So its dc->retry_max should be larger
> then slow backing device.
> 
> Therefore I'd like to have a tunable per-backing-device retry_max. And
> the syses interface will be added when users/customers want it. The
> use case is from SAP HANA users, I have report that they observe the
> soft lockup warning for dc->writeback_lock contention and worry about
> whether data is corrupted (indeed, of course not).

The initial patch has 5 as the default, and there are no sysfs knobs. If
you ever need a sysfs knob, by all means make it a variable and make it
configurable too. But don't do it upfront where the '5' suitabled named
would do the job.

>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index 9ee0005874cd..cbc01372c7a1 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -235,19 +235,27 @@ static void update_writeback_rate(struct
>> work_struct *work)
>>          return;
>>      }
>>
>> -    if (atomic_read(&dc->has_dirty) && dc->writeback_percent) {
>> +    if (atomic_read(&dc->has_dirty) && dc->writeback_percent &&
>> +        !set_at_max_writeback_rate(c, dc)) {
>>          /*
>>           * If the whole cache set is idle, set_at_max_writeback_rate()
>>           * will set writeback rate to a max number. Then it is
>>           * unncessary to update writeback rate for an idle cache set
>>           * in maximum writeback rate number(s).
>>           */
>> -        if (!set_at_max_writeback_rate(c, dc)) {
> 
> The reason I didn't place '!set_at_max_writeback_rate' with other items in
> previous if() was for the above code comment. If I moved it to previous
> if() without other items, I was not comfortable to place the code comments
> neither before or after the if() check. So I used a separated if() check for
> '!set_at_max_writeback_rate'.
> 
> From your change, it seems placing the code comments behind is fine (or
> better), can I understand in this way? I try to learn and follow your way
> to handle such code comments situation.

Just put it higher up if you want, it doesn't really matter, or leave it
where it is.

>>              __update_writeback_rate(dc);
>>              update_gc_after_writeback(c);
>>              up_read(&dc->writeback_lock);
>> -        }
>> +        } while (0);
> 
> Aha, this is cool! I never though of using do{}while(0) and break in
> such a genius way! Sure I will use this, thanks for the hint :-)
> 
> After you reply my defense of dc->retry_max, and the question of code
> comments location, I will update and test the patch again, and
> re-sbumit to you.
> 
> Thanks for your constructive suggestion, especially the do{}while(0)
> part!

I would do something similar to my change and drop the 'dc' addition for
the max retries as it, by definition, can only be one value right now.
For all I know, you'll never need to change it again, and then you're
just wasting memory and making the code harder to read by putting it in
dc instead of just having this define.

-- 
Jens Axboe


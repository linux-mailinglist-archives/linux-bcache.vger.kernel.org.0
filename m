Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9031A4E3672
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Mar 2022 03:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbiCVCKN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Mar 2022 22:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiCVCKN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Mar 2022 22:10:13 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48541A82D
        for <linux-bcache@vger.kernel.org>; Mon, 21 Mar 2022 19:08:41 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s42so17098020pfg.0
        for <linux-bcache@vger.kernel.org>; Mon, 21 Mar 2022 19:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qHp6ZM7QO810u6lxZT1+sX05ciSgzorOAN9oko61nh8=;
        b=F2Mo4FDJPrftF24y9lvJErQl8u/KpfYgFRdhxl/PJAr3RiJZzt3p9woxktpc7V+PXM
         WdyOLuSbs2THlxQ1hqDXPUw71FZj8OuWlYE+HI1nkU+ryosZ8WnUQ2M5YU70BaAkcJgS
         nQ6B8FvkUcvhR/Jh0vxXZkLBWLdAXlTCEE6AXPoVynYqTxm39zpwhfSway8wOWSSjiUj
         xhuQdLXw1F3h6CWT3UeMHzUzbhp+SFsasXo5YiuGfXHrRncB3S4QvFnrRngk8urwTpbk
         GqCWCnLyHcSrrNUa6cdkfPjlNTbWfDG4JfretjQ783z/U04tcfyCdgtEEzckw6oivw5q
         HzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qHp6ZM7QO810u6lxZT1+sX05ciSgzorOAN9oko61nh8=;
        b=o6OG6CYeNz+6CCOzj88dSXWY3Bb2ehGM4vL+G+qCSqtpoPnVoi6XFz94ONw+lZ1vQK
         k4sx2S0k3Yh7eGLt4/qGFbI1aISqTI6J2XngMF27nMi8tn09wnnsJjW40FmD9nFwtKvk
         UZDcvSPpj+aE4qv64DbdA1eJ06/oqbSzzu4vtoUF3tYcogtwncZLOjYiAWNmJLWa3i7Z
         s2puvpn9wC/n7RdPiV5ZtILXf+IVON/5n77mm4cajohIBkys+QHvov4Tq0vbf99TQsJm
         qQh0nXcK3Z2ItOtoKYkSILQ0Mr2zzt1lGO3z1buGbXXb4nlqRgjYI72w2HAKEXaBtbLK
         Ixiw==
X-Gm-Message-State: AOAM5323f5PW1c8ASU1YJrIVaDsXw58PJb4jdwnwcuibezKCY/JWYYnR
        j0HbSVVr67sdiVk82tMFIEc=
X-Google-Smtp-Source: ABdhPJyB6zLaGNox8fJQAyNwg0azhOAYxI/YBe1MWx9+ijDAdJPK2zfG3PTZQiEFYM8rGom8LUqMLA==
X-Received: by 2002:a65:5c48:0:b0:382:2c7:28e9 with SMTP id v8-20020a655c48000000b0038202c728e9mr19801484pgr.472.1647914921242;
        Mon, 21 Mar 2022 19:08:41 -0700 (PDT)
Received: from [172.20.104.92] ([61.16.102.70])
        by smtp.gmail.com with ESMTPSA id o14-20020a056a0015ce00b004fab49cd65csm1200709pfu.205.2022.03.21.19.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 19:08:40 -0700 (PDT)
Message-ID: <5c233851-2c3b-7552-5e6a-2dc467f278aa@gmail.com>
Date:   Tue, 22 Mar 2022 10:08:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH] Bcache: don't return BLK_STS_IOERR during cache detach
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <20220307091409.3273-1-zhangzhen.email@gmail.com>
 <7e4035fa-a7cb-6be5-a143-011e035d8f33@gmail.com>
 <8146b053-deec-ae29-ea49-d8df8f1c0b6e@suse.de>
 <09d98f06-9f3c-91e3-29c6-20ebd92e7571@gmail.com>
 <2f3f8e84-b332-46fa-dc19-5b31212f9d29@suse.de>
From:   Zhang Zhen <zhangzhen.email@gmail.com>
In-Reply-To: <2f3f8e84-b332-46fa-dc19-5b31212f9d29@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 3/14/22 8:57 PM, Coly Li wrote:
> On 3/14/22 8:04 PM, Zhang Zhen wrote:
>>
>>
>> On 3/10/22 5:10 PM, Coly Li wrote:
>>> On 3/10/22 10:50 AM, Zhang Zhen wrote:
>>>> Before this patch, if cache device missing, cached_dev_submit_bio 
>>>> return io err
>>>> to fs during cache detach, randomly lead to xfs do force shutdown.
>>>>
>>>> This patch delay the cache io submit in cached_dev_submit_bio
>>>> and wait for cache set detach finish.
>>>> So if the cache device become missing, bcache detach cache set 
>>>> automatically,
>>>> and the io will sumbit normally.
>>>>
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: 
>>>> IO error on writing btree.
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>>>> "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error 
>>>> on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
>>>> Feb  2 20:59:23  kernel: journal io error
>>>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling 
>>>> caching
>>>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>>>> Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
>>>> stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, 
>>>> keep it alive.
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>>>> "xlog_iodone" at daddr 0x400123e60 len 64 error 12
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) 
>>>> called from line 1298 of file fs/xfs/xfs_log.c. Return address = 
>>>> 00000000c1c8077f
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
>>>> Shutting down filesystem
>>>> Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the 
>>>> filesystem and rectify the problem(s)
>>>>
>>>> Signed-off-by: Zhen Zhang <zhangzhen.email@gmail.com>
>>>> ---
>>>>  drivers/md/bcache/bcache.h  | 5 -----
>>>>  drivers/md/bcache/request.c | 8 ++++----
>>>>  drivers/md/bcache/super.c   | 3 ++-
>>>>  3 files changed, 6 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>>>> index 9ed9c955add7..e5227dd08e3a 100644
>>>> --- a/drivers/md/bcache/bcache.h
>>>> +++ b/drivers/md/bcache/bcache.h
>>>> @@ -928,11 +928,6 @@ static inline void closure_bio_submit(struct 
>>>> cache_set *c,
>>>>                        struct closure *cl)
>>>>  {
>>>>      closure_get(cl);
>>>> -    if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
>>>> -        bio->bi_status = BLK_STS_IOERR;
>>>> -        bio_endio(bio);
>>>> -        return;
>>>> -    }
>>>>      submit_bio_noacct(bio);
>>>>  }
>>>
>>>
>>> Comparing to make bcache device living as it looks like, avoiding 
>>> data corruption or stale is much more critical. Therefore once there 
>>> is critical device failure detected, the following I/O requests must 
>>> be stopped (especially write request) to avoid further data 
>>> corruption. Without the above checking for CACHE_SET_IO_DISABLE, the 
>>> cache has to be attached until there is no I/O. For a busy system it 
>>> should be quite long time. Then users may encounter silent data 
>>> corruption or inconsistency after a long time since hardware failed.
>>>
>>>
>>> Again, with the above change, you may introduce other issue which 
>>> more hard to detect.
>>>
>>>
>>>>  diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>>>> index d15aae6c51c1..36f0ee95b51f 100644
>>>> --- a/drivers/md/bcache/request.c
>>>> +++ b/drivers/md/bcache/request.c
>>>> @@ -13,6 +13,7 @@
>>>>  #include "request.h"
>>>>  #include "writeback.h"
>>>>  +#include <linux/delay.h>
>>>>  #include <linux/module.h>
>>>>  #include <linux/hash.h>
>>>>  #include <linux/random.h>
>>>> @@ -1172,11 +1173,10 @@ void cached_dev_submit_bio(struct bio *bio)
>>>>      unsigned long start_time;
>>>>      int rw = bio_data_dir(bio);
>>>>  -    if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
>>>> &d->c->flags)) ||
>>>> +    while (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
>>>> &d->c->flags)) ||
>>>>               dc->io_disable)) {
>>>> -        bio->bi_status = BLK_STS_IOERR;
>>>> -        bio_endio(bio);
>>>> -        return;
>>>> +        /* wait for detach finish and d->c == NULL. */
>>>> +        msleep(2);
>>>>      }
>>>
>>> This is unacceptible, neither the infinite loop nor the msleep. You 
>>> cannot solve the target issue by an infinite retry, such method will 
>>> introduce more issue from other place.
>>>
>>>
>>>>       if (likely(d->c)) {
>>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>>> index 140f35dc0c45..8d9a5e937bc8 100644
>>>> --- a/drivers/md/bcache/super.c
>>>> +++ b/drivers/md/bcache/super.c
>>>> @@ -661,7 +661,8 @@ int bch_prio_write(struct cache *ca, bool wait)
>>>>          p->csum        = bch_crc64(&p->magic, 
>>>> meta_bucket_bytes(&ca->sb) - 8);
>>>>           bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
>>>> -        BUG_ON(bucket == -1);
>>>> +        if (bucket == -1)
>>>> +            return -1;
>>>
>>> This change is wrong. bucket == -1 indicates the bucket allocator 
>>> doesn't work properly, if it happens something really critical 
>>> happening. This is why BUG_ON is used here.
>>>
>>> With the above change, you will encounter other strange issue sooner 
>>> or later and hard to tell the root cause.
>>>
>>>
>>>> mutex_unlock(&ca->set->bucket_lock);
>>>>          prio_io(ca, bucket, REQ_OP_WRITE, 0);
>>>
>>>
>>> Currently I don't have clear idea on how to avoid the IO error return 
>>> value during cache set detaching for a failed cache device. But it 
>>> cannot be such simple change by the this patch.
>> Hi Coly,
>>
>> Thanks for your review，
>> It seems that this is a difficult problem.
>>
>> Maybe we can try another method.
>> If critical device failure detected, we just set IO_DISABLE flag and 
>> detach cache device. But don't auto recover.
> 
> 
> What do you mean on "auto recover", could you describe it with more 
> details ?
> 
"auto recover" means bcache return io error only during the detach time.
It will submit io to bdev after the detach finished.
> 
>>
>> This will at least not confuse users，some disk is normal and some 
>> disk is error.
>> Let user recover it manually.
> 
> When you see panic, it is from XFS meta data I/O error, which is 
> critical to XFS and trigger its panic. When the I/O error happens for 
> normal file system data blocks, the user space receives I/O error return 
> values that's why you don't see the panic.
> 
Thanks for your reminding.
> In your case, the cache device is always clean, so cache device failure 
> will detach the cache from backing device. It will be better if we can 
> re-read data from backing device if no dirty data on cache, but we need 
> to handle the potential race window between cache-seen-clean and 
> read-from-backing-device, because the cache mode can change on-fly and 
> writing may come at any time. This is not simple and should be careful, 
> but it can be improved.
> 
> 
> Coly Li
> 
> 
> 

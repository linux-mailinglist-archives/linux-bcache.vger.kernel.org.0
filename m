Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500C44D82D0
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Mar 2022 13:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240466AbiCNML3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 14 Mar 2022 08:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbiCNMIN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 14 Mar 2022 08:08:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE72F2CCA2
        for <linux-bcache@vger.kernel.org>; Mon, 14 Mar 2022 05:04:19 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso13707891pjc.0
        for <linux-bcache@vger.kernel.org>; Mon, 14 Mar 2022 05:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RfgG/VPib3idOGTeKEskqhW4QROSHZejwYqdRNUrQTs=;
        b=QgFSC+argm/rnI/MUKQXyoYoorrQB99XNnq6hQGdCjDtkK1iMvYOUWteebjfppYf0D
         /57mnZivL7EwNnC7hnVB6wwgQKp18vCNBjD9FbhIDo/8Si3ZQsHWzzb3bALcCSKLGf6T
         NcfTC87Yh8OrdtEB4P3Ps/DI1S60SsQnM7KZZwtkTisURauDkJ5MV7o/+M2AXPlCTenk
         ESaGpWXQggOjGcntHQM4dPd1JWCi3T+ur3hMTkhWxA7rsTeZAd8N9AVa7YmfIXR3C+p1
         OrryKNSu0Fq+7hEZN59UY4gguxbHQ0EAs7tObtsSkY3XP4VjaODP3SjPAEqdr7qJBcGX
         815g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RfgG/VPib3idOGTeKEskqhW4QROSHZejwYqdRNUrQTs=;
        b=FNrEC3FO1ZrCrxiCk+4dzgfr/27/P2DuNFes/wa/QqOwYCVGn5zfPvdmz82RGh12xw
         i3ZAw4P2I3pItBwet4hqVxD5WWsHJEGInDC3KfHc2t5ulrCwjIxNbGE2lQHgmCbByrue
         alqX3F3qqHAplHKwtPAf97zDQ/0Nxz8popmjwKfacO8eLfqPPVX3d5RHSWO5+H52DkSE
         UvdIubaeoJjlO+naOWfsrzXJE+8lN4MWjopce9qvx2XMmxMixs526Ko4LYBmgm6U0ntQ
         93m5SJtr2v9NR9y761KJRMRg9iuqjx5UYHcOzDnGuWkq/6Cf/UX3B4xy0/dRVsTe8Fa6
         EQ8w==
X-Gm-Message-State: AOAM533VX3osWAByTtY3LpIcYhLhh+fE4p5NBW5ukfGWzHKQt5I6jzra
        UAA+MYJlj7TZnC/j7jQSnUadKCDyU9nhnAFK
X-Google-Smtp-Source: ABdhPJyJb9ORbDTL+QojEhVCKFsYl8ubFTJ4y1e0zXDJIvsy6P1RmzOFtb352oAvH07gAjooKEJUDA==
X-Received: by 2002:a17:903:124f:b0:153:4a27:47f5 with SMTP id u15-20020a170903124f00b001534a2747f5mr10201626plh.169.1647259458965;
        Mon, 14 Mar 2022 05:04:18 -0700 (PDT)
Received: from [172.20.104.4] ([61.16.102.69])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a0024cb00b004f725ecf900sm20915234pfv.97.2022.03.14.05.04.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 05:04:18 -0700 (PDT)
Message-ID: <09d98f06-9f3c-91e3-29c6-20ebd92e7571@gmail.com>
Date:   Mon, 14 Mar 2022 20:04:15 +0800
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
From:   Zhang Zhen <zhangzhen.email@gmail.com>
In-Reply-To: <8146b053-deec-ae29-ea49-d8df8f1c0b6e@suse.de>
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



On 3/10/22 5:10 PM, Coly Li wrote:
> On 3/10/22 10:50 AM, Zhang Zhen wrote:
>> Before this patch, if cache device missing, cached_dev_submit_bio 
>> return io err
>> to fs during cache detach, randomly lead to xfs do force shutdown.
>>
>> This patch delay the cache io submit in cached_dev_submit_bio
>> and wait for cache set detach finish.
>> So if the cache device become missing, bcache detach cache set 
>> automatically,
>> and the io will sumbit normally.
>>
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
>> error on writing btree.
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>> "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error 
>> on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
>> Feb  2 20:59:23  kernel: journal io error
>> Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling 
>> caching
>> Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
>> Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
>> stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, 
>> keep it alive.
>> Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
>> "xlog_iodone" at daddr 0x400123e60 len 64 error 12
>> Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) 
>> called from line 1298 of file fs/xfs/xfs_log.c. Return address = 
>> 00000000c1c8077f
>> Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
>> Shutting down filesystem
>> Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the filesystem 
>> and rectify the problem(s)
>>
>> Signed-off-by: Zhen Zhang <zhangzhen.email@gmail.com>
>> ---
>>  drivers/md/bcache/bcache.h  | 5 -----
>>  drivers/md/bcache/request.c | 8 ++++----
>>  drivers/md/bcache/super.c   | 3 ++-
>>  3 files changed, 6 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 9ed9c955add7..e5227dd08e3a 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h
>> @@ -928,11 +928,6 @@ static inline void closure_bio_submit(struct 
>> cache_set *c,
>>                        struct closure *cl)
>>  {
>>      closure_get(cl);
>> -    if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
>> -        bio->bi_status = BLK_STS_IOERR;
>> -        bio_endio(bio);
>> -        return;
>> -    }
>>      submit_bio_noacct(bio);
>>  }
> 
> 
> Comparing to make bcache device living as it looks like, avoiding data 
> corruption or stale is much more critical. Therefore once there is 
> critical device failure detected, the following I/O requests must be 
> stopped (especially write request) to avoid further data corruption. 
> Without the above checking for CACHE_SET_IO_DISABLE, the cache has to be 
> attached until there is no I/O. For a busy system it should be quite 
> long time. Then users may encounter silent data corruption or 
> inconsistency after a long time since hardware failed.
> 
> 
> Again, with the above change, you may introduce other issue which more 
> hard to detect.
> 
> 
>>  diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index d15aae6c51c1..36f0ee95b51f 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -13,6 +13,7 @@
>>  #include "request.h"
>>  #include "writeback.h"
>>  +#include <linux/delay.h>
>>  #include <linux/module.h>
>>  #include <linux/hash.h>
>>  #include <linux/random.h>
>> @@ -1172,11 +1173,10 @@ void cached_dev_submit_bio(struct bio *bio)
>>      unsigned long start_time;
>>      int rw = bio_data_dir(bio);
>>  -    if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
>> &d->c->flags)) ||
>> +    while (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, 
>> &d->c->flags)) ||
>>               dc->io_disable)) {
>> -        bio->bi_status = BLK_STS_IOERR;
>> -        bio_endio(bio);
>> -        return;
>> +        /* wait for detach finish and d->c == NULL. */
>> +        msleep(2);
>>      }
> 
> This is unacceptible, neither the infinite loop nor the msleep. You 
> cannot solve the target issue by an infinite retry, such method will 
> introduce more issue from other place.
> 
> 
>>       if (likely(d->c)) {
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 140f35dc0c45..8d9a5e937bc8 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -661,7 +661,8 @@ int bch_prio_write(struct cache *ca, bool wait)
>>          p->csum        = bch_crc64(&p->magic, 
>> meta_bucket_bytes(&ca->sb) - 8);
>>           bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
>> -        BUG_ON(bucket == -1);
>> +        if (bucket == -1)
>> +            return -1;
> 
> This change is wrong. bucket == -1 indicates the bucket allocator 
> doesn't work properly, if it happens something really critical 
> happening. This is why BUG_ON is used here.
> 
> With the above change, you will encounter other strange issue sooner or 
> later and hard to tell the root cause.
> 
> 
>> mutex_unlock(&ca->set->bucket_lock);
>>          prio_io(ca, bucket, REQ_OP_WRITE, 0);
> 
> 
> Currently I don't have clear idea on how to avoid the IO error return 
> value during cache set detaching for a failed cache device. But it 
> cannot be such simple change by the this patch.
Hi Coly,

Thanks for your review，
It seems that this is a difficult problem.

Maybe we can try another method.
If critical device failure detected, we just set IO_DISABLE flag and 
detach cache device. But don't auto recover.

This will at least not confuse users，some disk is normal and some disk 
is error.
Let user recover it manually.
> 
> 
> Coly Li
> 

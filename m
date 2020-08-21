Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CCF24CE38
	for <lists+linux-bcache@lfdr.de>; Fri, 21 Aug 2020 08:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgHUGtF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 Aug 2020 02:49:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10250 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726119AbgHUGtD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 Aug 2020 02:49:03 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3BAEB2361A4606B1535F;
        Fri, 21 Aug 2020 14:48:58 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.253) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 21 Aug 2020
 14:48:56 +0800
Subject: Re: [PATCH 1/1] block: move the PAGE_SECTORS definition into
 <linux/blkdev.h>
To:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        dm-devel <dm-devel@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bcache <linux-bcache@vger.kernel.org>
References: <20200821020345.3358-1-thunder.leizhen@huawei.com>
 <b4643e74-aad9-385f-01f2-f8e48ba4dbef@suse.de>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <ad100923-e479-faf0-f749-ac8e4cf87899@huawei.com>
Date:   Fri, 21 Aug 2020 14:48:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <b4643e74-aad9-385f-01f2-f8e48ba4dbef@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.253]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 8/21/2020 12:11 PM, Coly Li wrote:
> On 2020/8/21 10:03, Zhen Lei wrote:
>> There are too many PAGE_SECTORS definitions, and all of them are the
>> same. It looks a bit of a mess. So why not move it into <linux/blkdev.h>,
>> to achieve a basic and unique definition.
>>
>> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> 
> 
> A lazy question about page size > 4KB: currently in bcache code the
> sector size is assumed to be 512 sectors, if kernel page > 4KB, it is
> possible that PAGE_SECTORS in bcache will be a number > 8 ?

Sorry, I don't fully understand your question. I known that the sector size
can be 512 or 4K, and the PAGE_SIZE can be 4K or 64K. So even if sector size
is 4K, isn't it greater than 8 for 64K pages?

I'm not sure if the question you're asking is the one Matthew Wilcox has
answered before:
https://www.spinics.net/lists/raid/msg64345.html

> 
> Thanks.
> 
> Coly Li
> 
> 
>> ---
>>  drivers/block/brd.c           | 1 -
>>  drivers/block/null_blk_main.c | 1 -
>>  drivers/md/bcache/util.h      | 2 --
>>  include/linux/blkdev.h        | 5 +++--
>>  include/linux/device-mapper.h | 1 -
>>  5 files changed, 3 insertions(+), 7 deletions(-)
>>
> 
> [snipped]
> 
>> diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
>> index c029f7443190805..55196e0f37c32c6 100644
>> --- a/drivers/md/bcache/util.h
>> +++ b/drivers/md/bcache/util.h
>> @@ -15,8 +15,6 @@
>>  
>>  #include "closure.h"
>>  
>> -#define PAGE_SECTORS		(PAGE_SIZE / 512)
>> -
>>  struct closure;
>>  
>>  #ifdef CONFIG_BCACHE_DEBUG
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index bb5636cc17b91a7..b068dfc5f2ef0ab 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -949,11 +949,12 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>>   * multiple of 512 bytes. Hence these two constants.
>>   */
>>  #ifndef SECTOR_SHIFT
>> -#define SECTOR_SHIFT 9
>> +#define SECTOR_SHIFT		9
>>  #endif
>>  #ifndef SECTOR_SIZE
>> -#define SECTOR_SIZE (1 << SECTOR_SHIFT)
>> +#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
>>  #endif
>> +#define PAGE_SECTORS		(PAGE_SIZE / SECTOR_SIZE)
>>  
>>  /*
>>   * blk_rq_pos()			: the current sector
> [snipped]
> 
> 


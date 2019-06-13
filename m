Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B264413C
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389120AbfFMQM4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 12:12:56 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44984 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfFMQMy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 12:12:54 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jun 2019 12:12:53 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DBAAD204192;
        Thu, 13 Jun 2019 18:07:18 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YkRU4Nrtfdcc; Thu, 13 Jun 2019 18:07:12 +0200 (CEST)
Received: from [192.168.48.23] (host-45-58-224-183.dyn.295.ca [45.58.224.183])
        by smtp.infotech.no (Postfix) with ESMTPA id 08BC0204163;
        Thu, 13 Jun 2019 18:07:10 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 1/8] block: add a helper function to read nr_setcs
To:     Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com
References: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
 <20190613145955.4813-2-chaitanya.kulkarni@wdc.com>
 <9abfc2b8-4496-db7a-fcbb-b52102a67f8e@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f8ab9587-309b-79a0-e6fc-f6683176f498@interlog.com>
Date:   Thu, 13 Jun 2019 12:07:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <9abfc2b8-4496-db7a-fcbb-b52102a67f8e@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019-06-13 11:31 a.m., Bart Van Assche wrote:
> On 6/13/19 7:59 AM, Chaitanya Kulkarni wrote:
>> This patch introduces helper function to read the number of sectors
>> from struct block_device->bd_part member. For more details Please refer
>> to the comment in the include/linux/genhd.h for part_nr_sects_read().
>>
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>> ---
>>   include/linux/blkdev.h | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 592669bcc536..1ae65107182a 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1475,6 +1475,18 @@ static inline void put_dev_sector(Sector p)
>>       put_page(p.v);
>>   }
>> +/* Helper function to read the bdev->bd_part->nr_sects */
>> +static inline sector_t bdev_nr_sects(struct block_device *bdev)
>> +{
>> +    sector_t nr_sects;
>> +
>> +    rcu_read_lock();
>> +    nr_sects = part_nr_sects_read(bdev->bd_part);
>> +    rcu_read_unlock();
>> +
>> +    return nr_sects;
>> +}
>> +
>>   int kblockd_schedule_work(struct work_struct *work);
>>   int kblockd_schedule_work_on(int cpu, struct work_struct *work);
>>   int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork, 
>> unsigned long delay);
>>
> 
> Please explain what makes you think that part_nr_sects_read() must be protected 
> by an RCU read lock.

Dear reviewer,
Please rephrase the above sentence without the accusative tone.
Specifically, please do not use the phrase "what makes you think"
in this or any other code review. For example: "I believe that..."
is more accurate and less provocative.


Observation: as a Canadian citizen when crossing the US border I
believe contradicting a US border official with the phrase "what
makes you think ..." could lead to a rather bad outcome :-)
Please make review comments with that in mind.

Thanks.

Doug Gilbert

P.S. Do we have any Linux code-of-conduct for reviewers?


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C722CA87F
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Dec 2020 17:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgLAQnL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Dec 2020 11:43:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:52028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbgLAQnK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Dec 2020 11:43:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2CC2AAC2F;
        Tue,  1 Dec 2020 16:42:29 +0000 (UTC)
Subject: Re: [PATCH] bcache: fix panic due to cache_set is null
To:     Yi Li <yilikernel@gmail.com>, Yi Li <yili@winhong.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guo Chao <guochao@winhong.com>
References: <20201130112137.587437-1-yili@winhong.com>
 <CAJfdMYDnDJXFVfEECtQ9-E4F9kfsF035PH+x3kaVn6PPSYCydA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <b838b790-e1e3-d644-2b1c-5de02a10669f@suse.de>
Date:   Wed, 2 Dec 2020 00:42:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAJfdMYDnDJXFVfEECtQ9-E4F9kfsF035PH+x3kaVn6PPSYCydA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/1/20 12:35 PM, Yi Li wrote:
> sorry, This patch will cause deadlock, i will check and redo it.

Can you try latest upstream kernel firstly ? Before spending more time
on the fix.

If I remember correctly, when cancel_writeback_rate_update_dwork() is
not timed out, the cache set memory won't be freed before the
writeback_rate_update worker terminates. It is possible that I miss
something in the code, but I suggest to test with a kernel after v5.3,
and better a v5.8+ kernel.

Coly Li

> 
> On 11/30/20, Yi Li <yili@winhong.com> wrote:
>> bcache_device_detach will release the cache_set after hotunplug cache
>> disk. update_writeback_rate should check validate of cache_set.
>>
>>   IP: [<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
>>   PGD 879620067 PUD 8755d3067 PMD 0
>>   Oops: 0000 [#1] SMP
>>   CPU: 8 PID: 1005702 Comm: kworker/8:0 Tainted: G 4.4.0+10 #1
>>   Hardware name: Intel BIOS SE5C610.86B.01.01.0021.032120170601 03/21/2017
>>   Workqueue: events update_writeback_rate [bcache]
>>   task: ffff8808786f3800 ti: ffff88077082c000 task.ti: ffff88077082c000
>>   RIP: e030:[<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
>>   RSP: e02b:ffff88077082fde0  EFLAGS: 00010202
>>   RAX: 0000000000000018 RBX: ffff8808047f0b08 RCX: 0000000000000000
>>   RDX: 0000000000000001 RSI: ffff88088170dab8 RDI: ffff88088170dab8
>>   RBP: ffff88077082fe18 R08: 000000000000000a R09: 0000000000000000
>>   R10: 0000000000000000 R11: 0000000000017bc8 R12: 0000000000000000
>>   R13: ffff8808047f0000 R14: 0000000000000200 R15: ffff8808047f0b08
>>   FS:  00007f157b6d6700(0000) GS:ffff880881700000(0000)
>> knlGS:0000000000000000
>>   CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>>   CR2: 0000000000000368 CR3: 0000000875c05000 CR4: 0000000000040660
>>   Stack:
>>    0000000000000001 0000000000007ff0 ffff88085ff600c0 ffff880881714e80
>>    ffff880881719500 0000000000000200 ffff8808047f0b08 ffff88077082fe60
>>    ffffffff81088c0c 0000000081714e80 0000000000000000 ffff880881714e80
>>   Call Trace:
>>    [<ffffffff81088c0c>] process_one_work+0x1fc/0x3b0
>>    [<ffffffff81089575>] worker_thread+0x2a5/0x470
>>    [<ffffffff815a2f58>] ? __schedule+0x648/0x870
>>    [<ffffffff810892d0>] ? rescuer_thread+0x300/0x300
>>    [<ffffffff8108e3d5>] kthread+0xd5/0xe0
>>    [<ffffffff8108e300>] ? kthread_stop+0x110/0x110
>>    [<ffffffff815a704f>] ret_from_fork+0x3f/0x70
>>    [<ffffffff8108e300>] ? kthread_stop+0x110/0x110
>>
>> Reported-by: Guo Chao <guochao@winhong.com>
>> Signed-off-by: Guo Chao <guochao@winhong.com>
>> Signed-off-by: Yi Li <yili@winhong.com>
>> ---
>>  drivers/md/bcache/writeback.c | 12 +++++++++++-
>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
>> index 3c74996978da..186c4c6e1607 100644
>> --- a/drivers/md/bcache/writeback.c
>> +++ b/drivers/md/bcache/writeback.c
>> @@ -175,7 +175,15 @@ static void update_writeback_rate(struct work_struct
>> *work)
>>  	struct cached_dev *dc = container_of(to_delayed_work(work),
>>  					     struct cached_dev,
>>  					     writeback_rate_update);
>> -	struct cache_set *c = dc->disk.c;
>> +	struct cache_set *c = NULL;
>> +
>> +	mutex_lock(&bch_register_lock);
>> +	c = dc->disk.c;
>> +
>> +	if (c == NULL) {
>> +		mutex_unlock(&bch_register_lock);
>> +		return;
>> +	}
>>
>>  	/*
>>  	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
>> @@ -194,6 +202,7 @@ static void update_writeback_rate(struct work_struct
>> *work)
>>  		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>>  		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>>  		smp_mb__after_atomic();
>> +		mutex_unlock(&bch_register_lock);
>>  		return;
>>  	}
>>
>> @@ -230,6 +239,7 @@ static void update_writeback_rate(struct work_struct
>> *work)
>>  	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>>  	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>>  	smp_mb__after_atomic();
>> +	mutex_unlock(&bch_register_lock);
>>  }
>>
>>  static unsigned int writeback_delay(struct cached_dev *dc,
>> --
>> 2.25.3
>>
>>
>>
>>


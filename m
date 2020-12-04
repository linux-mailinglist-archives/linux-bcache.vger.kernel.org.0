Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6056C2CE52B
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Dec 2020 02:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgLDBeL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Dec 2020 20:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgLDBeL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Dec 2020 20:34:11 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D5CC061A51;
        Thu,  3 Dec 2020 17:33:30 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x24so2590290pfn.6;
        Thu, 03 Dec 2020 17:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=pwt4Dz/MItuLszDwuCb5KE9JFpoisYTMIMIqFSmKU50=;
        b=O8YHXWSfsGj63o9pG8JukbggA2mhu/41VW++DJE605Bp2fcOI3nWuccT8x7YkRxTFQ
         Dr9A5wyQNf1gyGbyUMJKEOpKLSIKrOqIemjxwxX/4gLmKfX3+ZH+yVSGD1AJpFm+ndrR
         CV3ORGbz0Vd1spyUHR+8BTrLgO1zKor7OD/OVqvuAuRG9yd1rG0bkgBFrl6Hyqsn+xmZ
         0wBQ60exAkOQuhWcsaBUorHodxWxI4Ob7/utmft/dPLNO8K8SmLT4OLdgMyOb/NFPG0O
         Zawr2JzDLw8ZJtSZHB43cUzBfMCP/8sE/IHG6iGLxKNZ5b2U5jF5XEsubS9VvBxL6CSt
         FwyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=pwt4Dz/MItuLszDwuCb5KE9JFpoisYTMIMIqFSmKU50=;
        b=C9xZksVpyTyYnduTv74dLwi/IaMq0skpzYdL197G0IzkKDtrVohde5eI0M6gnELnoY
         8yB+3tRo0vIaeLt1un/IzjUryySdytgbH5XR8x5S1kKOkR6nILyE4zttDWv+i9NmIm/j
         333hGEimjUN2Z6GoiUbnJ43D5dW5Wx/Vrgv18Y1829ICc+/8evAns0D2oEd2yW+7AxVc
         6IVv76faQh+aG7CfP3zoy4KeE5s013KrLRk2cNZKHhJ3ckvysRTGWfcI0bzbCuDQOfzJ
         UydC+k/Igdc9jbas1UhSG6nTLxC8zsKTlo+2vZ453rkWbx186uiHWd6OUde2OAHcEOiQ
         o5tw==
X-Gm-Message-State: AOAM533yvgds9yqnJRG/QO4jNQAydvNOUGa8zJ8ysfNe+d7mXsu54Gfn
        TP4MAlq2msSQYO32Nik4TARZL85n3+XvSD87okLxra7rP9Q=
X-Google-Smtp-Source: ABdhPJwYR39Bbs9tvDjhSuwMmE94aHudLYG6PwdkutGZHioayjqxkYQgub1gNG87uu6DUNa9Nd+1ZqVSZDnqhwclQHs=
X-Received: by 2002:a63:ea48:: with SMTP id l8mr534625pgk.293.1607045610324;
 Thu, 03 Dec 2020 17:33:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:7886:0:0:0:0 with HTTP; Thu, 3 Dec 2020 17:33:29
 -0800 (PST)
In-Reply-To: <d25c094a-fcbc-c4da-3bf5-72549578e653@suse.de>
References: <CAJfdMYDLydAtoxvPGzaQ+K5jLvwAXg6MvpE-OM9sFjZgz_01sQ@mail.gmail.com>
 <20201203094711.3236551-1-yili@winhong.com> <d25c094a-fcbc-c4da-3bf5-72549578e653@suse.de>
From:   Yi Li <yilikernel@gmail.com>
Date:   Fri, 4 Dec 2020 09:33:29 +0800
Message-ID: <CAJfdMYA159asor+HuFRhzyNp-zT7SRo6GmST4ZU7DNGhoQkYOQ@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: fix panic due to cache_set is null
To:     Coly Li <colyli@suse.de>
Cc:     Yi Li <yili@winhong.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo Chao <guochao@winhong.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20, Coly Li <colyli@suse.de> wrote:
> On 12/3/20 5:47 PM, Yi Li wrote:
>> bcache_device_detach will release the cache_set after hotunplug cache
>> disk.
>>
>> Here is how the issue happens.
>> 1) cached_dev_free do cancel_writeback_rate_update_dwork
>>    without bch_register_lock.
>> 2) Wirting the writeback_percent by sysfs with
>>    bch_register_lock will insert a writeback_rate_update work.
>> 3) cached_dev_free with bch_register_lock to do bcache_device_free.
>>    dc->disk.cl will be set NULL
>> 4) update_writeback_rate will crash when access dc->disk.cl
>
> The analysis makes sense, good catch! Thank you for make me understand
> the problem.
>
>
>>
>> Fixes: 80265d8dfd77 ("bcache: acquire bch_register_lock later in
>> cached_dev_free()")
>>
>>   IP: [<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
>>   PGD 879620067 PUD 8755d3067 PMD 0
>>   Oops: 0000 [#1] SMP
>>   CPU: 8 PID: 1005702 Comm: kworker/8:0 Tainted: G 4.4.0+10 #1
>>   Hardware name: Intel BIOS SE5C610.86B.01.01.0021.032120170601
>> 03/21/2017
>>   Workqueue: events update_writeback_rate [bcache]
>>   task: ffff8808786f3800 ti: ffff88077082c000 task.ti: ffff88077082c000
>>   RIP: e030:[<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0
>> [bcache]
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
>> Signed-off-by: Yi Li <yili@winhong.com>
>> ---
>>  drivers/md/bcache/super.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 46a00134a36a..8b341f756ac0 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1334,9 +1334,6 @@ static void cached_dev_free(struct closure *cl)
>>  {
>>  	struct cached_dev *dc = container_of(cl, struct cached_dev, disk.cl);
>>
>> -	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
>> -		cancel_writeback_rate_update_dwork(dc);
>> -
>>  	if (!IS_ERR_OR_NULL(dc->writeback_thread))
>>  		kthread_stop(dc->writeback_thread);
>>  	if (!IS_ERR_OR_NULL(dc->status_update_thread))
>> @@ -1344,6 +1341,9 @@ static void cached_dev_free(struct closure *cl)
>>
>>  	mutex_lock(&bch_register_lock);
>>
>> +	if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
>> +		cancel_writeback_rate_update_dwork(dc);
>> +
>>  	if (atomic_read(&dc->running))
>>  		bd_unlink_disk_holder(dc->bdev, dc->disk.disk);
>>  	bcache_device_free(&dc->disk);
>>
>
> Such change is problematic, the writeback rate kworker mush stopped
> before writeback and status_update thread, otherwise you may encounter
> other problem.
>
enn, It is possible that I miss something.

1: writeback_rate_update work will add to the system_wq by
schedule_delayed_work.

2: The issue 80265d8dfd77 --" After moving
mutex_lock(&bch_register_lock) to a later location where before
atomic_read(&dc->running) in cached_dev_free()" .


> And when I review your patch I find another similar potential problem.
>
> This is tricky, let me think how to fix it ....
>
> Thank you again, for catch such issue.
>
> Coly Li
>
>

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571FF4CE3EB
	for <lists+linux-bcache@lfdr.de>; Sat,  5 Mar 2022 10:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiCEJOC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 5 Mar 2022 04:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiCEJOC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 5 Mar 2022 04:14:02 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554D71AD3B5
        for <linux-bcache@vger.kernel.org>; Sat,  5 Mar 2022 01:13:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 044C321100;
        Sat,  5 Mar 2022 09:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646471591; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8hAIq3u/qnodZoRbFQjrG8xQVuSGMdO8As0aXw9xUM=;
        b=0B+AUJSDrX8RMDfY6nEIutHJvqS1orrrgF0UjT3qt9TlJeO2BnqM1Jq99w0qYU5j97bjJD
        z330s1fX6hyBFv3+M5T4Tod2+EV4Zq7Sa4eMjPNEDpCvlhHVtium18/lzr62VMlRLj/oOj
        YQ7jyspddn9LeCwuxWPzrztdSao3so4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646471591;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8hAIq3u/qnodZoRbFQjrG8xQVuSGMdO8As0aXw9xUM=;
        b=aM2gqKXZpVoo3f89Z3FveMfdOXn+twBMQrbmaee/leuI1jbLs1l5ZlFFgQDqpmvdSmD0v9
        I+BAIfuIVHyFaeDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4EC8613A05;
        Sat,  5 Mar 2022 09:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id me8iB6YpI2J/BQAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 05 Mar 2022 09:13:10 +0000
Message-ID: <0bf15c2d-a309-789f-c722-c1bab20aa8c9@suse.de>
Date:   Sat, 5 Mar 2022 17:13:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: kernel 5.16.11 can't use an existing /dev/bcache0 as backing
 device for /dev/bcache1
Content-Language: en-US
To:     Cedric de Wijs <cedric.dewijs@eclipso.eu>
Cc:     linux-bcache@vger.kernel.org
References: <a719b71b-6ab1-d9c8-b437-8f43ee306767@eclipso.eu>
 <aa879f78-32d9-b814-2b8f-558f3433d667@suse.de>
 <bdfa8a1b-ddc1-990f-f8b8-2541317de4d2@eclipso.eu>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <bdfa8a1b-ddc1-990f-f8b8-2541317de4d2@eclipso.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/5/22 3:54 PM, Cedric de Wijs wrote:
> On 3/4/22 08:45, Coly Li wrote:
>> On 3/3/22 1:23 AM, Cedric de Wijs wrote:
>>> Hi All,
>>>
>>> Summary: the kernel can't use an existing /dev/bcache0 as backing 
>>> device for /dev/bcache1, and throws a lot of errors in /var/log/syslog.
>>>
>>> In detail:
>>> I would like to use a small slow ssd as a write cache for a hard 
>>> drive, and a large, fast SSD as read cache. Therefore I'm trying to 
>>> stack two bcaches on top of each other like this: (Note, I have done 
>>> all tests on one HDD with a lot of partitions, so all devices start 
>>> with /dev/sde)
>>>
>>> +---------------------------------+
>>> | btrfs file system |                                 |
>>> +---------------------------------+
>>> | /dev/Bcache1                    |
>>> +---------------------------------+
>>> | Read cache on fast ssd          |
>>> | /dev/sde3 (5GB)                 |
>>> +---------------------------------+
>>> | /dev/Bcache0                    |
>>> +---------------------------------+
>>> | Write Cache on slow SSD         |
>>> | /dev/sde2 (2GB)                 |
>>> +---------------------------------+
>>> | Data on big spinning hard drive |
>>> | /dev/sde1 (40GB)                |
>>> +---------------------------------+
>>>
>>> I create the stack from bottom to top:
>>> 1) Format the big spinning hard drive as backing device
>>> # make-bcache -B /dev/sde1
>>> Name            /dev/sde1
>>> Label
>>> Type            data
>>> UUID:            a2b424ce-c7dd-4d16-8600-fa4b47306865
>>> Set UUID:        f9698940-513b-4649-9d0e-58216587bd6f
>>> version:        1
>>> block_size_in_sectors:    1
>>> data_offset_in_sectors:    16
>>> # dmesg
>>> [52742.372299] bcache: register_bdev() registered backing device sde1
>>>
>>> 2) Format the slow SSD as cache device
>>> # make-bcache -C /dev/sde2
>>> Name            /dev/sde2
>>> Label
>>> Type            cache
>>> UUID:            58092ee5-2412-4f25-af21-ed8d30fb3f1c
>>> Set UUID:        a5bfbb35-dd42-4593-af63-9af53a5cc3a0
>>> version:        0
>>> nbuckets:        3814
>>> block_size_in_sectors:    1
>>> bucket_size_in_sectors:    1024
>>> nr_in_set:        1
>>> nr_this_dev:        0
>>> first_bucket:        1
>>> # dmesg
>>> [52965.412606] bcache: run_cache_set() invalidating existing data
>>> [52965.438891] bcache: register_cache() registered cache device sde2
>>>
>>> 3) Attach the slow ssd cache (/dev/sde2) to the big spinning hard 
>>> drive (/dev/sde1)
>>> # bcache-super-show /dev/sde2 | grep cset
>>> cset.uuid        a5bfbb35-dd42-4593-af63-9af53a5cc3a0
>>> echo a5bfbb35-dd42-4593-af63-9af53a5cc3a0 > 
>>> /sys/block/bcache0/bcache/attach
>>> # dmesg
>>> Mar  2 17:45:17 cedric kernel: bcache: bch_cached_dev_run() cached 
>>> dev sde1 is running already
>>> Mar  2 17:45:17 cedric kernel: bcache: bch_cached_dev_attach() 
>>> Caching sde1 as bcache0 on set a5bfbb35-dd42-4593-af63-9af53a5cc3a0
>>>
>>> 4) Format /dev/bcache0 as backing device
>>> # make-bcache -B /dev/bcache0
>>> Name            /dev/bcache0
>>> Label
>>> Type            data
>>> UUID:            21cc37f3-9aa7-4eba-b652-8cd6b1f812ae
>>> Set UUID:        2d45c3c2-1efc-43bb-80e0-33859649aba2
>>> version:        1
>>> block_size_in_sectors:    1
>>> data_offset_in_sectors:    16
>>> # tail -F /var/log/everything.log
>>> Mar  2 17:48:47 cedric kernel: sysfs: cannot create duplicate 
>>> filename '/devices/virtual/block/bcache0/bcache'
>>> Mar  2 17:48:47 cedric kernel: CPU: 1 PID: 37431 Comm: kworker/1:4 
>>> Tainted: G           OE     5.16.11-arch1-1 #1 
>>> ded1ca8dd1dd660648f829b67fad213afe36c9c9
>>> Mar  2 17:48:47 cedric kernel: Hardware name: Gigabyte Technology 
>>> Co., Ltd. B550 AORUS PRO AC/B550 AORUS PRO AC, BIOS F12 01/18/2021
>>> Mar  2 17:48:47 cedric kernel: Workqueue: events 
>>> register_bdev_worker [bcache]
>>> Mar  2 17:48:47 cedric kernel: Call Trace:
>>> Mar  2 17:48:47 cedric kernel:  <TASK>
>>> Mar  2 17:48:47 cedric kernel:  dump_stack_lvl+0x48/0x5e
>>> Mar  2 17:48:47 cedric kernel:  sysfs_warn_dup.cold+0x17/0x24
>>> Mar  2 17:48:47 cedric kernel:  sysfs_create_dir_ns+0xc6/0xe0
>>> Mar  2 17:48:47 cedric kernel: kobject_add_internal+0xbd/0x2c0
>>> Mar  2 17:48:47 cedric kernel:  kobject_add+0x98/0xd0
>>> Mar  2 17:48:47 cedric kernel:  ? bcache_device_init+0x242/0x2a0 
>>> [bcache eb8586620a25cfc9a2e260d15875c9beb6c2953d]
>>> Mar  2 17:48:47 cedric kernel: register_bdev_worker+0x30d/0x3b0 
>>> [bcache eb8586620a25cfc9a2e260d15875c9beb6c2953d]
>>> Mar  2 17:48:47 cedric kernel:  process_one_work+0x1e8/0x3c0
>>> Mar  2 17:48:47 cedric kernel:  worker_thread+0x50/0x3b0
>>> Mar  2 17:48:47 cedric kernel:  ? rescuer_thread+0x3a0/0x3a0
>>> Mar  2 17:48:47 cedric kernel:  kthread+0x15c/0x180
>>> Mar  2 17:48:47 cedric kernel:  ? set_kthread_struct+0x40/0x40
>>> Mar  2 17:48:47 cedric kernel:  ret_from_fork+0x22/0x30
>>> Mar  2 17:48:47 cedric kernel:  </TASK>
>>> Mar  2 17:48:47 cedric kernel: kobject_add_internal failed for 
>>> bcache with -EEXIST, don't try to register things with the same name 
>>> in the same directory.
>>> Mar  2 17:48:47 cedric kernel: bcache: register_bdev() error 
>>> bcache0: error creating kobject
>>> Mar  2 17:48:47 cedric kernel: bcache: register_bdev_worker() error 
>>> /dev/bcache0: fail to register backing device
>>> Mar  2 17:48:47 cedric kernel: bcache: bcache_device_free() bcache1 
>>> stopped
>>> # ls -l /dev/bca*
>>> brw-rw---- 1 root disk 254, 0 Mar  2 17:48 /dev/bcache0
>>>
>>> Expected result:
>>> I expected step 4 to create the new bcache device /dev/bcache1.
>>> >That would have enabled me to take these steps:
>>> 5) Format the fast SSD as cache device:
>>> # make-bcache -C /dev/sde3
>>>
>>> 6) Attach the fast ssd cache /dev/sde3 to /dev/bcache1 created in 
>>> step 4
>>> # bcache-super-show /dev/sde3 | grep cset
>>> cset.uuid        957377e0-ae6f-45fb-9ad8-9ff7ca83a861
>>> # echo 957377e0-ae6f-45fb-9ad8-9ff7ca83a861 > 
>>> /sys/block/bcache1/bcache/attach
>>>
>>> 7) Finally use /dev/bcache1 as device for the btrfs filesystem:
>>> # mkfs.btrfs /dev/bcache1
>>>
>>> My Kernel:
>>> # uname -a
>>> Linux cedric 5.16.11-arch1-1 #1 SMP PREEMPT Thu, 24 Feb 2022 
>>> 02:18:20 +0000 x86_64 GNU/Linux
>>>
>>> How can I help to debug this?
>>> Is linux-bcache the best place to report this problem?
>>> Is there a workaround for this problem?
>>
>> It seems you are trying to stack a bcache device on top of another 
>> bcache device. This is unsupported operation.
>>
>>
>> Coly Li
>
> Thank you for your reply.
>
> English is nog my first language, so I would like to get some more 
> clarification.
>
> 1) Is stacking bcaches on op of each other unsupported for now, and is 
> it considered a technical problem that needs to be solved?
>
> 2) If I manage to somehow make the code work with stacked bcaches, 
> will this code be accepted in the kernel?


Bcache is designed that a cache set or a backing device cannot be 
stacked by itself. Otherwise some internal data structure will be 
conflicted, e.g. sysfs device model related ones.


>
> 3) Is there another solution for my problem? I try to create a system 
> that can do this:
> - Mechanical hard drives are used for storage of data
> - Mechanical drives must stay idle as much as possible
> - SSD's or memory sticks are used to cache written data
> - A fast SSD is used to cache read data
> - The system has enough redundancy that 1 drive failing does not cause 
> data loss (<- This is the reason why I want one ssd/memory stick per 
> mechanical drive)
> - The system can see and correct bitrot. (-< This is why i use btrfs 
> as the file system. This is also the reason why I cannot use classic 
> RAID, as this can't see/correct bitrot / silent corruption
>
> This is the final system I would like to build:
>
> +--------------------------------------------+
> | btrfs file system                          |
> +--------------------------------------------+
> | /dev/Bcache1 | /dev/Bcache3 | /dev/Bcache5 |
> +--------------------------------------------+
> | Read cache                                 |
> | fast SSD                                   |
> | /dev/sde3                                  |
> +--------------------------------------------+
> | /dev/Bcache0 | /dev/Bcache0 | /dev/Bcache0 |
> +--------------+--------------+--------------+
> | Write Cache  | Write Cache  | Write Cache  |
> | slow SSD     | slow SSD     | slow SSD     |
> | /dev/sde2    | /dev/sde6    | /dev/sde7    |
> +--------------+--------------+--------------+
> | hard drive   | hard drive   | hard drive   |
> | /dev/sde1    | /dev/sde4    | /dev/sde5    |
> +--------------+--------------+--------------+


Bcache does not support to separately store write and read cache on 
different device, and keeping data consistency between the two caches 
while keeping high performance and low latency, this is very hard.

It might be improved or support via file system layer, for block layer 
cache it is not easy. I am not very familiar with bcachefs, but I guess 
maybe it might be a worthy file system to look into.


Coly Li


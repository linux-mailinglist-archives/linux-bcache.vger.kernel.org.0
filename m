Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D91583FB7
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jul 2022 15:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiG1NO1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jul 2022 09:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236620AbiG1NO0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jul 2022 09:14:26 -0400
Received: from schatzi.steelbluetech.co.uk (james.steelbluetech.co.uk [92.63.139.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BD32CC8B
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jul 2022 06:14:23 -0700 (PDT)
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
        by schatzi.steelbluetech.co.uk (Postfix) with ESMTP id 2A35ABFC40;
        Thu, 28 Jul 2022 14:14:21 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 schatzi.steelbluetech.co.uk 2A35ABFC40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1659014061; bh=vwOVimT77LQg2afib36mPETDtCymBcDiUrB0vgyVRvM=;
        h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nvOxQYr6pRd5U4r1ncDDYh/LqxZkMz2Y7FjvLPLkiQVmsRABR7kTMtcHGvurkU1fI
         xRvhbpIxB9CjyqCFU/MYUwZjP4PmAnIgLRZkLFasvv5QJY2z1bVTCSJqryxwqbdf4k
         d2EyscMZZPKMBU2PcaSxcEFvTou/PQdbtxuKvBCw=
Message-ID: <b86affce-acc4-f23c-dc96-b92567b2f26b@ehuk.net>
Date:   Thu, 28 Jul 2022 14:14:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eddie@ehuk.net
Subject: Re: Some persistently stuck cache devices after backing device
 failures
Content-Language: en-GB
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <b968c31a-aeeb-28fd-78ef-d38344d4ecc1@ehuk.net>
 <B282B4DF-D42C-49BD-9D59-0D2140A210CE@suse.de>
From:   Eddie Chapman <eddie@ehuk.net>
In-Reply-To: <B282B4DF-D42C-49BD-9D59-0D2140A210CE@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 28/07/2022 13:37, Coly Li wrote:
> 
> 
>> 2022年7月22日 00:18，Eddie Chapman <eddie@ehuk.net> 写道：
>>
>> Hello,
>>
>> I've been using bcache for several years and have learned how to resolve various problems. However now I have a situation on a live server where I've tried everything but looks like I might have to reboot the kernel to resolve it. This will be a big pain for this server so thought I'd check here if anyone knows something else I could try.
>>
>> Let me try and describe the situation:
>>
>> - system is running vanilla stable kernel 5.10.107 for 100+ days
>> - There's a single nvme device with 15 partitions
>> - Each nvme partition is a bcache cache device in writeback mode, attached to a backing device of course (there are various types of backing devices)
>> - Now a SATA controller has completely failed and taken out 3 spinning SATA disks, leading to several backing devices but not all failing.
>> - The nvme device is fine and still acting as cache for some remaining, working backing devices which have nothing to do with the failed disks.
>> - The bcache backing devices that failed and their corresponding caches were in a mixed state immediately after the disks failed, some gone, some not.
>> - I don't care about any of the failed data, I just want to clean up the mess and re-use the nvme partitions that had backing device failures with some other working spinning disks on the system.
>> - So, I've been able to unregister, free, wipe and re-use MOST of the cache devices that had failed backing devices.
>> - Of the cache devices I unregistered I've been able to clean up completely their failed backing devices (both the bcacheN device and failed backing device is completely gone from /sys/block).
>> - However, there are 3 cache devices, with failed backing devices, which completely refuse to either stop or unregister. I have written 1 many times to the "stop" and "unregister" files but nothing changes and nothing is logged in the kernel log.
>> - There has not been any crash or warning emitted by bcache in the kernel log, just the normal messages you would expect to see when backing devices fail.
>>
>> For each of these 3 "stuck" cache devices:
>>
>>   - The cache directory still exists in /sys/fs/bcache/
>>   - Inside the cache directory there is no bdev0 symlink anymore. There *is* the cache0 symlink pointing to the nvme partition.
>>   - The corresponding /sys/block/bcacheN directory does still exist.
>>   - There is nothing in the /sys/block/bcacheN/holders/ directory. Above the bcache device was LVM devices but I was able to successfully remove all of them with dmsetup remove. There is definitely nothing above still holding the bcacheN device still open.
>>   - The failed backing device, which is an md raid0, still exists on the system, but it is not possible to stop it with mdadm, it is also "stuck" (I've tried to normally "fail" and "remove" it as well as using mdadm's special "failed" and "detached" keywords). It still shows up in /proc/mdstat. The raid members are the SATA disks which have now disappeared. mdadm -D says the array is in a state "broken, FAILED" and it's disks are all "missing".
>>   - Inside the /sys/block/mdN/ directory there is NO "bcache" subdirectory
>>   - Inside the /sys/block/mdN/holders/ directory there is still a working "bcacheN" symlink to /sys/block/bcacheN
>>   - Inside the /sys/block/bcacheN directory there is a broken "bcache" symlink pointing to the now disappeared /sys/block/mdN/bcache
>>
>>
>> As I said, I don't care about any of the failed data, I only care about freeing the nvme cache devices. But I have 2 problems:
>>
>> 1. Something in the kernel is constantly reading hundreds of Mbytes/s of data from the 3 "stuck" nvme partitions (but not writing anything, at least not at any significant rate). I can see it using atop. I'm wondering if bcache is stuck in a loop trying to read something from them and that is why it will not let go of these remaining 3 nvme partitions. I believe this is affecting performance of the nvme device as a whole for the other working bcache devices using it. load average is quite high continually as a result.
>>
>> 2. I cannot re-use these 3 nvme partitions while they are "stuck", though this is less of a problem that 1.
>>
>> I'm hoping there might be a simple way to force bcache to "let go" of these 3 cache devices without rebooting? I don't care if the leftover stuff of the md backing devices doesn't go away, it is not doing any harm that I can tell, just that I can successfully unregister the cache devices. Or at least stop bcache from constantly reading the hundreds of Mbyte/s, I could live with just that.
>>
>> I see there is an "io_disable" file in the "internal" subdirectory. What does that do? Maybe it is the solution but I dare not try it as I don't know what it does and don't want to risk crashing the kernel.
>>
> 
> The io_disable option might be helpful but I don’t recommend. Setting it to 1 will directly reject all external and internal I/Os inside bcache driver, most of time it just triggers errors and forces the cache or backing device to stop, but sometimes if the I/O error is unrecoverable in critical I/O path it may trigger kernel panic in upper layer code.
> 
> BTW, does it help a bit if you write 1 to /sys/fs/bcache/pendings_cleanup?
> 
> Coly Li
> 
 >

Hi Coly,

Really appreciate you looking at this. The server is still running in 
this state and I'm still hoping I can free these cache devices somehow.

I should have mentioned in my original email that when I was originally 
searching for solutions I cam across the original mailing list posting 
for your patch that added /sys/fs/bcache/pendings_cleanup and thought 
"yes, that sounds like it will do it!". But tried it and unfortunately 
nothing happened.

Thanks for confirming that io_disable is to risky, I'm glad I followed 
my instinct to not try that :-)

One interesting thing to add is that every 2 or 3 days bcache logs about 
50 or so lines of exactly the same:

bcache: bch_count_backing_io_errors() mdX: IO error on backing device, 
unrecoverable

With mdX being one of the failed md raid0 backing devices, it can be any 
of the 3 devices but then all the lines logged are for just that one 
device (i.e. not a mix of the 3 devices).

It's interesting that it happens sporadically every few days and then 
bcache goes completely quiet again. Made me wonder if perhaps the cache 
device is still stuck trying to write old data to the backing devices 
over and over and every now and then some very long timeout kicks in or 
something for just a subset of IOs and then it moves onto another subset.

So made me wonder maybe there is some configurable timeout setting 
somewhere in the cache dev settings that I can reduce. Which would then 
result in bcache giving up and letting go of these devices sooner. e.g 
in some days instead of months or years?

If there is any further info I can pull from the system that might be 
useful please let me know. Ultimately if there's nothing I can do I'll 
just have to bite the bullet and arrange a reboot.

Many thanks,
Eddie

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBEF5843FF
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jul 2022 18:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiG1QPp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jul 2022 12:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiG1QPj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jul 2022 12:15:39 -0400
Received: from schatzi.steelbluetech.co.uk (james.steelbluetech.co.uk [92.63.139.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038471149
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jul 2022 09:15:34 -0700 (PDT)
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
        by schatzi.steelbluetech.co.uk (Postfix) with ESMTP id E58C4BFC35;
        Thu, 28 Jul 2022 17:15:31 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 schatzi.steelbluetech.co.uk E58C4BFC35
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1659024932; bh=QCAKyVIx7SfnSs39t9leCCT+cmPCEEE/14ALM1t8BWY=;
        h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nVfFSq4mXRKfG61BVhBIL/uTQb70DypYvRoRCoBdcSAlX8iEHtVQZg6QhP3quJUEI
         qoKnJKhQE9xXk3lafBZ5K57gOLx9XBLTW8StLol/5V0fMZkTRMThN0lKeOsYvRHd2+
         S4h6b0fVX9v1ouEESPEZdTia/o34KVo7nvferHe4=
Message-ID: <55edf995-8ed3-1db8-af05-2f3a9e57c2d0@ehuk.net>
Date:   Thu, 28 Jul 2022 17:15:31 +0100
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
 <b86affce-acc4-f23c-dc96-b92567b2f26b@ehuk.net>
 <8820069C-5E97-402A-BFC1-05FF9A5608B0@suse.de>
From:   Eddie Chapman <eddie@ehuk.net>
In-Reply-To: <8820069C-5E97-402A-BFC1-05FF9A5608B0@suse.de>
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

On 28/07/2022 16:40, Coly Li wrote:
> 
> 
>> 2022年7月28日 21:14，Eddie Chapman <eddie@ehuk.net> 写道：
>>
>> On 28/07/2022 13:37, Coly Li wrote:
>>>> 2022年7月22日 00:18，Eddie Chapman <eddie@ehuk.net> 写道：
>>>>
>>>> Hello,
>>>>
>>>> I've been using bcache for several years and have learned how to resolve various problems. However now I have a situation on a live server where I've tried everything but looks like I might have to reboot the kernel to resolve it. This will be a big pain for this server so thought I'd check here if anyone knows something else I could try.
>>>>
>>>> Let me try and describe the situation:
>>>>
>>>> - system is running vanilla stable kernel 5.10.107 for 100+ days
>>>> - There's a single nvme device with 15 partitions
>>>> - Each nvme partition is a bcache cache device in writeback mode, attached to a backing device of course (there are various types of backing devices)
>>>> - Now a SATA controller has completely failed and taken out 3 spinning SATA disks, leading to several backing devices but not all failing.
>>>> - The nvme device is fine and still acting as cache for some remaining, working backing devices which have nothing to do with the failed disks.
>>>> - The bcache backing devices that failed and their corresponding caches were in a mixed state immediately after the disks failed, some gone, some not.
>>>> - I don't care about any of the failed data, I just want to clean up the mess and re-use the nvme partitions that had backing device failures with some other working spinning disks on the system.
>>>> - So, I've been able to unregister, free, wipe and re-use MOST of the cache devices that had failed backing devices.
>>>> - Of the cache devices I unregistered I've been able to clean up completely their failed backing devices (both the bcacheN device and failed backing device is completely gone from /sys/block).
>>>> - However, there are 3 cache devices, with failed backing devices, which completely refuse to either stop or unregister. I have written 1 many times to the "stop" and "unregister" files but nothing changes and nothing is logged in the kernel log.
>>>> - There has not been any crash or warning emitted by bcache in the kernel log, just the normal messages you would expect to see when backing devices fail.
>>>>
>>>> For each of these 3 "stuck" cache devices:
>>>>
>>>>   - The cache directory still exists in /sys/fs/bcache/
>>>>   - Inside the cache directory there is no bdev0 symlink anymore. There *is* the cache0 symlink pointing to the nvme partition.
>>>>   - The corresponding /sys/block/bcacheN directory does still exist.
>>>>   - There is nothing in the /sys/block/bcacheN/holders/ directory. Above the bcache device was LVM devices but I was able to successfully remove all of them with dmsetup remove. There is definitely nothing above still holding the bcacheN device still open.
>>>>   - The failed backing device, which is an md raid0, still exists on the system, but it is not possible to stop it with mdadm, it is also "stuck" (I've tried to normally "fail" and "remove" it as well as using mdadm's special "failed" and "detached" keywords). It still shows up in /proc/mdstat. The raid members are the SATA disks which have now disappeared. mdadm -D says the array is in a state "broken, FAILED" and it's disks are all "missing".
>>>>   - Inside the /sys/block/mdN/ directory there is NO "bcache" subdirectory
>>>>   - Inside the /sys/block/mdN/holders/ directory there is still a working "bcacheN" symlink to /sys/block/bcacheN
>>>>   - Inside the /sys/block/bcacheN directory there is a broken "bcache" symlink pointing to the now disappeared /sys/block/mdN/bcache
>>>>
>>>>
>>>> As I said, I don't care about any of the failed data, I only care about freeing the nvme cache devices. But I have 2 problems:
>>>>
>>>> 1. Something in the kernel is constantly reading hundreds of Mbytes/s of data from the 3 "stuck" nvme partitions (but not writing anything, at least not at any significant rate). I can see it using atop. I'm wondering if bcache is stuck in a loop trying to read something from them and that is why it will not let go of these remaining 3 nvme partitions. I believe this is affecting performance of the nvme device as a whole for the other working bcache devices using it. load average is quite high continually as a result.
>>>>
>>>> 2. I cannot re-use these 3 nvme partitions while they are "stuck", though this is less of a problem that 1.
>>>>
>>>> I'm hoping there might be a simple way to force bcache to "let go" of these 3 cache devices without rebooting? I don't care if the leftover stuff of the md backing devices doesn't go away, it is not doing any harm that I can tell, just that I can successfully unregister the cache devices. Or at least stop bcache from constantly reading the hundreds of Mbyte/s, I could live with just that.
>>>>
>>>> I see there is an "io_disable" file in the "internal" subdirectory. What does that do? Maybe it is the solution but I dare not try it as I don't know what it does and don't want to risk crashing the kernel.
>>>>
>>> The io_disable option might be helpful but I don’t recommend. Setting it to 1 will directly reject all external and internal I/Os inside bcache driver, most of time it just triggers errors and forces the cache or backing device to stop, but sometimes if the I/O error is unrecoverable in critical I/O path it may trigger kernel panic in upper layer code.
>>> BTW, does it help a bit if you write 1 to /sys/fs/bcache/pendings_cleanup?
>>> Coly Li
>>>
>>
>> Hi Coly,
>>
>> Really appreciate you looking at this. The server is still running in this state and I'm still hoping I can free these cache devices somehow.
>>
>> I should have mentioned in my original email that when I was originally searching for solutions I cam across the original mailing list posting for your patch that added /sys/fs/bcache/pendings_cleanup and thought "yes, that sounds like it will do it!". But tried it and unfortunately nothing happened.
> 
> Copied. Then there is no luck for this...
> 
> 
>>
>> Thanks for confirming that io_disable is to risky, I'm glad I followed my instinct to not try that :-)
>>
>> One interesting thing to add is that every 2 or 3 days bcache logs about 50 or so lines of exactly the same:
>>
>> bcache: bch_count_backing_io_errors() mdX: IO error on backing device, unrecoverable
> 
> This is exact the IO error returned from backing device. Since it is a md raid0, one of the component disks might be failing soon.

This is why this situation is puzzling; the bcache device has completely 
gone (the /sys/block/bcacheN gone). The backing device itself still 
exists but is a "brain dead" non-functioning md device with no members, 
it has no /sys/block/mdN/bcache directory. The only thing left is the 
cache device which refuses to stop or unregister and is still somehow 
"stuck" to the backing device even though bcache has "let go" of the 
failed backing device.

There surely must be a bug here somewhere, because the cache device 
should not be still holding onto a device which bcache has already 
"ejected" from itself when it failed.
>> With mdX being one of the failed md raid0 backing devices, it can be any of the 3 devices but then all the lines logged are for just that one device (i.e. not a mix of the 3 devices).
>>
>> It's interesting that it happens sporadically every few days and then bcache goes completely quiet again. Made me wonder if perhaps the cache device is still stuck trying to write old data to the backing devices over and over and every now and then some very long timeout kicks in or something for just a subset of IOs and then it moves onto another subset.
>>
> 
> It is possible, that bcache was trying to writeback while encounter the error location on backing device and try it in next run. In bcache code, if the I/O errors don’t happen frequently in a period, then it may continue to work. If there are too many I/O errors from backing device then the bcache device will stop (io_disable set within the bcache code) and disappear.

Yes, this has already happened when the backing device completely failed 
about 2 weeks ago.

Note, I don't care about any of the data here, neither on the cache 
device or backing device. The problem is that bcache won't let go of the 
nvme cache device when it should do, and worse it is constantly reading 
many hundreds of Mbyte/s from the nvme device partition it is hanging 
onto, affecting its performance.

>> So made me wonder maybe there is some configurable timeout setting somewhere in the cache dev settings that I can reduce. Which would then result in bcache giving up and letting go of these devices sooner. e.g in some days instead of months or years?
> 
> In the backing device sysfs directory, you may find a file named io_errors, which counts the I/O errors of this backing device. And you may find another file io_error_limit, this is the threshold which stops the bcache device when I/O error reaches the threshold. The default io_error_limit is 64 if I remember correctly, you can modify it to a much smaller number to trigger backing device failure earlier.

The /sys/block/mdN/bcache directory is gone so those files are gone 
unfortunately. The /sys/block/mdN directory is still there, the md 
device still exists but in a "brain dead" state.

> For cache device, there are io_errors_halftime and io_error_limit files as well. You may also modify io_error_limit to a smaller value to trigger cache failure earlier.

I do have these files since the cache device still exists and I cannot 
stop it. io_error_halflife has 0 and io_error_limit has 8

> When io errors reaches io_error_limit, the io_disable tag will be set on cache or backing device (depends on where the I/O errors are from), and bcache will reject all external and internal I/O requests. If some upper layer code encounters an I/O error that it cannot handle, a kernel panic is possible. So setting io_disable file is same to wait for io errors reaches io_error_limit.

I suspect this must have already happened as the /sys/block/bcacheN is gone?

> This is as-designed behavior, because avoiding data corruption is the highest priority, rejecting I/O to avoid data corruption is more important than avoid a system down.

Right. Yes, this is very good and desirable, and it has happened here 
already when the backing devices failed at the start.
>> If there is any further info I can pull from the system that might be useful please let me know. Ultimately if there's nothing I can do I'll just have to bite the bullet and arrange a reboot.
> 
> I am not able to provide more useful suggestion for current situation, maybe arrange a reboot might be an ideal plan.

Yes I guess I'll have to do this unfortunately. I had hoped there might 
be a way to force bcache to release the nvme device like it should do, 
like it usually does in a situation like this, as rebooting this 
particular server is a big pain. But if not is there anything I can do 
to try and get some data that might give an idea what might have gone 
wrong here in bcache? So that it could possibly lead to a fix, because 
it is a very bad bug for any who might get hit by it in the future. I 
guess this could also be a bug in the md raid driver in which case I 
could report it there if that turns out to be the case.

Thanks!
Eddie

> 
> Thanks.
> 
> Coly Li
> 

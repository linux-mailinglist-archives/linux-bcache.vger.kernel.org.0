Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA62B17DA1
	for <lists+linux-bcache@lfdr.de>; Wed,  8 May 2019 17:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfEHP7Q (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 May 2019 11:59:16 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:55384 "EHLO
        mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfEHP7P (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 May 2019 11:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=thorsten-knabe.de; s=dkim1; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2plVTQoK93IpYRXgTI8VeTflExZRmLgIkc1uBlkWeqU=; b=MyYvt4vvV/TB2KaXrghSWmzw8S
        uxY4LAvuonu+qMG4v18WvXZFt1obE8w80vTg8TWJjuH3bXGpLYDWuH52DTJ8L0j5Tz4xIdomZFWUf
        KTopyvtytrseD5wH9XSB5MA4M2CpphcWb95GRQqhwiDUM59Z04W7+3mW7/o8rHPdfKdCa7NJ9GeLz
        nSRIXn5z+MHvbywFhuTkYY/jLd8H7/LMNrnwcT7Sg7YgSyNN1y0B6AIg/cd2bc+dSvm7tvjO6ihDZ
        LOz33jDUEf6gavStLlXfgWofnpOg+aP1+m7GoQAptzXchVKbX/0sC77TACE7cMoSh/IjOSejSInCq
        VdXZQA0g==;
Received: from tek01.intern.thorsten-knabe.de ([2a01:170:101e:1::a00:101])
        by mail.thorsten-knabe.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <linux@thorsten-knabe.de>)
        id 1hOOyM-0006px-AP; Wed, 08 May 2019 17:59:12 +0200
Subject: Re: BUG: bcache failing on top of degraded RAID-6
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <557659ec-3f41-d463-aa42-df33cb8d18b8@thorsten-knabe.de>
 <c11201ba-094a-db5b-4962-1dbafd377c85@suse.de>
 <0df416df-7cb7-05a4-e7ff-76da1d128560@thorsten-knabe.de>
 <efd60c92-e2f7-c07d-dc03-557eeee1ae3a@suse.de>
 <d8473b88-1f3c-145c-0ca8-e8c207f47d38@thorsten-knabe.de>
 <29b5552f-39b5-b0b9-80ec-cc4a32bcba78@suse.de>
 <3a5e949b-c51c-01ab-578c-ed4883522937@thorsten-knabe.de>
 <56663d65-02d3-2d55-9e90-d02987f61f7d@suse.de>
 <3153278c-0203-3ce5-5de3-40f08d409173@thorsten-knabe.de>
 <61323026-f168-b472-41f8-57c42a7fd0cc@suse.de>
 <63fc8271-f5a5-7fc3-9f4b-d8a610cf70b0@thorsten-knabe.de>
 <2515e3b2-1626-2206-add1-550a9dd34dee@suse.de>
From:   Thorsten Knabe <linux@thorsten-knabe.de>
Openpgp: preference=signencrypt
Message-ID: <2a444578-1828-763b-88ca-e1cda46864d2@thorsten-knabe.de>
Date:   Wed, 8 May 2019 17:58:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <2515e3b2-1626-2206-add1-550a9dd34dee@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Report: Content analysis details:   (-1.1 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.8 DKIM_ADSP_ALL          No valid author signature, domain signs all mail
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/7/19 5:05 PM, Coly Li wrote:
> On 2019/5/7 9:48 下午, Thorsten Knabe wrote:
>> On 5/7/19 3:07 PM, Coly Li wrote:
>>> On 2019/5/7 9:01 下午, Thorsten Knabe wrote:
>>>> On 5/7/19 2:23 PM, Coly Li wrote:
>>>>> On 2019/5/7 8:19 下午, Thorsten Knabe wrote:
>>>>>> On 3/27/19 2:45 PM, Coly Li wrote:
>>>>>>> On 2019/3/27 9:42 下午, Thorsten Knabe wrote:
>>>>>>>> On 3/27/19 12:53 PM, Coly Li wrote:
>>>>>>>>> On 2019/3/27 7:00 下午, Thorsten Knabe wrote:
>>>>>>>>>> On 3/27/19 10:44 AM, Coly Li wrote:
>>>>>>>>>>> On 2019/3/26 9:21 下午, Thorsten Knabe wrote:
>>>>>>>>>>>> Hello,
>>>>>>>>>>>>
>>>>>>>>>>>> there seems to be a serious problem, when running bcache on top of a
>>>>>>>>>>>> degraded RAID-6 (MD) array. The bcache device /dev/bcache0 disappears
>>>>>>>>>>>> after a few I/O operations on the affected device and the kernel log
>>>>>>>>>>>> gets filled with the following log message:
>>>>>>>>>>>>
>>>>>>>>>>>> bcache: bch_count_backing_io_errors() md0: IO error on backing device,
>>>>>>>>>>>> unrecoverable
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> It seems I/O request onto backing device failed. If the md raid6 device
>>>>>>>>>>> is the backing device, does it go into read-only mode after degrade ?
>>>>>>>>>>
>>>>>>>>>> No, the RAID6 backing device is still in read-write mode after the disk
>>>>>>>>>> has been removed from the RAID array. That's the way RAID6 is supposed
>>>>>>>>>> to work.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>> Setup:
>>>>>>>>>>>> Linux kernel: 5.1-rc2, 5.0.4, 4.19.0-0.bpo.2-amd64 (Debian backports)
>>>>>>>>>>>> all affected
>>>>>>>>>>>> bcache backing device: EXT4 filesystem -> /dev/bcache0 -> /dev/md0 ->
>>>>>>>>>>>> /dev/sd[bcde]1
>>>>>>>>>>>> bcache cache device: /dev/sdf1
>>>>>>>>>>>> cache mode: writethrough, none and cache device detached are all
>>>>>>>>>>>> affected, writeback and writearound has not been tested
>>>>>>>>>>>> KVM for testing, first observed on real hardware (failing RAID device)
>>>>>>>>>>>>
>>>>>>>>>>>> As long as the RAID6 is healthy, bcache works as expected. Once the
>>>>>>>>>>>> RAID6 gets degraded, for example by removing a drive from the array
>>>>>>>>>>>> (mdadm --fail /dev/md0 /dev/sde1, mdadm --remove /dev/md0 /dev/sde1),
>>>>>>>>>>>> the above-mentioned log messages appear in the kernel log and the bcache
>>>>>>>>>>>> device /dev/bcache0 disappears shortly afterwards logging:
>>>>>>>>>>>>
>>>>>>>>>>>> bcache: bch_cached_dev_error() stop bcache0: too many IO errors on
>>>>>>>>>>>> backing device md0
>>>>>>>>>>>>
>>>>>>>>>>>> to the kernel log.
>>>>>>>>>>>>
>>>>>>>>>>>> Increasing /sys/block/bcache0/bcache/io_error_limit to a very high value
>>>>>>>>>>>> (1073741824) the bcache device /dev/bcache0 remains usable without any
>>>>>>>>>>>> noticeable filesystem corruptions.
>>>>>>>>>>>
>>>>>>>>>>> If the backing device goes into read-only mode, bcache will take this
>>>>>>>>>>> backing device as a failure status. The behavior is to stop the bcache
>>>>>>>>>>> device of the failed backing device, to notify upper layer something
>>>>>>>>>>> goes wrong.
>>>>>>>>>>>
>>>>>>>>>>> In writethough and writeback mode, bcache requires the backing device to
>>>>>>>>>>> be writable.
>>>>>>>>>>
>>>>>>>>>> But, the degraded (one disk of the array missing) RAID6 device is still
>>>>>>>>>> writable.
>>>>>>>>>>
>>>>>>>>>> Also after raising the io_error_limit of the bcache device to a very
>>>>>>>>>> high value (1073741824 in my tests) I can use the bcache device on the
>>>>>>>>>> degraded RAID6 array for hours reading and writing gigabytes of data,
>>>>>>>>>> without getting any I/O errors or observing any filesystem corruptions.
>>>>>>>>>> I'm just getting a lot of those
>>>>>>>>>>
>>>>>>>>>> bcache: bch_count_backing_io_errors() md0: IO error on backing device,
>>>>>>>>>> unrecoverable
>>>>>>>>>>
>>>>>>>>>> messages in the kernel log.
>>>>>>>>>>
>>>>>>>>>> It seems that I/O requests for data that have been successfully
>>>>>>>>>> recovered by the RAID6 from the redundant information stored on the
>>>>>>>>>> additional disks are accidentally counted as failed I/O requests and
>>>>>>>>>> when the configured io_error_limit for the bcache device is reached, the
>>>>>>>>>> bcache device gets stopped.
>>>>>>>>> Oh, thanks for the informaiton.
>>>>>>>>>
>>>>>>>>> It sounds during md raid6 degrading and recovering, some I/O from bcache
>>>>>>>>> might be failed, and after md raid6 degrades and recovers, the md device
>>>>>>>>> continue to serve I/O request. Am I right ?
>>>>>>>>>
>>>>>>>>
>>>>>>>> I think, the I/O errors logged by bcache are not real I/O errors,
>>>>>>>> because the filesystem on top of the bcache device does not report any
>>>>>>>> I/O errors unless the bcache device gets stopped by bcache due to too
>>>>>>>> many errors (io_error_limit reached).
>>>>>>>>
>>>>>>>> I performed the following test:
>>>>>>>>
>>>>>>>> Starting with bcache on a healthy RAID6 with 4 disks (all attached and
>>>>>>>> completely synced). cache_mode set to "none" to ensure data is read from
>>>>>>>> the backing device. EXT4 filesystem on top of bcache mounted with two
>>>>>>>> identical directories each containing 4GB of data on a system with 2GB
>>>>>>>> of RAM to ensure data is not coming form the page cache. "diff -r dir1
>>>>>>>> dir2" running in a loop to check for inconsistencies. Also
>>>>>>>> io_error_limit has been raised to 1073741824 to ensure the bcache device
>>>>>>>> does not get stopped due to too many io errors during the test.
>>>>>>>>
>>>>>>>> As long as all 4 disks attached to the RAID6 array, no messages get logged.
>>>>>>>>
>>>>>>>> Once one disk is removed from the RAID6 array using
>>>>>>>>   mdadm --fail /dev/md0 /dev/sde1
>>>>>>>> the kernel log gets filled with the
>>>>>>>>
>>>>>>>> bcache: bch_count_backing_io_errors() md0: IO error on backing device,
>>>>>>>> unrecoverable
>>>>>>>>
>>>>>>>> messages. However neither the EXT4 filesystem logs any corruptions nor
>>>>>>>> does the diff comparing the two directories report any inconsistencies.
>>>>>>>>
>>>>>>>> Adding the previously removed disk back to the RAID6 array, bcache stops
>>>>>>>> reporting the above-mentioned error message once the re-added disk is
>>>>>>>> fully synced and the RAID6 array is healthy again.
>>>>>>>>
>>>>>>>> If the I/O requests to the RAID6 device would actually fail, I would
>>>>>>>> expect to see either EXT4 filesystem errors in the logs or at least diff
>>>>>>>> reporting differences, but nothing gets logged in the kernel log expect
>>>>>>>> the above-mentioned message from bcache.
>>>>>>>>
>>>>>>>> It seems bcache mistakenly classifies or at least counts some I/O
>>>>>>>> requests as failed although they have not actually failed.
>>>>>>>>
>>>>>>>> By the way Linux 4.9 (from Debian stable) is most probably not affected.
>>>>>>> Hi Thorsten,
>>>>>>>
>>>>>>> Let me try to reproduce and check into. I will ask you for more
>>>>>>> information later.
>>>>>>>
>>>>>>> Very informative, thanks.
>>>>>>>
>>>>>>
>>>>>> Hello Cody.
>>>>>>
>>>>>> I'm now running Linux 5.1 and still see the errors described above.
>>>>>>
>>>>>> I did some further investigations myself.
>>>>>>
>>>>>> The affected bio have the bio_status field set to 10 (=BLK_STS_IOERR)
>>>>>> and the bio_ops field set to 524288 (=REQ_RAHEAD).
>>>>>>
>>>>>> According to the comment in linux/blk_types.h such requests may fail.
>>>>>> Quote from linux/blk_types.h:
>>>>>> 	__REQ_RAHEAD,           /* read ahead, can fail anytime */
>>>>>>
>>>>>> That would explain why no file system errors or corruptions occur,
>>>>>> although bcache reports IO errors from the backing device.
>>>>>>
>>>>>> Thus I assume errors resulting from such read-ahead bio requests should
>>>>>> not be counted/ignored by bcache.
>>>>>
>>>>> Hi Thorsten,
>>>>>
>>>>> Do you mean should not be counted, or should not be ignored for
>>>>> read-ahead bio failure ?
>>>>>
>>>>> Thanks.
>>>>>
>>>>>
>>>>
>>>> I'm far from being a Linux block IO subsystem expert.
>>>> My assumption is that a block device has the option to fail read-ahead
>>>> bio requests under certain circumstances, for example, if receiving the
>>>> requested sectors is too expensive and that the MD RAID6 code makes use
>>>> of that option when the RAID array is in a degraded state. But I'm just
>>>> guessing.
>>>>
>>>> I'm not sure how such errors are handled correctly, probably they can
>>>> simply be ignored completely, but should at least not contribute to the
>>>> bcache error counter (dc->io_errors).
>>>
>>> Hi Thorsten,
>>>
>>> As you said "should at least not contribute to the
>>>> bcache error counter (dc->io_errors)", the challenge is that I need a
>>> method to distinguish a real device I/O failure or a md raid6 degraded
>>> failure. So far I don't have idea how to make it.
>>
>> Maybe:
>>
>> --- linux-5.1/drivers/md/bcache/io.c-orig       2019-05-07
>> 15:34:23.283543872 +0200
>> +++ linux-5.1/drivers/md/bcache/io.c    2019-05-07 15:36:11.133543872 +0200
>> @@ -58,6 +58,8 @@ void bch_count_backing_io_errors(struct
>>
>>         WARN_ONCE(!dc, "NULL pointer of struct cached_dev");
>>
>> +       if (bio && (bio->bi_opf & REQ_RAHEAD))
>> +               return;
>>         errors = atomic_add_return(1, &dc->io_errors);
>>         if (errors < dc->error_limit)
>>                 pr_err("%s: IO error on backing device, unrecoverable",
> 

Hi Cody.

> I cannot do this. Because this is real I/O issued to backing device, if
> it failed, it means something really wrong on backing device.

I have not found a definitive answer or documentation what the
REQ_RAHEAD flag is actually used for. However in my understanding, after
reading a lot of kernel source, it is used as an indication, that the
bio read request is unimportant for proper operation and may be failed
by the block device driver returning BLK_STS_IOERR, if it is too
expensive or requires too many additional resources.

At least the BTRFS and DRBD code do not take bio request IO errors that
are marked with the REQ_RAHEAD flag into account in their error
counters. Thus it is probably okay if such IO errors with the REQ_RAHEAD
flags set are not counted as errors by bcache too.

> 
> Hmm, If raid6 may returns different error code in bio->bi_status, then
> we can identify this is a failure caused by raid degrade, not a read
> hardware or link failure. But now I am not familiar with raid456 code,
> no idea how to change the md raid code (I assume you meant md raid6)...

I my assumptions above regarding the REQ_RAHEAD flag are correct, then
the RAID code is correct, because restoring data from the parity
information is a relatively expensive operation for read-ahead data,
that is possibly never actually needed.

Regards
Thorsten


-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de

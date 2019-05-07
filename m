Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F374163CF
	for <lists+linux-bcache@lfdr.de>; Tue,  7 May 2019 14:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbfEGMgr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 May 2019 08:36:47 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:40586 "EHLO
        mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfEGMgr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 May 2019 08:36:47 -0400
X-Greylist: delayed 1017 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2019 08:36:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=thorsten-knabe.de; s=dkim1; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xBPcM/z9GRasKzHlCwMssUbP1Wgmxu+WfppW/zxx/5A=; b=KA/YNXrz4nZhpzX+cyvyOiQikw
        N4PbMSrFbRh4Mhsutq8YV0J9FVmhxb7htvBrGkQ/lZWEmO7dbTJZIkeA2K6e+cHE6BdALwiGwVhtV
        49AGMjUwX0BggrRAeCKNaco+62fAuzP7BE3wvUeDsTGnfoSad1whi1XfH1W+Y4GdKknUYDMgXfcrb
        QWD/JMboyCGD3S2IQ/SY/Scg0V7VCgTS7v6L4+0W7k9wKhcQ+ofFiarmUMmwaftX2E6j+TFjxlYCC
        X1F4tksIbtzZCWRF8qzpEyTABLjsVtP/4jhGr7vtPmUXvdd/hlR/F+7V64gkWAaTq9xZEyKJrXFcj
        VXal4WDw==;
Received: from tek01.intern.thorsten-knabe.de ([2a01:170:101e:1::a00:101])
        by mail.thorsten-knabe.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <linux@thorsten-knabe.de>)
        id 1hNz4S-0004lv-5U; Tue, 07 May 2019 14:19:46 +0200
Subject: Re: BUG: bcache failing on top of degraded RAID-6
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <557659ec-3f41-d463-aa42-df33cb8d18b8@thorsten-knabe.de>
 <c11201ba-094a-db5b-4962-1dbafd377c85@suse.de>
 <0df416df-7cb7-05a4-e7ff-76da1d128560@thorsten-knabe.de>
 <efd60c92-e2f7-c07d-dc03-557eeee1ae3a@suse.de>
 <d8473b88-1f3c-145c-0ca8-e8c207f47d38@thorsten-knabe.de>
 <29b5552f-39b5-b0b9-80ec-cc4a32bcba78@suse.de>
From:   Thorsten Knabe <linux@thorsten-knabe.de>
Openpgp: preference=signencrypt
Message-ID: <3a5e949b-c51c-01ab-578c-ed4883522937@thorsten-knabe.de>
Date:   Tue, 7 May 2019 14:19:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <29b5552f-39b5-b0b9-80ec-cc4a32bcba78@suse.de>
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

On 3/27/19 2:45 PM, Coly Li wrote:
> On 2019/3/27 9:42 下午, Thorsten Knabe wrote:
>> On 3/27/19 12:53 PM, Coly Li wrote:
>>> On 2019/3/27 7:00 下午, Thorsten Knabe wrote:
>>>> On 3/27/19 10:44 AM, Coly Li wrote:
>>>>> On 2019/3/26 9:21 下午, Thorsten Knabe wrote:
>>>>>> Hello,
>>>>>>
>>>>>> there seems to be a serious problem, when running bcache on top of a
>>>>>> degraded RAID-6 (MD) array. The bcache device /dev/bcache0 disappears
>>>>>> after a few I/O operations on the affected device and the kernel log
>>>>>> gets filled with the following log message:
>>>>>>
>>>>>> bcache: bch_count_backing_io_errors() md0: IO error on backing device,
>>>>>> unrecoverable
>>>>>>
>>>>>
>>>>> It seems I/O request onto backing device failed. If the md raid6 device
>>>>> is the backing device, does it go into read-only mode after degrade ?
>>>>
>>>> No, the RAID6 backing device is still in read-write mode after the disk
>>>> has been removed from the RAID array. That's the way RAID6 is supposed
>>>> to work.
>>>>
>>>>>
>>>>>
>>>>>> Setup:
>>>>>> Linux kernel: 5.1-rc2, 5.0.4, 4.19.0-0.bpo.2-amd64 (Debian backports)
>>>>>> all affected
>>>>>> bcache backing device: EXT4 filesystem -> /dev/bcache0 -> /dev/md0 ->
>>>>>> /dev/sd[bcde]1
>>>>>> bcache cache device: /dev/sdf1
>>>>>> cache mode: writethrough, none and cache device detached are all
>>>>>> affected, writeback and writearound has not been tested
>>>>>> KVM for testing, first observed on real hardware (failing RAID device)
>>>>>>
>>>>>> As long as the RAID6 is healthy, bcache works as expected. Once the
>>>>>> RAID6 gets degraded, for example by removing a drive from the array
>>>>>> (mdadm --fail /dev/md0 /dev/sde1, mdadm --remove /dev/md0 /dev/sde1),
>>>>>> the above-mentioned log messages appear in the kernel log and the bcache
>>>>>> device /dev/bcache0 disappears shortly afterwards logging:
>>>>>>
>>>>>> bcache: bch_cached_dev_error() stop bcache0: too many IO errors on
>>>>>> backing device md0
>>>>>>
>>>>>> to the kernel log.
>>>>>>
>>>>>> Increasing /sys/block/bcache0/bcache/io_error_limit to a very high value
>>>>>> (1073741824) the bcache device /dev/bcache0 remains usable without any
>>>>>> noticeable filesystem corruptions.
>>>>>
>>>>> If the backing device goes into read-only mode, bcache will take this
>>>>> backing device as a failure status. The behavior is to stop the bcache
>>>>> device of the failed backing device, to notify upper layer something
>>>>> goes wrong.
>>>>>
>>>>> In writethough and writeback mode, bcache requires the backing device to
>>>>> be writable.
>>>>
>>>> But, the degraded (one disk of the array missing) RAID6 device is still
>>>> writable.
>>>>
>>>> Also after raising the io_error_limit of the bcache device to a very
>>>> high value (1073741824 in my tests) I can use the bcache device on the
>>>> degraded RAID6 array for hours reading and writing gigabytes of data,
>>>> without getting any I/O errors or observing any filesystem corruptions.
>>>> I'm just getting a lot of those
>>>>
>>>> bcache: bch_count_backing_io_errors() md0: IO error on backing device,
>>>> unrecoverable
>>>>
>>>> messages in the kernel log.
>>>>
>>>> It seems that I/O requests for data that have been successfully
>>>> recovered by the RAID6 from the redundant information stored on the
>>>> additional disks are accidentally counted as failed I/O requests and
>>>> when the configured io_error_limit for the bcache device is reached, the
>>>> bcache device gets stopped.
>>> Oh, thanks for the informaiton.
>>>
>>> It sounds during md raid6 degrading and recovering, some I/O from bcache
>>> might be failed, and after md raid6 degrades and recovers, the md device
>>> continue to serve I/O request. Am I right ?
>>>
>>
>> I think, the I/O errors logged by bcache are not real I/O errors,
>> because the filesystem on top of the bcache device does not report any
>> I/O errors unless the bcache device gets stopped by bcache due to too
>> many errors (io_error_limit reached).
>>
>> I performed the following test:
>>
>> Starting with bcache on a healthy RAID6 with 4 disks (all attached and
>> completely synced). cache_mode set to "none" to ensure data is read from
>> the backing device. EXT4 filesystem on top of bcache mounted with two
>> identical directories each containing 4GB of data on a system with 2GB
>> of RAM to ensure data is not coming form the page cache. "diff -r dir1
>> dir2" running in a loop to check for inconsistencies. Also
>> io_error_limit has been raised to 1073741824 to ensure the bcache device
>> does not get stopped due to too many io errors during the test.
>>
>> As long as all 4 disks attached to the RAID6 array, no messages get logged.
>>
>> Once one disk is removed from the RAID6 array using
>>   mdadm --fail /dev/md0 /dev/sde1
>> the kernel log gets filled with the
>>
>> bcache: bch_count_backing_io_errors() md0: IO error on backing device,
>> unrecoverable
>>
>> messages. However neither the EXT4 filesystem logs any corruptions nor
>> does the diff comparing the two directories report any inconsistencies.
>>
>> Adding the previously removed disk back to the RAID6 array, bcache stops
>> reporting the above-mentioned error message once the re-added disk is
>> fully synced and the RAID6 array is healthy again.
>>
>> If the I/O requests to the RAID6 device would actually fail, I would
>> expect to see either EXT4 filesystem errors in the logs or at least diff
>> reporting differences, but nothing gets logged in the kernel log expect
>> the above-mentioned message from bcache.
>>
>> It seems bcache mistakenly classifies or at least counts some I/O
>> requests as failed although they have not actually failed.
>>
>> By the way Linux 4.9 (from Debian stable) is most probably not affected.
> Hi Thorsten,
> 
> Let me try to reproduce and check into. I will ask you for more
> information later.
> 
> Very informative, thanks.
> 

Hello Cody.

I'm now running Linux 5.1 and still see the errors described above.

I did some further investigations myself.

The affected bio have the bio_status field set to 10 (=BLK_STS_IOERR)
and the bio_ops field set to 524288 (=REQ_RAHEAD).

According to the comment in linux/blk_types.h such requests may fail.
Quote from linux/blk_types.h:
	__REQ_RAHEAD,           /* read ahead, can fail anytime */

That would explain why no file system errors or corruptions occur,
although bcache reports IO errors from the backing device.

Thus I assume errors resulting from such read-ahead bio requests should
not be counted/ignored by bcache.

Kind regards
Thorsten





-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de

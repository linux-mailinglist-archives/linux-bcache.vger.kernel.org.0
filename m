Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D96C31C5E0
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2019 11:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfENJUF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 May 2019 05:20:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:52228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbfENJUE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 May 2019 05:20:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9E4EAF03;
        Tue, 14 May 2019 09:20:02 +0000 (UTC)
Subject: Re: BUG: bcache failing on top of degraded RAID-6
To:     Thorsten Knabe <linux@thorsten-knabe.de>
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
 <2a444578-1828-763b-88ca-e1cda46864d2@thorsten-knabe.de>
 <3ac24c5b-05f5-560d-12d5-57acdb96e50a@suse.de>
 <21269f9e-194a-b86c-1940-c63450c1ac55@suse.de>
 <6b7b7611-4fa8-5980-8d90-4adb1e2016ee@thorsten-knabe.de>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <e734bbc2-0f64-8fbb-8b7b-c9d8764b6788@suse.de>
Date:   Tue, 14 May 2019 17:19:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6b7b7611-4fa8-5980-8d90-4adb1e2016ee@thorsten-knabe.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/14 4:55 下午, Thorsten Knabe wrote:
> On 5/13/19 5:36 PM, Coly Li wrote:
>> On 2019/5/9 3:43 上午, Coly Li wrote:
>>> On 2019/5/8 11:58 下午, Thorsten Knabe wrote:
>> [snipped]
>>
>>>> Hi Cody.
>>>>
>>>>> I cannot do this. Because this is real I/O issued to backing device, if
>>>>> it failed, it means something really wrong on backing device.
>>>>
>>>> I have not found a definitive answer or documentation what the
>>>> REQ_RAHEAD flag is actually used for. However in my understanding, after
>>>> reading a lot of kernel source, it is used as an indication, that the
>>>> bio read request is unimportant for proper operation and may be failed
>>>> by the block device driver returning BLK_STS_IOERR, if it is too
>>>> expensive or requires too many additional resources.
>>>>
>>>> At least the BTRFS and DRBD code do not take bio request IO errors that
>>>> are marked with the REQ_RAHEAD flag into account in their error
>>>> counters. Thus it is probably okay if such IO errors with the REQ_RAHEAD
>>>> flags set are not counted as errors by bcache too.
>>>>
>>>>>
>>>>> Hmm, If raid6 may returns different error code in bio->bi_status, then
>>>>> we can identify this is a failure caused by raid degrade, not a read
>>>>> hardware or link failure. But now I am not familiar with raid456 code,
>>>>> no idea how to change the md raid code (I assume you meant md raid6)...
>>>>
>>>> I my assumptions above regarding the REQ_RAHEAD flag are correct, then
>>>> the RAID code is correct, because restoring data from the parity
>>>> information is a relatively expensive operation for read-ahead data,
>>>> that is possibly never actually needed.
>>>
>>>
>>> Hi Thorsten,
>>>
>>> Thank you for the informative hint. I agree with your idea, it seems
>>> ignoring I/O error of REQ_RAHEAD bios does not hurt. Let me think how to
>>> fix it by your suggestion.
>>>
>>
>> Hi Thorsten,
>>
>> Could you please to test the attached patch ?
>> Thanks in advance.
>>
> 
> Hi Cody.
> 
> I have applied your patch to a 3 systems running Linux 5.1.1 yesterday
> evening, on one of them I removed a disk from the RAID6 array.
> 
> The patch works as expected. The system with the removed disk has logged
> more than 1300 of the messages added by your patch. Most of them have
> been logged shortly after boot up and a few shorter burst evenly spread
> over the runtime of the system.
> 
> Probably it would be a good idea to apply some sort of rate limit to the
> log message. I could imagine that a different file system or I/O pattern
> could cause a lot more of these message.
> 

Hi Thorsten,

Nice suggestion, I will add ratelimit to pr_XXX routines in other patch.
Will post it out later for your testing.

> When we are at it. The WARN_ONCE at the beginning of the function looks
> a bit suspicious too. It logs a warning when dc is NULL but the function
> continues and dereferences dc later on. -> Oops!

The WARN_ONCE you see is on purpose, because dc should not be NULL here.
Once dc is NULL here, that means the code is buggy, and the oops is
unavoidable. Then the WARN_ONCE just gives more clue in kernel message.

When oops happens, the whole system might still be alive, which is
better than panic by BUG_ON(), IMHO. Anyway, dc should not be NULL here.

Thanks.
-- 

Coly Li

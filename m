Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8527A1C56F
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2019 10:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbfENIzF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 14 May 2019 04:55:05 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:58022 "EHLO
        mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfENIzF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 14 May 2019 04:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=thorsten-knabe.de; s=dkim1; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Cj57tAAcuaZIG6KheX3yOzz5YYTS72y5SK5bQWZIYpg=; b=PPHPJ4vWxH5N87U0qll0E3iMvO
        gPsJZ/RIhgkBbinlr5p8Ru5U+6hnE8vPrQXJ0NvyCTsK+qkEkZM9XC1/IfmcrBncc+coJTnBgIfuI
        c13cJuK4dMovnXbCAYBIl8F+wYth8NUFkNIn30ys9sITBxO4hDNzsxt/pKuO91gascj4d2EqLcBBC
        k44X8xzvdOEiUGs0939qBxjN3qQFBmKRq4pXFBGeyXcO3DFeC9i9CEAsxcg0VfR61jxhv0wj15DEO
        K1bRS+kOsPnjdRoSYx8dOZS7zHaSji0+JNyNaebYYZH3TK4+T+nmOwI7oBril+U2MF0ZOEEdIC/jD
        6hr/hHWQ==;
Received: from tek01.intern.thorsten-knabe.de ([2a01:170:101e:1::a00:101])
        by mail.thorsten-knabe.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <linux@thorsten-knabe.de>)
        id 1hQTDB-00031S-16; Tue, 14 May 2019 10:55:02 +0200
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
 <2a444578-1828-763b-88ca-e1cda46864d2@thorsten-knabe.de>
 <3ac24c5b-05f5-560d-12d5-57acdb96e50a@suse.de>
 <21269f9e-194a-b86c-1940-c63450c1ac55@suse.de>
From:   Thorsten Knabe <linux@thorsten-knabe.de>
Openpgp: preference=signencrypt
Message-ID: <6b7b7611-4fa8-5980-8d90-4adb1e2016ee@thorsten-knabe.de>
Date:   Tue, 14 May 2019 10:55:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <21269f9e-194a-b86c-1940-c63450c1ac55@suse.de>
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

On 5/13/19 5:36 PM, Coly Li wrote:
> On 2019/5/9 3:43 上午, Coly Li wrote:
>> On 2019/5/8 11:58 下午, Thorsten Knabe wrote:
> [snipped]
> 
>>> Hi Cody.
>>>
>>>> I cannot do this. Because this is real I/O issued to backing device, if
>>>> it failed, it means something really wrong on backing device.
>>>
>>> I have not found a definitive answer or documentation what the
>>> REQ_RAHEAD flag is actually used for. However in my understanding, after
>>> reading a lot of kernel source, it is used as an indication, that the
>>> bio read request is unimportant for proper operation and may be failed
>>> by the block device driver returning BLK_STS_IOERR, if it is too
>>> expensive or requires too many additional resources.
>>>
>>> At least the BTRFS and DRBD code do not take bio request IO errors that
>>> are marked with the REQ_RAHEAD flag into account in their error
>>> counters. Thus it is probably okay if such IO errors with the REQ_RAHEAD
>>> flags set are not counted as errors by bcache too.
>>>
>>>>
>>>> Hmm, If raid6 may returns different error code in bio->bi_status, then
>>>> we can identify this is a failure caused by raid degrade, not a read
>>>> hardware or link failure. But now I am not familiar with raid456 code,
>>>> no idea how to change the md raid code (I assume you meant md raid6)...
>>>
>>> I my assumptions above regarding the REQ_RAHEAD flag are correct, then
>>> the RAID code is correct, because restoring data from the parity
>>> information is a relatively expensive operation for read-ahead data,
>>> that is possibly never actually needed.
>>
>>
>> Hi Thorsten,
>>
>> Thank you for the informative hint. I agree with your idea, it seems
>> ignoring I/O error of REQ_RAHEAD bios does not hurt. Let me think how to
>> fix it by your suggestion.
>>
> 
> Hi Thorsten,
> 
> Could you please to test the attached patch ?
> Thanks in advance.
> 

Hi Cody.

I have applied your patch to a 3 systems running Linux 5.1.1 yesterday
evening, on one of them I removed a disk from the RAID6 array.

The patch works as expected. The system with the removed disk has logged
more than 1300 of the messages added by your patch. Most of them have
been logged shortly after boot up and a few shorter burst evenly spread
over the runtime of the system.

Probably it would be a good idea to apply some sort of rate limit to the
log message. I could imagine that a different file system or I/O pattern
could cause a lot more of these message.

When we are at it. The WARN_ONCE at the beginning of the function looks
a bit suspicious too. It logs a warning when dc is NULL but the function
continues and dereferences dc later on. -> Oops!

Regards
Thorsten


-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915DE685DA2
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Feb 2023 04:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjBADDC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 Jan 2023 22:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjBADCz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Jan 2023 22:02:55 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198361BC0
        for <linux-bcache@vger.kernel.org>; Tue, 31 Jan 2023 19:02:52 -0800 (PST)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id 1D5776201F6;
        Wed,  1 Feb 2023 11:02:49 +0800 (CST)
Message-ID: <3ac5b76c-4f73-5668-50da-d3038f162040@easystack.cn>
Date:   Wed, 1 Feb 2023 11:02:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Multi-Level Caching
To:     Coly Li <colyli@suse.de>,
        Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
References: <CAHykVA6L3bQkGJ11N3jG_QSgPbyr40zc8rBNPPwBN9a5RHwC6Q@mail.gmail.com>
 <AA6912BA-7DE5-466E-8E85-9EB58FCFC81D@suse.de>
Content-Language: en-US
From:   mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <AA6912BA-7DE5-466E-8E85-9EB58FCFC81D@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTxpCVkkfSh4ZTh1OQxkZHlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ny46EQw4HTJWNRFNPhFMFElM
        KwkKCTVVSlVKTUxOSUlLTk1CQ0NCVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0lPSTcG
X-HM-Tid: 0a860aed4d9200a4kurm1d5776201f6
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



在 2023/1/31 23:51, Coly Li 写道:
> 
> 
>> 2023年1月26日 19:30，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
>>
>> Hi,
>> I know that bcache doesn't natively support multi-level caching but I
>> was playing with it and found this interesting "workaround":
>>   make-bcache -B /dev/vdb -C /dev/vdc
>> the above command will generate a /dev/bcache0 device that we can now
>> use as backing (or cached) device:
>>   make-bcache -B /dev/bcache0 -C /dev/vdd
>> This will make the kernel panic because the driver is trying to create
>> a duplicated "bcache" folder under /sys/block/bcache0/ .
>> So, simply patching the code inside register_bdev to create a folder
>> "bcache2" if "bcache" already exists does the trick.
>> Now I have:
>> vdb                       252:16   0    5G  0 disk
>> └─bcache0                 251:0    0    5G  0 disk
>>   └─bcache1               251:128  0    5G  0 disk /mnt/bcache1
>> vdc                       252:32   0   10G  0 disk
>> └─bcache0                 251:0    0    5G  0 disk
>>   └─bcache1               251:128  0    5G  0 disk /mnt/bcache1
>> vdd                       252:48   0    5G  0 disk
>> └─bcache1                 251:128  0    5G  0 disk /mnt/bcache1
>>
>> Is anyone using this functionality? I assume not, because by default
>> it doesn't work.
>> Is there any good reason why this doesn't work by default?
>>
>> I tried to understand how data will be read out of /dev/bcache1: will
>> the /dev/vdd cache, secondly created cache device, be interrogated
>> first and then will it be the turn of /dev/vdc ?
>> Meaning: can we consider that now the layer structure is
>>
>> vdd
>> └─vdc
>>        └─bcache0
>>              └─bcache1
>> ?
> 
> IIRC, there was a patch tried to achieve similar purpose. I was not supportive for this idea because I didn’t see really useful use case.

Hi, Coly

Maybe we have a case like this. We are considering make-bcache a hdd as 
a cache device and create a flash device in it, and then using the flash 
device as a backing. So， completely converts writeback to sequential 
writes.

However, we found that there may be many unknown problems in the flash 
device, such as the created size, etc.

For now, we've put it due to time，but we think it might be a good thing 
to do. We also have some patches, I will post them.

mingzhe

> In general, extra layer cache means extra latency in the I/O path. What I see in practical deployments are, people try very hard to minimize the cache layer and place it close to application.
> 
> Introduce stackable bcache for itself may work, but I don’t see real usage yet, and no motivation to maintain such usage still.
> 
> Thanks.
> 
> Coly Li

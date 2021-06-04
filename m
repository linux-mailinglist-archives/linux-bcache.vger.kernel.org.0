Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7236339B8D3
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 14:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFDMOd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 08:14:33 -0400
Received: from correo01.aragon.es ([188.244.81.25]:29652 "EHLO aragon.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230034AbhFDMOd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 08:14:33 -0400
Received: from aragon.es ([172.30.3.33])
        by FM2.aragon.es  with ESMTP id 154CCjSC030111-154CCjSD030111;
        Fri, 4 Jun 2021 14:12:45 +0200
Received: from [1.8.2.59] (account scastillo@aragon.es [1.8.2.59] verified)
  by aragon.es (CommuniGate Pro SMTP 6.2.12)
  with ESMTPSA id 92491107; Fri, 04 Jun 2021 14:12:45 +0200
Subject: Re: Low hit ratio and cache usage
To:     Pierre Juhen <pierre.juhen@orange.fr>, linux-bcache@vger.kernel.org
References: <5b01087b-6e56-0396-774a-1c1a71fe50df@aragon.es>
 <f25c7f91-433e-d699-c1f6-7e828023167f@orange.fr>
From:   Santiago Castillo Oli <scastillo@aragon.es>
Message-ID: <6f1e1665-a231-47e2-5271-588d79915f66@aragon.es>
Date:   Fri, 4 Jun 2021 14:12:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <f25c7f91-433e-d699-c1f6-7e828023167f@orange.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-FE-Policy-ID: 21:5:5:aragon.es
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Pierre!


I see your point about Copy On Write, but in this scenario most of the 
data is only written once and read many times. I hoped bcache to perform 
better as a read cache. I´m afraid that bcache is only caching written 
(new and modified) blocks, not blocks already in backing device but not 
in cache device. Cache device was attached with most of data already 
resting on backing device.


What other setup would you say to be an optimal configuration to speed 
up VMs I/O using qcow2 files?


Thank you and regards


El 04/06/2021 a las 14:00, Pierre Juhen escribió:
>
> Hi !
>
> COW from qcow2 means Copy On Write.
>
> It means that a new block is written for each modification on an 
> existing block.
>
> Therefore, a "living" block is read only once, and the statistics are 
> not favorable keep the blocks in the cache.
>
> Only the "static" files (OS and frequently used program) benefit from 
> the cache.
>
> So I think that qcow2 and bcache might not be a optimal configuration.
>
> Any complement on this quick analysis ?
>
> Regards,
>
>
> Le 04/06/2021 à 13:07, Santiago Castillo Oli a écrit :
>> Hi all!
>>
>>
>> I'm using bcache and I think I have a rather low hit ratio and cache 
>> occupation.
>>
>>
>> My setup is:
>>
>> - Cache device: 82 GiB partition on a SSD drive. Bucket size=4M. The 
>> partition is aligned on a Gigabyte boundary.
>>
>> - Backing device: 3.6 TiB partition on a HDD drive. There is 732 GiB 
>> of data usage on this partition. This 732 GiB are used by 9 qcow2 
>> files assigned to 3 VMs running on the host.
>>
>> - Neither the SDD nor HDD drives have another partitions in use.
>>
>> - After 24 hours of use, according to priority_stats the cache is 75% 
>> Unused (63 GiB Unused - 19 GiB used), but...
>>
>> - ... according to "smartctl -a" in those 24 hours "Writes to Flash" 
>> has increased in 160 GiB and "GB written from host" has increased in 
>> 90 GiB
>>
>> - cache_hit_ratio is 10 %
>>
>>
>>
>> - I'm using maximum bucket size (4M) trying to minimize write 
>> amplification. With this bucket size, "Writes to Flash" (160) to "GB 
>> written from host"(90) ratio is 1,78. Previously, some days ago, I 
>> was using default bucket size. The write amplification ratio then was 
>> 2,01.
>>
>> - Isn't the cache_hit_ratio (10%) a bit low?
>>
>> - Is it normal that, after 24 hours running, the cache occupation is 
>> that low (82-63 = 19GiB, 25%)  when the host has written 90 GiB to 
>> the cache device in the same period? I don´t understand why 90 GiB of 
>> data has been written to fill 19 GiB of cache.
>>
>>
>> Any ideas?
>>
>>
>> Thank you and regards.
>>
>>
-- 
___________________________________________________________


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988BCE2128
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Oct 2019 18:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfJWQ6W (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Oct 2019 12:58:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:60180 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbfJWQ6W (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Oct 2019 12:58:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E08E2ACB7;
        Wed, 23 Oct 2019 16:58:20 +0000 (UTC)
Subject: Re: Getting high cache_bypass_misses in my setup
To:     Sergey Kolesnikov <rockingdemon@gmail.com>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org
References: <CAExpLJg86wKgY=1iPt6VMOiWbVKHU-TCQqWa0aD1OA-ype07sw@mail.gmail.com>
 <18e5a2af-da70-60f6-6bd9-33f585b5971b@suse.de>
 <alpine.LRH.2.11.1910221906210.25870@mx.ewheeler.net>
 <11f217a7-2ea8-65c5-6317-a4f2b56aa200@suse.de>
 <CAExpLJhXrsuVm5G8P-G7zPCnheZTMe__Aqa9RKDWj3cjGPB99w@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <f39217ed-fee7-f226-bb44-70e60d3b8fd4@suse.de>
Date:   Thu, 24 Oct 2019 00:58:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAExpLJhXrsuVm5G8P-G7zPCnheZTMe__Aqa9RKDWj3cjGPB99w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/23 5:17 下午, Sergey Kolesnikov wrote:
> ср, 23 окт. 2019 г. в 11:20, Coly Li <colyli@suse.de>:
>>
>> On 2019/10/23 3:12 上午, Eric Wheeler wrote:
> 
>>> On Tue, 15 Oct 2019, Coly Li wrote:
>>>> I have no much idea. The 4Kn SSD is totally new to me. Last time I saw
>>>> Eric Wheeler reported 4Kn hard diver didn't work well as backing device,
>>>> and I don't find an exact reason up to now. I am not able to say 4Kn is
>>>> not supported or not, before I have such device to test...
> 
> Coly, thank you for your reply. It seems I'll have ot do some more
> tests and dive a little into bcache sources when I have time.
> Meanwhile, could you please explain what cache_bypass_misses and
> cache_bypass_hits mean? It's not obvious from the docs.
> 
> 
>> Yes, this is the problem I wanted to say. Kent suggested me to look into
>> the extent code, but I didn't find anything suspicious. Also I tried to
>> buy a 4Kn SSD, but it seemed not for consumer market and I could not
>> find it from Taobao (www.taobao.com).
> 
> I'm using SANDISK Extreme Pro SDSSDXPM2-500G-G25 M.2 NVMe drive and
> it's quite common desktop drive, just use native 4K format (nvme-cli)
> LBA Format  0 : Metadata Size: 0   bytes - Data Size: 512 bytes -
> Relative Performance: 0x2 Good
> LBA Format  1 : Metadata Size: 0   bytes - Data Size: 4096 bytes -
> Relative Performance: 0x1 Better (in use)
> 
> I'm not sure, but I think other drives support this too.

Hi Sergey,

Thanks for the hint, let me try on my NVMe SSD :-)


-- 

Coly Li

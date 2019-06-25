Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49F552082
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jun 2019 03:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729894AbfFYB7d (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jun 2019 21:59:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:33656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729601AbfFYB7d (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jun 2019 21:59:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 071ACAB5F;
        Tue, 25 Jun 2019 01:59:31 +0000 (UTC)
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for
 hardware raid5/6
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-block@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
 <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
 <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
 <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
Date:   Tue, 25 Jun 2019 09:59:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/25 2:14 上午, Eric Wheeler wrote:
> On Mon, 24 Jun 2019, Coly Li wrote:
> 
>> On 2019/6/23 7:16 上午, Eric Wheeler wrote:
>>> From: Eric Wheeler <git@linux.ewheeler.net>
>>>
>>> While some drivers set queue_limits.io_opt (e.g., md raid5), there are
>>> currently no SCSI/RAID controller drivers that do.  Previously stripe_size
>>> and partial_stripes_expensive were read-only values and could not be
>>> tuned by users (eg, for hardware RAID5/6).
>>>
>>> This patch enables users to save the optimal IO size via sysfs through
>>> the backing device attributes stripe_size and partial_stripes_expensive
>>> into the bcache superblock.
>>>
>>> Superblock changes are backwards-compatable:
>>>
>>> *  partial_stripes_expensive: One bit was used in the superblock flags field
>>>
>>> *  stripe_size: There are eight 64-bit "pad" fields for future use in
>>>    the superblock which default to 0; from those, 32-bits are now used
>>>    to save the stripe_size and load at device registration time.
>>>
>>> Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
>>
>> Hi Eric,
>>
>> In general I am OK with this patch. Since Peter comments lots of SCSI
>> RAID devices reports a stripe width, could you please list the hardware
>> raid devices which don't list stripe size ? Then we can make decision
>> whether it is necessary to have such option enabled.
> 
> Perhaps they do not set stripe_width using io_opt? I did a grep to see if 
> any of them did, but I didn't see them. How is stripe_width indicated by 
> RAID controllers? 
> 
> If they do set io_opt, then at least my Areca 1883 does not set io_opt as 
> of 4.19.x. I also have a LSI MegaRAID 3108 which does not report io_opt as 
> of 4.1.x, but that is an older kernel so maybe support has been added 
> since then.
> 
> Martin,
> 
> Where would stripe_width be configured in the SCSI drivers? Is it visible 
> through sysfs or debugfs so I can check my hardware support without 
> hacking debugging the kernel?
> 
>>
>> Another point is, this patch changes struct cache_sb, it is no problem
>> to change on-disk format. I plan to update the super block version soon,
>> to store more configuration persistently into super block. stripe_size
>> can be added to cache_sb with other on-disk changes.
> 

Hi Eric,

> Maybe bumping version makes sense, but even if you do not, this is safe to 
> use on systems without bumping the version because the values are unused 
> and default to 0.

Yes, I understand you, it works as you suggested. I need to think how to
organize all options in struct cache_sb, stripe_size will be arranged
then. And I will ask help to you for reviewing the changes of on-disk
format.

Thanks.

[snipped]

-- 

Coly Li

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B707112994
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Dec 2019 11:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfLDKzW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Dec 2019 05:55:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:52978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727445AbfLDKzW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Dec 2019 05:55:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 50AA6B280;
        Wed,  4 Dec 2019 10:55:20 +0000 (UTC)
Subject: Re: [PATCH] bcache: add REQ_FUA to avoid data lost in writeback mode
From:   Coly Li <colyli@suse.de>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     kungf <wings.wyang@gmail.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191202102409.3980-1-wings.wyang@gmail.com>
 <785fe04f-f841-3083-66db-53fab7bc0577@suse.de>
 <alpine.LRH.2.11.1912021932570.11561@mx.ewheeler.net>
 <1a728329-1b12-0ebf-21a4-058ef6f65ead@suse.de>
Organization: SUSE Labs
Message-ID: <2d085823-57ac-dba9-6d2e-1cf01c949875@suse.de>
Date:   Wed, 4 Dec 2019 18:55:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1a728329-1b12-0ebf-21a4-058ef6f65ead@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/3 10:21 下午, Coly Li wrote:
> On 2019/12/3 3:34 上午, Eric Wheeler wrote:
>> On Mon, 2 Dec 2019, Coly Li wrote:
>>> On 2019/12/2 6:24 下午, kungf wrote:
>>>> data may lost when in the follow scene of writeback mode:
>>>> 1. client write data1 to bcache
>>>> 2. client fdatasync
>>>> 3. bcache flush cache set and backing device
>>>> if now data1 was not writed back to backing, it was only guaranteed safe in cache.
>>>> 4.then cache writeback data1 to backing with only REQ_OP_WRITE
>>>> So data1 was not guaranteed in non-volatile storage,  it may lost if  power interruption 
>>>>
>>>
>>> Hi,
>>>
>>> Do you encounter such problem in real work load ? With bcache journal, I
>>> don't see the possibility of data lost with your description.
>>>
>>> Correct me if I am wrong.
>>>
>>> Coly Li
>>
>> If this does become necessary, then we should have a sysfs or superblock 
>> flag to disable FUA for those with RAID BBUs.
> 
> Hi Eric,
> 
> I doubt it is necessary to add FUA tag for all writeback bios, it is
> unnecessary. If power failure happens after dirty data written to
> backing device and the bkey turns into clean, a following read request
> will go to cache device because the LBA can be indexed no matter it is
> dirty or clean. Unless the bkey is invalidated from the B+tree, read
> will always go to cache device firstly in writeback mode. If a power
> failure happens before the cached bkey turns from dirty to clean, just
> an extra writeback bio flushed from cache device to backing device with
> identical data. Comparing the FUA tag for all writeback bios (it will be
> really slow), the extra writeback IOs after a power failure is more
> acceptable to me.

Hi Eric,

I come to realize what the problem is. Yes there is potential
possibility.With FUA the writeback performance will be very low, it is
quite tricky....

Coly Li

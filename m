Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B3D1E088B
	for <lists+linux-bcache@lfdr.de>; Mon, 25 May 2020 10:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbgEYIOc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 May 2020 04:14:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:54498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730769AbgEYIOV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 May 2020 04:14:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E9109AC4A;
        Mon, 25 May 2020 08:14:21 +0000 (UTC)
Subject: Re: [RFC PATCH v4 0/3] bcache: support zoned device as bcache backing
 device
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20200522121837.109651-1-colyli@suse.de>
 <CY4PR04MB3751BEA457F5B95A4D6EFB01E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <f9b8d7a4-2cdb-9c65-81a7-a1fbabb47159@suse.de>
Date:   Mon, 25 May 2020 16:14:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB3751BEA457F5B95A4D6EFB01E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/5/25 13:25, Damien Le Moal wrote:
> On 2020/05/22 21:19, Coly Li wrote:
>> Hi folks,
>>
>> This is series, now bcache can support zoned device (e.g. host managed
>> SMR hard drive) as the backing deice. Currently writeback mode is not
>> support yet, which is on the to-do list (requires on-disk super block
>> format change).
>>
>> The first patch makes bcache to export the zoned information to upper
>> layer code, for example formatting zonefs on top of the bcache device.
>> By default, zone 0 of the zoned device is fully reserved for bcache
>> super block, therefore the reported zones number is 1 less than the
>> exact zones number of the physical SMR hard drive.
>>
>> The second patch handles zone management command for bcache. Indeed
>> these zone management commands are wrappered as zone management bios.
>> For REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL zone management bios,
>> before forwarding the bio to backing device, all cached data covered
>> by the resetting zone(s) must be invalidated to keep data consistency.
>> For rested zone management bios just minus the bi_sector by data_offset
>> and simply forward to the zoned backing device.
>>
>> The third patch is to make sure after bcache device starts, the cache
>> mode cannot be changed to writeback via sysfs interface. Bcache-tools
>> is modified to notice users and convert to writeback mode to the default
>> writethrough mode when making a bcache device.
>>
>> There is one thing not addressed by this series, that is re-write the
>> bcache super block after REQ_OP_ZONE_RESET_ALL command. There will be
>> quite soon that all seq zones device may appear, but it is OK to make
>> bcache support such all seq-zones device a bit later.
>>
>> Now a bcache device created with a zoned SMR drive can pass these test
>> cases,
>> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'
>> - read /sys/block/bcache0/queue/nr_zones, content is number of zones
>>   excluding zone 0 of the backing device (reserved for bcache super
>>   block).
>> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size
>>   in sectors.
>> - run 'blkzone report /dev/bcache0', all zones information displayed.
>> - run 'blkzone reset -o <zone LBA> -c <zones number> /dev/bcache0',
>>   conventional zones will reject the command, seqential zones covered
>>   by the command range will reset its write pointer to start LBA of
>>   their zones. If <zone LBA> is 0 and <zones number> covers all zones,
>>   REQ_OP_ZONE_RESET_ALL command will be received and handled by bcache
>>   device properly.
>> - zonefs can be created on top of the bcache device, with/without cache
>>   device attached. All sequential direct write and random read work well
>>   and zone reset by 'truncate -s 0 <zone file>' works too.
>> - Writeback cache mode does not support yet.
>>
>> Now all prevous code review comments are addressed by this RFC version.
>> Please don't hesitate to offer your opinion on this version.
>>
>> Thanks in advance for your help.
> 
> Coly,
> 
> One more thing: your patch series lacks support for REQ_OP_ZONE_APPEND. It would
> be great to add that. As is, since you do not set the max_zone_append_sectors
> queue limit for the bcache device, that command will not be issued by the block
> layer. But zonefs (and btrfs) will use zone append in (support for zonefs is
> queued already in 5.8, btrfs will come later).

Hi Damien,

Thank you for the suggestion, I will work on it now and post in next
version.

> 
> If bcache writethrough policy results in a data write to be issued to both the
> backend device and the cache device, then some special code will be needed:
> these 2 BIOs will need to be serialized since the actual write location of a
> zone append command is known only on completion of the command. That is, the
> zone append BIO needs to be issued to the backend device first, then to the
> cache SSD device as a regular write once the zone append completes and its write
> location is known.
> 

Copied. It should be OK for bcache. For writethrough mode the data will
be inserted into SSD only after bio to the backing storage accomplished.

Thank you for all your comments, I start to work on your comments on the
series and reply your comments (maybe with more questions) latter.

Coly Li



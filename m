Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D342C1D6EE4
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 04:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgERCc1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 17 May 2020 22:32:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:55212 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgERCc1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 17 May 2020 22:32:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 62A6AAE96;
        Mon, 18 May 2020 02:32:26 +0000 (UTC)
Subject: Re: [RFC PATCH v2 4/4] block: set bi_size to REQ_OP_ZONE_RESET bio
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        Ajay Joshi <Ajay.Joshi@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-5-colyli@suse.de>
 <BY5PR04MB6900FDE1CD0D754084FCCA38E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <4248690d-1be2-3da4-3dec-9d9f3216526e@suse.de>
Date:   Mon, 18 May 2020 10:32:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <BY5PR04MB6900FDE1CD0D754084FCCA38E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/5/18 08:59, Damien Le Moal wrote:
> On 2020/05/16 12:55, Coly Li wrote:
>> Now for zoned device, zone management ioctl commands are converted into
>> zone management bios and handled by blkdev_zone_mgmt(). There are 4 zone
>> management bios are handled, their op code is,
>> - REQ_OP_ZONE_RESET
>>   Reset the zone's writer pointer and empty all previously stored data.
>> - REQ_OP_ZONE_OPEN
>>   Open the zones in the specified sector range, no influence on data.
>> - REQ_OP_ZONE_CLOSE
>>   Close the zones in the specified sector range, no influence on data.
>> - REQ_OP_ZONE_FINISH
>>   Mark the zone as full, no influence on data.
>> All the zone management bios has 0 byte size, a.k.a their bi_size is 0.
>>
>> Exept for REQ_OP_ZONE_RESET request, zero length bio works fine for
>> other zone management bio, before the zoned device e.g. host managed SMR
>> hard drive can be created as a bcache device.
>>
>> When a bcache device (virtual block device to forward bios like md raid
>> drivers) can be created on top of the zoned device, and a fast SSD is
>> attached as a cache device, bcache driver may cache the frequent random
>> READ requests on fast SSD to accelerate hot data READ performance.
>>
>> When bcache driver receives a zone management bio for REQ_OP_ZONE_RESET
>> op, while forwarding the request to underlying zoned device e.g. host
>> managed SMR hard drive, it should also invalidate all cached data from
>> SSD for the resetting zone. Otherwise bcache will continue provide the
>> outdated cached data to READ request and cause potential data storage
>> inconsistency and corruption.
>>
>> In order to invalidate outdated data from SSD for the reset zone, bcache
>> needs to know not only the start LBA but also the range length of the
>> resetting zone. Otherwise, bcache won't be able to accurately invalidate
>> the outdated cached data.
>>
>> Is it possible to simply set the bi_size inside bcache driver? The
>> answer is NO. Although every REQ_OP_ZONE_RESET bio has exact length as
>> zone size or q->limits.chunk_sectors, it is possible that some other
>> layer stacking block driver (in the future) exists between bcache driver
>> and blkdev_zone_mgmt() where the zone management bio is made.
> 
> But bcache "knows" what underlying devices it is using, right ? So getting the
> SMR drive zone size using blk_queue_zone_sectors(), bdev_zone_sectors() or by
> directly accessing q->limits->chunk_sectors should not be a problem at all, no ?
> 
>>
>> The best location to set bi_size is where the zone management bio is
>> composed in blkdev_zone_mgmt(), then no matter how this bio is split
>> before bcache driver receives it, bcache driver can always correctly
>> invalidate the resetting range.
>>
>> This patch sets the bi_size of REQ_OP_ZONE_RESET bio for each resetting
>> zone. Here REQ_OP_ZONE_RESET_ALL is special whose bi_size should be set
>> as capacity of whole drive size, then bcache can invalidate all cached
>> data from SSD for the zoned backing device.
> 
> NACK. The problem here is that struct bio_vec bv_len field and struct bvec_iter
> bi_size field are both "unsigned int". So they can describe at most 4G x 512B =
> 2TB ranges. For REQ_OP_ZONE_RESET_ALL, that is simply way too small (we already
> are at 20TB capacity for SMR). One cannot issue a BIO with a length that is the
> entire disk capacity.
> 
> I really think that bcache should handle the zone management ops as a special
> case. I understand the goal of trying to minimize that by integrating them as
> much as possible into the regular bcache IO path, but that really seems
> dangerous to me. Since these operations will need remapping in bcache anyway
> (for handling the first hidden zone containing the super block), all special
> processing can be done under a single "if" which should not impact too much
> performance of regular read/write commands in the hot path.
> 
> Device mapper has such code: see __split_and_process_bio() and its use of
> op_is_zone_mgmt() function to handle zone management requests slightly
> differently than other BIOs. That remove the need for relying on op_is_write()
> direction (patch 1 and 2 in this series) for reset zones too, which in the end
> will I think make your bcache code a lot more solid.
> 

Copied. I understand and agree with you and Christoph now. Let me
reconstruct the bcache code and maybe the depended change of generic
block layer code can be avoided.

Damien and Christoph, thank you all for the comments.

Coly Li

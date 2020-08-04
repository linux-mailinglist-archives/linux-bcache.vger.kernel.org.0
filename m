Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F0823BC86
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Aug 2020 16:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgHDOpe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Aug 2020 10:45:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:59502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729259AbgHDOp0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Aug 2020 10:45:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83520ACB7;
        Tue,  4 Aug 2020 14:45:40 +0000 (UTC)
Subject: Re: [PATCH] block: tolerate 0 byte discard_granularity in
 __blkdev_issue_discard()
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>, Xiao Ni <xni@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Evan Green <evgreen@chromium.org>
References: <20200804142332.29961-1-colyli@suse.de>
 <SN4PR0401MB3598033FF16A5AE1D375EDD69B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <b469f0ec-0185-c624-b967-5080d805040c@suse.de>
 <SN4PR0401MB35983A30C6AE9886EF6E91C79B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <SN4PR0401MB35984D6090CE1B7F1FD06CD59B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <06f2bb53-8917-82d6-3e0c-76270cd80e06@suse.de>
Date:   Tue, 4 Aug 2020 22:45:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB35984D6090CE1B7F1FD06CD59B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/8/4 22:39, Johannes Thumshirn wrote:
> On 04/08/2020 16:37, Johannes Thumshirn wrote:
>> On 04/08/2020 16:34, Coly Li wrote:
>>> On 2020/8/4 22:31, Johannes Thumshirn wrote:
>>>> On 04/08/2020 16:23, Coly Li wrote:
>>>>> This is the procedure to reproduce the panic,
>>>>>   # modprobe scsi_debug delay=0 dev_size_mb=2048 max_queue=1
>>>>>   # losetup -f /dev/nvme0n1 --direct-io=on
>>>>>   # blkdiscard /dev/loop0 -o 0 -l 0x200
>>>>
>>>> losetup -f /dev/sdX isn't it?
>>>>
>>>
>>> In my case, I use a NVMe SSD as the backing device of the loop device.
>>> Because I don't have a scsi lun.
>>>
>>> And loading scsi_debug module seems necessary, otherwise the discard
>>> process just hang and I cannot see the kernel panic (I don't know why yet).
>>
>> OK, now that's highly interesting. Does it also happen if you back loop with
>> a file? loop_config_discard() has different cases for the different backing devices/files. S
>>
> 
> Damn I didn't want to hit sent....
> 
> Does this (untested) change make a difference:
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 475e1a738560..8a07a89d702e 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -895,6 +895,9 @@ static void loop_config_discard(struct loop_device *lo)
>                 blk_queue_max_write_zeroes_sectors(q,
>                         backingq->limits.max_write_zeroes_sectors);
>  
> +               q->limits.discard_granularity =
> +                       backingq->limits.discard_granularity;
> +
>         /*
>          * We use punch hole to reclaim the free space used by the
>          * image a.k.a. discard. However we do not support discard if
> 

Yes, Ming just posts a patch with a very similar change to loop device
driver.

Coly Li

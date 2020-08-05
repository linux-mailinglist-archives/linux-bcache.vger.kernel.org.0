Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417D523C3B9
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Aug 2020 04:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHECw1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Aug 2020 22:52:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:56248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgHECw0 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Aug 2020 22:52:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 624C6ABEF;
        Wed,  5 Aug 2020 02:52:41 +0000 (UTC)
Subject: Re: [PATCH] block: tolerate 0 byte discard_granularity in
 __blkdev_issue_discard()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Xiao Ni <xni@redhat.com>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Evan Green <evgreen@chromium.org>
References: <20200804142332.29961-1-colyli@suse.de>
 <20200804235811.GA1981569@T590>
 <f9da9db8-d60b-3974-92cd-c8c5f2634acd@suse.de>
 <20200805024613.GB1981569@T590>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <44503c40-5ead-3d07-ee81-150cbc8586e3@suse.de>
Date:   Wed, 5 Aug 2020 10:52:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200805024613.GB1981569@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/8/5 10:46, Ming Lei wrote:
> On Wed, Aug 05, 2020 at 09:54:00AM +0800, Coly Li wrote:
>> On 2020/8/5 07:58, Ming Lei wrote:
>>> On Tue, Aug 04, 2020 at 10:23:32PM +0800, Coly Li wrote:
>>>> When some buggy driver doesn't set its queue->limits.discard_granularity
>>>> (e.g. current loop device driver), discard at LBA 0 on such device will
>>>> trigger a kernel BUG() panic from block/blk-mq.c:563.
>>>>
>>>> [  955.565006][   C39] ------------[ cut here ]------------
>>>> [  955.559660][   C39] invalid opcode: 0000 [#1] SMP NOPTI
>>>> [  955.622171][   C39] CPU: 39 PID: 248 Comm: ksoftirqd/39 Tainted: G            E     5.8.0-default+ #40
>>>> [  955.622171][   C39] Hardware name: Lenovo ThinkSystem SR650 -[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE160M-2.70]- 07/17/2020
>>>> [  955.622175][   C39] RIP: 0010:blk_mq_end_request+0x107/0x110
>>>> [  955.622177][   C39] Code: 48 8b 03 e9 59 ff ff ff 48 89 df 5b 5d 41 5c e9 9f ed ff ff 48 8b 35 98 3c f4 00 48 83 c7 10 48 83 c6 19 e8 cb 56 c9 ff eb cb <0f> 0b 0f 1f 80 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 56 41 54
>>>> [  955.622179][   C39] RSP: 0018:ffffb1288701fe28 EFLAGS: 00010202
>>>> [  955.749277][   C39] RAX: 0000000000000001 RBX: ffff956fffba5080 RCX: 0000000000004003
>>>> [  955.749278][   C39] RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000000
>>>> [  955.749279][   C39] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>>> [  955.749279][   C39] R10: ffffb1288701fd28 R11: 0000000000000001 R12: ffffffffa8e05160
>>>> [  955.749280][   C39] R13: 0000000000000004 R14: 0000000000000004 R15: ffffffffa7ad3a1e
>>>> [  955.749281][   C39] FS:  0000000000000000(0000) GS:ffff95bfbda00000(0000) knlGS:0000000000000000
>>>> [  955.749282][   C39] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [  955.749282][   C39] CR2: 00007f6f0ef766a8 CR3: 0000005a37012002 CR4: 00000000007606e0
>>>> [  955.749283][   C39] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> [  955.749284][   C39] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> [  955.749284][   C39] PKRU: 55555554
>>>> [  955.749285][   C39] Call Trace:
>>>> [  955.749290][   C39]  blk_done_softirq+0x99/0xc0
>>>> [  957.550669][   C39]  __do_softirq+0xd3/0x45f
>>>> [  957.550677][   C39]  ? smpboot_thread_fn+0x2f/0x1e0
>>>> [  957.550679][   C39]  ? smpboot_thread_fn+0x74/0x1e0
>>>> [  957.550680][   C39]  ? smpboot_thread_fn+0x14e/0x1e0
>>>> [  957.550684][   C39]  run_ksoftirqd+0x30/0x60
>>>> [  957.550687][   C39]  smpboot_thread_fn+0x149/0x1e0
>>>> [  957.886225][   C39]  ? sort_range+0x20/0x20
>>>> [  957.886226][   C39]  kthread+0x137/0x160
>>>> [  957.886228][   C39]  ? kthread_park+0x90/0x90
>>>> [  957.886231][   C39]  ret_from_fork+0x22/0x30
>>>> [  959.117120][   C39] ---[ end trace 3dacdac97e2ed164 ]---
>>>>
>>>> This is the procedure to reproduce the panic,
>>>>   # modprobe scsi_debug delay=0 dev_size_mb=2048 max_queue=1
>>>>   # losetup -f /dev/nvme0n1 --direct-io=on
>>>>   # blkdiscard /dev/loop0 -o 0 -l 0x200
>>>>
>>>> This is how the BUG() panic triggered by __blkdev_issue_discard(),
>>>> - For a NVMe SSD backing loop device, the driver does not initialize
>>>>   its queue->limits.discard_granularity and leaves it to 0.
>>>> - When discard on LBA 0 of the loop device, __blkdev_issue_discard()
>>>>   is called before loop device driver code.
>>>> - Inside __blkdev_issue_discard(), when calculating value of
>>>>   granularity_aligned_lba by
>>>> 	granularity_aligned_lba = round_up(sector_mapped,
>>>> 			q->limits.discard_granularity >> SECTOR_SHIFT);
>>>>   because sector_mapped is 0 (at LBA 0 and no partition offset), and
>>>>   q->limits.discard_granularity is 0 (by the buggy loop driver), the
>>>>   calculated granularity_aligned_lba is 0.
>>>> - The inline function bio_aligned_discard_max_sectors() is defined as
>>>> 	return round_down(UINT_MAX, q->limits.discard_granularity) >>
>>>> 			SECTOR_SHIFT;
>>>>    when q->limits.discard_granularity is 0 from loop device driver, the
>>>>    above calculation returns value 0.
>>>> - Now granularity_aligned_lba and sctor_mapped are 0, req_sectors is
>>>>   calculated by the following lines in __blkdev_issue_discard(),
>>>> 	if (granularity_aligned_lba == sector_mapped)
>>>> 		req_sects = min_t(sector_t, nr_sects,
>>>> 				  bio_aligned_discard_max_sectors(q));
>>>>   because bio_aligned_discard_max_sectors(q) returns 0, req_sects is
>>>>   calculated as 0.
>>>> - Now a discard bio is mistakenly initialized as a 0 byte bio by,
>>>> 	bio->bi_iter.bi_size = req_sects << 9;
>>>>   and sent to loop device driver.
>>>> - This discard request is handled by loop device driver by following
>>>>   code path,
>>>>     loop_handle_cmd => do_req_filebacked => lo_fallocate =>
>>>>     file->f_op->fallocate => blkdev_fallocate => blkdev_issue_zeroout =>
>>>>     __blkdev_issue_write_zeroes
>>>> - Inside __blkdev_issue_write_zeroes(), a 0 byte length discard bio is
>>>>   composed and sent to the backing device of the loop device.
>>>> - In the I/O completion code path, in my case it is,
>>>>     blk_done_softirq => nrq->q->mq_ops->complete => nvme_pci_complete_rq
>>>>     => nvme_complete_rq => blk_mq_end_request
>>>>   inside blk_mq_end_request(), blk_update_request() is called and due to
>>>>   req->bio is NULL in previous step, blk_update_request() returns false
>>>>   then the BUG() panic in blk_mq_end_request() is triggered.
>>>>
>>>> Although the above panic can be fixed in loop device driver, the generic
>>>> __blkdev_issue_discard() should also be fixed to tolerate the incorrect
>>>> 0 value from queue->limits.discard_granularity, in case some other buggy
>>>> driver makes such mistake again.
>>>>
>>>> This patch checks whether q->limits.discard_granularity is 0 in
>>>> __blkdev_issue_discard() and bio_aligned_discard_max_sectors(). If it is
>>>> 0 from some buggy driver queue, prints a warning oops information and
>>>> set queue_logical_block_size(q) to a local variable discard_granularity.
>>>> This local variable is used in round_up() and round_down() calculation,
>>>> now req_sects won't be 0  and no empty discard request is generated.
>>>>
>>>> Fixes: 9b15d109a6b2 ("block: improve discard bio alignment in __blkdev_issue_discard()")
>>>> Fixes: c52abf563049 ("loop: Better discard support for block devices")
>>>> Reported-by: Ming Lei <ming.lei@redhat.com>
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> Cc: Hannes Reinecke <hare@suse.com>
>>>> Cc: Ming Lei <ming.lei@redhat.com>
>>>> Cc: Xiao Ni <xni@redhat.com>
>>>> Cc: Bart Van Assche <bvanassche@acm.org>
>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>> Cc: Enzo Matsumiya <ematsumiya@suse.com>
>>>> Cc: Jens Axboe <axboe@kernel.dk>
>>>> Cc: Evan Green <evgreen@chromium.org>
>>>> ---
>>>>  block/blk-lib.c | 8 +++++++-
>>>>  block/blk.h     | 9 +++++++--
>>>>  2 files changed, 14 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>>>> index 019e09bb9c0e..3017e4cba923 100644
>>>> --- a/block/blk-lib.c
>>>> +++ b/block/blk-lib.c
>>>> @@ -30,6 +30,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>>>>  	struct bio *bio = *biop;
>>>>  	unsigned int op;
>>>>  	sector_t bs_mask, part_offset = 0;
>>>> +	sector_t discard_granularity;
>>>>  
>>>>  	if (!q)
>>>>  		return -ENXIO;
>>>> @@ -54,6 +55,11 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>>>>  	if (!nr_sects)
>>>>  		return -EINVAL;
>>>>  
>>>> +	discard_granularity = q->limits.discard_granularity;
>>>> +	/* In case some buggy driver does not set limits.discard_granularity */
>>>> +	if (WARN_ON_ONCE(discard_granularity == 0))
>>>> +		discard_granularity = queue_logical_block_size(q);
>>>
>>> This code path is supposed to not run in case of zero q->limits.discard_granularity,
>>> and looks it is fine to just warn and return -EINVAL in this case,
>>> see Documentation/ABI/testing/sysfs-block:
>>>
>>> 	What:       /sys/block/<disk>/queue/discard_granularity
>>> 	Date:       May 2011
>>> 	Contact:    Martin K. Petersen <martin.petersen@oracle.com>
>>> 	Description:
>>> 	        Devices that support discard functionality may
>>> 	        internally allocate space using units that are bigger
>>> 	        than the logical block size. The discard_granularity
>>> 	        parameter indicates the size of the internal allocation
>>> 	        unit in bytes if reported by the device. Otherwise the
>>> 	        discard_granularity will be set to match the device's
>>> 	        physical block size. A discard_granularity of 0 means
>>> 	        that the device does not support discard functionality.
>>>
>>> What we need to fix is loop driver, if it claims to support discard,
>>> q->limits.discard_granularity has to be one valid value.
>>
>> Yes your suggestion is much simpler, let me do it :-)
> 
> That is exactly what the following patch does:
> 
> https://lore.kernel.org/linux-block/6f642b8a-648e-8b59-067f-6c9f4cc32fa6@suse.de/T/#m82a878277ae7ed6b7a595820112fd13beaa24c99

I meant your suggestion in __blkdev_issue_discard(), in case some other
buggy driver does similar fault in future. Now the v2 patch is much
simpler, please review it and thank you in advance :-)

Coly Li

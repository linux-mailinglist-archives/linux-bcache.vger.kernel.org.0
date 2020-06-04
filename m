Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227EA1EDA10
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jun 2020 02:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgFDAlM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Jun 2020 20:41:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:54086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728061AbgFDAlL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Jun 2020 20:41:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F13EBB16B;
        Thu,  4 Jun 2020 00:41:12 +0000 (UTC)
To:     Mauricio Faria de Oliveira <mfo@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
References: <20200603160310.499252-1-mfo@canonical.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Subject: Re: [PATCH] bcache: check and adjust logical block size for backing
 devices
Message-ID: <c4442cda-941c-c697-f7d5-b9121c780f45@suse.de>
Date:   Thu, 4 Jun 2020 08:40:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603160310.499252-1-mfo@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/6/4 00:03, Mauricio Faria de Oliveira wrote:
> It's possible for a block driver to set logical block size to
> a value greater than page size incorrectly; e.g. bcache takes
> the value from the superblock, set by the user w/ make-bcache.
> 
> This causes a BUG/NULL pointer dereference in the path:
> 
>   __blkdev_get()
>   -> set_init_blocksize() // set i_blkbits based on ...
>      -> bdev_logical_block_size()
>         -> queue_logical_block_size() // ... this value
>   -> bdev_disk_changed()
>      ...
>      -> blkdev_readpage()
>         -> block_read_full_page()
>            -> create_page_buffers() // size = 1 << i_blkbits
>               -> create_empty_buffers() // give size/take pointer
>                  -> alloc_page_buffers() // return NULL
>                  .. BUG!
> 
> Because alloc_page_buffers() is called with size > PAGE_SIZE,
> thus it initializes head = NULL, skips the loop, return head;
> then create_empty_buffers() gets (and uses) the NULL pointer.
> 
> This has been around longer than commit ad6bf88a6c19 ("block:
> fix an integer overflow in logical block size"); however, it
> increased the range of values that can trigger the issue.
> 
> Previously only 8k/16k/32k (on x86/4k page size) would do it,
> as greater values overflow unsigned short to zero, and queue_
> logical_block_size() would then use the default of 512.
> 
> Now the range with unsigned int is much larger, and users w/
> the 512k value, which happened to be zero'ed previously and
> work fine, started to hit this issue -- as the zero is gone,
> and queue_logical_block_size() does return 512k (>PAGE_SIZE.)
> 
> Fix this by checking the bcache device's logical block size,
> and if it's greater than page size, fallback to the backing/
> cached device's logical page size.
> 
> This doesn't affect cache devices as those are still checked
> for block/page size in read_super(); only the backing/cached
> devices are not.
> 
> Apparently it's a regression from commit 2903381fce71 ("bcache:
> Take data offset from the bdev superblock."), moving the check
> into BCACHE_SB_VERSION_CDEV only. Now that we have superblocks
> of backing devices out there with this larger value, we cannot
> refuse to load them (i.e., have a similar check in _BDEV.)
> 
> Ideally perhaps bcache should use all values from the backing
> device (physical/logical/io_min block size)? But for now just
> fix the problematic case.
> 
> Test-case:
> 
>     # IMG=/root/disk.img
>     # dd if=/dev/zero of=$IMG bs=1 count=0 seek=1G
>     # DEV=$(losetup --find --show $IMG)
>     # make-bcache --bdev $DEV --block 8k
>       < see dmesg >
> 
> Before:
> 
>     # uname -r
>     5.7.0-rc7
> 
>     [   55.944046] BUG: kernel NULL pointer dereference, address: 0000000000000000
>     ...
>     [   55.949742] CPU: 3 PID: 610 Comm: bcache-register Not tainted 5.7.0-rc7 #4
>     ...
>     [   55.952281] RIP: 0010:create_empty_buffers+0x1a/0x100
>     ...
>     [   55.966434] Call Trace:
>     [   55.967021]  create_page_buffers+0x48/0x50
>     [   55.967834]  block_read_full_page+0x49/0x380
>     [   55.972181]  do_read_cache_page+0x494/0x610
>     [   55.974780]  read_part_sector+0x2d/0xaa
>     [   55.975558]  read_lba+0x10e/0x1e0
>     [   55.977904]  efi_partition+0x120/0x5a6
>     [   55.980227]  blk_add_partitions+0x161/0x390
>     [   55.982177]  bdev_disk_changed+0x61/0xd0
>     [   55.982961]  __blkdev_get+0x350/0x490
>     [   55.983715]  __device_add_disk+0x318/0x480
>     [   55.984539]  bch_cached_dev_run+0xc5/0x270
>     [   55.986010]  register_bcache.cold+0x122/0x179
>     [   55.987628]  kernfs_fop_write+0xbc/0x1a0
>     [   55.988416]  vfs_write+0xb1/0x1a0
>     [   55.989134]  ksys_write+0x5a/0xd0
>     [   55.989825]  do_syscall_64+0x43/0x140
>     [   55.990563]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     [   55.991519] RIP: 0033:0x7f7d60ba3154
>     ...
> 
> After:
> 
>     # uname -r
>     5.7.0.bcachelbspgsz
> 
>     [   31.672460] bcache: bcache_device_init() bcache0: sb/logical block size (8192) greater than page size (4096) falling back to device logical block size (512)
>     [   31.675133] bcache: register_bdev() registered backing device loop0
> 
>     # grep ^ /sys/block/bcache0/queue/*_block_size
>     /sys/block/bcache0/queue/logical_block_size:512
>     /sys/block/bcache0/queue/physical_block_size:8192
> 
> Reported-by: Ryan Finnie <ryan@finnie.org>
> Reported-by: Sebastian Marsching <sebastian@marsching.com>
> Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
> ---
>  drivers/md/bcache/super.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index d98354fa28e3..d0af298d39ba 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -816,7 +816,8 @@ static void bcache_device_free(struct bcache_device *d)
>  }
>  
>  static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> -			      sector_t sectors, make_request_fn make_request_fn)
> +			      sector_t sectors, make_request_fn make_request_fn,
> +			      struct block_device *cached_bdev)
>  {
>  	struct request_queue *q;
>  	const size_t max_stripes = min_t(size_t, INT_MAX,
> @@ -882,6 +883,21 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	q->limits.io_min		= block_size;
>  	q->limits.logical_block_size	= block_size;
>  	q->limits.physical_block_size	= block_size;
> +
> +	if (q->limits.logical_block_size > PAGE_SIZE && cached_bdev) {
> +		/*
> +		 * This should only happen with BCACHE_SB_VERSION_BDEV.
> +		 * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
> +		 */
> +		pr_info("%s: sb/logical block size (%u) greater than page size "
> +			"(%lu) falling back to device logical block size (%u)",
> +			d->disk->disk_name, q->limits.logical_block_size,
> +			PAGE_SIZE, bdev_logical_block_size(cached_bdev));
> +
> +		/* This also adjusts physical block size/min io size if needed */
> +		blk_queue_logical_block_size(q, bdev_logical_block_size(cached_bdev));
> +	}
> +
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
>  	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
>  	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);
> @@ -1339,7 +1355,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  
>  	ret = bcache_device_init(&dc->disk, block_size,
>  			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
> -			 cached_dev_make_request);
> +			 cached_dev_make_request, dc->bdev);
>  	if (ret)
>  		return ret;
>  
> @@ -1452,7 +1468,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>  	kobject_init(&d->kobj, &bch_flash_dev_ktype);
>  
>  	if (bcache_device_init(d, block_bytes(c), u->sectors,
> -			flash_dev_make_request))
> +			flash_dev_make_request, NULL))
>  		goto err;
>  
>  	bcache_device_attach(d, c, u - c->uuids);
> 

Hi Mauricio,

Thank you for this good catch. I am OK with the analysis, but I prefer
to check the block_size when reading backing device super block. Such
check can be added after this code piece in read_super(),

 117         err = "Superblock block size smaller than device block size";
 118         if (sb->block_size << 9 < bdev_logical_block_size(bdev))
 119                 goto err;

My opinion is, if there is a illegal value in on-disk super block, we
should fail the registration and report it immediately, it is better
then keep it and implicitly fix the value in memory.

BTW, would you like to patch the bcache-tools as well against,
https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/

Then we can also prevent people create incorrect block size in creating
time.

After all, great catch, thank you :-)

Coly Li


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B64C1CD195
	for <lists+linux-bcache@lfdr.de>; Mon, 11 May 2020 08:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgEKGFr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 11 May 2020 02:05:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:42344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgEKGFr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 11 May 2020 02:05:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F074DB19D;
        Mon, 11 May 2020 06:05:47 +0000 (UTC)
Subject: Re: [RFC PATCH v2] bcache: export zoned information for backing
 device
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20200510165232.67500-1-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8204e985-3251-d4fa-27f1-f0e028d1629f@suse.de>
Date:   Mon, 11 May 2020 08:05:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200510165232.67500-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/10/20 6:52 PM, Coly Li wrote:
> This is a very basic zoned device support. With this patch, bcache
> device is able to,
> - Export zoned device attribution via sysfs
> - Response report zones request, e.g. by command 'blkzone report'
> But the bcache device is still NOT able to,
> - Response any zoned device management request or IOCTL command
> 
> Here are the testings I have done,
> - read /sys/block/bcache0/queue/zoned, content is 'host-managed'
> - read /sys/block/bcache0/queue/nr_zones, content is number of zones
>    including all zone types.
> - read /sys/block/bcache0/queue/chunk_sectors, content is zone size
>    in sectors.
> - run 'blkzone report /dev/bcache0', all zones information displayed.
> - run 'blkzone reset /dev/bcache0', operation is rejected with error
>    information: "blkzone: /dev/bcache0: BLKRESETZONE ioctl failed:
>    Operation not supported"
> - Sequential writes by dd, I can see some zones' write pointer 'wptr'
>    values updated.
> 
> All of these are very basic testings, if you have better testing
> tools or cases, please offer me hint.
> 
> Thanks in advance for your review and comments.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> CC: Hannes Reinecke <hare@suse.com>
> CC: Damien Le Moal <damien.lemoal@wdc.com>
> CC: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   drivers/md/bcache/bcache.h  | 10 +++++
>   drivers/md/bcache/request.c | 74 +++++++++++++++++++++++++++++++++++++
>   drivers/md/bcache/super.c   | 51 +++++++++++++++++++++----
>   3 files changed, 128 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 74a9849ea164..0d298b48707f 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -221,6 +221,7 @@ BITMASK(GC_MOVE, struct bucket, gc_mark, 15, 1);
>   struct search;
>   struct btree;
>   struct keybuf;
> +struct bch_report_zones_args;
>   
>   struct keybuf_key {
>   	struct rb_node		node;
> @@ -277,6 +278,8 @@ struct bcache_device {
>   			  struct bio *bio, unsigned int sectors);
>   	int (*ioctl)(struct bcache_device *d, fmode_t mode,
>   		     unsigned int cmd, unsigned long arg);
> +	int (*report_zones)(struct bch_report_zones_args *args,
> +			    unsigned int nr_zones);
>   };
>   
>   struct io {
> @@ -748,6 +751,13 @@ struct bbio {
>   	struct bio		bio;
>   };
>   
> +struct bch_report_zones_args {
> +	struct bcache_device *bcache_device;
> +	sector_t sector;
> +	void *orig_data;
> +	report_zones_cb orig_cb;
> +};
> +
>   #define BTREE_PRIO		USHRT_MAX
>   #define INITIAL_PRIO		32768U
>   
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 71a90fbec314..bd50204caac7 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1190,6 +1190,19 @@ blk_qc_t cached_dev_make_request(struct request_queue *q, struct bio *bio)
>   		}
>   	}
>   
> +	/*
> +	 * zone management request may change the data layout and content
> +	 * implicitly on backing device, which introduces unacceptible
> +	 * inconsistency between the backing device and the cache device.
> +	 * Therefore all zone management related request will be denied here.
> +	 */
> +	if (op_is_zone_mgmt(bio->bi_opf)) {
> +		pr_err_ratelimited("zoned device management request denied.");
> +		bio->bi_status = BLK_STS_NOTSUPP;
> +		bio_endio(bio);
> +		return BLK_QC_T_NONE;
> +	}
> +
>   	generic_start_io_acct(q,
>   			      bio_op(bio),
>   			      bio_sectors(bio),
> @@ -1233,6 +1246,24 @@ static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
>   	if (dc->io_disable)
>   		return -EIO;
>   
> +	/*
> +	 * zone management ioctl commands may change the data layout
> +	 * and content implicitly on backing device, which introduces
> +	 * unacceptible inconsistency between the backing device and
> +	 * the cache device. Therefore all zone management related
> +	 * ioctl commands will be denied here.
> +	 */
> +	switch (cmd) {
> +	case BLKRESETZONE:
> +	case BLKOPENZONE:
> +	case BLKCLOSEZONE:
> +	case BLKFINISHZONE:
> +		return -EOPNOTSUPP;
> +	default:
> +		/* Other commands fall through*/
> +		break;
> +	}
> +
>   	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
>   }
>   
> @@ -1261,6 +1292,48 @@ static int cached_dev_congested(void *data, int bits)
>   	return ret;
>   }
>   
> +static int cached_dev_report_zones_cb(struct blk_zone *zone,
> +				      unsigned int idx,
> +				      void *data)
> +{
> +	struct bch_report_zones_args *args = data;
> +	struct bcache_device *d = args->bcache_device;
> +	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> +	unsigned long data_offset = dc->sb.data_offset;
> +
> +	if (zone->start >= data_offset) {
> +		zone->start -= data_offset;
> +		zone->wp -= data_offset;
> +	} else {
> +		/*
> +		 * Normally the first zone is conventional zone,
> +		 * we don't need to worry about how to maintain
> +		 * the write pointer.
> +		 * But the zone->len is special, because the
> +		 * sector 0 on bcache device is 8KB offset on
> +		 * backing device indeed.
> +		 */
> +		zone->len -= data_offset;
> +	}
> +
> +	return args->orig_cb(zone, idx, args->orig_data);
> +}
> +
Well, I'm afraid that this is not going to work.
For SMR drives only the _last_ sector may be of a different length than 
the other sectors (specifications vary, but implementations do follow 
this model).
So either you blank out the first zone completely (and modify each and 
every zone in the report zones output) or you move the metadata to the 
last zone (but then this zone might be sequential, requiring even more 
changes to the metadata).

So all things considered I guess the easiest way would be to blank out 
the first zone...

> +static int cached_dev_report_zones(struct bch_report_zones_args *args,
> +				   unsigned int nr_zones)
> +{
> +	struct bcache_device *d = args->bcache_device;
> +	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
> +	sector_t sector = args->sector + dc->sb.data_offset;
> +
> +	/* sector is real LBA of backing device */
> +	return blkdev_report_zones(dc->bdev,
> +				   sector,
> +				   nr_zones,
> +				   cached_dev_report_zones_cb,
> +				   args);
> +}
> +
>   void bch_cached_dev_request_init(struct cached_dev *dc)
>   {
>   	struct gendisk *g = dc->disk.disk;
> @@ -1268,6 +1341,7 @@ void bch_cached_dev_request_init(struct cached_dev *dc)
>   	g->queue->backing_dev_info->congested_fn = cached_dev_congested;
>   	dc->disk.cache_miss			= cached_dev_cache_miss;
>   	dc->disk.ioctl				= cached_dev_ioctl;
> +	dc->disk.report_zones			= cached_dev_report_zones;
>   }
>   
>   /* Flash backed devices */
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index d98354fa28e3..b7d496040cee 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -679,10 +679,31 @@ static int ioctl_dev(struct block_device *b, fmode_t mode,
>   	return d->ioctl(d, mode, cmd, arg);
>   }
>   
> +static int report_zones_dev(struct gendisk *disk,
> +			    sector_t sector,
> +			    unsigned int nr_zones,
> +			    report_zones_cb cb,
> +			    void *data)
> +{
> +	struct bcache_device *d = disk->private_data;
> +	struct bch_report_zones_args args = {
> +		.bcache_device = d,
> +		.sector = sector,
> +		.orig_data = data,
> +		.orig_cb = cb,
> +	};
> +
> +	if (d->report_zones)
> +		return d->report_zones(&args, nr_zones);
> +
> +	return -EOPNOTSUPP;
> +}
> +
>   static const struct block_device_operations bcache_ops = {
>   	.open		= open_dev,
>   	.release	= release_dev,
>   	.ioctl		= ioctl_dev,
> +	.report_zones	= report_zones_dev,
>   	.owner		= THIS_MODULE,
>   };
>   
> @@ -815,8 +836,12 @@ static void bcache_device_free(struct bcache_device *d)
>   	closure_debug_destroy(&d->cl);
>   }
>   
> -static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> -			      sector_t sectors, make_request_fn make_request_fn)
> +static int bcache_device_init(struct cached_dev *dc,
> +			      struct bcache_device *d,
> +			      unsigned int block_size,
> +			      sector_t sectors,
> +			      make_request_fn make_request_fn)
> +
>   {
>   	struct request_queue *q;
>   	const size_t max_stripes = min_t(size_t, INT_MAX,
> @@ -886,6 +911,17 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>   	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
>   	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);
>   
> +	/*
> +	 * If this is for backing device registration, and it is an
> +	 * zoned device (e.g. host-managed S.M.R. hard drive), set
> +	 * up zoned device attribution properly for sysfs interface.
> +	 */
> +	if (dc && bdev_is_zoned(dc->bdev)) {
> +		q->limits.zoned = bdev_zoned_model(dc->bdev);
> +		q->nr_zones = blkdev_nr_zones(dc->bdev->bd_disk);
> +		q->limits.chunk_sectors = bdev_zone_sectors(dc->bdev);
> +	}
> +
>   	blk_queue_write_cache(q, true, true);
>   
>   	return 0;
> @@ -1337,9 +1373,9 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>   		dc->partial_stripes_expensive =
>   			q->limits.raid_partial_stripes_expensive;
>   
> -	ret = bcache_device_init(&dc->disk, block_size,
> -			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
> -			 cached_dev_make_request);
> +	ret = bcache_device_init(dc, &dc->disk, block_size,
> +			dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
> +			cached_dev_make_request);
>   	if (ret)
>   		return ret;
>   

If you already pass in 'dc' as argument, can't you drop '&dc->disk' as 
argument?

> @@ -1451,8 +1487,9 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>   
>   	kobject_init(&d->kobj, &bch_flash_dev_ktype);
>   
> -	if (bcache_device_init(d, block_bytes(c), u->sectors,
> -			flash_dev_make_request))
> +	if (bcache_device_init(NULL, d, block_bytes(c),
> +			       u->sectors,
> +			       flash_dev_make_request))
>   		goto err;
>   
>   	bcache_device_attach(d, c, u - c->uuids);
> 
Ah. Hmm. Probably not. Ignore my previous comment.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

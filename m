Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6926C1EA3F4
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Jun 2020 14:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgFAMeu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Jun 2020 08:34:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:48094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgFAMet (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Jun 2020 08:34:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0190CAFDB;
        Mon,  1 Jun 2020 12:34:47 +0000 (UTC)
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
References: <20200522121837.109651-1-colyli@suse.de>
 <20200522121837.109651-2-colyli@suse.de>
 <CY4PR04MB37519681E8730119C1C74A75E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Subject: Re: [RFC PATCH v4 1/3] bcache: export bcache zone information for
 zoned backing device
Message-ID: <1c124ebe-3f1c-6715-0c1b-245ae18ec012@suse.de>
Date:   Mon, 1 Jun 2020 20:34:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB37519681E8730119C1C74A75E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/5/25 09:10, Damien Le Moal wrote:
> On 2020/05/22 21:18, Coly Li wrote:
[snip]>> zone files, 523 of them are for convential zones (1 zone is
reserved
> 
> s/convential/conventional
> 
>> for bcache super block and not reported), 51632 of them are for
>> sequential zones.
>>
>> First run to read first 4KB from all the zone files with 50 processes,
>> it takes 5 minutes 55 seconds. Second run takes 12 seconds only because
>> all the read requests hit on cache device.
> 

Hi Damien,

> Did you write anything first to the bcache device ? Otherwise, all zonefs files
> will be empty and there is not going to be any file access... Question though:
> when writing to a bcache device with writethrough mode, does the data go to the
> SSD cache too ? Or is it written only to the backend device ?
> 

Yes, I did. For all random and sequential zone files, I write 8KB on
their head and read back 4KB from offset 0 of each zone files.

In my test case, all data will first go into backing device, after
completed they will be inserted into SSD. The order is guaranteed by
bcache code.

>>
>> 29 times faster is as expected for an ideal case when all READ I/Os hit
>> on NVMe cache device.
>>
>> Besides providing report_zones method of the bcache gendisk structure,
>> this patch also initializes the following zoned device attribution for
>> the bcache device,
>> - zones number: the total zones number minus reserved zone(s) for bcache
> 
> s/zones number/number of zones
> 
>>   super block.
>> - zone size: same size as reported from the underlying zoned device
>> - zone mode: same mode as reported from the underlying zoned device
> 
> s/zone mode/zoned model
> 
>> Currently blk_revalidate_disk_zones() does not accept non-mq drivers, so
>> all the above attribution are initialized mannally in bcache code.
> 
> s/mannally/manually
> 
>>
>> This patch just provides the report_zones method only. Handling all zone
>> management commands will be addressed in following patches.
>>

The above typos will be fixed in next version.


>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Damien Le Moal <damien.lemoal@wdc.com>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>> Changelog:
>> v4: the version without any generic block layer change.
>> v3: the version depends on other generic block layer changes.
>> v2: an improved version for comments.
>> v1: initial version.
>>  drivers/md/bcache/bcache.h  | 10 ++++
>>  drivers/md/bcache/request.c | 69 ++++++++++++++++++++++++++
>>  drivers/md/bcache/super.c   | 96 ++++++++++++++++++++++++++++++++++++-
>>  3 files changed, 174 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
>> index 74a9849ea164..0d298b48707f 100644
>> --- a/drivers/md/bcache/bcache.h
>> +++ b/drivers/md/bcache/bcache.h

[snip]
>>  
>> +/*
>> + * The callback routine to parse a specific zone from all reporting
>> + * zones. args->orig_cb() is the upper layer report zones callback,
>> + * which should be called after the LBA conversion.
>> + * Notice: all zones after zone 0 will be reported, including the
>> + * offlined zones, how to handle the different types of zones are
>> + * fully decided by upper layer who calss for reporting zones of
>> + * the bcache device.
>> + */
>> +static int cached_dev_report_zones_cb(struct blk_zone *zone,
>> +				      unsigned int idx,
>> +				      void *data)
> 
> I do not think you need the line break for the last argument.
> 

OK, let me change the style.

>> +{
>> +	struct bch_report_zones_args *args = data;
>> +	struct bcache_device *d = args->bcache_device;
>> +	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
>> +	unsigned long data_offset = dc->sb.data_offset;
>> +
>> +	/* Zone 0 should not be reported */
>> +	BUG_ON(zone->start < data_offset);
> 
> Wouldn't a WARN_ON_ONCE and return -EIO be better here ?

Do it in next version.


> 
>> +
>> +	/* convert back to LBA of the bcache device*/
>> +	zone->start -= data_offset;
>> +	zone->wp -= data_offset;
> 
> This has to be done depending on the zone type and zone condition: zone->wp is
> "invalid" for conventional zones, and sequential zones that are full, read-only
> or offline. So you need something like this:
> 
> 	/* Remap LBA to the bcache device */
> 	zone->start -= data_offset;
> 	switch(zone->cond) {
> 	case BLK_ZONE_COND_NOT_WP:
> 	case BLK_ZONE_COND_READONLY:
> 	case BLK_ZONE_COND_FULL:
> 	case BLK_ZONE_COND_OFFLINE:
> 		break;
> 	case BLK_ZONE_COND_EMPTY:
> 		zone->wp = zone->start;
> 		break;
> 	default:
> 		zone->wp -= data_offset;
> 		break;
> 	}
> 
> 	return args->orig_cb(zone, idx, args->orig_data);
> 

Hmm, do we have a unified spec to handle the wp on different zone
condition ?

In zonefs I see zone->wp sets to zone->start for,
- BLK_ZONE_COND_OFFLINE
- BLK_ZONE_COND_READONLY

In sd_zbc.c, I see wp sets to end of the zone for
- BLK_ZONE_COND_FULL

And in dm.c I see zone->wp is set to zone->start for,
- BLK_ZONE_COND_EMPTY

It seems except for BLK_ZONE_COND_NOT_WP, for other conditions the
writer pointer should be taken cared by device driver already.

So I write such switch-case in the following way by the inspair of your
comments,

        /* Zone 0 should not be reported */
        if(WARN_ON_ONCE(zone->start < data_offset))
                return -EIO;

        /* convert back to LBA of the bcache device*/
        zone->start -= data_offset;
        if (zone->cond != BLK_ZONE_COND_NOT_WP)
                zone->wp -= data_offset;

        switch (zone->cond) {
        case BLK_ZONE_COND_NOT_WP:
                /* No write pointer available */
                break;
        case BLK_ZONE_COND_EMPTY:
        case BLK_ZONE_COND_READONLY:
        case BLK_ZONE_COND_OFFLINE:
                /*
                 * If underlying device driver does not properly
                 * set writer pointer, warn and fix it.
                 */
                if (WARN_ON_ONCE(zone->wp != zone->start))
                        zone->wp = zone->start;
                break;
        case BLK_ZONE_COND_FULL:
                /*
                 * If underlying device driver does not properly
                 * set writer pointer, warn and fix it.
                 */
                if (WARN_ON_ONCE(zone->wp != zone->start + zone->len))
                        zone->wp = zone->start + zone->len;
                break;
        default:
                break;
        }

        return args->orig_cb(zone, idx, args->orig_data);

The above code converts zone->wp by minus data_offset for
non-BLK_ZONE_COND_NOT_WP condition. And for other necessary conditions,
I just check whether the underlying device driver updates write pointer
properly (as I observed in other drivers), if not then drop a warning
and fix the write pointer to the expected value.

Now the write pointer is only fixed when it was wrong value. If the
underlying device driver does not maintain the value properly, we figure
out and fix it.

>> +
>> +	return args->orig_cb(zone, idx, args->orig_data);
>> +}
>> +
>> +static int cached_dev_report_zones(struct bch_report_zones_args *args,
>> +				   unsigned int nr_zones)
>> +{
>> +	struct bcache_device *d = args->bcache_device;
>> +	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
>> +	/* skip zone 0 which is fully occupied by bcache super block */
>> +	sector_t sector = args->sector + dc->sb.data_offset;
>> +
>> +	/* sector is real LBA of backing device */
>> +	return blkdev_report_zones(dc->bdev,
>> +				   sector,
>> +				   nr_zones,
>> +				   cached_dev_report_zones_cb,
>> +				   args);
> 
> You could have multiple arguments on a couple of lines only here...
> 

Sure I change the style in next version.

>> +}
>> +
>>  void bch_cached_dev_request_init(struct cached_dev *dc)
>>  {
>>  	struct gendisk *g = dc->disk.disk;
>> @@ -1268,6 +1336,7 @@ void bch_cached_dev_request_init(struct cached_dev *dc)
>>  	g->queue->backing_dev_info->congested_fn = cached_dev_congested;
>>  	dc->disk.cache_miss			= cached_dev_cache_miss;
>>  	dc->disk.ioctl				= cached_dev_ioctl;
>> +	dc->disk.report_zones			= cached_dev_report_zones;
> 
> Why set this method unconditionally ? Should it be set only for a zoned bcache
> device ? E.g.:
> 	
> 	if (bdev_is_zoned(bcache bdev))
> 		dc->disk.report_zones = cached_dev_report_zones;
> 

Will fix it in next version. Thanks.


>>  }
>>  
>>  /* Flash backed devices */
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index d98354fa28e3..d5da7ad5157d 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -679,10 +679,36 @@ static int ioctl_dev(struct block_device *b, fmode_t mode,
>>  	return d->ioctl(d, mode, cmd, arg);
>>  }
>>  
>> +static int report_zones_dev(struct gendisk *disk,
>> +			    sector_t sector,
>> +			    unsigned int nr_zones,
>> +			    report_zones_cb cb,
>> +			    void *data)
>> +{
>> +	struct bcache_device *d = disk->private_data;
>> +	struct bch_report_zones_args args = {
>> +		.bcache_device = d,
>> +		.sector = sector,
>> +		.orig_data = data,
>> +		.orig_cb = cb,
>> +	};
>> +
>> +	/*
>> +	 * only bcache device with backing device has
>> +	 * report_zones method, flash device does not.
>> +	 */
>> +	if (d->report_zones)
>> +		return d->report_zones(&args, nr_zones);
>> +
>> +	/* flash dev does not have report_zones method */
> 
> This comment is confusing. Report zones is called against the bcache device, not
> against its components... In any case, if the bcache device is not zoned, the

My fault. There are two kinds of bcache device for now, one is the
bcache device with a backing device, one is the bcache device without a
backing device. For the bcache device without backing device, its I/Os
all go into the cache device (SSD). Now such bcache device is called
flash device or flash only volume IMHO. Yes this is confusing, I need to
fix it.


> report_zones method will never be called by the block layer. So you probably
> should just check that on entry:
> 
> 	if (WARN_ON_ONCE(!blk_queue_is_zoned(disk->queue))
> 		return -EOPNOTSUPP;
> 
> 	return d->report_zones(&args, nr_zones);
> 
>> +	return -EOPNOTSUPP;
>> +}
>> +

Good point, I use it in next version.


>>  static const struct block_device_operations bcache_ops = {
>>  	.open		= open_dev,
>>  	.release	= release_dev,
>>  	.ioctl		= ioctl_dev,
>> +	.report_zones	= report_zones_dev,
>>  	.owner		= THIS_MODULE,
>>  };
> 
> Same here. It may be better to set the report zones method only for a zoned
> bcache dev. So you will need an additional block_device_operations struct for
> that type.
> 
> static const struct block_device_operations bcache_zoned_ops = {
>  	.open		= open_dev,
>  	.release	= release_dev,
>  	.ioctl		= ioctl_dev,
> 	.report_zones	= report_zones_dev,
>  	.owner		= THIS_MODULE,
> };
> 

I see you point. But the purpose of such coding style is to avoid an
extra block_device_operations, just like ioctl_dev() does. Let's keep
the existsing style at this moment, and may change it in future when
necessary.


[snipped]
>>  
>> +static inline int cached_dev_data_offset_check(struct cached_dev *dc)
>> +{
>> +	if (!bdev_is_zoned(dc->bdev))
>> +		return 0;
>> +
>> +	/*
>> +	 * If the backing hard drive is zoned device, sb.data_offset
>> +	 * should be aligned to zone size, which is automatically
>> +	 * handled by 'bcache' util of bcache-tools. If the data_offset
>> +	 * is not aligned to zone size, it means the bcache-tools is
>> +	 * outdated.
>> +	 */
>> +	if (dc->sb.data_offset & (bdev_zone_sectors(dc->bdev) - 1)) {
>> +		pr_err("data_offset %llu is not aligned to zone size %llu, please update bcache-tools and re-make the zoned backing device.\n",
> 
> Long line... May be split the pr_err in 2 calls ?

This is what I learned from md code style, which is don't split the
error message into multiple lines. See the following commit,

commit 9d48739ef19aa8ad6026fd312b3ed81b560c8579
Author: NeilBrown <neilb@suse.com>
Date:   Wed Nov 2 14:16:49 2016 +1100

    md: change all printk() to pr_err() or pr_warn() etc.

This is just a choice of code style, and I'd like to take the single
line message for the following cited reason,

    3/ When strings have been split onto multiple lines, rejoin into
       a single string.
       The cost of having lines > 80 chars is less than the cost of not
       being able to easily search for a particular message.


> 
>> +			dc->sb.data_offset, bdev_zone_sectors(dc->bdev));
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
[snipped]

>> + */
>> +static int bch_cached_dev_zone_init(struct cached_dev *dc)
>> +{
>> +	struct request_queue *d_q, *b_q;
>> +	enum blk_zoned_model mode;
> 
> To be clear, may be call this variable "model" ?

Sure, it will be fixed in next version.


[snipped]
>> +	if (mode != BLK_ZONED_NONE) {
>> +		d_q->limits.zoned = mode;
>> +		blk_queue_chunk_sectors(d_q, b_q->limits.chunk_sectors);
>> +		/*
>> +		 * (dc->sb.data_offset / q->limits.chunk_sectors) is the
>> +		 * zones number reserved for bcache super block. By default
>> +		 * it is set to 1 by bcache-tools.
>> +		 */
>> +		d_q->nr_zones = b_q->nr_zones -
>> +			(dc->sb.data_offset / d_q->limits.chunk_sectors);
> 
> Does this compile on 32bits arch ? Don't you need a do_div() here ?
> 

Yes, I wil fix it in next version.

[snipped]

Thank you for the very detailed review comments :-)

Coly Li




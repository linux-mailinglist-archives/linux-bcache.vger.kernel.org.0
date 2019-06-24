Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C408502B8
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jun 2019 09:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfFXHFj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jun 2019 03:05:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:54712 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726340AbfFXHFj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jun 2019 03:05:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A9FDEAEEC;
        Mon, 24 Jun 2019 07:05:37 +0000 (UTC)
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent for
 hardware raid5/6
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-block@vger.kernel.org, Eric Wheeler <git@linux.ewheeler.net>,
        Eric Wheeler <bcache@linux.ewheeler.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
 <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
Date:   Mon, 24 Jun 2019 15:05:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/23 7:16 上午, Eric Wheeler wrote:
> From: Eric Wheeler <git@linux.ewheeler.net>
> 
> While some drivers set queue_limits.io_opt (e.g., md raid5), there are
> currently no SCSI/RAID controller drivers that do.  Previously stripe_size
> and partial_stripes_expensive were read-only values and could not be
> tuned by users (eg, for hardware RAID5/6).
> 
> This patch enables users to save the optimal IO size via sysfs through
> the backing device attributes stripe_size and partial_stripes_expensive
> into the bcache superblock.
> 
> Superblock changes are backwards-compatable:
> 
> *  partial_stripes_expensive: One bit was used in the superblock flags field
> 
> *  stripe_size: There are eight 64-bit "pad" fields for future use in
>    the superblock which default to 0; from those, 32-bits are now used
>    to save the stripe_size and load at device registration time.
> 
> Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>

Hi Eric,

In general I am OK with this patch. Since Peter comments lots of SCSI
RAID devices reports a stripe width, could you please list the hardware
raid devices which don't list stripe size ? Then we can make decision
whether it is necessary to have such option enabled.

Another point is, this patch changes struct cache_sb, it is no problem
to change on-disk format. I plan to update the super block version soon,
to store more configuration persistently into super block. stripe_size
can be added to cache_sb with other on-disk changes.

Thanks.

Coly Li


> ---
>  Documentation/admin-guide/bcache.rst | 21 +++++++++++++++++++++
>  drivers/md/bcache/super.c            | 15 ++++++++++++++-
>  drivers/md/bcache/sysfs.c            | 33 +++++++++++++++++++++++++++++++--
>  include/uapi/linux/bcache.h          |  6 ++++--
>  4 files changed, 70 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
> index c0ce64d..ef82022 100644
> --- a/Documentation/admin-guide/bcache.rst
> +++ b/Documentation/admin-guide/bcache.rst
> @@ -420,6 +420,12 @@ dirty_data
>  label
>    Name of underlying device.
>  
> +partial_stripes_expensive
> +  Flag to bcache that partial or unaligned stripe_size'd
> +  writes to the backing device are expensive (e.g., RAID5/6 incur
> +  read-copy-write). Writing this sysfs attribute updates the superblock
> +  and also takes effect immediately.  See also stripe_size, below.
> +
>  readahead
>    Size of readahead that should be performed.  Defaults to 0.  If set to e.g.
>    1M, it will round cache miss reads up to that size, but without overlapping
> @@ -458,6 +464,21 @@ stop
>    Write to this file to shut down the bcache device and close the backing
>    device.
>  
> +stripe_size
> +  The stripe size in bytes of the backing device for optimial
> +  write performance (also known as the "stride width"). This is set
> +  automatically when using a device driver sets blk_limits_io_opt
> +  (e.g., md, rbd, skd, zram, virtio_blk).  No hardware RAID controller
> +  sets blk_limits_io_opt as of 2019-06-15, so configure this to suit
> +  your needs.  Note that you must unregister and re-register the backing
> +  device after making a change to stripe_size.
> +
> +  Where N is the number of data disks,
> +    RAID5: stripe_size = (N-1)*RAID_CHUNK_SIZE.
> +    RAID6: stripe_size = (N-2)*RAID_CHUNK_SIZE.
> +
> +  See also partial_stripes_expensive, above.
> +
>  writeback_delay
>    When dirty data is written to the cache and it previously did not contain
>    any, waits some number of seconds before initiating writeback. Defaults to
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1b63ac8..d0b9501 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -80,6 +80,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>  
>  	sb->flags		= le64_to_cpu(s->flags);
>  	sb->seq			= le64_to_cpu(s->seq);
> +	sb->stripe_size		= le32_to_cpu(s->stripe_size);
>  	sb->last_mount		= le32_to_cpu(s->last_mount);
>  	sb->first_bucket	= le16_to_cpu(s->first_bucket);
>  	sb->keys		= le16_to_cpu(s->keys);
> @@ -221,6 +222,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
>  
>  	out->flags		= cpu_to_le64(sb->flags);
>  	out->seq		= cpu_to_le64(sb->seq);
> +	out->stripe_size	= cpu_to_le32(sb->stripe_size);
>  
>  	out->last_mount		= cpu_to_le32(sb->last_mount);
>  	out->first_bucket	= cpu_to_le16(sb->first_bucket);
> @@ -1258,7 +1260,18 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  
>  	dc->disk.stripe_size = q->limits.io_opt >> 9;
>  
> -	if (dc->disk.stripe_size)
> +	if (dc->sb.stripe_size) {
> +		if (dc->disk.stripe_size &&
> +		    dc->disk.stripe_size != dc->sb.stripe_size) {
> +			pr_warn("superblock stripe_size (%d) overrides bdev stripe_size (%d)\n",
> +				(int)dc->sb.stripe_size,
> +				(int)dc->disk.stripe_size);
> +		}
> +
> +		dc->disk.stripe_size = dc->sb.stripe_size;
> +		dc->partial_stripes_expensive =
> +			(unsigned int)BDEV_PARTIAL_STRIPES_EXPENSIVE(&dc->sb);
> +	} else if (dc->disk.stripe_size)
>  		dc->partial_stripes_expensive =
>  			q->limits.raid_partial_stripes_expensive;
>  
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index bfb437f..4ebca52 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -111,8 +111,8 @@
>  rw_attribute(writeback_rate_minimum);
>  read_attribute(writeback_rate_debug);
>  
> -read_attribute(stripe_size);
> -read_attribute(partial_stripes_expensive);
> +rw_attribute(stripe_size);
> +rw_attribute(partial_stripes_expensive);
>  
>  rw_attribute(synchronous);
>  rw_attribute(journal_delay_ms);
> @@ -343,6 +343,35 @@ static ssize_t bch_snprint_string_list(char *buf,
>  		}
>  	}
>  
> +	if (attr == &sysfs_stripe_size) {
> +		int v = strtoul_or_return(buf);
> +
> +		if (v & 0x1FF) {
> +			pr_err("stripe_size must be a muliple of 512-byte sectors");
> +			return -EINVAL;
> +		}
> +
> +		v >>= 9;
> +
> +		if (v != dc->sb.stripe_size) {
> +			dc->sb.stripe_size = v;
> +			pr_info("stripe_size=%d, re-register to take effect.",
> +				v<<9);
> +			bch_write_bdev_super(dc, NULL);
> +		} else
> +			pr_info("stripe_size is already set to %d.", v<<9);
> +	}
> +
> +	if (attr == &sysfs_partial_stripes_expensive) {
> +		int v = strtoul_or_return(buf);
> +
> +		if (v != BDEV_PARTIAL_STRIPES_EXPENSIVE(&dc->sb)) {
> +			SET_BDEV_PARTIAL_STRIPES_EXPENSIVE(&dc->sb, v);
> +			dc->partial_stripes_expensive = v;
> +			bch_write_bdev_super(dc, NULL);
> +		}
> +	}
> +
>  	if (attr == &sysfs_stop_when_cache_set_failed) {
>  		v = __sysfs_match_string(bch_stop_on_failure_modes, -1, buf);
>  		if (v < 0)
> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> index 5d4f58e..ee60914 100644
> --- a/include/uapi/linux/bcache.h
> +++ b/include/uapi/linux/bcache.h
> @@ -172,7 +172,9 @@ struct cache_sb {
>  
>  	__u64			flags;
>  	__u64			seq;
> -	__u64			pad[8];
> +	__u32			stripe_size;
> +	__u32			pad_u32;
> +	__u64			pad_u64[7];
>  
>  	union {
>  	struct {
> @@ -230,7 +232,7 @@ static inline _Bool SB_IS_BDEV(const struct cache_sb *sb)
>  #define BDEV_STATE_CLEAN		1U
>  #define BDEV_STATE_DIRTY		2U
>  #define BDEV_STATE_STALE		3U
> -
> +BITMASK(BDEV_PARTIAL_STRIPES_EXPENSIVE,	struct cache_sb, flags, 60, 1);
>  /*
>   * Magic numbers
>   *
> 


-- 

Coly Li

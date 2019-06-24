Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E624051A4E
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jun 2019 20:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfFXSPH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Jun 2019 14:15:07 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:35806 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbfFXSPG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Jun 2019 14:15:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 65FA3A0692;
        Mon, 24 Jun 2019 18:15:05 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id AAlO9Xf1o3LH; Mon, 24 Jun 2019 18:15:04 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id C9245A067D;
        Mon, 24 Jun 2019 18:15:03 +0000 (UTC)
Date:   Mon, 24 Jun 2019 18:14:59 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     linux-block@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
In-Reply-To: <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
Message-ID: <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de> <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net> <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1690155773-122018265-1561399774=:1114"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1690155773-122018265-1561399774=:1114
Content-Type: TEXT/PLAIN; CHARSET=ISO-2022-JP

On Mon, 24 Jun 2019, Coly Li wrote:

> On 2019/6/23 7:16 上午, Eric Wheeler wrote:
> > From: Eric Wheeler <git@linux.ewheeler.net>
> > 
> > While some drivers set queue_limits.io_opt (e.g., md raid5), there are
> > currently no SCSI/RAID controller drivers that do.  Previously stripe_size
> > and partial_stripes_expensive were read-only values and could not be
> > tuned by users (eg, for hardware RAID5/6).
> > 
> > This patch enables users to save the optimal IO size via sysfs through
> > the backing device attributes stripe_size and partial_stripes_expensive
> > into the bcache superblock.
> > 
> > Superblock changes are backwards-compatable:
> > 
> > *  partial_stripes_expensive: One bit was used in the superblock flags field
> > 
> > *  stripe_size: There are eight 64-bit "pad" fields for future use in
> >    the superblock which default to 0; from those, 32-bits are now used
> >    to save the stripe_size and load at device registration time.
> > 
> > Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
> 
> Hi Eric,
> 
> In general I am OK with this patch. Since Peter comments lots of SCSI
> RAID devices reports a stripe width, could you please list the hardware
> raid devices which don't list stripe size ? Then we can make decision
> whether it is necessary to have such option enabled.

Perhaps they do not set stripe_width using io_opt? I did a grep to see if 
any of them did, but I didn't see them. How is stripe_width indicated by 
RAID controllers? 

If they do set io_opt, then at least my Areca 1883 does not set io_opt as 
of 4.19.x. I also have a LSI MegaRAID 3108 which does not report io_opt as 
of 4.1.x, but that is an older kernel so maybe support has been added 
since then.

Martin,

Where would stripe_width be configured in the SCSI drivers? Is it visible 
through sysfs or debugfs so I can check my hardware support without 
hacking debugging the kernel?

> 
> Another point is, this patch changes struct cache_sb, it is no problem
> to change on-disk format. I plan to update the super block version soon,
> to store more configuration persistently into super block. stripe_size
> can be added to cache_sb with other on-disk changes.

Maybe bumping version makes sense, but even if you do not, this is safe to 
use on systems without bumping the version because the values are unused 
and default to 0.

--
Eric Wheeler

> 
> Thanks.
> 
> Coly Li
> 
> 
> > ---
> >  Documentation/admin-guide/bcache.rst | 21 +++++++++++++++++++++
> >  drivers/md/bcache/super.c            | 15 ++++++++++++++-
> >  drivers/md/bcache/sysfs.c            | 33 +++++++++++++++++++++++++++++++--
> >  include/uapi/linux/bcache.h          |  6 ++++--
> >  4 files changed, 70 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/bcache.rst b/Documentation/admin-guide/bcache.rst
> > index c0ce64d..ef82022 100644
> > --- a/Documentation/admin-guide/bcache.rst
> > +++ b/Documentation/admin-guide/bcache.rst
> > @@ -420,6 +420,12 @@ dirty_data
> >  label
> >    Name of underlying device.
> >  
> > +partial_stripes_expensive
> > +  Flag to bcache that partial or unaligned stripe_size'd
> > +  writes to the backing device are expensive (e.g., RAID5/6 incur
> > +  read-copy-write). Writing this sysfs attribute updates the superblock
> > +  and also takes effect immediately.  See also stripe_size, below.
> > +
> >  readahead
> >    Size of readahead that should be performed.  Defaults to 0.  If set to e.g.
> >    1M, it will round cache miss reads up to that size, but without overlapping
> > @@ -458,6 +464,21 @@ stop
> >    Write to this file to shut down the bcache device and close the backing
> >    device.
> >  
> > +stripe_size
> > +  The stripe size in bytes of the backing device for optimial
> > +  write performance (also known as the "stride width"). This is set
> > +  automatically when using a device driver sets blk_limits_io_opt
> > +  (e.g., md, rbd, skd, zram, virtio_blk).  No hardware RAID controller
> > +  sets blk_limits_io_opt as of 2019-06-15, so configure this to suit
> > +  your needs.  Note that you must unregister and re-register the backing
> > +  device after making a change to stripe_size.
> > +
> > +  Where N is the number of data disks,
> > +    RAID5: stripe_size = (N-1)*RAID_CHUNK_SIZE.
> > +    RAID6: stripe_size = (N-2)*RAID_CHUNK_SIZE.
> > +
> > +  See also partial_stripes_expensive, above.
> > +
> >  writeback_delay
> >    When dirty data is written to the cache and it previously did not contain
> >    any, waits some number of seconds before initiating writeback. Defaults to
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 1b63ac8..d0b9501 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -80,6 +80,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
> >  
> >  	sb->flags		= le64_to_cpu(s->flags);
> >  	sb->seq			= le64_to_cpu(s->seq);
> > +	sb->stripe_size		= le32_to_cpu(s->stripe_size);
> >  	sb->last_mount		= le32_to_cpu(s->last_mount);
> >  	sb->first_bucket	= le16_to_cpu(s->first_bucket);
> >  	sb->keys		= le16_to_cpu(s->keys);
> > @@ -221,6 +222,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
> >  
> >  	out->flags		= cpu_to_le64(sb->flags);
> >  	out->seq		= cpu_to_le64(sb->seq);
> > +	out->stripe_size	= cpu_to_le32(sb->stripe_size);
> >  
> >  	out->last_mount		= cpu_to_le32(sb->last_mount);
> >  	out->first_bucket	= cpu_to_le16(sb->first_bucket);
> > @@ -1258,7 +1260,18 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
> >  
> >  	dc->disk.stripe_size = q->limits.io_opt >> 9;
> >  
> > -	if (dc->disk.stripe_size)
> > +	if (dc->sb.stripe_size) {
> > +		if (dc->disk.stripe_size &&
> > +		    dc->disk.stripe_size != dc->sb.stripe_size) {
> > +			pr_warn("superblock stripe_size (%d) overrides bdev stripe_size (%d)\n",
> > +				(int)dc->sb.stripe_size,
> > +				(int)dc->disk.stripe_size);
> > +		}
> > +
> > +		dc->disk.stripe_size = dc->sb.stripe_size;
> > +		dc->partial_stripes_expensive =
> > +			(unsigned int)BDEV_PARTIAL_STRIPES_EXPENSIVE(&dc->sb);
> > +	} else if (dc->disk.stripe_size)
> >  		dc->partial_stripes_expensive =
> >  			q->limits.raid_partial_stripes_expensive;
> >  
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index bfb437f..4ebca52 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -111,8 +111,8 @@
> >  rw_attribute(writeback_rate_minimum);
> >  read_attribute(writeback_rate_debug);
> >  
> > -read_attribute(stripe_size);
> > -read_attribute(partial_stripes_expensive);
> > +rw_attribute(stripe_size);
> > +rw_attribute(partial_stripes_expensive);
> >  
> >  rw_attribute(synchronous);
> >  rw_attribute(journal_delay_ms);
> > @@ -343,6 +343,35 @@ static ssize_t bch_snprint_string_list(char *buf,
> >  		}
> >  	}
> >  
> > +	if (attr == &sysfs_stripe_size) {
> > +		int v = strtoul_or_return(buf);
> > +
> > +		if (v & 0x1FF) {
> > +			pr_err("stripe_size must be a muliple of 512-byte sectors");
> > +			return -EINVAL;
> > +		}
> > +
> > +		v >>= 9;
> > +
> > +		if (v != dc->sb.stripe_size) {
> > +			dc->sb.stripe_size = v;
> > +			pr_info("stripe_size=%d, re-register to take effect.",
> > +				v<<9);
> > +			bch_write_bdev_super(dc, NULL);
> > +		} else
> > +			pr_info("stripe_size is already set to %d.", v<<9);
> > +	}
> > +
> > +	if (attr == &sysfs_partial_stripes_expensive) {
> > +		int v = strtoul_or_return(buf);
> > +
> > +		if (v != BDEV_PARTIAL_STRIPES_EXPENSIVE(&dc->sb)) {
> > +			SET_BDEV_PARTIAL_STRIPES_EXPENSIVE(&dc->sb, v);
> > +			dc->partial_stripes_expensive = v;
> > +			bch_write_bdev_super(dc, NULL);
> > +		}
> > +	}
> > +
> >  	if (attr == &sysfs_stop_when_cache_set_failed) {
> >  		v = __sysfs_match_string(bch_stop_on_failure_modes, -1, buf);
> >  		if (v < 0)
> > diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> > index 5d4f58e..ee60914 100644
> > --- a/include/uapi/linux/bcache.h
> > +++ b/include/uapi/linux/bcache.h
> > @@ -172,7 +172,9 @@ struct cache_sb {
> >  
> >  	__u64			flags;
> >  	__u64			seq;
> > -	__u64			pad[8];
> > +	__u32			stripe_size;
> > +	__u32			pad_u32;
> > +	__u64			pad_u64[7];
> >  
> >  	union {
> >  	struct {
> > @@ -230,7 +232,7 @@ static inline _Bool SB_IS_BDEV(const struct cache_sb *sb)
> >  #define BDEV_STATE_CLEAN		1U
> >  #define BDEV_STATE_DIRTY		2U
> >  #define BDEV_STATE_STALE		3U
> > -
> > +BITMASK(BDEV_PARTIAL_STRIPES_EXPENSIVE,	struct cache_sb, flags, 60, 1);
> >  /*
> >   * Magic numbers
> >   *
> > 
> 
> 
> -- 
> 
> Coly Li
> 
---1690155773-122018265-1561399774=:1114--

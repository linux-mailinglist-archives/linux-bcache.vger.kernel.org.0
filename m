Return-Path: <linux-bcache+bounces-671-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA55890F201
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 17:23:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65115281B50
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 15:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D551513D525;
	Wed, 19 Jun 2024 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Flw9Cwkp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1260D182B5;
	Wed, 19 Jun 2024 15:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718810607; cv=none; b=CKQhTo1gUaePoxfFz29ccBVdlRfmQzemEEZNeF9jGKUaEB35GCq1Chm7o7qPQh0kggbgA2Ek9WOiFW0FjkqGS9xx73snONJmpOP3pI5hvjUzVTahrsAKkEKaC1xHmRf21B61eYSue/3NtleEzof+2++BiKnHTUwzw9gtqVpkHow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718810607; c=relaxed/simple;
	bh=IdOk+ny5qiEZHf8cAFRy5n9FZGEilhrl1UYgnWmQhR8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CeYSpRHQrcgL3aFDZGrg1ZyHsLZpAX6UPho/G3ikSddivv4i/5XdAUqp9oLE3SZo6DC6QvO0eB+4cmtSXcKhGTTfw9py/rLaTtTaLFeBXBuR1EaXo3Y7E4KNJz7rTfcM/n3/+/rleFsS/Abh5sdQCQWUGWQFNHi7OCemFh+LBFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Flw9Cwkp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4217990f8baso60195335e9.2;
        Wed, 19 Jun 2024 08:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718810603; x=1719415403; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSVLHkgMSUqxWcbc1T+fsQsit0Pgp/IVlzKOv2OSI7w=;
        b=Flw9CwkpOiw2o+PNn2ULllvu0PUuevw0mfrOAPH3QFqd1vJCgG0ioNdG/1ZIfRCxFB
         t9J7VxjyIfB3MjkwrHRSbzzdv2mvpi0bdfuPPrLsMq27ogqBAb5zqpLAskIIoVEOupId
         rLsPgJeSkvWrergASeMSruCnExJoE+RNH5u6QXYxn92Tdcnh+uh/tUvYYoPqbNfGqCkM
         k/6NEfv9e1Kjw5R93sFQHamRLVM7Xvf+kvlcgMczWqt/1/23JLPU1VfFFpu4CncsiSqE
         kdFhLxoxBJ+kuiDX7SLYAG4mg49+GAf1I4+CeTsm3GaZPuoEO5qbNmcVSUT5pPQdbeUw
         gNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718810603; x=1719415403;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSVLHkgMSUqxWcbc1T+fsQsit0Pgp/IVlzKOv2OSI7w=;
        b=WatKSpY6QfW7gCA8XJUppgca9AkFEVSSt8JZVbjad6tRn6BmCqjOySNpMpYe94tHkT
         +/Ydv27WH4EYQOYsf6p8brRG6xtxoWNy3KHzLKLij7y8w0xKKIFiOrgvRjf81e0dMWdI
         qNwHzllLYUqqW6h8wMRe6o0Fg0Zj1eKTaMO3kFNiAqkU/TtttGM7LaxS2Pbx2Sz7UKZN
         D664XxFAl1nbk/BP1+UVUCkCH/BobO7XSt0YXX52pyZh3Ry60gz/UOop66+70eU0xuyy
         iMju06h8V39KFu8EExn/yYfMAWhCyRodwQao8IBUvsbYU9NVqfTnC7md2ggLEYihJHcB
         1BmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPBWurdERc/GfdbEMY5qF4vkkRqVJ92Lo1ShpyXkkZEvS7hCtPDC/x7wEGgK4Ky4dKBukjWiDtdgIQxEhl6k0sUaiXXaWwH3iLUVv5QZvvPcQjowrUwF3oZXiK/Bj1pxwZVQxrR5/tl8Bh3julI2zoVDjP7nZ3VTUnLnpKRNCmc/4Np3gGl2wTDmQ4zvAVD606J9cWuqL4qd8x16EVVdLgEy/El2o8A8IwTAbmAIZ1f3zChV0nOnxT7mbIFk6OSA9kwDzTXQk4/vAF6c/yfLcKRxT0/Ivy6b2Z9XAU7L3Xk8OKhvJ+dz/RG+X2IPJ9VBa431JH
X-Gm-Message-State: AOJu0YwCjArmmYr34TR1/q8glk79wS1BiiE2feVxxU5aUR9VLWUykTby
	F/5Ud3TcKe7s+Yo+euk6bGgHuxhFoW9U9X5r5ZNVpTtdeHSIHDob
X-Google-Smtp-Source: AGHT+IG+MXhlW+QFpM6Rnupka8napxwJxRH0oCI9mys5+mxI/fFZ68OpTovznOA60BtwebCs2O4yVw==
X-Received: by 2002:a05:600c:6a9a:b0:422:50d7:ff0 with SMTP id 5b1f17b1804b1-4247507a6f6mr19093275e9.3.1718810603126;
        Wed, 19 Jun 2024 08:23:23 -0700 (PDT)
Received: from [10.14.0.2] ([178.239.163.102])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422f641f522sm230634805e9.48.2024.06.19.08.23.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2024 08:23:22 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: Re: [PATCH 14/26] block: move the nonrot flag to queue_limits
From: Simon Fernandez <fernandez.simon@gmail.com>
In-Reply-To: <20240617060532.127975-15-hch@lst.de>
Date: Wed, 19 Jun 2024 16:23:52 +0100
Cc: Jens Axboe <axboe@kernel.dk>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?utf-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>,
 Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 =?utf-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>,
 Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org,
 linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com,
 nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org,
 ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org,
 dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org,
 nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org,
 linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 linux-block@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <312DD24A-7AB5-4FAC-8880-EA80056CFC44@gmail.com>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-15-hch@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3608.120.23.2.7)

Hi folks, how can I unsubscribe from this group.?
Thanks in advance.
S

> On 17 Jun 2024, at 07:04, Christoph Hellwig <hch@lst.de> wrote:
>=20
> Move the nonrot flag into the queue_limits feature field so that it =
can
> be set atomically with the queue frozen.
>=20
> Use the chance to switch to defaulting to non-rotational and require
> the driver to opt into rotational, which matches the polarity of the
> sysfs interface.
>=20
> For the z2ram, ps3vram, 2x memstick, ubiblock and dcssblk the new
> rotational flag is not set as they clearly are not rotational despite
> this being a behavior change.  There are some other drivers that
> unconditionally set the rotational flag to keep the existing behavior
> as they arguably can be used on rotational devices even if that is
> probably not their main use today (e.g. virtio_blk and drbd).
>=20
> The flag is automatically inherited in blk_stack_limits matching the
> existing behavior in dm and md.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
> arch/m68k/emu/nfblock.c             |  1 +
> arch/um/drivers/ubd_kern.c          |  1 -
> arch/xtensa/platforms/iss/simdisk.c |  5 +++-
> block/blk-mq-debugfs.c              |  1 -
> block/blk-sysfs.c                   | 39 ++++++++++++++++++++++++++---
> drivers/block/amiflop.c             |  5 +++-
> drivers/block/aoe/aoeblk.c          |  1 +
> drivers/block/ataflop.c             |  5 +++-
> drivers/block/brd.c                 |  2 --
> drivers/block/drbd/drbd_main.c      |  3 ++-
> drivers/block/floppy.c              |  3 ++-
> drivers/block/loop.c                |  8 +++---
> drivers/block/mtip32xx/mtip32xx.c   |  1 -
> drivers/block/n64cart.c             |  2 --
> drivers/block/nbd.c                 |  5 ----
> drivers/block/null_blk/main.c       |  1 -
> drivers/block/pktcdvd.c             |  1 +
> drivers/block/ps3disk.c             |  3 ++-
> drivers/block/rbd.c                 |  3 ---
> drivers/block/rnbd/rnbd-clt.c       |  4 ---
> drivers/block/sunvdc.c              |  1 +
> drivers/block/swim.c                |  5 +++-
> drivers/block/swim3.c               |  5 +++-
> drivers/block/ublk_drv.c            |  9 +++----
> drivers/block/virtio_blk.c          |  4 ++-
> drivers/block/xen-blkfront.c        |  1 -
> drivers/block/zram/zram_drv.c       |  2 --
> drivers/cdrom/gdrom.c               |  1 +
> drivers/md/bcache/super.c           |  2 --
> drivers/md/dm-table.c               | 12 ---------
> drivers/md/md.c                     | 13 ----------
> drivers/mmc/core/queue.c            |  1 -
> drivers/mtd/mtd_blkdevs.c           |  1 -
> drivers/nvdimm/btt.c                |  1 -
> drivers/nvdimm/pmem.c               |  1 -
> drivers/nvme/host/core.c            |  1 -
> drivers/nvme/host/multipath.c       |  1 -
> drivers/s390/block/dasd_genhd.c     |  1 -
> drivers/s390/block/scm_blk.c        |  1 -
> drivers/scsi/sd.c                   |  4 +--
> include/linux/blkdev.h              | 10 ++++----
> 41 files changed, 83 insertions(+), 88 deletions(-)
>=20
> diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
> index 642fb80c5c4e31..8eea7ef9115146 100644
> --- a/arch/m68k/emu/nfblock.c
> +++ b/arch/m68k/emu/nfblock.c
> @@ -98,6 +98,7 @@ static int __init nfhd_init_one(int id, u32 blocks, =
u32 bsize)
> {
> 	struct queue_limits lim =3D {
> 		.logical_block_size	=3D bsize,
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> 	};
> 	struct nfhd_device *dev;
> 	int dev_id =3D id - NFHD_DEV_OFFSET;
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index 19e01691ea0ea7..9f1e76ddda5a26 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -882,7 +882,6 @@ static int ubd_add(int n, char **error_out)
> 		goto out_cleanup_tags;
> 	}
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
> 	disk->major =3D UBD_MAJOR;
> 	disk->first_minor =3D n << UBD_SHIFT;
> 	disk->minors =3D 1 << UBD_SHIFT;
> diff --git a/arch/xtensa/platforms/iss/simdisk.c =
b/arch/xtensa/platforms/iss/simdisk.c
> index defc67909a9c74..d6d2b533a5744d 100644
> --- a/arch/xtensa/platforms/iss/simdisk.c
> +++ b/arch/xtensa/platforms/iss/simdisk.c
> @@ -263,6 +263,9 @@ static const struct proc_ops simdisk_proc_ops =3D =
{
> static int __init simdisk_setup(struct simdisk *dev, int which,
> 		struct proc_dir_entry *procdir)
> {
> +	struct queue_limits lim =3D {
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> +	};
> 	char tmp[2] =3D { '0' + which, 0 };
> 	int err;
>=20
> @@ -271,7 +274,7 @@ static int __init simdisk_setup(struct simdisk =
*dev, int which,
> 	spin_lock_init(&dev->lock);
> 	dev->users =3D 0;
>=20
> -	dev->gd =3D blk_alloc_disk(NULL, NUMA_NO_NODE);
> +	dev->gd =3D blk_alloc_disk(&lim, NUMA_NO_NODE);
> 	if (IS_ERR(dev->gd)) {
> 		err =3D PTR_ERR(dev->gd);
> 		goto out;
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index e8b9db7c30c455..4d0e62ec88f033 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -84,7 +84,6 @@ static const char *const blk_queue_flag_name[] =3D {
> 	QUEUE_FLAG_NAME(NOMERGES),
> 	QUEUE_FLAG_NAME(SAME_COMP),
> 	QUEUE_FLAG_NAME(FAIL_IO),
> -	QUEUE_FLAG_NAME(NONROT),
> 	QUEUE_FLAG_NAME(IO_STAT),
> 	QUEUE_FLAG_NAME(NOXMERGES),
> 	QUEUE_FLAG_NAME(ADD_RANDOM),
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 4f524c1d5e08bd..637ed3bbbfb46f 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -263,6 +263,39 @@ static ssize_t queue_dma_alignment_show(struct =
request_queue *q, char *page)
> 	return queue_var_show(queue_dma_alignment(q), page);
> }
>=20
> +static ssize_t queue_feature_store(struct request_queue *q, const =
char *page,
> +		size_t count, unsigned int feature)
> +{
> +	struct queue_limits lim;
> +	unsigned long val;
> +	ssize_t ret;
> +
> +	ret =3D queue_var_store(&val, page, count);
> +	if (ret < 0)
> +		return ret;
> +
> +	lim =3D queue_limits_start_update(q);
> +	if (val)
> +		lim.features |=3D feature;
> +	else
> +		lim.features &=3D ~feature;
> +	ret =3D queue_limits_commit_update(q, &lim);
> +	if (ret)
> +		return ret;
> +	return count;
> +}
> +
> +#define QUEUE_SYSFS_FEATURE(_name, _feature)				 =
\
> +static ssize_t queue_##_name##_show(struct request_queue *q, char =
*page) \
> +{									 =
\
> +	return sprintf(page, "%u\n", !!(q->limits.features & _feature)); =
\
> +}									 =
\
> +static ssize_t queue_##_name##_store(struct request_queue *q,		=
 \
> +		const char *page, size_t count)				 =
\
> +{									 =
\
> +	return queue_feature_store(q, page, count, _feature);		 =
\
> +}
> +
> #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				=
\
> static ssize_t								=
\
> queue_##name##_show(struct request_queue *q, char *page)		=
\
> @@ -289,7 +322,7 @@ queue_##name##_store(struct request_queue *q, =
const char *page, size_t count) \
> 	return ret;							=
\
> }
>=20
> -QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
> +QUEUE_SYSFS_FEATURE(rotational, BLK_FEAT_ROTATIONAL)
> QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
> QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
> QUEUE_SYSFS_BIT_FNS(stable_writes, STABLE_WRITES, 0);
> @@ -526,7 +559,7 @@ static struct queue_sysfs_entry =
queue_hw_sector_size_entry =3D {
> 	.show =3D queue_logical_block_size_show,
> };
>=20
> -QUEUE_RW_ENTRY(queue_nonrot, "rotational");
> +QUEUE_RW_ENTRY(queue_rotational, "rotational");
> QUEUE_RW_ENTRY(queue_iostats, "iostats");
> QUEUE_RW_ENTRY(queue_random, "add_random");
> QUEUE_RW_ENTRY(queue_stable_writes, "stable_writes");
> @@ -624,7 +657,7 @@ static struct attribute *queue_attrs[] =3D {
> 	&queue_write_zeroes_max_entry.attr,
> 	&queue_zone_append_max_entry.attr,
> 	&queue_zone_write_granularity_entry.attr,
> -	&queue_nonrot_entry.attr,
> +	&queue_rotational_entry.attr,
> 	&queue_zoned_entry.attr,
> 	&queue_nr_zones_entry.attr,
> 	&queue_max_open_zones_entry.attr,
> diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
> index a25414228e4741..ff45701f7a5e31 100644
> --- a/drivers/block/amiflop.c
> +++ b/drivers/block/amiflop.c
> @@ -1776,10 +1776,13 @@ static const struct blk_mq_ops amiflop_mq_ops =
=3D {
>=20
> static int fd_alloc_disk(int drive, int system)
> {
> +	struct queue_limits lim =3D {
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> +	};
> 	struct gendisk *disk;
> 	int err;
>=20
> -	disk =3D blk_mq_alloc_disk(&unit[drive].tag_set, NULL, NULL);
> +	disk =3D blk_mq_alloc_disk(&unit[drive].tag_set, &lim, NULL);
> 	if (IS_ERR(disk))
> 		return PTR_ERR(disk);
>=20
> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> index b6dac8cee70fe1..2028795ec61cbb 100644
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -337,6 +337,7 @@ aoeblk_gdalloc(void *vp)
> 	struct queue_limits lim =3D {
> 		.max_hw_sectors		=3D aoe_maxsectors,
> 		.io_opt			=3D SZ_2M,
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> 	};
> 	ulong flags;
> 	int late =3D 0;
> diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
> index cacc4ba942a814..4ee10a742bdb93 100644
> --- a/drivers/block/ataflop.c
> +++ b/drivers/block/ataflop.c
> @@ -1992,9 +1992,12 @@ static const struct blk_mq_ops ataflop_mq_ops =3D=
 {
>=20
> static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
> {
> +	struct queue_limits lim =3D {
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> +	};
> 	struct gendisk *disk;
>=20
> -	disk =3D blk_mq_alloc_disk(&unit[drive].tag_set, NULL, NULL);
> +	disk =3D blk_mq_alloc_disk(&unit[drive].tag_set, &lim, NULL);
> 	if (IS_ERR(disk))
> 		return PTR_ERR(disk);
>=20
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index 558d8e67056608..b25dc463b5e3a6 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -366,8 +366,6 @@ static int brd_alloc(int i)
> 	strscpy(disk->disk_name, buf, DISK_NAME_LEN);
> 	set_capacity(disk, rd_size * 2);
> =09
> -	/* Tell the block layer that this is not a rotational device */
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
> 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, disk->queue);
> 	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
> 	err =3D add_disk(disk);
> diff --git a/drivers/block/drbd/drbd_main.c =
b/drivers/block/drbd/drbd_main.c
> index bf42a46781fa21..2ef29a47807550 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -2697,7 +2697,8 @@ enum drbd_ret_code drbd_create_device(struct =
drbd_config_context *adm_ctx, unsig
> 		 * connect.
> 		 */
> 		.max_hw_sectors		=3D DRBD_MAX_BIO_SIZE_SAFE >> 8,
> -		.features		=3D BLK_FEAT_WRITE_CACHE | =
BLK_FEAT_FUA,
> +		.features		=3D BLK_FEAT_WRITE_CACHE | =
BLK_FEAT_FUA |
> +					  BLK_FEAT_ROTATIONAL,
> 	};
>=20
> 	device =3D minor_to_device(minor);
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 25c9d85667f1a2..6d7f7df97c3a6c 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4516,7 +4516,8 @@ static bool floppy_available(int drive)
> static int floppy_alloc_disk(unsigned int drive, unsigned int type)
> {
> 	struct queue_limits lim =3D {
> -		.max_hw_sectors =3D 64,
> +		.max_hw_sectors		=3D 64,
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> 	};
> 	struct gendisk *disk;
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 08d0fc7f17b701..86b5d956dc4e02 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -985,13 +985,11 @@ static int loop_reconfigure_limits(struct =
loop_device *lo, unsigned short bsize)
> 	lim.logical_block_size =3D bsize;
> 	lim.physical_block_size =3D bsize;
> 	lim.io_min =3D bsize;
> -	lim.features &=3D ~BLK_FEAT_WRITE_CACHE;
> +	lim.features &=3D ~(BLK_FEAT_WRITE_CACHE | BLK_FEAT_ROTATIONAL);
> 	if (file->f_op->fsync && !(lo->lo_flags & LO_FLAGS_READ_ONLY))
> 		lim.features |=3D BLK_FEAT_WRITE_CACHE;
> -	if (!backing_bdev || bdev_nonrot(backing_bdev))
> -		blk_queue_flag_set(QUEUE_FLAG_NONROT, lo->lo_queue);
> -	else
> -		blk_queue_flag_clear(QUEUE_FLAG_NONROT, lo->lo_queue);
> +	if (backing_bdev && !bdev_nonrot(backing_bdev))
> +		lim.features |=3D BLK_FEAT_ROTATIONAL;
> 	loop_config_discard(lo, &lim);
> 	return queue_limits_commit_update(lo->lo_queue, &lim);
> }
> diff --git a/drivers/block/mtip32xx/mtip32xx.c =
b/drivers/block/mtip32xx/mtip32xx.c
> index 43a187609ef794..1dbbf72659d549 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -3485,7 +3485,6 @@ static int mtip_block_initialize(struct =
driver_data *dd)
> 		goto start_service_thread;
>=20
> 	/* Set device limits. */
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, dd->queue);
> 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, dd->queue);
> 	dma_set_max_seg_size(&dd->pdev->dev, 0x400000);
>=20
> diff --git a/drivers/block/n64cart.c b/drivers/block/n64cart.c
> index 27b2187e7a6d55..b9fdeff31cafdf 100644
> --- a/drivers/block/n64cart.c
> +++ b/drivers/block/n64cart.c
> @@ -150,8 +150,6 @@ static int __init n64cart_probe(struct =
platform_device *pdev)
> 	set_capacity(disk, size >> SECTOR_SHIFT);
> 	set_disk_ro(disk, 1);
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
> -
> 	err =3D add_disk(disk);
> 	if (err)
> 		goto out_cleanup_disk;
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index cb1c86a6a3fb9d..6cddf5baffe02a 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -1867,11 +1867,6 @@ static struct nbd_device *nbd_dev_add(int =
index, unsigned int refs)
> 		goto out_err_disk;
> 	}
>=20
> -	/*
> -	 * Tell the block layer that we are not a rotational device
> -	 */
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
> -
> 	mutex_init(&nbd->config_lock);
> 	refcount_set(&nbd->config_refs, 0);
> 	/*
> diff --git a/drivers/block/null_blk/main.c =
b/drivers/block/null_blk/main.c
> index 21f9d256e88402..83a4ebe4763ae5 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1948,7 +1948,6 @@ static int null_add_dev(struct nullb_device =
*dev)
> 	}
>=20
> 	nullb->q->queuedata =3D nullb;
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
>=20
> 	rv =3D ida_alloc(&nullb_indexes, GFP_KERNEL);
> 	if (rv < 0)
> diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
> index 8a2ce80700109d..7cece5884b9c67 100644
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -2622,6 +2622,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* =
pkt_dev)
> 	struct queue_limits lim =3D {
> 		.max_hw_sectors		=3D PACKET_MAX_SECTORS,
> 		.logical_block_size	=3D CD_FRAMESIZE,
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> 	};
> 	int idx;
> 	int ret =3D -ENOMEM;
> diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
> index 8b73cf459b5937..ff45ed76646957 100644
> --- a/drivers/block/ps3disk.c
> +++ b/drivers/block/ps3disk.c
> @@ -388,7 +388,8 @@ static int ps3disk_probe(struct =
ps3_system_bus_device *_dev)
> 		.max_segments		=3D -1,
> 		.max_segment_size	=3D dev->bounce_size,
> 		.dma_alignment		=3D dev->blk_size - 1,
> -		.features		=3D BLK_FEAT_WRITE_CACHE,
> +		.features		=3D BLK_FEAT_WRITE_CACHE |
> +					  BLK_FEAT_ROTATIONAL,
> 	};
> 	struct gendisk *gendisk;
>=20
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 22ad704f81d8b9..ec1f1c7d4275cd 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4997,9 +4997,6 @@ static int rbd_init_disk(struct rbd_device =
*rbd_dev)
> 	disk->fops =3D &rbd_bd_ops;
> 	disk->private_data =3D rbd_dev;
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> -	/* QUEUE_FLAG_ADD_RANDOM is off by default for blk-mq */
> -
> 	if (!ceph_test_opt(rbd_dev->rbd_client->client, NOCRC))
> 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, q);
>=20
> diff --git a/drivers/block/rnbd/rnbd-clt.c =
b/drivers/block/rnbd/rnbd-clt.c
> index 02c4b173182719..4918b0f68b46cd 100644
> --- a/drivers/block/rnbd/rnbd-clt.c
> +++ b/drivers/block/rnbd/rnbd-clt.c
> @@ -1352,10 +1352,6 @@ static int rnbd_clt_setup_gen_disk(struct =
rnbd_clt_dev *dev,
> 	if (dev->access_mode =3D=3D RNBD_ACCESS_RO)
> 		set_disk_ro(dev->gd, true);
>=20
> -	/*
> -	 * Network device does not need rotational
> -	 */
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, dev->queue);
> 	err =3D add_disk(dev->gd);
> 	if (err)
> 		put_disk(dev->gd);
> diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
> index 5286cb8e0824d1..2d38331ee66793 100644
> --- a/drivers/block/sunvdc.c
> +++ b/drivers/block/sunvdc.c
> @@ -791,6 +791,7 @@ static int probe_disk(struct vdc_port *port)
> 		.seg_boundary_mask		=3D PAGE_SIZE - 1,
> 		.max_segment_size		=3D PAGE_SIZE,
> 		.max_segments			=3D port->ring_cookies,
> +		.features			=3D BLK_FEAT_ROTATIONAL,
> 	};
> 	struct request_queue *q;
> 	struct gendisk *g;
> diff --git a/drivers/block/swim.c b/drivers/block/swim.c
> index 6731678f3a41db..126f151c4f2cf0 100644
> --- a/drivers/block/swim.c
> +++ b/drivers/block/swim.c
> @@ -787,6 +787,9 @@ static void swim_cleanup_floppy_disk(struct =
floppy_state *fs)
>=20
> static int swim_floppy_init(struct swim_priv *swd)
> {
> +	struct queue_limits lim =3D {
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> +	};
> 	int err;
> 	int drive;
> 	struct swim __iomem *base =3D swd->base;
> @@ -820,7 +823,7 @@ static int swim_floppy_init(struct swim_priv *swd)
> 			goto exit_put_disks;
>=20
> 		swd->unit[drive].disk =3D
> -			blk_mq_alloc_disk(&swd->unit[drive].tag_set, =
NULL,
> +			blk_mq_alloc_disk(&swd->unit[drive].tag_set, =
&lim,
> 					  &swd->unit[drive]);
> 		if (IS_ERR(swd->unit[drive].disk)) {
> 			blk_mq_free_tag_set(&swd->unit[drive].tag_set);
> diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
> index a04756ac778ee8..90be1017f7bfcd 100644
> --- a/drivers/block/swim3.c
> +++ b/drivers/block/swim3.c
> @@ -1189,6 +1189,9 @@ static int swim3_add_device(struct macio_dev =
*mdev, int index)
> static int swim3_attach(struct macio_dev *mdev,
> 			const struct of_device_id *match)
> {
> +	struct queue_limits lim =3D {
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> +	};
> 	struct floppy_state *fs;
> 	struct gendisk *disk;
> 	int rc;
> @@ -1210,7 +1213,7 @@ static int swim3_attach(struct macio_dev *mdev,
> 	if (rc)
> 		goto out_unregister;
>=20
> -	disk =3D blk_mq_alloc_disk(&fs->tag_set, NULL, fs);
> +	disk =3D blk_mq_alloc_disk(&fs->tag_set, &lim, fs);
> 	if (IS_ERR(disk)) {
> 		rc =3D PTR_ERR(disk);
> 		goto out_free_tag_set;
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index e45c65c1848d31..4fcde099935868 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -484,14 +484,8 @@ static inline unsigned ublk_pos_to_tag(loff_t =
pos)
>=20
> static void ublk_dev_param_basic_apply(struct ublk_device *ub)
> {
> -	struct request_queue *q =3D ub->ub_disk->queue;
> 	const struct ublk_param_basic *p =3D &ub->params.basic;
>=20
> -	if (p->attrs & UBLK_ATTR_ROTATIONAL)
> -		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> -	else
> -		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> -
> 	if (p->attrs & UBLK_ATTR_READ_ONLY)
> 		set_disk_ro(ub->ub_disk, true);
>=20
> @@ -2214,6 +2208,9 @@ static int ublk_ctrl_start_dev(struct =
ublk_device *ub, struct io_uring_cmd *cmd)
> 			lim.features |=3D BLK_FEAT_FUA;
> 	}
>=20
> +	if (ub->params.basic.attrs & UBLK_ATTR_ROTATIONAL)
> +		lim.features |=3D BLK_FEAT_ROTATIONAL;
> +
> 	if (wait_for_completion_interruptible(&ub->completion) !=3D 0)
> 		return -EINTR;
>=20
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index b1a3c293528519..13a2f24f176628 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -1451,7 +1451,9 @@ static int virtblk_read_limits(struct virtio_blk =
*vblk,
> static int virtblk_probe(struct virtio_device *vdev)
> {
> 	struct virtio_blk *vblk;
> -	struct queue_limits lim =3D { };
> +	struct queue_limits lim =3D {
> +		.features		=3D BLK_FEAT_ROTATIONAL,
> +	};
> 	int err, index;
> 	unsigned int queue_depth;
>=20
> diff --git a/drivers/block/xen-blkfront.c =
b/drivers/block/xen-blkfront.c
> index 9aafce3e5987bf..fa3a2ba525458b 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1146,7 +1146,6 @@ static int xlvbd_alloc_gendisk(blkif_sector_t =
capacity,
> 		err =3D PTR_ERR(gd);
> 		goto out_free_tag_set;
> 	}
> -	blk_queue_flag_set(QUEUE_FLAG_VIRT, gd->queue);
>=20
> 	strcpy(gd->disk_name, DEV_NAME);
> 	ptr =3D encode_disk_name(gd->disk_name + sizeof(DEV_NAME) - 1, =
offset);
> diff --git a/drivers/block/zram/zram_drv.c =
b/drivers/block/zram/zram_drv.c
> index 3acd7006ad2ccd..aad840fc7e18e3 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -2245,8 +2245,6 @@ static int zram_add(void)
>=20
> 	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize =
*/
> 	set_capacity(zram->disk, 0);
> -	/* zram devices sort of resembles non-rotational disks */
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, zram->disk->queue);
> 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, zram->disk->queue);
> 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
> 	ret =3D device_add_disk(NULL, zram->disk, zram_disk_groups);
> diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
> index eefdd422ad8e9f..71cfe7a85913c4 100644
> --- a/drivers/cdrom/gdrom.c
> +++ b/drivers/cdrom/gdrom.c
> @@ -744,6 +744,7 @@ static int probe_gdrom(struct platform_device =
*devptr)
> 		.max_segments			=3D 1,
> 		/* set a large max size to get most from DMA */
> 		.max_segment_size		=3D 0x40000,
> +		.features			=3D BLK_FEAT_ROTATIONAL,
> 	};
> 	int err;
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index cb6595c8b5514e..baa364eedd0051 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -974,8 +974,6 @@ static int bcache_device_init(struct bcache_device =
*d, unsigned int block_size,
> 	d->disk->minors		=3D BCACHE_MINORS;
> 	d->disk->fops		=3D ops;
> 	d->disk->private_data	=3D d;
> -
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
> 	return 0;
>=20
> out_bioset_exit:
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 03abdae646829c..c062af32970934 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1716,12 +1716,6 @@ static int =
device_dax_write_cache_enabled(struct dm_target *ti,
> 	return false;
> }
>=20
> -static int device_is_rotational(struct dm_target *ti, struct dm_dev =
*dev,
> -				sector_t start, sector_t len, void =
*data)
> -{
> -	return !bdev_nonrot(dev->bdev);
> -}
> -
> static int device_is_not_random(struct dm_target *ti, struct dm_dev =
*dev,
> 			     sector_t start, sector_t len, void *data)
> {
> @@ -1870,12 +1864,6 @@ int dm_table_set_restrictions(struct dm_table =
*t, struct request_queue *q,
> 	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, =
NULL))
> 		dax_write_cache(t->md->dax_dev, true);
>=20
> -	/* Ensure that all underlying devices are non-rotational. */
> -	if (dm_table_any_dev_attr(t, device_is_rotational, NULL))
> -		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> -	else
> -		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> -
> 	/*
> 	 * Some devices don't use blk_integrity but still want stable =
pages
> 	 * because they do their own checksumming.
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2f4c5d1755d857..c23423c51fb7c2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6151,20 +6151,7 @@ int md_run(struct mddev *mddev)
>=20
> 	if (!mddev_is_dm(mddev)) {
> 		struct request_queue *q =3D mddev->gendisk->queue;
> -		bool nonrot =3D true;
>=20
> -		rdev_for_each(rdev, mddev) {
> -			if (rdev->raid_disk >=3D 0 && =
!bdev_nonrot(rdev->bdev)) {
> -				nonrot =3D false;
> -				break;
> -			}
> -		}
> -		if (mddev->degraded)
> -			nonrot =3D false;
> -		if (nonrot)
> -			blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> -		else
> -			blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> 		blk_queue_flag_set(QUEUE_FLAG_IO_STAT, q);
>=20
> 		/* Set the NOWAIT flags if all underlying devices =
support it */
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index 97ff993d31570c..b4f62fa845864c 100644
> --- a/drivers/mmc/core/queue.c
> +++ b/drivers/mmc/core/queue.c
> @@ -387,7 +387,6 @@ static struct gendisk *mmc_alloc_disk(struct =
mmc_queue *mq,
> 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, mq->queue);
> 	blk_queue_rq_timeout(mq->queue, 60 * HZ);
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, mq->queue);
> 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, mq->queue);
>=20
> 	dma_set_max_seg_size(mmc_dev(host), =
queue_max_segment_size(mq->queue));
> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
> index 1b9f57f231e8be..bf8369ce7ddf1d 100644
> --- a/drivers/mtd/mtd_blkdevs.c
> +++ b/drivers/mtd/mtd_blkdevs.c
> @@ -375,7 +375,6 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev =
*new)
> 	spin_lock_init(&new->queue_lock);
> 	INIT_LIST_HEAD(&new->rq_list);
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, new->rq);
> 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, new->rq);
>=20
> 	gd->queue =3D new->rq;
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index c5f8451b494d6c..e474afa8e9f68d 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1518,7 +1518,6 @@ static int btt_blk_init(struct btt *btt)
> 	btt->btt_disk->fops =3D &btt_fops;
> 	btt->btt_disk->private_data =3D btt;
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
> 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, =
btt->btt_disk->queue);
>=20
> 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index aff818469c114c..501cf226df0187 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -546,7 +546,6 @@ static int pmem_attach_disk(struct device *dev,
> 	}
> 	pmem->virt_addr =3D addr;
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> 	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
> 	if (pmem->pfn_flags & PFN_MAP)
> 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 9fc5e36fe2e55e..0d753fe71f35b0 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -3744,7 +3744,6 @@ static void nvme_alloc_ns(struct nvme_ctrl =
*ctrl, struct nvme_ns_info *info)
> 	if (ctrl->opts && ctrl->opts->data_digest)
> 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, ns->queue);
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, ns->queue);
> 	if (ctrl->ops->supports_pci_p2pdma &&
> 	    ctrl->ops->supports_pci_p2pdma(ctrl))
> 		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
> diff --git a/drivers/nvme/host/multipath.c =
b/drivers/nvme/host/multipath.c
> index 3d0e23a0a4ddd8..58c13304e558e0 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -549,7 +549,6 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, =
struct nvme_ns_head *head)
> 	sprintf(head->disk->disk_name, "nvme%dn%d",
> 			ctrl->subsys->instance, head->instance);
>=20
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, head->disk->queue);
> 	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, head->disk->queue);
> 	blk_queue_flag_set(QUEUE_FLAG_IO_STAT, head->disk->queue);
> 	/*
> diff --git a/drivers/s390/block/dasd_genhd.c =
b/drivers/s390/block/dasd_genhd.c
> index 4533dd055ca8e3..1aa426b1deddc7 100644
> --- a/drivers/s390/block/dasd_genhd.c
> +++ b/drivers/s390/block/dasd_genhd.c
> @@ -68,7 +68,6 @@ int dasd_gendisk_alloc(struct dasd_block *block)
> 		blk_mq_free_tag_set(&block->tag_set);
> 		return PTR_ERR(gdp);
> 	}
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, gdp->queue);
>=20
> 	/* Initialize gendisk structure. */
> 	gdp->major =3D DASD_MAJOR;
> diff --git a/drivers/s390/block/scm_blk.c =
b/drivers/s390/block/scm_blk.c
> index 1d456a5a3bfb8e..2e2309fa9a0b34 100644
> --- a/drivers/s390/block/scm_blk.c
> +++ b/drivers/s390/block/scm_blk.c
> @@ -475,7 +475,6 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, =
struct scm_device *scmdev)
> 		goto out_tag;
> 	}
> 	rq =3D bdev->rq =3D bdev->gendisk->queue;
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, rq);
> 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, rq);
>=20
> 	bdev->gendisk->private_data =3D scmdev;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d8ee4a4d4a6283..a42c3c45e86830 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3318,7 +3318,7 @@ static void sd_read_block_characteristics(struct =
scsi_disk *sdkp,
> 	rcu_read_unlock();
>=20
> 	if (rot =3D=3D 1) {
> -		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> +		lim->features &=3D ~BLK_FEAT_ROTATIONAL;
> 		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
> 	}
>=20
> @@ -3646,7 +3646,7 @@ static int sd_revalidate_disk(struct gendisk =
*disk)
> 		 * cause this to be updated correctly and any device =
which
> 		 * doesn't support it should be treated as rotational.
> 		 */
> -		blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> +		lim.features |=3D BLK_FEAT_ROTATIONAL;
> 		blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
>=20
> 		if (scsi_device_supports_vpd(sdp)) {
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index acdfe5122faa44..988e3248cffeb7 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -289,14 +289,16 @@ enum {
>=20
> 	/* supports passing on the FUA bit */
> 	BLK_FEAT_FUA				=3D (1u << 1),
> +
> +	/* rotational device (hard drive or floppy) */
> +	BLK_FEAT_ROTATIONAL			=3D (1u << 2),
> };
>=20
> /*
>  * Flags automatically inherited when stacking limits.
>  */
> #define BLK_FEAT_INHERIT_MASK \
> -	(BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA)
> -
> +	(BLK_FEAT_WRITE_CACHE | BLK_FEAT_FUA | BLK_FEAT_ROTATIONAL)
>=20
> /* internal flags in queue_limits.flags */
> enum {
> @@ -553,8 +555,6 @@ struct request_queue {
> #define QUEUE_FLAG_NOMERGES     3	/* disable merge attempts */
> #define QUEUE_FLAG_SAME_COMP	4	/* complete on same CPU-group */
> #define QUEUE_FLAG_FAIL_IO	5	/* fake timeout */
> -#define QUEUE_FLAG_NONROT	6	/* non-rotational device (SSD) =
*/
> -#define QUEUE_FLAG_VIRT		QUEUE_FLAG_NONROT /* paravirt =
device */
> #define QUEUE_FLAG_IO_STAT	7	/* do disk/partitions IO =
accounting */
> #define QUEUE_FLAG_NOXMERGES	9	/* No extended merges */
> #define QUEUE_FLAG_ADD_RANDOM	10	/* Contributes to random pool */
> @@ -589,7 +589,7 @@ bool blk_queue_flag_test_and_set(unsigned int =
flag, struct request_queue *q);
> #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, =
&(q)->queue_flags)
> #define blk_queue_noxmerges(q)	\
> 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
> -#define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, =
&(q)->queue_flags)
> +#define blk_queue_nonrot(q)	((q)->limits.features & =
BLK_FEAT_ROTATIONAL)
> #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, =
&(q)->queue_flags)
> #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, =
&(q)->queue_flags)
> #define blk_queue_zone_resetall(q)	\
> --=20
> 2.43.0
>=20



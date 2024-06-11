Return-Path: <linux-bcache+bounces-543-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A5F29031DA
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:57:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBD64282D36
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D17E7170842;
	Tue, 11 Jun 2024 05:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fv21i4LD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D5B8488;
	Tue, 11 Jun 2024 05:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085426; cv=none; b=gAO9EZfbZAntWvStdOv5UQFq4EyDHlBc975AE/nODd8D6SS08TC6rQ2HrIutu/vvTNUyUyXvA6t4bI5+f99VDxcrnxp2Xmjgd+blZfTlJwxKaJSKvAWUV4t0ToS+1pFMfzUOH89AUwaSApdHKIDhAGdyqi4bvVWfC1yK4Aam1JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085426; c=relaxed/simple;
	bh=xFN1h7CLNOVeSD1DVq7Y6t3Bb5KlL582IrHJpAfOI+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E1KjbnE/xswZCzfSKvZypqhp2d+az6/f/dNO67BziRlKyLOrpYYnc5HfItIV3b4mXdr/Y7qDnFoGlquXporozoihTTCiKRulctFK6tPkyy7NpDFpCH3ktHDCfWdjlNzlsUlBn9BN3iFY1HpZ0sZoSF8szd8MGrxIZrjuA3jotT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fv21i4LD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4CBC2BD10;
	Tue, 11 Jun 2024 05:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718085426;
	bh=xFN1h7CLNOVeSD1DVq7Y6t3Bb5KlL582IrHJpAfOI+I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fv21i4LDKBohOjAMc7pIwhaiiTsAlafv5K+jqxJasBRtlliGgCtTrXsT0H8yV5+9T
	 njwksi1EuST41csRG3Vqsp2L+QlP+t8YOn8e3W08JXRiXRq8hhVj8Dagc3+6nbt30R
	 F+mIQhqmSwNPdFOouK0TdZvzzsTWzz1Lqs4jPTNbQ0Jw2LrEoRIpZD54zKPNaLm1HA
	 t4c032+2B98Y3f+oLMEONdKDXJVupqzzbghc2EZK18tDOe6HzPnnhx/GWgADRWFlM4
	 oxYC9o2lrFo6wnGlsgbujf5T6gsAVdypUTxeMWDRMSrvLMxkDZnNQFg5hAvDm4J/fA
	 kYvXmValPXY/Q==
Message-ID: <dabc33cd-feb9-4263-8f6e-4d2ab3d71430@kernel.org>
Date: Tue, 11 Jun 2024 14:56:59 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/26] loop: regularize upgrading the lock size for direct
 I/O
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com, nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-6-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> The LOOP_CONFIGURE path automatically upgrades the block size to that
> of the underlying file for O_DIRECT file descriptors, but the
> LOOP_SET_BLOCK_SIZE path does not.  Fix this by lifting the code to
> pick the block size into common code.

s/lock/block in the commit title.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/loop.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c658282454af1b..4f6d8514d19bd6 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -975,10 +975,24 @@ loop_set_status_from_info(struct loop_device *lo,
>  	return 0;
>  }
>  
> +static unsigned short loop_default_blocksize(struct loop_device *lo,
> +		struct block_device *backing_bdev)
> +{
> +	/* In case of direct I/O, match underlying block size */
> +	if ((lo->lo_backing_file->f_flags & O_DIRECT) && backing_bdev)
> +		return bdev_logical_block_size(backing_bdev);
> +	return 512;

Nit: SECTOR_SIZE ?

> +}
> +
>  static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize)
>  {
> +	struct file *file = lo->lo_backing_file;
> +	struct inode *inode = file->f_mapping->host;
>  	struct queue_limits lim;
>  
> +	if (!bsize)
> +		bsize = loop_default_blocksize(lo, inode->i_sb->s_bdev);

If bsize is specified and there is a backing dev used with direct IO, should it
be checked that bsize is a multiple of bdev_logical_block_size(backing_bdev) ?

> +
>  	lim = queue_limits_start_update(lo->lo_queue);
>  	lim.logical_block_size = bsize;
>  	lim.physical_block_size = bsize;
> @@ -997,7 +1011,6 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
>  	int error;
>  	loff_t size;
>  	bool partscan;
> -	unsigned short bsize;
>  	bool is_loop;
>  
>  	if (!file)
> @@ -1076,15 +1089,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
>  	if (!(lo->lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
>  		blk_queue_write_cache(lo->lo_queue, true, false);
>  
> -	if (config->block_size)
> -		bsize = config->block_size;
> -	else if ((lo->lo_backing_file->f_flags & O_DIRECT) && inode->i_sb->s_bdev)
> -		/* In case of direct I/O, match underlying block size */
> -		bsize = bdev_logical_block_size(inode->i_sb->s_bdev);
> -	else
> -		bsize = 512;
> -
> -	error = loop_reconfigure_limits(lo, bsize);
> +	error = loop_reconfigure_limits(lo, config->block_size);
>  	if (WARN_ON_ONCE(error))
>  		goto out_unlock;
>  

-- 
Damien Le Moal
Western Digital Research



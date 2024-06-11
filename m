Return-Path: <linux-bcache+bounces-537-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C787790318D
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E00B71C20E6B
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F72917085D;
	Tue, 11 Jun 2024 05:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANn0WrF5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053618488;
	Tue, 11 Jun 2024 05:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085091; cv=none; b=XnLtROH+PfBj1aw9t0vjWsZSWYX7JMxZMCcYVN2KBEIxvcpFXZT5S0fzBE2B+2sJSeOwjNBUQJsQCQ+8RQTPY0HtK1CxDpbXtEHXwUJpmK0/J00p5RR73yKFqm55ApZJQHT80955ziNJGLLN3iiL5HlGVJNAuLothh+xqdD1FR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085091; c=relaxed/simple;
	bh=n/truQQNALnyrE4ZbwFnrA1tq2cozaH91kaKcSN3ADo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lx4rL9kFLbLyb/ojMDZ1JriB4MvddSwbtN1Q04lt6BQ7F64N3iAezJPxwONPAoQnwWSEKsP5VPtvNXjX2ZfMUpL41YU2aNMBwiRnmuFoDuA6XJpAbZqvwEuErlFViZOR2RZQ3zkaqaD2Jra0F5uQrUgftuoHx6M+xJMbJK+7DCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANn0WrF5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8B3C2BD10;
	Tue, 11 Jun 2024 05:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718085090;
	bh=n/truQQNALnyrE4ZbwFnrA1tq2cozaH91kaKcSN3ADo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ANn0WrF5kOQJZxWO+lYlEGkU5hVzQiFb2dNu1fRL0d2IWY3RReTj+asObSRTOVsDn
	 nik3p07qhEGu9jO0A5uH0hbRiLwLOJ3d6qy5Lpfrdzdf1JpR8Qb6Y+TeigefvpTdHC
	 PaMP9CtOKbfsr2fBnfzUYFtnczoPg5lf2QS4Trvu+DMNLb/UDOZQCC9uHBx6LdmPM8
	 /dgqDFvO1q4KPpY9GF6hhisUoWhTc6hasUEAygvr3guCne7aOz50r92/yOBM880RPV
	 /mezANfcSB8zUh/+nThd+2qNqFJrJ+m45Wswa5U72/uWVWbOFnW/S5hmwY1Gx82O5w
	 +K3mqL1+sk3wQ==
Message-ID: <40ca8052-6ac1-4c1b-8c39-b0a7948839f8@kernel.org>
Date: Tue, 11 Jun 2024 14:51:24 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/26] sd: move zone limits setup out of
 sd_read_block_characteristics
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
 <20240611051929.513387-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move a bit of code that sets up the zone flag and the write granularity
> into sd_zbc_read_zones to be with the rest of the zoned limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c     | 21 +--------------------
>  drivers/scsi/sd_zbc.c | 13 ++++++++++++-
>  2 files changed, 13 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 85b45345a27739..5bfed61c70db8f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3308,29 +3308,10 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp,
>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
>  	}
>  
> -
> -#ifdef CONFIG_BLK_DEV_ZONED /* sd_probe rejects ZBD devices early otherwise */
> -	if (sdkp->device->type == TYPE_ZBC) {
> -		lim->zoned = true;
> -
> -		/*
> -		 * Per ZBC and ZAC specifications, writes in sequential write
> -		 * required zones of host-managed devices must be aligned to
> -		 * the device physical block size.
> -		 */
> -		lim->zone_write_granularity = sdkp->physical_block_size;
> -	} else {
> -		/*
> -		 * Host-aware devices are treated as conventional.
> -		 */
> -		lim->zoned = false;
> -	}
> -#endif /* CONFIG_BLK_DEV_ZONED */
> -
>  	if (!sdkp->first_scan)
>  		return;
>  
> -	if (lim->zoned)
> +	if (sdkp->device->type == TYPE_ZBC)

Nit: use sd_is_zoned() here ?

>  		sd_printk(KERN_NOTICE, sdkp, "Host-managed zoned block device\n");
>  	else if (sdkp->zoned == 1)
>  		sd_printk(KERN_NOTICE, sdkp, "Host-aware SMR disk used as regular disk\n");
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 422eaed8457227..e9501db0450be3 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -598,8 +598,19 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
>  	u32 zone_blocks = 0;
>  	int ret;
>  
> -	if (!sd_is_zoned(sdkp))
> +	if (!sd_is_zoned(sdkp)) {
> +		lim->zoned = false;

Maybe we should clear the other zone related limits here ? If the drive is
reformatted/converted from SMR to CMR (FORMAT WITH PRESET), the other zone
limits may be set already, no ?

>  		return 0;
> +	}
> +
> +	lim->zoned = true;
> +
> +	/*
> +	 * Per ZBC and ZAC specifications, writes in sequential write required
> +	 * zones of host-managed devices must be aligned to the device physical
> +	 * block size.
> +	 */
> +	lim->zone_write_granularity = sdkp->physical_block_size;
>  
>  	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
>  	sdkp->device->use_16_for_rw = 1;

-- 
Damien Le Moal
Western Digital Research



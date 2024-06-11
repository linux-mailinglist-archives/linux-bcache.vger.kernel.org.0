Return-Path: <linux-bcache+bounces-552-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F8F9033A5
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 09:30:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAAC01C23048
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A755172BAA;
	Tue, 11 Jun 2024 07:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCI1eDgX"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54022172795;
	Tue, 11 Jun 2024 07:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718091046; cv=none; b=T0Kt9a7Kz9LJablClmHOQ7Fnl/BJlON3U5ysAbikS0KejBOwIqSa0XFZqHUOAr3IRTFqnUtuiiuHoiCyOsG0emo5OtiORv4DME9SOFHQzV/JNnvJ9/yxfEUdJty59zkOn2TpXAdMo1oxQ5GcLxSPuuPrkHgnkbEUES4dXq5JX5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718091046; c=relaxed/simple;
	bh=mXwlDhzGw5x2p2Nr8gAFPISP2nDIAfZIJOaFJyvJXOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvMlz1qoL0/mE667j99aP850Mfaz7WKBIa5XQ/7dkrMfYAXJKm5YKz9f+EkZ/kUvDEpVQbyEuR8WC62q0y8I1TD/5cl+DY4HMiiDqY0j4zKeKYHtJ41YEqBtaNMlplzxknt3FAnNLl8rWamWg9NKSVuTeTMP4HgguUdCJc+yR24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCI1eDgX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC6CC2BD10;
	Tue, 11 Jun 2024 07:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718091045;
	bh=mXwlDhzGw5x2p2Nr8gAFPISP2nDIAfZIJOaFJyvJXOI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VCI1eDgXTsePnpt155uEye/3wYDicIPNZJ3+S2Hq2BKZNkLNvV5I0fT+JdCzdUnSb
	 yuXJ7xiSHP9TiSA6PVPXt+qO9Dn4e1NQaWtG0WZKRDKr7qk2obBVABl9+DPiAto15R
	 ZY06Qeaqugg7VSWPCcJ0qkt9/u4FV8hF/W3PG2hU6Xg27Ev50hNdLuTn4EcUBYyJ8n
	 S+KRGHhRfCxLhpogZoDRTutfmrs5hXd1HvW8FhrlCCZSHQ5haYJkZbrzON8/BzrfEH
	 kcYMtKu/xYq8uguhHsXhgHJwfT/OivpjDtyI/mVqW6dF9WSlmB2m2KaCIH1Th4AQTt
	 8udJurnL3fqPA==
Message-ID: <fdfc024a-368a-4495-8b85-b5ab7741f6d4@kernel.org>
Date: Tue, 11 Jun 2024 16:30:39 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/26] xen-blkfront: don't disable cache flushes when they
 fail
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
 <20240611051929.513387-11-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> blkfront always had a robust negotiation protocol for detecting a write
> cache.  Stop simply disabling cache flushes when they fail as that is
> a grave error.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me but maybe mention that removal of xlvbd_flush() as well ?
And it feels like the "stop disabling cache flushes when they fail" part should
be a fix patch sent separately...

Anyway, for both parts, feel free to add:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  drivers/block/xen-blkfront.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 9b4ec3e4908cce..9794ac2d3299d1 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -982,18 +982,6 @@ static const char *flush_info(struct blkfront_info *info)
>  		return "barrier or flush: disabled;";
>  }
>  
> -static void xlvbd_flush(struct blkfront_info *info)
> -{
> -	blk_queue_write_cache(info->rq, info->feature_flush ? true : false,
> -			      info->feature_fua ? true : false);
> -	pr_info("blkfront: %s: %s %s %s %s %s %s %s\n",
> -		info->gd->disk_name, flush_info(info),
> -		"persistent grants:", info->feature_persistent ?
> -		"enabled;" : "disabled;", "indirect descriptors:",
> -		info->max_indirect_segments ? "enabled;" : "disabled;",
> -		"bounce buffer:", info->bounce ? "enabled" : "disabled;");
> -}
> -
>  static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
>  {
>  	int major;
> @@ -1162,7 +1150,15 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
>  	info->sector_size = sector_size;
>  	info->physical_sector_size = physical_sector_size;
>  
> -	xlvbd_flush(info);
> +	blk_queue_write_cache(info->rq, info->feature_flush ? true : false,
> +			      info->feature_fua ? true : false);
> +
> +	pr_info("blkfront: %s: %s %s %s %s %s %s %s\n",
> +		info->gd->disk_name, flush_info(info),
> +		"persistent grants:", info->feature_persistent ?
> +		"enabled;" : "disabled;", "indirect descriptors:",
> +		info->max_indirect_segments ? "enabled;" : "disabled;",
> +		"bounce buffer:", info->bounce ? "enabled" : "disabled;");
>  
>  	if (info->vdisk_info & VDISK_READONLY)
>  		set_disk_ro(gd, 1);
> @@ -1622,13 +1618,6 @@ static irqreturn_t blkif_interrupt(int irq, void *dev_id)
>  				       info->gd->disk_name, op_name(bret.operation));
>  				blkif_req(req)->error = BLK_STS_NOTSUPP;
>  			}
> -			if (unlikely(blkif_req(req)->error)) {
> -				if (blkif_req(req)->error == BLK_STS_NOTSUPP)
> -					blkif_req(req)->error = BLK_STS_OK;
> -				info->feature_fua = 0;
> -				info->feature_flush = 0;
> -				xlvbd_flush(info);
> -			}
>  			fallthrough;
>  		case BLKIF_OP_READ:
>  		case BLKIF_OP_WRITE:

-- 
Damien Le Moal
Western Digital Research



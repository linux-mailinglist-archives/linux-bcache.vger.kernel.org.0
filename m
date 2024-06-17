Return-Path: <linux-bcache+bounces-643-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A15390A56D
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3DFF28878E
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBE818629A;
	Mon, 17 Jun 2024 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLJEJwmM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E50A186291;
	Mon, 17 Jun 2024 06:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718605413; cv=none; b=KEW7XJlLS0ItPC8SguusIXZnU3YqEOT4Mrikw5LjHX8/hfufmHR0scc3DCQIhStZh72g2hWhiQTetNTUCUnXIaLhS3ksegUA9cxBd+Gq8Kq6SbVR6fxpamfGBd833EyYnCRclaxE5cvvLY9LxmIAP84+2FW6wW/fc/7VyJF4zZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718605413; c=relaxed/simple;
	bh=uMvSBiMCv5pxii/WRMe23vNNUZcfAqUN7YYlV2bv5Ko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C94vTcV0J8C+2ZAwbiwVvnR5sDTzFcztTpVt/xRnxQVvnts4o3bYNNhjEc2ndCqtQ31nBkQ0hX/47H5RMc85loJ72U0X8Y8YOSUbOXXd7IhUDFRrMQHkCu4vxXyYt1Ga1sfmqcWNS+hdmncL8CEq3B7xxWbdVVlb2CPzTWCj8IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLJEJwmM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0EEC4AF1D;
	Mon, 17 Jun 2024 06:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718605412;
	bh=uMvSBiMCv5pxii/WRMe23vNNUZcfAqUN7YYlV2bv5Ko=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BLJEJwmMsCdQfpgeuSDFFhnTeYFrqXQ3GLsKdxLZUdhrqVCdlccETSs3reVgf76Rb
	 4NtHvzGyiVxgePozGjF6t5kslEhri7LHZl0DvN4BR4smuIdi3fWqPb/I1vVcfCYeYi
	 fiVbKgy6qBR19yAJJ+QQiLpd0oScLx6sTzGkD0QZlko71H6Yz0ku2d3RgXA7QaUtXr
	 GCCeiq+Ax8cIg0E+JxaozXjwtykL41yfJ3EoBVzh7JOK3qIJv+ADxMbH5/c2pw1ot4
	 Uz1JoQGCWSohEy6+TWZP70VoRi8sStV1FCojepppq975Nhv9oB4B67NtvIDhRuNUUc
	 t0DawHP78ZCMQ==
Message-ID: <3247433c-b356-425c-a888-8f7904351a2f@kernel.org>
Date: Mon, 17 Jun 2024 15:23:27 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/26] block: move cache control settings out of
 queue->flags
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
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Ulf Hansson <ulf.hansson@linaro.org>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-14-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240617060532.127975-14-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/24 15:04, Christoph Hellwig wrote:
> Move the cache control settings into the queue_limits so that the flags
> can be set atomically with the device queue frozen.
> 
> Add new features and flags field for the driver set flags, and internal
> (usually sysfs-controlled) flags in the block layer.  Note that we'll
> eventually remove enough field from queue_limits to bring it back to the
> previous size.
> 
> The disable flag is inverted compared to the previous meaning, which
> means it now survives a rescan, similar to the max_sectors and
> max_discard_sectors user limits.
> 
> The FLUSH and FUA flags are now inherited by blk_stack_limits, which
> simplified the code in dm a lot, but also causes a slight behavior
> change in that dm-switch and dm-unstripe now advertise a write cache
> despite setting num_flush_bios to 0.  The I/O path will handle this
> gracefully, but as far as I can tell the lack of num_flush_bios
> and thus flush support is a pre-existing data integrity bug in those
> targets that really needs fixing, after which a non-zero num_flush_bios
> should be required in dm for targets that map to underlying devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org> [mmc]

A few nits below. With these fixed,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> +Implementation details for bio based block drivers
> +--------------------------------------------------
> +
> +For bio based drivers the REQ_PREFLUSH and REQ_FUA bit are simplify passed on

...bit are simplify... -> ...bits are simply...

> +to the driver if the drivers sets the BLK_FEAT_WRITE_CACHE flag and the drivers
> +needs to handle them.

s/drivers/driver (2 times)

> -and the driver must handle write requests that have the REQ_FUA bit set
> -in prep_fn/request_fn.  If the FUA bit is not natively supported the block
> -layer turns it into an empty REQ_OP_FLUSH request after the actual write.
> +When the BLK_FEAT_FUA flags is set, the REQ_FUA bit simplify passed on for the

s/bit simplify/bit is simply


-- 
Damien Le Moal
Western Digital Research



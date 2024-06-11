Return-Path: <linux-bcache+bounces-544-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12FE790321E
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56A03B2B2FB
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E254D171083;
	Tue, 11 Jun 2024 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juelLKuk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964018488;
	Tue, 11 Jun 2024 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085543; cv=none; b=N14lWJhvs23BrTE5l/ubK2uTbqd4vh5bS1Fo8peenq1mBEvKEz0XHrmmfNhwiPQ8uzOjtK21Q3AoPSqsqxWVxcDQ/MecEzUIhCnJiaz35bWNcmokQ3mFD5NlTwLkzAjVJ8jbFbs/rg6P8SIL+A6zs8cBuxDR+RPqk0BGQFPLjHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085543; c=relaxed/simple;
	bh=ytNiiCLVFE28gHr4h5G30TNqYehF/KogG4pSKSbNQ2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZN/25cMjWEAQKyVCvO+lSvrEuQrQkFvWYQJGT2QDImDJwLZMhMqZ4EQyLfpK8hoCaPe2V4Kj5/Ne+uM7SXn9kyPITYXCWJM2lC/nfEUjnIvZ7geoi7ajeGZWLgngYnCk++3acEEthJxHEKbunJczxYcRXbzXRiavQ+GZvw7oKfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juelLKuk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39B0C2BD10;
	Tue, 11 Jun 2024 05:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718085543;
	bh=ytNiiCLVFE28gHr4h5G30TNqYehF/KogG4pSKSbNQ2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=juelLKuku0LFbgtXG9OzRzRWb3ooPaRYkdEGYbxCY/l/EREHcpsd6y+kWaUp4iBKj
	 Cs53RLnIaSbrZccm/GN9QVCVAOcAI/+By8TM/0/LFmq4RPTUmj+axscKmxzzB5coCx
	 TPpMXPmrdbBJt790n7mZ2SG7cnazZrwM4LN+e2wDErlp27GY0Q5cW5+prp1xuTs+nr
	 t3wCoIWjpcxWO+rGzFp9IqhsxvwTy7jx2vG3FMgsOx4qNL4tLOJuL4SBWR9Le8e1Gu
	 FbIAW9jk7NKo8gZzoXSm3zjx5aS60f2RIO1ZIKWZDZVw79ebRnV6Cm+DP9ptNCmDsn
	 briDJeVws9DJA==
Message-ID: <27e76310-1831-473e-803a-e0294b91463c@kernel.org>
Date: Tue, 11 Jun 2024 14:58:56 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/26] loop: also use the default block size from an
 underlying block device
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
 <20240611051929.513387-7-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Fix the code in loop_reconfigure_limits to pick a default block size for
> O_DIRECT file descriptors to also work when the loop device sits on top
> of a block device and not just on a regular file on a block device based
> file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/loop.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 4f6d8514d19bd6..d7cf6bbbfb1b86 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -988,10 +988,16 @@ static int loop_reconfigure_limits(struct loop_device *lo, unsigned short bsize)
>  {
>  	struct file *file = lo->lo_backing_file;
>  	struct inode *inode = file->f_mapping->host;
> +	struct block_device *backing_bdev = NULL;
>  	struct queue_limits lim;
>  
> +	if (S_ISBLK(inode->i_mode))
> +		backing_bdev = I_BDEV(inode);
> +	else if (inode->i_sb->s_bdev)
> +		backing_bdev = inode->i_sb->s_bdev;
> +

Why not move this hunk inside the below "if" ? (backing_dev declaration can go
there too).

>  	if (!bsize)
> -		bsize = loop_default_blocksize(lo, inode->i_sb->s_bdev);
> +		bsize = loop_default_blocksize(lo, backing_bdev);
>  
>  	lim = queue_limits_start_update(lo->lo_queue);
>  	lim.logical_block_size = bsize;

-- 
Damien Le Moal
Western Digital Research



Return-Path: <linux-bcache+bounces-271-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEE0856C44
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 19:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5693B21C55
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Feb 2024 18:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57561384AE;
	Thu, 15 Feb 2024 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FQjjgAXb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFCB137C2E;
	Thu, 15 Feb 2024 18:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708020970; cv=none; b=AUN503OjSSaaDJzdmU+Hfv/rgY8X8K4Q8ckKdxkOQbC9v2KSki7GLOHxuXtLK7WRBoUo/iF+UsPgXuQKYPs0TsTMcLkJH4YnudhGnvrpmLNWXtUol7Ty9rspZkFKh5CoCys29l6CmzAJQPLyURAXYy5deg3FqF9L7GWKf2UnBNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708020970; c=relaxed/simple;
	bh=I4dB3GMx6a+9L4e9XCMmtI4/zUU1rGbMjgwANKjHCRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LH+PTTljQspdCQYLbLNxvHfVLCa8W5qQ687TViojW270V82sMhVJIj4hCF4g4deXeTrr7zGF1zc24CwEFloZY8og1yIW9pqe3HmfkehL5VgkPqdUBt6nJA9ij4v5Ugm2Lu9xjkHhBGjJULYByY2ZdxQmC+QrxCIQul0OwPHi8jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FQjjgAXb; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708020968; x=1739556968;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I4dB3GMx6a+9L4e9XCMmtI4/zUU1rGbMjgwANKjHCRY=;
  b=FQjjgAXbIbHI4cO2BX2DX5fXIU9ymIqwignaroWGXO/Q31K3n8l2iVRZ
   6+8hvUdAfvyoSuW9QIFVzTAYOJOBDhPppNifOlBuqt0WtY+nP7Q6/gbWD
   JXenB2QIwltkwGD06a91zVj2xCHWStajUf7Ck3E2ombGT3wFtBVyK+RlM
   4uUk6ba2lCxiYG+SscrYFjn4EhsSw4NK7OAslzDiDkrrHXiSCyVnDUhb7
   zj4CUlYgdYv9DDl18f+r8Wh9oVmyb22lK5OPgrxHn9fbhBVZ8kk9yJSQ7
   vwudIevow45Sw88xTGxOOkVMSQrIWAlMKLWob5ijD6cgQ+XNWnEb4gtpL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="27583108"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="27583108"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 10:15:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="8210773"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.246.113.87]) ([10.246.113.87])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 10:15:49 -0800
Message-ID: <b5fab2d6-5cc1-4dd9-b3a3-faf649427ae7@intel.com>
Date: Thu, 15 Feb 2024 11:15:47 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] pmem: pass queue_limits to blk_mq_alloc_disk
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Coly Li <colyli@suse.de>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 linux-m68k@lists.linux-m68k.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-block@vger.kernel.org
References: <20240215071055.2201424-1-hch@lst.de>
 <20240215071055.2201424-9-hch@lst.de>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240215071055.2201424-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/15/24 12:10 AM, Christoph Hellwig wrote:
> Pass the queue limits directly to blk_alloc_disk instead of setting them
> one at a time.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/pmem.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 3a5df8d467c507..8dcc10b6db5b12 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -451,6 +451,11 @@ static int pmem_attach_disk(struct device *dev,
>  {
>  	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
>  	struct nd_region *nd_region = to_nd_region(dev->parent);
> +	struct queue_limits lim = {
> +		.logical_block_size	= pmem_sector_size(ndns),
> +		.physical_block_size	= PAGE_SIZE,
> +		.max_hw_sectors		= UINT_MAX,
> +	};
>  	int nid = dev_to_node(dev), fua;
>  	struct resource *res = &nsio->res;
>  	struct range bb_range;
> @@ -497,7 +502,7 @@ static int pmem_attach_disk(struct device *dev,
>  		return -EBUSY;
>  	}
>  
> -	disk = blk_alloc_disk(NULL, nid);
> +	disk = blk_alloc_disk(&lim, nid);
>  	if (IS_ERR(disk))
>  		return PTR_ERR(disk);
>  	q = disk->queue;
> @@ -539,9 +544,6 @@ static int pmem_attach_disk(struct device *dev,
>  	pmem->virt_addr = addr;
>  
>  	blk_queue_write_cache(q, true, fua);
> -	blk_queue_physical_block_size(q, PAGE_SIZE);
> -	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
> -	blk_queue_max_hw_sectors(q, UINT_MAX);
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>  	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
>  	if (pmem->pfn_flags & PFN_MAP)


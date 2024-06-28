Return-Path: <linux-bcache+bounces-698-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A397F91C09F
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2024 16:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 602E02811B6
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2024 14:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 299C71AE09D;
	Fri, 28 Jun 2024 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="knuo9cDK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914C8155747
	for <linux-bcache@vger.kernel.org>; Fri, 28 Jun 2024 14:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719584163; cv=none; b=ZiBFEKxXeu1qWqPAiffko8HhbdS6H5BeIwStbPx+8vH23IgdeUFsKgL5Dx6bTwHGcZYY7p1vXxBKvBwzjWQ1pUSNJ+69X8IR/o5x8qYaj8YrKYYRTAMYgUGsoxRce2KzyOl6krqwS2G4IhFPb3ZgFaZG9MDQj+dbftlB550mUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719584163; c=relaxed/simple;
	bh=vHZyixfEkCMpIyO9IGhaRp3Z5sPLTkM6zv+ScwgMy94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbbrSXk8/OIq1a646n9JSe9ji8tu9zWEdUL7gkMdKjijNb4zXrEpV0kr2AY9ZzifgFM0UZmggbSqivR67EnMFase0S7aVWu5vQyWDLq0i8a2TN+ZQJXcYFLeEbopH2qB5XJZ29cKbegevhF3ThRAXXxVk5eMro8ZOkpAt6h01QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=knuo9cDK; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: hch@lst.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719584158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nRvueP+d2bhVAo6RSQKCivngECnsghXuwqTiVR/kFb0=;
	b=knuo9cDKmrj3EyOWJMegcQooUgs21zOgvavE1vmjQxpX22nkBmTMpycLoC2yx93g2lyUSY
	YpCa8fDo/70pedlyr4iLnhzETnd7njWnElGxFQYSw209DBjuJIl2B2Y4/uRkHAJjNYuk6a
	JK1nidF/xzO1Yx0ZUJLar3KrcdMvFSA=
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: colyli@suse.de
X-Envelope-To: linux-bcache@vger.kernel.org
X-Envelope-To: linux-block@vger.kernel.org
X-Envelope-To: lkp@intel.com
Date: Fri, 28 Jun 2024 10:15:55 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, colyli@suse.de, linux-bcache@vger.kernel.org, 
	linux-block@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] bcache: work around a __bitwise to bool conversion
 sparse warning
Message-ID: <2znmmytmon4kfhpfqofcfei7ajl2d7wsz6nacio37ees66q6ag@7z3wdwa3ltdx>
References: <20240628131657.667797-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240628131657.667797-1-hch@lst.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 28, 2024 at 03:16:48PM +0200, Christoph Hellwig wrote:
> Sparse is a bit dumb about bitwise operation on __bitwise types used
> in boolean contexts.  Add a !! to explicitly propagate to boolean
> without a warning.
> 
> Fixes: fcf865e357f8 ("block: convert features and flags to __bitwise types")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Kent Overstreet <kent.overstreet@linux.dev>

> ---
>  drivers/md/bcache/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 283b2511c6d21f..b5d6ef430b86fc 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1416,8 +1416,8 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  	}
>  
>  	if (bdev_io_opt(dc->bdev))
> -		dc->partial_stripes_expensive = q->limits.features &
> -			BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
> +		dc->partial_stripes_expensive = !!(q->limits.features &
> +			BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE);
>  
>  	ret = bcache_device_init(&dc->disk, block_size,
>  			 bdev_nr_sectors(dc->bdev) - dc->sb.data_offset,
> -- 
> 2.43.0
> 


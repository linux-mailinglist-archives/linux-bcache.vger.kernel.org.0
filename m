Return-Path: <linux-bcache+bounces-856-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDA9A7F3DB
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 06:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49DCD1896E13
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 04:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F9C1CD1E0;
	Tue,  8 Apr 2025 04:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAfRmE6q"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2744529A2;
	Tue,  8 Apr 2025 04:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744088327; cv=none; b=MPPf8UctU9y7e973DtDcukMtJdqaZDjHDcC1zJitZmHAniUanuAyQNvpfGOqmES5hNo20gmESDgFH0GlxzO7dXuQ7gvq6RlZSuf475xcrrSDd34X6fLCeZmAfqeVMmyN4Zl0b29iUZgSa2F2+tPoDGBaeoPMLK8bDtDsmXbvxdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744088327; c=relaxed/simple;
	bh=NCA2SH3nfhAojGa3g1MbLvwbOTfzPUNub82XUWjladc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BiB/I3S2550+qZHMyyofxK3Sebn67YeetEUKmAuo/zYQ/At3lpHxu3x7Uj7Ilq6wWMvO9i3mhrbdt2lx+XRjXt3yfpMNn75TS/2o3dEL3HvVgGzxBBufcgahPGaZYAuN0r612Lpy4XKeXXhI91jx1c9HJeU74ddHMSOAhGlm0Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAfRmE6q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74769C4CEE5;
	Tue,  8 Apr 2025 04:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744088326;
	bh=NCA2SH3nfhAojGa3g1MbLvwbOTfzPUNub82XUWjladc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lAfRmE6qIqfRyd2z/Bjgo0X/dpcE9p6QizYOc9mC7gxFmsqfKtgmU21lHLIYRgD3h
	 2p0E1Ptzeoo1m8je4CfUNNWVvYNvQlxj1Us86KO7ufYuSNxlO8Y6wwxe/ND+E5/PGg
	 qMEx1Inf3My5oJdUeLjr5LFY3DWOZn1BDGORZf/eQ29UoIrCNO/dNYorSHiyUUmZNf
	 cjtTiZmu3AUDBvJcpuI5Kj4P999UWBNP4YhV1fvCR+6v9sL9Nln5XRCqZ7MjiClwGB
	 nnIL1EEVeM9ym5KQfY1crGQJurMtK9wMva4SBGPIFNvWTJbaBNnZsX1zgBVHtbOaa2
	 VNoycLSrCOmuQ==
Date: Tue, 8 Apr 2025 12:58:41 +0800
From: Coly Li <colyli@kernel.org>
To: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	kernelmentees@lists.linuxfoundation.org
Subject: Re: [PATCH 2/2] bcache: Fix warnings for incorrect type in
 assignments
Message-ID: <7muoawncdumcsclkcxklw6olqcjko63et26ptbh5lidximffoh@lu34aqtcujtn>
References: <20250408033322.401680-1-gshahrouzi@gmail.com>
 <20250408033322.401680-3-gshahrouzi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250408033322.401680-3-gshahrouzi@gmail.com>

On Mon, Apr 07, 2025 at 11:33:22PM +0800, Gabriel Shahrouzi wrote:
> Remove unnecessary cpu_to_le16() and cpu_to_le32() conversions when
> assigning values (priorities, timestamps) to native integer type
> members. Prevent incorrect byte ordering for big-endian systems.
> 

Hmm, why do you feel the conversions are unncessary? Please explain
with details.

I don't mean the modification is correct or incorrect, just want to
see detailed analysis and help me understand in correct why as you
are.

BTW, did you have chance to test your patch on big-endian machine?

Thanks.


> Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
> ---
>  drivers/md/bcache/super.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e42f1400cea9d..c4c5ca17fb600 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -648,7 +648,7 @@ int bch_prio_write(struct cache *ca, bool wait)
>  		for (b = ca->buckets + i * prios_per_bucket(ca);
>  		     b < ca->buckets + ca->sb.nbuckets && d < end;
>  		     b++, d++) {
> -			d->prio = cpu_to_le16(b->prio);
> +			d->prio = b->prio;
>  			d->gen = b->gen;
>  		}
>  
> @@ -721,7 +721,7 @@ static int prio_read(struct cache *ca, uint64_t bucket)
>  			d = p->data;
>  		}
>  
> -		b->prio = le16_to_cpu(d->prio);
> +		b->prio = d->prio;
>  		b->gen = b->last_gc = d->gen;
>  	}
>  
> @@ -832,7 +832,7 @@ static void bcache_device_detach(struct bcache_device *d)
>  
>  		SET_UUID_FLASH_ONLY(u, 0);
>  		memcpy(u->uuid, invalid_uuid, 16);
> -		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
> +		u->invalidated = (u32)ktime_get_real_seconds();
>  		bch_uuid_write(d->c);
>  	}
>  
> @@ -1188,7 +1188,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
>  int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
>  			  uint8_t *set_uuid)
>  {
> -	uint32_t rtime = cpu_to_le32((u32)ktime_get_real_seconds());
> +	uint32_t rtime = (u32)ktime_get_real_seconds();
>  	struct uuid_entry *u;
>  	struct cached_dev *exist_dc, *t;
>  	int ret = 0;
> @@ -1230,7 +1230,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
>  	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
>  	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
>  		memcpy(u->uuid, invalid_uuid, 16);
> -		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
> +		u->invalidated = (u32)ktime_get_real_seconds();
>  		u = NULL;
>  	}
>  
> @@ -1591,7 +1591,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
>  
>  	get_random_bytes(u->uuid, 16);
>  	memset(u->label, 0, 32);
> -	u->first_reg = u->last_reg = cpu_to_le32((u32)ktime_get_real_seconds());
> +	u->first_reg = u->last_reg = (u32)ktime_get_real_seconds();
>  
>  	SET_UUID_FLASH_ONLY(u, 1);
>  	u->sectors = size >> 9;
> -- 
> 2.43.0
> 

-- 
Coly Li


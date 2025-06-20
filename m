Return-Path: <linux-bcache+bounces-1143-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E99BAE1A5D
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Jun 2025 13:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E9AD1BC2B8C
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Jun 2025 11:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E29264A6E;
	Fri, 20 Jun 2025 11:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/nXUE54"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA4F223DFA;
	Fri, 20 Jun 2025 11:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750420742; cv=none; b=GL9hsC34J4g+kSsD+bdCZkEbTg6l8htQ8B8x6RyRqDCxTx6vWG61k6M56Z6t9YIMbODVGN6UDG4xUPGCCeVSyKdPcvV24EKft2baCUABU1wSkYeRy2XA4WQ6iN074Our3hyagJHnVpj7+54r3dK+g/TkN8DcSQ6owv+4rmOSJIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750420742; c=relaxed/simple;
	bh=Mi/AJLT7ejPY7tX/YpmXZttTM0u1iSXMtpI3Vg9vOOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvZDLOZ6osu8AmyRjiaw9TAkpII5V3L1qG0Dz3LMjnbj+6MusdZ1f0QdXrxsRO4WnuZkeE/3vMebnDDAa/bmfTwmHbsxJl0rLKuNi42bbbwGRwWYVnv5MEs3NknoLmxbs/LeKln0V2X1KUrvOyIVjtRB4Dv0aQ98bDaUeogDwZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/nXUE54; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A82C4CEE3;
	Fri, 20 Jun 2025 11:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750420741;
	bh=Mi/AJLT7ejPY7tX/YpmXZttTM0u1iSXMtpI3Vg9vOOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r/nXUE544Z2r07TDbn08l3r39svAZ84NQZ4LNKAqKs3SqcWLCy54MdVOTwB5UDe6s
	 Ge28OzFOUFUBs3DJdhyy+xtMqrFOnHQAAhBGSKKi3jN3H7H7wS4oRafsK50oU3ann0
	 Q2D+zGTuDcHiVwwJVrTOPXPPScNAerPK9SkJECkODZJ2s8cm0bA+Ko8RQDYiwfttFh
	 B14cUAfw0Qi9Zz7l3ye+oz66ZrwokehooNQwEegSLJ+SBdQSOxpA8SNaKpFvMznwLq
	 vfUQNXoZo4onjbdzlsOMXOy//IbkUpSB+TEkFSKKJTbJTu6/7nhQPs11lCDqgI8Kfe
	 6nAolBoRl0cTA==
Date: Fri, 20 Jun 2025 19:58:56 +0800
From: Coly Li <colyli@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] bcache: Use a folio
Message-ID: <avp5ecscfzz2ekasr3qr6fvyhxwijkwn5k3z6lq5emrcdagpyc@qvzxjtc3uetx>
References: <20250613191942.3169727-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250613191942.3169727-1-willy@infradead.org>

On Fri, Jun 13, 2025 at 08:19:39PM +0800, Matthew Wilcox (Oracle) wrote:
> Retrieve a folio from the page cache instead of a page.  Removes a
> hidden call to compound_head().  Then be sure to call folio_put()
> instead of put_page() to release it.  That doesn't save any calls
> to compound_head(), just moves them around.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-back: Coly Li <colyli@kernel.org>

The patch looks fine and works well. If you want this patch to go upstream
by your path, please add my Acked-by.

Otherwise I can submit it to Jens with my Signed-off-by.

Thanks.

Coly Li


> ---
>  drivers/md/bcache/super.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1efb768b2890..83c786a5cc47 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -168,14 +168,14 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>  {
>  	const char *err;
>  	struct cache_sb_disk *s;
> -	struct page *page;
> +	struct folio *folio;
>  	unsigned int i;
>  
> -	page = read_cache_page_gfp(bdev->bd_mapping,
> -				   SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
> -	if (IS_ERR(page))
> +	folio = mapping_read_folio_gfp(bdev->bd_mapping,
> +			SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
> +	if (IS_ERR(folio))
>  		return "IO error";
> -	s = page_address(page) + offset_in_page(SB_OFFSET);
> +	s = folio_address(folio) + offset_in_folio(folio, SB_OFFSET);
>  
>  	sb->offset		= le64_to_cpu(s->offset);
>  	sb->version		= le64_to_cpu(s->version);
> @@ -272,7 +272,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>  	*res = s;
>  	return NULL;
>  err:
> -	put_page(page);
> +	folio_put(folio);
>  	return err;
>  }
>  
> @@ -1366,7 +1366,7 @@ static CLOSURE_CALLBACK(cached_dev_free)
>  	mutex_unlock(&bch_register_lock);
>  
>  	if (dc->sb_disk)
> -		put_page(virt_to_page(dc->sb_disk));
> +		folio_put(virt_to_folio(dc->sb_disk));
>  
>  	if (dc->bdev_file)
>  		fput(dc->bdev_file);
> @@ -2215,7 +2215,7 @@ void bch_cache_release(struct kobject *kobj)
>  		free_fifo(&ca->free[i]);
>  
>  	if (ca->sb_disk)
> -		put_page(virt_to_page(ca->sb_disk));
> +		folio_put(virt_to_folio(ca->sb_disk));
>  
>  	if (ca->bdev_file)
>  		fput(ca->bdev_file);
> @@ -2592,7 +2592,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	if (!holder) {
>  		ret = -ENOMEM;
>  		err = "cannot allocate memory";
> -		goto out_put_sb_page;
> +		goto out_put_sb_folio;
>  	}
>  
>  	/* Now reopen in exclusive mode with proper holder */
> @@ -2666,8 +2666,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  
>  out_free_holder:
>  	kfree(holder);
> -out_put_sb_page:
> -	put_page(virt_to_page(sb_disk));
> +out_put_sb_folio:
> +	folio_put(virt_to_folio(sb_disk));
>  out_blkdev_put:
>  	if (bdev_file)
>  		fput(bdev_file);
> -- 
> 2.47.2
> 
> 


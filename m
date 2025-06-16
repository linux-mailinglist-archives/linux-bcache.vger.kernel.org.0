Return-Path: <linux-bcache+bounces-1142-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 460C4ADA81B
	for <lists+linux-bcache@lfdr.de>; Mon, 16 Jun 2025 08:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C51516E190
	for <lists+linux-bcache@lfdr.de>; Mon, 16 Jun 2025 06:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D5F61CF5C6;
	Mon, 16 Jun 2025 06:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioQACaDt"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B56156228;
	Mon, 16 Jun 2025 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750054774; cv=none; b=awNituYnq8ywRXiI1LA9RvhLvftSZXmqEW0WIql4RBnLJPfrjr2RHyJEVKXG9G89xWg/5Sl/G+ng/TNmRvr7zCy9Rm0SPnJ5uCcP4MpgiajX7Bjz7KLzvVWialou8HTrfOEX+i2XSeWr8zRcLikw2szXT1Mfp6I1uB//aTAPnOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750054774; c=relaxed/simple;
	bh=PwoDpo6CtYxteSGqWYWEaQGKGibhDwIXR2Zxa4oPxo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2nu6nMSMWQdR/B12F7bnCY0KcnGevSmN8oU8V9SQNK1sxyh5q18oSLWdownLvTLC2a5h1aGvN8bWWmOV4TRyfcuNYHQj7aSv1w5RFGr8WaH5EnWUjlROh0FAFWZy67jYDj9QgoJCSCt/vPxPn7aaRIrRozAA1WJeJmw8dPiOD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioQACaDt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9A6C4CEEA;
	Mon, 16 Jun 2025 06:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750054773;
	bh=PwoDpo6CtYxteSGqWYWEaQGKGibhDwIXR2Zxa4oPxo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ioQACaDtrf3y5MSDYBB7beyei/Vf5Psf0PmG2W/6PAFfGejuiV8RaOyCLSSuWGEnf
	 9Xa16tOdt//OkKWvozRLPHK2W7glD0TJ2wnrlTHI33ITFRZHfhpfup2agZlDWZuzkw
	 OQQ9hxmULMzh3FDxPvsH+2j0vD4PdlrhCVj8rLujmzzy7d77hGbO2dltXzy8H19MPw
	 KThXIKMngxKGTJuWOs/rju4X1Q/uSNrN9JRKbEwLEY2ilpsAo14lilzNvFihD9Z+HN
	 Dckt5rfuHIjOzC0zekz7OxJ16l539kCTlZ9WLzpEoxDAMd+m7Ogdm1fXXtE7GSJ6NQ
	 OteQY296MQNmA==
Date: Mon, 16 Jun 2025 14:19:30 +0800
From: Coly Li <colyli@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] bcache: Use a folio
Message-ID: <4h542zrzxd2cdetymvw7txrgdpony452cxej26msqprcfpu23h@kxgiywm76dwt>
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

Hi Matthew,

Overall the patch is fine to me. I will reply you after doing some basic testing.

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


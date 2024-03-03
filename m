Return-Path: <linux-bcache+bounces-284-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9425986F624
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Mar 2024 17:34:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4263B28189A
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Mar 2024 16:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359526D1BF;
	Sun,  3 Mar 2024 16:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CDUUMA9W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/Tcb0KQJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CDUUMA9W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/Tcb0KQJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6FBF9CB;
	Sun,  3 Mar 2024 16:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709483643; cv=none; b=rXRJfPQ/gbuEAVsFYtvbLkoKyWmADK1DQpN+Hy4Wn2VA7txvSNCkqu2txwAzT0Ik5hxFse7Io3UvMM6dm75eKqLbrmIE1ojho7NqlbVLK7Pp2xHB3H+G9DwsRWYatJwIwpLAtzZvcNZl1v3XMKiH1PwFU5MtehX83DS2u4Wqj+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709483643; c=relaxed/simple;
	bh=BlvSj1v2d3XclabTcNZA3Zkwmh5yE6aDItczXBYuc24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nh0irAkA6LtzRVMZyF6x3dlJn3QwgQ7Jp4477UzxiCR5fvIXsPTDIWBvBexIXMk2gaY2J5Jem7Ydae4sj4r1RfxJPQ8gWiX4H5K1tfFHIejrz/6Rx542N3oN9TQOgYpMAitOiynwoXx7nqWn2w6N4X5DODW+TGamlzr2MHtdSxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CDUUMA9W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/Tcb0KQJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CDUUMA9W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/Tcb0KQJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 950E6610F1;
	Sun,  3 Mar 2024 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709483632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgYXiJduXPXsodx25AjnH4FPbMThuU2OAntFAMDV9KU=;
	b=CDUUMA9WLzYm1gA/KQ8esbh3M/1bvOaWC2WuUQ7ZnzGYvBbhcX8rRpq/+yZIyJm6QFsWqn
	TpOFEinyLt0NIi0UZV4rx1oOEexInAxDr1jaonTBcCzSJbbfR8TF0swN4fMwlMoKYVFI9b
	5axPr+4tf60COyAtb3DNR+atkgseNU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709483632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgYXiJduXPXsodx25AjnH4FPbMThuU2OAntFAMDV9KU=;
	b=/Tcb0KQJ9knvGvxVv9qIWH1cmIM10s5rc8Ne+2Hz+u5HqFgv65ejG3G/pYfDkf03vF+rXk
	vCQAYuVFPG2hEqDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709483632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgYXiJduXPXsodx25AjnH4FPbMThuU2OAntFAMDV9KU=;
	b=CDUUMA9WLzYm1gA/KQ8esbh3M/1bvOaWC2WuUQ7ZnzGYvBbhcX8rRpq/+yZIyJm6QFsWqn
	TpOFEinyLt0NIi0UZV4rx1oOEexInAxDr1jaonTBcCzSJbbfR8TF0swN4fMwlMoKYVFI9b
	5axPr+4tf60COyAtb3DNR+atkgseNU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709483632;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UgYXiJduXPXsodx25AjnH4FPbMThuU2OAntFAMDV9KU=;
	b=/Tcb0KQJ9knvGvxVv9qIWH1cmIM10s5rc8Ne+2Hz+u5HqFgv65ejG3G/pYfDkf03vF+rXk
	vCQAYuVFPG2hEqDw==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 59AF7133B5;
	Sun,  3 Mar 2024 16:33:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id zEwlA26m5GVOWAAAn2gu4w
	(envelope-from <colyli@suse.de>); Sun, 03 Mar 2024 16:33:50 +0000
Date: Mon, 4 Mar 2024 00:33:43 +0800
From: Coly Li <colyli@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH] bcache: move calculation of stripe_size and io_opt into
 bcache_device_init
Message-ID: <sdnjcxp7ief6fmfwrooxyqrrld4wwqjum5jyngz7nktckzoy5u@3g4ppphlfqp7>
References: <20240226104826.283067-1-hch@lst.de>
 <20240226104826.283067-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240226104826.283067-2-hch@lst.de>
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=CDUUMA9W;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/Tcb0KQJ"
X-Spamd-Result: default: False [0.18 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.01)[46.13%]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: 0.18
X-Rspamd-Queue-Id: 950E6610F1
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Bar: /

On Mon, Feb 26, 2024 at 11:48:26AM +0100, Christoph Hellwig wrote:
> bcache currently calculates the stripe size for the non-cached_dev
> case directly in bcache_device_init, but for the cached_dev case it does
> it in the caller.  Consolidate it in one places, which also enables
> setting the io_opt queue_limit before allocating the gendisk so that it
> can be passed in instead of changing the limit just after the allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Coly Li <colyli@suse.de>

Thanks.


Coly Li


> ---
>  drivers/md/bcache/super.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index d06a9649d30269..f716c3265f5cf0 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -913,6 +913,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	uint64_t n;
>  	int idx;
>  
> +	if (cached_bdev) {
> +		d->stripe_size = bdev_io_opt(cached_bdev) >> SECTOR_SHIFT;
> +		lim.io_opt = umax(block_size, bdev_io_opt(cached_bdev));
> +	}
>  	if (!d->stripe_size)
>  		d->stripe_size = 1 << 31;
>  	else if (d->stripe_size < BCH_MIN_STRIPE_SZ)
> @@ -1418,9 +1422,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  		hlist_add_head(&io->hash, dc->io_hash + RECENT_IO);
>  	}
>  
> -	dc->disk.stripe_size = q->limits.io_opt >> 9;
> -
> -	if (dc->disk.stripe_size)
> +	if (bdev_io_opt(dc->bdev))
>  		dc->partial_stripes_expensive =
>  			q->limits.raid_partial_stripes_expensive;
>  
> @@ -1430,9 +1432,6 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  	if (ret)
>  		return ret;
>  
> -	blk_queue_io_opt(dc->disk.disk->queue,
> -		max(queue_io_opt(dc->disk.disk->queue), queue_io_opt(q)));
> -
>  	atomic_set(&dc->io_errors, 0);
>  	dc->io_disable = false;
>  	dc->error_limit = DEFAULT_CACHED_DEV_ERROR_LIMIT;


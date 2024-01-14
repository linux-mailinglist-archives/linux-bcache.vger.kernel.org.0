Return-Path: <linux-bcache+bounces-228-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A127382D121
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Jan 2024 16:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 110B91C20BFF
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Jan 2024 15:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEE923C6;
	Sun, 14 Jan 2024 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yfYDL8jm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/53U8nSP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yfYDL8jm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/53U8nSP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15767E;
	Sun, 14 Jan 2024 15:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 186791F800;
	Sun, 14 Jan 2024 15:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705245397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=076w5od7kF2YEfcTBD90+IgJV1k7VqdmZs66NXRF1w0=;
	b=yfYDL8jmRHrYLP1P3/b+p8/5f41dvrGZYO3I/L44lcNDJT4+e41uPLBWksgu5YJ4HjIrx0
	8sdsdPj1IBivyW270ZP0rv5iW7oN5XpTYK3w7cp6x2RI1jLls7Ox1wNAHMb4AuO0PNbYIM
	FbbkkdC/bBWahJtlHhUUgUuPFRsjWxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705245397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=076w5od7kF2YEfcTBD90+IgJV1k7VqdmZs66NXRF1w0=;
	b=/53U8nSPl7no6mmAQ+hhQd4II6sI5yAJKA5s7N5j6WeQW9wN8cXREX7IP2Hhg0A1lZ8Yft
	Jz0rt5cr7/+VkPBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1705245397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=076w5od7kF2YEfcTBD90+IgJV1k7VqdmZs66NXRF1w0=;
	b=yfYDL8jmRHrYLP1P3/b+p8/5f41dvrGZYO3I/L44lcNDJT4+e41uPLBWksgu5YJ4HjIrx0
	8sdsdPj1IBivyW270ZP0rv5iW7oN5XpTYK3w7cp6x2RI1jLls7Ox1wNAHMb4AuO0PNbYIM
	FbbkkdC/bBWahJtlHhUUgUuPFRsjWxw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1705245397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=076w5od7kF2YEfcTBD90+IgJV1k7VqdmZs66NXRF1w0=;
	b=/53U8nSPl7no6mmAQ+hhQd4II6sI5yAJKA5s7N5j6WeQW9wN8cXREX7IP2Hhg0A1lZ8Yft
	Jz0rt5cr7/+VkPBg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id DBCDB1331A;
	Sun, 14 Jan 2024 15:16:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id R2QKI9L6o2UQWAAAn2gu4w
	(envelope-from <colyli@suse.de>); Sun, 14 Jan 2024 15:16:34 +0000
Date: Sun, 14 Jan 2024 23:16:31 +0800
From: Coly Li <colyli@suse.de>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-bcache@vger.kernel.org
Subject: Re: [PATCH] bcache: Remove usage of the deprecated ida_simple_xx()
 API
Message-ID: <y2c3dt325d4xzcknmwtyd6gungco6jqucz3fsrm6lsyjtiwpp4@ozmsw6vp67jk>
References: <2f038df3860c2f44d5c7f5d06d03ca663cdbc651.1705235398.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2f038df3860c2f44d5c7f5d06d03ca663cdbc651.1705235398.git.christophe.jaillet@wanadoo.fr>
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yfYDL8jm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/53U8nSP"
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.01 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[wanadoo.fr];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	 RCPT_COUNT_FIVE(0.00)[5];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FREEMAIL_TO(0.00)[wanadoo.fr];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -1.01
X-Rspamd-Queue-Id: 186791F800
X-Spam-Flag: NO

On Sun, Jan 14, 2024 at 01:30:16PM +0100, Christophe JAILLET wrote:
> ida_alloc() and ida_free() should be preferred to the deprecated
> ida_simple_get() and ida_simple_remove().
> 
> Note that the upper limit of ida_simple_get() is exclusive, but the one of
> ida_alloc_max() is inclusive. So a -1 has been added when needed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

It looks good to me. Add this patch into my testing directory.

Thanks.

Coly Li


> ---
>  drivers/md/bcache/super.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index dc3f50f69714..a2eecd1db126 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -881,8 +881,8 @@ static void bcache_device_free(struct bcache_device *d)
>  		bcache_device_detach(d);
>  
>  	if (disk) {
> -		ida_simple_remove(&bcache_device_idx,
> -				  first_minor_to_idx(disk->first_minor));
> +		ida_free(&bcache_device_idx,
> +			 first_minor_to_idx(disk->first_minor));
>  		put_disk(disk);
>  	}
>  
> @@ -926,8 +926,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	if (!d->full_dirty_stripes)
>  		goto out_free_stripe_sectors_dirty;
>  
> -	idx = ida_simple_get(&bcache_device_idx, 0,
> -				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
> +	idx = ida_alloc_max(&bcache_device_idx, BCACHE_DEVICE_IDX_MAX - 1,
> +			    GFP_KERNEL);
>  	if (idx < 0)
>  		goto out_free_full_dirty_stripes;
>  
> @@ -980,7 +980,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  out_bioset_exit:
>  	bioset_exit(&d->bio_split);
>  out_ida_remove:
> -	ida_simple_remove(&bcache_device_idx, idx);
> +	ida_free(&bcache_device_idx, idx);
>  out_free_full_dirty_stripes:
>  	kvfree(d->full_dirty_stripes);
>  out_free_stripe_sectors_dirty:
> -- 
> 2.43.0
> 

-- 
Coly Li


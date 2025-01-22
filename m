Return-Path: <linux-bcache+bounces-841-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D26A18B1B
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Jan 2025 05:43:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3228D7A4BBB
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Jan 2025 04:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFEB61487FE;
	Wed, 22 Jan 2025 04:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FQ4qPQ6k";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GDNiNZRE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FQ4qPQ6k";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GDNiNZRE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6F4323D
	for <linux-bcache@vger.kernel.org>; Wed, 22 Jan 2025 04:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737520991; cv=none; b=lFsrf3XxuKEdWKhu7yWfKlZepi6YdrXj2N34uI1nH8mmWDYWXyb9lo4lftIcbUKQL2uIbTvLjKNxeua2+X9/XdsqlwpboORP0+bAtombkD26dIOBM+O7woR+YoO81u3/5/9QiJ2/mH+shw0pVXF1D7/vGK88U99Iq/Od4q1hJr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737520991; c=relaxed/simple;
	bh=aXJnklLp82WZv4vOG0qcxSXcpk1JIGculspE+SYMimI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oESL9015QcOppVnqnba+4EVY2hzfSV9NIuzmZebKqlzSoJpCviyzvu4Uari2ioXI/OP8CViL9gNYiLvV6uokUMa6faHzc1fxr5HKacFYagd+azHvKMRZCLioyKI39BtzFLuwSpYgU3BJfaxSyWAwyOQxH+nUzQDXtZqCfCzkWrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FQ4qPQ6k; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GDNiNZRE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FQ4qPQ6k; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GDNiNZRE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD2B01F789;
	Wed, 22 Jan 2025 04:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737520987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wqXlgyoTRmKwX4gtrsIZDmXWGSvvDUHBJrq5nfvVbVA=;
	b=FQ4qPQ6kmESielHnn3p4MZfe2gkFyzN2EEBFtHJVgx3Hv2mN/dCiqMCLt1P1/jXtNWmZMw
	3Qn6Fpu9xba0+VuaXjNNIQNel3bAWVgwphEd0Uz5x/OBm1t2l5fguW8JAHUF1yzxF+GRh/
	iJazvP7C4AGEXE6ERBe5kN/w76aK8b4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737520987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wqXlgyoTRmKwX4gtrsIZDmXWGSvvDUHBJrq5nfvVbVA=;
	b=GDNiNZREwIOva0QLuxmpLVeMFwp5WQ5h6FAyiBS5f6s0DaBqanY2njgxoqGAXYh+mO9KOs
	kigy93ZNnK0tgoCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FQ4qPQ6k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GDNiNZRE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737520987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wqXlgyoTRmKwX4gtrsIZDmXWGSvvDUHBJrq5nfvVbVA=;
	b=FQ4qPQ6kmESielHnn3p4MZfe2gkFyzN2EEBFtHJVgx3Hv2mN/dCiqMCLt1P1/jXtNWmZMw
	3Qn6Fpu9xba0+VuaXjNNIQNel3bAWVgwphEd0Uz5x/OBm1t2l5fguW8JAHUF1yzxF+GRh/
	iJazvP7C4AGEXE6ERBe5kN/w76aK8b4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737520987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wqXlgyoTRmKwX4gtrsIZDmXWGSvvDUHBJrq5nfvVbVA=;
	b=GDNiNZREwIOva0QLuxmpLVeMFwp5WQ5h6FAyiBS5f6s0DaBqanY2njgxoqGAXYh+mO9KOs
	kigy93ZNnK0tgoCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53F3D136A1;
	Wed, 22 Jan 2025 04:43:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +ZBbA1p3kGevNgAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 22 Jan 2025 04:43:06 +0000
Date: Wed, 22 Jan 2025 12:42:59 +0800
From: Coly Li <colyli@suse.de>
To: mingzhe.zou@easystack.cn
Cc: linux-bcache@vger.kernel.org, dongsheng.yang@easystack.cn, 
	zoumingzhe@qq.com
Subject: Re: [PATCH v2 1/3] bcache: avoid invalidating buckets in use
Message-ID: <4r4vgsftskzardq4fndoamvhua22mhe6nzyoowguznhiiwwzg7@sw44gkioflgf>
References: <20241119074031.27340-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241119074031.27340-1-mingzhe.zou@easystack.cn>
X-Rspamd-Queue-Id: BD2B01F789
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,easystack.cn,qq.com];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO

On Tue, Nov 19, 2024 at 03:40:29PM +0800, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> If the bucket was reused while our bio was in flight, we might
> have read the wrong data. Currently, we will reread the data from
> the backing device. This not only reduces performance, but also
> makes the process more complex.
> 
> When the bucket is in use, we hope not to reclaim it.
>

No please don't do this.

This is the essential designment of bcache buckets, concurrent access
is expected and permitted. Locked the bucket and prohibit detectable
race is a huge change to the whole code logic, may introduce potential
issue which I am not able to tell immediately.

I know although the upper layer code or application should retry with
an I/O error code received, but most of the cases it is very hard to
modify the deployed software. Maybe a feasible fix is to set the error
code to AGAIN, and before returning to upper layer code if the error
code is AGAIN other than ERROR, re-submit the bio again from a worker.

Anyway, this is just a quite rough idea, I don't think over it
carefully.

Thanks.

Coly Li


 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>  drivers/md/bcache/alloc.c  | 32 +++++++++++++++++++++++---------
>  drivers/md/bcache/bcache.h |  3 ++-
>  2 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index da50f6661bae..18441aa74229 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -134,25 +134,41 @@ bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b)
>  	       !atomic_read(&b->pin) && can_inc_bucket_gen(b));
>  }
>  
> -void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
> +bool __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
>  {
>  	lockdep_assert_held(&ca->set->bucket_lock);
>  	BUG_ON(GC_MARK(b) && GC_MARK(b) != GC_MARK_RECLAIMABLE);
>  
> +	if (!spin_trylock(&b->lock))
> +		return false;
> +
> +	/*
> +	 * If the bucket was reused while read bio was in flight, it will
> +	 * reread the data from the backing device. This will increase latency
> +	 * and cause other errors. When b->pin is not 0, do not invalidate
> +	 * the bucket.
> +	 */
> +
> +	if (atomic_inc_return(&b->pin) > 1) {
> +		atomic_dec(&b->pin);
> +		spin_unlock(&b->lock);
> +		return false;
> +	}
> +
>  	if (GC_SECTORS_USED(b))
>  		trace_bcache_invalidate(ca, b - ca->buckets);
>  
>  	bch_inc_gen(ca, b);
>  	b->prio = INITIAL_PRIO;
> -	atomic_inc(&b->pin);
>  	b->reclaimable_in_gc = 0;
> +	spin_unlock(&b->lock);
> +	return true;
>  }
>  
>  static void bch_invalidate_one_bucket(struct cache *ca, struct bucket *b)
>  {
> -	__bch_invalidate_one_bucket(ca, b);
> -
> -	fifo_push(&ca->free_inc, b - ca->buckets);
> +	if (bch_can_invalidate_bucket(ca, b) && __bch_invalidate_one_bucket(ca, b))
> +		fifo_push(&ca->free_inc, b - ca->buckets);
>  }
>  
>  /*
> @@ -253,8 +269,7 @@ static void invalidate_buckets_fifo(struct cache *ca)
>  
>  		b = ca->buckets + ca->fifo_last_bucket++;
>  
> -		if (bch_can_invalidate_bucket(ca, b))
> -			bch_invalidate_one_bucket(ca, b);
> +		bch_invalidate_one_bucket(ca, b);
>  
>  		if (++checked >= ca->sb.nbuckets) {
>  			ca->invalidate_needs_gc = 1;
> @@ -279,8 +294,7 @@ static void invalidate_buckets_random(struct cache *ca)
>  
>  		b = ca->buckets + n;
>  
> -		if (bch_can_invalidate_bucket(ca, b))
> -			bch_invalidate_one_bucket(ca, b);
> +		bch_invalidate_one_bucket(ca, b);
>  
>  		if (++checked >= ca->sb.nbuckets / 2) {
>  			ca->invalidate_needs_gc = 1;
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 785b0d9008fa..fc7f10c5f222 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -196,6 +196,7 @@
>  
>  struct bucket {
>  	atomic_t	pin;
> +	spinlock_t	lock;
>  	uint16_t	prio;
>  	uint8_t		gen;
>  	uint8_t		last_gc; /* Most out of date gen in the btree */
> @@ -981,7 +982,7 @@ uint8_t bch_inc_gen(struct cache *ca, struct bucket *b);
>  void bch_rescale_priorities(struct cache_set *c, int sectors);
>  
>  bool bch_can_invalidate_bucket(struct cache *ca, struct bucket *b);
> -void __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b);
> +bool __bch_invalidate_one_bucket(struct cache *ca, struct bucket *b);
>  
>  void __bch_bucket_free(struct cache *ca, struct bucket *b);
>  void bch_bucket_free(struct cache_set *c, struct bkey *k);
> -- 
> 2.34.1
> 
> 

-- 
Coly Li


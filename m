Return-Path: <linux-bcache+bounces-840-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FD4A18B0C
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Jan 2025 05:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94C0216B836
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Jan 2025 04:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276A215383C;
	Wed, 22 Jan 2025 04:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KQv6kGcw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DsuLcDuT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bZxlXJc6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bIM2tA6Z"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA9014885D
	for <linux-bcache@vger.kernel.org>; Wed, 22 Jan 2025 04:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737520465; cv=none; b=nQOMLdxJFJ69aAmDkM8UvV9/HyM+1E4v+hIELIjrgp/3qMPHxc+ddmDeYt+8W4EnMvgVeKjxrX7KP2mAUyREtWBeubdiIyNLN9MOVUGlRdn5sDb2OojdJBTwtPO1RdNuU5aHZ9nC4sU2koSL+lmKTavlh9H5/i82teCfEYzTYC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737520465; c=relaxed/simple;
	bh=DgN4Ci0YzWPQAMJInX1yu0PBYKKs53Uzx784eQRNGRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dBnhGNH3p++NlM8kvBG1GYmTgZ8SEyvavPAPjKxZXUFpaDFSI70pkVOw3DuYonmnhkZ7czfpxoN3GVdTI2762Kn0WvjOMgRg/sNcW2aI2SDhiKPzFFjJWHSFP1n3MWoP7aKYQhYRC2/XZM47riImORZAz8GNo6pSARdnCO+C5uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KQv6kGcw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DsuLcDuT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bZxlXJc6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bIM2tA6Z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E23231F789;
	Wed, 22 Jan 2025 04:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737520461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KFS0izezOfBMf2UYNcTma+fhZJqc1EgRLm2qz5KlGZc=;
	b=KQv6kGcwhwE5bMmKCfPpZPVJubJ6PpewBmzKfrgCe4/TXZZTEl4facrbdI8QwnsA031Lp3
	Mzg3KfaJkr/UmwwNChFF5u1DVfenBVR9BP79Q0MMsWkfMmewEdPHv1SRI+ooZW1W6wR4ZB
	0vi7FUbvf5HTa/oOxxPlnd+ij0VOYyM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737520461;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KFS0izezOfBMf2UYNcTma+fhZJqc1EgRLm2qz5KlGZc=;
	b=DsuLcDuTn/s4IHILwCft7e1bwUkBKLX9vhh8UnknIE4/fbisvC/0318ZxWvP06FyWNW1hj
	7TYaFt8u4fCAbXBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bZxlXJc6;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bIM2tA6Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737520460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KFS0izezOfBMf2UYNcTma+fhZJqc1EgRLm2qz5KlGZc=;
	b=bZxlXJc6EDGi9qxoJX8OvVHZrrDG7MgoMckH55DJiXFMpUHoyIgaXr6BkOPVUXQGqLSDmP
	yjtZG/AXoVxNC2/7q5UXuJkbFbi9icC6jrteKTKG1HsFi7KtDC+RUnkY64UePiMzsGqiOC
	IBytWFjnDWQ12P7Do+/20hmkYWvuUxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737520460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KFS0izezOfBMf2UYNcTma+fhZJqc1EgRLm2qz5KlGZc=;
	b=bIM2tA6ZexwVHDEiw7cF+PBQ7fJcHuOz7WNxW2RD6Ruq1q+rZC6IvfmJuVEmQOVftSqwLQ
	GiflJo0z5WazqEAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0435136A1;
	Wed, 22 Jan 2025 04:34:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GBH+J0p1kGfmEwAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 22 Jan 2025 04:34:18 +0000
Date: Wed, 22 Jan 2025 12:34:12 +0800
From: Coly Li <colyli@suse.de>
To: mingzhe.zou@easystack.cn
Cc: linux-bcache@vger.kernel.org, dongsheng.yang@easystack.cn, 
	zoumingzhe@qq.com
Subject: Re: [PATCH] bcache: fix journal full and c->root write not flushed
Message-ID: <kwxbhcz3i7sbdqetd6zjo3lnzjjrtbvkgopqh4rodwydnrmpaw@hjwjgevpl2mq>
References: <20250109032304.1040957-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250109032304.1040957-1-mingzhe.zou@easystack.cn>
X-Rspamd-Queue-Id: E23231F789
X-Spam-Score: -4.01
X-Rspamd-Action: no action
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Thu, Jan 09, 2025 at 11:23:04AM +0800, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> When we use a new cache device for performance testing, the (bs=4k, iodepth=1)
> write result is abnormal. With a cycle of 30 seconds, IOPS drop to 0 within 10
> seconds, and then recover after 30 seconds.
> 
> After debugging, we found that journal is full and btree_node_write_work() runs
> at least 30 seconds apart. However, when the journal is full, we expect to call
> btree_flush_write() to release the oldest journal entry. Obviously, flush write
> failed to release the journal.
> 
> View the code, we found that the btree_flush_write() only select flushing btree
> node from c->btree_cache list. However, list_del_init(&b->list) will be called
> in bch_btree_set_root(), so the c->root is not in the c->btree_cache list.
> 
> For a new cache, there was only one btree node before btree split. This patch
> hopes to flush c->root write when the journal is full.
> 
> Fixes: 91be66e1 (bcache: performance improvement for btree_flush_write())
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

Hi Mingzhe,

Thanks for the patch. Though I am not supportive to this patch, my opinion
is placed inline where it is concerned.

> ---
>  drivers/md/bcache/journal.c | 86 ++++++++++++++++++++-----------------
>  1 file changed, 46 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
> index 7ff14bd2feb8..837073fe5e5a 100644
> --- a/drivers/md/bcache/journal.c
> +++ b/drivers/md/bcache/journal.c
> @@ -413,13 +413,53 @@ void bch_journal_space_reserve(struct journal *j)
>  
>  /* Journalling */
>  
> +static inline bool btree_need_flush_write(struct btree *b, atomic_t *front)
> +{
> +	if (btree_node_journal_flush(b))
> +		pr_err("BUG: flush_write bit should not be set here!\n");
> +
> +	mutex_lock(&b->write_lock);
> +
> +	if (!btree_node_dirty(b)) {
> +		mutex_unlock(&b->write_lock);
> +		return false;
> +	}
> +
> +	if (!btree_current_write(b)->journal) {
> +		mutex_unlock(&b->write_lock);
> +		return false;
> +	}
> +
> +	/*
> +	 * Only select the btree node which exactly references
> +	 * the oldest journal entry.
> +	 *
> +	 * If the journal entry pointed by fifo_front_p is
> +	 * reclaimed in parallel, don't worry:
> +	 * - the list_for_each_xxx loop will quit when checking
> +	 *   next now_fifo_front_p.
> +	 * - If there are matched nodes recorded in btree_nodes[],
> +	 *   they are clean now (this is why and how the oldest
> +	 *   journal entry can be reclaimed). These selected nodes
> +	 *   will be ignored and skipped in the folowing for-loop.
> +	 */
> +	if ((btree_current_write(b)->journal - front) & b->c->journal.pin.mask) {
> +		mutex_unlock(&b->write_lock);
> +		return false;
> +	}
> +
> +	set_btree_node_journal_flush(b);
> +
> +	mutex_unlock(&b->write_lock);
> +	return true;
> +}
> +
>  static void btree_flush_write(struct cache_set *c)
>  {
>  	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
>  	unsigned int i, nr;
>  	int ref_nr;
>  	atomic_t *fifo_front_p, *now_fifo_front_p;
> -	size_t mask;
>  
>  	if (c->journal.btree_flushing)
>  		return;
> @@ -446,12 +486,14 @@ static void btree_flush_write(struct cache_set *c)
>  	}
>  	spin_unlock(&c->journal.lock);
>  
> -	mask = c->journal.pin.mask;
>  	nr = 0;
>  	atomic_long_inc(&c->flush_write);
>  	memset(btree_nodes, 0, sizeof(btree_nodes));
>  
>  	mutex_lock(&c->bucket_lock);
> +	if (btree_need_flush_write(c->root, fifo_front_p))
> +		btree_nodes[nr++] = c->root;
> +

c->root never goes though the journal code path. All internal btree nodes
are flushed synchronically in plac where it is updated.

E.g. in drivers/md/bcache/btree.c:btree_split(), after a leaf btree ndoe
splitted, and the parent internal node is updated, bch_btree_node_write()
is called immediately to flush the dirty internal btree node. The journal
code path is not involved in.


>  	list_for_each_entry_safe_reverse(b, t, &c->btree_cache, list) {
>  		/*
>  		 * It is safe to get now_fifo_front_p without holding
> @@ -476,45 +518,9 @@ static void btree_flush_write(struct cache_set *c)
>  		if (nr >= ref_nr)
>  			break;
>  
> -		if (btree_node_journal_flush(b))
> -			pr_err("BUG: flush_write bit should not be set here!\n");
> -
> -		mutex_lock(&b->write_lock);
> -
> -		if (!btree_node_dirty(b)) {
> -			mutex_unlock(&b->write_lock);
> -			continue;
> -		}
> -
> -		if (!btree_current_write(b)->journal) {
> -			mutex_unlock(&b->write_lock);
> -			continue;
> -		}
> -
> -		/*
> -		 * Only select the btree node which exactly references
> -		 * the oldest journal entry.
> -		 *
> -		 * If the journal entry pointed by fifo_front_p is
> -		 * reclaimed in parallel, don't worry:
> -		 * - the list_for_each_xxx loop will quit when checking
> -		 *   next now_fifo_front_p.
> -		 * - If there are matched nodes recorded in btree_nodes[],
> -		 *   they are clean now (this is why and how the oldest
> -		 *   journal entry can be reclaimed). These selected nodes
> -		 *   will be ignored and skipped in the following for-loop.
> -		 */
> -		if (((btree_current_write(b)->journal - fifo_front_p) &
> -		     mask) != 0) {
> -			mutex_unlock(&b->write_lock);
> -			continue;
> -		}
> -
> -		set_btree_node_journal_flush(b);
> -
> -		mutex_unlock(&b->write_lock);
> +		if (btree_need_flush_write(b, fifo_front_p))
> +			btree_nodes[nr++] = b;
>  
> -		btree_nodes[nr++] = b;
>  		/*
>  		 * To avoid holding c->bucket_lock too long time,
>  		 * only scan for BTREE_FLUSH_NR matched btree nodes
> -- 

If c->root is forced accessed here, I assume a potential race against
normal root node flush code path will be introduced.

And the I/O hang was not from here. IMHO the root cause is journal space
is not big enough. When journal is blocked, the jouranl flushing code is
busy on flushing all bkeys in the oldest jset. Flushing root node will
follow a bch_journal_meta(), which will add the key of root node into
a jset and flush this jset into journal area. And at this moment journal
space is full and busy flushing, so even your code works it will
introduce more journal workload....

Just my opinion for your reference.

-- 
Coly Li


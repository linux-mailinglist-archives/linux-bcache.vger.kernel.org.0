Return-Path: <linux-bcache+bounces-816-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB399E08CE
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 17:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE1B01658AB
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 16:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EA2D17DFE1;
	Mon,  2 Dec 2024 16:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ahqwgH8C";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RNGkqSZy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="fyYYPtB3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jWlh3xnw"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4C517D366;
	Mon,  2 Dec 2024 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733156482; cv=none; b=eqQvhRpnstC5bcw/5uBKqa8t75MLqR0xJzHtA6biUWFSoXYeaX6Jh9e3uyc8Ce7PLJid8WxWDjb4A/wPBagOaOK8Ty2UgCCdVfbvuRheasF8m5JsM+fvZu0OuLL1/KYoJeNbMAMvgdurCKrxVNaaNgcAqz9iWthY5dTgZkL1k1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733156482; c=relaxed/simple;
	bh=GepOY+2bSH0E/kWJpHBLyw1FRYVtuWSxRHGQ1U8w1N0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLgbKsIif0Ob7zViez+otTGXYwqPFvPoCRkoy21eJknXplvvSu3eWIXG8F2K0Vfspprmlt2wXbCnLafq4xoU1t9vR1nOede4o58YtGdjzkpfeaULEImbQFcvMDYxD1DITIbuZl4ev2/5Z50OWYUOxAS0Z+XZnQ9DuGm45EdADpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ahqwgH8C; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RNGkqSZy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=fyYYPtB3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jWlh3xnw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D2ECD2116E;
	Mon,  2 Dec 2024 16:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733156478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1z4TbU/Qkr/jvGw5g0HDhjUZVdLmjABAsTzcryF/YSQ=;
	b=ahqwgH8Cm7IMlLSR5xUALMENPXVrfiVZYRM2EnGvSOz1cHJn9o4PPUF31fVJKP26sNONwj
	/BNFGzGzx2KvFNH68BSPa82uwszqyhuxmMfZg0NiV6dsoXiMkakgIXNSzxpQyoJGdSyuHV
	egZjdixQ7CgOiRl41c70hLgOAilmCFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733156478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1z4TbU/Qkr/jvGw5g0HDhjUZVdLmjABAsTzcryF/YSQ=;
	b=RNGkqSZyu8FikIALm4xcffpc0Mp2YnxHSUWMw1XbaLWfFmW1tJoLw/O/RE7tPPdsu5Di9g
	MwNpvhoDhZ5MxiCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fyYYPtB3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jWlh3xnw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733156477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1z4TbU/Qkr/jvGw5g0HDhjUZVdLmjABAsTzcryF/YSQ=;
	b=fyYYPtB3IU3lSwDkK02nZlnsUkmLxcj3SJs69Ykiq83EpNod6P26mmQtjYymLOBE4pLYRP
	Md6K1iSYMs+S6z+/SQxqOCDp29VJHyb6AONouXiCHMsbUhJWbMr5Se7zFdgEZm3uJSSykP
	6tt3BE+ZeN49klRPVsjp1FTcAbbc7zo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733156477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1z4TbU/Qkr/jvGw5g0HDhjUZVdLmjABAsTzcryF/YSQ=;
	b=jWlh3xnwkmNY4Q/NgVKE3IcFrN09XgEpMmPNnHxrnv3XnjUq1MMnges55t4yysr2tZ8j3h
	X8uhfoPaiadUgJCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D865713A31;
	Mon,  2 Dec 2024 16:21:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5Q0oJXneTWfUQgAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 02 Dec 2024 16:21:13 +0000
Date: Tue, 3 Dec 2024 00:21:07 +0800
From: Coly Li <colyli@suse.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, haris.iqbal@ionos.com, jinpu.wang@ionos.com, 
	kent.overstreet@linux.dev, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] block: Delete bio_set_prio()
Message-ID: <xrrvym37rltbopjxuz2cozkladm7nlklms46dnddexlpxva373@xrsrq3y54qsv>
References: <20241202111957.2311683-1-john.g.garry@oracle.com>
 <20241202111957.2311683-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241202111957.2311683-3-john.g.garry@oracle.com>
X-Rspamd-Queue-Id: D2ECD2116E
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MISSING_XM_UA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim,oracle.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, Dec 02, 2024 at 11:19:57AM +0000, John Garry wrote:
> Since commit 43b62ce3ff0a ("block: move bio io prio to a new field"), macro
> bio_set_prio() does nothing but set bio->bi_ioprio. All other places just
> set bio->bi_ioprio directly, so replace bio_set_prio() remaining
> callsites with setting bio->bi_ioprio directly and delete that macro.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/block/rnbd/rnbd-srv.c | 2 +-
>  drivers/md/bcache/movinggc.c  | 2 +-
>  drivers/md/bcache/writeback.c | 2 +-
>  fs/bcachefs/move.c            | 6 +++---
>  include/linux/bio.h           | 2 --
>  5 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.c
> index 08ce6d96d04c..2ee6e9bd4e28 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -167,7 +167,7 @@ static int process_rdma(struct rnbd_srv_session *srv_sess,
>  	bio->bi_iter.bi_sector = le64_to_cpu(msg->sector);
>  	prio = srv_sess->ver < RNBD_PROTO_VER_MAJOR ||
>  	       usrlen < sizeof(*msg) ? 0 : le16_to_cpu(msg->prio);
> -	bio_set_prio(bio, prio);
> +	bio->bi_ioprio = prio;
>  
>  	submit_bio(bio);
>  
> diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
> index ef6abf33f926..45ca134cbf02 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -82,7 +82,7 @@ static void moving_init(struct moving_io *io)
>  	bio_init(bio, NULL, bio->bi_inline_vecs,
>  		 DIV_ROUND_UP(KEY_SIZE(&io->w->key), PAGE_SECTORS), 0);
>  	bio_get(bio);
> -	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
> +	bio->bi_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0);
>  
>  	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
>  	bio->bi_private		= &io->cl;
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index c1d28e365910..453efbbdc8ee 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -334,7 +334,7 @@ static void dirty_init(struct keybuf_key *w)
>  	bio_init(bio, NULL, bio->bi_inline_vecs,
>  		 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS), 0);
>  	if (!io->dc->writeback_percent)
> -		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
> +		bio->bi_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0);
>  
>  	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
>  	bio->bi_private		= w;


For bcache part, Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


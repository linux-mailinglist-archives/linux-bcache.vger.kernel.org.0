Return-Path: <linux-bcache+bounces-826-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0AFD9FA198
	for <lists+linux-bcache@lfdr.de>; Sat, 21 Dec 2024 17:17:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9065188E4D0
	for <lists+linux-bcache@lfdr.de>; Sat, 21 Dec 2024 16:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FAC11C32;
	Sat, 21 Dec 2024 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GgdmZ9Hx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XQZEmlFa";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FGDhGrVe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AnrZtlex"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CBE84D02
	for <linux-bcache@vger.kernel.org>; Sat, 21 Dec 2024 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734797831; cv=none; b=fUQcGguGG5mTYFdCp4ob7R+b54Jo2OH6cusl0mk9Ujm4ljU+QKpuSSxh8nyc3onORqXGEUYtpTd/ghZxY81zOFI7/DboyVeaHo0vc7QelNCGTEgR/AaSsJC/AurMYVUAV1VgAC8YttmF6OXZB3fGjSY1ZpnUI8oadde5A2HW9aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734797831; c=relaxed/simple;
	bh=r/bQHyj1zpBEev2fE0HmiZjTW3lNyCdsH0WNFv81G9Y=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=ct8tsnxxVfqA6HTZUy3B4xMYkzGW8LVmgw9xbvNCDXVyo/lSdZMQ4jhM0XEEOr7A94RcEyXRq6muXHqAaTMzqXGEySQJREdQy9Fus93woFcJoOY3HF+O3jMWIlGcG6v1aojRLrG/4zR3pE8hcawvqJ6Pqi3BVv7BfbJnkbnwGZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GgdmZ9Hx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XQZEmlFa; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FGDhGrVe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AnrZtlex; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E67E820163;
	Sat, 21 Dec 2024 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734797827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNcRIVRx0+TAw7psrqoLwgy0J6HkRXd0aeAaCqHEx5E=;
	b=GgdmZ9Hx0Mfni11YRpr2ynFO8jf2HZis3o9CqoQmzmDQwXFiIJHxla0EvBWSZgBR19t6bB
	C4OIHBOtNW9YePSOwgUg3urQerkTFJCv8BAzXatODdP8ivL402vvt531hKI3ch1kSOOlcm
	NRphbsO0xphg8SjfAbJIL4LKN4WmTAI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734797827;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNcRIVRx0+TAw7psrqoLwgy0J6HkRXd0aeAaCqHEx5E=;
	b=XQZEmlFayuh25seex7BX1Y/vO2hA+G9g+7dUJ5cb30YoO1L1DwsGQrKX8EdldKsJZS6AXO
	0eapJzhoELAionBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FGDhGrVe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AnrZtlex
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734797826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNcRIVRx0+TAw7psrqoLwgy0J6HkRXd0aeAaCqHEx5E=;
	b=FGDhGrVeY/zT3WtF6EWSzlzbz5r+oHh9wGJdUrFimvWZqp+0HsDRyRIJixMVKIQn1ojqUO
	7P7SfW4z6RKVOXRA0rjM2LdeOAjhewqQ91FLuTG0DbNO7YXXyAJfdDzXeT4YQJ5DobACH3
	qHCyBO1NDaLBZkXqyUqy1DqnOZfWnUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734797826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNcRIVRx0+TAw7psrqoLwgy0J6HkRXd0aeAaCqHEx5E=;
	b=AnrZtlex1T24O5yqSq1dkakAJ1FjfPCzHHFZk2awevZztXmWSy9nQUTH9QULGmXQnhrCBJ
	jukOhOOLAwn+HqDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB43A1369C;
	Sat, 21 Dec 2024 16:17:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 86UkNQLqZmfWOQAAD6G6ig
	(envelope-from <colyli@suse.de>); Sat, 21 Dec 2024 16:17:06 +0000
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 22 Dec 2024 00:17:06 +0800
From: colyli <colyli@suse.de>
To: =?UTF-8?Q?=E9=82=B9=E6=98=8E=E5=93=B2?= <mingzhe.zou@easystack.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, zoumingzhe
 <zoumingzhe@qq.com>
Subject: Re: [PATCH v2 2/3] bcache: fix io error during cache read race
In-Reply-To: <AMcAQwBHLpIksKhhq8fkdqro.3.1734672038253.Hmail.mingzhe.zou@easystack.cn>
References: <20241119074031.27340-1-mingzhe.zou@easystack.cn>
 <20241119074031.27340-2-mingzhe.zou@easystack.cn>
 <AMcAQwBHLpIksKhhq8fkdqro.3.1734672038253.Hmail.mingzhe.zou@easystack.cn>
User-Agent: Roundcube Webmail
Message-ID: <4da838e985ec3f7263a4ad4a9b307d15@suse.de>
X-Sender: colyli@suse.de
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E67E820163
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,qq.com];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

在 2024-12-20 13:20，邹明哲 写道：
> Hi, Coly:
> 
> Our users have reported this issue to us in their generation 
> environment!
> 
> Please review these patches and provide feedback.
> 
> Thank you very much.

Hi Mingzhe,

Yes it is planed for next week, I will start to look at this series.

BTW, I don't see change log from the v1 to v2 series. Can I assume the 
v2 series fix warning reported by kernel test robot?

Thanks.

Coly Li

> 
> mingzhe
> 
> Original:
> From：mingzhe.zou<mingzhe.zou@easystack.cn>
> Date：2024-11-19 15:40:30(中国 (GMT+08:00))
> To：colyli<colyli@suse.de>
> Cc：linux-bcache<linux-bcache@vger.kernel.org> ,
> dongsheng.yang<dongsheng.yang@easystack.cn> ,
> zoumingzhe<zoumingzhe@qq.com>
> Subject：[PATCH v2 2/3] bcache: fix io error during cache read race
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> In our production environment, bcache returned IO_ERROR(errno=-5).
> These errors always happen during 1M read IO under high pressure
> and without any message log. When the error occurred, we stopped
> all reading and writing and used 1M read IO to read the entire disk
> without any errors. Later we found that cache_read_races of cache_set
> is non-zero.
> 
> If a large (1M) read bio is split into two or more bios, when one bio
> reads dirty data, s-&gt;read_dirty_data will be set to true and remain.
> If the bucket was reused while our subsequent read bio was in flight,
> the read will be unrecoverable(cannot read data from backing).
> 
> This patch increases the count for bucket-&gt;pin to prevent the bucket
> from being reclaimed and reused.
> 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>  drivers/md/bcache/request.c | 39 ++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde1..6c41957138e5 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -502,12 +502,8 @@ static void bch_cache_read_endio(struct bio *bio)
>  	struct closure *cl = bio-&gt;bi_private;
>  	struct search *s = container_of(cl, struct search, cl);
> 
> -	/*
> -	 * If the bucket was reused while our bio was in flight, we might 
> have
> -	 * read the wrong data. Set s-&gt;error but not error so it doesn't 
> get
> -	 * counted against the cache device, but we'll still reread the data
> -	 * from the backing device.
> -	 */
> +	BUG_ON(ptr_stale(s-&gt;iop.c, &amp;b-&gt;key, 0)); // bucket should
> not be reused
> +	atomic_dec(&amp;PTR_BUCKET(s-&gt;iop.c, &amp;b-&gt;key, 0)-&gt;pin);
> 
>  	if (bio-&gt;bi_status)
>  		s-&gt;iop.status = bio-&gt;bi_status;
> @@ -520,6 +516,8 @@ static void bch_cache_read_endio(struct bio *bio)
>  	bch_bbio_endio(s-&gt;iop.c, bio, bio-&gt;bi_status, "reading from 
> cache");
>  }
> 
> +static void backing_request_endio(struct bio *bio);
> +
>  /*
>   * Read from a single key, handling the initial cache miss if the key 
> starts in
>   * the middle of the bio
> @@ -529,7 +527,6 @@ static int cache_lookup_fn(struct btree_op *op,
> struct btree *b, struct bkey *k)
>  	struct search *s = container_of(op, struct search, op);
>  	struct bio *n, *bio = &amp;s-&gt;bio.bio;
>  	struct bkey *bio_key;
> -	unsigned int ptr;
> 
>  	if (bkey_cmp(k, &amp;KEY(s-&gt;iop.inode, bio-&gt;bi_iter.bi_sector,
> 0)) &lt;= 0)
>  		return MAP_CONTINUE;
> @@ -553,20 +550,36 @@ static int cache_lookup_fn(struct btree_op *op,
> struct btree *b, struct bkey *k)
>  	if (!KEY_SIZE(k))
>  		return MAP_CONTINUE;
> 
> -	/* XXX: figure out best pointer - for multiple cache devices */
> -	ptr = 0;
> +	/*
> +	 * If the bucket was reused while our bio was in flight, we might 
> have
> +	 * read the wrong data. Set s-&gt;cache_read_races and reread the 
> data
> +	 * from the backing device.
> +	 */
> +	spin_lock(&amp;PTR_BUCKET(b-&gt;c, k, 0)-&gt;lock);
> +	if (ptr_stale(s-&gt;iop.c, k, 0)) {
> +		spin_unlock(&amp;PTR_BUCKET(b-&gt;c, k, 0)-&gt;lock);
> +		atomic_long_inc(&amp;s-&gt;iop.c-&gt;cache_read_races);
> +		pr_warn("%pU cache read race count: %lu", 
> s-&gt;iop.c-&gt;sb.set_uuid,
> +			atomic_long_read(&amp;s-&gt;iop.c-&gt;cache_read_races));
> 
> -	PTR_BUCKET(b-&gt;c, k, ptr)-&gt;prio = INITIAL_PRIO;
> +		n-&gt;bi_end_io	= backing_request_endio;
> +		n-&gt;bi_private	= &amp;s-&gt;cl;
> +
> +		/* I/O request sent to backing device */
> +		closure_bio_submit(s-&gt;iop.c, n, &amp;s-&gt;cl);
> +		return n == bio ? MAP_DONE : MAP_CONTINUE;
> +	}
> +	atomic_inc(&amp;PTR_BUCKET(s-&gt;iop.c, k, 0)-&gt;pin);
> +	spin_unlock(&amp;PTR_BUCKET(b-&gt;c, k, 0)-&gt;lock);
> 
> -	if (KEY_DIRTY(k))
> -		s-&gt;read_dirty_data = true;
> +	PTR_BUCKET(b-&gt;c, k, 0)-&gt;prio = INITIAL_PRIO;
> 
>  	n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
>  				      KEY_OFFSET(k) - bio-&gt;bi_iter.bi_sector),
>  			   GFP_NOIO, &amp;s-&gt;d-&gt;bio_split);
> 
>  	bio_key = &amp;container_of(n, struct bbio, bio)-&gt;key;
> -	bch_bkey_copy_single_ptr(bio_key, k, ptr);
> +	bch_bkey_copy_single_ptr(bio_key, k, 0);
> 
>  	bch_cut_front(&amp;KEY(s-&gt;iop.inode, n-&gt;bi_iter.bi_sector, 0), 
> bio_key);
>  	bch_cut_back(&amp;KEY(s-&gt;iop.inode, bio_end_sector(n), 0), 
> bio_key);


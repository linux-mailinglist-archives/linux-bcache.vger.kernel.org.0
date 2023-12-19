Return-Path: <linux-bcache+bounces-158-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9338E8181FB
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Dec 2023 08:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A99901C23041
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Dec 2023 07:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B59E848E;
	Tue, 19 Dec 2023 07:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zVRdai30";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qxb331BZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gq3laVAw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="29gKWPWZ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9372D881E;
	Tue, 19 Dec 2023 07:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D34321F7A5;
	Tue, 19 Dec 2023 07:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702969699; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wj5FWLm7rq7c9ULD+6OZOIhvpxTPaHm9vpb8dq5+e3Y=;
	b=zVRdai30/CJw2bclC4Z3kqBP1s0av2v/Cbfyv8eaGyhSxUe7IdmJZ85KyK6dxKHL6c8VFx
	gzeu44yY2XwNs7KLXM8YjNX63tvVQyzQ2Y+C8SwawkCg0Gs4fYeu6qdnQdlASYXNJD2Mcc
	zAtGPhv3HJCHUmLSCAam4wDrP1FRjo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702969699;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wj5FWLm7rq7c9ULD+6OZOIhvpxTPaHm9vpb8dq5+e3Y=;
	b=qxb331BZPk1Lz60wN+t0VEF8t67GSA/65p2boWMdICeLO1VsZ8xx+bX/72UfMKsdTRH47F
	TinAGRlkrBaTsyCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702969698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wj5FWLm7rq7c9ULD+6OZOIhvpxTPaHm9vpb8dq5+e3Y=;
	b=gq3laVAwaDCupJGwdZ3P3wv2KZ/FEAjM9/5oD7CcWbFW6hIbqf1qyi2WR68HYNgALAauli
	HfK16RAJ+vemj36vWNhVkrRqMvzsU0RhDcbuxzbfvrGJdeywzRD4Ey6gOfigskORA3cMyw
	XFmgb2XLP9fPtZx9uf9soInoZlvPaPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702969698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wj5FWLm7rq7c9ULD+6OZOIhvpxTPaHm9vpb8dq5+e3Y=;
	b=29gKWPWZCOD/SlqEUqWli1flFrWAsI5iossuD1aq/gbVwYTohOCAdnhPr6NO1BDvdHaMkS
	IqdufoiXYK02bdBQ==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A47013BE8;
	Tue, 19 Dec 2023 07:08:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id EkAwDmBBgWVJfgAAn2gu4w
	(envelope-from <colyli@suse.de>); Tue, 19 Dec 2023 07:08:16 +0000
Date: Tue, 19 Dec 2023 15:08:10 +0800
From: Coly Li <colyli@suse.de>
To: Kunwu Chan <chentao@kylinos.cn>
Cc: kent.overstreet@gmail.com, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kunwu Chan <kunwu.chan@hotmail.com>
Subject: Re: [PATCH] bcache: Fix NULL pointer dereference in
 bch_cached_dev_run
Message-ID: <nqdvnxwug6dv4xkt3kmzp6eiqnrjeilyaeaoukrtime5wjrz6c@jwliy7gmljvu>
References: <20231211082510.262292-1-chentao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231211082510.262292-1-chentao@kylinos.cn>
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.73
X-Spamd-Result: default: False [0.73 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_SPAM(0.03)[52.49%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com,hotmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,hotmail.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Flag: NO

On Mon, Dec 11, 2023 at 04:25:10PM +0800, Kunwu Chan wrote:
> kasprintf() returns a pointer to dynamically allocated memory
> which can be NULL upon failure.
> 

If you check kobject_uevent_env(), you will find the NULL pointer dereference
won't happen. Sending env[1] or env[2] as NULL into kobject_uevent_env() just
results an unexpected udev event message, IMHO it is better than nothing.

> Cc: Kunwu Chan <kunwu.chan@hotmail.com>
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>

Why this patch is Cced to another email address of same person?

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1402096b8076..40b657887d3b 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1053,6 +1053,12 @@ int bch_cached_dev_run(struct cached_dev *dc)
>  		NULL,
>  	};
>  
> +	if (!env[1] || !env[2]) {
> +		pr_err("Couldn't create bcache dev <-> fail to allocate memory\n");
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
>  	if (dc->io_disable) {
>  		pr_err("I/O disabled on cached dev %pg\n", dc->bdev);
>  		ret = -EIO;
> -- 
> 2.39.2
> 
> 

-- 
Coly Li


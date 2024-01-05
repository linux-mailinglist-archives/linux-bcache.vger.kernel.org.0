Return-Path: <linux-bcache+bounces-220-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F76B824EDB
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Jan 2024 07:55:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DDEC282A11
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Jan 2024 06:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4676F522C;
	Fri,  5 Jan 2024 06:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z642c/ch";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HT0tlVy9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="z642c/ch";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HT0tlVy9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4ED20306;
	Fri,  5 Jan 2024 06:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8A0671F88F;
	Fri,  5 Jan 2024 06:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704437731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhJQ0cCoglIFZPkNRqp4uGdfdg93eiXc0HbR1FvQX5Q=;
	b=z642c/chS8BpjXukVZ2Bl2vq4jTFn95a5Pu5hpmq79061fX/0/bJvAjE8Rjph9dBm5lDh8
	Vt0tKuYig3SV+6rgDjFtD3pxLr5C82qd+j1Dd15hNq0b8T5I0ERxz6QbKPtxdDKsZz+A+J
	CgDhi6B6hXShh7J9TouNk99Ql9Dh1lU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704437731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhJQ0cCoglIFZPkNRqp4uGdfdg93eiXc0HbR1FvQX5Q=;
	b=HT0tlVy9hNV8zWE21AiiCw3cGjkmH1wK9nbnm0RHCevmwTK6mQTBOgt+Nji/AndgfFsQIX
	/wgj2TivDlpFpzCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704437731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhJQ0cCoglIFZPkNRqp4uGdfdg93eiXc0HbR1FvQX5Q=;
	b=z642c/chS8BpjXukVZ2Bl2vq4jTFn95a5Pu5hpmq79061fX/0/bJvAjE8Rjph9dBm5lDh8
	Vt0tKuYig3SV+6rgDjFtD3pxLr5C82qd+j1Dd15hNq0b8T5I0ERxz6QbKPtxdDKsZz+A+J
	CgDhi6B6hXShh7J9TouNk99Ql9Dh1lU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704437731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YhJQ0cCoglIFZPkNRqp4uGdfdg93eiXc0HbR1FvQX5Q=;
	b=HT0tlVy9hNV8zWE21AiiCw3cGjkmH1wK9nbnm0RHCevmwTK6mQTBOgt+Nji/AndgfFsQIX
	/wgj2TivDlpFpzCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BA06137E8;
	Fri,  5 Jan 2024 06:55:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OKRqD92nl2ViJgAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 05 Jan 2024 06:55:25 +0000
Date: Fri, 5 Jan 2024 14:55:18 +0800
From: Coly Li <colyli@suse.de>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: linux-kernel@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kent Overstreet <kent.overstreet@gmail.com>, Marco Elver <elver@google.com>, 
	Kees Cook <keescook@chromium.org>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	linux-bcache@vger.kernel.org
Subject: Re: [PATCH v2 3/3] bcache: Use of hlist_count_nodes()
Message-ID: <4myh2bosrpeom3aiwsdhlksly7l7k5fiabuwoblxr52k6dp5ua@xok4hlxudw23>
References: <20240104164937.424320-1-pierre.gondois@arm.com>
 <20240104164937.424320-4-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240104164937.424320-4-pierre.gondois@arm.com>
X-Spam-Level: 
X-Spam-Level: 
X-Spamd-Bar: /
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="z642c/ch";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HT0tlVy9
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [0.47 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-0.02)[51.57%];
	 ARC_NA(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,arm.com:email];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[17];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[vger.kernel.org,linuxfoundation.org,android.com,joelfernandes.org,kernel.org,google.com,gmail.com,chromium.org,intel.com,linux.intel.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[];
	 RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Score: 0.47
X-Rspamd-Queue-Id: 8A0671F88F
X-Spam-Flag: NO

On Thu, Jan 04, 2024 at 05:49:35PM +0100, Pierre Gondois wrote:
> Make use of the newly added hlist_count_nodes().
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
>  drivers/md/bcache/sysfs.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index a438efb66069..6956beb55326 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -702,13 +702,7 @@ static unsigned int bch_cache_max_chain(struct cache_set *c)
>  	for (h = c->bucket_hash;
>  	     h < c->bucket_hash + (1 << BUCKET_HASH_BITS);
>  	     h++) {
> -		unsigned int i = 0;
> -		struct hlist_node *p;
> -
> -		hlist_for_each(p, h)
> -			i++;
> -
> -		ret = max(ret, i);
> +		ret = max(ret, hlist_count_nodes(h));
>  	}
>  
>  	mutex_unlock(&c->bucket_lock);
> -- 
> 2.25.1
> 
> 

-- 
Coly Li


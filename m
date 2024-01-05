Return-Path: <linux-bcache+bounces-219-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B80824ED3
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Jan 2024 07:54:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAE7D1C21857
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Jan 2024 06:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCDD653;
	Fri,  5 Jan 2024 06:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TXBYAHQ/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/g2k3isD";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TXBYAHQ/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/g2k3isD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C921DDCA;
	Fri,  5 Jan 2024 06:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E359220D0;
	Fri,  5 Jan 2024 06:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704437648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNR4qmyfrPzmJTZgxJg9wWBaUMtfuQeh/96F2dVyF20=;
	b=TXBYAHQ/FY5Id6/SUcdltey2rb9Tg8llrOwL8T72wml6mVRzgU5ZVuYRp9YRGeTVhhVfTa
	ZQeV8Ib8dUj91PhPxD8hLbAAlcFhUAA64R+rCZUqFJVkNw2ST0s8vOwfc/0u3XNp+dqerX
	OY0hwHeY6qoZ+veBoI6//Gw+ya0Ffe0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704437648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNR4qmyfrPzmJTZgxJg9wWBaUMtfuQeh/96F2dVyF20=;
	b=/g2k3isDsX1Kzaf9TzZMfr2ZRoFFrGxnEdcoXh7ECd/gXSrwqVYU5Wxp/VJruaHeZ6fe+f
	zdxDKyE2cnZXEsBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704437648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNR4qmyfrPzmJTZgxJg9wWBaUMtfuQeh/96F2dVyF20=;
	b=TXBYAHQ/FY5Id6/SUcdltey2rb9Tg8llrOwL8T72wml6mVRzgU5ZVuYRp9YRGeTVhhVfTa
	ZQeV8Ib8dUj91PhPxD8hLbAAlcFhUAA64R+rCZUqFJVkNw2ST0s8vOwfc/0u3XNp+dqerX
	OY0hwHeY6qoZ+veBoI6//Gw+ya0Ffe0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704437648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GNR4qmyfrPzmJTZgxJg9wWBaUMtfuQeh/96F2dVyF20=;
	b=/g2k3isDsX1Kzaf9TzZMfr2ZRoFFrGxnEdcoXh7ECd/gXSrwqVYU5Wxp/VJruaHeZ6fe+f
	zdxDKyE2cnZXEsBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 542A0137E8;
	Fri,  5 Jan 2024 06:54:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BZFAAYqnl2UQJgAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 05 Jan 2024 06:54:02 +0000
Date: Fri, 5 Jan 2024 14:53:55 +0800
From: Coly Li <colyli@suse.de>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: linux-kernel@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kent Overstreet <kent.overstreet@gmail.com>, Marco Elver <elver@google.com>, 
	Kees Cook <keescook@chromium.org>, Jani Nikula <jani.nikula@intel.com>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, Ingo Molnar <mingo@kernel.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH v2 1/3] list: Add hlist_count_nodes()
Message-ID: <65qcwqfaicc2wrhf5mjrj24j3kep7yv7ezvv22ctrbwyoag43h@tu26mhauwc2u>
References: <20240104164937.424320-1-pierre.gondois@arm.com>
 <20240104164937.424320-2-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240104164937.424320-2-pierre.gondois@arm.com>
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [0.70 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_RATELIMIT(0.00)[to_ip_from(RLrmm7d381faskkr1sa8sqxo77)];
	 RCVD_COUNT_THREE(0.00)[3];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 BAYES_HAM(-0.00)[32.60%];
	 ARC_NA(0.00)[];
	 URIBL_BLOCKED(0.00)[arm.com:email,suse.de:email];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_TWELVE(0.00)[18];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 MID_RHS_NOT_FQDN(0.50)[];
	 FREEMAIL_CC(0.00)[vger.kernel.org,linuxfoundation.org,android.com,joelfernandes.org,kernel.org,google.com,gmail.com,chromium.org,intel.com,linux.intel.com];
	 RCVD_TLS_ALL(0.00)[];
	 SUSPICIOUS_RECIPS(1.50)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: 0.70

On Thu, Jan 04, 2024 at 05:49:33PM +0100, Pierre Gondois wrote:
> Add a function to count nodes in a hlist. hlist_count_nodes()
> is similar to list_count_nodes().
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
>  include/linux/list.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 1837caedf723..0f1b1d4a2e2e 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -1175,4 +1175,19 @@ static inline void hlist_move_list(struct hlist_head *old,
>  	     pos && ({ n = pos->member.next; 1; });			\
>  	     pos = hlist_entry_safe(n, typeof(*pos), member))
>  
> +/**
> + * hlist_count_nodes - count nodes in the hlist
> + * @head:	the head for your hlist.
> + */
> +static inline size_t hlist_count_nodes(struct hlist_head *head)
> +{
> +	struct hlist_node *pos;
> +	size_t count = 0;
> +
> +	hlist_for_each(pos, head)
> +		count++;
> +
> +	return count;
> +}
> +
>  #endif
> -- 
> 2.25.1
> 
> 

-- 
Coly Li


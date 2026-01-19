Return-Path: <linux-bcache+bounces-1386-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6483D3AFDF
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 17:00:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 50FE7309FC66
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 15:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DA838B99C;
	Mon, 19 Jan 2026 15:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kglkAOim";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vUyPNmpc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n9NFkx2m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="b03o/fQl"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687B521FF2A
	for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768838230; cv=none; b=l2AncKXzzDQIHRhQ5Bz83ZtAenga7fW0MNNylBZ/dKjgB4IOieZ7SnrRHIgTUyFse1qyEWEE0WFicQjQ1+GwRQ10QYStu+NHkIbE2cVAMmUXKY7qroB/O7nhV1zWDnYcl+ssOyinnrAVe+8ezbnEp+S6x4yJaiLL0fFZxqzY9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768838230; c=relaxed/simple;
	bh=pTFzu+uZg+boSjY878R+c8nRpLFoaEecQZ6bGsiGzo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZsgTZUxL0sjhstqz/CTDrWseBJbyZsmk/FMfxQtG2PJwVg7cLVNPcIsRnEENp3Tmo/M0f7Ye4ucPvFWj1mN+AZ1CYBLiN1tnGdsUP80SKXdzAizK+y1lI4VMdjEg3MYUQGlLJ22cGq8sckV7qYmmitrx5KFhU34tlmdwOacDqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kglkAOim; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vUyPNmpc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n9NFkx2m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=b03o/fQl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D58433725;
	Mon, 19 Jan 2026 15:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768838227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=msWUNQIl0T+SKY0aMGXculM4ILtkCPb+eK1aBarneAI=;
	b=kglkAOimmtKNnofM/dhoQI65iduwcM+aWiALRYwA8+UzGonr8hxZQ8t+YglpaJ3HC5A3td
	xlewsJHGemupMyfAXy7iHYTRuRHOJzry3H6C/OEGum4g84v2GFbIEoJWeO0CFWVCbA210j
	EGXTS+RuI/jnclwLusYXyDHt774siww=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768838227;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=msWUNQIl0T+SKY0aMGXculM4ILtkCPb+eK1aBarneAI=;
	b=vUyPNmpcDovKpxxW5vQDnVe4NJU+GPorxcG8yYw3z1VXHFY3AQMzV9ADBwIwD8mu6hm3vI
	jqNcTpruHuFyo8BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768838226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=msWUNQIl0T+SKY0aMGXculM4ILtkCPb+eK1aBarneAI=;
	b=n9NFkx2meYt4cWL54v55GLDvDGgvnmD3T4u5/uf89r1otVsZfgr8iFDWEeOj8VOvUgTbBK
	e/8ssgnq+eHoRt/yIk+hb1l7XVvzoDSdjuuj+2/OQOyvGXmEKMSvkWh4Z4/dT4yOlD+EwL
	e5PxvoXVV+cgre+6aP1Wxyum03NruGs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768838226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=msWUNQIl0T+SKY0aMGXculM4ILtkCPb+eK1aBarneAI=;
	b=b03o/fQl3MZXi2PQ98MkX6f5zGKgdh5msWXo1sMJ8mBed+IWQWAogUHXHG8begl8Rhxz2R
	EqelcYK9rbOqfjCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DFD43EA63;
	Mon, 19 Jan 2026 15:57:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UabKHVJUbmk9WAAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 19 Jan 2026 15:57:06 +0000
Date: Mon, 19 Jan 2026 16:57:05 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@fnnas.com>, 
	axboe@kernel.dk, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <4712ff66-ecce-4a50-82f7-8f27930e79a2@flourine.local>
References: <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
 <aWZwBZaVVBC0otPd@studio.local>
 <aWZyHz_eZWN-yQiD@infradead.org>
 <aWZyWJiOi9hZgtqo@moria.home.lan>
 <f7af1e25-fbe9-4d37-b902-5b3a9ed4c8f4@flourine.local>
 <aW4D0UPTBXEap1Jg@moria.home.lan>
 <4224c9a1-e53c-4592-933c-dc6b1003ce00@flourine.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4224c9a1-e53c-4592-933c-dc6b1003ce00@flourine.local>
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[flourine.local:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

On Mon, Jan 19, 2026 at 11:34:15AM +0100, Daniel Wagner wrote:
> That's why I said some of tests could be added directly to blktests,

FWIW, I've started to work on an initial test case for bcache in
blktests. I shamelessly stole some helper/setup stuff from ktest to get
things rolling. But I think I am going to replace this as it doesn't
really match the blktests style for helpers and in the end it's not that
much we need to get it working anyway:

   https://github.com/igaw/blktests/pull/new/bcache

In case anyone wants to play with, you need to define
TEST_CASE_DEV_ARRAY:

# cat /root/config
TEST_CASE_DEV_ARRAY[bcache/*]="/dev/nvme0n1 /dev/nvme1n1 /dev/vda /dev/vdb"

# ./check -c /root/config bcache


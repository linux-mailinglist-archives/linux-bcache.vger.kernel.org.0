Return-Path: <linux-bcache+bounces-1383-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7811ED3A3BE
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 10:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BCD730456A7
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 09:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B700B3081A2;
	Mon, 19 Jan 2026 09:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dxOx0lHp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W4qUigv7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dxOx0lHp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W4qUigv7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8D6305057
	for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 09:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768816314; cv=none; b=UuXoL4JBexo6tCIVIE0LARFAKc892BylrUYV+67rx+1xtfhZBF0AX9X8HZxjJHi5wxMRglFTjDa2R6LXnDkJffY4NgBa7H5sdYDUEu3s+BmZ1gEq5WNfdCUWJFyJZX7WFbuBIeXW/UInJ4RBaa1qo2zeIgsn4Iz2oeWhAvL2lsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768816314; c=relaxed/simple;
	bh=SDYD2YLxll9ec1gMp8losBgO3r9CiNIjB7uVki/KizM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osmzKKM59CyRutJ6Gb5hCsCOgKXou4J/zJx59iMTRgf/UVC2vCdgkK7O8TTAwupjwhAMFI7jF95SeG4MFB4Q+/7XARgSCwDydW/2gVOxrAaSInM4yUvFICtUfoP04WLm1nusOT5EhTf+b/Uc+jzdOf4YWq2dbk38h++Xliwodtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dxOx0lHp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W4qUigv7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dxOx0lHp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W4qUigv7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B29C5BD44;
	Mon, 19 Jan 2026 09:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768816311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uxrf5LEU65FkvilzgzhnRk5j0tnadXH2M9TjKeq/hFA=;
	b=dxOx0lHpchUMMf22iNFKaVVDlTatr+n4W11wp/giefmQVnSPR/pV9g/f73N7zQ6pQ3Grcs
	982NMXN/D1zRvwvhaW+b9eqiXwbMDX4BE7ukW6ebKDm3owQJ/b2eOLilPS2bv9lnQDbBkw
	iZbI8f76oEfoDVGQKJrUNZrjr7vdXBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768816311;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uxrf5LEU65FkvilzgzhnRk5j0tnadXH2M9TjKeq/hFA=;
	b=W4qUigv7MeAHgq2fBI4s2LelPP64yG+1MwtrszNw9gORsnTsPCABESWudlnJ/0K4Gog81D
	pI6xmGmkTKf4TuBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768816311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uxrf5LEU65FkvilzgzhnRk5j0tnadXH2M9TjKeq/hFA=;
	b=dxOx0lHpchUMMf22iNFKaVVDlTatr+n4W11wp/giefmQVnSPR/pV9g/f73N7zQ6pQ3Grcs
	982NMXN/D1zRvwvhaW+b9eqiXwbMDX4BE7ukW6ebKDm3owQJ/b2eOLilPS2bv9lnQDbBkw
	iZbI8f76oEfoDVGQKJrUNZrjr7vdXBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768816311;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uxrf5LEU65FkvilzgzhnRk5j0tnadXH2M9TjKeq/hFA=;
	b=W4qUigv7MeAHgq2fBI4s2LelPP64yG+1MwtrszNw9gORsnTsPCABESWudlnJ/0K4Gog81D
	pI6xmGmkTKf4TuBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C95E3EA63;
	Mon, 19 Jan 2026 09:51:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hLh+Ibf+bWkCawAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 19 Jan 2026 09:51:51 +0000
Date: Mon, 19 Jan 2026 10:51:46 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@fnnas.com>, 
	axboe@kernel.dk, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <f7af1e25-fbe9-4d37-b902-5b3a9ed4c8f4@flourine.local>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
 <aWZwBZaVVBC0otPd@studio.local>
 <aWZyHz_eZWN-yQiD@infradead.org>
 <aWZyWJiOi9hZgtqo@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWZyWJiOi9hZgtqo@moria.home.lan>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO

On Tue, Jan 13, 2026 at 11:34:18AM -0500, Kent Overstreet wrote:
> Coly and I were just on a call discussing updating my old test suite. I
> haven't used the bcache tests in > 10 years so they do need to be
> updated, but the harness and related tooling is well supported both for
> local development and has full CI.
> 
> https://evilpiepirate.org/git/ktest.git/tree/README.md
> https://evilpiepirate.org/git/ktest.git/tree/tests/bcache/

I just quickly look at the tests and I got the impression some of those
tests could be added to blktests. blktests is run by various people,
thus bcache would get some basic test exposure, e.g. in linux-next.


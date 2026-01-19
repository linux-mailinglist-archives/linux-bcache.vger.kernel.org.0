Return-Path: <linux-bcache+bounces-1385-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6598D3A522
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 11:34:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 101283009C17
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 10:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A2553093A0;
	Mon, 19 Jan 2026 10:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vnGI+qri";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="edawG3Fy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vnGI+qri";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="edawG3Fy"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A62FF153
	for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768818858; cv=none; b=f4w+z6NXzqpprgFatIH8NTKfTwAgdh6PeNujTTCzKHwQNXJiQVYwPCXq6U4c7St6gD67FnAy9kdl5CvE8NS8M/K6kDitgVFRZ0fZqrcM3I4J2wWwLK04S3koQj3WqPCie3Xek1Y79eRTDOg6hUNfVFCfsbKzgN6ylH5GuQHpydg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768818858; c=relaxed/simple;
	bh=Ha2iYLBKlnXjBI9X9uQioVp5F/wgDXuYaFL6vuLYnS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgMdt/xK/QqTij1jfw8cy442GeHuWovgn29RcjRNiFkrXSL4e+ikqXufpJP9TitGYccZ5GNajBJZKHDwxQ1MxsTaTpDB9+cG5z1I+ZyBL/rdBOaWzej4RwAZF7DEw9pOxp01fPTRN0t59btws9Xvtx0GS1oUdjjQLq1Apn6rJyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vnGI+qri; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=edawG3Fy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vnGI+qri; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=edawG3Fy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C5B35BD46;
	Mon, 19 Jan 2026 10:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768818855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Wpdq55ceHQmUYYe27cM2eJgKFzemAro8VkD02wsMKg=;
	b=vnGI+qriM2h7slH+69+GOnyaUz8WxP4ak+qw8W7GORjLxRyGJiKDhDaBZz09fdg0H/uarb
	P7EbtnXOJ960QQGlTBDmwFpaJ8nk/fPdwZUaZe7cTP/tqpVj1f+Bct+DTqRrCkNzaZKEIF
	05iCluGaX0y41rML3+BxGvTUUcMdiUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768818855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Wpdq55ceHQmUYYe27cM2eJgKFzemAro8VkD02wsMKg=;
	b=edawG3FyKonW4g0ADmrANLS82cE0/noeP4DQisPvDNNUvwxrdARX8ia6Cf8CiSyvt1xApv
	FtzsPPQSTBrDpHAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vnGI+qri;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=edawG3Fy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768818855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Wpdq55ceHQmUYYe27cM2eJgKFzemAro8VkD02wsMKg=;
	b=vnGI+qriM2h7slH+69+GOnyaUz8WxP4ak+qw8W7GORjLxRyGJiKDhDaBZz09fdg0H/uarb
	P7EbtnXOJ960QQGlTBDmwFpaJ8nk/fPdwZUaZe7cTP/tqpVj1f+Bct+DTqRrCkNzaZKEIF
	05iCluGaX0y41rML3+BxGvTUUcMdiUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768818855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Wpdq55ceHQmUYYe27cM2eJgKFzemAro8VkD02wsMKg=;
	b=edawG3FyKonW4g0ADmrANLS82cE0/noeP4DQisPvDNNUvwxrdARX8ia6Cf8CiSyvt1xApv
	FtzsPPQSTBrDpHAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E5A73EA63;
	Mon, 19 Jan 2026 10:34:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q7CcAqcIbmn1FQAAD6G6ig
	(envelope-from <dwagner@suse.de>); Mon, 19 Jan 2026 10:34:15 +0000
Date: Mon, 19 Jan 2026 11:34:10 +0100
From: Daniel Wagner <dwagner@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@fnnas.com>, 
	axboe@kernel.dk, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <4224c9a1-e53c-4592-933c-dc6b1003ce00@flourine.local>
References: <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
 <aWZwBZaVVBC0otPd@studio.local>
 <aWZyHz_eZWN-yQiD@infradead.org>
 <aWZyWJiOi9hZgtqo@moria.home.lan>
 <f7af1e25-fbe9-4d37-b902-5b3a9ed4c8f4@flourine.local>
 <aW4D0UPTBXEap1Jg@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW4D0UPTBXEap1Jg@moria.home.lan>
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 1C5B35BD46
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

On Mon, Jan 19, 2026 at 05:18:15AM -0500, Kent Overstreet wrote:
> > > https://evilpiepirate.org/git/ktest.git/tree/README.md
> > > https://evilpiepirate.org/git/ktest.git/tree/tests/bcache/
> > 
> > I just quickly look at the tests and I got the impression some of those
> > tests could be added to blktests. blktests is run by various people,
> > thus bcache would get some basic test exposure, e.g. in linux-next.
> 
> ktest has features that blktests/fstests don't - it's a full testrunner,
> with a CI and test dashboard, with subtest level sharding that runs on
> entire cluster.

That's why I said some of tests could be added directly to blktests,
e.g.

test_main()
{
    setup_tracing 'bcache:*'

    setup_bcache
    cset_uuid=$(ls -d /sys/fs/bcache/*-*-* | sed -e 's/.*\///')

    (
     	for i in $(seq 1 3); do
	    sleep 5
	    echo > /sys/block/bcache0/bcache/detach
	    echo "detach done"
	    sleep 5
	    echo $cset_uuid > /sys/block/bcache0/bcache/attach
	    echo "attach done"
	done
    )&

    run_antagonist
    run_fio
    stop_bcache
}

seems something which could also run in blktests. Sure, blktests doesn't
have all the features ktest has, but that is besides the point. The
bcache test suite is surely a good thing. Lately, blktests is getting
traction and run by more people and QA teams. My whole comment is that
adding some explicit bcache tests will get bcache more test exposure.

> What would make sense would be for ktest to wrap blktests, like it
> already does fstests.

Sure, not a problem.


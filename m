Return-Path: <linux-bcache+bounces-751-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7617F99BD3B
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 03:19:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB656B20E21
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 01:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB438F70;
	Mon, 14 Oct 2024 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yDZYjsn9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZWV7Irwq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yDZYjsn9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZWV7Irwq"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798A5672;
	Mon, 14 Oct 2024 01:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728868742; cv=none; b=UMJp2gBMsKquHfbgWshjD8GM/OBwpeXCJ2sOkCqG6aT8X3PXpwyege9yRUPkOGvwxaKK8OMWrC7Cb4ViKgM8iQKUPxRmGWQD6DYiwW+fvXsXPJgckM6xBCLczot7GcxKqHp7fxAD0jx1ErSdeakrnmP4MEyC0VGulC1teeoyNgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728868742; c=relaxed/simple;
	bh=TgLiSgDRHlg+Q8uOEPaet1coLY/1yE8wamnwKC0Stq8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ss4BXUioItzCfuF6vKmj5G/ES0fJr5zEhg8ouUU7lRPyHNZ7P5vdLmsxCMKLeX72G5vYm6NCuTFbDdZWGhhirwre6sQFv1So0IwUSk8aPJ53Bg/3mMyBEySJ1j4nzQCYHmULb3xc1QzP9h6R5QGbNQSJtI5DNonq8ousZrViG+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yDZYjsn9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZWV7Irwq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yDZYjsn9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZWV7Irwq; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 07C1821F43;
	Mon, 14 Oct 2024 01:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728868733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TgLiSgDRHlg+Q8uOEPaet1coLY/1yE8wamnwKC0Stq8=;
	b=yDZYjsn9FnXp1i+/3Lz2Lux75VdRer6GmJnm3JCMKJKYG3Q7sRXOsFkOUGYxLkKruvldb1
	/XmYgGfty50lSxOJFnl1DAhs1DyrzHSFMGI1aqKF7J2BxqH0xjK5HOoxOsRKXS9FJ1wjFj
	D214YSzdYdVap+H3EoulF4GWy+FJxxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728868733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TgLiSgDRHlg+Q8uOEPaet1coLY/1yE8wamnwKC0Stq8=;
	b=ZWV7Irwq1fJMn+z/pBBW79Wg8A85FuxSEdpiJTh4RtCRH5fPADMTH31lMM9GtaU+WxHhNs
	ikgpELgMznFjdxAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728868733; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TgLiSgDRHlg+Q8uOEPaet1coLY/1yE8wamnwKC0Stq8=;
	b=yDZYjsn9FnXp1i+/3Lz2Lux75VdRer6GmJnm3JCMKJKYG3Q7sRXOsFkOUGYxLkKruvldb1
	/XmYgGfty50lSxOJFnl1DAhs1DyrzHSFMGI1aqKF7J2BxqH0xjK5HOoxOsRKXS9FJ1wjFj
	D214YSzdYdVap+H3EoulF4GWy+FJxxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728868733;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TgLiSgDRHlg+Q8uOEPaet1coLY/1yE8wamnwKC0Stq8=;
	b=ZWV7Irwq1fJMn+z/pBBW79Wg8A85FuxSEdpiJTh4RtCRH5fPADMTH31lMM9GtaU+WxHhNs
	ikgpELgMznFjdxAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3AF11388C;
	Mon, 14 Oct 2024 01:18:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 95qfH3ZxDGeufwAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 14 Oct 2024 01:18:46 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH 0/3] Enhance min heap API with non-inline functions and
 optimizations
From: Coly Li <colyli@suse.de>
In-Reply-To: <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>
Date: Mon, 14 Oct 2024 09:18:33 +0800
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>,
 msakai@redhat.com,
 corbet@lwn.net,
 peterz@infradead.org,
 mingo@redhat.com,
 acme@kernel.org,
 namhyung@kernel.org,
 akpm@linux-foundation.org,
 mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com,
 jolsa@kernel.org,
 irogers@google.com,
 adrian.hunter@intel.com,
 kan.liang@linux.intel.com,
 jserv@ccns.ncku.edu.tw,
 linux-kernel@vger.kernel.org,
 linux-bcache@vger.kernel.org,
 dm-devel@lists.linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-perf-users@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D65079CE-3DFF-4FC2-B18D-DD54A5563878@suse.de>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,lwn.net,infradead.org,kernel.org,linux-foundation.org,arm.com,linux.intel.com,google.com,intel.com,ccns.ncku.edu.tw,vger.kernel.org,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Level: 



> 2024=E5=B9=B410=E6=9C=8814=E6=97=A5 07:05=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Oct 14, 2024 at 02:47:00AM GMT, Kuan-Wei Chiu wrote:
>> Add non-inline versions of the min heap API functions in =
lib/min_heap.c
>> and updates all users outside of kernel/events/core.c to use these
>> non-inline versions. Additionally, it micro-optimizes the efficiency =
of
>> the min heap by pre-scaling the counter, following the same approach =
as
>> in lib/sort.c. Documentation for the min heap API has also been added
>> to the core-api section.
>=20
> Nice, has it been tested - do you need a CI account?
>=20
> I'd like to start seeing links to CI results in patch postings (and I
> need to tweak the CI to add git fetch links, as well).
>=20
> Coly, there's ktest tests for bcache that need to be updated - if you
> wanted to take that on it'd be lovely to consolidate how our =
subsystems
> are getting tested; I can give you a CI account as well.

Yes, please do. And let me take a look at the test cases for bcache =
part.

Thanks.

Coly Li



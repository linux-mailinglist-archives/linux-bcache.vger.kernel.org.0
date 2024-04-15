Return-Path: <linux-bcache+bounces-401-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAD6D8A55D2
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Apr 2024 17:00:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A13202819B2
	for <lists+linux-bcache@lfdr.de>; Mon, 15 Apr 2024 15:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8056B757E4;
	Mon, 15 Apr 2024 15:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EKsYIaPL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vR8Iy/Um";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EKsYIaPL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vR8Iy/Um"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB82878B50;
	Mon, 15 Apr 2024 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713193223; cv=none; b=Fdbe8dU8anWayI7Oy8iX+7qN1vDlJmXoLmZeJHnDi0iVPRyKl8UbCx6tExCJPXWiAwWi+jLSneWY8zNxp54dcFe3VedRxy+av7sW0ImTSJ05zQ1tVsNIorcAdTZ7qEZjBrmsrp0IhPQ9NlHER2dKA9Q2IEcf0hyxBtYgkroQD2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713193223; c=relaxed/simple;
	bh=2WE10r71jQvyNYocCtd9QNiyivLI/QP6AtzHMGv8gVA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mCTrAk16HH3OiiS9X/KLYgdyTBC5jdI4M477Rysc0948MJGMSNrT1HAgziUaeY0xUEb1LEQlgyVqCDrgFlYpb3edtHlzdo4V31wR5TzQqCx0EkxTZC9QOFij6OmZ6QkdgSDl7X67QfBMLEMGmhGwcDJAdwqFEC03JzTwXOFAGS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EKsYIaPL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vR8Iy/Um; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=EKsYIaPL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vR8Iy/Um; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 00AAA5D124;
	Mon, 15 Apr 2024 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713193220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WE10r71jQvyNYocCtd9QNiyivLI/QP6AtzHMGv8gVA=;
	b=EKsYIaPLqd21jbpNul9XdzHzETWowkni3lMuKYJ82hW9pXlhqN/ZF8CcoQoU8jxpI+36/Q
	iFV9piyGfxtoFlCZ/0hxYi4twQFeMfQD3/69pr1K9Li0HqhoCl381pAbE/FQ7VcuhnS89F
	ekl1pPOf2ZnJfosPzCvGj9CWtFfpub0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713193220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WE10r71jQvyNYocCtd9QNiyivLI/QP6AtzHMGv8gVA=;
	b=vR8Iy/UmLidMgsQZNDzBRqZBLsxWjzgtNnOehE12VIfAqzKQHsQvjcyJKCVbDKs2U37jUj
	KbVt1xgdKJ6YMdCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1713193220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WE10r71jQvyNYocCtd9QNiyivLI/QP6AtzHMGv8gVA=;
	b=EKsYIaPLqd21jbpNul9XdzHzETWowkni3lMuKYJ82hW9pXlhqN/ZF8CcoQoU8jxpI+36/Q
	iFV9piyGfxtoFlCZ/0hxYi4twQFeMfQD3/69pr1K9Li0HqhoCl381pAbE/FQ7VcuhnS89F
	ekl1pPOf2ZnJfosPzCvGj9CWtFfpub0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1713193220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WE10r71jQvyNYocCtd9QNiyivLI/QP6AtzHMGv8gVA=;
	b=vR8Iy/UmLidMgsQZNDzBRqZBLsxWjzgtNnOehE12VIfAqzKQHsQvjcyJKCVbDKs2U37jUj
	KbVt1xgdKJ6YMdCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20C551368B;
	Mon, 15 Apr 2024 15:00:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uI9EMQFBHWYlNAAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 15 Apr 2024 15:00:17 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] bcache: Remove usage of the deprecated ida_simple_xx()
 API
From: Coly Li <colyli@suse.de>
In-Reply-To: <4230d015-d9b6-4753-8957-717eab00d5cb@wanadoo.fr>
Date: Mon, 15 Apr 2024 23:00:04 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E93A4C68-B846-4BBC-8778-EAC3DF97507A@suse.de>
References: <2f038df3860c2f44d5c7f5d06d03ca663cdbc651.1705235398.git.christophe.jaillet@wanadoo.fr>
 <y2c3dt325d4xzcknmwtyd6gungco6jqucz3fsrm6lsyjtiwpp4@ozmsw6vp67jk>
 <4230d015-d9b6-4753-8957-717eab00d5cb@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Flag: NO
X-Spam-Score: -3.75
X-Spam-Level: 
X-Spamd-Result: default: False [-3.75 / 50.00];
	BAYES_HAM(-2.95)[99.80%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[wanadoo.fr];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[wanadoo.fr];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]



> 2024=E5=B9=B44=E6=9C=8814=E6=97=A5 16:24=EF=BC=8CChristophe JAILLET =
<christophe.jaillet@wanadoo.fr> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Le 14/01/2024 =C3=A0 16:16, Coly Li a =C3=A9crit :
>> On Sun, Jan 14, 2024 at 01:30:16PM +0100, Christophe JAILLET wrote:
>>> ida_alloc() and ida_free() should be preferred to the deprecated
>>> ida_simple_get() and ida_simple_remove().
>>>=20
>>> Note that the upper limit of ida_simple_get() is exclusive, but the =
one of
>>> ida_alloc_max() is inclusive. So a -1 has been added when needed.
>>>=20
>>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> It looks good to me. Add this patch into my testing directory.
>> Thanks.
>> Coly Li
>=20
> Hi,
>=20
> polite reminder ;-)

Yes, this one is included in my recent performance testing :-)

Thank you.

Coly Li



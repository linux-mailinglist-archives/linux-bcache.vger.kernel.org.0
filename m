Return-Path: <linux-bcache+bounces-495-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92DE68D11D5
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 04:21:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECF8DB22C3B
	for <lists+linux-bcache@lfdr.de>; Tue, 28 May 2024 02:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5895C4DA14;
	Tue, 28 May 2024 02:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tL46fUW4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MBrduJIj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tL46fUW4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MBrduJIj"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D52D4CB4B
	for <linux-bcache@vger.kernel.org>; Tue, 28 May 2024 02:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716862753; cv=none; b=QwCedfGmpySxtvp3dqcumFft58H71Aa+F7IOt8U1neIiPS3YG3WlPvDfOKigwKzb4HOjVpiNqjaXUaiASB9pjh8R6fkL2VIi3/iVtpToPIS5XdZMEI9vofS25yYi/oTNeS/O81xRmPCiXhfzQSZElGJ9uAFY4nx/WfcFog4IC9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716862753; c=relaxed/simple;
	bh=br7OX9RgkaoJTCwO8rXrjdaIdsB3zuUQkTjBvHALiDg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=leIVxaVvRIgW2ZoiaFKk6MyX/Xnj+mBbFVmxwIh24hmsb0YYNA8OJfcXTjfJ8tOw3APo4+zARAbPltUvFhyUMe1vYP5IQE/f6aAVJoOzIyBcyehouJZlXyM3BEwX8iPTpjuZkB0DmCn02LdAaQwQTcFmrZ+V+LNdcdOgREoMRcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tL46fUW4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MBrduJIj; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tL46fUW4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MBrduJIj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 861932008B;
	Tue, 28 May 2024 02:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716862749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5tpUHFCAWUgN8H2zckvZVHqMIXHa4bQQIxN+ogL9J4=;
	b=tL46fUW46OiwFPUXgnfb+yH5J0shNgSuDS0nKtwfS+D8vaIR7M2P6aELE0JpSgMQrcXFqL
	H6kZJ2T879yOEVt4qLriEuAtrh5NBLAAJcnJSUNYB9gYnskx3E56igRUQJzRyKFSD8j1ue
	oE/4b2KdeG45jPvceqLDhA+0gn5OlYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716862749;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5tpUHFCAWUgN8H2zckvZVHqMIXHa4bQQIxN+ogL9J4=;
	b=MBrduJIjqB7MICqK/qN7DP3oeBSMJdNaCR/sTjmjwCbewxdgOObT16ZY+4+mruOc+dTnh/
	1X7BlSgaSJfPeFCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tL46fUW4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MBrduJIj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716862749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5tpUHFCAWUgN8H2zckvZVHqMIXHa4bQQIxN+ogL9J4=;
	b=tL46fUW46OiwFPUXgnfb+yH5J0shNgSuDS0nKtwfS+D8vaIR7M2P6aELE0JpSgMQrcXFqL
	H6kZJ2T879yOEVt4qLriEuAtrh5NBLAAJcnJSUNYB9gYnskx3E56igRUQJzRyKFSD8j1ue
	oE/4b2KdeG45jPvceqLDhA+0gn5OlYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716862749;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5tpUHFCAWUgN8H2zckvZVHqMIXHa4bQQIxN+ogL9J4=;
	b=MBrduJIjqB7MICqK/qN7DP3oeBSMJdNaCR/sTjmjwCbewxdgOObT16ZY+4+mruOc+dTnh/
	1X7BlSgaSJfPeFCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 68A9213A6B;
	Tue, 28 May 2024 02:19:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ys/VAxw/VWYaUwAAD6G6ig
	(envelope-from <colyli@suse.de>); Tue, 28 May 2024 02:19:08 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH 3/3] bcache: code cleanup in __bch_bucket_alloc_set()
From: Coly Li <colyli@suse.de>
In-Reply-To: <c6e740e5-6e9-4c43-9cfd-5ff1e52a986@ewheeler.net>
Date: Tue, 28 May 2024 10:18:46 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <101B71A6-23A7-478D-A619-57976D885871@suse.de>
References: <20240527174733.16351-1-colyli@suse.de>
 <20240527174733.16351-2-colyli@suse.de>
 <c6e740e5-6e9-4c43-9cfd-5ff1e52a986@ewheeler.net>
To: Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3774.600.62)
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 861932008B
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]



> 2024=E5=B9=B45=E6=9C=8828=E6=97=A5 06:33=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 28 May 2024, Coly Li wrote:
>> In __bch_bucket_alloc_set() the lines after lable 'err:' indeed do
>> nothing useful after multiple cache devices are removed from bcache
>> code. This cleanup patch drops the useless code to save a bit CPU
>> cycles.
>>=20
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>> drivers/md/bcache/alloc.c | 8 ++------
>> 1 file changed, 2 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>> index 32a46343097d..48ce750bf70a 100644
>> --- a/drivers/md/bcache/alloc.c
>> +++ b/drivers/md/bcache/alloc.c
>> @@ -498,8 +498,8 @@ int __bch_bucket_alloc_set(struct cache_set *c, =
unsigned int reserve,
>>=20
>> ca =3D c->cache;
>> b =3D bch_bucket_alloc(ca, reserve, wait);
>> - if (b =3D=3D -1)
>> - goto err;
>> + if (b < 0)
>> + return -1;
>>=20
>> k->ptr[0] =3D MAKE_PTR(ca->buckets[b].gen,
>>     bucket_to_sector(c, b),
>> @@ -508,10 +508,6 @@ int __bch_bucket_alloc_set(struct cache_set *c, =
unsigned int reserve,
>> SET_KEY_PTRS(k, 1);
>>=20
>> return 0;
>> -err:
>> - bch_bucket_free(c, k);
>> - bkey_put(c, k);
>=20
>=20
> Is there a matching "get" somewhere that should be removed, too?

No, it is unnecessary and should be avoided. Because k is ZERO_KEY here, =
calling bch_bucket_free() and bkey_put() are NOOP indeed.

Coly Li



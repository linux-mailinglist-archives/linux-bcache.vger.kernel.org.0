Return-Path: <linux-bcache+bounces-807-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF299DA116
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 04:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 727A9167FE6
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 03:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C21341760;
	Wed, 27 Nov 2024 03:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="abCvyCLl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="91HwI6qF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="abCvyCLl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="91HwI6qF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A0B15C0;
	Wed, 27 Nov 2024 03:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732677445; cv=none; b=mIRqMPqaTeILSiz75K6RHdOmospaUaLInYnLeYoFvur9sq0J4Pua8Yiafxg9vDS1tK1dxJxclMRC5NhwQH5dyArc0vONdarhD2zfnzyXbc9M5M4okdWdHqAz8FXQ+O7dkxkP1yHye1tBYpacJlZCJ8RORaJZEXPwhPPlvg9thcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732677445; c=relaxed/simple;
	bh=7hssgipUOAkhjejCsuRKLDuJDq27eMRBSF25vQXFmHg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NkgD8O0jRkqhKBBNKTHyed1OuR0T5YqKywJlJ9rMcTOksxeZu+KeB/gxlFjru1Zae4hFu+/TU1d+eWYEbr2yiK8xwuDqwlYXLFreIDQfWXHo7BprpKwBlimQ5LDJPuKG4v2ltSFntrL0d7OCR//fWoO27u3lg4+QPuzTT5d5/wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=abCvyCLl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=91HwI6qF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=abCvyCLl; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=91HwI6qF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0789621164;
	Wed, 27 Nov 2024 03:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732677441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jATjBtB2OGVhywDyqkSVuR6RGqt1WfVDdmwiHU0e0ng=;
	b=abCvyCLlTSo2+k30H/RwkhESOy1z5Ac1OjjN8XisisPhXMFvnVWNOPhlQh3jpF5XpLkAEN
	MuBHiM2TaAuNNWw1gEbC9DD0iQDTq9Pxn6iJVS15D8x2XYEqoiAnQHjGaF8AnonI84+XEl
	ItXONFEex0yEty/nuVUayh+p6fifCKE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732677441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jATjBtB2OGVhywDyqkSVuR6RGqt1WfVDdmwiHU0e0ng=;
	b=91HwI6qFUKaYPUizYHkfSO1/eLgX02u4L9fnhqUfxjYHE4ioMmcyCKFNV1/Ww6FzQ0jlTj
	WGkjuigjgzuf9ABw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=abCvyCLl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=91HwI6qF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732677441; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jATjBtB2OGVhywDyqkSVuR6RGqt1WfVDdmwiHU0e0ng=;
	b=abCvyCLlTSo2+k30H/RwkhESOy1z5Ac1OjjN8XisisPhXMFvnVWNOPhlQh3jpF5XpLkAEN
	MuBHiM2TaAuNNWw1gEbC9DD0iQDTq9Pxn6iJVS15D8x2XYEqoiAnQHjGaF8AnonI84+XEl
	ItXONFEex0yEty/nuVUayh+p6fifCKE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732677441;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jATjBtB2OGVhywDyqkSVuR6RGqt1WfVDdmwiHU0e0ng=;
	b=91HwI6qFUKaYPUizYHkfSO1/eLgX02u4L9fnhqUfxjYHE4ioMmcyCKFNV1/Ww6FzQ0jlTj
	WGkjuigjgzuf9ABw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D679313983;
	Wed, 27 Nov 2024 03:17:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0HeJIj6PRmdLVwAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 27 Nov 2024 03:17:18 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH V3] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR
 again
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAAsfc_pxrz1bcfo=29-qPuZhEEffbK5=LYGeNRV9gf=vfyp8Aw@mail.gmail.com>
Date: Wed, 27 Nov 2024 11:17:01 +0800
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7B52DB03-5E27-4F61-AE1A-11081B12E4BE@suse.de>
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
 <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de>
 <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
 <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de>
 <CAAsfc_oTmE2E8pMctiLSwMngVUbtJa4G=KAozzAfztMMc_RMOQ@mail.gmail.com>
 <0CFF2B9E-4E40-480D-9F3B-F7631FE3CEA5@suse.de>
 <A86AAB66-C89A-4A37-8416-F9A99D4630D8@suse.de>
 <CAAsfc_pxrz1bcfo=29-qPuZhEEffbK5=LYGeNRV9gf=vfyp8Aw@mail.gmail.com>
To: liequan che <liequanche@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-Rspamd-Queue-Id: 0789621164
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[easystack.cn,gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,inspur.com:email,suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO



> 2024=E5=B9=B411=E6=9C=8827=E6=97=A5 11:01=EF=BC=8Cliequan che =
<liequanche@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
> node allocations") leads a NULL pointer deference in =
cache_set_flush().
>=20
> 1721         if (!IS_ERR_OR_NULL(c->root))
> 1722                 list_add(&c->root->list, &c->btree_cache);
>=20
> =46rom the above code in cache_set_flush(), if previous registration =
code
> fails before allocating c->root, it is possible c->root is NULL as =
what
> it is initialized. Also __bch_btree_node_alloc() never returns NULL =
but
> c->root is possible to be NULL at above line 1721.
>=20
> This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.


OK, this time the commit log makes a lot sense. It is clear to me.


>=20
> Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in
> node allocations")
> Signed-off-by: Liequan Che <cheliequan@inspur.com>
> Cc: stable@vger.kernel.org
> Cc: Zheng Wang <zyytlz.wz@163.com>
> Cc: Coly Li <colyli@suse.de>
> ---
> drivers/md/bcache/super.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e7abfdd77c3b..e42f1400cea9 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1718,7 +1718,7 @@ static CLOSURE_CALLBACK(cache_set_flush)
>        if (!IS_ERR_OR_NULL(c->gc_thread))
>                kthread_stop(c->gc_thread);
>=20
> -       if (!IS_ERR(c->root))
> +       if (!IS_ERR_OR_NULL(c->root))
>                list_add(&c->root->list, &c->btree_cache);
>=20
>        /*
> =E2=80=94
> 2.46.0

It is fine to me. I am in travel these days, and will handle this patch =
by end of this week.

Thanks for composing this patch.

Coly Li=


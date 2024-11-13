Return-Path: <linux-bcache+bounces-782-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9779C69A1
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 08:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB05283E16
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 07:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1835C16E87D;
	Wed, 13 Nov 2024 07:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CpgP73Aq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i4bLNeBK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CpgP73Aq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="i4bLNeBK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5508B230996;
	Wed, 13 Nov 2024 07:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731481481; cv=none; b=kBPvhYRuKJvkpAGLqc3jT4WjKy7W3y463j7h3omFhgF9bJaYxQkZhI4kwrBtGidq7tAOZtNgK0vREsbsA/mxq7yNE+/hlz+Lji7Im3i6+Hg36WlNRc+KxBGSW/1yQ9prr6JgeTG4TMBFiYLl4kWvHZv+zBvzPMYi4+bEF6yTN9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731481481; c=relaxed/simple;
	bh=2eO2wsILqAPIvH5dKfhHblSv9b5HCaATpy6xktLY0eI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Bw+ivGEjAodTb5VX9QRPNuhMeJdUGPZe7l90IW1/RtivbBVs1AoBPNvVFQtjHK5+PVtM60n73L/wn9Jf3YIUWnopNtMbTlyQg5hWZB+YoCedtQXCGxET39PsghAMd3hw8c9w9eoUPKSj8B3AfEZmYuC9B1f34hvXTEyME9dHPwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CpgP73Aq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i4bLNeBK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=CpgP73Aq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=i4bLNeBK; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CF24211E0;
	Wed, 13 Nov 2024 07:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731481477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3usIAWkA34t3JRyZdefu9oCpw+12iEGeWsQ+oEtopkw=;
	b=CpgP73AqTLH7uAuFdbuak5hmStPIgRgIbczNtA5hdK2WENsPXrTHMH85D8/qQB+syfPwCy
	Xna3iDdvSj+RqGeBEtdP5YR0FlwGggo+kVUwj6RFb3TTTjk18hhUMHvbuKVfL/7vs51XBl
	L9F+DjQFUz7dsk8yLON5TnT46EN51a8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731481477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3usIAWkA34t3JRyZdefu9oCpw+12iEGeWsQ+oEtopkw=;
	b=i4bLNeBK91BgOr950ylkGkUNVccaV2T81QG5hTLDiDQXW9gTnO7z/n9fCH2BWjkE8FodDs
	5QdGwSWKVvjG/mCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731481477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3usIAWkA34t3JRyZdefu9oCpw+12iEGeWsQ+oEtopkw=;
	b=CpgP73AqTLH7uAuFdbuak5hmStPIgRgIbczNtA5hdK2WENsPXrTHMH85D8/qQB+syfPwCy
	Xna3iDdvSj+RqGeBEtdP5YR0FlwGggo+kVUwj6RFb3TTTjk18hhUMHvbuKVfL/7vs51XBl
	L9F+DjQFUz7dsk8yLON5TnT46EN51a8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731481477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3usIAWkA34t3JRyZdefu9oCpw+12iEGeWsQ+oEtopkw=;
	b=i4bLNeBK91BgOr950ylkGkUNVccaV2T81QG5hTLDiDQXW9gTnO7z/n9fCH2BWjkE8FodDs
	5QdGwSWKVvjG/mCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16C5513AC3;
	Wed, 13 Nov 2024 07:04:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GYNsMYNPNGcrEgAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 13 Nov 2024 07:04:35 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: bcache: fix oops bug in cache_set_flush
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
Date: Wed, 13 Nov 2024 15:04:15 +0800
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D57B37C5-3241-483B-83DE-483243984E60@suse.de>
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
To: liequan che <liequanche@gmail.com>
X-Mailer: Apple Mail (2.3826.200.121)
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Flag: NO
X-Spam-Level: 

Hi Liequan,

> 2024=E5=B9=B411=E6=9C=8813=E6=97=A5 14:25=EF=BC=8Cliequan che =
<liequanche@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Signed-off-by: cheliequan <cheliequan@inspur.com>
>=20
>   If the bcache cache disk contains damaged btree data,
> when the bcache cache disk partition is directly operated,
> the system-udevd service is triggered to call the bcache-register
> program to register the bcache device,resulting in kernel oops.
>=20

What is the kernel version ?=20

Interesting that why the btree node checking code during registration =
doesn=E2=80=99t cache the meta data error.



> crash> bt
> PID: 7773     TASK: ffff49cc44d69340  CPU: 57   COMMAND: =
"kworker/57:2"
> #0 [ffff800046373800] machine_kexec at ffffbe5039eb54a8
> #1 [ffff8000463739b0] __crash_kexec at ffffbe503a052824
> #2 [ffff8000463739e0] crash_kexec at ffffbe503a0529cc
> #3 [ffff800046373a60] die at ffffbe5039e9445c
> #4 [ffff800046373ac0] die_kernel_fault at ffffbe5039ec698c
> #5 [ffff800046373af0] __do_kernel_fault at ffffbe5039ec6a38
> #6 [ffff800046373b20] do_page_fault at ffffbe503ac76ba4
> #7 [ffff800046373b70] do_translation_fault at ffffbe503ac76ebc
> #8 [ffff800046373b90] do_mem_abort at ffffbe5039ec68ac
> #9 [ffff800046373bc0] el1_abort at ffffbe503ac669bc
> #10 [ffff800046373bf0] el1_sync_handler at ffffbe503ac671d4
> #11 [ffff800046373d30] el1_sync at ffffbe5039e82230
> #12 [ffff800046373d50] cache_set_flush at ffffbe50121fa4c4 [bcache]
> #13 [ffff800046373da0] process_one_work at ffffbe5039f5af68
> #14 [ffff800046373e00] worker_thread at ffffbe5039f5b3c4
> #15 [ffff800046373e50] kthread at ffffbe5039f634b8
> crash> dis cache_set_flush+0x94
> 0xffffbe50121fa4c8 <cache_set_flush+148>:       str     x23, [x20, =
#512]
>=20
> ---
> drivers/md/bcache/super.c | 16 ++++++++++------
> 1 file changed, 10 insertions(+), 6 deletions(-)
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index fd97730479d8..8a41dfcf9fb6 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1741,8 +1741,10 @@ static void cache_set_flush(struct closure *cl)
>       if (!IS_ERR_OR_NULL(c->gc_thread))
>               kthread_stop(c->gc_thread);
>=20
> -       if (!IS_ERR(c->root))
> -               list_add(&c->root->list, &c->btree_cache);
> +       if (!IS_ERR_OR_NULL(c->root)) {
> +               if (!list_empty(&c->root->list))
> +                       list_add(&c->root->list, &c->btree_cache);
> +       }
>=20
>       /*
>        * Avoid flushing cached nodes if cache set is retiring
> @@ -1750,10 +1752,12 @@ static void cache_set_flush(struct closure =
*cl)
>        */
>       if (!test_bit(CACHE_SET_IO_DISABLE, &c->flags))
>               list_for_each_entry(b, &c->btree_cache, list) {
> -                       mutex_lock(&b->write_lock);
> -                       if (btree_node_dirty(b))
> -                               __bch_btree_node_write(b, NULL);
> -                       mutex_unlock(&b->write_lock);
> +                       if (!IS_ERR_OR_NULL(b)) {

The above check is not safe.=20



> +                               mutex_lock(&b->write_lock);
> +                               if (btree_node_dirty(b))
> +                                       __bch_btree_node_write(b, =
NULL);
> +                               mutex_unlock(&b->write_lock);
> +                       }
>               }
>=20
>       if (ca->alloc_thread)
> --
> 2.33.0


Thanks.

Coly Li=


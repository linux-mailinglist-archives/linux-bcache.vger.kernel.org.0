Return-Path: <linux-bcache+bounces-30-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9280F7F78F3
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 17:29:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 240CC1F20C37
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 16:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAA1B34189;
	Fri, 24 Nov 2023 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="CBUsUsEh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qz/eHiR/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AF9199A;
	Fri, 24 Nov 2023 08:29:37 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EA59A21E75;
	Fri, 24 Nov 2023 16:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700843373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnLFi4GJJHGz6wMxhsSIgbgHlypgMQFR88Q3hpHSyhI=;
	b=CBUsUsEhSLNPRluRHLjiLQNp3FuaH7bSL2Yw7oBDKWuXr9T6NO1uBzpoPojoANDTbG70vP
	v8TgonhYdajtraqNPVfFNBhcvFNNos9qWYpsn0gnthArTyPM6wWzWtKsOXtHl4X8D76Tfr
	gtzq+hqsbTtxF/IWC3RZfHLGezvJcx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700843373;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnLFi4GJJHGz6wMxhsSIgbgHlypgMQFR88Q3hpHSyhI=;
	b=qz/eHiR/VC4sSjLEeDqvic4tGZ/r9n/nwps/OZxPd/EBK1Wa0dYhL0rdputcWRFubZPzab
	0QPu6Nbq/xWFmtDw==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A29D132E2;
	Fri, 24 Nov 2023 16:29:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id oGAbA2rPYGX9RQAAn2gu4w
	(envelope-from <colyli@suse.de>); Fri, 24 Nov 2023 16:29:30 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR
From: Coly Li <colyli@suse.de>
In-Reply-To: <c47d3540ece151a2fb30e1c7b5881cb8922db915.camel@gekmihesg.de>
Date: Sat, 25 Nov 2023 00:29:12 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>,
 Thorsten Leemhuis <regressions@leemhuis.info>,
 Zheng Wang <zyytlz.wz@163.com>,
 linux-kernel@vger.kernel.org,
 =?utf-8?Q?Stefan_F=C3=B6rster?= <cite@incertum.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Jens Axboe <axboe@kernel.dk>,
 Linux kernel regressions list <regressions@lists.linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B68E455A-D6EB-4BB9-BD60-F2F8C3C8C21A@suse.de>
References: <ZV9ZSyDLNDlzutgQ@pharmakeia.incertum.net>
 <be371028-efeb-44af-90ea-5c307f27d4c6@leemhuis.info>
 <71576a9ff7398bfa4b8c0a1a1a2523383b056168.camel@gekmihesg.de>
 <989C39B9-A05D-4E4F-A842-A4943A29FFD6@suse.de>
 <1c2a1f362d667d36d83a5ba43218bad199855b11.camel@gekmihesg.de>
 <3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de>
 <c47d3540ece151a2fb30e1c7b5881cb8922db915.camel@gekmihesg.de>
To: Markus Weippert <markus@gekmihesg.de>
X-Mailer: Apple Mail (2.3774.200.91.1.1)
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: 1.53
X-Spamd-Result: default: False [1.53 / 50.00];
	 ARC_NA(0.00)[];
	 TO_DN_EQ_ADDR_SOME(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 FREEMAIL_ENVRCPT(0.00)[163.com];
	 REPLY(-4.00)[];
	 BAYES_HAM(-1.18)[88.95%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_SPAM_LONG(3.49)[0.997];
	 RCPT_COUNT_SEVEN(0.00)[10];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,gekmihesg.de:email];
	 NEURAL_SPAM_SHORT(2.81)[0.937];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[vger.kernel.org,leemhuis.info,163.com,incertum.net,linuxfoundation.org,kernel.dk,lists.linux.dev];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]



> 2023=E5=B9=B411=E6=9C=8824=E6=97=A5 23:14=EF=BC=8CMarkus Weippert =
<markus@gekmihesg.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
> node allocations") replaced IS_ERR_OR_NULL by IS_ERR. This leads to a
> NULL pointer dereference.
>=20
> BUG: kernel NULL pointer dereference, address: 0000000000000080
> Call Trace:
> ? __die_body.cold+0x1a/0x1f
> ? page_fault_oops+0xd2/0x2b0
> ? exc_page_fault+0x70/0x170
> ? asm_exc_page_fault+0x22/0x30
> ? btree_node_free+0xf/0x160 [bcache]
> ? up_write+0x32/0x60
> btree_gc_coalesce+0x2aa/0x890 [bcache]
> ? bch_extent_bad+0x70/0x170 [bcache]
> btree_gc_recurse+0x130/0x390 [bcache]
> ? btree_gc_mark_node+0x72/0x230 [bcache]
> bch_btree_gc+0x5da/0x600 [bcache]
> ? cpuusage_read+0x10/0x10
> ? bch_btree_gc+0x600/0x600 [bcache]
> bch_gc_thread+0x135/0x180 [bcache]
>=20
> The relevant code starts with:
>=20
>    new_nodes[0] =3D NULL;
>=20
>    for (i =3D 0; i < nodes; i++) {
>        if (__bch_keylist_realloc(&keylist, bkey_u64s(&r[i].b->key)))
>            goto out_nocoalesce;
>    // ...
> out_nocoalesce:
>    // ...
>    for (i =3D 0; i < nodes; i++)
>        if (!IS_ERR(new_nodes[i])) {  // IS_ERR_OR_NULL before
> 028ddcac477b
>            btree_node_free(new_nodes[i]);  // new_nodes[0] is NULL
>            rw_unlock(true, new_nodes[i]);
>        }
>=20
> This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.
>=20
> Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in
> node allocations")
> Link:
> =
https://lore.kernel.org/all/3DF4A87A-2AC1-4893-AE5F-E921478419A9@suse.de/
> Cc: stable@vger.kernel.org
> Cc: Zheng Wang <zyytlz.wz@163.com>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Markus Weippert <markus@gekmihesg.de>

Added into my for-next.  Thanks for patching up.

Coly Li


>=20
> ---
> drivers/md/bcache/btree.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index de3019972..261596791 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1522,7 +1522,7 @@ static int btree_gc_coalesce(struct btree *b,
> struct btree_op *op,
>        bch_keylist_free(&keylist);
>=20
>        for (i =3D 0; i < nodes; i++)
> -               if (!IS_ERR(new_nodes[i])) {
> +               if (!IS_ERR_OR_NULL(new_nodes[i])) {
>                        btree_node_free(new_nodes[i]);
>                        rw_unlock(true, new_nodes[i]);
>                }
> --



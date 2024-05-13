Return-Path: <linux-bcache+bounces-437-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 557C08C3CC4
	for <lists+linux-bcache@lfdr.de>; Mon, 13 May 2024 09:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D4C8E1F21695
	for <lists+linux-bcache@lfdr.de>; Mon, 13 May 2024 07:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134D5146D61;
	Mon, 13 May 2024 07:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="T8U9aZqp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8M5Gfs+i";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="T8U9aZqp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8M5Gfs+i"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61604146A9D
	for <linux-bcache@vger.kernel.org>; Mon, 13 May 2024 07:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715587043; cv=none; b=sDfHrgqQhzvdE4YlkcF54OyeBmG87zbCCTH4gyZaCJ4L0RzBza5QbrMzGSdPQQMO/WeiDE6KB39Jq7yZDsBn4oM+uIjxL5/iKLn1XUTuc7IgI0qQjcmNRr2h8KouPPpeo7UP1KQ8zwsF0DzyVPBaPeFxM9VHcvWHbOSDiiD1jUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715587043; c=relaxed/simple;
	bh=FoeUJucJQTMOseovmjxXSS+vw7kIibEPPj+fR2I7oG8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XPpwRr1vNsgIVP0Uwc5DwhPERXE5wQznYYwAlV9W4/dzdkX2wd4prvJjSXwuywWotr74LwFHcaxvqL6ASywKobDyu+X5SNrwEYqQL7+SIbccppDE41fP/gOeKZYkThxKepNV4TMWHVZQjKb4ILhyo4NoEn9DN8HPvt9uq0SPA/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=T8U9aZqp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8M5Gfs+i; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=T8U9aZqp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8M5Gfs+i; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 301FE33A35;
	Mon, 13 May 2024 07:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715587039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TwAeaKckIfv5borw70VTX/Dz3IFfwJJ//JrXdeBpi98=;
	b=T8U9aZqpZFrhXCi4WGoMgszOwT5yBXazOckdUPwK8LWu0dzObnt93iAxUlzxf62qD9LnpQ
	HxY8rsX6PiVKyJFKZe5HGsXld8tFOftWJ4QOgI4SoamuEmTPgguaovnqL3F8octXuO/g9h
	Wi+8aPjzeTKWYgPIzp2qaxKnIyzrX6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715587039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TwAeaKckIfv5borw70VTX/Dz3IFfwJJ//JrXdeBpi98=;
	b=8M5Gfs+inleZwMVpzWbpjnXfgsXw8XqMr02rYo30Ftn+NOoX1gJy5evD1Cbra/Ic2VjsCy
	9mUPhAsykQ8KhCAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T8U9aZqp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8M5Gfs+i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715587039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TwAeaKckIfv5borw70VTX/Dz3IFfwJJ//JrXdeBpi98=;
	b=T8U9aZqpZFrhXCi4WGoMgszOwT5yBXazOckdUPwK8LWu0dzObnt93iAxUlzxf62qD9LnpQ
	HxY8rsX6PiVKyJFKZe5HGsXld8tFOftWJ4QOgI4SoamuEmTPgguaovnqL3F8octXuO/g9h
	Wi+8aPjzeTKWYgPIzp2qaxKnIyzrX6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715587039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TwAeaKckIfv5borw70VTX/Dz3IFfwJJ//JrXdeBpi98=;
	b=8M5Gfs+inleZwMVpzWbpjnXfgsXw8XqMr02rYo30Ftn+NOoX1gJy5evD1Cbra/Ic2VjsCy
	9mUPhAsykQ8KhCAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D3C81372E;
	Mon, 13 May 2024 07:57:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rgiEOt3HQWanJwAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 13 May 2024 07:57:17 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: Kernel error with 6.8.9
From: Coly Li <colyli@suse.de>
In-Reply-To: <1be3d08b-4c85-4031-b674-549289395e45@orange.fr>
Date: Mon, 13 May 2024 15:57:01 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FCB4406D-192D-46A1-BB6D-2153B527ED87@suse.de>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
 <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
 <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
 <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
 <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
 <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
 <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
 <1be3d08b-4c85-4031-b674-549289395e45@orange.fr>
To: "Pierre Juhen (IMAP)" <pierre.juhen@orange.fr>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Level: 
X-Spamd-Result: default: False [-1.01 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	BAYES_HAM(-0.00)[12.78%];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[orange.fr];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[orange.fr];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 301FE33A35
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -1.01



> 2024=E5=B9=B45=E6=9C=8812=E6=97=A5 17:41=EF=BC=8CPierre Juhen (IMAP) =
<pierre.juhen@orange.fr> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
>=20
> I use bcache on an nvme partition as frontend and md array ass =
backend.
>=20
> I have the following error since I updated to kernel 6.8.9.
>=20
>  UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1098:3
> [    7.138127] index 4 is out of range for type 'btree_iter_set [4]'
> [    7.138129] CPU: 9 PID: 645 Comm: bcache-register Not tainted =
6.8.9-200.fc39.x86_64 #1
> [    7.138131] Hardware name: Gigabyte Technology Co., Ltd. B550M =
DS3H/B550M DS3H, BIOS F1 12/07/2022
> [    7.138133] Call Trace:
> [    7.138135]  <TASK>
> [    7.138137]  dump_stack_lvl+0x64/0x80
> [    7.138143]  __ubsan_handle_out_of_bounds+0x95/0xd0
> [    7.138148]  bch_btree_iter_push+0x4ca/0x4e0 [bcache]
> [    7.138160]  bch_btree_node_read_done+0xca/0x3f0 [bcache]
> [    7.138171]  bch_btree_node_read+0xe4/0x1d0 [bcache]
> [    7.138180]  ? __pfx_closure_sync_fn+0x10/0x10
> [    7.138183]  bch_btree_node_get.part.0+0x156/0x320 [bcache]
> [    7.138192]  ? __pfx_up_write+0x10/0x10
> [    7.138197]  register_bcache+0x1f31/0x2230 [bcache]
> [    7.138212]  kernfs_fop_write_iter+0x136/0x1d0
> [    7.138217]  vfs_write+0x29e/0x470
> [    7.138222]  ksys_write+0x6f/0xf0
> [    7.138224]  do_syscall_64+0x83/0x170
> [    7.138229]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138232]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138234]  ? xas_find+0x75/0x1d0
> [    7.138237]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138239]  ? next_uptodate_folio+0xa5/0x2e0
> [    7.138243]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138245]  ? filemap_map_pages+0x474/0x550
> [    7.138248]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138251]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138253]  ? do_fault+0x246/0x490
> [    7.138256]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138258]  ? __handle_mm_fault+0x827/0xe40
> [    7.138262]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138264]  ? __count_memcg_events+0x69/0x100
> [    7.138267]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138269]  ? count_memcg_events.constprop.0+0x1a/0x30
> [    7.138271]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138273]  ? handle_mm_fault+0xa2/0x360
> [    7.138275]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138277]  ? do_user_addr_fault+0x304/0x690
> [    7.138281]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138282]  ? srso_alias_return_thunk+0x5/0xfbef5
> [    7.138285]  entry_SYSCALL_64_after_hwframe+0x78/0x80
> [    7.138287] RIP: 0033:0x7f2dba570ee4
> [    7.138292] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f =
84 00 00 00 00 00 f3 0f 1e fa 80 3d 85 74 0d 00 00 74 13 b8 01 00 00 00 =
0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 55 48 89 e5 48 83 ec 20 4
> 8 89
> [    7.138293] RSP: 002b:00007ffe3e2f1df8 EFLAGS: 00000202 ORIG_RAX: =
0000000000000001
> [    7.138295] RAX: ffffffffffffffda RBX: 00007ffe3e2f1e6c RCX: =
00007f2dba570ee4
> [    7.138297] RDX: 000000000000000f RSI: 00007ffe3e2f1e6c RDI: =
0000000000000003
> [    7.138298] RBP: 00007ffe3e2f1e30 R08: 0000000000000073 R09: =
0000000000000001
> [    7.138299] R10: 0000000000000000 R11: 0000000000000202 R12: =
000000000000000f
> [    7.138300] R13: 00007ffe3e2f1e7b R14: 00007ffe3e2f1e6c R15: =
00007ffe3e2f1e40
> [    7.138303]  </TASK>
>=20
> The error is repeated  15 times while  reboot
>=20
>  (I have a 12 threads processors).

The fix is in linux-next and will be in 6.10 as expecting.

Thanks.

Coly Li



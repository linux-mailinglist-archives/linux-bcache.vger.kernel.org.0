Return-Path: <linux-bcache+bounces-712-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C481494E123
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Aug 2024 14:32:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E944B1C20A04
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Aug 2024 12:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F46443AA8;
	Sun, 11 Aug 2024 12:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q4z9agTT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GNrKNgEE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Q4z9agTT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GNrKNgEE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766D0EEBA
	for <linux-bcache@vger.kernel.org>; Sun, 11 Aug 2024 12:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723379519; cv=none; b=BbJ/X7AtNvauRrhPgGLfDJnVHik5V/eeglfttj2Gpo/Di0gEEPJ6KsEOh1rnxYp3y3JGEjsyU9mMpDAX4f+rLBcqhYE2mi8VKtX6XXPRTIRh9oCjlI4pR4qNSWq2l0XwWKtjwzbVw+e64f+PL8OhSps6zvuEUZvW25GmOLSZWhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723379519; c=relaxed/simple;
	bh=0PQYE0UJXla7a+9t3LBYWoEavgkYuzfMFfEjOdd6kRU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WxXvsFqfmFaLT8e32u05OcezRGUGv9EkM40dz+L5mK/mBwZ/AmurbNptsgR5Kl9jj1lifHE1RHRkm7vd8pXzgAIJBs/y7K2KnN/nnnh9lwg3nItnkEf+JcluaRFdNWg0JlnomoqmF2CnpVbo1fcPIsTCjfGNoDHgLTzBZLV2IAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q4z9agTT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GNrKNgEE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Q4z9agTT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GNrKNgEE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4333C20123;
	Sun, 11 Aug 2024 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723379515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0PQYE0UJXla7a+9t3LBYWoEavgkYuzfMFfEjOdd6kRU=;
	b=Q4z9agTTfH1tXkqh/m42qAIrDhZUs/C6UfIUMjPXwRE7Dxd33KdSOVUEHcbTx2jaSgv280
	p55duuTrEtaMoE6iyCdwXdNKFFWSf7AdL/qjQyDJSl7Hu2xdkBr5RiDOaFgIrUTOoO74A/
	8wDHNzOjyBdTk+yDb3dZbYa/aZKtTz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723379515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0PQYE0UJXla7a+9t3LBYWoEavgkYuzfMFfEjOdd6kRU=;
	b=GNrKNgEEHJfdIgaRUl+UGo/fTs9RTyyC7sDVhjQw8cUzqbXZDKDqD6cjzFUtAfP7iN/mNg
	H3p697ntMzRu+/Cw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q4z9agTT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GNrKNgEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1723379515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0PQYE0UJXla7a+9t3LBYWoEavgkYuzfMFfEjOdd6kRU=;
	b=Q4z9agTTfH1tXkqh/m42qAIrDhZUs/C6UfIUMjPXwRE7Dxd33KdSOVUEHcbTx2jaSgv280
	p55duuTrEtaMoE6iyCdwXdNKFFWSf7AdL/qjQyDJSl7Hu2xdkBr5RiDOaFgIrUTOoO74A/
	8wDHNzOjyBdTk+yDb3dZbYa/aZKtTz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1723379515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0PQYE0UJXla7a+9t3LBYWoEavgkYuzfMFfEjOdd6kRU=;
	b=GNrKNgEEHJfdIgaRUl+UGo/fTs9RTyyC7sDVhjQw8cUzqbXZDKDqD6cjzFUtAfP7iN/mNg
	H3p697ntMzRu+/Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 31F4013704;
	Sun, 11 Aug 2024 12:31:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sho5MzmvuGZ0DgAAD6G6ig
	(envelope-from <colyli@suse.de>); Sun, 11 Aug 2024 12:31:53 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: multipath'd bcache device
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
Date: Sun, 11 Aug 2024 20:31:34 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <08E9CAFD-1ECC-4B46-8F0D-7124716E76EF@suse.de>
References: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
To: Mitchell Dzurick <mitchell.dzurick@canonical.com>
X-Mailer: Apple Mail (2.3774.600.62)
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: 4333C20123
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spam-Flag: NO



> 2024=E5=B9=B48=E6=9C=888=E6=97=A5 09:21=EF=BC=8CMitchell Dzurick =
<mitchell.dzurick@canonical.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello bcache team.
>=20
> I know this project is done and stable as [0] says, but I have a
> question if anyone is around to answer.
>=20
> Has bcache devices been tested and supported on multipath'd disks? I'm
> looking into an Ubuntu bug[1], where these 2 projects are clashing.
> I'm wondering if there was any consideration or support for
> multipathing when this project was made.
>=20
> Also, your new project, bcachefs, might be hitting the same scenario.
> I haven't had the time to test this though unfortunately.
>=20
> Thanks for your time,
> -Mitch
>=20
> [0] - https://bcache.evilpiepirate.org/#index4h1
> [1] - =
https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/1887558
>=20

=46rom the Ubuntu bug report, I don=E2=80=99t see the kernel version. =
After parallel and asynchronous initialization was enabled, the udev =
rule won=E2=80=99t always occupy the bcache block device for long time.

It might be a bit helpful if you may provide the kernel version and =
Ubuntu os version. BTW I don=E2=80=99t have ubuntu account and cannot =
access pastern.canonical.com.

Thanks.

Coly Li=


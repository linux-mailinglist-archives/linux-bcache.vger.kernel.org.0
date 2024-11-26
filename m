Return-Path: <linux-bcache+bounces-803-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A27989D9FD2
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Nov 2024 00:46:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62CA228554D
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Nov 2024 23:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B17D31DFE08;
	Tue, 26 Nov 2024 23:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HtSUOt9Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="knCl1QIi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HtSUOt9Z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="knCl1QIi"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DA3D299;
	Tue, 26 Nov 2024 23:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732664761; cv=none; b=nywsKpbEtc7VQItxzGGwD+40el6vD3baMgrz80Q72jKwZi25k07UB+gCznIPQX9AycOZXE9Ww76SnpxAXCpmaLatRVYf2/JbQ9hZjDfHpQA4dnso4jh4yK7fQ1Ih+hk6lMd2CtDyfpA9wnN+W6IiClAJnjoY42a7jIwPxYLJwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732664761; c=relaxed/simple;
	bh=imzoDdGoUlA4iho1rt7o5uuKgdiKDjDA/QhR36BjxdA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=iHg4I5RSV4Eoz/UL3RSKa7LbeACJ5LK8grn1jbKb4TEMyXAyrxnqQRhIukn3wS1S2vciBl22XlPQ9zbOcfCTxbecdQ8LabYgigZm5UgRt5r0aQ9woDAQ+NuEEQKC6dSwr1CcfrAN+EH9Fg4ea9BfZB/qvRZcqa+T4a22uMfLt3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HtSUOt9Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=knCl1QIi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HtSUOt9Z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=knCl1QIi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 92FC92116E;
	Tue, 26 Nov 2024 23:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732664757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=imzoDdGoUlA4iho1rt7o5uuKgdiKDjDA/QhR36BjxdA=;
	b=HtSUOt9Z/xmqnTYRgPT1LO1Aao5htxdkI3Kh/x5y+Xx24WTXr/kb0jsGA3wxEUTv1YFOwu
	5EQ6GRBAOxocu2xGrbkRiLF8brnSr7kDYzu4yB5PrPjXrW/4CLZKTPi0yjQ8QG+UTTjkXs
	2z3R+WfQGOOlV7lnpA0m/fA1Pv2prYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732664757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=imzoDdGoUlA4iho1rt7o5uuKgdiKDjDA/QhR36BjxdA=;
	b=knCl1QIiky4za0UQ5/TLWUwV/LHMLcaOUf946oGj4zAhsWhR5ODmhkgH/Rf2regsPQLklk
	kYKGoEMdn5hintCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HtSUOt9Z;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=knCl1QIi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732664757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=imzoDdGoUlA4iho1rt7o5uuKgdiKDjDA/QhR36BjxdA=;
	b=HtSUOt9Z/xmqnTYRgPT1LO1Aao5htxdkI3Kh/x5y+Xx24WTXr/kb0jsGA3wxEUTv1YFOwu
	5EQ6GRBAOxocu2xGrbkRiLF8brnSr7kDYzu4yB5PrPjXrW/4CLZKTPi0yjQ8QG+UTTjkXs
	2z3R+WfQGOOlV7lnpA0m/fA1Pv2prYs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732664757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=imzoDdGoUlA4iho1rt7o5uuKgdiKDjDA/QhR36BjxdA=;
	b=knCl1QIiky4za0UQ5/TLWUwV/LHMLcaOUf946oGj4zAhsWhR5ODmhkgH/Rf2regsPQLklk
	kYKGoEMdn5hintCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B094213890;
	Tue, 26 Nov 2024 23:45:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N4UYGbNdRmfQHwAAD6G6ig
	(envelope-from <colyli@suse.de>); Tue, 26 Nov 2024 23:45:55 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] bcache:fix oops in cache_set_flush
From: Coly Li <colyli@suse.de>
In-Reply-To: <0CFF2B9E-4E40-480D-9F3B-F7631FE3CEA5@suse.de>
Date: Wed, 27 Nov 2024 07:45:38 +0800
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A86AAB66-C89A-4A37-8416-F9A99D4630D8@suse.de>
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
 <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de>
 <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
 <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de>
 <CAAsfc_oTmE2E8pMctiLSwMngVUbtJa4G=KAozzAfztMMc_RMOQ@mail.gmail.com>
 <0CFF2B9E-4E40-480D-9F3B-F7631FE3CEA5@suse.de>
To: liequan che <liequanche@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-Rspamd-Queue-Id: 92FC92116E
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[easystack.cn,gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	APPLE_MAILER_COMMON(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO



> 2024=E5=B9=B411=E6=9C=8826=E6=97=A5 23:38=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
>> 2024=E5=B9=B411=E6=9C=8819=E6=97=A5 12:19=EF=BC=8Cliequan che =
<liequanche@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>=20
> [snipped]
>=20
>>>> 7. Repartition again, triggering kernel panic again.
>>>> parted -s --align optimal /dev/nvme2n1 mkpart primary 2048s 1536GiB
>>>> The same operation was performed on the other two servers, and no
>>>> panic was triggered.
>>=20
>>> I guess this is another undefine operation. I assume the cache =
device is still references somewhere. A reboot should follow the wipefs.
>> Your guess is correct. In addition, after erasing the superblock
>> information in CD rescue mode,
>> I rebooted into the system where the original panic kernel was =
located.
>>=20
>=20
> Please try latest upstream kernel and try whether you can see the =
issue.
>=20
> c->root is allocated by __bch_btree_node_alloc(), it doesn=E2=80=99t =
return NULL pointer.

I need to withdraw the above inaccurate comments. It c->root cannot be =
NULL from __bch_btree_node_alloc(), but it can be NULL if previous lines =
failed and went to the error code path.

Thanks to commit 028ddcac477b ("bcache: Remove unnecessary NULL point =
check in node allocations=E2=80=9D). Could you please to compose a patch =
to partially revert it? The change is same, but change the commit log to =
mention that your change partially revert commit 028ddcac477b.


Thanks.

Coly Li=


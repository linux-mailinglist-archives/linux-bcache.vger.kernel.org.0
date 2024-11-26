Return-Path: <linux-bcache+bounces-802-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6CB9D9A82
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Nov 2024 16:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 679C9B21700
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Nov 2024 15:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02AF1D63E2;
	Tue, 26 Nov 2024 15:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="otySuYr0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HdnzXvoP";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="otySuYr0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HdnzXvoP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B5C1CD219;
	Tue, 26 Nov 2024 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732635551; cv=none; b=mbcnVv4h5D8ptaoopXHmJwziPOB9/Kp4UtK3Up+HlbHOHMDoQEMxOPuDBZ6ecQ3k6ZoPqKrAaKcG/3fznM+9bN+wfxTgEW7psWjW6nyU8R+bqBEVUqR+/AiRMn/vGHtpBgN/Y3iWtMqcDEtRHqExU1PtATL6rMFNJpa5vtndk9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732635551; c=relaxed/simple;
	bh=QSuLfzieJyxHmLpdpnck/AUeIFMZ4v6AVU8TSsTHAhw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EF57KkOiC395cDyEufCpoIviyhJ/SUSEWElHPLMtoFoZd6r7Eu9Efe6YUxBjSUWOSaNur3/KWVnoRLVnIMK3KAfoL99eeTHKFIHaBI8fnwnoIo1iOnlZTvivQoHiTMgWdaSDmhOMuLhM57X2OeFcagf9dY5CSO27E7XLZj8dzrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=otySuYr0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HdnzXvoP; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=otySuYr0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HdnzXvoP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4A4861F74C;
	Tue, 26 Nov 2024 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732635548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QSuLfzieJyxHmLpdpnck/AUeIFMZ4v6AVU8TSsTHAhw=;
	b=otySuYr0A8ktry9wWYUPoQyyi/KqsDtMBDeZq1t1t9+USfCtigQyi7dFW2n6cELSN6CcDu
	ZttZGEtFuzOgtqIakqIqXFRkM1BImR9PhMQyvMvSPK4JuUBJ8bpvLjpb3aDUw3liTit4Ae
	H4u74ISnwY1/DOX9AXjRYeu4dnpOF8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732635548;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QSuLfzieJyxHmLpdpnck/AUeIFMZ4v6AVU8TSsTHAhw=;
	b=HdnzXvoPXUmGjiXEMram6r9II66DqANjyD0b7uJUhKawl8AjdXYu1hBtRsm7T83MLbCQxr
	6/jS63/pKovK4nAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1732635548; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QSuLfzieJyxHmLpdpnck/AUeIFMZ4v6AVU8TSsTHAhw=;
	b=otySuYr0A8ktry9wWYUPoQyyi/KqsDtMBDeZq1t1t9+USfCtigQyi7dFW2n6cELSN6CcDu
	ZttZGEtFuzOgtqIakqIqXFRkM1BImR9PhMQyvMvSPK4JuUBJ8bpvLjpb3aDUw3liTit4Ae
	H4u74ISnwY1/DOX9AXjRYeu4dnpOF8Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1732635548;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QSuLfzieJyxHmLpdpnck/AUeIFMZ4v6AVU8TSsTHAhw=;
	b=HdnzXvoPXUmGjiXEMram6r9II66DqANjyD0b7uJUhKawl8AjdXYu1hBtRsm7T83MLbCQxr
	6/jS63/pKovK4nAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8635B13890;
	Tue, 26 Nov 2024 15:39:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nNrfBZrrRWc+EQAAD6G6ig
	(envelope-from <colyli@suse.de>); Tue, 26 Nov 2024 15:39:06 +0000
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
In-Reply-To: <CAAsfc_oTmE2E8pMctiLSwMngVUbtJa4G=KAozzAfztMMc_RMOQ@mail.gmail.com>
Date: Tue, 26 Nov 2024 23:38:52 +0800
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0CFF2B9E-4E40-480D-9F3B-F7631FE3CEA5@suse.de>
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
 <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de>
 <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
 <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de>
 <CAAsfc_oTmE2E8pMctiLSwMngVUbtJa4G=KAozzAfztMMc_RMOQ@mail.gmail.com>
To: liequan che <liequanche@gmail.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Level: 



> 2024=E5=B9=B411=E6=9C=8819=E6=97=A5 12:19=EF=BC=8Cliequan che =
<liequanche@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20

[snipped]

>>> 7. Repartition again, triggering kernel panic again.
>>> parted -s --align optimal /dev/nvme2n1 mkpart primary 2048s 1536GiB
>>> The same operation was performed on the other two servers, and no
>>> panic was triggered.
>=20
>> I guess this is another undefine operation. I assume the cache device =
is still references somewhere. A reboot should follow the wipefs.
> Your guess is correct. In addition, after erasing the superblock
> information in CD rescue mode,
> I rebooted into the system where the original panic kernel was =
located.
>=20

Please try latest upstream kernel and try whether you can see the issue.

c->root is allocated by __bch_btree_node_alloc(), it doesn=E2=80=99t =
return NULL pointer.=20

Your kernel is 5.10 based distribution kernel, I am not able to help =
much here. If you may reproduce the oops in latest upstream kernel, it =
will be a surprise and please let me know.



>>> The server with the problem was able to enter the system normally
>>> after the root of the cache_set structure was determined to be =
empty.
>>> I updated the description of the problem in the link below.
>=20
>> No, if you clean up the partition, no cache device will exist. Cache =
registration won=E2=80=99t treat it as a bcache device.
>=20
>> OK, from the above description, I see you replace the backing device =
(and I don=E2=80=99t know where the previous data was), then you extend =
the cache device size. They are all unsupported operations.
> The behavior here is a bit strange. After partitioning, I may have
> recreated the bcache device here,
> which triggered the bcache rigister operation. Then the kernel =
panicked again.

When you mention your operations, it is better to provide exact detailed =
command lines, otherwise maybe I will misunderstand you.

After all, please try the latest upstream kernel. Not the distro kernel. =
Otherwise I am not able to help.

Coly Li



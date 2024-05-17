Return-Path: <linux-bcache+bounces-464-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0608C89AA
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 17:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCD151C225C0
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2024 15:57:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C32A12F58E;
	Fri, 17 May 2024 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qE7YwsSt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t3fEOTH8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qE7YwsSt";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="t3fEOTH8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0906212F589
	for <linux-bcache@vger.kernel.org>; Fri, 17 May 2024 15:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715961458; cv=none; b=G2CcANJa4qOKbI6Fi4kBbesoStJgB4PmGE92ChAi3f3cYL7ixzs3Vz0geI62OymAabr2JNkG5zeaxN4laj4k0aMTRLoLjNBPGghcaC3Eh/3ELemPuqnNveWcoZpzUbhuiFqAxL44560Co2iw5okRTxw3PWPz/CZkiK+dsiUm0wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715961458; c=relaxed/simple;
	bh=EBLNc/tfrgAw5Mr6+fdht47juiwdctByXBk2Uu/Xvzo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pFakkCiXKP4hpjuX4ZUaW+MnAHziBxeXOHpy5WThQ1OxfqAHKsinleGuWoPL91G04GVB8ebOkdHBHE2NL0fBQ0F7JqSLW6wA1riT1AMt2xaXhKSQZ37wE/t03b4tNhUgVPQG/PsW7AzoqZYSTYACsbg7EwFhEarUK5fh1tiWzCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qE7YwsSt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t3fEOTH8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qE7YwsSt; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=t3fEOTH8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 810F95D546;
	Fri, 17 May 2024 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715961448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Viyi8Zm2j8oJ+w7IRhkLWn89X6zgDwQS1/F6UcBpF/g=;
	b=qE7YwsSt/jAfmGPXgl4GrY9vZEM22a/8fv/uRQKdaLmyVpaCM11+6HAdXtuvwLXqv5OkiK
	Tg48FlV/GObo7dRPwVuH1mBKx4ybtyuuZr+RULpiqi2AyUoxc2WHWcpfgoiiACKCBqqDsa
	4P9Z0gfI6ibsALII0Gh6e9aDHgJeuno=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715961448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Viyi8Zm2j8oJ+w7IRhkLWn89X6zgDwQS1/F6UcBpF/g=;
	b=t3fEOTH8H+/YTjCYp1q7UC7mHyb6t/cRi4s5CUKXbqUSG6V40iGqszgbaZVEFzEwlrFy9D
	9ValqU5fhKuAogCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1715961448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Viyi8Zm2j8oJ+w7IRhkLWn89X6zgDwQS1/F6UcBpF/g=;
	b=qE7YwsSt/jAfmGPXgl4GrY9vZEM22a/8fv/uRQKdaLmyVpaCM11+6HAdXtuvwLXqv5OkiK
	Tg48FlV/GObo7dRPwVuH1mBKx4ybtyuuZr+RULpiqi2AyUoxc2WHWcpfgoiiACKCBqqDsa
	4P9Z0gfI6ibsALII0Gh6e9aDHgJeuno=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1715961448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Viyi8Zm2j8oJ+w7IRhkLWn89X6zgDwQS1/F6UcBpF/g=;
	b=t3fEOTH8H+/YTjCYp1q7UC7mHyb6t/cRi4s5CUKXbqUSG6V40iGqszgbaZVEFzEwlrFy9D
	9ValqU5fhKuAogCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DCDD13991;
	Fri, 17 May 2024 15:57:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Esk9MGR+R2bwHQAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 17 May 2024 15:57:24 +0000
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
In-Reply-To: <ad9d8aa-a6f2-1ec6-1e64-e848c55fd33@ewheeler.net>
Date: Fri, 17 May 2024 23:57:07 +0800
Cc: "Pierre Juhen (IMAP)" <pierre.juhen@orange.fr>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8BFD4A3C-1F0A-4693-B6CA-4D560FDB4125@suse.de>
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
 <FCB4406D-192D-46A1-BB6D-2153B527ED87@suse.de>
 <ad9d8aa-a6f2-1ec6-1e64-e848c55fd33@ewheeler.net>
To: Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Flag: NO
X-Spam-Score: -3.77
X-Spam-Level: 
X-Spamd-Result: default: False [-3.77 / 50.00];
	BAYES_HAM(-2.98)[99.91%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.977];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[orange.fr];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[orange.fr,vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]



> 2024=E5=B9=B45=E6=9C=8817=E6=97=A5 08:34=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, 13 May 2024, Coly Li wrote:
>=20
>>=20
>>=20
>>> 2024=E5=B9=B45=E6=9C=8812=E6=97=A5 17:41=EF=BC=8CPierre Juhen (IMAP) =
<pierre.juhen@orange.fr> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hi,
>>>=20
>>> I use bcache on an nvme partition as frontend and md array ass =
backend.
>>>=20
>>> I have the following error since I updated to kernel 6.8.9.
>>>=20
>>> UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1098:3
>>> [    7.138127] index 4 is out of range for type 'btree_iter_set [4]'
> ...
>>=20
>> The fix is in linux-next and will be in 6.10 as expecting.
>=20
> Thank you Coly!
>=20
> Two questions:
>=20
> - What is the commit hash for this fix?=20

It is commit 3a861560ccb3 (=E2=80=9C bcache: fix variable length array =
abuse in btree_iter=E2=80=9D) from Linus tree.

>=20
> - Does it need to be backported to older kernels?
>=20

This is a patch to moving warning, the original code works fine. IMHO it =
is not mandatory to backport to elder kernels, but good to have if UBSAN =
also complains in that kernel version.

Thanks.

Coly Li




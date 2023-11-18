Return-Path: <linux-bcache+bounces-6-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E817F0148
	for <lists+linux-bcache@lfdr.de>; Sat, 18 Nov 2023 18:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63F99B20988
	for <lists+linux-bcache@lfdr.de>; Sat, 18 Nov 2023 17:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191DD18C3B;
	Sat, 18 Nov 2023 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Wwod6iFg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CmOBsO6n"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A46A0;
	Sat, 18 Nov 2023 09:20:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 904F71F37C;
	Sat, 18 Nov 2023 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700328036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46ia7DRlB/IH6qcR1sQCmNVQI/gY2ouMnWRwtUSreIQ=;
	b=Wwod6iFgcElg0ih/AqP21gh/Yi73DyT/8fa9P5MTi8SQLvZZOeh2Why2HT1VKbvb1ivqKg
	Xx4ilzpVr8l5sovhnHfxP9EA76slz5S8G3KUHcHIPczFbjpTo7xJg8/naNkEFvMRx4vwsK
	Tx/H8AXcwa0R5/Va/3mBL14U8Lc9L/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700328036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=46ia7DRlB/IH6qcR1sQCmNVQI/gY2ouMnWRwtUSreIQ=;
	b=CmOBsO6nCOgGXfmGARYeRJLiuydOq+btwAwDdEnXmD5XU3p3j9Dr9JzAomXPM+wMpUCJGu
	32dYOQSIqXslv6Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 403721348D;
	Sat, 18 Nov 2023 17:20:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id iIKMO2LyWGUiLwAAMHmgww
	(envelope-from <colyli@suse.de>); Sat, 18 Nov 2023 17:20:34 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH 0/2] Two small closures patches
From: Coly Li <colyli@suse.de>
In-Reply-To: <79FE1457-FC6D-46A9-A7F9-55ADCCBE42DF@suse.de>
Date: Sun, 19 Nov 2023 01:20:22 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DD7F284F-7133-46A1-A866-31E17604314F@suse.de>
References: <20231031162454.3761482-1-kent.overstreet@linux.dev>
 <79FE1457-FC6D-46A9-A7F9-55ADCCBE42DF@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3774.200.91.1.1)
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.28
X-Spamd-Result: default: False [-3.28 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-2.48)[97.65%];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 TO_DN_SOME(0.00)[];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]



> 2023=E5=B9=B411=E6=9C=8819=E6=97=A5 00:43=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
>> 2023=E5=B9=B411=E6=9C=881=E6=97=A5 00:24=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> I'll be sending these to Linus in my next pull request, sending them =
to
>> linux-bcache so Coly gets a chance to see them.
>>=20
>> Kent Overstreet (2):
>> closures: Better memory barriers
>> closures: Fix race in closure_sync()
>>=20
>> fs/bcachefs/fs-io-direct.c |  1 +
>> include/linux/closure.h    | 12 +++++++++---
>> lib/closure.c              |  9 +++++++--
>> 3 files changed, 17 insertions(+), 5 deletions(-)
>=20
> The whole series got tested with current bcache code, it works fine.
>=20
> Acked-by: Coly Li <colyli@suse.de <mailto:colyli@suse.de>>

The above line was automatically modified by the MacOS Mail client, =
sigh=E2=80=A6
Please use the following line,

Acked-by: Coly Li <colyli@suse.de>


Thanks.

Coly Li



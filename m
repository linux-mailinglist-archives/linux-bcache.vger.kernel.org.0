Return-Path: <linux-bcache+bounces-492-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CA78D09CD
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 20:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53B361C21E9C
	for <lists+linux-bcache@lfdr.de>; Mon, 27 May 2024 18:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB5915F3F4;
	Mon, 27 May 2024 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ggn65k7q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7HES59ZB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ggn65k7q";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7HES59ZB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338CB15FA62
	for <linux-bcache@vger.kernel.org>; Mon, 27 May 2024 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716833682; cv=none; b=Ep89DQarSoyxjfPaehVLX4V0DgZtS7uoHo2bGYGCyNDjALC+U6WVLHepv3tcnb213SrvfudnTrEj2+NO+Any2v3IJ3F8/gP0l31onqEtg3U3r0zhTfvwdYAQgQTQUVVKnIubL4+KPU+z98nqlPId9ir1y9WDZf0+HNmJfKMKWMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716833682; c=relaxed/simple;
	bh=6os5b4+wpPG7z2vpxrqTrlBd0vtc5mUfpd+bhblZ4kA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Uw6+hg+1klPVRobUZbZsiQQkuHi1zGYBKwBCGKK7R1RQ2ee5RnLj4/uJclqfXyIdbBTj1Gnn+WEw+c7Ts1DaX4zrufQh3SOaeqF8kZMt5z20OaLpqF6ql4cY+KFswb3In3+dQxThQVwMEzyyn075rdVJLWJKIcmV2Bp4ymOnmQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ggn65k7q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7HES59ZB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ggn65k7q; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7HES59ZB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 47B7E220CF;
	Mon, 27 May 2024 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716833678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lqpnIg5p062ul2SyE0CngAwCvrjKCXCg2STSA2u/1sM=;
	b=Ggn65k7q+abTr46o4BZ37312koqRokH3ILaFBT4dxiCKvcA8tsaReu50yaX3b8l+DfcTUy
	bzUIQbfvrDpPOlvOq9jhJFcvMNjWbw55WOOSc2+dOtdLQtyWrMo1k4iZLXd6mDneFgiMyd
	BfXDCt+S4CUYTbf2BteqoESc35znhP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716833678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lqpnIg5p062ul2SyE0CngAwCvrjKCXCg2STSA2u/1sM=;
	b=7HES59ZBR/RF86yfI9lHSJaLRUgq2SP1EzGsRbUOcBbdSIOau93sHh6QH6vkHyY7Lj5KEE
	hviWrzlSEPu3UkBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716833678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lqpnIg5p062ul2SyE0CngAwCvrjKCXCg2STSA2u/1sM=;
	b=Ggn65k7q+abTr46o4BZ37312koqRokH3ILaFBT4dxiCKvcA8tsaReu50yaX3b8l+DfcTUy
	bzUIQbfvrDpPOlvOq9jhJFcvMNjWbw55WOOSc2+dOtdLQtyWrMo1k4iZLXd6mDneFgiMyd
	BfXDCt+S4CUYTbf2BteqoESc35znhP8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716833678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lqpnIg5p062ul2SyE0CngAwCvrjKCXCg2STSA2u/1sM=;
	b=7HES59ZBR/RF86yfI9lHSJaLRUgq2SP1EzGsRbUOcBbdSIOau93sHh6QH6vkHyY7Lj5KEE
	hviWrzlSEPu3UkBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C589513A88;
	Mon, 27 May 2024 18:14:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B4vkGovNVGZvGgAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 27 May 2024 18:14:35 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAJhEC07Pdea5XKyMLVw=GeBZksNWoWpCmHs7shBPcgW3OoDonw@mail.gmail.com>
Date: Tue, 28 May 2024 02:14:06 +0800
Cc: Eric Wheeler <bcache@lists.ewheeler.net>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F310CA03-432E-4C8A-8054-EAF1BA5E8F12@suse.de>
References: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
 <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
 <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
 <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de>
 <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
 <xbm4drbn7hdxedptocnc77m53kce3jdaedsvxh7dcwts7yivjx@jbvhh43wd3tp>
 <9c197420-2c46-222a-6176-8a3ecae1d01d@ewheeler.net>
 <3E11DC5E-92D1-43FF-8948-B99F665E445D@suse.de>
 <CAJhEC07Pdea5XKyMLVw=GeBZksNWoWpCmHs7shBPcgW3OoDonw@mail.gmail.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3774.600.62)
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO



> 2024=E5=B9=B45=E6=9C=8824=E6=97=A5 15:14=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> I hope this email finds you well.
>=20
> I wanted to express my appreciation for your work.  I was curious if
> you've had a chance to submit the patch yet? If so, would you mind
> sharing the link to the Git commit?
>=20

The fix from me is posted on linux-bcache mailing list just a moment =
ago.


> The reason I ask is that some downstream Linux distributions are eager
> to incorporate this fix into their upcoming releases once it lands.

Can I know which Linux distributions are waiting for this? Just wonder =
and want to know more Linux distribution officially bcache.

> Any information you can provide would be greatly helpful in
> coordinating those efforts.


The test and code review from my side are done. It is in my for-next =
branch,  I will submit them to upstream soon if no complain from kernel =
test robot.

Thanks.

Coly Li






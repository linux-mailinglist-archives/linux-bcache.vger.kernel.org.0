Return-Path: <linux-bcache+bounces-505-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D754B8D3C35
	for <lists+linux-bcache@lfdr.de>; Wed, 29 May 2024 18:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 495B51F22022
	for <lists+linux-bcache@lfdr.de>; Wed, 29 May 2024 16:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3EB71836DA;
	Wed, 29 May 2024 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jmn45z6C";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S7iupIVE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jmn45z6C";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S7iupIVE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC471836DF
	for <linux-bcache@vger.kernel.org>; Wed, 29 May 2024 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716999898; cv=none; b=JJG89yM/o0OBkkTr19cwPhq3K1nzBfIDKNV6XoHm6/orBTo/ZDvEI2ySmlDaC24URfhfVLViKh0UEvkuPIFq4j/gfxToomEJNjSNP5bzfzwUf1Gn0m3pTFzauCBClokb59qmbt9rkKyjx15uhoB8JAmn5R6PlOpiGDYkk/G4dNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716999898; c=relaxed/simple;
	bh=jDr2DBq7hBiQM6iz6BkUjAfcEO4cOqh5ULWKEOOMp9U=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=U/zvf5BlOs3kpVvSB7ASSY7XPQVo/nQcU6B/t8oSo4b42RBMpiKLySGEtnm1TTOml3bxR1rQXAnxkPNeUATrqEm/d+XP3vEly/MtU48tp4sIYppLc05r64IoJnay8ruUsajlM+f8KoeOWdPtaTbI6gzHYdmvaNCBh1OvO4pKVfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jmn45z6C; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S7iupIVE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jmn45z6C; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S7iupIVE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 38B00336E3;
	Wed, 29 May 2024 16:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716999895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izuiKU3YJpo+Z2DIpQwGrtKiI38kWEoBRn50S3cU6VQ=;
	b=jmn45z6CkVSb60sqzY2qef3OOKpWCyJkTEVRmMOuGG3Rk8eE0hSC+kWzRMwCW4SGB2/wXl
	ioTkc92RdcQ4xN7PgRa64zr49yMPZC87BtGlcLVi/FgYAk4du0DrDZlXO7veiBIBkamHUT
	XizGNZFjw1pT96VjTqnOIHthziIUXHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716999895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izuiKU3YJpo+Z2DIpQwGrtKiI38kWEoBRn50S3cU6VQ=;
	b=S7iupIVE/EEbaZW2pM5DfaagtWY4AK94BQuTsaWD/AOZ1TD1DfIOURTvrOguiIDy7UlVSh
	z4+gcEiSzv/8bFBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716999895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izuiKU3YJpo+Z2DIpQwGrtKiI38kWEoBRn50S3cU6VQ=;
	b=jmn45z6CkVSb60sqzY2qef3OOKpWCyJkTEVRmMOuGG3Rk8eE0hSC+kWzRMwCW4SGB2/wXl
	ioTkc92RdcQ4xN7PgRa64zr49yMPZC87BtGlcLVi/FgYAk4du0DrDZlXO7veiBIBkamHUT
	XizGNZFjw1pT96VjTqnOIHthziIUXHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716999895;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=izuiKU3YJpo+Z2DIpQwGrtKiI38kWEoBRn50S3cU6VQ=;
	b=S7iupIVE/EEbaZW2pM5DfaagtWY4AK94BQuTsaWD/AOZ1TD1DfIOURTvrOguiIDy7UlVSh
	z4+gcEiSzv/8bFBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D4E31372E;
	Wed, 29 May 2024 16:24:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ACikKdRWV2bRBgAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 29 May 2024 16:24:52 +0000
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
In-Reply-To: <CAJhEC06ro134BKQ_41TLpbsQNE+WwiMpoxrSc3UpA3CF1VX_Fw@mail.gmail.com>
Date: Thu, 30 May 2024 00:24:37 +0800
Cc: Eric Wheeler <bcache@lists.ewheeler.net>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <355ABD73-04C8-45AF-9F8D-D912DABCA716@suse.de>
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
 <F310CA03-432E-4C8A-8054-EAF1BA5E8F12@suse.de>
 <CAJhEC06ro134BKQ_41TLpbsQNE+WwiMpoxrSc3UpA3CF1VX_Fw@mail.gmail.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3774.600.62)
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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



> 2024=E5=B9=B45=E6=9C=8828=E6=97=A5 13:50=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, May 27, 2024 at 11:14=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
>>=20
>>> 2024=E5=B9=B45=E6=9C=8824=E6=97=A5 15:14=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hi Coly,
>>>=20
>>> I hope this email finds you well.
>>>=20
>>> I wanted to express my appreciation for your work.  I was curious if
>>> you've had a chance to submit the patch yet? If so, would you mind
>>> sharing the link to the Git commit?
>>>=20
>>=20
>> The fix from me is posted on linux-bcache mailing list just a moment =
ago.
>=20
> Thank you for that fix also. Appreciate your diligence in resolving
> this stuck bypass.
>=20
>>> The reason I ask is that some downstream Linux distributions are =
eager
>>> to incorporate this fix into their upcoming releases once it lands.
>>=20
>> Can I know which Linux distributions are waiting for this? Just =
wonder and want to know more Linux distribution officially bcache.
>=20
> It is the Container-Optimized OS.
>=20
> =
https://cloud.google.com/container-optimized-os/docs/legacy-release-notes#=
gci-dev-54-8711-0-0
>=20
>>> Any information you can provide would be greatly helpful in
>>> coordinating those efforts.
>>=20
>>=20
>> The test and code review from my side are done. It is in my for-next =
branch,  I will submit them to upstream soon if no complain from kernel =
test robot.
>=20
> Great to hear that. Any estimate when the test will finish and the
> patch can submit?


It is in linux-block already, will be in next -rc quite soon as =
expecting.

Thanks.

Coly Li



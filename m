Return-Path: <linux-bcache+bounces-363-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 872CC891F36
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Mar 2024 16:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FF69285CCF
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Mar 2024 15:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37012130A5C;
	Fri, 29 Mar 2024 13:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="uLjn9sn5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fZarekEl"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842C8130493
	for <linux-bcache@vger.kernel.org>; Fri, 29 Mar 2024 13:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711717236; cv=none; b=n6siprQn3o35FzgacQiCZe4epLLaDm0+ahAwXQNPniLPZ9bU/jg/xIi+a0pJuCe+0Cyyg0+FbrVcoRefTY+MK37wAEr3Mobom5py0jn6T31bj+K8gF+MuD1iRUT3WzTLfPm8UvJ/6MTAdzxF/KqiNgS6s0olghr2KuThkIvxx4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711717236; c=relaxed/simple;
	bh=x41OazEfNl9pqrTOhM1BwSxvXNTuHIirTXUvN+3VaXk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YV/jUI75r2KDZkclpkH6C5c3DxRHcFsnuS9GeqV49iLvM0CtwwtHDaeXwHH7dZHnpxhLWv8HQnUVbOp+zru6UZXuCR97hhEVNcGAQrYZS/eldbMMuV0la+l9+xUf3Dqx4SzJFpmzGr0W95r/Qze3iME+2pWuwkkyEjicod3/ShM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=uLjn9sn5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=fZarekEl; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3E50034B61;
	Fri, 29 Mar 2024 13:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711717227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x41OazEfNl9pqrTOhM1BwSxvXNTuHIirTXUvN+3VaXk=;
	b=uLjn9sn56fbFEqks6/ByJ3zhLRAyLURbA618G7ytWTnzCTGCEGNn5L73Q7VflPSqv0secp
	QUKLCF7WdgZHG4eMZUZzsik6PCitzMR0DqY4RxpPc6rtochyrR6Zy+UuZ30FGm5Rb/0vV5
	vukUJ3+znNstkFwcR20Am+ffSHWlFn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711717227;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x41OazEfNl9pqrTOhM1BwSxvXNTuHIirTXUvN+3VaXk=;
	b=fZarekEl90RwiC5zl0wirZ8nXZADWy1jo8sKT6e34uedQojJ5Sj74E3YPFQP5t28oRG9bU
	nXmpbyC9DgM69YCA==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 04D2913A89;
	Fri, 29 Mar 2024 13:00:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 2jmvKmm7BmZWSQAAn2gu4w
	(envelope-from <colyli@suse.de>); Fri, 29 Mar 2024 13:00:25 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
Date: Fri, 29 Mar 2024 21:00:12 +0800
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>,
 Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
 <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
 <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
 <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3774.400.31)
X-Spam-Score: -1.18
X-Spamd-Result: default: False [-1.18 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 MV_CASE(0.50)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 TO_DN_ALL(0.00)[];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.38)[77.27%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO



> 2024=E5=B9=B43=E6=9C=8829=E6=97=A5 02:05=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi bcache developers
>=20
> Greetings. Any update on this patch? How are things going with the
> testing and submission upstream?

Hi Peng,

As I said, it will be in next merge window, not this one. If there is =
help necessary, I will ask :-)

Thanks.

Coly Li


>=20
>=20
> On Sun, Mar 17, 2024 at 11:16=E2=80=AFPM Robert Pang =
<robertpang@google.com> wrote:
>>=20
>> Hi Coly
>>=20
>> Thank you for confirming. It looks like the 6.9 merge window just
>> opened last week so we hope it can catch it. Please update in this
>> thread when it gets submitted.
>>=20
>> =
https://lore.kernel.org/lkml/CAHk-=3Dwiehc0DfPtL6fC2=3DbFuyzkTnuiuYSQrr6JT=
QxQao6pq1Q@mail.gmail.com/T/
>>=20
>> BTW, speaking of testing, mind if you point us to the bcache test
>> suite? We would like to have a look and maybe give it a try also.
>>=20
>> Thanks
>> Robert
>>=20
>> On Sun, Mar 17, 2024 at 7:00=E2=80=AFAM Coly Li <colyli@suse.de> =
wrote:
>>>=20
>>>=20
>>>=20
>>>> 2024=E5=B9=B43=E6=9C=8817=E6=97=A5 13:41=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> Hi Coly
>>>>=20
>>>=20
>>> Hi Robert,
>>>=20
>>>> Thank you for looking into this issue.
>>>>=20
>>>> We tested this patch in 5 machines with local SSD size ranging from
>>>> 375 GB to 9 TB, and ran tests for 10 to 12 hours each. We observed =
no
>>>> stall nor other issues. Performance was comparable before and after
>>>> the patch. Hope this info will be helpful.
>>>=20
>>> Thanks for the information.
>>>=20
>>> Also I was told this patch has been deployed and shipped for 1+ year =
in easystack products, works well.
>>>=20
>>> The above information makes me feel confident for this patch. I will =
submit it in next merge window if some ultra testing loop passes.
>>>=20
>>> Coly Li
>>>=20
>=20

[snipped]



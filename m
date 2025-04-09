Return-Path: <linux-bcache+bounces-861-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 325FDA81B74
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Apr 2025 05:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 174BB4A4E35
	for <lists+linux-bcache@lfdr.de>; Wed,  9 Apr 2025 03:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890B217CA17;
	Wed,  9 Apr 2025 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="KfVqEcH0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail50.out.titan.email (mail50.out.titan.email [44.199.128.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FEB157E6B
	for <linux-bcache@vger.kernel.org>; Wed,  9 Apr 2025 03:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.199.128.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744169582; cv=none; b=g3kRP6Oi20Hr6tucI4ZVXVGORstViWFqCkHujpuqtkEsI1aC5gsSUwPYugijfYy6UHHxgsjpvzsn6cLhrxNG3pwcTmPhCaPMNZ3JmR6SIC1PVO1OzF1RynyISDUIJueOt/5QO33BNVmPPa108dHqi3P9ZfyJLQVgGZDfRhF0F6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744169582; c=relaxed/simple;
	bh=Pb9rPAKTcXtfDMYNkf/J8fDNAG1WHDuKpMtpY/FBRmk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LeY8xcH2rEvqTRyzN3pT27jT+WVgA4vCty48gyV61emMncm+4TvFGxblHF1ProxwAhNdf9qAgIo4cQ6b8bBpsAo4LaTp1dLXX0ShIZkm1A6HL/XLHVbqqLBgSVsLQMo4FJqeSrzAyzc/c2uxIpT6cLE+rqLgL4tWjN0IqDH8/4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=KfVqEcH0; arc=none smtp.client-ip=44.199.128.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 3827FE0395;
	Wed,  9 Apr 2025 03:27:25 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=FGoG8tMY82U3r2D91yEEnczPBCPlPVey2FvwnJKvLbk=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=subject:mime-version:in-reply-to:message-id:references:from:to:date:cc:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1744169245; v=1;
	b=KfVqEcH0FdQygEm2Se8GHTaX6005NaxEtaaa2xhCZBZUDkxF+XuhTJbfXhHKUEy+4578aUOJ
	VXFvIN5GWoLD69uLNRVBaXzWwOXHvnDA504hZZqjxaRRuYggpSAfPEdr/9QRyWdBItQwlIkNRRT
	+OQt9NievNdIBrF5gaurf2/4=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 31277E0146;
	Wed,  9 Apr 2025 03:27:22 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH] bcache: fix NULL pointer in cache_set_flush()
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
X-Priority: 3
In-Reply-To: <ALcAnACYLj4w0H9xEeuAy4ox.3.1744162924028.Hmail.mingzhe.zou@easystack.cn>
Date: Wed, 9 Apr 2025 11:27:10 +0800
Cc: Coly Li <colyli@kernel.org>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 "dongsheng.yang" <dongsheng.yang@easystack.cn>,
 zoumingzhe <zoumingzhe@qq.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8AB585A2-22F0-4D2F-BCB3-864A96C54208@coly.li>
References: <20250407125625.270827-1-mingzhe.zou@easystack.cn>
 <wboosa77dyqt2sybdg4re7blmh56j2tkpcndydbztakdsxzobp@a7a2ur2wq73y>
 <ALcAnACYLj4w0H9xEeuAy4ox.3.1744162924028.Hmail.mingzhe.zou@easystack.cn>
To: =?utf-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1744169245072398435.26132.6602430907154786044@prod-use1-smtp-out1004.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=RvE/LDmK c=1 sm=1 tr=0 ts=67f5e91d
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=P4lzD79S6dXEZkmX6fUA:9
	a=QEXdDO2ut3YA:10



> 2025=E5=B9=B44=E6=9C=889=E6=97=A5 09:42=EF=BC=8C=E9=82=B9=E6=98=8E=E5=93=
=B2 <mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> &gt;Nice catch!  Thanks for the fix up!
>=20
> &gt;There are two suggestions from me,
>=20
> Hi, Coly Li
>=20
> &gt;1) the above code example is from 4.18 kernel I guess, could you =
please
> &gt;   update the commit log against latest upstream kernel code?
>=20
> Firstly, this is a fairly (about 4-5 years ago) old patch. Now, we =
have
> rebased to the 6.6 kernel. We have no more crashes, so we are unable =
to
> obtain the latest message logs.

OK, then forget this suggestion, I will refine the commit log.


>=20
> &gt;2) Could you please add code commet here to explain why ca is =
checked
> &gt;   here? Let other people to know that in registration failure =
code
> &gt;   path, ca might be NULL. Such information could be quite helpful =
for
> &gt;   others to understand the code.
>=20
> This is a good idea. I am currently dealing with other issues and will
> send the v2 version later.

Thanks.

Coly Li=


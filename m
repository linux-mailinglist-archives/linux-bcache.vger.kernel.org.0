Return-Path: <linux-bcache+bounces-1222-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5B0BF43CA
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Oct 2025 03:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C05144E83DC
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Oct 2025 01:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B154915E5DC;
	Tue, 21 Oct 2025 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="uteYp9Qr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906DF625
	for <linux-bcache@vger.kernel.org>; Tue, 21 Oct 2025 01:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761009508; cv=none; b=EfJcQhdItUCfL1DD78AAQ5TpMKsVQQwoXs2jxIPSiaP5wapKWxv3SBjFZxOlo2l3PLG66or/stAaHl8/bM5IU1KmDFmmbWaE0w0OtTItHedFQRiwFTyBqdwXSVcokmPVpJ3uZ8U/UuV5P/cIBuF2JxDZI7m56cSOwEG5M/B/L7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761009508; c=relaxed/simple;
	bh=pxm7whG1+Mu8dx1jaNuDM8I5Nx93c6dimteOfoPScAs=;
	h=Cc:From:Date:Mime-Version:Message-Id:Content-Type:In-Reply-To:To:
	 Subject:References; b=oIMjfv229dwpMyYBvijH2ztn6h6Eeai7zHZqN+Egg/g7Q1dnI/CcNYz+RPL4SWUXcjQjRAVLzj2gIXJX5FX2iUR3c6Clxco4clzTKm7w/z45o6es1cZ4Qiugqzd3aZVvhAPtEXaNHI/SzMBsNjG85YWf1OkvomWhgI22SlJu3K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=uteYp9Qr; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761009498;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=pxm7whG1+Mu8dx1jaNuDM8I5Nx93c6dimteOfoPScAs=;
 b=uteYp9QraSwwnos7FQQu9dtxRRxw8OLxcWtGgOyXCdzF1tTw1YMEZ3PZF7LwoVYiPEIOYq
 qgjJ6ncXEzYWn/7iiWTfvGFa8ItYE30dP/ZtuIvFMAUrNWb2pEE+sNcR+51YGHy1Jdqi4n
 2ZXbZYmRnV7zWaFBe4dHyo7IQ+8E6t83YulkNS6EizZAvvPSD0f5K8nrPvvXF1pTGko7zf
 QVWh/oxta7BoTYBEqTkvnHR8HgQ2isemL3nnRdlvbjwOlG7YTYaSE6lv4/YwQ4vavbr3pP
 B74b5LW+IY51ap1HdtE0cjlsfVl/F8SrqcDKD9RAQxqg1c2x1qPw7YScdKdOhg==
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Lms-Return-Path: <lba+268f6df58+110616+vger.kernel.org+colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Cc: <linux-bcache@vger.kernel.org>
From: "Coly Li" <colyli@fnnas.com>
Date: Tue, 21 Oct 2025 09:18:04 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <745B055F-0934-4D2A-9717-DFE34300457E@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <050fe436-e629-4428-8e4d-33edd8985767@orange.fr>
Content-Transfer-Encoding: quoted-printable
To: "Pierre Juhen" <pierre.juhen@orange.fr>
Subject: Re: [PATCH] bcache: avoid redundant access RB tree in read_dirty
Received: from smtpclient.apple ([120.245.65.31]) by smtp.feishu.cn with ESMTPS; Tue, 21 Oct 2025 09:18:15 +0800
References: <20251007090232.30386-1-colyli@fnnas.com> <050fe436-e629-4428-8e4d-33edd8985767@orange.fr>

> 2025=E5=B9=B410=E6=9C=8821=E6=97=A5 00:39=EF=BC=8CPierre Juhen <pierre.ju=
hen@orange.fr> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi=20
> I am on kernel 6.16.12.
> I have had errors with bcache recently, And I lost my fronted 3 or 4 time=
s :
> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 128: =
bad csum, 32768 bytes, offset 0=20
> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 64: b=
ad csum, 22928 bytes, offset 0=20
> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 32: b=
ad csum, 4848 bytes, offset 2=20
> oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 48: b=
ad csum, 14096 bytes, offset 0=20
> oct. 20 15:37:40 pierre.juhen (udev-worker)[461]: nvme0n1p3: Process 'bca=
che-register /dev/nvme0n1p3' failed with exit code 1.=20
> oct. 20 15:37:40 pierre.juhen kernel: bcache: prio_read() bad csum readin=
g priorities=20
> oct. 20 15:37:40 pierre.juhen kernel: bcache: bch_cache_set_error() error=
 on 448f191c-28df-4396-bc44-14d1f77c9005: IO error reading priorities, disa=
bling caching=20
> oct. 20 15:37:40 pierre.juhen kernel: bcache: register_bcache() error : f=
ailed to register device
>=20

I assume this email is irrelevant to the patch =E2=80=9Cbcache: avoid redun=
dant access RB tree in read_dirty=E2=80=9D, am I correct?


> I had to reconfigure everything after a disk problem.
> I have been running bcache for years now, without any problems.
> The only difference might be that I configured the frontend with the disc=
ard option.

The discard option is not recommended. Indeed in next merge window I will s=
ubmit a patch series to drop the discard option.


> The logical volume using bcache have also a discard option in fstab.
> The frontend is on a Samsung 980 nvme disk.=20

Try not to enable discard on cache device. This option will disappear soon.

I don=E2=80=99t know whether discard option of Samsung 980 nvme disk may ch=
ange the content of discarded LBA or not, from NVMe spec, it could be zero-=
filled or undefined.
Anyway in current code discard doesn=E2=80=99t help performance, I suggest =
to not enable discard and see whether the issue still shows up.

My suggestion is: always use default configuration, all our test case and p=
erformance optimization are for default configurations.

Thanks.

Coly Li


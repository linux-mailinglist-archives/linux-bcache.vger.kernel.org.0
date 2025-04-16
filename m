Return-Path: <linux-bcache+bounces-886-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E779EA8B8F2
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 14:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 778E93BBF21
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 12:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC1824889A;
	Wed, 16 Apr 2025 12:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="A4Xnp9Mg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail66.out.titan.email (mail66.out.titan.email [3.216.99.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2708C2459F8
	for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 12:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744806381; cv=none; b=eWN84eGWYDbkGjscJ09mFPPJCKmUpew5P4Xu7pKXd+ycj8ie83tKa8f8uUq4Wi0Q/LH5+g+hZ5TScQyp9hnIp29bwKAGHFFMj1ANmVxn3I1BKQGsdE/l1j5jan73GJec5gcCc/XyBwjfiXTWxL1RRQgXmqDpsJL6+wgY7o6RyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744806381; c=relaxed/simple;
	bh=ZlLm5E8xrxYt7/tjKWOwX/LGFL3xxvplHR34NZON8wA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=OXvNBsRfcH0LzMB59FRLpU4ycLOU6HuTldy5kMFCyZFXdpERb9ahhhm0Ug382VoEJT0ch/JrSTGYv92AKj+4W7ORFH1dWr89mxt0b5SnkDrFDILGHQNZ/opLUByCxEG4hZrvC7mY3MGEYj2+6sCl1wQMZxG+/DRESy9jxQzvciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=A4Xnp9Mg; arc=none smtp.client-ip=3.216.99.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 1382E600C9;
	Wed, 16 Apr 2025 09:46:25 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=YfxLBf5c0U/p+rueW2MA9gn88rwWf+u4t6Tiw9cgto8=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=mime-version:cc:to:subject:from:date:message-id:in-reply-to:references:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1744796785; v=1;
	b=A4Xnp9MgZ9Kih+vTf/o+BYYjTiwDvm1Vi62BSvEIw3FJQCTrOgXJ9CEakttuh3HG86f5sjum
	xJ2R2gaXfl6tI/xyDOFkvvB+deVdsoSGQNtizufJypGFbHerk5YN1v52C0KldClU/vst7vPl/fg
	sPFPFWJ9382XQb7yscIjiJOQ=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 5D650601BB;
	Wed, 16 Apr 2025 09:46:23 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH] bcache: remove unused constants
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <20250415170002.334278-1-robertpang@google.com>
Date: Wed, 16 Apr 2025 17:46:10 +0800
Cc: Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <18F0FB83-BD38-456E-B822-A13C8EF11DD1@coly.li>
References: <20250415170002.334278-1-robertpang@google.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1744796784940922392.5242.2193316255149991258@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=fZxXy1QF c=1 sm=1 tr=0 ts=67ff7c70
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
	a=ei5mcS5IK7MuZK5A7soA:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B44=E6=9C=8816=E6=97=A5 00:59=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Remove constants MAX_NEED_GC and MAX_SAVE_PRIO in btree.c that have =
been unused
> since initial commit.
>=20
> Signed-off-by: Robert Pang <robertpang@google.com>

Reviewed-by: Coly Li <colyli@kernel.org <mailto:colyli@kernel.org>>

Thanks.


Coly Li



> ---
> drivers/md/bcache/btree.c | 2 --
> 1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index ed40d8600656..f991be2bc44e 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -88,8 +88,6 @@
>  * Test module load/unload
>  */
>=20
> -#define MAX_NEED_GC 64
> -#define MAX_SAVE_PRIO 72
> #define MAX_GC_TIMES 100
> #define MIN_GC_NODES 100
> #define GC_SLEEP_MS 100
> --=20
> 2.49.0.805.g082f7c87e0-goog
>=20
>=20



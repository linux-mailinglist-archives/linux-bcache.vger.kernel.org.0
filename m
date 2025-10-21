Return-Path: <linux-bcache+bounces-1224-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 82A11BF4951
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Oct 2025 06:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 623804E38D2
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Oct 2025 04:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA731246BAA;
	Tue, 21 Oct 2025 04:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="UC8YjA3E"
X-Original-To: linux-bcache@vger.kernel.org
Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B4114A62B
	for <linux-bcache@vger.kernel.org>; Tue, 21 Oct 2025 04:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761019871; cv=none; b=GV77mYgFzxp52npgrV0I0u9CkRiOEyHoJhQEA/iLECOVYOWAforPDo5N58/7yeCtyhZwN9LaODJgHsd59p7diZQpnT0SsIe+iQrfiq/GXJ06ZFPIW8PxelcXWS5tjUH2lkZqUxf7iPyuzhkgFXu5dsF31Es2ds0YgpWDsIaZXxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761019871; c=relaxed/simple;
	bh=f2ft52KfTGCS/OWXo9ok6htonS7k9xbMoI+l4Uu3hlU=;
	h=Cc:Message-Id:Content-Disposition:Content-Type:References:Subject:
	 Date:From:Mime-Version:To:In-Reply-To; b=brZeak3I1jpeJhPOsnz/u+ULarN4KmwDPat9GM4bIdVUWnjdwCobtXfyYY5i5l2Q5Jwz5ug4fLvsH2gs8Pd571iYOW5WZW4Dj1n8bZQ/pBm57iTuX3nmH+Urz9CQB6aLUHAvXKGURdFzd+KaaER/WoeUaRcxsBUcaVqHHWYAWDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=UC8YjA3E; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761019813;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=f2ft52KfTGCS/OWXo9ok6htonS7k9xbMoI+l4Uu3hlU=;
 b=UC8YjA3EGrHlpWwE2YS71vqD5Ii0v2KjER+7lT31snr4iktmk8e/qjEhi501axzkDajPWy
 HnDSe8hlbBI0UUcEy+B6iBnn5lzWY8FK5o5xhE173bAZ7BoFDJ8Z11DBnoO2Tih7xkwPbF
 DBvxSt9E73Pu8PnSd3O9hwJHmDW5x+q6lsbVxRqPepOrsAXil2j+SzjsT/3JB/P1oDhdGk
 Qd/kXNh9lyu4zHEZPXB+i1tZBVRrCLen5JcLAYqkJh/9KdW8lIuWVCuk1EBmxsDuVDrMpp
 gi3Oo7Z35qWj4PSMXJmpP6ZyJ/XHle4HkyLyraNHbx1MBWI3rfSS4bm327fYvg==
X-Lms-Return-Path: <lba+268f707a3+cf2b95+vger.kernel.org+colyli@fnnas.com>
X-Original-From: Coly Li <colyli@fnnas.com>
Cc: <linux-bcache@vger.kernel.org>
Message-Id: <bylrai4kufkldmprnlbuypfftgaah2umvggux2uheu7jjcwzgx@bgcigj3znw4d>
Content-Disposition: inline
Content-Type: text/plain; charset=UTF-8
References: <20251007090232.30386-1-colyli@fnnas.com> <050fe436-e629-4428-8e4d-33edd8985767@orange.fr> <745B055F-0934-4D2A-9717-DFE34300457E@fnnas.com> <c9ce4400-8b0a-430a-a336-32d59be1ee67@orange.fr>
Received: from studio.lan ([120.245.65.31]) by smtp.feishu.cn with ESMTPS; Tue, 21 Oct 2025 12:10:10 +0800
Subject: Re: Discard option
Date: Tue, 21 Oct 2025 12:10:09 +0800
Content-Transfer-Encoding: quoted-printable
From: "Coly Li" <colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Pierre Juhen" <pierre.juhen@orange.fr>
In-Reply-To: <c9ce4400-8b0a-430a-a336-32d59be1ee67@orange.fr>

On Tue, Oct 21, 2025 at 04:58:21AM +0800, Pierre Juhen wrote:
> Hi Coli,
>=20
> I assume this email is irrelevant to the patch =E2=80=9Cbcache: avoid red=
undant access RB tree in read_dirty=E2=80=9D, am I correct?
>=20
> Yes you are;=C2=A0 sorry, I picked a message and forgot to change the tit=
le
>=20
> The discard option is not recommended. Indeed in next merge window I will=
 submit a patch series to drop the discard option.
>=20
> OK, I will boot on a Live USB Key to wipe the caching device and create a
> new one without discard option.
>=20
> But should I keep the discard mount option in fstab for the logical volum=
es
> inside bcache ?
>=20

Just not enable the bcache internal discard is fine. Bcache handles outside
discard bios properly, if this is a file system mounted on top of a bcache
device, it is fine to keep discard option of the file system.


>=20
> _______________
>=20
> Le 21/10/2025 =C3=A0 03:18, Coly Li a =C3=A9crit=C2=A0:
> > > 2025=E5=B9=B410=E6=9C=8821=E6=97=A5 00:39=EF=BC=8CPierre Juhen <pierr=
e.juhen@orange.fr> =E5=86=99=E9=81=93=EF=BC=9A
> > >=20
> > > Hi
> > > I am on kernel 6.16.12.
> > > I have had errors with bcache recently, And I lost my fronted 3 or 4 =
times :
> > > oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 1=
28: bad csum, 32768 bytes, offset 0
> > > oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 6=
4: bad csum, 22928 bytes, offset 0
> > > oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 3=
2: bad csum, 4848 bytes, offset 2
> > > oct. 20 15:37:40 pierre.juhen kernel: bcache: journal_read_bucket() 4=
8: bad csum, 14096 bytes, offset 0
> > > oct. 20 15:37:40 pierre.juhen (udev-worker)[461]: nvme0n1p3: Process =
'bcache-register /dev/nvme0n1p3' failed with exit code 1.
> > > oct. 20 15:37:40 pierre.juhen kernel: bcache: prio_read() bad csum re=
ading priorities
> > > oct. 20 15:37:40 pierre.juhen kernel: bcache: bch_cache_set_error() e=
rror on 448f191c-28df-4396-bc44-14d1f77c9005: IO error reading priorities, =
disabling caching
> > > oct. 20 15:37:40 pierre.juhen kernel: bcache: register_bcache() error=
 : failed to register device
> > >=20
> > I assume this email is irrelevant to the patch =E2=80=9Cbcache: avoid r=
edundant access RB tree in read_dirty=E2=80=9D, am I correct?
> >=20
> >=20
> > > I had to reconfigure everything after a disk problem.
> > > I have been running bcache for years now, without any problems.
> > > The only difference might be that I configured the frontend with the =
discard option.
> > The discard option is not recommended. Indeed in next merge window I wi=
ll submit a patch series to drop the discard option.
> >=20
> >=20
> > > The logical volume using bcache have also a discard option in fstab.
> > > The frontend is on a Samsung 980 nvme disk.
> > Try not to enable discard on cache device. This option will disappear s=
oon.
> >=20
> > I don=E2=80=99t know whether discard option of Samsung 980 nvme disk ma=
y change the content of discarded LBA or not, from NVMe spec, it could be z=
ero-filled or undefined.
> > Anyway in current code discard doesn=E2=80=99t help performance, I sugg=
est to not enable discard and see whether the issue still shows up.
> >=20
> > My suggestion is: always use default configuration, all our test case a=
nd performance optimization are for default configurations.
> >=20
> > Thanks.
> >=20
> > Coly Li
> >


Return-Path: <linux-bcache+bounces-878-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D994A891E6
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 04:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 364927A6F0F
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 02:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9862219E819;
	Tue, 15 Apr 2025 02:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="uD039/bP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail90.out.titan.email (mail90.out.titan.email [209.209.25.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2E818FC92
	for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 02:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744684504; cv=none; b=Yc5KwfpA/T3AFw0rT6l4eKh05Dme/tn/anfF3tezyK4VcRYd1RAvZMhYwimW0+aO4TeAZTecEicACuJFuG47hHA4da9FAbbI8Q69Wfl4XREGsVNS41jOr4sjD/hlb2VPexWfdRqqXBPivF7NlHpVu+WDcQ9/tfylFHujZSlRG6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744684504; c=relaxed/simple;
	bh=T1y/CMwAFz7pNxUjh7yqxYmGC0hU6DiTWywFAAxz+gM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ZrPj4B2nB9J+dMjEQswZYgo4R/oHyzNZ0P5q32EtUBPvdrUqCq25RZpwRy6S3/l0JTqP5w8+Ww1myj6o0/cd1nDcpFnjK3Qo0ZTGscbLh8r0W1rqR46Fs3jR5XrJpSg7rMNy7sbnwfn7ncIWPJrCoVdov2LwytVXEbuo7nuOrTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=uD039/bP; arc=none smtp.client-ip=209.209.25.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 77252140237;
	Tue, 15 Apr 2025 01:57:25 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=T1y/CMwAFz7pNxUjh7yqxYmGC0hU6DiTWywFAAxz+gM=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=subject:from:references:to:cc:in-reply-to:date:message-id:mime-version:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1744682245; v=1;
	b=uD039/bPyh+FNRFeJHMZAbCpxMIJx1L7liUKKeGGBOQ7pBmN0W8cSxsfed7pc9JC3c0sQp1y
	K2eLG+OehbhvJnZTUnLpxAAO0GCm/WRbjvDvg0IYXE3KucVDAANc/a9rsYVdrIboguIUf6PdP6I
	HcFNdiwgQo6jd2DjFxSCV9jM=
Received: from smtpclient.apple (tk2-118-59677.vs.sakura.ne.jp [153.121.56.181])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id CE505140180;
	Tue, 15 Apr 2025 01:57:23 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <20250414224415.77926-1-robertpang@google.com>
Date: Tue, 15 Apr 2025 09:57:11 +0800
Cc: Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
References: <20250414224415.77926-1-robertpang@google.com>
To: Robert Pang <robertpang@google.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1744682245321204847.32042.7242447923843221103@prod-use1-smtp-out1003.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=fZxXy1QF c=1 sm=1 tr=0 ts=67fdbd05
	a=hXS1xhdqaCDGgKeHTjTB6g==:117 a=hXS1xhdqaCDGgKeHTjTB6g==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
	a=8T08Js6Nrb8FjSixL_cA:9 a=QEXdDO2ut3YA:10

Hi Robert,

Thanks for the fix up :-)

> 2025=E5=B9=B44=E6=9C=8815=E6=97=A5 06:44=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> In performance benchmarks on disks with bcache using the Linux 6.6 =
kernel, we
> observe noticeable IO latency increase during btree garbage =
collection. The
> increase ranges from high tens to hundreds of milliseconds, depending =
on the
> size of the cache device. Further investigation reveals that it is the =
same
> issue reported in [1], where the large number of nodes processed in =
each
> incremental GC cycle causes the front IO latency.
>=20
> Building upon the approach suggested in [1], this patch decomposes the
> incremental GC process into more but smaller cycles. In contrast to =
[1], this
> implementation adopts a simpler strategy by setting a lower limit of =
10 nodes
> per cycle to reduce front IO delay and introducing a fixed 10ms sleep =
per cycle
> when front IO is in progress. Furthermore, when garbage collection =
statistics
> are available, the number of nodes processed per cycle is dynamically =
rescaled
> based on the average GC frequency to ensure GC completes well within =
the next
> subsequent scheduled interval.
>=20
> Testing with a 750GB NVMe cache and 256KB bucket size using the =
following fio
> configuration demonstrates that our patch reduces front IO latency =
during GC
> without significantly increasing GC duration.
>=20
> ioengine=3Dlibaio
> direct=3D1
> bs=3D4k
> size=3D900G
> iodepth=3D10
> readwrite=3Drandwrite
> log_avg_msec=3D10
>=20
> Before:
>=20
> time-ms,latency-ns,,,
>=20
> 12170, 285016, 1, 0, 0
> 12183, 296581, 1, 0, 0
> 12207, 6542725, 1, 0, 0
> 12242, 24483604, 1, 0, 0
> 12250, 1895628, 1, 0, 0
> 12260, 284854, 1, 0, 0
> 12270, 275513, 1, 0, 0
>=20
> =
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:2880=

> =
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:13=
3
> /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:121
> /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3456
>=20
> After:
>=20
> 12690, 378494, 1, 0, 0
> 12700, 413934, 1, 0, 0
> 12710, 661217, 1, 0, 0
> 12727, 354510, 1, 0, 0
> 12730, 1100768, 1, 0, 0
> 12742, 382484, 1, 0, 0
> 12750, 532679, 1, 0, 0
> 12760, 572758, 1, 0, 0
> 12773, 283416, 1, 0, 0
>=20
> =
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:3619=

> =
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:58=

> /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:23
> /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3866
>=20
> [1] =
https://lore.kernel.org/all/20220511073903.13568-1-mingzhe.zou@easystack.c=
n/


I see the data, it makes sense. I=E2=80=99d like to see more testing =
data, e.g.
1) Larger SSD (4T or 8T)
2) Higher I/O pressure (randomwrite)
3) Much longer time with high I/O pressure (24 hours+)

Then it can help me to understand the optimization better and make =
decision easier. Of course it will save a lot of testing time from my =
side.

Thank you in advance.

Coly Li=20



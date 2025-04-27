Return-Path: <linux-bcache+bounces-966-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1363FA9E064
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Apr 2025 09:26:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BA7B17D954
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Apr 2025 07:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70A86245022;
	Sun, 27 Apr 2025 07:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="PgqdcOqV"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail38.out.titan.email (mail38.out.titan.email [209.209.25.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119B410E0
	for <linux-bcache@vger.kernel.org>; Sun, 27 Apr 2025 07:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745738777; cv=none; b=MVdyCk3J0QHAxIzfCM/2azYNKYNL2vWq/VKLCa9giJeEGr2KsvJlGYeRQ4GLh0b8qvYcoiIVdQuYlMlE5HKe6OkPKmap+zau+becB70hs6yysD3G+xiDuzA936861Vm26EXYqiaR5Y23suEVbT+HQtAzVdPQOZyyN7Y0AfMHv/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745738777; c=relaxed/simple;
	bh=SnKDtn9vNNEvBK7+Ork9k+3FMuZ/BPGhOp5jL12zxrg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UEtiIgitelcwyyHZT7yIwQLi/BkmT3/aI/3bWPGE5H11mqVVDMmMq4sfEPIzTRejt/wyvXHUlw7HyC76GqZdRsMQpGkYW2nugb5D3k8ZbuRmrNDj7+4JKs4Vz1q/716oygYVGcZ33Up8NCpsIFZshzJTe0mROiJx8duLP5OWPyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=PgqdcOqV; arc=none smtp.client-ip=209.209.25.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id CCDA060044;
	Sun, 27 Apr 2025 06:48:15 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=bQYeXUX70C/rw//HG2eTPdfBxl6JMtsEVq9jZKgzyKc=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=from:to:subject:cc:references:mime-version:in-reply-to:date:message-id:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1745736495; v=1;
	b=PgqdcOqVqt+jjQSSE7o6p7HfsCdoMUDlzBggVwEqnpHlCqGJmf5HxriVcC1vdVauXKCp1JfL
	euNNMmfRDdxuilG2f82OsJ0ZbWcF/NJso/ZEpDlvMkAyHhOf0BV9DB6KJXXigw3+TOHbTj7WWlH
	iEvIlCgfDt0N6TRMAdtLeFWs=
Received: from smtpclient.apple (v133-18-227-172.vir.kagoya.net [133.18.227.172])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id ED03360110;
	Sun, 27 Apr 2025 06:48:12 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH] bcache: add the deferred_flush IO processing path in the
 writeback mode
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
X-Priority: 3
In-Reply-To: <tencent_5EFAC84160EC2688341D1A8F@qq.com>
Date: Sun, 27 Apr 2025 14:47:59 +0800
Cc: Coly Li <colyli@kernel.org>,
 "kent.overstreet" <kent.overstreet@linux.dev>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 =?utf-8?B?5aSP5Y2O?= <xiahua@kylinos.com.cn>,
 =?utf-8?B?6YKT5pe65rOi?= <dengwangbo@kylinos.com.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DEAB3741-AF2F-4CD3-B715-EBC3AB9B394E@coly.li>
References: <20250425035021.921-1-zhoujifeng@kylinos.com.cn>
 <ug3sqyn42af4bjsp3l5d5ymiabtc767oaoud3ddzv6jnw2eh27@4gcxqaq5tatf>
 <tencent_5EFAC84160EC2688341D1A8F@qq.com>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1745736495701004276.5242.6327280174020665267@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=O7TDvA9W c=1 sm=1 tr=0 ts=680dd32f
	a=mj4eMbsE5mSnrU54dbyulA==:117 a=mj4eMbsE5mSnrU54dbyulA==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=2g-bObx1AAAA:8 a=VwQbUJbxAAAA:8
	a=fA3rBA8wnNJP-tMNtCUA:9 a=QEXdDO2ut3YA:10 a=2vxvtA42U9rPmyYw9DsL:22



> 2025=E5=B9=B44=E6=9C=8825=E6=97=A5 16:18=EF=BC=8CZhou Jifeng =
<zhoujifeng@kylinos.com.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly Li,
> Thank you for your reply and your question.
>=20
> On Fri, 25 Apr 2025 at 13:46, Coly Li <colyli@kernel.org> wrote:
>>=20
>> Hi Jifeng,
>>=20
>> Thanks for posting the patch.
>>=20
>> On Fri, Apr 25, 2025 at 11:50:21AM +0800, Zhou Jifeng wrote:
>>> In some scenarios with high requirements for both data reliability =
and
>>> write performance, the various cache modes of the current bcache =
cannot
>>=20
>> Could you provide the detail workload or circumstance which requires =
both
>> data reliability and write performance that current bcache cannot =
serve?
>=20
> For example, in some database application scenarios, the requirements =
for data
> security are relatively high. When writing frequently, flush is called =
more often,
> and the performance of write dsync is of great concern. The =
operational performance
> of several cache modes of bcache in such scenarios at present:
> none: The cache does not work and is of no help to performance. The =
performance is
> the same as that of the backing device and cannot meet the performance =
requirements.
> writeround and writethrough: They are not helpful for write =
performance. The write
> performance is the same as that of the backing device and cannot meet =
the write
> performance requirements.
> writeback: Since when it writes back dirty data, it only marks bio as =
REQ_OP_WRITE,
> there is a risk of data loss due to power failure. In addition, since =
it needs to send a
> flush request to the backing device when handling requests with the =
flush mark, it will
> affect the write performance.
>=20
>>> fully match the requirements. deferred_flush aims to increase the
>>> reliability of writeback write-back. And reduce the sending of =
PREFLUSH
>>> requests to the backing device to enhance data security and dsync =
write
>>> performance in wrieback mode.
>>=20
>> I'd like to see the detailed description on how deferred flush is =
defined,
>> and how it works. And why deferred flush may provide the data =
reliability
>> and performance better than current bcache code.
>=20
> deferred flush: When data is processed through the writeback path, it =
will determine
> whether a PREFLUSH needs to be sent to the backing device. The =
judgment criterion
> is whether a write request has been sent through bypass or =
writethrough before. If not,
> it is not necessary. Put the PREFLUSH semantics into the dirty data =
write-back stage
> to ensure the reliability of the dirty data write-back. Here, by =
reducing the sending of
> PRELUSH to the backing device, the delay for the backing device to =
process PRELUSH
> is decreased, thereby improving the performance of dsync write =
requests when the
> cache space is abundant. During the dirty data write-back stage, the =
FUA method is
> adopted to ensure that the dirty data will not be lost due to factors =
such as power failure.
>=20
>> I don't look into the patch yet, just with my intuition the overall
>> performance won't be quite optimized by setting FUA on writeback =
I/Os.
>=20
> Using the FUA method to write back dirty data does indeed have an =
impact on the speed
> of writing back dirty data. In a test where I/O is written randomly at =
4K, the speed of
> writing back dirty data is approximately half that of the non-FUA =
method. However,
> considering that the data is not written at a high intensity =
continuously, this provides some
> buffer time for writing back dirty data. In extreme cases, when the =
effective space of the
> cache is tight, its write efficiency is not lower than the performance =
of the backing device.
> Therefore, enabling deferred_flush is effective in low-cost deployment =
solutions that require
> the use of SSD to accelerate the performance of dsync.

I am not sure whether the situation you stated is acceptable or not for =
most of users.

I hope to see more testing data.

>=20
>> And the cache mode can swtich arbitarily in run time, if cache mode =
was none
>> or writethough, then switch to writeback, I don't see your patch =
handles
>> such situation.
>=20
> When switching from other cache modes to writeback and simultaneously =
enabling=20
> deferred_flush, a REQ_PREFLUSH request will be sent to the backing =
device.
> Code location in the patch:
> +   if (attr =3D=3D &sysfs_deferred_flush) {
> +       v =3D __sysfs_match_string(bch_deferred_flush, -1, buf);
> +       if (v < 0)
> +           return v;
> +
> +       if ((unsigned int) v !=3D BDEV_DEFERRED_FLUSH(&dc->sb)) {
> +           if (v && (BDEV_CACHE_MODE(&dc->sb) !=3D =
CACHE_MODE_WRITEBACK)) {
> +               pr_err("It's not the writeback mode that can't enable =
deferred_flush.\n");
> +               return -EINVAL;
> +           }
> +
> +           SET_BDEV_DEFERRED_FLUSH(&dc->sb, v);
> +           bch_write_bdev_super(dc, NULL);
> +           if (v) {
> +               bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | =
REQ_PREFLUSH);
> +               /* I/O request sent to backing device */
> +               submit_bio_wait(&flush);
> +           }
> +       }
> +   }

And when read/write congestion happen, part of read/write requests will =
directly from/to hard drive and bypass cache device.

Anyway, long time high load testing result is necessary. I assume this =
patch will decrease general write back throughput and result higher =
pressure for cache device garbage collection load triggered by =
allocator.
Maybe I am wrong, I=E2=80=99d like to learn from your benchmark results.

Thanks.

Coly Li=


Return-Path: <linux-bcache+bounces-1257-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9A6C5C26E
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Nov 2025 10:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0B8D1358677
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Nov 2025 09:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C39B301493;
	Fri, 14 Nov 2025 09:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="LaLRcpyh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-13.ptr.blmpb.com (sg-1-13.ptr.blmpb.com [118.26.132.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3C826CE25
	for <linux-bcache@vger.kernel.org>; Fri, 14 Nov 2025 09:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111036; cv=none; b=p4gHaOxGFcESZ/RFgCcEnKG/oFj3sPIK/ZZlQt7QXOY8eoD5ZG8ASBngXBD9zu4WH+m/IhMSD+AuYK5o1608dBFGoN7vdn+JWh9B29k1jMc6PKXwoqE+J+QJF/PD0rD3KOOuYk0KkQrhUSKzWoa6RN1/r2LGy4t1jj6aqvHlNtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111036; c=relaxed/simple;
	bh=4O7KLGIHhHTX6UHtPkiroNXXmtNdk6P2JM8CAnt5lXc=;
	h=Content-Type:To:Cc:Subject:Message-Id:Mime-Version:References:
	 From:Date:In-Reply-To; b=iKLNnjyfz1bzSXjeKVKHPvgL7Eu0GlC9PbCR7UpyOZpZaEcL+2jH4mjG+S+ch9R7t4KkYCFG6VhgYczz7FzaQUWRBIQ0iwajtMTBLxTZORXtbnL7/A0wN3VCpb2kFIgt42YjLgl5xqXsZ+pcoc/3essLORfXpxcw3Kl/ay+vZpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=LaLRcpyh; arc=none smtp.client-ip=118.26.132.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1763111022;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=4O7KLGIHhHTX6UHtPkiroNXXmtNdk6P2JM8CAnt5lXc=;
 b=LaLRcpyhrACfzkWICkRQudWhzotDp9X6yXW+w0cY+D2y79pryZ+9YxojsUzzKh8G6kjSq/
 PY7CKcmBmI6rbI8F5J6JL3PwxzIbrHs/7uMKGYOCbDdTw85Ae299CNMtTKqapLFJPle4XE
 GztjVeWwnSKe0/CW5xgn8JtpBd5wPgACM3vl2hP8bdeZJX41VHDrLipA7rf4JbTb9GUruO
 IzAp2KsbNfCRlOrhahhZgut9WUDGo57xxzMju827aBDy1Sn5KpztIlEt3z49015dg8LEvB
 HIcKxr4j3uvKcAYJLDdj/UB0jkUpSmyaJA/G+h5+pgVCBDZP8c0QqAiMtktEmQ==
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fnnas.com>
X-Lms-Return-Path: <lba+26916f06c+725298+vger.kernel.org+colyli@fnnas.com>
To: <linf@wangsu.com>
Cc: <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH 1/9] bcache: get rid of discard code from journal
Message-Id: <E26D0C0C-FB08-4C44-B6CC-6E04D58CB43D@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <007801dc5533$064c29a0$12e47ce0$@wangsu.com>
From: "Coly Li" <colyli@fnnas.com>
Date: Fri, 14 Nov 2025 17:03:27 +0800
Content-Transfer-Encoding: quoted-printable
Received: from smtpclient.apple ([120.245.64.178]) by smtp.feishu.cn with ESMTPS; Fri, 14 Nov 2025 17:03:38 +0800
X-Mailer: Apple Mail (2.3864.200.81.1.6)
In-Reply-To: <007801dc5533$064c29a0$12e47ce0$@wangsu.com>

> 2025=E5=B9=B411=E6=9C=8814=E6=97=A5 14:50=EF=BC=8Clinf@wangsu.com =E5=86=
=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly:
> =20
> AFAICT SSD use write-after-erase mode to reuse a ssd block for writing an=
d
> internally ssd firmware will gc those to be discarded blocks for future w=
rites.
> so even write to a same logical bcache bucket it won=E2=80=99t be mapped =
to the same=20
> physical ssd block, because ssd always needs a clean block for writing.=
=20
> =20
> So IMHO the discard op does have its function role, it could tell the fir=
mware=20
> to gc that bucket immediately while I=E2=80=99m not sure if we gain perfo=
rmance benefit
> from such journal discard ops.
> =20
> Perhaps I misunderstood something, kindly if you could point me out.

The issue is the time when discard is issued for cache device (not backing =
device).
For enterprise SSD such discard hint is unnecessary, for low end consumer S=
SD it is too late.

In my testing, enterprise SSDs (e.g. Lenovo or memblaze ones) have enough i=
nternal reserved
space for gc, almost no performance impact with/without enabling cache devi=
ce discard option.

For low end SATA or m.2 SSD, after issue discard bio then new data is writi=
ng onto SSD, the performance
number differs a lot comparing that I manually discard the SSD and then cre=
ate cache device. I assume it
is because the internal reserved space is quite limited for gc. Such quite =
late discard hint doesn=E2=80=99t help any
and introduces extra latency.

This is why I call it useless.

Thanks.

Coly Li


> =20
> Ps: I haven=E2=80=99t subscribe the mail list so I just paste the patch t=
itle for reply,
> Sorry if it makes inconvenient to anyone. =20
> =20
> Thanks!
> linfeng
> =20
> =20
> Following contents extracted from original patch.
> =20
> From: Coly Li <colyli@fnnas.com>
> =20
> In bcache journal there is discard functionality but almost useless in
> reality. Because discard happens after a journal bucket is reclaimed,
> and the reclaimed bucket is allocated for new journaling immediately.
> There is no time for underlying SSD to use the discard hint for internal
> data management.
> =20
> The discard code in bcache journal doesn't bring any performance
> optimization and wastes CPU cycles for issuing discard bios. Therefore
> this patch gits rid of it from journal.c and journal.h.
> =20
> Signed-off-by: Coly Li <colyli@fnnas.com>
> ---
> drivers/md/bcache/journal.c | 93 ++++---------------------------------
> drivers/md/bcache/journal.h | 13 ------
> 2 files changed, 8 insertions(+), 98 deletions(-)


Return-Path: <linux-bcache+bounces-1227-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1057BBFD7EB
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Oct 2025 19:13:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C75853BE537
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Oct 2025 16:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEEC635A13D;
	Wed, 22 Oct 2025 16:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="mA7fH5eK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C25280018
	for <linux-bcache@vger.kernel.org>; Wed, 22 Oct 2025 16:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761150571; cv=none; b=uJ4dh6pCTg1I4uaNgGw5KmMKSLVHjLPjue8bEz3El10asRsHDywnN8jJ7yENkfo2ant56eYZyl0jpTSVfGqgt4/mekJBmEiI3IQgZjN6/kAMzbVSOP2OjR7RlG2B58sZJTGFQPrakM8HmeXau/76viaqnHUC6Ca0vIJjbj/H7gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761150571; c=relaxed/simple;
	bh=naLCPT8QruCSsbO4C1gsw20tFuE+6Ghf/ppz3Oxv5E8=;
	h=In-Reply-To:Content-Type:Date:Subject:Mime-Version:References:To:
	 From:Content-Disposition:Cc:Message-Id; b=X+GukXD+tKm5o7IcwRLUaQoH0GKWX3/SLDLoWtPbBWAz+Ipd9rdkn5F/+rls8YDrqfvlflv336OcXzkt1QOcPHTYETBiSROHGqGO3tL/HXvG33uU+hXYZiqYA6l1eK6mMZIqPd7rsPAu71b4M+J60YXaBVAR6pDOfauyBhh26N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=mA7fH5eK; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761150555;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=8uejkmSekgy5VFSaXpL18QWdgvHhehs+yN8EUrm6rvI=;
 b=mA7fH5eKUcmj6cxce7+R+1WVjXu6NpBKYKkjrDPvG7BK8Asjwt9TTGsm02ezcActGQCBZE
 3eY2MsC5jSxCm2YEsBNAGmlZoL/lU2/t+Em0StNWsQS0IwkUhM969Z7seDslpYEJd4sJ5z
 2hoGk7FP4kOuzySUs9vcN7jxIB8QiZ5UZMMlTCCKAYXekrrhnrpWY3+Y84unznysGNKb1J
 jhx75KCW+HUIQ9LiimyBfw7YWKVWIRgpqNEEygkVTy7j/hCtsZsIG0h8SVYnwftEkZyyeQ
 oHYYZ++xmVEv1sTwYnFq4PkV0wGbUrwoDhejlhCAGFLYHQ8PdJZMWipgVckmMw==
In-Reply-To: <66608f30-f1b8-4b0f-bd3e-6e039c328873@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Oct 2025 00:29:11 +0800
Subject: Re: [PATCH v1] bcache: Use vmalloc_array() to improve code
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>
References: <20251017111306.239064-1-tanze@kylinos.cn> <bb26wdvihppk6wjpy3ysijfxaj6kofw7zbich4b72bwwnl7fec@cpkvrdhpkj3e> <66608f30-f1b8-4b0f-bd3e-6e039c328873@kylinos.cn>
To: "tanze" <tanze@kylinos.cn>
From: "Coly Li" <colyli@fnnas.com>
X-Lms-Return-Path: <lba+268f90659+f42d8e+vger.kernel.org+colyli@fnnas.com>
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Cc: <kent.overstreet@linux.dev>, <john.g.garry@oracle.com>, 
	<linux-kernel@vger.kernel.org>, <linux-bcache@vger.kernel.org>
Received: from studio.lan ([120.245.65.31]) by smtp.feishu.cn with ESMTPS; Thu, 23 Oct 2025 00:29:12 +0800
Message-Id: <tw4rtosj3jcu73u4eggg7ygh2fstsg5xr774ep2gr2lsnac4md@szuihm2uoafh>

On Wed, Oct 22, 2025 at 10:24:36PM +0800, tanze wrote:
>=20
> =E5=9C=A8 2025/10/22 20:03, Coly Li =E5=86=99=E9=81=93:
> > On Fri, Oct 17, 2025 at 07:13:06PM +0800, tanze wrote:
> > > Remove array_size() calls and replace vmalloc(), Due to vmalloc_array=
() is optimized better,
> > > uses fewer instructions, and handles overflow more concisely[1].
> > >=20
> > > Signed-off-by: tanze<tanze@kylinos.cn>
> > > ---
> > >   drivers/md/bcache/sysfs.c | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > > index 826b14cae4e5..dc568e8eb6eb 100644
> > > --- a/drivers/md/bcache/sysfs.c
> > > +++ b/drivers/md/bcache/sysfs.c
> > > @@ -1061,8 +1061,7 @@ SHOW(__bch_cache)
> > >   		uint16_t q[31], *p, *cached;
> > >   		ssize_t ret;
> > > -		cached =3D p =3D vmalloc(array_size(sizeof(uint16_t),
> > > -						ca->sb.nbuckets));
> > > +		cached =3D p =3D vmalloc_array(ca->sb.nbuckets,sizeof(uint16_t));
> >                                                            ^^^-> a blan=
k missing?
> Thank you for your correction. If you need me to revise these description=
s,
> I will send the version 2 (v2) patch later

Yes, version 2 will be fine.

> > >   		if (!p)
> > >   			return -ENOMEM;
> > Except for the missing blank, overall the patch is fine.
> >=20
> > BTW, IMHO tanze is not a formal method to spell the name, could you ple=
ase
> > use a formal format? It will be helpful to identify your contribution i=
n
> > future.
>=20
> Hi , Coly Li.
> Thank you for your reply. First of all, I am Chinese. I often use this na=
me
> as
> my signature on many occasions, and I also used this name for the code
> submitted
> to the upstream party before.

Okey, then ignore my noise.

Thanks.

Coly Li


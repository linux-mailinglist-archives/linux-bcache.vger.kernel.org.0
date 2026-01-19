Return-Path: <linux-bcache+bounces-1382-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A990BD3A21A
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 09:52:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 708023016CFF
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 08:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B258A34FF59;
	Mon, 19 Jan 2026 08:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="sHn0ZVXo"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BC426158C
	for <linux-bcache@vger.kernel.org>; Mon, 19 Jan 2026 08:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768812736; cv=none; b=RrDztxUPlmqI0izqFrC+6wEftH9ORHoqPQg+S1b/IJGSE60csICUEDuspyFfFQOiDhypSAS7Y7+NqV88ds2R5a/YEvVPJxtvoxblNRzM3NjHxTDpsu6KuTkOSWhvruYPBTthInrBx4LYsAxt3XslaXQhfnywfVVIBz0c2/HU+JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768812736; c=relaxed/simple;
	bh=jf86IloKeDsZGLkTiknyb5s0/ZMBbJtIFQQMkrjARyM=;
	h=Subject:References:Cc:From:Date:Mime-Version:Message-Id:
	 In-Reply-To:Content-Type:To; b=okHsKs5VKDLorLnvFl1sjKz91KHq5+7iTPmB9tZoqK3q75Ir9gJHm5rw2RDdEure5cuFrNRzfx3hAxlGBEGCC99rY5IVYFJP1Pni2GS+RbCZOvhxkKe96091yx5HGovCn87g3HQHt4EkAGkFCwkIMbLRgS62jQl7FjauYy3Yij0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=sHn0ZVXo; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768812728;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CQgXpZzD7q7X74mbtoLyfIj+SzVrOwqEO5tD2hixhKA=;
 b=sHn0ZVXoxJcaLlExHznKIbWOFUGm7GrwYkRAypHKNTO1j3YtjYHIsBwy6yqAYbbqauP6GP
 4QoWCd+DeH4KNIbrMceVjVY0hhOfsx+ScY8P55N4LzYoppkvP5AAqqiPRrGAnTLCw8/R2f
 F6ncAzWqdVfw7UoEUrH2d0L9XUkiMJX8hLmpl7PyZtl5xGejqc88utSJRVHeDOxZNxfvks
 +vWUdzYRCymnqfXtW1poiiLEV5rROtMlk43D2izQwWidPWgApqF3KGkFV4d/YxHiYAOjoB
 dH+dQh9ctr3Yfx/AQCPFGs9voXtpk+IPO5ycb9+v207YS5F594SC31jZwyMFMQ==
Subject: Re: [PATCH] bcache: fix double bio_endio completion in detached_dev_end_io
X-Mailer: Apple Mail (2.3864.300.41.1.7)
References: <20260115074811.230807-1-zhangshida@kylinos.cn> <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com> <aWilW0RKQiHJzpsZ@infradead.org> <aWzIU3ASp139lHNz@studio.local> <aW3Sq4H_OosPVaNe@infradead.org> <aW3nzb2lOSVSbqQZ@studio.local> <aW3rfPoloviR1Rp9@infradead.org>
Content-Transfer-Encoding: quoted-printable
Cc: "Stephen Zhang" <starzhangzsd@gmail.com>, <kent.overstreet@linux.dev>, 
	<axboe@kernel.dk>, <sashal@kernel.org>, <linux-bcache@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <zhangshida@kylinos.cn>
From: "Coly Li" <colyli@fnnas.com>
Date: Mon, 19 Jan 2026 16:51:54 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <18D8841B-9C33-436A-9B8D-C81E2EA0DE69@fnnas.com>
Received: from smtpclient.apple ([120.245.64.73]) by smtp.feishu.cn with ESMTPS; Mon, 19 Jan 2026 16:52:05 +0800
In-Reply-To: <aW3rfPoloviR1Rp9@infradead.org>
X-Lms-Return-Path: <lba+2696df0b6+a232e8+vger.kernel.org+colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fnnas.com>
To: "Christoph Hellwig" <hch@infradead.org>

> 2026=E5=B9=B41=E6=9C=8819=E6=97=A5 16:29=EF=BC=8CChristoph Hellwig <hch@i=
nfradead.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Jan 19, 2026 at 04:19:38PM +0800, Coly Li wrote:
>> Before I work on it, I want to know the author already ran and tested th=
e
>> patch firstly. Normally I won't test any patches posted on mailing list.
>=20
> Without a published test suite that can be used for that, that is a very
> high demand.  Maintainers of code that can't easily be tested by a
> drive by contributor (or contributor to the parent subsystems for that
> matter) need to help with testing, otherwise we would not get anything
> done in the kernel.
>=20

OK, let me integrate Kent=E2=80=99s test cases and my scripts, and show it =
in git.kernel.org.
You ask this for times, I should handle it ASAP. But it won=E2=80=99t be th=
e blocker of proceeding this fix.

Anyway, there is no conflict with asking =E2=80=9Cdo you test your patch=E2=
=80=9D from me.

Coly Li


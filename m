Return-Path: <linux-bcache+bounces-1303-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D490C95B8B
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 06:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C51F3A1FBB
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 05:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B389F200110;
	Mon,  1 Dec 2025 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MjNzpAAN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0E3154BE2
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 05:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764567769; cv=none; b=TovgJSQdcuUOZZBdIefR5xIOuJ4pdx8VTdHb7ND4/P/bOQ6L9MUKUnODhsJHKFMakelvajRkqrpFKxu+OyK+bF0BcnjDKXiq3p8WbhNmuORqDwlIQORnIypkul3111fr2KKdImQKlWgctEyZ3kbi1Z6G/rjpZOAfenvznnMUpuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764567769; c=relaxed/simple;
	bh=c1rjV/8l6N5f1RM2rQjR3SlHORaNasTZ5ipYnJkZFDQ=;
	h=From:Date:In-Reply-To:Cc:Message-Id:Content-Type:References:To:
	 Subject:Mime-Version; b=hfPvPzX4bpxDyNMbb2uMqSp2KUx8FbPrBaNTkv7RvePZHJQlvNT8p1hnKe7hgWUroQwrqKXudnWR/rGnRsIL6sijyg8tnOndhdeKa/XPIsF5c1VPJxF7DNWPHLnzRl+WZPLZ9uSc1sRd7niryhgLkH2mfV9P5YHpbzteiNmW7Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MjNzpAAN; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764567755;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=c1rjV/8l6N5f1RM2rQjR3SlHORaNasTZ5ipYnJkZFDQ=;
 b=MjNzpAANlYctCOptHx7qmyvN2J0YX+8JCV6JeYdi861oS/dWVuAIyMMBujx1D5GHdb1vFX
 858dMeQ/4+hdOZIIfvmoXXYqWAd5KcHC21JRni7LKd2WhEltRFAyXZIowviHf7pmTyyT3r
 kwv8FN55eKgjmby6IiJiRGCosEKJb7zZVvWopY2bXK5EDDAJtabeofKD8hDRiG4venN3WW
 n344r30BgSrYW9CbhHmLppqwPBieyawzfryQ7tqqt6sXhIciR8w6e6ubB/AAvW/uVgNEdy
 bAc09oixfEIdfN8QIvcZeF4rzV7XUCOmFmputhllrPSdPE4+x6H+9zCZQRh7hw==
From: "Coly Li" <colyli@fnnas.com>
Date: Mon, 1 Dec 2025 13:42:20 +0800
Received: from smtpclient.apple ([120.245.66.121]) by smtp.feishu.cn with ESMTPS; Mon, 01 Dec 2025 13:42:32 +0800
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANubcdUGqYsaxsd-cUtjhtCSL4G1kQGevei1m25qKm0ip0-i9g@mail.gmail.com>
X-Original-From: Coly Li <colyli@fnnas.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)
Cc: <baijiaju1990@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, 
	<linux-bcache@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	<stable@vger.kernel.org>, "zhangshida" <zhangshida@kylinos.cn>
Message-Id: <D4188931-CEEE-49CB-94AF-FE81D952BAA4@fnnas.com>
Content-Type: text/plain; charset=UTF-8
References: <CANubcdUGqYsaxsd-cUtjhtCSL4G1kQGevei1m25qKm0ip0-i9g@mail.gmail.com>
To: "Stephen Zhang" <starzhangzsd@gmail.com>
Subject: Re: [PATCH] bcache: call bio_endio() to replace directly calling bio->bi_end_io()
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+2692d2ac9+9329a4+vger.kernel.org+colyli@fnnas.com>

> 2025=E5=B9=B412=E6=9C=881=E6=97=A5 10:49=EF=BC=8CStephen Zhang <starzhang=
zsd@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> For this issue, I've previously sent a fix here:
> https://lore.kernel.org/all/20251129090122.2457896-2-zhangshida@kylinos.c=
n/
> Would you be able to take a look and see if that one is suitable to pick =
up?

Hi Shida,

It seems my email server didn=E2=80=99t handle the v3 patch set well. Yes, =
now I see your patch,
I will reply your in the patch context.

Thanks.

Coly Li


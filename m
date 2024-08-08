Return-Path: <linux-bcache+bounces-711-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB8E094B497
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Aug 2024 03:21:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 091D71C20D8E
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Aug 2024 01:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0DAE29AF;
	Thu,  8 Aug 2024 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="j87/6QgT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6A979CC
	for <linux-bcache@vger.kernel.org>; Thu,  8 Aug 2024 01:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723080085; cv=none; b=hQoWoclOUTH0mIFM1I08w3kCKh4VkN+Teiwzk4p4Bs2RUJK1zN3rUQ2TjE2QJngxMCrjArYR8cuxBNXW64a2RXhxoC780haFR7OliiHlxJ7pY0H2EiIdzl4y26OIiODkw+j956ztigx0wsqLYx15zAxbZQsG8Q2eNpFRbIXUD9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723080085; c=relaxed/simple;
	bh=nrpjz5Urg+oYXmbTFaIVqfOcCFUn5JbJopvjqAA7JxQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=nPHNFV+vfUxzITSU0HVUo6WrAFWKnTOc2VqSV1f1nfSbnRzmGVf7UDMhP97jWF5wmTk67myoJj1hczo5NSdSJfJns4zRorEv9bOAo0NpQejwzAD9q2CDvqho6my8cz93X8pLz1eMyipPp3xX9vf299f3LhawfPveNT+iZd5yEcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=j87/6QgT; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 25E2F3F733
	for <linux-bcache@vger.kernel.org>; Thu,  8 Aug 2024 01:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1723080075;
	bh=nrpjz5Urg+oYXmbTFaIVqfOcCFUn5JbJopvjqAA7JxQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type;
	b=j87/6QgTkpsWh+ajN8rkGhFxvg0hy25CM+1XMSUw7B7uCtEle2ffhq+51Cwp3E2y1
	 JU7N4Dny+GQdBKG7blOZPpxvDSsrVvE78C5s6pM0aDuYg77m9QTyt9xMOBxj/EVX9k
	 0u0BCvLyi65PTKc66Vsg2VieP+IdITaIQed40CutOcA+WguAhPFqIA/b0iCKlpidTe
	 c9Dp8dNFhVdoS6qwjuh3Xz1zVJ+RJB9a5tQCQ5Fxg5zFij2SFJbe7OKe4TaSwOpihO
	 9ZcqJ1gjXfPQ77OWsJaFxz8aTptMXS0X4ksSQoQsxjF8q66k232BA1CPpjtc6e8a2Z
	 gm3BB0CHDiZPg==
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52fceed3473so332273e87.0
        for <linux-bcache@vger.kernel.org>; Wed, 07 Aug 2024 18:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723080074; x=1723684874;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nrpjz5Urg+oYXmbTFaIVqfOcCFUn5JbJopvjqAA7JxQ=;
        b=Iehkb2MNI1CR0HdpT1w1Fif79x6kB4n2u4u8UjWYWfRDtXXf9BLxTF4bLIYLJYiC2u
         v0C+gSyhKAPfkIUS2V4V/N6B8EOZEnQfBBVGO94OaOep41J8zY9N9wdvd51aaoK5qn1a
         Mf+hBpZBVWPBZlWd5CZiEcVJMKHPWUPOPcGA01duQTS9M2Q5DBoLb9uzUksk0NzTpI7y
         5ulwnlyiTkce9YUhNlD/F7HNxx/AOk9C6KSk2M+LFV2zGFVhMbiMlxZPzoL736MJuVGZ
         +4MNsV0adfEdXA40ve+YPLiq0/BEx4MC0KMxtcp2znrzX8VD4ajnuZEVV9T5ZxMiMCHz
         hGmA==
X-Gm-Message-State: AOJu0YxH9KhGkH6rtHNlz4Zmp9KCce/KUZ8yflmVHNFHX8Q7jqLJwIAr
	VZTjDRue6N0BD+pZT98tCqqnEheZdn7xddKtvOjBfldtoPDo74z8eZNPaWy4A/S9KWTU/qY+aKl
	bc6W+hOkY5Ysy5HkQ5WRAuQbkMzCsEE9YupmjKH4Ubpg9Rjo0PLVF53CgmL6IaTCo4K7Z1x7o8K
	YVEeuwUiRcsXgLEknYs91JZxWNquRK5QfUoweV+iaF9P10HCMV0siNsoZeYHS1alI=
X-Received: by 2002:a05:6512:138a:b0:52c:8342:6699 with SMTP id 2adb3069b0e04-530e588ed00mr219825e87.55.1723080074069;
        Wed, 07 Aug 2024 18:21:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHao9tGto2FB3oRxS/oBv1oQWG8pxW12DclnPsSbfv9U6/gW5EKdKOToSUqKEfr+VEEzRDUQKwK2b1VQ3qqLYo=
X-Received: by 2002:a05:6512:138a:b0:52c:8342:6699 with SMTP id
 2adb3069b0e04-530e588ed00mr219798e87.55.1723080073109; Wed, 07 Aug 2024
 18:21:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Mitchell Dzurick <mitchell.dzurick@canonical.com>
Date: Wed, 7 Aug 2024 18:21:32 -0700
Message-ID: <CAG2GFaH3_Ux=Ewi_SOqpiDhF=qVDkX-sTBB8z75mm8LOd03tfw@mail.gmail.com>
Subject: multipath'd bcache device
To: linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello bcache team.

I know this project is done and stable as [0] says, but I have a
question if anyone is around to answer.

Has bcache devices been tested and supported on multipath'd disks? I'm
looking into an Ubuntu bug[1], where these 2 projects are clashing.
I'm wondering if there was any consideration or support for
multipathing when this project was made.

Also, your new project, bcachefs, might be hitting the same scenario.
I haven't had the time to test this though unfortunately.

Thanks for your time,
-Mitch

[0] - https://bcache.evilpiepirate.org/#index4h1
[1] - https://bugs.launchpad.net/ubuntu/+source/bcache-tools/+bug/1887558


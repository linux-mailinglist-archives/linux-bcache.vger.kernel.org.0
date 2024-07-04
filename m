Return-Path: <linux-bcache+bounces-702-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF1E92749C
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jul 2024 13:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CF501F22796
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jul 2024 11:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7921AC237;
	Thu,  4 Jul 2024 11:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVwMuNkq"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6EB1ABCC0;
	Thu,  4 Jul 2024 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720091482; cv=none; b=eylKD1niaP1W3FMc0uwiCrQneWoM+/d5rG2JM51pyIzNF0gnU3cM7adUeH2X7Q+E47+ofDkfJwr7sQLmuNh8PVBc1GSdHSKsmJ9IBtnndrY1fWZU9gZWwflSc0vAESmvNsZg/7cC2cWEOF0PFFbPSLW4KPoii6SSSEuNfIy7tIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720091482; c=relaxed/simple;
	bh=TwoVc/A5cvcKyYqBk85IeSoXm8WueZBsy4xxLnttTxM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=tmwlqUlopYjHTOcnxa3V9+3j8EqLLbnYgx82qagPMZLyfpFxuBeT4b/djFcZQayRN9XbAO3OIG9al09zvhY24BWYjfvlsbnk/BATtaNP8UBqgVk4wONiv1uu7h3Ylgvui80xSvJ7coyAtAs0Y1bIDclyRnYsnEG/h0YvJ6WcyxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DVwMuNkq; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-36786081ac8so349222f8f.0;
        Thu, 04 Jul 2024 04:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720091479; x=1720696279; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwBmB9TZGFjcG5R2+2N2tz93DvezoEGxh6PsIk8IO/w=;
        b=DVwMuNkqn+2XTBypJEguND4yU8ZLt/XCn2Rvvwjwn91IWH1oe1bp5nF7YelyIo6Aof
         PGzrkUJnD/afC5RbxYs0jxQOCW15tG8pCg5zJ+ojuyIOTmkn3P8zdLKbWKqPYYnFNmtJ
         3ZCTjLm1HcilZKiDwLpk2UPxvNY66g6DH5nYYf8GITmrmNiesvpDlUJVIkG8NEyVVom8
         kAPftQeFsPA1tCPbALMUCe5WurN0VVxrJVxSSVOvTyPD65adG8ML73VRBjk0VlY6G8Ez
         tX70faa2b6tdI/78pXvVP8ub7qRieBucgNTvNZ38S4R9NoLgoHTvD+O70rxLUJGHKE6z
         hAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720091479; x=1720696279;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwBmB9TZGFjcG5R2+2N2tz93DvezoEGxh6PsIk8IO/w=;
        b=GOgGX4KiCmxV4F2434WjNsNGyyz3RKdNgB1Pf3Bv6uyGfgGOkM8Pb+yVWffU8IWLSi
         8E2NSwHBV+1GDQ17f7ukqMI2a7nOJU35e9n6lEqV8eAGdTA3BJ6skutgZIrhmg8HIgKa
         dQ5bMCO3oqQMaR3lZxHMcQUwbwP9qzYSow5H/jeiCqcBHwR7IGtxz+b5WNTz6WCqE6pK
         KdxwkyPI3bPwTpAV201Q9UHx7lpf5FSeYavrQabkEOHnEaVZcE1LAWFrLhLR+UfiT8zj
         SaektvU9KQa5J7yXuEt0SQO5TM0GAakpU9gFAbbMvc8wv49SdRLcQrmhz8KwNRelqBHT
         67aA==
X-Forwarded-Encrypted: i=1; AJvYcCUq+56FaN0zIJqcWsJmItbCW58aH2Jh97TYBkd5ZYdzi0qAkwg7X69KwUe/hcwmKhVtsPpob/ttD5MxA2+xKuGXBlsZdbcx3mDZbpV8ihWUaaMhYnI696CL+OUFoRdzMlyLc49PgQs/tVeneEiKYn2B/8oqHlpboQXgB2764v1/DdydYE1F2UvrY+ruLkYXcghX7QmHlbbBH9HSHCRN3ETZ4vY/t+hpK0VUF5GuRym/Vr54VzSwowORbKFpLKLIaYmX+nVm0EG9X5U4iTtRKESQHVHoAPXxn7ApXZaZVQr+Jvlj2lE6/axS2DZma1VlSO8BrF6U
X-Gm-Message-State: AOJu0YwW4QvKglXPMHCvZZYtBkq0dlKbQXsnkYd9AavBo4Er98F+EmXF
	2rXxBQI73GGXs85q0pSbBLqf9Wvyzdm87kXqQ9A/4bMWtdskHK7p
X-Google-Smtp-Source: AGHT+IFEzvL2jC2faLe/uaMvaq/UCJ26KrH1XFm9Ol6h8w0Rebt6hjx4X+gdY7pIVUfbtqQYexMuPw==
X-Received: by 2002:a5d:5712:0:b0:367:94e7:958a with SMTP id ffacd0b85a97d-3679dd17ec1mr1153338f8f.6.1720091479417;
        Thu, 04 Jul 2024 04:11:19 -0700 (PDT)
Received: from [10.14.0.2] ([139.28.176.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36787db4d12sm6821051f8f.110.2024.07.04.04.11.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2024 04:11:18 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: Re: [PATCH 14/26] block: move the nonrot flag to queue_limits
From: Simon Fernandez <fernandez.simon@gmail.com>
In-Reply-To: <ZnmoANp0TgpxWuF-@kbusch-mbp.dhcp.thefacebook.com>
Date: Thu, 4 Jul 2024 12:11:16 +0100
Cc: Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?utf-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>,
 Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 =?utf-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>,
 Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org,
 linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com,
 nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org,
 ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org,
 dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org,
 nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org,
 linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 linux-block@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <78BDDF6A-1FC7-4DD7-AABF-E0B055772CBF@gmail.com>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-15-hch@lst.de>
 <ZnmoANp0TgpxWuF-@kbusch-mbp.dhcp.thefacebook.com>
To: Keith Busch <kbusch@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.7)

Hi folks, how can I unsubscribe from this group.?
Thanks in advance.
S

> On 24 Jun 2024, at 18:08, Keith Busch <kbusch@kernel.org> wrote:
>=20
> On Mon, Jun 17, 2024 at 08:04:41AM +0200, Christoph Hellwig wrote:
>> -#define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, =
&(q)->queue_flags)
>> +#define blk_queue_nonrot(q)	((q)->limits.features & =
BLK_FEAT_ROTATIONAL)
>=20
> This is inverted. Should be:
>=20
> #define blk_queue_nonrot(q)	(!((q)->limits.features & =
BLK_FEAT_ROTATIONAL))
>=20



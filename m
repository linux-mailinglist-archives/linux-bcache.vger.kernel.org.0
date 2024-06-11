Return-Path: <linux-bcache+bounces-553-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 254A29033B6
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 09:32:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8318228FD25
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E441171660;
	Tue, 11 Jun 2024 07:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPZjzavt"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AAF1E52F;
	Tue, 11 Jun 2024 07:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718091152; cv=none; b=HFDhSy/twFtuey2jGBuLcR8C1Kw3IpA5vpNz+1tOfIXwjgdy8Mhix80AWj6FDlfPADsbEoD/YzjsKwkQGkbBw3paTblvxJqdhaka/AIwFx6WRxehFomCSG+1jAjsJda/z0pny9V3GDN2OMkSdRnOgC0fFhke+hH0DeBuKgWiR7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718091152; c=relaxed/simple;
	bh=AF+zG6ZFufj7ktoeAMS7+47wp+ON6l7hR24Gr5fCwt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bVShflt2TYYQMNTYvItpQrLFLVwPFLXGhM0hKz/jGDR4P6vP4vzIfOFsLgWkfjCCjZxYihcoTZHx7Dx49TSwpfeLI6Bw5gBt19/mIkBYBMgs5lsto+rvsxg645/RJ0uEPv+v8RLGxjBw/n4n1MXt9NQAgof/4BF3iZ/V6it+JUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPZjzavt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0F2C2BD10;
	Tue, 11 Jun 2024 07:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718091151;
	bh=AF+zG6ZFufj7ktoeAMS7+47wp+ON6l7hR24Gr5fCwt0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SPZjzavtcTKyCdC4WGEmHFxtV9LSffVVHpZkghrgh94KIDRkU8Rgia29Z6gttxoe9
	 zOX7C6t8muRYmEJZDxtGZLcKQdFby+uhJ+qwHFKzMHofsRuUcCtmhO2REjHrW7IVjC
	 7C0j0tRe+awY6OwUGv767JT4KMLbYhYrBxC1MF4vQdaDAWH1YkqCVa5cS1IpTDl7jQ
	 DwpBzOgI8vuLSRr2nP+6MuC1MYxBAnJs8yxlw2hav/xabgNZGi1G1i8tZ6aqMjzXS4
	 h+CSlB5tmAFTFG1Iuv9NHsTDXLnN731DIz3tGAdH8iuIjAV/89MvaPrp5ZojK8LhAf
	 PBu9mWf+fZU2w==
Message-ID: <77ea357f-f73f-4524-8995-ed204d5f3431@kernel.org>
Date: Tue, 11 Jun 2024 16:32:26 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/26] block: freeze the queue in queue_attr_store
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com, nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-12-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> queue_attr_store updates attributes used to control generating I/O, and
> can cause malformed bios if changed with I/O in flight.  Freeze the queue
> in common code instead of adding it to almost every attribute.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



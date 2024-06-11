Return-Path: <linux-bcache+bounces-575-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EDEF90360A
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:24:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4A4A1C2322E
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67908175543;
	Tue, 11 Jun 2024 08:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFzobLSE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF5174EDF;
	Tue, 11 Jun 2024 08:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094211; cv=none; b=cWWMBPRLODMI4PkmRa+LEhT5O5M+5+lhwgPDCPG5MTAkJ9uX/SmuEXAU+fxS07eNkY76+nTuI+AD6ODCz7TXYg31eXLDPO4kDsIbr/IsMCpRvzVe/Zhjzkm2ujCwuA9gyOIdTsCe5uf0uA2Qq6lpXzzXqdAtw6AwF6P4bn4nXWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094211; c=relaxed/simple;
	bh=PCwVdRvz4XJGGIiNmDy6wMkXrr3H3HUMT3pkIraybk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kocCbrwifShZoPVUVYad9DhU3DbNvY3DYFEUx8SIhPceKm8Ng5KjUlkNyghM5UmdCqZXKEsB5BxHa28bXW/nNfxfDgZvIZ29wrl7sqWiFFr/xK3PwpTe4ZpcAkoR3S3ZX5CAWKawDek4pysHJpwBxv6YgUAvKfimxQK40ncwoAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFzobLSE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86496C2BD10;
	Tue, 11 Jun 2024 08:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718094210;
	bh=PCwVdRvz4XJGGIiNmDy6wMkXrr3H3HUMT3pkIraybk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JFzobLSEwQfpgalfDjsXhew6RBycCszqE2f2C/Ru/r8ifaDggADerb3ZWcDYMf7wy
	 2UguDgiYd7paLCb6tqnoYu2dxS7VJu76k45dUpfxH2c8l3qFSrNn2EGh4jWjnKfIAS
	 HBvH4pVK5+Is/WKoiUVoWutNlCyWeMQP2hCSD9Kx8S9haYF4sfr4JiJhYG2nonJP87
	 ivR19am2NLev5ARZzY2SbXtQPtiKMKt2kSHRh2CyzGWwYvO/eLAkUihfoIzngcBiyb
	 99DP2nymQwawaYtHi2qz0jmjPnoMpqNkIxNh8Ag/5f+XcYLmzaYxN9ppmZ11QAIus7
	 gALv/eJkusunA==
Message-ID: <29c6bbe8-f0fe-49dd-a28b-327d86ceb51d@kernel.org>
Date: Tue, 11 Jun 2024 17:23:25 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/26] block: move the zoned flag into the feature field
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
 <20240611051929.513387-23-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-23-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the boolean zoned field into the flags field to reclaim a little
> bit of space.

Nit: flags -> feature flags

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



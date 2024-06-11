Return-Path: <linux-bcache+bounces-577-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2CAD903624
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:25:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83ACD28A697
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FFC817334F;
	Tue, 11 Jun 2024 08:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/kBEFZ/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5FB42A93;
	Tue, 11 Jun 2024 08:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094252; cv=none; b=jOdxKhV79gkxMG5uR4HEN9onfw5Y/faqZ1+gSuSKS5e+UtQnEiKE2rqa4G8WhGglQ2InIKOw75rPbC3hKqK+aYSeHlY7E3YD7WdI+WvZrmZtYYKySqJ67sVWsukrNeUHMuPzwtIwF4zK11uuMmA0Ju7HYqQPNBK//hy9zjdZnk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094252; c=relaxed/simple;
	bh=EFLCVdoWVXgI8x+vDqpH+KGLXZNaxOUmiQChqNs4meI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rAmQIDrRZv7RbKkq4jr3ylKVCeIojxKhcdY0d+/korP8iINca4EFSjxJNS+OXLA24sTGeTMgdLSHns/EuSsarr0AVRUwd22ObinVowHfSLphNLZV9atmIpuAxEVi2+bl+TBY4Sisf9Ch5B8tZRfpSO8Af1RwBc5DzsZ3do5jjBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/kBEFZ/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2C5C2BD10;
	Tue, 11 Jun 2024 08:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718094251;
	bh=EFLCVdoWVXgI8x+vDqpH+KGLXZNaxOUmiQChqNs4meI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q/kBEFZ/0xrAI2sEu9TaynLfxDXFSelXwQfPVhceWBMJF67rXnsoSf0WPmrSssyjG
	 wAyQEjvNKOSDuGTW99P/n/USyXBpEs/hJPBtWDhhYK8Vw7vkoUePhP/xVsLzFkoqW6
	 lvKTjjxF0YRUZJg2F6zMuxFTCUXMjyMw9CECUZorzcdjTlaZUCv5Igv6ct9+LSc3ef
	 11G6zLnpcAxQhEGJrLPj98OB8egVZFZCicz/XL1AiLWkTGFK+0l5ihYD/pd34iBMBZ
	 L/cJqhcyVqLZ5BGlUzg23fH/c4iANFyH2WwiPuUXno5waidx9DiZljw1OQFE15jkSs
	 eG4YOkLzWNcuA==
Message-ID: <cb865b5b-ea4d-49cc-b41b-7f46b62b9dd0@kernel.org>
Date: Tue, 11 Jun 2024 17:24:04 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/26] block: move the zone_resetall flag to queue_limits
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
 <20240611051929.513387-24-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-24-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the zone_resetall flag into the queue_limits feature field so that
> it can be set atomically and all I/O is frozen when changing the flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



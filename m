Return-Path: <linux-bcache+bounces-557-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D9369034CE
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CAFD1C231D7
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FCA173323;
	Tue, 11 Jun 2024 08:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d/4pmxeJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7041314D449;
	Tue, 11 Jun 2024 08:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093195; cv=none; b=Pz0aQWladqS4cfPed8hjw/MQDK3++FpVV4SwKNvBSERgMGXuZ99eZmIx9LoSzYqEpW1z2eHRmlJrj13ubI7yZ+k35kxV5dJYaxaIx7hbu5kCIELKmDrgJCVt+FDTOhkWyIl7DXA0vcSsOy06l8k9Q6uic0nW8au1u+DtlJGJ928=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093195; c=relaxed/simple;
	bh=jCn0oX3HrJ6Qlcw/LuQoAhJRxhLaDvFIki6GqIikVDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qD+FYs7m6zTSliZV0Z+RmSNQpc/AJ4GreD4JQ1t6eNY5PXzBorMwx8GfdugnB6NDBva72EK7lzuAz30bGtR1b9kf5oz0mKxq8zeL5pyEm8E5H1UqN4xPKmo1npq8oBqXwwX21WLwerGjic3WoXznw0tYQK78EtOpJKB09r615Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d/4pmxeJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A7BC2BD10;
	Tue, 11 Jun 2024 08:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718093195;
	bh=jCn0oX3HrJ6Qlcw/LuQoAhJRxhLaDvFIki6GqIikVDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d/4pmxeJzHoEeQ+g2h36PLWMNipYFVLUgldUlVqiJ/oHVrEeGGWvSVD8Qj0WOLs1h
	 W+bfZgsci1Mj1j7xr+uUvjowbUTryqU8M7niWdxvm06YM2JVc8jmnbjYFRmHHcrBjc
	 35EtrgT1CO5oyRbn/EfIn5kNPHJPwVOwHupvi057HyipWOQnDb4p6IBWsy9PJTe2z7
	 aguwef6PSD/S3jnHhAFsQmA+8/MCfLVtbrqTe0OoYvK6gaKfrbg4IMTS8YbzdTrpnX
	 ruwuQZ89i04k1WQRZE0wdLm48U3gwb4DUnNOpOrrhv3eKIrI6XQd7uuU3njn1J65js
	 90POvgbQ696Tw==
Message-ID: <0f01ed9c-6f85-427c-9690-1551e67e46a9@kernel.org>
Date: Tue, 11 Jun 2024 17:06:29 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/26] block: move the add_random flag to queue_limits
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
 <20240611051929.513387-16-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-16-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the add_random flag into the queue_limits feature field so that it
> can be set atomically and all I/O is frozen when changing the flag.

Same remark as the previous patches for the end of this sentence.c

> 
> Note that this also removes code from dm to clear the flag based on
> the underlying devices, which can't be reached as dm devices will
> always start out without the flag set.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Other than that, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



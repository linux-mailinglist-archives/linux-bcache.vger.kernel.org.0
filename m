Return-Path: <linux-bcache+bounces-642-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 533E190A534
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:18:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF0F628E54B
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55933188CC2;
	Mon, 17 Jun 2024 06:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOFdmVOJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E21A1836DF;
	Mon, 17 Jun 2024 06:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604867; cv=none; b=YSOituNSdTzeHbE/0BKRdPDK60PplqOm+xj4CftS5uDtRuh7BwtfiuCW6WlIfKksZ/WyWfQwodkFdMgordolu8108gCsKa/q3QdMxuJqydvOgDMuzEffJ8RKN+JkFH4NYIMc7J1tN4vnMqP5SlwIMoNqgEaa5XZnfaADnFrPqHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604867; c=relaxed/simple;
	bh=0lJUnETFqPY6tW6TrXFvmKZbVynd6dSdhAW9BC6m+kE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oTNPMja4xMNV6WvFcipU5h1j7bEIX+qSb2FAlT5iTr7RsDUCqO/ObQvyHUq/MTCgr+Lc2q22GxTI3yCSB2ANg5as74P0ReJNbq8dEyZyL1gNVnJvK8ZYwW2Ipu+1bP1csLhJ6l89hSAfwPVLFZpBAn5DStqfHSEe9i7wpGA04Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOFdmVOJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD93C2BD10;
	Mon, 17 Jun 2024 06:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718604866;
	bh=0lJUnETFqPY6tW6TrXFvmKZbVynd6dSdhAW9BC6m+kE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KOFdmVOJ7h8N9C7m0i5IH5j0T08893gjt00viGEXx0ITrjnEVSc7/n9x0PQNWhoCT
	 R0G81HXchAoQj63QO9zRTuNrWvr+9t+JPXFgDrlIxVtX306FULncwLvEYKw7dkrJFz
	 S6g5cy4QX7ofX49F8f+GhBjuuHoOe+F7NO0rxdIU4Xo0KJqwPt8S0uxmuFJz89cUcE
	 b/qPpB1pTQXoj1rhBApU3rTIJGnWH/qdRZJ9WOKQ+vU7PAj3CbnFFbcYvIj/VggV6B
	 QjSaWBl2euqvrvUDeNk514rvS2oC47UJWpHbvgG7uFw1q8j7/c3YYf4Afd7F+Ekvnv
	 W3vwVHRQv5iRw==
Message-ID: <d7b45e0b-68a9-4612-861a-7f192fbe6f84@kernel.org>
Date: Mon, 17 Jun 2024 15:14:21 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/26] loop: also use the default block size from an
 underlying block device
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
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-8-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240617060532.127975-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/24 15:04, Christoph Hellwig wrote:
> Fix the code in loop_reconfigure_limits to pick a default block size for
> O_DIRECT file descriptors to also work when the loop device sits on top
> of a block device and not just on a regular file on a block device based
> file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



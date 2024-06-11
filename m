Return-Path: <linux-bcache+bounces-551-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA60490338F
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 09:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A007A1F2A2FE
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2F38172764;
	Tue, 11 Jun 2024 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTBp4slD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D33315AAC6;
	Tue, 11 Jun 2024 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718090891; cv=none; b=T/pmsU9VRpBcn7VMXrFg45q3EfGpP+2uQGUU8KoZTDi+0mebkTBbKfzMRzOpRIz5xzxZmlRXZG/xuY1AfeJ4tSm0keSEMmphjREVzKB0jnNr+ErPVovtyrtSAuLbGsJJ+2D04p6w95jOQQGCMSQo3CWyYTyXyiFMrx3OCy8n3zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718090891; c=relaxed/simple;
	bh=PzNpxodKMaXzOrbrQbgP0Usp5K8OR/0f+y46RXYG5GI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dgwaJXwklg/usm7xI9FdClqUW8Kd2s6V+rx/JMHtMQNMJ2anMv7MDcKhmyBrP2wCxeqtMTPahnxgVD/eztc16qlU/+hV7alPDVHRjcvuiQW3wR7YYpcBykwAx/w7EIq/hhfV5dK4dtJ8S3va+LeJe7m85emjBg94T/m2oWNl6Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTBp4slD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C86C2BD10;
	Tue, 11 Jun 2024 07:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718090891;
	bh=PzNpxodKMaXzOrbrQbgP0Usp5K8OR/0f+y46RXYG5GI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LTBp4slDow5NcmeSUO+en/N5x+IvZpqfr4dZ5xfX2JzmBZDcu3dZh1tN6fO3CqfN5
	 fC9Rl/OM4T8uVQSZE7K0T1VbSc5kGVEloD8CTTVrPkbvI0U3LUhjHwjw0gYgT6m0wL
	 fsRPyDZqXTT6dQCkbhnlW45jwonhukSCr4JLmJKisZxNZLowwOQwk30YR8lK0/xTNh
	 Ya4myshjfW/7uX8nEJDGL/WMaUQq8CNmicSbttSzKnr2l9hJq0Cmz3iSLAwvK+uere
	 9vcVlwnm7Ycw2p4k6Qg21I4xZXBRD9ik7edbDXJpFSNi3bC1udvNreNPZ0wJBOp6Lf
	 6blq/N52Sp8VQ==
Message-ID: <d1bff26d-0059-4122-8179-75a1b72f3cfc@kernel.org>
Date: Tue, 11 Jun 2024 16:28:05 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/26] nbd: move setting the cache control flags to
 __nbd_set_size
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
 <20240611051929.513387-10-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move setting the cache control flags in nbd in preparation for moving
> these flags into the queue_limits structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



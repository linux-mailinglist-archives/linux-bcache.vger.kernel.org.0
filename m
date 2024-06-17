Return-Path: <linux-bcache+bounces-645-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F4F290A5A4
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BAD11C2652B
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04741850BC;
	Mon, 17 Jun 2024 06:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVa4VXa4"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1781822F3;
	Mon, 17 Jun 2024 06:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718605589; cv=none; b=GXVwMdMmU6LdsyA6iCKdF85NBSnyPhCqRFGVjhQUvKMfmXhQJi1zKBj7xaD1OK0aFZYy8aqgyhkHKnQqmDmGgTxaj35HkDG/BctmidNVZ1/30gwNrTqx+GrL7b0UAbk9NFzMP9bPcmykpDOQsK22Fxn57FDhzHgkBHBIjbHfE4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718605589; c=relaxed/simple;
	bh=5ukl1My1jMqhSyTqZEFqdGlI+72qAecy5V2ti5Kc46U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eS1CAG9ixn7Y+VSNE6byZVc8CNzyjNkpGUnwwey3TLWcyF1QQvtwGjDdtxm7OMESpfCIYjbwrQU2zIUVeF08vq1QN+OL4QG5sEzt9CEVcBGPnyx7+OmIEBesD8PEYQ+qNQ904xf5dewlwBAhc54Af7342kOwqGBKXCoVB7319QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVa4VXa4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897D7C2BD10;
	Mon, 17 Jun 2024 06:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718605589;
	bh=5ukl1My1jMqhSyTqZEFqdGlI+72qAecy5V2ti5Kc46U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OVa4VXa4gPyN4KTWboLud3pwf0TJbbk/rQ5BM4+Ufc5q6edplugfrWWUEhonGkfMR
	 QHtsT5neG8mJ3vHyVK4COzgFtMwuBSA3Ltr1Kmgg0P9h/SDaPK/4D4vixnSs7AOdoo
	 HP6agM24471d/vJb4Hh8SFe0zewqIqWCGc3aXNawn13hq27CQJOtkzwEi0TWYKBp4l
	 c0TLeE0D0RKiKV3rNJyqOIzjVOG/87Bt7edT59MQLl5UfWjsDRSx6vZMzrYnvW4QJA
	 /RoDuAqhbb/WQma0tOFHLAJHwURkZ+Z0rxy3rGxoovWXWM4rnyYIVDHULrocVjTDvQ
	 k66Zct4kG1uEw==
Message-ID: <c9871979-de72-49ca-879b-5f2bd773d517@kernel.org>
Date: Mon, 17 Jun 2024 15:26:23 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/26] block: move the nowait flag to queue_limits
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
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-20-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240617060532.127975-20-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/24 15:04, Christoph Hellwig wrote:
> Move the nowait flag into the queue_limits feature field so that it can
> be set atomically with the queue frozen.
> 
> Stacking drivers are simplified in that they now can simply set the
> flag, and blk_stack_limits will clear it when the features is not
> supported by any of the underlying devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



Return-Path: <linux-bcache+bounces-687-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4888191550D
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jun 2024 19:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7990B2595D
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jun 2024 17:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8482119EEB1;
	Mon, 24 Jun 2024 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d8C/s3Ng"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC301EA87;
	Mon, 24 Jun 2024 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719248903; cv=none; b=Ak3u/B+r6+h3FmaclxeeDgT0Prv8sodSjcnPYVj9RxtAkpgHrU5J/SlQqORE8vbwZidDO1L0VGFhvqV4yadQhSpSOt9BnUp+KMNh+3tInSB45ELPupdIhhgzAc1DefO3hipvX/cGJlDDTURyvR9kVaTQRvfbvg2/dH4GjZPImUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719248903; c=relaxed/simple;
	bh=c5IMwi2AkSm61J7nCdd2EBXV6o3vo+7AANeGa2JN45A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBJ8TZyaH8WIj2Ts6Q4p6lV2Ty+f6miWRlG1702oDfCCd8MuzgjAxCrcD9E/BqqIYkgMTUjwrncYv+xjFEFBJL/4Q13pgvZRQ3FgyGsc/2HrdI81eMRNZuHojM/0NHXCmYLqGuZq7DE0D7kPuMlWWFTG6l3N7g2zwrg8gEasji0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d8C/s3Ng; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682D2C2BBFC;
	Mon, 24 Jun 2024 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719248903;
	bh=c5IMwi2AkSm61J7nCdd2EBXV6o3vo+7AANeGa2JN45A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d8C/s3NgDhBmDzX7X6Z3a8NgLG1XRNWm3AVon41eJewAqY4XNmD50+AdQpjukysaA
	 0+c9peZEcs8AURzleAxgVmV3zaxrAP0+WMQxnkR3oNoVdRegLrw7QTozLmVentUZPE
	 P0BMSL1dkoExQoFoaBFFudfcpEmdYCHeKJ0irUoLxUFwgxCKTvfHLKHNHL2RN4iLoh
	 ki4NFa+liGK52kKToNiMhO53pIJVSGFwHndW7Uw+1UTH4eb3kjlEU/UFxvZz4PM4y3
	 BbdO/dVn76ts+09ZmrGp9NorxeNYJ2cNYzLcTNejNMPSMmam7/bl5ZZAKhBMTTCFIl
	 W6hH1Idyq3vZQ==
Date: Mon, 24 Jun 2024 11:08:16 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
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
	Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 14/26] block: move the nonrot flag to queue_limits
Message-ID: <ZnmoANp0TgpxWuF-@kbusch-mbp.dhcp.thefacebook.com>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617060532.127975-15-hch@lst.de>

On Mon, Jun 17, 2024 at 08:04:41AM +0200, Christoph Hellwig wrote:
> -#define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
> +#define blk_queue_nonrot(q)	((q)->limits.features & BLK_FEAT_ROTATIONAL)

This is inverted. Should be:

 #define blk_queue_nonrot(q)	(!((q)->limits.features & BLK_FEAT_ROTATIONAL))


Return-Path: <linux-bcache+bounces-663-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C2C90B3B0
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 17:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B5B91F28A37
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 15:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97D6158A37;
	Mon, 17 Jun 2024 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eD5n/nvW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFF0158A05;
	Mon, 17 Jun 2024 14:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718634907; cv=none; b=KiM+GgE2CCBVWpN14REjdiO72KjyYUmBKg67cledLbY/epVdRh6CJP+Vf0f9Uo4SErntKCp1kHdg+6oafnVXLfqlUJ6HvnhRrxu5ZIwGltQ4+RyGI82xdYmCDyMCmsPT031/CCSitVczlum9qoR1P2zh8dMEanXHjwTf65H3FjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718634907; c=relaxed/simple;
	bh=zR4PmzG8eM11uEea9QT6dpcyWJEpQ/sobqtYRuY7p2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqxtyjYTm+h4cPOpB1NvrWKHldAZ4h173Lde+YoP6k2ni4/MzlbFBgoPS/eXrrTslI7YBsrMv7EbJzgVUcWcaxDA0Q/9e0VDr4hV3alIXfduWEOdvuCjvnEnwOm4OmK2R3gLQIJL9SWbQjN9sDXBVSCXExXRiR7GQyPxiiDyOgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eD5n/nvW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7346C2BD10;
	Mon, 17 Jun 2024 14:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718634907;
	bh=zR4PmzG8eM11uEea9QT6dpcyWJEpQ/sobqtYRuY7p2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eD5n/nvWPH0mROLi1mYqjLG+6CkIkCxCEDr7KHYv5mCJ6cJ3axvL3iUR8FSfF/NAJ
	 aWF+hMFp26+MYq12L40CvD0LxAzWJTFIpFvJFlT/13JJ1EJCWWsc/XXuMYInx3fYPk
	 PVqFFZp9qinzyqQ1wbJp1uQUpFSEgZjA7/AJ/D87BnMG71EbVAfG4CFQOyKDe6kjS2
	 0qjhzv59DCAwJqh60nhssiSotn3a1GiLXJljndQUFTrzdMkRj7pO46aG6KaDjyXOpw
	 MXJnwDrZxtrM68cj9z93ToW3XbCMjuJFfQuHw/qbhAPx1AOR5+hjUoIbpzcdxhC3Vq
	 UbiPTmWDLBjCA==
Date: Mon, 17 Jun 2024 08:35:02 -0600
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
Subject: Re: [PATCH 26/26] block: move the bounce flag into the features field
Message-ID: <ZnBJlix63Fj_G1px@kbusch-mbp.dhcp.thefacebook.com>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-27-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617060532.127975-27-hch@lst.de>

On Mon, Jun 17, 2024 at 08:04:53AM +0200, Christoph Hellwig wrote:
> @@ -352,7 +355,6 @@ enum blk_bounce {

No more users of "enum blk_bounce" after this, so you can delete that
too.

>  struct queue_limits {
>  	unsigned int		features;
>  	unsigned int		flags;
> -	enum blk_bounce		bounce;


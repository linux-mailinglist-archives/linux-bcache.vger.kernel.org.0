Return-Path: <linux-bcache+bounces-600-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6621904A70
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2024 06:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDACA1C20C87
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2024 04:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 651882D057;
	Wed, 12 Jun 2024 04:58:35 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CA428385;
	Wed, 12 Jun 2024 04:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718168315; cv=none; b=k0CRDapt8wdRAN+vO1CTkWpPW0m12DXCNjQ0fc3XUG6CdWaB0ezlak4+oiUcYKd4ur5Vu+qhal6g9JzUJAsmRMjwvfS0w3DvlJi49x679fhWQrWkVumeCVZL3xZKnh8SlnPgDlB8gh+vXIu0RwA8uxPxrOvk9NaJJ9RZ+mUm95Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718168315; c=relaxed/simple;
	bh=SAXdlm2t78uvwP6lbGBucu+NXd4/mt1SXHOAWS3+Nso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AbG/+5cV3Q/bWtE4JgiATiQ2D3MZ3yA1mlg+lszVu760ZvHmTtrA8mnfcnrA8h1G5nTkUlV9jhPP0w1l6vkwN9Z+LzMn/DbEWDC/SaDClSWzB6y9GiLYhBct9KoaGg28oz1s11tJtrDYxPQwz+XfnI+SUQZiu/MCfN5OsiDhfrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6FC9B68BFE; Wed, 12 Jun 2024 06:58:28 +0200 (CEST)
Date: Wed, 12 Jun 2024 06:58:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
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
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 16/26] block: move the io_stat flag setting to
 queue_limits
Message-ID: <20240612045828.GC26776@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-17-hch@lst.de> <d51e4163-99e3-4435-870d-faef3887ab6a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d51e4163-99e3-4435-870d-faef3887ab6a@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 05:09:45PM +0900, Damien Le Moal wrote:
> On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> > Move the io_stat flag into the queue_limits feature field so that it
> > can be set atomically and all I/O is frozen when changing the flag.
> 
> Why a feature ? It seems more appropriate for io_stat to be a flag rather than
> a feature as that is a block layer thing rather than a device characteristic, no ?

Because it must actually be supported by the driver for bio based
drivers.  Then again we also support chaning it through sysfs, so
we might actually need both.  At least unlike say the cache it's
not actively harmful when enabled despite not being supported.

I can look into that, but I'll do it in another series after getting
all the driver changes out.


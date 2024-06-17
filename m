Return-Path: <linux-bcache+bounces-611-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B655990A329
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84041C2163C
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 04:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BF1181317;
	Mon, 17 Jun 2024 04:54:04 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2F17BB18;
	Mon, 17 Jun 2024 04:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718600044; cv=none; b=XgnVn05Jh4ox5aGBhUZzHw9xgUFXpCM+s/ld2095ZwqQj7ULEm1pj3042HawNmSHKuoGCGbiB0ynjkQAXrMkJPvRPHrc+MlZOF5jqvsKzbV9/pcYhNgEd91dk0ZmxgZx/NIibAq76bPO4wyD73wmfAbQuu2f39wejGB0ybmlef0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718600044; c=relaxed/simple;
	bh=f51eJuLD+jCJwPBEqnxoATJev9gS6I2x2ghJMdgsL3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INidu/Db80+BW7spXY57nZoNGhlM8JJnujvNJm2CGaeIit81xbOZdU9Jg1Lzw7kwriIUJRkKrJ1Z/xDxtvOedMRbrJ6fXQusI8h3GxP+Gh9RgYXG+Zews6n2PIqYoEssa1h7OSp4PATpJ5VaMW0tenGYnrKcDqUeBw59QNDZgxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB40668B05; Mon, 17 Jun 2024 06:53:56 +0200 (CEST)
Date: Mon, 17 Jun 2024 06:53:56 +0200
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
Subject: Re: [PATCH 02/26] sd: move zone limits setup out of
 sd_read_block_characteristics
Message-ID: <20240617045356.GA16277@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-3-hch@lst.de> <40ca8052-6ac1-4c1b-8c39-b0a7948839f8@kernel.org> <20240613093918.GA27629@lst.de> <5a697233-0611-459d-b889-2e0133bbb541@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a697233-0611-459d-b889-2e0133bbb541@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 17, 2024 at 08:01:04AM +0900, Damien Le Moal wrote:
> On 6/13/24 18:39, Christoph Hellwig wrote:
> > On Tue, Jun 11, 2024 at 02:51:24PM +0900, Damien Le Moal wrote:
> >>> +	if (sdkp->device->type == TYPE_ZBC)
> >>
> >> Nit: use sd_is_zoned() here ?
> > 
> > Actually - is there much in even keeping sd_is_zoned now that the
> > host aware support is removed?  Just open coding the type check isn't
> > any more code, and probably easier to follow.
> 
> Removing this helper is fine by me.

FYI, I've removed it yesterday, but not done much of the cleanups suggest
here.  We should probably do those in a follow up up, uncluding removing
the !ZBC check in sd_zbc_check_zoned_characteristics.



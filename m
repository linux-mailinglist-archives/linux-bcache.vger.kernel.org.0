Return-Path: <linux-bcache+bounces-538-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0308D90319E
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC9981F24E1C
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89E017108D;
	Tue, 11 Jun 2024 05:52:46 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D902E170842;
	Tue, 11 Jun 2024 05:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085166; cv=none; b=j3pjcX4WP+pFN6ePVRCZXkLfZsSAbNOWAPcmwMs2/aZiHLIASp3QpIE1Xhp6dvPiu8yvhQZEpGWGzhJ1yGucdt5PsndqX4DP9gotwtBw1mhvOowSEugme4K2PFvYo/BsgVxZKUcabY6IwNCXBYrRL5XmMlw9qbMxF9Kjl8Y1y4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085166; c=relaxed/simple;
	bh=CEpp2YDI0ZOF94plOE1UU/+3yRuFfIBCruUI1vIIj+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E138qGrCmSPHphaNgAfs+406CipH5ul3vL4dVq9RQ36iD7s7v9JwHLATeiF07i8m89mImLWVoUqZ7HOBKnXOyinGbmLYaNwb4Ro8Xgm+DNqo9USzzROC9SSW7IGZAF1QWjJpT5l9WWpEZMvCd1flxioJmo7db7A9ScIAzRPZ4I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3636D67373; Tue, 11 Jun 2024 07:52:39 +0200 (CEST)
Date: Tue, 11 Jun 2024 07:52:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph B??hmwalder <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Roger Pau Monn?? <roger.pau@citrix.com>,
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
Message-ID: <20240611055239.GA3141@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-3-hch@lst.de> <40ca8052-6ac1-4c1b-8c39-b0a7948839f8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40ca8052-6ac1-4c1b-8c39-b0a7948839f8@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 02:51:24PM +0900, Damien Le Moal wrote:
> > -	if (lim->zoned)
> > +	if (sdkp->device->type == TYPE_ZBC)
> 
> Nit: use sd_is_zoned() here ?

Yes.

> > -	if (!sd_is_zoned(sdkp))
> > +	if (!sd_is_zoned(sdkp)) {
> > +		lim->zoned = false;
> 
> Maybe we should clear the other zone related limits here ? If the drive is
> reformatted/converted from SMR to CMR (FORMAT WITH PRESET), the other zone
> limits may be set already, no ?

blk_validate_zoned_limits already takes care of that.



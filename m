Return-Path: <linux-bcache+bounces-694-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC8DF9178C0
	for <lists+linux-bcache@lfdr.de>; Wed, 26 Jun 2024 08:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88303B2248B
	for <lists+linux-bcache@lfdr.de>; Wed, 26 Jun 2024 06:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C831E14D715;
	Wed, 26 Jun 2024 06:18:10 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E413A88B;
	Wed, 26 Jun 2024 06:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719382690; cv=none; b=pjvuXJbQBPgMFEbgyoD9SVAZmbBkmjc/CGoA6HncJ3xNrbpEcuPgy4hw4JrnCh8ydjRi/PDPY9TEYZI5hR4n+r2y3Wsvq38zuS3bcEdDnQrz+JCNmAto21VJMeqnc9ItUYFSfZZYGkgH/lWhX/eO66v4CPt8NANZDlFxXw7F2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719382690; c=relaxed/simple;
	bh=xexNyQLOtrjNiS8Ln7SBcgYZbXn8BHeCquAeOp7gjzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7W3sP7bqXx198dStcrPWPWInyvS6AdShbq7DIND7Idf89rQK+d447w4NomX/DzVcvWG9bJoCsconkRGY5NzHVg9IdakQtDX4Waz+Yn6kfYTk8qcd/pXNiC1G8eJ03bMHINNsEfnGAk7X0z+7VEW/iR7l24prCd8vh7O5fvGBBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 85E4B68BEB; Wed, 26 Jun 2024 08:18:04 +0200 (CEST)
Date: Wed, 26 Jun 2024 08:18:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Oliver Sang <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>, linux-m68k@lists.linux-m68k.org,
	linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
	nbd@other.debian.org, linuxppc-dev@lists.ozlabs.org,
	ceph-devel@vger.kernel.org, virtualization@lists.linux.dev,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
	nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	ying.huang@intel.com, feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [axboe-block:for-next] [block]  bd4a633b6f:
 fsmark.files_per_sec -64.5% regression
Message-ID: <20240626061804.GA23481@lst.de>
References: <202406241546.6bbd44a7-oliver.sang@intel.com> <20240624083537.GA19941@lst.de> <Znuw/4zMD4w5Oq2a@xsang-OptiPlex-9020>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Znuw/4zMD4w5Oq2a@xsang-OptiPlex-9020>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 26, 2024 at 02:11:11PM +0800, Oliver Sang wrote:
> hi, Christoph Hellwig,
> 
> On Mon, Jun 24, 2024 at 10:35:37AM +0200, Christoph Hellwig wrote:
> > This is odd to say at least.  Any chance you can check the value
> > of /sys/block/$DEVICE/queue/rotational for the relevant device before
> > and after this commit?  And is this an ATA or NVMe SSD?
> > 
> 
> yeah, as Niklas mentioned, it's an ATA SSD.
> 
> I checked the /sys/block/$DEVICE/queue/rotational before and after this commit,
> both show '0'. not sure if this is expected.
> 
> anyway, I noticed you send a patch [1]
> 
> so I applied this patch upon bd4a633b6f, and found the performance restored.

Thanks for testing!



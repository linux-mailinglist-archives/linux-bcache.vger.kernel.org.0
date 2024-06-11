Return-Path: <linux-bcache+bounces-545-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB729031F7
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 560A71F22E5A
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A8B17166C;
	Tue, 11 Jun 2024 05:59:14 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829EA17085D;
	Tue, 11 Jun 2024 05:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718085554; cv=none; b=FNZQ9noFTMqletWy/FxZknmSPDNB7t/uB2AmS5fJoMz+L2tYbAY0bXeRLYM0CdeqOy5g0X1Z7FyBjrPZCi/R2Sn3Eo53lS8hcv6x9gUiUh1xLy1OUSTswxxmE2Bbph0SLl828q65Z8K/W02jUgyDlex168bOIQGN29JTfe078xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718085554; c=relaxed/simple;
	bh=cnjedp2uVnzEopZTQQoYup8KDP0AjEtAiNcdLbnmZME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzHpXy0YPEoFfguoBfIXKctGQVKR/iLM42t4Jt5tKMxnkVUu1W2a0enGlY24m7ZQNlPhedVEwDKxKYw/Ieo4qP59fo8MlsvJvrw4bWpY2oBzKyJxkmUGRUV1IkT3gt9svP0NKrw3HKxyam5ID14Ln+Q3KCt3dj5KptNAffZ0wnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B7C0F68CFE; Tue, 11 Jun 2024 07:59:06 +0200 (CEST)
Date: Tue, 11 Jun 2024 07:59:06 +0200
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
Subject: Re: [PATCH 05/26] loop: regularize upgrading the lock size for
 direct I/O
Message-ID: <20240611055906.GA3640@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-6-hch@lst.de> <dabc33cd-feb9-4263-8f6e-4d2ab3d71430@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dabc33cd-feb9-4263-8f6e-4d2ab3d71430@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 02:56:59PM +0900, Damien Le Moal wrote:
> > +	if (!bsize)
> > +		bsize = loop_default_blocksize(lo, inode->i_sb->s_bdev);
> 
> If bsize is specified and there is a backing dev used with direct IO, should it
> be checked that bsize is a multiple of bdev_logical_block_size(backing_bdev) ?

For direct I/O that check would be useful.  For buffered I/O we can do
read-modify-write cycles.  However this series is already huge and not
primarily about improving the loop driver parameter validation, so
I'll defer this for now.


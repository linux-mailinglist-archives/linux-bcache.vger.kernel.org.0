Return-Path: <linux-bcache+bounces-703-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD29A93C138
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Jul 2024 13:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAA021C21940
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Jul 2024 11:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553A0199224;
	Thu, 25 Jul 2024 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=uter.be header.i=@uter.be header.b="HRSnzfY+"
X-Original-To: linux-bcache@vger.kernel.org
Received: from lounge.grep.be (lounge.grep.be [144.76.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24523C3C;
	Thu, 25 Jul 2024 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721908683; cv=none; b=T6O4KC99b08b+g+WWGqY8FZEe1qOcoUmJTNxAJ/eFLguczN5rReawo91ht6N+gMpbapMr3Z/1oLF3T4TSaKk8a0NLq581AgTnMLn34hQQYHI5GRs+Mq4bm6DNlYnzn8ykfKaYWmnGZlrA82BESQZV0eRdR80xtcXCF/sp6Y6EYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721908683; c=relaxed/simple;
	bh=SUGuNHYDGosNycUsgB3AByvAAi9UaKUxeW+YSC9jcyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzvJeReR8fKFPiAdwy7sdOG8OAge3ZGHb2wvDKg/Mn/0ZT2/9jLKDKf+Et4HXwrocgFXzVI+z1wKxI3qApuSwv7OMqmBQFUG3aqzhkybfMhIfgaZIUNc4JsFM6N0smbKlZJ87az7v80bQYCL71QMyB7cGTto17V914xdsLGAHaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uter.be; spf=pass smtp.mailfrom=uter.be; dkim=pass (2048-bit key) header.d=uter.be header.i=@uter.be header.b=HRSnzfY+; arc=none smtp.client-ip=144.76.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uter.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uter.be
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=uter.be;
	s=2021.lounge; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A2VuDAKeSGGGRwdNEgASvdRePK2jE6LTgdknFzfGiVg=; b=HRSnzfY+SxqUo9lzjJBHswdyNO
	izEqhcP/7tFCFgJJGzzhTZHV+hkIJ95lvet5keDsrZB2SVJh4LM2TT0rY+nfGtvBDiOATcCiQ/ZZp
	NX14nRCfBdImELKCJsEds0YwtB87PNneYsFwhe69klvX8hKaVd3bPAdUOO5oKLpwqsdI1TpEV3xHA
	zPeruYumASMydrGBh8+RD0p+DiFqZyJ0vUaImcbHlwd7Aik2LDO+RgK3xJUkwPiJj9pwJIeGrrPKF
	y3yZwQEUsA40VBWzlQvQ+rZPVwPFNOT65DR9yRxPQziuObFSyUbJuGiw7PBH1R7FTtIfgagxi0sHi
	wC/6XZ8A==;
Received: from [102.39.153.168] (helo=pc220518)
	by lounge.grep.be with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <w@uter.be>)
	id 1sWwlF-001dJr-31;
	Thu, 25 Jul 2024 13:35:53 +0200
Received: from wouter by pc220518 with local (Exim 4.98)
	(envelope-from <w@uter.be>)
	id 1sWwl8-00000002sGZ-0mps;
	Thu, 25 Jul 2024 13:35:46 +0200
Date: Thu, 25 Jul 2024 13:35:46 +0200
From: Wouter Verhelst <w@uter.be>
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
Message-ID: <ZqI4kosy20WkLC2P@pc220518.home.grep.be>
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
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: none

On Mon, Jun 17, 2024 at 08:04:41AM +0200, Christoph Hellwig wrote:
> Use the chance to switch to defaulting to non-rotational and require
> the driver to opt into rotational, which matches the polarity of the
> sysfs interface.
[...]
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index cb1c86a6a3fb9d..6cddf5baffe02a 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -1867,11 +1867,6 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
>  		goto out_err_disk;
>  	}
>  
> -	/*
> -	 * Tell the block layer that we are not a rotational device
> -	 */
> -	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
> -
>  	mutex_init(&nbd->config_lock);
>  	refcount_set(&nbd->config_refs, 0);
>  	/*

NBD actually exports a flag for rotational devices; it's defined in
nbd.h in the NBD userland source as

#define NBD_FLAG_ROTATIONAL     (1 << 4)        /* Use elevator algorithm - rotational media */

which is passed in the same flags field which also contains the
NBD_FLAG_SEND_FLUSH and NBD_FLAG_SEND_FUA flags.

Perhaps we might want to look at that flag and set the device to
rotational if it is specified?

-- 
     w@uter.{be,co.za}
wouter@{grep.be,fosdem.org,debian.org}

I will have a Tin-Actinium-Potassium mixture, thanks.


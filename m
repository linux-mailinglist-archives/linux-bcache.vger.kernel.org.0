Return-Path: <linux-bcache+bounces-686-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C12019151E4
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jun 2024 17:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 631D01F22F66
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Jun 2024 15:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1236F19B3ED;
	Mon, 24 Jun 2024 15:20:37 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454A51DFEA;
	Mon, 24 Jun 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719242437; cv=none; b=g+65n3b9JqXhlldieqHuhXDpfi+12aGrwSi49Dd35nG0Z7EmLrMJZUbl6YZcFsOHmyoGRyTO3zvG4h3I/jiYID1sJxWm+NOSs0fnR28YxC6YROPFvOPVDe7lFRDBpd9YH/5i09HuoB1XikQTCaKB9JrsZ0jqWoTghGExPhAd/+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719242437; c=relaxed/simple;
	bh=/E9O2ottwm4ttwGeO0wU48nA9Dao832H9uEl8uWGVRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oO2uPLbjYj26viXxV2QCI0+ogiZjtrsVggrltLcnDkrT//UClxADbovlPTXOoDn/NmO/Cn7MbTbxCCGdrLonLgdkaRCG0wj/KnR+l0gjaNWVjTM2IG40T8U690wZLAayq2SPMAULWx7OjQJ6+crzOyMURezvRZvwTlQt70sBFio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AAC0B68D05; Mon, 24 Jun 2024 17:20:28 +0200 (CEST)
Date: Mon, 24 Jun 2024 17:20:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, ying.huang@intel.com,
	feng.tang@intel.com, fengwei.yin@intel.com
Subject: Re: [axboe-block:for-next] [block]  bd4a633b6f:
 fsmark.files_per_sec -64.5% regression
Message-ID: <20240624152028.GA11961@lst.de>
References: <202406241546.6bbd44a7-oliver.sang@intel.com> <20240624083537.GA19941@lst.de> <Znl4lXRmK2ukDB7r@ryzen.lan>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Znl4lXRmK2ukDB7r@ryzen.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 24, 2024 at 03:45:57PM +0200, Niklas Cassel wrote:
> Seems to be ATA SSD:
> https://download.01.org/0day-ci/archive/20240624/202406241546.6bbd44a7-oliver.sang@intel.com/job.yaml
> 
> ssd_partitions: "/dev/disk/by-id/ata-INTEL_SSDSC2BG012T4_BTHC428201ZX1P2OGN-part1"
> 
> Most likely btrfs does something different depending on the nonrot flag
> being set or not. (And like you are suggesting, most likely the value of
> the nonrot flag is somehow different after commit bd4a633b6f)

Yes, btrfs does.  That's why I'm curious about the before and after,
as I can't see any way how they would be set differently.  Right now
I can only claim with vitual AHCI devices, which claim to be rotational,
though.



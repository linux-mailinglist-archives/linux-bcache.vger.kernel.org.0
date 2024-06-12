Return-Path: <linux-bcache+bounces-602-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A59904A93
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2024 07:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6CDF285D2F
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Jun 2024 05:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0901364BA;
	Wed, 12 Jun 2024 05:03:48 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AFA2BAE3;
	Wed, 12 Jun 2024 05:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718168628; cv=none; b=hT+pgGcqJo6qy9QSXGWxUgLnkwFc3kZprB8FiEabIL0WDzY6/IjWJ69O01n760Arbd+GGYUSSeNtA/He5gRJ1HQqT3ILp3fYZkX1o0ZI83pWZc8bkCx7kXSkQndx+iZKI11mj7ss3gDx4g3Cqyy9QrIH0rsYjGlFJvAmkP2h/G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718168628; c=relaxed/simple;
	bh=yideDWBgYhb8gdrUDek21Tjymn+mofyCK/oOHbACXbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OyQEHCkrJ/aNq7QiFnqHXJ+vJy+MCBbnrUmj0UvvbgGUaivx9S6U7pdXMuG2EbEb0oonhD7Jf9XY7JJo9tYJ2A2JrXcZ+EPg6eFD6YKfh/XLvNsf9G0+UsM6KoAIoZd0VQxPBxXA+BDctoo7bGlrS8iKuaTQLgy+ppZnfFzCHvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0069168C4E; Wed, 12 Jun 2024 07:03:41 +0200 (CEST)
Date: Wed, 12 Jun 2024 07:03:41 +0200
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
Subject: Re: [PATCH 21/26] block: move the poll flag to queue_limits
Message-ID: <20240612050341.GA27049@lst.de>
References: <20240611051929.513387-1-hch@lst.de> <20240611051929.513387-22-hch@lst.de> <d1775d3f-daaa-4193-9f68-06ec47563b35@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1775d3f-daaa-4193-9f68-06ec47563b35@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 11, 2024 at 05:21:07PM +0900, Damien Le Moal wrote:
> Kind of the same remark as for io_stat about this not really being a device
> feature. But I guess seeing "features" as a queue feature rather than just a
> device feature makes it OK to have poll (and io_stat) as a feature rather than
> a flag.

So unlike io_stat this very much is a feature and a feature only as
we don't even allow changing it.  It purely exposes a device (or
rather driver) capability.


Return-Path: <linux-bcache+bounces-644-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E29A990A58D
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:25:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78878B26EC2
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A491E1836DF;
	Mon, 17 Jun 2024 06:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEnK17zF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B601822F3;
	Mon, 17 Jun 2024 06:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718605522; cv=none; b=W3z+mRuc71iV96Oe1+cU5Uns+uzMJy9NRVgx28sEsTxva5vYP2a4B9Ig22v9RvHC7t+RsUxUJh5C+pq37IcGNr8YAVbjLNxCGhzSkT9xhiVDJSHoJuFhWDfKM/DFUTWfnYQWxwUKPmsdCwR/UPr1yx1cPHynzLhyzxvPh+lsazs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718605522; c=relaxed/simple;
	bh=b4C7oWXm6AiByOywGcEEC3GnqcHjFi/qcKpmuC4GSl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BC4xgqCBhLqu/SA5czubCk6BpS8H67C2CDyi0I57cUp8whHYm/vpOt+qcBP9hEx137xP+aYVo1qlXgpUULEC5RCiqI+x01zjqFLOwYWPMryO9y/lJ9Rwy8eqIfhmxlknUPTMJcfSgk298kqnRaBdFnpedAnNPrwcrIteP9GaEoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEnK17zF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B3DC2BD10;
	Mon, 17 Jun 2024 06:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718605521;
	bh=b4C7oWXm6AiByOywGcEEC3GnqcHjFi/qcKpmuC4GSl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LEnK17zFqe+hZOSDUj/tOYJPTbrEr/iyN4UNL0SmIILaSKuqTSJ4sjLsh83tbNp98
	 xMaGs3z4bHthSiIVUGgn6p6k1Hp4OFwjqTvBViQ5r26ZmMaTUT3kdJYmUDeoTb8K+4
	 jT0vLs8Spfa7yPWU+yf5YKwUzdEIRo48lJNdqGhIlmZTb6k7761bMjs2rcyd0Hfqhj
	 Vpk+ileeXJ565Q23YPjftwlXpdj9Xgx1bQhDcK36W/6YmID+8NvWJsHJ8cIkaSJCt0
	 a65W2bmG0g0iV3m+rrO4imip0sJi5o8S5QSdLa4VJ1pKGoVgY8bkQ22MoITZxj7f6K
	 IsTYJ2fK4dlcQ==
Message-ID: <dd4ca62c-fc36-4439-a1ad-c55250f8d1a8@kernel.org>
Date: Mon, 17 Jun 2024 15:25:16 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/26] block: move the io_stat flag setting to
 queue_limits
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Vineeth Vijayan <vneethv@linux.ibm.com>,
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
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-17-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240617060532.127975-17-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/24 15:04, Christoph Hellwig wrote:
> Move the io_stat flag into the queue_limits feature field so that it can
> be set atomically with the queue frozen.
> 
> Simplify md and dm to set the flag unconditionally instead of avoiding
> setting a simple flag for cases where it already is set by other means,
> which is a bit pointless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



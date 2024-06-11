Return-Path: <linux-bcache+bounces-561-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EBA903518
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3106F1C25033
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F98174EC2;
	Tue, 11 Jun 2024 08:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efMUQjqz"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BED173321;
	Tue, 11 Jun 2024 08:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093566; cv=none; b=sYu+SOxSSjc4qF0Jbih9kb1f6+53FiyFMIStLRf24A5gHShwpMeESOBiyDaIXvFHc3KmSCzeCjGZSST7MaolQln6raU/xULfg8dm5MF6Mad6OEtUQ2sFMPRIhkt+J7+8NfA4c42JQAu27LoZoYtBqRv/xwa5ZMj4YDzq4bAxDTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093566; c=relaxed/simple;
	bh=zMBbLHWiI0o4/6MjscYA2/ULza201WjvhSMdL22ilmQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ff2yLEktHNcSZKgmjSTcvptr/BrvLU4FohFQQRfkt+vxtTNsDuPXVuA0DCewEbhe5APyJNPicXPwNreNXLDBcX6gPPYJXevzeBJrlalJc6BbCx1o8E84C6ITj/PBUvYsKt/f24KOF/ymatzjao+KUj5egeqlo5IluMSOkotAgWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efMUQjqz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85352C2BD10;
	Tue, 11 Jun 2024 08:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718093565;
	bh=zMBbLHWiI0o4/6MjscYA2/ULza201WjvhSMdL22ilmQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=efMUQjqzDR6/6LZgdCczIkMTU67PAqpDM0RBu6vBwxbRTCrqV/SLQPjysAgXVIH+u
	 Gs7FwJjGTrCL01zQP92DMiL3AF1rQHaJ0EqlTORyNynpUYXTzsuY6sJ9mfoqPT1Tvg
	 BSo7cvDW+fM7fvH1aN5LdfHWfYWXWuQSJiOAXVL+z2KUCiOWthz8XV9sMCo6FSpXv+
	 2SHsDignO7grM22XDSxgAJ0znadsNiLDmWusigAzWpriOV5Y9jvSmQhMPwNSEb8Bvj
	 SvInHsx54FSttIPvfIwG30ulL5P3X40mKZipSzOnWLUzNb0kOcJMR/irZgSdTd0fnE
	 LJc4doaBwGC7g==
Message-ID: <a10087ad-8b2c-4a6c-accb-fb1e8015e704@kernel.org>
Date: Tue, 11 Jun 2024 17:12:40 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/26] block: move the stable_write flag to queue_limits
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
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-18-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-18-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the io_stat flag into the queue_limits feature field so that it can

s/io_stat/stable_write

> be set atomically and all I/O is frozen when changing the flag.
> 
> The flag is now inherited by blk_stack_limits, which greatly simplifies
> the code in dm, and fixed md which previously did not pass on the flag
> set on lower devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Other than the nit above, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



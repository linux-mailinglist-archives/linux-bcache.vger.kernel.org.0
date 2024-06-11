Return-Path: <linux-bcache+bounces-556-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF269034A2
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:02:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73D0E1F22001
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C40E1422A6;
	Tue, 11 Jun 2024 08:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVm1t8g2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31928173323;
	Tue, 11 Jun 2024 08:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718092955; cv=none; b=AxpG7E9JoN84FgUR4A7xZe6k3dqf0FsHp5x4A3hT9x0Fr5ytIOUzL0gqAxk5sGRY7lax3Prm1IJVu/bqG69N4w3YEqDp2ZRLbX4GLwAn7/NKOxWPGw7VYin51x1LBNIWCxGb7He20XhYnstGJww9pVZq+CsiCzj8LnNNgmL8K7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718092955; c=relaxed/simple;
	bh=9448E2ZQUrvNp7ZURrtI3/D86m7bLK+HS2+4F3/kAbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o4IJ3DBdSWfmm2Qi2yOfEKyhOwQ8hbWC1Kix1QKLEIdD9nT+Gi66czcpg/ClImhnte2XrPi1LnqaCUVx24L9V3PUyxo8lul/V0n7VVLQWfzgiV7553KQ7HMjTNObMsqhwNqtnI2N3DIljqSsB84FHjnjrKVvNgdAwaQDJhXfB9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVm1t8g2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD55C2BD10;
	Tue, 11 Jun 2024 08:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718092954;
	bh=9448E2ZQUrvNp7ZURrtI3/D86m7bLK+HS2+4F3/kAbo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cVm1t8g2Dmo9pyaeFexP0cVZp2V9+zrzLaosx0fHWpCgyVMjhJafz/YjIRFcP6e/N
	 JiQrRCWm2cXvKJW25gK4jKXdI9z1r5PiGAPnVoL3Jgi9iLA+RTBXO3LhS10/kQ9VJv
	 S0HFEAZmlsLJdqInbsOGCHZ7lARtlpYV0wnusyawzuHxpb/RclmLX5rlq1DxBTsAuq
	 DUc+w0vOa4IhkCXuAcAxPK35SsjdXOHX0tyGNoT44IBIj7FNuzH/TkqH47YX1TuM03
	 t8bqET45kpSSPx+5HvwwYL7yfxY/bG8VgPBzRal4b99z62CNkY4oDCrnC6ah7dxmTJ
	 PwVnGOKYPVpoA==
Message-ID: <01366bae-699e-45dc-bad1-9541883a8b42@kernel.org>
Date: Tue, 11 Jun 2024 17:02:28 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/26] block: move the nonrot flag to queue_limits
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
 <20240611051929.513387-15-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-15-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the norot flag into the queue_limits feature field so that it can be

s/norot/nonrot

> set atomically and all I/O is frozen when changing the flag.

and... -> with the queue frozen when... ?

> 
> Use the chance to switch to defaulting to non-rotational and require
> the driver to opt into rotational, which matches the polarity of the
> sysfs interface.
> 
> For the z2ram, ps3vram, 2x memstick, ubiblock and dcssblk the new
> rotational flag is not set as they clearly are not rotational despite
> this being a behavior change.  There are some other drivers that
> unconditionally set the rotational flag to keep the existing behavior
> as they arguably can be used on rotational devices even if that is
> probably not their main use today (e.g. virtio_blk and drbd).
> 
> The flag is automatically inherited in blk_stack_limits matching the
> existing behavior in dm and md.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Other than that, looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



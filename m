Return-Path: <linux-bcache+bounces-580-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01E93903657
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A87FB1F280C9
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C651A16F908;
	Tue, 11 Jun 2024 08:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ez17pQw3"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BC016F8EC;
	Tue, 11 Jun 2024 08:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094415; cv=none; b=JfYqH9qg07YPCP2FvArbrPGuODLpNzQWAw3rBR+sdHuNwCJWuMtqG1ultaEHvzTNvC7nHCr3g8nsgMsZE9bHbzwKt+G+2T533zFp6hmUgHWGLMIRWCQpbeZi9gCWrY9BNVew8BycP5fPlJnAE6SPFriPQU4ASMnNQEqCDwciX0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094415; c=relaxed/simple;
	bh=zPCa8xPO5T29Ue6m/rGvsIVSedmfYpv71DR4OREdVBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVE8dfBBMmyC6/5xGH6xIt5T/ONWpYr8amNP+GY7V4WlbCXqrqpEnU2JFkKElYKFHOA3C2iKg5QRvsjhltvitSY5+MowimLUrusPMsuwK0LNChj+4PQJxGDsG+WQVSfWvpJNjX5/CZEotb/7HhBI9ke5CAovNkKMdigEg3yIH4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ez17pQw3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91B8C2BD10;
	Tue, 11 Jun 2024 08:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718094415;
	bh=zPCa8xPO5T29Ue6m/rGvsIVSedmfYpv71DR4OREdVBQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ez17pQw3y3AnnRAsbp/TeB/EKjEe7TyilW2EVLSJJrew7wwyol5eLtQF972oIfLpG
	 oYcDa9ge7GLmbENS0nP9E6ta6tD7CQef1VnquDAuNjK/vmtFTMl8qc2CWkRZn6DFMS
	 raKMjYT80FmXY5BCGp2iWYpN2mIcXyE1s1Z58hYCCGi8z4FHsqMGJz+kXo4P2Nk278
	 r+zW/RpHA3mNDdc41rCNeksvCw0askxtETJGNAUBwkUPNPgC4kqE5kupqRA+Iycdzy
	 jj5qMbPiZljguvK2fsauAxET3ATsJgfsyWMl0BAtw4WiWIzM56ISDOgnDaaVGyV3zf
	 MkLh4tzLpuL/g==
Message-ID: <b5db88d4-5639-47a9-9611-2628235f4244@kernel.org>
Date: Tue, 11 Jun 2024 17:26:49 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/26] block: move the bounce flag into the feature field
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
 <20240611051929.513387-27-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-27-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the bounce field into the flags field to reclaim a little bit of

s/flags/feature

> space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



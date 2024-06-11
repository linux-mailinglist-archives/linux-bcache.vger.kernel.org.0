Return-Path: <linux-bcache+bounces-587-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A292F904466
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 21:22:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 517FB28AC89
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 19:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAE080BEE;
	Tue, 11 Jun 2024 19:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AyIVaWHW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52453762C9;
	Tue, 11 Jun 2024 19:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718133732; cv=none; b=l31KIi795CbIF2lbJ6sQRf2Z0DXnVtfsDvGPmpxVa8TrYZP6dIaRVuXF0vCi315nBtOqlYWgjQ6nqknoyP1Gg0jlXKWZG4qYhwFG17ReK8pw9KYKVy/KDtSciY4gBYdrH4ctf90Dzvw8FucVHHBY8feEaizfw5I4jfPQUsD0RrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718133732; c=relaxed/simple;
	bh=3ixPd20Brm0Ojggy7qJw2cbm5fUEi/vuhCs/LVeVXKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1XoACNkMH0OvRfhBKRo2rs9kFlAg7cSHmxleeNv/rQX/qbe2qzNu2iQNIVbxeopTkpkqvhdcX5oKaa7dlLRkdeyuehs0DJ8hSZiBDCWcLToyYqmcscjCCKywjzTSpO2mofJb0IVg+epSwHUBjW1HyGOlVe0fa+BeQEJ1TfyUdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AyIVaWHW; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VzJTG32hjzlgMVS;
	Tue, 11 Jun 2024 19:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718133721; x=1720725722; bh=2kItM8M6DKC8yk2cGf7wD1da
	KQLqhlWP/tN3daGsJLE=; b=AyIVaWHWYQL5dujfBjhbCIsCn397P+T5JLcgaDqJ
	pzESqNRWihm+746zwor/sibSvVIHxIyLj3I91PU4zHR4eiIJTnWSankubQFHkoES
	nh+QGckPwl5LlUArR5NM75XHxtPvhUfvqBY9mUu1pPzAlLzEtFY8gm1BpazYZh+r
	eW0iCZxPI/ZM6Um6Jh0o6Qaqo9cTiflVm+qX5Iae8FNcpCd4IG1igDsvNxIWTO8h
	pCjh2iWPrBsFmJCx0AeTInPZYsGcJ2NUw3I9d9axGajvmLN3Qd5Vay7WgFzs+E7r
	R9Jl5pi76ng65UABo1TMrVFSsftoCgjknuPmDNeELXHvOQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kg4NlOQnyRM4; Tue, 11 Jun 2024 19:22:01 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzJSw3kFKzlgMVR;
	Tue, 11 Jun 2024 19:21:52 +0000 (UTC)
Message-ID: <490fb178-8246-46cc-87fc-a57e076b9657@acm.org>
Date: Tue, 11 Jun 2024 12:21:50 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/26] loop: stop using loop_reconfigure_limits in
 __loop_clr_fd
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
 <20240611051929.513387-4-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240611051929.513387-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/24 10:19 PM, Christoph Hellwig wrote:
> __loop_clr_fd wants to clear all settings on the device.  Prepare for
> moving more settings into the block limits by open coding
> loop_reconfigure_limits.

If Damien's comment is addressed, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


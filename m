Return-Path: <linux-bcache+bounces-589-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB27D90448C
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 21:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 558A2285FEE
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 19:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259C481AD0;
	Tue, 11 Jun 2024 19:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EdKe51ZY"
X-Original-To: linux-bcache@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC138004E;
	Tue, 11 Jun 2024 19:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718134085; cv=none; b=Y0hUHZX4pU5YUe5GzDH3hdYDd7tb3MzgfDibZUVKemFcYD2FpDqpS6FU6P0ouySGj7IIrEcH4HbGF+DB4DCVpVLXdEZ/JT1Y51Cr4Jvmq/q9/eiD9d//ZNxOmuifEmMORvPhKqMjp+pCwLDHoUofCdaJqMViZsc/qEDduC6R10E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718134085; c=relaxed/simple;
	bh=YtvkWw8Gi6upB6SKoYVFeE/L/SHaNAbPzpI3b0v+iss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Da1xYAPJPQzITEYl0dyF46nAe5esf3dDE0VoqE6SphNdd9s0kg6MozPJKZHqd7acMSi4qwziCEYatJot0xXYYl9dYKTF6swCnG0u7HfmpSWAJW0ALzSs1TRE/timuNXmOorLiyRbkCMVgxGQkuk0pIQBeCu7tHppRUTuce42IA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EdKe51ZY; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VzJc26ZdMzlgMVS;
	Tue, 11 Jun 2024 19:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718134074; x=1720726075; bh=gYA8TbA/2Ugidtah56dUhtBG
	Galu8/NG0wUScZCuyoQ=; b=EdKe51ZYqmfiPrpKkhPZ4ZF3PIbJwSbtn3RaaOF4
	ofhW5+7WMGPdWrsE2RMUMe4iOqCcKHfWsBE3jV1OI639Mq7dV1i23L3heMui5/1M
	qnw7wzx3me2m0nYbh4wIXdkzvzP1wJeBO9R+vxMKtan9+zubixL4PI1lPSTjLtQo
	fiVS5xI+5EIjbwxGLfn4YEaQCSjam9kUL6ZrBJ399SkJbGkj6meDfAJdNRLPTK4J
	cHr7uNkLCLE6LFJeypIVrgAn7huEmidRUea5q5IRH9I+kWNO+72D6ry2ZEj0M5Y2
	xKogQ+lj25MniDZvtXiYa8/diDPnTI2EYnDYd8bY8qFhAA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3RE5VBL2zIbE; Tue, 11 Jun 2024 19:27:54 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzJbg1ZPszlgMVR;
	Tue, 11 Jun 2024 19:27:42 +0000 (UTC)
Message-ID: <ec31fd62-8a1d-44b2-8c0d-d6cca64f752e@acm.org>
Date: Tue, 11 Jun 2024 12:27:41 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/26] loop: regularize upgrading the lock size for direct
 I/O
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
 <20240611051929.513387-6-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240611051929.513387-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/24 10:19 PM, Christoph Hellwig wrote:
> The LOOP_CONFIGURE path automatically upgrades the block size to that
> of the underlying file for O_DIRECT file descriptors, but the
> LOOP_SET_BLOCK_SIZE path does not.  Fix this by lifting the code to
> pick the block size into common code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


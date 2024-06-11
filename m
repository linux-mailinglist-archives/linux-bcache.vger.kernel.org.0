Return-Path: <linux-bcache+bounces-593-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D76329044DB
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 21:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6132EB236B7
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 19:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CBDA80605;
	Tue, 11 Jun 2024 19:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="map4zviG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49377F492;
	Tue, 11 Jun 2024 19:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718134530; cv=none; b=O76DxSY4l2UtFeytZyMPjruKZmABf7o2U++xVYDEah2z9PVYGmjPM4ZmNmUU6QP2GMujnJkFe27DndP5wMb2vEIWJC48IkBs68Iu1VZBNKfGZ3aSNzKVNrnj80fX+hup/YOiEkDB0P3X3x2bKatsRWh9ETzydAwNI5jXVQGjNlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718134530; c=relaxed/simple;
	bh=qIoic/+Eicm2rmoTh1GHTDwZkragJhr4fvW17JXrG0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NGmRtUGtZNBPCezSyXLq3lOfORQf/Sw6IBamtM2i29yo8XRPisfMiWhu36WnZusoJmaVeLshYbhreSmCu835MU8hXXbZE+bk6Q7iew1W6TWhocR/8gCjl4RxJ6+czMuth8gySbWSyuijOpE1qksiQOdHwsNAzyPdl8Z6jV/IpoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=map4zviG; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VzJmc1ZkpzlgMVP;
	Tue, 11 Jun 2024 19:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718134520; x=1720726521; bh=qIoic/+Eicm2rmoTh1GHTDwZ
	kragJhr4fvW17JXrG0M=; b=map4zviGJJNMHWZcL0XSQcKZOt8HWwKs4uPCn6h8
	ClKZM//GsD59uwkW/BTQY4EwjOkcFI8O/2h1lvfA4LAL1jmbGgLTNuYoF0Q6mH/f
	f0c9ECm+XNFBDbP6yRxg58slOwTWkCmc/bwd3R9+TXJ6JNN+7VCrT6hBYuAJbGau
	cP0Ibr0GKyH9NB+v4g+CkSDs2g8BRJcKK2rvBZA6bcKGt4wBGdtuJJyCZ9IkY8vH
	+jBWfaKTTSMD0aQJ/O6PovdqQWYkZxLId41z+BCIcQxfQOcW8v1mrgpZgFJMJsy7
	Jf+H2kPgaFs82OcmUoGRFeFKF0L/aVmUOEUaFL7Q+8CSAQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kM3NVR9fxZIH; Tue, 11 Jun 2024 19:35:20 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzJm40fCWzlgMVN;
	Tue, 11 Jun 2024 19:34:59 +0000 (UTC)
Message-ID: <5a806e25-554f-4179-b73e-d3fd9f440441@acm.org>
Date: Tue, 11 Jun 2024 12:34:58 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/26] nbd: move setting the cache control flags to
 __nbd_set_size
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
 <20240611051929.513387-10-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240611051929.513387-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/24 10:19 PM, Christoph Hellwig wrote:
> Move setting the cache control flags in nbd in preparation for moving
> these flags into the queue_limits structure.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


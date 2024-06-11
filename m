Return-Path: <linux-bcache+bounces-594-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08C1F9044F8
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 21:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C6791C20A7C
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 19:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDFA9824B5;
	Tue, 11 Jun 2024 19:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n4YdDdBf"
X-Original-To: linux-bcache@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B9D7F492;
	Tue, 11 Jun 2024 19:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718134637; cv=none; b=BephpmIOtrP76/xsl4Z3Lxn7E/ZpHPot6LHRft1mku6brI0zDCfqQSH2EoAVE091z5KHfi9sTLk2rWfE4YYuDTuXz+sm/x7rk9EzyewVaq4hT34fykngUzNN8uMWFRZy913VRK4ZdWt0bo/C3cbrpjW9Z3ac+l2f37u4TnyAfe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718134637; c=relaxed/simple;
	bh=/NNQk2y/aszAHt5aS3qTao60p+qxs/BoKd/BYoR91zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rmvFiTT/F/t/8YPgi/A4MMYz3WgQZXFeeIBZ1a7ZZ7u53nIyksIEzaTWH51cVCV7tAxoJJXK6cFIELh2ZwGYn43R2EkBB4YTGrDKawntaaKTvtxoSfsaRoWDm/VdM/RIdUh3c8gJnBjMWBEQVWzumgCbR9zie5wUvPcEFRQ8VE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n4YdDdBf; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VzJpg3N77zlgMVP;
	Tue, 11 Jun 2024 19:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718134626; x=1720726627; bh=nxeAEPoRIF1w17Vf6H50avwR
	d47tQeq24V55mlSo6Fo=; b=n4YdDdBfOscNrfscK2NP2xV4LYi1o1AdP30LHl21
	+IbqLgtMyNqee6SbzA50sLVTZE0Ji6k+2w0WLmPh57DienJvg5IuAQuKYp0InUsK
	R6rrYr54yHJbztT/cndM4ZANOd0BSHTpKcctiVeFtmZFjzrLeHPbM9VtSJmKwf7X
	Af8olT+2oDMLUTt1MIpMS3WiRglrB6WCMiAEgpmD+A4upmkHshWHc+3fJHBYgE5i
	tD5snqlsdZGaJP09e2u2aXuuDiqbxQTmEF2zfjaEm7Jr+gWSnF6gfshEHOyMC1oC
	wY6QiEq3x8Ed+pcVJd6N4WwEZhVXh/S1bVC6eE1yI7Gx6w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id I78Iw22WN8VT; Tue, 11 Jun 2024 19:37:06 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzJpL0wGgzlgMVN;
	Tue, 11 Jun 2024 19:36:57 +0000 (UTC)
Message-ID: <1f7c1123-0f80-42a4-8252-c082ded33ca6@acm.org>
Date: Tue, 11 Jun 2024 12:36:55 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/26] block: freeze the queue in queue_attr_store
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
 <20240611051929.513387-12-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240611051929.513387-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/24 10:19 PM, Christoph Hellwig wrote:
> queue_attr_store updates attributes used to control generating I/O, and
> can cause malformed bios if changed with I/O in flight.  Freeze the queue
> in common code instead of adding it to almost every attribute.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


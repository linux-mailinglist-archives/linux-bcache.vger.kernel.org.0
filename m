Return-Path: <linux-bcache+bounces-588-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D44904479
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 21:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F57628B872
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 19:24:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83A881AC8;
	Tue, 11 Jun 2024 19:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tf12JUS8"
X-Original-To: linux-bcache@vger.kernel.org
Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F88D770FF;
	Tue, 11 Jun 2024 19:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718133840; cv=none; b=ScTHiYw32hzD312zN1aueJcVcEvDsEX6bik5xVlkgogpurjHv/uXiAT6Wtx8CyAtM+ub2ztwUQq4WxgYHKUjoEPZh2KBkydrOysqwPzyiUdnyz1BXeMo0ccq80eg4bA6I7+X5cJpyqokZOLgVAXSx0uPqS7hwX90fyOLNS+Y1wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718133840; c=relaxed/simple;
	bh=rZhPumdb2n42pDla++r+0nDRHS4rqP791XrFPg2G27s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gJKbpaWSFIxAz86ElA689UrIrMXt+My1QyGKUalw5IjH+5x/22WwCIksGbYsFUBMhe5JQVv83mpsMpBWVz7B2gI7juu55E+7vOUEkpAIjOxlKQ/M0DzQ4jfItTvDYXnSIjT9zBk0F51ubu63g0Y/Ueszr/Pz6bMSV+UDMH84juw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tf12JUS8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VzJWL4fk8zlgMVV;
	Tue, 11 Jun 2024 19:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718133830; x=1720725831; bh=rZhPumdb2n42pDla++r+0nDR
	HS4rqP791XrFPg2G27s=; b=tf12JUS8O/vzIYeKCwJjv+pwBfVWJQo9KgcDGp0z
	zC7lV0/c/f2ThXKlndGod8/GtTQwAvp2FqIrETvuNz72J0EV/Nq7OLg2Ro3uTx1k
	a3Lag73AcQE3SA5r4iVyJOxbBbB3z7MfHM9AUAy4N74Z8QUhqfhGTIxZ6DcyQWB0
	8Q6dtcQ0sUi3rbVLLp7uCK5xx11aui7r2k4FrkxildcMH3hs4D+DUFLmfX5g1L14
	BQ47XWYzIYACtm6ChhwhZqZfg6iWXjIO/WaP2y1Mjt4ULw04tLtnXIqdkxdlkhKw
	j/QTJWPUoPxIYeArXQy68tOsZbpeaOqMb660pTcOxJP27w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zYqmexEwqHMb; Tue, 11 Jun 2024 19:23:50 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VzJVz4rs6zlgMVT;
	Tue, 11 Jun 2024 19:23:39 +0000 (UTC)
Message-ID: <165613a2-237d-4f2b-9843-75ce0f928dff@acm.org>
Date: Tue, 11 Jun 2024 12:23:36 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/26] loop: always update discard settings in
 loop_reconfigure_limits
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
 <20240611051929.513387-5-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240611051929.513387-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/24 10:19 PM, Christoph Hellwig wrote:
> Simplify loop_reconfigure_limits by always updating the discard limits.
> This adds a little more work to loop_set_block_size, but doesn't change
> the outcome as the discard flag won't change.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>


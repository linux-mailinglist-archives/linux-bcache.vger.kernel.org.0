Return-Path: <linux-bcache+bounces-562-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3696C903523
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFA201F29D33
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E58A17332B;
	Tue, 11 Jun 2024 08:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rofJBX5J"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB9E2AF11;
	Tue, 11 Jun 2024 08:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093637; cv=none; b=I1h3sTDCLWo/JKeKyLrNmrLoRu3cJkuP1oe4y0IFMH6c5xFUTqnrruQbeeDtRtzZfXKWntPS1wW16KlnlAc/5Avf6SB1o6JD9u1CgD1jNvPASafPReeQF+r0TvUAYJNCOo12stFhsHDK0Q6s4Fi3n5XFzCriXoHHElBFUZXlhTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093637; c=relaxed/simple;
	bh=Ts7aLdf8C9OWwGOUYNUO/M/a+9bfhQDB/UXt0XvRgP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NipUDkdqJW5upytb7MRkpW2w7Wx7r37XeHzIJCuWdF+B1PdY931IACZaeCj7K/RLjO+VsIYMb4dt4DvvY/k5Uh+OJqdaISpjCRdeK9VnbDtadRfa65q6C1LD+wY4JxXkowHASb2zkjbniUGhzfkBaprvpAoDFY0YWZPVT1jexiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rofJBX5J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C1DC2BD10;
	Tue, 11 Jun 2024 08:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718093636;
	bh=Ts7aLdf8C9OWwGOUYNUO/M/a+9bfhQDB/UXt0XvRgP8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rofJBX5JNUQ4+kum9tXFynL7EYsPL7Q0KpCGApK8UUywKKWzZFWf//NTc6ETwxvAj
	 a8A/PpgedR3JFeoFFYagjhmZDCoIfcDwvtbjsSmqm4tUPrc5+/CNJBuJdjSU/gAghn
	 gFAjLu8rDiAmvD+AGVC2HFwxhOJxaDRk0LEG637q0x+wWdh1qDqXecrioXhw/WgLq/
	 z6eYyXSBzOA5E93r3CufKFnmCp0Rd06eblngnOUKkmVMJslwphJuJlwn0dieAbpnXx
	 mIsJEpZRQysVLdUZy59Nxz+wB/+28rVZ5Fwtt4tdw0yLdp6mqNz/XQPlvKYsJFt70s
	 9HDIcvYwKXcTA==
Message-ID: <0d4a7361-f3f1-4014-af92-9abd45223fed@kernel.org>
Date: Tue, 11 Jun 2024 17:13:50 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/26] block: move the synchronous flag to queue_limits
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
 <20240611051929.513387-19-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-19-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the synchronous flag into the queue_limits feature field so that it
> can be set atomically and all I/O is frozen when changing the flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



Return-Path: <linux-bcache+bounces-565-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA938903551
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 10:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7058B1F22259
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 08:16:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149DD16F83D;
	Tue, 11 Jun 2024 08:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BshMQEOF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AE93F8C7;
	Tue, 11 Jun 2024 08:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718093803; cv=none; b=Bnya0LYkSYjz59KPN01JISnVI578hiXdAxrpGi6iA5oWRhiNhBfQA7V353znqOwyVEvGHwXCQC7MveX4sw7DrwCpX+pEBR37UdGAmo2PDbxrLgCPZFaWd3gT/ADegyn8ndO9hiAhhkXAduMW783c4lwbSFN+dqsHhdAabpfoxt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718093803; c=relaxed/simple;
	bh=0xCsZy2WAGO31vOt2jMux3XsQG5JzkwMLoCsgqbDM7s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Klp6UgG9DqOhwbrQ4msbpKrrcbWFUgc98WQe6hB1jwIWCMTRKvpcDbl5nvK4ywEx+4kjnVMdjnFKj6MRRRWhl8SC8nhrxIY1rNNRTZquB34gTCqlb8Y/ijFzJG/tZoTIVcbk98RY3xzeNxbQc5a8IcYkwAPlCFD4fbKXMXFISC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BshMQEOF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A204C2BD10;
	Tue, 11 Jun 2024 08:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718093802;
	bh=0xCsZy2WAGO31vOt2jMux3XsQG5JzkwMLoCsgqbDM7s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BshMQEOFKHQCAeU7Uq7D/QqRf+yvZZUvvFAljFVHRMbxOyzti+TjMe0D1IJKi9gMV
	 zyUA+05eoWqeEmhuLL8uoXj2uFvoj39+EiUXirtXWtXQFdTuvV4hWDH4qLaMCjLfy+
	 AnqgnZ0xCGWpIVHNkCHGqby5QcQzPelY2FXqqGrtk4KASWZEpNZldaxiF+wB3Rw9dc
	 xbMnzOX/e3WR+yoGOTEoauLs/X9V3dTUosPnw+YpOF05bIeErHzOz8DqMDnd798OeG
	 g23Oj4HG5YREgeqkRw2UIxm1G6V2rlg7SUCDzzjKvw7jq8xou/AYaSDtybrj1/IgEi
	 S8SrLRUjTG4qQ==
Message-ID: <4845aae8-ad03-407e-bf31-f164b8f684d4@kernel.org>
Date: Tue, 11 Jun 2024 17:16:37 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/26] block: move the nowait flag to queue_limits
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
 <20240611051929.513387-20-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-20-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Move the nowait flag into the queue_limits feature field so that it
> can be set atomically and all I/O is frozen when changing the flag.
> 
> Stacking drivers are simplified in that they now can simply set the
> flag, and blk_stack_limits will clear it when the features is not
> supported by any of the underlying devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>


> @@ -1825,9 +1815,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	int r;
>  
>  	if (dm_table_supports_nowait(t))
> -		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
> -	else
> -		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
> +		limits->features &= ~BLK_FEAT_NOWAIT;

Shouldn't you set the flag here instead of clearing it ?

-- 
Damien Le Moal
Western Digital Research



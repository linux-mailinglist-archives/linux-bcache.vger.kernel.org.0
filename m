Return-Path: <linux-bcache+bounces-536-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E34990318B
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 874DEB297B3
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 05:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFF217085B;
	Tue, 11 Jun 2024 05:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WBxCLVZA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FB08488;
	Tue, 11 Jun 2024 05:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718084805; cv=none; b=Ql7S63r+w0N2BME42JBUrTMj9t7YkN+RWPzK5XYYxRzNXYwaenEzEPj0QU7IaIH63zCdiD1Z5gQ9Rwbw+Gxxi9U08Yww69OYNi1/QpPtqZQAeDqQlJlN6jjfD7ePGUM0sJIiJkclyNBhLMxa2Pa46afXQQWgG8ofz4ALeKpMvfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718084805; c=relaxed/simple;
	bh=ExeLOYUGYjsXp3wdbBqJbcQ6b1Q8a86JlJB2p9Et3no=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I9a7qlAsa4qdn/h5dG/Jdu4St7L2yn9bmAYkLRs55XW3PV244ssi2Po7Ti4UvjjfIBua1Z3IxGbiG/mCx/gnzsQuTP01nt7SamydC5v59tE8duBoVEy05N6dda7g+hzDx1CTeEkQ7dRR/Q1ZuhZqL/Q/s0Xq6WJKNrOj1A3THdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WBxCLVZA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6E2C2BD10;
	Tue, 11 Jun 2024 05:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718084804;
	bh=ExeLOYUGYjsXp3wdbBqJbcQ6b1Q8a86JlJB2p9Et3no=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WBxCLVZAQ2Cg02C5kvrfE9AgQqRfV0Vp9wUF3fqyRhPTMqteB7yjcEcGuYnFUrdIw
	 Nu+HCmDrsEWaDY0FS7c46/3H7ATl/iGMVLCSF+Y1IXagrNKa23K/U8gLfuLZVv+pfk
	 se724bhlH7gvtfrzVvNU5z4sgOI97FPDkZ/i4w+FATTtdCE12k8Vsqx39K60DyqVqK
	 eKEG3WqOVb470PJhBzxUxSx4QvapUkoaIbwLZb4Jn2jRXEpSQbkqLj2jPx5RESJvRH
	 5VCPbFYE05UT1aOpVYJIEWldcQvGMdLjZeDXOZ3CBVDxeKuyv8iCzyjAX6fSrOkmTW
	 QhoVFafzbn1yw==
Message-ID: <d50efca4-ba29-49f9-94cc-5bd4795f6e38@kernel.org>
Date: Tue, 11 Jun 2024 14:46:38 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/26] sd: fix sd_is_zoned
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
 <20240611051929.513387-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611051929.513387-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:19 PM, Christoph Hellwig wrote:
> Since commit 7437bb73f087 ("block: remove support for the host aware zone
> model"), only ZBC devices expose a zoned access model.  sd_is_zoned is
> used to check for that and thus return false for host aware devices.
> 
> Fixes: 7437bb73f087 ("block: remove support for the host aware zone model")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research



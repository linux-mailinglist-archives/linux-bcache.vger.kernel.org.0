Return-Path: <linux-bcache+bounces-612-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFBD090A39A
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 08:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 997E71C213FD
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2024 06:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4304D181CE9;
	Mon, 17 Jun 2024 06:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHL4hpDI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34A61862;
	Mon, 17 Jun 2024 06:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718604220; cv=none; b=Uzo9Uii40rCFLOoVioM8EcdSi2AfwtOQsd2KlEy1Ip52YDf7snK2ioxaAwdNK+Iz1944WSVcW8gPl2kTRmZx90Odi/p0XAepPu3QEqs/yu7ySEH3SRSjXpjVRF08BW+RomYTfypV37VFB/R9j1swl/ng2RkcrLZqJEqm7rwATQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718604220; c=relaxed/simple;
	bh=m0CKH+FHwbkUOr+sSrcVkW5ESZFXp5kIa1//vjrk4yE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TGOoysYKdE08MlSp0kTOvEIhVUl7WLwG5o0Gq8W0t/7c+p11q6fHQ8NDTbvCTTRth2a2n1o3nKCvVMz8gonSNBddk7/CD9zC7waDERhv8zqhfctueOP2nHEn/k4m/GASd4QN79ouIQxkJ8B0epucIq8axqhF61pPjtHDR7hsE0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHL4hpDI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A36C2BD10;
	Mon, 17 Jun 2024 06:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718604219;
	bh=m0CKH+FHwbkUOr+sSrcVkW5ESZFXp5kIa1//vjrk4yE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZHL4hpDIzus9MORWkAbgDJINc4LVHx93lSfKixSkm6WuLxyXO8kkYM44k+wcOnr5y
	 tkFWuqAKw955Q/rvEo4d1MS5n/NwL4TdN4ssl8cV7ZAZLbnGhDKwhC73QRhgwv+NZq
	 4MHo4ahMA2gZVzsFtyj1OAL5yJiTS0PIsFOfjpr6Q4Iz0vizRFUgFcQcYzSr+vYOlU
	 9makxthgJ0C1BEmV0I9GbD23VHSGMav9AQ29gAEuujqqpGZAlwMM1nxM2wawtGe3Za
	 Rfe2pF85RFEJcZaeOU4UkFt4BeHCBkbgQEQvS0KKa82U3uwq4hheAWgp20LXEFXakj
	 o5wuVRw+MEylQ==
Message-ID: <bf52121f-38f2-4789-b545-7c6ed0fe55b2@kernel.org>
Date: Mon, 17 Jun 2024 15:03:33 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/26] sd: move zone limits setup out of
 sd_read_block_characteristics
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
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
 <20240611051929.513387-3-hch@lst.de>
 <40ca8052-6ac1-4c1b-8c39-b0a7948839f8@kernel.org>
 <20240613093918.GA27629@lst.de>
 <5a697233-0611-459d-b889-2e0133bbb541@kernel.org>
 <20240617045356.GA16277@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240617045356.GA16277@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/24 13:53, Christoph Hellwig wrote:
> On Mon, Jun 17, 2024 at 08:01:04AM +0900, Damien Le Moal wrote:
>> On 6/13/24 18:39, Christoph Hellwig wrote:
>>> On Tue, Jun 11, 2024 at 02:51:24PM +0900, Damien Le Moal wrote:
>>>>> +	if (sdkp->device->type == TYPE_ZBC)
>>>>
>>>> Nit: use sd_is_zoned() here ?
>>>
>>> Actually - is there much in even keeping sd_is_zoned now that the
>>> host aware support is removed?  Just open coding the type check isn't
>>> any more code, and probably easier to follow.
>>
>> Removing this helper is fine by me.
> 
> FYI, I've removed it yesterday, but not done much of the cleanups suggest
> here.  We should probably do those in a follow up up, uncluding removing
> the !ZBC check in sd_zbc_check_zoned_characteristics.

OK. I will send that once your series in queued.

-- 
Damien Le Moal
Western Digital Research



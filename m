Return-Path: <linux-bcache+bounces-548-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC73903352
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 09:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FF8F28B3FF
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Jun 2024 07:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F78F171E58;
	Tue, 11 Jun 2024 07:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9t/JghW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C581126AF6;
	Tue, 11 Jun 2024 07:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718090462; cv=none; b=ukUSN8oeQnlnLe1dKed7wigeu/Xu3jxPkMSZMe+uDXsVVCm+D+jyqLdFJQ8ivyBOsHQm+JTOf+ci7ODr7I/yFTpMPKEGoR38J5BFVVEzj9Oc+FFThCHGgXlDCIwo5jk8nbS7nXGPFjZUkWwEtPftJbgSj9EEx68NbsnSi1TAjEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718090462; c=relaxed/simple;
	bh=SxGiXC2eXjeuicvqjgmxBbbuRkQDAALVXqGltltCvpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kLloKrgzwvysRNcCtJnjxEzESwXzbXDL1lnMiNbIJ0xTEJN1RkUG/ZRKuwmv8E2unW1AGERUKcOS/5bZduh/n4JAnjqCrTTlrtbgFxYRaXZp+RM7FSLcThjjb5ADIlsj7/FGb42AK8TpKjDhT1q0ga9ISxAH1Jua3yVg6ifaZS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9t/JghW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B857C2BD10;
	Tue, 11 Jun 2024 07:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718090461;
	bh=SxGiXC2eXjeuicvqjgmxBbbuRkQDAALVXqGltltCvpM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J9t/JghW0gR/ETwdzjpl7VD7KnwAlMW8rRhwZr9kxWhQ6tl8Phg9WjO76NiKxxgu8
	 fLxeqF9M5t6BVVC5kK/sKL3zR1K2qLPoyVha6i0EJluUzp1kNJ5g2TNKh8g+EJPN33
	 hrljcXVnUuN8Lr5KlIujiAJZzEJDuCsFcPLl3jPutPmhKf9R0GeNiPNem29bg2OBO7
	 a1cFWzw0qNt9DSnc6yLqLEresNea8LBs8q7/++QEaUosyu+AjkSi/+C9VElPN9n7PP
	 XlPsIxsXYvBqYod+WVUBRRvW1FiyVSTv+Mlz8E7DodnwczmTJdbU3tnt32fP5VZhAs
	 3tDYxoJTsEL7w==
Message-ID: <6bf90562-0ff9-46b6-8a58-7381332e3beb@kernel.org>
Date: Tue, 11 Jun 2024 16:20:54 +0900
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
 Christoph B??hmwalder <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Roger Pau Monn?? <roger.pau@citrix.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Vineeth Vijayan <vneethv@linux.ibm.com>,
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
 <20240611055239.GA3141@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240611055239.GA3141@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/24 2:52 PM, Christoph Hellwig wrote:
> On Tue, Jun 11, 2024 at 02:51:24PM +0900, Damien Le Moal wrote:
>>> -	if (lim->zoned)
>>> +	if (sdkp->device->type == TYPE_ZBC)
>>
>> Nit: use sd_is_zoned() here ?
> 
> Yes.
> 
>>> -	if (!sd_is_zoned(sdkp))
>>> +	if (!sd_is_zoned(sdkp)) {
>>> +		lim->zoned = false;
>>
>> Maybe we should clear the other zone related limits here ? If the drive is
>> reformatted/converted from SMR to CMR (FORMAT WITH PRESET), the other zone
>> limits may be set already, no ?
> 
> blk_validate_zoned_limits already takes care of that.

I do not think it does:

static int blk_validate_zoned_limits(struct queue_limits *lim)
{
        if (!lim->zoned) {
                if (WARN_ON_ONCE(lim->max_open_zones) ||
                    WARN_ON_ONCE(lim->max_active_zones) ||
                    WARN_ON_ONCE(lim->zone_write_granularity) ||
                    WARN_ON_ONCE(lim->max_zone_append_sectors))
                        return -EINVAL;
                return 0;
        }
	...

So setting lim->zoned to false without clearing the other limits potentially
will trigger warnings...

-- 
Damien Le Moal
Western Digital Research



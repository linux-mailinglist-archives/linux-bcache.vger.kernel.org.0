Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CE22AA302
	for <lists+linux-bcache@lfdr.de>; Sat,  7 Nov 2020 08:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgKGH20 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 7 Nov 2020 02:28:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:39124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbgKGH20 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 7 Nov 2020 02:28:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 240D3ABA2;
        Sat,  7 Nov 2020 07:28:24 +0000 (UTC)
Subject: Re: [PATCH, RFC 11/10] block: propagate BLKROSET to all partitions
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ilya Dryomov <idryomov@gmail.com>,
        Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
        martin.petersen@oracle.com
References: <20201106140817.GA23557@lst.de>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <a2add52e-715b-f82a-d6a0-b285f0f5acde@suse.de>
Date:   Sat, 7 Nov 2020 15:28:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201106140817.GA23557@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/11/6 22:08, Christoph Hellwig wrote:
> 
> When setting the whole device read-only (or clearing the read-only
> state), also update the policy for all partitions.  The s390 dasd
> driver has awlways been doing this and it makes a lot of sense.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Coly Li <colyli@suse.de>

Thanks.


Coly Li

> ---
>  block/ioctl.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 6b785181344fe1..22f394d118c302 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -354,7 +354,10 @@ static int blkdev_roset(struct block_device *bdev, fmode_t mode,
>  		if (ret)
>  			return ret;
>  	}
> -	bdev->bd_part->policy = n;
> +	if (bdev_is_partition(bdev))
> +		bdev->bd_part->policy = n;
> +	else
> +		set_disk_ro(bdev->bd_disk, n);
>  	return 0;
>  }
>  
> 


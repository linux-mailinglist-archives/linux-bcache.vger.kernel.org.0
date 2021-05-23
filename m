Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558BF38DBDD
	for <lists+linux-bcache@lfdr.de>; Sun, 23 May 2021 18:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhEWQWO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 23 May 2021 12:22:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:40046 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhEWQWN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 23 May 2021 12:22:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621786845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFkWHMko4nu73I8bffz46LtF778hJacVhJlqbZzQwF8=;
        b=xIMCLEuwtEJ3ZYLVT1jAFLSlmekHbIbar2TdYds2f7pJgux+ASXt64k09tx/I3VzYVSQbd
        jYbEua8uhBBK1QtJJhgUBirelGonk+/REbn1EZdyuTOztWNmc/243wGZRrn0BpiSJnEF/k
        3o6nC8QrS3eMOcehdY1jqcN3GUtqNzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621786845;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFkWHMko4nu73I8bffz46LtF778hJacVhJlqbZzQwF8=;
        b=OjWXQORh1AHg1yI5pLimYhJCE0/GNAVfRs6jLZKfmf7Vpd71K+gfdYi9LvcDAJhupXh6Tf
        ZrcrurNwYt+dptBg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DA2BFAAFD;
        Sun, 23 May 2021 16:20:44 +0000 (UTC)
Subject: Re: [PATCH 12/26] bcache: convert to blk_alloc_disk/blk_cleanup_disk
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jim Paris <jim@jtan.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Matias Bjorling <mb@lightnvm.io>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-13-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <19e05358-abc2-a577-d3bd-d4ae89f6316e@suse.de>
Date:   Mon, 24 May 2021 00:20:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-13-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/21/21 1:51 PM, Christoph Hellwig wrote:
> Convert the bcache driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Coly Li <colyli@suse.de>

Thanks.


Coly Li

> ---
>  drivers/md/bcache/super.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index bea8c4429ae8..185246a0d855 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -890,13 +890,9 @@ static void bcache_device_free(struct bcache_device *d)
>  		if (disk_added)
>  			del_gendisk(disk);
>  
> -		if (disk->queue)
> -			blk_cleanup_queue(disk->queue);
> -
> +		blk_cleanup_disk(disk);
>  		ida_simple_remove(&bcache_device_idx,
>  				  first_minor_to_idx(disk->first_minor));
> -		if (disk_added)
> -			put_disk(disk);
>  	}
>  
>  	bioset_exit(&d->bio_split);
> @@ -946,7 +942,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
>  		goto err;
>  
> -	d->disk = alloc_disk(BCACHE_MINORS);
> +	d->disk = blk_alloc_disk(NUMA_NO_NODE);
>  	if (!d->disk)
>  		goto err;
>  
> @@ -955,14 +951,11 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	d->disk->major		= bcache_major;
>  	d->disk->first_minor	= idx_to_first_minor(idx);
> +	d->disk->minors		= BCACHE_MINORS;
>  	d->disk->fops		= ops;
>  	d->disk->private_data	= d;
>  
> -	q = blk_alloc_queue(NUMA_NO_NODE);
> -	if (!q)
> -		return -ENOMEM;
> -
> -	d->disk->queue			= q;
> +	q = d->disk->queue;
>  	q->limits.max_hw_sectors	= UINT_MAX;
>  	q->limits.max_sectors		= UINT_MAX;
>  	q->limits.max_segment_size	= UINT_MAX;
> 


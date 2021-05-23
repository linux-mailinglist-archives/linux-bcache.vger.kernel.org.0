Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E0038DA02
	for <lists+linux-bcache@lfdr.de>; Sun, 23 May 2021 10:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhEWIOT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 23 May 2021 04:14:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:48872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231665AbhEWIOS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 23 May 2021 04:14:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621757571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QPb9JWvY5Mv2CQaqhfS/CQ9rp49Qt1b0dGLtKqWAHI=;
        b=bmLKYtBm8+NBy0rlZh5vgGqGnuUZQLXD5BUZHEsC9KLWeRov/Kd6myZf3F/3Hji8xMjQ4e
        XjNGXj+P/iVCSJDfUijcHK/6GnQs8Q24V+00sjOXcvV369Y7JMbEdHVZbnUo2wP5SwFvtR
        NE9Ud+kiuo+RtjyO7YO79/Vtotp8i1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621757571;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+QPb9JWvY5Mv2CQaqhfS/CQ9rp49Qt1b0dGLtKqWAHI=;
        b=TpSTAzMPXkVgQoDLdk+dThL13YkgxTUpmMsPvWCAi0674zr0yAyJez4vAZgVjbOQTqHQTY
        aFmfGWmflFT7I3Ag==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 009B9AC3A;
        Sun, 23 May 2021 08:12:51 +0000 (UTC)
Subject: Re: [PATCH 14/26] md: convert to blk_alloc_disk/blk_cleanup_disk
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
        Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
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
 <20210521055116.1053587-15-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e65de9e6-337c-3e41-b5c2-d033ff236582@suse.de>
Date:   Sun, 23 May 2021 10:12:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-15-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/21/21 7:51 AM, Christoph Hellwig wrote:
> Convert the md driver to use the blk_alloc_disk and blk_cleanup_disk
> helpers to simplify gendisk and request_queue allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 25 +++++++++----------------
>   1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 49f897fbb89b..d806be8cc210 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5598,12 +5598,10 @@ static void md_free(struct kobject *ko)
>   	if (mddev->sysfs_level)
>   		sysfs_put(mddev->sysfs_level);
>   
> -	if (mddev->gendisk)
> +	if (mddev->gendisk) {
>   		del_gendisk(mddev->gendisk);
> -	if (mddev->queue)
> -		blk_cleanup_queue(mddev->queue);
> -	if (mddev->gendisk)
> -		put_disk(mddev->gendisk);
> +		blk_cleanup_disk(mddev->gendisk);
> +	}
>   	percpu_ref_exit(&mddev->writes_pending);
>   
>   	bioset_exit(&mddev->bio_set);
> @@ -5711,20 +5709,13 @@ static int md_alloc(dev_t dev, char *name)
>   		goto abort;
>   
>   	error = -ENOMEM;
> -	mddev->queue = blk_alloc_queue(NUMA_NO_NODE);
> -	if (!mddev->queue)
> +	disk = blk_alloc_disk(NUMA_NO_NODE);
> +	if (!disk)
>   		goto abort;
>   
> -	blk_set_stacking_limits(&mddev->queue->limits);
> -
> -	disk = alloc_disk(1 << shift);
> -	if (!disk) {
> -		blk_cleanup_queue(mddev->queue);
> -		mddev->queue = NULL;
> -		goto abort;
> -	}
>   	disk->major = MAJOR(mddev->unit);
>   	disk->first_minor = unit << shift;
> +	disk->minors = 1 << shift;
>   	if (name)
>   		strcpy(disk->disk_name, name);
>   	else if (partitioned)
> @@ -5733,7 +5724,9 @@ static int md_alloc(dev_t dev, char *name)
>   		sprintf(disk->disk_name, "md%d", unit);
>   	disk->fops = &md_fops;
>   	disk->private_data = mddev;
> -	disk->queue = mddev->queue;
> +
> +	mddev->queue = disk->queue;
> +	blk_set_stacking_limits(&mddev->queue->limits);
>   	blk_queue_write_cache(mddev->queue, true, true);
>   	/* Allow extended partitions.  This makes the
>   	 * 'mdp' device redundant, but we can't really
> 
Wouldn't it make sense to introduce a helper 'blk_queue_from_disk()' or 
somesuch to avoid having to keep an explicit 'queue' pointer?


Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

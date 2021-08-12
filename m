Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6D3EA7F1
	for <lists+linux-bcache@lfdr.de>; Thu, 12 Aug 2021 17:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238195AbhHLPsi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Aug 2021 11:48:38 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37574 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbhHLPsi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Aug 2021 11:48:38 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EA35F222A7;
        Thu, 12 Aug 2021 15:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628783291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dggFCYfqvDGrc8ufyifdsUWa0iADyaxGU9QqwNJ3pNo=;
        b=NAfSTEBSkS/9UW2OGRu0KM86uMN88fpuuZtoZ0nyXuJbRTctqKyh0GvWMMiCntTvbWNXpe
        7sgCRk8h28MJodPKkmk7skNfmgLD4i6itTH+af4ASG70uoioR8IJj8hDd5o7JuWDpt7UIU
        BEzdCi8FzV/QQVpIGcEGYVUoYbIHqVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628783291;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dggFCYfqvDGrc8ufyifdsUWa0iADyaxGU9QqwNJ3pNo=;
        b=jlMXXbviU9zQg6ZGEOseMnWtZOCtL2RjJqg6qLc4keAjYa1QgoS7S/8NawXNXzIrXsnDwt
        ZGO8Eq2x0gyEi9Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E09C13C59;
        Thu, 12 Aug 2021 15:48:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id f/BwFLlCFWE6HwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 12 Aug 2021 15:48:09 +0000
Subject: Re: [PATCH 6/8] bcache: add proper error unwinding in
 bcache_device_init
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
References: <20210809064028.1198327-1-hch@lst.de>
 <20210809064028.1198327-7-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <bdec1e0a-e789-19f1-e9b6-d7f99413670d@suse.de>
Date:   Thu, 12 Aug 2021 23:48:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210809064028.1198327-7-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/9/21 2:40 PM, Christoph Hellwig wrote:
> Except for the IDA none of the allocations in bcache_device_init is
> unwound on error, fix that.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 185246a0d855..d0f08e946453 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -931,20 +931,20 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
>  	d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
>  	if (!d->full_dirty_stripes)
> -		return -ENOMEM;
> +		goto out_free_stripe_sectors_dirty;
>  
>  	idx = ida_simple_get(&bcache_device_idx, 0,
>  				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
>  	if (idx < 0)
> -		return idx;
> +		goto out_free_full_dirty_stripes;
>  
>  	if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
>  			BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
> -		goto err;
> +		goto out_ida_remove;
>  
>  	d->disk = blk_alloc_disk(NUMA_NO_NODE);
>  	if (!d->disk)
> -		goto err;
> +		goto out_bioset_exit;
>  
>  	set_capacity(d->disk, sectors);
>  	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
> @@ -987,8 +987,14 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	return 0;
>  
> -err:
> +out_bioset_exit:
> +	bioset_exit(&d->bio_split);
> +out_ida_remove:
>  	ida_simple_remove(&bcache_device_idx, idx);
> +out_free_full_dirty_stripes:
> +	kvfree(d->full_dirty_stripes);
> +out_free_stripe_sectors_dirty:
> +	kvfree(d->stripe_sectors_dirty);
>  	return -ENOMEM;
>  
>  }


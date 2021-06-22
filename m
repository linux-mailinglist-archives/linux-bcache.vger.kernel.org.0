Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692933B00B7
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 11:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFVJuN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 05:50:13 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40024 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFVJuN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 05:50:13 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F20D31FD36;
        Tue, 22 Jun 2021 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624355276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JYVfXcIPsCV7Z8grPlh/8UTaauBG7X79vOGaOLJhEU=;
        b=z+vbrqwFEMjYdAo4bm9zLFdxEIgwaAW6gVBgFX4xefBLtD93MFMxXbjy/Tr6OF2zZt5NTC
        +qAfCsJ/KL5BmaSbfRl7mFN9dqk0NzWyz6J2cOQuJ5bYhOUrYTFGB3n6CXZHwy9dStlvfl
        yC0FYhK0wn+IakiEMQ97TydlGVW10Jc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624355276;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JYVfXcIPsCV7Z8grPlh/8UTaauBG7X79vOGaOLJhEU=;
        b=biq88fvQVONhUGXbpEoEEHwivXlMYxSOzt7tB9IXf+dcLLlirj4TZqgt7urUV0vs9BTEj+
        JkYS8gbJr4TD0UBQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id DBC22118DD;
        Tue, 22 Jun 2021 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624355276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JYVfXcIPsCV7Z8grPlh/8UTaauBG7X79vOGaOLJhEU=;
        b=z+vbrqwFEMjYdAo4bm9zLFdxEIgwaAW6gVBgFX4xefBLtD93MFMxXbjy/Tr6OF2zZt5NTC
        +qAfCsJ/KL5BmaSbfRl7mFN9dqk0NzWyz6J2cOQuJ5bYhOUrYTFGB3n6CXZHwy9dStlvfl
        yC0FYhK0wn+IakiEMQ97TydlGVW10Jc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624355276;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JYVfXcIPsCV7Z8grPlh/8UTaauBG7X79vOGaOLJhEU=;
        b=biq88fvQVONhUGXbpEoEEHwivXlMYxSOzt7tB9IXf+dcLLlirj4TZqgt7urUV0vs9BTEj+
        JkYS8gbJr4TD0UBQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id xihqNcyx0WDCNgAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 09:47:56 +0000
Subject: Re: [PATCH 01/14] bcache: fix error info in register_bcache()
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-2-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4905e9f6-f1fe-f2d6-a633-79c2b17cfcbb@suse.de>
Date:   Tue, 22 Jun 2021 11:47:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> From: Chao Yu <yuchao0@huawei.com>
> 
> In register_bcache(), there are several cases we didn't set
> correct error info (return value and/or error message):
> - if kzalloc() fails, it needs to return ENOMEM and print
> "cannot allocate memory";
> - if register_cache() fails, it's better to propagate its
> return value rather than using default EINVAL.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/super.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index bea8c4429ae8..0a20ccf5a1db 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2620,8 +2620,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	if (SB_IS_BDEV(sb)) {
>  		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
>  
> -		if (!dc)
> +		if (!dc) {
> +			ret = -ENOMEM;
> +			err = "cannot allocate memory";
>  			goto out_put_sb_page;
> +		}
>  
>  		mutex_lock(&bch_register_lock);
>  		ret = register_bdev(sb, sb_disk, bdev, dc);
> @@ -2632,11 +2635,15 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	} else {
>  		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
>  
> -		if (!ca)
> +		if (!ca) {
> +			ret = -ENOMEM;
> +			err = "cannot allocate memory";
>  			goto out_put_sb_page;
> +		}
>  
>  		/* blkdev_put() will be called in bch_cache_release() */
> -		if (register_cache(sb, sb_disk, bdev, ca) != 0)
> +		ret = register_cache(sb, sb_disk, bdev, ca);
> +		if (ret)
>  			goto out_free_sb;
>  	}
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

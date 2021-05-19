Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF64A389406
	for <lists+linux-bcache@lfdr.de>; Wed, 19 May 2021 18:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbhESQpB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 May 2021 12:45:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:60298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237611AbhESQpB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 May 2021 12:45:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 449C7ADAA;
        Wed, 19 May 2021 16:43:40 +0000 (UTC)
Subject: Re: [PATCH] bcache: fix error info in register_bcache()
To:     Chao Yu <chao@kernel.org>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>
References: <20210519132823.14920-1-chao@kernel.org>
From:   Coly Li <colyli@suse.de>
Message-ID: <8c9f1ee7-553c-d795-40c2-7de2e0a0c4ac@suse.de>
Date:   Thu, 20 May 2021 00:43:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210519132823.14920-1-chao@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/19/21 9:28 PM, Chao Yu wrote:
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

Will add it to my test queue.

Thanks.

Coly Li


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


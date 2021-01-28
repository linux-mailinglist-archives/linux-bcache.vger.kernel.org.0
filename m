Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8845B307958
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 16:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhA1PRX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 10:17:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:58894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231163AbhA1PRW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 10:17:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B6271ACB7;
        Thu, 28 Jan 2021 15:16:40 +0000 (UTC)
Subject: Re: [PATCH] bcache: Fix register_device_aync typo
To:     Kai Krakow <kai@kaishome.de>
References: <20210128143319.202694-1-kai@kaishome.de>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <2b39601a-aadf-46cd-d034-a763082ac0fd@suse.de>
Date:   Thu, 28 Jan 2021 23:16:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128143319.202694-1-kai@kaishome.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/28/21 10:33 PM, Kai Krakow wrote:
> Should be `register_device_async`.
> 
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Kai Krakow <kai@kaishome.de>

Thanks for the catch :-) I add it into my 5.12 for-next.

Coly Li

> ---
>  drivers/md/bcache/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 2047a9cccdb5d..e7d1b52c5cc8b 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2517,7 +2517,7 @@ static void register_cache_worker(struct work_struct *work)
>  	module_put(THIS_MODULE);
>  }
>  
> -static void register_device_aync(struct async_reg_args *args)
> +static void register_device_async(struct async_reg_args *args)
>  {
>  	if (SB_IS_BDEV(args->sb))
>  		INIT_DELAYED_WORK(&args->reg_work, register_bdev_worker);
> @@ -2611,7 +2611,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  		args->sb	= sb;
>  		args->sb_disk	= sb_disk;
>  		args->bdev	= bdev;
> -		register_device_aync(args);
> +		register_device_async(args);
>  		/* No wait and returns to user space */
>  		goto async_done;
>  	}
> 


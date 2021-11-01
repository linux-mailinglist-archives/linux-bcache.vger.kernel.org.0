Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D5441246
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Nov 2021 04:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbhKADIe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 31 Oct 2021 23:08:34 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:49108
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S230222AbhKADIe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 31 Oct 2021 23:08:34 -0400
Received: from [10.8.148.37] (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewB3fGSWWX9hVH0AAA--.180S2;
        Mon, 01 Nov 2021 11:05:58 +0800 (CST)
Message-ID: <4c40083d-1fbe-570a-55c7-180ad9021edd@wangsu.com>
Date:   Mon, 1 Nov 2021 11:05:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] bcache: make checkings for sb.nr_in_set and
 sb.nr_this_dev
Content-Language: en-US
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211101030224.8152-1-linf@wangsu.com>
From:   Lin Feng <linf@wangsu.com>
In-Reply-To: <20211101030224.8152-1-linf@wangsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: 4zNnewB3fGSWWX9hVH0AAA--.180S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4kWFWUtFy3Ar45Jry7Wrg_yoW8Zr15pF
        ZrZFySy3ykZa15AryDAr48uFyrA343tay0gas3A3s5Za4avry5ZFWUKrWUAry8WrWfXF47
        Kw4Dtr9rWF98GaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Sorry, strings missing in patch title, ignore this patch please.

thanks,
linfeng

On 11/1/21 11:02, Lin Feng wrote:
> Commit 697e23495c94f0380c1ed8b11f830b92b64c99ea
> ("bcache: explicitly make cache_set only have single cache")
> explicitly makes a cache_set only have single cache and based on the
> fact that historily only one cache is ever used in the cache set, so
> valid number fo sb.nr_in_set should be 1 and sb.nr_this_dev should
> always be 0.
> 
> Based on above truth, codes validations for sb.nr_in_set and sb.nr_this_dev
> can make to be more accurate, that means tolerance for error checking
> are reduced comparing before.
> 
> Signed-off-by: Lin Feng <linf@wangsu.com>
> ---
>   drivers/md/bcache/bcache.h | 2 +-
>   drivers/md/bcache/super.c  | 4 +---
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 5fc989a6d452..a4a410a178c0 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -833,7 +833,7 @@ static inline uint8_t ptr_stale(struct cache_set *c, const struct bkey *k,
>   static inline bool ptr_available(struct cache_set *c, const struct bkey *k,
>   				 unsigned int i)
>   {
> -	return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && c->cache;
> +	return (PTR_DEV(k, i) == 0) && c->cache;
>   }
>   
>   /* Btree key macros */
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f2874c77ff79..2253044c9289 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -140,9 +140,7 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
>   		goto err;
>   
>   	err = "Bad cache device number in set";
> -	if (!sb->nr_in_set ||
> -	    sb->nr_in_set <= sb->nr_this_dev ||
> -	    sb->nr_in_set > MAX_CACHES_PER_SET)
> +	if (sb->nr_in_set != 1 || sb->nr_this_dev != 0)
>   		goto err;
>   
>   	err = "Journal buckets not sequential";
> 


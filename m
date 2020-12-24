Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F202E27CD
	for <lists+linux-bcache@lfdr.de>; Thu, 24 Dec 2020 15:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgLXOrr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Dec 2020 09:47:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:50646 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbgLXOrr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Dec 2020 09:47:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1C817ACC4;
        Thu, 24 Dec 2020 14:47:06 +0000 (UTC)
Subject: Re: [PATCH v2 -next] md: bcache: use DEFINE_MUTEX() for mutex lock
To:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201224132431.31180-1-zhengyongjun3@huawei.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <2cef0ad9-b179-ece0-8787-368b21a427f1@suse.de>
Date:   Thu, 24 Dec 2020 22:47:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224132431.31180-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/24/20 9:24 PM, Zheng Yongjun wrote:
> mutex lock can be initialized automatically with DEFINE_MUTEX()
> rather than explicitly calling mutex_init().
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

NACK. For this case, it is unnecessary to initialize a global variable
so early in declaration, this change makes bcache.ko bigger and I don't
see any benefit.

Coly Li

> ---
>  drivers/md/bcache/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 46a00134a36a..963d62a15f37 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -40,7 +40,7 @@ static const char invalid_uuid[] = {
>  };
>  
>  static struct kobject *bcache_kobj;
> -struct mutex bch_register_lock;
> +DEFINE_MUTEX(bch_register_lock);
>  bool bcache_is_reboot;
>  LIST_HEAD(bch_cache_sets);
>  static LIST_HEAD(uncached_devices);
> @@ -2832,7 +2832,6 @@ static int __init bcache_init(void)
>  
>  	check_module_parameters();
>  
> -	mutex_init(&bch_register_lock);
>  	init_waitqueue_head(&unregister_wait);
>  	register_reboot_notifier(&reboot);
>  
> 


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7912E1D6A
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 15:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgLWOXV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 09:23:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:41198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgLWOXV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 09:23:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C32C1ACF1;
        Wed, 23 Dec 2020 14:22:39 +0000 (UTC)
Subject: Re: [PATCH -next] md: bcache: use DEFINE_MUTEX (and mutex_init() had
 been too late)
To:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201223141215.32727-1-zhengyongjun3@huawei.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <f2b123a2-ba10-cff0-0c55-2c6558f150ec@suse.de>
Date:   Wed, 23 Dec 2020 22:22:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223141215.32727-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/23/20 10:12 PM, Zheng Yongjun wrote:
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

NACK. The commit log is necessary to explain why it is too late, IMHO I
don't find the implicit reason from the patch.

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


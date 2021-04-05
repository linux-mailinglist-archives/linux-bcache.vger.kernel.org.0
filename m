Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F7354287
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Apr 2021 16:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhDEOCw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 5 Apr 2021 10:02:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:55324 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235903AbhDEOCw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Apr 2021 10:02:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3FE55B2DA;
        Mon,  5 Apr 2021 14:02:45 +0000 (UTC)
To:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
References: <20210405101453.15096-1-zhengyongjun3@huawei.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH -next] bcache: use DEFINE_MUTEX() for mutex lock
Message-ID: <42c3e33d-c20e-0fdd-f316-5084e33f9a3b@suse.de>
Date:   Mon, 5 Apr 2021 22:02:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405101453.15096-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/5/21 6:14 PM, Zheng Yongjun wrote:
> mutex lock can be initialized automatically with DEFINE_MUTEX()
> rather than explicitly calling mutex_init().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

NACK. This is not the first time people try to "fix" this location...

Using DEFINE_MUTEX() does not gain anything for us, it will generate
unnecessary extra size for the bcache.ko.
ines.

> ---
>  drivers/md/bcache/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 78c08a8aece8..c124da6e646d 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -41,7 +41,7 @@ static const char invalid_uuid[] = {
>  };
>  
>  static struct kobject *bcache_kobj;
> -struct mutex bch_register_lock;


Hmm, maybe if you compose a patch to add comments for bch_register_lock,
for something like: Don't initialize global variable here. It might be
helpful for noticing people not to fixing this in future.

Thanks.

Coly Li

> +DEFINE_MUTEX(bch_register_lock);
>  bool bcache_is_reboot;
>  LIST_HEAD(bch_cache_sets);
>  static LIST_HEAD(uncached_devices);
> @@ -2870,7 +2870,6 @@ static int __init bcache_init(void)
>  
>  	check_module_parameters();
>  
> -	mutex_init(&bch_register_lock);
>  	init_waitqueue_head(&unregister_wait);
>  	register_reboot_notifier(&reboot);
>  
> 


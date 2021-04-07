Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9171935685F
	for <lists+linux-bcache@lfdr.de>; Wed,  7 Apr 2021 11:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346113AbhDGJuK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 7 Apr 2021 05:50:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:34386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346088AbhDGJuJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 7 Apr 2021 05:50:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 815FAAE06;
        Wed,  7 Apr 2021 09:49:59 +0000 (UTC)
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
References: <20210407093848.567720-1-zhengyongjun3@huawei.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH -next v2] bcache: use DEFINE_MUTEX() for mutex lock
Message-ID: <7037a34e-988e-dbf5-9bed-e40f5e11c36b@suse.de>
Date:   Wed, 7 Apr 2021 17:49:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407093848.567720-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/7/21 5:38 PM, Zheng Yongjun wrote:
> mutex lock can be initialized automatically with DEFINE_MUTEX() rather
> than explicitly calling mutex_init().
> 
> this patch will reduce the size of bcache.ko about 64 bytes, the reason
> as follows:
> 
> though this patch will increase the size of .data segment about 32 bytes,
> it will also reduce the size of .init.text and .rodata.str1.1(at x86_64),
> .rodata_str1.8(at arm64) and .bss segment total about 96 bytes which reduce
>  the size more than .data segment;
> 

Thanks for the following information. BTW, the bss section should be
ignored, because they don't take physical file size.

It seems although the patched code has larger .data section, but the
generated code in .init.text and .rodata.str1.1(or 8) are much lesser
than the increased size. This is really interesting :-)

Your data is convinced, it is fair to take this patch in.

Could you please post a v3 version which removes the .bss information ?


Coly Li


> here is the statistics:
> Sections: (arm64 platform)
> Idx name		size
> -.init.text		00000240
> +.init.text		00000228
> 
> -.rodata.str1.8	000012cd
> +.rodata.str1.8	000012b5
> 
> -.data			00000c60
> +.data			00000c80
> 
> -.bss			00000080
> +.bss			00000060
> 
> Sections: (x86 platform)
> Idx name		size
> -.init.text		000001d9
> +.init.text		000001bf
> 
> -.rodata.str1.1	00000c80
> +.rodata.str1.1	00000c6d
> 
> -.data			00000cc0
> +.data			00000ce0
> 
> -.bss			00000080
> +.bss			00000070
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/md/bcache/super.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 03e1fe4de53d..3635f454309e 100644
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
> @@ -2869,7 +2869,6 @@ static int __init bcache_init(void)
>  
>  	check_module_parameters();
>  
> -	mutex_init(&bch_register_lock);
>  	init_waitqueue_head(&unregister_wait);
>  	register_reboot_notifier(&reboot);
>  
> 


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F02836DEAE
	for <lists+linux-bcache@lfdr.de>; Wed, 28 Apr 2021 19:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243364AbhD1R4E (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Apr 2021 13:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243349AbhD1R4C (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Apr 2021 13:56:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6C0C06138A
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 10:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Tt80hesbLTgYrhbs0v+FP21iqxj0tkS428TeUH6qsAI=; b=WCCqtNMmSqkpnUVfhPuTKKycSQ
        0dihRh2+8xNd7FswdJ5+UpwEbKaqd6P8O6iBzArvHi6jw737R6XfGTqT1sHugK/Ip5x/SVX84GPfE
        2J8iRJ4jtaw5PWOdYTZqNp0iQJW5f6oZ6LbUxuX3W7XoB8jAq4Cqz3uA4DcqgTFpyE8tXIRO0H3Yb
        U4yD1BVu4typfY0QdUxi/rN6zFPBXX6NZXXFVV30KyV2MIW12CulLGPEXNHmewBeU9It3zCC82Pwt
        2rvg+YRTlQ39OCuIHQW0HnNsHiKrFoIIEZ0G3wLuX60VXPPNvo6m2YJZILQ+xwdCflf9JCDxo9IT/
        /OdSnq3A==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lboNu-008dOx-67; Wed, 28 Apr 2021 17:54:21 +0000
Subject: Re: [bch-nvm-pages v9 2/6] bcache: initialize the nvm pages allocator
To:     Qiaowei Ren <qiaowei.ren@intel.com>, linux-bcache@vger.kernel.org
Cc:     jianpeng.ma@intel.com, colyli@suse.de, rdunlap@infradead.oom,
        Colin Ian King <colin.king@canonical.com>
References: <20210428213952.197504-1-qiaowei.ren@intel.com>
 <20210428213952.197504-3-qiaowei.ren@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <69f9e7f2-b09c-ed9b-e08f-777ce374a7d7@infradead.org>
Date:   Wed, 28 Apr 2021 10:53:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210428213952.197504-3-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

On 4/28/21 2:39 PM, Qiaowei Ren wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This patch define the prototype data structures in memory and initializes
> the nvm pages allocator.
> 
> The nvm address space which is managed by this allocatior can consist of

                                                 allocator

> many nvm namespaces, and some namespaces can compose into one nvm set,
> like cache set. For this initial implementation, only one set can be
> supported.
> 
> The users of this nvm pages allocator need to call regiseter_namespace()

                                                     register_namespace()

> to register the nvdimm device (like /dev/pmemX) into this allocator as
> the instance of struct nvm_namespace.
> 
> v9:
>   -Fix Kconfig dependance error(Reported-by Randy)

                 dependence

>   -Fix an uninitialized return value(Colin)
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/md/bcache/Kconfig     |   8 +
>  drivers/md/bcache/Makefile    |   2 +-
>  drivers/md/bcache/nvm-pages.c | 285 ++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h |  74 +++++++++
>  drivers/md/bcache/super.c     |   3 +
>  5 files changed, 371 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/md/bcache/nvm-pages.c
>  create mode 100644 drivers/md/bcache/nvm-pages.h
> 
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index d1ca4d059c20..3057da4cf8ff 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -35,3 +35,11 @@ config BCACHE_ASYNC_REGISTRATION
>  	device path into this file will returns immediately and the real
>  	registration work is handled in kernel work queue in asynchronous
>  	way.
> +
> +config BCACHE_NVM_PAGES
> +	bool "NVDIMM support for bcache (EXPERIMENTAL)"
> +	depends on BCACHE
> +	depends on LIBNVDIMM
> +	depends on DAX
> +	help
> +	nvm pages allocator for bcache.
> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
> index 5b87e59676b8..948e5ed2ca66 100644
> --- a/drivers/md/bcache/Makefile
> +++ b/drivers/md/bcache/Makefile
> @@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
>  
>  bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
>  	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
> -	util.o writeback.o features.o
> +	util.o writeback.o features.o nvm-pages.o

This is not the right way to add an optional piece of code (nvm-pages.o)
to the full linked binary.

I.e., it is added unconditionally here and then inside its .c file, the
entire file is bracketed with (see below):

#ifdef CONFIG_BCACHE_NVM_PAGES
...
#endif /* CONFIG_BCACHE_NVM_PAGES */


The right way to do this is in Kconfig and Makefile changes alone,
and then nvm-pages.c does not need that huge #ifdef/#endif bracketing.


Documentation/kbuild/*.rst has some references to this, but it's probably
easier just to look at some examples.

E.g., see drivers/usb/common/: Kconfig and Makefile and how CONFIG_TRACING
adds debug.o to the usb-common-y binary build.
Same for USB_LED_TRIG and led.o.


> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> new file mode 100644
> index 000000000000..976ab9002c17
> --- /dev/null
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -0,0 +1,285 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Nvdimm page-buddy allocator
> + *
> + * Copyright (c) 2021, Intel Corporation.
> + * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
> + * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
> + */
> +
> +#ifdef CONFIG_BCACHE_NVM_PAGES

[delete many lines]

> +
> +#endif /* CONFIG_BCACHE_NVM_PAGES */


The header (.h) file also probably needs some fixing up.


thanks.
-- 
~Randy


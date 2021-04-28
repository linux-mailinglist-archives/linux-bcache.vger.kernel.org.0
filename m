Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AB36DD06
	for <lists+linux-bcache@lfdr.de>; Wed, 28 Apr 2021 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhD1QbV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 28 Apr 2021 12:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhD1QbT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 28 Apr 2021 12:31:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29877C061573
        for <linux-bcache@vger.kernel.org>; Wed, 28 Apr 2021 09:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ua8H7Z5N8EEQ55xxuzKFxaf1aGe85tC7y0xEVmSnuOI=; b=ANlVcP5gKYQF/flEwbGbeuq7r2
        gQq1XKuYtduEcz1X9BRIvrK+fAb5cn9v8mTOue18aLcwIok6J+9QyEbQcsRBKj9uV9nuwaT9NRFcO
        iXx5aHBqKBfuuotK09p/KkXeJgZ23f6Mh5cjWq9XYaByxGmpgvcgn+Up+echGCQpNE0JaiKXthpIT
        QNS9UV4C2bNgEgFzT3LQ5l7xXnAu6UeBA05RTsnlRKq0n1IpjdTUfhI6BbZ2HmcZWb3E3MNCMpSJJ
        s2QpqFth2xctJ/GTDyBvyISqS1WVi20uV+exntJQTHNnqGqqQYiljUIcwMsi2TDu0Pmc7P8mMj1Zw
        VqWsFXZQ==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lbn4G-008XkY-55; Wed, 28 Apr 2021 16:30:04 +0000
Subject: Re: [bch-nvm-pages v9 2/6] bcache: initialize the nvm pages allocator
To:     Qiaowei Ren <qiaowei.ren@intel.com>, linux-bcache@vger.kernel.org
Cc:     jianpeng.ma@intel.com, colyli@suse.de, rdunlap@infradead.oom,
        Colin Ian King <colin.king@canonical.com>
References: <20210428213952.197504-1-qiaowei.ren@intel.com>
 <20210428213952.197504-3-qiaowei.ren@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <779bb3fb-ad1c-35d0-c43d-b25d39200570@infradead.org>
Date:   Wed, 28 Apr 2021 09:29:36 -0700
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

On 4/28/21 2:39 PM, Qiaowei Ren wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This patch define the prototype data structures in memory and initializes
> the nvm pages allocator.
> 
> The nvm address space which is managed by this allocatior can consist of
> many nvm namespaces, and some namespaces can compose into one nvm set,
> like cache set. For this initial implementation, only one set can be
> supported.
> 
> The users of this nvm pages allocator need to call regiseter_namespace()
> to register the nvdimm device (like /dev/pmemX) into this allocator as
> the instance of struct nvm_namespace.
> 
> v9:
>   -Fix Kconfig dependance error(Reported-by Randy)
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

Please follow coding-style for Kconfig files:

(from Documentation/process/coding-style.rst, section 10):

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.


Also, that help text could be better.

-- 
~Randy


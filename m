Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2092DBEF4
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Dec 2020 11:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbgLPKrb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 05:47:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:51308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgLPKrb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 05:47:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E2D47AF45;
        Wed, 16 Dec 2020 10:46:49 +0000 (UTC)
Subject: Re: [RFC PATCH 5/8] bcache: nvm_free_pages() of the buddy
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     linux-bcache@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-6-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <4b3a3fe6-137f-5790-a106-c574bd63b115@suse.de>
Date:   Wed, 16 Dec 2020 18:46:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203105337.4592-6-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20 6:53 PM, Qiaowei Ren wrote:
> This patch implements the nvm_free_pages() of the buddy.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/nvm-pages.c | 142 ++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h |   2 +
>  2 files changed, 144 insertions(+)
> 

[snipped]

> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index 95b7fa4b7dd0..1e435ce0ddf4 100644
> --- a/drivers/md/bcache/nvm-pages.h
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -78,6 +78,7 @@ extern int bch_nvm_init(void);
>  extern void bch_nvm_exit(void);
>  
>  extern void *nvm_alloc_pages(int order, const char *owner_uuid);
> +extern void nvm_free_pages(void *addr, int order, const char *owner_uuid);

We should have a bch_ prefix for the above function, and maybe "extern"
can be removed here.

>  
>  #else
>  
> @@ -92,6 +93,7 @@ static inline int bch_nvm_init(void)
>  static inline void bch_nvm_exit(void) { }
>  
>  static inline void *nvm_alloc_pages(int order, const char *owner_uuid) { }
> +static inline void nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
>  
>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>  
> 

Thanks.

Coly Li

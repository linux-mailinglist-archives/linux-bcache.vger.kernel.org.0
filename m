Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9AB2DBEF9
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Dec 2020 11:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgLPKtG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 05:49:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:55006 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgLPKtG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 05:49:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F28B8AE76;
        Wed, 16 Dec 2020 10:48:24 +0000 (UTC)
Subject: Re: [RFC PATCH 6/8] bcache: get allocated pages from specific owner
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     linux-bcache@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-7-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <c13d9aca-fc4a-9486-7392-4181e7faa7fe@suse.de>
Date:   Wed, 16 Dec 2020 18:48:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203105337.4592-7-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20 6:53 PM, Qiaowei Ren wrote:
> This patch implements get_allocated_pages() of the buddy to be used to
> get allocated pages from specific owner.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/nvm-pages.c | 36 +++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h |  7 +++++++
>  2 files changed, 43 insertions(+)
> 

[snipped]

> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index 1e435ce0ddf4..4f0374459459 100644
> --- a/drivers/md/bcache/nvm-pages.h
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -80,6 +80,8 @@ extern void bch_nvm_exit(void);
>  extern void *nvm_alloc_pages(int order, const char *owner_uuid);
>  extern void nvm_free_pages(void *addr, int order, const char *owner_uuid);
>  
> +extern struct extent *get_allocated_pages(const char *owner_uuid);
> +


We should have a bch_ prefix for the above function name, and maybe
"extern" can be removed here too.


>  #else
>  
>  static inline struct nvm_namespace *register_namespace(const char *dev_path)
> @@ -95,6 +97,11 @@ static inline void bch_nvm_exit(void) { }
>  static inline void *nvm_alloc_pages(int order, const char *owner_uuid) { }
>  static inline void nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
>  
> +static inline struct extent *get_allocated_pages(const char *owner_uuid)
> +{
> +	return NULL;
> +}
> +
>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>  
>  #endif /* _BCACHE_NVM_PAGES_H */

Thanks

Coly Li


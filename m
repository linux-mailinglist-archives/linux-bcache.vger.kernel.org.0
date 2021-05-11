Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A8037A7FE
	for <lists+linux-bcache@lfdr.de>; Tue, 11 May 2021 15:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhEKNq0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 11 May 2021 09:46:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:59964 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231461AbhEKNqY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 May 2021 09:46:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BFB35AE81;
        Tue, 11 May 2021 13:45:16 +0000 (UTC)
Subject: Re: [bch-nvm-pages v9 6/6] bcache: get allocated pages from specific
 owner
To:     Qiaowei Ren <qiaowei.ren@intel.com>, jianpeng.ma@intel.com
Cc:     linux-bcache@vger.kernel.org
References: <20210428213952.197504-1-qiaowei.ren@intel.com>
 <20210428213952.197504-7-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <dc4386c6-dc67-08da-cf45-2c983aea7ddc@suse.de>
Date:   Tue, 11 May 2021 21:45:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210428213952.197504-7-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/29/21 5:39 AM, Qiaowei Ren wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This patch implements bch_get_allocated_pages() of the buddy to be used to
> get allocated pages from specific owner.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/nvm-pages.c | 6 ++++++
>  drivers/md/bcache/nvm-pages.h | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 39807046ecce..0be89a03255c 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -389,6 +389,12 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>  }
>  EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
>  
> +struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
> +{
> +	return find_owner_head(owner_uuid, false);
> +}
> +EXPORT_SYMBOL_GPL(bch_get_allocated_pages);
> +
>  static int init_owner_info(struct bch_nvm_namespace *ns)
>  {
>  	struct bch_owner_list_head *owner_list_head = ns->sb->owner_list_head;
> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index 918aee6a9afc..cfb3e8ef01ee 100644
> --- a/drivers/md/bcache/nvm-pages.h
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -64,6 +64,7 @@ int bch_nvm_init(void);
>  void bch_nvm_exit(void);
>  void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
>  void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
> +struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid);
>  
>  #else
>  
> @@ -81,6 +82,10 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>  	return NULL;
>  }
>  static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
> +static inline struct bch_nvm_pages_owner_head *bch_get_allocated_pages(const char *owner_uuid)
> +{
> +	return NULL;
> +}
>  
>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>  
> 

It looks fine to me. Thanks for the great work :-)

Coly Li


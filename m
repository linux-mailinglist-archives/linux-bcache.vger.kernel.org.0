Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC8B2DBEF0
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Dec 2020 11:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgLPKo6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 05:44:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:49300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgLPKo6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 05:44:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BEE17AF3E;
        Wed, 16 Dec 2020 10:44:16 +0000 (UTC)
Subject: Re: [RFC PATCH 4/8] bcache: nvm_alloc_pages() of the buddy
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     linux-bcache@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-5-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <a89eb5fd-693c-59aa-d270-6c083cc2cbca@suse.de>
Date:   Wed, 16 Dec 2020 18:44:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203105337.4592-5-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20 6:53 PM, Qiaowei Ren wrote:
> This patch implements the nvm_alloc_pages() of the buddy.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/nvm-pages.c | 136 ++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h |   4 +
>  2 files changed, 140 insertions(+)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 7ffbfbacaf3f..2cde62081c4f 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -95,6 +95,142 @@ static inline void remove_owner_space(struct nvm_namespace *ns,
>  	bitmap_set(ns->pages_bitmap, pgoff, nr);
>  }

[snipped]

> +
> +void *nvm_alloc_pages(int order, const char *owner_uuid)
> +{
> +	void *kaddr = NULL;
> +	struct owner_list *owner_list;
> +	struct nvm_alloced_recs *alloced_recs;
> +	int i, j;
> +
> +	mutex_lock(&only_set->lock);
> +	owner_list = find_owner_list(owner_uuid, true);
> +
> +	for (j = 0; j < only_set->total_namespaces_nr; j++) {
> +		struct nvm_namespace *ns = only_set->nss[j];
> +
> +		if (!ns || (ns->free < (1 << order)))
> +			continue;
> +
> +		for (i = order; i < MAX_ORDER; i++) {
> +			struct list_head *list;
> +			struct page *page, *buddy_page;
> +
> +			if (list_empty(&ns->free_area[i]))
> +				continue;
> +
> +			list = ns->free_area[i].next;
> +			page = container_of((void *)list, struct page, zone_device_data);
> +
> +			list_del(list);
> +
> +			while (i != order) {
> +				buddy_page = nvm_vaddr_to_page(ns,
> +					nvm_pgoff_to_vaddr(ns, page->index + (1 << (i - 1))));
> +				buddy_page->private = i - 1;
> +				buddy_page->index = page->index + (1 << (i - 1));
> +				__SetPageBuddy(buddy_page);
> +				list_add((struct list_head *)&buddy_page->zone_device_data,
> +					&ns->free_area[i - 1]);
> +				i--;
> +			}
> +
> +			page->private = order;
> +			__ClearPageBuddy(page);
> +			ns->free -= 1 << order;
> +			kaddr = nvm_pgoff_to_vaddr(ns, page->index);
> +			break;
> +		}
> +
> +		if (i != MAX_ORDER) {
> +			alloced_recs = find_nvm_alloced_recs(owner_list, ns, true);
> +			add_extent(alloced_recs, kaddr, order);
> +			break;
> +		}
> +	}
> +
> +	mutex_unlock(&only_set->lock);
> +	return kaddr;
> +}
> +EXPORT_SYMBOL_GPL(nvm_alloc_pages);


It is better to name it as bch_nvmd_alloc_pages() now.


> +
>  static void init_owner_info(struct nvm_namespace *ns)
>  {
>  	struct owner_list_head *owner_list_head;
> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index d91352496af1..95b7fa4b7dd0 100644
> --- a/drivers/md/bcache/nvm-pages.h
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -77,6 +77,8 @@ extern struct nvm_namespace *register_namespace(const char *dev_path);
>  extern int bch_nvm_init(void);
>  extern void bch_nvm_exit(void);
>  
> +extern void *nvm_alloc_pages(int order, const char *owner_uuid);
> +

Maybe we don't need "extern" here.


>  #else
>  
>  static inline struct nvm_namespace *register_namespace(const char *dev_path)
> @@ -89,6 +91,8 @@ static inline int bch_nvm_init(void)
>  }
>  static inline void bch_nvm_exit(void) { }
>  
> +static inline void *nvm_alloc_pages(int order, const char *owner_uuid) { }

The above should be,

static inline void *nvm_alloc_pages(int order, const char *owner_uuid)
{return NULL;}

> +
>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>  
>  #endif /* _BCACHE_NVM_PAGES_H */
> 

Thanks.

Coly Li

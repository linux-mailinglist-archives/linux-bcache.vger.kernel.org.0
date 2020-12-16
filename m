Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2E82DBEFC
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Dec 2020 11:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbgLPKua (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 05:50:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:55432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgLPKua (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 05:50:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 918E0AC91;
        Wed, 16 Dec 2020 10:49:48 +0000 (UTC)
Subject: Re: [RFC PATCH 7/8] bcache: persist owner info when alloc/free pages.
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     linux-bcache@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-8-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <275018af-373f-df0c-bf53-1148a8e250e2@suse.de>
Date:   Wed, 16 Dec 2020 18:49:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203105337.4592-8-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20 6:53 PM, Qiaowei Ren wrote:
> This patch implement persist owner info on nvdimm device
> when alloc/free pages.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>

Reviwed-by: Coly Li <colyli@suse.de>


This patch can be improved, but the current shape is OK to me as a start.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/nvm-pages.c | 86 +++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index e8765b0b3398..ba1ff0582b20 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -197,6 +197,17 @@ static struct nvm_namespace *find_nvm_by_addr(void *addr, int order)
>  	return NULL;
>  }
>  
> +static void init_pgalloc_recs(struct nvm_pgalloc_recs *recs, const char *owner_uuid)
> +{
> +	memset(recs, 0, sizeof(struct nvm_pgalloc_recs));
> +	memcpy(recs->owner_uuid, owner_uuid, 16);
> +}
> +
> +static pgoff_t vaddr_to_nvm_pgoff(struct nvm_namespace *ns, void *kaddr)
> +{
> +	return (kaddr - ns->kaddr - ns->pages_offset) / PAGE_SIZE;
> +}
> +
>  static int remove_extent(struct nvm_alloced_recs *alloced_recs, void *addr, int order)
>  {
>  	struct list_head *list = alloced_recs->extent_head.next;
> @@ -275,6 +286,77 @@ static void __free_space(struct nvm_namespace *ns, void *addr, int order)
>  	ns->free += add_pages;
>  }
>  
> +#define RECS_LEN (sizeof(struct nvm_pgalloc_recs))
> +
> +static void write_owner_info(void)
> +{
> +	struct owner_list *owner_list;
> +	struct nvm_pages_owner_head *owner_head;
> +	struct nvm_pgalloc_recs *recs;
> +	struct extent *extent;
> +	struct nvm_namespace *ns = only_set->nss[0];
> +	struct owner_list_head *owner_list_head;
> +	bool update_owner = false;
> +	u64 recs_pos = NVM_PAGES_SYS_RECS_HEAD_OFFSET;
> +	struct list_head *list;
> +	int i, j;
> +
> +	owner_list_head = kzalloc(sizeof(struct owner_list_head), GFP_KERNEL);
> +	recs = kmalloc(RECS_LEN, GFP_KERNEL);
> +
> +	// in-memory owner maybe not contain alloced-pages.
> +	for (i = 0; i < only_set->owner_list_size; i++) {
> +		owner_head = &owner_list_head->heads[owner_list_head->size];
> +		owner_list = only_set->owner_lists[i];
> +
> +		for (j = 0; j < only_set->total_namespaces_nr; j++) {
> +			struct nvm_alloced_recs *extents = owner_list->alloced_recs[j];
> +
> +			if (!extents || !extents->size)
> +				continue;
> +
> +			init_pgalloc_recs(recs, owner_list->owner_uuid);
> +
> +			BUG_ON(recs_pos >= NVM_PAGES_OFFSET);
> +			owner_head->recs[j] = (struct nvm_pgalloc_recs *)recs_pos;
> +
> +			for (list = extents->extent_head.next;
> +				list != &extents->extent_head;
> +				list = list->next) {
> +				extent = container_of(list, struct extent, list);
> +
> +				if (recs->size == MAX_RECORD) {
> +					BUG_ON(recs_pos >= NVM_PAGES_OFFSET);
> +					recs->next =
> +						(struct nvm_pgalloc_recs *)(recs_pos + RECS_LEN);
> +					memcpy_flushcache(ns->kaddr + recs_pos, recs, RECS_LEN);
> +					init_pgalloc_recs(recs, owner_list->owner_uuid);
> +					recs_pos += RECS_LEN;
> +				}
> +
> +				recs->recs[recs->size].pgoff =
> +					vaddr_to_nvm_pgoff(only_set->nss[j], extent->kaddr);
> +				recs->recs[recs->size].nr = extent->nr;
> +				recs->size++;
> +			}
> +
> +			update_owner = true;
> +			memcpy_flushcache(ns->kaddr + recs_pos, recs, RECS_LEN);
> +			recs_pos += sizeof(struct nvm_pgalloc_recs);
> +		}
> +
> +		if (update_owner) {
> +			memcpy(owner_head->uuid, owner_list->owner_uuid, 16);
> +			owner_list_head->size++;
> +			update_owner = false;
> +		}
> +	}
> +
> +	memcpy_flushcache(ns->kaddr + NVM_PAGES_OWNER_LIST_HEAD_OFFSET,
> +				(void *)owner_list_head, sizeof(struct owner_list_head));
> +	kfree(owner_list_head);
> +}
> +
>  void nvm_free_pages(void *addr, int order, const char *owner_uuid)
>  {
>  	struct nvm_namespace *ns;
> @@ -309,6 +391,7 @@ void nvm_free_pages(void *addr, int order, const char *owner_uuid)
>  	}
>  
>  	__free_space(ns, addr, order);
> +	write_owner_info();
>  
>  unlock:
>  	mutex_unlock(&only_set->lock);
> @@ -368,7 +451,10 @@ void *nvm_alloc_pages(int order, const char *owner_uuid)
>  		}
>  	}
>  
> +	if (kaddr)
> +		write_owner_info();
>  	mutex_unlock(&only_set->lock);
> +
>  	return kaddr;
>  }
>  EXPORT_SYMBOL_GPL(nvm_alloc_pages);
> 


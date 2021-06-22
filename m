Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5D3B01D2
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 12:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFVKzu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 06:55:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47180 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhFVKzt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 06:55:49 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2FE252197B;
        Tue, 22 Jun 2021 10:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fb+GhFJ5qaVu9F7yk9c1nnvBVFoMv+X6eF/zYB+oe/U=;
        b=NOU/FJ840NwxmFGlSRjhGDJt7f0GPRSxpIC96v02e+znVwfc4LyefkkmIyEpQZDMy9/cmG
        NlWmCcPdkRzt712TmTSTiSh8BmN1ac9M7mPIsWUEXrJPnEhF06qD+9jHS5bS6e0YDLtEhU
        NOo9ouWeHc5dTXu8rb7Cv1c88AxNAlg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359212;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fb+GhFJ5qaVu9F7yk9c1nnvBVFoMv+X6eF/zYB+oe/U=;
        b=/ixnCrX6mtNFEc2Vi0ZQZlstzTWdAZWZFuefqCulekWRzjDTrq6h/7bs9iWnRB+Zi4Masz
        9ogEWEW3bX5eP5Dg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 1EAF4118DD;
        Tue, 22 Jun 2021 10:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359212; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fb+GhFJ5qaVu9F7yk9c1nnvBVFoMv+X6eF/zYB+oe/U=;
        b=NOU/FJ840NwxmFGlSRjhGDJt7f0GPRSxpIC96v02e+znVwfc4LyefkkmIyEpQZDMy9/cmG
        NlWmCcPdkRzt712TmTSTiSh8BmN1ac9M7mPIsWUEXrJPnEhF06qD+9jHS5bS6e0YDLtEhU
        NOo9ouWeHc5dTXu8rb7Cv1c88AxNAlg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359212;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fb+GhFJ5qaVu9F7yk9c1nnvBVFoMv+X6eF/zYB+oe/U=;
        b=/ixnCrX6mtNFEc2Vi0ZQZlstzTWdAZWZFuefqCulekWRzjDTrq6h/7bs9iWnRB+Zi4Masz
        9ogEWEW3bX5eP5Dg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id v6FlByzB0WChWgAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 10:53:32 +0000
Subject: Re: [PATCH 07/14] bcache: bch_nvm_free_pages() of the buddy
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-8-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <327edd3d-c239-9099-5e2a-448dcc7a972f@suse.de>
Date:   Tue, 22 Jun 2021 12:53:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-8-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This patch implements the bch_nvm_free_pages() of the buddy.
> 
> The difference between this and page-buddy-free:
> it need owner_uuid to free owner allocated pages.And must
> persistent after free.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/nvm-pages.c | 164 ++++++++++++++++++++++++++++++++--
>  drivers/md/bcache/nvm-pages.h |   3 +-
>  2 files changed, 159 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 5d095d241483..74d08950c67c 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -52,7 +52,7 @@ static void release_nvm_set(struct bch_nvm_set *nvm_set)
>  	kfree(nvm_set);
>  }
>  
> -static struct page *nvm_vaddr_to_page(struct bch_nvm_namespace *ns, void *addr)
> +static struct page *nvm_vaddr_to_page(void *addr)
>  {
>  	return virt_to_page(addr);
>  }

If you don't need this argument please modify the patch adding the
nvm_vaddr_to_page() function.

> @@ -183,6 +183,155 @@ static void add_pgalloc_rec(struct bch_nvm_pgalloc_recs *recs, void *kaddr, int
>  	BUG_ON(i == recs->size);
>  }
>  
> +static inline void *nvm_end_addr(struct bch_nvm_namespace *ns)
> +{
> +	return ns->kaddr + (ns->pages_total << PAGE_SHIFT);
> +}
> +
> +static inline bool in_nvm_range(struct bch_nvm_namespace *ns,
> +		void *start_addr, void *end_addr)
> +{
> +	return (start_addr >= ns->kaddr) && (end_addr < nvm_end_addr(ns));
> +}
> +
> +static struct bch_nvm_namespace *find_nvm_by_addr(void *addr, int order)
> +{
> +	int i;
> +	struct bch_nvm_namespace *ns;
> +
> +	for (i = 0; i < only_set->total_namespaces_nr; i++) {
> +		ns = only_set->nss[i];
> +		if (ns && in_nvm_range(ns, addr, addr + (1L << order)))
> +			return ns;
> +	}
> +	return NULL;
> +}
> +
> +static int remove_pgalloc_rec(struct bch_nvm_pgalloc_recs *pgalloc_recs, int ns_nr,
> +				void *kaddr, int order)
> +{
> +	struct bch_nvm_pages_owner_head *owner_head = pgalloc_recs->owner;
> +	struct bch_nvm_pgalloc_recs *prev_recs, *sys_recs;
> +	u64 pgoff = (unsigned long)kaddr >> PAGE_SHIFT;
> +	struct bch_nvm_namespace *ns = only_set->nss[0];
> +	int i;
> +
> +	prev_recs = pgalloc_recs;
> +	sys_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
> +	while (pgalloc_recs) {
> +		for (i = 0; i < pgalloc_recs->size; i++) {
> +			struct bch_pgalloc_rec *rec = &(pgalloc_recs->recs[i]);
> +
> +			if (rec->pgoff == pgoff) {
> +				WARN_ON(rec->order != order);
> +				rec->pgoff = 0;
> +				rec->order = 0;
> +				pgalloc_recs->used--;
> +
> +				if (pgalloc_recs->used == 0) {
> +					int recs_pos = pgalloc_recs - sys_recs;
> +
> +					if (pgalloc_recs == prev_recs)
> +						owner_head->recs[ns_nr] = pgalloc_recs->next;
> +					else
> +						prev_recs->next = pgalloc_recs->next;
> +
> +					pgalloc_recs->next = NULL;
> +					pgalloc_recs->owner = NULL;
> +
> +					bitmap_clear(ns->pgalloc_recs_bitmap, recs_pos, 1);
> +				}
> +				goto exit;
> +			}
> +		}
> +		prev_recs = pgalloc_recs;
> +		pgalloc_recs = pgalloc_recs->next;
> +	}
> +exit:
> +	return pgalloc_recs ? 0 : -ENOENT;
> +}
> +
> +static void __free_space(struct bch_nvm_namespace *ns, void *addr, int order)
> +{
> +	unsigned long add_pages = (1L << order);
> +	pgoff_t pgoff;
> +	struct page *page;
> +
> +	page = nvm_vaddr_to_page(addr);
> +	WARN_ON((!page) || (page->private != order));
> +	pgoff = page->index;
> +
> +	while (order < BCH_MAX_ORDER - 1) {
> +		struct page *buddy_page;
> +
> +		pgoff_t buddy_pgoff = pgoff ^ (1L << order);
> +		pgoff_t parent_pgoff = pgoff & ~(1L << order);
> +
> +		if ((parent_pgoff + (1L << (order + 1)) > ns->pages_total))
> +			break;
> +
> +		buddy_page = nvm_vaddr_to_page(nvm_pgoff_to_vaddr(ns, buddy_pgoff));
> +		WARN_ON(!buddy_page);
> +
> +		if (PageBuddy(buddy_page) && (buddy_page->private == order)) {
> +			list_del((struct list_head *)&buddy_page->zone_device_data);
> +			__ClearPageBuddy(buddy_page);
> +			pgoff = parent_pgoff;
> +			order++;
> +			continue;
> +		}
> +		break;
> +	}
> +
> +	page = nvm_vaddr_to_page(nvm_pgoff_to_vaddr(ns, pgoff));
> +	WARN_ON(!page);
> +	list_add((struct list_head *)&page->zone_device_data, &ns->free_area[order]);
> +	page->index = pgoff;
> +	set_page_private(page, order);
> +	__SetPageBuddy(page);
> +	ns->free += add_pages;
> +}
> +
> +void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid)
> +{
> +	struct bch_nvm_namespace *ns;
> +	struct bch_nvm_pages_owner_head *owner_head;
> +	struct bch_nvm_pgalloc_recs *pgalloc_recs;
> +	int r;
> +
> +	mutex_lock(&only_set->lock);
> +
> +	ns = find_nvm_by_addr(addr, order);
> +	if (!ns) {
> +		pr_err("can't find nvm_dev by kaddr %p\n", addr);
> +		goto unlock;
> +	}
> +
> +	owner_head = find_owner_head(owner_uuid, false);
> +	if (!owner_head) {
> +		pr_err("can't found bch_nvm_pages_owner_head by(uuid=%s)\n", owner_uuid);
> +		goto unlock;
> +	}
> +
> +	pgalloc_recs = find_nvm_pgalloc_recs(ns, owner_head, false);
> +	if (!pgalloc_recs) {
> +		pr_err("can't find bch_nvm_pgalloc_recs by(uuid=%s)\n", owner_uuid);
> +		goto unlock;
> +	}
> +
> +	r = remove_pgalloc_rec(pgalloc_recs, ns->sb->this_namespace_nr, addr, order);
> +	if (r < 0) {
> +		pr_err("can't find bch_pgalloc_rec\n");
> +		goto unlock;
> +	}
> +
> +	__free_space(ns, addr, order);
> +
> +unlock:
> +	mutex_unlock(&only_set->lock);
> +}
> +EXPORT_SYMBOL_GPL(bch_nvm_free_pages);
> +
>  void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>  {
>  	void *kaddr = NULL;
> @@ -217,7 +366,7 @@ void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>  			list_del(list);
>  
>  			while (i != order) {
> -				buddy_page = nvm_vaddr_to_page(ns,
> +				buddy_page = nvm_vaddr_to_page(
>  					nvm_pgoff_to_vaddr(ns, page->index + (1L << (i - 1))));
>  				set_page_private(buddy_page, i - 1);
>  				buddy_page->index = page->index + (1L << (i - 1));
> @@ -301,7 +450,7 @@ static int init_owner_info(struct bch_nvm_namespace *ns)
>  						BUG_ON(rec->pgoff <= offset);
>  
>  						/* init struct page: index/private */
> -						page = nvm_vaddr_to_page(ns,
> +						page = nvm_vaddr_to_page(
>  							BCH_PGOFF_TO_KVADDR(rec->pgoff));
>  
>  						set_page_private(page, rec->order);
> @@ -340,11 +489,12 @@ static void init_nvm_free_space(struct bch_nvm_namespace *ns)
>  					break;
>  			}
>  
> -			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
> +			page = nvm_vaddr_to_page(nvm_pgoff_to_vaddr(ns, pgoff_start));
>  			page->index = pgoff_start;
>  			set_page_private(page, i);
> -			__SetPageBuddy(page);
> -			list_add((struct list_head *)&page->zone_device_data, &ns->free_area[i]);
> +
> +			/* in order to update ns->free */
> +			__free_space(ns, nvm_pgoff_to_vaddr(ns, pgoff_start), i);
>  
>  			pgoff_start += 1L << i;
>  			pages -= 1L << i;
> @@ -535,7 +685,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
>  	ns->page_size = ns->sb->page_size;
>  	ns->pages_offset = ns->sb->pages_offset;
>  	ns->pages_total = ns->sb->pages_total;
> -	ns->free = 0;
> +	ns->free = 0; /* increase by __free_space() */
>  	ns->bdev = bdev;
>  	ns->nvm_set = only_set;
>  	mutex_init(&ns->lock);
> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index f2583723aca6..0ca699166855 100644
> --- a/drivers/md/bcache/nvm-pages.h
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -63,6 +63,7 @@ struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
>  int bch_nvm_init(void);
>  void bch_nvm_exit(void);
>  void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
> +void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid);
>  
>  #else
>  
> @@ -79,7 +80,7 @@ static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>  {
>  	return NULL;
>  }
> -
> +static inline void bch_nvm_free_pages(void *addr, int order, const char *owner_uuid) { }
>  
>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>  
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

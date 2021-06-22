Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA123B01C6
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Jun 2021 12:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhFVKxW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Jun 2021 06:53:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46740 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbhFVKxV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Jun 2021 06:53:21 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0F35A2197B;
        Tue, 22 Jun 2021 10:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3xpYXUrrKugrXWyHt2Wmrg8BKK4R9gM5JsQ55xPsL0=;
        b=cviH+n2QUmanmSBNWjdCLd+ounrUf9fNBLsG+PJ8MlkteG1UxN52OGT/r4y4cmyqNAwTwt
        SHquZDxsO9OfH6wgMBNqOkd529r9kn6YjqsmqSDnFOFMj+CH1ej42ABAed/IgIBSlS6Vyd
        opZ+kOcQ7I33vnhsqFnRTde3RaKPItI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359065;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3xpYXUrrKugrXWyHt2Wmrg8BKK4R9gM5JsQ55xPsL0=;
        b=Tc3sVUQXxphRVzEoCeobzfu2HbTXdx283nr/bb+GJiWWLP0II3qgmYeQSh1vDoGCfVmwvk
        cODGCrVEsK7Q7NDA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id F375B118DD;
        Tue, 22 Jun 2021 10:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624359065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3xpYXUrrKugrXWyHt2Wmrg8BKK4R9gM5JsQ55xPsL0=;
        b=cviH+n2QUmanmSBNWjdCLd+ounrUf9fNBLsG+PJ8MlkteG1UxN52OGT/r4y4cmyqNAwTwt
        SHquZDxsO9OfH6wgMBNqOkd529r9kn6YjqsmqSDnFOFMj+CH1ej42ABAed/IgIBSlS6Vyd
        opZ+kOcQ7I33vnhsqFnRTde3RaKPItI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624359065;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l3xpYXUrrKugrXWyHt2Wmrg8BKK4R9gM5JsQ55xPsL0=;
        b=Tc3sVUQXxphRVzEoCeobzfu2HbTXdx283nr/bb+GJiWWLP0II3qgmYeQSh1vDoGCfVmwvk
        cODGCrVEsK7Q7NDA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id TTupOpjA0WB6WQAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 22 Jun 2021 10:51:04 +0000
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-7-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/14] bcache: bch_nvm_alloc_pages() of the buddy
Message-ID: <34dc388c-ccbf-3b09-8254-188d183c3d26@suse.de>
Date:   Tue, 22 Jun 2021 12:51:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210615054921.101421-7-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/15/21 7:49 AM, Coly Li wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This patch implements the bch_nvm_alloc_pages() of the buddy.
> In terms of function, this func is like current-page-buddy-alloc.
> But the differences are:
> a: it need owner_uuid as parameter which record owner info. And it
> make those info persistence.
> b: it don't need flags like GFP_*. All allocs are the equal.
> c: it don't trigger other ops etc swap/recycle.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>  drivers/md/bcache/nvm-pages.c   | 174 ++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h   |   6 ++
>  include/uapi/linux/bcache-nvm.h |   6 +-
>  3 files changed, 184 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 804ee66e97be..5d095d241483 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -74,6 +74,180 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
>  	}
>  }
>  
> +/* If not found, it will create if create == true */
> +static struct bch_nvm_pages_owner_head *find_owner_head(const char *owner_uuid, bool create)
> +{
> +	struct bch_owner_list_head *owner_list_head = only_set->owner_list_head;
> +	struct bch_nvm_pages_owner_head *owner_head = NULL;
> +	int i;
> +
> +	if (owner_list_head == NULL)
> +		goto out;
> +
> +	for (i = 0; i < only_set->owner_list_used; i++) {
> +		if (!memcmp(owner_uuid, owner_list_head->heads[i].uuid, 16)) {
> +			owner_head = &(owner_list_head->heads[i]);
> +			break;
> +		}
> +	}
> +

Please, don't name is 'heads'. If this is supposed to be a linked list,
use the standard list implementation and initialize the pointers correctly.
If it isn't use an array (as you know in advance how many array entries
you can allocate).

> +	if (!owner_head && create) {
> +		u32 used = only_set->owner_list_used;
> +
> +		if (only_set->owner_list_size > used) {
> +			memcpy_flushcache(owner_list_head->heads[used].uuid, owner_uuid, 16);
> +			only_set->owner_list_used++;
> +
> +			owner_list_head->used++;
> +			owner_head = &(owner_list_head->heads[used]);
> +		} else
> +			pr_info("no free bch_nvm_pages_owner_head\n");
> +	}
> +
> +out:
> +	return owner_head;
> +}
> +
> +static struct bch_nvm_pgalloc_recs *find_empty_pgalloc_recs(void)
> +{
> +	unsigned int start;
> +	struct bch_nvm_namespace *ns = only_set->nss[0];
> +	struct bch_nvm_pgalloc_recs *recs;
> +
> +	start = bitmap_find_next_zero_area(ns->pgalloc_recs_bitmap, BCH_MAX_PGALLOC_RECS, 0, 1, 0);
> +	if (start > BCH_MAX_PGALLOC_RECS) {
> +		pr_info("no free struct bch_nvm_pgalloc_recs\n");
> +		return NULL;
> +	}
> +
> +	bitmap_set(ns->pgalloc_recs_bitmap, start, 1);
> +	recs = (struct bch_nvm_pgalloc_recs *)(ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET)
> +		+ start;
> +	return recs;
> +}
> +
> +static struct bch_nvm_pgalloc_recs *find_nvm_pgalloc_recs(struct bch_nvm_namespace *ns,
> +		struct bch_nvm_pages_owner_head *owner_head, bool create)
> +{
> +	int ns_nr = ns->sb->this_namespace_nr;
> +	struct bch_nvm_pgalloc_recs *prev_recs = NULL, *recs = owner_head->recs[ns_nr];
> +
> +	/* If create=false, we return recs[nr] */
> +	if (!create)
> +		return recs;
> +
> +	/*
> +	 * If create=true, it mean we need a empty struct bch_pgalloc_rec
> +	 * So we should find non-empty struct bch_nvm_pgalloc_recs or alloc
> +	 * new struct bch_nvm_pgalloc_recs. And return this bch_nvm_pgalloc_recs
> +	 */
> +	while (recs && (recs->used == recs->size)) {
> +		prev_recs = recs;
> +		recs = recs->next;
> +	}
> +
> +	/* Found empty struct bch_nvm_pgalloc_recs */
> +	if (recs)
> +		return recs;
> +	/* Need alloc new struct bch_nvm_galloc_recs */
> +	recs = find_empty_pgalloc_recs();
> +	if (recs) {
> +		recs->next = NULL;
> +		recs->owner = owner_head;
> +		memcpy_flushcache(recs->magic, bch_nvm_pages_pgalloc_magic, 16);
> +		memcpy_flushcache(recs->owner_uuid, owner_head->uuid, 16);
> +		recs->size = BCH_MAX_RECS;
> +		recs->used = 0;
> +
> +		if (prev_recs)
> +			prev_recs->next = recs;
> +		else
> +			owner_head->recs[ns_nr] = recs;
> +	}
> +

Wouldn't it be easier if the bitmap covers the entire range, and not
just the non-empty ones?
Eventually (ie if the NVM set becomes full) it'll cover it anyway, so
can't we save ourselves some time to allocate a large enough bitmap
upfront and only use it do figure out empty recs?

> +	return recs;
> +}
> +
> +static void add_pgalloc_rec(struct bch_nvm_pgalloc_recs *recs, void *kaddr, int order)
> +{
> +	int i;
> +
> +	for (i = 0; i < recs->size; i++) {
> +		if (recs->recs[i].pgoff == 0) {
> +			recs->recs[i].pgoff = (unsigned long)kaddr >> PAGE_SHIFT;
> +			recs->recs[i].order = order;
> +			recs->used++;
> +			break;
> +		}
> +	}
> +	BUG_ON(i == recs->size);
> +}
> +
> +void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
> +{
> +	void *kaddr = NULL;
> +	struct bch_nvm_pgalloc_recs *pgalloc_recs;
> +	struct bch_nvm_pages_owner_head *owner_head;
> +	int i, j;
> +
> +	mutex_lock(&only_set->lock);
> +	owner_head = find_owner_head(owner_uuid, true);
> +
> +	if (!owner_head) {
> +		pr_err("can't find bch_nvm_pgalloc_recs by(uuid=%s)\n", owner_uuid);
> +		goto unlock;
> +	}
> +
> +	for (j = 0; j < only_set->total_namespaces_nr; j++) {
> +		struct bch_nvm_namespace *ns = only_set->nss[j];
> +
> +		if (!ns || (ns->free < (1L << order)))
> +			continue;
> +
> +		for (i = order; i < BCH_MAX_ORDER; i++) {
> +			struct list_head *list;
> +			struct page *page, *buddy_page;
> +
> +			if (list_empty(&ns->free_area[i]))
> +				continue;
> +
> +			list = ns->free_area[i].next;

list_first_entry()?

> +			page = container_of((void *)list, struct page, zone_device_data);
> +
> +			list_del(list);
> +
> +			while (i != order) {
> +				buddy_page = nvm_vaddr_to_page(ns,
> +					nvm_pgoff_to_vaddr(ns, page->index + (1L << (i - 1))));
> +				set_page_private(buddy_page, i - 1);
> +				buddy_page->index = page->index + (1L << (i - 1));
> +				__SetPageBuddy(buddy_page);
> +				list_add((struct list_head *)&buddy_page->zone_device_data,
> +					&ns->free_area[i - 1]);
> +				i--;
> +			}
> +
> +			set_page_private(page, order);
> +			__ClearPageBuddy(page);
> +			ns->free -= 1L << order;
> +			kaddr = nvm_pgoff_to_vaddr(ns, page->index);
> +			break;
> +		}
> +
> +		if (i < BCH_MAX_ORDER) {
> +			pgalloc_recs = find_nvm_pgalloc_recs(ns, owner_head, true);
> +			/* ToDo: handle pgalloc_recs==NULL */
> +			add_pgalloc_rec(pgalloc_recs, kaddr, order);
> +			break;
> +		}
> +	}
> +
> +unlock:
> +	mutex_unlock(&only_set->lock);
> +	return kaddr;
> +}
> +EXPORT_SYMBOL_GPL(bch_nvm_alloc_pages);
> +
>  #define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
>  
>  static int init_owner_info(struct bch_nvm_namespace *ns)
> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index 71beb244b9be..f2583723aca6 100644
> --- a/drivers/md/bcache/nvm-pages.h
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -62,6 +62,7 @@ extern struct bch_nvm_set *only_set;
>  struct bch_nvm_namespace *bch_register_namespace(const char *dev_path);
>  int bch_nvm_init(void);
>  void bch_nvm_exit(void);
> +void *bch_nvm_alloc_pages(int order, const char *owner_uuid);
>  
>  #else
>  
> @@ -74,6 +75,11 @@ static inline int bch_nvm_init(void)
>  	return 0;
>  }
>  static inline void bch_nvm_exit(void) { }
> +static inline void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
> +{
> +	return NULL;
> +}
> +
>  
>  #endif /* CONFIG_BCACHE_NVM_PAGES */
>  
> diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
> index 1fdb3eaabf7e..9cb937292202 100644
> --- a/include/uapi/linux/bcache-nvm.h
> +++ b/include/uapi/linux/bcache-nvm.h
> @@ -135,9 +135,11 @@ union {
>  	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /			\
>  	 sizeof(struct bch_pgalloc_rec))
>  
> +/* Currently 64 struct bch_nvm_pgalloc_recs is enough */
>  #define BCH_MAX_PGALLOC_RECS						\
> -	((BCH_NVM_PAGES_OFFSET - BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET) /	\
> -	 sizeof(struct bch_nvm_pgalloc_recs))
> +	(min_t(unsigned int, 64,					\
> +		(BCH_NVM_PAGES_OFFSET - BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET) / \
> +		 sizeof(struct bch_nvm_pgalloc_recs)))
>  
>  struct bch_nvm_pages_owner_head {
>  	unsigned char			uuid[16];
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

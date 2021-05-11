Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD82937A70E
	for <lists+linux-bcache@lfdr.de>; Tue, 11 May 2021 14:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhEKMuR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 11 May 2021 08:50:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:41732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231644AbhEKMuQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 11 May 2021 08:50:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 789ACAF79;
        Tue, 11 May 2021 12:49:09 +0000 (UTC)
To:     Qiaowei Ren <qiaowei.ren@intel.com>, jianpeng.ma@intel.com
Cc:     linux-bcache@vger.kernel.org
References: <20210428213952.197504-1-qiaowei.ren@intel.com>
 <20210428213952.197504-5-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [bch-nvm-pages v9 4/6] bcache: bch_nvm_alloc_pages() of the buddy
Message-ID: <0a3540c1-1af2-7b06-0e1c-634ab57c62b6@suse.de>
Date:   Tue, 11 May 2021 20:49:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210428213952.197504-5-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/29/21 5:39 AM, Qiaowei Ren wrote:
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
> [colyli: fix typo in commit log]

Once you fixed the typo in this version, you may remove the above line
from this patch. Such comment is used when I submit patches to mainline
kernel.

> Signed-off-by: Coly Li <colyli@suse.de>

And this is maintainer's SOB not author's, you may remove it from all
rested patches except for the first one of this series.


> ---
>  drivers/md/bcache/nvm-pages.c | 172 ++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h |   6 ++
>  2 files changed, 178 insertions(+)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 810f65cf756a..2647ff997fab 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -68,6 +68,178 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
>  	bitmap_set(ns->pages_bitmap, pgoff, nr);
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
> +	if (!owner_head && create) {
> +		int used = only_set->owner_list_used;
> +
> +		BUG_ON((used > 0) && (only_set->owner_list_size == used));


It seems the above condition may happen when owner_list is full? Maybe
return NULL for a full-occupied owner header list can be better?


> +		memcpy_flushcache(owner_list_head->heads[used].uuid, owner_uuid, 16);
> +		only_set->owner_list_used++;
> +
> +		owner_list_head->used++;
> +		owner_head = &(owner_list_head->heads[used]);
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

We cannot assume all space in [BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET,
BCH_NVM_PAGES_OFFSET) are dedicated to recs structures.

Right now each bch_nvm_pgalloc_recs is 8KB, we can assume the
BCH_MAX_PGALLOC_RECS to be 64, that means 512KB space starts at
BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET. we won't exceed the limition in next
12 months at least.


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

I assume when create == false, at least the first non-full recs
structure should be returned before iterated all the list nodes. How
about return recs by the way in my next comment.



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

If recs is NULL here, and create == false, we may return the NULL as
well here,

	if (recs || !create)
		return recs;

Just for your reference.

> +	/* Need alloc new struct bch_nvm_galloc_recs */
> +	recs = find_empty_pgalloc_recs();
> +	if (recs) {
> +		recs->next = NULL;
> +		recs->owner = owner_head;
> +		strncpy(recs->magic, bch_nvm_pages_pgalloc_magic, 16);
> +		strncpy(recs->owner_uuid, owner_head->uuid, 16);

Maybe memcpy_flushcache() is better here.

> +		recs->size = BCH_MAX_RECS;
> +		recs->used = 0;
> +
> +		if (prev_recs)
> +			prev_recs->next = recs;
> +		else
> +			owner_head->recs[ns_nr] = recs;
> +	}
> +
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
> +	BUG_ON(i == recs->size);> +}
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
> +		if (!ns || (ns->free < (1 << order)))
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
> +			page = container_of((void *)list, struct page, zone_device_data);
> +
> +			list_del(list);
> +
> +			while (i != order) {
> +				buddy_page = nvm_vaddr_to_page(ns,
> +					nvm_pgoff_to_vaddr(ns, page->index + (1 << (i - 1))));
> +				set_page_private(buddy_page, i - 1);
> +				buddy_page->index = page->index + (1 << (i - 1));
> +				__SetPageBuddy(buddy_page);
> +				list_add((struct list_head *)&buddy_page->zone_device_data,
> +					&ns->free_area[i - 1]);
> +				i--;
> +			}
> +
> +			set_page_private(page, order);
> +			__ClearPageBuddy(page);
> +			ns->free -= 1 << order;
> +			kaddr = nvm_pgoff_to_vaddr(ns, page->index);
> +			break;
> +		}
> +
> +		if (i != BCH_MAX_ORDER) {

In case to avoid an invalid order is sent in, maybe it is better to be
		if (i < BCH_MAX_ORDER) {


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
>  static int init_owner_info(struct bch_nvm_namespace *ns)
>  {
>  	struct bch_owner_list_head *owner_list_head = ns->sb->owner_list_head;
> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> index e08864af96a0..4fd5205146a2 100644
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
> 

The rested are fine to me. Thanks for the great work :-)

Coly Li


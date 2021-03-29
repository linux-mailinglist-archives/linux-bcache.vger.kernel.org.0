Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B592C34CE82
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Mar 2021 13:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbhC2LKa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Mar 2021 07:10:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:37366 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231735AbhC2LKI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Mar 2021 07:10:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 84537B457;
        Mon, 29 Mar 2021 11:10:07 +0000 (UTC)
To:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Cc:     linux-bcache@vger.kernel.org
References: <20210317151029.40735-1-qiaowei.ren@intel.com>
 <20210317151029.40735-4-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [bch-nvm-pages v7 3/6] bcache: initialization of the buddy
Message-ID: <e52b3a34-b394-0d16-56b9-edb1e5ba9933@suse.de>
Date:   Mon, 29 Mar 2021 19:10:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317151029.40735-4-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/17/21 11:10 PM, Qiaowei Ren wrote:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This nvm pages allocator will implement the simple buddy to manage the
> nvm address space. This patch initializes this buddy for new namespace.
> 
> the unit of alloc/free of the buddy is page. DAX device has their
> struct page(in dram or PMEM).
> 
> 	struct {        /* ZONE_DEVICE pages */
> 		/** @pgmap: Points to the hosting device page map. */
> 		struct dev_pagemap *pgmap;
> 		void *zone_device_data;
> 		/*
> 		 * ZONE_DEVICE private pages are counted as being
> 		 * mapped so the next 3 words hold the mapping, index,
> 		 * and private fields from the source anonymous or
> 		 * page cache page while the page is migrated to device
> 		 * private memory.
> 		 * ZONE_DEVICE MEMORY_DEVICE_FS_DAX pages also
> 		 * use the mapping, index, and private fields when
> 		 * pmem backed DAX files are mapped.
> 		 */
> 	};
> 
> ZONE_DEVICE pages only use pgmap. Other 4 words[16/32 bytes] don't use.
> So the second/third word will be used as 'struct list_head ' which list
> in buddy. The fourth word(that is normal struct page::index) store pgoff
> which the page-offset in the dax device. And the fifth word (that is
> normal struct page::private) store order of buddy. page_type will be used
> to store buddy flags.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/nvm-pages.c   | 142 +++++++++++++++++++++++++++++++-
>  drivers/md/bcache/nvm-pages.h   |   6 ++
>  include/uapi/linux/bcache-nvm.h |   8 ++
>  3 files changed, 152 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 9335371c9d91..1f99965920a1 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -41,6 +41,10 @@ static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
>  	for (i = 0; i < nvm_set->total_namespaces_nr; i++) {
>  		ns = nvm_set->nss[i];
>  		if (ns) {
> +			kvfree(ns->pages_bitmap);
> +			if (ns->pgalloc_recs_bitmap)
> +				bitmap_free(ns->pgalloc_recs_bitmap);
> +
>  			blkdev_put(ns->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
>  			kfree(ns);
>  		}
> @@ -55,17 +59,122 @@ static void release_nvm_set(struct bch_nvm_set *nvm_set)
>  	kfree(nvm_set);
>  }
>  
> +static struct page *nvm_vaddr_to_page(struct bch_nvm_namespace *ns, void *addr)
> +{
> +	return virt_to_page(addr);
> +}
> +
> +static void *nvm_pgoff_to_vaddr(struct bch_nvm_namespace *ns, pgoff_t pgoff)
> +{
> +	return ns->kaddr + (pgoff << PAGE_SHIFT);
> +}
> +
> +static inline void remove_owner_space(struct bch_nvm_namespace *ns,
> +					pgoff_t pgoff, u32 nr)
> +{
> +	bitmap_set(ns->pages_bitmap, pgoff, nr);
> +}
> +
>  static int init_owner_info(struct bch_nvm_namespace *ns)
>  {
>  	struct bch_owner_list_head *owner_list_head = ns->sb->owner_list_head;
> +	struct bch_nvm_pgalloc_recs *sys_recs;
> +	int i, j, k, rc = 0;
>  
>  	mutex_lock(&only_set->lock);
>  	only_set->owner_list_head = owner_list_head;
>  	only_set->owner_list_size = owner_list_head->size;
>  	only_set->owner_list_used = owner_list_head->used;
> +
> +	/*remove used space*/
> +	remove_owner_space(ns, 0, ns->pages_offset/ns->page_size);
> +
> +	sys_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
> +	// suppose no hole in array

We don't use such code comments format, please follow the comments style
of existing bcache code.

There are also other locations using "//" for code comments, they should
be modified as well.

Thanks.

Coly Li


[snipped]

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D581D2DBEAA
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Dec 2020 11:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgLPKbC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 05:31:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:60734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgLPKbB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 05:31:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 03922AE63;
        Wed, 16 Dec 2020 10:30:20 +0000 (UTC)
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     linux-bcache@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-4-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH 3/8] bcache: initialization of the buddy
Message-ID: <3e326a79-a7a4-de3b-c514-3f0b7f7c3cdc@suse.de>
Date:   Wed, 16 Dec 2020 18:30:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203105337.4592-4-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20 6:53 PM, Qiaowei Ren wrote:
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
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---
>  drivers/md/bcache/nvm-pages.c | 68 ++++++++++++++++++++++++++++++++++-
>  drivers/md/bcache/nvm-pages.h |  3 ++
>  2 files changed, 70 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> index 841616ea3267..7ffbfbacaf3f 100644
> --- a/drivers/md/bcache/nvm-pages.c
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -84,6 +84,17 @@ static void *nvm_pgoff_to_vaddr(struct nvm_namespace *ns, pgoff_t pgoff)
>  	return ns->kaddr + ns->pages_offset + (pgoff << PAGE_SHIFT);
>  }
>  
> +static struct page *nvm_vaddr_to_page(struct nvm_namespace *ns, void *addr)
> +{
> +	return virt_to_page(addr);
> +}
> +
> +static inline void remove_owner_space(struct nvm_namespace *ns,
> +		pgoff_t pgoff, u32 nr)
> +{
> +	bitmap_set(ns->pages_bitmap, pgoff, nr);
> +}
> +
>  static void init_owner_info(struct nvm_namespace *ns)
>  {
>  	struct owner_list_head *owner_list_head;
> @@ -126,6 +137,8 @@ static void init_owner_info(struct nvm_namespace *ns)
>  					extent->nr = rec->nr;
>  					list_add_tail(&extent->list, &extents->extent_head);
>  
> +					remove_owner_space(extents->ns, rec->pgoff, rec->nr);
> +
>  					extents->ns->free -= rec->nr;
>  				}
>  				extents->size += nvm_pgalloc_recs->size;
> @@ -143,6 +156,54 @@ static void init_owner_info(struct nvm_namespace *ns)
>  	mutex_unlock(&only_set->lock);
>  }
>  
> +static void init_nvm_free_space(struct nvm_namespace *ns)
> +{
> +	unsigned int start, end, i;
> +	struct page *page;
> +	unsigned int pages;
> +	pgoff_t pgoff_start;
> +
> +	bitmap_for_each_clear_region(ns->pages_bitmap, start, end, 0, ns->pages_total) {
> +		pgoff_start = start;
> +		pages = end - start;
> +
> +		while (pages) {
> +			for (i = MAX_ORDER - 1; i >= 0 ; i--) {
> +				if ((start % (1 << i) == 0) && (pages >= (1 << i)))
> +					break;
> +			}
> +
> +			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
> +			page->index = pgoff_start;
> +			page->private = i;
> +			__SetPageBuddy(page);
> +			list_add((struct list_head *)&page->zone_device_data, &ns->free_area[i]);
> +
> +			pgoff_start += 1 << i;
> +			pages -= 1 << i;
> +		}
> +	}
> +
> +	bitmap_for_each_set_region(ns->pages_bitmap, start, end, 0, ns->pages_total) {
> +		pages = end - start;
> +		pgoff_start = start;
> +
> +		while (pages) {
> +			for (i = MAX_ORDER - 1; i >= 0 ; i--) {
> +				if ((start % (1 << i) == 0) && (pages >= (1 << i)))
> +					break;
> +			}
> +
> +			page = nvm_vaddr_to_page(ns, nvm_pgoff_to_vaddr(ns, pgoff_start));
> +			page->index = pgoff_start;
> +			page->private = i;
> +
> +			pgoff_start += 1 << i;
> +			pages -= 1 << i;
> +		}
> +	}
> +}
> +


The buddy structure should be initialized from the owner lists, we
cannot assume the name space is empty. Because the user space may also
allocate space from NVDIMM even before the first time it is attached by
kernel driver.


[snipped]

Coly Li

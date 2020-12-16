Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B30F2DBE7B
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Dec 2020 11:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgLPKSJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 16 Dec 2020 05:18:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:47300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgLPKSJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 16 Dec 2020 05:18:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9EB2FAC7F;
        Wed, 16 Dec 2020 10:17:27 +0000 (UTC)
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     linux-bcache@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>
References: <20201203105337.4592-1-qiaowei.ren@intel.com>
 <20201203105337.4592-3-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: [RFC PATCH 2/8] bcache: initialize the nvm pages allocator
Message-ID: <3f082cd2-45d7-e914-68b9-c886124f6919@suse.de>
Date:   Wed, 16 Dec 2020 18:17:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201203105337.4592-3-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/3/20 6:53 PM, Qiaowei Ren wrote:
> This patch define the prototype data structures in memory and initializes
> the nvm pages allocator.
> 
> The nv address space which is managed by this allocatior can consist of
> many nvm namespaces, and some namespaces can compose into one nvm set,
> like cache set. For this initial implementation, only one set can be
> supported.
> 
> The users of this nvm pages allocator need to call regiseter_namespace()
> to register the nvdimm device (like /dev/pmemX) into this allocator as
> the instance of struct nvm_namespace.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>

Hi Jianpeng,

I add my comments in line.


> ---
>  drivers/md/bcache/Kconfig     |   6 +
>  drivers/md/bcache/Makefile    |   2 +-
>  drivers/md/bcache/nvm-pages.c | 303 ++++++++++++++++++++++++++++++++++
>  drivers/md/bcache/nvm-pages.h |  91 ++++++++++
>  drivers/md/bcache/super.c     |   3 +
>  5 files changed, 404 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/md/bcache/nvm-pages.c
>  create mode 100644 drivers/md/bcache/nvm-pages.h
> 
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index d1ca4d059c20..448a99ce13b2 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -35,3 +35,9 @@ config BCACHE_ASYNC_REGISTRATION
>  	device path into this file will returns immediately and the real
>  	registration work is handled in kernel work queue in asynchronous
>  	way.
> +
> +config BCACHE_NVM_PAGES
> +	bool "NVDIMM support for bcache"

I'd like to have this change in kernel ASAP for more people to test and
evaludate, but it should be bool "NVDIMM support for bcache (EXPERIMENTAL)".


> +	depends on BCACHE
> +	help
> +	nvm pages allocator for bcache.
> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
> index 5b87e59676b8..948e5ed2ca66 100644
> --- a/drivers/md/bcache/Makefile
> +++ b/drivers/md/bcache/Makefile
> @@ -4,4 +4,4 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
>  
>  bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
>  	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
> -	util.o writeback.o features.o
> +	util.o writeback.o features.o nvm-pages.o
> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
> new file mode 100644
> index 000000000000..841616ea3267
> --- /dev/null
> +++ b/drivers/md/bcache/nvm-pages.c
> @@ -0,0 +1,303 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <linux/dax.h>
> +#include <linux/pfn_t.h>
> +#include <linux/libnvdimm.h>
> +#include <linux/mm_types.h>
> +#include <linux/err.h>
> +#include <linux/pagemap.h>
> +#include <linux/bitmap.h>
> +#include <linux/blkdev.h>
> +#include "nvm-pages.h"
> +
> +struct nvm_set *only_set;
> +

[snipped]

> +static void init_owner_info(struct nvm_namespace *ns)
> +{
> +	struct owner_list_head *owner_list_head;
> +	struct nvm_pages_owner_head *owner_head;
> +	struct nvm_pgalloc_recs *nvm_pgalloc_recs;
> +	struct owner_list *owner_list;
> +	struct nvm_alloced_recs *extents;
> +	struct extent *extent;
> +	u32 i, j, k;
> +
> +	owner_list_head = (struct owner_list_head *)
> +			(ns->kaddr + NVM_PAGES_OWNER_LIST_HEAD_OFFSET);
> +
> +	mutex_lock(&only_set->lock);
> +	only_set->owner_list_size = owner_list_head->size;
> +	for (i = 0; i < owner_list_head->size; i++) {
> +		owner_head = &owner_list_head->heads[i];
> +		owner_list = alloc_owner_list(owner_head->uuid, owner_head->label,
> +				only_set->total_namespaces_nr);
> +
> +		for (j = 0; j < only_set->total_namespaces_nr; j++) {
> +			if (only_set->nss[j] == NULL || owner_head->recs[j] == NULL)
> +				continue;
> +
> +			nvm_pgalloc_recs = (struct nvm_pgalloc_recs *)
> +					((long)owner_head->recs[j] + ns->kaddr);
> +
> +			extents = kzalloc(sizeof(struct nvm_alloced_recs), GFP_KERNEL);
> +			extents->ns = only_set->nss[j];
> +			INIT_LIST_HEAD(&extents->extent_head);
> +			owner_list->alloced_recs[j] = extents;
> +
> +			do {
> +				struct nvm_pgalloc_rec *rec;
> +
> +				for (k = 0; k < nvm_pgalloc_recs->size; k++) {
> +					rec = &nvm_pgalloc_recs->recs[k];
> +					extent = kzalloc(sizeof(struct extent), GFP_KERNEL);
> +					extent->kaddr = nvm_pgoff_to_vaddr(extents->ns, rec->pgoff);
> +					extent->nr = rec->nr;
> +					list_add_tail(&extent->list, &extents->extent_head);
> +
> +					extents->ns->free -= rec->nr;
> +				}
> +				extents->size += nvm_pgalloc_recs->size;
> +
> +				if (nvm_pgalloc_recs->next)
> +					nvm_pgalloc_recs = (struct nvm_pgalloc_recs *)
> +						((long)nvm_pgalloc_recs->next + ns->kaddr);
> +				else
> +					nvm_pgalloc_recs = NULL;
> +			} while (nvm_pgalloc_recs);
> +		}
> +		only_set->owner_lists[i] = owner_list;
> +		owner_list->nvm_set = only_set;
> +	}
> +	mutex_unlock(&only_set->lock);
> +}

Currently the initialization of owner_list_head is done by user space
tool. We just need to check whether the owner_list_head is correctly
initialized by user space tool.


[snipped]
> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
> new file mode 100644
> index 000000000000..1a24af6cb5a9
> --- /dev/null
> +++ b/drivers/md/bcache/nvm-pages.h
> @@ -0,0 +1,91 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _BCACHE_NVM_PAGES_H
> +#define _BCACHE_NVM_PAGES_H
> +
> +#include <linux/bcache-nvm.h>
> +
> +/*
> + * Bcache NVDIMM in memory data structures
> + */
> +
> +/*
> + * The following three structures in memory records which page(s) allocated
> + * to which owner. After reboot from power failure, they will be initialized
> + * based on nvm pages superblock in NVDIMM device.
> + */
> +struct extent {
> +	void *kaddr;
> +	u32 nr;
> +	struct list_head list;
> +};
> +
> +struct nvm_alloced_recs {
> +	u32  size;
> +	struct nvm_namespace *ns;
> +	struct list_head extent_head;
> +};
> +
> +struct owner_list {
> +	u8  owner_uuid[16];
> +	char label[NVM_PAGES_LABEL_SIZE];
> +
> +	struct nvm_set *nvm_set;
> +	struct nvm_alloced_recs **alloced_recs;
> +};
> +
> +struct nvm_namespace {
> +	void *kaddr;
> +
> +	u8 uuid[18];
> +	u64 free;
> +	u32 page_size;
> +	u64 pages_offset;
> +	u64 pages_total;
> +	pfn_t start_pfn;
> +
> +	struct dax_device *dax_dev;
> +	struct block_device *bdev;
> +	struct nvm_pages_sb *sb;
> +	struct nvm_set *nvm_set;
> +
> +	struct mutex lock;
> +};> +/*
> + * A set of namespaces. Currently only one set can be supported.
> + */
> +struct nvm_set {
> +	u8 set_uuid[16];
> +	u32 total_namespaces_nr;
> +
> +	u32 owner_list_size;
> +	struct owner_list **owner_lists;
> +
> +	struct nvm_namespace **nss;
> +
> +	struct mutex lock;
> +};


All the above data structures should be named with prefix bch_ .

[snipped]

Thanks.

Coly Li

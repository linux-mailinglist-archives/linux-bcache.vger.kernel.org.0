Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9229334C32B
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Mar 2021 07:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhC2FsE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Mar 2021 01:48:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:34598 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhC2Frn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Mar 2021 01:47:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 24056B320;
        Mon, 29 Mar 2021 05:47:42 +0000 (UTC)
Subject: Re: [bch-nvm-pages v7 1/6] bcache: add initial data structures for
 nvm pages
To:     Qiaowei Ren <qiaowei.ren@intel.com>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org
References: <20210317151029.40735-1-qiaowei.ren@intel.com>
 <20210317151029.40735-2-qiaowei.ren@intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <41ee5873-97cc-9afa-7c48-f64ab6165116@suse.de>
Date:   Mon, 29 Mar 2021 13:47:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317151029.40735-2-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/17/21 11:10 PM, Qiaowei Ren wrote:
> From: Coly Li <colyli@suse.de>
> 
> This patch initializes the prototype data structures for nvm pages
> allocator,
> 
> - struct bch_nvm_pages_sb
> This is the super block allocated on each nvdimm namespace. A nvdimm
> set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used
> to mark which nvdimm set this name space belongs to. Normally we will
> use the bcache's cache set UUID to initialize this uuid, to connect this
> nvdimm set to a specified bcache cache set.
> 
> - struct bch_owner_list_head
> This is a table for all heads of all owner lists. A owner list records
> which page(s) allocated to which owner. After reboot from power failure,
> the ownwer may find all its requested and allocated pages from the owner
> list by a handler which is converted by a UUID.
> 
> - struct bch_nvm_pages_owner_head
> This is a head of an owner list. Each owner only has one owner list,
> and a nvm page only belongs to an specific owner. uuid[] will be set to
> owner's uuid, for bcache it is the bcache's cache set uuid. label is not
> mandatory, it is a human-readable string for debug purpose. The pointer
> *recs references to separated nvm page which hold the table of struct
> bch_nvm_pgalloc_rec.
> 
> - struct bch_nvm_pgalloc_recs
> This struct occupies a whole page, owner_uuid should match the uuid
> in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
> allocated records.
> 
> - struct bch_nvm_pgalloc_rec
> Each structure records a range of allocated nvm pages. pgoff is offset
> in unit of page size of this allocated nvm page range. The adjoint page
> ranges of same owner can be merged into a larger one, therefore pages_nr
> is NOT always power of 2.
> 
> Signed-off-by: Coly Li <colyli@suse.de>


With comments from Jens, I update this header. Also I add helper
routines to get and set the allocated rec pgoff and order, which may fix
the improper bit field definiation in this series.


I will post this patch with other bcache part change soon.

Thanks.

Coly Li


> ---
>  include/uapi/linux/bcache-nvm.h | 195 ++++++++++++++++++++++++++++++++
>  1 file changed, 195 insertions(+)
>  create mode 100644 include/uapi/linux/bcache-nvm.h
> 
> diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
> new file mode 100644
> index 000000000000..01370f4e12d4
> --- /dev/null
> +++ b/include/uapi/linux/bcache-nvm.h
> @@ -0,0 +1,195 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +
> +#ifndef _UAPI_BCACHE_NVM_H
> +#define _UAPI_BCACHE_NVM_H
> +
> +/*
> + * Bcache on NVDIMM data structures
> + */
> +
> +/*
> + * - struct bch_nvm_pages_sb
> + *   This is the super block allocated on each nvdimm namespace. A nvdimm
> + * set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used to mark
> + * which nvdimm set this name space belongs to. Normally we will use the
> + * bcache's cache set UUID to initialize this uuid, to connect this nvdimm
> + * set to a specified bcache cache set.
> + *
> + * - struct bch_owner_list_head
> + *   This is a table for all heads of all owner lists. A owner list records
> + * which page(s) allocated to which owner. After reboot from power failure,
> + * the ownwer may find all its requested and allocated pages from the owner
> + * list by a handler which is converted by a UUID.
> + *
> + * - struct bch_nvm_pages_owner_head
> + *   This is a head of an owner list. Each owner only has one owner list,
> + * and a nvm page only belongs to an specific owner. uuid[] will be set to
> + * owner's uuid, for bcache it is the bcache's cache set uuid. label is not
> + * mandatory, it is a human-readable string for debug purpose. The pointer
> + * recs references to separated nvm page which hold the table of struct
> + * bch_pgalloc_rec.
> + *
> + *- struct bch_nvm_pgalloc_recs
> + *  This structure occupies a whole page, owner_uuid should match the uuid
> + * in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
> + * allocated records.
> + *
> + * - struct bch_pgalloc_rec
> + *   Each structure records a range of allocated nvm pages. pgoff is offset
> + * in unit of page size of this allocated nvm page range. The adjoint page
> + * ranges of same owner can be merged into a larger one, therefore pages_nr
> + * is NOT always power of 2.
> + *
> + *
> + * Memory layout on nvdimm namespace 0
> + *
> + *    0 +---------------------------------+
> + *      |                                 |
> + *  4KB +---------------------------------+
> + *      |         bch_nvm_pages_sb        |
> + *  8KB +---------------------------------+ <--- bch_nvm_pages_sb.bch_owner_list_head
> + *      |       bch_owner_list_head       |
> + *      |                                 |
> + * 16KB +---------------------------------+ <--- bch_owner_list_head.heads[0].recs[0]
> + *      |       bch_nvm_pgalloc_recs      |
> + *      |  (nvm pages internal usage)     |
> + * 24KB +---------------------------------+
> + *      |                                 |
> + *      |                                 |
> + * 16MB  +---------------------------------+
> + *      |      allocable nvm pages        |
> + *      |      for buddy allocator        |
> + * end  +---------------------------------+
> + *
> + *
> + *
> + * Memory layout on nvdimm namespace N
> + * (doesn't have owner list)
> + *
> + *    0 +---------------------------------+
> + *      |                                 |
> + *  4KB +---------------------------------+
> + *      |         bch_nvm_pages_sb        |
> + *  8KB +---------------------------------+
> + *      |                                 |
> + *      |                                 |
> + *      |                                 |
> + *      |                                 |
> + *      |                                 |
> + *      |                                 |
> + * 16MB  +---------------------------------+
> + *      |      allocable nvm pages        |
> + *      |      for buddy allocator        |
> + * end  +---------------------------------+
> + *
> + */
> +
> +#include <linux/types.h>
> +
> +/* In sectors */
> +#define BCH_NVM_PAGES_SB_OFFSET			4096
> +#define BCH_NVM_PAGES_OFFSET			(16 << 20)
> +
> +#define BCH_NVM_PAGES_LABEL_SIZE		32
> +#define BCH_NVM_PAGES_NAMESPACES_MAX		8
> +
> +#define BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET	(8<<10)
> +#define BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET	(16<<10)
> +
> +#define BCH_NVM_PAGES_SB_VERSION		0
> +#define BCH_NVM_PAGES_SB_VERSION_MAX		0
> +
> +static const char bch_nvm_pages_magic[] = {
> +	0x17, 0xbd, 0x53, 0x7f, 0x1b, 0x23, 0xd6, 0x83,
> +	0x46, 0xa4, 0xf8, 0x28, 0x17, 0xda, 0xec, 0xa9 };
> +static const char bch_nvm_pages_pgalloc_magic[] = {
> +	0x39, 0x25, 0x3f, 0xf7, 0x27, 0x17, 0xd0, 0xb9,
> +	0x10, 0xe6, 0xd2, 0xda, 0x38, 0x68, 0x26, 0xae };
> +
> +struct bch_pgalloc_rec {
> +	__u64			pgoff:52;
> +	__u64			order:12;
> +};
> +
> +struct bch_nvm_pgalloc_recs {
> +union {
> +	struct {
> +		struct bch_nvm_pages_owner_head	*owner;
> +		struct bch_nvm_pgalloc_recs	*next;
> +		__u8				magic[16];
> +		__u8				owner_uuid[16];
> +		__u32				size;
> +		__u32				used;
> +		__u64				_pad[4];
> +		struct bch_pgalloc_rec		recs[];
> +	};
> +	__u8	pad[8192];
> +};
> +};
> +#define BCH_MAX_REC					\
> +	((sizeof(struct bch_nvm_pgalloc_recs) -		\
> +	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /	\
> +	 sizeof(struct bch_pgalloc_rec))
> +
> +struct bch_nvm_pages_owner_head {
> +	__u8			uuid[16];
> +	char			label[BCH_NVM_PAGES_LABEL_SIZE];
> +	/* Per-namespace own lists */
> +	struct bch_nvm_pgalloc_recs	*recs[BCH_NVM_PAGES_NAMESPACES_MAX];
> +};
> +
> +/* heads[0] is always for nvm_pages internal usage */
> +struct bch_owner_list_head {
> +union {
> +	struct {
> +		__u32				size;
> +		__u32				used;
> +		__u64				_pad[4];
> +		struct bch_nvm_pages_owner_head	heads[];
> +	};
> +	__u8	pad[8192];
> +};
> +};
> +#define BCH_MAX_OWNER_HEAD				\
> +	((sizeof(struct bch_owner_list_head) -		\
> +	 offsetof(struct bch_owner_list_head, heads)) /	\
> +	 sizeof(struct bch_nvm_pages_owner_head))
> +
> +/* The on-media bit order is local CPU order */
> +struct bch_nvm_pages_sb {
> +	__u64			csum;
> +	__u64			ns_start;
> +	__u64			sb_offset;
> +	__u64			version;
> +	__u8			magic[16];
> +	__u8			uuid[16];
> +	__u32			page_size;
> +	__u32			total_namespaces_nr;
> +	__u32			this_namespace_nr;
> +	union {
> +		__u8		set_uuid[16];
> +		__u64		set_magic;
> +	};
> +
> +	__u64			flags;
> +	__u64			seq;
> +
> +	__u64			feature_compat;
> +	__u64			feature_incompat;
> +	__u64			feature_ro_compat;
> +
> +	/* For allocable nvm pages from buddy systems */
> +	__u64			pages_offset;
> +	__u64			pages_total;
> +
> +	__u64			pad[8];
> +
> +	/* Only on the first name space */
> +	struct bch_owner_list_head	*owner_list_head;
> +
> +	/* Just for csum_set() */
> +	__u32			keys;
> +	__u64			d[0];
> +};
> +
> +#endif /* _UAPI_BCACHE_NVM_H */
> 


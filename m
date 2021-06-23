Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBD23B16A8
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 11:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhFWJSs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 05:18:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58122 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhFWJSs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 05:18:48 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 21BA721981;
        Wed, 23 Jun 2021 09:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624439790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NokfFS3lgRkXtDowvvd0f8BMjh9mmmgD1Q9zGGcCgrQ=;
        b=A7yAKFUrSV2T4hb1dKoerxOidG9M/2Hlh35ZESLNvS/eq7+Av4ZPEGJ7ThVVIsYb+QMrUt
        5RhYqGZhX6H6IEeZhZNALhWEjp7gKOuA4kR/QACrsDfJ9HIOFguvoaDSxX+eKX5o50SmyT
        hHpLEfjiraje5gNtJMHc/zB7KfhR7hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624439790;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NokfFS3lgRkXtDowvvd0f8BMjh9mmmgD1Q9zGGcCgrQ=;
        b=c0qCwrPUYZFpBZgMxfmY+4lFOiG4j6xXgv/qfDtmN1yTjVYvpp8PC1x0KLMs5HnWSeqLff
        PTQISNrfJG0+eqCg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id DD9AB11A97;
        Wed, 23 Jun 2021 09:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624439790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NokfFS3lgRkXtDowvvd0f8BMjh9mmmgD1Q9zGGcCgrQ=;
        b=A7yAKFUrSV2T4hb1dKoerxOidG9M/2Hlh35ZESLNvS/eq7+Av4ZPEGJ7ThVVIsYb+QMrUt
        5RhYqGZhX6H6IEeZhZNALhWEjp7gKOuA4kR/QACrsDfJ9HIOFguvoaDSxX+eKX5o50SmyT
        hHpLEfjiraje5gNtJMHc/zB7KfhR7hM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624439790;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NokfFS3lgRkXtDowvvd0f8BMjh9mmmgD1Q9zGGcCgrQ=;
        b=c0qCwrPUYZFpBZgMxfmY+4lFOiG4j6xXgv/qfDtmN1yTjVYvpp8PC1x0KLMs5HnWSeqLff
        PTQISNrfJG0+eqCg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id jGlsNO370mAhOAAALh3uQQ
        (envelope-from <hare@suse.de>); Wed, 23 Jun 2021 09:16:29 +0000
Subject: Re: [PATCH 04/14] bcache: initialize the nvm pages allocator
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-5-colyli@suse.de>
 <39c118e3-ddc9-f417-a929-fc21e761a4ac@suse.de>
 <fc5b8586-0181-da7b-ba1f-73f7b00b8d16@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <48cab671-d4d6-d5f2-29bf-b2f19e04e533@suse.de>
Date:   Wed, 23 Jun 2021 11:16:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <fc5b8586-0181-da7b-ba1f-73f7b00b8d16@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 7:26 AM, Coly Li wrote:
> On 6/22/21 6:39 PM, Hannes Reinecke wrote:
>> On 6/15/21 7:49 AM, Coly Li wrote:
>>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>>
>>> This patch define the prototype data structures in memory and
>>> initializes the nvm pages allocator.
>>>
>>> The nvm address space which is managed by this allocator can consist of
>>> many nvm namespaces, and some namespaces can compose into one nvm set,
>>> like cache set. For this initial implementation, only one set can be
>>> supported.
>>>
>>> The users of this nvm pages allocator need to call register_namespace()
>>> to register the nvdimm device (like /dev/pmemX) into this allocator as
>>> the instance of struct nvm_namespace.
>>>
>>> Reported-by: Randy Dunlap <rdunlap@infradead.org>
>>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>>> Signed-off-by: Coly Li <colyli@suse.de>
>>> ---
>>>   drivers/md/bcache/Kconfig     |  10 ++
>>>   drivers/md/bcache/Makefile    |   1 +
>>>   drivers/md/bcache/nvm-pages.c | 295 ++++++++++++++++++++++++++++++++++
>>>   drivers/md/bcache/nvm-pages.h |  74 +++++++++
>>>   drivers/md/bcache/super.c     |   3 +
>>>   5 files changed, 383 insertions(+)
>>>   create mode 100644 drivers/md/bcache/nvm-pages.c
>>>   create mode 100644 drivers/md/bcache/nvm-pages.h
>>>
>>> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
>>> index d1ca4d059c20..a69f6c0e0507 100644
>>> --- a/drivers/md/bcache/Kconfig
>>> +++ b/drivers/md/bcache/Kconfig
>>> @@ -35,3 +35,13 @@ config BCACHE_ASYNC_REGISTRATION
>>>   	device path into this file will returns immediately and the real
>>>   	registration work is handled in kernel work queue in asynchronous
>>>   	way.
>>> +
>>> +config BCACHE_NVM_PAGES
>>> +	bool "NVDIMM support for bcache (EXPERIMENTAL)"
>>> +	depends on BCACHE
>>> +	depends on 64BIT
>>> +	depends on LIBNVDIMM
>>> +	depends on DAX
>>> +	help
>>> +	  Allocate/release NV-memory pages for bcache and provide allocated pages
>>> +	  for each requestor after system reboot.
>>> diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
>>> index 5b87e59676b8..2397bb7c7ffd 100644
>>> --- a/drivers/md/bcache/Makefile
>>> +++ b/drivers/md/bcache/Makefile
>>> @@ -5,3 +5,4 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
>>>   bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
>>>   	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
>>>   	util.o writeback.o features.o
>>> +bcache-$(CONFIG_BCACHE_NVM_PAGES) += nvm-pages.o
>>> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
>>> new file mode 100644
>>> index 000000000000..18fdadbc502f
>>> --- /dev/null
>>> +++ b/drivers/md/bcache/nvm-pages.c
>>> @@ -0,0 +1,295 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Nvdimm page-buddy allocator
>>> + *
>>> + * Copyright (c) 2021, Intel Corporation.
>>> + * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
>>> + * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
>>> + */
>>> +
>>> +#if defined(CONFIG_BCACHE_NVM_PAGES)
>>> +
>> No need for this 'if' statement as it'll be excluded by the Makefile
>> anyway if the config option isn't set.
> 
> Such if is necessary because stub routines are defined when
> CONFIG_BCACHE_NVM_PAGES is not defined, e.g.
> 
> 426 +#else
> 427 +
> 428 +static inline struct bch_nvm_namespace
> *bch_register_namespace(const char *dev_path)
> 429 +{
> 430 +       return NULL;
> 431 +}
> 432 +static inline int bch_nvm_init(void)
> 433 +{
> 434 +       return 0;
> 435 +}
> 436 +static inline void bch_nvm_exit(void) { }
> 437 +
> 438 +#endif /* CONFIG_BCACHE_NVM_PAGES */
> 
But then these stubs should be defined in the header file, not here.

[ .. ]

>>> +			rc = -ENOMEM;
>>> +			goto unlock;
>>> +		}
>>> +	}
>>> +
>>> +	only_set->nss[ns->sb->this_namespace_nr] = ns;
>>> +
>>> +	/* Firstly attach */
>> Initial attach?
> 
> Will fix in next post.
> 
>>
>>> +	if ((unsigned long)ns->sb->owner_list_head == BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET) {
>>> +		struct bch_nvm_pages_owner_head *sys_owner_head;
>>> +		struct bch_nvm_pgalloc_recs *sys_pgalloc_recs;
>>> +
>>> +		ns->sb->owner_list_head = ns->kaddr + BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET;
>>> +		sys_pgalloc_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
>>> +
>>> +		sys_owner_head = &(ns->sb->owner_list_head->heads[0]);
>>> +		sys_owner_head->recs[0] = sys_pgalloc_recs;
>>> +		ns->sb->csum = csum_set(ns->sb);
>>> +
>> Hmm. You are trying to pick up the 'list_head' structure from NVM, right?
> 
> No, this is not READ, it's WRITE onto NVDIMM.
> 
> sys_owner_head points to NVDIMM, since ns->sb->owner_list_head is updated,
> the checksum of ns->sb should be updated to new value onto the NVDIMM.
> This is what the above line does.
> 
> 
Ah, right.

>>
>> In doing so, don't you need to validate the structure (eg by checking
>> the checksum) before doing so to ensure that the contents are valid?
> 
> The check sum checking for READ is done in read_nvdimm_meta_super() in
> following lines,
> 198 +       r = -EINVAL;
> 199 +       expected_csum = csum_set(sb);
> 200 +       if (expected_csum != sb->csum) {
> 201 +               pr_info("csum is not match with expected one\n");
> 202 +               goto put_page;
> 203 +       }
> 
> Once thing to note is, currently all NVDIMM update is not power failure
> considered. This is the next big task to do after the first small code
> base merged.
> 
> 
>>> +		sys_pgalloc_recs->owner = sys_owner_head;
>>> +	} else
>>> +		BUG_ON(ns->sb->owner_list_head !=
>>> +			(ns->kaddr + BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET));
>>> +
>>> +unlock:
>>> +	mutex_unlock(&only_set->lock);
>>> +	return rc;
>>> +}
>>> +
>>> +static int read_nvdimm_meta_super(struct block_device *bdev,
>>> +			      struct bch_nvm_namespace *ns)
>>> +{
>>> +	struct page *page;
>>> +	struct bch_nvm_pages_sb *sb;
>>> +	int r = 0;
>>> +	uint64_t expected_csum = 0;
>>> +
>>> +	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
>>> +			BCH_NVM_PAGES_SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
>>> +
>>> +	if (IS_ERR(page))
>>> +		return -EIO;
>>> +
>>> +	sb = (struct bch_nvm_pages_sb *)(page_address(page) +
>>> +					offset_in_page(BCH_NVM_PAGES_SB_OFFSET));
>>> +	r = -EINVAL;
>>> +	expected_csum = csum_set(sb);
>>> +	if (expected_csum != sb->csum) {
>>> +		pr_info("csum is not match with expected one\n");
>>> +		goto put_page;
>>> +	}
>>> +
>>> +	if (memcmp(sb->magic, bch_nvm_pages_magic, 16)) {
>>> +		pr_info("invalid bch_nvm_pages_magic\n");
>>> +		goto put_page;
>>> +	}
>>> +
>>> +	if (sb->total_namespaces_nr != 1) {
>>> +		pr_info("currently only support one nvm device\n");
>>> +		goto put_page;
>>> +	}
>>> +
>>> +	if (sb->sb_offset != BCH_NVM_PAGES_SB_OFFSET) {
>>> +		pr_info("invalid superblock offset\n");
>>> +		goto put_page;
>>> +	}
>>> +
>>> +	r = 0;
>>> +	/* temporary use for DAX API */
>>> +	ns->page_size = sb->page_size;
>>> +	ns->pages_total = sb->pages_total;
>>> +
>>> +put_page:
>>> +	put_page(page);
>>> +	return r;
>>> +}
>>> +
>>> +struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
>>> +{
>>> +	struct bch_nvm_namespace *ns;
>>> +	int err;
>>> +	pgoff_t pgoff;
>>> +	char buf[BDEVNAME_SIZE];
>>> +	struct block_device *bdev;
>>> +	int id;
>>> +	char *path = NULL;
>>> +
>>> +	path = kstrndup(dev_path, 512, GFP_KERNEL);
>>> +	if (!path) {
>>> +		pr_err("kstrndup failed\n");
>>> +		return ERR_PTR(-ENOMEM);
>>> +	}
>>> +
>>> +	bdev = blkdev_get_by_path(strim(path),
>>> +				  FMODE_READ|FMODE_WRITE|FMODE_EXEC,
>>> +				  only_set);
>>> +	if (IS_ERR(bdev)) {
>>> +		pr_info("get %s error: %ld\n", dev_path, PTR_ERR(bdev));
>>> +		kfree(path);
>>> +		return ERR_PTR(PTR_ERR(bdev));
>>> +	}
>>> +
>>> +	err = -ENOMEM;
>>> +	ns = kzalloc(sizeof(struct bch_nvm_namespace), GFP_KERNEL);
>>> +	if (!ns)
>>> +		goto bdput;
>>> +
>>> +	err = -EIO;
>>> +	if (read_nvdimm_meta_super(bdev, ns)) {
>>> +		pr_info("%s read nvdimm meta super block failed.\n",
>>> +			bdevname(bdev, buf));
>>> +		goto free_ns;
>>> +	}
>>> +
>>> +	err = -EOPNOTSUPP;
>>> +	if (!bdev_dax_supported(bdev, ns->page_size)) {
>>> +		pr_info("%s don't support DAX\n", bdevname(bdev, buf));
>>> +		goto free_ns;
>>> +	}
>>> +
>>> +	err = -EINVAL;
>>> +	if (bdev_dax_pgoff(bdev, 0, ns->page_size, &pgoff)) {
>>> +		pr_info("invalid offset of %s\n", bdevname(bdev, buf));
>>> +		goto free_ns;
>>> +	}
>>> +
>>> +	err = -ENOMEM;
>>> +	ns->dax_dev = fs_dax_get_by_bdev(bdev);
>>> +	if (!ns->dax_dev) {
>>> +		pr_info("can't by dax device by %s\n", bdevname(bdev, buf));
>>> +		goto free_ns;
>>> +	}
>>> +
>>> +	err = -EINVAL;
>>> +	id = dax_read_lock();
>>> +	if (dax_direct_access(ns->dax_dev, pgoff, ns->pages_total,
>>> +			      &ns->kaddr, &ns->start_pfn) <= 0) {
>>> +		pr_info("dax_direct_access error\n");
>>> +		dax_read_unlock(id);
>>> +		goto free_ns;
>>> +	}
>>> +	dax_read_unlock(id);
>>> +
>>> +	ns->sb = ns->kaddr + BCH_NVM_PAGES_SB_OFFSET;
>>> +
>> You already read the superblock in read_nvdimm_meta_super(), right?
>> Wouldn't it be better to first do the 'dax_direct_access()' call, and
>> then check the superblock?
>> That way you'll ensure that dax_direct_access()' did the right thing;
>> with the current code you are using two different methods of accessing
>> the superblock, which theoretically can result in one method succeeding,
>> the other not ...
> 
> We have to do it. Because the mapping size of dax_direct_access() is
> from ns->pages_total, it is stored on NVDIMM. Before calling
> dax_direct_acess()
> we need to make sure ns is an valid super block stored on NVDIMM, then
> we can
> trust value of ns->pages_total to do the DAX mapping.
> 
> Another method is firstly mapping a small fixed range (e.g. 1GB), and
> check whether the super block on NVDIMM is valid. If yes, re-map the
> whole space indicated by ns->pages_total. But the two-times accessing cannot
> be avoided.
> 
Oh, indeed, you are correct. Disregard my comments here.

>>> +	err = -EINVAL;
>>> +	/* Check magic again to make sure DAX mapping is correct */
>>> +	if (memcmp(ns->sb->magic, bch_nvm_pages_magic, 16)) {
>>> +		pr_info("invalid bch_nvm_pages_magic after DAX mapping\n");
>>> +		goto free_ns;
>>> +	}
>>> +
>>> +	err = attach_nvm_set(ns);
>>> +	if (err < 0)
>>> +		goto free_ns;
>>> +
>>> +	ns->page_size = ns->sb->page_size;
>>> +	ns->pages_offset = ns->sb->pages_offset;
>>> +	ns->pages_total = ns->sb->pages_total;
>>> +	ns->free = 0;
>>> +	ns->bdev = bdev;
>>> +	ns->nvm_set = only_set;
>>> +	mutex_init(&ns->lock);
>>> +
>>> +	if (ns->sb->this_namespace_nr == 0) {
>>> +		pr_info("only first namespace contain owner info\n");
>>> +		err = init_owner_info(ns);
>>> +		if (err < 0) {
>>> +			pr_info("init_owner_info met error %d\n", err);
>>> +			only_set->nss[ns->sb->this_namespace_nr] = NULL;
>>> +			goto free_ns;
>>> +		}
>>> +	}
>>> +
>>> +	kfree(path);
>>> +	return ns;
>>> +free_ns:
>>> +	kfree(ns);
>>> +bdput:
>>> +	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
>>> +	kfree(path);
>>> +	return ERR_PTR(err);
>>> +}
>>> +EXPORT_SYMBOL_GPL(bch_register_namespace);
>>> +
>>> +int __init bch_nvm_init(void)
>>> +{
>>> +	only_set = kzalloc(sizeof(*only_set), GFP_KERNEL);
>>> +	if (!only_set)
>>> +		return -ENOMEM;
>>> +
>>> +	only_set->total_namespaces_nr = 0;
>>> +	only_set->owner_list_head = NULL;
>>> +	only_set->nss = NULL;
>>> +
>>> +	mutex_init(&only_set->lock);
>>> +
>>> +	pr_info("bcache nvm init\n");
>>> +	return 0;
>>> +}
>>> +
>>> +void bch_nvm_exit(void)
>>> +{
>>> +	release_nvm_set(only_set);
>>> +	pr_info("bcache nvm exit\n");
>>> +}
>>> +
>>> +#endif /* CONFIG_BCACHE_NVM_PAGES */
>>> diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
>>> new file mode 100644
>>> index 000000000000..3e24c4dee7fd
>>> --- /dev/null
>>> +++ b/drivers/md/bcache/nvm-pages.h
>>> @@ -0,0 +1,74 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +
>>> +#ifndef _BCACHE_NVM_PAGES_H
>>> +#define _BCACHE_NVM_PAGES_H
>>> +
>>> +#if defined(CONFIG_BCACHE_NVM_PAGES)
>>> +#include <linux/bcache-nvm.h>
>>> +#endif /* CONFIG_BCACHE_NVM_PAGES */
>>> +
>> Hmm? What is that doing here?
>> Please move it into the source file.
> 
> This is temporary before the whole NVDIMM support for bcache is completed.
> 
> drivers/md/bcache/nvm-pages.h has to be included because there are still
> stub
> routines in this header. Such stub routines like,
> 
> +static inline struct bch_nvm_namespace *bch_register_namespace(const char *dev_path)
> +{
> +	return NULL;
> +}
> 
> will be removed after the whole code completed and merged. So currently we have to
> do this to make sure the NVDIMM related code won't be leaked out if such experimental
> configure is not enabled.
> 
> 
> Thanks for your review. The addressed issue will be fixed and updated in next post.
> 
Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

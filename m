Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE66471CB3
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 20:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhLLTeW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 14:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLLTeW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 14:34:22 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A61C061751
        for <linux-bcache@vger.kernel.org>; Sun, 12 Dec 2021 11:34:22 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id p65so16361619iof.3
        for <linux-bcache@vger.kernel.org>; Sun, 12 Dec 2021 11:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lZ+l7uzShCuzC5tuwX4/K4z01/9IOyPLBkoQZ+OHhsw=;
        b=NoFrd5QdLo/4V2EcaWiZDUQO2KjtIMNGke5SjBW309ZRPodaaJxrjmvw0QjlKb23p3
         9fueuD9x3ies3yzEYI0fK0TJpdvGkC1V+Ku6igDiYEgg9RicbtdS0vTnhHfYVjAr7ksD
         IzS7XadQKseEG3kjJFPoohvBdC+1Bl/lnRs+e82wOPesN7r8etOb3ZYknHeFzIVf6ue3
         vs9p+ydJQVnJ8o2ivWEOK/f8deYHR60VqBVMlPYgh11C4nqzfW5RopXr05+OGwcyxLU1
         bUJBuElgjcJQJjWBTr3tZfVQbt9nbJNexR6mJXoZ87tizWB/c3tMiGY72DtPQl34R2zn
         Aw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZ+l7uzShCuzC5tuwX4/K4z01/9IOyPLBkoQZ+OHhsw=;
        b=sX2KOVy6WxzHOITjGCuxZ0gufg+4TlWUyLRTTpMATrE6VFIbjRntCJFIg9Cwx0YELA
         c4IX5L2zxUWVKJ50qnMYyppfHulDU07PKI5yTuJfJIHfTYhnDS+EnFYRuNKZrkGLvCai
         EC7HPBKMGrkYAu0wLpkefMXotisBQYanMkxwf8bXS2kHknHb0a1Ne1cxAi30577c5S5Q
         ZoApKG4OmeO3nRcn1ckCW2/e29HmfRd4MGit1RP4IoMvT83Mzd6LT2eE8C60f0KqPVSC
         9yh5+5X/UJ+DwcnW7Or4G430kt4l/bayoYjTsAtMFhnDH2SDCEY2thmh0LW/2mC4iJYQ
         lb7g==
X-Gm-Message-State: AOAM530QESz9bSaooNJXzcjsobGhyaCE2sAyUmOuqeSvjlA/+fimPmUC
        4u67w4tYQhFUHn7/Of57Jy2AUw==
X-Google-Smtp-Source: ABdhPJzb+GQE8PRRhWae99vXI1FIHjtNgKdXNg9egXcwgIbMZxFN4PpMfctVkEp+0Gu1GZQACUfjTg==
X-Received: by 2002:a5d:9053:: with SMTP id v19mr30817254ioq.39.1639337661564;
        Sun, 12 Dec 2021 11:34:21 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r14sm7791572ill.70.2021.12.12.11.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 11:34:21 -0800 (PST)
Subject: Re: [PATCH v13 02/12] bcache: initialize the nvm pages allocator
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-3-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <db3fe961-020a-1d0d-bfb8-d5229b50474f@kernel.dk>
Date:   Sun, 12 Dec 2021 12:34:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211212170552.2812-3-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/12/21 10:05 AM, Coly Li wrote:
> diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
> new file mode 100644
> index 000000000000..b654bbbda03e
> --- /dev/null
> +++ b/drivers/md/bcache/nvmpg.c
> @@ -0,0 +1,340 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Nvdimm page-buddy allocator
> + *
> + * Copyright (c) 2021, Intel Corporation.
> + * Copyright (c) 2021, Qiaowei Ren <qiaowei.ren@intel.com>.
> + * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
> + */
> +
> +#include "bcache.h"
> +#include "nvmpg.h"
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
> +
> +struct bch_nvmpg_set *global_nvmpg_set;
> +
> +void *bch_nvmpg_offset_to_ptr(unsigned long offset)
> +{
> +	int ns_id = BCH_NVMPG_GET_NS_ID(offset);
> +	struct bch_nvmpg_ns *ns = global_nvmpg_set->ns_tbl[ns_id];
> +
> +	if (offset == 0)
> +		return NULL;
> +
> +	ns_id = BCH_NVMPG_GET_NS_ID(offset);
> +	ns = global_nvmpg_set->ns_tbl[ns_id];
> +
> +	if (ns)
> +		return (void *)(ns->base_addr + BCH_NVMPG_GET_OFFSET(offset));
> +
> +	pr_err("Invalid ns_id %u\n", ns_id);
> +	return NULL;
> +}
> +
> +unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
> +{
> +	int ns_id = ns->ns_id;
> +	unsigned long offset = (unsigned long)(ptr - ns->base_addr);
> +
> +	return BCH_NVMPG_OFFSET(ns_id, offset);
> +}
> +
> +static void release_ns_tbl(struct bch_nvmpg_set *set)
> +{
> +	int i;
> +	struct bch_nvmpg_ns *ns;
> +
> +	for (i = 0; i < BCH_NVMPG_NS_MAX; i++) {
> +		ns = set->ns_tbl[i];
> +		if (ns) {
> +			fs_put_dax(ns->dax_dev);
> +			blkdev_put(ns->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
> +			set->ns_tbl[i] = NULL;
> +			set->attached_ns--;
> +			kfree(ns);
> +		}
> +	}
> +
> +	if (set->attached_ns)
> +		pr_err("unexpected attached_ns: %u\n", set->attached_ns);
> +}
> +
> +static void release_nvmpg_set(struct bch_nvmpg_set *set)
> +{
> +	release_ns_tbl(set);
> +	kfree(set);
> +}
> +
> +/* Namespace 0 contains all meta data of the nvmpg allocation set */
> +static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
> +{
> +	struct bch_nvmpg_set_header *set_header;
> +
> +	if (ns->ns_id != 0) {
> +		pr_err("unexpected ns_id %u for first nvmpg namespace.\n",
> +		       ns->ns_id);
> +		return -EINVAL;
> +	}
> +
> +	set_header = bch_nvmpg_offset_to_ptr(ns->sb->set_header_offset);
> +
> +	mutex_lock(&global_nvmpg_set->lock);
> +	global_nvmpg_set->set_header = set_header;
> +	global_nvmpg_set->heads_size = set_header->size;
> +	global_nvmpg_set->heads_used = set_header->used;
> +	mutex_unlock(&global_nvmpg_set->lock);
> +
> +	return 0;
> +}
> +
> +static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
> +{
> +	struct bch_nvmpg_sb *sb = ns->sb;
> +	int rc = 0;
> +
> +	mutex_lock(&global_nvmpg_set->lock);
> +
> +	if (global_nvmpg_set->ns_tbl[sb->this_ns]) {
> +		pr_err("ns_id %u already attached.\n", ns->ns_id);
> +		rc = -EEXIST;
> +		goto unlock;
> +	}
> +
> +	if (ns->ns_id != 0) {
> +		pr_err("unexpected ns_id %u for first namespace.\n", ns->ns_id);
> +		rc = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (global_nvmpg_set->attached_ns > 0) {
> +		pr_err("multiple namespace attaching not supported yet\n");
> +		rc = -EOPNOTSUPP;
> +		goto unlock;
> +	}
> +
> +	if ((global_nvmpg_set->attached_ns + 1) > sb->total_ns) {
> +		pr_err("namespace counters error: attached %u > total %u\n",
> +		       global_nvmpg_set->attached_ns,
> +		       global_nvmpg_set->total_ns);
> +		rc = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	memcpy(global_nvmpg_set->set_uuid, sb->set_uuid, 16);
> +	global_nvmpg_set->ns_tbl[sb->this_ns] = ns;
> +	global_nvmpg_set->attached_ns++;
> +	global_nvmpg_set->total_ns = sb->total_ns;
> +
> +unlock:
> +	mutex_unlock(&global_nvmpg_set->lock);
> +	return rc;
> +}
> +
> +static int read_nvdimm_meta_super(struct block_device *bdev,
> +				  struct bch_nvmpg_ns *ns)
> +{
> +	struct page *page;
> +	struct bch_nvmpg_sb *sb;
> +	uint64_t expected_csum = 0;
> +	int r;
> +
> +	page = read_cache_page_gfp(bdev->bd_inode->i_mapping,
> +				BCH_NVMPG_SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
> +
> +	if (IS_ERR(page))
> +		return -EIO;
> +
> +	sb = (struct bch_nvmpg_sb *)
> +	     (page_address(page) + offset_in_page(BCH_NVMPG_SB_OFFSET));
> +
> +	r = -EINVAL;
> +	expected_csum = csum_set(sb);
> +	if (expected_csum != sb->csum) {
> +		pr_info("csum is not match with expected one\n");

"Checksum mismatch"

would be more correct english, should it print the checksums as well?

> +		goto put_page;
> +	}
> +
> +	if (memcmp(sb->magic, bch_nvmpg_magic, 16)) {
> +		pr_info("invalid bch_nvmpg_magic\n");
> +		goto put_page;
> +	}
> +
> +	if (sb->sb_offset !=
> +	    BCH_NVMPG_OFFSET(sb->this_ns, BCH_NVMPG_SB_OFFSET)) {
> +		pr_info("invalid superblock offset 0x%llx\n", sb->sb_offset);
> +		goto put_page;
> +	}
> +
> +	r = -EOPNOTSUPP;
> +	if (sb->total_ns != 1) {
> +		pr_info("multiple name space not supported yet.\n");
> +		goto put_page;
> +	}

Please use namespace consistently.

> +struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
> +{
> +	struct bch_nvmpg_ns *ns = NULL;
> +	struct bch_nvmpg_sb *sb = NULL;
> +	char buf[BDEVNAME_SIZE];
> +	struct block_device *bdev;
> +	pgoff_t pgoff;
> +	int id, err;
> +	char *path;
> +	long dax_ret = 0;
> +
> +	path = kstrndup(dev_path, 512, GFP_KERNEL);
> +	if (!path) {
> +		pr_err("kstrndup failed\n");
> +		return ERR_PTR(-ENOMEM);
> +	}

Really don't think we need that piece of information. Same for a lot of
other places, you have a ton of pr_err() stuff that looks mostly like
debugging.

> +	ns->page_size = sb->page_size;
> +	ns->pages_offset = sb->pages_offset;
> +	ns->pages_total = sb->pages_total;
> +	ns->sb = sb;
> +	ns->free = 0;
> +	ns->bdev = bdev;
> +	ns->set = global_nvmpg_set;
> +
> +	err = attach_nvmpg_set(ns);
> +	if (err < 0)
> +		goto free_ns;
> +
> +	mutex_init(&ns->lock);
> +
> +	err = init_nvmpg_set_header(ns);
> +	if (err < 0)
> +		goto free_ns;

Does this error path need to un-attach?
> +int __init bch_nvmpg_init(void)
> +{
> +	global_nvmpg_set = kzalloc(sizeof(*global_nvmpg_set), GFP_KERNEL);
> +	if (!global_nvmpg_set)
> +		return -ENOMEM;
> +
> +	global_nvmpg_set->total_ns = 0;
> +	mutex_init(&global_nvmpg_set->lock);
> +
> +	pr_info("bcache nvm init\n");

Another useless pr debug print, just get rid of it (and others).

> +void bch_nvmpg_exit(void)
> +{
> +	release_nvmpg_set(global_nvmpg_set);
> +	pr_info("bcache nvm exit\n");
> +}

Ditto


-- 
Jens Axboe


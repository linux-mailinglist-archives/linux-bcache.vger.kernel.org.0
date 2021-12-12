Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255AA471CD6
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 21:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhLLULa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 15:11:30 -0500
Received: from mail-io1-f51.google.com ([209.85.166.51]:40856 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhLLUL3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 15:11:29 -0500
Received: by mail-io1-f51.google.com with SMTP id p23so16376247iod.7
        for <linux-bcache@vger.kernel.org>; Sun, 12 Dec 2021 12:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k7djtLakH6/5qgeRtY9LSI3y4sGPR3n+46CIpVbnqk8=;
        b=JFJjfMSCgl5tHtNhjRZ/YFXqRXlwZK0KTmlhPOQfbEWRbLTTmfAKR6esPtMEMtDjyR
         16xKCOwRqb5KGQgu97xrQ4OOOkLIP0Sb8axzIYYlmr9CMvQ3fMDqZyZUqROoyzgw8nPk
         s7YkbfnsQ8bqZSU44kUSZQhpyKaAnklnHXMqZA6nL98Zpwj4yqYbWHKLf0E7sgh1W3Xz
         prf1vwxrq/ZtZAY8VIYqHjHOamkWXjsRS20txIREKcr78uA+9cWnXuN8siuZPPr9wtTh
         gxWD271Hth/6okqEzXSO/ILYzGKjYtwV8PDTxFXiCOYZVIDhTi0lnMtkqHedxzNNqHtx
         oEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k7djtLakH6/5qgeRtY9LSI3y4sGPR3n+46CIpVbnqk8=;
        b=tweyPMXLDWcMF0EHTDIJH1gXGEIh/hVSMxRg3KPJWNFVHUz9VTBFZZ4F1ahokLi7Nr
         FEkdXESNlRxfjLYiqEt40UBNitJRcShIE7PPkwr9hI2i8yoFRMVh2pantPij30aAXYM5
         M6ImSpwmCPiXTbZrGgNd+0JtsVXQIAvi9jDzkMiVAqlDA6FfDqPaTmw7WrnJ3cy87AES
         kA9gXaKBrwQbOu3m85PXmCw8K+uuDnTje82klTnMz/bUUFdHZk/0AoN7PA4a0jdFscss
         797yEkzNn1O2IhOWw1blvxtOn46fKGJwt/a4dIjG3kgpWoilk5VjjzmCkl9HhqxiFhEI
         EPrg==
X-Gm-Message-State: AOAM532oVjGUiZvFMSvTUoKVc/ruvIgZgg3mhsrDjyDbW4aCdLNRMSHj
        uWEJJzMB7StYJcQJamk+hDAcYw==
X-Google-Smtp-Source: ABdhPJzL1gukDwuwjIt+d0e+Ppbu5BaDycP3Y7qQpC7x5hSYb0on2hpP92R7QvbE2S3vJ9vT7b/wDQ==
X-Received: by 2002:a05:6638:3048:: with SMTP id u8mr29923161jak.148.1639339829072;
        Sun, 12 Dec 2021 12:10:29 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j8sm6655609ilu.64.2021.12.12.12.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 12:10:28 -0800 (PST)
Subject: Re: [PATCH v13 03/12] bcache: initialization of the buddy
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-4-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e578d54-296d-813a-876f-45881ce5a1ba@kernel.dk>
Date:   Sun, 12 Dec 2021 13:10:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211212170552.2812-4-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
> index b654bbbda03e..2b70ee4a6028 100644
> --- a/drivers/md/bcache/nvmpg.c
> +++ b/drivers/md/bcache/nvmpg.c
> @@ -50,6 +50,36 @@ unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
>  	return BCH_NVMPG_OFFSET(ns_id, offset);
>  }
>  
> +static struct page *bch_nvmpg_va_to_pg(void *addr)
> +{
> +	return virt_to_page(addr);
> +}

What's the purpose of this helper?

> +static inline void reserve_nvmpg_pages(struct bch_nvmpg_ns *ns,
> +				       pgoff_t pgoff, u64 nr)
> +{
> +	while (nr > 0) {
> +		unsigned int num = nr > UINT_MAX ? UINT_MAX : nr;

Surely UINT_MAX isn't anywhere near a valid limit?

> @@ -76,10 +110,73 @@ static void release_nvmpg_set(struct bch_nvmpg_set *set)
>  	kfree(set);
>  }
>  
> +static int validate_recs(int ns_id,
> +			 struct bch_nvmpg_head *head,
> +			 struct bch_nvmpg_recs *recs)
> +{
> +	if (memcmp(recs->magic, bch_nvmpg_recs_magic, 16)) {
> +		pr_err("Invalid bch_nvmpg_recs magic\n");
> +		return -EINVAL;
> +	}
> +
> +	if (memcmp(recs->uuid, head->uuid, 16)) {
> +		pr_err("Invalid bch_nvmpg_recs uuid\n");
> +		return -EINVAL;
> +	}
> +
> +	if (recs->head_offset !=
> +	    bch_nvmpg_ptr_to_offset(global_nvmpg_set->ns_tbl[ns_id], head)) {
> +		pr_err("Invalid recs head_offset\n");
> +		return -EINVAL;
> +	}

Same comments here on the frivilous error messaging, other places in
this file too. Check all the other patches as well, please.

>  /* Namespace 0 contains all meta data of the nvmpg allocation set */
>  static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
>  {
>  	struct bch_nvmpg_set_header *set_header;
> +	struct bch_nvmpg_recs *sys_recs;
> +	int i, j, used = 0, rc = 0;
>  
>  	if (ns->ns_id != 0) {
>  		pr_err("unexpected ns_id %u for first nvmpg namespace.\n",
> @@ -93,9 +190,83 @@ static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
>  	global_nvmpg_set->set_header = set_header;
>  	global_nvmpg_set->heads_size = set_header->size;
>  	global_nvmpg_set->heads_used = set_header->used;
> +
> +	/* Reserve the used space from buddy allocator */
> +	reserve_nvmpg_pages(ns, 0, div_u64(ns->pages_offset, ns->page_size));
> +
> +	sys_recs = ns->base_addr + BCH_NVMPG_SYSRECS_OFFSET;
> +	for (i = 0; i < set_header->size; i++) {
> +		struct bch_nvmpg_head *head;
> +
> +		head = &set_header->heads[i];
> +		if (head->state == BCH_NVMPG_HD_STAT_FREE)
> +			continue;
> +
> +		used++;
> +		if (used > global_nvmpg_set->heads_size) {
> +			pr_err("used heads %d > heads size %d.\n",
> +			       used, global_nvmpg_set->heads_size);
> +			goto unlock;
> +		}
> +
> +		for (j = 0; j < BCH_NVMPG_NS_MAX; j++) {
> +			struct bch_nvmpg_recs *recs;
> +
> +			recs = bch_nvmpg_offset_to_ptr(head->recs_offset[j]);
> +
> +			/* Iterate the recs list */
> +			while (recs) {
> +				rc = validate_recs(j, head, recs);
> +				if (rc < 0)
> +					goto unlock;
> +
> +				rc = reserve_nvmpg_recs(recs);
> +				if (rc < 0)
> +					goto unlock;
> +
> +				bitmap_set(ns->recs_bitmap, recs - sys_recs, 1);
> +				recs = bch_nvmpg_offset_to_ptr(recs->next_offset);
> +			}
> +		}
> +	}
> +unlock:
>  	mutex_unlock(&global_nvmpg_set->lock);
> +	return rc;
> +}
>  
> -	return 0;
> +static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
> +{
> +	unsigned int start, end, pages;
> +	int i;
> +	struct page *page;
> +	pgoff_t pgoff_start;
> +
> +	bitmap_for_each_clear_region(ns->pages_bitmap,
> +				     start, end, 0, ns->pages_total) {
> +		pgoff_start = start;
> +		pages = end - start;
> +
> +		while (pages) {
> +			void *addr;
> +
> +			for (i = BCH_MAX_ORDER - 1; i >= 0; i--) {
> +				if ((pgoff_start % (1L << i) == 0) &&
> +				    (pages >= (1L << i)))
> +					break;
> +			}
> +
> +			addr = bch_nvmpg_pgoff_to_ptr(ns, pgoff_start);
> +			page = bch_nvmpg_va_to_pg(addr);
> +			set_page_private(page, i);
> +			page->index = pgoff_start;
> +			__SetPageBuddy(page);
> +			list_add((struct list_head *)&page->zone_device_data,
> +				 &ns->free_area[i]);
> +
> +			pgoff_start += 1L << i;
> +			pages -= 1L << i;
> +		}
> +	}
>  }
>  
>  static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
> @@ -200,7 +371,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
>  	char buf[BDEVNAME_SIZE];
>  	struct block_device *bdev;
>  	pgoff_t pgoff;
> -	int id, err;
> +	int id, i, err;
>  	char *path;
>  	long dax_ret = 0;
>  
> @@ -304,13 +475,48 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
>  
>  	mutex_init(&ns->lock);
>  
> +	/*
> +	 * parameters of bitmap_set/clear are unsigned int.
> +	 * Given currently size of nvm is far from exceeding this limit,
> +	 * so only add a WARN_ON message.
> +	 */
> +	WARN_ON(BITS_TO_LONGS(ns->pages_total) > UINT_MAX);

Does this really need to be a WARN_ON()? Looks more like an -EINVAL
condition.


-- 
Jens Axboe


Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EF1471CE4
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 21:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhLLURu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 15:17:50 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:39684 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhLLURu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 15:17:50 -0500
Received: by mail-io1-f42.google.com with SMTP id c3so16398650iob.6
        for <linux-bcache@vger.kernel.org>; Sun, 12 Dec 2021 12:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uf5AYzw3W83+CSC9tbLrLGgAFvLkWotjuGPWw+XKSLI=;
        b=f/EM5IgqzqaG73npLIAY8bs/WbCFN+k4q8aRPP+AmmhTofEuMzdiF1T+wCmLXGYKch
         JXSfYwtp0beHma/7mupbG9hrn2xR/YP1pz2YC5N/0/0JhNMvm6+BHmOchnuewpO/IOYA
         gzWiZdecYB/1JZ0kCl8vWsj/TPBTZILWl3q1oO2KI2fprvkvUH60O1u6AO7/varTGlfc
         oUhe7seS+7raOx30ro68ZUxyu7Bp6MNJc896Blvx0vtG20ZjerjxhGX6XVX8zNK4/OuD
         TB48ILW4+38t4GGyt04ts97tSMOCC9vyERBUL86zofvth1UtaG4NAOTYT2cS/E8kotWE
         6T/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uf5AYzw3W83+CSC9tbLrLGgAFvLkWotjuGPWw+XKSLI=;
        b=zQFVyR55F61Lzl/62nSKYGVMSZdlWMmkkeeD4DO8VnVUzdlcHNkZ3iWVw7YTsxeXsx
         dH7W91VIVPjDtdIhJTdaJB0LDyyqzhU9P3d9AHqF7p1ANE3VHRGVVfdnJsbj2N6lqyMl
         i5M6vXrOFGGaFBBTrA5mMaS7YPggh50pCZo/pg9C9KGvJq4SJxRJvNoR/0yY8Z65F7dx
         QNl0TT7nWdltGZ19rA1GNavNQw0HluDhh1OHhaL8gN0rSBzFoeH+MYDLteWpKRgfnmVh
         oQgR7FYp7sS0ct1rPUOdb3pnd6u8sGJ/ElVZ5QF5ZAp5Z9MId0+PMxizbQb8rzIZwYMJ
         MSlQ==
X-Gm-Message-State: AOAM531ft5Re5FeRJWvV0cWxyFUJVi0sFf+qhCa1n8jpYfNzz2+oStfp
        afesbiw9pk3JBQj1Zj005xspOA==
X-Google-Smtp-Source: ABdhPJxDHpowed6+cr/Iqn2wYo5qY8IQkCMpY2PMnAtC9/iIAOaCdSMDXwOjaJJyKG01yV3jEM+tFg==
X-Received: by 2002:a05:6602:1609:: with SMTP id x9mr30821653iow.6.1639340209870;
        Sun, 12 Dec 2021 12:16:49 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r3sm6138981iob.0.2021.12.12.12.16.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 12:16:49 -0800 (PST)
Subject: Re: [PATCH v13 05/12] bcache: bch_nvmpg_free_pages() of the buddy
 allocator
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-6-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <34997a50-52c0-33b8-a3ff-e0c02389f365@kernel.dk>
Date:   Sun, 12 Dec 2021 13:16:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211212170552.2812-6-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/12/21 10:05 AM, Coly Li wrote:
> diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
> index a920779eb548..8ce0c4389b42 100644
> --- a/drivers/md/bcache/nvmpg.c
> +++ b/drivers/md/bcache/nvmpg.c
> @@ -248,6 +248,57 @@ static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
>  	return rc;
>  }
>  
> +static void __free_space(struct bch_nvmpg_ns *ns, unsigned long nvmpg_offset,
> +			 int order)
> +{
> +	unsigned long add_pages = (1L << order);
> +	pgoff_t pgoff;
> +	struct page *page;
> +	void *va;
> +
> +	if (nvmpg_offset == 0) {
> +		pr_err("free pages on offset 0\n");
> +		return;
> +	}
> +
> +	page = bch_nvmpg_va_to_pg(bch_nvmpg_offset_to_ptr(nvmpg_offset));
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
> +		va = bch_nvmpg_pgoff_to_ptr(ns, buddy_pgoff);
> +		buddy_page = bch_nvmpg_va_to_pg(va);
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
> +	va = bch_nvmpg_pgoff_to_ptr(ns, pgoff);
> +	page = bch_nvmpg_va_to_pg(va);
> +	WARN_ON(!page);
> +	list_add((struct list_head *)&page->zone_device_data,
> +		 &ns->free_area[order]);
> +	page->index = pgoff;
> +	set_page_private(page, order);
> +	__SetPageBuddy(page);
> +	ns->free += add_pages;
> +}

There are 3 WARN_ON's in here. If you absolutely must use a WARN_ON,
then make them WARN_ON_ONCE(). Ditto in other spots in this patch.

> +void bch_nvmpg_free_pages(unsigned long nvmpg_offset, int order,
> +			  const char *uuid)
> +{
> +	struct bch_nvmpg_ns *ns;
> +	struct bch_nvmpg_head *head;
> +	struct bch_nvmpg_recs *recs;
> +	int r;
> +
> +	mutex_lock(&global_nvmpg_set->lock);
> +
> +	ns = global_nvmpg_set->ns_tbl[BCH_NVMPG_GET_NS_ID(nvmpg_offset)];
> +	if (!ns) {
> +		pr_err("can't find namespace by given kaddr from namespace\n");
> +		goto unlock;
> +	}
> +
> +	head = find_nvmpg_head(uuid, false);
> +	if (!head) {
> +		pr_err("can't found bch_nvmpg_head by uuid\n");
> +		goto unlock;
> +	}
> +
> +	recs = find_nvmpg_recs(ns, head, false);
> +	if (!recs) {
> +		pr_err("can't find bch_nvmpg_recs by uuid\n");
> +		goto unlock;
> +	}
> +
> +	r = remove_nvmpg_rec(recs, ns->sb->this_ns, nvmpg_offset, order);
> +	if (r < 0) {
> +		pr_err("can't find bch_nvmpg_rec\n");
> +		goto unlock;
> +	}
> +
> +	__free_space(ns, nvmpg_offset, order);
> +
> +unlock:
> +	mutex_unlock(&global_nvmpg_set->lock);
> +}

Again tons of useless error prints. Make them return a proper error
instad of just making things void...

> @@ -686,6 +835,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
>  	ns->pages_offset = sb->pages_offset;
>  	ns->pages_total = sb->pages_total;
>  	ns->sb = sb;
> +	/* increase by __free_space() */
>  	ns->free = 0;
>  	ns->bdev = bdev;
>  	ns->set = global_nvmpg_set;

Does that hunk belong in here?

-- 
Jens Axboe


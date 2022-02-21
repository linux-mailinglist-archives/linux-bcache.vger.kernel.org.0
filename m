Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6174BE419
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Feb 2022 18:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358028AbiBUMge (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Feb 2022 07:36:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358044AbiBUMgd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Feb 2022 07:36:33 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F6A17ABE;
        Mon, 21 Feb 2022 04:36:09 -0800 (PST)
Received: from kwepemi100009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K2MDy0MFyz9ssW;
        Mon, 21 Feb 2022 20:34:26 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 kwepemi100009.china.huawei.com (7.221.188.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 20:36:07 +0800
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 20:36:07 +0800
Subject: Re: [PATCH v13 05/12] bcache: bch_nvmpg_free_pages() of the buddy
 allocator
To:     Coly Li <colyli@suse.de>, <axboe@kernel.dk>
CC:     <linux-bcache@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        "Christoph Hellwig" <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        "Hannes Reinecke" <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-6-colyli@suse.de>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <e1e08398-dccb-6c0d-aaa9-da72f0cf9ef1@huawei.com>
Date:   Mon, 21 Feb 2022 20:36:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20211212170552.2812-6-colyli@suse.de>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

ÔÚ 2021/12/13 1:05, Coly Li Ð´µÀ:
> From: Jianpeng Ma <jianpeng.ma@intel.com>
> 
> This patch implements the bch_nvmpg_free_pages() of the buddy allocator.
> 
> The difference between this and page-buddy-free:
> it need owner_uuid to free owner allocated pages, and must
> persistent after free.
> 
> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>   drivers/md/bcache/nvmpg.c | 164 ++++++++++++++++++++++++++++++++++++--
>   drivers/md/bcache/nvmpg.h |   3 +
>   2 files changed, 160 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
> index a920779eb548..8ce0c4389b42 100644
> --- a/drivers/md/bcache/nvmpg.c
> +++ b/drivers/md/bcache/nvmpg.c
> @@ -248,6 +248,57 @@ static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
>   	return rc;
>   }
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
> +
>   static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
>   {
>   	unsigned int start, end, pages;
> @@ -261,21 +312,19 @@ static void bch_nvmpg_init_free_space(struct bch_nvmpg_ns *ns)
>   		pages = end - start;
>   
>   		while (pages) {
> -			void *addr;
> -
>   			for (i = BCH_MAX_ORDER - 1; i >= 0; i--) {
>   				if ((pgoff_start % (1L << i) == 0) &&
>   				    (pages >= (1L << i)))
>   					break;
>   			}
>   
> -			addr = bch_nvmpg_pgoff_to_ptr(ns, pgoff_start);
> -			page = bch_nvmpg_va_to_pg(addr);
> +			page = bch_nvmpg_va_to_pg(
> +					bch_nvmpg_pgoff_to_ptr(ns, pgoff_start));
>   			set_page_private(page, i);
>   			page->index = pgoff_start;
> -			__SetPageBuddy(page);
> -			list_add((struct list_head *)&page->zone_device_data,
> -				 &ns->free_area[i]);
> +
> +			/* In order to update ns->free */
> +			__free_space(ns, pgoff_start, i);

Hi,

While testing this patchset, we found that this is probably wrong,
pgoff_start represent page number here, however, __free_space expect
this to be page offset. Maybe this should be:

__free_space(ns, pgoff_start << PAGE_SHIFT, i);

Thanks,
Kuai

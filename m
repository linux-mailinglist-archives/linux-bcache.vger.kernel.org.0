Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89E4471CDD
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 21:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhLLUPe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 15:15:34 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:37775 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhLLUPd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 15:15:33 -0500
Received: by mail-io1-f42.google.com with SMTP id k21so16378453ioh.4
        for <linux-bcache@vger.kernel.org>; Sun, 12 Dec 2021 12:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rwj0nad5q2hq8VX/DIUevOJ4QtUoXWXfy7Kdh7yQEPU=;
        b=tKcedmKRh3wJUaG+1GcCt8NzzkHOpQkYt9GNiba3guq0oXW4tPY/46Rf/dkj59dlcC
         I0E4i1rOZdpjx0+PoK7CjdcrjKWS8meLTsCikIn18M3R3VlGXwiLPZU63cfJu08zlgC7
         U+PqdkpEMTTuj1lnkLRkrPGY5g76TxlL1ewK/3TZcSw/hwe/m1OME2d3PXVwoQzg5kXb
         2t80hJ5c8E/dzBQGMX3LBCX3+3ZlenKSFFTYSauhzEM45LZw57dv2OVAXhYQ9T0tPEU7
         hk+QrZAmUdqZy0sZ45IM8d1JiKi46Y1L7a7rfswnyQ8cs5l9kv2EldB6NbCpNuyZWA1T
         RbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rwj0nad5q2hq8VX/DIUevOJ4QtUoXWXfy7Kdh7yQEPU=;
        b=5DNNkaAfpU0Qgdlb/EzPSfim6tjiTM0qSSRTRo15kYV5xlj8KFyjI8wHGGIdSvm6HV
         OPlfQaKlCYIjtp6bz9QarhTbYjBLQ8X5Xuj02KhcN9Cf4zVdBp3wMkxRnMR35nd/QcrY
         96weYlyB/RYBesuF72z2kGsfCv3E2r7w8m9cCSAZi3tozhoeklFXKkzWHdNhphM2ThNe
         lpvQblX1RFsmQVECtqYBkghn8oN9TvNE4AdGOG3g7QI1+rkmpcujOqP46HVHGmgJeKGP
         3Uiak0yNImXuqljUajY0ltCfbXRBr2XbHfd9qFs8YkxtkxgRzuPl9Bs73bvLmkv2DyTR
         HTag==
X-Gm-Message-State: AOAM531Y6F1ss5e+rkabCfL/+Wx/Hxpi7bSN+0zyyjQXSxaT4Qi2+8tN
        Bh2EAbuB3pA8cHfzhoLlXmQaAg==
X-Google-Smtp-Source: ABdhPJymTLuRHPYc7Ss2XGfMnR38H2kjZsPhNMspMGpAHyt3wCwKZ8aUeEN9HdiMqplMgWutrFhYIw==
X-Received: by 2002:a05:6638:2105:: with SMTP id n5mr29878759jaj.32.1639340072717;
        Sun, 12 Dec 2021 12:14:32 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id t6sm5896028ios.13.2021.12.12.12.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 12:14:32 -0800 (PST)
Subject: Re: [PATCH v13 04/12] bcache: bch_nvmpg_alloc_pages() of the buddy
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-5-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <22d13a6d-4ac7-18e5-13cd-84e6353755be@kernel.dk>
Date:   Sun, 12 Dec 2021 13:14:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211212170552.2812-5-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/12/21 10:05 AM, Coly Li wrote:
> +/* If not found, it will create if create == true */
> +static struct bch_nvmpg_head *find_nvmpg_head(const char *uuid, bool create)
> +{
> +	struct bch_nvmpg_set_header *set_header = global_nvmpg_set->set_header;
> +	struct bch_nvmpg_head *head = NULL;
> +	int i;
> +
> +	if (set_header == NULL)
> +		goto out;
> +
> +	for (i = 0; i < set_header->size; i++) {
> +		struct bch_nvmpg_head *h = &set_header->heads[i];
> +
> +		if (h->state != BCH_NVMPG_HD_STAT_ALLOC)
> +			continue;
> +
> +		if (!memcmp(uuid, h->uuid, 16)) {
> +			head = h;
> +			break;
> +		}
> +	}
> +
> +	if (!head && create) {
> +		u32 used = set_header->used;
> +
> +		if (set_header->size > used) {
> +			head = &set_header->heads[used];
> +			memset(head, 0, sizeof(struct bch_nvmpg_head));
> +			head->state = BCH_NVMPG_HD_STAT_ALLOC;
> +			memcpy(head->uuid, uuid, 16);
> +			global_nvmpg_set->heads_used++;
> +			set_header->used++;
> +		} else
> +			pr_info("No free bch_nvmpg_head\n");
> +	}

Use {} consistently. Again probably just some printk that should go
away.

> +static struct bch_nvmpg_recs *find_nvmpg_recs(struct bch_nvmpg_ns *ns,
> +					      struct bch_nvmpg_head *head,
> +					      bool create)
> +{
> +	int ns_id = ns->sb->this_ns;
> +	struct bch_nvmpg_recs *prev_recs = NULL, *recs = NULL;
> +
> +	recs = bch_nvmpg_offset_to_ptr(head->recs_offset[ns_id]);
> +
> +	/* If create=false, we return recs[nr] */
> +	if (!create)
> +		return recs;

Would this be cleaner to handle in the caller?

> +static void add_nvmpg_rec(struct bch_nvmpg_ns *ns,
> +			  struct bch_nvmpg_recs *recs,
> +			  unsigned long nvmpg_offset,
> +			  int order)
> +{
> +	int i, ns_id;
> +	unsigned long pgoff;
> +
> +	pgoff = bch_nvmpg_offset_to_pgoff(nvmpg_offset);
> +	ns_id = ns->sb->this_ns;
> +
> +	for (i = 0; i < recs->size; i++) {
> +		if (recs->recs[i].pgoff == 0) {
> +			recs->recs[i].pgoff = pgoff;
> +			recs->recs[i].order = order;
> +			recs->recs[i].ns_id = ns_id;
> +			recs->used++;
> +			break;
> +		}
> +	}
> +	BUG_ON(i == recs->size);

No BUG_ON's, please. It only truly belongs in core code for cases where
error handling isn't possible, does not apply here.

> diff --git a/drivers/md/bcache/nvmpg.h b/drivers/md/bcache/nvmpg.h
> index 55778d4db7da..d03f3241b45a 100644
> --- a/drivers/md/bcache/nvmpg.h
> +++ b/drivers/md/bcache/nvmpg.h
> @@ -76,6 +76,9 @@ struct bch_nvmpg_set {
>  /* Indicate which field in bch_nvmpg_sb to be updated */
>  #define BCH_NVMPG_TOTAL_NS	0	/* total_ns */
>  
> +#define BCH_PGOFF_TO_KVADDR(pgoff)					\
> +	((void *)((unsigned long)(pgoff) << PAGE_SHIFT))

Pretty sure we have a general kernel helper for this, better to use that
rather than duplicate it.

-- 
Jens Axboe


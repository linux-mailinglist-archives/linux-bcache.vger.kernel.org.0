Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C095221C5A
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jul 2020 08:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgGPGIA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 02:08:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:38660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgGPGIA (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 02:08:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 165D5AF8E;
        Thu, 16 Jul 2020 06:08:02 +0000 (UTC)
Subject: Re: [PATCH v3 11/16] bcache: handle cache set verify_ondisk properly
 for bucket size > 8MB
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-12-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2c45279a-9faf-a0a7-6527-bda7c598442b@suse.de>
Date:   Thu, 16 Jul 2020 08:07:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715143015.14957-12-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/15/20 4:30 PM, colyli@suse.de wrote:
> From: Coly Li <colyli@suse.de>
> 
> In bch_btree_cache_alloc() when CONFIG_BCACHE_DEBUG is configured,
> allocate memory for c->verify_ondisk may fail if the bucket size > 8MB,
> which will require __get_free_pages() to allocate continuous pages
> with order > 11 (the default MAX_ORDER of Linux buddy allocator). Such
> over size allocation will fail, and cause 2 problems,
> - When CONFIG_BCACHE_DEBUG is configured,  bch_btree_verify() does not
>    work, because c->verify_ondisk is NULL and bch_btree_verify() returns
>    immediately.
> - bch_btree_cache_alloc() will fail due to c->verify_ondisk allocation
>    failed, then the whole cache device registration fails. And because of
>    this failure, the first problem of bch_btree_verify() has no chance to
>    be triggered.
> 
> This patch fixes the above problem by two means,
> 1) If pages allocation of c->verify_ondisk fails, set it to NULL and
>     returns bch_btree_cache_alloc() with -ENOMEM.
> 2) When calling __get_free_pages() to allocate c->verify_ondisk pages,
>     use ilog2(meta_bucket_pages(&c->sb)) to make sure ilog2() will always
>     generate a pages order <= MAX_ORDER (or CONFIG_FORCE_MAX_ZONEORDER).
>     Then the buddy system won't directly reject the allocation request.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/btree.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

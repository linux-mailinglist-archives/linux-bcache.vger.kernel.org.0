Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BC522114E
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgGOPi2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 11:38:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:41594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgGOPi1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 11:38:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6A2B8AD1E;
        Wed, 15 Jul 2020 15:38:29 +0000 (UTC)
Subject: Re: [PATCH v3 10/16] bcache: handle cache prio_buckets and
 disk_buckets properly for bucket size > 8MB
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715143015.14957-1-colyli@suse.de>
 <20200715143015.14957-11-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8d42ce3f-070d-7862-e8cb-d92ad14059a5@suse.de>
Date:   Wed, 15 Jul 2020 17:38:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715143015.14957-11-colyli@suse.de>
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
> Similar to c->uuids, struct cache's prio_buckets and disk_buckets also
> have the potential memory allocation failure during cache registration
> if the bucket size > 8MB.
> 
> ca->prio_buckets can be stored on cache device in multiple buckets, its
> in-memory space is allocated by kzalloc() interface but normally
> allocated by alloc_pages() because the size > KMALLOC_MAX_CACHE_SIZE.
> 
> So allocation of ca->prio_buckets has the MAX_ORDER restriction too. If
> the bucket size > 8MB, by default the page allocator will fail because
> the page order > 11 (default MAX_ORDER value). ca->prio_buckets should
> also use meta_bucket_bytes(), meta_bucket_pages() to decide its memory
> size and use alloc_meta_bucket_pages() to allocate pages, to avoid the
> allocation failure during cache set registration when bucket size > 8MB.
> 
> ca->disk_buckets is a single bucket size memory buffer, it is used to
> iterate each bucket of ca->prio_buckets, and compose the bio based on
> memory of ca->disk_buckets, then write ca->disk_buckets memory to cache
> disk one-by-one for each bucket of ca->prio_buckets. ca->disk_buckets
> should have in-memory size exact to the meta_bucket_pages(), this is the
> size that ca->prio_buckets will be stored into each on-disk bucket.
> 
> This patch fixes the above issues and handle cache's prio_buckets and
> disk_buckets properly for bucket size larger than 8MB.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/bcache.h |  9 +++++----
>   drivers/md/bcache/super.c  | 10 +++++-----
>   2 files changed, 10 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

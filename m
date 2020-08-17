Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97C6245C6E
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgHQG0h (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:26:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:46766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgHQG0h (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:26:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A4346AD5F;
        Mon, 17 Aug 2020 06:27:00 +0000 (UTC)
Subject: Re: [PATCH 13/14] bcache: remove embedded struct cache_sb from struct
 cache_set
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-14-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1843e122-7c20-45f4-d46c-84c2d7a22adf@suse.de>
Date:   Mon, 17 Aug 2020 08:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-14-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> Since bcache code was merged into mainline kerrnel, each cache set only
> as one single cache in it. The multiple caches framework is here but the
> code is far from completed. Considering the multiple copies of cached
> data can also be stored on e.g. md raid1 devices, it is unnecessary to
> support multiple caches in one cache set indeed.
> 
> The previous preparation patches fix the dependencies of explicitly
> making a cache set only have single cache. Now we don't have to maintain
> an embedded partial super block in struct cache_set, the in-memory super
> block can be directly referenced from struct cache.
> 
> This patch removes the embedded struct cache_sb from struct cache_set,
> and fixes all locations where the superb lock was referenced from this
> removed super block by referencing the in-memory super block of struct
> cache.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/alloc.c     |  6 +++---
>   drivers/md/bcache/bcache.h    |  4 +---
>   drivers/md/bcache/btree.c     | 17 +++++++++--------
>   drivers/md/bcache/btree.h     |  2 +-
>   drivers/md/bcache/extents.c   |  6 +++---
>   drivers/md/bcache/features.c  |  4 ++--
>   drivers/md/bcache/io.c        |  2 +-
>   drivers/md/bcache/journal.c   | 11 ++++++-----
>   drivers/md/bcache/request.c   |  4 ++--
>   drivers/md/bcache/super.c     | 19 +++++++++----------
>   drivers/md/bcache/writeback.c |  2 +-
>   11 files changed, 38 insertions(+), 39 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

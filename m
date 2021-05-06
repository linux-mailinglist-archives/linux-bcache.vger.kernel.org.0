Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09D374E40
	for <lists+linux-bcache@lfdr.de>; Thu,  6 May 2021 06:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhEFEKF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 May 2021 00:10:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:46112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229605AbhEFEKF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 May 2021 00:10:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D11B4B03B;
        Thu,  6 May 2021 04:09:06 +0000 (UTC)
To:     Marc Smith <msmith626@gmail.com>
References: <CAH6h+hc2quJhhBindQwQdK5pfsJRZWk5tX95RT3U_shuN1D=eQ@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Cc:     linux-bcache <linux-bcache@vger.kernel.org>
Subject: Re: [PATCH v2] RFC - Write Bypass Race Bug
Message-ID: <d616e7c1-2406-472f-0653-39612250c2f0@suse.de>
Date:   Thu, 6 May 2021 12:09:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <CAH6h+hc2quJhhBindQwQdK5pfsJRZWk5tX95RT3U_shuN1D=eQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/30/21 10:44 PM, Marc Smith wrote:
> The problem:
> If an inflight backing WRITE operation for a block is performed that
> meets the criteria for bypassing the cache and that takes a long time
> to complete, a READ operation for the same block may be fully
> processed in the interim that populates the cache with the device
> content from before the inflight WRITE. When the inflight WRITE
> finally completes, since it was marked for bypass, the cache is not
> subsequently updated, and the stale data populated by the READ request
> remains in cache. While there is code in bcache for invalidating the
> cache when a bypassed WRITE is performed, this is done prior to
> issuing the backing I/O so it does not help.
> 
> The proposed fix:
> Add two new lists to the cached_dev structure to track inflight
> "bypass" write requests and inflight read requests that have have
> missed cache. These are called "inflight_bypass_write_list" and
> "inflight_read_list", respectively, and are protected by a spinlock
> called the "inflight_lock"
> 
> When a WRITE is bypassing the cache, check whether there is an
> overlapping inflight read. If so, set bypass = false to essentially
> convert the bypass write into a writethrough write. Otherwise, if
> there is no overlapping inflight read, then add the "search" structure
> to the inflight bypass write list.

Hi Marc,

Could you please explain a bit more why the above thing is necessary ?
Please help me to understand your idea more clear :-)

> 
> When a READ misses cache, check whether there is an overlapping
> inflight write. If so, set a new flag in the search structure called
> "do_not_cache" which causes cache population to be skipped after the
> backing I/O completes. Otherwise, if there is no overlapping inflight
> write, then add the "search" structure to the inflight read list.
> 
> The rest of the changes are to add a new stat called
> "bypass_cache_insert_races" to track how many times the race was
> encountered. Example:
> cat /sys/fs/bcache/0c9b7a62-b431-4328-9dcb-a81e322238af/bdev0/stats_total/cache_bypass_races
> 16577
> 

The stat counters make sense.

> Assuming this is the correct approach, areas to look at:
> 1) Searching linked lists doesn't scale. Can something like an
> interval tree be used here instead?

Tree is not good. Heavy I/O may add and delete many nodes in and from
the tree, the operation is heavy and congested, especially this is a
balanced tree.


> 2) Can this be restructured so that the inflight_lock doesn't have to
> be accessed with interrupts disabled? Note that search_free() can be
> called in interrupt context.

Yes it is possible, with a lockless approach. What is needed is an array
to atomic counter. Each element of the array covers a range of LBA, if a
bypass write hits a range of LBA, increases the atomic counter from
corresponding element(s). For the cache miss read, just do an atomic
read without tree iteration and any lock protection.

An array of atomic counters should work but not space efficient, memory
should be allocated for all LBA ranges even most of the counters not
touched during the whole system up time.

Maybe xarray works, but I don't look into the xarray api carefully yet.

> 3) Can do_not_cache just be another (1-bit) flag in the search
> structure instead of occupying its own "int" ?

At this moment, taking an int space is OK.


Thanks for the patch.

Coly Li

> 
> v1 -> v2 changes:
> - Use interval trees instead of linked lists to track inflight requests.
> - Change code order to avoid acquiring lock in search_free().
> ---
>  drivers/md/bcache/bcache.h  |  4 ++
>  drivers/md/bcache/request.c | 88 ++++++++++++++++++++++++++++++++++++-
>  drivers/md/bcache/stats.c   | 14 ++++++
>  drivers/md/bcache/stats.h   |  4 ++
>  drivers/md/bcache/super.c   |  4 ++
>  5 files changed, 113 insertions(+), 1 deletion(-)
> 

[snipped]


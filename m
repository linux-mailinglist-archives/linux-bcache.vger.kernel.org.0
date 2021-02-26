Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5BF3260AE
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Feb 2021 10:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhBZJ5B (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 26 Feb 2021 04:57:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:53314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhBZJyx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Feb 2021 04:54:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2A881AAAE;
        Fri, 26 Feb 2021 09:54:12 +0000 (UTC)
Subject: Re: Large latency with bcache for Ceph OSD
To:     "Norman.Kern" <norman.kern@gmx.com>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-bcache@vger.kernel.org
References: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
 <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
 <5867daf1-0960-39aa-1843-1a76c1e9a28d@suse.de>
 <07bcb6c8-21e1-11de-d1f0-ffd417bd36ff@gmx.com>
 <cfe2746f-18a7-a768-ea72-901793a3133e@gmx.com>
 <96daa0bf-c8e1-a334-14cb-2d260aed5115@suse.de>
 <b808dde3-cb58-907b-4df0-e0eb2938b51e@gmx.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <04770825-b1d2-8ec0-2345-77d49d99631a@suse.de>
Date:   Fri, 26 Feb 2021 17:54:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <b808dde3-cb58-907b-4df0-e0eb2938b51e@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/26/21 4:57 PM, Norman.Kern wrote:
>
[snipped]
>> You may try to trigger a gc by writing to
>> sys/fs/bcache/<cache-set-uuid>/internal/trigger_gc
>>
> When all cache had written back, I triggered gc, it recalled.
> 
> root@WXS0106:~# cat /sys/block/bcache0/bcache/cache/cache_available_percent
> 30
> 
> root@WXS0106:~# echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc
> root@WXS0106:~# cat /sys/block/bcache0/bcache/cache/cache_available_percent
> 97
> 
> Why must I trigger gc manually? Is not a default action of bcache-gc thread? And I found it can only work when all dirty data written back.
> 

1, GC is automatically triggered after some mount of data consumed. I
guess it is just not about time in your situation.

2, Because the gc will shrink all cached clean data, which is very
unfriendly for read-intend workload. Therefore gc_after_writeback is
defaulted as 0, when this sysfs file content set to 1, a gc will trigger
after the writeback accomplished.

Coly Li





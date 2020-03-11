Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878E0181696
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Mar 2020 12:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgCKLPh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Mar 2020 07:15:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:37712 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgCKLPg (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Mar 2020 07:15:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 153E3AED2;
        Wed, 11 Mar 2020 11:15:35 +0000 (UTC)
Subject: Re: [QUESTION] Bcache in writeback mode is bypassed
To:     Benjamin Allot <benjamin.allot@canonical.com>
References: <abe94294-4365-6448-4c46-831c40d4d41d@canonical.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <edb39850-b488-5a54-709e-fc889b932bd1@suse.de>
Date:   Wed, 11 Mar 2020 19:15:30 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <abe94294-4365-6448-4c46-831c40d4d41d@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/3/11 6:20 下午, Benjamin Allot wrote:
> Hello and sorry for the noise if this list is fully intended for contribution or patch purpose only.
> 
> We use bcache quite a lot on our infrastructure, and quite happily so far.
> We recently noticed a strange behavior in the way bcache reports amount of dirty data and the related
> available cache percentage used.
> 
> I opened a related "bug" [0] but I will do a quick TL;DR here
> 
> * bcache is in writeback mode, running, with one cache device, one backing device, writeback_percent set to 40
> 
> * bcache congested_{read,write}_threshold_us are set to 0
> 
> * writeback_rate_debug shows 148Gb of dirty data, priority_stats shows 70% of dirty data in the cache,
>   the cache device is 1.6 TB (and the cache size related to that, given the nbbucket and bucket_size),
>   so one of the metric is lying. Because we're at 70%, I believe we bypass the writeback
>   completely because we reach CUTOFF_WRITEBACK_SYNC [1].
> 
> * As a result, on an I/O intensive throughput server, we have high I/O latency (=~ 1 sec) for both the cache device
>   and the backing device (although I don't explain why we have this latency on the cache device as well. The graphs
>   of both devices are pretty much aligned).
> 
> * when the GC is triggered (manually or automatically), the writeback is restored for a short period of
>   time (10-15 minutes) and the I/O latency drops. Until we reach the 70% of dirty data mark again
> 
> * we seems to have this discrepancy of metric everywhere but because the default writeback_percent is at 10%, we
>   never really reach the 70% threshold as displayed in priority_stats
> 
> Again sorry if this was the wrong forum.
> 
> Regards,
> 
> [0]: https://bugzilla.kernel.org/show_bug.cgi?id=206767
> [1]: https://github.com/torvalds/linux/blob/v4.15/drivers/md/bcache/writeback.h line 69
> 

Hi Benjamin,

I see the kernel is 4.15 stable without bcache backport, am I right ?
There are quite a lot of things fixed in later kernel releases. And I
suggest to use Linux kernel after v5.3 (and v5.5 is better), which I
feel most of obvious issues are fixed.

Could you please to try Linux v5.5 and see whether things get better ?

Thanks.
-- 

Coly Li

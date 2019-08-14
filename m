Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71F78D86D
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Aug 2019 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfHNQuN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Aug 2019 12:50:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:51580 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfHNQuN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Aug 2019 12:50:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C8C4BACC2;
        Wed, 14 Aug 2019 16:50:11 +0000 (UTC)
Subject: Re: [PATCH] bcache: add cond_resched() in __bch_cache_cmp()
To:     Heitor Alves de Siqueira <halves@canonical.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, shile.zhang@linux.alibaba.com,
        vojtech@suse.com
References: <c13b1d2a-a8e6-f20c-604e-a375c018bf66@suse.de>
 <20190814142301.32556-1-halves@canonical.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <74950e24-245a-c627-0e2e-32ac0b304a6c@suse.de>
Date:   Thu, 15 Aug 2019 00:50:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814142301.32556-1-halves@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/8/14 10:23 下午, Heitor Alves de Siqueira wrote:
> Hi Coly,
> 
> We've had users impacted by system stalls and were able to trace it back to the
> bcache priority_stats query. After investigating a bit further, it seems that
> the sorting step in the quantiles calculation can cause heavy CPU
> contention. This has a severe performance impact on any task that is running in
> the same CPU as the sysfs query, and caused issues even for non-bcache
> workloads.
> 
> We did some test runs with fio to get a better picture of the impact on
> read/write workloads while a priority_stats query is running, and came up with
> some interesting results. The bucket locking doesn't seem to have that
> much performance impact even in full-write workloads, but the 'sort' can affect
> bcache device throughput and latency pretty heavily (and any other tasks that
> are "unlucky" to be scheduled together with it). In some of our tests, there was
> a performance reduction of almost 90% in random read IOPS to the bcache device
> (refer to the comparison graph at [0]). There's a few more details on the
> Launchpad bug [1] we've created to track this, together with the complete fio
> results + comparison graphs.
> 
> The cond_resched() patch suggested by Shile Zhang actually improved performance
> a lot, and eliminated the stalls we've observed during the priority_stats
> query. Even though it may cause the sysfs query to take a bit longer, it seems
> like a decent tradeoff for general performance when running that query on a
> system under heavy load. It's also a cheap short-term solution until we can look
> into a more complex re-write of the priority_stats calculation (perhaps one that
> doesn't require the locking?). Could we revisit Shile's patch, and consider
> merging it?
> 
> Thanks!
> Heitor
> 
> [0] https://people.canonical.com/~halves/priority_stats/read/4k-iops-2Dsmooth.png
> [1] https://bugs.launchpad.net/bugs/1840043
> 

Hi Heitor,

With your very detailed explanation I come to understand why people
cares about performance impact of pririty_stats. In the case of system
monitoring, how long priority_stats returns is less important than
overall system throughput.

Yes I agree with your opinion and the benchmark chart makes me confident
with the original patch. I will add this patch to v5.4 window with
tested-by: Heitor Alves de Siqueira <halves@canonical.com>

Thanks for your detailed information. And thanks for Shile Zhang
originally composing this patch.

-- 

Coly Li

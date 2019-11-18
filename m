Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51AB100868
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Nov 2019 16:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfKRPkI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Nov 2019 10:40:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:46914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726739AbfKRPkI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Nov 2019 10:40:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AEC03B32E;
        Mon, 18 Nov 2019 15:40:06 +0000 (UTC)
Subject: Re: [PATCH 02/12] bcache: fix a lost wake-up problem caused by
 mca_cannibalize_lock
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Guoju Fang <fangguoju@gmail.com>
References: <20191113080326.69989-1-colyli@suse.de>
 <20191113080326.69989-3-colyli@suse.de>
 <alpine.LRH.2.11.1911170332430.23583@mx.ewheeler.net>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <10577c93-557a-6f5c-d0ed-7225fcd2c985@suse.de>
Date:   Mon, 18 Nov 2019 23:40:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1911170332430.23583@mx.ewheeler.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/11/17 11:32 上午, Eric Wheeler wrote:
> On Wed, 13 Nov 2019, Coly Li wrote:
> 
>> From: Guoju Fang <fangguoju@gmail.com>
>>
>> This patch fix a lost wake-up problem caused by the race between
>> mca_cannibalize_lock and bch_cannibalize_unlock.
>>
>> Consider two processes, A and B. Process A is executing
>> mca_cannibalize_lock, while process B takes c->btree_cache_alloc_lock
>> and is executing bch_cannibalize_unlock. The problem happens that after
>> process A executes cmpxchg and will execute prepare_to_wait. In this
>> timeslice process B executes wake_up, but after that process A executes
>> prepare_to_wait and set the state to TASK_INTERRUPTIBLE. Then process A
>> goes to sleep but no one will wake up it. This problem may cause bcache
>> device to dead.
>>
>> Signed-off-by: Guoju Fang <fangguoju@gmail.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
> 
> Add cc stable?
> 

Yes, I agree. Now these patches are applied by Jens, how about
explicitly send these patches to linux-stable after they go upstream ?

Thanks.

Coly Li


> -Eric
> 
> 
>> ---
>>  drivers/md/bcache/bcache.h |  1 +
>>  drivers/md/bcache/btree.c  | 12 ++++++++----
>>  drivers/md/bcache/super.c  |  1 +
>>  3 files changed, 10 insertions(+), 4 deletions(-)
>>
[snip]


-- 

Coly Li

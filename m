Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6EE131E9B
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2020 05:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgAGEQ7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 23:16:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:34242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727534AbgAGEQ7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 23:16:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5CE18ABE7;
        Tue,  7 Jan 2020 04:16:57 +0000 (UTC)
Subject: Re: [RFC PATCH 5/7] bcache: limit bcache btree node cache memory
 consumption by I/O throttle
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
References: <20200106160456.45689-1-colyli@suse.de>
 <20200106160456.45689-6-colyli@suse.de>
 <alpine.LRH.2.11.2001062306590.2074@mx.ewheeler.net>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <6450666d-de01-6250-d65a-e3ebec8c7260@suse.de>
Date:   Tue, 7 Jan 2020 12:16:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.2001062306590.2074@mx.ewheeler.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/7 7:08 上午, Eric Wheeler wrote:
> On Tue, 7 Jan 2020, Coly Li wrote:
> 
>> Now most of obvious deadlock or panic problems in bcache are fixed, so
>> bcache now can survie under very high I/O load until ... it consumpts
>> all system memory for bcache btree node cache, and the system hangs or
>> panics.
>>
>> The bcache btree node cache is used to cache the bcace btree node from
>> SSD to memory, when determine whether a data block is cached or not
>> by indexing the btree, the speed can be much more fast by an in-memory
>> search.
>>
>> Before this patch, there is no btree node cache memory limitation, just
>> a slab shrinker callback registered to slab memory manager. If the I/O
>> requests are coming faster than kernel memory management code to shrink
>> the bcache btree node cache memory, it is possible for bcache to consume
>> all available system memory for its btree node cache, and make whole
>> system hang or panic. On high performance machine with many CPU cores,
>> large memory size and SSD capanicity, it is often observed the whole
>> system gets hung or panic afer 12+ hours high small random I/O load
>> (e.g. 30K IOPS with 512 bytes random reads and writes).
>>
>> This patch tries to limit bcache btree node cache memory consumption by
>> I/O throttle. The idea is,
>> 1) Add kernel thread c->btree_cache_shrink_thread to shrink in-memory
>>    cached btree nodes.
>> 2) Add a threshold c->btree_cache_threshold to limit number of in-memory
>>    cached btree node, if c->btree_cache_used reaches the threshold, wake
>>    up the shrink kernel thread to shrink in-memory cached btree nodes.
>> 3) In the shrink kernel thread, call __bch_mca_scan() with reap_flush
>>    parameter set to true, then all candidate clean and dirty (flush to
>>    SSD before reap) btree nodes will be shrunk.
>> 4) In the shrink kernel thread main loop, try to shrink 100 btree nodes
>>    by calling __bch_mca_scan(). Inside __bch_mca_scan() c->bucket_lock
>>    is held during shrinking all the 100 btree nodes. The shrinking will
>>    stop until in-memory cached btree node number less than
>> 	c->btree_cache_threshold - MCA_SHRINK_DEFAULT_HYSTERESIS
>>    MCA_SHRINK_DEFAULT_HYSTERESIS is used to avoid the shrinking kernel
>>    thread is waken up too frequently, by default its value is 1000.
>>
>> The I/O throttle happens when __bch_mca_scan() is called in the while-
>> loop inside the shrink kernel thread main loop.
>> - Every time when __bch_mca_scan() is called, 100 btree nodes are about
>>   to shrink. During __bch_mca_scan() shrinking all the btree nodes,
>>   c->bucket_lock is held.
>> - When a write request coming, bcache needs to allocate a SSD space for
>>   the cached data with c->bucket_lock held. If __bch_mca_scan() is
>>   executing to shrink btree node memory, the allocation operation has to
>>   wait for c->bucket_lock.
>> - When allocating in-memory btree node for new I/O request, mutex
>>   c->bucket_lock is also required. If __bch_mca_scan() is running
>>   new I/O request has to wait until the above 100 btree nodes are
>>   shunk, then the new I/O request has chance to compete c->bucket_lock.
>> Once c->bucket_lock is acquired inside shrink kernel thread, all other
>> I/Os has to wait until the 100 in-memory btree node cache are shunk.
>> Then the I/O requests are throttled by shrink kernel thread until all
>> in-memory cached btree node number is less than,
>> 	c->btree_cache_threshold - MCA_SHRINK_DEFAULT_HYSTERESIS
>>
>> This is a simple but working method to limit bcache btree node cache
>> memory consumption by I/O throttle.
>>
>> By default c->btree_cache_threshold is 15000, if the btree node size is
>> 2MB (default bucket size), it is around 30GB. It means if the bcache
>> btree node cache accupies around 30GB memory, the shrink kernel thread
>> will wake up and start to shrink the bcache in-memory btree node cache.
>>
>> 30GB in-memory btree node cache is already big enough, it is reasonable
>> for a default threshold. If there is report in fture that people do want
>> to offer much more memory for bcache in-memory btree node cache, there
>> will be a sysfs interface later for such configuration.
> 
> Is there already a sysfs that shows what is currently used by the cache?

Yes, it is /sys/fs/bcache/<UUID>/btree_cache_size, it shows amount of
memory occupied by in-memory btree node cache.

So far I don't see the out-of-memory report from others, it seems only
myself notices and observes such issue. Therefore I am not sure whether
an extra interface for btree cache size threshold is necessary (we have
had a lot already).


[snipped]

-- 

Coly Li

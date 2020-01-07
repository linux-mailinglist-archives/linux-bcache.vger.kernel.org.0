Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68738133062
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2020 21:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgAGUMk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 Jan 2020 15:12:40 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:58115 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgAGUMj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Jan 2020 15:12:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 040A9A0692;
        Tue,  7 Jan 2020 20:12:34 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id cj8HNE1GhdJX; Tue,  7 Jan 2020 20:12:12 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id BF09DA0440;
        Tue,  7 Jan 2020 20:12:07 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net BF09DA0440
Date:   Tue, 7 Jan 2020 20:12:06 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     linux-bcache@vger.kernel.org
Subject: Re: [RFC PATCH 5/7] bcache: limit bcache btree node cache memory
 consumption by I/O throttle
In-Reply-To: <6450666d-de01-6250-d65a-e3ebec8c7260@suse.de>
Message-ID: <alpine.LRH.2.11.2001072006270.2074@mx.ewheeler.net>
References: <20200106160456.45689-1-colyli@suse.de> <20200106160456.45689-6-colyli@suse.de> <alpine.LRH.2.11.2001062306590.2074@mx.ewheeler.net> <6450666d-de01-6250-d65a-e3ebec8c7260@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-844282404-478050418-1578427927=:2074"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---844282404-478050418-1578427927=:2074
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 7 Jan 2020, Coly Li wrote:
> On 2020/1/7 7:08 上午, Eric Wheeler wrote:
> > On Tue, 7 Jan 2020, Coly Li wrote:
> > 
> >> Now most of obvious deadlock or panic problems in bcache are fixed, so
> >> bcache now can survie under very high I/O load until ... it consumpts
> >> all system memory for bcache btree node cache, and the system hangs or
> >> panics.
> >>
> >> The bcache btree node cache is used to cache the bcace btree node from
> >> SSD to memory, when determine whether a data block is cached or not
> >> by indexing the btree, the speed can be much more fast by an in-memory
> >> search.
> >>
> >> Before this patch, there is no btree node cache memory limitation, just
> >> a slab shrinker callback registered to slab memory manager. If the I/O
> >> requests are coming faster than kernel memory management code to shrink
> >> the bcache btree node cache memory, it is possible for bcache to consume
> >> all available system memory for its btree node cache, and make whole
> >> system hang or panic. On high performance machine with many CPU cores,
> >> large memory size and SSD capanicity, it is often observed the whole
> >> system gets hung or panic afer 12+ hours high small random I/O load
> >> (e.g. 30K IOPS with 512 bytes random reads and writes).
> >>
> >> This patch tries to limit bcache btree node cache memory consumption by
> >> I/O throttle. The idea is,
> >> 1) Add kernel thread c->btree_cache_shrink_thread to shrink in-memory
> >>    cached btree nodes.
> >> 2) Add a threshold c->btree_cache_threshold to limit number of in-memory
> >>    cached btree node, if c->btree_cache_used reaches the threshold, wake
> >>    up the shrink kernel thread to shrink in-memory cached btree nodes.
> >> 3) In the shrink kernel thread, call __bch_mca_scan() with reap_flush
> >>    parameter set to true, then all candidate clean and dirty (flush to
> >>    SSD before reap) btree nodes will be shrunk.
> >> 4) In the shrink kernel thread main loop, try to shrink 100 btree nodes
> >>    by calling __bch_mca_scan(). Inside __bch_mca_scan() c->bucket_lock
> >>    is held during shrinking all the 100 btree nodes. The shrinking will
> >>    stop until in-memory cached btree node number less than
> >> 	c->btree_cache_threshold - MCA_SHRINK_DEFAULT_HYSTERESIS
> >>    MCA_SHRINK_DEFAULT_HYSTERESIS is used to avoid the shrinking kernel
> >>    thread is waken up too frequently, by default its value is 1000.
> >>
> >> The I/O throttle happens when __bch_mca_scan() is called in the while-
> >> loop inside the shrink kernel thread main loop.
> >> - Every time when __bch_mca_scan() is called, 100 btree nodes are about
> >>   to shrink. During __bch_mca_scan() shrinking all the btree nodes,
> >>   c->bucket_lock is held.
> >> - When a write request coming, bcache needs to allocate a SSD space for
> >>   the cached data with c->bucket_lock held. If __bch_mca_scan() is
> >>   executing to shrink btree node memory, the allocation operation has to
> >>   wait for c->bucket_lock.
> >> - When allocating in-memory btree node for new I/O request, mutex
> >>   c->bucket_lock is also required. If __bch_mca_scan() is running
> >>   new I/O request has to wait until the above 100 btree nodes are
> >>   shunk, then the new I/O request has chance to compete c->bucket_lock.
> >> Once c->bucket_lock is acquired inside shrink kernel thread, all other
> >> I/Os has to wait until the 100 in-memory btree node cache are shunk.
> >> Then the I/O requests are throttled by shrink kernel thread until all
> >> in-memory cached btree node number is less than,
> >> 	c->btree_cache_threshold - MCA_SHRINK_DEFAULT_HYSTERESIS
> >>
> >> This is a simple but working method to limit bcache btree node cache
> >> memory consumption by I/O throttle.
> >>
> >> By default c->btree_cache_threshold is 15000, if the btree node size is
> >> 2MB (default bucket size), it is around 30GB. It means if the bcache
> >> btree node cache accupies around 30GB memory, the shrink kernel thread
> >> will wake up and start to shrink the bcache in-memory btree node cache.
> >>
> >> 30GB in-memory btree node cache is already big enough, it is reasonable
> >> for a default threshold. If there is report in fture that people do want
> >> to offer much more memory for bcache in-memory btree node cache, there
> >> will be a sysfs interface later for such configuration.
> > 
> > Is there already a sysfs that shows what is currently used by the cache?
> 
> Yes, it is /sys/fs/bcache/<UUID>/btree_cache_size, it shows amount of
> memory occupied by in-memory btree node cache.
> 
> So far I don't see the out-of-memory report from others, it seems only
> myself notices and observes such issue. Therefore I am not sure whether
> an extra interface for btree cache size threshold is necessary (we have
> had a lot already).


FYI, these are some of our btree_cache_size's:

 ~]# cat /sys/fs/bcache/*/btree_cache_size
263.6M

 ~]# cat /sys/fs/bcache/*/btree_cache_size
174.2M

 ~]# cat /sys/fs/bcache/*/btree_cache_size
523.5M

 ~]# cat /sys/fs/bcache/*/btree_cache_size
464.2M

 ~]# cat /sys/fs/bcache/*/btree_cache_size
847.2M

 ~]# cat /sys/fs/bcache/*/btree_cache_size
864.0M

 ~]# cat /sys/fs/bcache/*/btree_cache_size
441.2M

 ~]# cat /sys/fs/bcache/*/btree_cache_size
1.2G


--
Eric Wheeler


> 
> 
> [snipped]
> 
> -- 
> 
> Coly Li
> 
---844282404-478050418-1578427927=:2074--

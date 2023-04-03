Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3836D5152
	for <lists+linux-bcache@lfdr.de>; Mon,  3 Apr 2023 21:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjDCT1x (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 3 Apr 2023 15:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjDCT1w (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 3 Apr 2023 15:27:52 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1253E7C
        for <linux-bcache@vger.kernel.org>; Mon,  3 Apr 2023 12:27:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 7ADAD40;
        Mon,  3 Apr 2023 12:27:51 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id myi9AvbX4qqR; Mon,  3 Apr 2023 12:27:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id E741D85;
        Mon,  3 Apr 2023 12:27:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net E741D85
Date:   Mon, 3 Apr 2023 12:27:46 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>
Subject: Re: Writeback cache all used.
In-Reply-To: <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de>
Message-ID: <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-796620248-1680550066=:27286"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-796620248-1680550066=:27286
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 3 Apr 2023, Coly Li wrote:
> > 2023年4月2日 08:01，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > 
> > On Fri, 31 Mar 2023, Adriano Silva wrote:
> >> Thank you very much!
> >> 
> >>> I don't know for sure, but I'd think that since 91% of the cache is
> >>> evictable, writing would just evict some data from the cache (without
> >>> writing to the HDD, since it's not dirty data) and write to that area of
> >>> the cache, *not* to the HDD. It wouldn't make sense in many cases to
> >>> actually remove data from the cache, because then any reads of that data
> >>> would have to read from the HDD; leaving it in the cache has very little
> >>> cost and would speed up any reads of that data.
> >> 
> >> Maybe you're right, it seems to be writing to the cache, despite it 
> >> indicating that the cache is at 100% full.
> >> 
> >> I noticed that it has excellent reading performance, but the writing 
> >> performance dropped a lot when the cache was full. It's still a higher 
> >> performance than the HDD, but much lower than it is when it's half full 
> >> or empty.
> >> 
> >> Sequential writing tests with "_fio" now show me 240MB/s of writing, 
> >> which was already 900MB/s when the cache was still half full. Write 
> >> latency has also increased. IOPS on random 4K writes are now in the 5K 
> >> range. It was 16K with half used cache. At random 4K with Ioping, 
> >> latency went up. With half cache it was 500us. It is now 945us.
> >> 
> >> For reading, nothing has changed.
> >> 
> >> However, for systems where writing time is critical, it makes a 
> >> significant difference. If possible I would like to always keep it with 
> >> a reasonable amount of empty space, to improve writing responses. Reduce 
> >> 4K latency, mostly. Even if it were for me to program a script in 
> >> crontab or something like that, so that during the night or something 
> >> like that the system executes a command for it to clear a percentage of 
> >> the cache (about 30% for example) that has been unused for the longest 
> >> time . This would possibly make the cache more efficient on writes as 
> >> well.
> > 
> > That is an intersting idea since it saves latency. Keeping a few unused 
> > ready to go would prevent GC during a cached write. 
> > 
> 
> Currently there are around 10% reserved already, if dirty data exceeds 
> the threshold further writing will go into backing device directly.

It doesn't sound like he is referring to dirty data.  If I understand 
correctly, he means that when the cache is 100% allocated (whether or not 
anything is dirty) that latency is 2x what it could be compared to when 
there are unallocated buckets ready for writing (ie, after formatting the 
cache, but before it fully allocates).  His sequential throughput was 4x 
slower with a 100% allocated cache: 900MB/s at 50% full after a format, 
but only 240MB/s when the cache buckets are 100% allocated.

> Reserve more space doesn’t change too much, if there are always busy 
> write request arriving. For occupied clean cache space, I tested years 
> ago, the space can be shrunk very fast and it won’t be a performance 
> bottleneck. If the situation changes now, please inform me.

His performance specs above indicate that 100% occupided but clean cache 
increases latency (due to release/re-allocate overhead).  The increased 
latency reduces effective throughput.

> > Coly, would this be an easy feature to add?
> 
> To make it, the change won’t be complexed. But I don’t feel it may solve 
> the original writing performance issue when space is almost full. In the 
> code we already have similar lists to hold available buckets for future 
> data/metadata allocation.

Questions: 

- Right after a cache is formated and attached to a bcache volume, which 
  list contains the buckets that have never been used?

- Where does bcache insert back onto that list?  Does it?

> But if the lists are empty, there is still time required to do the dirty 
> writeback and garbage collection if necessary.

True, that code would always remain, no change there.

> > Bcache would need a `cache_min_free` tunable that would (asynchronously) 
> > free the least recently used buckets that are not dirty.
> 
> For clean cache space, it has been already.

I'm not sure what you mean by "it has been already" - do you mean this is 
already implemented?  If so, what/where is the sysfs tunable (or 
hard-coded min-free-buckets value) ?

> This is very fast to shrink clean cache space, I did a test 2 years ago, 
> it was just not more than 10 seconds to reclaim around 1TB+ clean cache 
> space. I guess the time might be much less, because reading the 
> information from priorities file also takes time.

Reclaiming large chunks of cache is probably fast in one shot, but 
reclaiming one "clean but allocated" bucket (or even a few buckets) with 
each WRITE has latency overhead associated with it.  Early reclaim to some 
reasonable (configrable) minimum free-space value could hide that latency 
in many workloads.

Long-running bcache volumes are usually 100% allocated, and if freeing 
batches of clean buckets is fast, then doing it early would save metadata 
handling during clean bucket re-allocation for new writes (and maybe 
read-promotion, too).


--
Eric Wheeler

> 
> 
> Coly Li
> 
> 
> 
--8323328-796620248-1680550066=:27286--

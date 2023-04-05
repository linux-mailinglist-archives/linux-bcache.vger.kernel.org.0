Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0B66D86C7
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Apr 2023 21:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjDETYl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Apr 2023 15:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDETYl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Apr 2023 15:24:41 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404804C12
        for <linux-bcache@vger.kernel.org>; Wed,  5 Apr 2023 12:24:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id DE9A546;
        Wed,  5 Apr 2023 12:24:39 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id EDuM6goeloKb; Wed,  5 Apr 2023 12:24:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 768C345;
        Wed,  5 Apr 2023 12:24:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 768C345
Date:   Wed, 5 Apr 2023 12:24:35 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
In-Reply-To: <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
Message-ID: <ba3d48a-24ac-6c28-d5e1-d45a58e5960@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-497452666-1680722675=:27286"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-497452666-1680722675=:27286
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Apr 2023, Coly Li wrote:
> > 2023年4月5日 04:29，Adriano Silva <adriano_da_silva@yahoo.com.br> 写道：
> > 
> > Hello,
> > 
> >> It sounds like a large cache size with limit memory cache 
> >> for B+tree nodes?
> > 
> >> If the memory is limited and all B+tree nodes in the hot I/O 
> >> paths cannot stay in memory, it is possible for such 
> >> behavior happens. In this case, shrink the cached data 
> >> may deduce the meta data and consequential in-memory 
> >> B+tree nodes as well. Yes it may be helpful for such 
> >> scenario.
> > 
> > There are several servers (TEN) all with 128 GB of RAM, of which 
> > around 100GB (on average) are presented by the OS as free. Cache is 
> > 594GB in size on enterprise NVMe, mass storage is 6TB. The 
> > configuration on all is the same. They run Ceph OSD to service a pool 
> > of disks accessed by servers (others including themselves).
> > 
> > All show the same behavior.
> > 
> > When they were installed, they did not occupy the entire cache. 
> > Throughout use, the cache gradually filled up and never decreased in 
> > size. I have another five servers in another cluster going the same 
> > way. During the night their workload is reduced.
> 
> Copied.
> 
> >> But what is the I/O pattern here? If all the cache space occupied by 
> >> clean data for read request, and write performance is cared about 
> >> then. Is this a write tended, or read tended workload, or mixed?
> > 
> > The workload is greater in writing. Both are important, read and 
> > write. But write latency is critical. These are virtual machine disks 
> > that are stored on Ceph. Inside we have mixed loads, Windows with 
> > terminal service, Linux, including a database where direct write 
> > latency is critical.
> 
> 
> Copied.
> 
> >> As I explained, the re-reclaim has been here already. But it cannot 
> >> help too much if busy I/O requests always coming and writeback and gc 
> >> threads have no spare time to perform.
> >>
> >> If coming I/Os exceeds the service capacity of the cache service 
> >> window, disappointed requesters can be expected.
> > 
> > Today, the ten servers have been without I/O operation for at least 24 
> > hours. Nothing has changed, they continue with 100% cache occupancy. I 
> > believe I should have given time for the GC, no?
> 
> This is nice. Now we have the maximum writeback thoughput after I/O idle 
> for a while, so after 24 hours all dirty data should be written back and 
> the whole cache might be clean.
> 
> I guess just a gc is needed here.
> 
> Can you try to write 1 to cache set sysfs file gc_after_writeback? When 
> it is set, a gc will be waken up automatically after all writeback 
> accomplished. Then most of the clean cache might be shunk and the B+tree 
> nodes will be deduced quite a lot.

If writeback is done then you might need this to trigger it, too:
	echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc

Question for Coly: Will `gc_after_writeback` evict read-promoted pages, 
too, making this effectively a writeback-only cache?

Here is the commit:
	https://patchwork.kernel.org/project/linux-block/patch/20181213145357.38528-9-colyli@suse.de/

> >> Let’s check whether it is just becasue of insuffecient 
> >> memory to hold the hot B+tree node in memory.
> > 
> > Does the bcache configuration have any RAM memory reservation options? 
> > Or would the 100GB of RAM be insufficient for the 594GB of NVMe Cache? 
> > For that amount of Cache, how much RAM should I have reserved for 
> > bcache? Is there any command or parameter I should use to signal 
> > bcache that it should reserve this RAM memory? I didn't do anything 
> > about this matter. How would I do it?
> > 
> 
> Currently there is no such option for limit bcache in-memory B+tree 
> nodes cache occupation, but when I/O load reduces, such memory 
> consumption may drop very fast by the reaper from system memory 
> management code. So it won’t be a problem. Bcache will try to use any 
> possible memory for B+tree nodes cache if it is necessary, and throttle 
> I/O performance to return these memory back to memory

Does bcache intentionally throttle I/O under memory pressure, or is the 
I/O throttling just a side-effect of increased memory pressure caused by 
fewer B+tree nodes in cache?

> management code when the available system memory is low. By default, it 
> should work well and nothing should be done from user.
> 
> > Another question: How do I know if I should trigger a TRIM (discard) 
> > for my NVMe with bcache?
> 
> Bcache doesn’t issue trim request proactively. 

Are you sure?  Maybe I misunderstood the code here, but it looks like 
buckets get a discard during allocation:
	https://elixir.bootlin.com/linux/v6.3-rc5/source/drivers/md/bcache/alloc.c#L335

	static int bch_allocator_thread(void *arg)
	{
		...
		while (1) {
			long bucket;

			if (!fifo_pop(&ca->free_inc, bucket))
				break;

			if (ca->discard) {
				mutex_unlock(&ca->set->bucket_lock);
				blkdev_issue_discard(ca->bdev, <<<<<<<<<<<<<
					bucket_to_sector(ca->set, bucket),
					ca->sb.bucket_size, GFP_KERNEL);
				mutex_lock(&ca->set->bucket_lock);
			}
			...
		}
		...
	}

-Eric


> The bcache program from bcache-tools may issue a discard request when 
> you run,
> 	bcache make -C <cache device path>
> to create a cache device.
> 
> In run time, bcache code only forward the trim request to backing device (not cache device).



> 
> 
> Thanks.
> 
> Coly Li
>  
> 
> > 
> [snipped]
> 
> 
--8323328-497452666-1680722675=:27286--

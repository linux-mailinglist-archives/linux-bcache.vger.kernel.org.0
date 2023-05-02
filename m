Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D866F4B6D
	for <lists+linux-bcache@lfdr.de>; Tue,  2 May 2023 22:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjEBUeY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 May 2023 16:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjEBUeY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 May 2023 16:34:24 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F871198C
        for <linux-bcache@vger.kernel.org>; Tue,  2 May 2023 13:34:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id B142647;
        Tue,  2 May 2023 13:34:21 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 9crx-jHRFr4C; Tue,  2 May 2023 13:34:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 251E546;
        Tue,  2 May 2023 13:34:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 251E546
Date:   Tue, 2 May 2023 13:34:15 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
In-Reply-To: <1399491299.3275222.1681990558684@mail.yahoo.com>
Message-ID: <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
 <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com> <1399491299.3275222.1681990558684@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-498046013-1683059657=:22690"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-498046013-1683059657=:22690
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 20 Apr 2023, Adriano Silva wrote:
> I continue to investigate the situation. There is actually a performance 
> gain when the bcache device is only half filled versus full. There is a 
> reduction and greater stability in the latency of direct writes and this 
> improves my scenario.

Hi Coly, have you been able to look at this?

This sounds like a great optimization and Adriano is in a place to test 
this now and report his findings.

I think you said this should be a simple hack to add early reclaim, so 
maybe you can throw a quick patch together (even a rough first-pass with 
hard-coded reclaim values)

If we can get back to Adriano quickly then he can test while he has an 
easy-to-reproduce environment.  Indeed, this could benefit all bcache 
users.

--
Eric Wheeler



> 
> But it should be noted that the difference is noticed when we wait for 
> the device to rest (organize itself internally) after being cleaned. 
> Maybe for him to clear his internal caches?
> 
> I thought about keeping gc_after_writeback on all the time and also 
> turning on bcache's discard option to see if that improves. But my back 
> device is an HDD.
> 
> One thing that wasn't clear to me since the last conversation is about 
> the bcache discard option, because Coly even said that the discard would 
> be passed only to the back device. However, Eric pulled up a snippet of 
> source code that supposedly could indicate something different, asking 
> Coly if there could be a mistake. Anyway Coly, can you confirm whether 
> or not the discard is passed on to the buckets deleted from the cache? 
> Or does it confirm that it would really only be for the back device?
> 
> Thank you all!
> 
> 
> 
> Em domingo, 9 de abril de 2023 às 18:07:41 BRT, Adriano Silva <adriano_da_silva@yahoo.com.br> escreveu: 
> 
> 
> 
> 
> 
> Hi Coly! 
> 
> Talking about the TRIM (discard) made in the cache...
> 
> > There was such attempt but indeed doesn’t help at all. 
> > The reason is, bcache can only know which bucket can 
> > be discarded when it is handled by garbage collection.
> 
> Come to think of it, I spoke to Eric before something curious, but I could be wrong. What I understand about the "garbage collector" is that the "garbage" would be parts of buckets (blocks) that would not have been reused and were "lost" outside the c->free list and also outside the free_inc list. If I'm correct in my perception, I think the garbage collector would help very little in my case. Of course, all help is welcome. But I'm already thinking about the bigger one.
> 
> If I think correctly, I don't think that in my case most of the buckets would be collected by the garbage collector. Because it is data that has not been erased in the file system. They would need to be cleaned (saved to the mass device) and after some time passed without access, removed from the cache. That is, in the cache would only be hot data. That is recently accessed data (LRU), but never allowing the cache to fill completely.
> 
> Using the same logic that bcache already uses to choose a bucket to be erased and replaced (in case the cache is already completely full and a new write is requested), it would do the same, allocating empty space by erasing the data in the bucket (in many buckets) previously whenever you notice that the cache is very close to being full. You can do this in the background, asynchronously. So in this case I understand that TRIM/discard should help a lot. Do not you think?
> 
> So my question would be: is bcache capable of ranking recently accessed buckets, differentiating into lines (levels) of more or less recently accessed buckets?
> 
> I think the variable I mentioned, which I saw in the kernel documentation (freelist_percent), may have been designed for this purpose.
> 
> Coly, thank you very much!
> 
> 
> 
> Em domingo, 9 de abril de 2023 às 17:14:57 BRT, Adriano Silva <adriano_da_silva@yahoo.com.br> escreveu: 
> 
> 
> Hello Eric !
> 
> > Did you try to trigger gc after setting gc_after_writeback=1?
> > 
> >         echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc
> > 
> > The `gc_after_writeback=1` setting might not trigger until writeback
> > finishes, but if writeback is already finished and there is no new IO then
> > it may never trigger unless it is forced via `tigger_gc`
> > 
> > -Eric
> 
> 
> Yes, I use the two commands indicated several times, one after the other, first one, then the other, then in reversed order... successive times, after hours of zero disk writing/reading. On more than one server. I tested it on all my servers actually. And in all, the results are similar, there is no significant cache space flush.
> 
> And to make matters worse, in other performance tests, I realized that depending on the size of the block I manipulate, the difference in performance is frightening. With 4MB blocks I can write 691MB/s with freshly formatted cache.
> 
> root@pve-01-007:~# ceph tell osd.0 bench                
> {                
>     bytes_written: 1073741824,                
>     blocksize: 4194304,                
>     elapsed_sec: 1.5536911500000001,                
>     bytes_per_sec: 691090905.67967761,
>     iops: 164.76891176216068
> }                
> root@pve-01-007:~#
> 
> In the same test I only get 142MB/s when all cache is occupied.
> 
> root@pve-00-005:~# ceph tell osd.0 bench
> {
>     bytes_written: 1073741824,
>     blocksize: 4194304,
>     elapsed_sec: 7.5302066820000002,
>     bytes_per_sec: 142591281.93209398,
>     iops: 33.996410830520148
> }
> root@pve-00-005:~#
> 
> That is, with the cache after all occupied, the bcache can write with only 21% of the performance obtained with the newly formatted cache. It doesn't look like we're talking about exactly the same hardware... Same NVME, same processors, same RAM, same server, same OS, same bcache settings..... If you format the cache, it returns to the original performance.
> 
> I'm looking at the bcache source code to see if I can pick up anything that might be useful to me. But the code is big and complex. I confess that it is not quick to understand.
> 
> I created a little C program to try and call a built-in bcache function for testing, but I spent Sunday and couldn't even compile the program. It is funny.
> 
> But what would the garbage collector be in this case? What I understand is that the "garbage" would be parts of buckets (blocks) that would not have been reused and were "lost" outside the c->free list and also outside the free_inc list. I think that would help yes, but maybe in a very limited way. Is this the condition of most buckets that are in use?
> 
> As it seems to me (I could be talking nonsense), what would solve the problem would be to get bcache to allocate an adequate amount of buckets in the c->free list. I see this being mentioned in bcache/alloc.c
> 
> Would it be through invalidate_buckets(ca) called through the bch_allocator_thread(void *arg) thread? I don't know. What is limiting the action of this thread? I could not understand.
> 
> But here in my anxious ignorance, I'm left thinking maybe this was the way, a way to call this function to invalidate many clean buckets in the lru order and discard them. So I looked for an external interface that calls it, but I didn't find it.
> 
> Thank you very much!
> 
> Em domingo, 9 de abril de 2023 às 13:37:32 BRT, Coly Li <colyli@suse.de> escreveu: 
> 
> 
> 
> 
> 
> 
> 
> > 2023年4月6日 03:31，Adriano Silva <adriano_da_silva@yahoo.com.br> 写道：
> > 
> > Hello Coly.
> > 
> > Yes, the server is always on. I allowed it to stay on for more than 24 hours with zero disk I/O to the bcache device. The result is that there are no movements on the cache or data disks, nor on the bcache device as we can see:
> > 
> > root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> > --dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 ----system----
> >  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ|    time    
> >  54k  154k: 301k  221k: 223k  169k|0.67  0.54 :6.99  20.5 :6.77  12.3 |05-04 14:45:50
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:51
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:52
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:53
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:54
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:55
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:56
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:57
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:58
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:45:59
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:00
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:01
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:02
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:03
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:04
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:05
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:06
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 14:46:07
> > 
> > It can stay like that for hours without showing any, zero data flow, either read or write on any of the devices.
> > 
> > root@pve-00-005:~# cat /sys/block/bcache0/bcache/state
> > clean
> > root@pve-00-005:~#
> > 
> > But look how strange, in another command (priority_stats), it shows that there is still 1% of dirt in the cache. And 0% unused cache space. Even after hours of server on and completely idle:
> > 
> > root@pve-00-005:~# cat /sys/devices/pci0000:80/0000:80:01.1/0000:82:00.0/nvme/nvme0/nvme0n1/nvme0n1p1/bcache/priority_stats
> > Unused:        0%
> > Clean:          98%
> > Dirty:          1%
> > Metadata:      0%
> > Average:        1137
> > Sectors per Q:  36245232
> > Quantiles:      [12 26 42 60 80 127 164 237 322 426 552 651 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2076 2232 2350 2471 2594 2764]
> > 
> > Why is this happening?
> > 
> >> Can you try to write 1 to cache set sysfs file 
> >> gc_after_writeback? 
> >> When it is set, a gc will be waken up automatically after 
> >> all writeback accomplished. Then most of the clean cache 
> >> might be shunk and the B+tree nodes will be deduced 
> >> quite a lot.
> > 
> > Would this be the command you ask me for?
> > 
> > root@pve-00-005:~# echo 1 > /sys/fs/bcache/a18394d8-186e-44f9-979a-8c07cb3fbbcd/internal/gc_after_writeback
> > 
> > If this command is correct, I already advance that it did not give the expected result. The Cache continues with 100% of the occupied space. Nothing has changed despite the cache being cleaned and having written the command you recommended. Let's see:
> > 
> > root@pve-00-005:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stats
> > Unused:        0%
> > Clean:          98%
> > Dirty:          1%
> > Metadata:      0%
> > Average:        1137
> > Sectors per Q:  36245232
> > Quantiles:      [12 26 42 60 80 127 164 237 322 426 552 651 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2076 2232 2350 2471 2594 2764]
> > 
> > But if there was any movement on the disks after the command, I couldn't detect it:
> > 
> > root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> > --dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 ----system----
> >  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ|    time    
> >  54k  153k: 300k  221k: 222k  169k|0.67  0.53 :6.97  20.4 :6.76  12.3 |05-04 15:28:57
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 15:28:58
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 15:28:59
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 15:29:00
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 15:29:01
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 15:29:02
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 15:29:03
> >    0    0 :  0    0 :  0    0 |  0    0 :  0    0 :  0    0 |05-04 15:29:04^C
> > root@pve-00-005:~#
> > 
> > Why were there no changes?
> 
> Thanks for the above information. The result is unexpected from me. Let me check whether the B+tree nodes are not shrunk, this is something should be improved. And when the write erase time matters for write requests, normally it is the condition that heavy write loads coming. In such education, the LBA of the collected buckets might be allocated out very soon even before the SSD controller finishes internal write-erasure by the hint of discard/trim. Therefore issue discard/trim right before writing to this LBA doesn’t help on any write performance and involves in extra unnecessary workload into the SSD controller.
> 
> And for nowadays SATA/NVMe SSDs, with your workload described above, the write performance drawback can be almost ignored
> 
> > 
> >> Currently there is no such option for limit bcache 
> >> in-memory B+tree nodes cache occupation, but when I/O 
> >> load reduces, such memory consumption may drop very 
> >> fast by the reaper from system memory management 
> >> code. So it won’t be a problem. Bcache will try to use any 
> >> possible memory for B+tree nodes cache if it is 
> >> necessary, and throttle I/O performance to return these 
> >> memory back to memory management code when the 
> >> available system memory is low. By default, it should 
> >> work well and nothing should be done from user.
> > 
> > I've been following the server's operation a lot and I've never seen less than 50 GB of free RAM memory. Let's see: 
> > 
> > root@pve-00-005:~# free              total        used        free      shared  buff/cache  available
> > Mem:      131980688    72670448    19088648      76780    40221592    57335704
> > Swap:              0          0          0
> > root@pve-00-005:~#
> > 
> > There is always plenty of free RAM, which makes me ask: Could there really be a problem related to a lack of RAM?
> 
> No, this is not because of insufficient memory. From your information the memory is enough.
> 
> > 
> >> Bcache doesn’t issue trim request proactively. 
> >> [...]
> >> In run time, bcache code only forward the trim request to backing device (not cache device).
> > 
> > Wouldn't it be advantageous if bcache sent TRIM (discard) to the cache temporarily? I believe flash drives (SSD or NVMe) that need TRIM to maintain top performance are typically used as a cache for bcache. So, I think that if the TRIM command was used regularly by bcache, in the background (only for clean and free buckets), with a controlled frequency, or even if executed by a manually triggered by the user background task (always only for clean and free buckets), it could help to reduce the write latency of the cache. I believe it would help the writeback efficiency a lot. What do you think about this?
> 
> There was such attempt but indeed doesn’t help at all. The reason is, bcache can only know which bucket can be discarded when it is handled by garbage collection. 
> 
> 
> > 
> > Anyway, this issue of the free buckets not appearing is keeping me awake at night. Could it be a problem with my Kernel version (Linux 5.15)?
> > 
> > As I mentioned before, I saw in the bcache documentation (https://docs.kernel.org/admin-guide/bcache.html) a variable (freelist_percent) that was supposed to control a minimum rate of free buckets. Could it be a solution? I don't know. But in practice, I didn't find this variable in my system (could it be because of the OS version?)
> 
> Let me look into this…
> 
> 
> Thanks.
> 
> Coly Li
> 
> 
--8323328-498046013-1683059657=:22690--

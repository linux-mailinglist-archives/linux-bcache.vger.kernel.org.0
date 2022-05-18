Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AC752AFDF
	for <lists+linux-bcache@lfdr.de>; Wed, 18 May 2022 03:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiERBXK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 17 May 2022 21:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiERBXJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 17 May 2022 21:23:09 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA6054681
        for <linux-bcache@vger.kernel.org>; Tue, 17 May 2022 18:23:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 8D0644A;
        Tue, 17 May 2022 18:23:08 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 7szOXptHDa-G; Tue, 17 May 2022 18:23:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 1C25340;
        Tue, 17 May 2022 18:23:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 1C25340
Date:   Tue, 17 May 2022 18:22:59 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Coly Li <colyli@suse.de>, Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
In-Reply-To: <958894243.922478.1652201375900@mail.yahoo.com>
Message-ID: <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 10 May 2022, Adriano Silva wrote:
> I'm trying to set up a flash disk NVMe as a disk cache for two or three 
> isolated (I will use 2TB disks, but in these tests I used a 1TB one) 
> spinning disks that I have on a Linux 5.4.174 (Proxmox node).

Coly has been adding quite a few optimizations over the years.  You might 
try a new kernel and see if that helps.  More below.

> I'm using a NVMe (960GB datacenter devices with tantalum capacitors) as 
> a cache.
> [...]
>
> But when I do the same test on bcache writeback, the performance drops a 
> lot. Of course, it's better than the performance of spinning disks, but 
> much worse than when accessed directly from the NVMe device hardware.
>
> [...]
> As we can see, the same test done on the bcache0 device only got 1548 
> IOPS and that yielded only 6.3 KB/s.

Well done on the benchmarking!  I always thought our new NVMes performed 
slower than expected but hadn't gotten around to investigating. 

> I've noticed in several tests, varying the amount of jobs or increasing 
> the size of the blocks, that the larger the size of the blocks, the more 
> I approximate the performance of the physical device to the bcache 
> device.

You said "blocks" but did you mean bucket size (make-bcache -b) or block 
size (make-bcache -w) ?

If larger buckets makes it slower than that actually surprises me: bigger 
buckets means less metadata and better sequential writeback to the 
spinning disks (though you hadn't yet hit writeback to spinning disks in 
your stats).  Maybe you already tried, but varying the bucket size might 
help.  Try graphing bucket size (powers of 2) against IOPS, maybe there is 
a "sweet spot"?

Be aware that 4k blocks (so-called "4Kn") is unsafe for the cache device, 
unless Coly has patched that.  Make sure your `blockdev --getss` reports 
512 for your NVMe!

Hi Coly,

Some time ago you ordered an an SSD to test the 4k cache issue, has that 
been fixed?  I've kept an eye out for the patch but not sure if it was released.

You have a really great test rig setup with NVMes for stress
testing bcache. Can you replicate Adriano's `ioping` numbers below?

> With ioping it is also possible to notice a limitation, as the latency 
> of the bcache0 device is around 1.5ms, while in the case of the raw 
> device (a partition of NVMe), the same test is only 82.1us.
> 
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=1 time=1.52 ms (warmup)
> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=2 time=1.60 ms
> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3 time=1.55 ms
>
> root@pve-20:~# ioping -c10 /dev/nvme0n1p2 -D -Y -WWW -s4k
> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=1 time=81.2 us (warmup)
> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=2 time=82.7 us
> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3 time=82.4 us

Wow, almost 20x higher latency, sounds convincing that something is wrong.

A few things to try:

1. Try ioping without -Y.  How does it compare?

2. Maybe this is an inter-socket latency issue.  Is your server 
   multi-socket?  If so, then as a first pass you could set the kernel 
   cmdline `isolcpus` for testing to limit all processes to a single 
   socket where the NVMe is connected (see `lscpu`).  Check `hwloc-ls`
   or your motherboard manual to see how the NVMe port is wired to your
   CPUs.

   If that helps then fine tune with `numactl -cN ioping` and 
   /proc/irq/<n>/smp_affinity_list (and `grep nvme /proc/interrupts`) to 
   make sure your NVMe's are locked to IRQs on the same socket.

3a. sysfs:

> # echo 0 > /sys/block/bcache0/bcache/sequential_cutoff

good.

> # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
> # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us

Also try these (I think bcache/cache is a symlink to /sys/fs/bcache/<cache set>)

echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us 
echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us


Try tuning journal_delay_ms: 
  /sys/fs/bcache/<cset-uuid>/journal_delay_ms
    Journal writes will delay for up to this many milliseconds, unless a 
    cache flush happens sooner. Defaults to 100.

3b: Hacking bcache code:

I just noticed that journal_delay_ms says "unless a cache flush happens 
sooner" but cache flushes can be re-ordered so flushing the journal when 
REQ_OP_FLUSH comes through may not be useful, especially if there is a 
high volume of flushes coming down the pipe because the flushes could kill 
the NVMe's cache---and maybe the 1.5ms ping is actual flash latency.  It
would flush data and journal.

Maybe there should be a cachedev_noflush sysfs option for those with some 
kind of power-loss protection of there SSD's.  It looks like this is 
handled in request.c when these functions call bch_journal_meta():

	1053: static void cached_dev_nodata(struct closure *cl)
	1263: static void flash_dev_nodata(struct closure *cl)

Coly can you comment about journal flush semantics with respect to 
performance vs correctness and crash safety?

Adriano, as a test, you could change this line in search_alloc() in 
request.c:

	- s->iop.flush_journal    = op_is_flush(bio->bi_opf);
	+ s->iop.flush_journal    = 0;

and see how performance changes.

Someone correct me if I'm wrong, but I don't think flush_journal=0 will 
affect correctness unless there is a crash.  If that /is/ the performance 
problem then it would narrow the scope of this discussion.

4. I wonder if your 1.5ms `ioping` stats scale with CPU clock speed: can 
   you set your CPU governor to run at full clock speed and then slowest 
   clock speed to see if it is a CPU limit somewhere as we expect?

   You can do `grep MHz /proc/cpuinfo` to see the active rate to make sure 
   the governor did its job.  

   If it scales with CPU then something in bcache is working too hard.  
   Maybe garbage collection?  Other devs would need to chime in here to 
   steer the troubleshooting if that is the case.


5. I'm not sure if garbage collection is the issue, but you might try 
   Mingzhe's dynamic incremental gc patch:
	https://www.spinics.net/lists/linux-bcache/msg11185.html

6. Try dm-cache and see if its IO latency is similar to bcache: If it is 
   about the same then that would indicate an issue in the block layer 
   somewhere outside of bcache.  If dm-cache is better, then that confirms 
   a bcache issue.


> The cache was configured directly on one of the NVMe partitions (in this 
> case, the first partition). I did several tests using fio and ioping, 
> testing on a partition on the NVMe device, without partition and 
> directly on the raw block, on a first partition, on the second, with or 
> without configuring bcache. I did all this to remove any doubt as to the 
> method. The results of tests performed directly on the hardware device, 
> without going through bcache are always fast and similar.
> 
> But tests in bcache are always slower. If you use writethrough, of 
> course, it gets much worse, because the performance is equal to the raw 
> spinning disk.
> 
> Using writeback improves a lot, but still doesn't use the full speed of 
> NVMe (honestly, much less than full speed).

Indeed, I hope this can be fixed!  A 20x improvement in bcache would 
be awesome.
 
> But I've also noticed that there is a limit on writing sequential data, 
> which is a little more than half of the maximum write rate shown in 
> direct tests by the NVMe device.

For sync, async, or both?

> Processing doesn't seem to be going up like the tests.

What do you mean "processing" ?

-Eric



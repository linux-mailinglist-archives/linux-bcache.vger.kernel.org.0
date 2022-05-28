Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8315369AE
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 03:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237441AbiE1B2C (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 21:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbiE1B2C (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 21:28:02 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B57127199
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 18:27:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 3E4F981;
        Fri, 27 May 2022 18:27:58 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id N0WVGyPo1hTo; Fri, 27 May 2022 18:27:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 8EF93B;
        Fri, 27 May 2022 18:27:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 8EF93B
Date:   Fri, 27 May 2022 18:27:53 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
cc:     Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
In-Reply-To: <532745340.2051210.1653624441686@mail.yahoo.com>
Message-ID: <5b164113-364b-76a8-5bcc-94c1cec868db@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <681726005.1812841.1653564986700@mail.yahoo.com> <8aac4160-4da5-453b-48ba-95e79fb8c029@ewheeler.net>
 <532745340.2051210.1653624441686@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1285737907-1653701273=:2952"
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

--8323328-1285737907-1653701273=:2952
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 27 May 2022, Adriano Silva wrote:
> > Please confirm that this says "write back":
> 
> > ]# cat /sys/block/nvme0n1/queue/write_cache
> 
> No, this says "write through"
> 
> 
> > ]# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
> Done!
> 
> I can say that the performance of tests after the write back command for 
> all devices greatly worsens the performance of direct tests on NVME 
> hardware. Below you can see this.

I wonder what is going on there!  I tried the same thing on my system and 
'write through' is faster for me, too, so it would be worth investigating.

Try this too in case the scheduler is getting in the way, but I don't 
think thats it at this point:

	echo none > /sys/block/nvme0n1/queue/scheduler
 
> What I realized doing the test was, right after doing the blkdiscard on 
> the first server the command took a long time, I think more than 1 
> minute to return. After the return, when doing the ioping it increased 
> the latency a lot that I'm used to. So I turned the server off and on 
> again to discard again and test. I noticed that he improved, as I 
> demonstrate.

Hmm, a server power cycle decreases IO latency?  Maybe it reset something 
in the NVMe embedded CPU that drives the FTL...

You could try changing the PCIe payload size to 512 or 256 if your BIOS 
has such a setting, but I would expect that to be slower...but maybe 
faster for 512b IO's?  Not sure but you could try it:
	https://www.techarp.com/bios-guide/pci-e-maximum-payload-size/

> From my understanding of the tests, it was clear that the performance of 
> direct writes to NVME hardware on the two servers is very similar. 
> Perhaps exactly the same. Also in NVME, when writing 512 Bytes at a 
> time, the latency starts well but gets worse after a few write 
> operations, which doesn't happen when writing 4K which always has better 
> performance.
> 
> In all scenarios, when using write cache on 
> /sys/block/nvme0n1/queue/write_cache, performance is severely degraded.
> 
> Also in all scenarios, when synchronization is required (parameter -Y), 
> the performance is slightly worse.

Ultimately it is clear that your NVMe doesn't like 512b requests, they 
have a ~6x higher RTT:

    512b:
        root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -WWW -s512
        min/avg/max/mdev = 476.4 us / 479.2 us / 480.9 us / 1.73 us
                                      ^^^^^

        root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -Y -WWW -s512
        min/avg/max/mdev = 476.4 us / 479.2 us / 480.9 us / 1.73 us
                                      ^^^^^
    4k:
        root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -Y -WWW -s4K
        min/avg/max/mdev = 70.9 us / 79.4 us / 94.3 us / 9.20 us
                                     ^^^^

        root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -WWW -s4K
        min/avg/max/mdev = 66.1 us / 82.7 us / 119.0 us / 21.2 us
                                     ^^^^

... so unfortunately this is a hardware issue that bcache can't easily fix.

You could format everything with -w 4096 if it will work for your 
application.  It is safe to run bcache with -w 4096, we have for 8 years 
now.

However, keep your hardware sector size of the cache device (blockdev 
--getss /dev/nvme0n1) at 512b like it is now because there might be a 4k 
cache device alignment bug floating around.

If the bug is still out there, then it is caused by a possiblity that 
bcache may send 512b-aligned IOs to 4k-aligned cachedevs.  In your case 
the only downside to that is lower performance, but if you were using a 
"4Kn" cache device then it may not be safe.

The only way to get a 4Kn cache device is to purchase an NVMe with 4Kn or 
use vendor tools to re-format it that way so---its not going to happen by 
accident!  As far as I have seen, 4Kn backing devices are fine with 
-w 4096; the possible problem is just in the cache device.


I'm not sure what else to suggest at this point.  If you really need 512b 
IOs then you might try a few different NVMe vendors to benchmark and 
ioping them with 512b sectors to see how they respond and I would be 
curious to know what you find!

--
Eric Wheeler

> But between servers, there is no difference in bcache when the backup 
> device is in RAM.
> 
> >I think in newer kernels that bcache is more aggressive at writeback. 
> >Using /dev/mapper/zero as above will help rule out backing device 
> >interference.  Also make sure you have the sysfs flags turned to 
> >encourge it to write to SSD and not bypass
> 
> I actually went back to using the previous Kernel version (5.4) after I 
> noticed that it wouldn't have improved performance. Today, both servers 
> have version 5.4.
> 
> 
> Just below the result right after the blkdiscard that took a long time.
> 
> =========
> In first server
> 
> root@pve-20:~# cat /sys/block/nvme0n1/queue/write_cache
> write through
> root@pve-20:~# blkdiscard /dev/nvme0n1
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=544.6 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=388.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=1.44 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=656.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=1.71 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=1.83 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=702.2 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=582.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=1.15 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=1.07 ms
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 9.54 ms, 4.50 KiB written, 943 iops, 471.9 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 388.1 us / 1.06 ms / 1.83 ms / 487.4 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=1.28 ms (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=678.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=725.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=1.25 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=794.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=493.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=1.10 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=1.06 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=971.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=1.11 ms
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 8.19 ms, 4.50 KiB written, 1.10 k iops, 549.2 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 493.1 us / 910.3 us / 1.25 ms / 235.1 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=471.0 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=1.06 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=1.17 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=1.29 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=830.5 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=1.31 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=1.40 ms (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=195.0 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=841.2 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=1.22 ms
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 9.32 ms, 36 KiB written, 965 iops, 3.77 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 195.0 us / 1.04 ms / 1.40 ms / 352.0 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=645.2 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=1.20 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=1.41 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=1.39 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=978.4 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=75.8 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=68.6 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=74.0 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=73.7 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=67.0 us (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 5.34 ms, 36 KiB written, 1.68 k iops, 6.58 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 67.0 us / 593.7 us / 1.41 ms / 595.1 us
> root@pve-20:~#
> 
> ==========
> Here, below the results after I shut down the first server and test again:
> 
> root@pve-20:~# blkdiscard /dev/nvme0n1
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=68.4 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=76.5 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=67.0 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=60.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=463.9 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=471.4 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=505.1 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=501.0 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=486.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=520.4 us (slow)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 3.15 ms, 4.50 KiB written, 2.85 k iops, 1.39 MiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 60.1 us / 350.2 us / 520.4 us / 200.3 us
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=460.8 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=507.5 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=514.9 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=505.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=500.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=503.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=506.9 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=499.4 us (fast)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=500.1 us (fast)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=502.4 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 4.54 ms, 4.50 KiB written, 1.98 k iops, 991.0 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 499.4 us / 504.5 us / 514.9 us / 4.64 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=56.7 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=81.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=60.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=78.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=75.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=79.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=91.2 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=76.6 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=79.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=87.1 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 708.4 us, 36 KiB written, 12.7 k iops, 49.6 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 60.0 us / 78.7 us / 91.2 us / 8.20 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=86.6 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=72.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=60.5 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=70.5 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=72.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=60.2 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=83.5 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=60.4 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=86.0 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=61.2 us (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 627.7 us, 36 KiB written, 14.3 k iops, 56.0 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 60.2 us / 69.7 us / 86.0 us / 9.49 us
> root@pve-20:~#
> 
> ======= 
> On the second server...
> On the second server, blkdiscard didn't take long and the first result was the one below:
> 
> root@pve-21:~# cat /sys/block/nvme0n1/queue/write_cache
> write through
> root@pve-21:~# blkdiscard /dev/nvme0n1
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=60.7 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=71.9 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=77.4 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=61.2 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=468.2 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=497.0 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=491.8 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=490.6 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=494.4 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=493.9 us (slow)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 3.15 ms, 4.50 KiB written, 2.86 k iops, 1.40 MiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 61.2 us / 349.6 us / 497.0 us / 197.8 us
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=494.5 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=490.6 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=490.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=489.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=492.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=488.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=496.0 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=492.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=493.0 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=508.0 us (slow)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 4.44 ms, 4.50 KiB written, 2.03 k iops, 1013.5 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 488.1 us / 493.3 us / 508.0 us / 5.60 us
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=84.9 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=75.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=76.5 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=76.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=77.6 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=78.8 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=84.2 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=85.0 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=79.3 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=97.1 us (slow)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 730.1 us, 36 KiB written, 12.3 k iops, 48.1 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 75.7 us / 81.1 us / 97.1 us / 6.48 us
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=80.8 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=77.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=70.9 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=69.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=72.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=68.3 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=71.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=86.7 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=93.2 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=64.8 us (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 674.3 us, 36 KiB written, 13.3 k iops, 52.1 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 64.8 us / 74.9 us / 93.2 us / 8.79 us
> root@pve-21:~#
> 
> ========== 
> After switching to wirte back and going back to write through.
> In first server...
> 
> oot@pve-20:~# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=2.31 ms (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=2.37 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=2.40 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=2.45 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=2.57 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=2.46 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=2.57 ms (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=2.56 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=2.38 ms (fast)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=2.48 ms
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 22.2 ms, 4.50 KiB written, 404 iops, 202.4 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 2.37 ms / 2.47 ms / 2.57 ms / 75.2 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=1.16 ms (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=1.15 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=1.14 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=1.15 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=1.17 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=1.15 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=1.13 ms (fast)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=1.14 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=1.22 ms (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=1.20 ms
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 10.5 ms, 4.50 KiB written, 860 iops, 430.1 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 1.13 ms / 1.16 ms / 1.22 ms / 27.6 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=2.03 ms (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=2.04 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=2.07 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=2.07 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=2.05 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=2.02 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=2.05 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=2.09 ms (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=2.04 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=1.99 ms (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 18.4 ms, 36 KiB written, 489 iops, 1.91 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 1.99 ms / 2.04 ms / 2.09 ms / 29.0 us
> root@pve-20:~#
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=703.4 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=725.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=724.8 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=705.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=733.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=697.6 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=690.2 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=688.4 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=689.5 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=671.7 us (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 6.33 ms, 36 KiB written, 1.42 k iops, 5.56 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 671.7 us / 702.9 us / 733.1 us / 19.6 us
> root@pve-20:~#
> root@pve-20:~# for i in /sys/block/*/queue/write_cache; do echo 'write through' > $i; done
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=82.6 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=89.3 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=61.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=74.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=89.4 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=62.5 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=74.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=81.3 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=78.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=84.3 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 694.9 us, 36 KiB written, 13.0 k iops, 50.6 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 61.7 us / 77.2 us / 89.4 us / 9.67 us
> root@pve-20:~#
> 
> =============
> On  the second server...
> 
> root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
> root@pve-21:~# blkdiscard /dev/nvme0n1
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=1.83 ms (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=2.39 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=2.40 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=2.21 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=2.44 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=2.34 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=2.34 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=2.42 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=2.22 ms (fast)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=2.20 ms (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 21.0 ms, 4.50 KiB written, 429 iops, 214.7 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 2.20 ms / 2.33 ms / 2.44 ms / 88.9 us
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=1.12 ms (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=663.6 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=1.12 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=1.11 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=1.11 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=1.16 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=1.18 ms (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=1.11 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=1.16 ms
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=1.17 ms (slow)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 9.78 ms, 4.50 KiB written, 920 iops, 460.2 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 663.6 us / 1.09 ms / 1.18 ms / 151.9 us
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=1.85 ms (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=1.81 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=1.82 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=1.82 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=2.01 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=1.99 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=1.98 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=1.95 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=1.83 ms
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=1.82 ms (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 17.0 ms, 36 KiB written, 528 iops, 2.06 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 1.81 ms / 1.89 ms / 2.01 ms / 82.3 us
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=673.1 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=667.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=688.2 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=653.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=661.5 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=663.3 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=698.0 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=663.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=708.6 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=677.2 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 6.08 ms, 36 KiB written, 1.48 k iops, 5.78 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 653.1 us / 675.6 us / 708.6 us / 17.7 us
> root@pve-21:~#
> root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write through' > $i; done
> root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=85.3 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=79.8 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=74.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=85.6 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=66.8 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=92.2 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=73.5 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=65.0 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=73.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=73.2 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 683.7 us, 36 KiB written, 13.2 k iops, 51.4 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 65.0 us / 76.0 us / 92.2 us / 8.17 us
> root@pve-21:~#
> 
> As you can see from the tests, the write performance on NVME hardware is horrible when putting /sys/block/*/queue/write_cache as 'write back'.
> 
> 
> =====
> Lets go..
> 
> root@pve-21:~# modprobe brd rd_size=$((128*1024))
> root@pve-21:~# cat << EOT | dmsetup create zero
>     0 262144 linear /dev/ram0 0
>     262144 2147483648 zero
> > EOT
> root@pve-21:~# blkdiscard /dev/nvme0n1
> root@pve-21:~# make-bcache -w 512 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback
> UUID:            563eaa85-43e9-491b-8c1f-f1b94a8f97c8
> Set UUID:        0dcec849-9ee9-41a9-b220-b1923e93cdb1
> version:        0
> nbuckets:        1831430
> block_size:        1
> bucket_size:        1024
> nr_in_set:        1
> nr_this_dev:        0
> first_bucket:        1
> UUID:            acdd0f18-4198-43dd-847a-087058d80c25
> Set UUID:        0dcec849-9ee9-41a9-b220-b1923e93cdb1
> version:        1
> block_size:        1
> data_offset:        16
> root@pve-21:~#
> root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=3.04 ms (warmup)
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=1.98 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=1.88 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=1.95 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=1.78 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=1.92 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=1.87 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=1.87 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=1.87 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=1.83 ms
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 17.0 ms, 4.50 KiB written, 530 iops, 265.2 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 1.78 ms / 1.89 ms / 1.98 ms / 57.4 us
> root@pve-21:~#
> root@pve-21:~# ioping -c10 /dev/bcache0 -D -WWW -s512
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=1.12 ms (warmup)
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=1.01 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=1.00 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=1.05 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=1.04 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=1.04 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=996.5 us (fast)
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=1.01 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=994.3 us (fast)
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=976.5 us (fast)
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 9.11 ms, 4.50 KiB written, 987 iops, 493.9 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 976.5 us / 1.01 ms / 1.05 ms / 22.5 us
> root@pve-21:~#
> root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=1.43 ms (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=1.39 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=1.38 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=1.40 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=1.40 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=1.43 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=1.39 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=1.42 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=1.41 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=1.40 ms
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 12.6 ms, 36 KiB written, 713 iops, 2.79 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 1.38 ms / 1.40 ms / 1.43 ms / 13.1 us
> root@pve-21:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=676.0 us (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=638.0 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=659.5 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=650.2 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=644.0 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=644.4 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=652.1 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=641.8 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=658.0 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=642.7 us
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 5.83 ms, 36 KiB written, 1.54 k iops, 6.03 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 638.0 us / 647.9 us / 659.5 us / 7.06 us
> root@pve-21:~#
> 
> =========
> Now, bcache -w 4k
> 
> root@pve-21:~# blkdiscard /dev/nvme0n1
> root@pve-21:~# make-bcache -w 4096 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback
> UUID:            c955591f-21af-467d-b26a-5ff567af2001
> Set UUID:        8c477796-88ab-4b20-990a-cef8b2df040a
> version:        0
> nbuckets:        1831430
> block_size:        8
> bucket_size:        1024
> nr_in_set:        1
> nr_this_dev:        0
> first_bucket:        1
> UUID:            ea89b843-a019-4464-8da5-377ba44f0e6b
> Set UUID:        8c477796-88ab-4b20-990a-cef8b2df040a
> version:        1
> block_size:        8
> data_offset:        16
> root@pve-21:
> root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
> ioping: request failed: Invalid argument
> root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=2.93 ms (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=313.2 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=274.1 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=296.4 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=247.2 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=227.4 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=224.6 us (fast)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=253.8 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=235.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=197.6 us (fast)
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 2.27 ms, 36 KiB written, 3.96 k iops, 15.5 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 197.6 us / 252.2 us / 313.2 us / 34.7 us
> root@pve-21:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=262.8 us (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=255.9 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=239.9 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=228.8 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=252.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=237.1 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=237.5 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=232.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=243.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=232.7 us
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 2.16 ms, 36 KiB written, 4.17 k iops, 16.3 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 228.8 us / 240.0 us / 255.9 us / 8.62 us
> 
> 
> =========
> On the first server
> 
> root@pve-20:~# modprobe brd rd_size=$((128*1024))
> root@pve-20:~# cat << EOT | dmsetup create zero
> >     0 262144 linear /dev/ram0 0
> >     262144 2147483648 zero
> > EOT
> root@pve-20:~# blkdiscard /dev/nvme0n1
> root@pve-20:~# make-bcache -w 512 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback
> UUID:            f82f76a1-8f41-4a0a-9213-f4632fa372a4
> Set UUID:        d6ba5557-3055-4151-bd91-05db6a668ba7
> version:        0
> nbuckets:        1831430
> block_size:        1
> bucket_size:        1024
> nr_in_set:        1
> nr_this_dev:        0
> first_bucket:        1
> UUID:            5c3d1795-c484-4611-881f-bc991642aa76
> Set UUID:        d6ba5557-3055-4151-bd91-05db6a668ba7
> version:        1
> block_size:        1
> data_offset:        16
> root@pve-20:~# ls /sys/fs/bcache/
> d6ba5557-3055-4151-bd91-05db6a668ba7/ register
> pendings_cleanup                      register_quiet
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=3.05 ms (warmup)
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=1.98 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=1.99 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=1.94 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=1.88 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=1.77 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=1.82 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=1.86 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=1.99 ms (slow)
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=1.82 ms
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 17.1 ms, 4.50 KiB written, 527 iops, 263.9 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 1.77 ms / 1.89 ms / 1.99 ms / 76.6 us
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s512
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=1.05 ms (warmup)
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=1.07 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=1.04 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=1.01 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=1.11 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=1.06 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=1.03 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=1.06 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=1.04 ms
> 512 B >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=1.06 ms
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 9.49 ms, 4.50 KiB written, 948 iops, 474.1 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 1.01 ms / 1.05 ms / 1.11 ms / 26.3 us
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=1.47 ms (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=1.57 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=1.57 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=1.52 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=1.11 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=1.02 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=1.03 ms (fast)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=1.04 ms (fast)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=1.45 ms
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=1.45 ms
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 11.8 ms, 36 KiB written, 765 iops, 2.99 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 1.02 ms / 1.31 ms / 1.57 ms / 232.7 us
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=249.7 us (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=671.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=663.0 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=655.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=664.0 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=693.7 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=610.5 us (fast)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=217.8 us (fast)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=223.0 us (fast)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=219.7 us (fast)
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 4.62 ms, 36 KiB written, 1.95 k iops, 7.61 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 217.8 us / 513.1 us / 693.7 us / 208.2 us
> root@pve-20:~#
> 
> root@pve-20:~# blkdiscard /dev/nvme0n1
> root@pve-20:~# make-bcache -w 4096 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback
> UUID:            c0252cdb-6a3b-43c1-8c86-3f679dd61d06
> Set UUID:        e56ca07c-4b1a-4bea-8bd4-2cabb60cb4f0
> version:        0
> nbuckets:        1831430
> block_size:        8
> bucket_size:        1024
> nr_in_set:        1
> nr_this_dev:        0
> first_bucket:        1
> UUID:            2c501dde-dd04-4294-9e35-8f3b57fdd75d
> Set UUID:        e56ca07c-4b1a-4bea-8bd4-2cabb60cb4f0
> version:        1
> block_size:        8
> data_offset:        16
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
> ioping: request failed: Invalid argument
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s512
> ioping: request failed: Invalid argument
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=2.91 ms (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=227.9 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=353.8 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=193.2 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=189.0 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=340.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=259.8 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=254.9 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=285.3 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=282.7 us
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 2.39 ms, 36 KiB written, 3.77 k iops, 14.7 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 189.0 us / 265.2 us / 353.8 us / 54.5 us
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=1 time=276.3 us (warmup)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=2 time=224.6 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3 time=226.8 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=4 time=240.1 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=5 time=237.4 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=6 time=231.6 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=7 time=238.1 us
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=8 time=199.1 us (fast)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=9 time=240.4 us (slow)
> 4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=10 time=280.5 us (slow)
> 
> --- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 2.12 ms, 36 KiB written, 4.25 k iops, 16.6 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 199.1 us / 235.4 us / 280.5 us / 20.0 us
> root@pve-20:~#
> 
> 
> In addition to the request, I decided to add these results to help:
> 
> root@pve-20:~# ioping -c5 /dev/mapper/zero -D -Y -WWW -s512
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=14.4 us (warmup)
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=19.9 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=23.4 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=17.5 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=19.4 us
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 4 requests completed in 80.2 us, 2 KiB written, 49.9 k iops, 24.4 MiB/s
> generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s
> 
> min/avg/max/mdev = 17.5 us / 20.0 us / 23.4 us / 2.12 us
> 
> root@pve-20:~# ioping -c5 /dev/mapper/zero -D -WWW -s512
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=14.4 us (warmup)
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=13.0 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=18.8 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=17.4 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=18.8 us
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 4 requests completed in 67.9 us, 2 KiB written, 58.9 k iops, 28.8 MiB/s
> generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s
> min/avg/max/mdev = 13.0 us / 17.0 us / 18.8 us / 2.38 us
> root@pve-20:~# ioping -c5 /dev/mapper/zero -D -Y -WWW -s4K
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=24.6 us (warmup)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=27.2 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=21.1 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=17.0 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=22.8 us
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 4 requests completed in 88.0 us, 16 KiB written, 45.4 k iops, 177.5 MiB/s
> generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
> min/avg/max/mdev = 17.0 us / 22.0 us / 27.2 us / 3.65 us
> root@pve-20:~# ioping -c5 /dev/mapper/zero -D -WWW -s4K
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=22.9 us (warmup)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=15.7 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=21.5 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=21.1 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=24.3 us
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 4 requests completed in 82.6 us, 16 KiB written, 48.4 k iops, 189.2 MiB/s
> generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
> min/avg/max/mdev = 15.7 us / 20.6 us / 24.3 us / 3.09 us
> root@pve-20:~#
> 
> root@pve-20:~# blkdiscard /dev/nvme0n1
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=82.7 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=78.6 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=63.2 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=72.4 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=75.4 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=82.4 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=71.9 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=84.8 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=95.6 us (slow)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=84.9 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 709.1 us, 36 KiB written, 12.7 k iops, 49.6 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 63.2 us / 78.8 us / 95.6 us / 8.89 us
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=68.3 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=70.3 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=81.4 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=81.9 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=83.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=91.7 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=71.1 us (fast)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=87.9 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=81.2 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=60.4 us (fast)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 708.9 us, 36 KiB written, 12.7 k iops, 49.6 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 60.4 us / 78.8 us / 91.7 us / 9.18 us
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=59.2 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=63.6 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=64.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=63.4 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=516.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=502.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=510.5 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=502.9 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=496.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=505.5 us (slow)
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 3.23 ms, 4.50 KiB written, 2.79 k iops, 1.36 MiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 63.4 us / 358.4 us / 516.1 us / 208.2 us
> root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=491.5 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=496.1 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=506.9 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=510.7 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=503.2 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=6 time=501.4 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=7 time=498.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=8 time=510.4 us (slow)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=9 time=502.4 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=10 time=501.3 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 9 requests completed in 4.53 ms, 4.50 KiB written, 1.99 k iops, 993.1 KiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 496.1 us / 503.5 us / 510.7 us / 4.70 us
> root@pve-20:~#
> 
> 
> root@pve-21:~# ioping -c10 /dev/mapper/zero -D -Y -WWW -s512
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=13.4 us (warmup)
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=22.6 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=15.3 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=26.1 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=15.2 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=6 time=20.8 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=7 time=24.9 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=8 time=15.2 us (fast)
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=9 time=15.2 us (fast)
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=10 time=15.7 us (fast)
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 171.0 us, 4.50 KiB written, 52.6 k iops, 25.7 MiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 15.2 us / 19.0 us / 26.1 us / 4.34 us
> root@pve-21:~# ioping -c10 /dev/mapper/zero -D -WWW -s512
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=14.3 us (warmup)
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=22.4 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=25.9 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=14.8 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=24.8 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=6 time=24.6 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=7 time=13.7 us (fast)
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=8 time=18.2 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=9 time=15.4 us
> 512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=10 time=15.2 us
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 174.9 us, 4.50 KiB written, 51.5 k iops, 25.1 MiB/s
> generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
> min/avg/max/mdev = 13.7 us / 19.4 us / 25.9 us / 4.67 us
> root@pve-21:~# ioping -c10 /dev/mapper/zero -D -Y -WWW -s4K
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=22.3 us (warmup)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=17.3 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=26.0 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=27.0 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=15.7 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=6 time=18.1 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=7 time=17.8 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=8 time=16.9 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=9 time=15.4 us (fast)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=10 time=15.5 us (fast)
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 169.7 us, 36 KiB written, 53.0 k iops, 207.2 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 15.4 us / 18.9 us / 27.0 us / 4.21 us
> root@pve-21:~# ioping -c10 /dev/mapper/zero -D -WWW -s4K
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=1 time=22.4 us (warmup)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=2 time=15.3 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3 time=26.1 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=4 time=15.0 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=5 time=15.0 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=6 time=17.8 us
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=7 time=15.3 us (fast)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=8 time=15.3 us (fast)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=9 time=15.0 us (fast)
> 4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=10 time=14.9 us (fast)
> 
> --- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
> 9 requests completed in 149.6 us, 36 KiB written, 60.2 k iops, 235.0 MiB/s
> generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
> min/avg/max/mdev = 14.9 us / 16.6 us / 26.1 us / 3.47 us
> root@pve-21:~#
> root@pve-21:~# blkdiscard /dev/nvme0n1
> root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -Y -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=461.1 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=476.4 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=479.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=480.2 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=480.9 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 4 requests completed in 1.92 ms, 2 KiB written, 2.09 k iops, 1.02 MiB/s
> generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s
> min/avg/max/mdev = 476.4 us / 479.2 us / 480.9 us / 1.73 us
> root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -WWW -s512
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=456.1 us (warmup)
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=423.0 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=424.8 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=433.3 us
> 512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=446.3 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 4 requests completed in 1.73 ms, 2 KiB written, 2.31 k iops, 1.13 MiB/s
> generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s
> min/avg/max/mdev = 423.0 us / 431.9 us / 446.3 us / 9.23 us
> root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -Y -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=88.9 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=79.8 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=70.9 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=94.3 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=72.8 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 4 requests completed in 317.7 us, 16 KiB written, 12.6 k iops, 49.2 MiB/s
> generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
> min/avg/max/mdev = 70.9 us / 79.4 us / 94.3 us / 9.20 us
> root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -WWW -s4K
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=1 time=86.4 us (warmup)
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=2 time=119.0 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3 time=66.1 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=4 time=72.4 us
> 4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=5 time=73.1 us
> 
> --- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
> 4 requests completed in 330.6 us, 16 KiB written, 12.1 k iops, 47.3 MiB/s
> generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
> min/avg/max/mdev = 66.1 us / 82.7 us / 119.0 us / 21.2 us
> root@pve-21:~#
> 
> Em quinta-feira, 26 de maio de 2022 17:28:36 BRT, Eric Wheeler <bcache@lists.ewheeler.net> escreveu: 
> 
> 
> 
> 
> 
> On Thu, 26 May 2022, Adriano Silva wrote:
> > This is a enterprise NVMe device with Power Loss Protection system. It 
> > has a non-volatile cache.
> > 
> > Before purchasing these enterprise devices, I did tests with consumer 
> > NVMe. Consumer device performance is acceptable only on hardware cached 
> > writes. But on the contrary on consumer devices in tests with fio 
> > passing parameters for direct and synchronous writing (--direct=1 
> > --fsync=1 --rw=randwrite --bs=4K --numjobs=1 --iodepth= 1) the 
> > performance is very low. So today I'm using enterprise NVME with 
> > tantalum capacitors which makes the cache non-volatile and performs much 
> > better when written directly to the hardware. But the performance issue 
> > is only occurring when the write is directed to the bcache device.
> > 
> > Here is information from my Hardware you asked for (Eric), plus some 
> > additional information to try to help.
> > 
> > root@pve-20:/# blockdev --getss /dev/nvme0n1
> > 512
> > root@pve-20:/# blockdev --report /dev/nvme0n1
> > RO    RA   SSZ   BSZ   StartSec            Size   Device
> > rw   256   512  4096          0    960197124096   /dev/nvme0n1
> 
> > root@pve-20:~# nvme id-ctrl -H /dev/nvme0n1 |grep -A1 vwc
> > vwc       : 0
> >   [0:0] : 0    Volatile Write Cache Not Present
> 
> Please confirm that this says "write back":
> 
> ]# cat /sys/block/nvme0n1/queue/write_cache 
> 
> Try this to set _all_ blockdevs to write-back and see if it affects
> performance (warning: power loss is unsafe for non-volatile caches after 
> this command):
> 
> ]# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
> 
> > An interesting thing to note is that when I test using fio with 
> > --bs=512, the direct hardware performance is horrible (~1MB/s).
> 
> I think you know this already, but for CYA:
> 
>   WARNING: THESE ARE DESTRUCTIVE WRITES, DO NOT USE ON PRODUCTION DATA!
> 
> Please post `ioping` stats for each server you are testing (some of these 
> you may have already posted, but if you can place them inline of this same 
> response it would be helpful so we don't need to dig into old emails).
> 
> ]# blkdiscard /dev/nvme0n1
> 
> ]# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
> ]# ioping -c10 /dev/nvme0n1 -D -WWW -s512
> 
> ]# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4k
> ]# ioping -c10 /dev/nvme0n1 -D -WWW -s4k
> 
> Next, lets rule out backing-device interference by creating a dummy
> mapper device that has 128mb of ramdisk for persistent meta storage
> (superblock, LVM, etc) but presents as a 1TB volume in size; writes
> beyond 128mb are dropped:
> 
>     modprobe brd rd_size=$((128*1024))
> 
>     ]# cat << EOT | dmsetup create zero
>     0 262144 linear /dev/ram0 0
>     262144 2147483648 zero
>     EOT
> 
> Then use that as your backing device:
> 
>     ]# blkdiscard /dev/nvme0n1
>     ]# make-bcache -w 512 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback
> 
> ]# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
> ]# ioping -c10 /dev/bcache0 -D -WWW -s512
> 
> ]# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> ]# ioping -c10 /dev/bcache0 -D -WWW -s4k
> 
> Test again with -w 4096:
>     ]# blkdiscard /dev/nvme0n1
>     ]# make-bcache -w 4096 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback
> 
> ]# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> ]# ioping -c10 /dev/bcache0 -D -WWW -s4k
> 
> # These should error with -w 4096 because 512 is too small:
> 
> ]# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
> ]# ioping -c10 /dev/bcache0 -D -WWW -s512
> 
> > root@pve-20:/# fio --filename=/dev/nvme0n1p2 --direct=1 --fsync=1 --rw=randwrite --bs=512 --numjobs=1 --iodepth=1 --runtime=5 --time_based --group_reporting --name=journal-test --ioengine=libaio
> >   write: IOPS=2087, BW=1044KiB/s (1069kB/s)(5220KiB/5001msec); 0 zone resets
> >          ^^^^^^^^^ 
> > But the same test directly on the hardware with fio passing the
> > parameter --bs=4K, the performance completely changes, for the better
> > (~130MB/s).
> >
> > root@pve-20:/# fio --filename=/dev/nvme0n1p2 --direct=1 --fsync=1 --rw=randwrite --bs=4K --numjobs=1 --iodepth=1 --runtime=5 --time_based --group_reporting --name=journal-test --ioengine=libaio
> >   write: IOPS=31.9k, BW=124MiB/s (131MB/s)(623MiB/5001msec); 0 zone resets
> >          ^^^^^^^^^^
> > Does anything justify this difference?
> 
> I think you may have discovered the problem and the `ioping`s above
> might confirm that.
> 
> IOPS are a better metric here, not MB/sec because smaller IOs will
> always be smaller bandwidth because they are smaller and RTT is a
> factor.  However, IOPS are ~16x lower than the expected 8x difference
> (512/4096=1/8) so something else is going on. 
> 
> The hardware is probably addressed 4k internally "4Kn" (with even larger 
> erase pages that the FTL manages).  Sending it a bunch of 512-byte IOs may 
> trigger a read-modify-write operation on the flash controller and is 
> (probably) spinning CPU cycles on the flash controller itself. A firmware 
> upgrade on the NVMe might help if they have addressed this.
> 
> This is speculaution, but assuming that internally the flash uses 4k 
> sectors, it is doing something like this (pseudo code):
> 
>     1. new_data = fetch_from_pcie()
>     2. rmw = read_sector(LBA)
>     3. memcpy(rmw+offset, new_data, 512)
>     4. queue_write_to_flash(rmw, LBA)
> 
> > Maybe that's why when I create bcache with the -w=4K option the 
> > performance improves. Not as much as I'd like, but it gets better.
> > [...] 
> > The buckets, I read that it would be better to put the hardware device 
> > erase block size. However, I have already tried to find this information 
> > by reading the device, also with the manufacturer, but without success. 
> > So I have no idea which bucket size would be best, but from my tests, 
> > the default of 512KB seems to be adequate.
> 
> It might be worth testing power-of-2 bucket sizes to see what works best
> for your workload.  Note that `fio --rw=randwrite` may not be
> representative of your "real" workload so randwrite could be a good
> place to start, but bench your real workload against bucket sizes to see
> what works best.
> 
> > Eric, perhaps it is not such a simple task to recompile the Kernel with 
> > the suggested change. I'm working with Proxmox 6.4. I'm not sure, but I 
> > think the Kernel may have some adaptation. It is based on Kernel 5.4, 
> > which it is approved for.
> 
> Keith and Christoph corrected me; as noted above, this does the same 
> thing, so no need to hack on the kernel to change flush behavior:
> 
>     echo 'write back' > /sys/block/<DEV>/queue/write_cache
> 
> > Also listening to Coly's suggestion, I'll try to perform tests with the 
> > Kernel version 5.15 to see if it can solve. Would this version be good 
> > enough? It's just that, as I said above, as I'm using Proxmox, I'm 
> > afraid to change the Kernel version they provide.
> 
> I'm guessing proxmox doesn't care too much about the kernel version as
> long as the modules you use are built.  Just copy your existing .config
> (usually /boot/config-<version>) as
> kernel-source-dir/.config and run `make oldconfig` (or `make menuconfig`
> and save+exit, which is what I usually do).
> 
> > Eric, to be clear, the hardware I'm using has only 1 processor socket.
> 
> Ok, so not a cacheline bounce issue.
> 
> > I'm trying to test with another identical computer (the same 
> > motherboard, the same processor, the same NVMe, with the difference that 
> > it only has 12GB of RAM, the first having 48GB). It is an HP Z400 
> > Workstation with an Intel Xeon X5680 sixcore processor (12 threads), 
> > DDR3 1333MHz 10600E (old computer).
> 
> Is this second server still a single-socket?
> 
> > On the second computer, I put a newer version of the distribution that 
> > uses Kernel based on version 5.15. I am now comparing the performance of 
> > the two computers in the lab.
> > 
> > On this second computer I had worse performance than the first one 
> > (practically half the performance with bcache), despite the performance 
> > of the tests done directly in NVME being identical.
> > 
> > I tried going back to the same OS version on the first computer to try 
> > and keep the exact same scenario on both computers so I could first 
> > compare the two. I try to keep the exact same software configuration. 
> > However, there were no changes. Is it the low RAM that makes the 
> > performance worse in the second?
> 
> The amount of memory isn't an issue, but CPU clock speed or memory speed 
> might.  If server-2 has 2x sockets then make sure NVMe interrupts hit the 
> socket where it is attached.  Could be a PCIe version thing, but I 
> don't think you are saturating the PCIe link.
> 
> > I noticed a difference in behavior on the second computer compared to 
> > the first in dstat. While the first computer doesn't seem to touch the 
> > backup device at all, the second computer signals something a little 
> > different, as although it doesn't write data to the backup disk, it does 
> > signal IO movement. Strange no?
> > 
> > Let's look at the dstat of the first computer:
> > 
> > --dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- async
> >  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ| recv  send| 1m   5m  15m |usr sys idl wai stl| int   csw |     time     | #aio
> >    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |6953B 7515B|0.13 0.26 0.26|  0   0  99   0   0| 399   634 |25-05 09:41:42|   0
> >    0  8192B:4096B 2328k:   0  1168k|   0  2.00 :1.00   586 :   0   587 |9150B 2724B|0.13 0.26 0.26|  2   2  96   0   0|1093  3267 |25-05 09:41:43|   1B
> >    0     0 :   0    58M:   0    29M|   0     0 :   0  14.8k:   0  14.7k|  14k 9282B|0.13 0.26 0.26|  1   3  94   2   0|  16k   67k|25-05 09:41:44|   1B
> >    0     0 :   0    58M:   0    29M|   0     0 :   0  14.9k:   0  14.8k|  10k 8992B|0.13 0.26 0.26|  1   3  93   2   0|  16k   69k|25-05 09:41:45|   1B
> >    0     0 :   0    58M:   0    29M|   0     0 :   0  14.9k:   0  14.8k|7281B 4651B|0.13 0.26 0.26|  1   3  92   4   0|  16k   67k|25-05 09:41:46|   1B
> >    0     0 :   0    59M:   0    30M|   0     0 :   0  15.2k:   0  15.1k|7849B 4729B|0.20 0.28 0.27|  1   4  94   2   0|  16k   69k|25-05 09:41:47|   1B
> >    0     0 :   0    57M:   0    28M|   0     0 :   0  14.4k:   0  14.4k|  11k 8584B|0.20 0.28 0.27|  1   3  94   2   0|  15k   65k|25-05 09:41:48|   0
> >    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |4086B 7720B|0.20 0.28 0.27|  0   0 100   0   0| 274   332 |25-05 09:41:49|   0
> > 
> > Note that on this first computer, the writings and IOs of the backing 
> > device (sdb) remain motionless. While NVMe device IOs track bcache0 
> > device IOs at ~14.8K
> > 
> > Let's see the dstat now on the second computer:
> > 
> > --dsk/sdd---dsk/nvme0n1-dsk/bcache0 ---io/sdd----io/nvme0n1--io/bcache0 -net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- async
> >  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ| recv  send| 1m   5m  15m |usr sys idl wai stl| int   csw |     time     | #aio
> >    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |9254B 3301B|0.15 0.19 0.11|  1   2  97   0   0| 360   318 |26-05 06:27:15|   0
> >    0  8192B:4096B   19M:   0  9600k|   0  2402 :1.00  4816 :   0  4801 |8826B 3619B|0.15 0.19 0.11|  0   1  98   0   0|8115    27k|26-05 06:27:16|   1B
> >    0     0 :   0    21M:   0    11M|   0  2737 :   0  5492 :   0  5474 |4051B 2552B|0.15 0.19 0.11|  0   2  97   1   0|9212    31k|26-05 06:27:17|   1B
> >    0     0 :   0    23M:   0    11M|   0  2890 :   0  5801 :   0  5781 |4816B 2492B|0.15 0.19 0.11|  1   2  96   2   0|9976    34k|26-05 06:27:18|   1B
> >    0     0 :   0    23M:   0    11M|   0  2935 :   0  5888 :   0  5870 |4450B 2552B|0.22 0.21 0.12|  0   2  96   2   0|9937    33k|26-05 06:27:19|   1B
> >    0     0 :   0    22M:   0    11M|   0  2777 :   0  5575 :   0  5553 |8644B 1614B|0.22 0.21 0.12|  0   2  98   0   0|9416    31k|26-05 06:27:20|   1B
> >    0     0 :   0  2096k:   0  1040k|   0   260 :   0   523 :   0   519 |  10k 8760B|0.22 0.21 0.12|  0   1  99   0   0|1246  3157 |26-05 06:27:21|   0
> >    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |4083B 2990B|0.22 0.21 0.12|  0   0 100   0   0| 390   369 |26-05 06:27:22|   0
> 
> > In this case, with exactly the same command, we got a very different 
> > result. While writes to the backing device (sdd) do not happen (this is 
> > correct), we noticed that IOs occur on both the NVMe device and the 
> > backing device (i think this is wrong), but at a much lower rate now, 
> > around 5.6K on NVMe and 2.8K on the backing device. It leaves the 
> > impression that although it is not writing anything to sdd device, it is 
> > sending some signal to the backing device in each two IO operations that 
> > is performed with the cache device. And that would be delaying the 
> > answer. Could it be something like this?
> 
> I think in newer kernels that bcache is more aggressive at writeback. 
> Using /dev/mapper/zero as above will help rule out backing device 
> interference.  Also make sure you have the sysfs flags turned to encourge 
> it to write to SSD and not bypass:
> 
>     echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
>     echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us 
>     echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
> 
> > It is important to point out that the writeback mode is on, obviously, 
> > and that the sequential cutoff is at zero, but I tried to put default 
> > values or high values and there were no changes. I also tried changing 
> > congested_write_threshold_us and congested_read_threshold_us, also with 
> > no result changes.
> 
> Try this too: 
>     echo 300 > /sys/block/bcache0/bcache/writeback_delay
> 
> and make sure bcache is in writeback (echo writeback > 
> /sys/block/bcache0/bcache0/cache_mode) in case that was not configured on 
> server2.
> 
> 
> -Eric
> 
> > The only thing I noticed different between the configurations of the two 
> > computers was btree_cache_size, which on the first is much larger (7.7M) 
> > m while on the second it is only 768K. But I don't know if this 
> > parameter is configurable and if it could justify the difference.
> > 
> > Disabling Intel's Turbo Boost technology through the BIOS appears to 
> > have no effect.
> > 
> > And we will continue our tests comparing the two computers, including to 
> > test the two versions of the Kernel. If anyone else has ideas, thanks!
> 
> 
> > 
> > Em terça-feira, 17 de maio de 2022 22:23:09 BRT, Eric Wheeler <bcache@lists.ewheeler.net> escreveu: 
> > 
> > 
> > 
> > 
> > 
> > On Tue, 10 May 2022, Adriano Silva wrote:
> > > I'm trying to set up a flash disk NVMe as a disk cache for two or three 
> > > isolated (I will use 2TB disks, but in these tests I used a 1TB one) 
> > > spinning disks that I have on a Linux 5.4.174 (Proxmox node).
> > 
> > Coly has been adding quite a few optimizations over the years.  You might 
> > try a new kernel and see if that helps.  More below.
> > 
> > > I'm using a NVMe (960GB datacenter devices with tantalum capacitors) as 
> > > a cache.
> > > [...]
> > >
> > > But when I do the same test on bcache writeback, the performance drops a 
> > > lot. Of course, it's better than the performance of spinning disks, but 
> > > much worse than when accessed directly from the NVMe device hardware.
> > >
> > > [...]
> > > As we can see, the same test done on the bcache0 device only got 1548 
> > > IOPS and that yielded only 6.3 KB/s.
> > 
> > Well done on the benchmarking!  I always thought our new NVMes performed 
> > slower than expected but hadn't gotten around to investigating. 
> > 
> > > I've noticed in several tests, varying the amount of jobs or increasing 
> > > the size of the blocks, that the larger the size of the blocks, the more 
> > > I approximate the performance of the physical device to the bcache 
> > > device.
> > 
> > You said "blocks" but did you mean bucket size (make-bcache -b) or block 
> > size (make-bcache -w) ?
> > 
> > If larger buckets makes it slower than that actually surprises me: bigger 
> > buckets means less metadata and better sequential writeback to the 
> > spinning disks (though you hadn't yet hit writeback to spinning disks in 
> > your stats).  Maybe you already tried, but varying the bucket size might 
> > help.  Try graphing bucket size (powers of 2) against IOPS, maybe there is 
> > a "sweet spot"?
> > 
> > Be aware that 4k blocks (so-called "4Kn") is unsafe for the cache device, 
> > unless Coly has patched that.  Make sure your `blockdev --getss` reports 
> > 512 for your NVMe!
> > 
> > Hi Coly,
> > 
> > Some time ago you ordered an an SSD to test the 4k cache issue, has that 
> > been fixed?  I've kept an eye out for the patch but not sure if it was released.
> > 
> > You have a really great test rig setup with NVMes for stress
> > testing bcache. Can you replicate Adriano's `ioping` numbers below?
> > 
> > > With ioping it is also possible to notice a limitation, as the latency 
> > > of the bcache0 device is around 1.5ms, while in the case of the raw 
> > > device (a partition of NVMe), the same test is only 82.1us.
> > > 
> > > root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> > > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=1 time=1.52 ms (warmup)
> > > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=2 time=1.60 ms
> > > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3 time=1.55 ms
> > >
> > > root@pve-20:~# ioping -c10 /dev/nvme0n1p2 -D -Y -WWW -s4k
> > > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=1 time=81.2 us (warmup)
> > > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=2 time=82.7 us
> > > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3 time=82.4 us
> > 
> > Wow, almost 20x higher latency, sounds convincing that something is wrong.
> > 
> > A few things to try:
> > 
> > 1. Try ioping without -Y.  How does it compare?
> > 
> > 2. Maybe this is an inter-socket latency issue.  Is your server 
> >   multi-socket?  If so, then as a first pass you could set the kernel 
> >   cmdline `isolcpus` for testing to limit all processes to a single 
> >   socket where the NVMe is connected (see `lscpu`).  Check `hwloc-ls`
> >   or your motherboard manual to see how the NVMe port is wired to your
> >   CPUs.
> > 
> >   If that helps then fine tune with `numactl -cN ioping` and 
> >   /proc/irq/<n>/smp_affinity_list (and `grep nvme /proc/interrupts`) to 
> >   make sure your NVMe's are locked to IRQs on the same socket.
> > 
> > 3a. sysfs:
> > 
> > > # echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> > 
> > good.
> > 
> > > # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
> > > # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us
> > 
> > Also try these (I think bcache/cache is a symlink to /sys/fs/bcache/<cache set>)
> > 
> > echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us 
> > echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
> > 
> > 
> > Try tuning journal_delay_ms: 
> >   /sys/fs/bcache/<cset-uuid>/journal_delay_ms
> >     Journal writes will delay for up to this many milliseconds, unless a 
> >     cache flush happens sooner. Defaults to 100.
> > 
> > 3b: Hacking bcache code:
> > 
> > I just noticed that journal_delay_ms says "unless a cache flush happens 
> > sooner" but cache flushes can be re-ordered so flushing the journal when 
> > REQ_OP_FLUSH comes through may not be useful, especially if there is a 
> > high volume of flushes coming down the pipe because the flushes could kill 
> > the NVMe's cache---and maybe the 1.5ms ping is actual flash latency.  It
> > would flush data and journal.
> > 
> > Maybe there should be a cachedev_noflush sysfs option for those with some 
> > kind of power-loss protection of there SSD's.  It looks like this is 
> > handled in request.c when these functions call bch_journal_meta():
> > 
> >     1053: static void cached_dev_nodata(struct closure *cl)
> >     1263: static void flash_dev_nodata(struct closure *cl)
> > 
> > Coly can you comment about journal flush semantics with respect to 
> > performance vs correctness and crash safety?
> > 
> > Adriano, as a test, you could change this line in search_alloc() in 
> > request.c:
> > 
> >     - s->iop.flush_journal    = op_is_flush(bio->bi_opf);
> >     + s->iop.flush_journal    = 0;
> > 
> > and see how performance changes.
> > 
> > Someone correct me if I'm wrong, but I don't think flush_journal=0 will 
> > affect correctness unless there is a crash.  If that /is/ the performance 
> > problem then it would narrow the scope of this discussion.
> > 
> > 4. I wonder if your 1.5ms `ioping` stats scale with CPU clock speed: can 
> >   you set your CPU governor to run at full clock speed and then slowest 
> >   clock speed to see if it is a CPU limit somewhere as we expect?
> > 
> >   You can do `grep MHz /proc/cpuinfo` to see the active rate to make sure 
> >   the governor did its job.  
> > 
> >   If it scales with CPU then something in bcache is working too hard.  
> >   Maybe garbage collection?  Other devs would need to chime in here to 
> >   steer the troubleshooting if that is the case.
> > 
> > 
> > 5. I'm not sure if garbage collection is the issue, but you might try 
> >   Mingzhe's dynamic incremental gc patch:
> >     https://www.spinics.net/lists/linux-bcache/msg11185.html
> > 
> > 6. Try dm-cache and see if its IO latency is similar to bcache: If it is 
> >   about the same then that would indicate an issue in the block layer 
> >   somewhere outside of bcache.  If dm-cache is better, then that confirms 
> >   a bcache issue.
> > 
> > 
> > > The cache was configured directly on one of the NVMe partitions (in this 
> > > case, the first partition). I did several tests using fio and ioping, 
> > > testing on a partition on the NVMe device, without partition and 
> > > directly on the raw block, on a first partition, on the second, with or 
> > > without configuring bcache. I did all this to remove any doubt as to the 
> > > method. The results of tests performed directly on the hardware device, 
> > > without going through bcache are always fast and similar.
> > > 
> > > But tests in bcache are always slower. If you use writethrough, of 
> > > course, it gets much worse, because the performance is equal to the raw 
> > > spinning disk.
> > > 
> > > Using writeback improves a lot, but still doesn't use the full speed of 
> > > NVMe (honestly, much less than full speed).
> > 
> > Indeed, I hope this can be fixed!  A 20x improvement in bcache would 
> > be awesome.
> > 
> > > But I've also noticed that there is a limit on writing sequential data, 
> > > which is a little more than half of the maximum write rate shown in 
> > > direct tests by the NVMe device.
> > 
> > For sync, async, or both?
> > 
> > 
> > > Processing doesn't seem to be going up like the tests.
> > 
> > 
> > What do you mean "processing" ?
> > 
> > -Eric
> > 
> > 
> > 
> 
> 
--8323328-1285737907-1653701273=:2952--

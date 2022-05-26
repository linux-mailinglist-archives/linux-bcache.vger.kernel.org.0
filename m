Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C9C535467
	for <lists+linux-bcache@lfdr.de>; Thu, 26 May 2022 22:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiEZU2k (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 May 2022 16:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiEZU2i (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 May 2022 16:28:38 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC460CE09
        for <linux-bcache@vger.kernel.org>; Thu, 26 May 2022 13:28:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 5550C4A;
        Thu, 26 May 2022 13:28:35 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 9z3BfRD6i9rA; Thu, 26 May 2022 13:28:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id B5FFD39;
        Thu, 26 May 2022 13:28:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net B5FFD39
Date:   Thu, 26 May 2022 13:28:28 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
cc:     Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
In-Reply-To: <681726005.1812841.1653564986700@mail.yahoo.com>
Message-ID: <8aac4160-4da5-453b-48ba-95e79fb8c029@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <681726005.1812841.1653564986700@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1607642748-1653596082=:20764"
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

--8323328-1607642748-1653596082=:20764
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 26 May 2022, Adriano Silva wrote:
> This is a enterprise NVMe device with Power Loss Protection system. It 
> has a non-volatile cache.
> 
> Before purchasing these enterprise devices, I did tests with consumer 
> NVMe. Consumer device performance is acceptable only on hardware cached 
> writes. But on the contrary on consumer devices in tests with fio 
> passing parameters for direct and synchronous writing (--direct=1 
> --fsync=1 --rw=randwrite --bs=4K --numjobs=1 --iodepth= 1) the 
> performance is very low. So today I'm using enterprise NVME with 
> tantalum capacitors which makes the cache non-volatile and performs much 
> better when written directly to the hardware. But the performance issue 
> is only occurring when the write is directed to the bcache device.
> 
> Here is information from my Hardware you asked for (Eric), plus some 
> additional information to try to help.
> 
> root@pve-20:/# blockdev --getss /dev/nvme0n1
> 512
> root@pve-20:/# blockdev --report /dev/nvme0n1
> RO    RA   SSZ   BSZ   StartSec            Size   Device
> rw   256   512  4096          0    960197124096   /dev/nvme0n1

> root@pve-20:~# nvme id-ctrl -H /dev/nvme0n1 |grep -A1 vwc
> vwc       : 0
>   [0:0] : 0    Volatile Write Cache Not Present

Please confirm that this says "write back":

]# cat /sys/block/nvme0n1/queue/write_cache 

Try this to set _all_ blockdevs to write-back and see if it affects
performance (warning: power loss is unsafe for non-volatile caches after 
this command):

]# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
 
> An interesting thing to note is that when I test using fio with 
> --bs=512, the direct hardware performance is horrible (~1MB/s).

I think you know this already, but for CYA:

   WARNING: THESE ARE DESTRUCTIVE WRITES, DO NOT USE ON PRODUCTION DATA!

Please post `ioping` stats for each server you are testing (some of these 
you may have already posted, but if you can place them inline of this same 
response it would be helpful so we don't need to dig into old emails).

]# blkdiscard /dev/nvme0n1

]# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
]# ioping -c10 /dev/nvme0n1 -D -WWW -s512

]# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4k
]# ioping -c10 /dev/nvme0n1 -D -WWW -s4k

Next, lets rule out backing-device interference by creating a dummy
mapper device that has 128mb of ramdisk for persistent meta storage
(superblock, LVM, etc) but presents as a 1TB volume in size; writes
beyond 128mb are dropped:

	modprobe brd rd_size=$((128*1024))

	]# cat << EOT | dmsetup create zero
	0 262144 linear /dev/ram0 0
	262144 2147483648 zero
	EOT

Then use that as your backing device:

	]# blkdiscard /dev/nvme0n1
	]# make-bcache -w 512 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
]# ioping -c10 /dev/bcache0 -D -WWW -s512

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
]# ioping -c10 /dev/bcache0 -D -WWW -s4k

Test again with -w 4096:
	]# blkdiscard /dev/nvme0n1
	]# make-bcache -w 4096 -B /dev/mapper/zero -C /dev/nvme0n1 --writeback

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
]# ioping -c10 /dev/bcache0 -D -WWW -s4k

# These should error with -w 4096 because 512 is too small:

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
]# ioping -c10 /dev/bcache0 -D -WWW -s512

> root@pve-20:/# fio --filename=/dev/nvme0n1p2 --direct=1 --fsync=1 --rw=randwrite --bs=512 --numjobs=1 --iodepth=1 --runtime=5 --time_based --group_reporting --name=journal-test --ioengine=libaio
>   write: IOPS=2087, BW=1044KiB/s (1069kB/s)(5220KiB/5001msec); 0 zone resets
>          ^^^^^^^^^ 
> But the same test directly on the hardware with fio passing the
> parameter --bs=4K, the performance completely changes, for the better
> (~130MB/s).
>
> root@pve-20:/# fio --filename=/dev/nvme0n1p2 --direct=1 --fsync=1 --rw=randwrite --bs=4K --numjobs=1 --iodepth=1 --runtime=5 --time_based --group_reporting --name=journal-test --ioengine=libaio
>   write: IOPS=31.9k, BW=124MiB/s (131MB/s)(623MiB/5001msec); 0 zone resets
>          ^^^^^^^^^^
> Does anything justify this difference?

I think you may have discovered the problem and the `ioping`s above
might confirm that.

IOPS are a better metric here, not MB/sec because smaller IOs will
always be smaller bandwidth because they are smaller and RTT is a
factor.  However, IOPS are ~16x lower than the expected 8x difference
(512/4096=1/8) so something else is going on. 

The hardware is probably addressed 4k internally "4Kn" (with even larger 
erase pages that the FTL manages).  Sending it a bunch of 512-byte IOs may 
trigger a read-modify-write operation on the flash controller and is 
(probably) spinning CPU cycles on the flash controller itself. A firmware 
upgrade on the NVMe might help if they have addressed this.

This is speculaution, but assuming that internally the flash uses 4k 
sectors, it is doing something like this (pseudo code):

	1. new_data = fetch_from_pcie()
	2. rmw = read_sector(LBA)
	3. memcpy(rmw+offset, new_data, 512)
	4. queue_write_to_flash(rmw, LBA)

> Maybe that's why when I create bcache with the -w=4K option the 
> performance improves. Not as much as I'd like, but it gets better.
> [...] 
> The buckets, I read that it would be better to put the hardware device 
> erase block size. However, I have already tried to find this information 
> by reading the device, also with the manufacturer, but without success. 
> So I have no idea which bucket size would be best, but from my tests, 
> the default of 512KB seems to be adequate.

It might be worth testing power-of-2 bucket sizes to see what works best
for your workload.  Note that `fio --rw=randwrite` may not be
representative of your "real" workload so randwrite could be a good
place to start, but bench your real workload against bucket sizes to see
what works best.

> Eric, perhaps it is not such a simple task to recompile the Kernel with 
> the suggested change. I'm working with Proxmox 6.4. I'm not sure, but I 
> think the Kernel may have some adaptation. It is based on Kernel 5.4, 
> which it is approved for.

Keith and Christoph corrected me; as noted above, this does the same 
thing, so no need to hack on the kernel to change flush behavior:

	echo 'write back' > /sys/block/<DEV>/queue/write_cache

> Also listening to Coly's suggestion, I'll try to perform tests with the 
> Kernel version 5.15 to see if it can solve. Would this version be good 
> enough? It's just that, as I said above, as I'm using Proxmox, I'm 
> afraid to change the Kernel version they provide.

I'm guessing proxmox doesn't care too much about the kernel version as
long as the modules you use are built.  Just copy your existing .config
(usually /boot/config-<version>) as
kernel-source-dir/.config and run `make oldconfig` (or `make menuconfig`
and save+exit, which is what I usually do).

> Eric, to be clear, the hardware I'm using has only 1 processor socket.

Ok, so not a cacheline bounce issue.

> I'm trying to test with another identical computer (the same 
> motherboard, the same processor, the same NVMe, with the difference that 
> it only has 12GB of RAM, the first having 48GB). It is an HP Z400 
> Workstation with an Intel Xeon X5680 sixcore processor (12 threads), 
> DDR3 1333MHz 10600E (old computer).

Is this second server still a single-socket?

> On the second computer, I put a newer version of the distribution that 
> uses Kernel based on version 5.15. I am now comparing the performance of 
> the two computers in the lab.
> 
> On this second computer I had worse performance than the first one 
> (practically half the performance with bcache), despite the performance 
> of the tests done directly in NVME being identical.
> 
> I tried going back to the same OS version on the first computer to try 
> and keep the exact same scenario on both computers so I could first 
> compare the two. I try to keep the exact same software configuration. 
> However, there were no changes. Is it the low RAM that makes the 
> performance worse in the second?
 
The amount of memory isn't an issue, but CPU clock speed or memory speed 
might.  If server-2 has 2x sockets then make sure NVMe interrupts hit the 
socket where it is attached.  Could be a PCIe version thing, but I 
don't think you are saturating the PCIe link.

> I noticed a difference in behavior on the second computer compared to 
> the first in dstat. While the first computer doesn't seem to touch the 
> backup device at all, the second computer signals something a little 
> different, as although it doesn't write data to the backup disk, it does 
> signal IO movement. Strange no?
> 
> Let's look at the dstat of the first computer:
> 
> --dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- async
>  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ| recv  send| 1m   5m  15m |usr sys idl wai stl| int   csw |     time     | #aio
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |6953B 7515B|0.13 0.26 0.26|  0   0  99   0   0| 399   634 |25-05 09:41:42|   0
>    0  8192B:4096B 2328k:   0  1168k|   0  2.00 :1.00   586 :   0   587 |9150B 2724B|0.13 0.26 0.26|  2   2  96   0   0|1093  3267 |25-05 09:41:43|   1B
>    0     0 :   0    58M:   0    29M|   0     0 :   0  14.8k:   0  14.7k|  14k 9282B|0.13 0.26 0.26|  1   3  94   2   0|  16k   67k|25-05 09:41:44|   1B
>    0     0 :   0    58M:   0    29M|   0     0 :   0  14.9k:   0  14.8k|  10k 8992B|0.13 0.26 0.26|  1   3  93   2   0|  16k   69k|25-05 09:41:45|   1B
>    0     0 :   0    58M:   0    29M|   0     0 :   0  14.9k:   0  14.8k|7281B 4651B|0.13 0.26 0.26|  1   3  92   4   0|  16k   67k|25-05 09:41:46|   1B
>    0     0 :   0    59M:   0    30M|   0     0 :   0  15.2k:   0  15.1k|7849B 4729B|0.20 0.28 0.27|  1   4  94   2   0|  16k   69k|25-05 09:41:47|   1B
>    0     0 :   0    57M:   0    28M|   0     0 :   0  14.4k:   0  14.4k|  11k 8584B|0.20 0.28 0.27|  1   3  94   2   0|  15k   65k|25-05 09:41:48|   0
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |4086B 7720B|0.20 0.28 0.27|  0   0 100   0   0| 274   332 |25-05 09:41:49|   0
> 
> Note that on this first computer, the writings and IOs of the backing 
> device (sdb) remain motionless. While NVMe device IOs track bcache0 
> device IOs at ~14.8K
> 
> Let's see the dstat now on the second computer:
> 
> --dsk/sdd---dsk/nvme0n1-dsk/bcache0 ---io/sdd----io/nvme0n1--io/bcache0 -net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- async
>  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ| recv  send| 1m   5m  15m |usr sys idl wai stl| int   csw |     time     | #aio
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |9254B 3301B|0.15 0.19 0.11|  1   2  97   0   0| 360   318 |26-05 06:27:15|   0
>    0  8192B:4096B   19M:   0  9600k|   0  2402 :1.00  4816 :   0  4801 |8826B 3619B|0.15 0.19 0.11|  0   1  98   0   0|8115    27k|26-05 06:27:16|   1B
>    0     0 :   0    21M:   0    11M|   0  2737 :   0  5492 :   0  5474 |4051B 2552B|0.15 0.19 0.11|  0   2  97   1   0|9212    31k|26-05 06:27:17|   1B
>    0     0 :   0    23M:   0    11M|   0  2890 :   0  5801 :   0  5781 |4816B 2492B|0.15 0.19 0.11|  1   2  96   2   0|9976    34k|26-05 06:27:18|   1B
>    0     0 :   0    23M:   0    11M|   0  2935 :   0  5888 :   0  5870 |4450B 2552B|0.22 0.21 0.12|  0   2  96   2   0|9937    33k|26-05 06:27:19|   1B
>    0     0 :   0    22M:   0    11M|   0  2777 :   0  5575 :   0  5553 |8644B 1614B|0.22 0.21 0.12|  0   2  98   0   0|9416    31k|26-05 06:27:20|   1B
>    0     0 :   0  2096k:   0  1040k|   0   260 :   0   523 :   0   519 |  10k 8760B|0.22 0.21 0.12|  0   1  99   0   0|1246  3157 |26-05 06:27:21|   0
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |4083B 2990B|0.22 0.21 0.12|  0   0 100   0   0| 390   369 |26-05 06:27:22|   0
 
> In this case, with exactly the same command, we got a very different 
> result. While writes to the backing device (sdd) do not happen (this is 
> correct), we noticed that IOs occur on both the NVMe device and the 
> backing device (i think this is wrong), but at a much lower rate now, 
> around 5.6K on NVMe and 2.8K on the backing device. It leaves the 
> impression that although it is not writing anything to sdd device, it is 
> sending some signal to the backing device in each two IO operations that 
> is performed with the cache device. And that would be delaying the 
> answer. Could it be something like this?

I think in newer kernels that bcache is more aggressive at writeback. 
Using /dev/mapper/zero as above will help rule out backing device 
interference.  Also make sure you have the sysfs flags turned to encourge 
it to write to SSD and not bypass:

	echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
	echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us 
	echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us

> It is important to point out that the writeback mode is on, obviously, 
> and that the sequential cutoff is at zero, but I tried to put default 
> values or high values and there were no changes. I also tried changing 
> congested_write_threshold_us and congested_read_threshold_us, also with 
> no result changes.

Try this too: 
	echo 300 > /sys/block/bcache0/bcache/writeback_delay

and make sure bcache is in writeback (echo writeback > 
/sys/block/bcache0/bcache0/cache_mode) in case that was not configured on 
server2.

-Eric

> The only thing I noticed different between the configurations of the two 
> computers was btree_cache_size, which on the first is much larger (7.7M) 
> m while on the second it is only 768K. But I don't know if this 
> parameter is configurable and if it could justify the difference.
> 
> Disabling Intel's Turbo Boost technology through the BIOS appears to 
> have no effect.
> 
> And we will continue our tests comparing the two computers, including to 
> test the two versions of the Kernel. If anyone else has ideas, thanks!


> 
> Em terça-feira, 17 de maio de 2022 22:23:09 BRT, Eric Wheeler <bcache@lists.ewheeler.net> escreveu: 
> 
> 
> 
> 
> 
> On Tue, 10 May 2022, Adriano Silva wrote:
> > I'm trying to set up a flash disk NVMe as a disk cache for two or three 
> > isolated (I will use 2TB disks, but in these tests I used a 1TB one) 
> > spinning disks that I have on a Linux 5.4.174 (Proxmox node).
> 
> Coly has been adding quite a few optimizations over the years.  You might 
> try a new kernel and see if that helps.  More below.
> 
> > I'm using a NVMe (960GB datacenter devices with tantalum capacitors) as 
> > a cache.
> > [...]
> >
> > But when I do the same test on bcache writeback, the performance drops a 
> > lot. Of course, it's better than the performance of spinning disks, but 
> > much worse than when accessed directly from the NVMe device hardware.
> >
> > [...]
> > As we can see, the same test done on the bcache0 device only got 1548 
> > IOPS and that yielded only 6.3 KB/s.
> 
> Well done on the benchmarking!  I always thought our new NVMes performed 
> slower than expected but hadn't gotten around to investigating. 
> 
> > I've noticed in several tests, varying the amount of jobs or increasing 
> > the size of the blocks, that the larger the size of the blocks, the more 
> > I approximate the performance of the physical device to the bcache 
> > device.
> 
> You said "blocks" but did you mean bucket size (make-bcache -b) or block 
> size (make-bcache -w) ?
> 
> If larger buckets makes it slower than that actually surprises me: bigger 
> buckets means less metadata and better sequential writeback to the 
> spinning disks (though you hadn't yet hit writeback to spinning disks in 
> your stats).  Maybe you already tried, but varying the bucket size might 
> help.  Try graphing bucket size (powers of 2) against IOPS, maybe there is 
> a "sweet spot"?
> 
> Be aware that 4k blocks (so-called "4Kn") is unsafe for the cache device, 
> unless Coly has patched that.  Make sure your `blockdev --getss` reports 
> 512 for your NVMe!
> 
> Hi Coly,
> 
> Some time ago you ordered an an SSD to test the 4k cache issue, has that 
> been fixed?  I've kept an eye out for the patch but not sure if it was released.
> 
> You have a really great test rig setup with NVMes for stress
> testing bcache. Can you replicate Adriano's `ioping` numbers below?
> 
> > With ioping it is also possible to notice a limitation, as the latency 
> > of the bcache0 device is around 1.5ms, while in the case of the raw 
> > device (a partition of NVMe), the same test is only 82.1us.
> > 
> > root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=1 time=1.52 ms (warmup)
> > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=2 time=1.60 ms
> > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3 time=1.55 ms
> >
> > root@pve-20:~# ioping -c10 /dev/nvme0n1p2 -D -Y -WWW -s4k
> > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=1 time=81.2 us (warmup)
> > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=2 time=82.7 us
> > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3 time=82.4 us
> 
> Wow, almost 20x higher latency, sounds convincing that something is wrong.
> 
> A few things to try:
> 
> 1. Try ioping without -Y.  How does it compare?
> 
> 2. Maybe this is an inter-socket latency issue.  Is your server 
>   multi-socket?  If so, then as a first pass you could set the kernel 
>   cmdline `isolcpus` for testing to limit all processes to a single 
>   socket where the NVMe is connected (see `lscpu`).  Check `hwloc-ls`
>   or your motherboard manual to see how the NVMe port is wired to your
>   CPUs.
> 
>   If that helps then fine tune with `numactl -cN ioping` and 
>   /proc/irq/<n>/smp_affinity_list (and `grep nvme /proc/interrupts`) to 
>   make sure your NVMe's are locked to IRQs on the same socket.
> 
> 3a. sysfs:
> 
> > # echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> 
> good.
> 
> > # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
> > # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us
> 
> Also try these (I think bcache/cache is a symlink to /sys/fs/bcache/<cache set>)
> 
> echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us 
> echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
> 
> 
> Try tuning journal_delay_ms: 
>   /sys/fs/bcache/<cset-uuid>/journal_delay_ms
>     Journal writes will delay for up to this many milliseconds, unless a 
>     cache flush happens sooner. Defaults to 100.
> 
> 3b: Hacking bcache code:
> 
> I just noticed that journal_delay_ms says "unless a cache flush happens 
> sooner" but cache flushes can be re-ordered so flushing the journal when 
> REQ_OP_FLUSH comes through may not be useful, especially if there is a 
> high volume of flushes coming down the pipe because the flushes could kill 
> the NVMe's cache---and maybe the 1.5ms ping is actual flash latency.  It
> would flush data and journal.
> 
> Maybe there should be a cachedev_noflush sysfs option for those with some 
> kind of power-loss protection of there SSD's.  It looks like this is 
> handled in request.c when these functions call bch_journal_meta():
> 
>     1053: static void cached_dev_nodata(struct closure *cl)
>     1263: static void flash_dev_nodata(struct closure *cl)
> 
> Coly can you comment about journal flush semantics with respect to 
> performance vs correctness and crash safety?
> 
> Adriano, as a test, you could change this line in search_alloc() in 
> request.c:
> 
>     - s->iop.flush_journal    = op_is_flush(bio->bi_opf);
>     + s->iop.flush_journal    = 0;
> 
> and see how performance changes.
> 
> Someone correct me if I'm wrong, but I don't think flush_journal=0 will 
> affect correctness unless there is a crash.  If that /is/ the performance 
> problem then it would narrow the scope of this discussion.
> 
> 4. I wonder if your 1.5ms `ioping` stats scale with CPU clock speed: can 
>   you set your CPU governor to run at full clock speed and then slowest 
>   clock speed to see if it is a CPU limit somewhere as we expect?
> 
>   You can do `grep MHz /proc/cpuinfo` to see the active rate to make sure 
>   the governor did its job.  
> 
>   If it scales with CPU then something in bcache is working too hard.  
>   Maybe garbage collection?  Other devs would need to chime in here to 
>   steer the troubleshooting if that is the case.
> 
> 
> 5. I'm not sure if garbage collection is the issue, but you might try 
>   Mingzhe's dynamic incremental gc patch:
>     https://www.spinics.net/lists/linux-bcache/msg11185.html
> 
> 6. Try dm-cache and see if its IO latency is similar to bcache: If it is 
>   about the same then that would indicate an issue in the block layer 
>   somewhere outside of bcache.  If dm-cache is better, then that confirms 
>   a bcache issue.
> 
> 
> > The cache was configured directly on one of the NVMe partitions (in this 
> > case, the first partition). I did several tests using fio and ioping, 
> > testing on a partition on the NVMe device, without partition and 
> > directly on the raw block, on a first partition, on the second, with or 
> > without configuring bcache. I did all this to remove any doubt as to the 
> > method. The results of tests performed directly on the hardware device, 
> > without going through bcache are always fast and similar.
> > 
> > But tests in bcache are always slower. If you use writethrough, of 
> > course, it gets much worse, because the performance is equal to the raw 
> > spinning disk.
> > 
> > Using writeback improves a lot, but still doesn't use the full speed of 
> > NVMe (honestly, much less than full speed).
> 
> Indeed, I hope this can be fixed!  A 20x improvement in bcache would 
> be awesome.
> 
> > But I've also noticed that there is a limit on writing sequential data, 
> > which is a little more than half of the maximum write rate shown in 
> > direct tests by the NVMe device.
> 
> For sync, async, or both?
> 
> 
> > Processing doesn't seem to be going up like the tests.
> 
> 
> What do you mean "processing" ?
> 
> -Eric
> 
> 
> 
--8323328-1607642748-1653596082=:20764--

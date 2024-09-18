Return-Path: <linux-bcache+bounces-718-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 814B697BAAB
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 12:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6C5C1C21621
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 10:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A7F17B401;
	Wed, 18 Sep 2024 10:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PZqo31Jb"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35D158203
	for <linux-bcache@vger.kernel.org>; Wed, 18 Sep 2024 10:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726654728; cv=none; b=PwlUAh3xtZxnRadFf8PFnoHm1OGu0A+mvg64/XeLNhtEtKFt1jDRNekqg98JgFs2ZUrNlZwLfUX7QQhEvg3kr6SVglBvD6RUk1c1XICOntca+dcdwC2g5mrWkt39/PpxHI9gZjGddntWq3jDZEdQlfG1Mq8hRnaTataI8yYIicM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726654728; c=relaxed/simple;
	bh=rQMTrIs2uxiG5Zd84TTp94d//7op6Q5zP2UnBiMBk8M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Z9L1DaitNnyAPIYK7XTUYTL1BwAtvC5oqzwvSGVM2biEcSy7irig1HsuTtEtA64BjKwb4H0WC+e8h/aNdbe1dP5+YD1qd/bpgCA8vAmykrszm4meRJ+ojWpHYBuIAmLCW7Cbq/v33tfvAUtMek+iSCYf2co4Q9MrdtxwQmovp/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PZqo31Jb; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726654722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kOc9PhmRBkQsL8H56R2rWsXDnAPxqY/k+F7uAdNbnH8=;
	b=PZqo31Jb5eVakP0P5MXPCO6OaC/4aVukUj26q/TvX1U+MXIxXtRP5KPibIcBnIq4pVTzKp
	oAwhcSmVUoVaW0lf8Wl/wlHkv1X2YUs3N9bgmhFaWo36HjChVuZGbngieYi4Fxh3OEFQm/
	owGEEKTAF/8DZWS/YFV70iYuZkDmhaE=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: axboe@kernel.dk,
	dan.j.williams@intel.com,
	gregory.price@memverge.com,
	John@groves.net,
	Jonathan.Cameron@Huawei.com,
	bbhushan2@marvell.com,
	chaitanyak@nvidia.com,
	rdunlap@infradead.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v2 0/8] Introduce CBD (CXL Block Device)
Date: Wed, 18 Sep 2024 10:18:13 +0000
Message-Id: <20240918101821.681118-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi all,
    This is V2 for CBD (CXL Block Device). The most important
feature mentioned in the RFC, cbd cache, is finally ready for review.

The introduction of cbd cache makes cbd highly useful in single-host
scenarios. At the same time, since the hardware features are not yet
ready, I've included multi-host scenarios as an optional feature in
Kconfig in this version, with a note indicating that multi-host requires
shared memory to support hardware consistency.

V2 of the code can be found at: https://github.com/DataTravelGuide/linux.git branch cbd

    (1) What is CBD Cache
  cbd cache is a *lightweight* solution that uses persistent memory as block
device cache. It works similar with bcache, where bcache uses block
devices as cache device, but cbd cache only supports persistent memory
devices for caching. It accesses the cache device through DAX and
is designed with features specifically for persistent memory scenarios,
such as multi-cache tree structures and sync insertion of cached data.

+-----------------------------------------------------------------+
|                         single-host                             |
+-----------------------------------------------------------------+
|                                                                 |
|                                                                 |
|                                                                 |
|                                                                 |
|                                                                 |
|                        +-----------+     +------------+         |
|                        | /dev/cbd0 |     | /dev/cbd1  |         |
|                        |           |     |            |         |
|  +---------------------|-----------|-----|------------|-------+ |
|  |                     |           |     |            |       | |
|  |      /dev/pmem0     | cbd0 cache|     | cbd1 cache |       | |
|  |                     |           |     |            |       | |
|  +---------------------|-----------|-----|------------|-------+ |
|                        |+---------+|     |+----------+|         |
|                        ||/dev/sda ||     || /dev/sdb ||         |
|                        |+---------+|     |+----------+|         |
|                        +-----------+     +------------+         |
+-----------------------------------------------------------------+

Note: cbd cache is not intended to replace your bcache. Instead, it
offers an alternative solution specifically suited for scenarios where
you want to use persistent memory devices as block device cache.

Another caching technique for accessing persistent memory using DAX is
dm-writeback, but it is designed for scenarios based on device-mapper.
On the other hand, cbd cache and bcache are caching solutions for block
device scenarios. Therefore, I did not do a comparative analysis between
cbd cache and dm-writeback.

    (2) light software overhead cache write (low latency)

For cache write, handling a write request typically involves the
following steps: (1) Allocating cache space -> (2) Writing data to the
cache -> (3) Recording cache index metadata -> (4) Returning the result.

In cache modules using block devices as the cache (e.g., bcache), the
steps of (2) writing data to the cache and (3) recording cache index
metadata are asynchronous.

During step (2), submit_bio is issued to the cache block device, and
after the bi_end_io callback completes, a new process continues with
step (3). This incurs significant overhead for persistent memory cache.

However, cbd cache, which is designed for persistent memory, does not
require asynchronous operations. It can directly proceed with steps (3)
and (4) after completing the memcpy through DAX.

This makes a significant difference for small IO. In the case of 4K
random writes, cbd cache achieves a latency of only 7.72us (compared to
25.30us for bcache in the same test, offering a 300% improvement).

Further comparative results for various scenarios are shown in the table
below.

+------------+-------------------------+--------------------------+
| numjobs=1  |         randwrite       |       randread           |
| iodepth=1  +------------+------------+-------------+------------+
| (latency)  |  cbd cache |  bcache    |  cbd cache  |  bcache    |
+------------+------------+------------+-------------+------------+
|  bs=512    |    6.10us  |    23.08us |      4.82us |     5.57us |
+------------+------------+------------+-------------+------------+
|  bs=1K     |    6.35us  |    21.68us |      5.38us |     6.05us |
+------------+------------+------------+-------------+------------+
|  bs=4K     |    7.72us  |    25.30us |      6.06us |     6.00us |
+------------+------------+------------+-------------+------------+
|  bs=8K     |    8.92us  |    27.73us |      7.24us |     7.35us |
+------------+------------+------------+-------------+------------+
|  bs=16K    |   12.25us  |    34.04us |      9.06us |     9.10us |
+------------+------------+------------+-------------+------------+
|  bs=32K    |   16.77us  |    49.24us |     14.10us |    16.18us |
+------------+------------+------------+-------------+------------+
|  bs=64K    |   30.52us  |    63.72us |     30.69us |    30.38us |
+------------+------------+------------+-------------+------------+
|  bs=128K   |   51.66us  |   114.69us |     38.47us |    39.10us |
+------------+------------+------------+-------------+------------+
|  bs=256K   |  110.16us  |   204.41us |     79.64us |    99.98us |
+------------+------------+------------+-------------+------------+
|  bs=512K   |  205.52us  |   398.70us |    122.15us |   131.97us |
+------------+------------+------------+-------------+------------+
|  bs=1M     |  493.57us  |   623.31us |    233.48us |   246.56us |
+------------+------------+------------+-------------+------------+

    (3) multi-queue and multi cache tree (high iops)

For persistent memory, the hardware concurrency is very high. If an
indexing tree is used to manage space indexing, the indexing will become
a bottleneck for concurrency.

cbd cache independently manages its own indexing tree for each backend.
Meanwhile, the indexing tree for the cache corresponding to each backend
is divided into multiple RB trees based on the logical address space.
All IO operations will find the corresponding indexing tree based on
their offset. This design increases concurrency while ensuring that the
depth of the indexing tree does not become too large.

From testing, in a scenario with 32 numjobs, cbd cache achieved nearly
1,400K IOPS for 4K random write (under the same test scenario, the IOPS
of bcache was around 210K, meaning CBD Cache provided an improvement of
over 600%).

More detailed comparison results are as follows:
+------------+-------------------------+--------------------------+
|  bs=4K     |         randwrite       |       randread           |
| iodepth=1  +------------+------------+-------------+------------+
|  (iops)    |  cbd cache |  bcache    |  cbd cache  |  bcache    |
+------------+------------+------------+-------------+------------+
|  numjobs=1 |    93652   |    38055   |    154101   |     142292 |
+------------+------------+------------+-------------+------------+
|  numjobs=2 |   205255   |    79322   |    317143   |     221957 |
+------------+------------+------------+-------------+------------+
|  numjobs=4 |   430588   |   124439   |    635760   |     513443 |
+------------+------------+------------+-------------+------------+
|  numjobs=8 |   852865   |   160980   |   1226714   |     505911 |
+------------+------------+------------+-------------+------------+
|  numjobs=16|  1140952   |   226094   |   2058178   |     996146 |
+------------+------------+------------+-------------+------------+
|  numjobs=32|  1418989   |   214447   |   2892710   |    1361308 |
+------------+------------+------------+-------------+------------+
    (4) better performance stablility (less stdev)

CBD Cache, through a streamlined design, simplifies and makes the IO
process more controllable, which allows for stable performance output.

For example, in CBD Cache, the writeback does not need to walk through
the indexing tree, meaning that the writeback process will not suffer
from increased IO latency due to conflict in the indexing tree.

From testing, under random write, CBD Cache achieves an average latency
of 6.80us, with a max latency of 2794us and a latency standard deviation
of 36.45 (under the same test, Bcache has an average latency of 24.28us,
but a max latency of 474,622us and a standard deviation as high as
937.81. This means that in terms of standard deviation, CBD Cache
achieved approximately 30 times the improvement).

Bcache:
=================================================
write: IOPS=39.1k, BW=153MiB/s (160MB/s)(5120MiB/33479msec); 0 zone
resets
    slat (usec): min=4, max=157364, avg=12.47, stdev=138.93
    clat (nsec): min=1168, max=474615k, avg=11808.80, stdev=927287.74
     lat (usec): min=11, max=474622, avg=24.28, stdev=937.81
    clat percentiles (nsec):
     |  1.00th=[   1256],  5.00th=[   1304], 10.00th=[   1320],
     | 20.00th=[   1400], 30.00th=[   1448], 40.00th=[   1672],
     | 50.00th=[   8640], 60.00th=[   9152], 70.00th=[   9664],
     | 80.00th=[  10048], 90.00th=[  11328], 95.00th=[  19072],
     | 99.00th=[  27776], 99.50th=[  36608], 99.90th=[ 173056],
     | 99.95th=[ 856064], 99.99th=[2039808]
   bw (  KiB/s): min=28032, max=214664, per=99.69%, avg=156122.03, stdev=51649.87, samples=66
   iops        : min= 7008, max=53666, avg=39030.53, stdev=12912.50, samples=66
  lat (usec)   : 2=41.55%, 4=4.59%, 10=32.70%, 20=16.37%, 50=4.45%
  lat (usec)   : 100=0.10%, 250=0.17%, 500=0.02%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.03%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
  lat (msec)   : 100=0.01%, 250=0.01%, 500=0.01%
  cpu          : usr=11.93%, sys=38.61%, ctx=1311384, majf=0, minf=382
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1310718,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=153MiB/s (160MB/s), 153MiB/s-153MiB/s (160MB/s-160MB/s), io=5120MiB (5369MB), run=33479-33479msec

Disk stats (read/write):
    bcache0: ios=0/1305444, sectors=0/10443552, merge=0/0,
ticks=0/21789, in_queue=21789, util=65.13%, aggrios=0/0, aggsectors=0/0,
aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
  ram0: ios=0/0, sectors=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
  pmem0: ios=0/0, sectors=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%

CBD cache:
==============================================
  write: IOPS=133k, BW=520MiB/s (545MB/s)(5120MiB/9848msec); 0 zone
resets
    slat (usec): min=3, max=2786, avg= 5.84, stdev=36.41
    clat (nsec): min=852, max=132404, avg=959.09, stdev=436.60
     lat (usec): min=4, max=2794, avg= 6.80, stdev=36.45
    clat percentiles (nsec):
     |  1.00th=[  884],  5.00th=[  900], 10.00th=[  908], 20.00th=[916],
     | 30.00th=[  924], 40.00th=[  924], 50.00th=[  932], 60.00th=[940],
     | 70.00th=[  948], 80.00th=[  964], 90.00th=[ 1004], 95.00th=[1064],
     | 99.00th=[ 1192], 99.50th=[ 1432], 99.90th=[ 6688], 99.95th=[7712],
     | 99.99th=[12480]
   bw (  KiB/s): min=487088, max=552928, per=99.96%, avg=532154.95, stdev=18228.92, samples=19
   iops        : min=121772, max=138232, avg=133038.84, stdev=4557.32, samples=19
  lat (nsec)   : 1000=89.09%
  lat (usec)   : 2=10.76%, 4=0.03%, 10=0.09%, 20=0.03%, 50=0.01%
  lat (usec)   : 100=0.01%, 250=0.01%
  cpu          : usr=23.93%, sys=76.03%, ctx=61, majf=0, minf=16
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1310720,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=520MiB/s (545MB/s), 520MiB/s-520MiB/s (545MB/s-545MB/s),
io=5120MiB (5369MB), run=9848-9848msec

Disk stats (read/write):
  cbd0: ios=0/1280334, sectors=0/10242672, merge=0/0, ticks=0/0, in_queue=0, util=43.07%

    (5) no need of formating for your existing disk

As a lightweight block storage caching technology, cbd cache does not
require storing metadata on backend disk. This allows users to easily
add caching to existing disks without the need for any formatting
operations and data migration. They can also easily stop using the cbd
cache without complications, The backend disk can be used independently
as a raw disk.

    (6) backend device is crash-consistency

The writeback mechanism of cbd cache strictly follows a log-structured
approach when writeback data. Even if dirty cache data is overwritten by
new data (e.g., the old data from 0-4K is A, and new data overwrites
0-4K with B), the old data A is writeback first, followed by writeback
the new data B to overwrite on the backend disk. This ensures that the
backend disk maintains crash consistency. In the event of a failure of
the pmem device, the data on the backend disk remains usable, though
crash consistency is maintained while losing the data in the cache. This
feature is particularly useful in cloud storage for disaster recovery
scenarios.

It is important to note that this approach may lead to cache space
utilization issues if there are many overwrite operations. However,
modern file systems, such as Btrfs and F2FS, take wear leveling of the
disk into account, so they tend to avoid writing repeatedly to the same
area. This means that there will not be a large number of overwrite
writes for the disk. Additionally, modern databases, especially those
using LSM engines, rarely perform overwrite operations.

Additionally, there is an entry on the TODO list to provide a parameter
backend_consistency=false to allow users to achieve better cache space
utilization. That depends on how urgent the requirment is.

    (7) cache space for each disk is configurable

For each backend, when enabling caching, we can specify cache space size
for this backend. This is different from bcache, where all backing
devices can dynamically share the cache space within a single cache
device. This improves cache utilization by achieving optimal utilization
through time-sharing. However, this can lead to an issue where cache
behavior becomes unpredictable. In enterprise applications, it's
important to have a more precise understanding of the performance of
each disk. When multiple disks dynamically share the cache, the exact
amount of cache each disk receives becomes uncertain. cbd cache assigns
a dedicated cache space for each disk, ensuring that the cache is
exclusive and not affected by others, making the cache behavior more
predictable.

    (8) After all, all the performance test results mentioned
above were executed using the `memmap=20G!4G` option to simulate the `/dev/pmem0` device.

Additionally, the cbd code runs the cbd-tests by default, including the
xfstests suite, it passes xfstests test suite.

If anyone has a real CXL memory device, it would be great if you could
help with the testing. Thanks!


Dongsheng Yang (8):
  cbd: introduce cbd_transport
  cbd: introduce cbd_host
  cbd: introduce cbd_segment
  cbd: introduce cbd_channel
  cbd: introduce cbd_cache
  cbd: introduce cbd_blkdev
  cbd: introduce cbd_backend
  block: Init for CBD(CXL Block Device) module

 drivers/block/Kconfig             |    2 +
 drivers/block/Makefile            |    2 +
 drivers/block/cbd/Kconfig         |   45 +
 drivers/block/cbd/Makefile        |    3 +
 drivers/block/cbd/cbd_backend.c   |  395 +++++
 drivers/block/cbd/cbd_blkdev.c    |  433 ++++++
 drivers/block/cbd/cbd_cache.c     | 2410 +++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_channel.c   |   96 ++
 drivers/block/cbd/cbd_handler.c   |  242 +++
 drivers/block/cbd/cbd_host.c      |  129 ++
 drivers/block/cbd/cbd_internal.h  | 1193 ++++++++++++++
 drivers/block/cbd/cbd_main.c      |  224 +++
 drivers/block/cbd/cbd_queue.c     |  574 +++++++
 drivers/block/cbd/cbd_segment.c   |  349 +++++
 drivers/block/cbd/cbd_transport.c |  957 ++++++++++++
 15 files changed, 7054 insertions(+)
 create mode 100644 drivers/block/cbd/Kconfig
 create mode 100644 drivers/block/cbd/Makefile
 create mode 100644 drivers/block/cbd/cbd_backend.c
 create mode 100644 drivers/block/cbd/cbd_blkdev.c
 create mode 100644 drivers/block/cbd/cbd_cache.c
 create mode 100644 drivers/block/cbd/cbd_channel.c
 create mode 100644 drivers/block/cbd/cbd_handler.c
 create mode 100644 drivers/block/cbd/cbd_host.c
 create mode 100644 drivers/block/cbd/cbd_internal.h
 create mode 100644 drivers/block/cbd/cbd_main.c
 create mode 100644 drivers/block/cbd/cbd_queue.c
 create mode 100644 drivers/block/cbd/cbd_segment.c
 create mode 100644 drivers/block/cbd/cbd_transport.c

-- 
2.34.1



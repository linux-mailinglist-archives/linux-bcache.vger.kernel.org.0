Return-Path: <linux-bcache+bounces-837-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAE40A03E08
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 12:39:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9346D165D64
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D5381E5738;
	Tue,  7 Jan 2025 11:38:28 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046C51E47DD;
	Tue,  7 Jan 2025 11:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736249907; cv=none; b=OjTFQT8WJquuG0M+IWZy0ADzcnG2mPv5E4jaWIYzEvvIqWOFZ+DMKb9a8N/uUIjarNriGHe9iHIJFPg7vR3kC4E0vTcuYRs5FGZ5ZVhx9hXgFKlsW6H9lqpUqoJpiAYeCRhmuaO0IAb2GG1vcaUvZTWTwUiCGGVHxtmU9mIv0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736249907; c=relaxed/simple;
	bh=K28Q/7ydyBx0TYZ2gaYlgfCN0BElGpvz/jW54iGq0rU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mqgqEQpTnJXS/XXAZ4IObk2kp8GHiheChvWb4deJ7wTa8Yf+sJQu7H0AmcXz+XX7Q6KjddixXiUrZ7DnitI3b1d45hQPR8GfALrtqaaXr5W71W0DWVG3yBdU5osAk/hUopDb3rpPG4ukxAZ8uuF1jIQ8nXRalSCkFTRm/RIcDXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YS8CB1HYwzpTQV;
	Tue,  7 Jan 2025 19:36:38 +0800 (CST)
Received: from kwepemo500009.china.huawei.com (unknown [7.202.194.199])
	by mail.maildlp.com (Postfix) with ESMTPS id DFAA21403D1;
	Tue,  7 Jan 2025 19:38:19 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 kwepemo500009.china.huawei.com (7.202.194.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 7 Jan 2025 19:38:19 +0800
Message-ID: <2a75df28-5e05-460b-8427-78c8e9d18f52@huawei.com>
Date: Tue, 7 Jan 2025 19:38:17 +0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] Introduce CBD (CXL Block Device)
Content-Language: en-US
To: Dongsheng Yang <dongsheng.yang@linux.dev>, <axboe@kernel.dk>,
	<dan.j.williams@intel.com>, <gregory.price@memverge.com>, <John@groves.net>,
	<Jonathan.Cameron@Huawei.com>, <bbhushan2@marvell.com>,
	<chaitanyak@nvidia.com>, <rdunlap@infradead.org>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux-bcache@vger.kernel.org>
References: <20250107103024.326986-1-dongsheng.yang@linux.dev>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20250107103024.326986-1-dongsheng.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemo500009.china.huawei.com (7.202.194.199)



On 2025/1/7 18:30, Dongsheng Yang wrote:
> Hi Jens,
>      Please help to take a look at this patchset. This is V3 for CBD (CXL Block Device).
> CBD supports both single-host and multi-host scenarios, and allows the use of pmem
> devices as block device cache, providing low latency and high-concurrency performance.
>      (1) Better latency:
>          1 iodepth, 1 numjobs, randwrite bs=4K: cbd 7.72us vs bcache
> 25.30us, about 300% improvement
>      (2) Better iops:
>          1 iodepth, 32 numjobs, randwrite bs=4K: cbd 1,400K IOPS vs
> bcache 210K IOPS, about 600% improvement
>      (3) Better stdev:
>          1 iodepth, 1 numjobs, randwrite bs=4K: cbd stdev=36.45 vs bcache
> stdev=937.81, about 30 times improvement.
> 
> V3 of the code can be found at: https://github.com/DataTravelGuide/linux.git tag cbd-v3
> 
> Changelog from V2:
> 	- Refactored the cbd_cache.c and cbd_internal.h files by splitting them into multiple files, making the structure clearer and increasing readability.
> 	- Added CRC verification for all data and metadata. This means that if all CRC verification options are enabled in Kconfig, all information written to pmem, including data and metadata, will have CRC checks.
> 	- Fixed some minor bugs discovered during long-term runs of xfstests.
> 	- Added the cbd-utils (https://github.com/DataTravelGuide/cbd-utils) project to user-space tools, providing the cbdctrl command for cbd-related management operations.
> 
> You can create a cbd using the following commands:
> 
> 	# cbdctrl tp-reg --path /dev/pmem0 --host node0 --format --force
> 	# cbdctrl backend-start --path /dev/sda --start-dev --cache-size 1G
> 	/dev/cbd0
> 	# cbdctrl backend-list
> 	[
> 	    {
> 		"backend_id": 0,
> 		"host_id": 0,
> 		"backend_path": "/dev/sda",
> 		"alive": true,
> 		"cache_segs": 64,
> 		"cache_gc_percent": 70,
> 		"cache_used_segs": 1,
> 		"blkdevs": [
> 		    {
> 			"blkdev_id": 0,
> 			"host_id": 0,
> 			"backend_id": 0,
> 			"dev_name": "/dev/cbd0",
> 			"alive": true
> 		    }
> 		]
> 	    }
> 	]
> 
> Additional information about CBD cache:
> 
>      (1) What is CBD Cache
>    cbd cache is a *lightweight* solution that uses persistent memory as block
> device cache. It works similar with bcache, where bcache uses block
> devices as cache device, but cbd cache only supports persistent memory
> devices for caching. It accesses the cache device through DAX and
> is designed with features specifically for persistent memory scenarios,
> such as multi-cache tree structures and sync insertion of cached data.
> 
> +-----------------------------------------------------------------+
> |                         single-host                             |
> +-----------------------------------------------------------------+
> |                                                                 |
> |                                                                 |
> |                                                                 |
> |                                                                 |
> |                                                                 |
> |                        +-----------+     +------------+         |
> |                        | /dev/cbd0 |     | /dev/cbd1  |         |
> |                        |           |     |            |         |
> |  +---------------------|-----------|-----|------------|-------+ |
> |  |                     |           |     |            |       | |
> |  |      /dev/pmem0     | cbd0 cache|     | cbd1 cache |       | |
> |  |                     |           |     |            |       | |
> |  +---------------------|-----------|-----|------------|-------+ |
> |                        |+---------+|     |+----------+|         |
> |                        ||/dev/sda ||     || /dev/sdb ||         |
> |                        |+---------+|     |+----------+|         |
> |                        +-----------+     +------------+         |
> +-----------------------------------------------------------------+
> 
> Note: cbd cache is not intended to replace your bcache. Instead, it
> offers an alternative solution specifically suited for scenarios where
> you want to use persistent memory devices as block device cache.
> 
> Another caching technique for accessing persistent memory using DAX is
> dm-writeback, but it is designed for scenarios based on device-mapper.
> On the other hand, cbd cache and bcache are caching solutions for block
> device scenarios. Therefore, I did not do a comparative analysis between
> cbd cache and dm-writeback.
> 
>      (2) light software overhead cache write (low latency)
> 
> For cache write, handling a write request typically involves the
> following steps: (1) Allocating cache space -> (2) Writing data to the
> cache -> (3) Recording cache index metadata -> (4) Returning the result.
> 
> In cache modules using block devices as the cache (e.g., bcache), the
> steps of (2) writing data to the cache and (3) recording cache index
> metadata are asynchronous.
> 
> During step (2), submit_bio is issued to the cache block device, and
> after the bi_end_io callback completes, a new process continues with
> step (3). This incurs significant overhead for persistent memory cache.
> 
> However, cbd cache, which is designed for persistent memory, does not
> require asynchronous operations. It can directly proceed with steps (3)
> and (4) after completing the memcpy through DAX.

So, is this the main source of performance improvement? And I'm curious 
if supporting nvm as a cache layer in bcache could achieve the same 
effect. What's the different between cbd and bcache over nvm? Some works 
about bcache over nvm have been done in [1][2], they only store part of 
data on nvm. So can we achieve the same purpose if we make pmem as the 
cache layer for bcache? That means the layer is: backend block device 
--> pmem device (cache layer) ---> FS/application.

Thanks,
Hongbo

[1] 
https://lore.kernel.org/linux-block/20210207152423.70697-4-colyli@suse.de/T/

[2] 
https://patchwork.kernel.org/project/linux-block/patch/20210210050742.31237-8-colyli@suse.de/

> 
> This makes a significant difference for small IO. In the case of 4K
> random writes, cbd cache achieves a latency of only 7.72us (compared to
> 25.30us for bcache in the same test, offering a 300% improvement).
> 
> Further comparative results for various scenarios are shown in the table
> below.
> 
> +------------+-------------------------+--------------------------+
> | numjobs=1  |         randwrite       |       randread           |
> | iodepth=1  +------------+------------+-------------+------------+
> | (latency)  |  cbd cache |  bcache    |  cbd cache  |  bcache    |
> +------------+------------+------------+-------------+------------+
> |  bs=512    |    6.10us  |    23.08us |      4.82us |     5.57us |
> +------------+------------+------------+-------------+------------+
> |  bs=1K     |    6.35us  |    21.68us |      5.38us |     6.05us |
> +------------+------------+------------+-------------+------------+
> |  bs=4K     |    7.72us  |    25.30us |      6.06us |     6.00us |
> +------------+------------+------------+-------------+------------+
> |  bs=8K     |    8.92us  |    27.73us |      7.24us |     7.35us |
> +------------+------------+------------+-------------+------------+
> |  bs=16K    |   12.25us  |    34.04us |      9.06us |     9.10us |
> +------------+------------+------------+-------------+------------+
> |  bs=32K    |   16.77us  |    49.24us |     14.10us |    16.18us |
> +------------+------------+------------+-------------+------------+
> |  bs=64K    |   30.52us  |    63.72us |     30.69us |    30.38us |
> +------------+------------+------------+-------------+------------+
> |  bs=128K   |   51.66us  |   114.69us |     38.47us |    39.10us |
> +------------+------------+------------+-------------+------------+
> |  bs=256K   |  110.16us  |   204.41us |     79.64us |    99.98us |
> +------------+------------+------------+-------------+------------+
> |  bs=512K   |  205.52us  |   398.70us |    122.15us |   131.97us |
> +------------+------------+------------+-------------+------------+
> |  bs=1M     |  493.57us  |   623.31us |    233.48us |   246.56us |
> +------------+------------+------------+-------------+------------+
> 
>      (3) multi-queue and multi cache tree (high iops)
> 
> For persistent memory, the hardware concurrency is very high. If an
> indexing tree is used to manage space indexing, the indexing will become
> a bottleneck for concurrency.
> 
> cbd cache independently manages its own indexing tree for each backend.
> Meanwhile, the indexing tree for the cache corresponding to each backend
> is divided into multiple RB trees based on the logical address space.
> All IO operations will find the corresponding indexing tree based on
> their offset. This design increases concurrency while ensuring that the
> depth of the indexing tree does not become too large.
> 
>>From testing, in a scenario with 32 numjobs, cbd cache achieved nearly
> 1,400K IOPS for 4K random write (under the same test scenario, the IOPS
> of bcache was around 210K, meaning CBD Cache provided an improvement of
> over 600%).
> 
> More detailed comparison results are as follows:
> +------------+-------------------------+--------------------------+
> |  bs=4K     |         randwrite       |       randread           |
> | iodepth=1  +------------+------------+-------------+------------+
> |  (iops)    |  cbd cache |  bcache    |  cbd cache  |  bcache    |
> +------------+------------+------------+-------------+------------+
> |  numjobs=1 |    93652   |    38055   |    154101   |     142292 |
> +------------+------------+------------+-------------+------------+
> |  numjobs=2 |   205255   |    79322   |    317143   |     221957 |
> +------------+------------+------------+-------------+------------+
> |  numjobs=4 |   430588   |   124439   |    635760   |     513443 |
> +------------+------------+------------+-------------+------------+
> |  numjobs=8 |   852865   |   160980   |   1226714   |     505911 |
> +------------+------------+------------+-------------+------------+
> |  numjobs=16|  1140952   |   226094   |   2058178   |     996146 |
> +------------+------------+------------+-------------+------------+
> |  numjobs=32|  1418989   |   214447   |   2892710   |    1361308 |
> +------------+------------+------------+-------------+------------+
>      (4) better performance stablility (less stdev)
> 
> CBD Cache, through a streamlined design, simplifies and makes the IO
> process more controllable, which allows for stable performance output.
> 
> For example, in CBD Cache, the writeback does not need to walk through
> the indexing tree, meaning that the writeback process will not suffer
> from increased IO latency due to conflict in the indexing tree.
> 
>>From testing, under random write, CBD Cache achieves an average latency
> of 6.80us, with a max latency of 2794us and a latency standard deviation
> of 36.45 (under the same test, Bcache has an average latency of 24.28us,
> but a max latency of 474,622us and a standard deviation as high as
> 937.81. This means that in terms of standard deviation, CBD Cache
> achieved approximately 30 times the improvement).
> 
> Bcache:
> =================================================
> write: IOPS=39.1k, BW=153MiB/s (160MB/s)(5120MiB/33479msec); 0 zone
> resets
>      slat (usec): min=4, max=157364, avg=12.47, stdev=138.93
>      clat (nsec): min=1168, max=474615k, avg=11808.80, stdev=927287.74
>       lat (usec): min=11, max=474622, avg=24.28, stdev=937.81
>      clat percentiles (nsec):
>       |  1.00th=[   1256],  5.00th=[   1304], 10.00th=[   1320],
>       | 20.00th=[   1400], 30.00th=[   1448], 40.00th=[   1672],
>       | 50.00th=[   8640], 60.00th=[   9152], 70.00th=[   9664],
>       | 80.00th=[  10048], 90.00th=[  11328], 95.00th=[  19072],
>       | 99.00th=[  27776], 99.50th=[  36608], 99.90th=[ 173056],
>       | 99.95th=[ 856064], 99.99th=[2039808]
>     bw (  KiB/s): min=28032, max=214664, per=99.69%, avg=156122.03, stdev=51649.87, samples=66
>     iops        : min= 7008, max=53666, avg=39030.53, stdev=12912.50, samples=66
>    lat (usec)   : 2=41.55%, 4=4.59%, 10=32.70%, 20=16.37%, 50=4.45%
>    lat (usec)   : 100=0.10%, 250=0.17%, 500=0.02%, 750=0.01%, 1000=0.01%
>    lat (msec)   : 2=0.03%, 4=0.01%, 10=0.01%, 20=0.01%, 50=0.01%
>    lat (msec)   : 100=0.01%, 250=0.01%, 500=0.01%
>    cpu          : usr=11.93%, sys=38.61%, ctx=1311384, majf=0, minf=382
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued rwts: total=0,1310718,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    WRITE: bw=153MiB/s (160MB/s), 153MiB/s-153MiB/s (160MB/s-160MB/s), io=5120MiB (5369MB), run=33479-33479msec
> 
> Disk stats (read/write):
>      bcache0: ios=0/1305444, sectors=0/10443552, merge=0/0,
> ticks=0/21789, in_queue=21789, util=65.13%, aggrios=0/0, aggsectors=0/0,
> aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
>    ram0: ios=0/0, sectors=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
>    pmem0: ios=0/0, sectors=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
> 
> CBD cache:
> ==============================================
>    write: IOPS=133k, BW=520MiB/s (545MB/s)(5120MiB/9848msec); 0 zone
> resets
>      slat (usec): min=3, max=2786, avg= 5.84, stdev=36.41
>      clat (nsec): min=852, max=132404, avg=959.09, stdev=436.60
>       lat (usec): min=4, max=2794, avg= 6.80, stdev=36.45
>      clat percentiles (nsec):
>       |  1.00th=[  884],  5.00th=[  900], 10.00th=[  908], 20.00th=[916],
>       | 30.00th=[  924], 40.00th=[  924], 50.00th=[  932], 60.00th=[940],
>       | 70.00th=[  948], 80.00th=[  964], 90.00th=[ 1004], 95.00th=[1064],
>       | 99.00th=[ 1192], 99.50th=[ 1432], 99.90th=[ 6688], 99.95th=[7712],
>       | 99.99th=[12480]
>     bw (  KiB/s): min=487088, max=552928, per=99.96%, avg=532154.95, stdev=18228.92, samples=19
>     iops        : min=121772, max=138232, avg=133038.84, stdev=4557.32, samples=19
>    lat (nsec)   : 1000=89.09%
>    lat (usec)   : 2=10.76%, 4=0.03%, 10=0.09%, 20=0.03%, 50=0.01%
>    lat (usec)   : 100=0.01%, 250=0.01%
>    cpu          : usr=23.93%, sys=76.03%, ctx=61, majf=0, minf=16
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued rwts: total=0,1310720,0,0 short=0,0,0,0 dropped=0,0,0,0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> 
> Run status group 0 (all jobs):
>    WRITE: bw=520MiB/s (545MB/s), 520MiB/s-520MiB/s (545MB/s-545MB/s),
> io=5120MiB (5369MB), run=9848-9848msec
> 
> Disk stats (read/write):
>    cbd0: ios=0/1280334, sectors=0/10242672, merge=0/0, ticks=0/0, in_queue=0, util=43.07%
> 
>      (5) no need of formating for your existing disk
> 
> As a lightweight block storage caching technology, cbd cache does not
> require storing metadata on backend disk. This allows users to easily
> add caching to existing disks without the need for any formatting
> operations and data migration. They can also easily stop using the cbd
> cache without complications, The backend disk can be used independently
> as a raw disk.
> 
>      (6) backend device is crash-consistency
> 
> The writeback mechanism of cbd cache strictly follows a log-structured
> approach when writeback data. Even if dirty cache data is overwritten by
> new data (e.g., the old data from 0-4K is A, and new data overwrites
> 0-4K with B), the old data A is writeback first, followed by writeback
> the new data B to overwrite on the backend disk. This ensures that the
> backend disk maintains crash consistency. In the event of a failure of
> the pmem device, the data on the backend disk remains usable, though
> crash consistency is maintained while losing the data in the cache. This
> feature is particularly useful in cloud storage for disaster recovery
> scenarios.
> 
> It is important to note that this approach may lead to cache space
> utilization issues if there are many overwrite operations. However,
> modern file systems, such as Btrfs and F2FS, take wear leveling of the
> disk into account, so they tend to avoid writing repeatedly to the same
> area. This means that there will not be a large number of overwrite
> writes for the disk. Additionally, modern databases, especially those
> using LSM engines, rarely perform overwrite operations.
> 
> Additionally, there is an entry on the TODO list to provide a parameter
> backend_consistency=false to allow users to achieve better cache space
> utilization. That depends on how urgent the requirment is.
> 
>      (7) cache space for each disk is configurable
> 
> For each backend, when enabling caching, we can specify cache space size
> for this backend. This is different from bcache, where all backing
> devices can dynamically share the cache space within a single cache
> device. This improves cache utilization by achieving optimal utilization
> through time-sharing. However, this can lead to an issue where cache
> behavior becomes unpredictable. In enterprise applications, it's
> important to have a more precise understanding of the performance of
> each disk. When multiple disks dynamically share the cache, the exact
> amount of cache each disk receives becomes uncertain. cbd cache assigns
> a dedicated cache space for each disk, ensuring that the cache is
> exclusive and not affected by others, making the cache behavior more
> predictable.
> 
>      (8) After all, all the performance test results mentioned
> above were executed using the `memmap=20G!4G` option to simulate the `/dev/pmem0` device.
> 
> Additionally, the cbd code runs the cbd-tests daily, including the xfstests suite,
> it passes xfstests test suite. (cbd-tests: https://github.com/DataTravelGuide/cbd-tests)
> 
> Thanx
> 
> Dongsheng Yang (8):
>    cbd: introduce cbd_transport
>    cbd: introduce cbd_host
>    cbd: introduce cbd_segment
>    cbd: introduce cbd_channel
>    cbd: introduce cbd_blkdev
>    cbd: introduce cbd_backend
>    cbd: introduce cbd_cache
>    block: Init for CBD(CXL Block Device)
> 
>   MAINTAINERS                                   |    7 +
>   drivers/block/Kconfig                         |    2 +
>   drivers/block/Makefile                        |    2 +
>   drivers/block/cbd/Kconfig                     |   89 ++
>   drivers/block/cbd/Makefile                    |   14 +
>   drivers/block/cbd/cbd_backend.c               |  730 ++++++++++
>   drivers/block/cbd/cbd_backend.h               |  137 ++
>   drivers/block/cbd/cbd_blkdev.c                |  551 ++++++++
>   drivers/block/cbd/cbd_blkdev.h                |   92 ++
>   drivers/block/cbd/cbd_cache/cbd_cache.c       |  489 +++++++
>   drivers/block/cbd/cbd_cache/cbd_cache.h       |  157 +++
>   drivers/block/cbd/cbd_cache/cbd_cache_gc.c    |  167 +++
>   .../block/cbd/cbd_cache/cbd_cache_internal.h  |  536 ++++++++
>   drivers/block/cbd/cbd_cache/cbd_cache_key.c   |  881 ++++++++++++
>   drivers/block/cbd/cbd_cache/cbd_cache_req.c   |  921 +++++++++++++
>   .../block/cbd/cbd_cache/cbd_cache_segment.c   |  268 ++++
>   .../block/cbd/cbd_cache/cbd_cache_writeback.c |  197 +++
>   drivers/block/cbd/cbd_channel.c               |  144 ++
>   drivers/block/cbd/cbd_channel.h               |  429 ++++++
>   drivers/block/cbd/cbd_handler.c               |  468 +++++++
>   drivers/block/cbd/cbd_handler.h               |   66 +
>   drivers/block/cbd/cbd_host.c                  |  227 ++++
>   drivers/block/cbd/cbd_host.h                  |   67 +
>   drivers/block/cbd/cbd_internal.h              |  482 +++++++
>   drivers/block/cbd/cbd_main.c                  |  230 ++++
>   drivers/block/cbd/cbd_queue.c                 |  516 +++++++
>   drivers/block/cbd/cbd_queue.h                 |  288 ++++
>   drivers/block/cbd/cbd_segment.c               |  311 +++++
>   drivers/block/cbd/cbd_segment.h               |  104 ++
>   drivers/block/cbd/cbd_transport.c             | 1186 +++++++++++++++++
>   drivers/block/cbd/cbd_transport.h             |  169 +++
>   31 files changed, 9927 insertions(+)
>   create mode 100644 drivers/block/cbd/Kconfig
>   create mode 100644 drivers/block/cbd/Makefile
>   create mode 100644 drivers/block/cbd/cbd_backend.c
>   create mode 100644 drivers/block/cbd/cbd_backend.h
>   create mode 100644 drivers/block/cbd/cbd_blkdev.c
>   create mode 100644 drivers/block/cbd/cbd_blkdev.h
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache.c
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache.h
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_gc.c
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_internal.h
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_key.c
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_req.c
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_segment.c
>   create mode 100644 drivers/block/cbd/cbd_cache/cbd_cache_writeback.c
>   create mode 100644 drivers/block/cbd/cbd_channel.c
>   create mode 100644 drivers/block/cbd/cbd_channel.h
>   create mode 100644 drivers/block/cbd/cbd_handler.c
>   create mode 100644 drivers/block/cbd/cbd_handler.h
>   create mode 100644 drivers/block/cbd/cbd_host.c
>   create mode 100644 drivers/block/cbd/cbd_host.h
>   create mode 100644 drivers/block/cbd/cbd_internal.h
>   create mode 100644 drivers/block/cbd/cbd_main.c
>   create mode 100644 drivers/block/cbd/cbd_queue.c
>   create mode 100644 drivers/block/cbd/cbd_queue.h
>   create mode 100644 drivers/block/cbd/cbd_segment.c
>   create mode 100644 drivers/block/cbd/cbd_segment.h
>   create mode 100644 drivers/block/cbd/cbd_transport.c
>   create mode 100644 drivers/block/cbd/cbd_transport.h
> 


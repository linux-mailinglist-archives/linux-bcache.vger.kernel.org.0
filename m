Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BEBF7823
	for <lists+linux-bcache@lfdr.de>; Mon, 11 Nov 2019 16:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfKKP4S (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 11 Nov 2019 10:56:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:38040 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726887AbfKKP4S (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 11 Nov 2019 10:56:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78684B39F;
        Mon, 11 Nov 2019 15:56:15 +0000 (UTC)
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
To:     Christian Balzer <chibi@gol.com>, linux-bcache@vger.kernel.org
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
Date:   Mon, 11 Nov 2019 23:56:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/11/11 10:10 上午, Christian Balzer wrote:
> 
> 
> Hello,
> 
> When researching the issues below and finding out about the PDC changes
> since 4.9 this also provided a good explanation for the load spikes we see
> with 4.9, as the default writeback is way too slow to empty the dirty
> pages and thus there is never much of a buffer for sudden write spikes,
> causing the PDC to overshoot when trying to flush things out to the
> backing device.
> 
> With Debian Buster things obviously changed and the current kernel
> ---
> Linux version 4.19.0-6-amd64 (debian-kernel@lists.debian.org) (gcc version
> 8.3.0 (Debian 8.3.0-6)) #1 SMP Debian 4.19.67-2+deb10u1 (2019-09-20) ---
> we get writeback_rate_minimum (undocumented, value in 512Byte blocks).
> That looked promising and indeed it helps, but there are major gotchas.
> For the tests below I did set this to 8192 aka 4MB/s, which is something
> the backing Areca RAID (4GB cache, 16 handles at 0% utilization.
> 
> 1. Quiescent insanity
> 
> When running fio (see full command line and results below) all looks/seems
> fine, aside from issue #2 of course.
> However if one stops fio and the system is fully quiescent (no writes)
> then the new PDC goes berserk, most likely a division by zero type bug.
> 
> writeback_rate_debug goes from (just after stopping fio):
> ---
> rate:           4.0M/sec
> dirty:          954.7M
> target:         36.7G
> proportional:   -920.7M
> integral:       -17.1M
> change:         0.0k/sec
> next io:        -7969ms
> ---
> 
> to:
> ---
> rate:           0.9T/sec
> dirty:          496.4M
> target:         36.7G
> proportional:   0.0k
> integral:       0.0k
> change:         0.0k/sec
> next io:        -2000ms
> ---
> completely overwhelming the backing device and causing (again) massive
> load spikes. Very unintuitive and unexpected.
> 
> Any IO (like a fio with 1 IOPS target) will prevent this and the preset
> writeback_rate_minimum will be honored until the cache is clean.
> 
> 

This is a feature indeed.. When there is no I/O for a reasonable long
time, the writeback rate limit will be set to 1TB/s, to permit the
writeback I/O to perform as fastly as possible.

And as you observed, once there is new I/O coming, the maximized
writeback I/O will canceled and back to be controlled by PDC code.

Is there any inconvenience for such behavior in your environment ?


> 
> 2. Initial and intermittent 5 second drops
> 
> When starting the fiojob there is pronounced pause of about 5 seconds
> before things proceed.
> Then during the run we get this:
> ---
> Starting 1 process
> Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][2.4%][w=4000KiB/s][w=1000 IOPS][eta
> 04m:39s (repeats nicely for a while then we get the first slowdown)
> ...
> Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][14.9%][w=2192KiB/s][w=548 IOPS][eta
> 03m:49s Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][14.9%][eta
> 03m:55s] Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][17.0%][w=21.3MiB/s][w=5451
> IOPS][eta 03m:40 ...
> {last slowdown)
> Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][91.3%][w=3332KiB/s][w=833 IOPS][eta
> 00m:23s Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][91.3%][eta
> 00m:23s] Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][92.1%][w=6858KiB/s][w=1714
> IOPS][eta 00m:21 ---
> 
> These slowdowns happened 7 times during the run, alas not at particular
> regular intervals. A re-run with just a 10 IOPS rate shows a clearer
> pattern, the pauses are separated by 30 seconds of normal operation and
> take about 10(!!!) seconds.
> It's also quite visible in the latencies of the fiojob results.
> Neither the initial nor the intermittent pauses are present with the 4.9
> kernel bcache version.
> From a usability perspective, this very much counters the reason to use
> bcache in the first place.
> 

Can you run a top command on other terminal and check who is running
during the I/O slow down ? And what is the output of
/sys/block/bcache0/bcache/writeback_rate_debug (read the file every 30
seconds, don't be too frequently) when you feel the I/O is slow.

I encounter similar situation when GC thread is running, or too many
dirty data to throttle regular I/O requests. Not sure whether we are in
similar situation.

[snip]

> fio line/results:
> ---
> io --size=1G --ioengine=libaio --invalidate=1 --direct=1 --numjobs=1
> --rw=randwrite --name=fiojob --blocksize=4K --iodepth=32 --rate_iops=1000
> --- fiojob: (groupid=0, jobs=1): err= 0: pid=18933: Mon Nov 11 08:09:51
> 2019 write: IOPS=1000, BW=4000KiB/s (4096kB/s)(1024MiB/262144msec); 0 zone
> resets slat (usec): min=6, max=5227.2k, avg=153.88, stdev=22260.74
>     clat (usec): min=50, max=5207.0k, avg=569.68, stdev=20016.99
>      lat (usec): min=101, max=5228.0k, avg=724.32, stdev=30068.91
>     clat percentiles (usec):
>      |  1.00th=[  176],  5.00th=[  227], 10.00th=[  273], 20.00th=[  318],
>      | 30.00th=[  343], 40.00th=[  363], 50.00th=[  375], 60.00th=[  383],
>      | 70.00th=[  396], 80.00th=[  453], 90.00th=[  709], 95.00th=[  955],
>      | 99.00th=[ 3032], 99.50th=[ 4555], 99.90th=[ 8717], 99.95th=[10552],
>      | 99.99th=[13042]
>    bw (  KiB/s): min=  159, max=44472, per=100.00%, avg=4657.40,
> stdev=4975.82, samples=450 iops        : min=   39, max=11118,
> avg=1164.35, stdev=1243.96, samples=450 lat (usec)   : 100=0.07%,
> 250=7.42%, 500=75.19%, 750=8.81%, 1000=3.82% lat (msec)   : 2=2.95%,
> 4=1.04%, 10=0.63%, 20=0.07%, 100=0.01% lat (msec)   : 250=0.01%
>   cpu          : usr=1.63%, sys=7.48%, ctx=444428, majf=0, minf=10
>   IO depths    : 1=83.0%, 2=0.5%, 4=0.2%, 8=0.1%, 16=0.1%, 32=16.2%,
>> =64=0.0% submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>> =64=0.0% issued rwts: total=0,262144,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> Run status group 0 (all jobs):
>   WRITE: bw=4000KiB/s (4096kB/s), 4000KiB/s-4000KiB/s (4096kB/s-4096kB/s),
> io=1024MiB (1074MB), run=262144-262144msec ---
> 
The cache device is Samsung 960EVO 500GB, but how the backing devices
are attached ? Each hard drive running as a single bcache device, and
multiple bcache devices attached to the 500GB SSD ?

And could you post the fio job file, then let me try to setup a similar
configuration and check what happens exactly.

Thanks.

-- 

Coly Li

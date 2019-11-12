Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C912F88A6
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Nov 2019 07:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbfKLGjv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Tue, 12 Nov 2019 01:39:51 -0500
Received: from smtp12.dentaku.gol.com ([203.216.5.74]:14606 "EHLO
        smtp12.dentaku.gol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfKLGjv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Nov 2019 01:39:51 -0500
Received: from batzmaru.gol.ad.jp ([203.216.0.80])
        by smtp12.dentaku.gol.com with esmtpa (Dentaku)
        (envelope-from <chibi@gol.com>)
        id 1iUPq7-000DeT-V8; Tue, 12 Nov 2019 15:39:48 +0900
Date:   Tue, 12 Nov 2019 15:39:47 +0900
From:   Christian Balzer <chibi@gol.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
Message-ID: <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
In-Reply-To: <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
        <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
        <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
        <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
Organization: Rakuten Communications
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Virus-Scanned: ClamAV GOL (outbound)
X-GOL-Outbound-Spam-Score: -1.9
X-Abuse-Complaints: abuse@gol.com
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 12 Nov 2019 13:00:14 +0800 Coly Li wrote:

> On 2019/11/12 9:17 上午, Christian Balzer wrote:
> > On Mon, 11 Nov 2019 23:56:04 +0800 Coly Li wrote:
> >   
> >> On 2019/11/11 10:10 上午, Christian Balzer wrote:  
> >>>
> >>>
> >>> Hello,
> >>>
> >>> When researching the issues below and finding out about the PDC changes
> >>> since 4.9 this also provided a good explanation for the load spikes we see
> >>> with 4.9, as the default writeback is way too slow to empty the dirty
> >>> pages and thus there is never much of a buffer for sudden write spikes,
> >>> causing the PDC to overshoot when trying to flush things out to the
> >>> backing device.
> >>>
> >>> With Debian Buster things obviously changed and the current kernel
> >>> ---
> >>> Linux version 4.19.0-6-amd64 (debian-kernel@lists.debian.org) (gcc version
> >>> 8.3.0 (Debian 8.3.0-6)) #1 SMP Debian 4.19.67-2+deb10u1 (2019-09-20) ---
> >>> we get writeback_rate_minimum (undocumented, value in 512Byte blocks).
> >>> That looked promising and indeed it helps, but there are major gotchas.
> >>> For the tests below I did set this to 8192 aka 4MB/s, which is something
> >>> the backing Areca RAID (4GB cache, 16 handles at 0% utilization.
> >>>
> >>> 1. Quiescent insanity
> >>>
> >>> When running fio (see full command line and results below) all looks/seems
> >>> fine, aside from issue #2 of course.
> >>> However if one stops fio and the system is fully quiescent (no writes)
> >>> then the new PDC goes berserk, most likely a division by zero type bug.
> >>>
> >>> writeback_rate_debug goes from (just after stopping fio):
> >>> ---
> >>> rate:           4.0M/sec
> >>> dirty:          954.7M
> >>> target:         36.7G
> >>> proportional:   -920.7M
> >>> integral:       -17.1M
> >>> change:         0.0k/sec
> >>> next io:        -7969ms
> >>> ---
> >>>
> >>> to:
> >>> ---
> >>> rate:           0.9T/sec
> >>> dirty:          496.4M
> >>> target:         36.7G
> >>> proportional:   0.0k
> >>> integral:       0.0k
> >>> change:         0.0k/sec
> >>> next io:        -2000ms
> >>> ---
> >>> completely overwhelming the backing device and causing (again) massive
> >>> load spikes. Very unintuitive and unexpected.
> >>>
> >>> Any IO (like a fio with 1 IOPS target) will prevent this and the preset
> >>> writeback_rate_minimum will be honored until the cache is clean.
> >>>
> >>>     
> >>
> >> This is a feature indeed.. When there is no I/O for a reasonable long
> >> time, the writeback rate limit will be set to 1TB/s, to permit the
> >> writeback I/O to perform as fastly as possible.
> >>
> >> And as you observed, once there is new I/O coming, the maximized
> >> writeback I/O will canceled and back to be controlled by PDC code.
> >>
> >> Is there any inconvenience for such behavior in your environment ?
> >>  
> > Yes, unwanted load spikes, as I wrote.
> > Utilization of the backing RAID AND caching SSDs yo-yo'ing up to 100%.
> >   
> 
> Copied.
> 
> The maximum writeback rate feature is required by users indeed, from 
> workloads like desktop I/O acceleration, data base and distributed
> storage. People want to make the writeback thread to accomplish dirty
> data flushing as faster as possible in I/O idle time, then,
> - For desktop the hard drive may go to sleep and safe energy.
> - For other online workload less dirty data in cache means more writing
> can be served in busy hours.
> - Previous code will wake up hard drive every second for writeback at
> 4KB/s, so the hard drives are not able to have a rest even in I/O idle
> hours.
> 
No arguments here and in my use case the _minimum_ rate set to 4MB/s aka
8192 achieves all that.

> Therefore the maximum writeback rate is added, to maximum the writeback
> rate limit (1TB for now), then in I/O idle hours the dirty data can be
> flushed as faster as possible by writeback thread. From internal
> customers and external users, the feedback of maximum writeback rate is
> quite positive. This is the first time I realize not everyone wants it.
> 

The full speed (1TB/s) rate will result in initially high speeds (up to
280MBs) in most tests, but degrade (and cause load spikes -> alarms) later
on, often resulting in it taking LONGER than if it had stuck with the
4MB/s minimum rate set.
So yes, in my case something like a 32MB/s maximum rate would probably be
perfect.

> 
> > At some tests the backing device came to screeching halt at just 4MB/s
> > trying to accommodate that torrent of I/O.
> > At the best of times it peaked around 150MB/s which is still shy of what
> > it could do in a steady state scenario.
> > 
> > This is the backing device when set to a 32MB writeback minimum rate, as
> > you can see the RAID cache (4GB) still manages to squirrel that away w/o
> > any sign of load and then nicely coalesced flushes it to the actual RAID
> > (which can do about 700MBs sequential):
> > ---
> > 
> > DSK |          sda | busy      0% | read       0 | write  8002/s | MBr/s    0.0 | MBw/s   32.1 | avio 0.00 ms |
> > 
> > ---
> > 
> > This is when the lack of IO causes bcache to go to 1TB/s and totally trash
> > things:
> > ---
> > 
> > DSK |          sda | busy     84% | read     0/s | write 1845/s  | MBr/s    0.0 | MBw/s    7.2 | avio 0.45 ms |
> > 
> > ---
> > 
> > 
> > Whatever bcache or other kernel friends are doing when flushing at full
> > speed seems to be vastly different from the regulated writeback rate.
> >   
> 
> It seems Areca RAID adapter can not handle high random I/O pressure
> properly and even worse then regular write I/O rate (am I right ?).
> 
Already addressed, not really.

> It makes sense to not boost writeback rate in your case, one more
> question needs to be confirmed to make sure I don't mis-understand your
> issue.
> 
> For same amount of dirty data size, when regular I/O request is idle, in
> your hardware configuration, does maximum writeback rate accomplishes
> dirty data flushing faster ?
>
See above, not necessarily and definitely not at the "cost" of very visible
load spikes that can cause alerts to be triggered in production.

 
> 
> 
> > So yes, please either honor writeback_rate_minimum as the top value when
> > not under actual dirty cache pressure or add another parameter for upper
> > limits.
> > The later would also come in handy as an end stop for the PDC in general,
> > in my case I would never want it to write faster than something like
> > 100MB/s (average is 1-2MB/s on those servers).
> > 
> >   
> 
> So even with maximum writeback rate, the total time of flushing all
> dirty data can be much less, you still want a normal writeback rate and
> longer cache cleaning time with writeback_rate_minimum ?
> 

Even if that were the case, yes. 
Because it would reduce the load and leave more IOPS on the SSDs for other
activities.

Think of this similar to the MD RAID min and max settings.
The minimum is already there, max is currently hard-coded at 1TB/s and it
would be nice if a user who knows what they are doing could control that
as well.

> 
> 
> >>  
> >>>
> >>> 2. Initial and intermittent 5 second drops
> >>>
> >>> When starting the fiojob there is pronounced pause of about 5 seconds
> >>> before things proceed.
> >>> Then during the run we get this:
> >>> ---
> >>> Starting 1 process
> >>> Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][2.4%][w=4000KiB/s][w=1000 IOPS][eta
> >>> 04m:39s (repeats nicely for a while then we get the first slowdown)
> >>> ...
> >>> Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][14.9%][w=2192KiB/s][w=548 IOPS][eta
> >>> 03m:49s Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][14.9%][eta
> >>> 03m:55s] Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][17.0%][w=21.3MiB/s][w=5451
> >>> IOPS][eta 03m:40 ...
> >>> {last slowdown)
> >>> Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][91.3%][w=3332KiB/s][w=833 IOPS][eta
> >>> 00m:23s Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][91.3%][eta
> >>> 00m:23s] Jobs: 1 (f=1), 0-1000 IOPS: [w(1)][92.1%][w=6858KiB/s][w=1714
> >>> IOPS][eta 00m:21 ---
> >>>
> >>> These slowdowns happened 7 times during the run, alas not at particular
> >>> regular intervals. A re-run with just a 10 IOPS rate shows a clearer
> >>> pattern, the pauses are separated by 30 seconds of normal operation and
> >>> take about 10(!!!) seconds.
> >>> It's also quite visible in the latencies of the fiojob results.
> >>> Neither the initial nor the intermittent pauses are present with the 4.9
> >>> kernel bcache version.
> >>> From a usability perspective, this very much counters the reason to use
> >>> bcache in the first place.
> >>>     
> >>
> >> Can you run a top command on other terminal and check who is running
> >> during the I/O slow down ? And what is the output of
> >> /sys/block/bcache0/bcache/writeback_rate_debug (read the file every 30
> >> seconds, don't be too frequently) when you feel the I/O is slow.
> >>  
> > Does that "not too frequently" bit mean that the sysfs interaction bug is
> > still present after all this time?
> > There's no change in the output other than the amount of dirty data, rate
> > and everything else stays the same and with sane values.
> > 
> > At "full" 10 IOPS speed:
> > ---
> > 
> > rate:           4.0M/sec
> > dirty:          1.0M
> > target:         36.7G
> > proportional:   -941.4M
> > integral:       0.0k
> > change:         0.0k/sec
> > next io:        -21507ms
> > ---
> > When stalled:
> > ---
> > rate:           4.0M/sec
> > dirty:          1.5M
> > target:         36.7G
> > proportional:   -941.3M
> > integral:       0.0k
> > change:         0.0k/sec
> > next io:        -1147ms
> > ---
> > 
> > I'm running atop with a fast interval (5 or 2s) and the GC is only visible
> > sometimes when there is massive (unlimited) IOPS going on.
> > At the initial pause when starting fio and when it stalls every 30 seconds
> > the writeback thread is consuming 100%.  
> 
> The default writeback_rate_update_seconds is 5 seconds, if there is no
> regular I/O request after 6*5 (default writeback_rate_update_seconds) =
> 30 seconds, the writeback rate is set to 1TB/s as maximum rate.
> 
Yes, I do realize that.

But these pauses/stalls have nothing to do with issue #1 and the writeback
rate.

> The above is for only single backing device, more backing devices
> attached, more I/O idle time will be waited. E.g. If there are 4 backing
> devices attached to the cache set, the maximum writeback rate will be
> set to 1TB/s after waiting for 120 seconds.
> 
> > Which is obviously fishy, as when running with "--rate_iops=10" neither at
> > the start nor during the run is there any kind of pressure/load.
> > So my guess it's doing some navel gazing and rather ineffectively at that.
> > Again, this did not happen with the 4.9 kernel version.
> >   
> 
> When --rate_iops=10, it means there is regular I/O coming, maximum
> writeback rate should not be set. 

Correct, it never is.

>If you observe the 30 seconds stalls
> and writeback thread is 100% cpu consuming, there might be something
> wrong in the code. It seems not related to the backing raid adapter.
> 
None of the devices is (obviously) the least busy at 10 IOPS. 
The stall/pause is purely CPU, not iowait related.
And it's for 10 seconds (with the 10 IOPS at least), after 30 seconds of
normal operation.

> Could you please to offer me the command lines how the bcache devices
> are created, and the fio job file for your testing ? Then I can try to
> run similar procedure on my local machine and check what should be fixed.
>
The fio command line and output were in the original mail, vanilla bcache
creation originally on Jessie, don't have the exact command line anymore
obviously.

To trigger those stalls:
---
fio --size=1G --ioengine=libaio --invalidate=1 --direct=1 --numjobs=1 --rw=randwrite --name=fiojob --blocksize=4K --iodepth=32 --rate_iops=10
---

Regards,

Christian
 
> Thanks for the information.
> 
> -- 
> 
> Coly Li
> 


-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Rakuten Mobile Inc.

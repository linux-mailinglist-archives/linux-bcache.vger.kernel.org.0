Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3C715A545
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2020 10:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgBLJru (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 12 Feb 2020 04:47:50 -0500
Received: from smtp.mfedv.net ([212.82.36.170]:42652 "EHLO smtp.mfedv.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbgBLJru (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 12 Feb 2020 04:47:50 -0500
X-Greylist: delayed 885 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 04:47:48 EST
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 01C9X0UK017251;
        Wed, 12 Feb 2020 10:33:01 +0100
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with ESMTP id 3C9C811818B;
        Wed, 12 Feb 2020 10:33:00 +0100 (CET)
        (envelope-from bcache@mfedv.net)
Date:   Wed, 12 Feb 2020 10:33:00 +0100
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Postgarage Graz IT <it@postgarage.at>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: reads no longer cached since kernel 4.19
Message-ID: <20200212093300.GF24185@xoff>
References: <b039d510-9b03-e6a3-499a-1dbe72764cbe@postgarage.at>
 <98d03769-c58d-98dc-64aa-7d8fbf39ceea@postgarage.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98d03769-c58d-98dc-64aa-7d8fbf39ceea@postgarage.at>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Sorry for being late to reply. Your bcache is set to "writeback", and
your test is doing reads from a bcache with a still empty cache device;
while the "1GB" file resides initially only on the backing device.

My understanding so far was that in writeback mode only writes will ever
add data to the caching device (first as dirty, and post-writeback as
clean for as long as as space restrictions / usage patterns allow).
Therefore I would not have expected any piece of your "1GB" file to ever
be added to your caching device, and reading it would have to resort to
the backing device, even when repeatedly reading it.

I have seen discussion about caching of readahead requests for newer
kernels, and I thought (but never really checked) this would only
concern read-caching modes. Am I wrong in this assumption?

Matthias


On Wed, Feb 12, 2020 at 07:02:28AM +0100, Postgarage Graz IT wrote:
> On 10.02.20 17:10, Ville Aakko wrote:
> > Hi,
> > 
> > A fellow user responding here.
> > 
> > I've noticed similar behavior and have asked on this same mailing list
> > previously. See:
> > https://www.spinics.net/lists/linux-bcache/msg07859.html
> > 
> > Also seems there are other users with this issue on the Arch Forum,
> > where I have also started a discussion:
> > https://bbs.archlinux.org/viewtopic.php?id=250525
> > There is yet to be a single user to reply there (or on this mailing
> > list) claiming they have a working setup (for caching reads).
> > 
> > Judging from the Arch Linux thread, I have a hunch there were some
> > changes ~4.18, which broke read caching for many (all?) desktop users
> > (as anything which is flagged as readahed will not be cached, despite
> > setting sequential_cutoff). Also (again from the Arch thread) a
> > planned patch might enable expected read caching: "[PATCH 3/5] bcache:
> > add readahead cache policy options via sysfs interface" / see:
> > https://www.spinics.net/lists/linux-bcache/msg08074.html
> 
> Indeed that patch works.
> Now I'm using the 5.6-rc1 kernel and the performance gain is huge.
> 
> I only wonder, why the used cache number doesn't go up anymore like it
> did for pre-4.19 kernels.
> 
> 
> Linux kkb 5.6.0-050600rc1-generic #202002092032 SMP Mon Feb 10 01:36:50
> UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
> 
> --- bcache ---
> Device                      /dev/md0 (9:0)
> UUID                        d4f0e4cd-c2dc-4cec-bf5b-96f1f87ff0b8
> Block Size                  0.50KiB
> Bucket Size                 512.00KiB
> Congested?                  False
> Read Congestion             0.0ms
> Write Congestion            0.0ms
> Total Cache Size            111.79GiB
> Total Cache Used            1.12GiB	(0%)
> Total Cache Unused          110.67GiB	(99%)
> Evictable Cache             111.79GiB	(100%)
> Replacement Policy          [lru] fifo random
> Cache Mode                  writethrough [writeback] writearound none
> Total Hits                  0
> Total Misses                0
> Total Bypass Hits           0
> Total Bypass Misses         0
> Total Bypassed              0B
> 
> 1st pass
> 0.00user 0.60system 0:08.66elapsed 6%CPU (0avgtext+0avgdata
> 2220maxresident)k
> 2097632inputs+0outputs (1major+115minor)pagefaults 0swaps
> 
> 2nd pass
> 0.00user 0.47system 0:03.34elapsed 14%CPU (0avgtext+0avgdata
> 2216maxresident)k
> 2097128inputs+0outputs (1major+113minor)pagefaults 0swaps
> 
> 3rd pass
> 0.00user 0.45system 0:02.58elapsed 17%CPU (0avgtext+0avgdata
> 2096maxresident)k
> 2097296inputs+0outputs (1major+110minor)pagefaults 0swaps
> --- bcache ---
> Device                      /dev/md0 (9:0)
> UUID                        d4f0e4cd-c2dc-4cec-bf5b-96f1f87ff0b8
> Block Size                  0.50KiB
> Bucket Size                 512.00KiB
> Congested?                  False
> Read Congestion             0.0ms
> Write Congestion            0.0ms
> Total Cache Size            111.79GiB
> Total Cache Used            1.12GiB	(0%)
> Total Cache Unused          110.67GiB	(99%)
> Evictable Cache             110.67GiB	(99%)
> Replacement Policy          [lru] fifo random
> Cache Mode                  writethrough [writeback] writearound none
> Total Hits                  6352	(51%)
> Total Misses                6075
> Total Bypass Hits           0
> Total Bypass Misses         0
> 
> 
> As you can see, the reads must come from the SSD in the 2nd and 3rd
> pass, still "Total Cache Used" stays the same.
> 
> 
> > 
> > However this is highly speculative from someone not understanding file
> > systems or insides of bcache or the code at all.
> > 
> > Perhaps someone more involved can reply: is the current behavior
> > expected (reads are not getting cached practically at all). Also, is
> > the patch I've linked possibly going to fix the current issues?
> > 
> > Kind Regards,
> > Ville Aakko
> > 
> > 
> > 
> > su 9. helmik. 2020 klo 23.37 Postgarage Graz IT (it@postgarage.at) kirjoitti:
> >>
> >> Hello!
> >>
> >> I noticed, that bcache is no longer caching reads on my system which
> >> makes it behave like if there were only hdds.
> >>
> >> I'm using two hdds in a raid 1 as the backing device and a single ssd as
> >> cache device:
> >>
> >> sda             8:0    0 111,8G  0 disk
> >> └─bcache0     252:0    0 921,9G  0 disk  /
> >> sdb             8:16   0 931,5G  0 disk
> >> ├─sdb1          8:17   0   922G  0 part
> >> │ └─md0         9:0    0 921,9G  0 raid1
> >> │   └─bcache0 252:0    0 921,9G  0 disk  /
> >> ├─sdb2          8:18   0     1K  0 part
> >> ├─sdb5          8:21   0   1,9G  0 part
> >> │ └─md1         9:1    0   1,9G  0 raid1 /boot
> >> └─sdb6          8:22   0   7,6G  0 part  [SWAP]
> >> sdc             8:32   0 931,5G  0 disk
> >> ├─sdc1          8:33   0   922G  0 part
> >> │ └─md0         9:0    0 921,9G  0 raid1
> >> │   └─bcache0 252:0    0 921,9G  0 disk  /
> >> ├─sdc2          8:34   0     1K  0 part
> >> ├─sdc5          8:37   0   1,9G  0 part
> >> │ └─md1         9:1    0   1,9G  0 raid1 /boot
> >> └─sdc6          8:38   0   7,6G  0 part  [SWAP]
> >>
> >>
> >> For benchmarking every time I detach the cache device, stop the bcache
> >> device, do a wipefs on the cache device, then make-bcache -C /dev/sda
> >> and finally reattach the cache.
> >> After that, I'm using the following script to repeatedly read a 1gb file:
> >>
> >> #!/bin/sh
> >> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> >> echo 0 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us
> >> echo 0 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
> >> uname -a
> >> echo
> >> bcache-status
> >> echo
> >> echo "1st pass"
> >> sync; echo 3 > /proc/sys/vm/drop_caches
> >> (time cat 1GB.bin > /dev/null)
> >> echo
> >> echo "2nd pass"
> >> sync; echo 3 > /proc/sys/vm/drop_caches
> >> (time cat 1GB.bin > /dev/null)
> >> echo
> >> echo "3rd pass"
> >> sync; echo 3 > /proc/sys/vm/drop_caches
> >> (time cat 1GB.bin > /dev/null)
> >> bcache-status
> >>
> >>
> >>
> >> As you can see from the results below, kernel 4.18.20 is the last
> >> kernel, where the cache grows and the performance goes up.
> >>
> >> I also compiled 4.19.0 with the bcache files from 4.18.20 and much to my
> >> suprise, that didn't change 4.19's behavior - still no caching. So some
> >> other changes must be the culprit or I did something wrong.
> >> I'm not that much into compiling the kernel, but I checked out the
> >> 4.19.0 and 4.18.20 commits and replaced the 4.19.0 drivers/md/bcache
> >> directory with the one from 4.18.20 - then recompiled and installed the
> >> new kernel.
> >>
> >> So i am at my wits end. Any help would be appreciated.
> >> Thanks
> >> Flo
> >>
> >>
> >> Linux kkb 4.18.20-041820-generic #201812030624 SMP Mon Dec 3 11:25:55
> >> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> --- bcache ---
> >> Device                      /dev/md0 (9:0)
> >> UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
> >> Block Size                  0.50KiB
> >> Bucket Size                 512.00KiB
> >> Congested?                  False
> >> Read Congestion             0.0ms
> >> Write Congestion            0.0ms
> >> Total Cache Size            111.79GiB
> >> Total Cache Used            1.12GiB     (0%)
> >> Total Cache Unused          110.67GiB   (99%)
> >> Evictable Cache             111.79GiB   (100%)
> >> Replacement Policy          [lru] fifo random
> >> Cache Mode                  writethrough [writeback] writearound none
> >> Total Hits                  0   (0%)
> >> Total Misses                6
> >> Total Bypass Hits           0
> >> Total Bypass Misses         0
> >> Total Bypassed              0B
> >>
> >> 1st pass
> >> 0.00user 0.36system 0:08.58elapsed 4%CPU (0avgtext+0avgdata
> >> 2196maxresident)k
> >> 2097608inputs+0outputs (1major+113minor)pagefaults 0swaps
> >>
> >> 2nd pass
> >> 0.00user 0.32system 0:03.29elapsed 9%CPU (0avgtext+0avgdata
> >> 2100maxresident)k
> >> 2097184inputs+0outputs (1major+110minor)pagefaults 0swaps
> >>
> >> 3rd pass
> >> 0.00user 0.32system 0:02.64elapsed 12%CPU (0avgtext+0avgdata
> >> 2092maxresident)k
> >> 2097280inputs+0outputs (1major+111minor)pagefaults 0swaps
> >> --- bcache ---
> >> Device                      /dev/md0 (9:0)
> >> UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
> >> Block Size                  0.50KiB
> >> Bucket Size                 512.00KiB
> >> Congested?                  False
> >> Read Congestion             0.0ms
> >> Write Congestion            0.0ms
> >> Total Cache Size            111.79GiB
> >> Total Cache Used            2.24GiB     (2%)
> >> Total Cache Unused          109.55GiB   (98%)
> >> Evictable Cache             110.67GiB   (99%)
> >> Replacement Policy          [lru] fifo random
> >> Cache Mode                  writethrough [writeback] writearound none
> >> Total Hits                  5   (0%)
> >> Total Misses                4079
> >> Total Bypass Hits           0   (0%)
> >> Total Bypass Misses         615
> >> Total Bypassed              2.40MiB
> >>
> >>
> >>
> >> Linux kkb 4.19.0-041900-generic #201810221809 SMP Mon Oct 22 22:11:45
> >> UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> --- bcache ---
> >> Device                      /dev/md0 (9:0)
> >> UUID                        67269654-92e8-4c3b-a524-8e8910082146
> >> Block Size                  0.50KiB
> >> Bucket Size                 512.00KiB
> >> Congested?                  False
> >> Read Congestion             0.0ms
> >> Write Congestion            0.0ms
> >> Total Cache Size            111.79GiB
> >> Total Cache Used            1.12GiB     (0%)
> >> Total Cache Unused          110.67GiB   (99%)
> >> Evictable Cache             111.79GiB   (100%)
> >> Replacement Policy          [lru] fifo random
> >> Cache Mode                  writethrough [writeback] writearound none
> >> Total Hits                  0   (0%)
> >> Total Misses                1
> >> Total Bypass Hits           0
> >> Total Bypass Misses         0
> >> Total Bypassed              0B
> >>
> >> 1st pass
> >> 0.00user 0.33system 0:09.29elapsed 3%CPU (0avgtext+0avgdata
> >> 2280maxresident)k
> >> 2097624inputs+0outputs (1major+113minor)pagefaults 0swaps
> >>
> >> 2nd pass
> >> 0.00user 0.33system 0:08.47elapsed 4%CPU (0avgtext+0avgdata
> >> 2248maxresident)k
> >> 2097280inputs+0outputs (1major+111minor)pagefaults 0swaps
> >>
> >> 3rd pass
> >> 0.00user 0.37system 0:10.46elapsed 3%CPU (0avgtext+0avgdata
> >> 2220maxresident)k
> >> 2097616inputs+0outputs (1major+114minor)pagefaults 0swaps
> >> --- bcache ---
> >> Device                      /dev/md0 (9:0)
> >> UUID                        67269654-92e8-4c3b-a524-8e8910082146
> >> Block Size                  0.50KiB
> >> Bucket Size                 512.00KiB
> >> Congested?                  False
> >> Read Congestion             0.0ms
> >> Write Congestion            0.0ms
> >> Total Cache Size            111.79GiB
> >> Total Cache Used            1.12GiB     (0%)
> >> Total Cache Unused          110.67GiB   (99%)
> >> Evictable Cache             111.79GiB   (100%)
> >> Replacement Policy          [lru] fifo random
> >> Cache Mode                  writethrough [writeback] writearound none
> >> Total Hits                  132 (23%)
> >> Total Misses                436
> >> Total Bypass Hits           51  (0%)
> >> Total Bypass Misses         17399
> >> Total Bypassed              43.50MiB
> >>
> >>
> >>
> >>
> >> Linux kkb 5.5.2-050502-generic #202002041931 SMP Tue Feb 4 19:33:15 UTC
> >> 2020 x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> --- bcache ---
> >> Device                      /dev/md0 (9:0)
> >> UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
> >> Block Size                  0.50KiB
> >> Bucket Size                 512.00KiB
> >> Congested?                  False
> >> Read Congestion             0.0ms
> >> Write Congestion            0.0ms
> >> Total Cache Size            111.79GiB
> >> Total Cache Used            1.12GiB     (0%)
> >> Total Cache Unused          110.67GiB   (99%)
> >> Evictable Cache             111.79GiB   (100%)
> >> Replacement Policy          [lru] fifo random
> >> Cache Mode                  writethrough [writeback] writearound none
> >> Total Hits                  0   (0%)
> >> Total Misses                1
> >> Total Bypass Hits           0   (0%)
> >> Total Bypass Misses         3
> >> Total Bypassed              52.00KiB
> >>
> >> 1st pass
> >> 0.00user 0.42system 0:09.21elapsed 4%CPU (0avgtext+0avgdata
> >> 2216maxresident)k
> >> 2097608inputs+0outputs (1major+112minor)pagefaults 0swaps
> >>
> >> 2nd pass
> >> 0.00user 0.42system 0:09.62elapsed 4%CPU (0avgtext+0avgdata
> >> 2248maxresident)k
> >> 2097280inputs+0outputs (1major+112minor)pagefaults 0swaps
> >>
> >> 3rd pass
> >> 0.00user 0.43system 0:08.75elapsed 5%CPU (0avgtext+0avgdata
> >> 2220maxresident)k
> >> 2097224inputs+0outputs (1major+114minor)pagefaults 0swaps
> >> --- bcache ---
> >> Device                      /dev/md0 (9:0)
> >> UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
> >> Block Size                  0.50KiB
> >> Bucket Size                 512.00KiB
> >> Congested?                  False
> >> Read Congestion             0.0ms
> >> Write Congestion            0.0ms
> >> Total Cache Size            111.79GiB
> >> Total Cache Used            1.12GiB     (0%)
> >> Total Cache Unused          110.67GiB   (99%)
> >> Evictable Cache             111.79GiB   (100%)
> >> Replacement Policy          [lru] fifo random
> >> Cache Mode                  writethrough [writeback] writearound none
> >> Total Hits                  121 (32%)
> >> Total Misses                246
> >> Total Bypass Hits           15  (0%)
> >> Total Bypass Misses         12811
> >> Total Bypassed              39.70MiB
> > 
> > 
> > 
> > --
> > --
> > Ville Aakko - ville.aakko@gmail.com

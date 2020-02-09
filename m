Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0234B156CC5
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Feb 2020 22:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgBIVgr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Feb 2020 16:36:47 -0500
Received: from cuba.postgarage.at ([148.251.14.253]:48077 "EHLO
        cuba.postgarage.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgBIVgr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Feb 2020 16:36:47 -0500
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2020 16:36:45 EST
Received: from localhost (localhost [127.0.0.1])
        by cuba.postgarage.at (Postfix) with ESMTP id 4E68B3463CC
        for <linux-bcache@vger.kernel.org>; Sun,  9 Feb 2020 22:31:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=postgarage.at; h=
        content-transfer-encoding:content-language:content-type
        :content-type:mime-version:user-agent:date:date:message-id
        :subject:subject:from:from:to; s=dkim; t=1581283866; x=
        1582147867; bh=RM9wWi/TLvP0C2moHnucRoYUiRcT4tL+aTQbsdF+xoA=; b=s
        ZJu2v+KEjxbXf8F9jCR4q+vgF0p22Qh7sVON7exmFh7JCpySo2hf/+VFk9Hd5GXz
        YCdU7G71KcaB02ZdTk04BBkFDz5uM6waxw2NvDl/qvmGVrLo1dJSLeq+NmEIVyH7
        8vz2WBS1nPsPeGMFAk6GdSeZ5XoP7eYNA+gXIN+Uw0=
X-Virus-Scanned: Debian amavisd-new at cuba.postgarage.at
Received: from cuba.postgarage.at ([127.0.0.1])
        by localhost (cuba.postgarage.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zs-rUwK1WNdn for <linux-bcache@vger.kernel.org>;
        Sun,  9 Feb 2020 22:31:06 +0100 (CET)
Received: from [10.0.0.254] (c-82-150-210-9.dsl.hotze.com [82.150.210.9])
        by cuba.postgarage.at (Postfix) with ESMTPSA id F13A93462A8
        for <linux-bcache@vger.kernel.org>; Sun,  9 Feb 2020 22:31:05 +0100 (CET)
To:     linux-bcache@vger.kernel.org
From:   Postgarage Graz IT <it@postgarage.at>
Autocrypt: addr=it@postgarage.at; prefer-encrypt=mutual; keydata=
 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
 ngS1cX7A5Sxi4aY=
Subject: reads no longer cached since kernel 4.19
Message-ID: <d2691cbb-0364-825c-4fd5-4ff8dc733644@postgarage.at>
Date:   Sun, 9 Feb 2020 22:31:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello!

I noticed, that bcache is no longer caching reads on my system which
makes it behave like if there were only hdds.

I'm using two hdds in a raid 1 as the backing device and a single ssd as
cache device:

sda             8:0    0 111,8G  0 disk
=E2=94=94=E2=94=80bcache0     252:0    0 921,9G  0 disk  /
sdb             8:16   0 931,5G  0 disk
=E2=94=9C=E2=94=80sdb1          8:17   0   922G  0 part
=E2=94=82 =E2=94=94=E2=94=80md0         9:0    0 921,9G  0 raid1
=E2=94=82   =E2=94=94=E2=94=80bcache0 252:0    0 921,9G  0 disk  /
=E2=94=9C=E2=94=80sdb2          8:18   0     1K  0 part
=E2=94=9C=E2=94=80sdb5          8:21   0   1,9G  0 part
=E2=94=82 =E2=94=94=E2=94=80md1         9:1    0   1,9G  0 raid1 /boot
=E2=94=94=E2=94=80sdb6          8:22   0   7,6G  0 part  [SWAP]
sdc             8:32   0 931,5G  0 disk
=E2=94=9C=E2=94=80sdc1          8:33   0   922G  0 part
=E2=94=82 =E2=94=94=E2=94=80md0         9:0    0 921,9G  0 raid1
=E2=94=82   =E2=94=94=E2=94=80bcache0 252:0    0 921,9G  0 disk  /
=E2=94=9C=E2=94=80sdc2          8:34   0     1K  0 part
=E2=94=9C=E2=94=80sdc5          8:37   0   1,9G  0 part
=E2=94=82 =E2=94=94=E2=94=80md1         9:1    0   1,9G  0 raid1 /boot
=E2=94=94=E2=94=80sdc6          8:38   0   7,6G  0 part  [SWAP]


For benchmarking every time I detach the cache device, stop the bcache
device, do a wipefs on the cache device, then make-bcache -C /dev/sda
and finally reattach the cache.
After that, I'm using the following script to repeatedly read a 1gb file:

#!/bin/sh
echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 0 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us
echo 0 > /sys/block/bcache0/bcache/cache/congested_write_threshold_us
uname -a
echo
bcache-status
echo
echo "1st pass"
sync; echo 3 > /proc/sys/vm/drop_caches
(time cat 1GB.bin > /dev/null)
echo
echo "2nd pass"
sync; echo 3 > /proc/sys/vm/drop_caches
(time cat 1GB.bin > /dev/null)
echo
echo "3rd pass"
sync; echo 3 > /proc/sys/vm/drop_caches
(time cat 1GB.bin > /dev/null)
bcache-status



As you can see from the results below, kernel 4.18.20 is the last
kernel, where the cache grows and the performance goes up.

I also compiled 4.19.0 with the bcache files from 4.18.20 and much to my
suprise, that didn't change 4.19's behavior - still no caching. So some
other changes must be the culprit or I did something wrong.
I'm not that much into compiling the kernel, but I checked out the
4.19.0 and 4.18.20 commits and replaced the 4.19.0 drivers/md/bcache
directory with the one from 4.18.20 - then recompiled and installed the
new kernel.

So i am at my wits end. Any help would be appreciated.
Thanks
Flo


Linux kkb 4.18.20-041820-generic #201812030624 SMP Mon Dec 3 11:25:55
UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  0	(0%)
Total Misses                6
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0B

1st pass
0.00user 0.36system 0:08.58elapsed 4%CPU (0avgtext+0avgdata
2196maxresident)k
2097608inputs+0outputs (1major+113minor)pagefaults 0swaps

2nd pass
0.00user 0.32system 0:03.29elapsed 9%CPU (0avgtext+0avgdata
2100maxresident)k
2097184inputs+0outputs (1major+110minor)pagefaults 0swaps

3rd pass
0.00user 0.32system 0:02.64elapsed 12%CPU (0avgtext+0avgdata
2092maxresident)k
2097280inputs+0outputs (1major+111minor)pagefaults 0swaps
--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        8275bf01-f0b3-423e-87fa-48336ce33068
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            2.24GiB	(2%)
Total Cache Unused          109.55GiB	(98%)
Evictable Cache             110.67GiB	(99%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  5	(0%)
Total Misses                4079
Total Bypass Hits           0	(0%)
Total Bypass Misses         615
Total Bypassed              2.40MiB



Linux kkb 4.19.0-041900-generic #201810221809 SMP Mon Oct 22 22:11:45
UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        67269654-92e8-4c3b-a524-8e8910082146
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  0	(0%)
Total Misses                1
Total Bypass Hits           0
Total Bypass Misses         0
Total Bypassed              0B

1st pass
0.00user 0.33system 0:09.29elapsed 3%CPU (0avgtext+0avgdata
2280maxresident)k
2097624inputs+0outputs (1major+113minor)pagefaults 0swaps

2nd pass
0.00user 0.33system 0:08.47elapsed 4%CPU (0avgtext+0avgdata
2248maxresident)k
2097280inputs+0outputs (1major+111minor)pagefaults 0swaps

3rd pass
0.00user 0.37system 0:10.46elapsed 3%CPU (0avgtext+0avgdata
2220maxresident)k
2097616inputs+0outputs (1major+114minor)pagefaults 0swaps
--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        67269654-92e8-4c3b-a524-8e8910082146
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  132	(23%)
Total Misses                436
Total Bypass Hits           51	(0%)
Total Bypass Misses         17399
Total Bypassed              43.50MiB




Linux kkb 5.5.2-050502-generic #202002041931 SMP Tue Feb 4 19:33:15 UTC
2020 x86_64 x86_64 x86_64 GNU/Linux

--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  0	(0%)
Total Misses                1
Total Bypass Hits           0	(0%)
Total Bypass Misses         3
Total Bypassed              52.00KiB

1st pass
0.00user 0.42system 0:09.21elapsed 4%CPU (0avgtext+0avgdata
2216maxresident)k
2097608inputs+0outputs (1major+112minor)pagefaults 0swaps

2nd pass
0.00user 0.42system 0:09.62elapsed 4%CPU (0avgtext+0avgdata
2248maxresident)k
2097280inputs+0outputs (1major+112minor)pagefaults 0swaps

3rd pass
0.00user 0.43system 0:08.75elapsed 5%CPU (0avgtext+0avgdata
2220maxresident)k
2097224inputs+0outputs (1major+114minor)pagefaults 0swaps
--- bcache ---
Device                      /dev/md0 (9:0)
UUID                        38a8b675-e332-4076-b0cf-44e4be72c300
Block Size                  0.50KiB
Bucket Size                 512.00KiB
Congested?                  False
Read Congestion             0.0ms
Write Congestion            0.0ms
Total Cache Size            111.79GiB
Total Cache Used            1.12GiB	(0%)
Total Cache Unused          110.67GiB	(99%)
Evictable Cache             111.79GiB	(100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  121	(32%)
Total Misses                246
Total Bypass Hits           15	(0%)
Total Bypass Misses         12811
Total Bypassed              39.70MiB

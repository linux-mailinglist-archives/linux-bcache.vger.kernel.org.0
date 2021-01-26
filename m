Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A853046AC
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 19:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391268AbhAZRWT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 12:22:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:54954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728256AbhAZIgI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Jan 2021 03:36:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 48F13AF57;
        Tue, 26 Jan 2021 08:34:39 +0000 (UTC)
Subject: Re: bcache create hundred of kernel threads - is this expected?
To:     Kai Krakow <kai@kaishome.de>
References: <CAC2ZOYsNnB3dkbnh3geqrW1msjG+=q23REWAu+BHjqqaF4fzQw@mail.gmail.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <d213d46e-8726-34a4-c217-e6b3aec66568@suse.de>
Date:   Tue, 26 Jan 2021 16:34:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAC2ZOYsNnB3dkbnh3geqrW1msjG+=q23REWAu+BHjqqaF4fzQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/25/21 3:31 PM, Kai Krakow wrote:
> Hi!
> 
> When looking at htop, I see hundreds of kernel threads dedicated to
> bcache workers. Many of them go in and out of D state at the same time
> which may explain the spikes in load I'm seeing especially with
> writeback enabled (easily surpassing 200 loadavg).
> 
> From some older observations, the system feels smoother when turning
> bcache off (cache_mode = none) but obviously many file system
> operations are much slower. With bcache enabled, I'm seeing
> spontaneous desktop lags every once in a while.
> 
> My bcache setup runs mainly on btrfs, with one additional xfs
> partition where I've put some background database workload which isn't
> exactly friends with btrfs.
> 
> I'm wondering if this is expected. No other block-related driver seems
> to be such a heavy user of kernel threads:
> ```
> # uname -a
> Linux jupiter 5.10.9-gentoo #3 SMP PREEMPT Sun Jan 24 22:43:57 CET
> 2021 x86_64 Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz GenuineIntel
> GNU/Linux
> 
> # ps faux | grep bcache | wc -l
> 284
> 
> # lsblk
> NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> sda           8:0    0 931,5G  0 disk
> ├─sda1        8:1    0     2G  0 part /efi
> ├─sda2        8:2    0 865,5G  0 part
> │ ├─bcache0 254:0    0   2,7T  0 disk # pooled with bcache4
> │ ├─bcache1 254:128  0   2,7T  0 disk # pooled with bcache4
> │ ├─bcache2 254:256  0 925,5G  0 disk # pooled with bcache4
> │ ├─bcache3 254:384  0 931,5G  0 disk /mnt/xfs-storage
> │ └─bcache4 254:512  0 925,5G  0 disk /mnt/btrfs-pool
> └─sda3        8:3    0    64G  0 part [SWAP]
> sdb           8:16   0   2,7T  0 disk
> ├─sdb1        8:17   0    32G  0 part [SWAP]
> └─sdb2        8:18   0   2,7T  0 part
>  └─bcache0 254:0    0   2,7T  0 disk
> sdc           8:32   0 931,5G  0 disk
> ├─sdc1        8:33   0     6G  0 part [SWAP]
> └─sdc2        8:34   0 925,5G  0 part
>  └─bcache4 254:512  0 925,5G  0 disk /mnt/btrfs-pool
> sdd           8:48   0 931,5G  0 disk
> ├─sdd1        8:49   0     6G  0 part [SWAP]
> └─sdd2        8:50   0 925,5G  0 part
>  └─bcache2 254:256  0 925,5G  0 disk
> sde           8:64   0   3,7T  0 disk
> ├─sde1        8:65   0     6G  0 part [SWAP]
> ├─sde2        8:66   0   2,7T  0 part
> │ └─bcache1 254:128  0   2,7T  0 disk
> └─sde3        8:67   0 931,5G  0 part
>  └─bcache3 254:384  0 931,5G  0 disk /mnt/xfs-storage
> sdf           8:80   1   7,5G  0 disk
> └─sdf1        8:81   1   7,5G  0 part
> 
> # dmesg | grep bcache
> [    2.079349] bcache: bch_journal_replay() journal replay done, 503
> keys in 131 entries, seq 50942189
> [    2.079739] bcache: register_cache() registered cache device sda2
> [    2.079837] bcache: register_bdev() registered backing device sdb2
> [    2.286757] bcache: bch_cached_dev_attach() Caching sdb2 as bcache0
> on set df11a09d-b91a-4cd3-80e2-2684f5b9c1b2
> [    2.286846] bcache: register_bdev() registered backing device sde2
> [    2.385586] BTRFS: device label system devid 5 transid 2310589
> /dev/bcache0 scanned by systemd-udevd (341)
> [    2.394597] bcache: bch_cached_dev_attach() Caching sde2 as bcache1
> on set df11a09d-b91a-4cd3-80e2-2684f5b9c1b2
> [    2.394688] bcache: register_bdev() registered backing device sdd2
> [    2.507326] bcache: bch_cached_dev_attach() Caching sdd2 as bcache2
> on set df11a09d-b91a-4cd3-80e2-2684f5b9c1b2
> [    2.507416] BTRFS: device label system devid 3 transid 2310589
> /dev/bcache1 scanned by systemd-udevd (341)
> [    2.507422] bcache: register_bdev() registered backing device sde3
> [    2.604546] bcache: bch_cached_dev_attach() Caching sde3 as bcache3
> on set df11a09d-b91a-4cd3-80e2-2684f5b9c1b2
> [    2.604645] bcache: register_bdev() registered backing device sdc2
> [    2.708189] bcache: bch_cached_dev_attach() Caching sdc2 as bcache4
> on set df11a09d-b91a-4cd3-80e2-2684f5b9c1b2
> [    2.731318] BTRFS: device label system devid 2 transid 2310589
> /dev/bcache2 scanned by systemd-udevd (339)
> [    2.748793] BTRFS: device label system devid 1 transid 2310589
> /dev/bcache4 scanned by systemd-udevd (336)
> [    3.201845] BTRFS info (device bcache4): use zstd compression, level 3
> [    3.201847] BTRFS info (device bcache4): enabling ssd optimizations
> [    3.201848] BTRFS info (device bcache4): using free space tree
> [    3.201848] BTRFS info (device bcache4): has skinny extents
> [    3.212303] BTRFS info (device bcache4): bdev /dev/bcache4 errs: wr
> 0, rd 0, flush 0, corrupt 1, gen 0
> # ignore the corrupt 1, this was a one-time occurrence while scrubbing
> # I can no longer reproduce this, maybe cosmic rays flipped a bit
> during scrubbing ;-)
> [    3.538177] BTRFS info (device bcache4): start tree-log replay
> [    6.187652] BTRFS info (device bcache4): using free space tree
> [    6.242252] XFS (bcache3): Mounting V5 Filesystem
> [    6.386719] XFS (bcache3): Starting recovery (logdev: internal)
> [    6.548018] XFS (bcache3): Ending recovery (logdev: internal)
> [    6.989625] bcache: register_bcache() error : device already registered
> [    6.991794] bcache: register_bcache() error : device already registered
> [    7.007219] bcache: register_bcache() error : device already registered
> [    7.300065] bcache: register_bcache() error : device already registered
> [    7.301004] bcache: register_bcache() error : device already registered
> [    7.370755] bcache: register_bcache() error : device already registered
> ```
> 
> Here's an excerpt of what I'm seeing:
> ```
> # ps faux|grep bcache
> root         180  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_ [bcache]
> root         381  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [bcache_gc]
> root         399  0.0  0.0      0     0 ?        S    Jan24   0:01  \_
> [bcache_allocato]
> root         400  0.0  0.0      0     0 ?        S    Jan24   0:10  \_
> [bcache_gc]
> root         402  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [bcache_writebac]
> root         403  0.2  0.0      0     0 ?        S    Jan24   1:23  \_
> [bcache_writebac]
> root         408  0.0  0.0      0     0 ?        S    Jan24   0:00  \_
> [bcache_status_u]
> root         410  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [bcache_writebac]
> root         411  0.2  0.0      0     0 ?        S    Jan24   1:23  \_
> [bcache_writebac]
> root         417  0.0  0.0      0     0 ?        S    Jan24   0:00  \_
> [bcache_status_u]
> root         419  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [bcache_writebac]
> root         420  0.1  0.0      0     0 ?        S    Jan24   0:51  \_
> [bcache_writebac]
> root         425  0.0  0.0      0     0 ?        S    Jan24   0:00  \_
> [bcache_status_u]
> root         427  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [bcache_writebac]
> root         428  0.0  0.0      0     0 ?        S    Jan24   0:00  \_
> [bcache_writebac]
> root         433  0.0  0.0      0     0 ?        S    Jan24   0:00  \_
> [bcache_status_u]
> root         435  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [bcache_writebac]
> root         436  0.1  0.0      0     0 ?        S    Jan24   0:51  \_
> [bcache_writebac]
> root         441  0.0  0.0      0     0 ?        S    Jan24   0:00  \_
> [bcache_status_u]
> root         570  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [xfs-buf/bcache3]
> root         571  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [xfs-conv/bcache]
> root         572  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [xfs-cil/bcache3]
> root         575  0.0  0.0      0     0 ?        I<   Jan24   0:00  \_
> [xfs-log/bcache3]
> root         576  0.0  0.0      0     0 ?        S    Jan24   0:03  \_
> [xfsaild/bcache3]
> root       72935  0.0  0.0      0     0 ?        I    01:08   0:00  \_
> [kworker/4:33-bcache_writeback_wq]
> root       72946  0.0  0.0      0     0 ?        I    01:08   0:00  \_
> [kworker/4:88-bcache]
> root       73171  0.0  0.0      0     0 ?        I    01:15   0:00  \_
> [kworker/4:122-bcache]
> root       74312  0.0  0.0      0     0 ?        I    01:57   0:00  \_
> [kworker/4:205-bcache_writeback_wq]
> root       74649  0.0  0.0      0     0 ?        I    02:09   0:00  \_
> [kworker/4:177-bcache]
> root       74658  0.0  0.0      0     0 ?        I    02:09   0:00  \_
> [kworker/4:238-bcache]
> root       76622  0.0  0.0      0     0 ?        I    03:08   0:00  \_
> [kworker/4:222-bcache]
> root       76658  0.0  0.0      0     0 ?        I    03:08   0:00  \_
> [kworker/4:318-bcache]
> ...
> root      111243  0.0  0.0      0     0 ?        I    03:49   0:00  \_
> [kworker/4:165-bcache_writeback_wq]
> root      111628  0.0  0.0      0     0 ?        I    04:05   0:00  \_
> [kworker/4:11-bcache_writeback_wq]
> root      111643  0.0  0.0      0     0 ?        I    04:05   0:00  \_
> [kworker/4:124-bcache_writeback_wq]
> root      111679  0.0  0.0      0     0 ?        I    04:05   0:00  \_
> [kworker/4:245-bcache]
> root      111697  0.0  0.0      0     0 ?        I    04:05   0:00  \_
> [kworker/4:295-bcache_writeback_wq]
> root      111720  0.0  0.0      0     0 ?        I    04:05   0:00  \_
> [kworker/4:337-bcache]
> root      111860  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:386-bcache]
> root      111862  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:390-bcache_writeback_wq]
> root      111866  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:394-bcache_writeback_wq]
> root      111867  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:395-bcache]
> root      111880  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:408-bcache_writeback_wq]
> root      111882  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:410-bcache]
> root      111896  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:424-bcache]
> root      111897  0.0  0.0      0     0 ?        I    04:09   0:00  \_
> [kworker/4:425-bcache]
> ...
> root      114184  0.0  0.0      0     0 ?        I    05:28   0:00  \_
> [kworker/4:181-bcache_writeback_wq]
> root      114186  0.0  0.0      0     0 ?        I    05:28   0:00  \_
> [kworker/4:187-bcache_writeback_wq]
> root      114187  0.0  0.0      0     0 ?        I    05:28   0:00  \_
> [kworker/4:188-bcache_writeback_wq]
> root      114193  0.0  0.0      0     0 ?        I    05:28   0:00  \_
> [kworker/4:207-bcache_writeback_wq]
> ...
> root      117073  0.0  0.0      0     0 ?        I    06:48   0:00  \_
> [kworker/4:182-bcache_writeback_wq]
> root      117074  0.0  0.0      0     0 ?        I    06:48   0:00  \_
> [kworker/4:190-bcache_writeback_wq]
> root      117077  0.0  0.0      0     0 ?        I    06:48   0:00  \_
> [kworker/4:218-bcache]
> root      117081  0.0  0.0      0     0 ?        I    06:48   0:00  \_
> [kworker/4:239-bcache_writeback_wq]
> root      117084  0.0  0.0      0     0 ?        I    06:48   0:00  \_
> [kworker/4:249-bcache]
> root      117087  0.0  0.0      0     0 ?        I    06:48   0:00  \_
> [kworker/4:264-bcache_writeback_wq]
> root      117088  0.0  0.0      0     0 ?        I    06:48   0:00  \_
> [kworker/4:269-bcache]
> root      118151  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:299-bcache]
> root      118152  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:300-bcache]
> root      118154  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:305-bcache]
> root      118159  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:313-bcache]
> root      118170  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:326-bcache_writeback_wq]
> root      118172  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:328-bcache]
> root      118179  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:335-bcache]
> root      118184  0.0  0.0      0     0 ?        I    06:53   0:00  \_
> [kworker/4:341-bcache_writeback_wq]
> ...
> ```
> 
> During high write work-loads, I'm sometimes seeing over 2000 kthreads
> (most of them are bcache workers).

They are not kernel thread exactly. Indeed they are kernel works
attaching on some kernel work queue. Bcache does I/Os in async way by
kwoerks (by explicit work queue schedule, or by implicit bcache closure
schedule), the "kthread" you observed is a context of an I/O kworker.

That is, the more parallel I/Os flying, the more such contexts you may
observe. This is as-designed for current bcache.

Thanks.

Coly Li

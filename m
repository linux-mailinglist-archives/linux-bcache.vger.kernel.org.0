Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45AB2B12D5
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Nov 2020 00:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgKLXkG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 12 Nov 2020 18:40:06 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:38568
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgKLXkG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 12 Nov 2020 18:40:06 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2020 18:40:04 EST
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <glbd-linux-bcache@m.gmane-mx.org>)
        id 1kdM7K-0008iX-Ad
        for linux-bcache@vger.kernel.org; Fri, 13 Nov 2020 00:35:02 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-bcache@vger.kernel.org
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: bcache error -> btrfs unmountable
Date:   Thu, 12 Nov 2020 13:25:15 -1000
Message-ID: <rokg8t$u8n$1@ciao.gmane.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
X-Mozilla-News-Host: news://news.gmane.org:119
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi list,

I have a RAID1 Btrfs (on sdb and sdc) behind bcache (on nvme0n1p4):

[jdg@tiare ~]$  lsblk -o NAME,UUID,SIZE,MOUNTPOINT
NAME           UUID                                   SIZE MOUNTPOINT
sdb            8ae3c26b-6932-4dad-89bc-569ae2c74366   3,7T
└─bcache1      c5b8386b-b81d-4473-9340-7b8a74fc3a3c   3,7T
sdc            7ccac426-dc8c-4cb3-9e64-13b1cf48d4bf   3,7T
└─bcache0      c5b8386b-b81d-4473-9340-7b8a74fc3a3c   3,7T
nvme0n1                                             119,2G
├─nvme0n1p1    1725-D2D0                              512M /boot/efi
├─nvme0n1p2    d3cc080c-0c3f-4191-a25d-7c419e00316a    40G /
├─nvme0n1p3    572b43a3-7690-4daa-beeb-d1c030f194e8    16G [SWAP]
└─nvme0n1p4    a3ed0098-36b4-46a6-8e38-efe9b9a94e52  62,8G <- bcache

The Btrfs filesystem is used for /home (one subvolume per user).

An error happened during the nightly backup on nvme0 (see below) and 
Btrfs went readonly. After reboot, it refused to mount.

I'm on Fedora-32 with kernel-5.9.7, and I compiled latest btrfs-progs:

[root@tiare btrfs-progs-5.9]# ./btrfs -v check  /dev/bcache0
Opening filesystem to check...
parent transid verify failed on 3010317451264 wanted 29647859 found 29647852
parent transid verify failed on 3010317451264 wanted 29647859 found 29647852
parent transid verify failed on 3010317451264 wanted 29647859 found 29647852
Ignoring transid failure
ERROR: could not setup extent tree
ERROR: cannot open file system

I have restored from backups on a different disk, but still, I would be 
interested in trying to restore the broken filesystem.

I have posted this message on Btrfs mailing list already. The advice was 
to seek for help here: what should I try? Detach both HDD from bcache? 
Create loopdev on both HDD with losetup -o 8192, then try to mount?


/var/log/messages :
Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 0 QID 5 timeout, aborting
Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 1 QID 5 timeout, aborting
Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 2 QID 5 timeout, aborting
Nov 11 00:24:28 tiare kernel: nvme nvme0: Abort status: 0x0
Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 3 QID 5 timeout, aborting
Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 4 QID 5 timeout, aborting
  ...
Nov 11 00:24:58 tiare kernel: nvme nvme0: I/O 0 QID 5 timeout, reset 
controller
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 153333328 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
IO error on reading from
  cache, recovering.
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 153333344 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
IO error on reading from cache, recovering.
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 153333384 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
IO error on reading from cache, recovering.
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 153333424 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
IO error on reading from cache, recovering.
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 153333464 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
IO error on reading from cache, recovering.
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 153333520 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
IO error on reading from cache, recovering.
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 142766872 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
IO error on reading from cache, recovering.
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 142766888 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: bcache: bch_cache_set_error() error on 
db563a68-d350-4eaf-978b-eee7095543c5: nvme0n1p4: too many IO errors 
reading from cache#012, disabling caching
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 142766912 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
nvme0n1, sector 142766936 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
class 0
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache1 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache1 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: bcache: conditional_stop_bcache_device() 
stop_when_cache_set_failed of bcache1 is "auto" and cache is dirty, stop 
it to avoid potential data corruption.
Nov 11 00:24:58 tiare kernel: bcache: conditional_stop_bcache_device() 
stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty, stop 
it to avoid potential data corruption.
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 3, rd 1, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 3, rd 2, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 3, rd 3, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 3, rd 4, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
/dev/bcache0 errs: wr 3, rd 5, flush 0, corrupt 0, gen 0
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
Read-ahead I/O failed on backing device, ignore
Nov 11 00:24:58 tiare kernel: nvme nvme0: 8/0/0 default/read/poll queues


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527


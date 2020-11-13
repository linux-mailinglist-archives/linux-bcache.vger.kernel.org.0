Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CE42B16F0
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Nov 2020 09:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgKMIEW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 Nov 2020 03:04:22 -0500
Received: from vostok.pvgoran.name ([71.19.149.48]:44823 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgKMIEW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Nov 2020 03:04:22 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2020 03:04:21 EST
Received: from [10.0.10.127] (l37-193-246-51.novotelecom.ru [::ffff:37.193.246.51])
  (AUTH: CRAM-MD5 main-collector@pvgoran.name, )
  by vostok.pvgoran.name with ESMTPSA
  id 0000000000165BBD.000000005FAE3CD5.0000047F; Fri, 13 Nov 2020 07:59:17 +0000
Date:   Fri, 13 Nov 2020 14:59:13 +0700
From:   Pavel Goran <via-bcache@pvgoran.name>
X-Mailer: The Bat! (v3.85.03) Professional
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
X-Priority: 3 (Normal)
Message-ID: <1854634128.20201113145913@pvgoran.name>
To:     Jean-Denis Girard <jd.girard@sysnux.pf>
CC:     linux-bcache@vger.kernel.org
Subject: Re: bcache error -> btrfs unmountable
In-Reply-To: <rokg8t$u8n$1@ciao.gmane.io>
References: <rokg8t$u8n$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Jean-Denis,

See comments inline.

Friday, November 13, 2020, 6:25:15 AM, you wrote:

> Hi list,

> I have a RAID1 Btrfs (on sdb and sdc) behind bcache (on nvme0n1p4):

What's the cache mode? Writeback, writethrough, writearound?

You can execute 'cat /sys/block/bcache0/bcache/cache_mode' and
'cat /sys/block/bcache1/bcache/cache_mode' to find out.

> [jdg@tiare ~]$  lsblk -o NAME,UUID,SIZE,MOUNTPOINT
> NAME           UUID                                   SIZE MOUNTPOINT
> sdb            8ae3c26b-6932-4dad-89bc-569ae2c74366   3,7T
> L-bcache1      c5b8386b-b81d-4473-9340-7b8a74fc3a3c   3,7T
> sdc            7ccac426-dc8c-4cb3-9e64-13b1cf48d4bf   3,7T
> L-bcache0      c5b8386b-b81d-4473-9340-7b8a74fc3a3c   3,7T
> nvme0n1                                             119,2G
> +-nvme0n1p1    1725-D2D0                              512M /boot/efi
> +-nvme0n1p2    d3cc080c-0c3f-4191-a25d-7c419e00316a    40G /
> +-nvme0n1p3    572b43a3-7690-4daa-beeb-d1c030f194e8    16G [SWAP]
> L-nvme0n1p4    a3ed0098-36b4-46a6-8e38-efe9b9a94e52  62,8G <- bcache

> The Btrfs filesystem is used for /home (one subvolume per user).

> An error happened during the nightly backup on nvme0 (see below) and 
> Btrfs went readonly. After reboot, it refused to mount.

> I'm on Fedora-32 with kernel-5.9.7, and I compiled latest btrfs-progs:

> [root@tiare btrfs-progs-5.9]# ./btrfs -v check  /dev/bcache0
> Opening filesystem to check...
> parent transid verify failed on 3010317451264 wanted 29647859 found 29647852
> parent transid verify failed on 3010317451264 wanted 29647859 found 29647852
> parent transid verify failed on 3010317451264 wanted 29647859 found 29647852
> Ignoring transid failure
> ERROR: could not setup extent tree
> ERROR: cannot open file system

> I have restored from backups on a different disk, but still, I would be 
> interested in trying to restore the broken filesystem.

> I have posted this message on Btrfs mailing list already. The advice was 
> to seek for help here: what should I try? Detach both HDD from bcache? 
> Create loopdev on both HDD with losetup -o 8192, then try to mount?

You could try to detach the *cache* from the bcache devices, and then try to
use the bcache devices as before; it should be possible and harmless,
*unless* the cache mode is "writeback". If it's "writeback", things are more
complicated, and I'll leave them to more experienced people around.

For instructions on how to detach the cache, see, for example,
https://unix.stackexchange.com/a/115808/82477 (it's just the first thing
that I found by googling, and it seems to match what I did when detaching
myself).

IMPORANT: The kernel logs below indicate that bcache failed to do IO on the
cache device. It could be a hardware problem with your NVMe device, so I
suggest you look at its SMART, ASAP.

> /var/log/messages :
> Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 0 QID 5 timeout, aborting
> Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 1 QID 5 timeout, aborting
> Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 2 QID 5 timeout, aborting
> Nov 11 00:24:28 tiare kernel: nvme nvme0: Abort status: 0x0
> Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 3 QID 5 timeout, aborting
> Nov 11 00:24:28 tiare kernel: nvme nvme0: I/O 4 QID 5 timeout, aborting
>   ...
> Nov 11 00:24:58 tiare kernel: nvme nvme0: I/O 0 QID 5 timeout, reset 
> controller
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 153333328 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
> IO error on reading from
>   cache, recovering.
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 153333344 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
> IO error on reading from cache, recovering.
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 153333384 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
> IO error on reading from cache, recovering.
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 153333424 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
> IO error on reading from cache, recovering.
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 153333464 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
> IO error on reading from cache, recovering.
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 153333520 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
> IO error on reading from cache, recovering.
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 142766872 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_io_errors() nvme0n1p4: 
> IO error on reading from cache, recovering.
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 142766888 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_cache_set_error() error on 
> db563a68-d350-4eaf-978b-eee7095543c5: nvme0n1p4: too many IO errors 
> reading from cache#012, disabling caching
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 142766912 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: blk_update_request: I/O error, dev 
> nvme0n1, sector 142766936 op 0x0:(READ) flags 0x80700 phys_seg 1 prio 
> class 0
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache1 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache1 errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: bcache: conditional_stop_bcache_device() 
> stop_when_cache_set_failed of bcache1 is "auto" and cache is dirty, stop 
> it to avoid potential data corruption.
> Nov 11 00:24:58 tiare kernel: bcache: conditional_stop_bcache_device() 
> stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty, stop 
> it to avoid potential data corruption.
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 3, rd 1, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 3, rd 2, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 3, rd 3, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 3, rd 4, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: BTRFS error (device bcache0): bdev 
> /dev/bcache0 errs: wr 3, rd 5, flush 0, corrupt 0, gen 0
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: bcache: bch_count_backing_io_errors() sdc: 
> Read-ahead I/O failed on backing device, ignore
> Nov 11 00:24:58 tiare kernel: nvme nvme0: 8/0/0 default/read/poll queues


> Thanks,



Pavel Goran
  


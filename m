Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3561A2E8848
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 20:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbhABTZH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Sat, 2 Jan 2021 14:25:07 -0500
Received: from mail.eclipso.de ([217.69.254.104]:34480 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbhABTZG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 14:25:06 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jan 2021 14:25:04 EST
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 77B0937B
        for <linux-bcache@vger.kernel.org>; Sat, 02 Jan 2021 20:18:42 +0100 (CET)
Date:   Sat, 02 Jan 2021 20:18:41 +0100
MIME-Version: 1.0
Message-ID: <f79735e98dbd8af70fbf59f8c2212ca4@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: make-bcache -B /dev/bcache0 fails, Can't stack bcache on top of bcache
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

­TLDR: I can't stack bcache on top of bcache, This command fails:
# make-bcache -B /dev/bcache0
Name			/dev/bcache0
Label			
Type			data
UUID:			758be840-f232-44dd-8e56-83fb55ba20ea
Set UUID:		ddbcc87b-d25d-483f-8874-49b80ba26472
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16
[ 5187.054662] sysfs: cannot create duplicate filename '/devices/virtual/block/bcache0/bcache'
[ 5187.054667] CPU: 2 PID: 567 Comm: bcache-register Not tainted 5.9.14-arch1-1 #1
[ 5187.054669] Hardware name: Hewlett-Packard HP Compaq 8200 Elite CMT PC/1494, BIOS J01 v02.28 03/24/2015
[ 5187.054670] Call Trace:
[ 5187.054681]  dump_stack+0x6b/0x83
[ 5187.054686]  sysfs_warn_dup.cold+0x17/0x24
[ 5187.054694]  sysfs_create_dir_ns+0xc6/0xe0
[ 5187.054699]  kobject_add_internal+0xab/0x2f0
[ 5187.054703]  kobject_add+0x98/0xd0
[ 5187.054707]  ? blk_queue_write_cache+0x2f/0x60
[ 5187.054723]  register_bdev+0x337/0x360 [bcache]
[ 5187.054735]  register_bcache+0x43c/0x910 [bcache]
[ 5187.054740]  ? kernfs_fop_write+0xce/0x1b0
[ 5187.054750]  ? register_cache+0x1290/0x1290 [bcache]
[ 5187.054753]  kernfs_fop_write+0xce/0x1b0
[ 5187.054756]  vfs_write+0xc7/0x210
[ 5187.054759]  ksys_write+0x67/0xe0
[ 5187.054763]  do_syscall_64+0x33/0x40
[ 5187.054766]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 5187.054769] RIP: 0033:0x7fbd1edb3f67
[ 5187.054772] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[ 5187.054774] RSP: 002b:00007fff335fa418 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 5187.054777] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007fbd1edb3f67
[ 5187.054778] RDX: 000000000000000d RSI: 0000562bf3f902a0 RDI: 0000000000000003
[ 5187.054780] RBP: 0000562bf3f902a0 R08: 00007fbd1ee4a040 R09: 00007fbd1ee4a0c0
[ 5187.054781] R10: 00007fbd1ee49fc0 R11: 0000000000000246 R12: 000000000000000d
[ 5187.054782] R13: 00007fff335fa4a0 R14: 000000000000000d R15: 00007fbd1ee86720
[ 5187.054787] kobject_add_internal failed for bcache with -EEXIST, don't try to register things with the same name in the same directory.
[ 5187.054789] bcache: register_bdev() error bcache0: error creating kobject
[ 5187.054794] bcache: register_bcache() error : failed to register device
[ 5187.054963] bcache: bcache_device_free() bcache3 stopped

(very) long version:

I want to create a silent and fast NAS. I want to keep the hard drives idle for as long as possible. Therefore I need flash memory as write cache, so the hard drives stay idle when the user writes a file. The write caches rarely get flushed into the drives, so they are dirty for a long time. Therefore each drive needs it's own write cache device, so btrfs can recreate the lost data when a device fails. The read cache can be shared across all drives, as all the data in it also exists in the devices under it, so failure of the read cache does not result in data loss.

I'm testing this on a single drive with a lot of partitions. This kills performance (and fault tolerance). In production, each partition will be on a different drive.

+--------------------------------------------+
|         btrfs raid 1 (2 copies) /mnt       |
+--------------+--------------+--------------+
| /dev/bcache3 | /dev/bcache4 | /dev/bcache5 |
+--------------+--------------+--------------+
|              Read Cache (SSD)              |
|                /dev/sda4                   |
+--------------+--------------+--------------+
| /dev/bcache0 | /dev/bcache1 | /dev/bcache2 |
+--------------+--------------+--------------+
| Write Cache  | Write Cache  | Write Cache  |
|(Flash Drive) |(Flash Drive) |(Flash Drive) |
| /dev/sda5    | /dev/sda6    | /dev/sda7    |
+--------------+--------------+--------------+
| Data         | Data         | Data         |
| /dev/sda8    | /dev/sda9    | /dev/sda10   |
+--------------+--------------+--------------+
0. make the partitions on the drive:
# fdisk -l
/dev/sda1            2048   6293503   6291456     3G 83 Linux
/dev/sda2         6293504  14682111   8388608     4G 83 Linux
/dev/sda3        14682112  25167871  10485760     5G 83 Linux
/dev/sda4        25167872 976773167 951605296 453.8G  5 Extended
/dev/sda5        25169920  37752831  12582912     6G 83 Linux
/dev/sda6        37754880  52434943  14680064     7G 83 Linux
/dev/sda7        52436992  69214207  16777216     8G 83 Linux
/dev/sda8        69216256  88090623  18874368     9G 83 Linux
/dev/sda9        88092672 109064191  20971520    10G 83 Linux
/dev/sda10      109066240 132134911  23068672    11G 83 Linux

Wipe the partitions:
[root@bcache-test cedric]# wipefs -a /dev/sda5
[root@bcache-test cedric]# wipefs -a /dev/sda6
[root@bcache-test cedric]# wipefs -a /dev/sda7
[root@bcache-test cedric]# wipefs -a /dev/sda8
[root@bcache-test cedric]# wipefs -a /dev/sda9
[root@bcache-test cedric]# wipefs -a /dev/sda10

Check for old bcache devices:
# ls /dev/bca*
ls: cannot access '/dev/bca*': No such file or directory

1. Format the backing devices:
root@bcache-test cedric]# make-bcache -B /dev/sda8
Name			/dev/sda8
Label			
Type			data
UUID:			3bae90e9-d2c5-4d62-96a8-07dc1cb1440d
Set UUID:		271e657c-2a3a-417e-9a8d-430129095a47
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16
[ 4196.603418] bcache: register_bdev() registered backing device sda8

# make-bcache -B /dev/sda9
Name			/dev/sda9
Label			
Type			data
UUID:			28ce8fa5-6918-4637-b612-374cf75635c2
Set UUID:		c12faa51-6042-4b46-8448-ee4a5acd0e8e
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16
[ 4269.009004] bcache: register_bdev() registered backing device sda9

[root@bcache-test cedric]# make-bcache -B /dev/sda10
Name			/dev/sda10
Label			
Type			data
UUID:			4bca4225-4143-41af-b0e2-2ca2700e4931
Set UUID:		5442ccbe-6f12-40df-a309-30f66191773f
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16
[ 4285.151623] bcache: register_bdev() registered backing device sda10

Now 3 bcache devices are created:
[root@bcache-test cedric]# ls -l /dev/bca*
brw-rw---- 1 root disk 254,   0 Jan  2 20:46 /dev/bcache0
brw-rw---- 1 root disk 254, 128 Jan  2 20:47 /dev/bcache1
brw-rw---- 1 root disk 254, 256 Jan  2 20:47 /dev/bcache2

/dev/bcache:
total 0
drwxr-xr-x 2 root root 100 Jan  2 20:47 by-uuid

2. Format the cache devices:
[root@bcache-test cedric]# make-bcache -C /dev/sda5
Name			/dev/sda5
Label			
Type			cache
UUID:			6e7610b2-5f28-4699-aed0-ffd78c1db77d
Set UUID:		924e51c2-9b49-4802-b87f-b379cd9a06a6
version:		0
nbuckets:		12288
block_size_in_sectors:	1
bucket_size_in_sectors:	1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
[ 4505.224494] bcache: run_cache_set() invalidating existing data
[ 4505.265255] bcache: register_cache() registered cache device sda5

[root@bcache-test cedric]# make-bcache -C /dev/sda6
Name			/dev/sda6
Label			
Type			cache
UUID:			4ff65c49-e225-4975-aac1-1be7da22d434
Set UUID:		ab10dafe-e8a4-4aa9-89f7-1a0575659f06
version:		0
nbuckets:		14336
block_size_in_sectors:	1
bucket_size_in_sectors:	1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
[ 4558.676081] bcache: run_cache_set() invalidating existing data
[ 4558.724051] bcache: register_cache() registered cache device sda6

[root@bcache-test cedric]# make-bcache -C /dev/sda7
Name			/dev/sda7
Label			
Type			cache
UUID:			02d4fe5e-5c01-4c94-9e89-3a97b01118b2
Set UUID:		31350209-3c13-4e78-b782-2c16e9d52e6a
version:		0
nbuckets:		16384
block_size_in_sectors:	1
bucket_size_in_sectors:	1024
nr_in_set:		1
nr_this_dev:		0
first_bucket:		1
[ 4583.036101] bcache: run_cache_set() invalidating existing data
[ 4583.077035] bcache: register_cache() registered cache device sda7

Register the cache devices against the backing devices.
# echo 924e51c2-9b49-4802-b87f-b379cd9a06a6 > /sys/block/bcache0/bcache/attach
[ 5008.251480] bcache: bch_cached_dev_run() cached dev sda8 is running already
[ 5008.251500] bcache: bch_cached_dev_attach() Caching sda8 as bcache0 on set 924e51c2-9b49-4802-b87f-b379cd9a06a6
# echo ab10dafe-e8a4-4aa9-89f7-1a0575659f06 > /sys/block/bcache1/bcache/attach
[ 5037.562635] bcache: bch_cached_dev_run() cached dev sda9 is running already
[ 5037.562648] bcache: bch_cached_dev_attach() Caching sda9 as bcache1 on set ab10dafe-e8a4-4aa9-89f7-1a0575659f06
# echo 31350209-3c13-4e78-b782-2c16e9d52e6a > /sys/block/bcache2/bcache/attach
[ 5061.280096] bcache: bch_cached_dev_run() cached dev sda10 is running already
[ 5061.280110] bcache: bch_cached_dev_attach() Caching sda10 as bcache2 on set 31350209-3c13-4e78-b782-2c16e9d52e6a
 
Format /dev/bcache0 as backing devices for the read cache fails:
make-bcache -B /dev/bcache0
# make-bcache -B /dev/bcache0
Name			/dev/bcache0
Label			
Type			data
UUID:			758be840-f232-44dd-8e56-83fb55ba20ea
Set UUID:		ddbcc87b-d25d-483f-8874-49b80ba26472
version:		1
block_size_in_sectors:	1
data_offset_in_sectors:	16
[ 5187.054662] sysfs: cannot create duplicate filename '/devices/virtual/block/bcache0/bcache'
[ 5187.054667] CPU: 2 PID: 567 Comm: bcache-register Not tainted 5.9.14-arch1-1 #1
[ 5187.054669] Hardware name: Hewlett-Packard HP Compaq 8200 Elite CMT PC/1494, BIOS J01 v02.28 03/24/2015
[ 5187.054670] Call Trace:
[ 5187.054681]  dump_stack+0x6b/0x83
[ 5187.054686]  sysfs_warn_dup.cold+0x17/0x24
[ 5187.054694]  sysfs_create_dir_ns+0xc6/0xe0
[ 5187.054699]  kobject_add_internal+0xab/0x2f0
[ 5187.054703]  kobject_add+0x98/0xd0
[ 5187.054707]  ? blk_queue_write_cache+0x2f/0x60
[ 5187.054723]  register_bdev+0x337/0x360 [bcache]
[ 5187.054735]  register_bcache+0x43c/0x910 [bcache]
[ 5187.054740]  ? kernfs_fop_write+0xce/0x1b0
[ 5187.054750]  ? register_cache+0x1290/0x1290 [bcache]
[ 5187.054753]  kernfs_fop_write+0xce/0x1b0
[ 5187.054756]  vfs_write+0xc7/0x210
[ 5187.054759]  ksys_write+0x67/0xe0
[ 5187.054763]  do_syscall_64+0x33/0x40
[ 5187.054766]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 5187.054769] RIP: 0033:0x7fbd1edb3f67
[ 5187.054772] Code: 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[ 5187.054774] RSP: 002b:00007fff335fa418 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 5187.054777] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007fbd1edb3f67
[ 5187.054778] RDX: 000000000000000d RSI: 0000562bf3f902a0 RDI: 0000000000000003
[ 5187.054780] RBP: 0000562bf3f902a0 R08: 00007fbd1ee4a040 R09: 00007fbd1ee4a0c0
[ 5187.054781] R10: 00007fbd1ee49fc0 R11: 0000000000000246 R12: 000000000000000d
[ 5187.054782] R13: 00007fff335fa4a0 R14: 000000000000000d R15: 00007fbd1ee86720
[ 5187.054787] kobject_add_internal failed for bcache with -EEXIST, don't try to register things with the same name in the same directory.
[ 5187.054789] bcache: register_bdev() error bcache0: error creating kobject
[ 5187.054794] bcache: register_bcache() error : failed to register device
[ 5187.054963] bcache: bcache_device_free() bcache3 stopped

I expected this command to create /dev/bcache3

My versions:
# uname -a
Linux bcache-test 5.9.14-arch1-1 #1 SMP PREEMPT Sat, 12 Dec 2020 14:37:12 +0000 x86_64 GNU/Linux
# pacman -Q bcache-tools
bcache-tools 1.1-1

I've used this guide for inspiration:
https://wiki.archlinux.org/index.php/Bcache



---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!



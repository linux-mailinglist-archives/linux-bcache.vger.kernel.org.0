Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4EF2E884E
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 20:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbhABTi5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Sat, 2 Jan 2021 14:38:57 -0500
Received: from mail.eclipso.de ([217.69.254.104]:55754 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbhABTi5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 14:38:57 -0500
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 1EB83D52
        for <linux-bcache@vger.kernel.org>; Sat, 02 Jan 2021 20:38:15 +0100 (CET)
Date:   Sat, 02 Jan 2021 20:38:15 +0100
MIME-Version: 1.0
Message-ID: <b8b1e5a4b32bc064ccaca8d8e2024a2a@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: make-bcache -B /dev/bcache0 fails, Can't stack bcache on top of bcache
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     ",  linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

­I can't stack bcache on top of bcache, This command fails:
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

I expected this command to create a new /dev/bcacheX node. Instead it tries to overwrite /devices/virtual/block/bcache0/bcache

My versions:
# uname -a
Linux bcache-test 5.9.14-arch1-1 #1 SMP PREEMPT Sat, 12 Dec 2020 14:37:12 +0000 x86_64 GNU/Linux
# pacman -Q bcache-tools
bcache-tools 1.1-1

I've used this guide for inspiration:
https://wiki.archlinux.org/index.php/Bcache


---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!



Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883CC20943
	for <lists+linux-bcache@lfdr.de>; Thu, 16 May 2019 16:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfEPOMW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 May 2019 10:12:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:40536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726909AbfEPOMW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 May 2019 10:12:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 27F7EAC23;
        Thu, 16 May 2019 14:12:20 +0000 (UTC)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Pierre JUHEN <pierre.juhen@orange.fr>, kent.overstreet@gmail.com
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
Date:   Thu, 16 May 2019 22:12:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/13 1:11 上午, Coly Li wrote:
> On 2019/5/12 1:30 上午, Pierre JUHEN wrote:
>> Hi,
>>
>> I use bcache extensively on 3 PC, and I lost data on 2 of them after an
>> attempt to migrate to Fedora 30.
>>
>> My configuration is almost the same on the 3 PCs :
>>
>> /boot/efi and /boot are native on the SSD, and there is a bache frontend.
>>
>> bcache backend is on a HDD or on a raid1 array.
>>
>> bcache device is the physical volume of an LVM volume group.
>>
>> Here is how to reproduce the problem :
>>
>> 1/ Create the storage configuration as explained above.
>>
>> 2/ Install Fedora 29 on a logical volume (ext4) and a swap logical volume.
>>
>> 3/ Update the installation (dnf update --refresh)
>>
>> 4/ Migrate to Fedora 30 in download mode (dnf system-upgrade
>> --releasever=30 --allowerasing donwnload, then dnf system-upgrade reboot)
>>
>> 5/ try to prevent automatic reboot in Fedora 30 (for example in
>> commenting out /boot/efi in /etc/fstab)
>>
>> 6/ reboot using Fedora 29 kernel and initramfs -> Everything is fine
>>
>> 7/ reboot using Fedora 30 kernel and initramfs -> Everything is
>> corrupted, even unmounted volumes of the volume group
>>
>> I did the test case twice, the second time in downgrading bcache-tools
>> to Fedora 29 -> same issue
>>
>> This means that's the problem is located in the bcache kernel module ;
>> but since I guess it's the same code, the problem is probably linked to
>> the building environment (gcc version ?)
>>
>> I reported the bug : https://bugzilla.redhat.com/show_bug.cgi?id=1707822
>>
>> But I thought it was not a kernel problem.
> 
> On my development machine the GCC is still v7.3.1, for now I don't know
> how to upgrade to GCC 9.1 yet.
> 
> From the dmesg.lis file, it seems fc30 uses 5.0.11-300, so what is the
> kernel version of fc29 ?
> 
> (And from dmesg.lis I don't see anything suspicious on bcache message,
> no clue yet).

Such problem is very easy to produce, only a few sequential I/Os may
trigger a panic from bch_btree_iter_next_check().

Here is content of my fio script,
[global]
lockmem=1
direct=1
ioengine=psync

[job1]
filename=/dev/bcache0
readwrite=write
blocksize=4k
iodepth=1
numjobs=1
io_size=64K

In my observation, 2 sequential I/Os may trigger this panic. Here is the
kernel output when panic in bch_btree_iter_next_check() triggered,

[  153.478620] bcache: bch_dump_bset() block 1 key 0/9:
[  153.478621] bcache: bch_bkey_dump()  0x0:0x10 len 0x8 -> [check dev]
[  153.478623] bcache: bch_bkey_dump()  bucket 7560168717
[  153.478624] bcache: bch_bkey_dump()
[  153.478624]
[  153.478625] bcache: bch_dump_bset() block 1 key 3/9:
[  153.478626] bcache: bch_bkey_dump()  0x0:0x18 len 0x8 -> [check dev]
[  153.478627] bcache: bch_bkey_dump()  bucket 4400861924
[  153.478628] bcache: bch_bkey_dump()
[  153.478628]
[  153.478629] bcache: bch_dump_bset() Key skipped backwards
[  153.478629]
[  153.478630] bcache: bch_dump_bset() block 1 key 6/9:
[  153.478631] bcache: bch_bkey_dump()  0x0:0x10 len 0x8 -> [0:392192
gen 1] dirty
[  153.478632] bcache: bch_bkey_dump()  bucket 383
[  153.478635] bcache: bch_bkey_dump()
[  153.478635]
[  153.532890] Kernel panic - not syncing: Key skipped backwards
[  153.535924] CPU: 0 PID: 790 Comm: bcache_writebac Tainted: G        W
        5.1.0+ #3
[  153.539656] Hardware name: VMware, Inc. VMware Virtual Platform/440BX
Desktop Reference Platform, BIOS 6.00 04/13/2018
[  153.545002] Call Trace:
[  153.546702]  dump_stack+0x85/0xc0
[  153.548675]  panic+0x106/0x2da
[  153.550560]  ? bch_ptr_invalid+0x10/0x10 [bcache]
[  153.553178]  bch_btree_iter_next_filter.cold+0xff/0x12e [bcache]
[  153.556117]  ? btree_insert_key+0x190/0x190 [bcache]
[  153.558646]  bch_btree_map_keys_recurse+0x5c/0x190 [bcache]
[  153.561557]  bch_btree_map_keys+0x177/0x1a0 [bcache]
[  153.564085]  ? btree_insert_key+0x190/0x190 [bcache]
[  153.566688]  ? dirty_init+0x80/0x80 [bcache]
[  153.569224]  bch_refill_keybuf+0xcc/0x290 [bcache]
[  153.571609]  ? finish_wait+0x90/0x90
[  153.573525]  ? dirty_init+0x80/0x80 [bcache]
[  153.575705]  bch_writeback_thread+0x3b9/0x5c0 [bcache]
[  153.578527]  ? __kthread_parkme+0x58/0x80
[  153.580662]  kthread+0x108/0x140
[  153.582541]  ? read_dirty+0x620/0x620 [bcache]
[  153.584998]  ? kthread_park+0x90/0x90
[  153.586991]  ret_from_fork+0x3a/0x50
[  153.589236] Kernel Offset: 0x12000000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  153.594868] ---[ end Kernel panic - not syncing: Key skipped
backwards ]---

The panic happens in bch_writeback context, because bkeys in btree node
is not in linear increasing order. Adjacent two sequential write
requests is very common condition in bcache, such corrupted btree node
is not reported in recent 2~3 years. Unless the kernel is compiled with
gcc9...

It is not clear to me why the key 0:0x10 appears in same btree node
twice, and why there are 3 keys for two 4K write requests.

If anyone may have any clue, please offer. Now I continue to check how
this happens.

Thanks.

-- 

Coly Li

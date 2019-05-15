Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE061F840
	for <lists+linux-bcache@lfdr.de>; Wed, 15 May 2019 18:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfEOQLF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 May 2019 12:11:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:36324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfEOQLF (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 May 2019 12:11:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80679AB98;
        Wed, 15 May 2019 16:11:03 +0000 (UTC)
Subject: Re: Kernel bug message when registering cache devices
To:     Jordan Patterson <jordanp@gmail.com>
References: <CAHDOzW4gegWc8sM-gS9Ddnsbm1dhMUuHcwjuWP10fdxXwQ1OkA@mail.gmail.com>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <aba0a684-383a-eb7a-a00d-036f5ec804bc@suse.de>
Date:   Thu, 16 May 2019 00:10:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAHDOzW4gegWc8sM-gS9Ddnsbm1dhMUuHcwjuWP10fdxXwQ1OkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/8 12:08 上午, Jordan Patterson wrote:
> Hi:
> 
> I upgraded my kernel to 5.1 yesterday and after about an hour, I got
> some messages about timeouts on bcache_writeback.  After rebooting, I
> get a kernel bug message when the init tries to register my cache
> devices.  My setup consists of 4 bcache devices, each with a 6TB hard
> drive for the backing device and 800GB ssd for the cache device.
> 

[snipped]

> 
> The kernel bug message when trying to reload after reboot (booting
> from a USB key so I could get the log to a file):
> 
> [  241.374514] kernel BUG at drivers/md/bcache/extents.c:294!
> [  241.374520] invalid opcode: 0000 [#1] SMP PTI
> [  241.374523] CPU: 1 PID: 12951 Comm: bash Tainted: P           O
>  4.19.27-gentoo-r1 #1
> [  241.374523] Hardware name: Supermicro X9DAi/X9DAi, BIOS 3.3 07/12/2018
> [  241.374529] RIP: 0010:bch_extent_sort_fixup+0x293/0x49d [bcache]
> [  241.374531] Code: 4c 8b 48 08 4d 89 d0 49 c1 e8 14 45 0f b7 c0 4d
> 89 ce 4d 29 c6 48 39 d1 74 0b 49 89 ce 49 29 d6 4c 89 f2 eb 0d 4d 39
> f3 75 02 <0f> 0b 48 89 fa 4c 29 ca 48 85 d2 0f 89 6e 01 00 00 4c 89 d2
> 48 89
> [  241.374532] RSP: 0018:ffffc900098b39a8 EFLAGS: 00010246
> [  241.374533] RAX: ffff88882bba75a8 RBX: ffff88885c633000 RCX: 0000000000000000
> [  241.374534] RDX: 0000000000000000 RSI: ffff88882bba8200 RDI: 0000000048044e58
> [  241.374535] RBP: ffffc900098b3a08 R08: 0000000000000040 R09: 0000000048044e88
> [  241.374536] R10: 9000001004000000 R11: 0000000048044e48 R12: ffffc900098b3a48
> [  241.374536] R13: ffff88885c633020 R14: 0000000048044e48 R15: 0000000000000004
> [  241.374538] FS:  00007fe781406740(0000) GS:ffff88887fc40000(0000)
> knlGS:0000000000000000
> [  241.374538] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  241.374539] CR2: 00005590ae11fe08 CR3: 000000085e206002 CR4: 00000000000606e0
> [  241.374540] Call Trace:
> [  241.374546]  ? bch_ptr_status+0x127/0x127 [bcache]
> [  241.374548]  btree_mergesort+0x161/0x46b [bcache]
> [  241.374551]  ? bch_cache_allocator_start+0x3d/0x3d [bcache]
> [  241.374554]  __btree_sort+0xaf/0x19c [bcache]
> [  241.374557]  bch_btree_node_read_done+0x20f/0x363 [bcache]
> [  241.374560]  bch_btree_node_read+0x14e/0x184 [bcache]
> [  241.374563]  ? __closure_wake_up+0x31/0x31 [bcache]
> [  241.374566]  bch_btree_check_recurse+0x116/0x1e0 [bcache]
> [  241.374569]  ? bch_extent_to_text+0xec/0x14c [bcache]
> [  241.374572]  bch_btree_check+0xd3/0x14e [bcache]
> [  241.374575]  ? wait_woken+0x68/0x68
> [  241.374578]  run_cache_set+0x328/0x730 [bcache]
> [  241.374582]  register_bcache+0x1290/0x1438 [bcache]
> [  241.374586]  kernfs_fop_write+0xf4/0x136
> [  241.374590]  __vfs_write+0x2e/0x13c
> [  241.374592]  ? __alloc_fd+0x91/0x147
> [  241.374594]  ? set_close_on_exec+0x25/0x50
> [  241.374595]  vfs_write+0xc3/0x166
> [  241.374596]  ksys_write+0x58/0xa6
> [  241.374599]  do_syscall_64+0x57/0xe6
> [  241.374603]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  241.374605] RIP: 0033:0x7fe78155cbf8
> [  241.374606] Code: 00 90 48 83 ec 38 64 48 8b 04 25 28 00 00 00 48
> 89 44 24 28 31 c0 48 8d 05 e5 7a 0d 00 8b 00 85 c0 75 27 b8 01 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 60 48 8b 4c 24 28 64 48 33 0c 25 28 00
> 00 00
> [  241.374607] RSP: 002b:00007ffcdca34870 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000001
> [  241.374608] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007fe78155cbf8
> [  241.374609] RDX: 0000000000000009 RSI: 00005590ae915940 RDI: 0000000000000001
> [  241.374609] RBP: 00005590ae915940 R08: 00005590ae943550 R09: 000000000000000a
> [  241.374610] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe781630760
> [  241.374611] R13: 0000000000000009 R14: 00007fe78162b760 R15: 0000000000000009
> [  241.374612] Modules linked in: bcache crc64 ipv6 cfg80211 rfkill


Yes, now I am to reproduce this problem too. After enable bcache debug,
I can trigger a kernel panic when making filesystem on top of a bcache
device.

It seems when bcache code is compiled with gcc9, the bkey in a btree
node is corrupted. Now I see some bkeys are not linear increasing in
btree node, or its KEY_PTRS field is empty.

This is strange, which is never happened before. Let me check why ....

Thanks.

-- 

Coly Li

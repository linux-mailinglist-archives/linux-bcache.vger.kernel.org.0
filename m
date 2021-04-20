Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13731365D09
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Apr 2021 18:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhDTQPV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Apr 2021 12:15:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:36892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233168AbhDTQPK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Apr 2021 12:15:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 02E39B2EA;
        Tue, 20 Apr 2021 16:14:38 +0000 (UTC)
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
To:     Victor Westerhuis <victor@westerhu.is>
References: <f8a8d65a-8579-eccb-ddf1-33a2196ea83b@westerhu.is>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <210bc2f6-32c6-be3e-1c9a-40f635ba4580@suse.de>
Date:   Wed, 21 Apr 2021 00:14:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <f8a8d65a-8579-eccb-ddf1-33a2196ea83b@westerhu.is>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/20/21 10:54 PM, Victor Westerhuis wrote:
> Hi all!
> 
> Today I tried using bcache for the first time, but after a few minutes
> all accesses to my new bcache filesystem started hanging.
> 
> Looking in dmesg I found the following Oops:
> [  533.649096] kernel BUG at block/bio.c:52!
> [  533.649107] invalid opcode: 0000 [#1] SMP PTI
> [  533.649111] CPU: 3 PID: 1161 Comm: transmission-qt Not tainted
> 5.12.0-rc8-personal #1
> [  533.649115] Hardware name: LENOVO 20354/Lancer 5A5, BIOS 9BCN91WW
> 07/21/2015
> [  533.649117] RIP: 0010:biovec_slab.part.0+0x5/0x10
> [  533.649128] Code: 82 00 48 8b 7b f0 48 85 ff 74 e1 48 8b 07 48 89 43
> f0 48 85 c0 75 ce 48 c7 43 f8 00 00 00 00 eb c4 5b 5d c3 90 0f 1f 44 00
> 00 <0f> 0b 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 83 7f 40 00 75
> [  533.649132] RSP: 0018:ffffbc0cc3337950 EFLAGS: 00010206
> [  533.649136] RAX: 000000000000017f RBX: ffffbc0cc3337984 RCX:
> 0000000000000100
> [  533.649139] RDX: 0000000000000800 RSI: ffffbc0cc3337984 RDI:
> ffffa015d5300118
> [  533.649141] RBP: 0000000000000800 R08: ffffa015d5300118 R09:
> ffffa015222d8d00
> [  533.649143] R10: ffffa015d47d38f0 R11: 9000000002800000 R12:
> ffffa015d5300118
> [  533.649145] R13: 0000000000000800 R14: ffffa015d53000d0 R15:
> 0000000000000800
> [  533.649148] FS:  00007f68dab79700(0000) GS:ffffa01707380000(0000)
> knlGS:0000000000000000
> [  533.649151] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  533.649153] CR2: 00007f84340df020 CR3: 0000000145538006 CR4:
> 00000000001706e0
> [  533.649155] Call Trace:
> [  533.649158]  bvec_alloc+0x90/0xc0
> [  533.649166]  bio_alloc_bioset+0x130/0x1d0
> [  533.649172]  cached_dev_cache_miss+0x100/0x300 [bcache]
> [  533.649202]  cache_lookup_fn+0x119/0x300 [bcache]
> [  533.649222]  ? bch_btree_iter_next_filter+0x1b0/0x2c0 [bcache]
> [  533.649239]  ? bch_data_invalidate+0x160/0x160 [bcache]
> [  533.649258]  bch_btree_map_keys_recurse+0x7e/0x180 [bcache]
> [  533.649277]  ? mempool_alloc+0x62/0x170
> [  533.649283]  bch_btree_map_keys+0x15c/0x1b0 [bcache]
> [  533.649301]  ? bch_data_invalidate+0x160/0x160 [bcache]
> [  533.649321]  cache_lookup+0x8a/0x140 [bcache]
> [  533.649340]  cached_dev_submit_bio+0x964/0xc90 [bcache]
> [  533.649361]  ? submit_bio_checks+0x1a2/0x570
> [  533.649366]  ? mempool_alloc+0x62/0x170
> [  533.649371]  submit_bio_noacct+0x122/0x4f0
> [  533.649376]  ext4_mpage_readpages+0x1e0/0x8d0 [ext4]
> [  533.649420]  ? __mod_memcg_lruvec_state+0x22/0xe0
> [  533.649424]  ? __add_to_page_cache_locked+0x18f/0x370
> [  533.649429]  read_pages+0x82/0x1e0
> [  533.649433]  page_cache_ra_unbounded+0x197/0x1e0
> [  533.649438]  force_page_cache_ra+0xda/0x140
> [  533.649442]  generic_fadvise+0x190/0x280
> [  533.649448]  __x64_sys_fadvise64+0x7c/0x90
> [  533.649453]  do_syscall_64+0x33/0x40
> [  533.649458]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  533.649463] RIP: 0033:0x7f68eeab954a
> [  533.649467] Code: ff eb 80 0f 1f 44 00 00 48 8b 15 41 a9 0c 00 f7 d8
> 64 89 02 b8 ff ff ff ff eb c3 e8 e0 a0 01 00 41 89 ca b8 dd 00 00 00 0f
> 05 <89> c2 f7 da 3d 00 f0 ff ff b8 00 00 00 00 0f 47 c2 c3 0f 1f 40 00
> [  533.649470] RSP: 002b:00007f68dab787f8 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000dd
> [  533.649474] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
> 00007f68eeab954a
> [  533.649477] RDX: 0000000000800000 RSI: 0000000038ff17a8 RDI:
> 0000000000000028
> [  533.649479] RBP: 0000000000000000 R08: 0000000000000003 R09:
> 0000000000000003
> [  533.649481] R10: 0000000000000003 R11: 0000000000000246 R12:
> 0000000000000001
> [  533.649483] R13: 0000000000000001 R14: 00007f68c434aaf8 R15:
> 00007f68c42dd950
> [  533.649488] Modules linked in: des_generic libdes sha1_ssse3
> sha1_generic md5 md4 bcache crc64 hid_generic usbhid ext4 crc32c_generic
> mbcache jbd2 pkcs8_key_parser fuse
> [  533.649506] ---[ end trace 4d34ff6f2d05924c ]---
> [  533.649509] RIP: 0010:biovec_slab.part.0+0x5/0x10
> [  533.649515] Code: 82 00 48 8b 7b f0 48 85 ff 74 e1 48 8b 07 48 89 43
> f0 48 85 c0 75 ce 48 c7 43 f8 00 00 00 00 eb c4 5b 5d c3 90 0f 1f 44 00
> 00 <0f> 0b 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 83 7f 40 00 75
> [  533.649518] RSP: 0018:ffffbc0cc3337950 EFLAGS: 00010206
> [  533.649522] RAX: 000000000000017f RBX: ffffbc0cc3337984 RCX:
> 0000000000000100
> [  533.649524] RDX: 0000000000000800 RSI: ffffbc0cc3337984 RDI:
> ffffa015d5300118
> [  533.649526] RBP: 0000000000000800 R08: ffffa015d5300118 R09:
> ffffa015222d8d00
> [  533.649528] R10: ffffa015d47d38f0 R11: 9000000002800000 R12:
> ffffa015d5300118
> [  533.649531] R13: 0000000000000800 R14: ffffa015d53000d0 R15:
> 0000000000000800
> [  533.649533] FS:  00007f68dab79700(0000) GS:ffffa01707380000(0000)
> knlGS:0000000000000000
> [  533.649536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  533.649539] CR2: 00007f84340df020 CR3: 0000000145538006 CR4:
> 00000000001706e0
> 
> I've traced the error back to  drivers/md/bcache/request.c:919, but I
> don't know the code well enough to trace it any further. It appears to
> me that bcache tries to allocate an invalid amount of memory, but like
> I said, I'm not sure what is going on exactly.
> 
> The problem hasn't appeared yet when running 5.11.15.

Could you please help to apply a debug patch and gather some debug
information when it reproduces ?

Thanks.

Coly Li

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C4866DE62
	for <lists+linux-bcache@lfdr.de>; Tue, 17 Jan 2023 14:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbjAQNIQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 17 Jan 2023 08:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbjAQNIP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 17 Jan 2023 08:08:15 -0500
Received: from smtp.smtpout.orange.fr (smtp-19.smtpout.orange.fr [80.12.242.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E84032E67
        for <linux-bcache@vger.kernel.org>; Tue, 17 Jan 2023 05:08:13 -0800 (PST)
Received: from [192.168.1.7] ([82.125.227.6])
        by smtp.orange.fr with ESMTPA
        id HlhEp8jiJnvraHlhEp54eK; Tue, 17 Jan 2023 14:08:12 +0100
X-ME-Helo: [192.168.1.7]
X-ME-Auth: cGllcnJlLmp1aGVuQG9yYW5nZS5mcg==
X-ME-Date: Tue, 17 Jan 2023 14:08:12 +0100
X-ME-IP: 82.125.227.6
Message-ID: <c63dc204-13c1-6e3a-3c93-5c5f3dd9271f@orange.fr>
Date:   Tue, 17 Jan 2023 14:08:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Pierre Juhen <pierre.juhen@orange.fr>
Subject: Error messages with kernel 6.1.[56]
To:     linux-bcache@vger.kernel.org
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
Content-Language: fr, en-GB, en-US
In-Reply-To: <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi bcache-list,

I wish you all the best for 2023.

I use fedora (36 for the moment).

Since the migration to 6.1 kernel, I get the following messages at boot 
time :

    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 264) of single field "&i->j" at
    drivers/md/bcache/journal.c:152 (size 240)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 650 at
    drivers/md/bcache/journal.c:152 journal_read_bucket+0x3d0/0x480 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in:
    bcachefjes(-) raid0 crct10dif_pclmul crc32_pclmul crc32c_intel
    polyval_clmulni polyval_generic nvme ghash_clmulni_intel
    sha512_ssse3 nvme_core sp5100_>
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 650 Comm:
    bcache-register Not tainted 6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:journal_read_bucket+0x3d0/0x480 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ? bch_btree_exit+0x20/0x20
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_journal_read+0x69/0x2f0
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      register_bcache+0x12c9/0x1bf0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field "&b->key" at
    drivers/md/bcache/btree.c:939 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 650 at
    drivers/md/bcache/btree.c:939 mca_alloc+0x421/0x4c0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: raid1
    fjes(-) bcacheraid0 crct10dif_pclmul crc32_pclmul crc32c_intel
    polyval_clmulni polyval_generic nvme ghash_clmulni_intel
    sha512_ssse3 nvme_core s>
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 650 Comm:
    bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:mca_alloc+0x421/0x4c0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_node_get.part.0+0x109/0x2b0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      register_bcache+0x16ed/0x1bf0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field "&c->uuid_bucket" at
    drivers/md/bcache/super.c:465 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 650 at
    drivers/md/bcache/super.c:465 register_bcache+0x1b39/0x1bf0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: raid1
    fjes(-) bcacheraid0 crct10dif_pclmul crc32_pclmul crc32c_intel
    polyval_clmulni polyval_generic nvme ghash_clmulni_intel
    sha512_ssse3 nvme_core s>
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 650 Comm:
    bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:register_bcache+0x1b39/0x1bf0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field "&temp.key" at
    drivers/md/bcache/extents.c:428 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 9 PID: 650 at
    drivers/md/bcache/extents.c:428 bch_extent_insert_fixup+0x54e/0x560
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
    hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
    crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
    ghash_clmulni_intel sh>
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 9 PID: 650 Comm:
    bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:bch_extent_insert_fixup+0x54e/0x560 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_insert_key+0xc5/0x260 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  btree_insert_key+0x4c/0xd0
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_insert_keys+0x3e/0x290 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    __bch_btree_ptr_invalid+0x5b/0xc0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_insert_node+0x143/0x3a0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_insert_check_key+0x150/0x150 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  btree_insert_fn+0x20/0x40
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_map_nodes_recurse+0xf0/0x170 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      __bch_btree_map_nodes+0x1dd/0x1f0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_insert_check_key+0x150/0x150 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_btree_insert+0xcd/0x110
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_journal_replay+0xe6/0x1f0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      register_bcache+0x1918/0x1bf0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field "&k.key" at
    drivers/md/bcache/btree.c:371 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 9 PID: 650 at
    drivers/md/bcache/btree.c:371 __bch_btree_node_write+0x59d/0x5d0
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
    hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
    crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
    ghash_clmulni_intel sh>
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 9 PID: 650 Comm:
    bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:__bch_btree_node_write+0x59d/0x5d0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_insert_keys+0x48/0x290 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_insert_node+0x32b/0x3a0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_insert_check_key+0x150/0x150 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  btree_insert_fn+0x20/0x40
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_map_nodes_recurse+0xf0/0x170 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      __bch_btree_map_nodes+0x1dd/0x1f0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_insert_check_key+0x150/0x150 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_btree_insert+0xcd/0x110
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_journal_replay+0xe6/0x1f0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      register_bcache+0x1918/0x1bf0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: bcache: bch_journal_replay()
    journal replay done, 3591 keys in 304 entries, seq 6243591
    janv. 17 07:20:50 pierre.juhen kernel: bcache: register_cache()
    registered cache device nvme0n1p3
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field
    "&w->data->btree_root" at drivers/md/bcache/journal.c:778 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 700 at
    drivers/md/bcache/journal.c:778 journal_write_unlocked+0x4f6/0x560
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
    hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
    crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
    ghash_clmulni_intel sh>
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 700 Comm:
    bcache_allocato Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:journal_write_unlocked+0x4f6/0x560 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_journal+0x302/0x370 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_journal_meta+0x38/0x50
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_prio_write+0x3af/0x4c0
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_allocator_thread+0x199/0xcd0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_invalidate_one_bucket+0x80/0x80 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field
    "&w->data->uuid_bucket" at drivers/md/bcache/journal.c:779 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 700 at
    drivers/md/bcache/journal.c:779 journal_write_unlocked+0x545/0x560
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in: fjes(-)
    hid_logitech_hidpp(+) raid1 bcacheraid0 crct10dif_pclmul
    crc32_pclmul crc32c_intel polyval_clmulni polyval_generic nvme
    ghash_clmulni_intel sh>
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 700 Comm:
    bcache_allocato Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:journal_write_unlocked+0x545/0x560 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_journal+0x302/0x370 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_journal_meta+0x38/0x50
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_prio_write+0x3af/0x4c0
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_allocator_thread+0x199/0xcd0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_invalidate_one_bucket+0x80/0x80 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: bcache: register_bdev()
    registered backing device md126
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field "&c->uuid_bucket" at
    drivers/md/bcache/super.c:520 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 11 PID: 703 at
    drivers/md/bcache/super.c:520 __uuid_write+0x1ad/0x1c0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in:
    hid_logitech_hidpp raid1 bcacheraid0 crct10dif_pclmul crc32_pclmul
    crc32c_intel polyval_clmulni polyval_generic nvme
    ghash_clmulni_intel sha512_ssse3 >
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 11 PID: 703 Comm:
    bcache-register Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:__uuid_write+0x1ad/0x1c0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ? bch_btree_exit+0x20/0x20
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_cached_dev_attach+0x442/0x560 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      register_bcache.cold+0x26c/0x3e4 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: bcache:
    bch_cached_dev_attach() Caching md126 as bcache0 on set
    4e3b28d9-0795-4f91-af97-f8429b325481
    janv. 17 07:20:50 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field "&w->key" at
    drivers/md/bcache/btree.c:2618 (size 16)
    janv. 17 07:20:50 pierre.juhen kernel: WARNING: CPU: 0 PID: 706 at
    drivers/md/bcache/btree.c:2618 refill_keybuf_fn+0x220/0x230 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel: Modules linked in:
    hid_logitech_hidpp raid1 bcacheraid0 crct10dif_pclmul crc32_pclmul
    crc32c_intel polyval_clmulni polyval_generic nvme
    ghash_clmulni_intel sha512_ssse3 >
    janv. 17 07:20:50 pierre.juhen kernel: CPU: 0 PID: 706 Comm:
    bcache_writebac Tainted: G        W          6.1.6-100.fc36.x86_64 #1
    janv. 17 07:20:50 pierre.juhen kernel: RIP:
    0010:refill_keybuf_fn+0x220/0x230 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_map_keys_recurse+0x60/0x180 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_gc_finish+0x390/0x390 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_map_keys_recurse+0xe6/0x180 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_gc_finish+0x390/0x390 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    idle_counter_exceeded+0x50/0x50 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_btree_map_keys+0x1dd/0x1f0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    bch_btree_gc_finish+0x390/0x390 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    idle_counter_exceeded+0x50/0x50 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  bch_refill_keybuf+0xba/0x1e0
    [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ?
    idle_counter_exceeded+0x50/0x50 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:
      bch_writeback_thread+0x31a/0x5b0 [bcache]
    janv. 17 07:20:50 pierre.juhen kernel:  ? read_dirty+0x450/0x450
    [bcache]
    janv. 17 07:20:52 pierre.juhen dracut-initqueue[783]: Scanning
    devices bcache0 md127 sdc1  for LVM volume groups
    janv. 17 07:20:52 pierre.juhen kernel: memcpy: detected
    field-spanning write (size 24) of single field "&ret->key" at
    drivers/md/bcache/alloc.c:586 (size 16)
    janv. 17 07:20:52 pierre.juhen kernel: WARNING: CPU: 5 PID: 870 at
    drivers/md/bcache/alloc.c:586 bch_alloc_sectors+0x4ad/0x500 [bcache]
    janv. 17 07:20:52 pierre.juhen kernel: Modules linked in:
    nvidia_drm(POE) nvidia_modeset(POE) nvidia_uvm(POE) nvidia(POE)
    hid_logitech_hidpp raid1 bcacheraid0 crct10dif_pclmul crc32_pclmul
    crc32c_intel polyva>
    janv. 17 07:20:52 pierre.juhen kernel: RIP:
    0010:bch_alloc_sectors+0x4ad/0x500 [bcache]
    janv. 17 07:20:52 pierre.juhen kernel:
      bch_data_insert_start+0x150/0x4c0 [bcache]
    janv. 17 07:20:52 pierre.juhen kernel:
      cached_dev_submit_bio+0xb1d/0xd70 [bcache]

Thank you,

Regards,

Pierre


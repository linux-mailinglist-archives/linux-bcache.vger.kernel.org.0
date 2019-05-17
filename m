Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E7621337
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2019 06:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfEQEpg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 17 May 2019 00:45:36 -0400
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:51496 "EHLO
        smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEQEpg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 May 2019 00:45:36 -0400
Received: from pierre.juhen (89-156-43-137.rev.numericable.fr [89.156.43.137])
        by smtp7.tech.numericable.fr (Postfix) with ESMTPS id 24F5E627AF;
        Fri, 17 May 2019 06:45:33 +0200 (CEST)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     kent.overstreet@gmail.com, Rolf Fokkens <rolf@rolffokkens.nl>
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
 <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
From:   Pierre JUHEN <pierre.juhen@orange.fr>
Message-ID: <cbd597ad-ed21-34ef-1fec-03fa943fd704@orange.fr>
Date:   Fri, 17 May 2019 06:45:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr-FR
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtuddgkeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfdpqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomheprfhivghrrhgvucflfgfjgffpuceophhivghrrhgvrdhjuhhhvghnsehorhgrnhhgvgdrfhhrqeenucfrrghrrghmpehmohguvgepshhmthhpohhuthenucevlhhushhtvghrufhiiigvpedt
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Le 16/05/2019 à 16:12, Coly Li a écrit


> Such problem is very easy to produce, only a few sequential I/Os may
> trigger a panic from bch_btree_iter_next_check().
>
> Here is content of my fio script,
> [global]
> lockmem=1
> direct=1
> ioengine=psync
>
> [job1]
> filename=/dev/bcache0
> readwrite=write
> blocksize=4k
> iodepth=1
> numjobs=1
> io_size=64K
>
> In my observation, 2 sequential I/Os may trigger this panic. Here is the
> kernel output when panic in bch_btree_iter_next_check() triggered,
>
> [  153.478620] bcache: bch_dump_bset() block 1 key 0/9:
> [  153.478621] bcache: bch_bkey_dump()  0x0:0x10 len 0x8 -> [check dev]
> [  153.478623] bcache: bch_bkey_dump()  bucket 7560168717
> [  153.478624] bcache: bch_bkey_dump()
> [  153.478624]
> [  153.478625] bcache: bch_dump_bset() block 1 key 3/9:
> [  153.478626] bcache: bch_bkey_dump()  0x0:0x18 len 0x8 -> [check dev]
> [  153.478627] bcache: bch_bkey_dump()  bucket 4400861924
> [  153.478628] bcache: bch_bkey_dump()
> [  153.478628]
> [  153.478629] bcache: bch_dump_bset() Key skipped backwards
> [  153.478629]
> [  153.478630] bcache: bch_dump_bset() block 1 key 6/9:
> [  153.478631] bcache: bch_bkey_dump()  0x0:0x10 len 0x8 -> [0:392192
> gen 1] dirty
> [  153.478632] bcache: bch_bkey_dump()  bucket 383
> [  153.478635] bcache: bch_bkey_dump()
> [  153.478635]
> [  153.532890] Kernel panic - not syncing: Key skipped backwards
> [  153.535924] CPU: 0 PID: 790 Comm: bcache_writebac Tainted: G        W
>          5.1.0+ #3
> [  153.539656] Hardware name: VMware, Inc. VMware Virtual Platform/440BX
> Desktop Reference Platform, BIOS 6.00 04/13/2018
> [  153.545002] Call Trace:
> [  153.546702]  dump_stack+0x85/0xc0
> [  153.548675]  panic+0x106/0x2da
> [  153.550560]  ? bch_ptr_invalid+0x10/0x10 [bcache]
> [  153.553178]  bch_btree_iter_next_filter.cold+0xff/0x12e [bcache]
> [  153.556117]  ? btree_insert_key+0x190/0x190 [bcache]
> [  153.558646]  bch_btree_map_keys_recurse+0x5c/0x190 [bcache]
> [  153.561557]  bch_btree_map_keys+0x177/0x1a0 [bcache]
> [  153.564085]  ? btree_insert_key+0x190/0x190 [bcache]
> [  153.566688]  ? dirty_init+0x80/0x80 [bcache]
> [  153.569224]  bch_refill_keybuf+0xcc/0x290 [bcache]
> [  153.571609]  ? finish_wait+0x90/0x90
> [  153.573525]  ? dirty_init+0x80/0x80 [bcache]
> [  153.575705]  bch_writeback_thread+0x3b9/0x5c0 [bcache]
> [  153.578527]  ? __kthread_parkme+0x58/0x80
> [  153.580662]  kthread+0x108/0x140
> [  153.582541]  ? read_dirty+0x620/0x620 [bcache]
> [  153.584998]  ? kthread_park+0x90/0x90
> [  153.586991]  ret_from_fork+0x3a/0x50
> [  153.589236] Kernel Offset: 0x12000000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [  153.594868] ---[ end Kernel panic - not syncing: Key skipped
> backwards ]---
>
> The panic happens in bch_writeback context, because bkeys in btree node
> is not in linear increasing order. Adjacent two sequential write
> requests is very common condition in bcache, such corrupted btree node
> is not reported in recent 2~3 years. Unless the kernel is compiled with
> gcc9...
>
> It is not clear to me why the key 0:0x10 appears in same btree node
> twice, and why there are 3 keys for two 4K write requests.
>
> If anyone may have any clue, please offer. Now I continue to check how
> this happens.
>
> Thanks.
>
Hi,

Either Rolf and I didn't experiment a kernel panic, probably because we 
are working a bcache device already used at 100% or close.

The trace shows that's the btree structure that is corrupted, and 
probably the adresses of the next btree nodes. This could be in the 
tasks that walk's inside the btree :

Could you check that the size of each btree node is the same with the 
two versions of the compiler  ? (alignment issue)

It could be also a problem where the end of the btree are not correctly 
detected and you jump on un-itinialized node.

Since you are able to reproduce it very fast, could you put a trace that 
dump the btree nodes that are crossed during the search ?

Thank you,

Regards,




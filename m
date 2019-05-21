Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A2124FDD
	for <lists+linux-bcache@lfdr.de>; Tue, 21 May 2019 15:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfEUNMa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 May 2019 09:12:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:60830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726900AbfEUNM3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 May 2019 09:12:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1AEFDAE91;
        Tue, 21 May 2019 13:12:28 +0000 (UTC)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com
Cc:     Pierre JUHEN <pierre.juhen@orange.fr>,
        Rolf Fokkens <rolf@rolffokkens.nl>
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
 <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
 <cbd597ad-ed21-34ef-1fec-03fa943fd704@orange.fr>
 <cefbcdf6-6ab6-6ab0-8afa-bcd4d85401a5@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <9fc7c451-0507-b5c3-efc8-ab1baf7a1d44@suse.de>
Date:   Tue, 21 May 2019 21:12:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cefbcdf6-6ab6-6ab0-8afa-bcd4d85401a5@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/17 1:38 下午, Coly Li wrote:
> On 2019/5/17 12:45 下午, Pierre JUHEN wrote:
>> Le 16/05/2019 à 16:12, Coly Li a écrit
>>
>>
>>> Such problem is very easy to produce, only a few sequential I/Os may
>>> trigger a panic from bch_btree_iter_next_check().
>>>
>>> Here is content of my fio script,
>>> [global]
>>> lockmem=1
>>> direct=1
>>> ioengine=psync
>>>
>>> [job1]
>>> filename=/dev/bcache0
>>> readwrite=write
>>> blocksize=4k
>>> iodepth=1
>>> numjobs=1
>>> io_size=64K
>>>
>>> In my observation, 2 sequential I/Os may trigger this panic. Here is the
>>> kernel output when panic in bch_btree_iter_next_check() triggered,
>>>
>>> [  153.478620] bcache: bch_dump_bset() block 1 key 0/9:
>>> [  153.478621] bcache: bch_bkey_dump()  0x0:0x10 len 0x8 -> [check dev]
>>> [  153.478623] bcache: bch_bkey_dump()  bucket 7560168717
>>> [  153.478624] bcache: bch_bkey_dump()
>>> [  153.478624]
>>> [  153.478625] bcache: bch_dump_bset() block 1 key 3/9:
>>> [  153.478626] bcache: bch_bkey_dump()  0x0:0x18 len 0x8 -> [check dev]
>>> [  153.478627] bcache: bch_bkey_dump()  bucket 4400861924
>>> [  153.478628] bcache: bch_bkey_dump()
>>> [  153.478628]
>>> [  153.478629] bcache: bch_dump_bset() Key skipped backwards
>>> [  153.478629]
>>> [  153.478630] bcache: bch_dump_bset() block 1 key 6/9:
>>> [  153.478631] bcache: bch_bkey_dump()  0x0:0x10 len 0x8 -> [0:392192
>>> gen 1] dirty
>>> [  153.478632] bcache: bch_bkey_dump()  bucket 383
>>> [  153.478635] bcache: bch_bkey_dump()
>>> [  153.478635]
>>> [  153.532890] Kernel panic - not syncing: Key skipped backwards
>>> [  153.535924] CPU: 0 PID: 790 Comm: bcache_writebac Tainted: G        W
>>>          5.1.0+ #3
>>> [  153.539656] Hardware name: VMware, Inc. VMware Virtual Platform/440BX
>>> Desktop Reference Platform, BIOS 6.00 04/13/2018
>>> [  153.545002] Call Trace:
>>> [  153.546702]  dump_stack+0x85/0xc0
>>> [  153.548675]  panic+0x106/0x2da
>>> [  153.550560]  ? bch_ptr_invalid+0x10/0x10 [bcache]
>>> [  153.553178]  bch_btree_iter_next_filter.cold+0xff/0x12e [bcache]
>>> [  153.556117]  ? btree_insert_key+0x190/0x190 [bcache]
>>> [  153.558646]  bch_btree_map_keys_recurse+0x5c/0x190 [bcache]
>>> [  153.561557]  bch_btree_map_keys+0x177/0x1a0 [bcache]
>>> [  153.564085]  ? btree_insert_key+0x190/0x190 [bcache]
>>> [  153.566688]  ? dirty_init+0x80/0x80 [bcache]
>>> [  153.569224]  bch_refill_keybuf+0xcc/0x290 [bcache]
>>> [  153.571609]  ? finish_wait+0x90/0x90
>>> [  153.573525]  ? dirty_init+0x80/0x80 [bcache]
>>> [  153.575705]  bch_writeback_thread+0x3b9/0x5c0 [bcache]
>>> [  153.578527]  ? __kthread_parkme+0x58/0x80
>>> [  153.580662]  kthread+0x108/0x140
>>> [  153.582541]  ? read_dirty+0x620/0x620 [bcache]
>>> [  153.584998]  ? kthread_park+0x90/0x90
>>> [  153.586991]  ret_from_fork+0x3a/0x50
>>> [  153.589236] Kernel Offset: 0x12000000 from 0xffffffff81000000
>>> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>>> [  153.594868] ---[ end Kernel panic - not syncing: Key skipped
>>> backwards ]---
>>>
>>> The panic happens in bch_writeback context, because bkeys in btree node
>>> is not in linear increasing order. Adjacent two sequential write
>>> requests is very common condition in bcache, such corrupted btree node
>>> is not reported in recent 2~3 years. Unless the kernel is compiled with
>>> gcc9...
>>>
>>> It is not clear to me why the key 0:0x10 appears in same btree node
>>> twice, and why there are 3 keys for two 4K write requests.
>>>
>>> If anyone may have any clue, please offer. Now I continue to check how
>>> this happens.
>>>
>>> Thanks.
>>>
>> Hi,
>>
>> Either Rolf and I didn't experiment a kernel panic, probably because we
>> are working a bcache device already used at 100% or close.
>>
> 
> It seems something wrong in btree related code with GCC9.
> 
>> The trace shows that's the btree structure that is corrupted, and
>> probably the adresses of the next btree nodes. This could be in the
>> tasks that walk's inside the btree :
>>
>> Could you check that the size of each btree node is the same with the
>> two versions of the compiler  ? (alignment issue)
>>
> 
> Not yet, but since the keys are combined with 64bit words, it should not
> be problematic for bits alignment. bkey assignment is not by data
> structure, is by several uint64 words, this is reliable operation.
> 
> 
>> It could be also a problem where the end of the btree are not correctly
>> detected and you jump on un-itinialized node.
>>
> 
> This is suspicious. I only sent two 4K write, but there are three keys
> in the btree node. Currently I am not fully understand how bcache btree
> code works, still on the way to dig out.
> 
>> Since you are able to reproduce it very fast, could you put a trace that
>> dump the btree nodes that are crossed during the search ?

There is a btree dump sysinterface already,
/sys/kernel/debug/bcache/bcache-<UUID>, which requires bcache debug to
be configured.

The panic I observe in bch_btree_iter_next_check() was because, when
kernel is compiled with gcc9, all adjacent keys are not merged at all.
So when same sequential I/Os submitted again, bcache code just tries to
appends same keys on the tail of existing keys on btree node, then panic
triggered inside bch_btree_iter_next_check().

When the code is compiled with gcc7/8, the sequential keys are merged
into one single key. So the skipped backward key does not exist at all.

The bkey insert/merge is very essential and hot code path, there is very
small possibility that some hidden bug exists. So now I come to think,
maybe there is something wrong in gcc9 code ?

Also I try to analyze the assemble code of bcache, just find out the
generated assembly code between gcc9 and gcc7 is quite different. For
gcc9 there is a XXXX.cold part. So far I can not tell where the problem
is from yet.

Now I feel such problem is beyond my current understanding of bcache
code. It will be great if Kent has time and may have a look on what is
wrong in key insert code path.

Sequential keys not merging is only a simplest problem I observe, I
believe this is not a simple point issue, the gcc9 generated code may
have problem in other multiple places, this might be the reason why we
see different buggy behavior from different people.

Thanks.

-- 

Coly Li

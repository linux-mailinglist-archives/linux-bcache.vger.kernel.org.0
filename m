Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5B2DE808
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Oct 2019 11:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfJUJ0p (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Oct 2019 05:26:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:55382 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfJUJ0p (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Oct 2019 05:26:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 54DD6B242;
        Mon, 21 Oct 2019 09:26:43 +0000 (UTC)
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
To:     Teodor Milkov <tm@del.bg>
Cc:     linux-bcache@vger.kernel.org
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
 <224a181d-06a6-2517-865d-c71595487187@suse.de>
 <8f26d359-5080-65fc-b84c-3b89b188426f@del.bg>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <08dd5d30-5ec0-6612-6484-7157e0c9c0d4@suse.de>
Date:   Mon, 21 Oct 2019 17:26:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8f26d359-5080-65fc-b84c-3b89b188426f@del.bg>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/21 4:37 下午, Teodor Milkov wrote:
> On 20.10.19 г. 9:34 ч., Coly Li wrote:
>> On 2019/10/17 11:21 下午, Teodor Milkov wrote:
>>> Hello,
>>>
>>> I've tried using bcache with a large 6.4TB NVMe device, but found it
>>> takes long time to register after clean reboot -- around 10 minutes.
>>> That's even with idle machine reboot.
>>>
>>> Things look like this soon after reboot:
>>>
>>> root@node420:~# ps axuww |grep md12
>>> root      9768 88.1  0.0   2268   744 pts/0    D+   16:20 0:25
>>> /lib/udev/bcache-register /dev/md12
>>>
>>>
>>> Device            r/s     w/s     rMB/s     wMB/s rrqm/s   wrqm/s
>>> %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
>>> nvme0n1        420.00    0.00     52.50      0.00 0.00     0.00   0.00
>>> 0.00    0.30    0.00   1.04   128.00 0.00   2.38  99.87
>>> nvme1n1        417.67    0.00     52.21      0.00 0.00     0.00   0.00
>>> 0.00    0.30    0.00   1.03   128.00 0.00   2.39 100.00
>>> md12           838.00    0.00    104.75      0.00 0.00     0.00   0.00
>>> 0.00    0.00    0.00   0.00   128.00 0.00   0.00   0.00
>>>
>>> As you can see nvme1n1, which is Micron 9200, is reading with the humble
>>> 52MB/s (417r/s), and that is very far bellow it's capabilities of
>>> 3500MB/s & 840K IOPS.
>>>
>>> At the same time it seems like the bcache-register process is saturating
>>> the CPU core it's running on, so maybe that's the bottleneck?
>>>
>>> Tested with kernels 4.9 and 4.19.
>>>
>>> 1. Is this current state of affairs -- i.e. this known/expected
>>> behaviour with such a large cache?
>>>
>> The CPU is busy on checking checksum of all btree nodes. It is as
>> expected but definitely should be improved.
> 
> Thank you for your quick and detailed response, Coly Li!
> 
> I didn't think of checksum calculation, because in my mind these are
> usually very fast nowadays.
> 
> For example I have tried on a very modest 7" laptop with mobile
> processor what would the perl Digest::CRC implementation of crc64 would
> be and it's crunching it at 228MB/s (see bellow).
> 
> There are reports for speeds up to 1600MB/s like the one at
> https://matt.sh/redis-crcspeed
> 
> At the same time my experience was -- bcache reading from NVMe only
> 52MB/s on a quite powerful Intel(R) Xeon(R) Gold 6140 CPU, which caught
> me unprepared.
> 
> $ yes $(strings /dev/urandom |dd bs=1M count=1) |pv -s 1000M -S |perl
> -ne 'use Digest::CRC qw(crc64);  $crc = crc64($_);'
> 0+1 records in
> 0+1 records out
> 4096 bytes (4,1 kB, 4,0 KiB) copied, 0,00504587 s, 812 kB/s
> 1000MiB 0:00:04 [ 228MiB/s] [=======================>] 100%
> 
> 
> $ grep "model name" /proc/cpuinfo
> model name      : Intel(R) Core(TM) m3-7Y30 CPU @ 1.00GHz
> 

See drivers/md/bcache/btree.c:bch_btree_check(), this function is called
in run_cache_set() when running a cache set after a reboot.

The bottle neck is not only crc64 itself, bch_btree_check() iterates all
internal B+tree nodes in linear order, that is,
 read bnode -> check csum -> read next bnode -> check csum
This is why I/O is slow. And there is only one thread performs csum
checking, this is why only a single CPU core being busy.

When cache is small, it won't be a problem. But now NVMe SSD is cheaper
and bigger, checking B+btree node in start up comes to be a performance
problem.

-- 

Coly Li

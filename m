Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F17CDE6B7
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Oct 2019 10:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfJUIiL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Oct 2019 04:38:11 -0400
Received: from s802.sureserver.com ([195.8.222.36]:40126 "EHLO
        s802.sureserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfJUIiL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Oct 2019 04:38:11 -0400
Received: (qmail 4196 invoked by uid 1003); 21 Oct 2019 08:38:07 -0000
Received: from unknown (HELO ?213.145.98.190?) (zimage@dni.li@213.145.98.190)
  by s802.sureserver.com with ESMTPA; 21 Oct 2019 08:38:07 -0000
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
 <224a181d-06a6-2517-865d-c71595487187@suse.de>
From:   Teodor Milkov <tm@del.bg>
Message-ID: <8f26d359-5080-65fc-b84c-3b89b188426f@del.bg>
Date:   Mon, 21 Oct 2019 11:37:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <224a181d-06a6-2517-865d-c71595487187@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 20.10.19 г. 9:34 ч., Coly Li wrote:
> On 2019/10/17 11:21 下午, Teodor Milkov wrote:
>> Hello,
>>
>> I've tried using bcache with a large 6.4TB NVMe device, but found it
>> takes long time to register after clean reboot -- around 10 minutes.
>> That's even with idle machine reboot.
>>
>> Things look like this soon after reboot:
>>
>> root@node420:~# ps axuww |grep md12
>> root      9768 88.1  0.0   2268   744 pts/0    D+   16:20 0:25
>> /lib/udev/bcache-register /dev/md12
>>
>>
>> Device            r/s     w/s     rMB/s     wMB/s rrqm/s   wrqm/s
>> %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
>> nvme0n1        420.00    0.00     52.50      0.00 0.00     0.00   0.00
>> 0.00    0.30    0.00   1.04   128.00 0.00   2.38  99.87
>> nvme1n1        417.67    0.00     52.21      0.00 0.00     0.00   0.00
>> 0.00    0.30    0.00   1.03   128.00 0.00   2.39 100.00
>> md12           838.00    0.00    104.75      0.00 0.00     0.00   0.00
>> 0.00    0.00    0.00   0.00   128.00 0.00   0.00   0.00
>>
>> As you can see nvme1n1, which is Micron 9200, is reading with the humble
>> 52MB/s (417r/s), and that is very far bellow it's capabilities of
>> 3500MB/s & 840K IOPS.
>>
>> At the same time it seems like the bcache-register process is saturating
>> the CPU core it's running on, so maybe that's the bottleneck?
>>
>> Tested with kernels 4.9 and 4.19.
>>
>> 1. Is this current state of affairs -- i.e. this known/expected
>> behaviour with such a large cache?
>>
> The CPU is busy on checking checksum of all btree nodes. It is as
> expected but definitely should be improved.

Thank you for your quick and detailed response, Coly Li!

I didn't think of checksum calculation, because in my mind these are 
usually very fast nowadays.

For example I have tried on a very modest 7" laptop with mobile 
processor what would the perl Digest::CRC implementation of crc64 would 
be and it's crunching it at 228MB/s (see bellow).

There are reports for speeds up to 1600MB/s like the one at 
https://matt.sh/redis-crcspeed

At the same time my experience was -- bcache reading from NVMe only 
52MB/s on a quite powerful Intel(R) Xeon(R) Gold 6140 CPU, which caught 
me unprepared.

$ yes $(strings /dev/urandom |dd bs=1M count=1) |pv -s 1000M -S |perl -ne 'use Digest::CRC qw(crc64);  $crc = crc64($_);'
0+1 records in
0+1 records out
4096 bytes (4,1 kB, 4,0 KiB) copied, 0,00504587 s, 812 kB/s
1000MiB 0:00:04 [ 228MiB/s] [=======================>] 100%


$ grep "model name" /proc/cpuinfo
model name      : Intel(R) Core(TM) m3-7Y30 CPU @ 1.00GHz


> When the btree is very large, checking checksum of each btree node with
> crc64 on single thread is very slow. On my machine it can be 20 minutes
> around.
>
> So far there is less method to improve crc64 speed, but it is possible
> to checking checksum with multiple threads. Just need time to work on it.
>
>> 2. If this isn't expected -- any ideas how to debug or fix it?
>>
> As I mentioned on question 1, we need multiple threads to check the
> checksum of each btree nodes, since it is read-only access on boot time
> and no lock contention, it is possible to speed up much with more CPU
> core involved in crc64 calculation in parallel.
>
>> 3. What is max recommended cache size?
>>
> So far we only have a single B+tree to contain and index all bkeys. If
> the cached data is large, this could be slow. So I suggest to create
> more partition and make individual cache set on each partition. In my
> personal testing, I suggest the maximum cache set size as 2-4TB.
>
> Multiple B+trees is on my to-do list, but I need to finish other tasks
> with higher priority. So far I am working on big-endian machine support
> still.
>
> Thanks.
>

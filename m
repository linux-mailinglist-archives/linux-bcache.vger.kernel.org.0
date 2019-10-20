Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40E9DDD0A
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2019 08:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfJTGec (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 20 Oct 2019 02:34:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:34110 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbfJTGec (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 20 Oct 2019 02:34:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B03AAF13;
        Sun, 20 Oct 2019 06:34:31 +0000 (UTC)
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
To:     Teodor Milkov <tm@del.bg>
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Cc:     linux-bcache@vger.kernel.org
Message-ID: <224a181d-06a6-2517-865d-c71595487187@suse.de>
Date:   Sun, 20 Oct 2019 14:34:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/17 11:21 下午, Teodor Milkov wrote:
> Hello,
> 
> I've tried using bcache with a large 6.4TB NVMe device, but found it
> takes long time to register after clean reboot -- around 10 minutes.
> That's even with idle machine reboot.
> 
> Things look like this soon after reboot:
> 
> root@node420:~# ps axuww |grep md12
> root      9768 88.1  0.0   2268   744 pts/0    D+   16:20 0:25
> /lib/udev/bcache-register /dev/md12
> 
> 
> Device            r/s     w/s     rMB/s     wMB/s rrqm/s   wrqm/s 
> %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme0n1        420.00    0.00     52.50      0.00 0.00     0.00   0.00  
> 0.00    0.30    0.00   1.04   128.00 0.00   2.38  99.87
> nvme1n1        417.67    0.00     52.21      0.00 0.00     0.00   0.00  
> 0.00    0.30    0.00   1.03   128.00 0.00   2.39 100.00
> md12           838.00    0.00    104.75      0.00 0.00     0.00   0.00  
> 0.00    0.00    0.00   0.00   128.00 0.00   0.00   0.00
> 
> As you can see nvme1n1, which is Micron 9200, is reading with the humble
> 52MB/s (417r/s), and that is very far bellow it's capabilities of
> 3500MB/s & 840K IOPS.
> 
> At the same time it seems like the bcache-register process is saturating
> the CPU core it's running on, so maybe that's the bottleneck?
> 
> Tested with kernels 4.9 and 4.19.
> 
> 1. Is this current state of affairs -- i.e. this known/expected
> behaviour with such a large cache?
> 

The CPU is busy on checking checksum of all btree nodes. It is as
expected but definitely should be improved.

When the btree is very large, checking checksum of each btree node with
crc64 on single thread is very slow. On my machine it can be 20 minutes
around.

So far there is less method to improve crc64 speed, but it is possible
to checking checksum with multiple threads. Just need time to work on it.

> 2. If this isn't expected -- any ideas how to debug or fix it?
> 

As I mentioned on question 1, we need multiple threads to check the
checksum of each btree nodes, since it is read-only access on boot time
and no lock contention, it is possible to speed up much with more CPU
core involved in crc64 calculation in parallel.

> 3. What is max recommended cache size?
> 

So far we only have a single B+tree to contain and index all bkeys. If
the cached data is large, this could be slow. So I suggest to create
more partition and make individual cache set on each partition. In my
personal testing, I suggest the maximum cache set size as 2-4TB.

Multiple B+trees is on my to-do list, but I need to finish other tasks
with higher priority. So far I am working on big-endian machine support
still.

Thanks.

-- 

Coly Li

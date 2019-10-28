Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5970AE6B43
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2019 04:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfJ1DIC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 27 Oct 2019 23:08:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:51128 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727330AbfJ1DIC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 27 Oct 2019 23:08:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D294AACC0;
        Mon, 28 Oct 2019 03:07:59 +0000 (UTC)
Subject: Re: bcache writeback infinite loop?
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
References: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Cc:     linux-bcache@vger.kernel.org
Message-ID: <40ddfd48-a163-5e7e-cf62-9e072bcc685f@suse.de>
Date:   Mon, 28 Oct 2019 11:07:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4d6fe8a0-ecae-738b-165b-ee66683a2df6@nuclearwinter.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/24 10:40 上午, Larkin Lowrey wrote:
> I have a backing device that is constantly writing due to
> bcache_writebac. It has been at 14.3.MB dirty all day and has not
> changed. There's nothing else writing to it.
> 
> This started after I "upgraded" from Fedora 29 to 30 and consequently
> from kernel 5.2.18 to 5.3.6.
> 
> You can see from the info below that the writeback process is chewing
> up  A LOT of CPU and writing constantly at ~7MB/s. It sure looks like
> it's in an infinite loop and writing the same data over and over. At
> least I hope that's the case and it's not just filling the array with
> garbage.
> 
> This configuration has been stable for many years and across many Fedora
> upgrades. The host has ECC memory so RAM corruption should not be a
> concern. I have not had any recent controller or drive failures.
> 
>   PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+
> COMMAND
>  5915 root      20   0       0      0      0 R  94.1   0.0 891:45.42
> bcache_writebac
> 
> 
> Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s 
> %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> md3              0.02 1478.77      0.00      6.90     0.00     0.00  
> 0.00   0.00    0.00    0.00   0.00     7.72     4.78   0.00   0.00
> md3              0.00 1600.00      0.00      7.48     0.00     0.00  
> 0.00   0.00    0.00    0.00   0.00     0.00     4.79   0.00   0.00
> md3              0.00 1300.00      0.00      6.07     0.00     0.00  
> 0.00   0.00    0.00    0.00   0.00     0.00     4.78   0.00   0.00
> md3              0.00 1500.00      0.00      7.00     0.00     0.00  
> 0.00   0.00    0.00    0.00   0.00     0.00     4.78   0.00   0.00
> 
> --- bcache ---
> UUID                        dc2877bc-d1b3-43fa-9f15-cad018e73bf6
> Block Size                  512 B
> Bucket Size                 512.00 KiB
> Congested?                  False
> Read Congestion             2.0ms
> Write Congestion            20.0ms
> Total Cache Size            128 GiB
> Total Cache Used            128 GiB     (100%)
> Total Cache Unused          0 B (0%)
> Evictable Cache             127 GiB     (99%)
> Replacement Policy          [lru] fifo random
> Cache Mode                  writethrough [writeback] writearound none
> Total Hits                  49872       (97%)
> Total Misses                1291
> Total Bypass Hits           659 (77%)
> Total Bypass Misses         189
> Total Bypassed              5.8 MiB
> --- Cache Device ---
>   Device File               /dev/dm-3 (253:3)
>   Size                      128 GiB
>   Block Size                512 B
>   Bucket Size               512.00 KiB
>   Replacement Policy        [lru] fifo random
>   Discard?                  False
>   I/O Errors                0
>   Metadata Written          5.0 MiB
>   Data Written              86.1 MiB
>   Buckets                   262144
>   Cache Used                128 GiB     (100%)
>   Cache Unused              0 B (0%)
> --- Backing Device ---
>   Device File               /dev/md3 (9:3)
>   bcache Device File        /dev/bcache0 (252:0)
>   Size                      73 TiB
>   Cache Mode                writethrough [writeback] writearound none
>   Readahead                 0.0k
>   Sequential Cutoff         4.0 MiB
>   Merge sequential?         False
>   State                     dirty
>   Writeback?                True
>   Dirty Data                14.3 MiB
>   Total Hits                49872       (97%)
>   Total Misses              1291
>   Total Bypass Hits         659 (77%)
>   Total Bypass Misses       189
>   Total Bypassed            5.8 MiB
> 
> I have not tried reverting back to an earlier kernel. I'm concerned
> about possible corruption. Is that safe? Any other suggestions as to how
> to debug and/or resolve this issue?

From 5.2 to 5.3, there is only a few change related to writeback, and I
don't find obviously suspicious location for the infinite writback loop.

Since in 5.3 there are many issue fixed, it might be possible that
another problem shows up because the previous problem fixed.

Do you see anything suspicious in kernel message log ? or is it possible
to tar up and compress the /sys/fs/bcache/<cache-set-uuid> and
/sys/block/bcache0/ directories and emailed them to me ?

And if you may run perf on the writback thread to sample the hot
location in the infinite loop, maybe I can find some clue if lucky.

Thanks.

-- 

Coly Li

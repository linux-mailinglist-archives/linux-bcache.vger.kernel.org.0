Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8148C3251B4
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Feb 2021 15:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhBYOoy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 25 Feb 2021 09:44:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:43414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229752AbhBYOox (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 25 Feb 2021 09:44:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BF62AF6F;
        Thu, 25 Feb 2021 14:44:10 +0000 (UTC)
To:     "Norman.Kern" <norman.kern@gmx.com>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-bcache@vger.kernel.org
References: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
 <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
 <5867daf1-0960-39aa-1843-1a76c1e9a28d@suse.de>
 <07bcb6c8-21e1-11de-d1f0-ffd417bd36ff@gmx.com>
 <cfe2746f-18a7-a768-ea72-901793a3133e@gmx.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: Large latency with bcache for Ceph OSD
Message-ID: <96daa0bf-c8e1-a334-14cb-2d260aed5115@suse.de>
Date:   Thu, 25 Feb 2021 22:44:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <cfe2746f-18a7-a768-ea72-901793a3133e@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/25/21 9:00 PM, Norman.Kern wrote:
> I made a test:

BTW, what is the version of your kernel, and your bcache-tool, and which
distribution is running ?

> 
> - Stop writing and wait for dirty data writen back
> 
> $ lsblk
> NAME                                                                                                   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> sdf                                                                                                      8:80   0   7.3T  0 disk
> └─bcache0                                                                                              252:0    0   7.3T  0 disk
>   └─ceph--32a481f9--313c--417e--aaf7--bdd74515fd86-osd--data--2f670929--3c8a--45dd--bcef--c60ce3ee08e1 253:1    0   7.3T  0 lvm 
> sdd                                                                                                      8:48   0   7.3T  0 disk
> sdb                                                                                                      8:16   0   7.3T  0 disk
> sdk                                                                                                      8:160  0 893.8G  0 disk
> └─bcache0                                                                                              252:0    0   7.3T  0 disk
>   └─ceph--32a481f9--313c--417e--aaf7--bdd74515fd86-osd--data--2f670929--3c8a--45dd--bcef--c60ce3ee08e1 253:1    0   7.3T  0 lvm 
> $ cat /sys/block/bcache0/bcache/dirty_data
> 0.0k
> 
> root@WXS0106:~# bcache-super-show /dev/sdf
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 71DA9CA968B4A625 [match]
> sb.version              1 [backing device]
> 
> dev.label               (empty)
> dev.uuid                d07dc435-129d-477d-8378-a6af75199852
> dev.sectors_per_block   8
> dev.sectors_per_bucket  1024
> dev.data.first_sector   16
> dev.data.cache_mode     1 [writeback]
> dev.data.cache_state    1 [clean]
> cset.uuid               d87713c6-2e76-4a09-8517-d48306468659
> 
> - check the available cache
> 
> # cat /sys/fs/bcache/d87713c6-2e76-4a09-8517-d48306468659/cache_available_percent
> 27
> 

What is the content from
/sys/fs/bcache/<cache-set-uuid>/cache0/priority_stats ? Can you past
here too.

There is no dirty blocks, but cache is occupied 78% buckets, if you are
using 5.8+ kernel, then a gc is probably desired.

You may try to trigger a gc by writing to
sys/fs/bcache/<cache-set-uuid>/internal/trigger_gc


> 
> As the doc described:
> 
> cache_available_percent
>     Percentage of cache device which doesn’t contain dirty data, and could potentially be used for writeback. This doesn’t mean this space isn’t used for clean cached data; the unused statistic (in priority_stats) is typically much lower.
> When all dirty data writen back,  why cache_available_percent was not 100?
> 
> And when I start the write I/O, the new writen didn't replace the clean cache(it think the cache is diry now?), so it cause the hdd with large latency:
> 
> ./bin/iosnoop -Q -d '8,80'
> 
> <...>        73338  WS   8,80     3513701472   4096     217.69
> <...>        73338  WS   8,80     3513759360   4096     448.80
> <...>        73338  WS   8,80     3562211912   4096     511.69
> <...>        73335  WS   8,80     3562212528   4096     505.08
> <...>        73339  WS   8,80     3562213376   4096     501.19
> <...>        73336  WS   8,80     3562213992   4096     511.16
> <...>        73343  WS   8,80     3562214016   4096     511.74
> <...>        73340  WS   8,80     3562214128   4096     512.95
> <...>        73329  WS   8,80     3562214208   4096     510.48
> <...>        73338  WS   8,80     3562214600   4096     518.64
> <...>        73341  WS   8,80     3562214632   4096     519.09
> <...>        73342  WS   8,80     3562214664   4096     518.28
> <...>        73336  WS   8,80     3562214688   4096     519.27
> <...>        73343  WS   8,80     3562214736   4096     528.31
> <...>        73339  WS   8,80     3562214784   4096     530.13
> 

I just wondering why gc thread does not run up ....


Thanks.

Coly Li


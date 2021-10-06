Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE81423B23
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Oct 2021 11:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbhJFJ6T (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 Oct 2021 05:58:19 -0400
Received: from kuira.zi.fi ([135.181.25.145]:58468 "EHLO mail.zi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229874AbhJFJ6S (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 Oct 2021 05:58:18 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2021 05:58:18 EDT
Authentication-Results: mail.zi.fi;
        auth=pass (login)
MIME-Version: 1.0
Date:   Wed, 06 Oct 2021 10:48:31 +0100
From:   "L. Karkkainen" <trn+linux@iki.fi>
To:     linux-bcache@vger.kernel.org
Subject: Nearly all reads are bypassing the cache
Message-ID: <b29fc89b5331014004e820bb7e6a0da9@iki.fi>
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Received: from localhost (Unknown [127.0.0.1])
        by mail.zi.fi (Haraka/2.8.27) with ESMTPSA id 9BFE4779-740B-4E07-94CC-A85B740876B4.1
        envelope-from <trn+linux@iki.fi>
        tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (authenticated bits=0);
        Wed, 06 Oct 2021 12:48:42 +0300
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I have a bcache device that has been acting up lately. I believe it 
worked correctly until this week but now I cannot get any sequential 
reads to use the cache anymore. Writes appear to be cached correctly, 
but when reading back the same sectors the data comes from spinning rust 
instead. I tried recreating the cache device but that did not help.

# dd if=/dev/bcache0 of=/dev/null bs=1M count=32768
34359738368 bytes (34 GB, 32 GiB) copied, 67.976 s, 505 MB/s

# dd if=/dev/bcache0 of=/dev/null bs=1M count=32768
34359738368 bytes (34 GB, 32 GiB) copied, 74.5009 s, 461 MB/s

# dd if=/dev/md/CacheRaid of=/dev/null bs=1M count=32768
34359738368 bytes (34 GB, 32 GiB) copied, 7.4617 s, 4.6 GB/s

Every repeated read on the same data shows similar speeds to the first 
run. Accessing through a mounted btrfs shows similar results.
Expected: On repeated rounds speeds a few gigabytes per second, as per 
the cache device speed.

# bcache-super-show /dev/mapper/BigRaw
sb.version              4 [backing device]
dev.sectors_per_block   8
dev.sectors_per_bucket  2048
dev.data.first_sector   4096
dev.data.cache_mode     0 [writethrough]
dev.data.cache_state    1 [clean]

# bcache-super-show /dev/md/CacheRaid
sb.version              3 [cache device]
dev.sectors_per_block   8
dev.sectors_per_bucket  512
dev.cache.first_sector  512
dev.cache.cache_sectors 3369647616
dev.cache.total_sectors 3369648128
dev.cache.ordered       yes
dev.cache.discard       no
dev.cache.pos           0
dev.cache.replacement   0 [lru]

# cat /sys/block/bcache0/bcache/cache/cache0/priority_stats
Unused:     91%
Clean:      8%
Dirty:      0%
Metadata:   0%
Average:    127
Sectors per Q:  9959504
Quantiles:  [0 0 5 8 12 15 18 21 24 50 85 93 99 107 114 122 131 140 149 
159 169 180 191 203 215 228 241 254 269 281 309]

Expected: Clean at least 50 % and unused below 50 % if all the data read 
was cached (I read a much larger chunk than 32 GiB to test this).

/sys/block/bcache0/bcache/stats_total/bypassed 1.9G
/sys/block/bcache0/bcache/stats_total/cache_bypass_hits 57
/sys/block/bcache0/bcache/stats_total/cache_bypass_misses 890
/sys/block/bcache0/bcache/stats_total/cache_hit_ratio 3
/sys/block/bcache0/bcache/stats_total/cache_hits 15264
/sys/block/bcache0/bcache/stats_total/cache_miss_collisions 932
/sys/block/bcache0/bcache/stats_total/cache_misses 441927
/sys/block/bcache0/bcache/sequential_cutoff 0.0k
/sys/block/bcache0/bcache/cache/congested_read_threshold_us 0
/sys/block/bcache0/bcache/cache/congested_write_threshold_us 0

# uname -a
Linux xxx 5.14.8-zen1-1-zen #1 ZEN SMP PREEMPT Sun, 26 Sep 2021 19:36:16 
+0000 x86_64 GNU/Linux

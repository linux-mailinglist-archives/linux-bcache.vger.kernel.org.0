Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD492DE170
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Dec 2020 11:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389137AbgLRKpe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 18 Dec 2020 05:45:34 -0500
Received: from mail.wangsu.com ([123.103.51.227]:57859 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728246AbgLRKpd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 18 Dec 2020 05:45:33 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2020 05:45:33 EST
Received: from [10.8.148.37] (unknown [59.61.78.237])
        by app2 (Coremail) with SMTP id 4zNnewBHT0fdhdxfqNgFAA--.1343S2;
        Fri, 18 Dec 2020 18:35:10 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
Subject: Defects about bcache GC
To:     linux-bcache@vger.kernel.org
Cc:     linf@wangsu.com
Message-ID: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
Date:   Fri, 18 Dec 2020 18:35:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewBHT0fdhdxfqNgFAA--.1343S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw18WF4UKr1rAr17XFy7KFg_yoW5WrWDpF
        WUJ3WrKF4kWr1jkry0yw1DWF1UJ348AFZ8Grn5JFyjy345Xrn5JryUJr15Ga1jkw18Ga12
        qw18Xry2qr129aDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
        z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4
        xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r48McIj6xkF7I0En7xvr7AKxVW8
        Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI
        8I648v4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vI
        r41l42xK82IY6x8ErcxFaVAv8VW8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUcd
        WFUUUUU
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,

I googled a lot but only finding this, my question is if this issue have been fixed or
if there are ways to work around?

 > On Wed, 28 Jun 2017, Coly Li wrote:
 >
 > > On 2017/6/27 下午8:04, tang.junhui@xxxxxxxxxx wrote:
 > > > Hello Eric, Coly,
 > > >
 > > > I use a 1400G SSD device a bcache cache device,
 > > > and attach with 10 back-end devices,
 > > > and run random small write IOs,
 > > > when gc works, It takes about 15 seconds,
 > > > and the up layer application IOs was suspended at this time,
 > > > How could we bear such a long time IO stopping?
 > > > Is there any way we can avoid this problem?
 > > >
 > > > I am very anxious about this question, any comment would be valuable.
 > >
 > > I encounter same situation too.
 > > Hmm, I assume there are some locking issue here, to prevent application
 > > to send request and insert keys in LSM tree, no matter in writeback or
 > > writethrough mode. This is a lazy and fast response, I need to check the
 > > code then provide an accurate reply :-)
 >

I encoutered even worse situation(8TB ssd cached for 4*10 TB disks) as mail extracted above,
all usrer IOs are hung during bcache GC runs, my kernel is 4.18, while I tested it with kernel 5.10,
it seems that situation is unchaged.

Below are some logs for reference.
GC trace events:
[Wed Dec 16 15:08:40 2020]   ##48735 [046] .... 1632697.784097: bcache_gc_start: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
[Wed Dec 16 15:09:01 2020]   ##48735 [034] .... 1632718.828510: bcache_gc_end: 4ab63029-0c4a-42a8-8f54-e638358c2c6c

and during which iostat shows like:
12/16/2020 03:08:48 PM
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdb               0.00     0.50 1325.00   27.00 169600.00   122.00   251.07     0.32    0.24    0.24    0.02   0.13  17.90
sdc               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sde               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
bcache0           0.00     0.00    1.00    0.00     4.00     0.00     8.00    39.54    0.00    0.00    0.00 1000.00 100.00

# grep . /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/*gc*
/sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_duration_ms:26539
/sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_frequency_sec:8692
/sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_last_sec:6328
/sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_max_duration_ms:283405
/sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/copy_gc_enabled:1
/sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/gc_always_rewrite:1

Thanks and Best wishes!
linfeng


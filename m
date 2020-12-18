Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77782DE236
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Dec 2020 12:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgLRLw6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 18 Dec 2020 06:52:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:47016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgLRLw6 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 18 Dec 2020 06:52:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EB09FAEAC;
        Fri, 18 Dec 2020 11:52:16 +0000 (UTC)
Subject: Re: Defects about bcache GC
To:     Lin Feng <linf@wangsu.com>, linux-bcache@vger.kernel.org
References: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <2601f763-405c-b63d-a181-de022ecabaf3@suse.de>
Date:   Fri, 18 Dec 2020 19:52:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/18/20 6:35 PM, Lin Feng wrote:
> Hi all,
> 
> I googled a lot but only finding this, my question is if this issue have
> been fixed or
> if there are ways to work around?
> 
>> On Wed, 28 Jun 2017, Coly Li wrote:
>>
>> > On 2017/6/27 下午8:04, tang.junhui@xxxxxxxxxx wrote:
>> > > Hello Eric, Coly,
>> > >
>> > > I use a 1400G SSD device a bcache cache device,
>> > > and attach with 10 back-end devices,
>> > > and run random small write IOs,
>> > > when gc works, It takes about 15 seconds,
>> > > and the up layer application IOs was suspended at this time,
>> > > How could we bear such a long time IO stopping?
>> > > Is there any way we can avoid this problem?
>> > >
>> > > I am very anxious about this question, any comment would be valuable.
>> >
>> > I encounter same situation too.
>> > Hmm, I assume there are some locking issue here, to prevent application
>> > to send request and insert keys in LSM tree, no matter in writeback or
>> > writethrough mode. This is a lazy and fast response, I need to check
> the
>> > code then provide an accurate reply :-)
>>
> 
> I encoutered even worse situation(8TB ssd cached for 4*10 TB disks) as
> mail extracted above,
> all usrer IOs are hung during bcache GC runs, my kernel is 4.18, while I
> tested it with kernel 5.10,
> it seems that situation is unchaged.
> 
> Below are some logs for reference.
> GC trace events:
> [Wed Dec 16 15:08:40 2020]   ##48735 [046] .... 1632697.784097:
> bcache_gc_start: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
> [Wed Dec 16 15:09:01 2020]   ##48735 [034] .... 1632718.828510:
> bcache_gc_end: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
> 
> and during which iostat shows like:
> 12/16/2020 03:08:48 PM
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdb               0.00     0.50 1325.00   27.00 169600.00   122.00  
> 251.07     0.32    0.24    0.24    0.02   0.13  17.90
> sdc               0.00     0.00    0.00    0.00     0.00     0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> sdd               0.00     0.00    0.00    0.00     0.00     0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> sde               0.00     0.00    0.00    0.00     0.00     0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> sdf               0.00     0.00    0.00    0.00     0.00     0.00    
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> bcache0           0.00     0.00    1.00    0.00     4.00     0.00    
> 8.00    39.54    0.00    0.00    0.00 1000.00 100.00
> 
> # grep . /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/*gc*
> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_duration_ms:26539
> 
> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_frequency_sec:8692
> 
> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_last_sec:6328
> 
> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_max_duration_ms:283405
> 
> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/copy_gc_enabled:1
> 
> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/gc_always_rewrite:1

I/O hang during GC is as-designed. We have plan to improve, but the I/O
hang cannot be 100% avoided.

Coly Li

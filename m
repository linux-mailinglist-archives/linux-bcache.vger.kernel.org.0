Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2288E2DF7AE
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Dec 2020 03:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbgLUChM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 20 Dec 2020 21:37:12 -0500
Received: from mail.wangsu.com ([123.103.51.227]:37127 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727477AbgLUChL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 20 Dec 2020 21:37:11 -0500
Received: from [10.8.148.37] (unknown [59.61.78.237])
        by app2 (Coremail) with SMTP id 4zNnewDHzmIKCuBfRSIBAA--.11S2;
        Mon, 21 Dec 2020 10:35:54 +0800 (CST)
Subject: Re: Defects about bcache GC
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
 <2601f763-405c-b63d-a181-de022ecabaf3@suse.de>
 <X90C3q+OHke6OZ5H@moria.home.lan>
From:   Lin Feng <linf@wangsu.com>
Message-ID: <32dcbd1d-fbdc-9b37-ac15-38fe50d1b105@wangsu.com>
Date:   Mon, 21 Dec 2020 10:35:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X90C3q+OHke6OZ5H@moria.home.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewDHzmIKCuBfRSIBAA--.11S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4xZFyxtFyfGr1DXrykGrg_yoWrKr4rpr
        yrJF13Kry8Xrn3Jr42yFyUJryUtryUJ3s8Wrn5JF17J3sIq3Z0qw1UXw12g3ZIyr4xCr4D
        Jr1UJF43ur43ZaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkvb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv
        7VCY1x0262k0Y48FwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCF04k2
        0xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jieOXUUUUU=
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 12/19/20 03:28, Kent Overstreet wrote:
> On Fri, Dec 18, 2020 at 07:52:10PM +0800, Coly Li wrote:
>> On 12/18/20 6:35 PM, Lin Feng wrote:
>>> Hi all,
>>>
>>> I googled a lot but only finding this, my question is if this issue have
>>> been fixed or
>>> if there are ways to work around?
>>>
>>>> On Wed, 28 Jun 2017, Coly Li wrote:
>>>>
>>>>> On 2017/6/27 下午8:04, tang.junhui@xxxxxxxxxx wrote:
>>>>>> Hello Eric, Coly,
>>>>>>
>>>>>> I use a 1400G SSD device a bcache cache device,
>>>>>> and attach with 10 back-end devices,
>>>>>> and run random small write IOs,
>>>>>> when gc works, It takes about 15 seconds,
>>>>>> and the up layer application IOs was suspended at this time,
>>>>>> How could we bear such a long time IO stopping?
>>>>>> Is there any way we can avoid this problem?
>>>>>>
>>>>>> I am very anxious about this question, any comment would be valuable.
>>>>>
>>>>> I encounter same situation too.
>>>>> Hmm, I assume there are some locking issue here, to prevent application
>>>>> to send request and insert keys in LSM tree, no matter in writeback or
>>>>> writethrough mode. This is a lazy and fast response, I need to check
>>> the
>>>>> code then provide an accurate reply :-)
>>>>
>>>
>>> I encoutered even worse situation(8TB ssd cached for 4*10 TB disks) as
>>> mail extracted above,
>>> all usrer IOs are hung during bcache GC runs, my kernel is 4.18, while I
>>> tested it with kernel 5.10,
>>> it seems that situation is unchaged.
>>>
>>> Below are some logs for reference.
>>> GC trace events:
>>> [Wed Dec 16 15:08:40 2020]   ##48735 [046] .... 1632697.784097:
>>> bcache_gc_start: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
>>> [Wed Dec 16 15:09:01 2020]   ##48735 [034] .... 1632718.828510:
>>> bcache_gc_end: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
>>>
>>> and during which iostat shows like:
>>> 12/16/2020 03:08:48 PM
>>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
>>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>>> sdb               0.00     0.50 1325.00   27.00 169600.00   122.00
>>> 251.07     0.32    0.24    0.24    0.02   0.13  17.90
>>> sdc               0.00     0.00    0.00    0.00     0.00     0.00
>>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>>> sdd               0.00     0.00    0.00    0.00     0.00     0.00
>>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>>> sde               0.00     0.00    0.00    0.00     0.00     0.00
>>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>>> sdf               0.00     0.00    0.00    0.00     0.00     0.00
>>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>>> bcache0           0.00     0.00    1.00    0.00     4.00     0.00
>>> 8.00    39.54    0.00    0.00    0.00 1000.00 100.00
>>>
>>> # grep . /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/*gc*
>>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_duration_ms:26539
>>>
>>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_frequency_sec:8692
>>>
>>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_last_sec:6328
>>>
>>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_max_duration_ms:283405
>>>
>>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/copy_gc_enabled:1
>>>
>>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/gc_always_rewrite:1
>>
>> I/O hang during GC is as-designed. We have plan to improve, but the I/O
>> hang cannot be 100% avoided.
> 
> This is something that's entirely fixed in bcachefs - we update bucket sector
> counts as keys enter/leave the btree so runtime btree GC is no longer needed.
> 
Hi Kent and Coly,

Bcachefs, I'm glad to hear that and keen on having a trial, thank you for all your great work!

Pardon my ignorance I just started reading bcache codes and they are not easy to understand,
so as per Kent, is it possible to port things using in bcachefs to make I/O hang avoided
completely in bcache?
Since bcachefs is a relavite new(but great) filesystem and it needs some time to be matured,
if we can kill GC IO-stall completely in bcache, users won't be suffered from filesystem
migration while using bcache.

linfeng


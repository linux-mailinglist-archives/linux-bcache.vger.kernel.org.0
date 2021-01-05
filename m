Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01EE2EA6AF
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 09:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbhAEIjn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jan 2021 03:39:43 -0500
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:64139 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbhAEIjm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jan 2021 03:39:42 -0500
Received: from [192.168.122.37] (unknown [218.94.118.90])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 4EB4CE024E1;
        Tue,  5 Jan 2021 16:28:57 +0800 (CST)
Subject: Re: Defects about bcache GC
To:     Lin Feng <linf@wangsu.com>, linux-bcache@vger.kernel.org
References: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <ec826f2c-d0de-157f-c4d2-fa9325c83014@easystack.cn>
Date:   Tue, 5 Jan 2021 16:29:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZGhpJS04YSx0aHkJOVkpNS0JDSE5ISExOSUpVGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MCo6Mxw*Kj0wNh1CIhE6GR8q
        CBMaCgpVSlVKTUtCQ0hOSEhMTEhPVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0JPQzcG
X-HM-Tid: 0a76d1a9d6c120bdkuqy4eb4ce024e1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Lin,

     There is a patch for this situation: 
https://www.spinics.net/lists/linux-bcache/msg08870.html

     That's not in mainline yet, and not tested widely. You can give it 
a try if you are interested in.


Thanx

在 2020/12/18 星期五 下午 6:35, Lin Feng 写道:
> Hi all,
>
> I googled a lot but only finding this, my question is if this issue 
> have been fixed or
> if there are ways to work around?
>
> > On Wed, 28 Jun 2017, Coly Li wrote:
> >
> > > On 2017/6/27 下午8:04, tang.junhui@xxxxxxxxxx wrote:
> > > > Hello Eric, Coly,
> > > >
> > > > I use a 1400G SSD device a bcache cache device,
> > > > and attach with 10 back-end devices,
> > > > and run random small write IOs,
> > > > when gc works, It takes about 15 seconds,
> > > > and the up layer application IOs was suspended at this time,
> > > > How could we bear such a long time IO stopping?
> > > > Is there any way we can avoid this problem?
> > > >
> > > > I am very anxious about this question, any comment would be 
> valuable.
> > >
> > > I encounter same situation too.
> > > Hmm, I assume there are some locking issue here, to prevent 
> application
> > > to send request and insert keys in LSM tree, no matter in 
> writeback or
> > > writethrough mode. This is a lazy and fast response, I need to 
> check the
> > > code then provide an accurate reply :-)
> >
>
> I encoutered even worse situation(8TB ssd cached for 4*10 TB disks) as 
> mail extracted above,
> all usrer IOs are hung during bcache GC runs, my kernel is 4.18, while 
> I tested it with kernel 5.10,
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
> sdb               0.00     0.50 1325.00   27.00 169600.00 122.00   
> 251.07     0.32    0.24    0.24    0.02   0.13  17.90
> sdc               0.00     0.00    0.00    0.00     0.00 0.00     
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> sdd               0.00     0.00    0.00    0.00     0.00 0.00     
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> sde               0.00     0.00    0.00    0.00     0.00 0.00     
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> sdf               0.00     0.00    0.00    0.00     0.00 0.00     
> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
> bcache0           0.00     0.00    1.00    0.00     4.00 0.00     
> 8.00    39.54    0.00    0.00    0.00 1000.00 100.00
>
> # grep . 
> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/*gc*
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
>
>
> Thanks and Best wishes!
> linfeng
>

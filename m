Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8C682E7C
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2019 11:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732262AbfHFJMl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Aug 2019 05:12:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36941 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732427AbfHFJMl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Aug 2019 05:12:41 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andrea.righi@canonical.com>)
        id 1huvWJ-0000nM-A3
        for linux-bcache@vger.kernel.org; Tue, 06 Aug 2019 09:12:39 +0000
Received: by mail-wr1-f69.google.com with SMTP id x2so41847586wru.22
        for <linux-bcache@vger.kernel.org>; Tue, 06 Aug 2019 02:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DCLv3sMLBM925x8RSSNrHS4fEWxpwWMaXUx5IHkTnME=;
        b=YUUES38bZCsDXD36grxLBXpN9K9M1sJboPbjVDPIouN/fyUOv49N5LEpkD6MInf4Vs
         /l86FUbOhHU5p4Lcc4SHoErRxUaUurTj8VE+7WzYkZuFC1jR0zS/W6X5WllN2A52mYuh
         G89Sji+omcYWjfqpusvB186ld6/GCQjVtpOPBnrudalPXoh80tNnPeekB1PTwjzlBq3P
         uCbqbZ/vSB5MusFEFwjTanrCkQHPAQLhFcNpwOx9oDR1ozoROhpnQOMJBFstH5scCGYj
         lf6N/bLw6oLbSbtE1Dcl94tyqpaFb6Xt7Q7sITPMIMYxSPMLLou/oy8KqISTe5u4PdS+
         5G+A==
X-Gm-Message-State: APjAAAX87AJETfZy6urAEjrtU/6VU4DZ1ZOwrrGRlxl+TjC7dl1HHkxZ
        zprzuWfE0W9ga6Ckr87EctYwtsAXz6Cl6zxf1pxMrApm1X08MzAn9yJscMLers5xkHSQrjlMqbL
        s1yRMSc9kWCzhCiGY8/OsZcfiuJVBGoOkMlwdCHY1jA==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr3497171wrw.138.1565082758893;
        Tue, 06 Aug 2019 02:12:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/EKQczQQX5exzpECaaGyMZUukVREGnhBXUlXmObgskQQNmS6Chwa8ZH38w6QMMOlHTKDD3A==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr3497143wrw.138.1565082758555;
        Tue, 06 Aug 2019 02:12:38 -0700 (PDT)
Received: from localhost (host21-131-dynamic.46-79-r.retail.telecomitalia.it. [79.46.131.21])
        by smtp.gmail.com with ESMTPSA id y7sm64261675wmm.19.2019.08.06.02.12.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 02:12:38 -0700 (PDT)
Date:   Tue, 6 Aug 2019 11:12:37 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: fix deadlock in bcache_allocator()
Message-ID: <20190806091237.GB11184@xps-13>
References: <20190710093117.GA2792@xps-13>
 <82f1c5a9-9da4-3529-1ca5-af724d280580@suse.de>
 <20190710154656.GA7572@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710154656.GA7572@xps-13>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Jul 10, 2019 at 05:46:56PM +0200, Andrea Righi wrote:
> On Wed, Jul 10, 2019 at 11:11:37PM +0800, Coly Li wrote:
> > On 2019/7/10 5:31 下午, Andrea Righi wrote:
> > > bcache_allocator() can call the following:
> > > 
> > >  bch_allocator_thread()
> > >   -> bch_prio_write()
> > >      -> bch_bucket_alloc()
> > >         -> wait on &ca->set->bucket_wait
> > > 
> > > But the wake up event on bucket_wait is supposed to come from
> > > bch_allocator_thread() itself => deadlock:
> > > 
> > >  [ 242.888435] INFO: task bcache_allocato:9015 blocked for more than 120 seconds.
> > >  [ 242.893786] Not tainted 4.20.0-042000rc3-generic #201811182231
> > >  [ 242.896669] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > >  [ 242.900428] bcache_allocato D 0 9015 2 0x80000000
> > >  [ 242.900434] Call Trace:
> > >  [ 242.900448] __schedule+0x2a2/0x880
> > >  [ 242.900455] ? __schedule+0x2aa/0x880
> > >  [ 242.900462] schedule+0x2c/0x80
> > >  [ 242.900480] bch_bucket_alloc+0x19d/0x380 [bcache]
> > >  [ 242.900503] ? wait_woken+0x80/0x80
> > >  [ 242.900519] bch_prio_write+0x190/0x340 [bcache]
> > >  [ 242.900530] bch_allocator_thread+0x482/0xd10 [bcache]
> > >  [ 242.900535] kthread+0x120/0x140
> > >  [ 242.900546] ? bch_invalidate_one_bucket+0x80/0x80 [bcache]
> > >  [ 242.900549] ? kthread_park+0x90/0x90
> > >  [ 242.900554] ret_from_fork+0x35/0x40
> > > 
> > > Fix by making the call to bch_prio_write() non-blocking, so that
> > > bch_allocator_thread() never waits on itself.
> > > 
> > > Moreover, make sure to wake up the garbage collector thread when
> > > bch_prio_write() is failing to allocate buckets.
> > > 
> > > BugLink: https://bugs.launchpad.net/bugs/1784665
> > > Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> > 
> > Hi Andrea,
> > 
> 
> Hi Coly,
> 
> > >From the BugLink, it seems several critical bcache fixes are missing.
> > Could you please to try current 5.3-rc kernel, and try whether such
> > problem exists or not ?
> 
> Sure, I'll do a test with the latest 5.3-rc kernel. I just wanna mention
> that I've been able to reproduce this problem after backporting all the
> fixes (even those from linux-next), but I agree that testing 5.3-rc is a
> better idea (I may have introduced bugs while backporting stuff).

Finally I've been able to do a test with the latest 5.3.0-rc3 vanilla
kernel (from today's Linus git) and I confirm that I can reproduce the
same deadlock issue:

[ 1158.490744] INFO: task bcache_allocato:15861 blocked for more than 120 seconds.
[ 1158.495929]       Not tainted 5.3.0-050300rc3-generic #201908042232
[ 1158.500653] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1158.504413] bcache_allocato D    0 15861      2 0x80004000
[ 1158.504419] Call Trace:
[ 1158.504429]  __schedule+0x2a8/0x670
[ 1158.504432]  schedule+0x2d/0x90
[ 1158.504448]  bch_bucket_alloc+0xe5/0x370 [bcache]
[ 1158.504453]  ? wait_woken+0x80/0x80
[ 1158.504466]  bch_prio_write+0x1dc/0x390 [bcache]
[ 1158.504476]  bch_allocator_thread+0x233/0x490 [bcache]
[ 1158.504491]  kthread+0x121/0x140
[ 1158.504503]  ? invalidate_buckets+0x890/0x890 [bcache]
[ 1158.504506]  ? kthread_park+0xb0/0xb0
[ 1158.504510]  ret_from_fork+0x35/0x40

[ 1158.473567] INFO: task python3:13282 blocked for more than 120 seconds.
[ 1158.479846]       Not tainted 5.3.0-050300rc3-generic #201908042232
[ 1158.484503] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1158.490237] python3         D    0 13282  13274 0x00004000
[ 1158.490246] Call Trace:
[ 1158.490347]  __schedule+0x2a8/0x670
[ 1158.490360]  ? __switch_to_asm+0x40/0x70
[ 1158.490365]  schedule+0x2d/0x90
[ 1158.490433]  bch_bucket_alloc+0xe5/0x370 [bcache]
[ 1158.490468]  ? wait_woken+0x80/0x80
[ 1158.490484]  __bch_bucket_alloc_set+0x10d/0x160 [bcache]
[ 1158.490497]  bch_bucket_alloc_set+0x4e/0x70 [bcache]
[ 1158.490519]  __uuid_write+0x61/0x180 [bcache]
[ 1158.490538]  ? __write_super+0x154/0x190 [bcache]
[ 1158.490556]  bch_uuid_write+0x16/0x40 [bcache]
[ 1158.490573]  __cached_dev_store+0x668/0x8c0 [bcache]
[ 1158.490592]  bch_cached_dev_store+0x46/0x110 [bcache]
[ 1158.490623]  sysfs_kf_write+0x3c/0x50
[ 1158.490631]  kernfs_fop_write+0x125/0x1a0
[ 1158.490648]  __vfs_write+0x1b/0x40
[ 1158.490654]  vfs_write+0xb1/0x1a0
[ 1158.490658]  ksys_write+0xa7/0xe0
[ 1158.490663]  __x64_sys_write+0x1a/0x20
[ 1158.490675]  do_syscall_64+0x5a/0x130
[ 1158.490685]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

A better reproducer have been posted here:
https://launchpadlibrarian.net/435523192/curtin-nvme.sh

(see https://bugs.launchpad.net/curtin/+bug/1796292 for more details)

With this new reproducer script is very easy to hit the deadlock.

I've slightly modified my original patch and with that applied it seems
that I can't trigger any problem. I'm not sure if my patch is actually
the right thing to do, but it seems to prevent the deadlock from
happening.

I'll send a v2 soon.

-Andrea

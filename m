Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9626A10E3A4
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Dec 2019 22:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfLAVkQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 1 Dec 2019 16:40:16 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:35176 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbfLAVkQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 1 Dec 2019 16:40:16 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 2BF18A0693;
        Sun,  1 Dec 2019 21:40:15 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id YrZGrFGIhlXD; Sun,  1 Dec 2019 21:39:44 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 839ACA0440;
        Sun,  1 Dec 2019 21:39:39 +0000 (UTC)
Date:   Sun, 1 Dec 2019 21:39:38 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Eddie Chapman <eddie@ehuk.net>
cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Subject: Re: Backport bcache v5.4 to v4.19
In-Reply-To: <ded403fa-7f78-69e9-9d12-d16114246b18@ehuk.net>
Message-ID: <alpine.LRH.2.11.1912012137250.11561@mx.ewheeler.net>
References: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net> <cf687ad0-ca8a-dd9a-5959-079762c7a7e5@suse.de> <ded403fa-7f78-69e9-9d12-d16114246b18@ehuk.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-844282404-39253078-1575236379=:11561"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---844282404-39253078-1575236379=:11561
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 1 Dec 2019, Eddie Chapman wrote:
> On 01/12/2019 08:45, Coly Li wrote:
> > On 2019/12/1 6:34 上午, Eric Wheeler wrote:
> > > Hi Coly,
> > >
> > > We use 4.19.y and there have been many performance and stability changes
> > > since then.  I'm considering backporting the 5.4 version into 4.19 and
> > > wondered:
> > >
> > > Are there any changes in bcache between 4.19 and 5.4 that depend on new
> > > features elsewhere in the kernel, or should I basically be able to copy
> > > the tree from 5.4 to 4.19 and fix minor compilation issues?
> > >
> > > Can you think of any issues that would arise from such a backport?
> > 
> > Hi Eric,
> > 
> > It should be OK to backport bcache patches from 5.4 to 4.19. I did
> > similar thing for SUSE Enterprise kernel which were based on Linux 4.12
> > code base, and the changes was tiny.
> > 
> > If you encounter problem during the backport, you may post the .rej file
> > and maybe I can help.
> 
> Hi Eric, Coly,
> 
> I have been applying the list below to kernel.org 4.19.x latest stable and
> using it on several production machines without any issues for months apart
> from the newer ones of course.  Apart from the odd context adjust I don't
> think any needed any modifying. My list used to be much bigger but a lot has
> been backported already in 4.19.x stable so my list has gone down quite a lot
> :-)

Thanks Coly and Eddie for the feedback.  I just booted the patched 4.19.86 
kernel, will let you know if I notice any issues.

--
Eric Wheeler


> 
> Sorry I don't use git but if I run in my patches directory as it is currently
> the list is:
> 
> egrep '^Subject' *.patch
> 
> 00a.patch:Subject: bcache: account size of buckets used in uuid write to
> 00b.patch:Subject: bcache: fix typo in code comments of
> closure_return_with_destructor()
> 00c.patch:Subject: bcache: recal cached_dev_sectors on detach
> 01.patch:Subject: bcache: remove unused bch_passthrough_cache
> 02.patch:Subject: bcache: remove useless parameter of bch_debug_init()
> 03.patch:Subject: bcache: use MAX_CACHES_PER_SET instead of magic number 8 in
> 05.patch:Subject: bcache: do not check if debug dentry is ERR or NULL
> explicitly on
> 06.patch:Subject: bcache: do not mark writeback_running too early
> 07.patch:Subject: bcache: cannot set writeback_running via sysfs if no
> writeback
> 08.patch:Subject: bcache: introduce force_wake_up_gc()
> 09.patch:Subject: bcache: not use hard coded memset size in
> 11.patch:Subject: bcache: fix input integer overflow of congested threshold
> 13.patch:Subject: bcache: add sysfs_strtoul_bool() for setting bit-field
> variables
> 14.patch:Subject: bcache: use sysfs_strtoul_bool() to set bit-field variables
> 15.patch:Subject: bcache: fix input overflow to writeback_delay
> 17.patch:Subject: bcache: fix input overflow to journal_delay_ms
> 18.patch:Subject: bcache: fix input overflow to cache set io_error_limit
> 20.patch:Subject: bcache: fix crashes stopping bcache device before read miss
> done
> 22.patch:Subject: bcache: fix inaccurate result of unused buckets
> 24.patch:Subject: bcache: add error check for calling register_bdev()
> 26.patch:Subject: bcache: improve bcache_reboot()
> 28.patch:Subject: bcache: fix wrong usage use-after-freed on keylist in
> out_nocoalesce
> 30.patch:Subject: [PATCH 07/12] bcache: fix deadlock in bcache_allocator
> 
> 
---844282404-39253078-1575236379=:11561--

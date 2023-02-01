Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19850686D92
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Feb 2023 19:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjBASE3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Feb 2023 13:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjBASE3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2023 13:04:29 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6211E2BD
        for <linux-bcache@vger.kernel.org>; Wed,  1 Feb 2023 10:04:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 1399349;
        Wed,  1 Feb 2023 10:04:27 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id zQ4XwZbZBJUK; Wed,  1 Feb 2023 10:04:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9109446;
        Wed,  1 Feb 2023 10:04:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9109446
Date:   Wed, 1 Feb 2023 10:04:22 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
cc:     mingzhe <mingzhe.zou@easystack.cn>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: Multi-Level Caching
In-Reply-To: <CAHykVA5DmjjuLan1N9cHkhshtZ==M0FVjEJ7cHGjWBymE4kP0A@mail.gmail.com>
Message-ID: <d79844de-ab8a-f7c-087-122fade2064@ewheeler.net>
References: <CAHykVA6L3bQkGJ11N3jG_QSgPbyr40zc8rBNPPwBN9a5RHwC6Q@mail.gmail.com> <AA6912BA-7DE5-466E-8E85-9EB58FCFC81D@suse.de> <3ac5b76c-4f73-5668-50da-d3038f162040@easystack.cn> <CAHykVA5DmjjuLan1N9cHkhshtZ==M0FVjEJ7cHGjWBymE4kP0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1489476978-1675274662=:28752"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1489476978-1675274662=:28752
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 1 Feb 2023, Andrea Tomassetti wrote:
> Hi Coly,
> 
> On Wed, Feb 1, 2023 at 4:03 AM mingzhe <mingzhe.zou@easystack.cn> wrote:
> > 在 2023/1/31 23:51, Coly Li 写道:
> > >> 2023年1月26日 19:30，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
> > >>
> > >> Hi,
> > >> I know that bcache doesn't natively support multi-level caching but I
> > >> was playing with it and found this interesting "workaround":
> > >>   make-bcache -B /dev/vdb -C /dev/vdc
> > >> the above command will generate a /dev/bcache0 device that we can now
> > >> use as backing (or cached) device:
> > >>   make-bcache -B /dev/bcache0 -C /dev/vdd
> > >> This will make the kernel panic because the driver is trying to create
> > >> a duplicated "bcache" folder under /sys/block/bcache0/ .
> > >> So, simply patching the code inside register_bdev to create a folder
> > >> "bcache2" if "bcache" already exists does the trick.
> > >> Now I have:
> > >> vdb                       252:16   0    5G  0 disk
> > >> └─bcache0                 251:0    0    5G  0 disk
> > >>   └─bcache1               251:128  0    5G  0 disk /mnt/bcache1
> > >> vdc                       252:32   0   10G  0 disk
> > >> └─bcache0                 251:0    0    5G  0 disk
> > >>   └─bcache1               251:128  0    5G  0 disk /mnt/bcache1
> > >> vdd                       252:48   0    5G  0 disk
> > >> └─bcache1                 251:128  0    5G  0 disk /mnt/bcache1
> > >>
> > >> Is anyone using this functionality? I assume not, because by default
> > >> it doesn't work.
> > >> Is there any good reason why this doesn't work by default?
> > >>
> > >> I tried to understand how data will be read out of /dev/bcache1: will
> > >> the /dev/vdd cache, secondly created cache device, be interrogated
> > >> first and then will it be the turn of /dev/vdc ?
> > >> Meaning: can we consider that now the layer structure is
> > >>
> > >> vdd
> > >> └─vdc
> > >>        └─bcache0
> > >>              └─bcache1
> > >> ?
> > >
> > > IIRC, there was a patch tried to achieve similar purpose. I was not supportive for this idea because I didn’t see really useful use case.
> I didn't test it extensively but it looks like that the patch to
> achieve this is just a one-line patch, it could be very beneficial. (I
> just realized that mingzhe sent a relevant patch on this, thank for
> your work)
> Our use case will be to be able to take advantage of different
> blocking devices that differ in performance and cost.
> Some of these blocking devices are ephemeral and not suitable for wb
> cache mode, but stacking them with non-ephemeral ones would be a very
> nice and neat solution.

I like that!  

I've always wondered how a 64GB writethrough cache ram cache (/dev/ram0 or 
/dev/zram0) would perform on top of an NVMe backed by spinning disks.

I've also wondered about this kind of heirarchy:

/dev/ram0 -> /dev/zram0 -> /dev/nvme0n1 -> /dev/sda

--
Eric Wheeler



> 
> Cheers,
> Andrea
> 
> 
> >
> > Hi, Coly
> >
> > Maybe we have a case like this. We are considering make-bcache a hdd as
> > a cache device and create a flash device in it, and then using the flash
> > device as a backing. So， completely converts writeback to sequential
> > writes.
> >
> > However, we found that there may be many unknown problems in the flash
> > device, such as the created size, etc.
> >
> > For now, we've put it due to time，but we think it might be a good thing
> > to do. We also have some patches, I will post them.
> >
> > mingzhe
> >
> > > In general, extra layer cache means extra latency in the I/O path. What I see in practical deployments are, people try very hard to minimize the cache layer and place it close to application.
> > >
> > > Introduce stackable bcache for itself may work, but I don’t see real usage yet, and no motivation to maintain such usage still.
> > >
> > > Thanks.
> > >
> > > Coly Li
> 
--8323328-1489476978-1675274662=:28752--

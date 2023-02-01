Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF008685CAA
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Feb 2023 02:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjBABgc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 Jan 2023 20:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjBABga (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Jan 2023 20:36:30 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0D04FAE4
        for <linux-bcache@vger.kernel.org>; Tue, 31 Jan 2023 17:36:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id C96B985;
        Tue, 31 Jan 2023 17:36:25 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id JLXeELaEFYmB; Tue, 31 Jan 2023 17:36:21 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 6C56846;
        Tue, 31 Jan 2023 17:36:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 6C56846
Date:   Tue, 31 Jan 2023 17:36:16 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: Multi-Level Caching
In-Reply-To: <AA6912BA-7DE5-466E-8E85-9EB58FCFC81D@suse.de>
Message-ID: <1dfb124e-3076-a5b8-96c9-a391bcdd70@ewheeler.net>
References: <CAHykVA6L3bQkGJ11N3jG_QSgPbyr40zc8rBNPPwBN9a5RHwC6Q@mail.gmail.com> <AA6912BA-7DE5-466E-8E85-9EB58FCFC81D@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-968939147-1675215381=:28752"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-968939147-1675215381=:28752
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 31 Jan 2023, Coly Li wrote:
> > 2023年1月26日 19:30，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
> > 
> > Hi,
> > I know that bcache doesn't natively support multi-level caching but I
> > was playing with it and found this interesting "workaround":
> >  make-bcache -B /dev/vdb -C /dev/vdc
> > the above command will generate a /dev/bcache0 device that we can now
> > use as backing (or cached) device:
> >  make-bcache -B /dev/bcache0 -C /dev/vdd
> > This will make the kernel panic because the driver is trying to create
> > a duplicated "bcache" folder under /sys/block/bcache0/ .

panic? Ouch.

> > So, simply patching the code inside register_bdev to create a folder
> > "bcache2" if "bcache" already exists does the trick.
> > Now I have:
> > vdb                       252:16   0    5G  0 disk
> > └─bcache0                 251:0    0    5G  0 disk
> >  └─bcache1               251:128  0    5G  0 disk /mnt/bcache1
> > vdc                       252:32   0   10G  0 disk
> > └─bcache0                 251:0    0    5G  0 disk
> >  └─bcache1               251:128  0    5G  0 disk /mnt/bcache1
> > vdd                       252:48   0    5G  0 disk
> > └─bcache1                 251:128  0    5G  0 disk /mnt/bcache1
> > 
> > Is anyone using this functionality? I assume not, because by default
> > it doesn't work.
> > Is there any good reason why this doesn't work by default?
> > 
> > I tried to understand how data will be read out of /dev/bcache1: will
> > the /dev/vdd cache, secondly created cache device, be interrogated
> > first and then will it be the turn of /dev/vdc ?
> > Meaning: can we consider that now the layer structure is
> > 
> > vdd
> > └─vdc
> >       └─bcache0
> >             └─bcache1
> > ?
> 
> IIRC, there was a patch tried to achieve similar purpose. I was not 
> supportive for this idea because I didn’t see really useful use case. In 
> general, extra layer cache means extra latency in the I/O path. What I 
> see in practical deployments are, people try very hard to minimize the 
> cache layer and place it close to application.
> 
> Introduce stackable bcache for itself may work, but I don’t see real 
> usage yet, and no motivation to maintain such usage still.

Hi Coly, 

If Andrea's patch is simple and prevents a panic, would you consider 
accepting it?  Users should not be able to crash the kernel no matter what 
they do. Perhaps this should be considered a bug.

If so, then Andrea, can you post your suggested patch for review?

-Eric

> 
> Thanks.
> 
> Coly Li
--8323328-968939147-1675215381=:28752--

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B51485F36
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 04:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiAFD3O (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jan 2022 22:29:14 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:33228 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbiAFD3N (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jan 2022 22:29:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 1D16141;
        Wed,  5 Jan 2022 19:29:13 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id EF3nXm4EoBAl; Wed,  5 Jan 2022 19:29:08 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 32F2439;
        Wed,  5 Jan 2022 19:29:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 32F2439
Date:   Wed, 5 Jan 2022 19:29:05 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     linux-block@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bcache: make stripe_size configurable and persistent
 for hardware raid5/6
In-Reply-To: <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
Message-ID: <fdb85dc1-eee6-e55e-8e9c-fa1f36b4a37@ewheeler.net>
References: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de> <1561245371-10235-1-git-send-email-bcache@lists.ewheeler.net> <200638b0-7cba-38b4-20c4-b325f3cfe862@suse.de> <alpine.LRH.2.11.1906241800350.1114@mx.ewheeler.net>
 <8a9131dc-9bf7-a24a-f7b8-35e0c019e905@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1944457719-1641439748=:4450"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1944457719-1641439748=:4450
Content-Type: text/plain; charset=iso-2022-jp

On Tue, 25 Jun 2019, Coly Li wrote:
> On 2019/6/25 2:14 上午, Eric Wheeler wrote:
> > On Mon, 24 Jun 2019, Coly Li wrote:
> > 
> >> On 2019/6/23 7:16 上午, Eric Wheeler wrote:
> >>> From: Eric Wheeler <git@linux.ewheeler.net>
> >>>
> >>> While some drivers set queue_limits.io_opt (e.g., md raid5), there are
> >>> currently no SCSI/RAID controller drivers that do.  Previously stripe_size
> >>> and partial_stripes_expensive were read-only values and could not be
> >>> tuned by users (eg, for hardware RAID5/6).
> >>>
> >>> This patch enables users to save the optimal IO size via sysfs through
> >>> the backing device attributes stripe_size and partial_stripes_expensive
> >>> into the bcache superblock.
> >>>
> >>> Superblock changes are backwards-compatable:
> >>>
> >>> *  partial_stripes_expensive: One bit was used in the superblock flags field
> >>>
> >>> *  stripe_size: There are eight 64-bit "pad" fields for future use in
> >>>    the superblock which default to 0; from those, 32-bits are now used
> >>>    to save the stripe_size and load at device registration time.
> >>>
> >>> Signed-off-by: Eric Wheeler <bcache@linux.ewheeler.net>
> >>
> >> Hi Eric,
> >>
> >> In general I am OK with this patch. Since Peter comments lots of SCSI
> >> RAID devices reports a stripe width, could you please list the hardware
> >> raid devices which don't list stripe size ? Then we can make decision
> >> whether it is necessary to have such option enabled.
> > 
> > Perhaps they do not set stripe_width using io_opt? I did a grep to see if 
> > any of them did, but I didn't see them. How is stripe_width indicated by 
> > RAID controllers? 
> > 
> > If they do set io_opt, then at least my Areca 1883 does not set io_opt as 
> > of 4.19.x. I also have a LSI MegaRAID 3108 which does not report io_opt as 
> > of 4.1.x, but that is an older kernel so maybe support has been added 
> > since then.
> > 
> > Martin,
> > 
> > Where would stripe_width be configured in the SCSI drivers? Is it visible 
> > through sysfs or debugfs so I can check my hardware support without 
> > hacking debugging the kernel?
> > 
> >>
> >> Another point is, this patch changes struct cache_sb, it is no problem
> >> to change on-disk format. I plan to update the super block version soon,
> >> to store more configuration persistently into super block. stripe_size
> >> can be added to cache_sb with other on-disk changes.
> > 
> 
> Hi Eric,
> 
> > Maybe bumping version makes sense, but even if you do not, this is safe to 
> > use on systems without bumping the version because the values are unused 
> > and default to 0.
> 
> Yes, I understand you, it works as you suggested. I need to think how to
> organize all options in struct cache_sb, stripe_size will be arranged
> then. And I will ask help to you for reviewing the changes of on-disk
> format.

Hi Coli,

Just checking in, its been a while and I didn't see any more discussion on 
the topic:

This would benefit users with older RAID controllers using RAID-5/6 that 
don't set io_opt.

Even new new RAID controlers that _do_ provide `io_opt` still do _not_ 
indicate partial_stripes_expensive (which is an mdraid feature, but Martin 
please correct me if I'm wrong here).  Thus, all hardware RAID-5/6 users 
could benefit by manually flagging partial_stripes_expensive to get burst 
writes out of bcache that fit their stride width.

This patch probably needs rebased and documentation updated about io_opt, 
but here is the original patch with documentation for your reference:
	https://lkml.org/lkml/2019/6/22/298

What do you think?

-Eric

> 
> Thanks.
> 
> [snipped]
> 
> -- 
> 
> Coly Li
> 
--8323328-1944457719-1641439748=:4450--

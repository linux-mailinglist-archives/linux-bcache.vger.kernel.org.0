Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FAEFA4CF
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 03:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbfKMCSm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Nov 2019 21:18:42 -0500
Received: from smtp12.dentaku.gol.com ([203.216.5.74]:31542 "EHLO
        smtp12.dentaku.gol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbfKMCSl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Nov 2019 21:18:41 -0500
Received: from batzmaru.gol.ad.jp ([203.216.0.80])
        by smtp12.dentaku.gol.com with esmtpa (Dentaku)
        (envelope-from <chibi@gol.com>)
        id 1iUiEu-0002JR-UH; Wed, 13 Nov 2019 11:18:38 +0900
Date:   Wed, 13 Nov 2019 11:18:36 +0900
From:   Christian Balzer <chibi@gol.com>
To:     Tim Small <tim@buttersideup.com>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
Message-ID: <20191113111836.5ebf1c82@batzmaru.gol.ad.jp>
In-Reply-To: <941fdfe3-20d5-8333-6aab-d3cd7f992e31@buttersideup.com>
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
        <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
        <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
        <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
        <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
        <941fdfe3-20d5-8333-6aab-d3cd7f992e31@buttersideup.com>
Organization: Rakuten Communications
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: ClamAV GOL (outbound)
X-GOL-Outbound-Spam-Score: -1.9
X-Abuse-Complaints: abuse@gol.com
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Hello,

On Tue, 12 Nov 2019 08:54:21 +0000 Tim Small wrote:

> On 12/11/2019 06:39, Christian Balzer wrote:
> >> From internal
> >> customers and external users, the feedback of maximum writeback rate is
> >> quite positive. This is the first time I realize not everyone wants it.
> >>  
> > The full speed (1TB/s) rate will result in initially high speeds (up to
> > 280MBs) in most tests, but degrade (and cause load spikes -> alarms) later
> > on, often resulting in it taking LONGER than if it had stuck with the
> > 4MB/s minimum rate set.
> > So yes, in my case something like a 32MB/s maximum rate would probably be
> > perfect.  
> 
> 
> I have some backup/archival targetted "drive-managed" SMR drives which
> include a non-SMR magnetic storage cache area which can cause this sort
> of behaviour.
> 
SMR! (makes signs to ward off evil! :)

> Sustained random writes make the drives fill their cache, and then
> performance falls off a cliff, since the drive must start making many
> read-modify-write passes in the SMR area.
> 
But yes, it's a decent enough analogy to a RAID controller with HW cache
backed by a RAID6 on HDDs. 
And every I/O system with caches experiences that cliff (all is great
until it totally goes to hell in a handbasket), thus my hopes to avoid
this needlessly. 

> e.g. this latency result:
> 
> https://www.storagereview.com/images/seagate_archive_8tb_sata_main_4kwrite_avglatency.png
> 
> (taken from https://www.storagereview.com/node/4665) - which illustrates
> performance after the drive's non-SMR internal write cache area is full.
> 
> There is somewhat similar behaviour from some SSDs (plus the additional
> potential problem of thermal throttling from sustained writes, and other
> internal house-keeping operations):
> 
> https://www.tweaktown.com/image.php?image=images.tweaktown.com/content/8/8/8875_005_samsung-970-evo-plus-ssd-review-96-layer-refresh_full.png
> 
> 
> Perhaps bcache could monitor backing store write latency and back-off to
> avoid this condition?
> 
DRBD does a decent job in that area and while this sounds good I'm always
worried about needless complexity in things that should be very simple (and
thus less error prone) and fast.
And since bcache is supposed to speed things UP, a complex code path may
also prove counterproductive, as can be seen in things like Ceph.

Regards,

Christian
-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Rakuten Mobile Inc.

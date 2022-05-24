Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF845332FA
	for <lists+linux-bcache@lfdr.de>; Tue, 24 May 2022 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241637AbiEXVef (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 May 2022 17:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiEXVea (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 May 2022 17:34:30 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A677B9E0;
        Tue, 24 May 2022 14:34:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id D63E64A;
        Tue, 24 May 2022 14:34:28 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id qHMShKg0x9pW; Tue, 24 May 2022 14:34:28 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id C376740;
        Tue, 24 May 2022 14:34:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net C376740
Date:   Tue, 24 May 2022 14:34:23 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Keith Busch <kbusch@kernel.org>
cc:     Christoph Hellwig <hch@infradead.org>, Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
In-Reply-To: <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
Message-ID: <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net> <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 24 May 2022, Keith Busch wrote:
> On Tue, May 24, 2022 at 01:14:18PM -0700, Eric Wheeler wrote:
> > Hi Christoph,
> > 
> > On Mon, 23 May 2022, Christoph Hellwig wrote:
> > > ... wait.
> > > 
> > > Can someone explain what this is all about?  Devices with power fail 
> > > protection will advertise that (using VWC flag in NVMe for example) and 
> > > we will never send flushes. So anything that explicitly disables flushed 
> > > will generally cause data corruption.
> > 
> > Adriano was getting 1.5ms sync-write ioping's to an NVMe through bcache 
> > (instead of the expected ~70us), so perhaps the NVMe flushes were killing 
> > performance if every write was also forcing an erase cycle.
> > 
> > The suggestion was to disable flushes in bcache as a troubleshooting step 
> > to see if that solved the problem, but with the warning that it could be 
> > unsafe.
> > 
> > Questions:
> > 
> > 1. If a user knows their disks have a non-volatile cache then is it safe 
> >    to drop flushes?
> > 
> > 2. If not, then under what circumstances is it unsafe with a non-volatile 
> >    cache?
> >   
> > 3. Since the block layer wont send flushes when the hardware reports that 
> >    the cache is non-volatile, then how do you query the device to make 
> >    sure it is reporting correctly?  For NVMe you can get VWC as:
> > 	nvme id-ctrl -H /dev/nvme0 |grep -A1 vwc
> >    
> >    ...but how do you query a block device (like a RAID LUN) to make sure 
> >    it is reporting a non-volatile cache correctly?
> 
> You can check the queue attribute, /sys/block/<disk>/queue/write_cache. If the
> value is "write through", then the device is reporting it doesn't have a
> volatile cache. If it is "write back", then it has a volatile cache.
 
Thanks, Keith!  

Is this flag influced at all when /sys/block/sdX/queue/scheduler is set 
to "none", or does the write_cache flag operate independently of the 
selected scheduler?

Does the block layer stop sending flushes at the first device in the stack 
that is set to "write back"?  For example, if a device mapper target is 
writeback will it strip flushes on the way to the backing device?

This confirms what I have suspected all along: We have an LSI MegaRAID 
SAS-3516 where the write policy is "write back" in the LUN, but the cache 
is flagged in Linux as write-through:

	]# cat /sys/block/sdb/queue/write_cache 
	write through

I guess this is the correct place to adjust that behavior!


--
Eric Wheeler


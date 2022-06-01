Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDC553AD05
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jun 2022 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiFASsm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jun 2022 14:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiFASsm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jun 2022 14:48:42 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA7CED712
        for <linux-bcache@vger.kernel.org>; Wed,  1 Jun 2022 11:48:39 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 9F4114A;
        Wed,  1 Jun 2022 11:48:38 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id wQHZmPWv5kM7; Wed,  1 Jun 2022 11:48:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id F3DC5B;
        Wed,  1 Jun 2022 11:48:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net F3DC5B
Date:   Wed, 1 Jun 2022 11:48:33 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Keith Busch <kbusch@kernel.org>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Christoph Hellwig <hch@infradead.org>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>, Coly Li <colyli@suse.de>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
In-Reply-To: <Ypa0eVNwr0WjB6Cg@kbusch-mbp.dhcp.thefacebook.com>
Message-ID: <273d3e7e-4145-cdaf-2f80-dc61823dd6ea@ewheeler.net>
References: <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com> <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org> <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net> <YpGsKDQ1aAzXfyWl@infradead.org> <24456292.2324073.1653742646974@mail.yahoo.com>
 <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com> <f785ce75-da75-9976-9b60-2dd9f719b96@ewheeler.net> <YpZ482qYC929sS+v@kbusch-mbp.dhcp.thefacebook.com> <1462334e-d0ae-ded-7d0-57474f6eea@ewheeler.net> <Ypa0eVNwr0WjB6Cg@kbusch-mbp.dhcp.thefacebook.com>
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

On Tue, 31 May 2022, Keith Busch wrote:
> On Tue, May 31, 2022 at 04:04:12PM -0700, Eric Wheeler wrote:
> > 
> >   * Write-through: write is done synchronously both to the cache and to 
> >     the backing store.
> > 
> >   * Write-back (also called write-behind): initially, writing is done only 
> >     to the cache. The write to the backing store is postponed until the 
> >     modified content is about to be replaced by another cache block.
> >   [ https://en.wikipedia.org/wiki/Cache_(computing)#Writing_policies ]
> > 
> > 
> > So the kernel's notion of "write through" meaning "Drop FLUSH/FUA" sounds 
> > like the industry meaning of "write-back" as defined above; conversely, 
> > the kernel's notion of "write back" sounds like the industry definition of 
> > "write-through"
> > 
> > Is there a well-meaning rationale for the kernel's concept of "write 
> > through" to be different than what end users have been conditioned to 
> > understand?
> 
> I think we all agree what "write through" vs "write back" mean. I'm just not
> sure what's the source of the disconnect with the kernel's behavior.
> 
>   A "write through" device persists data before completing a write operation.
> 
>   Flush/FUA says to write data to persistence before completing the operation.
> 
> You don't need both. Flush/FUA should be a no-op to a "write through" device
> because the data is synchronously committed to the backing store automatically.

Ok, I think I'm starting to understand the rationale, thank you for your 
patience while I've come to wrap my head around it. So, using a RAID 
controller cache as an example:

1. A RAID controller with a _non-volatile_ "writeback" cache (from the 
   controller's perspective, ie, _with_ battery) is a "write through"  
   device as far as the kernel is concerned because the controller will 
   return the write as complete as soon as it is in the persistent cache.

2. A RAID controller with a _volatile_ "writeback" cache (from the 
   controller's perspective, ie _without_ battery) is a "write back"  
   device as far as the kernel is concerned because the controller will 
   return the write as complete as soon as it is in the cache, but the 
   cache is not persistent!  So in that case flush/FUA is necessary.

I think it is rare someone would configure a RAID controller is as 
writeback (in the controller) when the cache is volatile (ie, without 
battery), but it is an interesting way to disect this to understand the 
rationale around value choices for the `queue/write_cache` flag in sysfs.

So please correct me here if I'm wrong: theoretically, a RAID controller 
with a volatile writeback cache is "safe" in terms of any flush/FIO 
behavior, assuming the controller respects those ops in writeback mode.  
For example, ext4's journal is probably consistent after a crash, even if 
2GB of cached data might be lost (assuming FUA and not FLUSH is being 
used for meta, I don't actually know ext4's implementation there).


I would guess that most end users are going to expect queue/write_cache to 
match their RAID controller's naming convention.  If they see "write 
through" when they know their controller is in writeback w/battery then 
they might reasonably expect the flag to show "write back", too.  If they 
then force it to "write back" then they loose the performance benefit.

Given that, and considering end users that configure raid controllers do 
not commonly understand the flush/FUA intracies and what really 
constitutes "write back" vs "write through" from the kernel's perspective, 
then perhaps it would be a good idea to add more documentation around 
write_cache here:

  https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt

What do you think?


--
Eric Wheeler




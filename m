Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1355399E7
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jun 2022 01:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348606AbiEaXET (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 May 2022 19:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348604AbiEaXES (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 May 2022 19:04:18 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCE25A090
        for <linux-bcache@vger.kernel.org>; Tue, 31 May 2022 16:04:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0EAD24A;
        Tue, 31 May 2022 16:04:17 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id hnoaMfyd7oKf; Tue, 31 May 2022 16:04:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 92D2DB;
        Tue, 31 May 2022 16:04:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 92D2DB
Date:   Tue, 31 May 2022 16:04:12 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Keith Busch <kbusch@kernel.org>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Christoph Hellwig <hch@infradead.org>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>, Coly Li <colyli@suse.de>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
In-Reply-To: <YpZ482qYC929sS+v@kbusch-mbp.dhcp.thefacebook.com>
Message-ID: <1462334e-d0ae-ded-7d0-57474f6eea@ewheeler.net>
References: <YoxuYU4tze9DYqHy@infradead.org> <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com> <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net> <YpGsKDQ1aAzXfyWl@infradead.org> <24456292.2324073.1653742646974@mail.yahoo.com> <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com> <f785ce75-da75-9976-9b60-2dd9f719b96@ewheeler.net>
 <YpZ482qYC929sS+v@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1323931071-1654038252=:2952"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1323931071-1654038252=:2952
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 31 May 2022, Keith Busch wrote:
> On Tue, May 31, 2022 at 12:42:49PM -0700, Eric Wheeler wrote:
> > On Sat, 28 May 2022, Keith Busch wrote:
> > > On Sat, May 28, 2022 at 12:57:26PM +0000, Adriano Silva wrote:
> > > > Dear Christoph,
> > > > 
> > > > > Once you do that, the block layer ignores all flushes and FUA bits, so
> > > > > yes it is going to be a lot faster.  But also completely unsafe because
> > > > > it does not provide any data durability guarantees.
> > > > 
> > > > Sorry, but wouldn't it be the other way around? Or did I really not 
> > > > understand your answer?
> > > > 
> > > > Sorry, I don't know anything about kernel code, but wouldn't it be the 
> > > > other way around?
> > > > 
> > > > It's just that, I may not be understanding. And it's likely that I'm 
> > > > not, because you understand more about this, I'm new to this subject. 
> > > > I know very little about it, or almost nothing.
> > > > 
> > > > But it's just that I've read the opposite about it.
> > > > 
> > > >  Isn't "write through" to provide more secure writes?
> > > > 
> > > > I also see that "write back" would be meant to be faster. No?
> > > 
> > > The sysfs "write_cache" attribute just controls what the kernel does. It
> > > doesn't change any hardware settings.
> > > 
> > > In "write back" mode, a sync write will have FUA set, which will generally be
> > > slower than a write without FUA. In "write through" mode, the kernel doesn't
> > > set FUA so the data may not be durable after the completion if the controller
> > > is using a volatile write cache.
> > 
> > Something seems wrong here: Typically on a RAID controller LUN 
> > configuration "writeback" means that the non-volatile cache is active so 
> > "write back caching" is enabled.
> > 
> > According to https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt:
> > 
> > 	"When read, this file will display whether the device has write
> > 	back caching enabled or not. It will return "write back" for the former
> > 	case, and "write through" for the latter."
> > 
> > If my text mailer would underline then I would underline this from the 
> > documentation: "whether the device has write back caching enabled or not"
> 
> Maybe this is confusing because we let the user change the kernel's behavior
> regardless of how the storage device is configured?

This is important to keep, not all controllers properly report the LUN's 
cache state, so overrides are necessary in real life...but that's not what 
we're hoping to address:
  
> > Is there a good explanation for why the kernel setting is exactly 
> > _opposite_ of the controller setting?
> 
> By default, the drivers should have the correct setting reported for their
> devices, not the opposite. The user can override the sysfs attribute to the
> opposite setting though, so it's not necessarily an accurate report of what the
> device has actually enabled.

Lets assume for the moment that drivers always set this flag correctly 
because that isn't really the issue here: This is a discussion of 
terminology.

What I mean is that the very term "write-through" means to write _through_ 
the cache and block until completion to persistent storage, whereas, 
"write-back" means to return completion to the OS before IOs reach 
persistent storage.

...or at least this is the terminology that the RAID card manufacturers 
have used for decades.  I actually checked Wikipedia (as a zeitgeist 
reference, not as an authority) just in case I've been mistaken all these 
years as to the spirit of the meaning and it aligns with what I'm trying 
to express here:

  * Write-through: write is done synchronously both to the cache and to 
    the backing store.

  * Write-back (also called write-behind): initially, writing is done only 
    to the cache. The write to the backing store is postponed until the 
    modified content is about to be replaced by another cache block.
  [ https://en.wikipedia.org/wiki/Cache_(computing)#Writing_policies ]


So the kernel's notion of "write through" meaning "Drop FLUSH/FUA" sounds 
like the industry meaning of "write-back" as defined above; conversely, 
the kernel's notion of "write back" sounds like the industry definition of 
"write-through"

Is there a well-meaning rationale for the kernel's concept of "write 
through" to be different than what end users have been conditioned to 
understand?

--
Eric Wheeler

 
--8323328-1323931071-1654038252=:2952--

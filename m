Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE9D539742
	for <lists+linux-bcache@lfdr.de>; Tue, 31 May 2022 21:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347570AbiEaTo1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 May 2022 15:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347546AbiEaToN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 May 2022 15:44:13 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C535BA5A92
        for <linux-bcache@vger.kernel.org>; Tue, 31 May 2022 12:43:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 9F6E248;
        Tue, 31 May 2022 12:42:50 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id nSF7pREpxxkr; Tue, 31 May 2022 12:42:49 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 64E77B;
        Tue, 31 May 2022 12:42:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 64E77B
Date:   Tue, 31 May 2022 12:42:49 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Keith Busch <kbusch@kernel.org>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Christoph Hellwig <hch@infradead.org>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>, Coly Li <colyli@suse.de>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
In-Reply-To: <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com>
Message-ID: <f785ce75-da75-9976-9b60-2dd9f719b96@ewheeler.net>
References: <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net> <YoxuYU4tze9DYqHy@infradead.org> <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org> <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net> <YpGsKDQ1aAzXfyWl@infradead.org> <24456292.2324073.1653742646974@mail.yahoo.com>
 <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1679726992-1654025010=:2952"
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

--8323328-1679726992-1654025010=:2952
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Sat, 28 May 2022, Keith Busch wrote:
> On Sat, May 28, 2022 at 12:57:26PM +0000, Adriano Silva wrote:
> > Dear Christoph,
> > 
> > > Once you do that, the block layer ignores all flushes and FUA bits, so
> > > yes it is going to be a lot faster.  But also completely unsafe because
> > > it does not provide any data durability guarantees.
> > 
> > Sorry, but wouldn't it be the other way around? Or did I really not 
> > understand your answer?
> > 
> > Sorry, I don't know anything about kernel code, but wouldn't it be the 
> > other way around?
> > 
> > It's just that, I may not be understanding. And it's likely that I'm 
> > not, because you understand more about this, I'm new to this subject. 
> > I know very little about it, or almost nothing.
> > 
> > But it's just that I've read the opposite about it.
> > 
> >  Isn't "write through" to provide more secure writes?
> > 
> > I also see that "write back" would be meant to be faster. No?
> 
> The sysfs "write_cache" attribute just controls what the kernel does. It
> doesn't change any hardware settings.
> 
> In "write back" mode, a sync write will have FUA set, which will generally be
> slower than a write without FUA. In "write through" mode, the kernel doesn't
> set FUA so the data may not be durable after the completion if the controller
> is using a volatile write cache.

Something seems wrong here: Typically on a RAID controller LUN 
configuration "writeback" means that the non-volatile cache is active so 
"write back caching" is enabled.

According to https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt:

	"When read, this file will display whether the device has write
	back caching enabled or not. It will return "write back" for the former
	case, and "write through" for the latter."

If my text mailer would underline then I would underline this from the 
documentation: "whether the device has write back caching enabled or not"

Is there a good explanation for why the kernel setting is exactly 
_opposite_ of the controller setting?

> > But I understand that when I do a write with direct ioping (-D) and 
> > with forced sync (-Y), then an enterprise NVME device with PLP (Power 
> > Loss Protection) like mine here should perform very well because in 
> > theory, the messages are sent to the hardware by the OS with an 
> > instruction for the Hardware to ignore the cache (correct?), but the 
> > NVME device will still put it in its local cache and give an immediate 
> > response to the OS saying that the data has been written, because he 
> > knows his local cache is a safe place for this (in theory).
> 
> If the device's power-loss protected memory is considered non-volatile, then it
> shouldn't be reporting a volatile write cache, and it may complete commands
> once the write data reaches its non-volatile cache. It can treat flush and FUA
> as no-ops.
>  
> > On the other hand, answering why writing is slow when "write back" is 
> > activated is intriguing. Could it be the software logic stack involved 
> > to do the Write Back? I don't know.
> 
> Yeah, the software stack will issue flushes and FUA in "write back" 
> mode.

If it this setting really is intended to be backwards from industry 
vernacular then perhaps it is a documentation bug...

-Eric
--8323328-1679726992-1654025010=:2952--

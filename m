Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F595397EA
	for <lists+linux-bcache@lfdr.de>; Tue, 31 May 2022 22:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237362AbiEaUWR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 May 2022 16:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiEaUWQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 May 2022 16:22:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E1A2F009
        for <linux-bcache@vger.kernel.org>; Tue, 31 May 2022 13:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28424612A5
        for <linux-bcache@vger.kernel.org>; Tue, 31 May 2022 20:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09533C385A9;
        Tue, 31 May 2022 20:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654028534;
        bh=roWsGZM+BasLwPWWs5v+eZz6hj4TQPf0LJiqGnd8sgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCZRR7wNdE8pggEUnDOpECi6h+8bPxPPrPZlyuBZBtHhrw1okmGOOOMLKiDeZjqw9
         BwoEQj97Ox7+AfVo0EMKu70/A+ZBOl6C9H6+f/DmrGv0suEG2t3LwVbK8vk8Kun0l3
         pV+QUHPaoowyCwHVeKZ9+knKG3uVzQQzwRJvB4/GhLBdbYDOb0jiF5EurjbNXVu6dx
         7kwS7kkv/SuPWugQHuseQnFgR3SwSeVnIuzoxmsB0rv5LI8SUPRUjgpcQp+YPfO9wD
         uoemRyv7rVMUpxP+lDgG4rzrVM99dwYyFSKCAPGKcL0PIdkoKV7OiQoOoQveXSUEnY
         PKrFWuM4EGGCA==
Date:   Tue, 31 May 2022 14:22:11 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Christoph Hellwig <hch@infradead.org>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>, Coly Li <colyli@suse.de>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
Message-ID: <YpZ482qYC929sS+v@kbusch-mbp.dhcp.thefacebook.com>
References: <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net>
 <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com>
 <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net>
 <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
 <YpGsKDQ1aAzXfyWl@infradead.org>
 <24456292.2324073.1653742646974@mail.yahoo.com>
 <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com>
 <f785ce75-da75-9976-9b60-2dd9f719b96@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f785ce75-da75-9976-9b60-2dd9f719b96@ewheeler.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, May 31, 2022 at 12:42:49PM -0700, Eric Wheeler wrote:
> On Sat, 28 May 2022, Keith Busch wrote:
> > On Sat, May 28, 2022 at 12:57:26PM +0000, Adriano Silva wrote:
> > > Dear Christoph,
> > > 
> > > > Once you do that, the block layer ignores all flushes and FUA bits, so
> > > > yes it is going to be a lot faster.  But also completely unsafe because
> > > > it does not provide any data durability guarantees.
> > > 
> > > Sorry, but wouldn't it be the other way around? Or did I really not 
> > > understand your answer?
> > > 
> > > Sorry, I don't know anything about kernel code, but wouldn't it be the 
> > > other way around?
> > > 
> > > It's just that, I may not be understanding. And it's likely that I'm 
> > > not, because you understand more about this, I'm new to this subject. 
> > > I know very little about it, or almost nothing.
> > > 
> > > But it's just that I've read the opposite about it.
> > > 
> > >  Isn't "write through" to provide more secure writes?
> > > 
> > > I also see that "write back" would be meant to be faster. No?
> > 
> > The sysfs "write_cache" attribute just controls what the kernel does. It
> > doesn't change any hardware settings.
> > 
> > In "write back" mode, a sync write will have FUA set, which will generally be
> > slower than a write without FUA. In "write through" mode, the kernel doesn't
> > set FUA so the data may not be durable after the completion if the controller
> > is using a volatile write cache.
> 
> Something seems wrong here: Typically on a RAID controller LUN 
> configuration "writeback" means that the non-volatile cache is active so 
> "write back caching" is enabled.
> 
> According to https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt:
> 
> 	"When read, this file will display whether the device has write
> 	back caching enabled or not. It will return "write back" for the former
> 	case, and "write through" for the latter."
> 
> If my text mailer would underline then I would underline this from the 
> documentation: "whether the device has write back caching enabled or not"

Maybe this is confusing because we let the user change the kernel's behavior
regardless of how the storage device is configured?
 
> Is there a good explanation for why the kernel setting is exactly 
> _opposite_ of the controller setting?

By default, the drivers should have the correct setting reported for their
devices, not the opposite. The user can override the sysfs attribute to the
opposite setting though, so it's not necessarily an accurate report of what the
device has actually enabled.

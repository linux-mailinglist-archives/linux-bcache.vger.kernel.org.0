Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E3C534349
	for <lists+linux-bcache@lfdr.de>; Wed, 25 May 2022 20:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiEYSoS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 May 2022 14:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbiEYSoR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 May 2022 14:44:17 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022DAA186;
        Wed, 25 May 2022 11:44:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id A065046;
        Wed, 25 May 2022 11:44:16 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id AGSuPP3Baxbp; Wed, 25 May 2022 11:44:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9037940;
        Wed, 25 May 2022 11:44:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9037940
Date:   Wed, 25 May 2022 11:44:01 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Christoph Hellwig <hch@infradead.org>
cc:     Keith Busch <kbusch@kernel.org>, Coly Li <colyli@suse.de>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
In-Reply-To: <Yo28kDw8rZgFWpHu@infradead.org>
Message-ID: <77e7dbf9-d5bd-424-1ef7-8a1bb49e9010@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net> <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com> <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org>
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

On Tue, 24 May 2022, Christoph Hellwig wrote:
> On Tue, May 24, 2022 at 02:34:23PM -0700, Eric Wheeler wrote:
> > Is this flag influced at all when /sys/block/sdX/queue/scheduler is set 
> > to "none", or does the write_cache flag operate independently of the 
> > selected scheduler?
> 
> This is up to the stacking driver.  dm and tend to pass through flushes
> where needed.
> 
> > This confirms what I have suspected all along: We have an LSI MegaRAID 
> > SAS-3516 where the write policy is "write back" in the LUN, but the cache 
> > is flagged in Linux as write-through:
> > 
> > 	]# cat /sys/block/sdb/queue/write_cache 
> > 	write through
> > 
> > I guess this is the correct place to adjust that behavior!
> 
> MegaRAID has had all kinds of unsafe policies in the past unfortunately.
> I'm not even sure all of them could pass through flushes properly if we
> asked them to :(

Thanks for the feedback, great info!

In your experience, which SAS/SATA RAID controllers are best behaved in 
terms of policies and reporting things like io_opt and 
writeback/writethrough to the kernel?

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 982F45369E7
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 03:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiE1Bw2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 21:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiE1Bw0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 21:52:26 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7C814D14;
        Fri, 27 May 2022 18:52:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id BA8D981;
        Fri, 27 May 2022 18:52:23 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id x3FTyepQWAUe; Fri, 27 May 2022 18:52:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id BB3C3B;
        Fri, 27 May 2022 18:52:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net BB3C3B
Date:   Fri, 27 May 2022 18:52:22 -0700 (PDT)
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
Message-ID: <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net> <YoxuYU4tze9DYqHy@infradead.org>
 <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com> <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1504673015-1653701678=:2952"
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

--8323328-1504673015-1653701678=:2952
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 24 May 2022, Christoph Hellwig wrote:
> On Tue, May 24, 2022 at 02:34:23PM -0700, Eric Wheeler wrote:
> > Is this flag influced at all when /sys/block/sdX/queue/scheduler is set 
> > to "none", or does the write_cache flag operate independently of the 
> > selected scheduler?
> 
> This in completely independent from ﬆhe scheduler.
> 
> > Does the block layer stop sending flushes at the first device in the stack 
> > that is set to "write back"?  For example, if a device mapper target is 
> > writeback will it strip flushes on the way to the backing device?
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

Hi Keith, Christoph:

Adriano who started this thread (cc'ed) reported that setting 
queue/write_cache to "write back" provides much higher latency on his NVMe 
than "write through"; I tested a system here and found the same thing.

Here is Adriano's summary:

        # cat /sys/block/nvme0n1/queue/write_cache
        write through
        # ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
        ...
        min/avg/max/mdev = 60.0 us / 78.7 us / 91.2 us / 8.20 us
                                     ^^^^ ^^

        # for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
        # ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
        ...
        min/avg/max/mdev = 1.81 ms / 1.89 ms / 2.01 ms / 82.3 us
                                     ^^^^ ^^

Interestingly, Adriano's is 24.01x and ours is 23.97x higher latency
higher (see below).  These 24x numbers seem too similar to be a
coincidence on such different configurations.  He's running Linux 5.4
and we are on 4.19.

Is this expected?


More info:

The stack where I verified the behavior Adriano reported is slightly
different, NVMe's are under md RAID1 with LVM on top, so latency is
higher, but still basically the same high latency difference with
writeback enabled:

	]# cat /sys/block/nvme[01]n1/queue/write_cache
	write through
	write through
	]# ionice -c1 -n1 ioping -c10 /dev/ssd/ssd-test -D -s4k -WWW -Y
	...
	min/avg/max/mdev = 119.1 us / 754.9 us / 2.67 ms / 1.02 ms


	]# cat /sys/block/nvme[01]n1/queue/write_cache
	write back
	write back
	]# ionice -c1 -n1 ioping -c10 /dev/ssd/ssd-test -D -s4k -WWW -Y
	...
	min/avg/max/mdev = 113.4 us / 18.1 ms / 29.2 ms / 9.53 ms


--
Eric Wheeler
--8323328-1504673015-1653701678=:2952--

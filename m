Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836AF53AFDD
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Jun 2022 00:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiFAVMA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jun 2022 17:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiFAVL5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jun 2022 17:11:57 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DA355A0;
        Wed,  1 Jun 2022 14:11:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 719F539;
        Wed,  1 Jun 2022 14:11:55 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 3rIBJrIb89lU; Wed,  1 Jun 2022 14:11:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id DD5A348;
        Wed,  1 Jun 2022 14:11:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net DD5A348
Date:   Wed, 1 Jun 2022 14:11:35 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
cc:     Keith Busch <kbusch@kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
In-Reply-To: <1295433800.3263424.1654111657911@mail.yahoo.com>
Message-ID: <8a95d4f-b263-5231-537d-b1f88fdd5090@ewheeler.net>
References: <YoxuYU4tze9DYqHy@infradead.org> <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com> <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org>
 <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net> <YpGsKDQ1aAzXfyWl@infradead.org> <24456292.2324073.1653742646974@mail.yahoo.com> <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com> <2064546094.2440522.1653825057164@mail.yahoo.com>
 <YpTKfHHWz27Qugi+@kbusch-mbp.dhcp.thefacebook.com> <1295433800.3263424.1654111657911@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1241708468-1654117895=:2952"
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

--8323328-1241708468-1654117895=:2952
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 1 Jun 2022, Adriano Silva wrote:
> I don't know if my NVME's devices are 4K LBA. I do not think so. They 
> are all the same model and manufacturer. I know that they work with 
> blocks of 512 Bytes, but that their latency is very high when processing 
> blocks of this size.

Ok, it should be safe in terms of the possible bcache bug I was referring 
to if it supports 512b IOs.

> However, in all the tests I do with them with 4K blocks, the result is 
> much better. So I always use 4K blocks. Because in real life I don't 
> think I'll use blocks smaller than 4K.

Makes sense, format with -w 4k.  There is probably some CPU benefit to 
having page-aligned IOs, too.

> > You can remove the kernel interpretation using passthrough commands. Here's an
> > example comparing with and without FUA assuming a 512b logical block format:
> > 
> >   # echo "" | nvme write /dev/nvme0n1 --block-count=7 --data-size=4k --force-unit-access --latency
> >   # echo "" | nvme write /dev/nvme0n1 --block-count=7 --data-size=4k --latency
> > 
> > if you have a 4k LBA format, use "--block-count=0".
> > 
> > And you may want to run each of the above several times to get an average since
> > other factors can affect the reported latency.
> 
> I created a bash script capable of executing the two commands you 
> suggested to me in a period of 10 seconds in a row, to get some more 
> acceptable average. The result is the following:
> 
> root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done
> root@pve-21:~# cat /sys/block/nvme0n1/queue/write_cache
> write back
> root@pve-21:~# ./nvme_write.sh
> Total: 10 seconds, 3027 tests. Latency (us) : min: 29  /  avr: 37   /  max: 98
> root@pve-21:~# ./nvme_write.sh --force-unit-access
> Total: 10 seconds, 2985 tests. Latency (us) : min: 29  /  avr: 37   /  max: 111
> root@pve-21:~#
> root@pve-21:~# ./nvme_write.sh --force-unit-access --block-count=0
> Total: 10 seconds, 2556 tests. Latency (us) : min: 404  /  avr: 428   /  max: 492
> root@pve-21:~# ./nvme_write.sh --block-count=0
> Total: 10 seconds, 2521 tests. Latency (us) : min: 403  /  avr: 428   /  max: 496
> root@pve-21:~#
> root@pve-21:~#
> root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write through' > $i; done
> root@pve-21:~# cat /sys/block/nvme0n1/queue/write_cache
> write through
> root@pve-21:~# ./nvme_write.sh
> Total: 10 seconds, 2988 tests. Latency (us) : min: 29  /  avr: 37   /  max: 114
> root@pve-21:~# ./nvme_write.sh --force-unit-access
> Total: 10 seconds, 2926 tests. Latency (us) : min: 29  /  avr: 36   /  max: 71
> root@pve-21:~#
> root@pve-21:~# ./nvme_write.sh --force-unit-access --block-count=0
> Total: 10 seconds, 2456 tests. Latency (us) : min: 31  /  avr: 428   /  max: 496
> root@pve-21:~# ./nvme_write.sh --block-count=0
> Total: 10 seconds, 2627 tests. Latency (us) : min: 402  /  avr: 428   /  max: 509
> 
> Well, as we can see above, in almost 3k tests run in a period of ten 
> seconds, with each of the commands, I got even better results than I 
> already got with ioping. I did tests with isolated commands as well, but 
> I decided to write a bash script to be able to execute many commands in 
> a short period of time and make an average. And we can see an average of 
> about 37us in any situation. Very low!
> 
> However, when using that suggested command --block-count=0 the latency 
> is very high in any situation, around 428us.
> 
> But as we see, using the nvme command, the latency is always the same in 
> any scenario, whether with or without --force-unit-access, having a 
> difference only regarding the use of the command directed to devices 
> that don't have LBA or that aren't.
> 
> What do you think?

It looks like the NVMe works well except in 512b situations.  Its 
interesting that --force-unit-access doesn't increase the latency: Perhaps 
the NVMe ignores sync flags since it knows it has a non-volatile cache.

-Eric

> 
> Tanks,
> 
> 
> Em segunda-feira, 30 de maio de 2022 10:45:37 BRT, Keith Busch <kbusch@kernel.org> escreveu: 
> 
> 
> 
> 
> 
> On Sun, May 29, 2022 at 11:50:57AM +0000, Adriano Silva wrote:
> 
> > So why the slowness? Is it just the time spent in kernel code to set 
> > FUA and Flush Cache bits on writes that would cause all this latency 
> > increment (84us to 1.89ms) ?
> 
> 
> I don't think the kernel's handling accounts for that great of a difference. I
> think the difference is probably on the controller side.
> 
> The NVMe spec says that a Write command with FUA set:
> 
> "the controller shall write that data and metadata, if any, to non-volatile
> media before indicating command completion."
> 
> So if the memory is non-volatile, it can complete the command without writing
> to the backing media. It can also commit the data to the backing media if it
> wants to before completing the command, but that's implementation specific
> details.
> 
> You can remove the kernel interpretation using passthrough commands. Here's an
> example comparing with and without FUA assuming a 512b logical block format:
> 
>   # echo "" | nvme write /dev/nvme0n1 --block-count=7 --data-size=4k --force-unit-access --latency
>   # echo "" | nvme write /dev/nvme0n1 --block-count=7 --data-size=4k --latency
> 
> If you have a 4k LBA format, use "--block-count=0".
> 
> And you may want to run each of the above several times to get an average since
> other factors can affect the reported latency.
> 
--8323328-1241708468-1654117895=:2952--

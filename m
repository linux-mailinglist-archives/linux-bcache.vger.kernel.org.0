Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8495678C9
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jul 2022 22:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiGEUvQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jul 2022 16:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiGEUvD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jul 2022 16:51:03 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B0A1F2CD
        for <linux-bcache@vger.kernel.org>; Tue,  5 Jul 2022 13:50:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id AE1F14A;
        Tue,  5 Jul 2022 13:50:00 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id rsOZvf64OJ6q; Tue,  5 Jul 2022 13:49:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 4EA0240;
        Tue,  5 Jul 2022 13:49:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 4EA0240
Date:   Tue, 5 Jul 2022 13:49:56 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: bcache I/O performance tests on 5.15.0-40-generic
In-Reply-To: <8C0D66FE-FF1D-469D-A209-10E95F79D2FA@suse.de>
Message-ID: <37577c49-6d0-e5f4-2ea3-51128526526e@ewheeler.net>
References: <CAC6jXv0FoE60HEuc7tDMXEA27hkoMkZm5d6gt4NCRkAh2w3WvA@mail.gmail.com> <8C0D66FE-FF1D-469D-A209-10E95F79D2FA@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2140593308-1657054196=:20520"
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

--8323328-2140593308-1657054196=:20520
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sat, 25 Jun 2022, Coly Li wrote:
> > 2022年6月25日 14:29，Nikhil Kshirsagar <nkshirsagar@gmail.com> 写道：
> > 
> > Hello,
> > 
> > I've been doing some performance tests of bcache on 5.15.0-40-generic.
> > 
> > The baseline figures for the fast and slow disk for random writes are
> > consistent at around 225MiB/s and 3046KiB/s.
> > 
> > But the bcache results inexplicably drop sometimes to 10Mib/s, for
> > random write test using fio like this -
> > 
> > fio --rw=randwrite --size=1G --ioengine=libaio --direct=1
> > --gtod_reduce=1 --iodepth=128 --bs=4k --name=MY_TEST1
> > 
> >  WRITE: bw=168MiB/s (176MB/s), 168MiB/s-168MiB/s (176MB/s-176MB/s),
> > io=1024MiB (1074MB), run=6104-6104msec
> >  WRITE: bw=283MiB/s (297MB/s), 283MiB/s-283MiB/s (297MB/s-297MB/s),
> > io=1024MiB (1074MB), run=3621-3621msec
> >  WRITE: bw=10.3MiB/s (10.9MB/s), 10.3MiB/s-10.3MiB/s
> > (10.9MB/s-10.9MB/s), io=1024MiB (1074MB), run=98945-98945msec
> >  WRITE: bw=8236KiB/s (8434kB/s), 8236KiB/s-8236KiB/s
> > (8434kB/s-8434kB/s), io=1024MiB (1074MB), run=127317-127317msec
> >  WRITE: bw=9657KiB/s (9888kB/s), 9657KiB/s-9657KiB/s
> > (9888kB/s-9888kB/s), io=1024MiB (1074MB), run=108587-108587msec
> >  WRITE: bw=4543KiB/s (4652kB/s), 4543KiB/s-4543KiB/s
> > (4652kB/s-4652kB/s), io=1024MiB (1074MB), run=230819-230819msec
> > 
> > This seems to happen after 2 runs of 1gb writes (cache disk is 4gb size)
> > 
> > Some details are here - https://pastebin.com/V9mpLCbY , I will share
> > the full testing results soon, but just was wondering about this
> > performance drop for no apparent reason once the cache gets about 50%
> > full.
> 
> 
> It seems you are stuck by garbage collection. 4GB cache is small, the 
> garbage collection might be invoked quite frequently. Maybe you can see 
> the output of ’top -H’ to check whether there is kernel thread named 
> bache_gc.

Hi Nikhil,

Do you have Mingzhe's GC patch?  It might help:
  https://www.spinics.net/lists/linux-bcache/msg11185.html

Coli, did Mingzhe's patch get into your testing tree?  It looks like it 
could be a good addition to bcache.

--
Eric Wheeler



> 
> Anyway, 4GB cache is too small.
> 
> Coly Li
> 
> 
--8323328-2140593308-1657054196=:20520--

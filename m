Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58588531C5A
	for <lists+linux-bcache@lfdr.de>; Mon, 23 May 2022 22:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiEWSwI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 May 2022 14:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241838AbiEWSvJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 May 2022 14:51:09 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFC940E71;
        Mon, 23 May 2022 11:36:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0EAAC48;
        Mon, 23 May 2022 11:36:57 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id GFDRwiEhIT8D; Mon, 23 May 2022 11:36:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 65A9740;
        Mon, 23 May 2022 11:36:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 65A9740
Date:   Mon, 23 May 2022 11:36:50 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Adriano Silva <adriano_da_silva@yahoo.com.br>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        linux-block@vger.kernel.org
Subject: [RFC] Add sysctl option to drop disk flushes in bcache? (was: Bcache
 in writes direct with fsync)
In-Reply-To: <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
Message-ID: <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1782520720-1653330838=:2898"
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

--8323328-1782520720-1653330838=:2898
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 17 May 2022, Eric Wheeler wrote:
>   /sys/fs/bcache/<cset-uuid>/journal_delay_ms
>     Journal writes will delay for up to this many milliseconds, unless a 
>     cache flush happens sooner. Defaults to 100.
> 
> I just noticed that journal_delay_ms says "unless a cache flush happens 
> sooner" but cache flushes can be re-ordered so flushing the journal when 
> REQ_OP_FLUSH comes through may not be useful, especially if there is a 
> high volume of flushes coming down the pipe because the flushes could kill 
> the NVMe's cache---and maybe the 1.5ms ping is actual flash latency.  It
> would flush data and journal.
> 
> Maybe there should be a cachedev_noflush sysfs option for those with some 
> kind of power-loss protection of there SSD's.  It looks like this is 
> handled in request.c when these functions call bch_journal_meta():
> 
> 	1053: static void cached_dev_nodata(struct closure *cl)
> 	1263: static void flash_dev_nodata(struct closure *cl)
> 
> Coly can you comment about journal flush semantics with respect to 
> performance vs correctness and crash safety?
> 
> Adriano, as a test, you could change this line in search_alloc() in 
> request.c:
> 
> 	- s->iop.flush_journal    = op_is_flush(bio->bi_opf);
> 	+ s->iop.flush_journal    = 0;
> 
> and see how performance changes.

Hi Coly, all:

Can you think of any reason that forcing iop.flush_journal=0 for bcache 
devs with backed by non-volatile cache would be unsafe?

If it is safe, then three new sysctl flags to optionally drop flushes 
would increase overall bcache performance by avoiding controller flushes, 
especially on the spinning disks.  These would of course default to 0:

  - noflush_journal - no flush on journal writes
  - noflush_cache   - no flush on normal cache IO writes
  - noflush_bdev    - no flush on normal bdev IO writes

What do you think?

From Coly's iopings:

>  # ./ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=1 time=144.3 us (warmup)
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=2 time=84.1 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=3 time=71.8 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=4 time=68.9 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=5 time=69.8 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=6 time=68.7 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=7 time=68.8 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=8 time=70.3 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=9 time=68.8 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=10 time=68.5 us
 
^ Average is 71.1 us.

>  # ./ioping -c10 /dev/bcache0 -D -WWW -s4k
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=1 time=127.8 us (warmup)
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=2 time=67.8 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=3 time=60.3 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=4 time=46.9 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=5 time=52.6 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=6 time=43.8 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=7 time=52.7 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=8 time=44.3 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=9 time=52.0 us
> 4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=10 time=44.6 us

^ Average is 51.7 us.

Dropping sync write flushes provides a 27% reduction in SSD latency!


--
Eric Wheeler



> 
> Someone correct me if I'm wrong, but I don't think flush_journal=0 will 
> affect correctness unless there is a crash.  If that /is/ the performance 
> problem then it would narrow the scope of this discussion.
> 
> 4. I wonder if your 1.5ms `ioping` stats scale with CPU clock speed: can 
>    you set your CPU governor to run at full clock speed and then slowest 
>    clock speed to see if it is a CPU limit somewhere as we expect?
> 
>    You can do `grep MHz /proc/cpuinfo` to see the active rate to make sure 
>    the governor did its job.  
> 
>    If it scales with CPU then something in bcache is working too hard.  
>    Maybe garbage collection?  Other devs would need to chime in here to 
>    steer the troubleshooting if that is the case.
> 
> 
> 5. I'm not sure if garbage collection is the issue, but you might try 
>    Mingzhe's dynamic incremental gc patch:
> 	https://www.spinics.net/lists/linux-bcache/msg11185.html
> 
> 6. Try dm-cache and see if its IO latency is similar to bcache: If it is 
>    about the same then that would indicate an issue in the block layer 
>    somewhere outside of bcache.  If dm-cache is better, then that confirms 
>    a bcache issue.
> 
> 
> > The cache was configured directly on one of the NVMe partitions (in this 
> > case, the first partition). I did several tests using fio and ioping, 
> > testing on a partition on the NVMe device, without partition and 
> > directly on the raw block, on a first partition, on the second, with or 
> > without configuring bcache. I did all this to remove any doubt as to the 
> > method. The results of tests performed directly on the hardware device, 
> > without going through bcache are always fast and similar.
> > 
> > But tests in bcache are always slower. If you use writethrough, of 
> > course, it gets much worse, because the performance is equal to the raw 
> > spinning disk.
> > 
> > Using writeback improves a lot, but still doesn't use the full speed of 
> > NVMe (honestly, much less than full speed).
> 
> Indeed, I hope this can be fixed!  A 20x improvement in bcache would 
> be awesome.
>  
> > But I've also noticed that there is a limit on writing sequential data, 
> > which is a little more than half of the maximum write rate shown in 
> > direct tests by the NVMe device.
> 
> For sync, async, or both?
> 
> > Processing doesn't seem to be going up like the tests.
> 
> What do you mean "processing" ?
> 
> -Eric
> 
> 
> 
--8323328-1782520720-1653330838=:2898--

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2D76FBC01
	for <lists+linux-bcache@lfdr.de>; Tue,  9 May 2023 02:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjEIAaB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 May 2023 20:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjEIAaB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 May 2023 20:30:01 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8CE4EEE
        for <linux-bcache@vger.kernel.org>; Mon,  8 May 2023 17:29:59 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 6488C85;
        Mon,  8 May 2023 17:29:59 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 8GxFv-cFBM5K; Mon,  8 May 2023 17:29:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id D50AC45;
        Mon,  8 May 2023 17:29:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net D50AC45
Date:   Mon, 8 May 2023 17:29:54 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
cc:     Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Subject: Re: Writeback cache all used.
In-Reply-To: <230809962.2194275.1683210873801@mail.yahoo.com>
Message-ID: <f15daac1-58b0-1c4e-2611-e2bb213ff9ef@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
 <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com> <1399491299.3275222.1681990558684@mail.yahoo.com>
 <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net> <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de> <230809962.2194275.1683210873801@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1300850106-1683592194=:22690"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1300850106-1683592194=:22690
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 4 May 2023, Adriano Silva wrote:

> Hi Coly,
> 
> If I can help you with anything, please let me know.
> 
> Thanks!
> 
> 
> Guys, can I take advantage and ask one more question? If you prefer, 
> I'll open another topic, but as it has something to do with the subject 
> discussed here, I'll ask for now right here.
> 
> I decided to make (for now) a bash script to change the cache parameters 
> trying a temporary workaround to solve the issue manually in at least 
> one of my clusters.
> 
> So: I use in production cache_mode as writeback, writeback_percent to 2 
> (I think low is safer and faster for a flush, while staying at 10 hasn't 
> shown better performance in my case - i am wrong?). I use discard as 
> false, as it is slow to discard each bucket that is modified (I believe 
> the discard would need to be by large batches of free buckets). I use 0 
> (zero) in sequence_cutoff because using the bluestore file system (from 
> ceph), it seems to me that using any other value in this variable, 
> bcache understands everything as sequential and bypasses it to the back 
> disk. I also use congested_read_threshold_us and 
> congested_write_threshold_us to 0 (zero) as it seems to give slightly 
> better performance, lower latency. I always use rotational as 1, never 
> change it. They always say that for Ceph it works better, I've been 
> using it ever since. I put these parameters at system startup.
> 
> So, I decided at 01:00 that I'm going to run a bash script to change 
> these parameters in order to clear the cache and use it to back up my 
> data from databases and others. So, I change writeback_percent to 0 
> (zero) for it to clean all the dirt from the cache. Then I keep checking 
> the status until it's "cleared". I then pass the cache_mode to 
> writethrough. In the sequence I confirm if the cache remains "clean". 
> Being "clean", I change cache_mode to "none" and then comes the 
> following line:
> 
> echo $cache_cset > /sys/block/$bcache_device/bcache/cache/unregister

These are my notes for hot-removal of a cache.  You need to detach and 
then unregister:

~] bcache-super-show /dev/sdz1 # cache device
[...]
cset.uuid		3db83b23-1af7-43a6-965d-c277b402b16a

~] echo 3db83b23-1af7-43a6-965d-c277b402b16a > /sys/block/bcache0/bcache/detach
~] watch cat /sys/block/bcache0/bcache/dirty_data # wait until 0
~] echo 1 > /sys/fs/bcache/3db83b23-1af7-43a6-965d-c277b402b16a/unregister


> Here ends the script that runs at 01:00 am.
> 
> So, then I perform backups of my data, without the reading of this data 
> going through and being all written in my cache. (Am I thinking 
> correctly?)
> 
> Users will continue to use the system normally, however the system will 
> be slower because the Ceph OSD will be working on top of the bcache 
> device without having a cache. But a lower performance at that time, for 
> my case, is acceptable at that time.
> 
> After the backup is complete, at 05:00 am I run the following sequence:
> 
>           wipefs -a /dev/nvme0n1p1
>           sleep 1
>           blkdiscard /dev/nvme0n1p1
>           sleep 1
>           makebcache=$(make-bcache --wipe-bcache -w 4k --bucket 256K -C /dev/$cache_device)
>           sleep 1 cache_cset=$(bcache-super-show /dev/$cache_device | grep cset | awk '{ print $2 }')
>           echo $cache_cset > /sys/block/bcache0/bcache/attach
> 
> One thing to point out here is the size of the bucket I use (256K) which 
> I defined according to the performance tests I did.

How do you test performance, is it automated?

> While I didn't notice any big performance differences during these 
> tests, I thought 256K was the best performing smallest block I got with 
> my NVMe device, which is an enterprise device (with non-volatile cache), 
> but I don't have information about the size minimum erasure block. I did 
> not find this information about the smallest erase block of this device 
> anywhere. I looked in several ways, the manufacturer didn't inform me, 
> the nvme-cli tool didn't show me either. Would 256 really be a good 
> number to use?

If you can automate performance testing, then you could use something like 
Simplex [1] to optimize the following values for your infrastructure:

	- bucket size # `make-bcache --bucket N`
	- /sys/block/<nvme>/queue/nr_requests	
	- /sys/block/<nvme>/queue/io_poll_delay
	- /sys/block/<nvme>/queue/max_sectors_kb
	- /sys/block/<bdev>/queue/nr_requests
	- other IO tunables? maybe: /sys/block/bcache0/bcache/
		writeback_percent
		writeback_rate
		writeback_delay

	Selfless plug: I've always wanted to tune Linux with Simplex, but 
	haven't gotten to it: [1] https://metacpan.org/pod/PDL::Opt::Simplex::Simple
 
> Anyway, after attaching the cache again, I return the parameters to what 
> I have been using in production:
> 
>           echo writeback > /sys/block/$bcache_device/bcache/cache_mode
>           echo 1 > /sys/devices/virtual/block/$bcache_device/queue/rotational
>           echo 1 > /sys/fs/bcache/$cache_cset/internal/gc_after_writeback
>           echo 1 > /sys/block/$bcache_device/bcache/cache/internal/trigger_gc
>           echo 2 > /sys/block/$bcache_device/bcache/writeback_percent
>           echo 0 > /sys/fs/bcache/$cache_cset/cache0/discard
>           echo 0 > /sys/block/$bcache_device/bcache/sequential_cutoff
>           echo 0 > /sys/fs/bcache/$cache_cset/congested_read_threshold_us
>           echo 0 > /sys/fs/bcache/$cache_cset/congested_write_threshold_us
>
> 
> I created the scripts in a test environment and it seems to have worked as expected.

Looks good.  I might try those myself...
 
> My question: Would it be a correct way to temporarily solve the problem 
> as a palliative? 

If it works, then I don't see a problem except that you are evicting your 
cache.  

> Is it safe to do it this way with a mounted file 
> system, with files in use by users and databases in working order? 

Yes (at least by design, it is safe to detach bcache cdevs).  We have done 
it many times in production.

> Are there greater risks involved in putting this into production? Do you 
> see any problems or anything that could be different?

Only that you are turning on options that have not been tested much, 
simply because they are not default.  You might hit a bug... but if so, 
then report it to be fixed!

-Eric

> 
> Thanks!
> 
> 
> 
> Em quinta-feira, 4 de maio de 2023 às 01:56:23 BRT, Coly Li <colyli@suse.de> escreveu: 
> 
> 
> 
> 
> 
> 
> 
> > 2023年5月3日 04:34，Eric Wheeler <bcache@lists.ewheeler.net> 写道：
> > 
> > On Thu, 20 Apr 2023, Adriano Silva wrote:
> >> I continue to investigate the situation. There is actually a performance 
> >> gain when the bcache device is only half filled versus full. There is a 
> >> reduction and greater stability in the latency of direct writes and this 
> >> improves my scenario.
> > 
> > Hi Coly, have you been able to look at this?
> > 
> > This sounds like a great optimization and Adriano is in a place to test 
> > this now and report his findings.
> > 
> > I think you said this should be a simple hack to add early reclaim, so 
> > maybe you can throw a quick patch together (even a rough first-pass with 
> > hard-coded reclaim values)
> > 
> > If we can get back to Adriano quickly then he can test while he has an 
> > easy-to-reproduce environment.  Indeed, this could benefit all bcache 
> > users.
> 
> My current to-do list on hand is a little bit long. Yes I’d like and plan to do it, but the response time cannot be estimated.
> 
> 
> Coly Li
> 
> 
> [snipped]
> 
--8323328-1300850106-1683592194=:22690--

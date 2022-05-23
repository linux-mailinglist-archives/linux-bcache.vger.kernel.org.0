Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9DB5313A2
	for <lists+linux-bcache@lfdr.de>; Mon, 23 May 2022 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiEWOHg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 May 2022 10:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236611AbiEWOHf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 May 2022 10:07:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A8424941
        for <linux-bcache@vger.kernel.org>; Mon, 23 May 2022 07:07:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 31B8021AEB;
        Mon, 23 May 2022 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653314852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cm3/ha9KV14//H+P1OJOHeuobf3ONr1SVBMzE468OM8=;
        b=GyeZLI9Bjahtn+Qik6lHDUZVh6r/hGMugjimqxzufx1UoFxpumtmoL1dFgkMiqpC9iJUMy
        2cM2d4MKLkLtK2wK9TB3KbQSFOsw9GpMNq8mI1L6GlnbL0PTsZRcwWsW7n7vRqA3lh49Yp
        HMh2Xz0JUg9b5PJWaoMldkkPOWdfWMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653314852;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cm3/ha9KV14//H+P1OJOHeuobf3ONr1SVBMzE468OM8=;
        b=qZgJtENnB7iEVOKNSSjVxPI7jSk1UgcnKt4etzZv7aSONSVKRb3+rMXiqQBoEbhGvM6T8v
        Mpo5U0EzGXEd0aAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 254C9139F5;
        Mon, 23 May 2022 14:07:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2ovoOCKVi2I1bgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 23 May 2022 14:07:30 +0000
Message-ID: <a3830c54-5e88-658f-f0ef-7ac675090b24@suse.de>
Date:   Mon, 23 May 2022 22:07:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
From:   Coly Li <colyli@suse.de>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
To:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
Content-Language: en-US
In-Reply-To: <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/18/22 9:22 AM, Eric Wheeler wrote:
> On Tue, 10 May 2022, Adriano Silva wrote:
>> I'm trying to set up a flash disk NVMe as a disk cache for two or three
>> isolated (I will use 2TB disks, but in these tests I used a 1TB one)
>> spinning disks that I have on a Linux 5.4.174 (Proxmox node).
> Coly has been adding quite a few optimizations over the years.  You might
> try a new kernel and see if that helps.  More below.


Yes, the latest stable kernel is preferred. Linux 5.4 based kernel is 
stable enough for bcache, but it is still better to use latest stable 
kernel.


>> I'm using a NVMe (960GB datacenter devices with tantalum capacitors) as
>> a cache.
>> [...]
>>
>> But when I do the same test on bcache writeback, the performance drops a
>> lot. Of course, it's better than the performance of spinning disks, but
>> much worse than when accessed directly from the NVMe device hardware.
>>
>> [...]
>> As we can see, the same test done on the bcache0 device only got 1548
>> IOPS and that yielded only 6.3 KB/s.
> Well done on the benchmarking!  I always thought our new NVMes performed
> slower than expected but hadn't gotten around to investigating.
>
>> I've noticed in several tests, varying the amount of jobs or increasing
>> the size of the blocks, that the larger the size of the blocks, the more
>> I approximate the performance of the physical device to the bcache
>> device.
> You said "blocks" but did you mean bucket size (make-bcache -b) or block
> size (make-bcache -w) ?
>
> If larger buckets makes it slower than that actually surprises me: bigger
> buckets means less metadata and better sequential writeback to the
> spinning disks (though you hadn't yet hit writeback to spinning disks in
> your stats).  Maybe you already tried, but varying the bucket size might
> help.  Try graphing bucket size (powers of 2) against IOPS, maybe there is
> a "sweet spot"?
>
> Be aware that 4k blocks (so-called "4Kn") is unsafe for the cache device,
> unless Coly has patched that.  Make sure your `blockdev --getss` reports
> 512 for your NVMe!
>
> Hi Coly,
>
> Some time ago you ordered an an SSD to test the 4k cache issue, has that
> been fixed?  I've kept an eye out for the patch but not sure if it was released.


Yes, I got the Intel P3700 PCIe SSD to fix the 4Kn unaligned I/O issue 
(borrowed from a hardware vendor). The new situation is, current kernel 
does the sector size alignment checking quite earlier in bio layer, if 
the LBA is not sector size aligned, it is rejected in the bio code, and 
the underlying driver doesn't have chance to see the bio anymore. So for 
now, the unaligned LBA for 4Kn device cannot reach bcache code, that's 
to say, the original reported condition won't happen now.

And after this observation, I stopped my investigation on the unaligned 
sector size I/O on 4Kn device, and returned the P3700 PCIe SSD to the 
hardware vendor.


> You have a really great test rig setup with NVMes for stress
> testing bcache. Can you replicate Adriano's `ioping` numbers below?


I tried the similar operation, yes it should be a bit slower than raw 
device access, but should not be slow like that...

Here is my fio single thread fsync performance number,

job0: (groupid=0, jobs=1): err= 0: pid=3370: Mon May 23 16:17:05 2022
   write: IOPS=20.9k, BW=81.8MiB/s (85.8MB/s)(17.3GiB/216718msec); 0 
zone resets
    bw (  KiB/s): min=75904, max=86872, per=100.00%, avg=83814.21, 
stdev=1321.04, samples=433
    iops        : min=18976, max=21718, avg=20953.56, stdev=330.27, 
samples=433
   lat (usec)   : 2=0.01%, 10=0.01%, 20=97.34%, 50=1.71%, 100=0.47%
   lat (usec)   : 250=0.42%, 500=0.01%, 750=0.01%, 1000=0.02%
   lat (msec)   : 2=0.02%, 4=0.01%

Most of the write I/Os finished in 20us, comparing to 100-250us, that is 
too slow, which is out of my expectation. There should be something not 
properly working.



>> With ioping it is also possible to notice a limitation, as the latency
>> of the bcache0 device is around 1.5ms, while in the case of the raw
>> device (a partition of NVMe), the same test is only 82.1us.
>>
>> root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
>> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=1 time=1.52 ms (warmup)
>> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=2 time=1.60 ms
>> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3 time=1.55 ms
>>
>> root@pve-20:~# ioping -c10 /dev/nvme0n1p2 -D -Y -WWW -s4k
>> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=1 time=81.2 us (warmup)
>> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=2 time=82.7 us
>> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3 time=82.4 us
> Wow, almost 20x higher latency, sounds convincing that something is wrong.
>
> A few things to try:
>
> 1. Try ioping without -Y.  How does it compare?
>
> 2. Maybe this is an inter-socket latency issue.  Is your server
>     multi-socket?  If so, then as a first pass you could set the kernel
>     cmdline `isolcpus` for testing to limit all processes to a single
>     socket where the NVMe is connected (see `lscpu`).  Check `hwloc-ls`
>     or your motherboard manual to see how the NVMe port is wired to your
>     CPUs.
>
>     If that helps then fine tune with `numactl -cN ioping` and
>     /proc/irq/<n>/smp_affinity_list (and `grep nvme /proc/interrupts`) to
>     make sure your NVMe's are locked to IRQs on the same socket.

Wow, this is too slow...


Here is my performance number,

  # ./ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=1 time=144.3 us 
(warmup)
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=2 time=84.1 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=3 time=71.8 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=4 time=68.9 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=5 time=69.8 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=6 time=68.7 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=7 time=68.8 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=8 time=70.3 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=9 time=68.8 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=10 time=68.5 us

  # ./ioping -c10 /dev/bcache0 -D -WWW -s4k
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=1 time=127.8 us 
(warmup)
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=2 time=67.8 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=3 time=60.3 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=4 time=46.9 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=5 time=52.6 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=6 time=43.8 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=7 time=52.7 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=8 time=44.3 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=9 time=52.0 us
4 KiB >>> /dev/bcache0 (block device 3.49 TiB): request=10 time=44.6 us

1.5ms is really far from my expectation, there must be something wrong....


[snipped]

> Someone correct me if I'm wrong, but I don't think flush_journal=0 will
> affect correctness unless there is a crash.  If that /is/ the performance
> problem then it would narrow the scope of this discussion.
>
> 4. I wonder if your 1.5ms `ioping` stats scale with CPU clock speed: can
>     you set your CPU governor to run at full clock speed and then slowest
>     clock speed to see if it is a CPU limit somewhere as we expect?
>
>     You can do `grep MHz /proc/cpuinfo` to see the active rate to make sure
>     the governor did its job.
>
>     If it scales with CPU then something in bcache is working too hard.
>     Maybe garbage collection?  Other devs would need to chime in here to
>     steer the troubleshooting if that is the case.

Maybe system memory is small?  1.5ms is too slow, I cannot imagine how 
it can be such slow...


>
> 5. I'm not sure if garbage collection is the issue, but you might try
>     Mingzhe's dynamic incremental gc patch:
> 	https://www.spinics.net/lists/linux-bcache/msg11185.html
>
> 6. Try dm-cache and see if its IO latency is similar to bcache: If it is
>     about the same then that would indicate an issue in the block layer
>     somewhere outside of bcache.  If dm-cache is better, then that confirms
>     a bcache issue.

Great idea.


>
>> The cache was configured directly on one of the NVMe partitions (in this
>> case, the first partition). I did several tests using fio and ioping,
>> testing on a partition on the NVMe device, without partition and
>> directly on the raw block, on a first partition, on the second, with or
>> without configuring bcache. I did all this to remove any doubt as to the
>> method. The results of tests performed directly on the hardware device,
>> without going through bcache are always fast and similar.


What is the performance number on the whole NVMe disk without 
partition?  In case the partition start LBA is not perfectly aligned to 
some size...

Can I know the hardware configuration, and the NVMe SSD spec? Maybe I 
can try to find a similar one around my location and have a try if I am 
lucky.


Thanks.


Coly Li




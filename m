Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BC4522C4F
	for <lists+linux-bcache@lfdr.de>; Wed, 11 May 2022 08:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiEKGao (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 May 2022 02:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbiEKGan (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 May 2022 02:30:43 -0400
X-Greylist: delayed 624 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 May 2022 23:30:41 PDT
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A354D50
        for <linux-bcache@vger.kernel.org>; Tue, 10 May 2022 23:30:40 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 24B6KCD9003264;
        Wed, 11 May 2022 08:20:13 +0200
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with ESMTP id D02DBC801A;
        Wed, 11 May 2022 08:20:11 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Wed, 11 May 2022 08:20:11 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
Message-ID: <YntVm0jy5NY8ealB@xoff>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <958894243.922478.1652201375900@mail.yahoo.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, May 10, 2022 at 04:49:35PM +0000, Adriano Silva wrote:
> As we can see, the same test done on the bcache0 device only got 1548 IOPS and that yielded only 6.3 KB/s.
> 
> This is much more than any spinning HDD could give me, but many times less than the result obtained by NVMe.


Hi,

bcache needs to do a lot of metadata work, resulting in a noticeable
write amplification. My testing with bcache (some years ago and only with
SATA SSDs) showed that bcache latency increases a lot with high amounts
of dirty data, so I used to tune down writeback_percent, usually to 1,
and used to keep the cache device size low at around 40GB.
I also found performance to increase slightly when a bcache device
was created with 4k block size instead of default 512bytes.

Still quite a decrease in iops. Maybe you could monitor with iostat,
it gives those _await columns, there might be some hints.

Matthias

> I've noticed in several tests, varying the amount of jobs or increasing the size of the blocks, that the larger the size of the blocks, the more I approximate the performance of the physical device to the bcache device. But it always seems that the amount of IOPS is limited to somewhere around 1500-1800 IOPS (maximum). By increasing the amount of jobs, I get better results and more IOPS, but if you divide the total IOPS by the amount of jobs, you can see that the IOPS are always limited in the range 1500-1800 per job.
> 
> The commands used to configure bcache were:
> 
> # echo writeback > /sys/block/bcache0/bcache/cache_mode
> # echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> ##
> ## Then I tried everything also with the commands below, but there was no improvement.
> ##
> # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
> # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us
> 
> 
> Monitoring with dstat, it is possible to notice that when activating the fio command, the writing is all done in the cache device (a second partition of NVMe), until the end of the test. The spinning disk is only written after the time has passed and it is possible to see the read on the NVMe and the write on the spinning disk (which means the transfer of data in the background).
> 
> --dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- async
>  read  writ: read  writ: read  writ| read  writ: read  writ: read  writ| recv  send| 1m   5m  15m |usr sys idl wai stl| int   csw |     time     | #aio
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |8462B 8000B|0.03 0.15 0.31|  1   0  99   0   0| 250   383 |09-05 15:19:47|   0
>    0     0 :4096B  454k:   0   336k|   0     0 :1.00   184 :   0   170 |4566B 4852B|0.03 0.15 0.31|  2   2  94   1   0|1277  3470 |09-05 15:19:48|   1B
>    0  8192B:   0  8022k:   0  6512k|   0  2.00 :   0  3388 :   0  3254 |3261B 2827B|0.11 0.16 0.32|  0   2  93   5   0|4397    16k|09-05 15:19:49|   1B
>    0     0 :   0  7310k:   0  6460k|   0     0 :   0  3240 :   0  3231 |6773B 6428B|0.11 0.16 0.32|  0   1  93   6   0|4190    16k|09-05 15:19:50|   1B
>    0     0 :   0  7313k:   0  6504k|   0     0 :   0  3252 :   0  3251 |6719B 6201B|0.11 0.16 0.32|  0   2  92   6   0|4482    16k|09-05 15:19:51|   1B
>    0     0 :   0  7313k:   0  6496k|   0     0 :   0  3251 :   0  3250 |4743B 4016B|0.11 0.16 0.32|  0   1  93   6   0|4243    16k|09-05 15:19:52|   1B
>    0     0 :   0  7329k:   0  6496k|   0     0 :   0  3289 :   0  3245 |6107B 6062B|0.11 0.16 0.32|  1   1  90   8   0|4706    18k|09-05 15:19:53|   1B
>    0     0 :   0  5373k:   0  4184k|   0     0 :   0  2946 :   0  2095 |6387B 6062B|0.26 0.19 0.33|  0   2  95   4   0|3774    12k|09-05 15:19:54|   1B
>    0     0 :   0  6966k:   0  5668k|   0     0 :   0  3270 :   0  2834 |7264B 7546B|0.26 0.19 0.33|  0   1  93   5   0|4214    15k|09-05 15:19:55|   1B
>    0     0 :   0  7271k:   0  6252k|   0     0 :   0  3258 :   0  3126 |5928B 4584B|0.26 0.19 0.33|  0   2  93   5   0|4156    16k|09-05 15:19:56|   1B
>    0     0 :   0  7419k:   0  6504k|   0     0 :   0  3308 :   0  3251 |5226B 5650B|0.26 0.19 0.33|  2   1  91   6   0|4433    16k|09-05 15:19:57|   1B
>    0     0 :   0  6444k:   0  5704k|   0     0 :   0  2873 :   0  2851 |6494B 8021B|0.26 0.19 0.33|  1   1  91   7   0|4352    16k|09-05 15:19:58|   0
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 |6030B 7204B|0.24 0.19 0.32|  0   0 100   0   0| 209   279 |09-05 15:19:59|   0

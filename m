Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB844523F64
	for <lists+linux-bcache@lfdr.de>; Wed, 11 May 2022 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiEKVVt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 May 2022 17:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbiEKVVs (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 May 2022 17:21:48 -0400
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432725A0BD
        for <linux-bcache@vger.kernel.org>; Wed, 11 May 2022 14:21:45 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 24BLLhBX005464;
        Wed, 11 May 2022 23:21:44 +0200
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with SMTP id 1AADFC801A;
        Wed, 11 May 2022 23:21:43 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Wed, 11 May 2022 23:21:43 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
Message-ID: <Ynwo5yUIaP6irAHW@xoff>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
 <958894243.922478.1652201375900@mail.yahoo.com>
 <YntVm0jy5NY8ealB@xoff>
 <935414163.1122596.1652273928576@mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <935414163.1122596.1652273928576@mail.yahoo.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, May 11, 2022 at 12:58:48PM +0000, Adriano Silva wrote:
> Tank you for your answer!
> 
> > bcache needs to do a lot of metadata work, resulting in a noticeable
> > write amplification. My testing with bcache (some years ago and only with
> > SATA SSDs) showed that bcache latency increases a lot with high amounts
> > of dirty data
> 
> I'm testing with empty devices, no data.
> 
> Wouldn't write amplification be noticeable in dstat? Because it doesn't seem significant during the tests, since I monitor reads and writes in all disks in dstat.

yes, you are right, that would be visible. I was misled from ~3k writes
to nvme (vs. ~1.5k writes from fio), but the same ~3k writes are on
bcache.

> > I also found performance to increase slightly when a bcache device
> > was created with 4k block size instead of default 512bytes.
> 
> Are you talking about changing the block size for the cache device or the backing device?

neither - it was the "-w" argument to make-bcache. I found some old
logfile from my tests. Where both hdd and ssd showed as
512b-sector-devices, the command to create the bcache device was 
    make-bcache --data_offset 2048 --wipe-bcache -w 4k -C /dev/sde1 -B /dev/sdb
In /sys/block/bcacheX/queue/hw_sector_size it then says "4096".


> But when I remove the fsync flag in the test with fio, which tells the application to wait for the write response, the 4K write happens much faster, reaching 73.6 MB/s and 17k IOPS. This is half the device's performance, but it's more than enough for my case. The fsync flag makes no significant difference to the performance of my flash disk when testing directly on it. The fact that bcache speeds up when the fsync flag is removed makes me believe that bcache is not slow to write, but for some reason, bcache is taking a while to respond that the write is complete. I think that should be the point!

I can't claim to fully understand what fsync does (or how a block
device driver is supposed to handle it), but this might account for the
roughly doubled writes shown with dstat as opposed to the fio results.

From the name "journal-test" I guess you are trying something like
    https://www.sebastien-han.fr/blog/2014/10/10/ceph-how-to-test-if-your-ssd-is-suitable-as-a-journal-device/
He uses very similar parameters, except with "--sync=1", not
"--fsync=1".

This is a proper benchmark for the old ceph filestore journal, as this
was written linearly, and in the worst case could have been written in
chunks as small as 4k.

As you are using proxmox, I guess you want to use its ceph component.
They use the modern ceph bluestore format, and there is no journal
anymore.  I don't know if the bluestore WAL exhibits similar access
patterns as the old journal and if this benchmark still has real-world
relevance.  But when having enough NVMe disk space, you are advised to
put bluestore WAL and ideally also the bluestore DB directly on NVMe,
and use bcache only for the bluestore data part. If you do so, make sure
to set rotational=1 on the bcache device before creating the OSD, or
ceph will use unsuitable bluestore parameters, possibly overwhelming the
hdd:

    https://www.spinics.net/lists/ceph-users/msg71646.html

Matthias

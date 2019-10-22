Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1FEE0C67
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Oct 2019 21:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732804AbfJVTSJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Oct 2019 15:18:09 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:39860 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfJVTSJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Oct 2019 15:18:09 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Oct 2019 15:18:09 EDT
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 4FAC2A0692;
        Tue, 22 Oct 2019 19:12:53 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id VEQk0GTIhsk8; Tue, 22 Oct 2019 19:12:52 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id EEE0DA067D;
        Tue, 22 Oct 2019 19:12:48 +0000 (UTC)
Date:   Tue, 22 Oct 2019 19:12:48 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     Sergey Kolesnikov <rockingdemon@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: Getting high cache_bypass_misses in my setup
In-Reply-To: <18e5a2af-da70-60f6-6bd9-33f585b5971b@suse.de>
Message-ID: <alpine.LRH.2.11.1910221906210.25870@mx.ewheeler.net>
References: <CAExpLJg86wKgY=1iPt6VMOiWbVKHU-TCQqWa0aD1OA-ype07sw@mail.gmail.com> <18e5a2af-da70-60f6-6bd9-33f585b5971b@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1690155773-1709268097-1571771274=:25870"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1690155773-1709268097-1571771274=:25870
Content-Type: TEXT/PLAIN; CHARSET=ISO-2022-JP

On Tue, 15 Oct 2019, Coly Li wrote:
> On 2019/10/12 10:23 下午, Sergey Kolesnikov wrote:
> > Hello everyone.
> > 
> > I'm trying to get my bcache setup running, but having almost all my
> > traffic bypassing the cache.
> > Here are some stats that I have:
> > 
> > 
> > root@midnight:~# cat
> > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/bypassed
> > 2.8G
> > root@midnight:~# cat
> > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_bypass_misses
> > 247956
> > root@midnight:~# cat
> > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_bypass_hits
> > 5597
> > root@midnight:~# cat
> > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_hits
> > 233
> > root@midnight:~# cat
> > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_misses
> > 243
> > 
> > And now for my machine setup.
> > Running ubuntu 18.04 LTS with 5.0.0-31-lowlatency kernel.
> > Cache device is a partition on NVMe PCI-e SSD with 4k logical and
> > physical sector size.
> > Backing device is LVM logical volume on a 3-drive MD RAID-0 with 64K
> > stripe size, so it's optimal IO is 192K.
> > I have aligned backing-dev data offset with
> > make-bcache -B -o 15360 --writeback /dev/vm-vg/lvcachedvm-bdev
> > 
> > I have tried all recommendations for routing traffic to SSD:
> > 
> > echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/congested_read_threshold_us
> > echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/congested_write_threshold_us
> > echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/sequential_cutoff
> > 
> > But I still get almost all traffic going to cache_bypass_misse. BTW,
> > what does this stat mean? I don't get it from the in-kernel manual
> > 
> > Any help?..
> 
> I have no much idea. The 4Kn SSD is totally new to me. Last time I saw
> Eric Wheeler reported 4Kn hard diver didn't work well as backing device,
> and I don't find an exact reason up to now. I am not able to say 4Kn is
> not supported or not, before I have such device to test...

We pulled the 4Kn SSD configuration, it wasn't stable back in v4.1.  Not 
sure if the problem has been fixed, but I don't think so.  

Here is the original thread:

https://www.spinics.net/lists/linux-bcache/msg05971.html

--
Eric Wheeler



> 
> -- 
> 
> Coly Li
> 
---1690155773-1709268097-1571771274=:25870--

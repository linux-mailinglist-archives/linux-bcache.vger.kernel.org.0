Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19105D7805
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Oct 2019 16:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbfJOOHo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Oct 2019 10:07:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:40886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732435AbfJOOHo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Oct 2019 10:07:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DDA5AB2E9;
        Tue, 15 Oct 2019 14:07:42 +0000 (UTC)
Subject: Re: Getting high cache_bypass_misses in my setup
To:     Sergey Kolesnikov <rockingdemon@gmail.com>,
        linux-bcache@vger.kernel.org
References: <CAExpLJg86wKgY=1iPt6VMOiWbVKHU-TCQqWa0aD1OA-ype07sw@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <18e5a2af-da70-60f6-6bd9-33f585b5971b@suse.de>
Date:   Tue, 15 Oct 2019 22:07:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAExpLJg86wKgY=1iPt6VMOiWbVKHU-TCQqWa0aD1OA-ype07sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/12 10:23 下午, Sergey Kolesnikov wrote:
> Hello everyone.
> 
> I'm trying to get my bcache setup running, but having almost all my
> traffic bypassing the cache.
> Here are some stats that I have:
> 
> 
> root@midnight:~# cat
> /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/bypassed
> 2.8G
> root@midnight:~# cat
> /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_bypass_misses
> 247956
> root@midnight:~# cat
> /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_bypass_hits
> 5597
> root@midnight:~# cat
> /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_hits
> 233
> root@midnight:~# cat
> /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/stats_total/cache_misses
> 243
> 
> And now for my machine setup.
> Running ubuntu 18.04 LTS with 5.0.0-31-lowlatency kernel.
> Cache device is a partition on NVMe PCI-e SSD with 4k logical and
> physical sector size.
> Backing device is LVM logical volume on a 3-drive MD RAID-0 with 64K
> stripe size, so it's optimal IO is 192K.
> I have aligned backing-dev data offset with
> make-bcache -B -o 15360 --writeback /dev/vm-vg/lvcachedvm-bdev
> 
> I have tried all recommendations for routing traffic to SSD:
> 
> echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/congested_read_threshold_us
> echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/congested_write_threshold_us
> echo 0 > /sys/fs/bcache/9820f407-457a-46e3-abc0-f2214d39b64c/bdev0/sequential_cutoff
> 
> But I still get almost all traffic going to cache_bypass_misse. BTW,
> what does this stat mean? I don't get it from the in-kernel manual
> 
> Any help?..

I have no much idea. The 4Kn SSD is totally new to me. Last time I saw
Eric Wheeler reported 4Kn hard diver didn't work well as backing device,
and I don't find an exact reason up to now. I am not able to say 4Kn is
not supported or not, before I have such device to test...

-- 

Coly Li

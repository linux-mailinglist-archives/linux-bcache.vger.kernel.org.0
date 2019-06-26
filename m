Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0239055CC5
	for <lists+linux-bcache@lfdr.de>; Wed, 26 Jun 2019 02:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfFZAEd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Jun 2019 20:04:33 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:46884 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfFZAEd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jun 2019 20:04:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 208EDA0692;
        Wed, 26 Jun 2019 00:04:33 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 6frgO5jbvjWG; Wed, 26 Jun 2019 00:04:32 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 63867A067D;
        Wed, 26 Jun 2019 00:04:32 +0000 (UTC)
Date:   Wed, 26 Jun 2019 00:04:32 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Marc Smith <msmith626@gmail.com>
cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: Re: I/O Reordering: Cache -> Backing Device
In-Reply-To: <CAH6h+hd5qZdosqavv_ABHKAgRviUidxH_s3HZtLz5Fntg4Y3+A@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.1906260001290.1114@mx.ewheeler.net>
References: <CAH6h+hd5qZdosqavv_ABHKAgRviUidxH_s3HZtLz5Fntg4Y3+A@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, 25 Jun 2019, Marc Smith wrote:

> Hi,
> 
> I've been experimenting using bcache and MD RAID on Linux 4.14.91. I
> have a 12-disk RAID6 MD array as the backing device, and a decent NVMe
> SSD as the caching device. I'm testing using write-back mode.
> 
> I've been able to tune the sequential_cutoff so when issuing full
> stripe writes to the bcache device, these bypass hitting the cache
> device and go right into the MD RAID6 array, which seems to be working
> nicely.
> 
> In the next experiment, when performing more random / sequential
> (mixed) writes, the cache device does a nice job of keeping up
> performance. However, when watching the data get flushed from the
> cache device to the backing device (the MD RAID6 volume), it doesn't
> seem the data is being written out as mostly full stripe writes. I get
> a lot of RMW's on the drives, so I don't believe I'm seeing these full
> stripe writes. I was sort of hoping/expecting bcache to do some
> re-ordering with this... there seem to be some knobs in bcache where
> it detects the full stripe size, and it knows partial stripe writes
> are expensive.
> 
> So I guess my question is if it's known that the data is not
> re-ordered using full stripe geometry in bcache, or perhaps this is
> just a tunable that I'm not seeing? It seems bcache has access to this
> data, but maybe this is a future item where it could be implemented?
> 
> The problem of course comes from the the sub-par performance when data
> is flushed from the cache device to the backing device... lots of
> read-modify-writes result in very poor write performance. If the I/O
> was pushed to the backing device as full stripe I/O's (or at least
> mostly) I'd expect to see better performance when flushing the cache.

You could try turning up /sys/block/bcache0/bcache/writeback_percent .  
Maybe there aren't enough contiguous regions in the writeback cache to 
queue for write.

Coly,

Do you know how the nr_stripes, stripe_sectors_dirty and 
full_dirty_stripes bitmaps work together to make a best-effort of writing 
full stripes to the disk, and maybe you can explain under what 
circumstances partial stripes would be written?


--
Eric Wheeler


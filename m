Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FA246663C
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Dec 2021 16:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347525AbhLBPQh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Dec 2021 10:16:37 -0500
Received: from mailbackend.panix.com ([166.84.1.89]:50000 "EHLO
        mailbackend.panix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbhLBPQh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Dec 2021 10:16:37 -0500
Received: from xps-7390.lan (50-233-66-25-static.hfc.comcastbusiness.net [50.233.66.25])
        by mailbackend.panix.com (Postfix) with ESMTPSA id 4J4fbX4wgSzRyK;
        Thu,  2 Dec 2021 10:13:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=panix.com; s=panix;
        t=1638457993; bh=toNejAxkj+yP8ltzlp9a3STqZnD7jU0oVwaijQEJlZU=;
        h=Date:From:Reply-To:To:cc:Subject:In-Reply-To:References;
        b=iQWI9zs4cbEE27OPkZUNGunlqbBji7LPHblAro+/jkZcNX24HasiX5UC30tsS+Ese
         pPZ502MW72NrVzRpV70RpLot5KWFaFQS5/mSzJ3Rv12dJPF/NtSLrrtAyySPvjJTJU
         HL0nQA00QggMvQiD4jwuQqwy6YAByTPWSR92+T7c=
Date:   Thu, 2 Dec 2021 07:13:11 -0800 (PST)
From:   "Kenneth R. Crudup" <kenny@panix.com>
Reply-To: "Kenneth R. Crudup" <kenny@panix.com>
To:     Jens Axboe <axboe@kernel.dk>
cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-nvme@lists.infradead.org,
        "Kenneth R. Crudup" <kenny@panix.com>, shinichiro.kawasaki@wdc.com
Subject: Re: Write I/O queue hangup at random on recent Linus' kernels
In-Reply-To: <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com>
Message-ID: <4429eed8-b9b9-6943-f76-6ea38d695248@panix.com>
References: <b3ba57a7-d363-9c17-c4be-9dbe86875@panix.com> <b9c2681f-e63a-4d3b-913d-d8a75e2c2ea0@kernel.dk> <be6a783-97db-c3bf-b16f-e8c62b14755d@panix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On Thu, 25 Nov 2021, Kenneth R. Crudup wrote:

> > echo 0 > /sys/block/nvme0n1/queue/wbt_lat_usec
> > and that will disable writeback throttling on that device.

> It's been about 48 hours and haven't seen the issue since doing this.

I'm now back to running Linus' master (which includes your fix for this, and
I'm not disabling WBT any longer).

We may still have issues, it appears. Everything was going OK until yesterday,
when I had an SD-Card with an image of an SSD with a dm volume group on it,
that I'd had mounted as a loopback image and activated (... was that clear)?

While I'm not seeing any kernel messages related to my NVMe (root) device, I'm
also seeing the same UI issues as before- the KDE toolbar is unresponsive, and
I don't have full interaction with my desktop UI (i.e., can't click on the
bottom button bar to switch to the active window). I'm pretty sure this is a
symptom of another I/O problem, however.

I tried to unfreeze it by:

  $ echo 0 | sudo tee -a /sys/block/mmcblk0/queue/wbt_lat_usec /sys/block/loop?/queue/wbt_lat_usec

... and a couple of seconds after that, it looked as if some queued-up toolbar
actions spit out (but was then unresponsive), so I'd tried this to see if it
would tell me if I had any throttled/stalled IOs:

  $ egrep -r . $(sudo find /sys/block/*/ -name inflight )

... but they were all zeros.

Does this make sense? Your patch seemed to be block-device-agnostic, but is there
a chance there's a similar path in the "dm" that also needs to be fixed?

Thanks,

	-Kenny

-- 
Kenneth R. Crudup / Sr. SW Engineer, Scott County Consulting, Orange County CA

Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384AD487D99
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jan 2022 21:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiAGUUf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jan 2022 15:20:35 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:47850 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbiAGUUf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jan 2022 15:20:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id CFC4348;
        Fri,  7 Jan 2022 12:20:34 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id fOoNecp18Kep; Fri,  7 Jan 2022 12:20:32 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id D15A141;
        Fri,  7 Jan 2022 12:20:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net D15A141
Date:   Fri, 7 Jan 2022 12:20:29 -0800 (PST)
From:   bcache@lists.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     mingzhe.zou@easystack.cn, linux-bcache@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH] bcache: fixup bcache_dev_sectors_dirty_add() multithreaded
 CPU false sharing
In-Reply-To: <fa05fa29-076a-4d33-a578-abf5c2b5c78f@suse.de>
Message-ID: <c0ac712e-c9f-825-c2f6-aad0e648ebe6@ewheeler.net>
References: <20220107082113.18480-1-mingzhe.zou@easystack.cn> <fa05fa29-076a-4d33-a578-abf5c2b5c78f@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 7 Jan 2022, Coly Li wrote:
> On 1/7/22 4:21 PM, mingzhe.zou@easystack.cn wrote:
> > From: Zou Mingzhe <mingzhe.zou@easystack.cn>
> >
> > When attaching a cached device (a.k.a backing device) to a cache
> > device, bch_sectors_dirty_init() is called to count dirty sectors
> > and stripes (see what bcache_dev_sectors_dirty_add() does) on the
> > cache device.
> >
> > When bcache_dev_sectors_dirty_add() is called, set_bit(stripe,
> > d->full_dirty_stripes) or clear_bit(stripe, d->full_dirty_stripes)
> > operation will always be performed. In full_dirty_stripes, each 1bit
> > represents stripe_size (8192) sectors (512B), so 1bit=4MB (8192*512),
> > and each CPU cache line=64B=512bit=2048MB. When 20 threads process
> > a cached disk with 100G dirty data, a single thread processes about
> > 23M at a time, and 20 threads total 460M. These full_dirty_stripes
> > bits corresponding to the 460M data is likely to fall in the same CPU
> > cache line. When one of these threads performs a set_bit or clear_bit
> > operation, the same CPU cache line of other threads will become invalid
> > and must read the full_dirty_stripes from the main memory again. Compared
> > with single thread, the time of a bcache_dev_sectors_dirty_add()
> > call is increased by about 50 times in our test (100G dirty data,
> > 20 threads, bcache_dev_sectors_dirty_add() is called more than
> > 20 million times).
> >
> > This patch tries to test_bit before set_bit or clear_bit operation.
> > Therefore, a lot of force set and clear operations will be avoided,
> > and most of bcache_dev_sectors_dirty_add() calls will only read CPU
> > cache line.

Hi Mingzhe, good catch on this.  I'm curious: how much time does it save 
attaching a cache?

-Eric

> >
> > Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> Added into my testing queue. Thanks.
> 
> Coly Li
> 
> > ---
> >   drivers/md/bcache/writeback.c | 11 +++++++----
> >   1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> > index 68e75c692dd4..4afe22875d4f 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -596,10 +596,13 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c,
> > unsigned int inode,
> >   
> >     sectors_dirty = atomic_add_return(s,
> >   					d->stripe_sectors_dirty + stripe);
> > -		if (sectors_dirty == d->stripe_size)
> > -			set_bit(stripe, d->full_dirty_stripes);
> > -		else
> > -			clear_bit(stripe, d->full_dirty_stripes);
> > +		if (sectors_dirty == d->stripe_size) {
> > +			if (!test_bit(stripe, d->full_dirty_stripes))
> > +				set_bit(stripe, d->full_dirty_stripes);
> > +		} else {
> > +			if (test_bit(stripe, d->full_dirty_stripes))
> > +				clear_bit(stripe, d->full_dirty_stripes);
> > +		}
> >   
> >     nr_sectors -= s;
> >     stripe_offset = 0;
> 
> 
> 

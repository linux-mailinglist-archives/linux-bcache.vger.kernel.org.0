Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B9A1D60DB
	for <lists+linux-bcache@lfdr.de>; Sat, 16 May 2020 14:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgEPMkY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 May 2020 08:40:24 -0400
Received: from verein.lst.de ([213.95.11.211]:60430 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgEPMkY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 08:40:24 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2456968B05; Sat, 16 May 2020 14:40:20 +0200 (CEST)
Date:   Sat, 16 May 2020 14:40:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com,
        hch@lst.de, axboe@kernel.dk, linux-bcache@vger.kernel.org,
        kbusch@kernel.org
Subject: Re: [RFC PATCH v2 3/4] block: remove queue_is_mq restriction from
 blk_revalidate_disk_zones()
Message-ID: <20200516124020.GC13448@lst.de>
References: <20200516035434.82809-1-colyli@suse.de> <20200516035434.82809-4-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200516035434.82809-4-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, May 16, 2020 at 11:54:33AM +0800, Coly Li wrote:
> The bcache driver is bio based and NOT request based multiqueued driver,
> if a zoned SMR hard drive is used as backing device of a bcache device,
> calling blk_revalidate_disk_zones() for the bcache device will fail due
> to the following check in blk_revalidate_disk_zones(),
> 478       if (WARN_ON_ONCE(!queue_is_mq(q)))
> 479             return -EIO;
> 
> Now bcache is able to export the zoned information from the underlying
> zoned SMR drives and format zonefs on top of a bcache device, the
> resitriction that a zoned device should be multiqueued is unnecessary
> for now.
> 
> Although in commit ae58954d8734c ("block: don't handle bio based drivers
> in blk_revalidate_disk_zones") it is said that bio based drivers should
> not call blk_revalidate_disk_zones() and just manually update their own
> q->nr_zones, but this is inaccurate. The bio based drivers also need to
> set their zone size and initialize bitmaps for cnv and seq zones, it is
> necessary to call blk_revalidate_disk_zones() for bio based drivers.

Why would you need these bitmaps for bcache?  There is no reason to
serialize requests for stacking drivers, and you can already derive
if a zone is sequential or not from whatever internal information
you use.

So without a user that actually makes sense: NAK.

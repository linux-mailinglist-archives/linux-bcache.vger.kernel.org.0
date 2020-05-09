Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F781CBEEE
	for <lists+linux-bcache@lfdr.de>; Sat,  9 May 2020 10:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgEIIYe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 9 May 2020 04:24:34 -0400
Received: from verein.lst.de ([213.95.11.211]:56136 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgEIIYe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 9 May 2020 04:24:34 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8260E68CEC; Sat,  9 May 2020 10:24:31 +0200 (CEST)
Date:   Sat, 9 May 2020 10:24:31 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: Re: remove a few uses of ->queuedata
Message-ID: <20200509082431.GC21834@lst.de>
References: <20200508161517.252308-1-hch@lst.de> <20200508221321.GD1389136@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508221321.GD1389136@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, May 09, 2020 at 06:13:21AM +0800, Ming Lei wrote:
> On Fri, May 08, 2020 at 06:15:02PM +0200, Christoph Hellwig wrote:
> > Hi all,
> > 
> > various bio based drivers use queue->queuedata despite already having
> > set up disk->private_data, which can be used just as easily.  This
> > series cleans them up to only use a single private data pointer.
> > 
> > blk-mq based drivers that have code pathes that can't easily get at
> > the gendisk are unaffected by this series.
> 
> Yeah, before adding disk, there still may be requests queued to LLD
> for blk-mq based drivers.
> 
> So are there this similar situation for these bio based drivers?

bio submittsion is based on the gendisk, so we can't submit before
it is added.  The passthrough request based path obviously doesn't apply
here.

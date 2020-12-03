Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4812E2CD14F
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 09:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388410AbgLCIag (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Dec 2020 03:30:36 -0500
Received: from verein.lst.de ([213.95.11.211]:57585 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388390AbgLCIaf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Dec 2020 03:30:35 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8169467373; Thu,  3 Dec 2020 09:29:51 +0100 (CET)
Date:   Thu, 3 Dec 2020 09:29:51 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 3/9] block: store a block_device pointer in struct bio
Message-ID: <20201203082951.GA15581@lst.de>
References: <20201201165424.2030647-1-hch@lst.de> <20201201165424.2030647-4-hch@lst.de> <20201203063941.GA629758@T590> <20201203071055.GA633702@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203071055.GA633702@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Dec 03, 2020 at 03:10:55PM +0800, Ming Lei wrote:
> On Thu, Dec 03, 2020 at 02:40:04PM +0800, Ming Lei wrote:
> > On Tue, Dec 01, 2020 at 05:54:18PM +0100, Christoph Hellwig wrote:
> > > Replace the gendisk pointer in struct bio with a pointer to the newly
> > > improved struct block device.  From that the gendisk can be trivially
> > > accessed with an extra indirection, but it also allows to directly
> > > look up all information related to partition remapping.
> > 
> > The extra indirection is often done in fast path, so just wondering why
> > you don't consider to embed gendisk into block_device? Then the extra
> > indirection can be avoided.
> 
> oops, that is only possible for disk, and indirection is still needed
> for partitions.

I looked into that, but given that the block device is allocated as part
of the inode we'd need to tell ->alloc_inode if we want to allocate the
small inode without the gendisk, or the large one with it which doesn't
work with the current interface.  Beause the hd_struct is gone we're
still not using more structures in the I/O path than we did before.

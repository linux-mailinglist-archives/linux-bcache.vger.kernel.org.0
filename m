Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03372AF618
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Nov 2020 17:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKKQUk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Nov 2020 11:20:40 -0500
Received: from verein.lst.de ([213.95.11.211]:40830 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgKKQUj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Nov 2020 11:20:39 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 829EF6736F; Wed, 11 Nov 2020 17:20:35 +0100 (CET)
Date:   Wed, 11 Nov 2020 17:20:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Ilya Dryomov <idryomov@gmail.com>,
        Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: block ioctl cleanups v2
Message-ID: <20201111162035.GA23772@lst.de>
References: <20201103100018.683694-1-hch@lst.de> <20201111075802.GB23010@lst.de> <92a7c6e5-fe8b-e291-0dce-ecd727262a2e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92a7c6e5-fe8b-e291-0dce-ecd727262a2e@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Nov 11, 2020 at 09:13:05AM -0700, Jens Axboe wrote:
> On 11/11/20 12:58 AM, Christoph Hellwig wrote:
> > Jens, can you take a look and possibly pick this series up?
> 
> Looks good to me - but what is the final resolution on the BLKROSET
> propagation?

Do it properly including a hard read only flag.  Martin has an old
patch that I'm going to forward port.  For now I think we need to
adjust dasd to match the behavior of all drivers, so that we can fix
the common code to behave more like dasd in the next step.
